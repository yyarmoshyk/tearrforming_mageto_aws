data "template_file" "magento" {
  template = "${file("${var.userdata_file}")}"
  vars {
    project_name      = "${var.project_name}"
    domains           = "${var.domains}"
    S3_BUCKET         = "${var.project_name}-assets-bucket"
    my_role           = "${var.project_name}-mage-role"
  }
}

resource "aws_launch_configuration" "magento" {
  name_prefix                       = "${var.project_name}-mage"
  image_id                          = "${data.aws_ami.amzn.id}"
  key_name                          = "id_rsa_mac"
  user_data                         = "${data.template_file.magento.rendered}"
  security_groups                   = ["${aws_security_group.private.id}"]
  iam_instance_profile 	            = "${var.project_name}-ec2-profile"
  instance_type                     = "${var.instance_type}"

  lifecycle {
    create_before_destroy           = true
  }
}

resource "aws_autoscaling_group" "magento" {
  name = "${var.project_name}-mage-asg"
  launch_configuration = "${aws_launch_configuration.magento.id}"

  # -------------------------------------------------------------------
  # vpc_zone_identifier is used to define subnet ids of the desired VPC
  # We'll use the ID of the isolated subnet  that has been created few teps ago
  # -------------------------------------------------------------------
  vpc_zone_identifier = ["${data.aws_subnet_ids.private.ids}"]

  min_size = "1"
  max_size = "10"
  desired_capacity = "1"

  health_check_grace_period = 120

  load_balancers = ["${aws_elb.magento.name}"]
  health_check_type = "EC2"

  tags = [
    {
      key = "Name"
      value = "${var.project_name}-mage-ec2-instance"
      propagate_at_launch = true
    }
  ]
}
