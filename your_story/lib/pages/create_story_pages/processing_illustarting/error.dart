import 'package:flutter/material.dart';
import 'package:your_story/pages/MainPage.dart';
import '../../../style.dart';
import 'global_story.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  const ErrorPage({
    Key? key,
    this.errorMessage =
        "حدث خطأ أثناء معالجة الصورة، يرجى إعادة المحاولة لاحقًا",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          iconSize: 27,
          icon: const Icon(Icons.home),
          onPressed: () {
            globalTitle = "";
            globalContent = "";
            globalTotalNumberOfClauses = 0;
            globaltopsisScoresList = [];
            globaltopClausesToIllustrate = [];
            globalImagesUrls = [];
            sentenceImagePairs = [];
            globalDraftID = null;
            selectedImageStyle = null;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
              (Route<dynamic> route) =>
                  false, // this removes all routes below MainPage
            );
          },
        ),
        title: const Text(
          "حدث خطأ",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        centerTitle: true,
        actions: const <Widget>[
          SizedBox(
            width: 40,
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                errorMessage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
