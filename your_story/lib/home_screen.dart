

// ignore_for_file: prefer_const_constructors

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/homepage.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
 void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), (){
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));    }
    );
 }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    backgroundColor: Color.fromARGB(255, 216, 230, 243),
      body: Center(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset(
                'assets/112.json', 
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              // ignore: deprecated_member_use
              TypewriterAnimatedTextKit(
                speed: Duration(milliseconds: 180),
                totalRepeatCount: 0,
                text: ['TECHقصـ'],
                textStyle: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 22, 62, 95)
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ),
      ),
    );
  }
}
