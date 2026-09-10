#!/bin/bash

set -e

NAMESPACE="storage"
RELEASE_NAME="minio"
ACCESS_KEY="minioadmin"
SECRET_KEY="minioadmin123"
PERSISTENCE_SIZE="10Gi"

echo " Ajout du repo Helm MinIO..."
helm repo add minio https://charts.min.io/ || true
helm repo update

echo " Création du namespace $NAMESPACE (si nécessaire)..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

echo " Installation de MinIO..."
helm install $RELEASE_NAME minio/minio \
  --namespace $NAMESPACE \
  --set accessKey=$ACCESS_KEY \
  --set secretKey=$SECRET_KEY \
  --set persistence.enabled=true \
  --set persistence.size=$PERSISTENCE_SIZE

echo " MinIO installé avec succès !"
echo "  Namespace : $NAMESPACE"
echo "  Access Key : $ACCESS_KEY"
echo "  Secret Key : $SECRET_KEY"