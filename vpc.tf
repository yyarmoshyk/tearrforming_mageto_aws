resource "aws_vpc" "magento" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Name = "Magento"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Internet gateway for public networks
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "public" {
    vpc_id = "${aws_vpc.magento.id}"
}
