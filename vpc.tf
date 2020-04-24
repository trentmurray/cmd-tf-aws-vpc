/**
* # terraform-aws-vpc
* ## Summary
* This module deploys a 3-tier VPC. The following resources are managed:
* - VPC
* - Subnets
* - Routes
* - NACLs
* - Internet Gateway
* - NAT Gateways
* - Virtual Private Gateway
* - DHCP Option Sets
* - VPC Endpoints
*
* Tags on VPCs/Subnets are currently set to ignore changes. This is to support EKS clusters.
*
* Terraform >= 0.12 is required for this module.
*
* ## CIDR Calculations
* CIDR ranges are automatically calculated using Terraform's [`cidrsubnet()`](https://www.terraform.io/docs/configuration/functions/cidrsubnet.html) function. The default configuration results in equal-sized tiers that are -/2 smaller than the VPC. (A /16 VPC becomes a /18 tier.) Subnets are calculated with tierCIDR-/2. (A /18 tier becomes /20 subnets.) The number of subnets is determined by the number of `availability_zones` specified.
*
* In the event that you do not want this topology, you can configure the `x_tier_newbits` and `x_subnet_newbits` options found in the inputs.
*
* ## Custom NACLs
* NACLs in addition to the ones with input options can be added using the `nacl_x_custom` maps. The object schema is:
*
* ```hcl
* object(
*     key = object({
*         rule_number = number,
*         egress = bool,
*         protocol = number,
*         rule_action = string,
*         cidr_block = string,
*         from_port = string,
*         to_port = string
*     })
*     key = ...
* )
* ```
*/

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = merge(
    { Name = var.vpc_name },
    var.tags
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_internet_gateway" "main" {
  count = var.enable_internet_gateway ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = var.vpc_name },
    var.tags
  )
}

resource "aws_vpn_gateway" "main" {
  count = var.enable_virtual_private_gateway ? 1 : 0

  vpc_id          = aws_vpc.main.id
  amazon_side_asn = var.virtual_private_gateway_asn

  tags = merge(
    { Name = var.vpc_name },
    var.tags
  )
}

resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? (var.enable_per_az_nat_gateway ? length(var.availability_zones) : 1) : 0

  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.main[count.index].id

  tags = merge(
    { Name = "${var.vpc_name}-${local.count_to_alpha[count.index]}" },
    var.tags
  )
}

resource "aws_eip" "main" {
  count = var.enable_nat_gateway ? (var.enable_per_az_nat_gateway ? length(var.availability_zones) : 1) : 0

  vpc = true

  tags = merge(
    { Name = "${var.vpc_name}-nat-${local.count_to_alpha[count.index]}" },
    var.tags
  )
}
