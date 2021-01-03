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

# VPC network
module "vpc" {
  source          = "./modules/vpc"
  env             = var.env
  project         = var.project
  region          = var.region
  multi_az        = false
  rds             = false
  nat_mode        = "gateway"
  vpc_cidr_prefix = var.vpc_cidr_prefix
  common_tags     = local.common_tags
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
  common_tags = local.common_tags
  depends_on = [
    module.logging_s3,
  ]
}

# main web logs storage
module "logging_s3" {
  source        = "./modules/s3-logs"
  env           = var.env
  project       = var.project
  region        = var.region
  bucket        = "${var.bucket}-logs"
  force_destroy = true
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
  common_tags = local.common_tags
}

# main SSL Certificate
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

# main cloudfront distribution
module "cloudfront" {
  source             = "./modules/cloudfront"
  env                = var.env
  project            = var.project
  region             = var.region
  domain_name        = var.domain_name
  bucket_domain      = module.main_s3.s3_bucket_regional_domain_name
  logs_bucket_domain = module.logging_s3.s3_bucket_regional_domain_name
  s3_origin_id       = local.s3_origin_id
  acm_cert_arn       = aws_acm_certificate.cert.arn
  common_tags        = local.common_tags
}
