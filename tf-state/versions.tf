terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  profile = "default"
  # assume_role {
  #   role_arn = "${var.provider_env_roles[terraform.workspace]}"
  # }
  
}