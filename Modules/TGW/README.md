# Transit Gateway Module

This module should be called when a VPC is instanciated for it to be automatically attached to the transit gateway.

The transit gateway is instanciated in the network account and is shared throughout the AWS Organization.

This module will deploy resources in two accounts thanks to two providers:
- the targeted account in which the VPC is instanciated
- the network account to associate the attachment with the intended transit gateway route table and propagating/blackholing routes.

To fetch the right resources in each account, we use a tag strategy. The appropriate resources are retriveved in the data.tf file, which gathers the terraform datasources.

The module:
- creates an attachement to the private subnets of the VPC (targeted account)
- updates the private VPC route tables of the VPC to add the transit gateway as a default route for 0.0.0.0/0, only if it is not the VPC outbound from the network account. In this latter case, the VPC should have the NAT gateway as a target for 0.0.0.0/0 (targeted account)
- updates the vpc routes of the public subnets with a default route to the AWS network (172.0.0.0/6) except for the network vpc. Otherwise, there won't be any return traffic when going out to the internet (targeted account)
- associates the VPC attachment with the intended transit gateway route table (network account)
- propagates the VPC attachment on the other transit gateway route tables if the VPC is allowed to be reached by other VPCs (network account)
- blackholes the VPC attachment with the other transit gateway route table if the VPC is not allowed to be reached by other VPCs (network account)