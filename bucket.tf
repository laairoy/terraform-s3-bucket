resource "aws_s3_bucket" "this" {
  bucket        = var.bucket
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  count  = length(var.website) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "index_document" {
    for_each = try([var.website["index_document"]], [])
    content {
      suffix = index_document.value
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = try([var.website["redirect"]], [])

    content {
      host_name = redirect_all_requests_to.value.host_name
      protocol  = redirect_all_requests_to.value.protocol
    }
  }
}

resource "aws_s3_bucket_policy" "public_access" {
  count      = var.public_access == true ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.owner_prefered]
  bucket     = aws_s3_bucket.this.id
  policy     = data.aws_iam_policy_document.public_access.json
}

data "aws_iam_policy_document" "public_access" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]

    }
    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_ownership_controls" "owner_prefered" {
  count  = var.public_access == true ? 1 : 0
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count  = var.public_access == true ? 1 : 0
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_website_bucket_acl" {
  count      = var.public_access == true ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.owner_prefered, aws_s3_bucket_public_access_block.this]
  bucket     = aws_s3_bucket.this.id
  acl        = "public-read"
}
