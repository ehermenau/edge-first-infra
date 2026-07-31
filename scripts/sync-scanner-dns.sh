#!/usr/bin/env bash
# Upserts the scan.fetchlabs.io CNAME to point at the scanner's ALB.
#
# The ALB is created dynamically by the built-in EKS Auto Mode load
# balancer controller reacting to the scanner's Ingress, so its hostname
# isn't known to Terraform (see terraform/scanner-infra's providers.tf for
# why the ACM cert/ECR repo/OIDC role *are* Terraform-managed but this
# record isn't). This runs after every ArgoCD bootstrap/sync against prod.
#
# Required env: CLOUDFLARE_API_TOKEN, CLOUDFLARE_ZONE_ID
set -euo pipefail

NAMESPACE="scanner"
INGRESS_NAME="fetchlabs-scanner"
RECORD_NAME="scan.fetchlabs.io"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-300}"
INTERVAL="${INTERVAL:-10}"

elapsed=0
hostname=""
while [ "$elapsed" -lt "$TIMEOUT_SECONDS" ]; do
  hostname="$(kubectl get ingress -n "$NAMESPACE" "$INGRESS_NAME" \
    -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)"
  if [ -n "$hostname" ]; then
    break
  fi
  echo "waiting for ALB hostname..."
  sleep "$INTERVAL"
  elapsed=$((elapsed + INTERVAL))
done

if [ -z "$hostname" ]; then
  echo "timed out waiting for the scanner Ingress to get an ALB hostname" >&2
  exit 1
fi

echo "ALB hostname: $hostname"

existing_id="$(curl -sS \
  "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records?type=CNAME&name=${RECORD_NAME}" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  -H "Content-Type: application/json" |
  python3 -c "import json,sys; r=json.load(sys.stdin)['result']; print(r[0]['id'] if r else '')")"

body="$(python3 -c "
import json
print(json.dumps({'type': 'CNAME', 'name': '${RECORD_NAME}', 'content': '${hostname}', 'proxied': True, 'ttl': 1}))
")"

if [ -n "$existing_id" ]; then
  echo "updating existing DNS record $existing_id"
  method="PUT"
  url="https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records/${existing_id}"
else
  echo "creating new DNS record"
  method="POST"
  url="https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records"
fi

curl -sS -X "$method" "$url" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data "$body" |
  python3 -c "
import json, sys
d = json.load(sys.stdin)
if not d['success']:
    print(d['errors'], file=sys.stderr)
    sys.exit(1)
print('DNS record synced')
"
