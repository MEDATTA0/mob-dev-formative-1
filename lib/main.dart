import 'package:assignment1/constants.dart';
import 'package:assignment1/models/index.dart';
import 'package:assignment1/screens/login.dart';
import 'package:flutter/material.dart';
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
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.lightText),
          bodyMedium: TextStyle(color: AppColors.lightText),
          bodySmall: TextStyle(color: AppColors.lightText),
          displayLarge: TextStyle(color: AppColors.lightText),
          displayMedium: TextStyle(color: AppColors.lightText),
          displaySmall: TextStyle(color: AppColors.lightText),
          headlineLarge: TextStyle(color: AppColors.lightText),
          headlineMedium: TextStyle(color: AppColors.lightText),
          headlineSmall: TextStyle(color: AppColors.lightText),
          titleLarge: TextStyle(color: AppColors.lightText),
          titleMedium: TextStyle(color: AppColors.lightText),
          titleSmall: TextStyle(color: AppColors.lightText),
          labelLarge: TextStyle(color: AppColors.lightText),
          labelMedium: TextStyle(color: AppColors.lightText),
          labelSmall: TextStyle(color: AppColors.lightText),
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
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.darkText),
          bodyMedium: TextStyle(color: AppColors.darkText),
          bodySmall: TextStyle(color: AppColors.darkText),
          displayLarge: TextStyle(color: AppColors.darkText),
          displayMedium: TextStyle(color: AppColors.darkText),
          displaySmall: TextStyle(color: AppColors.darkText),
          headlineLarge: TextStyle(color: AppColors.darkText),
          headlineMedium: TextStyle(color: AppColors.darkText),
          headlineSmall: TextStyle(color: AppColors.darkText),
          titleLarge: TextStyle(color: AppColors.darkText),
          titleMedium: TextStyle(color: AppColors.darkText),
          titleSmall: TextStyle(color: AppColors.darkText),
          labelLarge: TextStyle(color: AppColors.darkText),
          labelMedium: TextStyle(color: AppColors.darkText),
          labelSmall: TextStyle(color: AppColors.darkText),
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
      ),

      themeMode: ThemeMode.system,

      initialRoute: "/",
      routes: {"/": (context) => LoginScreen()},
    );
  }
}
