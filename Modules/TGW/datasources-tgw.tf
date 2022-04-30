/**********
 * TGW ID *
 **********/
data "aws_ec2_transit_gateway" "this" {
  provider = aws.network_provider
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "tag:Name"
    values = [var.tag_tgw_name]
  }
}

/*********************
 * GETTING ALL TGWRTS *
 *********************/
data "aws_ec2_transit_gateway_route_tables" "tgw_rts" {
  provider   = aws.network_provider
  depends_on = [data.aws_ec2_transit_gateway.this]
}

/***************************
 * GETTING ALL TGWRTS BY ID *
 ***************************/
data "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  provider = aws.network_provider

  count = length(data.aws_ec2_transit_gateway_route_tables.tgw_rts.ids)
  id    = element(tolist(data.aws_ec2_transit_gateway_route_tables.tgw_rts.ids), count.index)

  depends_on = [data.aws_ec2_transit_gateway_route_tables.tgw_rts]
}

/************************************************************
 * THE TGWRT TO WHICH THE VPC ATTACHMENT WILL BE ASSOCIATED *
 ************************************************************/
data "aws_ec2_transit_gateway_route_table" "stack_tgw_rt" {
  provider = aws.network_provider

  filter {
    name   = "tag:Name"
    values = [var.stack_tgw_rt]
  }
}