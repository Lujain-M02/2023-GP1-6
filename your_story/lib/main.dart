// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:your_story/startScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TECHقصـ',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
