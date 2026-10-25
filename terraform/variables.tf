variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name, e.g. disha-devops-static-site-2026"
}
