## Memphis Application on AWS EKS

### Installation

#### Prerequisites
1. Make sure your machine is connected with [AWS Account](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=default&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start) using a AWS IAM User which has access to create resources(EKS,VPC,EC2)
3. AWS CLI, [installed](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
4. Terraform is [installed](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
5. Kubectl is [installed](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
6. heml is [installed](https://helm.sh/docs/intro/install/)

#### Steps
1. Deploy EKS Cluster using Terraform
```bash
make infra
```

2. Deploy Memphis App. Once deployment is complete. You can find Application Load Balancer URL.
```bash
make app
```

**You can view status of load balancer from AWS Account EC2->Load Balancers once its stats is active. You can hit the URL to view Memphis UI**

3. Login Details for root user
```bash
kubectl get secret memphis-creds -n memphis -o jsonpath="{.data.ROOT_PASSWORD}" | base64 --decode
```
4. Destroy Memphis App.
```bash
make destroyapp
```
**Wait for ALB to be deleted from AWS Console**

5. Destroy Memphis EKS Cluster.
```bash
make destroyinfra
```
