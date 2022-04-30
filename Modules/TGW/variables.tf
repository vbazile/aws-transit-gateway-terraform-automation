/******************
 * MAIN VARIABLES *
 ******************/

variable "account_name" {
  type        = string
  description = "Account's name"
}

/********
 * TAGS *
 ********/
variable "tag_tgw_name" {
  type        = string
  description = "Name of the transit gateway"
}

/********************
 * TGW ROUTE TABLES *
 ********************/
variable "stack_tgw_rt" {
  type        = string
  description = "TGWRT to which the stack VPC will be associated"
}

variable "blackholed_tgw_rts" {
  type        = list(any)
  description = "List of TGW route tables which are not allowed to communicate with the VPC"
}

variable "communicated_tgw_rts" {
  type        = list(any)
  description = "List of TGW route tables which are allowed to communicate with the VPC"
}

/*******
 * VPC *
 *******/
variable "account_vpc_id" {
  type        = string
  description = "Id of the VPC to be attached"
}

variable "account_vpc_cidr_block" {
  type        = string
  description = "Cidr block of the VPC (to be propagated or blackholed)"
}

variable "account_private_route_table_ids" {
  type        = list(any)
  description = "Private subnets route tables to update when VPC is attached ==> 0.0.0.0/0 => TGW"
}

variable "account_public_route_table_ids" {
  type        = list(any)
  description = "Public route tables to update when VPC is attached ==> 172.16.0.0/12 => TGW"
  default     = [""]
}

variable "account_private_subnets" {
  type        = list(any)
  description = "Private subnets of the VPC"
}