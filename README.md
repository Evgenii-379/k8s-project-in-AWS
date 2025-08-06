# AWS Terraform + Kubernetes Project

Этот проект автоматизирует развертывание Kubernetes-кластера в AWS с использованием Terraform.

## Структура проекта
- `infrastructure/` - Terraform-код для AWS-инфраструктуры
- `kubernetes/` - манифесты Kubernetes
- `monitoring/` - настройки Prometheus/Grafana
- `scripts/` - вспомогательные скрипты

## Начало работы
1. Установите Terraform и AWS CLI
2. Настройте AWS credentials
3. Инициализируйте Terraform:
   ```bash
   cd infrastructure
   terraform init
   terraform apply
