/***********
 * BACKEND *
 ***********/
terraform {
  backend "s3" {
    region         = "eu-west-1"
    profile        = "revolve_tooling"
    bucket         = "github-tgw-backend-tfstates"
    key            = "shared-services/network/vpc-outbound/terraform.tfstate"
    dynamodb_table = "tgw-tfstate-locking"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12"
    }
  }
}