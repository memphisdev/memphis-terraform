variable "region" {
  description = "AWS region. For example: eu-central-1"
  type        = string
}

variable "environment" {
  description = "EKS Cluster environment"
  type        = string
  default     = "cluster"
}

variable "application" {
  description = "Application supported by EKS Cluster"
  type        = string
  default     = "memphis-kela"
}

variable "vpc_cidr" {
  description = "CIDR range for VPC of EKS Cluster"
  type        = string
  default     = "10.0.0.0/16"
}

## EKS Registry details can be found here. 
##https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
variable "eksalb_addon_registryaccount" {
  description = "AWS Provided Account number "
  type        = string
  default     = "602401143452"
}

