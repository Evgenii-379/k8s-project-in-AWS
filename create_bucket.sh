#!/bin/bash
# Сохраните как create_bucket.sh и запустите: bash create_bucket.sh

# Генерация уникального имени
BUCKET_NAME="evg-tf-state-$(date +%Y%m%d%H%M%S)"

# Создание бакета с явным указанием формата вывода
AWS_PAGER="" aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region us-east-1 \
    --output json \
    --no-cli-pager

echo "Bucket created: $BUCKET_NAME"
