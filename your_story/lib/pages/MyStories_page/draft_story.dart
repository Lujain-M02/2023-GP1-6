import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/style.dart';

import '../../alerts.dart'; // Ensure you have this if it contains your app's style data

class DraftStoryPage extends StatefulWidget {
  final String title;
  final String content;
  final String? draftID;

  const DraftStoryPage(
      {Key? key, required this.title, required this.content, this.draftID})
      : super(key: key);

  @override
  _DraftStoryPageState createState() => _DraftStoryPageState();
}

class _DraftStoryPageState extends State<DraftStoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => saveDraft());
  }

  Future<void> saveDraft() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw "المستخدم لم يسجل دخوله";

      DocumentReference userRef =
          FirebaseFirestore.instance.collection("User").doc(user.uid);
      CollectionReference storiesCollection =
          userRef.collection("Story"); // Add draft story to Firestore

      if (widget.draftID != null) {
        // Draft ID exists, so update the existing draft
        await storiesCollection.doc(widget.draftID).update({
          'title': widget.title,
          'content': widget.content,
        });
      } else {
        await storiesCollection.add({
          'title': widget.title,
          'content': widget.content,
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

  @override
  Widget build(BuildContext context) {
    // This page does not need to display anything since it's
    // used for backend operations (saving drafts) only.
    // Hence, we return an empty container.
    return Container();
  }
}
