resource "local_file" "kubeconfig" {
  content = templatefile("${path.module}/templates/kubeconfig.tpl", {
    cluster_name     = "k8s-cluster"
    server           = "https://${aws_instance.k8s_master.public_ip}:6443"
    cluster_ca       = filebase64("${path.module}/ca.crt")
    client_cert      = filebase64("${path.module}/client.crt")
    client_key       = filebase64("${path.module}/client.key")
  })
  filename = "${path.module}/kubeconfig"
}

# Шаблон для генерации kubeconfig
resource "local_file" "kubeconfig_template" {
  content = <<-EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${cluster_ca}
    server: ${server}
  name: ${cluster_name}
contexts:
- context:
    cluster: ${cluster_name}
    user: admin
  name: ${cluster_name}
current-context: ${cluster_name}
kind: Config
preferences: {}
users:
- name: admin
  user:
    client-certificate-data: ${client_cert}
    client-key-data: ${client_key}
EOT
  filename = "${path.module}/templates/kubeconfig.tpl"
}
