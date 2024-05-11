import 'package:flutter/material.dart';
import 'package:your_story/pages/MainPage.dart';
import '../../../style.dart'; // Assuming style.dart contains styling information

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
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: YourStoryStyle.primarycolor),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: YourStoryStyle.primarycolor),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
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
