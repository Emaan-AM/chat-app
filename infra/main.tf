# main.tf - Provider Configuration

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "ChatApp"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Course      = "CSC418-DevOps"
      Batch       = "FA22"
      Section     = "G1"
      Owner       = "Khadijah"
    }
  }
}