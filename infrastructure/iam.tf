resource "aws_iam_instance_profile" "mage-profile" {
  name  = "${var.project_name}-ec2-profile"
  role = "${aws_iam_role.mage-role.name}"
}

resource "aws_iam_role" "mage-role" {
  name = "${var.project_name}-mage-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
