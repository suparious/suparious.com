#####################
## Allow Admin access
resource "aws_security_group" "allow_admins" {
  name        = "allow_admins"
  description = "Allow Suparious Admin inbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, map(
    "Name", "${var.project}-${var.env}-sg-admins"
  ))
}

# Admin SSH rule
resource "aws_security_group_rule" "admin_ssh_access" {
  description       = "admin_ssh_access"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_admin_ips]
  security_group_id = aws_security_group.allow_admins.id
}

# Admin RDP rule
resource "aws_security_group_rule" "admin_rdp_access" {
  description       = "admin_rdp_access"
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_admin_ips]
  security_group_id = aws_security_group.allow_admins.id
}

#######################
## Allow Jenkins access
resource "aws_security_group" "allow_jenkins" {
  name        = "allow_jenkins"
  description = "Allow Suparious Jenkins inbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, map(
    "Name", "${var.project}-${var.env}-sg-jenkins"
  ))
}

# Jenkins HTTP rule
resource "aws_security_group_rule" "jenkins_http_access" {
  description       = "jenkins_http_access"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_admin_ips]
  security_group_id = aws_security_group.allow_jenkins.id
}

# Admin HTTP proxy rule
resource "aws_security_group_rule" "jenkins_http_proxy_access" {
  description       = "jenkins_http_proxy_access"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_admin_ips]
  security_group_id = aws_security_group.allow_jenkins.id
}

# SSL rule
resource "aws_security_group_rule" "jenkins_ssl_access" {
  description       = "jenkins_ssl_access"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_admin_ips]
  security_group_id = aws_security_group.allow_jenkins.id
}

# Admin SSL proxy rule
resource "aws_security_group_rule" "jenkins_ssl_proxy_access" {
  description       = "jenkins_ssl_proxy_access"
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_admin_ips]
  security_group_id = aws_security_group.allow_jenkins.id
}
