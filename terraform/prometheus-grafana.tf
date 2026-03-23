resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }

  depends_on = [aws_eks_node_group.main]
}

resource "helm_release" "prometheus_stack" {
  name       = "prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.prometheus_stack_chart_version

 
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = var.prometheus_retention
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = "gp3"
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = var.prometheus_storage_size
  }

  set {
    name  = "prometheus.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "grafana.persistence.enabled"
    value = "true"
  }

  set {
    name  = "grafana.persistence.storageClassName"
    value = "gp3"
  }

  set {
    name  = "grafana.persistence.size"
    value = var.grafana_storage_size
  }

  set {
    name  = "alertmanager.enabled"
    value = "false"
  }

  set {
    name  = "prometheus.prometheusSpec.scrapeInterval"
    value = "30s"
  }

  wait    = true
  timeout = 600

  depends_on = [
    kubernetes_namespace.monitoring,
    kubernetes_storage_class.gp3,
    aws_eks_addon.ebs_csi,
  ]
}
