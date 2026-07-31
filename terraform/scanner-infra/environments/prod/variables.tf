variable "github_owner" {
  type    = string
  default = "ehermenau"
}

variable "repository" {
  description = "The fetchlabs-scanner repo's own CI identity, not edge-first-infra's"
  type        = string
  default     = "fetchlabs-scanner"
}

variable "github_owner_id" {
  description = "Immutable numeric GitHub user ID for github_owner (`gh api users/<owner> --jq .id`) - GitHub's OIDC sub claim now pins to this, not the mutable username"
  type        = string
  default     = "64927416"
}

variable "repository_id" {
  description = "Immutable numeric GitHub repo ID for repository (`gh api repos/<owner>/<repo> --jq .id`)"
  type        = string
  default     = "1318519354"
}

variable "root_domain" {
  type    = string
  default = "fetchlabs.io"
}

variable "subdomain" {
  type    = string
  default = "scan"
}

variable "cloudflare_zone_id" {
  description = "Zone ID for fetchlabs.io in Cloudflare"
  type        = string
}
