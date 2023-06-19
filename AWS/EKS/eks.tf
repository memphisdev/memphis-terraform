module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "18.28.0"
  enable_irsa                     = true
  tags                            = local.tags
  cluster_name                    = local.cluster_name
  cluster_version                 = "1.24"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_addons = {
    coredns = {
      resolve_conflicts_on_create = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts_on_create = "OVERWRITE"
    }
  }
  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  eks_managed_node_groups = {
    managed_nodegrp = {
      desired_size   = 3
      instance_types = ["t3.large"]
      labels = {
        NodeGroupType = "managed_node_groups"
        Environment   = var.environment
      }
    }
  }
  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    ingress_4443_from_controlplane = {
      description                   = "Cluster API to Nodegroup for metrics server"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 4443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
}
