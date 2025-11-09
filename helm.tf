resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }

  depends_on = [module.eks]
}

resource "helm_release" "nodejs" {
  name      = "nodejsapplication"
  chart     = "./charts/helm-nodejs-app"
  namespace = "default"
  timeout   = 300

  depends_on = [helm_release.metrics-server]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  timeout    = 600
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.ingress.enabled"
    value = "false"
  }

  # Enable server metrics
  set {
    name  = "server.metrics.enabled"
    value = "true"
  }

  # Resource limits
  set {
    name  = "server.resources.limits.cpu"
    value = "500m"
  }

  set {
    name  = "server.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "server.resources.requests.cpu"
    value = "250m"
  }

  set {
    name  = "server.resources.requests.memory"
    value = "256Mi"
  }

  depends_on = [module.eks]
}