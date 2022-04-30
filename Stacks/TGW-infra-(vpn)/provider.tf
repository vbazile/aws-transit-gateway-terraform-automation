/****************
 * AWS PROVIDER *
 ****************/
## Network account
provider "aws" {
  alias   = "network_provider"
  region  = var.aws_region
  profile = var.network_profile
  default_tags {
    tags = {
      project = lower(var.project_tag)
    }
  }
}