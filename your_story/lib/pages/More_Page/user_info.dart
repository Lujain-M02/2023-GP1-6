import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/style.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'معلومات الحساب',
            style: TextStyle(color: Colors.black),
          ),
          titleTextStyle: const TextStyle(fontSize: 24),
          centerTitle: true,
          leading: const BackButton(color: Colors.black),
        ),
        body: ProfileInformation(),
      ),
    );
  }
}

class ProfileInformation extends StatefulWidget {
  @override
  _ProfileInformationState createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>?> fetchUserInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> ds =
          await FirebaseFirestore.instance.collection("User").doc(userId).get();
      return ds.data();
    } catch (e) {
      // Handle the error or log it
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("المعذرة، حصل خطأ"),
        ),
      );
      return null;
    }
  }

  Widget customListTile(BuildContext context, IconData icon, String title, String subtitle, String field) {
    
    return InkWell(
      onTap: () {
        if (field == 'email') {
          // Navigate to edit email page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditEmailPage()),
          );
        } else if (field == 'username') {
          // Navigate to edit username page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditUsernamePage()),
          );
        }
      },
      child: Card(
        color: Colors.white,
        child: ListTile(
          leading: Icon(icon, color: const Color.fromARGB(255, 15, 26, 107)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color.fromARGB(255, 164, 161, 161)), 
          ],
        ),   
          subtitle: 
              Text(subtitle),
               ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Container();
        } else {
          String username = snapshot.data?['name'] ?? 'N/A';
          String useremail = snapshot.data?['email'] ?? 'N/A';
          return Container(
            color: const Color.fromARGB(255, 245, 242, 242),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: customListTile(context, FontAwesomeIcons.user, "الاسم", username, 'username'),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: customListTile(context, FontAwesomeIcons.envelope, "البريد الإلكتروني", useremail, 'email'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}


class EditEmailPage extends StatefulWidget {
  @override
  _EditEmailPageState createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'اعادة تعيين البريد الالكتروني',
            style: TextStyle(color: Colors.black),
          ),
          titleTextStyle: const TextStyle(fontSize: 24),
          centerTitle: true,
          leading: const BackButton(color: Colors.black),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني الجديد',
                  prefixIcon: Icon(FontAwesomeIcons.envelope),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await updateEmail();
                },
                style: ElevatedButton.styleFrom(
                 
                  backgroundColor: YourStoryStyle.titleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  ),
                
                child: const Text(
                  'حفظ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateEmail() async {
    try {
      // Get the new email from the text field
      final String newEmail = _emailController.text.trim();

      // Update the email in Firebase Auth
      await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);

      // Update the email in Firebase Firestore
      await FirebaseFirestore.instance.collection("User").doc(userId).update({
        'email': newEmail,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث البريد الإلكتروني بنجاح'),
        ),
      );

      // Navigate to the profile page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } catch (e) {
      // show an error message
      ScaffoldMessenger.of(context).showSnackBar(
         CustomSnackBar(
          content: 'حدث خطأ أثناء تحديث البريد الإلكتروني',
        ),
      );
      print(e);
    }
  }
}

class EditUsernamePage extends StatefulWidget {
  @override
  _EditUsernamePageState createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  final TextEditingController _usernameController = TextEditingController();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'اعادة تعيين الاسم',
            style: TextStyle(color: Colors.black),
          ),
          titleTextStyle: const TextStyle(fontSize: 24),
          centerTitle: true,
          leading: const BackButton(color: Colors.black),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                          labelText: "الاسم الجديد",
                          prefixIcon: Icon(
                            FontAwesomeIcons.user,
                          ))
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await updateUsername();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: YourStoryStyle.titleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'حفظ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUsername() async {
    try {
      // Get the new username from the text field
      final String newUsername = _usernameController.text.trim();

      // Update the username in Firebase Firestore
      await FirebaseFirestore.instance.collection("User").doc(userId).update({
        'name': newUsername,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: 'تم تحديث الاسم بنجاح',
        ),
      );

      // Navigate to the profile page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } catch (e) {
      // show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: 'حدث خطأ أثناء تحديث الاسم',
        ),
      );
    }
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../style.dart';
// import '../../alerts.dart';

// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: const Text(
//             'معلومات الحساب',
//             style: TextStyle(color: Colors.black),
//           ),
//           titleTextStyle: const TextStyle(fontSize: 24,),
//           centerTitle: true,
//           leading: const BackButton(color: Colors.black),
//         ),
//         body: profileInformation(),
//       ),
//     );
//   }
// }

// class profileInformation extends StatefulWidget {
//   @override
//   _profileInformationState createState() => _profileInformationState();
// }

// class _profileInformationState extends State<profileInformation> {
//   final String userId = FirebaseAuth.instance.currentUser!.uid;

//   Future<Map<String, dynamic>?> fetchUserInfo() async {
//     try {
//       DocumentSnapshot<Map<String, dynamic>> ds =
//           await FirebaseFirestore.instance.collection("User").doc(userId).get();
//       return ds.data();
//     } catch (e) {
//       // Handle the error or log it
//       ScaffoldMessenger.of(context).showSnackBar(
//         CustomSnackBar(
//           content: "المعذرة، حصل خطأ",
//         ),
//       );
//       return null;
//     }
//   }

//   Widget customListTile(IconData icon, String title, String subtitle) {
//     return ListTile(
//       leading: Icon(icon, color: Color.fromARGB(255, 22, 22, 22)),
//       title: Text(title),
//       subtitle: Text(subtitle),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>?>(
//       future: fetchUserInfo(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//               child: CircularProgressIndicator(
//             color: YourStoryStyle.titleColor,
//           ));
//         } else if (snapshot.hasError || !snapshot.hasData) {
//           return Container();
//         } else {
//           String username = snapshot.data?['name'] ?? 'N/A';
//           String useremail = snapshot.data?['email'] ?? 'N/A';
//           return ListView(
//             children: <Widget>[
//               customListTile(Icons.person, "الإسم", username),
//               customListTile(Icons.email, "البريد الإلكتروني", useremail),
//             ],
//           );
//         }
//       },
//     );
//   }
// }
