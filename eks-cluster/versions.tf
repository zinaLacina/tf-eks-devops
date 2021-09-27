terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "int-zin-interview-tf-state"
    key = "eks-us-east-2-state"
    region = "us-east-2"

    dynamodb_table = "int-eks-us-east-2-state-table"
  }
}

provider "aws" {
  region = var.deployment-region
  profile = "default"
  # assume_role {
  #   role_arn = "${var.provider_env_roles[terraform.workspace]}"
  # }
  
}