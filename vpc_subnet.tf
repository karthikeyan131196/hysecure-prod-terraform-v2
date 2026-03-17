
# VPC

resource "aws_vpc" "hysecure_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

# SUBNETS (Multi-AZ) Private

resource "aws_subnet" "az1a" {
  vpc_id            = aws_vpc.hysecure_vpc.id
  cidr_block        = var.subnet_az1a_cidr
  availability_zone = "ap-south-1a"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-subnet-az1a"
  })
}

resource "aws_subnet" "az1b" {
  vpc_id            = aws_vpc.hysecure_vpc.id
  cidr_block        = var.subnet_az1b_cidr
  availability_zone = "ap-south-1b"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-subnet-az1b"
  })
}


# VIP ENI - AZ1A 

resource "aws_network_interface" "vip_az1a" {
  subnet_id       = aws_subnet.az1a.id
  security_groups = [aws_security_group.hysecure_sg.id]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vip-az1a"
  })
}

# VIP ENI - AZ1B

resource "aws_network_interface" "vip_az1b" {
  subnet_id       = aws_subnet.az1b.id
  security_groups = [aws_security_group.hysecure_sg.id]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vip-az1b"
  })
}
