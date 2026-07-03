import 'package:flutter/material.dart';

class CargoTheme {
  static const Color primary = Color(0xFF0F172A);    // Navy Gelap & Tegas
  static const Color secondary = Color(0xFF1E293B);  // Slate Steel
  static const Color accent = Color(0xFFD97706);     // Amber/Gold Berwibawa
  static const Color background = Color(0xFFF1F5F9); // Abu Baja Ringan
  static const Color surface = Colors.white;

  static TextStyle titleStyle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: primary,
    letterSpacing: 0.5,
  );

  static TextStyle subtitleStyle = const TextStyle(
    fontSize: 14,
    color: Colors.blueGrey,
    fontWeight: FontWeight.w500,
  );
}