/******************
 * MAIN VARIABLES *
 ******************/
variable "aws_region" {
  description = "Default region where to deploy resources"
  type        = string
}

variable "network_profile" {
  description = "AWS credentials/profile of network account"
  type        = string
}

/********
 * TAGS *
 ********/
variable "project_tag" {
  description = "Project tag"
  type        = string
}

variable "tag_tgw_name" {
  description = "Name tag to name the TGW"
  type        = string
}

/****************************
 * RAM RESOURCE SHARED NAME *
 ****************************/
variable "should_share_with_aws_organizations" {
  description = "If yes, the TGW is shared throughout the AWS Organizations"
  type        = bool
}

variable "ram_resource_shared_name" {
  description = "Ram resource name"
  type        = string
}

/********************
 * TGW ROUTE TABLES *
 ********************/
variable "list_tgw_route_tables" {
  type        = list(any)
  description = "List of transit gateway route tables"
}

variable "blackholed_tgw_rts" {
  type        = list(any)
  description = "List of TGW route tables which are not allowed to communicate with the VPN"
}

variable "communicated_tgw_rts" {
  type        = list(any)
  description = "List of TGW route tables which are allowed to communicate with the VPN"
}

/*******
 * VPN *
 *******/
# variable "on_prem_gw" {
#   description = "Name of the customer gateway"
#   type        = string
# }

# variable "vpn_connection" {
#   description = "Name of the VPN site-to-site connection"
#   type        = string
# }

# variable "vpn_bgp_asn" {
#   description = "BGP ASN"
#   type        = string
# }

# variable "vpn_ip_address" {
#   description = "Address of the on-premise/customer public IP"
#   type        = string
# }

# variable "vpn_type" {
#   description = "Type of VPN"
#   type        = string
# }

# variable "vpn_static_routes_only" {
#   description = "To declare only VPN static routes"
#   type        = bool
# }

# variable "vpn_tunnel1_ike_versions" {
#   description = "IKE versions tunnel 1"
#   type        = list(any)
# }

# variable "vpn_tunnel1_phase1_dh_group_numbers" {
#   description = "DH group numbers phase1 tunnel 1"
#   type        = list(any)
# }

# variable "vpn_tunnel1_phase1_encryption_algorithms" {
#   description = "Encryption algorithms phase 1 tunnel 1"
#   type        = list(any)
# }

# variable "vpn_tunnel1_phase1_integrity_algorithms" {
#   description = "Integrity algorithms phase 1 tunnel 1"
#   type        = list(any)
# }

# variable "vpn_tunnel1_phase2_dh_group_numbers" {
#   description = "DH group numbers phase12 tunnel 1"
#   type        = list(any)
# }

# variable "vpn_tunnel1_phase2_encryption_algorithms" {
#   description = "Encryption algorithms phase 2 tunnel 1"
#   type        = list(any)
# }

# variable "vpn_tunnel1_phase2_integrity_algorithms" {
#   description = "Integrity algorithms phase 2 tunnel 1"
#   type        = list(any)
# }

# variable "vpn_tunnel1_phase1_lifetime_seconds" {
#   description = "Lifetime seconds phase 1 tunnel 1"
#   type        = string
# }

# variable "vpn_tunnel1_phase2_lifetime_seconds" {
#   description = "Lifetime seconds phase 2 tunnel 1"
#   type        = string
# }

# variable "vpn_tunnel2_ike_versions" {
#   description = "IKE versions tunnel 2"
#   type        = list(any)
# }

# variable "vpn_tunnel2_phase1_dh_group_numbers" {
#   description = "DH group numbers phase1 tunnel 2"
#   type        = list(any)
# }

# variable "vpn_tunnel2_phase1_encryption_algorithms" {
#   description = "Encryption algorithms phase 1 tunnel 2"
#   type        = list(any)
# }

# variable "vpn_tunnel2_phase1_integrity_algorithms" {
#   description = "Integrity algorithms phase 1 tunnel 2"
#   type        = list(any)
# }

# variable "vpn_tunnel2_phase2_dh_group_numbers" {
#   description = "DH group numbers phase 2 tunnel 2"
#   type        = list(any)
# }

# variable "vpn_tunnel2_phase2_encryption_algorithms" {
#   description = "Encryption algorithms phase 2 tunnel 2"
#   type        = list(any)
# }

# variable "vpn_tunnel2_phase2_integrity_algorithms" {
#   description = "Integrity algorithms phase 2 tunnel 2"
#   type        = list(any)
# }

# variable "vpn_tunnel2_phase1_lifetime_seconds" {
#   description = "Lifetime seconds phase 1 tunnel 2"
#   type        = string
# }

# variable "vpn_tunnel2_phase2_lifetime_seconds" {
#   description = "Lifetime seconds phase 2 tunnel 2"
#   type        = string
# }

/*************************
 * VPN ATTACHMENT TO TGW *
 *************************/
# variable "on_premise_cidr_block" {
#   description = "On premise cidr block"
#   type        = string
# }