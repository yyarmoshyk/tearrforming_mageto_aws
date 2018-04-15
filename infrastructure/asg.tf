data "template_file" "init" {
  template = "${file("${var.userdata_file}")}"
  vars {
    project_name      = "${var.project_name}"
    domains           = "${var.domains}"
  }
}

resource "aws_launch_configuration" "magento" {
  name_prefix             = "${var.project_name}"
  image_id                = "${data.aws_ami.centos7.id}"
  key_name                = "mage-operations-key"
  user_data               = "${data.template_file.init.rendered}"
  security_groups         = ["${aws_security_group.project.id}"]
  iam_instance_profile 	  =   "${var.project_name}-ec2-profile"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "magento" {
  name = "${var.project_name}-asg"
  launch_configuration = "${aws_launch_configuration.magento.id}"

  # -------------------------------------------------------------------
  # vpc_zone_identifier is used to define subnet ids of the desired VPC
  # We'll use the ID of the isolated subnet  that has been created few teps ago
  # -------------------------------------------------------------------
  #vpc_zone_identifier = ["${data.aws_subnet_ids.proxied.ids}"]
  vpc_zone_identifier = ["${data.aws_subnet_ids.private.ids}"]

  min_size = "1"
  max_size = "10"
  desired_capacity = "2"

  health_check_grace_period = 600

  load_balancers = ["${aws_elb.magento.name}"]
  health_check_type = "EC2"
}
