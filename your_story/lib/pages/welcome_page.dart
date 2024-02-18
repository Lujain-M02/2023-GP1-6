import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:your_story/pages/login%20page/login.dart';
import 'package:your_story/style.dart';
import 'package:your_story/pages/signup/signup.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),
            FadeInRight(
              duration: const Duration(milliseconds: 100),
              child: Image.asset(
                'assets/welcome.gif',
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 30,
                  right: 20,
                  bottom: 40,
                ),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color:Color.fromARGB(255, 0, 48, 96),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                      child: const Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'أهلا بك يا صانع القصص',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decorationThickness: BorderSide.strokeAlignCenter,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                      child: Image.asset(
                        //Padding:EdgeInsets,
                        'assets/white.png',
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const LoginPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: YourStoryStyle.buttonColor,
                                textStyle: const TextStyle(fontSize: 20),
                                elevation: 10,
                                shadowColor: YourStoryStyle.buttonShadowColor,
                              ),
                              child: const Text(
                                'سجل دخولك',
                                style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 1, 16, 87), 
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const SignUp()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: YourStoryStyle.buttonColor,
                                textStyle: const TextStyle(fontSize: 20),
                                elevation: 10,
                                shadowColor: YourStoryStyle.buttonShadowColor,
                              ),
                              child: const Text(
                                'أنشئ حساب',
                                style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 1, 16, 87), 
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
