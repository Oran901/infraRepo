locals {
  # Calculate number of AZs in the region
  az_count = min(3, length(data.aws_availability_zones.available.names))

  # Generate CIDR blocks for public subnets
  public_subnets = [
    for az_index in range(local.az_count) :
    cidrsubnet(local.vpc_cidr, 8, az_index)
  ]

  # Generate CIDR blocks for private subnets
  private_subnets = [
    for az_index in range(local.az_count) :
    cidrsubnet(local.vpc_cidr, 8, az_index + local.az_count)
  ]

  # Map AZs to their names
  azs = data.aws_availability_zones.available.names

  # security group inbound rules

  sg_inbound = {
    ssh   = { port = 22, description = "Allow SSH access" }
    http  = { port = 80, description = "Allow HTTP traffic" }
    https = { port = 443, description = "Allow HTTPS traffic" }
  }


  ########## variables ###############
  environment       = "dev"
  instance_type     = "t2.medium"
  project           = "pokerogue-dev"
  vpc_cidr          = "192.168.0.0/16"
  region            = "us-east-1"
  localAdminAccount = "767397954823"
  domain_name = "oyad.store"
  hostedZoneID = "Z00239011XNDU2W7J7TM6"
  email = "oranxbox@gmail.com"

}

data "aws_availability_zones" "available" {
  state = "available"
}

