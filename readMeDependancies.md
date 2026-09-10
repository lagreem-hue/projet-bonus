

---

# 📚 Documentation des Dépendances du Projet ETNAir

> **Date de création** : 6 décembre 2025  
> **Projet** : ETNAir - Plateforme de location de logements (Clone Airbnb)  
> **Contexte** : Projet ETNA - Semaines 1 à 5 (IDV + ISR)

---

## 📖 Table des matières

1. Technologies principales
2. Dépendances Backend (API)
3. Dépendances Frontend
4. Services Docker
5. Résumé des dépendances par catégorie
6. Vérification complète

---

## 1. Technologies principales

### Node.js (v20)

**Justification** : Node.js est le runtime JavaScript côté serveur imposé par le sujet du projet. Il permet d'exécuter du code JavaScript en dehors du navigateur et est particulièrement adapté pour créer des API REST performantes et scalables. Le sujet demande explicitement l'utilisation de Node.js avec Express, nous nous plions donc aux livrables du projet.

### Express.js

**Justification** : Framework web minimaliste pour Node.js, demandé dans le sujet (Semaine 2). Express simplifie la création de routes HTTP, la gestion des middlewares et l'organisation de l'API REST. C'est le standard de l'industrie pour les API Node.js.

### PostgreSQL (v16)

**Justification** : Base de données relationnelle imposée par le sujet (Semaine 1). PostgreSQL est robuste, open-source et parfaitement adapté pour gérer les relations complexes entre utilisateurs, propriétés, réservations et avis. Il supporte également les types JSON pour les données flexibles.

### Next.js (v14)

**Justification** : Framework React moderne avec routage intégré, recommandé pour le frontend (Semaine 4). Next.js simplifie le développement en incluant le routing, l'optimisation automatique des performances et le support du Server-Side Rendering (SSR). C'est une alternative plus complète qu'un setup React classique.

### Prisma ORM

**Justification** : ORM (Object-Relational Mapping) moderne demandé dans le sujet (Semaine 2). Prisma génère automatiquement un client TypeScript type-safe à partir du schéma de base de données, facilite les migrations et améliore la productivité du développement.

---

## 2. Dépendances Backend (API)

### 🔵 **Dépendances de production (dependencies)**

#### **cors** (^2.8.5)

**Justification** : Middleware Express pour gérer les Cross-Origin Resource Sharing. Indispensable pour permettre au frontend (qui tourne sur un domaine différent : port 3001) de communiquer avec l'API backend (port 3000) sans erreur de sécurité du navigateur.

#### **dotenv** (^16.3.1)

**Justification** : Permet de charger les variables d'environnement depuis un fichier `.env` vers `process.env`. Essentiel pour sécuriser les informations sensibles (mots de passe DB, clés API) et faciliter la configuration entre les environnements (dev, production).

#### **prisma** (^5.7.0)

**Justification** : CLI Prisma pour gérer les migrations de base de données et générer le client. Permet de synchroniser le schéma de base de données avec le code et d'effectuer des migrations versionnées.

#### **@prisma/client** (^5.7.0)

**Justification** : Client Prisma généré automatiquement qui permet d'interagir avec la base de données PostgreSQL de manière type-safe. Il transforme les requêtes SQL en méthodes JavaScript simples et évite les erreurs de typage.

#### **jsonwebtoken** (^9.0.2)

**Justification** : Bibliothèque pour créer et vérifier des JSON Web Tokens (JWT), demandée dans le sujet (Semaine 2 et 3). Les JWT permettent de sécuriser l'authentification des utilisateurs sans stocker de sessions côté serveur. Chaque requête authentifiée contient un token signé.

#### **bcrypt** (^5.1.1)

**Justification** : Librairie pour hacher (chiffrer) les mots de passe des utilisateurs, obligatoire dans le sujet (Semaine 3). Bcrypt utilise un algorithme de hachage lent et sécurisé qui protège contre les attaques par force brute. On ne stocke jamais les mots de passe en clair.

