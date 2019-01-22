resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "${var.app}-VPC-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.app}-IGW-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_subnet" "snELB1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.app}-SNG-ELB-1-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_subnet" "snELB2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.app}-SNG-ELB-2-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_subnet" "snAPP1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.app}-SNG-APP-1-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_subnet" "snAPP2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.app}-SNG-APP-2-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_network_acl" "acl" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.app}-ACL-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_route_table" "routeTable" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${var.app}-VPC-ROUTES-${var.env}"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_route_table_association" "rta-A" {
  subnet_id      = "${aws_subnet.snELB1.id}"
  route_table_id = "${aws_route_table.routeTable.id}"
}

resource "aws_route_table_association" "rta-B" {
  subnet_id      = "${aws_subnet.snELB2.id}"
  route_table_id = "${aws_route_table.routeTable.id}"
}

resource "aws_eip" "eIP-NAT" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.eIP-NAT.id}"
  subnet_id     = "${aws_subnet.snELB1.id}"

  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_route_table" "routeTable-PRVT" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw.id}"
  }

  tags {
    Name = "${var.app}-${var.env}-VPC-ROUTES-PRVT"
    App  = "${var.app}"
    Env  = "${var.env}"
  }
}

resource "aws_route_table_association" "rta-C" {
  subnet_id      = "${aws_subnet.snAPP1.id}"
  route_table_id = "${aws_route_table.routeTable-PRVT.id}"
}

resource "aws_route_table_association" "rta-D" {
  subnet_id      = "${aws_subnet.snAPP2.id}"
  route_table_id = "${aws_route_table.routeTable-PRVT.id}"
}