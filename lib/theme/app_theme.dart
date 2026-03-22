// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Dark Theme
  static const darkBg = Color(0xFF0A0E1A);
  static const darkBg2 = Color(0xFF0D1628);
  static const darkSurface = Color(0xFF111827);
  static const darkCard = Color(0xFF1A2744);
  static const darkBorder = Color(0x260D8AFF);

  // Light Theme
  static const lightBg = Color(0xFFF0F7FF);
  static const lightBg2 = Color(0xFFDBEAFE);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFE0EFFF);
  static const lightBorder = Color(0x330066CC);

  // Accent Colors (shared)
  static const cyan = Color(0xFF00D4FF);
  static const orange = Color(0xFFFF6B35);
  static const purple = Color(0xFF7C3AED);
  static const gold = Color(0xFFF59E0B);
  static const green = Color(0xFF10B981);
  static const red = Color(0xFFEF4444);

  // Gradients
  static const heroGradient = LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF7C3AED), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cyanGlow = LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF0066CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const orangeGlow = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFE53E3E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const purpleGlow = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const goldGlow = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData dark() {
    final base = ThemeData.dark();
    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.cyan,
        secondary: AppColors.orange,
        tertiary: AppColors.purple,
        surface: AppColors.darkSurface,
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFFE2E8F0),
      ),
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).apply(
        bodyColor: const Color(0xFFE2E8F0),
        displayColor: const Color(0xFFFFFFFF),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'BebasNeue',
          fontSize: 24,
          letterSpacing: 2,
          color: AppColors.cyan,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cyan, width: 1.5),
        ),
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cyan,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkCard,
        selectedColor: AppColors.cyan.withOpacity(0.2),
        labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
        side: const BorderSide(color: AppColors.darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerColor: AppColors.darkBorder,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.cyan,
        foregroundColor: Colors.black,
      ),
    );
  }

  static ThemeData light() {
    final base = ThemeData.light();
    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0066CC),
        secondary: Color(0xFFE55A2B),
        tertiary: Color(0xFF6D28D9),
        surface: AppColors.lightSurface,
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFF1E3A5F),
      ),
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).apply(
        bodyColor: const Color(0xFF1E3A5F),
        displayColor: const Color(0xFF0A1628),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        elevation: 0,
        shadowColor: const Color(0x110066CC),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'BebasNeue',
          fontSize: 24,
          letterSpacing: 2,
          color: Color(0xFF0066CC),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0066CC), width: 1.5),
        ),
        labelStyle: const TextStyle(color: Color(0xFF4A6FA5)),
        hintStyle: const TextStyle(color: Color(0xFF93A3B8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0066CC),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightCard,
        selectedColor: const Color(0xFF0066CC).withOpacity(0.15),
        labelStyle: const TextStyle(color: Color(0xFF4A6FA5), fontSize: 12),
        side: const BorderSide(color: AppColors.lightBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerColor: AppColors.lightBorder,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF0066CC),
        foregroundColor: Colors.white,
      ),
    );
  }
}
