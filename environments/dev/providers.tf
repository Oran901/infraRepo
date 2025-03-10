provider "aws" {
  region = local.region
  assume_role {
    role_arn     = "arn:aws:sts::767397954823:role/_localadmin_tf_role"
    session_name = "TerraformSession"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks-infra.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks-infra.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks_auth.token
  }
}

provider  "kubectl" {
    host                   = module.eks-infra.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks-infra.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks_auth.token
  }

data "aws_eks_cluster_auth" "eks_auth" {
  name = module.eks-infra.cluster_name
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-yada"    # Replace with your S3 bucket name
    key            = "terraform/state.tfstate" # Path to the state file in the bucket
    region         = "us-east-1"               # AWS region of the S3 bucket
    encrypt        = true                      # Encrypt state file at rest
    dynamodb_table = "terraform-lock-table"    # Optional for state locking
  }
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.81"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.17.0" 
    }
  }

  required_version = ">= 0.13"
}