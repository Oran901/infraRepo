terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17" # Adjust to the latest compatible version
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0" # Use the desired version
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81"
    }
    time = {
      source = "hashicorp/time"
    }
  }
  required_version = ">= 0.13"
}