aws_region        = "ap-south-1"

vpc_cidr          = "10.10.0.0/16"
subnet_az1a_cidr  = "10.10.1.0/24"
subnet_az1b_cidr  = "10.10.2.0/24"

instance_type     = "t3.small"
root_volume_size  = 65

ami_id            = "ami-0caa6d72e7d3af20d"
key_pair_name     = "hysecure-key"

project_name      = "hysecure-prod"

instance_az_map = {
  active  = "ap-south-1a"
  standby = "ap-south-1b"
  real-1  = "ap-south-1a"
}