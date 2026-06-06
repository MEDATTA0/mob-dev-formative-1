import 'package:assignment1/models/index.dart';
import 'package:assignment1/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  initializeStores();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
