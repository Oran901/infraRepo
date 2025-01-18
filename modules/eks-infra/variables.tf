variable "project" {
  description = "The name for generic stuff"
  type        = string
  default     = "yada"
}

variable "environment" {
  description = "The environment for the bucket"
  type        = string
}

variable "instance_type" {
  type        = string
  description = "ec2 instance type"
}

variable "region" {
  type        = string
  description = "aws region"
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "az_count" {
  description = "The number of availability zones to use, up to 3."
  type        = number
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
}

variable "database_subnets" {
  description = "List of CIDR blocks for database subnets."
  type        = list(string)
}


variable "azs" {
  description = "List of availability zone names."
  type        = list(string)
}

variable "sg_inbound" {
  description = "Map of security group inbound rules."
  type        = map(object({
    port        = number
    description = string
  }))
}
