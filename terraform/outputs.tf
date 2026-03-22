
output "cluster_name" {
  description = "Name of the EKS cluster"
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "URL of the Kubernetes API server"
  value = aws_eks_cluster.main.endpoint
}

output "configure_kubectl" {
  description = "Run this command to connect kubectl to your new cluster"
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}

output "get_nodes" {
  description = "Run this after configure_kubectl to verify all 3 workers are Ready"
  value = "kubectl get nodes"
}

output "get_argocd_url" {
  description = "Run this to get the ArgoCD web UI URL (may take 1-2 min after apply)"
  value = "kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}

output "get_argocd_password" {
  description = "Run this to get the initial ArgoCD admin password"
  value = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo"
}

output "get_app_url" {
  description = "Run this to get the quotes app frontend URL after ArgoCD syncs"
  value = "kubectl get svc frontend-service -n quotes-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}
