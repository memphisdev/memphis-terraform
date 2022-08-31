resource "kubernetes_namespace" "k8sns" {
  depends_on = [
    helm_release.eks-alb, helm_release.eks-ebscsi,module.eks
  ]
  metadata {
    name = var.application
  }
}

resource "helm_release" "release" {
  name       = var.application
  repository = "https://k8s.memphis.dev/charts/"
  chart      = "memphis"
  namespace = kubernetes_namespace.k8sns.id
  wait = true
  timeout = 600
}

resource "kubernetes_ingress_v1" "ingress" {
  depends_on = [
    helm_release.release
  ]
  metadata {
    name = var.application
    annotations = {
      "kubernetes.io/ingress.class": "alb"
      "alb.ingress.kubernetes.io/target-type": "ip"
      "alb.ingress.kubernetes.io/scheme": "internet-facing"
    }
    namespace = var.application
  }

  spec {
    default_backend {
      service {
        name = "memphis-ui"
        port {
          number = 80
        }
      }
    }
}
}