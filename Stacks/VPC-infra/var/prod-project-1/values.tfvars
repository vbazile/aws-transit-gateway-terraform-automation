/******************
 * MAIN VALUES *
 ******************/
aws_region   = "eu-west-1"
account_name = "prod-project-1"

/********
 * TAGS *
 ********/
project_tag  = "POC"
tag_tgw_name = "my-tgw"

/*******
 * VPC *
 *******/
vpc_name            = "prod-project-1"
vpc_cidr            = "172.25.0.0/22"
vpc_azs             = ["eu-west-1a", "eu-west-1b"]
vpc_private_subnets = ["172.25.0.0/24", "172.25.2.0/24"]
vpc_public_subnets  = ["172.25.1.0/24", "172.25.3.0/24"]

igw_boolean = true

/************
 * FLOWLOGS *
 ************/
enable_flow_logs            = false
security_flowlog_bucket_arn = "arn:aws:s3:::XXXXXX-vpc-flowlogs"

/******************
 * VPC ATTACHMENT *
 ******************/
vpc_attachment = true

/*********
 * TGWRTS *
 *********/
stack_tgw_rt = "tgw-prod-rt"

blackholed_tgw_rts = [
  "tgw-non-prod-rt"
]

communicated_tgw_rts = [
  "tgw-prod-rt",
  "tgw-vpn-rt",
  "tgw-tooling-rt",
  "tgw-network-rt"
]