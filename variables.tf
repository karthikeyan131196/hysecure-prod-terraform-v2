variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "source_ami_id" {
  description = "AMI ID from Mumbai Region"
  type = string
  default     = "ami-0caa6d72e7d3af20d"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "subnet_az1a_cidr" {
  description = "Subnet CIDR for AZ ap-south-1a"
  type        = string
}

variable "subnet_az1b_cidr" {
  description = "Subnet CIDR for AZ ap-south-1b"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size (GB)"
  type        = number
}

variable "project_name" {
  type = string
}

variable "instance_az_map" {
  type = map(string)
}