#### **express-validator** (^7.0.1)

**Justification** : Middleware de validation des données entrantes dans les requêtes HTTP, demandé dans le sujet (Semaine 3). Il vérifie que les emails sont valides, que les mots de passe respectent une longueur minimale, etc. Cela évite les erreurs et les injections malveillantes.

#### **swagger-jsdoc** (^6.2.8)

**Justification** : Génère automatiquement la documentation Swagger/OpenAPI à partir des commentaires JSDoc dans le code. Permet de maintenir une documentation API à jour sans effort supplémentaire.

#### **swagger-ui-express** (^5.0.0)

**Justification** : Interface web interactive pour visualiser et tester l'API via Swagger, requis dans le sujet (Semaine 2). Accessible sur `/api-docs`, elle permet aux développeurs frontend et testeurs d'explorer toutes les routes disponibles.

#### **@faker-js/faker** (^8.3.1)

**Justification** : Bibliothèque pour générer des données fictives réalistes (utilisateurs, annonces, réservations), demandée dans le sujet (Semaine 3). Faker permet de peupler rapidement la base de données avec des exemples pour tester l'application sans créer manuellement des centaines d'entrées.

#### **multer** (^1.4.5-lts.1)

**Justification** : Middleware pour gérer l'upload de fichiers (images de propriétés), nécessaire pour le bonus de la Semaine 3. Multer analyse les requêtes multipart/form-data et enregistre les fichiers uploadés temporairement avant de les envoyer vers MinIO ou Cloudinary.

#### **aws-sdk** (^2.1506.0)

**Justification** : SDK officiel d'Amazon Web Services, utilisé pour communiquer avec MinIO (compatible S3), demandé dans le sujet (Semaine 3 bonus). Permet de stocker les images des annonces sur un serveur de stockage objet auto-hébergé au lieu du système de fichiers local.

#### **morgan** (^1.10.0)

**Justification** : Logger HTTP qui enregistre automatiquement toutes les requêtes entrantes (méthode, URL, statut, temps de réponse), suggéré dans le sujet (Semaine 3 bonus). Utile pour le débogage et le monitoring de l'API en temps réel.

#### **helmet** (^7.1.0)

**Justification** : Middleware de sécurité qui configure automatiquement les en-têtes HTTP pour protéger l'API contre les vulnérabilités courantes (XSS, clickjacking, etc.). Recommandé pour toute application web en production.

#### **cookie-parser** (^1.4.6)

**Justification** : Middleware pour parser les cookies HTTP. Utile si l'on décide de stocker le JWT dans un cookie HttpOnly au lieu du localStorage, ce qui améliore la sécurité contre les attaques XSS.

#### **socket.io** (^4.6.1)

**Justification** : Bibliothèque pour les communications temps réel via WebSockets. Permet d'envoyer des notifications instantanées aux utilisateurs (nouvelle réservation, message reçu) sans qu'ils aient besoin de rafraîchir la page. Alternative à une table de notifications volumineuse.

#### **nodemailer** (^6.9.7)

**Justification** : Librairie pour envoyer des emails (confirmation de réservation, notifications importantes). Complète le système de notifications temps réel en fournissant un canal de communication asynchrone pour les événements critiques.

#### **cloudinary** (^1.41.0)

**Justification** : SDK pour le service cloud Cloudinary, ajouté pour un bonus futur. Cloudinary offre un CDN mondial, la transformation automatique d'images (resize, compression, conversion WebP) et des performances optimales pour l'affichage des photos de logements. Alternative/complément à MinIO.

#### **stripe** (^14.10.0)

**Justification** : SDK officiel de Stripe pour gérer les paiements en ligne, prévu pour un bonus (Semaine 5). Stripe permet de traiter les paiements par carte bancaire de manière sécurisée sans manipuler directement les données bancaires. La table `PAYMENTS` inclut déjà un champ `stripe_payment_id`.

