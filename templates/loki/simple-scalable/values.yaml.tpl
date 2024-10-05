# -- Helm Chart
# - https://github.com/grafana/loki/tree/main/production/helm/loki

nameOverride: "${loki_release}"

deploymentMode: SimpleScalable
loki:
  auth_enabled: true
  server:
    grpc_listen_port: 9095
    http_listen_port: 3100
    http_server_read_timeout: 600s
    http_server_write_timeout: 600s
  schemaConfig:
    configs:
      - from: 2024-04-01
        store: tsdb
        object_store: s3
        schema: v13
        index:
          prefix: loki_index_
          period: 24h
  
  common:
    compactor_address: 'http://${loki_release}-backend.${loki_namespace}.svc.cluster.local:3100'
    path_prefix: /var/loki
    replication_factor: 3
  ingester:
    chunk_encoding: snappy
    chunk_target_size: 5242880
    max_chunk_age: 4h
    chunk_idle_period: 45m
  tracing:
    enabled: true
  querier:
    max_concurrent: 4
    query_ingesters_within: 5h
  frontend:
    scheduler_address: ""
    tail_proxy_url: ""
    max_outstanding_per_tenant: 2048
    compress_responses: true
  frontend_worker:
    scheduler_address: ""
  index_gateway:
    mode: simple
  limits_config:
    max_cache_freshness_per_query: 10m
    query_timeout: 300s
    reject_old_samples: true
    reject_old_samples_max_age: 168h
    volume_enabled: true
    max_query_length: 744h
    retention_period: ${log_retention_in_hr}
    ingestion_rate_mb: 8
    ingestion_burst_size_mb: 12
  compactor:
    working_directory: /tmp/retention
    compaction_interval: 10m
    retention_enabled: true
    retention_delete_delay: 2h
    retention_delete_worker_count: 150
    delete_request_store: s3
  pattern_ingester:
    enabled: false
  query_range:
    align_queries_with_step: true
    cache_results: true  

  storage:
    bucketNames:
      chunks: ${chunks_s3_bucket}
      ruler: ${ruler_s3_bucket}
    s3:
      region: ${aws_region}
      # endpoint: s3.${aws_region}.amazonaws.com
      insecure: false

  memcached:
    chunk_cache:
      enabled: true
%{ if elasticache_enabled ~}
      host: "${elasticache_endpoint}"
%{ else ~}
      host: ""
%{ endif ~}
      service: "memcached-client"
      batch_size: 256
      parallelism: 10
    results_cache:
      enabled: true
%{ if elasticache_enabled ~}
      host: "${elasticache_endpoint}"
%{ else ~}
      host: ""
%{ endif ~}
      service: "memcached-client"
      timeout: "500ms"
      default_validity: "12h"      

serviceAccount:
  create: true
  name: ${loki_release}
  annotations:
     eks.amazonaws.com/role-arn: ${loki_iam_role_arn}

backend:
  replicas: 3
read:
  replicas: 3
write:
  replicas: 3

minio:
  enabled: false

memcached:
  image:
    repository: memcached
    tag: 1.6.23-alpine

chunksCache:
  enabled: %{ if elasticache_enabled }false%{ else }true%{ endif }
  allocatedMemory: 1024
resultsCache:
  enabled: %{ if elasticache_enabled }false%{ else }true%{ endif }
  allocatedMemory: 1024

singleBinary:
  replicas: 0

