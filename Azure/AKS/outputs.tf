output "kube_params" {
  value = module.aks.kube_params
}

output "helm_metadata" {
  value = module.helm.helm_metadata
}
