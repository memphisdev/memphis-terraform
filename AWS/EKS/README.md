## Memphis Application on AWS EKS

### Installation

#### Prerequisites
1. Make sure your machine is connected with AWS Account using a AWS IAM User which has access to create resources.
2. Terraform is installed
3. Kubectl is installed (needed if you want to connect cluster)

#### Steps
1. Initialise Terraform
```bash
terraform init
```
2. Plan Terraform to view resources which will be created during this deployment
```bash
terraform plan
```
3. Apply Terraform to create resources. Type yes when needed
```bash
terraform apply
```

4. Once deployment is complete. You can find Application Load Balancer URL via below kubectl
```bash
aws eks update-kubeconfig --name <clustername here>
kubectl get ingress -n memphis
```
**You can view status of load balancer from AWS Account EC2->Load Balancers once its stats is active. You can hit the URL to view Memphis UI**
