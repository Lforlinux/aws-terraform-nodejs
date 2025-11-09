output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider."
  value       = module.eks.cluster_oidc_issuer_url
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "argocd_server_url" {
  description = "ArgoCD Server URL (LoadBalancer endpoint)"
  value       = try("https://${data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname}", try("https://${data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].ip}", "Pending... Check with: kubectl get svc -n argocd argocd-server"))
  depends_on  = [helm_release.argocd, data.kubernetes_service.argocd_server]
}

output "argocd_username" {
  description = "ArgoCD admin username"
  value       = "admin"
}

output "argocd_password" {
  description = "ArgoCD admin password (from Kubernetes secret)"
  value       = try(base64decode(data.kubernetes_secret.argocd_admin_password.data["password"]), "Secret not found. Run: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d")
  sensitive   = true
  depends_on  = [helm_release.argocd, data.kubernetes_secret.argocd_admin_password]
}
