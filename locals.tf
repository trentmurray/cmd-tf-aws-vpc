locals {
  count_to_alpha = {
    "0" = "a"
    "1" = "b",
    "2" = "c",
    "3" = "d"
    "4" = "e"
    "5" = "f"
    "6" = "g"
    "7" = "h"
    "8" = "i"
    "9" = "j"
  }

  public_tier_subnet  = cidrsubnet(var.vpc_cidr_block, var.public_tier_newbits, var.public_tier_netnum)
  private_tier_subnet = cidrsubnet(var.vpc_cidr_block, var.private_tier_newbits, var.private_tier_netnum)
  secure_tier_subnet  = cidrsubnet(var.vpc_cidr_block, var.secure_tier_newbits, var.secure_tier_netnum)
}
