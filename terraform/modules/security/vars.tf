variable "env" {
  description = "The name of the environment"
}

variable "project" {
  description = "The name of the project"
  default = "suparious"
}

variable "region" {
  description = "(Optional) If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee."
  type        = string
  default     = "us-west-2"
}

variable "common_tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable vpc_id {}
variable allowed_admin_ips {}
variable vpc_cidr_block {}