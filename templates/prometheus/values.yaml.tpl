grafana:
  enabled: true
  replicas: 1
  ingress:
    enabled: false

  service:
    type: LoadBalancer

  persistence:
    type: pvc
    enabled: true
    storageClassName: gp2
    accessModes:
      - ReadWriteOnce
    size: 5Gi
  initChownData:
    enabled: true

  grafana.ini:
    database:
      type: "sqlite3"

  extraVolumeMounts:
    - name: dashboards-home
      mountPath: /var/lib/grafana/dashboards/default

  extraVolumes:
    - name: dashboards-home
      emptyDir: {}

  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'default'
        orgId: 1
        folder: 'Imported'
        type: file
        disableDeletion: false
        editable: true
        options:
          path: /var/lib/grafana/dashboards/default

  dashboards:
    default:
      prometheus-overview-dash:
        gnetId: 3662
        revision: 2
        datasource: Prometheus

  sidecar:
    alerts:
      enabled: true
      label: grafana_alert
      labelValue: "1"
      searchNamespace: null
    dashboards:
      enabled: true
      label: grafana_dashboard
      labelValue: "1"
      searchNamespace: null
      folder: /var/lib/grafana/dashboards
      folderAnnotation: grafana_folder
      provider:
        foldersFromFilesStructure: true

  additionalDataSources:
    - name: Loki
      type: loki
      uid: loki
      access: proxy
      url: http://${loki_ds_service}.${loki_namespace}/
      jsonData:
        timeout: 60
        maxLines: 1000
        httpHeaderName1: "X-Scope-OrgID"
      secureJsonData:
        httpHeaderValue1: ruanbekker

alertmanager:
  enabled: false
    
prometheus:
  ingress:
    enabled: false
    enableRemoteWriteReceiver: true
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: "gp2"
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: "10Gi"

