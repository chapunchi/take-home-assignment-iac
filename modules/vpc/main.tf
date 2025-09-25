locals {
  total_public_subnets  = length(var.azs) * var.public_subnet_count
  total_private_subnets = length(var.azs) * var.private_subnet_count

  public_subnets  = [for i in range(local.total_public_subnets)  : cidrsubnet(var.cidr, 8, i)]
  private_subnets = [for i in range(local.total_private_subnets) : cidrsubnet(var.cidr, 8, i + local.total_public_subnets)]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = local.public_subnets
  public_subnets  = local.private_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Environment = "gic-dev"
  }
}

