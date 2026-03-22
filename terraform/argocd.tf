
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

resource "kubernetes_manifest" "quotes_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind = "Application"

    metadata = {
      name = "quotes-app"
      namespace = "argocd"
    }

    spec = {
      project = "default"

      source = {
        repoURL = var.github_repo_url 
        targetRevision = "dev" 
        path = var.github_repo_path 

        directory = {  
          recurse = true 
        }
      }

      destination = {
        server = "https://kubernetes.default.svc"
        namespace = "quotes-app"
      }

      syncPolicy = {
        automated = {
          prune = true   
          selfHeal = true   
        }
        syncOptions = [
          "CreateNamespace=true" 
        ]
      }
    }
  }
  depends_on = [helm_release.argocd]
}
