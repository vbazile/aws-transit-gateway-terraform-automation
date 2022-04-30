/****************
 * AWS PROVIDER *
 ****************/
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.12"
      configuration_aliases = [aws.account_provider, aws.network_provider]
    }
  }
}