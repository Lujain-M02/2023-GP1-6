import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_story/pages/MainPage.dart';
import '../../style.dart';
import '../../alerts.dart';

class StorySave extends StatelessWidget {
  final String title;
  final String content;

  StorySave({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'معالجة القصة',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  'المعذرة النظام لا يعمل في الوقت الحالي',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(YourStoryStyle.titleColor)),
                onPressed: () {
                  addStoryToCurrentUser(title, content, context);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (Route<dynamic> route) =>
                        false, // this removes all routes below MainPage
                  );
                },
                child: Text('احفظ القصة وعد للصفحة الرئيسية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> addStoryToCurrentUser(
    String title, String content, BuildContext context) async {
  try {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection("User").doc(user.uid);

      // Create the "Stories" subcollection reference
      CollectionReference storiesCollection = userRef.collection("Stories");

      // Add a new story document to the subcollection
      await storiesCollection.add({
        'title': title,
        'content': content,
      });

      print("Story added successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: "تم الحفظ بنجاح",
        ),
      );
    } else {
      print("No user is currently signed in.");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        content: "حدث خطأ عند الحفظ",
      ),
    );
    print("Error adding story: $e");
  }
}
