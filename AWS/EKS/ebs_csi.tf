module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${local.name_prefix}-ebs-csi-${random_string.suffix.result}"
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
      "app.kubernetes.io/name"       = "aws-ebs-csi-driver"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/managed-by" = "Helm"     
    }
    annotations = {
      "eks.amazonaws.com/role-arn"     = module.ebs_csi_irsa_role.iam_role_arn
      "meta.helm.sh/release-name"      = "aws-ebs-csi-driver"
      "meta.helm.sh/release-namespace" = "kube-system"
    }
  }
  depends_on = [module.ebs_csi_irsa_role]
}

resource "kubernetes_annotations" "gp2_default" {
  annotations = {
    "storageclass.kubernetes.io/is-default-class" : "false"
  }
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  metadata {
    name = "gp2"
  }
  force = true
  depends_on = [module.ebs_csi_irsa_role]
}

resource "kubernetes_storage_class" "ebs_csi_gp3_storage_class" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" : "false"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
  parameters = {
   "csi.storage.k8s.io/fstype" = "xfs"
    type      = "gp3"
  }
  depends_on = [kubernetes_annotations.gp2_default]
}

resource "helm_release" "eks-ebscsi" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = "2.10.1"
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



