terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      version = ">= 3.15.0"
      source  = "hashicorp/azurerm"
    }
    helm = {
      version = ">=2.6.0"
      source  = "hashicorp/helm"
    }
    local = {
      version = ">=2.2.3"
      source  = "hashicorp/local"
    }
  }
}
