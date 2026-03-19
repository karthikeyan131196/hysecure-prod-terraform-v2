# VPC & SUBNET ID
output "vpc_id" {
  value = aws_vpc.hysecure_vpc.id
}

output "subnet_ids" {
  value = [
    aws_subnet.az1a.id,
    aws_subnet.az1b.id
  ]
}

# SECURITY GROUP NAME

output "security_group_id" {
  value = aws_security_group.hysecure_sg.id
}

# EC2 INSTANCE OUTPUTS

output "instance_ids" {
  value = {
    for k, v in aws_instance.nodes :
    k => v.id
  }
}

output "private_ips" {
  value = {
    for k, v in aws_instance.nodes :
    k => v.private_ip
  }
}

# VIP IP OUTPUT 

output "private_key_location" {
  value = "hysecure-key.pem created in Terraform folder"
}

output "vip_ips_by_az" {
  description = "VIP private IP mapped to Availability Zone"

  value = {
    (aws_subnet.az1a.availability_zone) = aws_network_interface.vip_az1a.private_ip
    (aws_subnet.az1b.availability_zone) = aws_network_interface.vip_az1b.private_ip
  }
}

# NLB DNS NAME

output "internal_nlb_by_az" {
  description = "Internal NLB DNS and IP per AZ"

  value = {
    dns_name = aws_lb.internal_nlb.dns_name
  }
}

output "external_nlb_by_az" {
  description = "External NLB DNS and IP per AZ"

  value = {
    dns_name = aws_lb.external_nlb.dns_name
  }
}