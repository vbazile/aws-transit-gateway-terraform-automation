## Transit gateway
This stack creates the AWS Transit Gateway (TGW) and the TGW route tables, and shares the TGW throughout the AWS Organizations if should_share_with_aws_organizations variable configured to true.
<br>
It can also create the site-to-site VPN connection with the on-premise if you carefully uncomment the vpn.tf and variables/values which are related to the VPN.