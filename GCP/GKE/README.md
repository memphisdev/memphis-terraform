<div align="center">
  
  ![Memphis light logo](https://github.com/memphisdev/memphis-broker/blob/master/logo-white.png?raw=true#gh-dark-mode-only)
  
</div>

<div align="center">
  
  ![Memphis light logo](https://github.com/memphisdev/memphis-broker/blob/master/logo-black.png?raw=true#gh-light-mode-only)
  
</div>

<div align="center">
<h1>A powerful messaging platform for modern developers</h1>
</div>

## Memphis Deployment on AWS EKS

### Installation

#### Prerequisites
1. Make sure your machine is connected with [AWS Account](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=default&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start) using a AWS IAM User which has access to create resources(EKS,VPC,EC2)
3. AWS CLI, [installed](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
4. Terraform is [installed](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
5. Kubectl is [installed](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
6. heml is [installed](https://helm.sh/docs/intro/install/)

#### Steps
1. Deploy GKE Cluster using Terraform
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

