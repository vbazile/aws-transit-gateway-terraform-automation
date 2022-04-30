/*****************************************
 * VPC PRIVATE SUBNETS AND TGW ATTACHMENT *
 *****************************************/
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_account_vpc_attachement" {
  provider                                        = aws.account_provider
  subnet_ids                                      = var.account_private_subnets
  transit_gateway_id                              = data.aws_ec2_transit_gateway.this.id
  vpc_id                                          = var.account_vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "tgw_att_${var.account_name}_vpc"
  }
}

/**************************************************************************************************
 * UPDATE ALL THE VPC PRIVATE ROUTE TABLES OF THE PROJECT ACCOUNT VPC WITH A DEFAULT ROUTE TO TGW *
 **************************************************************************************************/
resource "aws_route" "route_to_tgw" {
  provider               = aws.account_provider
  count                  = var.account_name == "network" ? 0 : length(var.account_private_route_table_ids)
  route_table_id         = element(var.account_private_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.this.id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_account_vpc_attachement]
}

/****************************************************************************************************************
 * UPDATE ALL THE VPC PUBLIC ROUTE TABLES OF THE PROJECT ACCOUNT VPC WITH A DEFAULT RETURN PRIVATE ROUTE TO TGW *
 ****************************************************************************************************************/
resource "aws_route" "public_return_route_to_tgw" {
  provider               = aws.account_provider
  count                  = var.account_name == "network" ? length(var.account_public_route_table_ids) : 0
  route_table_id         = element(var.account_public_route_table_ids, count.index)
  destination_cidr_block = "172.16.0.0/12"
  transit_gateway_id     = data.aws_ec2_transit_gateway.this.id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_account_vpc_attachement]
}

/****************************************************
 * ASSOCIATE THE VPC ATTACHMENT TO THE STACK TGW RT *
 ****************************************************/
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_account_vpc_assoc" {
  provider                       = aws.network_provider
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_account_vpc_attachement.id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.stack_tgw_rt.id
  depends_on                     = [data.aws_ec2_transit_gateway_route_table.tgw_rt]
}

## LOCALS
locals {
  blackholing_to_tgwrts = [for tgwrt in data.aws_ec2_transit_gateway_route_table.tgw_rt : tgwrt.id if contains(var.blackholed_tgw_rts, tgwrt.tags["Name"])]
  propagating_to_tgwrts = [for tgwrt in data.aws_ec2_transit_gateway_route_table.tgw_rt : tgwrt.id if contains(var.communicated_tgw_rts, tgwrt.tags["Name"])]
}

/*****************************************************************
 * VPC CIDR BLOCK WILL BE BLACKHOLED ON THE GIVEN LIST OF TGWRTS *
 *****************************************************************/
resource "aws_ec2_transit_gateway_route" "tgw_rts_blackholed" {
  provider = aws.network_provider

  count                          = length(local.blackholing_to_tgwrts)
  destination_cidr_block         = var.account_vpc_cidr_block
  blackhole                      = true
  transit_gateway_route_table_id = element(local.blackholing_to_tgwrts, count.index)
  depends_on                     = [data.aws_ec2_transit_gateway_route_table.tgw_rt]
}

/*****************************************************************
 * VPC ATTACHMENT WILL BE PROPAGATED ON THE GIVEN LIST OF TGWRTS *
 *****************************************************************/
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rts_propagated" {
  provider = aws.network_provider

  count                          = length(local.propagating_to_tgwrts)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_account_vpc_attachement.id
  transit_gateway_route_table_id = element(local.propagating_to_tgwrts, count.index)
  depends_on                     = [data.aws_ec2_transit_gateway_route_table.tgw_rt]
}