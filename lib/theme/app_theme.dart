import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(
    0xFF62A0EB,
  ); // Bleu principal (Boutons "Continue", "Book Now", FAB)
  static const Color primaryDark = Color(
    0xFF1E232D,
  ); // Bleu-gris foncé (Textes principaux)
  static const Color accent = Color(
    0xFFFF4D4D,
  ); // Rouge/Corail (Bouton favori / Cœur)
  static const Color secondarySoft = Color(
    0xFFE8F1FB,
  ); // Bleu très doux (Champs secondaires & bulles)

  // Light theme
  static const Color lightBackground = Color(
    0xFFEBF1F5,
  ); // Arrière-plan global (Gris/Bleu glacier)
  static const Color lightSurface = Colors.white; // Cartes et conteneurs
  static const Color lightInputFill = Color(
    0xFFF0F3F6,
  ); // Barre de recherche et inputs
  static const Color lightText = Color(0xFF1E232D);
  static const Color lightSecondaryText = Color(0xFF7D848D);

  // Dark theme
  static const Color darkBackground = Color(0xFF11161D);
  static const Color darkSurface = Color(0xFF1C242E);
  static const Color darkText = Color(0xFFF5F7FA);
  static const Color darkSecondaryText = Color(0xFF9EA6B0);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF4D4D);
  static const Color warning = Color(0xFFFFB84D);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.lightSurface,
      error: AppColors.error,
    ),

    scaffoldBackgroundColor: AppColors.lightBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.lightText,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightInputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedColor: AppColors.primary,
      secondarySelectedColor: AppColors.primary,
      labelStyle: const TextStyle(color: AppColors.lightText),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.darkSurface,
      error: AppColors.error,
    ),

    scaffoldBackgroundColor: AppColors.darkBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.darkText,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedColor: AppColors.primary,
      secondarySelectedColor: AppColors.primary,
      labelStyle: const TextStyle(color: AppColors.darkText),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
  );
}
