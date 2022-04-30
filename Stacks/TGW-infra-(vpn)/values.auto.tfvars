/******************
 * MAIN VARIABLES *
 ******************/
aws_region = "eu-west-1"

/********
 * TAGS *
 ********/
project_tag  = "POC"
tag_tgw_name = "my-tgw"

/****************************
 * RAM RESOURCE SHARED NAME *
 ****************************/
should_share_with_aws_organizations = false
ram_resource_shared_name            = "transit-gateway-share"

/********************
 * TGW ROUTE TABLES *
 ********************/
list_tgw_route_tables = [
  "tgw-tooling-rt",
  "tgw-network-rt",
  "tgw-non-prod-rt",
  "tgw-prod-rt",
  "tgw-vpn-rt"
]

## Shouldn't communicate with
blackholed_tgw_rts = [
  "tgw-vpn-rt"
]

## Should communicate with
communicated_tgw_rts = [
  "tgw-network-rt",
  "tgw-non-prod-rt",
  "tgw-prod-rt",
  "tgw-tooling-rt"
]

/*******
 * VPN *
 *******/
# on_prem_gw = "on-prem-gw"
# vpn_connection = "vpn-connection"

# vpn_bgp_asn            = XXX
# vpn_ip_address         = "XXX"
# vpn_type               = "XXX"
# vpn_static_routes_only = XXX

# vpn_tunnel1_ike_versions                 = ["XXX"]
# vpn_tunnel1_phase1_dh_group_numbers      = ["XXX"]
# vpn_tunnel1_phase1_encryption_algorithms = ["XXX"]
# vpn_tunnel1_phase1_integrity_algorithms  = ["XXX"]
# vpn_tunnel1_phase2_dh_group_numbers      = ["XXX"]
# vpn_tunnel1_phase2_encryption_algorithms = ["XXX"]
# vpn_tunnel1_phase2_integrity_algorithms  = ["XXX"]
# vpn_tunnel1_phase1_lifetime_seconds      = "XXX"
# vpn_tunnel1_phase2_lifetime_seconds      = "XXX"

# vpn_tunnel2_ike_versions                 = ["XXX"]
# vpn_tunnel2_phase1_dh_group_numbers      = ["XXX"]
# vpn_tunnel2_phase1_encryption_algorithms = ["XXX"]
# vpn_tunnel2_phase1_integrity_algorithms  = ["XXX"]
# vpn_tunnel2_phase2_dh_group_numbers      = ["XXX"]
# vpn_tunnel2_phase2_encryption_algorithms = ["XXX"]
# vpn_tunnel2_phase2_integrity_algorithms  = ["XXX"]
# vpn_tunnel2_phase1_lifetime_seconds      = "XXX"
# vpn_tunnel2_phase2_lifetime_seconds      = "XXX"

/*************************
 * VPN ATTACHMENT TO TGW *
 *************************/
# on_premise_cidr_block  = "XXX"