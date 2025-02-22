module "eks-infra" {
  source = "../../modules/eks-infra"

  vpc_cidr          = local.vpc_cidr
  az_count          = local.az_count
  public_subnets    = local.public_subnets
  private_subnets   = local.private_subnets
  database_subnets  = local.database_subnets
  azs               = local.azs
  sg_inbound        = local.sg_inbound
  environment       = local.environment
  instance_type     = local.instance_type
  project           = local.project
  region            = local.region
}

module "eks-helm" {
  source = "../../modules/eks-helm"
  
  cluster_name = module.eks-infra.cluster_name
  environment       = local.environment
  project           = local.project
  region            = local.region
  localAdminAccount = local.localAdminAccount
  domain_name = local.domain_name
  hostedZoneID = local.hostedZoneID
  oidc_provider = module.eks-infra.oidc_provider
  oidc_provider_arn = module.eks-infra.oidc_provider_arn
  vpc_id = module.eks-infra.vpc_id

  depends_on = [ module.eks-infra ]
}