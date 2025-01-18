module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "${var.project}-${var.region}-vpc"
  cidr   = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

   create_database_subnet_route_table = true


  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1" 
    "environment"            = var.environment
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1" 
    "environment"                     = var.environment
  }

  tags = {
    environment = var.environment
  }
}