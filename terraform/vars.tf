variable "env" {
  description = "The name of the environment"
}

variable "project" {
  description = "The name of the project"
  default = "suparious"
}

variable "bucket" {
  description = "The name of the bucket."
  type        = string
}

variable "region" {
  description = "(Optional) If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee."
  type        = string
  default     = "us-west-2"
}
