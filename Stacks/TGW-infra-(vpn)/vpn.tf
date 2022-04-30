/*******
 * VPN *
 *******/
# ## Customer gateway
# resource "aws_customer_gateway" "on_prem_gw" {
#   provider = aws.network_provider
#   bgp_asn    = var.vpn_bgp_asn
#   ip_address = var.vpn_ip_address
#   type       = var.vpn_type

#   tags = {
#     Name = var.on_prem_gw
#   }
# }

# ## Creation of the site-to-site VPN connection
# resource "aws_vpn_connection" "vpn_connection" {
#   provider = aws.network_provider
#   customer_gateway_id = aws_customer_gateway.on_prem_gw.id
#   transit_gateway_id  = aws_ec2_transit_gateway.this.id
#   type                = var.vpn_type
#   static_routes_only  = var.vpn_static_routes_only

#   ## Remove this if you want to destroy the stack. As long as you have this lifecycle policy, you won't be able to destroy the stack.
#   lifecycle {
#     prevent_destroy = true
#   }

#   ## VPN Parameters
#   tunnel1_ike_versions                 = var.vpn_tunnel1_ike_versions
#   tunnel1_phase1_dh_group_numbers      = var.vpn_tunnel1_phase1_dh_group_numbers
#   tunnel1_phase1_encryption_algorithms = var.vpn_tunnel1_phase1_encryption_algorithms
#   tunnel1_phase1_integrity_algorithms  = var.vpn_tunnel1_phase1_integrity_algorithms
#   tunnel1_phase2_dh_group_numbers      = var.vpn_tunnel1_phase2_dh_group_numbers
#   tunnel1_phase2_encryption_algorithms = var.vpn_tunnel1_phase2_encryption_algorithms
#   tunnel1_phase2_integrity_algorithms  = var.vpn_tunnel1_phase2_integrity_algorithms
#   tunnel1_phase1_lifetime_seconds      = var.vpn_tunnel1_phase1_lifetime_seconds
#   tunnel1_phase2_lifetime_seconds      = var.vpn_tunnel1_phase2_lifetime_seconds

#   tunnel2_ike_versions                 = var.vpn_tunnel2_ike_versions
#   tunnel2_phase1_dh_group_numbers      = var.vpn_tunnel2_phase1_dh_group_numbers
#   tunnel2_phase1_encryption_algorithms = var.vpn_tunnel2_phase1_encryption_algorithms
#   tunnel2_phase1_integrity_algorithms  = var.vpn_tunnel2_phase1_integrity_algorithms
#   tunnel2_phase2_dh_group_numbers      = var.vpn_tunnel2_phase2_dh_group_numbers
#   tunnel2_phase2_encryption_algorithms = var.vpn_tunnel2_phase2_encryption_algorithms
#   tunnel2_phase2_integrity_algorithms  = var.vpn_tunnel2_phase2_integrity_algorithms
#   tunnel2_phase1_lifetime_seconds      = var.vpn_tunnel2_phase1_lifetime_seconds
#   tunnel2_phase2_lifetime_seconds      = var.vpn_tunnel2_phase2_lifetime_seconds

#   tags = {
#     Name = var.vpn_connection
#   }
# }

/**********************
 * VPN-TGW ATTACHMENT *
 **********************/
# ## Locals to retrieve the ID of the VPN tgw route tables
# locals {
#   vpn_tgw_rt_id         = [for tgwrt in aws_ec2_transit_gateway_route_table.tgw_route_table : tgwrt.id if contains(["tgw-vpn-rt"], tgwrt.tags["Name"])]
#   blackholing_to_tgwrts = [for tgwrt in aws_ec2_transit_gateway_route_table.tgw_route_table : tgwrt.id if contains(var.blackholed_tgw_rts, tgwrt.tags["Name"])]
#   propagating_to_tgwrts = [for tgwrt in aws_ec2_transit_gateway_route_table.tgw_route_table : tgwrt.id if contains(var.communicated_tgw_rts, tgwrt.tags["Name"])]
# }

# ## Associate VPN site-to-site connection attachment to VPN TGW route table
# resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_vpn" {
#   provider = aws.network_provider
#   transit_gateway_attachment_id  = aws_vpn_connection.vpn_connection.transit_gateway_attachment_id
#   transit_gateway_route_table_id = local.vpn_tgw_rt_id[0]
# }

# ## Blackhole/prevent VPN site-to-site connection to communicate with itself
# resource "aws_ec2_transit_gateway_route" "tgw_rts_blackholed" {
#   provider = aws.network_provider
#   count                          = length(local.blackholing_to_tgwrts)
#   destination_cidr_block         = var.on_premise_cidr_block
#   blackhole                      = true
#   transit_gateway_route_table_id = element(local.blackholing_to_tgwrts, count.index)
# }

# ## Propagate the VPN site-to-site connection attachment to other TGW route tables
# resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rts_propagated" {
#   provider = aws.network_provider
#   count                          = length(local.propagating_to_tgwrts)
#   transit_gateway_attachment_id  = aws_vpn_connection.vpn_connection.transit_gateway_attachment_id
#   transit_gateway_route_table_id = element(local.propagating_to_tgwrts, count.index)
# }

# ## Add a route to VPN attachment for any TGW route tables which is not the VPN TGW route table
# locals {
#   route_to_vpn = [for tgwrt in aws_ec2_transit_gateway_route_table.this : tgwrt.id if !contains(["tgw-vpn-rt"], tgwrt.tags["Name"])]
# }

# resource "aws_ec2_transit_gateway_route" "route_to_VPN" {
#   provider = aws.network_provider
#   count                          = length(local.route_to_vpn)
#   transit_gateway_attachment_id  = aws_vpn_connection.vpn_connection.transit_gateway_attachment_id
#   destination_cidr_block         = <on_premise_cidr_block>
#   transit_gateway_route_table_id = local.route_to_vpn[count.index]
# }