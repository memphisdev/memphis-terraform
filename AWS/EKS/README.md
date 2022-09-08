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
1. Make sure your machine is connected with [AWS Account](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=default&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start) using an AWS IAM User which has access to create resources(VPC,EC2,EKS). For fast forward configuration create and use the following policy:
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
2. Create Access Key:

```
 1. Sign in to the AWS Management Console and open the IAM console at https://console.aws.amazon.com/iam/.

 2. In the navigation pane, choose Users.

 3. Choose the name of the user whose access keys you want to create, and then choose the Security credentials tab.

 4. In the Access keys section, choose Create access key.

 5. To view the new access key pair, choose Show. You will not have access to the secret access key again after this dialog box closes. Your credentials will look something like this:

    - Access key ID: AKIAIOSFODNN7EXAMPLE
    - Secret access key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

3. AWS CLI, [installed](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-methods) with Access Key.

 ```bash
 $ aws configure
   AWS Access Key ID [****************EF66]: 
   AWS Secret Access Key [****************Fzna]: 
   Default region name [eu-central-1]:
   Default output format [json]:
```
4. Terraform is [installed](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
5. Kubectl is [installed](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
6. helm is [installed](https://helm.sh/docs/intro/install/)
 
#### Steps
0. Change default variables if necessary in *variables.tf* file.(region,cidr and etc')

1. Deploy EKS Cluster including:
  - VPC with 2 public + 2 private networks
  - 3 node fully functional EKS cluster based on **t3.large** instances with EBS,ELB resources.

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

4. Destroy Memphis App + EKS Cluster
```bash
make destroy
```

5. Destroy Memphis App.
```bash
make destroyapp
```

**Wait for ALB to be deleted from AWS Console**

5. Destroy Memphis EKS Cluster.
```bash
make destroyinfra
```
