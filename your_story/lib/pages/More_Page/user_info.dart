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
  late ValueNotifier<bool> refreshNotifier = ValueNotifier<bool>(false);


  @override
  void initState() {
    super.initState();
    refreshNotifier = ValueNotifier<bool>(false);
  }

  Future<Map<String, dynamic>?> fetchUserInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> ds =
          await FirebaseFirestore.instance.collection("User").doc(userId).get();
      return ds.data();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: "المعذرة، حصل خطأ",
        ),
      );
      return null;
    }
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
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Container();
        } else {
          String username = snapshot.data?['name'] ?? 'N/A';
          String useremail = snapshot.data?['email'] ?? 'N/A';
          return ValueListenableBuilder<bool>(
            valueListenable: refreshNotifier,
            builder: (context, _, __) {
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
            },
          );
        }
      },
    );
  }

  Widget customListTile(BuildContext context, IconData icon, String title, String subtitle, String field) {
    return InkWell(
      onTap: () async {
            if (field == 'username') {
              dynamic result = await Navigator.push(
              context,
             MaterialPageRoute(builder: (context) => EditUsernamePage()),
              );

  if (result != null && result is bool && result) {
    // Refresh user information
    setState(() {});
  }
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
              if (field == 'username')
                const Icon(Icons.arrow_forward_ios, size: 16, color: Color.fromARGB(255, 164, 161, 161)),
            ],
          ),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}

class EditUsernamePage extends StatefulWidget {
  @override
  _EditUsernamePageState createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                TextFormField(
                  controller: _nameController,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    labelText: "الاسم الجديد",
                    prefixIcon: Icon(
                      FontAwesomeIcons.user,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || _nameController.text.trim() == "") {
                      return "الحقل مطلوب";
                    } else if (value.trim().length == 1) {
                      return " يجب أن يحتوي الاسم أكثر من حرف على الأقل";
                    } else if (!RegExp(
                            r"^[ء-يa-zA-Z]+(?:\s[ء-يa-zA-Z]+)?$"
                            )
                        .hasMatch(value.trim())) {
                      return 'أدخل اسم يحتوي على أحرف فقط';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await updateUsername();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: YourStoryStyle.titleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: const Size(180, 40),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'حفظ',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(FontAwesomeIcons.check, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateUsername() async {
    try {
      final String newUsername = _nameController.text.trim();
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

      // Navigate back to the profile page
      Navigator.pop(context, true);
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
