import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:your_story/pages/style.dart';
import 'create_story_pages/create_story.dart';

class welcomePage extends StatefulWidget {
  const welcomePage({Key? key}) : super(key: key);

  @override
  _welcomePageState createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: your_story_Style.backgroundColor,
      body: SizedBox(
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
                  bottom: 40,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                      child: const Center(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ' أهلا بك يا صانع القصص      ',
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
                      from: 70,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => WhitePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: your_story_Style.buttonColor,
                            textStyle: const TextStyle(fontSize: 20),
                            elevation: 10,
                            shadowColor: your_story_Style.buttonShadowColor,
                          ),
                          child: const Text(
                            '!اضغط للبدأ بصنع قصتك الآن',
                            style: TextStyle(
                              color:
                                  Color.fromARGB(255, 1, 16, 87), // Text color
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
        title: const Text('White Page'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 237, 245, 255),
        child: const Center(
          child: Text(
            'This is the white page after welcome page',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const CreateStory()),
          );
        },
        child: const Text(
          'move',
          style: TextStyle(
            fontSize: 19, // Adjust the font size here
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
