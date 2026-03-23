# Generate SSH Private Key

resource "tls_private_key" "hysecure_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "hysecure_pem" {
  content         = tls_private_key.hysecure_key.private_key_pem
  filename        = "${path.module}/${var.project_name}-key.pem"
  file_permission = "0400"
}

# AWS Key Pair

resource "aws_key_pair" "hysecure_key" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.hysecure_key.public_key_openssh
}

#AWS Ec2

locals {
  use_source_ami = var.aws_region == "ap-south-1"
}

resource "aws_ami_copy" "hysecure" {
  count = local.use_source_ami ? 0 : 1

  name              = "hysecure-${var.aws_region}"
  source_ami_id     = var.source_ami_id
  source_ami_region = "ap-south-1"

  description = "HySecure AMI copied to ${var.aws_region}"

  tags = {
    Name = "hysecure-${var.aws_region}"
  }
}

#Avalilable zone
locals {
  subnet_by_az = {
    "${var.aws_region}a" = aws_subnet.az1a.id
    "${var.aws_region}b" = aws_subnet.az1b.id
  }
}

resource "aws_instance" "nodes" {
  for_each = var.instance_az_map

  ami                         = local.use_source_ami ? var.source_ami_id : aws_ami_copy.hysecure[0].id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_by_az[each.value]
  vpc_security_group_ids      = [aws_security_group.hysecure_sg.id]

  key_name                    = aws_key_pair.hysecure_key.key_name
  associate_public_ip_address = false

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${each.key}"
    Role = each.key
  })

  depends_on = [aws_key_pair.hysecure_key]
}