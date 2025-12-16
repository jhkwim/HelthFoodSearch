import 'package:flutter/material.dart';

class AppTheme {
  // Soft Sage / Mint Palette
  static const Color _primarySage = Color(0xFF7CB342); // Softer Green (Light Green 600)
  static const Color _secondaryMint = Color(0xFFAED581); // Minty Green (Light Green 300)
  static const Color _backgroundCream = Color(0xFFFAFAFA); // Off-white/Cream
  static const Color _surfaceWhite = Colors.white;
  static const Color _textDark = Color(0xFF263238); // Blue Grey 900
  static const Color _accentCoral = Color(0xFFFF8A65); // Soft Coral for actions

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primarySage,
        primary: _primarySage,
        secondary: _secondaryMint,
        tertiary: _accentCoral,
        surface: _surfaceWhite,
        onSurface: _textDark,
        surfaceContainerHighest: _backgroundCream, // Replaces background
      ),
      scaffoldBackgroundColor: _backgroundCream,
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceWhite,
        foregroundColor: _textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: _textDark,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: _textDark),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: _textDark, letterSpacing: -1.0),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textDark, letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _textDark),
        bodyLarge: TextStyle(fontSize: 16, color: _textDark, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, color: _textDark, height: 1.5),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primarySage,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceWhite,
        prefixIconColor: _primarySage,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primarySage, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: _surfaceWhite,
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _secondaryMint.withOpacity(0.2),
        labelStyle: const TextStyle(color: _textDark, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide.none,
      ),
    );
  }
}
