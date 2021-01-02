# save state to s3
terraform {
  backend "s3" {}
}

# default provider
provider "aws" {
  region = var.region
}

# for managing certificates
provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

# discover current identity and save as a map
data "aws_caller_identity" "current" {}

# declare some local vars and common tags
locals {
  account_id        = data.aws_caller_identity.current.account_id
  cloudwatch_prefix = "/${var.project}/${var.env}"
  bucket_arn        = module.main_s3.s3_bucket_arn
  s3_origin_id      = "${var.project}-${var.env}"

  common_tags = {
    Project      = var.project
    Environment  = var.env
    CreatedBy    = "Terraform"
    CostCategory = "Suparious"
  }
}

# main web content storage
module "main_s3" {
  source        = "./modules/s3"
  env           = var.env
  project       = var.project
  region        = var.region
  bucket        = var.bucket
  acl           = "public-read"
  force_destroy = true
  common_tags   = local.common_tags

  versioning = {
    enabled = true
  }

  website = {
    index_document = "index.html"
    error_document = "shit.html"

  }

  logging = {
    target_bucket = module.logging_s3.s3_bucket_id
    target_prefix = "${var.project}-${var.env}"
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  depends_on = [
    module.logging_s3,
  ]
}

# main logs storage
module "logging_s3" {
  source        = "./modules/s3-logs"
  env           = var.env
  project       = var.project
  region        = var.region
  bucket        = "${var.bucket}-logs"
  force_destroy = true
  common_tags   = local.common_tags

  website = {
    index_document = "index.html"
    error_document = "shit.html"

  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

# DNS zones
resource "aws_route53_zone" "primary" {
  name = var.domain_name

  tags = merge(local.common_tags, map(
    "Name", "${var.project}-${var.env}-dist"
  ))
}

# SSL Certificate
resource "aws_acm_certificate" "cert" {
  provider = aws.acm

  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags, map(
    "Name", "${var.project}-${var.env}-dist"
  ))
}

# Origin access Identity
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Suparious Services ${var.env}"
}

# Website ditribution layer
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = module.main_s3.s3_bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.origin_access_identity.id}" ####WHUT
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Suparious Services website"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = module.logging_s3.s3_bucket_regional_domain_name
    prefix          = "cloudfront"
  }

  aliases = [var.domain_name, "*.${var.domain_name}"]

  custom_error_response {
    response_page_path = "/shit.html"
    error_code = 400
    response_code = 200      
  }

  custom_error_response {
    response_page_path = "/shit.html"
    error_code = 403
    response_code = 200      
  }

  custom_error_response {
    response_page_path = "/shit.html"
    error_code = 404
    response_code = 200      
  }

  # , 403, 404, 405, 414, 416]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = merge(local.common_tags, map(
    "Name", "${var.project}-${var.env}-dist"
  ))

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = "sni-only"
  }
}
