// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:your_story/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      title: 'TECHقصـ',
     
      home: HomeScreen(),
    );
  }
}
