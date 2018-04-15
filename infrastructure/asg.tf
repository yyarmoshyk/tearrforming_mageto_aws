data "template_file" "init" {
  template = "${file("${var.userdata_file}")}"
  vars {
    service_name      = "${var.service_name}"
    domains           = "${var.domains}"
  }
}

resource "aws_launch_configuration" "asg" {
  name_prefix             = "${var.project_name}"
  image_id                = "${data.aws_ami.mage_ami.id}"
  key_name                = "mage-operations-key"
  user_data               = "${data.template_file.init.rendered}"
  security_groups         = ["${aws_security_group.project.id}"]
  iam_instance_profile 	  =   "${var.project_name}-ec2-profile"

  lifecycle {
    create_before_destroy = true
  }
}
