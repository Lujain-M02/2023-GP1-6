import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/on_boarding.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (currentUser==null){
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnBoarding()));
      }else{
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset(
                    'assets/startimg.json',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                 
                  // ignore: deprecated_member_use
                  TypewriterAnimatedTextKit(
                    speed: const Duration(milliseconds: 180),
                    totalRepeatCount: 0,
                    text: ['TECHقصـ'],
                    textStyle: const TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 22, 62, 95)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
