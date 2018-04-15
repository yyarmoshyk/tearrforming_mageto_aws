resource "aws_security_group" "project" {
  name        = "${var.project_name}"
  description = "security group for ${var.project_name}"
  vpc_id      = "${data.aws_vpc.selected.id}"
}

resource "aws_security_group_rule" "http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
}
