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

  database_subnets = [
    for az_index in range(local.az_count) :
    cidrsubnet(local.vpc_cidr, 8, az_index + local.az_count + local.az_count)
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
  project           = "quotes-dev"
  vpc_cidr          = "192.168.0.0/16"
  region            = "us-east-1"
  localAdminAccount = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["localAdminAccount"]
  domain_name       = "oyad.store"
  hostedZoneID      = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["hostedZoneID"]
  karpenter_name    = "eks-karpenter"

}

data "aws_availability_zones" "available" {
  state = "available"
}


data "aws_secretsmanager_secret" "environment_secrets" {
  name = "environment_secrets"
}

data "aws_secretsmanager_secret_version" "example" {
  secret_id = data.aws_secretsmanager_secret.environment_secrets.id
}
