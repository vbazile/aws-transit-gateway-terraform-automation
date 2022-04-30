/***********************
 * AWS TRANSIT GATEWAY *
 ***********************/
## TGW
resource "aws_ec2_transit_gateway" "this" {
  provider                        = aws.network_provider
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"
  tags                            = { "Name" = var.tag_tgw_name }
}

## TGW route tables
resource "aws_ec2_transit_gateway_route_table" "this" {
  provider           = aws.network_provider
  count              = length(var.list_tgw_route_tables)
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags               = { "Name" = element(var.list_tgw_route_tables, count.index), "transit_gateway" = var.tag_tgw_name }
}

/********************************************************************************************************
 *                               SHARING THE TGW THROUGHOUT THE AWS ORGANIZATIONS.                      *
 * MADE POSSIBLE BY ENABLING AWS_SERVICE_ACCESS_PRINCIPALS = ["RAM.AMAZONAWS.COM"] IN AWS ORGANIZATIONS *
 ********************************************************************************************************/
## My AWS Organizations
data "aws_organizations_organization" "my_organization" {
  provider = aws.network_provider
  count    = var.should_share_with_aws_organizations ? 1 : 0
}

## Resource share
resource "aws_ram_resource_share" "ram_resource_share" {
  provider                  = aws.network_provider
  count                     = var.should_share_with_aws_organizations ? 1 : 0
  name                      = var.ram_resource_shared_name
  allow_external_principals = false
  tags                      = { "Name" = var.ram_resource_shared_name }
  depends_on                = [aws_ec2_transit_gateway.this]
}

## Associate a principal
resource "aws_ram_principal_association" "my_aws_organizations" {
  provider           = aws.network_provider
  count              = var.should_share_with_aws_organizations ? 1 : 0
  principal          = data.aws_organizations_organization.my_organization[count.index].arn
  resource_share_arn = aws_ram_resource_share.ram_resource_share[count.index].arn
}

## Associate a resource
resource "aws_ram_resource_association" "tgw" {
  provider           = aws.network_provider
  count              = var.should_share_with_aws_organizations ? 1 : 0
  resource_arn       = aws_ec2_transit_gateway.this.arn
  resource_share_arn = aws_ram_resource_share.ram_resource_share[count.index].arn
}