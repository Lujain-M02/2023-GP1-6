// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:your_story/style.dart';
import 'package:your_story/pages/welcome_page.dart';

class OnBoarding extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
      title: "",
      body: "",
      image: Image.asset('assets/onboarding11.png'),
      decoration: PageDecoration(
        imagePadding: EdgeInsets.all(0.1),
        pageColor: const Color.fromARGB(255, 238, 245, 255),
        imageFlex: 120,
        // titleTextStyle: TextStyle(
        //   fontSize: 27.0,
        //   fontWeight: FontWeight.bold,
        //   color: YourStoryStyle.titleColor,
        ),
        // bodyTextStyle: TextStyle(
        //   fontSize: 24.0,
        //   color: Colors.black,
        // ),
      // ),
    ),
    PageViewModel(
      title: "",
      body: "",
      image: Image.asset('assets/onboarding22.png'),
      decoration: PageDecoration(
        imagePadding: EdgeInsets.all(0.1),
        pageColor: const Color.fromARGB(255, 238, 245, 255),
        imageFlex: 120,
        // titleTextStyle: TextStyle(
        //   fontSize: 27.0,
        //   fontWeight: FontWeight.bold,
        //   color: YourStoryStyle.titleColor,
        // ),
        // bodyTextStyle: TextStyle(
        //   fontSize: 24.0,
        //   color: Colors.black,
        // ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: IntroductionScreen(
            globalBackgroundColor: Color.fromARGB(255, 238, 245, 255),
            pages: pages,
            onDone: () {
              // Navigate to the next page when "تم" is clicked
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => WelcomePage(),
                ),
              );
            },
            onSkip: () {
              // Navigate to the next page when "تخطي" is clicked
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => WelcomePage(),
                ),
              );
            },
            showSkipButton: true,
            skip: Text(
              "تخطي",
              style: TextStyle(
                color: YourStoryStyle.titleColor,
                fontSize: 23.0,
              ),
            ),
            next: Icon(
              Icons.arrow_forward,
              color: YourStoryStyle.titleColor,
            ),
            done: Text(
              "تم",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: YourStoryStyle.titleColor,
                fontSize: 23.0,
              ),
            ),
            dotsDecorator: DotsDecorator(
              size: Size(10.0, 10.0),
              color: const Color.fromARGB(255, 92, 91, 91),
              activeSize: Size(22.0, 10.0),
              activeColor: YourStoryStyle.titleColor,
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            )));
  }
}
