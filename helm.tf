resource "helm_release" "nodejs" {
  name       = "nodejsapplication"
  chart      = "./charts/helm-nodejs-app"
}

resource "helm_release" "mertics-server" {
  name       = "hpamerticsserver"
  chart      = "https://charts.bitnami.com/bitnami/metrics-server-5.10.13.tgz"
  set {
    name  = "apiService.create"
    value = "true"
  }
}