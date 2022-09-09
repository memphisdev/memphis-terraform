provider "azurerm" {
  features {}
}

module "aks" {
  source = "git@github.com:flavius-dinu/terraform-az-aks.git?ref=v1.0.3"
  kube_params = {
    memphis_cluster = {
      name                = "memphis_cluster"
      rg_name             = "rg1"
      rg_location         = "eastus"
      dns_prefix          = "kube"
      identity            = [{}]
      enable_auto_scaling = false
      max_count           = 1
      min_count           = 1
      node_count          = 1
      np_name             = "memphisnp"
      export_kube_config  = true
      kubeconfig_path     = "./config"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = module.aks.kube_config_path["memphis_cluster"]
  }
}

module "helm" {
  source = "git@github.com:flavius-dinu/terraform-helm-release.git?ref=v1.0.1"
  helm = {
    memphis = {
      name             = "memphis"
      repository       = "https://k8s.memphis.dev/charts/"
      chart            = "memphis"
      create_namespace = true
      namespace        = "memphis"
    }
  }
}
