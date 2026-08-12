# Lodg'in

**Lodg'in** est une application mobile développée avec **Flutter** dans le cadre d'un projet de validation des compétences en développement d'applications multi-écrans et en navigation.

L'application a pour objectif de permettre aux étudiants universitaires de rechercher et consulter des logements adaptés à leurs besoins.

---

## Objectif du projet

Le projet consiste à développer une application Flutter multi-écrans mettant en pratique :

- La création d'interfaces Flutter
- La navigation entre plusieurs écrans
- La transmission de paramètres entre les écrans
- La recherche et le filtrage de données
- La création et validation de formulaires
- La gestion des thèmes clair et sombre
- La création de widgets réutilisables
- L'adaptation de l'interface aux différentes tailles d'écran
- La séparation des données et de l'interface utilisateur

---

## Fonctionnalités

Lodg'in permet de :

- 🏠 Consulter une liste de logements
- 🔎 Rechercher un logement
- 🎯 Filtrer les logements
- 📄 Consulter les détails d'un logement
- 📝 Réserver un logement
- 🌙 Utiliser l'application en mode clair ou sombre
- 📱 Utiliser l'application sur mobile et tablette

---

# Structure du projet

lib/
├── main.dart
│
├── models/
│ ├── property/
│ │ └── property_model.dart
│ └── user/
│ └── user_model.dart
│
├── data/
│ └── properties.dart
│
├── screens/
│ ├── home_screen.dart
│ ├── search_screen.dart
│ ├── property_detail_screen.dart
│ ├── favorites_screen.dart
│ └── rental_application_screen.dart
│
├── widgets/
│ ├── property_card.dart
│ ├── property_search_bar.dart
│ └── property_type_chip.dart
│
├── routes/
│ └── app_router.dart
│
└── theme/
└── app_theme.dart

# Captures d'écran

Les captures d'écran de l'application sont disponibles dans le dossier :

screenshots/

# Installation et lancement

## Prérequis

- Flutter SDK
- Dart SDK
- Android Studio ou Visual Studio Code
- Un émulateur ou un appareil physique

Vérifier l'installation de Flutter :

```bash
flutter doctor
```

## Cloner le projet

```bash
git clone <URL_DU_REPOSITORY>
```

Puis :

```bash
cd studynest
```

## Installer les dépendances

```bash
flutter pub get
```

## Lancer l'application

```bash
flutter run
```

## Exécuter les tests

```bash
flutter test
```

---

# Contexte

Projet réalisé dans le cadre de l'évaluation :

**Flutter Project — Multi-screen app with navigation**

L'objectif est de mettre en pratique les compétences Flutter et les concepts de navigation à travers une application multi-écrans.

---

## 👨‍💻 Auteur

**Claudio Arthur**

Projet académique Flutter — Lodg'in.
