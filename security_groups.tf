resource "aws_security_group" "hysecure_sg" {
  name        = "${var.project_name}-sg"
  description = "HySecure Security Group"
  vpc_id      = aws_vpc.hysecure_vpc.id

  # TCP INBOUND 

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "User login"
  }

  dynamic "ingress" {
    for_each = {
      22    = "SSH access to the HySecure gateway"
      939   = "Cluster information"
      5536  = "Files Synchronization"
      3306  = "Database access"
      51234 = "Remote Meeting"
      4002  = "Logs Synchronization"
      539   = "Cluster information"
    }

    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
      description = ingress.value
    }
  }

  # UDP INBOUND 

  dynamic "ingress" {
    for_each = {
      539  = "Cluster information"
      4002 = "Logs Synchronization"
    }

    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "udp"
      cidr_blocks = [var.vpc_cidr]
      description = ingress.value
    }
  }

  # OUTBOUND 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-sg"
  })
}
