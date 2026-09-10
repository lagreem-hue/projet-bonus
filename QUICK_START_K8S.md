# 🚀 DÉMARRAGE RAPIDE POUR L'ÉQUIPE

## ⚠️ SI VOUS VENEZ DE PULL LA BRANCHE

Kubernetes utilise des **images Docker locales**. Avant de déployer, vous devez :

### 1️⃣ Builder l'image Docker de l'API
```powershell
cd d:\travail\ETNA\group-1068668
docker build -t etnair-api:latest ./api
```

### 2️⃣ Vérifier que l'image existe
```powershell
docker images | Select-String "etnair-api"
```

Vous devriez voir :
```
etnair-api   latest   xxxxxxxxx   X minutes ago   XXX MB
```

### 3️⃣ Déployer sur Kubernetes
```powershell
# Déployer PostgreSQL
kubectl apply -f k8s/postgresql-deployment.yaml
kubectl apply -f k8s/postgresql-service.yaml

# Déployer l'API
kubectl apply -f k8s/api-deployment.yaml
kubectl apply -f k8s/api-service.yaml
```

### 4️⃣ Vérifier le déploiement
```powershell
kubectl get pods
```

Tous les pods doivent être en status **Running**.

---

## 🔴 Problème : CrashLoopBackOff sur etnair-api ?

**Cause** : L'image `etnair-api:latest` n'existe pas sur votre machine.

**Solution** :
```powershell
# 1. Builder l'image
docker build -t etnair-api:latest ./api

# 2. Redémarrer les pods
kubectl delete -f k8s/api-deployment.yaml
kubectl apply -f k8s/api-deployment.yaml

# 3. Surveiller le démarrage
kubectl get pods -w
```

---

## 📖 Documentation complète

Voir le fichier `k8s/README.md` pour tous les détails.

## 🌐 Accès à l'API

Une fois déployé : **http://localhost:30000**
