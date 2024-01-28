// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_story/firebase_options.dart';
import 'package:your_story/startscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      theme: ThemeData(
        // Set the default font to Vazirmatn
        textTheme: GoogleFonts.vazirmatnTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: StartScreen(),
    );
  }
}
