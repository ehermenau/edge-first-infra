# --- Tunnel: outbound-only connection from the cloudflared pod in-cluster,
# no inbound ports/ALB/Ingress required ---

resource "cloudflare_zero_trust_tunnel_cloudflared" "argocd" {
  account_id = var.cloudflare_account_id
  name       = "fetchlabs-argocd"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "argocd" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.argocd.id

  config = {
    ingress = [
      {
        hostname = "${var.subdomain}.${var.root_domain}"
        service  = "https://argocd-server.argocd.svc.cluster.local:443"
        origin_request = {
          # ArgoCD terminates its own TLS internally with a self-signed cert
          # (server.insecure: false in gitops/bootstrap/argocd/values.yml).
          # Cloudflare Access in front of this hostname is the real auth
          # boundary - this just lets cloudflared complete the TLS handshake
          # to reach it.
          no_tls_verify = true
        }
      },
      # Required catch-all: any request not matching a rule above falls
      # through to here rather than erroring.
      { service = "http_status:404" }
    ]
  }
}

# --- DNS: must be proxied (orange-clouded) for Cloudflare edge to route to
# the tunnel via *.cfargotunnel.com ---

resource "cloudflare_dns_record" "argocd" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.argocd.id}.cfargotunnel.com"
  ttl     = 1 # "Auto" - required when proxied
  proxied = true
}

# --- Access: gates the tunnel hostname to one identity, via Cloudflare's
# built-in one-time-PIN login (no custom IdP setup needed for a single-owner
# app) ---

# As of a June 2026 Cloudflare change, newly-enabled Zero Trust accounts
# default to the built-in "Cloudflare" identity provider (login with your
# Cloudflare.com account) rather than One-Time PIN - confirmed the hard way
# when that IdP authenticated as the wrong email and Access correctly denied
# it. One-Time PIN has to be added manually (Zero Trust > Integrations >
# Identity providers > Add new > One-time PIN) before this lookup succeeds.
data "cloudflare_zero_trust_access_identity_providers" "all" {
  account_id = var.cloudflare_account_id
}

locals {
  onetimepin_idp_id = one([
    for idp in data.cloudflare_zero_trust_access_identity_providers.all.result :
    idp.id if idp.type == "onetimepin"
  ])
}

resource "cloudflare_zero_trust_access_application" "argocd" {
  account_id       = var.cloudflare_account_id
  name             = "ArgoCD"
  domain           = "${var.subdomain}.${var.root_domain}"
  type             = "self_hosted"
  session_duration = "24h"
  # Restricts login to One-Time PIN only, so the "Cloudflare" IdP - which
  # authenticates as whoever's logged into Cloudflare, not necessarily one
  # of allowed_emails - never shows up as a login option on this application.
  allowed_idps = [local.onetimepin_idp_id]

  policies = [{
    name       = "Allowed emails"
    decision   = "allow"
    precedence = 1
    # OR'd together - matching any one of these emails is sufficient.
    include = [for email in var.allowed_emails : { email = { email = email } }]
  }]
}

# --- Connector token: consumed by CI to populate the cloudflared-token
# Secret in-cluster (see argocd_bootstrap_prod in workflow.yml) ---

data "cloudflare_zero_trust_tunnel_cloudflared_token" "argocd" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.argocd.id
}
