#################################################
# VPC & SUBNET IDs
#################################################

output "vpc_id" {
  value = local.vpc_id
}

output "subnet_ids" {
  value = [
    local.subnet_az1a_id,
    local.subnet_az1b_id
  ]
}

#################################################
# SECURITY GROUP
#################################################

output "security_group_id" {
  value = aws_security_group.hysecure_sg.id
}

#################################################
# EC2 INSTANCES
#################################################

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

#################################################
# PRIVATE KEY
#################################################

output "private_key_location" {
  value = "hysecure-key.pem created in Terraform folder"
}

#################################################
# VIP IPs
#################################################

output "vip_ips_by_az" {
  description = "VIP private IP mapped to Availability Zone"

  value = {
    "${var.aws_region}a" = aws_network_interface.vip_az1a.private_ip
    "${var.aws_region}b" = aws_network_interface.vip_az1b.private_ip
  }
}

#################################################
# INTERNAL NLB
#################################################

output "internal_nlb_by_az" {
  description = "Internal NLB DNS"

  value = {
    dns_name = aws_lb.internal_nlb.dns_name
  }
}

#################################################
# EXTERNAL NLB
#################################################

output "external_nlb_by_az" {
  description = "External NLB DNS"

  value = {
    dns_name = aws_lb.external_nlb.dns_name
  }
}