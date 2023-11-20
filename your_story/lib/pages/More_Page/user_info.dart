import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'معلومات الحساب',
              style: TextStyle(
                color: Colors.black, // Set the AppBar title text color to black
              ),
            ),
            leading: BackButton(
              color: Colors.black,
            )),
        body:
            ProfileUpdateForm(), // Directly embedding the ProfileUpdateForm here
      ),
    );
  }
}

class ProfileUpdateForm extends StatefulWidget {
  @override
  _ProfileUpdateFormState createState() => _ProfileUpdateFormState();
}

//State<ProfileUpdateForm>
class _ProfileUpdateFormState extends State<ProfileUpdateForm> {
  // final _formKey = GlobalKey<FormState>();

  final user =
      FirebaseAuth.instance.currentUser!.uid; //retrieve signed in user ID
  String username = "";
  String useremail = "";
  getUserInfo() async {
    DocumentSnapshot<Map<String, dynamic>> ds =
        await FirebaseFirestore.instance.collection("User").doc(user).get();

    Map<String, dynamic>? userData = ds.data();

    String email = userData?['email'];
    String name = userData?['name'];
    // print('$email');
    // print('$name');
    setState(() {
      username = name;
      useremail = email;

      //print('$username');
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  Widget customListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 22, 22, 22)),
      title: Text(title),
      subtitle: Text(subtitle),
      // Add other properties and styling as needed
    );
  }

  @override
  Widget build(BuildContext context) {
    // Implement the actual UI of this widget
    return Scaffold(
      body: ListView(
        children: <Widget>[
          customListTile(Icons.person, "الإسم",
              username), 
          customListTile(Icons.email, "البريد الإلكتروني", useremail)
        ],
      ),
    );
  }
}