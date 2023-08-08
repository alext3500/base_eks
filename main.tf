terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.22.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = "admin"
  region  = "us-east-1"
}

data "aws_region" "current" {}