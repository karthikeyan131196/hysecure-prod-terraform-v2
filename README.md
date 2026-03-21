# HySecure Multi-Zone AWS Infrastructure – Terraform

## Overview
This repository contains **Terraform Infrastructure as Code (IaC)** used to deploy the **HySecure Gateway infrastructure on AWS Multi-Zone**.

The Terraform configuration provisions the following AWS resources:

- VPC
- Multi-AZ Subnets
- Internet Gateway
- Route Tables
- Security Groups
- EC2 Instances (Active / Standby / Real Node)
- External Network Load Balancer
- Internal Network Load Balancer
- Target Groups and Listeners
- VIP Network Interfaces
- SSH Key Pair generation

This setup provides **high availability HySecure deployment across multiple availability zones**.

---

# Architecture
Internet
│
▼
External Network Load Balancer (Port 443)
│
▼
HySecure Cluster

Active Node (ap-south-1a)
Standby Node (ap-south-1b)
Real Node (ap-south-1a)

│
▼
Internal Network Load Balancer (Between Active and standby)

Ports:
3306 → Database communication
939 → InfoAgent communication

# Repository Structure
hysecure-prod-terraform
│
├── main.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
│
├── ec2.tf
├── vpc_subnet.tf
├── security_groups.tf
├── internetroute.tf
│
├── nlb_external.tf
├── nlb_internal.tf
├── targetgroup.tf
│
├── outputs.tf
└── README.md

---

# Infrastructure Components

## VPC
Creates a dedicated VPC for HySecure deployment.

CIDR block is defined in **variables.tf**.

---

## Subnets

CIDR block is defined in **variables.tf**.

Two subnets are created across different Availability Zones.

| Subnet      | Availability Zone |
|------       |------             |
| subnet-az1a | ap-south-1a       |
| subnet-az1b | ap-south-1b       |

---

## EC2 Instances

Number of vm , instance type , vm size , Hysecure AMI , key pair , project name is defined in **terraform.tfvar**.

Three HySecure nodes are deployed.

| Instance | AZ          | Role                     |
|------    |------       |------                    |
| Active   | ap-south-1a | Primary HySecure Gateway |
| Standby  | ap-south-1b | Secondary Node           |
| Real     | ap-south-1a | Real Node                |

Instance configuration:

- Private IP only
- gp3 root volume
- SSH key generated automatically

---

# Load Balancers

## External Network Load Balancer

Used for **user login traffic**

Port: **443**  
Protocol: **TCP**

Routes traffic to HySecure nodes.

---

## Internal Network Load Balancer

Used for **internal cluster communication**

| Port | Purpose  |
|----  |----      |
| 3306 | Database |
| 939  | InfoAgent|

---

# Security Group Rules

Inbound ports allowed:

| Port   | Protocol | Purpose              |
|----    |----      |----                  |
| 443    | TCP      | HySecure login       |
| 22     | TCP      | SSH                  |
| 3306   | TCP      | Database             |
| 939    | TCP      | InfoAgent            |
| 5536   | TCP      | File synchronization |
| 51234  | TCP      | Remote meeting       |
| 4002   | TCP/UDP  | Log synchronization  |
| 539    | TCP/UDP  | Cluster communication|

Outbound traffic: **Allow All**

---

# SSH Key Generation

Terraform automatically generates an SSH key pair using:

- `tls_private_key`
- `aws_key_pair`

Private key saved locally in where terraform excecuted.


---

# Prerequisites

Install the following tools:

- Terraform >= 1.5
- AWS CLI

Check versions:

terraform -v
aws --version

# Configure AWS Credentials


aws configure

[default]
aws_access_key_id = AKIAxxxxxxxxxxxx
aws_secret_access_key = xxxxxxxxxxxxx

[default]
region = ap-south-1
output = json

# Verify Configuration

aws sts get-caller-identity

Expected output:

{
"UserId": "XXXXXXXXXXXX",
"Account": "123456789012",
"Arn": "arn:aws:iam::123456789012:user/your-user"
}

# Deploy Infrastructure

Initialize Terraform:

terraform init

Validate configuration:

terraform validate

terraform plan

Deploy infrastructure:

terraform apply

or 

terraform apply -auto-approve

# Terraform Outputs

After deployment Terraform returns outputs such as:

- `vpc_id`
- `subnet_ids`
- `instance_ids`
- `private_ips`
- `external_nlb_dns`
- `internal_nlb_dns`
- `vip_ips_by_az`

---

# Destroy Infrastructure

To remove all resources:

terraform destroy