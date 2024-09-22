// Prometheus
resource "helm_release" "prometheus" {
  name       = local.helm.prometheus_release
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = local.versions.prometheus
  namespace  = local.namespaces.prometheus
  create_namespace = true
    
  values = [templatefile("${path.module}/templates/prometheus/values.yaml.tpl", {
    loki_ds_service = local.loki.gateway
    loki_namespace  = local.namespaces.loki
  })]

  depends_on = [ module.eks ]

}

// Grafana Promtail
resource "helm_release" "grafana-promtail" {
  name             = local.helm.promtail_release
  repository       = "https://grafana.github.io/helm-charts"
  namespace        = local.namespaces.promtail
  create_namespace = true
  chart            = "promtail"
  version          = local.versions.promtail

  values = [
    templatefile(
      "${path.module}/templates/promtail/values.yaml.tpl",
      {
        prometheus_release   = local.helm.prometheus_release
        loki_gateway         = local.loki.gateway
        loki_namespace       = local.namespaces.loki
      }
    )
  ]
  depends_on = [ 
    helm_release.grafana-loki-deployment, 
    helm_release.prometheus,
    module.eks
  ]
}

// Grafana Loki
resource "helm_release" "grafana-loki-deployment" {
  name             = local.helm.loki_release
  repository       = "https://grafana.github.io/helm-charts"
  namespace        = local.namespaces.loki
  create_namespace = true
  chart            = "loki"
  version          = local.versions.loki

  values = [
    templatefile(
      "${path.module}/templates/loki/simple-scalable/values.yaml.tpl",
      {
        log_retention_in_hr  = local.loki.log_retention
        loki_release         = local.helm.loki_release
        loki_namespace       = local.namespaces.loki
        chunks_s3_bucket     = local.loki.chunks_s3_bucket
        ruler_s3_bucket      = local.loki.ruler_s3_bucket
        loki_iam_role_arn    = module.loki_oidc_role.iam_role_arn
        aws_region           = var.region
        elasticache_enabled  = var.elasticache_enabled
        elasticache_endpoint = var.elasticache_enabled ? aws_elasticache_cluster.memcached[0].configuration_endpoint : ""

      }
    )
  ]
  depends_on = [ 
    module.eks
  ]
}
