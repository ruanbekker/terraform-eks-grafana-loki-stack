output "account_id" {
  value = local.aws_account_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "memcached_endpoint" {
  value = var.elasticache_enabled ? aws_elasticache_cluster.memcached[0].configuration_endpoint : ""
}

output "access_cluster_cmd" {
  value  = join("\n", [
    "export KUBECONFIG=/tmp/kube.config",
    "aws eks update-kubeconfig --name ${module.eks.cluster_name} --alias ${module.eks.cluster_name} --region ${var.region}"
  ])
}

