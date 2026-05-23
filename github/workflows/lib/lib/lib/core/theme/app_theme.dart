import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _seed = Color(0xFF6D5DF6);

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.light),
    textTheme: GoogleFonts.interTextTheme(),
    cardTheme: CardTheme(
      elevation: 0, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white.withOpacity(0.8),
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    scaffoldBackgroundColor: const Color(0xFF0F0F1A),
    cardTheme: CardTheme(
      elevation: 0, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), 
      color: Colors.white.withOpacity(0.05)
    ),
  );
}
