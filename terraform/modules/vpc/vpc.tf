resource "aws_vpc" "project" {
  cidr_block           = "${var.vpc_cidr_prefix}.0.0/22"
  enable_dns_hostnames = true
  enable_dns_support   =  true
  tags {
    Name = "${var.project}"
  }
}
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.project.id}"
}