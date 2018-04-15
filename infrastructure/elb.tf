resource "aws_elb" "magento" {
  name                = "${var.project_name}-elb"
  subnets = ["${data.aws_subnet_ids.public.ids)}"]

  cross_zone_load_balancing   = true

  internal = "false"

  security_groups = ["${aws_security_group.project.id}"]

  listener {
    instance_port     = "80"
    instance_protocol = "http"
    lb_port           = "80"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 3
    target              = "HTTP:${var.server_port}${var.elb_health_check_path}"
    interval            = 10
  }
}
