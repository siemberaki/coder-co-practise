# Creating VPC
resource "aws_vpc" "vpc_aws" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "wordpress_vpc"
  }
}

# Creating Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc_aws.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "coderco_gw" {
  vpc_id = aws_vpc.vpc_aws.id

  tags = {
    Name = "wordpress_igw"
  }
}

# Route Table
resource "aws_route_table" "aws_routeTable" {
  vpc_id = aws_vpc.vpc_aws.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.coderco_gw.id
  }

  tags = {
    Name = "wordpress_routeTable"
  }
}

# Route Table Association
resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.aws_routeTable.id
}

# Security Group
resource "aws_security_group" "sg_rules" {
  name   = "wordpress_sg_rules"
  vpc_id = aws_vpc.vpc_aws.id
}

# HTTP inbound
resource "aws_vpc_security_group_ingress_rule" "wordpress_http_inbound" {
  security_group_id = aws_security_group.sg_rules.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

# SSH inbound
resource "aws_vpc_security_group_ingress_rule" "wordpress_ssh_inbound" {
  security_group_id = aws_security_group.sg_rules.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

# Outbound
resource "aws_vpc_security_group_egress_rule" "wordpress_outbound" {
  security_group_id = aws_security_group.sg_rules.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}