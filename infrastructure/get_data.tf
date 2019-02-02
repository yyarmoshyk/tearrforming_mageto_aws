data "aws_vpc" "selected" {
  filter = {
    name   = "tag:Name"
    values = ["Magento"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags {
    Name = "*private-net"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags {
    Name = "*public-net"
  }
}

# data "aws_ami" "amzn" {
#   most_recent      = true
#
#   filter {
#     name   = "owner-alias"
#     values = ["amazon"]
#   }
#
#   filter {
#     name   = "name"
#     values = ["amzn-ami-hvm-*x86_64-gp2"]
#   }
# }

data "aws_ami" "amzn" {
  most_recent      = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["*ubuntu-*-server*"]
  }
}
