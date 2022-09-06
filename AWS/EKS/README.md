## Memphis Application on AWS EKS

### Installation

#### Prerequisites
1. Make sure your machine is connected with AWS Account using a AWS IAM User which has access to create resources.
2. Terraform is installed
3. Kubectl is installed
4. heml is install

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
## Wait for ALB to be deleted....
make destroyinfra
```
**Wait for ALB to be deleted from AWS Console**
5. Destroy Memphis EKS Cluster.
```bash
make destroyinfra
```