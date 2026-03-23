#Tag
locals {
  common_tags = {
    Project     = var.project_name
    ManagedBy   = "Accops"
    Environment = "Production"
  }
}
#Avalilable zone
locals {
  subnet_by_az = {
    "${var.aws_region}a" = aws_subnet.az1a.id
    "${var.aws_region}b" = aws_subnet.az1b.id
  }
}
