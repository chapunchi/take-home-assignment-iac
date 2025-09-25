output "vpc_id" {
  description = "The id of the vpc"
  value       = module.vpc.vpc_id
}

output "cidr" {
  description = "CIDR of the vpc"
  value       = var.cidr
}

output "public_subnets_list" {
  description = "Public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets_list" {
  description = "Private subnets"
  value       = module.vpc.private_subnets
}