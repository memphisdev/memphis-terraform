<div align="center">
  
  ![Memphis light logo](https://github.com/memphisdev/memphis-broker/blob/master/logo-white.png?raw=true#gh-dark-mode-only)
  
</div>

<div align="center">
  
  ![Memphis light logo](https://github.com/memphisdev/memphis-broker/blob/master/logo-black.png?raw=true#gh-light-mode-only)
  
</div>

<div align="center">
<h1>A powerful messaging platform for modern developers</h1>
</div>

## Memphis Deployment on Azure

### Installation

#### Prerequisites
- You will need an Azure account and you should be connected to it
- [AZ CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)

#### Steps

1. Deploy Azure Cluster and Helm Chart
```bash
make infra
```

2. Deploy Memphis App. Once deployment is complete. You can find Application Load Balancer IP address and copy it to browser.
```bash
make app
```

**The external IP allocation can take up to 2 minutes depending on the infrastructure**

3. Login Details for root user
```bash
kubectl get secret memphis-creds -n memphis -o jsonpath="{.data.ROOT_PASSWORD}" | base64 --decode
```
4. Destroy Memphis App + Azure Cluster
```bash
make destroy
```

5. Destroy Memphis App.
```bash
make destroyapp
```

5. Destroy Memphis Azure Cluster.
```bash
make destroyinfra
```

#### Notes
The resource group should already exist in Azure.

If you change the first two parameters for the **kube_params** (`name` and `rg_name`) you will need to make the same changes in the **memphis-install.sh** script.

```hcl
module "aks" {
  source = "git@github.com:flavius-dinu/terraform-az-aks.git?ref=v1.0.3"
  kube_params = {
    memphis_cluster = {
      name                = "memphis_cluster"
      rg_name             = "rg1"
```

Terraform Helm Provider behaves strange if there is a directory containing the same name as a chart that you are planning to deploy so make sure you are not going to have a directory named memphis.