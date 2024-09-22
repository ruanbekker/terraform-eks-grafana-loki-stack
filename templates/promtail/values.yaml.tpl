daemonset:
  enabled: true

serviceMonitor:
  enabled: true
  labels:
    release: "${prometheus_release}"

config:
  enabled: true
  logLevel: info
  logFormat: logfmt
  serverPort: 3101
  clients:
    - url: http://${loki_gateway}.${loki_namespace}:80/loki/api/v1/push
      headers:
        X-Scope-OrgID: ruanbekker

  snippets:
    pipelineStages:
      - cri: {}
    common:
      - action: replace
        source_labels:
          - __meta_kubernetes_pod_node_name
        target_label: node_name
      - action: replace
        source_labels:
          - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        replacement: $1
        separator: /
        source_labels:
          - namespace
          - app
        target_label: job
      - action: replace
        source_labels:
          - __meta_kubernetes_pod_name
        target_label: pod
      - action: replace
        source_labels:
          - __meta_kubernetes_pod_container_name
        target_label: container
      - action: replace
        replacement: /var/log/pods/*$1/*.log
        separator: /
        source_labels:
          - __meta_kubernetes_pod_uid
          - __meta_kubernetes_pod_container_name
        target_label: __path__
      - action: replace
        replacement: /var/log/pods/*$1/*.log
        regex: true/(.*)
        separator: /
        source_labels:
          - __meta_kubernetes_pod_annotationpresent_kubernetes_io_config_hash
          - __meta_kubernetes_pod_annotation_kubernetes_io_config_hash
          - __meta_kubernetes_pod_container_name
        target_label: __path__

