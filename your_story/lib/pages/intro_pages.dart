// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/pages/welcome_page.dart';

class MyHomePage extends StatelessWidget { 
  
  final List<PageViewModel> pages = [
    PageViewModel(
      title: "المكان الأفضل لصناعة قصصك",
      body: "أصنع قصتك بكل سهولة، تطبيقنا يوصلك لنقطة البداية لرحلة صناعة القصص",
      image: Lottie.asset('assets/page1img.json'),
      decoration: PageDecoration(
        pageColor: const Color.fromARGB(255, 237, 245, 255),
        imageFlex: 3,
        titleTextStyle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
    ),
    PageViewModel(
      title: "مصوره عن طريق الذكاء الإصطناعي",
      body: "تقنياتنا تمكنك من صناعة قصتك وإنشاء صور مميزه لها",
      image: Lottie.asset('assets/page2img.json'),
      decoration: PageDecoration(
        pageColor: const Color.fromARGB(255, 237, 245, 255),
        imageFlex: 3,
        titleTextStyle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Color.fromARGB(255, 237, 245, 255),
      pages: pages,
      onDone: () {
        // Navigate to the next page when "تم" is clicked
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => welcomePage(),
          ),
        );
      },onSkip: () {
        // Navigate to the next page when "تخطي" is clicked
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => welcomePage(),
          ),
        );
      },
      showSkipButton: true,
      skip: Text(
        "تخطي",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 25.0,
        ),
      ),
      next: Icon(
        Icons.arrow_forward,
        color: Colors.blue,
      ),
      done: Text(
        "تم",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontSize: 25.0,
        ),
      ),
      dotsDecorator: DotsDecorator(
       size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.blue,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    ));
  }
}
