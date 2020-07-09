resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  availability_zone = sort(var.availability_zones)[count.index]
  cidr_block        = cidrsubnet(local.public_tier_subnet, var.public_subnet_newbits, count.index)

  tags = merge(
    { Name = "${var.vpc_name}-public-${local.count_to_alpha[count.index]}" },
    var.tags
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  availability_zone = sort(var.availability_zones)[count.index]
  cidr_block        = cidrsubnet(local.private_tier_subnet, var.private_subnet_newbits, count.index)

  tags = merge(
    { Name = "${var.vpc_name}-private-${local.count_to_alpha[count.index]}" },
    var.tags
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "secure" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  availability_zone = sort(var.availability_zones)[count.index]
  cidr_block        = cidrsubnet(local.secure_tier_subnet, var.secure_subnet_newbits, count.index)

  tags = merge(
    { Name = "${var.vpc_name}-secure-${local.count_to_alpha[count.index]}" },
    var.tags
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_db_subnet_group" "secure" {
  name       = "${lower(var.vpc_name)}-secure"
  subnet_ids = aws_subnet.secure.*.id

  tags = var.tags
}

resource "aws_redshift_subnet_group" "secure" {
  name       = "${lower(var.vpc_name)}-secure"
  subnet_ids = aws_subnet.secure.*.id

  tags = var.tags
}

resource "aws_elasticache_subnet_group" "secure" {
  name       = "${lower(var.vpc_name)}-secure"
  subnet_ids = aws_subnet.secure.*.id
}
