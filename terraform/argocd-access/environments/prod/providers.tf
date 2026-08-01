terraform {
  required_version = ">= 1.10.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }

  # Single-environment, same rationale as scanner-infra: a Cloudflare Tunnel,
  # DNS record, and Access application aren't per-cluster concepts - there's
  # exactly one ArgoCD UI worth reaching (prod; staging nightly-destroys and
  # isn't worth persistent access for). Intentionally excluded from
  # auto_destroy.yml for the same reason as scanner-infra: nothing here costs
  # anything at rest, and cycling it would rotate the tunnel ID under the
  # cloudflared Deployment that references it.
  backend "s3" {
    bucket       = "" # Passed in via var
    key          = "global/argocd-access/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "cloudflare" {
  # Uses CLOUDFLARE_API_TOKEN environment variable
}
