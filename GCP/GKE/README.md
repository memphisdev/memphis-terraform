<div align="center">
  
  <img src="https://user-images.githubusercontent.com/70286779/189522030-e9d19313-dea0-4223-8f91-3842610abd27.jpeg">
  
</div>

# Deploy Memphis cluster on GCP

[Google Cloud Platform](https://cloud.google.com/) is one of the world's three most popular cloud providers. It offers a high-performance infrastructure for cloud computing, data analytics & machine learning. Secure, reliable, and high-performance cloud services.

At the moment, memphis utilizing [Terraform](https://www.terraform.io/) to automate the entire deployment process from VPC creation, to K8S, to memphis deployment.

Terraform codifies cloud APIs into declarative configuration files.

### Prerequisites

1. A [GCP Account](https://console.cloud.google.com/)
2. Your local station is connected with your [GCP Account](https://console.cloud.google.com/)
3. A [GCP Project](https://console.cloud.google.com/projectcreate) + GCP [Service Account Key](https://console.cloud.google.com/apis/credentials/serviceaccountkey)
4. gcloud SDK + CLI [installed](https://cloud.google.com/sdk/docs/quickstarts), configuration depends on station OS.
5. Terraform is [installed](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
6. Kubectl is [installed](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
7. helm is [installed](https://helm.sh/docs/intro/install/)
8. You should enable container googleapis:

```
gcloud services enable container.googleapis.com
```

### Terraform Installation Flow

![gcp memphis terraform](https://user-images.githubusercontent.com/70286779/189522125-ae1bd8ed-7273-400f-ab56-d84bba39407f.png)

### Step 0: Clone Memphis-Terraform repo

```
git clone git@github.com:memphisdev/memphis-terraform.git && \
cd memphis-terraform/GCP/GKE
```

### Step 1: Define GCP project-id

Change `projectID` variable in _`terraform.tfvars`_ file.

### Step 2: Deploy GKE Cluster using Terraform

```bash
make infra
```

Instead of running three terraform commands

### Step 3: Deploy Memphis

```bash
make app
```

Once deployment is complete, the Application Load Balancer URL **** will be revealed.

### Step 3: Login to Memphis

Display memphis load balancer public IP by running the following -

```
kubectl get svc -n memphis
```

The UI will be available through **https://\<Public IP>:9000**

### Appendix A: Clean (Remove) Memphis Terraform deployment

Destroy Memphis App -&#x20;

```bash
make destroyapp
```

**It might take a few minutes for the ALB to be deleted.**

Destroy Memphis GKE Cluster -&#x20;

```bash
make destroyinfra
```