#### **express-rate-limit** (^7.1.5)

**Justification** : Middleware de limitation du taux de requêtes par IP. Protège l'API contre les attaques par déni de service (DOS) et les tentatives de brute-force sur les endpoints de connexion. Bonne pratique de sécurité pour toute API exposée publiquement.

#### **compression** (^1.7.4)

**Justification** : Middleware qui compresse automatiquement les réponses HTTP (gzip/deflate). Réduit la bande passante utilisée et améliore les temps de chargement, particulièrement pour les listes d'annonces avec beaucoup de données JSON.

---

### 🟢 **Dépendances de développement (devDependencies)**

#### **nodemon** (^3.0.2)

**Justification** : Outil qui redémarre automatiquement le serveur Node.js à chaque modification de fichier. Indispensable en développement pour éviter de relancer manuellement le serveur après chaque changement de code. Utilisé via la commande `npm run dev`.

#### **jest** (^29.7.0)

**Justification** : Framework de tests unitaires pour JavaScript, demandé dans le sujet (Semaine 3 et 5). Jest permet de tester la logique métier, les routes API et de garantir une couverture de tests d'au moins 50% du code. Inclut un système de mocking et d'assertions.

#### **supertest** (^6.3.3)

**Justification** : Librairie pour tester les routes HTTP de l'API, demandée dans le sujet (Semaine 3). Supertest simule des requêtes HTTP (GET, POST, etc.) sans démarrer un vrai serveur, ce qui accélère les tests et vérifie que les endpoints retournent les bonnes réponses.

#### **cross-env** (^7.0.3)

**Justification** : Outil pour définir des variables d'environnement dans les scripts npm de manière compatible Windows/Mac/Linux. Indispensable puisque l'équipe travaille sur Windows. Permet d'écrire `cross-env NODE_ENV=test` au lieu de syntaxes spécifiques à chaque OS.

#### **eslint** (^8.55.0)

**Justification** : Linter JavaScript qui analyse le code pour détecter les erreurs de syntaxe, les mauvaises pratiques et les incohérences de style. Essentiel pour le travail en équipe afin de maintenir une base de code propre et cohérente. Configurable avec des règles partagées.

#### **prettier** (^3.1.1)

**Justification** : Formateur de code automatique qui uniformise le style d'écriture (indentation, guillemets, points-virgules). Complémentaire à ESLint, Prettier évite les débats sur le formatage et garantit que tout le code de l'équipe suit les mêmes conventions visuelles.

#### **typescript** (^5.3.3)

**Justification** : Superset de JavaScript qui ajoute un système de typage statique optionnel. TypeScript améliore la qualité du code en détectant les erreurs de type à la compilation plutôt qu'à l'exécution. Particulièrement utile avec Prisma qui génère des types automatiques. Bien que le projet utilise principalement JavaScript, TypeScript peut être activé progressivement et est une bonne pratique pour les projets d'envergure. Recommandé pour le travail en équipe.

#### **@types/node** (^20.10.5)

**Justification** : Définitions de types TypeScript pour l'API Node.js. Permet à TypeScript de comprendre les modules natifs Node.js (fs, path, http, etc.) et d'offrir l'autocomplétion dans l'éditeur. Indispensable si l'on active TypeScript dans le projet.

#### **@types/express** (^4.17.21)

**Justification** : Définitions de types TypeScript pour Express.js. Fournit les types pour les objets Request, Response, NextFunction, etc. Améliore considérablement l'expérience de développement avec l'autocomplétion et la détection d'erreurs.

#### **@types/bcrypt** (^5.0.2)

**Justification** : Définitions de types TypeScript pour la bibliothèque bcrypt. Permet d'utiliser bcrypt avec un typage complet dans un projet TypeScript.

#### **@types/jsonwebtoken** (^9.0.5)

**Justification** : Définitions de types TypeScript pour jsonwebtoken. Offre un typage strict pour la génération et la validation des JWT.

