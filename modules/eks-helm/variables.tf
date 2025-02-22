variable "project" {
  description = "The name for generic stuff"
  type        = string
  default     = "yada"
}

variable "environment" {
  description = "The environment for the bucket"
  type        = string
}

variable "region" {
  type        = string
  description = "aws region"
}

variable "localAdminAccount" {
  type = string
}


variable "domain_name" {
  description = "domain name"
  type = string
}

variable "hostedZoneID" {
  description = "hosted zone id"
  type = string
  
}

variable "cluster_name" {
  description = "eks cluster name"
  type = string
}

variable "oidc_provider" {
  description = "oidc provider url without https://"
  type = string
}

variable "oidc_provider_arn" {
  description = "oidc provider arn"
  type = string
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

