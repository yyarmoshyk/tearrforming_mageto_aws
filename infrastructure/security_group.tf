resource "aws_security_group" "project" {
  name        = "${var.project_name}"
  description = "security group for ${var.project_name}"
  vpc_id      = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "allow_all" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  prefix_list_ids = ["pl-12c4e678"]

  security_group_id = "sg-123456"
}
