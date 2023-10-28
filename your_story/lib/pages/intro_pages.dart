// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:your_story/style.dart';
import 'package:your_story/pages/welcome_page.dart';

class MyHomePage extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
      title: "المكان الأفضل لصناعة قصصك",
      body:
          "أصنع قصتك بكل سهولة، تطبيقنا يسهل رحلة صناعة القصص",
      image: Image.asset('assets/onboarding1.png'),
      decoration: PageDecoration(
        pageColor: const Color.fromARGB(255, 238, 245, 255),
        imageFlex: -3,
        titleTextStyle: TextStyle(
          fontSize: 27.0,
          fontWeight: FontWeight.bold,
          color: your_story_Style.titleColor,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 24.0,
          color: Colors.black,
        ),
      ),
    ),
    PageViewModel(
      title: "قصص مصوره عن طريق الذكاء الإصطناعي",
      body: "تقنياتنا تمكنك من صناعة قصتك وإنشاء صور مميزه لها",
      image: Image.asset('assets/onboarding2.png'),
      decoration: PageDecoration(
        pageColor: const Color.fromARGB(255, 238, 245, 255),
        imageFlex: -3,
        titleTextStyle: TextStyle(
          fontSize: 27.0,
          fontWeight: FontWeight.bold,
          color: your_story_Style.titleColor,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 24.0,
          color: Colors.black,
        ),
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
                color: your_story_Style.titleColor,
                fontSize: 23.0,
              ),
            ),
            next: Icon(
              Icons.arrow_forward,
              color: your_story_Style.titleColor,
            ),
            done: Text(
              "تم",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: your_story_Style.titleColor,
                fontSize: 23.0,
              ),
            ),
            dotsDecorator: DotsDecorator(
              size: Size(10.0, 10.0),
              color: Colors.grey,
              activeSize: Size(22.0, 10.0),
              activeColor: your_story_Style.titleColor,
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            )));
  }
}
