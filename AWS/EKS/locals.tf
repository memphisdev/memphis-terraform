locals {
  ## Name Prefix
  name_prefix = "${var.application}-${var.environment}"
  ## Cluster name for EKS
  cluster_name = "${local.name_prefix}-${random_string.suffix.result}"
#  region = "${var.region}"

  tags = {
    Application = var.application
    Environment = var.environment
  }
}
