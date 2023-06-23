output "bucket_website_name" {
  value = try(aws_s3_bucket.this.bucket, "")
}

output "bucket_website_id" {
  value = try(aws_s3_bucket.this.id, "")
}

output "bucket_website_arn" {
  value = try(aws_s3_bucket.this.arn, "")
}

output "bucket_regional_domain_name" {
  value = try(aws_s3_bucket.this.bucket_regional_domain_name, "")
}

output "bucket_website_endpoint" {
  value = try(aws_s3_bucket_website_configuration.website_configuration[0].website_endpoint, "")
}
