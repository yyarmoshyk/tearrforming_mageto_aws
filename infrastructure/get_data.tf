data "aws_vpc" "magento" {
  filter = {
    name   = "tag:Name"
    values = ["Magento"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.magento.id}"
  tags {
    Name = "*public-net"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.magento.id}"
  tags {
    Name = "*private-net"
  }
}

data "aws_ami" "amzn" {
  most_recent      = true
  executable_users = ["self"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }
}
