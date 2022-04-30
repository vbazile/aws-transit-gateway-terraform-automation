/*******
 * VPC *
 *******/
module "vpc_network" {
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

  enable_nat_gateway     = true
  one_nat_gateway_per_az = var.boolean_one_nat_gateway_per_az
  enable_vpn_gateway     = false
  create_igw             = var.igw_boolean

  enable_dns_hostnames = true
  enable_dns_support   = true
}

/**************
 * VPC ROUTES *
 **************/
## Send any default private local traffic to TGW 
resource "aws_route" "local_default_traffic_to_TGW_1" {
  provider               = aws.network_provider
  count                  = length(module.vpc_network.private_route_table_ids)
  route_table_id         = module.vpc_network.private_route_table_ids[count.index]
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = data.aws_ec2_transit_gateway.transit_gateway.id
  depends_on             = [module.vpc_network]
}

resource "aws_route" "local_default_traffic_to_TGW_2" {
  provider               = aws.network_provider
  count                  = length(module.vpc_network.private_route_table_ids)
  route_table_id         = module.vpc_network.private_route_table_ids[count.index]
  destination_cidr_block = "172.16.0.0/12"
  transit_gateway_id     = data.aws_ec2_transit_gateway.transit_gateway.id
  depends_on             = [module.vpc_network]
}

resource "aws_route" "local_default_traffic_to_TGW_3" {
  provider               = aws.network_provider
  count                  = length(module.vpc_network.private_route_table_ids)
  route_table_id         = module.vpc_network.private_route_table_ids[count.index]
  destination_cidr_block = "192.168.0.0/16"
  transit_gateway_id     = data.aws_ec2_transit_gateway.transit_gateway.id
  depends_on             = [module.vpc_network]
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
  vpc_id               = module.vpc_network.vpc_id
  tags                 = { "vpc_name" = module.vpc_network.name }
}

/******************
 * VPC ATTACHMENT *
 ******************/
module "vpc_attachment" {
  source = "../../Modules/TGW"

  providers = {
    aws.account_provider = aws.account_provider
    aws.network_provider = aws.network_provider
  }
  count = var.vpc_attachment ? 1 : 0

  account_name = var.account_name
  stack_tgw_rt = var.stack_tgw_rt
  tag_tgw_name = var.tag_tgw_name

  account_vpc_id                  = module.vpc_network.vpc_id
  account_vpc_cidr_block          = var.vpc_cidr
  account_public_route_table_ids  = module.vpc_network.public_route_table_ids
  account_private_route_table_ids = module.vpc_network.private_route_table_ids
  account_private_subnets         = module.vpc_network.private_subnets

  blackholed_tgw_rts   = var.blackholed_tgw_rts
  communicated_tgw_rts = var.communicated_tgw_rts
}

/************************
 * DEFAULT ROUTE TO TGW *
 ************************/
## So that the internet traffic from other VPCs is routed to this outbound vpc
locals {
  route_to_internet = [for tgwrt in data.aws_ec2_transit_gateway_route_table.tgw_rt : tgwrt.id if !contains(["tgw-vpn-rt", "tgw-network-rt"], tgwrt.tags["Name"])]
}

resource "aws_ec2_transit_gateway_route" "route_to_internet" {
  provider                       = aws.network_provider
  count                          = length(local.route_to_internet)
  transit_gateway_attachment_id  = module.vpc_attachment[0].vpc_attachment_id
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = local.route_to_internet[count.index]
  depends_on                     = [module.vpc_attachment]
}