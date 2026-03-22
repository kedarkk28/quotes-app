
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  depends_on = [aws_eks_node_group.main]
}

resource "kubernetes_namespace" "quotes_app" {
  metadata {
    name = "quotes-app"
  }

  depends_on = [aws_eks_node_group.main]
}

resource "helm_release" "argocd" {
  name = "argocd"
  namespace = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  version = var.argocd_chart_version

  set {
    name = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name = "server.extraArgs[0]"
    value = "--insecure"
  }

  wait = true
  timeout = 600
}

