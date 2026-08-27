# Infrastructure Azure — Azure Quiz

## Présentation

Ce dépôt contient l'infrastructure Terraform de l'application **Azure Quiz** pour l'environnement de non-production.

L'application est composée de :

- un frontend Angular ;
- un backend Java Spring Boot ;
- une base de données PostgreSQL ;
- un cache Azure Managed Redis ;
- un compte de stockage Azure ;
- un Azure Key Vault ;
- un Azure Container Registry.

L'architecture repose principalement sur des **services Azure managés**.

---

## Architecture

Le frontend est hébergé sur **Azure Static Web Apps**.

Le backend Spring Boot est conteneurisé avec Docker et hébergé sur **Azure App Service**.

L'image Docker du backend est stockée dans **Azure Container Registry**.

Le backend communique avec PostgreSQL, Redis, Storage Account et Key Vault via l'infrastructure réseau Azure.

```text
Utilisateur
    |
    | HTTPS
    v
Azure Static Web Apps
Frontend Angular
    |
    | HTTPS / REST
    v
Azure App Service
Backend Spring Boot
    |
    | VNet Integration
    |
    +---- PostgreSQL
    |
    +---- Azure Managed Redis
    |
    +---- Storage Account
    |
    +---- Key Vault
    |
    +---- Azure Container Registry
```

![Architecture Azure Quiz](1PNG.png)


---

## Sécurité

Les principaux mécanismes de sécurité mis en place sont :

- HTTPS uniquement ;
- TLS 1.2 minimum ;
- intégration VNet du backend ;
- accès public désactivé sur les services concernés ;
- secrets stockés dans Azure Key Vault ;
- utilisation d'une identité managée pour l'App Service ;
- autorisations gérées avec Azure RBAC ;
- CORS limité à l'URL du frontend ;
- clé API pour protéger les appels au backend.

L'URL du frontend n'est pas codée en dur dans l'App Service.

Terraform récupère automatiquement le hostname de la Static Web App et configure la variable :

`FRONTEND_URL`

---

## Organisation Terraform

L'infrastructure est organisée en modules.

```text
starter/terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── modules/
    ├── network/
    ├── app-service/
    ├── static-web-app/
    ├── container-registry/
    ├── postgres/
    ├── redis/
    ├── storage/
    └── keyvault/
```

Chaque module est responsable d'un composant de l'infrastructure.

---

## Tags Azure

Les ressources sont identifiées avec des tags communs :

```text
owner       = aicha-conteneur
environment = dev
project     = azuretech
managed_by  = terraform
component   = <composant>
```

Le tag `component` permet notamment d'identifier :

- `frontend`
- `backend`
- `registry`
- `postgres`
- `redis`
- `storage`
- `keyvault`

Les pipelines CI/CD peuvent utiliser ces tags pour retrouver les ressources Azure.


---

## CI/CD

GitHub Actions est utilisé pour automatiser les contrôles et les déploiements.

### Infrastructure

Le pipeline Terraform réalise notamment :

- Terraform Format ;
- Terraform Validate ;
- Terraform Plan ;
- contrôles de sécurité ;
- Terraform Apply lorsque le déploiement est demandé.

L'authentification auprès d'Azure utilise **OIDC**.

### Backend

Le pipeline backend gère :

- le build Maven ;
- les tests ;
- les contrôles de sécurité ;
- la construction de l'image Docker ;
- le push vers Azure Container Registry ;
- le déploiement sur Azure App Service.

### Frontend

Le pipeline frontend gère :

- l'installation des dépendances ;
- le lint ;
- les tests ;
- les contrôles de sécurité ;
- le build Angular ;
- le déploiement sur Azure Static Web Apps.

---

## Gestion des secrets

Les secrets applicatifs sont stockés dans **Azure Key Vault**.

Ils comprennent notamment :

- les identifiants PostgreSQL ;
- l'URL JDBC PostgreSQL ;
- les informations nécessaires à Redis ;
- la clé API du backend.

Les secrets ne doivent pas être stockés en clair dans le dépôt Git.

---
