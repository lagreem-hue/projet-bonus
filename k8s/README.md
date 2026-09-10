# Guide de Déploiement Kubernetes - ETNAir

## Prérequis
- Docker Desktop installé sur Windows
- Kubernetes activé dans Docker Desktop

## Étape 1 : Activer Kubernetes dans Docker Desktop

1. Ouvrir Docker Desktop
2. Aller dans **Settings** (icône engrenage)
3. Sélectionner **Kubernetes** → Cocher **Enable Kubernetes**
4. Cliquer sur **Apply & Restart**
5. Attendre que le statut Kubernetes devienne vert

### Vérification
```powershell
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

## Étape 2 : Construire l'image Docker de l'API

⚠️ **IMPORTANT : Chaque membre de l'équipe doit construire l'image localement !**

L'image Docker n'est pas partagée via Git. Si vous clonez le projet ou pullez une branche, vous devez builder l'image vous-même.

Depuis le répertoire racine du projet :

```powershell
cd d:\travail\ETNA\group-1068668
docker build -t etnair-api:latest ./api
```

Vérifier que l'image est créée :
```powershell
docker images | Select-String "etnair-api"
```

💡 **Si vous avez des erreurs `CrashLoopBackOff` sur les pods etnair-api**, c'est probablement parce que vous avez oublié cette étape !

## Étape 3 : Déployer PostgreSQL

```powershell
# Appliquer le deployment PostgreSQL
kubectl apply -f k8s/postgresql-deployment.yaml

# Appliquer le service PostgreSQL
kubectl apply -f k8s/postgresql-service.yaml

# Vérifier le déploiement
kubectl get pods
kubectl get services
```

Attendre que le pod PostgreSQL soit en statut **Running** :
```powershell
kubectl get pods -w
```
(Appuyez sur Ctrl+C pour quitter)

## Étape 4 : Déployer l'API

```powershell
# Appliquer le deployment de l'API
kubectl apply -f k8s/api-deployment.yaml

# Appliquer le service de l'API
kubectl apply -f k8s/api-service.yaml

# Vérifier le déploiement
kubectl get pods
kubectl get services
```

## Étape 5 : Accéder à l'API

### Récupérer l'URL du service

```powershell
kubectl get services etnair-api
```

**Avec Docker Desktop sur Windows**, le LoadBalancer sera accessible sur :
- **http://localhost:30000**

### Tester l'API

```powershell
# Test depuis PowerShell
Invoke-WebRequest -Uri http://localhost:30000 -UseBasicParsing | Select-Object -ExpandProperty Content

# Ou depuis le navigateur
# Ouvrir : http://localhost:30000
```

## Commandes Utiles

### Voir les ressources déployées
```powershell
kubectl get all
kubectl get pods
kubectl get services
kubectl get deployments
```

### Voir les logs d'un pod
```powershell
# Lister les pods
kubectl get pods

# Voir les logs (remplacer <pod-name> par le nom du pod)
kubectl logs <pod-name>

# Exemples :
kubectl logs postgresql-xxxxxxxxxx-xxxxx
kubectl logs etnair-api-xxxxxxxxxx-xxxxx
```

### Décrire une ressource
```powershell
kubectl describe pod <pod-name>
kubectl describe service etnair-api
```

### Redémarrer un déploiement
```powershell
kubectl rollout restart deployment postgresql
kubectl rollout restart deployment etnair-api
```

### Supprimer les déploiements
```powershell
kubectl delete -f k8s/api-deployment.yaml
kubectl delete -f k8s/api-service.yaml
kubectl delete -f k8s/postgresql-deployment.yaml
kubectl delete -f k8s/postgresql-service.yaml
```

## URL à partager avec les développeurs

Une fois le déploiement réussi, partager cette URL avec l'équipe de développement :

**URL de l'API : http://localhost:30000**

Sur Docker Desktop, cette URL sera accessible depuis votre machine Windows.

## Troubleshooting

### Les pods ne démarrent pas
```powershell
# Vérifier l'état des pods
kubectl get pods

# Voir les détails d'un pod problématique
kubectl describe pod <pod-name>

# Voir les logs
kubectl logs <pod-name>
```

### L'API ne se connecte pas à PostgreSQL
```powershell
# Vérifier que PostgreSQL est bien démarré
kubectl get pods | Select-String "postgresql"

# Tester la connexion depuis un pod de l'API
kubectl exec -it <api-pod-name> -- sh
# Puis dans le pod :
# nc -zv postgresql 5432
```

### Réinitialiser complètement
```powershell
# Supprimer tous les déploiements
kubectl delete all --all

# Réappliquer
kubectl apply -f k8s/postgresql-deployment.yaml
kubectl apply -f k8s/postgresql-service.yaml
kubectl apply -f k8s/api-deployment.yaml
kubectl apply -f k8s/api-service.yaml
```

## Architecture déployée

```
┌─────────────────────────────────────┐
│      Docker Desktop Kubernetes      │
│                                     │
│  ┌──────────────┐  ┌─────────────┐ │
│  │ PostgreSQL   │  │  ETNAir API │ │
│  │  (1 replica) │  │ (2 replicas)│ │
│  └──────────────┘  └─────────────┘ │
│         │                 │         │
│  ┌──────────────┐  ┌─────────────┐ │
│  │postgresql-svc│  │etnair-api   │ │
│  │ ClusterIP    │  │ LoadBalancer│ │
│  └──────────────┘  └─────────────┘ │
│                          │          │
└──────────────────────────┼──────────┘
                           │
                  http://localhost:30000
```
