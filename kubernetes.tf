provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  }
}

# Data source for ArgoCD server service (to get LoadBalancer URL)
data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd]
}

# Data source for ArgoCD admin password
data "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd]
}