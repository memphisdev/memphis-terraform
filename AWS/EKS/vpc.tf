module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vpc_cidr
  networks = [
    {
      name     = "public1"
      new_bits = 4
    },
    {
      name     = "public2"
      new_bits = 4
    },
    {
      name     = "public3"
      new_bits = 4
    },
    {
      name     = "private1"
      new_bits = 8
    },
    {
      name     = "private2"
      new_bits = 8
    },
    {
      name     = "private3"
      new_bits = 8
    },
  ]
}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "3.19.0"
  name                 = local.name_prefix
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.azs.names
  private_subnets      = [module.subnet_addrs.network_cidr_blocks["private1"], module.subnet_addrs.network_cidr_blocks["private2"], module.subnet_addrs.network_cidr_blocks["private3"]]
  public_subnets       = [module.subnet_addrs.network_cidr_blocks["public1"], module.subnet_addrs.network_cidr_blocks["public2"], module.subnet_addrs.network_cidr_blocks["public3"]]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  vpc_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    "SubnetType"                                  = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    "SubnetType"                                  = "private"
  }
}
