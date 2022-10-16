module "external_dns_irsa_role" {
  count = var.enable_dns ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = "${local.name_prefix}-external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [data.aws_route53_zone.dns[count.index].arn]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns-controller-sa"]
    }
  }

  tags = local.tags
}

resource "kubernetes_service_account" "externaldns-service-account" {
  count = var.enable_dns ? 1 : 0
  depends_on = [
    module.eks
  ]
  metadata {
    name      = "external-dns-controller-sa"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-external-dns"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.external_dns_irsa_role[count.index].iam_role_arn
    }
  }
}

resource "helm_release" "eks-externaldns" {
  count      = var.enable_dns ? 1 : 0
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.externaldns-service-account
  ]

  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = "external-dns-controller-sa"
  }
  set {
    name  = "policy"
    value = "sync"
  }
}
