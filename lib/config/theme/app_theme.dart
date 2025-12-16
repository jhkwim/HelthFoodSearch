import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _primaryGreen = Color(0xFF2E7D32); // Nature Green
  static const Color _lightGreen = Color(0xFFE8F5E9);
  static const Color _darkGreen = Color(0xFF1B5E20);
  static const Color _accentOrange = Color(0xFFFF6D00); // Complementary for Actions

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryGreen,
        primary: _primaryGreen,
        secondary: _accentOrange,
        background: _lightGreen,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: _lightGreen,
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24, // Larger title
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _darkGreen),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _darkGreen),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _darkGreen),
        headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
        titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black87),
        bodyLarge: TextStyle(fontSize: 18, color: Colors.black87), // Base text larger
        bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Button text
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.all(20),
        labelStyle: const TextStyle(fontSize: 18, color: Colors.grey),
        floatingLabelStyle: const TextStyle(fontSize: 20, color: _primaryGreen),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }
}
