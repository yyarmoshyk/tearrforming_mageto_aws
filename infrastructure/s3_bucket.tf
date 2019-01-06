#####
# Create S3 bucket where servers will place assets and CloudFront will read them to deliver to clients
#####
resource "aws_s3_bucket" "mage-assets" {
  bucket  = "${var.project_name}-assets-bucket"
  region  = "${var.region}"
  acl     = "internal"

  versioning {
    enabled = true
  }

  # policy = "${file("policy.json")}"
  policy     = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_instance_profile.mage-instance-profile.arn}"
                ]
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.project_name}-assets-bucket/*",
                "arn:aws:s3:::${var.project_name}-assets-bucket"
            ]
        }
      ]
}
POLICY

  tags {
    project_name        = "${var.project_name}"
		Name 				        = "${var.project_name}-assets-bucket"
    infrastructure_ver  = "${var.infrastructure_ver != "" ? var.infrastructure_ver : "none"}"
	}
}
