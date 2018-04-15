data "aws_availability_zones" "available" {}

# ---------------------------------------------------------------------------------------------------------------------
# Create subnet with specified parametres
# Need one public and private subnet in every availability zone of the region
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "public" {
    count = "${length(data.aws_availability_zones.available.names)}"
    vpc_id = "${aws_vpc.magento.id}"
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    cidr_block = "10.0.${10+count.index}.0/24"
    tags {
        Name = "${replace(element(data.aws_availability_zones.available.names, count.index), "/([a-z]+-)+/", "")}-public-net"
    }
}

resource "aws_subnet" "private" {
    count = "${length(data.aws_availability_zones.available.names)}"
    vpc_id = "${aws_vpc.magento.id}"
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    cidr_block = "10.0.${20+count.index}.0/24"
    tags {
        Name = "${replace(element(data.aws_availability_zones.available.names, count.index), "/([a-z]+-)+/", "")}-private-net"
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# internet gateway
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "magento" {
  vpc_id = "${aws_vpc.magento.id}"

  tags {
    Name = "main internet gateway"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Route table for networks
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.magento.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.magento.id}"
    }

    tags {
        Name = "Public route"
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# Route association for networks
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "public" {
    # count = "${length(aws_subnet.public.*.id)}"
    count = "${length(data.aws_availability_zones.available.names)}"
    subnet_id = "${aws_subnet.public.*.id[count.index]}"
    route_table_id = "${aws_route_table.public.id}"
    depends_on = ["aws_route_table.public"]
}
resource "aws_route_table_association" "private" {
    # count = "${length(aws_subnet.private.*.id)}"
    count = "${length(data.aws_availability_zones.available.names)}"
    subnet_id = "${aws_subnet.private.*.id[count.index]}"
    route_table_id = "${aws_route_table.public.id}"
    depends_on = ["aws_route_table.public"]
}

resource "aws_eip" "egress" {
  vpc = true
  depends_on = ["aws_route_table.public"]
}

resource "aws_nat_gateway" "magento" {
  allocation_id = "${aws_eip.egress.id}"
  subnet_id     = "${aws_subnet.public.0.id}"
  depends_on = ["aws_eip.egress", "aws_route_table.public"]
}

# resource "aws_nat_gateway" "private" {
#   allocation_id = "${aws_eip.egress.id}"
#   subnet_id     = "${aws_subnet.private.*.id[count.index]}"
#
#   depends_on = ["aws_eip.egress", "aws_route_table.public"]
# }
