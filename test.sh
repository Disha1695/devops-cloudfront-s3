#!/usr/bin/env bash
# Proves: CloudFront works, direct S3 is blocked, cache is working.
cd "$(dirname "$0")"
CF=$(terraform -chdir=terraform output -raw cloudfront_url)
S3=$(terraform -chdir=terraform output -raw direct_s3_url_should_fail)
echo "1) Via CloudFront (expect 200):"; curl -s -o /dev/null -w "%{http_code}\n" "$CF/index.html"
echo "2) Direct S3 (expect 403):";      curl -s -o /dev/null -w "%{http_code}\n" "$S3"
echo "3) Cache headers (2nd call should show X-Cache: Hit from cloudfront):"
curl -sI "$CF/index.html" >/dev/null; curl -sI "$CF/index.html" | grep -i -E "x-cache|age"
