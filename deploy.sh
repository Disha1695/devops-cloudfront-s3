#!/usr/bin/env bash
# Uploads ./site to S3 and invalidates the CloudFront cache.
# Usage: ./deploy.sh            (invalidate everything: /*)
#        ./deploy.sh /index.html /style.css   (invalidate only given paths)
set -euo pipefail
cd "$(dirname "$0")"
BUCKET=$(terraform -chdir=terraform output -raw bucket_name)
DIST_ID=$(terraform -chdir=terraform output -raw distribution_id)

echo "== Uploading site to s3://$BUCKET =="
# HTML: always revalidate. Static assets: cache 1 day.
aws s3 sync site/ "s3://$BUCKET" --delete \
  --exclude "*.html" --cache-control "public,max-age=86400"
aws s3 sync site/ "s3://$BUCKET" \
  --exclude "*" --include "*.html" --cache-control "public,max-age=60" --content-type "text/html"

PATHS=("${@:-/*}")
echo "== Invalidating CloudFront cache: ${PATHS[*]} =="
INV=$(aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "${PATHS[@]}" \
      --query 'Invalidation.Id' --output text)
aws cloudfront wait invalidation-completed --distribution-id "$DIST_ID" --id "$INV"
echo "Invalidation $INV completed."
echo "Site: $(terraform -chdir=terraform output -raw cloudfront_url)"
