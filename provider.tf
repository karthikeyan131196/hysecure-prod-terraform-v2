# terraform version
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# aws provider 
provider "aws" {
  region = var.aws_region
}
# ami source region

provider "aws" {
  alias = "mumbai"
  region = "ap-south-1"
}
