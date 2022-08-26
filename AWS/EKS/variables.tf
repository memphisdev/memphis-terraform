variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "EKS Cluster environment"
  type        = string
  default     = "dev"
}

variable "application" {
  description = "Application supported by EKS Cluster"
  type        = string
  default     = "memphis"
}

variable "vpc_cidr" {
  description = "CIDR range for VPC of EKS Cluster"
  type        = string
  default     = "10.0.0.0/16"
}

