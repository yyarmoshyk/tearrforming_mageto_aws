data "aws_vpc" "magento" {
  filter = {
    name   = "tag:Name"
    values = ["magento"]
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

data "aws_ami" "centos7" {
  most_recent = "true"
  filter {
    name = "name"
    values = ["*CentOS 7*"]
  }
}
