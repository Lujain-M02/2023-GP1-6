import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class MyHomePage extends StatelessWidget {final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    // Navigate to the white page when "Skip" is clicked
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => WhitePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 19.0),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Welcome to Onboarding",
          body: "This is the first screen.",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Second Screen",
          body: "This is the second screen.",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Last Screen",
          body: "This is the last screen.",
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context), // Triggered when the user presses "Done"
      onSkip: () => _onIntroEnd(context), // Triggered when the user presses "Skip"
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done"),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.blue,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
        color: Colors.white,
        child: Center(
          child: Text(
            'This is the white page after onboarding.',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}