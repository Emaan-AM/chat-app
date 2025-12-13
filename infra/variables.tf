# variables.tf - Variable Definitions

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "chatapp"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

# RDS Configuration
variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "chatdb"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "chatadmin"
  sensitive   = true
}

variable "db_password" {
  description = "Database password - SET THIS IN terraform.tfvars"
  type        = string
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Storage in GB"
  type        = number
  default     = 20
}

# Redis Configuration
variable "redis_node_type" {
  description = "Redis node type"
  type        = string
  default     = "cache.t2.micro"
}

variable "redis_num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1
}

# EKS Configuration
variable "eks_cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "eks_node_instance_types" {
  description = "EKS node instance types"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "eks_min_size" {
  description = "Minimum nodes"
  type        = number
  default     = 1
}

variable "eks_max_size" {
  description = "Maximum nodes"
  type        = number
  default     = 3
}

# EC2 Configuration (Fallback)
variable "use_ec2_instead_of_eks" {
  description = "Use EC2 instead of EKS (cheaper option)"
  type        = bool
  default     = false  # Set to true for cost savings
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 2
}

variable "ssh_key_name" {
  description = "SSH key name for EC2 - SET THIS IF USING EC2"
  type        = string
  default     = ""
}