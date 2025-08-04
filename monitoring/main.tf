provider "helm" {
  kubernetes {
    host                   = "https://${aws_instance.k8s_master.public_ip}:6443"
    cluster_ca_certificate = base64decode(file("${path.module}/../kubernetes/ca.crt"))
    client_certificate     = base64decode(file("${path.module}/../kubernetes/client.crt"))
    client_key             = base64decode(file("${path.module}/../kubernetes/client.key"))
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  version    = "45.7.1"

  values = [
    file("${path.module}/helm-values/prometheus-values.yaml")
  ]
}
