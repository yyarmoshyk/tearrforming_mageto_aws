#####
# Public security groups to be attached to Load Balancer and bastion hosts
#####
resource "aws_security_group" "public" {
  name        = "${var.project_name}-public-sg"
  description = "Public security group for ${var.project_name}"
  vpc_id      = "${data.aws_vpc.magento.id}"
}

resource "aws_security_group_rule" "public-ingress" {
  count             = "${length(local.public_ingress_ports)}"
  security_group_id = "${aws_security_group.public.id}"
  type              = "ingress"
  from_port         = "${local.public_ingress_ports[count.index]}"
  to_port           = "${local.public_ingress_ports[count.index]}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public-egress" {
  count             = "${length(local.public_egress_ports)}"
  security_group_id = "${aws_security_group.public.id}"
  type              = "egress"
  from_port         = "${local.public_egress_ports[count.index]}"
  to_port           = "${local.public_egress_ports[count.index]}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public-ingress-from-private" {
  security_group_id         = "${aws_security_group.public.id}"
  type                      = "inress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "tcp"
  source_security_group_id  = "${aws_security_group.private.id}"
}

resource "aws_security_group_rule" "public-egress-to-private" {
  security_group_id         = "${aws_security_group.public.id}"
  type                      = "egress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "tcp"
  source_security_group_id  = "${aws_security_group.private.id}"
}

#####
# Non-public security groups to be attached to instances
#####
resource "aws_security_group" "private" {
  name                      = "${var.project_name}-private-sg"
  description               = "Private security group for ${var.project_name}"
  vpc_id                    = "${data.aws_vpc.magento.id}"
}

resource "aws_security_group_rule" "private-ingress-from-public" {
  security_group_id         = "${aws_security_group.private.id}"
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "tcp"
  source_security_group_id  = "${aws_security_group.public.id}"
}

resource "aws_security_group_rule" "private-egress-to-public" {
  security_group_id         = "${aws_security_group.private.id}"
  type                      = "egress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "tcp"
  source_security_group_id  = "${aws_security_group.public.id}"
}

resource "aws_security_group_rule" "private-egress" {
  count             = "${length(local.public_egress_ports)}"
  security_group_id = "${aws_security_group.private.id}"
  type              = "egress"
  from_port         = "${local.public_egress_ports[count.index]}"
  to_port           = "${local.public_egress_ports[count.index]}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
