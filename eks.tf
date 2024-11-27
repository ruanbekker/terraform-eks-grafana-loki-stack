module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> v19.21.0"

  cluster_name                   = local.name
  cluster_version                = local.versions.eks
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    instance_types   = [var.eks_desired_size]
    cluster_version  = local.versions.eks
    root_volume_type = "gp3"
    root_volume_size = 30
    # root_encrypted   = true
    # root_kms_key_id  = data.aws_kms_key.launch_template.arn
    iam_role_additional_policies = {
      ssm_default_policy = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
    }
    enable_bootstrap_user_data = true
    pre_bootstrap_user_data    = <<-EOF
      MIME-Version: 1.0
      Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

      --==MYBOUNDARY==
      Content-Type: text/x-shellscript; charset="us-ascii"

      #!/bin/bash
      yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      systemctl enable amazon-ssm-agent.service
      systemctl start amazon-ssm-agent.service

      --==MYBOUNDARY==--
      EOF
  }

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

    #observability-a = {
    #  name           = "observability-a"
    #  subnet_ids     = [data.aws_subnet.eu-west-1a-subnet.id]
    #  min_size       = 1
    #  desired_size   = 1
    #  capacity_type  = "ON_DEMAND"
    #  instance_types = ["m6a.xlarge"]
    #  labels = {
    #    observability = "true"
    #  }
    #  taints = [
    #    {
    #      key    = "observability"
    #      value  = "true"
    #      effect = "NO_EXECUTE"
    #    }
    #  ]
    #},

  }

  cluster_addons = {
    coredns = {
      addon_version = "v1.11.3-eksbuild.2"
    }
    kube-proxy = {
      addon_version = "v1.29.10-eksbuild.3"
    }
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

