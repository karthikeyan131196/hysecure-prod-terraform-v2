
# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hysecure_vpc.id

    tags = merge(local.common_tags, {
    Name = "${var.project_name}-igw"
  })
}


# Public Route Table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.hysecure_vpc.id

    tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-rt"
  })
}

# Internet Route

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnet AZ1A

resource "aws_route_table_association" "az1a_public_assoc" {
  subnet_id      = aws_subnet.az1a.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate Public Subnet AZ1B

resource "aws_route_table_association" "az1b_public_assoc" {
  subnet_id      = aws_subnet.az1b.id
  route_table_id = aws_route_table.public_rt.id
}
