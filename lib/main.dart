import 'package:assignment1/constants.dart';
import 'package:assignment1/models/index.dart';
import 'package:assignment1/screens/profile_page.dart';
import 'package:assignment1/screens/home.dart';
import 'package:assignment1/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:assignment1/screens/communities.dart';

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
    textTheme: GoogleFonts.poppinsTextTheme(),
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
    textTheme: GoogleFonts.poppinsTextTheme(),
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
      },
    );
  }
}
