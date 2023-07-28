#Author: Alexandru Raul
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"  # Specify the desired version constraint here
    }
  }
}

provider "aws" {
   region = var.region
   profile = var.profile
}
