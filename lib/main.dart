import 'package:assignment1/constants.dart';
import 'package:assignment1/models/index.dart';
import 'package:assignment1/screens/home.dart';
import 'package:assignment1/screens/login.dart';
import 'package:assignment1/screens/profile_page.dart';
import 'package:assignment1/screens/event_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeStores();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: AppColors.lightPrimary,
          secondary: AppColors.lightSecondary,
          surface: AppColors.lightSurface,
          error: Color(0xFFEF4444),
          onPrimary: Color(0xFF0F172A),
          onSurface: AppColors.lightText,
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
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          secondary: AppColors.darkSecondary,
          surface: AppColors.darkSurface,
          error: Color(0xFFEF4444),
          onPrimary: Color(0xFF0F172A),
          onSurface: AppColors.darkText,
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
      ),

      themeMode: ThemeMode.system,

      initialRoute: "/",
      routes: {
      "/": (context) => LoginScreen(),
      "/home": (context) => HomeScreen()},
    );
  }
}
