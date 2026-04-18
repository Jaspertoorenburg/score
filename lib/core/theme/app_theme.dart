import 'package:flutter/material.dart';

/// Kleurenpalet A — Game Night
/// Warm rood + goud + crème, geïnspireerd op de klassieke Yahtzee-doos.
abstract final class AppColors {
  // Primary
  static const primary = Color(0xFFC8322C);
  static const primaryDark = Color(0xFF8E211C);
  static const primaryContainer = Color(0xFFFFDAD6);

  // Accent (goud)
  static const accent = Color(0xFFF2A541);
  static const accentContainer = Color(0xFFFFECCC);

  // Success (categorie behaald / bonus)
  static const success = Color(0xFF3E8948);
  static const successContainer = Color(0xFFD4EDDA);

  // Surface — light
  static const surfaceLight = Color(0xFFFAF4EC);
  static const cardLight = Color(0xFFFFFFFF);
  static const dividerLight = Color(0xFFE5DCD0);

  // Surface — dark
  static const surfaceDark = Color(0xFF1C1814);
  static const cardDark = Color(0xFF2C2420);
  static const dividerDark = Color(0xFF3A302C);

  // Text
  static const textPrimary = Color(0xFF1C1814);
  static const textMuted = Color(0xFF6B615A);
  static const textOnPrimary = Colors.white;
}

ThemeData buildLightTheme() {
  const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.accent,
    onSecondary: AppColors.textPrimary,
    secondaryContainer: AppColors.accentContainer,
    onSecondaryContainer: AppColors.textPrimary,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: Color(0xFFF0E8DF),
    onSurfaceVariant: AppColors.textMuted,
    outline: AppColors.dividerLight,
    error: Color(0xFFD64545),
    onError: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.surfaceLight,
    cardTheme: CardTheme(
      color: AppColors.cardLight,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.dividerLight),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dividerLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
      space: 1,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedColor: AppColors.primaryContainer,
      side: const BorderSide(color: AppColors.dividerLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

ThemeData buildDarkTheme() {
  const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF8A84),
    onPrimary: Color(0xFF5C0007),
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.primaryContainer,
    secondary: AppColors.accent,
    onSecondary: AppColors.surfaceDark,
    secondaryContainer: Color(0xFF5C3A00),
    onSecondaryContainer: AppColors.accentContainer,
    surface: AppColors.surfaceDark,
    onSurface: Color(0xFFFAF4EC),
    surfaceContainerHighest: AppColors.cardDark,
    onSurfaceVariant: Color(0xFFBFB5AE),
    outline: AppColors.dividerDark,
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.surfaceDark,
    cardTheme: CardTheme(
      color: AppColors.cardDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.dividerDark),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: Color(0xFFFAF4EC),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFFFAF4EC),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF8A84),
        foregroundColor: Color(0xFF5C0007),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
      space: 1,
    ),
  );
}
