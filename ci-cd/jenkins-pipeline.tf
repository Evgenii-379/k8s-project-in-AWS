resource "kubernetes_config_map" "jenkins_pipeline" {
  metadata {
    name = "jenkins-pipeline-config"
    namespace = "default"
  }

  data = {
    "Jenkinsfile" = <<-EOT
    pipeline {
      agent any
      environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        KUBECONFIG = credentials('kubeconfig')
      }
      stages {
        stage('Checkout') {
          steps {
              git branch: 'main',
              url: 'https://github.com/your-repo/nginx-app.git'
          }
        }
        stage('Build Docker Image') {
          steps {
            script {
              docker.build("your-dockerhub/nginx-app:${env.BUILD_NUMBER}")
            }
          }
        }
        stage('Push to Docker Hub') {
          steps {
            script {
              docker.withRegistry('', env.DOCKERHUB_CREDENTIALS) {
                docker.image("your-dockerhub/nginx-app:${env.BUILD_NUMBER}").push()
              }
            }
          }
        }
        stage('Deploy to Kubernetes') {
          steps {
            sh '''
              kubectl apply -f kubernetes/deployments/nginx-deployment.yaml
              kubectl set image deployment/nginx nginx=your-dockerhub/nginx-app:${env.BUILD_NUMBER}
            '''
          }
        }
      }
    }
    EOT
  }
}

resource "kubernetes_secret" "dockerhub_creds" {
  metadata {
    name = "dockerhub-creds"
  }
  data = {
    "username" = var.dockerhub_username
    "password" = var.dockerhub_password
  }
  type = "Opaque"
}

resource "kubernetes_secret" "kubeconfig" {
  metadata {
    name = "kubeconfig"
  }
  data = {
    "config" = file("${path.module}/../kubernetes/kubeconfig")
  }
  type = "Opaque"
}
