variable "root_domain" {
  type    = string
  default = "fetchlabs.io"
}

variable "subdomain" {
  type    = string
  default = "argocd"
}

variable "cloudflare_zone_id" {
  description = "Zone ID for fetchlabs.io in Cloudflare"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID - Zero Trust resources (Tunnel, Access) are account-scoped, not zone-scoped like scanner-infra's DNS-only usage"
  type        = string
}

variable "allowed_emails" {
  description = "Identities allowed through Cloudflare Access to the ArgoCD UI"
  type        = list(string)
  default = [
    "hermenau.evan@gmail.com",
    "admin@fetchlabs.io",
  ]
}
