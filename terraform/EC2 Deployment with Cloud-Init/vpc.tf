resource "aws_vpc" "cloud_init_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cloud_init_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.cloud_init_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "cloud_init_public_subnet"
  }
}

resource "aws_internet_gateway" "cloud_init_igw" {
  vpc_id = aws_vpc.cloud_init_vpc.id

  tags = {
    Name = "cloud_init_igw"
  }
}

resource "aws_route_table" "cloud_init_route_table" {
  vpc_id = aws_vpc.cloud_init_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_init_igw.id
  }

  tags = {
    Name = "cloud_init_route_table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.cloud_init_route_table.id
}

resource "aws_security_group" "sg_rules" {
  name   = "cloud_init_sg"
  vpc_id = aws_vpc.cloud_init_vpc.id

  tags = {
    Name = "cloud_init_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_inbound" {
  security_group_id = aws_security_group.sg_rules.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.sg_rules.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}