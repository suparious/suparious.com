terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {
  # Common parameters
  account_id        = data.aws_caller_identity.current.account_id
  cloudwatch_prefix = "/${var.project}/${var.env}"
  bucket_arn        = module.main_s3.s3_bucket_arn

  common_tags = {
    Project      = var.project
    Environment  = var.env
    CreatedBy    = "Terraform"
    CostCategory = "Suparious"
  }
}

module "main_s3" {
  source             = "./modules/s3"
  env                = var.env
  project            = var.project
  region             = var.region
  bucket             = var.bucket
  acl                = "public-read"
  force_destroy      = true
  common_tags        = local.common_tags

  versioning = {
    enabled = true
  }

  website = {
    index_document = "index.html"
    error_document = "error.html"

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

module "logging_s3" {
  source             = "./modules/s3-logs"
  env                = var.env
  project            = var.project
  region             = var.region
  bucket             = "${var.bucket}-logs"
  force_destroy      = true
  common_tags        = local.common_tags

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}