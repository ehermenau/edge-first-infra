output "tunnel_token" {
  description = "Consumed by argocd_bootstrap_prod in workflow.yml to create the cloudflared-token Secret"
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.argocd.token
  sensitive   = true
}

output "argocd_fqdn" {
  value = "${var.subdomain}.${var.root_domain}"
}
