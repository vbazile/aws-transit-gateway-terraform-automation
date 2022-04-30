/***************
 * PROJECT VPC *
 ***************/
module "project_vpc" {
  providers = {
    aws = aws.account_provider
  }

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false
  create_igw         = var.igw_boolean

  enable_dns_hostnames = true
  enable_dns_support   = true
}

/*************
 * FLOW LOGS *
 *************/
resource "aws_flow_log" "flowlogs" {
  provider             = aws.account_provider
  count                = var.enable_flow_logs ? 1 : 0
  log_destination      = var.security_flowlog_bucket_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.project_vpc.vpc_id
}

/******************
 * VPC ATTACHMENT *
 ******************/
module "vpc_attachment" {
  source = "../../../Modules/TGW"

  providers = {
    aws.account_provider = aws.account_provider
    aws.network_provider = aws.network_provider
  }
  count = var.vpc_attachment ? 1 : 0

  account_name = var.account_name
  stack_tgw_rt = var.stack_tgw_rt
  tag_tgw_name = var.tag_tgw_name

  account_vpc_id                  = module.project_vpc.vpc_id
  account_vpc_cidr_block          = var.vpc_cidr
  account_private_route_table_ids = module.project_vpc.private_route_table_ids
  account_private_subnets         = module.project_vpc.private_subnets

  blackholed_tgw_rts   = var.blackholed_tgw_rts
  communicated_tgw_rts = var.communicated_tgw_rts
}