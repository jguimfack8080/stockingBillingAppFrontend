# Stocking Billing App

Une application Flutter moderne pour la gestion des stocks et la facturation, avec un système d'authentification robuste et des rôles utilisateurs.

## Description

Cette application permet de gérer efficacement les stocks et la facturation. Elle est développée avec Flutter, offrant ainsi une expérience utilisateur fluide et moderne sur plusieurs plateformes.

## Fonctionnalités

### Authentification
- Connexion sécurisée avec JWT
- Gestion des rôles (Admin, Manager, Cashier)
- Protection des routes par rôle
- Déconnexion sécurisée

### Gestion des Utilisateurs (Admin)
- Création de nouveaux utilisateurs
- Visualisation de la liste des utilisateurs
- Modification des informations utilisateur
- Désactivation/Activation des comptes
- Gestion des rôles et permissions

### Interface Utilisateur
- Design moderne et intuitif
- Thème sombre/clair
- Navigation fluide entre les écrans
- Indicateurs visuels pour les statuts utilisateur
- Gestion des erreurs et feedback utilisateur

## Prérequis

- Flutter SDK (version ^3.7.2)
- Dart SDK
- Un éditeur de code (VS Code, Android Studio, etc.)

## Installation

1. Clonez le dépôt :
```bash
git clone [URL_DU_REPO]
```

2. Installez les dépendances :
```bash
flutter pub get
```

3. Lancez l'application :
```bash
flutter run
```

## Structure du Projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/                   # Modèles de données
│   ├── user.dart            # Modèle utilisateur
│   ├── user_update_data.dart # Données de mise à jour utilisateur
│   └── user_deactivation.dart # Modèle de désactivation
├── screens/                  # Écrans de l'application
│   ├── auth/                # Écrans d'authentification
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/                # Écrans principaux
│   │   ├── admin_dashboard.dart
│   │   ├── manager_dashboard.dart
│   │   ├── cashier_dashboard.dart
│   │   ├── user_list_screen.dart
│   │   ├── create_user_screen.dart
│   │   └── edit_user_screen.dart
│   └── shared/              # Composants partagés
│       └── drawer.dart
├── services/                # Services
│   ├── api_service.dart     # Service API
│   ├── auth_service.dart    # Service d'authentification
│   └── user_service.dart    # Service de gestion utilisateur
├── utils/                   # Utilitaires
│   ├── constants.dart       # Constantes
│   └── routes.dart          # Routes de l'application
└── widgets/                 # Widgets réutilisables
    └── role_badge.dart      # Badge de rôle
```

## Configuration

1. Cloner le repository
2. Installer les dépendances :
   ```bash
   flutter pub get
   ```
3. Configurer les variables d'environnement :
   - Créer un fichier `.env` à la racine du projet
   - Ajouter les variables nécessaires (API_URL, etc.)

## Dépendances Principales

- `flutter_riverpod` : Gestion d'état
- `go_router` : Navigation
- `http` : Requêtes HTTP
- `shared_preferences` : Stockage local
- `flutter_dotenv` : Variables d'environnement
- `intl` : Formatage des dates
- `flutter_secure_storage` : Stockage sécurisé

## API Endpoints

### Authentification
- POST `/auth/login` : Connexion
- POST `/auth/register` : Inscription

### Utilisateurs
- GET `/users/` : Liste des utilisateurs
- POST `/users/` : Création d'utilisateur
- PUT `/users/{id}` : Mise à jour d'utilisateur
- PUT `/users/deactivate/{id}` : Désactivation d'utilisateur

## Sécurité

- Tokens JWT pour l'authentification
- Validation des rôles côté client et serveur
- Stockage sécurisé des informations sensibles
- Protection des routes par rôle
- Gestion des erreurs et exceptions

## Développement

Pour commencer à développer :

1. Assurez-vous d'avoir toutes les dépendances installées
2. Exécutez `flutter pub get` pour mettre à jour les dépendances
3. Utilisez `flutter run` pour lancer l'application en mode développement

## Tests

Pour exécuter les tests :
```bash
flutter test
```

## Contribution

1. Fork le projet
2. Créer une branche pour votre fonctionnalité
3. Commiter vos changements
4. Pousser vers la branche
5. Ouvrir une Pull Request

## Licence

Ce projet est sous licence MIT.

## Contact

Pour toute question ou suggestion, n'hésitez pas à [CONTACT].
