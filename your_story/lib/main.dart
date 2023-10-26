// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:your_story/firebase_options.dart';
import 'package:your_story/startscreen.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_fire_cli/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /*await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);*/
  runApp(const MyApp());
}

/*void main() {
  runApp(const MyApp());
}*/

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
