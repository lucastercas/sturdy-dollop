terraform {
  backend "s3" {
    bucket         = "home-infra-tf-state"
    key            = "app/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "home-tf-state-lock"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
