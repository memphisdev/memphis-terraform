variable "region" {
  description = "AWS region. For example: eu-central-1"
  type        = string
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

## EKS Registry details can be found here. 
##https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
variable "eksalb_addon_registryaccount" {
  description = "AWS Provided Account number "
  type        = string
  default     = "602401143452"
}

variable "enable_dns" {
  type = bool
  description = "To enable DNS using Route53"
  default = false
}

variable "hostedzonename" {
  description = "AWS Route53 Hosted Zone Name"
  type = string
  default = ""
}


variable "enable_ssl" {
  type = bool
  description = "To use HTTPs/SSL for in-transit communications."
  default = false
}