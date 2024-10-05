resource "aws_s3_bucket" "grafana-loki-chunks-bucket" {
  bucket = local.loki.chunks_s3_bucket
  
  tags = merge(var.default_tags, {
    "Name" = local.loki.chunks_s3_bucket
  })
}

resource "aws_s3_bucket" "grafana-loki-ruler-bucket" {
  bucket = local.loki.ruler_s3_bucket
  
  tags = merge(var.default_tags, {
    "Name" = local.loki.ruler_s3_bucket
  })
}

module "loki_oidc_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                      = "${local.loki.iam_name_prefix}-role"
  attach_external_secrets_policy = false

  oidc_providers = {
    oidc_provider = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${local.namespaces.loki}:${local.helm.loki_release}"]
    }
  }
}

resource "aws_iam_policy" "grafana-loki-s3-policy" {
  name        = "${local.loki.iam_name_prefix}-s3-policy"
  path        = "/"
  description = "Loki IAM Policy to have access to S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "LokiPermissions",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:ListObjects",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:GetObjectTagging",
          "s3:PutObjectTagging"
        ],
        "Resource" : [
          "arn:aws:s3:::${local.loki.chunks_s3_bucket}",
          "arn:aws:s3:::${local.loki.chunks_s3_bucket}/*",
          "arn:aws:s3:::${local.loki.ruler_s3_bucket}",
          "arn:aws:s3:::${local.loki.ruler_s3_bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "loki-attach" {
  role       = module.loki_oidc_role.iam_role_name
  policy_arn = aws_iam_policy.grafana-loki-s3-policy.arn
}