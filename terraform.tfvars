# Define the AWS region where the infrastructure will be created for production environment
aws_region        = "us-east-1"

# Define VPC and subnet CIDR ranges
vpc_cidr          = "10.10.0.0/16"
subnet_az1a_cidr  = "10.10.1.0/24"
subnet_az1b_cidr  = "10.10.2.0/24"

# Existing VPC and Subnet IDs
existing_vpc_id         = ""
existing_subnet_az1a_id = ""
existing_subnet_az1b_id = ""

# Define instance type and root volume size for EC2 instances
instance_type     = "t3.small"
root_volume_size  = 65

# Define project name used for resource naming and tagging
project_name      = "hysecure-prod"

# Define the nodes to be created along with their respective Availability Zones
# Note:
# - 'active' and 'standby' nodes name must retain same, as these names are used in loops for target group creation
# - Additional nodes (e.g., real-1) can be added with any name; corresponding VMs will be created accordingly
instance_az_map = {
  active  = "us-east-1a"
  standby = "us-east-1b"
  real-1  = "us-east-1a"
}