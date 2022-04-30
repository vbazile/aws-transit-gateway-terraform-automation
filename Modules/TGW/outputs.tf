/*********************
 * VPC ATTACHMENT ID *
 *********************/
output "vpc_attachment_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.tgw_account_vpc_attachement.id
  description = "Id of the VPC attachment"
}