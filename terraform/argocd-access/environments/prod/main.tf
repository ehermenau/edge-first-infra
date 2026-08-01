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
# built-in one-time-PIN login (no IdP setup needed for a single-owner app) ---

resource "cloudflare_zero_trust_access_application" "argocd" {
  account_id       = var.cloudflare_account_id
  name             = "ArgoCD"
  domain           = "${var.subdomain}.${var.root_domain}"
  type             = "self_hosted"
  session_duration = "24h"

  policies = [{
    name       = "Owner only"
    decision   = "allow"
    precedence = 1
    include = [{
      email = { email = var.owner_email }
    }]
  }]
}

# --- Connector token: consumed by CI to populate the cloudflared-token
# Secret in-cluster (see argocd_bootstrap_prod in workflow.yml) ---

data "cloudflare_zero_trust_tunnel_cloudflared_token" "argocd" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.argocd.id
}