#### **@types/multer** (^1.4.11)

**Justification** : Définitions de types TypeScript pour multer. Nécessaire pour typer correctement les fichiers uploadés et la configuration de multer.

#### **@types/cookie-parser** (^1.4.6)

**Justification** : Définitions de types TypeScript pour cookie-parser. Permet de typer l'accès aux cookies dans les requêtes Express.

#### **@types/morgan** (^1.9.9)

**Justification** : Définitions de types TypeScript pour morgan. Fournit le typage pour la configuration du logger HTTP.

#### **ts-node** (^10.9.2)

**Justification** : Permet d'exécuter directement des fichiers TypeScript sans compilation préalable. Utile en développement pour tester rapidement du code TypeScript. Fonctionne avec nodemon pour le hot-reload de fichiers `.ts`.

#### **tsx** (^4.7.0)

**Justification** : Alternative moderne à ts-node, plus rapide et plus légère. Permet d'exécuter des fichiers TypeScript avec une meilleure performance. Recommandé pour les scripts et le développement.

---

## 3. Dépendances Frontend

### 🔵 **Dépendances de production (dependencies)**

#### **next** (^14.0.4)

**Justification** : Framework React avec routage intégré, recommandé pour le frontend (Semaine 4). Next.js simplifie la création de pages, gère automatiquement le routing et optimise les performances (lazy-loading, splitting de code). Alternative plus moderne qu'un setup React pur.

#### **react** (^18.2.0)

**Justification** : Bibliothèque principale de React, obligatoire pour utiliser Next.js. React permet de créer des interfaces utilisateur dynamiques basées sur des composants réutilisables.

#### **react-dom** (^18.2.0)

**Justification** : Bibliothèque React pour le rendu dans le DOM du navigateur. Gère l'affichage des composants React dans les pages web.

#### **axios** (^1.6.2)

**Justification** : Client HTTP pour effectuer des requêtes vers l'API backend, suggéré dans le sujet (Semaine 4). Axios simplifie les appels API avec une syntaxe claire, gère automatiquement les erreurs et supporte les intercepteurs pour ajouter des headers (comme le JWT).

#### **@tanstack/react-query** (^5.14.2)

**Justification** : Bibliothèque de gestion d'état et de cache pour les requêtes API, bonus recommandé (Semaine 5). React Query optimise les performances en évitant les requêtes redondantes, met en cache les résultats et gère automatiquement le rechargement des données. Alternative moderne à Redux pour la gestion des données serveur.

#### **socket.io-client** (^4.6.1)

**Justification** : Client WebSocket pour recevoir les notifications temps réel depuis le backend. Permet d'afficher instantanément les messages, les nouvelles réservations ou les mises à jour sans polling. Fonctionne avec `socket.io` côté serveur.

#### **geolib** (^3.3.4)

**Justification** : Bibliothèque pour les calculs géographiques (distance entre deux points GPS, rayon de recherche). Utile pour implémenter la recherche de logements dans un rayon de X kilomètres autour d'une position. Le schéma de base de données inclut déjà `latitude` et `longitude`.

#### **@stripe/stripe-js** (^2.4.0)

**Justification** : Bibliothèque JavaScript officielle de Stripe pour charger et initialiser Stripe.js dans le navigateur (bonus Semaine 5). Gère la communication sécurisée avec les serveurs Stripe.

#### **@stripe/react-stripe-js** (^2.4.0)

**Justification** : Composants React officiels de Stripe pour intégrer un formulaire de paiement sécurisé (bonus Semaine 5). Ces composants gèrent l'UI de saisie de carte bancaire de manière PCI-compliant sans que les données bancaires transitent par notre serveur.

---

### 🟢 **Dépendances de développement (devDependencies)**

#### **typescript** (^5.3.3)

