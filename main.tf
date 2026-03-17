#tag
locals {
  common_tags = {
    Project     = var.project_name
    ManagedBy   = "Accops"
    Environment = "Production"
  }
}
#avalilable zone
locals {
  subnet_by_az = {
    "ap-south-1a" = aws_subnet.az1a.id
    "ap-south-1b" = aws_subnet.az1b.id
  }
}