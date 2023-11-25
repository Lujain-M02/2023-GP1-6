import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../style.dart';
import '../../alerts.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'معلومات الحساب',
            style: TextStyle(color: Colors.black),
          ),
          titleTextStyle: const TextStyle(fontSize: 24,),
          centerTitle: true,
          leading: const BackButton(color: Colors.black),
        ),
        body: profileInformation(),
      ),
    );
  }
}

class profileInformation extends StatefulWidget {
  @override
  _profileInformationState createState() => _profileInformationState();
}

class _profileInformationState extends State<profileInformation> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>?> fetchUserInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> ds =
          await FirebaseFirestore.instance.collection("User").doc(userId).get();
      return ds.data();
    } catch (e) {
      // Handle the error or log it
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: "المعذرة، حصل خطأ",
        ),
      );
      return null;
    }
  }

  Widget customListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 22, 22, 22)),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: YourStoryStyle.titleColor,
          ));
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Container();
        } else {
          String username = snapshot.data?['name'] ?? 'N/A';
          String useremail = snapshot.data?['email'] ?? 'N/A';
          return ListView(
            children: <Widget>[
              customListTile(Icons.person, "الإسم", username),
              customListTile(Icons.email, "البريد الإلكتروني", useremail),
            ],
          );
        }
      },
    );
  }
}
