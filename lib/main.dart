import 'package:flutter/material.dart';
import 'package:test_/datail_screen.dart';
import 'package:test_/main_app.dart';
import 'package:test_/splash_screen.dart';

void main() {
  runApp(
    MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => const SplashScreen(),
      '/home': (context) => const MainApp(),
      '/details': (context) => const DetailsScreen(),
    },
  ));
}
