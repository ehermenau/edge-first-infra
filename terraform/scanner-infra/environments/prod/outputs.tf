output "ecr_repository_url" {
  value = aws_ecr_repository.scanner.repository_url
}

output "ecr_repository_arn" {
  value = aws_ecr_repository.scanner.arn
}

output "acm_certificate_arn" {
  description = "Stable ARN referenced statically by the Ingress annotation in gitops/hub/apps/10-scanner"
  value       = aws_acm_certificate_validation.scanner.certificate_arn
}

output "scanner_ci_role_arn" {
  value = aws_iam_role.scanner_ci.arn
}

output "scan_fqdn" {
  value = "${var.subdomain}.${var.root_domain}"
}
