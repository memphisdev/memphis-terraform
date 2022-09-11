<div align="center">
  
  <img src="https://user-images.githubusercontent.com/70286779/189521560-7cb9bc32-1f2e-4974-bf10-c5c8bc52cf2f.jpeg">
  
</div>

# Deploy Memphis cluster on AWS

### Introduction

[_**Amazon Web Services**_](https://aws.amazon.com/), one of the world's three most popular cloud providers, offers reliable and scalable cloud computing services. Free to join. Pay only for what you use.

At the moment, memphis utilizing [Terraform](https://www.terraform.io/) to automate the entire deployment process from VPC creation, to K8S, to memphis deployment.

Terraform codifies cloud APIs into declarative configuration files.

### Prerequisites

* [AWS account](https://aws.amazon.com/free/)
* AWS CLI [installed](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
* Make sure your local station is connected with [AWS Account](https://portal.aws.amazon.com/billing/signup?nc2=h\_ct\&src=default\&redirect\_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start) using an AWS IAM user which has access to create resources (EKS, VPC, EC2)

IAM Policy to use -

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:*",
                "kms:*",
                "logs:*",
                "ec2:*",
                "eks:*"
            ],
            "Resource": "*"
        }
    ]
}
```

How to configure AWS CLI -

```bash
$ aws configure
  AWS Access Key ID [****************EF66]: 
  AWS Secret Access Key [****************Fzna]: 
  Default region name [eu-central-1]:
  Default output format [json]:
```

* Terraform is [installed](https://www.terraform.io/downloads)
* Kubectl is [installed](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* helm is [installed](https://helm.sh/docs/intro/install/)

### Terraform Installation Flow

![aws memphis terraform](https://user-images.githubusercontent.com/70286779/189521945-6b6fdb66-fbdf-4b14-bfcb-5453d77bf9d4.png)

### Step 0: Clone Memphis-Terraform repo

```
git clone git@github.com:memphisdev/memphis-terraform.git && \
cd memphis-terraform/AWS/EKS
```

### Step 1: Deploy EKS Cluster using Terraform

```bash
make infra
```

Instead of running three terraform commands

### Step 2: Deploy Memphis

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

**It might take a few minutes for the ELB to be deleted.**

Destroy Memphis EKS Cluster -&#x20;

```bash
make destroyinfra
```
