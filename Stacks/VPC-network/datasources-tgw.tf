/**********
 * TGW ID *
 **********/
data "aws_ec2_transit_gateway" "transit_gateway" {
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
  provider = aws.network_provider
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