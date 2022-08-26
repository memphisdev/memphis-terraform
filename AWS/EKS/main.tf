resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_kms_key" "eks" {
  description             = "${var.application} EKS Cluster Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags = local.tags
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${local.name_prefix}"
  target_key_id = aws_kms_key.eks.key_id
}
