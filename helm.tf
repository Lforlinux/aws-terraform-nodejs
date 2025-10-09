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
  name       = "nodejsapplication"
  chart      = "./charts/helm-nodejs-app"
  namespace  = "default"
  timeout    = 300
  
  depends_on = [helm_release.metrics-server]
}