output "public_tier_subnet_cidr" {
  description = "Public tier CIDR range"
  value       = local.public_tier_subnet
}

output "private_tier_subnet_cidr" {
  description = "Private tier CIDR range"
  value       = local.private_tier_subnet
}

output "secure_tier_subnet_cidr" {
  description = "Secure tier CIDR range"
  value       = local.secure_tier_subnet
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_tier_subnet_ids" {
  description = "List of subnet ids for the public tier"
  value       = aws_subnet.public.*.id
}

output "private_tier_subnet_ids" {
  description = "List of subnet ids for the private tier"
  value       = aws_subnet.private.*.id
}

output "secure_tier_subnet_ids" {
  description = "List of subnet ids for the secure tier"
  value       = aws_subnet.secure.*.id
}

output "public_tier_route_table_ids" {
  description = "List of route table ids for the public tier"
  value       = aws_route_table.public[*].id
}

output "private_tier_route_table_ids" {
  description = "List of route table ids for the private tier"
  value       = aws_route_table.private[*].id
}

output "secure_tier_route_table_ids" {
  description = "List of route table ids for the secure tier"
  value       = aws_route_table.secure[*].id
}

output "db_subnet_group" {
  description = "Name of db subnet group"
  value       = aws_db_subnet_group.secure.id
}

output "redshift_subnet_group" {
  description = "Name of redshift subnet group"
  value       = aws_redshift_subnet_group.secure.id
}

output "elasticache_subnet_group" {
  description = "Name of elasticache subnet group"
  value       = aws_elasticache_subnet_group.secure.name
}
