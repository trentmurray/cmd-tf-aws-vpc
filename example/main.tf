module "vpc" {
  source = "https://github.com/cmdlabs/cmd-tf-aws-vpc?ref=0.6.0"

  vpc_name       = "cmd-vpc-1"
  vpc_cidr_block = "10.150.0.0/16"

  availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]

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
    allow_http = {
      rule_number = 1001
      rule_action = "allow"
      egress      = false
      protocol    = 6
      from_port   = 80
      to_port     = 80
      cidr_block  = "0.0.0.0/0"
    }
    allow_ssh = {
      rule_number = 1002
      rule_action = "allow"
      egress      = false
      protocol    = 6
      from_port   = 22
      to_port     = 22
      cidr_block  = "0.0.0.0/0"
    }
  }

  tags = {
    Owner      = "Foo"
    Department = "Bar"
  }
}
