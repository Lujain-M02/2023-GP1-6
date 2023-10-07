
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class welcomePage extends StatefulWidget {
  const welcomePage({Key? key}) : super(key: key);

  @override
  _welcomePageState createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 239, 248),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),
            FadeInRight(
              duration: const Duration(milliseconds: 100),
              child: Image.asset(
                'assets/wel.png',
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 50,
                  top: 30,
                  right: 20,
                  bottom: 50,
                ),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 22, 62, 95),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Center-align the text
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                        child: const Center( // Wrap the Text with Center
                        child: Align(
                        alignment: Alignment.centerRight, // Align to the left
                        child: Text(
                          ' أهلا بك يا صانع القصص      '  ,
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            decorationThickness: BorderSide.strokeAlignCenter,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            
                            color: Colors.white,
                          ),
                        ),
                      ),),
                    ),
                    const SizedBox(height: 15),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                      child: Image.asset(
                        'assets/white.png',
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 1000),
                      from: 70,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: TextButton(
                          onPressed: () {
                            
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => WhitePage()),
                                      );                          },
                          child: const Text(
                            '!اضغط لبدأ بصنع قصتك الآن',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 249, 158, 102),
                            ),
                          ),
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


class WhitePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('White Page'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 237, 245, 255),
        child: Center(
          child: Text(
            'This is the white page after welcome page',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}