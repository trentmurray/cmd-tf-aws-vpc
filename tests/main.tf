resource "random_string" "random" {
  length  = 8
  special = false
}

module "vpc" {
  source = "../"

  vpc_name       = "cmdlabtf${random_string.random.result}"
  vpc_cidr_block = "10.150.0.0/16"

  availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

  vpc_enable_dns_support   = true
  vpc_enable_dns_hostnames = true

  enable_virtual_private_gateway = true
  enable_nat_gateway             = true
  enable_per_az_nat_gateway      = true

  vpc_gatewayendpoints = ["s3"]
  vpc_endpoints        = ["ssm"]

  nacl_block_public_to_secure = true

  nacl_public_custom = {
    allow_https = {
      rule_number = 1000
      rule_action = "allow"
      egress      = false
      protocol    = 6
      from_port   = 443
      to_port     = 443
      cidr_block  = "0.0.0.0/0"
    }
  }

  tags = {
    Owner      = "Foo"
    Department = "Bar"
  }
}
