# EXISTING VPC / SUBNET LOOKUP

data "aws_vpc" "existing" {
  count = var.existing_vpc_id != "" ? 1 : 0

  id = var.existing_vpc_id
}

data "aws_subnet" "existing_az1a" {
  count = var.existing_subnet_az1a_id != "" ? 1 : 0

  id = var.existing_subnet_az1a_id
}

data "aws_subnet" "existing_az1b" {
  count = var.existing_subnet_az1b_id != "" ? 1 : 0

  id = var.existing_subnet_az1b_id
}

# CREATE VPC (ONLY IF NOT PROVIDED)

resource "aws_vpc" "hysecure_vpc" {
  count = var.existing_vpc_id == "" ? 1 : 0

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

# LOCAL VALUES

locals {
  vpc_id = (
    var.existing_vpc_id != ""
    ? data.aws_vpc.existing[0].id
    : aws_vpc.hysecure_vpc[0].id
  )

  effective_vpc_cidr = (
    var.existing_vpc_id != ""
    ? data.aws_vpc.existing[0].cidr_block
    : var.vpc_cidr
  )

  subnet_az1a_id = (
    var.existing_subnet_az1a_id != ""
    ? data.aws_subnet.existing_az1a[0].id
    : aws_subnet.az1a[0].id
  )

  subnet_az1b_id = (
    var.existing_subnet_az1b_id != ""
    ? data.aws_subnet.existing_az1b[0].id
    : aws_subnet.az1b[0].id
  )
}

# CREATE SUBNETS (ONLY IF NOT PROVIDED)

resource "aws_subnet" "az1a" {
  count = var.existing_subnet_az1a_id == "" ? 1 : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.subnet_az1a_cidr
  availability_zone = "${var.aws_region}a"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-subnet-az1a"
  })
}

resource "aws_subnet" "az1b" {
  count = var.existing_subnet_az1b_id == "" ? 1 : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.subnet_az1b_cidr
  availability_zone = "${var.aws_region}b"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-subnet-az1b"
  })
}

# VIP ENI - AZ1A

resource "aws_network_interface" "vip_az1a" {
  subnet_id       = local.subnet_az1a_id
  security_groups = [aws_security_group.hysecure_sg.id]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vip-az1a"
  })
}

# VIP ENI - AZ1B

resource "aws_network_interface" "vip_az1b" {
  subnet_id       = local.subnet_az1b_id
  security_groups = [aws_security_group.hysecure_sg.id]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vip-az1b"
  })
}