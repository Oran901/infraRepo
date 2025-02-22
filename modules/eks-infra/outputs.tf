output "cluster_name" {
  description = "cluster name for providers"
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "cluster endpoint for providers"
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "cluster certificate authority data for providers"
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "oidc provider arn"
  value = module.eks.oidc_provider_arn
}

output "oidc_provider" {
    description = "oidc provider url without https://"
  value = module.eks.oidc_provider
}

output "vpc_id" { 
  description = "vpc id"
  value = module.vpc.vpc_id
}

