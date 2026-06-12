import 'package:flutter/painting.dart';

class AuthSession {
  static final AuthSession _instance = AuthSession._internal();
  factory AuthSession() => _instance;
  AuthSession._internal();

  String? loggedInEmail;
}

class AppColors {
  // ALU brand: blue, red, white
  static const Color aluBlue = Color(0xFF003580);
  static const Color aluRed = Color(0xFFCC0000);
  static const Color aluWhite = Color(0xFFFFFFFF);

  static const Color lightPrimary = aluBlue;
  static const Color darkPrimary = Color(0xFF1A5CB8);
  static const Color lightSecondary = aluRed;
  static const Color darkSecondary = Color(0xFFFF3333);
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color darkBackground = Color(0xFF020617);
  static const Color lightSurface = aluWhite;
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color lightText = Color(0xFF020617);
  static const Color darkText = aluWhite;
  static const Color lightTextSecondary = Color(0xFF020617);
  static const Color darkTextSecondary = aluWhite;
  static const Color lightTextDisabled = Color(0xFF020617);
  static const Color darkTextDisabled = aluWhite;
  static const Color lightBorder = Color(0xFF020617);
  static const Color darkBorder = aluWhite;
  static const Color primary = aluBlue;
  static const Color background = aluWhite;
  static const Color card = Color(0xFFF5F5F5);
  static const Color text = Color(0xFF1E2432);
  static const Color subtitle = Color(0xFF8F8F8F);
}
