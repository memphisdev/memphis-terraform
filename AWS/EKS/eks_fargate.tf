module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.28.0"
  enable_irsa     = true
  tags = local.tags
  cluster_name    = local.cluster_name
  cluster_version = "1.22"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }
  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  eks_managed_node_groups = {
    managed_nodegrp = {
      desired_size = 1
      instance_types = ["t3.large"]
      labels = {
        NodeGroupType    = "managed_node_groups"
        Environment      = var.environment
      }
    }
  }
    
  fargate_profiles = {
    default = {
      name = var.application
      selectors = [
        {
          namespace = var.application
        }
      ]

      tags = {
        Owner = var.application
      }

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
  }

}