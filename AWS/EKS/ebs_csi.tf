module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${local.name_prefix}-ebs-csi"
  attach_ebs_csi_policy = true
  ebs_csi_kms_cmk_ids   = [aws_kms_key.eks.arn]
  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = local.tags
}

resource "kubernetes_service_account" "ebscsi-service-account" {
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-ebs-csi-driver"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.ebs_csi_irsa_role.iam_role_arn
    }
  }
}

resource "helm_release" "eks-ebscsi" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = "1.2.4"
  depends_on = [
    kubernetes_service_account.ebscsi-service-account
  ]

  set {
    name  = "serviceAccount.controller.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.snapshot.create"
    value = "false"
  }

  set {
    name  = "enableVolumeScheduling"
    value = "true"
  }

  set {
    name  = "enableVolumeResizing"
    value = "true"
  }

  set {
    name  = "enableVolumeSnapshot"
    value = "true"
  }

  set {
    name  = "serviceAccount.snapshot.name"
    value = "ebs-csi-controller-sa"
  }

  set {
    name  = "serviceAccount.controller.name"
    value = "ebs-csi-controller-sa"
  }
}



