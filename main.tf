terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "vpc_flow_logs" {
  source = "./modules/vpc_flow_logs"
  vpc_id = module.vpc.vpc_id
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  cidr   = module.vpc.cidr
}

module "alb" {
  source                = "./modules/alb"
  vpc_id                = module.vpc.vpc_id
  public_subnets_list   = module.vpc.public_subnets_list
  alb_security_group_id = module.security_group.alb_security_group_id
}

module "waf" {
  source = "./modules/waf"
  alb    = module.alb.alb
}

module "ecr" {
  source = "./modules/ecr"
}

module "logging" {
  source = "./modules/logging"
}

module "ecs" {
  source                = "./modules/ecs"
  private_subnets_list  = module.vpc.private_subnets_list
  alb_security_group_id = module.security_group.alb_security_group_id
  aws_lb_target_group   = module.alb.aws_lb_target_group
  aws_lb_listener       = module.alb.aws_lb_listener
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "config" {
  source = "./modules/config"
}

module "cloudtrail" {
  source = "./modules/cloudtrail"
}

module "inspector" {
  source = "./modules/inspector"
}

module "securityhub" {
  source = "./modules/security_hub"
}

module "guardduty" {
  source = "./modules/guardduty"
}

module "ddb" {
  source = "./modules/ddb"
}

