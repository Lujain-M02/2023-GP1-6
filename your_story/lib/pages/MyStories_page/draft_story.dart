import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_story/pages/MainPage.dart';
// import 'package:your_story/style.dart';
import '../../alerts.dart';

void saveORupdateDraft(context, title, content, draftID) async {
  try {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw "المستخدم لم يسجل دخوله";

    DocumentReference userRef =
        FirebaseFirestore.instance.collection("User").doc(user.uid);
    CollectionReference storiesCollection =
        userRef.collection("Story"); // Add draft story to Firestore

    if (draftID != null) {
      // Draft ID exists, so update the existing draft
      await storiesCollection.doc(draftID).update({
        'title': title,
        'content': content,
      });
    } else {
      await storiesCollection.add({
        'title': title,
        'content': content,
        'type': 'drafted',
        //'published': false, // Use a boolean for published status
        //'url': pdfUrl, // Store the URL
        //'imageUrl': firstImageFile, // Store the image URL
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(content: 'تم حفظ المسودة بنجاح', icon: Icons.check),
    );

    // Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.of(context).pushReplacementNamed('/myStories');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage(initialIndex: 1)),
        (Route<dynamic> route) => false);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(content: 'حدث خطأ أثناء حفظ المسودة', icon: Icons.error),
    );
  }
}
