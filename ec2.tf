# Generate SSH Private Key

resource "tls_private_key" "hysecure_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "hysecure_pem" {
  content         = tls_private_key.hysecure_key.private_key_pem
  filename        = "${path.module}/hysecure-key.pem"
  file_permission = "0400"
}

# AWS Key Pair

resource "aws_key_pair" "hysecure_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.hysecure_key.public_key_openssh
}

#AWS Ec2

resource "aws_instance" "nodes" {
  for_each = var.instance_az_map

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_by_az[each.value]
  vpc_security_group_ids      = [aws_security_group.hysecure_sg.id]

  key_name                    = var.key_pair_name
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
