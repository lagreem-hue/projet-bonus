#!/bin/bash

# Script pour installer Portainer sur Kubernetes avec Helm

set -e
echo "Installation Helm ..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo " Vérification de Helm..."
if ! command -v helm &> /dev/null
then
    echo "Helm n'est pas installé. Veuillez installer Helm avant de continuer."
    exit 1
fi

echo " Ajout du dépôt Helm de Portainer..."
helm repo add portainer https://charts.portainer.io

helm repo update

echo " Création du namespace 'portainer'..."
kubectl create namespace portainer || echo "Namespace 'portainer' existe déjà, continuation..."

echo " Installation de Portainer via Helm..."
helm upgrade --install portainer portainer/portainer --namespace portainer

echo " Vérification du pod Portainer..."
kubectl rollout status deployment portainer -n portainer

echo " Portainer est installé. Infos du service :"
kubectl get svc -n portainer
echo "Utilisez 'kubectl port-forward -n portainer svc/portainer 9000:9000' pour y accéder depuis votre navigateur."
