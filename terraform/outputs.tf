output "bucket_name" { value = aws_s3_bucket.site.bucket }
output "distribution_id" { value = aws_cloudfront_distribution.cdn.id }
output "cloudfront_url" { value = "https://${aws_cloudfront_distribution.cdn.domain_name}" }
output "direct_s3_url_should_fail" { value = "https://${aws_s3_bucket.site.bucket_regional_domain_name}/index.html" }
