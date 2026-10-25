# Task 2 – CloudFront in front of a private S3 static website

* S3 bucket is **fully private** (Block Public Access ON) → direct S3 URL returns **403**.
* CloudFront uses **Origin Access Control (OAC)**; the bucket policy only allows *this* distribution.
* **Cache invalidation** is done by `deploy.sh` (all paths `/*` or chosen paths) and optionally by GitHub Actions.

## Values you must change
`terraform/variables.tf` → `bucket_name` (must be globally unique) – or pass it on the command line as below.

## Run it
```
cd terraform
terraform init
terraform apply -var="bucket_name=disha-devops-static-site-2026"     # type yes
cd ..
./deploy.sh        # uploads site/ and invalidates /*
./test.sh          # shows 200 via CloudFront, 403 direct S3, cache Hit
```
Open the `cloudfront_url` output. First deploy of CloudFront takes ~5 min.

## Demonstrate cache invalidation
1. Edit `site/index.html` (change `v1` → `v2`).
2. Run `./deploy.sh /index.html` → refresh the CloudFront URL → new version appears.
   (`index.html` has `max-age=60`, so without invalidation it could be stale up to 1 min; CSS/images are cached 1 day and need invalidation.)

## Clean up
`cd terraform && terraform destroy -var="bucket_name=..."`
