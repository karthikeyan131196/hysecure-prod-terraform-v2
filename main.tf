#Tag
locals {
  common_tags = {
    Project     = var.project_name
    ManagedBy   = "Accops"
    Environment = "Production"
  }
}

