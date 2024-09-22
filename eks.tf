module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> v19.21.0"

  cluster_name                   = local.name
  cluster_version                = local.versions.eks
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodegroup1 = {
      desired_size = var.eks_desired_size
      max_size     = var.eks_max_size
      min_size     = var.eks_min_size

      instance_types = [var.eks_instance_type]
      capacity_type  = var.eks_capacity_type

      iam_role_additional_policies = var.eks_workers_iam_policies

      update_config = {
        max_unavailable_percentage = 50
      }

      labels = {
        role = local.nodegroup_labels.nodegroup1
      }

    }
  }

  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    aws-ebs-csi-driver = {
      most_recent = true
    }
    vpc-cni = {
      before_compute = true
      most_recent    = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  tags = merge(var.default_tags, {
    "Name" = local.name
  })

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = merge(var.default_tags, {
    "Name" = "${local.name}-vpc"
  })

}

