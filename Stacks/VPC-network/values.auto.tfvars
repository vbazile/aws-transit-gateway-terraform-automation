/***************
 * MAIN VALUES *
 ***************/
aws_region = "eu-west-1"

# Account name
account_name = "network"

/********
 * TAGS *
 ********/
project_tag  = "POC"
tag_tgw_name = "my-tgw"

/*******
 * VPC *
 *******/
vpc_name                       = "network"
vpc_cidr                       = "172.22.0.0/22"
vpc_azs                        = ["eu-west-1a", "eu-west-1b"]
vpc_private_subnets            = ["172.22.0.0/24", "172.22.2.0/24"]
vpc_public_subnets             = ["172.22.1.0/24", "172.22.3.0/24"]
boolean_one_nat_gateway_per_az = true
igw_boolean                    = true

/*************
 * FLOW LOGS *
 *************/
enable_flow_logs            = false
security_flowlog_bucket_arn = "arn:aws:s3:::xxxxx-vpc-flowlogs"

/******************
 * VPC ATTACHMENT *
 ******************/
vpc_attachment = true
stack_tgw_rt   = "tgw-network-rt"
blackholed_tgw_rts = [
  "tgw-network-rt"
]

communicated_tgw_rts = [
  "tgw-tooling-rt",
  "tgw-non-prod-rt",
  "tgw-prod-rt",
  "tgw-vpn-rt"
]