# terraform-aws-vpc
## Summary  
This module deploys a 3-tier VPC. The following resources are managed:
- VPC
- Subnets
- Routes
- NACLs
- Internet Gateway
- NAT Gateways
- Virtual Private Gateway
- DHCP Option Sets
- VPC Endpoints
- RDS/EC/Redshift Subnet Groups

Tags on VPCs/Subnets are currently set to ignore changes. This is to support EKS clusters.

Terraform >= 0.12 is required for this module.

## CIDR Calculations  
CIDR ranges are automatically calculated using Terraform's [`cidrsubnet()`](https://www.terraform.io/docs/configuration/functions/cidrsubnet.html) function. The default configuration results in equal-sized tiers that are -/2 smaller than the VPC. (A /16 VPC becomes a /18 tier.) Subnets are calculated with tierCIDR-/2. (A /18 tier becomes /20 subnets.) The number of subnets is determined by the number of `availability_zones` specified.

In the event that you do not want this topology, you can configure the `x_tier_newbits` and `x_subnet_newbits` options found in the inputs.

## Custom NACLs  
NACLs in addition to the ones with input options can be added using the `nacl_x_custom` maps. The object schema is:

```hcl
object(
    key = object({
        rule_number = number,
        egress = bool,
        protocol = number,
        rule_action = string,
        cidr_block = string,
        from_port = string,
        to_port = string
    })
    key = ...
)
```

## Requirements

The following requirements are needed by this module:

- terraform (>= 0.12.6)

- aws (>= 2.8.1)

## Providers

The following providers are used by this module:

- aws (>= 2.8.1)

## Required Inputs

The following input variables are required:

### availability\_zones

Description: List of availability zones

Type: `list(string)`

### vpc\_cidr\_block

Description: The CIDR block of the VPC

Type: `string`

### vpc\_name

Description: Name that will be prefixed to resources

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### custom\_dhcp\_options

Description: Custom DHCP options

Type:

```hcl
object({
    domain_name          = string,
    domain_name_servers  = list(string),
    ntp_servers          = list(string),
    netbios_name_servers = list(string),
    netbios_node_type    = number
  })
```

Default:

```json
{
  "domain_name": null,
  "domain_name_servers": null,
  "netbios_name_servers": null,
  "netbios_node_type": null,
  "ntp_servers": null
}
```

### enable\_custom\_dhcp\_options

Description: Enable custom DHCP options, you must specify custom\_dhcp\_options

Type: `bool`

Default: `false`

### enable\_internet\_gateway

Description: Attach an internet gateway to the VPC

Type: `bool`

Default: `true`

### enable\_nat\_gateway

Description: Create nat gateways in the VPC,

Type: `bool`

Default: `true`

### enable\_per\_az\_nat\_gateway

Description: Create 1 nat gateway per AZ

Type: `bool`

Default: `true`

### enable\_virtual\_private\_gateway

Description: Attach a virtual private gateway to the VPC

Type: `bool`

Default: `false`

### nacl\_allow\_all\_ephemeral

Description: Add a rule to all NACLs allowing all ephemeral ports

Type: `bool`

Default: `true`

### nacl\_allow\_all\_http

Description: Add a rule to all NACLs allowing http egress

Type: `bool`

Default: `true`

### nacl\_allow\_all\_https

Description: Add a rule to all NACLs allowing https egress

Type: `bool`

Default: `true`

### nacl\_allow\_all\_vpc\_traffic

Description: Add a rule to all NACLs allowing all traffic to/from the vpc cidr

Type: `bool`

Default: `true`

### nacl\_block\_public\_to\_secure

Description: Block all traffic between public and secure tiers

Type: `bool`

Default: `false`

### nacl\_private\_custom

Description: List of custom nacls to apply to the private tier

Type: `map`

Default: `{}`

### nacl\_public\_custom

Description: List of custom nacls to apply to the public tier

Type: `map`

Default: `{}`

### nacl\_secure\_custom

Description: List of custom nacls to apply to the secure tier

Type: `map`

Default: `{}`

### private\_subnet\_newbits

Description: newbits value for calculating the private subnet size

Type: `number`

Default: `2`

### private\_tier\_netnum

Description: netnum value for calculating the private tier cidr

Type: `number`

Default: `1`

### private\_tier\_newbits

Description: newbits value for calculating the private tier size

Type: `number`

Default: `2`

### public\_subnet\_newbits

Description: newbits value for calculating the public subnet size

Type: `number`

Default: `2`

### public\_tier\_netnum

Description: netnum value for calculating the public tier cidr

Type: `number`

Default: `0`

### public\_tier\_newbits

Description: newbits value for calculating the public tier size

Type: `number`

Default: `2`

### secure\_subnet\_newbits

Description: newbits value for calculating the secure subnet size

Type: `number`

Default: `2`

### secure\_tier\_netnum

Description: netnum value for calculating the secure tier cidr

Type: `number`

Default: `2`

### secure\_tier\_newbits

Description: newbits value for calculating the secure tier size

Type: `number`

Default: `2`

### tags

Description: Tags applied to all resources

Type: `map(string)`

Default: `{}`

### virtual\_private\_gateway\_asn

Description: ASN for the Amazon side of the VPG

Type: `number`

Default: `64512`

### vpc\_enable\_dns\_hostnames

Description: Enable VPC DNS hostname resolution

Type: `bool`

Default: `true`

### vpc\_enable\_dns\_support

Description: Enable VPC DNS resolver

Type: `bool`

Default: `true`

### vpc\_endpoints

Description: List of VPC Interface endpoints

Type: `list(string)`

Default: `[]`

### vpc\_gatewayendpoints

Description: List of VPC Gateway endpoints

Type: `list(string)`

Default: `[]`

## Outputs

The following outputs are exported:

### private\_tier\_route\_table\_ids

Description: List of route table ids for the private tier

### private\_tier\_subnet\_cidr

Description: Private tier CIDR range

### private\_tier\_subnet\_ids

Description: List of subnet ids for the private tier

### public\_tier\_route\_table\_ids

Description: List of route table ids for the public tier

### public\_tier\_subnet\_cidr

Description: Public tier CIDR range

### public\_tier\_subnet\_ids

Description: List of subnet ids for the public tier

### secure\_tier\_route\_table\_ids

Description: List of route table ids for the secure tier

### secure\_tier\_subnet\_cidr

Description: Secure tier CIDR range

### secure\_tier\_subnet\_ids

Description: List of subnet ids for the secure tier

### vpc\_id

Description: VPC ID

