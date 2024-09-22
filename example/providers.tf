terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.67.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.14.0"
    }
  }
}

provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = var.profile
  region                   = var.region
  
  default_tags {
    tags = {
      "rbkr:name"        = "${var.environment}-${var.project_name}"
      "rbkr:environment" = var.environment
      "rbkr:description" = "${var.project_name} in ${var.environment} account"
    }
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.stack.cluster_name
}

provider "kubernetes" {
  host                   = module.stack.cluster_endpoint
  cluster_ca_certificate = base64decode(module.stack.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  repository_config_path = "${path.module}/.helm/repositories.yaml"
  repository_cache       = "${path.module}/.helm"
  burst_limit            = 300

  kubernetes {
    host                   = module.stack.cluster_endpoint
    cluster_ca_certificate = base64decode(module.stack.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