**Justification** : Superset de JavaScript qui ajoute un système de typage statique. TypeScript améliore la qualité du code en détectant les erreurs avant l'exécution. Next.js supporte nativement TypeScript. Bien que optionnel, il est recommandé pour les projets en équipe et facilite la maintenance à long terme.

#### **@types/react** (^18.2.45)

**Justification** : Définitions de types TypeScript pour React. Fournissent l'autocomplétion et la détection d'erreurs pour tous les composants, hooks et API React. Indispensables si l'on utilise TypeScript dans le frontend.

#### **@types/react-dom** (^18.2.18)

**Justification** : Définitions de types TypeScript pour React-DOM. Nécessaire pour typer les méthodes de rendu et les interactions avec le DOM.

#### **@types/node** (^20.10.5)

**Justification** : Définitions de types TypeScript pour Node.js. Nécessaire pour typer les modules Node.js utilisés dans Next.js (fs, path, etc.) et dans les scripts de configuration.

#### **eslint** (^8.55.0)

**Justification** : Linter JavaScript/TypeScript qui analyse le code pour détecter les erreurs et mauvaises pratiques.

#### **eslint-config-next** (^14.0.4)

**Justification** : Configuration ESLint spécifique à Next.js. Inclut les règles recommandées pour React, les hooks, l'accessibilité et les bonnes pratiques Next.js.

#### **prettier** (^3.1.1)

**Justification** : Formateur de code pour maintenir un style cohérent dans l'équipe frontend, identique à la version backend.

#### **jest** (^29.7.0)

**Justification** : Framework de tests unitaires pour tester les composants React et la logique frontend, demandé dans le sujet (Semaine 5).

#### **@testing-library/react** (^14.1.2)

**Justification** : Bibliothèque de tests pour React orientée utilisateur, demandée dans le sujet (Semaine 5). Permet de tester les composants en simulant les interactions utilisateur réelles plutôt que les détails d'implémentation.

#### **@testing-library/jest-dom** (^6.1.5)

**Justification** : Matchers Jest personnalisés pour tester les éléments DOM. Fournit des assertions comme `toBeInTheDocument()`, `toHaveClass()`, etc.

#### **@testing-library/user-event** (^14.5.1)

**Justification** : Bibliothèque pour simuler des interactions utilisateur réalistes (clics, saisie clavier, hover) dans les tests. Plus avancée que les événements de base de Testing Library.

#### **cypress** (^13.6.2)

**Justification** : Outil de tests end-to-end (E2E) pour tester l'application complète (frontend + backend) de manière automatisée, demandé dans le sujet (Semaine 5). Cypress simule un vrai utilisateur naviguant sur le site (connexion, recherche d'annonce, réservation) et vérifie que tout fonctionne.

#### **tailwindcss** (^3.3.6)

**Justification** : Framework CSS utility-first pour styliser rapidement l'interface, suggéré dans le sujet (Semaine 4 : "TailwindCSS"). Tailwind permet de créer des designs responsives sans écrire de CSS personnalisé. Peut être activé progressivement sans impacter le CSS classique existant.

#### **postcss** (^8.4.32)

**Justification** : Outil de transformation CSS requis par Tailwind CSS. PostCSS permet d'appliquer des plugins de traitement CSS (autoprefixer, minification, etc.).

#### **autoprefixer** (^10.4.16)

**Justification** : Plugin PostCSS qui ajoute automatiquement les préfixes vendeurs CSS (-webkit-, -moz-, etc.) pour assurer la compatibilité cross-browser. Requis par Tailwind CSS.

---

## 4. Services Docker

### PostgreSQL (image: postgres:16)

**Justification** : Base de données relationnelle officielle en version 16. Utilisée pour stocker toutes les données métier (utilisateurs, propriétés, réservations, avis). Le volume `db_data` persiste les données même si le conteneur est supprimé.

### MinIO (image: minio/minio)

**Justification** : Serveur de stockage objet auto-hébergé compatible S3, demandé dans le sujet (Semaine 3 bonus). MinIO stocke les images des annonces de manière scalable. La console web (port 9001) permet de visualiser les buckets et fichiers stockés.

