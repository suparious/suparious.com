provider "aws" {
  profile    = "default"
  region     = "ca-central-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}"
  cidr = "10.2.6.0/24"

  azs             = ["ca-central-1a", "ca-central-1b"]
  private_subnets = ["10.2.6.0/26", "10.2.6.128/26"]
  public_subnets  = ["10.2.6.64/26", "10.2.6.192/26"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


resource "aws_instance" "nat" {
	ami = "${lookup(var.aws_nat_ami, var.aws_region)}"
	instance_type = "t2.medium"
	key_name = "static-nat"
	security_groups = ["${aws_security_group.nat.id}"]
	subnet_id = "${aws_subnet.public.id}"
	associate_public_ip_address = true
	source_dest_check = false
	user_data = "${file("nat-user-data.yml")}"
	tags {
		Name = "nat"
	}
}

resource "aws_eip" "nat" {
	instance = "${aws_instance.nat.id}"
	vpc = true
}

resource "aws_security_group" "nat" {
	name = "nat"
	description = "Allow services from the private subnet through NAT"
	vpc_id = "${aws_vpc.default.id}"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		security_groups = ["${aws_security_group.private.id}"]
	}

	ingress {
		from_port = 0
		to_port = 65535
		protocol = "udp"
		security_groups = ["${aws_security_group.private.id}"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags {
		Name = "${var.aws_vpc_name}-nat"
	}
}
