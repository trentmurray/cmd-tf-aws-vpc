resource "random_string" "random" {
  length  = 8
  upper   = false
  special = false
}

module "vpc" {
  source = "../"

  vpc_name = "cmdlabtf${random_string.random.result}"
}
