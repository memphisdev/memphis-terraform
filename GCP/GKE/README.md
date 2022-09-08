<div align="center">
  
  ![Memphis light logo](https://github.com/memphisdev/memphis-broker/blob/master/logo-white.png?raw=true#gh-dark-mode-only)
  
</div>

<div align="center">
  
  ![Memphis light logo](https://github.com/memphisdev/memphis-broker/blob/master/logo-black.png?raw=true#gh-light-mode-only)
  
</div>

<div align="center">
<h1>A powerful messaging platform for modern developers</h1>
</div>

## Memphis Deployment on GCP GKE

### Installation

#### Prerequisites
1. Make sure your machine is connected with [GCP Account](https://console.cloud.google.com/)
2. [GCP Project](https://console.cloud.google.com/projectcreate) + GCP [Service Account Key](https://console.cloud.google.com/apis/credentials/serviceaccountkey)
3. gcloud SDK + CLI [installed](https://cloud.google.com/sdk/docs/quickstarts), configuration depends on machine OS.
4. Terraform is [installed](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
5. Kubectl is [installed](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
6. helm is [installed](https://helm.sh/docs/intro/install/)

#### Steps
0. Change default variables if necessary in *terraform.tfvars* file.(region,project and etc')

1. Deploy GKE Cluster including:
  - VPC
  - 3 node fully functional GKE cluster based on **n2-standard-4** instances.
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
4. Destroy Memphis App + GKE Cluster
```bash
make destroy
```

5. Destroy Memphis App.
```bash
make destroyapp
```

5. Destroy Memphis GKE Cluster.
```bash
make destroyinfra
```

