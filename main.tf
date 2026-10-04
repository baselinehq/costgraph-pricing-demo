terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Plan-only demo. No real AWS credentials or deployed resources.
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "demo-not-a-real-access-key"
  secret_key                  = "demo-not-a-real-secret-key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
}

variable "instance_type" {
  type = string
}

variable "instance_count" {
  type = number
}

resource "aws_instance" "api" {
  count             = var.instance_count
  ami               = "ami-00000000000000000" # Deliberately invalid. Never apply this demo.
  instance_type     = var.instance_type
  availability_zone = "us-east-1a"

  tags = {
    Name    = "costgraph-demo-api-${count.index + 1}"
    Purpose = "pricing-review-demo"
  }
}
