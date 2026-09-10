Write-Host "  Vérification de Helm"


if (-not (Get-Command helm -ErrorAction SilentlyContinue)) {
    Write-Host "Helm non trouvé. Installation..."

    # Téléchargement de Helm pour Windows
    Invoke-WebRequest -Uri "https://get.helm.sh/helm-v3.14.0-windows-amd64.zip" -OutFile "helm.zip"
    Expand-Archive helm.zip -DestinationPath .
    Move-Item windows-amd64\helm.exe -Destination "C:\Windows\System32\helm.exe" -Force
    Remove-Item windows-amd64, helm.zip -Recurse -Force

    Write-Host "Helm installé ✔"
} else {
    Write-Host "Helm déjà installé ✔"
}


Write-Host "  Ajout du dépôt Helm Portainer"

helm repo add portainer https://charts.portainer.io | Out-Null
helm repo update


Write-Host "  Création du namespace 'portainer'"


kubectl create namespace portainer 2>$null
Write-Host "Namespace prêt "


Write-Host "  Installation Portainer"


helm upgrade --install portainer portainer/portainer --namespace portainer


Write-Host "  Vérification du déploiement"


kubectl rollout status deployment/portainer -n portainer

Write-Host "  Récupération des infos d'accès"

$nodePort = kubectl get svc portainer -n portainer -o jsonpath="{.spec.ports[0].nodePort}"
$nodeIP = kubectl get nodes -o jsonpath="{.items[0].status.addresses[0].address}"

Write-Host "Portainer installé avec succès !"
Write-Host "Accès NodePort : http://$nodeIP:$nodePort"
Write-Host "Ou accès local : kubectl port-forward -n portainer svc/portainer 9000:9000"