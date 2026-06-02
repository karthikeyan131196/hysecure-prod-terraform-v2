#################################################
# CREATE NETWORKING ONLY FOR NEW VPC
#################################################

resource "aws_internet_gateway" "igw" {
  count  = var.existing_vpc_id == "" ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

resource "aws_route_table" "public_rt" {
  count  = var.existing_vpc_id == "" ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-rt"
  })
}

resource "aws_route" "internet_access" {
  count = var.existing_vpc_id == "" ? 1 : 0

  route_table_id         = aws_route_table.public_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

resource "aws_route_table_association" "az1a_public_assoc" {
  count = var.existing_vpc_id == "" ? 1 : 0

  subnet_id      = local.subnet_az1a_id
  route_table_id = aws_route_table.public_rt[0].id
}

resource "aws_route_table_association" "az1b_public_assoc" {
  count = var.existing_vpc_id == "" ? 1 : 0

  subnet_id      = local.subnet_az1b_id
  route_table_id = aws_route_table.public_rt[0].id
}