### pgAdmin (image: dpage/pgadmin4)

**Justification** : Interface web pour administrer PostgreSQL (bonus Semaine 1). pgAdmin permet de visualiser les tables, exécuter des requêtes SQL manuellement et gérer la base de données via une interface graphique accessible sur le port 5050.

---

## 5. Résumé des dépendances par catégorie

| Catégorie         | Backend            | Frontend           |
| ----------------- | ------------------ | ------------------ |
| **Production**    | 19 dépendances     | 8 dépendances      |
| **Développement** | 15 dépendances     | 13 dépendances     |
| **Total**         | **34 dépendances** | **21 dépendances** |

---

## 6. Vérification complète

### ✅ **Framework & Base**

- ✅ Node.js (runtime)
- ✅ Express (API)
- ✅ Next.js (frontend)
- ✅ PostgreSQL (BDD)

### ✅ **ORM & Base de données**

- ✅ Prisma
- ✅ @prisma/client

### ✅ **Authentification & Sécurité**

- ✅ jsonwebtoken (JWT)
- ✅ bcrypt (hash mots de passe)
- ✅ helmet (sécurité headers)
- ✅ cors (CORS)
- ✅ cookie-parser (cookies)
- ✅ express-validator (validation)
- ✅ express-rate-limit (protection DOS)

### ✅ **Documentation API**

- ✅ swagger-jsdoc
- ✅ swagger-ui-express

### ✅ **Tests**

- ✅ jest (tests unitaires)
- ✅ supertest (tests API)
- ✅ @testing-library/react (tests React)
- ✅ @testing-library/jest-dom
- ✅ @testing-library/user-event
- ✅ cypress (tests E2E)

### ✅ **Upload & Stockage**

- ✅ multer (upload fichiers)
- ✅ aws-sdk (MinIO/S3)
- ✅ cloudinary (bonus)

### ✅ **Notifications**

- ✅ socket.io (temps réel backend)
- ✅ socket.io-client (temps réel frontend)
- ✅ nodemailer (emails)

### ✅ **Paiements**

- ✅ stripe (backend)
- ✅ @stripe/stripe-js (frontend)
- ✅ @stripe/react-stripe-js (frontend)

### ✅ **Géolocalisation**

- ✅ geolib (calculs GPS)

### ✅ **Requêtes HTTP**

- ✅ axios (frontend)
- ✅ @tanstack/react-query (cache)

### ✅ **Performance**

- ✅ compression (compression HTTP)

### ✅ **Développement**

- ✅ TypeScript (backend + frontend)
- ✅ nodemon (auto-reload)
- ✅ cross-env (scripts multi-OS)
- ✅ eslint (linting)
- ✅ prettier (formatage)
- ✅ morgan (logs HTTP)
- ✅ dotenv (variables env)

### ✅ **Design (optionnel)**

- ✅ tailwindcss (CSS utility-first)
- ✅ postcss (traitement CSS)
- ✅ autoprefixer (préfixes vendeurs)

### ✅ **Génération de données**

- ✅ @faker-js/faker (seed)

---

## ✅ Conformité avec le sujet ETNA

- ✅ Toutes les dépendances **obligatoires** des semaines 1 à 5 sont incluses
- ✅ Les **bonus** suggérés sont anticipés (MinIO, Stripe, tests E2E, Socket.io, Tailwind)
- ✅ Les choix techniques sont **justifiés** par les livrables du projet
- ✅ L'infrastructure est **scalable** et prête pour le déploiement Kubernetes (Semaine 2-3 ISR)
- ✅ La sécurité est renforcée (helmet, rate-limit, compression)
- ✅ TypeScript est disponible pour une migration progressive
- ✅ Le design peut être amélioré avec Tailwind CSS en Semaine 4

---

**Fin du document de justification des dépendances.**
