data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

locals {
  name           = "${var.environment}-${var.project_name}"
  azs            = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_cidr       = var.vpc_cidr
  region         = var.region
  aws_account_id = data.aws_caller_identity.current.account_id

  helm = {
    promtail_release   = var.promtail_release_name
    loki_release       = var.loki_release_name
    prometheus_release = var.prometheus_release_name
  }

  versions = {
    eks        = var.eks_version
    prometheus = var.prometheus_version
    promtail   = var.promtail_version
    loki       = var.loki_version
  }

  namespaces = {
    prometheus = var.prometheus_namespace
    promtail   = var.promtail_namespace
    loki       = var.loki_namespace
  }

  nodegroup_labels = {
    nodegroup1 = "${local.name}-main"
  }

  loki = {
    gateway          = "${local.helm.loki_release}-gateway"
    chunks_s3_bucket = "${var.environment}-${local.helm.loki_release}-chunks-${local.aws_account_id}"
    ruler_s3_bucket  = "${var.environment}-${local.helm.loki_release}-ruler-${local.aws_account_id}"
    iam_name_prefix  = "${var.environment}-${local.helm.loki_release}"
    log_retention    = var.loki_log_retention
  }
}
