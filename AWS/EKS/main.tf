resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_kms_key" "eks" {
  description             = "${var.application} EKS Cluster Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${local.name_prefix}"
  target_key_id = aws_kms_key.eks.key_id
}

resource "helm_release" "metrics_server" {
  # Name of the release in the cluster
  name       = "metrics-server"

  # Name of the chart to install
  repository = "https://kubernetes-sigs.github.io/metrics-server/"

  # Version of the chart to use
  chart      = "metrics-server"

  # Wait for the release to be deployed
  wait = true
}
