module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "${var.project}-${var.region}-eks"
  cluster_version = "1.31"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
  }

  iam_role_additional_policies = {
    ecr_read_only = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }

  eks_managed_node_groups = {
    karpenter = {
      desired_size = 2
      min_size     = 1
      max_size     = 5

      instance_type = [var.instance_type]
      capacity_type = "ON_DEMAND"
    }


  }
  node_security_group_tags = {
    "karpenter.sh/discovery" = "${var.project}-${var.region}-eks"
  }
}

resource "time_sleep" "wait_100_seconds" {
  create_duration = "100s"
  depends_on = [ module.eks ]
}