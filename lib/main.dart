// ignore_for_file: library_private_types_in_public_api

import 'package:assignment1/constants.dart';
import 'package:assignment1/models/index.dart';
import 'package:assignment1/screens/profile_page.dart';
import 'package:assignment1/screens/home.dart';
import 'package:assignment1/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:assignment1/screens/communities.dart';
import 'package:assignment1/screens/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeStores();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      error: Color(0xFFEF4444),
      onPrimary: Color(0xFF0F172A),
      onSurface: AppColors.lightText,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      labelStyle: const TextStyle(color: Color(0xFF666666)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppColors.lightText),
      bodyMedium: GoogleFonts.poppins(color: AppColors.lightText),
      bodySmall: GoogleFonts.poppins(color: AppColors.lightText),
      displayLarge: GoogleFonts.poppins(color: AppColors.lightText),
      displayMedium: GoogleFonts.poppins(color: AppColors.lightText),
      displaySmall: GoogleFonts.poppins(color: AppColors.lightText),
      headlineLarge: GoogleFonts.poppins(color: AppColors.lightText),
      headlineMedium: GoogleFonts.poppins(color: AppColors.lightText),
      headlineSmall: GoogleFonts.poppins(color: AppColors.lightText),
      titleLarge: GoogleFonts.poppins(color: AppColors.lightText),
      titleMedium: GoogleFonts.poppins(color: AppColors.lightText),
      titleSmall: GoogleFonts.poppins(color: AppColors.lightText),
      labelLarge: GoogleFonts.poppins(color: AppColors.lightText),
      labelMedium: GoogleFonts.poppins(color: AppColors.lightText),
      labelSmall: GoogleFonts.poppins(color: AppColors.lightText),
    ),

    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      error: Color(0xFFEF4444),
      onPrimary: Color(0xFF0F172A),
      onSurface: AppColors.darkText,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      labelStyle: const TextStyle(color: Color(0xFFAAAAAA)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppColors.darkText),
      bodyMedium: GoogleFonts.poppins(color: AppColors.darkText),
      bodySmall: GoogleFonts.poppins(color: AppColors.darkText),
      displayLarge: GoogleFonts.poppins(color: AppColors.darkText),
      displayMedium: GoogleFonts.poppins(color: AppColors.darkText),
      displaySmall: GoogleFonts.poppins(color: AppColors.darkText),
      headlineLarge: GoogleFonts.poppins(color: AppColors.darkText),
      headlineMedium: GoogleFonts.poppins(color: AppColors.darkText),
      headlineSmall: GoogleFonts.poppins(color: AppColors.darkText),
      titleLarge: GoogleFonts.poppins(color: AppColors.darkText),
      titleMedium: GoogleFonts.poppins(color: AppColors.darkText),
      titleSmall: GoogleFonts.poppins(color: AppColors.darkText),
      labelLarge: GoogleFonts.poppins(color: AppColors.darkText),
      labelMedium: GoogleFonts.poppins(color: AppColors.darkText),
      labelSmall: GoogleFonts.poppins(color: AppColors.darkText),
    ),

    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: lightTheme,
      darkTheme: darkTheme,

      themeMode: _themeMode,

      initialRoute: "/",
      routes: {
        "/": (context) => LoginScreen(),
        "/home": (context) => HomeScreen(),
        "/profile": (context) => ProfilePage(),
        "/communities": (context) => const CommunitiesScreen(),
        "/notifications": (context) => const NotificationsScreen(),
      },
    );
  }
}
