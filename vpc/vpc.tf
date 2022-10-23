# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = var.vpc_name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  single_nat_gateway = true
  enable_nat_gateway = false

  tags = var.tags
}