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

resource "helm_release" "promtail" {
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  namespace  = "monitoring"
  timeout    = 300
  create_namespace = true

  # Promtail configuration - point to Loki
  set {
    name  = "config.clients[0].url"
    value = "http://loki:3100/loki/api/v1/push"
  }

  # Enable DaemonSet
  set {
    name  = "daemonset.enabled"
    value = "true"
  }

  # ServiceAccount
  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  # Resource limits
  set {
    name  = "resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }

  depends_on = [module.eks]
}