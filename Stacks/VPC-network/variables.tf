/******************
 * MAIN VARIABLES *
 ******************/
variable "aws_region" {
  description = "Default region where to deploy resources"
  type        = string
}

variable "network_profile" {
  description = "Network account's AWS credentials/profile"
  type        = string
}

variable "account_profile" {
  description = "Project account's AWS credentials/profile"
  type        = string
}

variable "account_name" {
  description = "Account where to the VPC is being deployed"
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
  type        = string
  description = "Name of the transit gateway"
}

/*******
 * VPC *
 *******/
variable "vpc_name" {
  description = "Name of the network vpc"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr block of the network VPC"
  type        = string
}

variable "vpc_azs" {
  description = "List of the AZ"
  type        = list(any)
}

variable "vpc_private_subnets" {
  description = "List of private subnets cidr blocks"
  type        = list(any)
}

variable "vpc_public_subnets" {
  description = "List of public subnets cidr blocks"
  type        = list(any)
}

variable "boolean_one_nat_gateway_per_az" {
  description = "High availability for nat gateway"
  type        = bool
}

variable "igw_boolean" {
  description = "Whether to create public subnets and related routes"
  type        = bool
}

/*************
 * FLOW LOGS *
 *************/
variable "enable_flow_logs" {
  description = "If true, flow logs are enabled"
  type        = bool
}

variable "security_flowlog_bucket_arn" {
  description = "ARN of the flowlog bucket in the security account"
  type        = string
}

/******************
 * VPC ATTACHMENT *
 ******************/
variable "vpc_attachment" {
  description = "If true, this VPC will be attached to the TGW"
  type        = bool
}

variable "stack_tgw_rt" {
  description = "TGW route table to which this VPC will be associated"
  type        = string
}

variable "blackholed_tgw_rts" {
  description = "List of TGW route tables which are not allowed to communicate with this VPC"
  type        = list(any)
}

variable "communicated_tgw_rts" {
  description = "List of TGW route tables which are allowed to communicate with this VPC"
  type        = list(any)
}