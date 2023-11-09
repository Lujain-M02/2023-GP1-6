import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyStories extends StatelessWidget {
final user = FirebaseAuth.instance.currentUser!.uid;

// Query the "stories" subcollection
//QuerySnapshot storiesQuery =  await userRef.collection('stories').get();

// Iterate through the documents in the subcollectio

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(textDirection: TextDirection.rtl
      , child: Container(
        color: Colors.amber,
        child: Text(
          "hi"
          ,style: TextStyle(color: Colors.black,fontSize: 40),
        ),
      )),
    );
    
  }

}