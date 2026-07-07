import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PlanetLogisticsApp());
}

class PlanetLogisticsApp extends StatelessWidget {
  const PlanetLogisticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planet Logistics',
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
