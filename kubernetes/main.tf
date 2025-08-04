provider "kubernetes" {
  host                   = "https://${aws_instance.k8s_master.public_ip}:6443"
  cluster_ca_certificate = base64decode(file("${path.module}/ca.crt"))
  client_certificate     = base64decode(file("${path.module}/client.crt"))
  client_key             = base64decode(file("${path.module}/client.key"))
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

