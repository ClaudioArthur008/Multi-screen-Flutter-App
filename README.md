Lodg'in

Lodg'in est une application mobile développée avec Flutter dans le cadre d'un projet de validation des compétences en développement d'applications multi-écrans et en navigation.

L'application permet aux étudiants universitaires de rechercher, consulter et réserver des logements adaptés à leurs besoins.

Objectif du projet

Ce projet met en pratique plusieurs compétences essentielles de Flutter, notamment :

Création d'interfaces utilisateur avec Flutter

Navigation entre plusieurs écrans avec GoRouter

Transmission de paramètres entre les écrans

Recherche et filtrage de données

Création et validation de formulaires

Gestion des thèmes clair et sombre

Création de widgets réutilisables

Adaptation de l'interface aux différentes tailles d'écran

Séparation de la logique métier, des données et de l'interface utilisateur

Fonctionnalités

L'application permet de :

🏠 Consulter une liste de logements

🔎 Rechercher un logement

🎯 Filtrer les logements par catégorie

📄 Consulter les détails d'un logement

📝 Réserver un logement via un formulaire

🌙 Basculer entre le mode clair et sombre

📱 Utiliser l'application sur smartphone et tablette

Structure du projet

lib/
├── main.dart
├── core/
│ ├── routes/
│ │ └── app_router.dart
│ └── theme/
│ └── app_theme.dart
├── services/
│ └── add_property_sheet.dart
├── data/
│ ├── data.dart
│ └── repositories/
│ ├── mock_property_repository.dart
│ ├── mock_user_repository.dart
│ ├── property_repository.dart
│ └── user_repository.dart
├── domain/
│ └── models/
│ ├── property/
│ │ └── property_model.dart
│ ├── rental/
│ │ └── rental_model.dart
│ └── user/
│ └── user_model.dart
└── presentation/
├── screens/
│ ├── booking/
│ ├── home/
│ ├── profile/
│ ├── property_details/
│ └── search/
└── widgets/
├── featured_carroussel.dart
├── header.dart
├── property_card.dart
├── property_chip_type.dart
├── rental_status_chip.dart
└── search_bar.dart

assets/
└── images/

screenshots/

test/
├── domain/
│ └── models/
│ └── property_model_test.dart
├── presentation/
│ ├── screens/
│ │ └── add_property_screen_test.dart
│ └── widgets/
│ └── property_search_bar_test.dart
├── services/
└── integration_test/

Cette organisation sépare clairement les responsabilités entre la navigation, les données, les modèles, les services, les écrans et les widgets réutilisables.

Captures d'écran

Les captures d'écran de l'application sont disponibles dans le dossier :

screenshots/
Installation et lancement
Prérequis

Flutter SDK

Dart SDK

Android Studio ou Visual Studio Code

Un émulateur Android/iOS ou un appareil physique

Vérifiez votre installation :

flutter doctor
Cloner le projet
git clone https://github.com/ClaudioArthur008/Multi-screen-Flutter-App.git

Puis accédez au dossier du projet :

cd Multi-screen-Flutter-App
Installer les dépendances
flutter pub get
Lancer l'application
flutter run
Exécuter les tests

Tests unitaires :

flutter test

Tests d'intégration :

flutter test integration_test
Technologies utilisées

Flutter

Dart

GoRouter (navigation)

Material Design 3

Tests unitaires et tests d'intégration Flutter

Contexte académique

Projet réalisé dans le cadre de l'évaluation Flutter Project — Multi-screen App with Navigation.

Les objectifs principaux étaient :

Concevoir une application comportant plusieurs écrans.

Mettre en œuvre une navigation avec des routes nommées.

Implémenter une recherche et un filtrage.

Créer un formulaire avec validation.

Gérer les thèmes clair et sombre.

Produire une interface responsive.

Auteur

Claudio Arthur

Projet académique Flutter — Lodg'in.
