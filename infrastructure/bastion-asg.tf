data "template_file" "bastion" {
  template = "${file("${var.userdata_file}")}"
  vars {
    project_name      = "${var.project_name}"
    domains           = "${var.domains}"
  }
}

resource "aws_launch_configuration" "bastion" {
  name_prefix                       = "${var.project_name}-bastion"
  image_id                          = "${data.aws_ami.amzn.id}"
  key_name                          = "mage-operations-key"
  user_data                         = "${data.template_file.bastion.rendered}"
  vpc_classic_link_security_groups  = ["${aws_security_group.public.id}"]
  iam_instance_profile 	            = "${var.project_name}-ec2-profile"
  instance_type                     = "${var.instance_type}"

  lifecycle {
    create_before_destroy           = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name = "${var.project_name}-bastion-asg"
  launch_configuration = "${aws_launch_configuration.bastion.id}"

  # -------------------------------------------------------------------
  # vpc_zone_identifier is used to define subnet ids of the desired VPC
  # We'll use the ID of the isolated subnet  that has been created few teps ago
  # -------------------------------------------------------------------
  #vpc_zone_identifier = ["${data.aws_subnet_ids.proxied.ids}"]
  vpc_zone_identifier = ["${data.aws_subnet_ids.public.ids}"]

  min_size = "1"
  max_size = "1"
  desired_capacity = "1"

  health_check_grace_period = 120

  health_check_type = "EC2"

  tags = [
    {
      key = "Name"
      value = "${var.project_name}-bastion-instance"
      propagate_at_launch = true
    }
  ]
}
