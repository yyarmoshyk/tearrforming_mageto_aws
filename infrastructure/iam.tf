####
# Define policy document of the role to be created
####
data "aws_iam_policy_document" "mage-role-policy-document" {
  statement {
    sid    = ""
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

####
# Create role
####
resource "aws_iam_role" "mage-role" {
  name               = "${var.project_name}-mage-role"
  path               = "/${var.project_name}/"
  assume_role_policy = "${data.aws_iam_policy_document.mage-role-policy-document.json}"
}

####
# Create IAM instance profile with aws_iam_role.mage-role
####
resource "aws_iam_instance_profile" "mage-instance-profile" {
  name  = "${var.project_name}-ec2-profile"
  role = "${aws_iam_role.mage-role.name}"
}

####
# Define IAM policy that allows to work with assets s3 bucket
####
data "aws_iam_policy_document" "mage-iam-policy-document" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.mage-assets.arn}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.mage-assets.arn}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListObjects",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "mage-iam-policy" {
  name        = "${var.project_name}-mage-iam-policy"
  description = "AWS policy of the role that is going to be attached to EC2 instances"
  path        = "/${var.project_name}/"
  policy      = "${data.aws_iam_policy_document.mage-iam-policy-document.json}"
}

# Attach IAM policy to instance profile:
# ec2_s3_prod_writer

resource "aws_iam_role_policy_attachment" "mage-iam-policy-role-attachment" {
  role       = "${aws_iam_role.mage-role.name}"
  policy_arn = "${aws_iam_policy.mage-iam-policy.arn}"
}
