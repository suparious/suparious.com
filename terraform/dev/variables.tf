variable "name" {
  type = "string"
  default = "dev-mh"
}

variable "aws_nat_ami" {
    default = {
        ca-central-1 = "ami-0b32354309da5bba5"
    }
}
