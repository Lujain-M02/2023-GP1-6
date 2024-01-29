// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/style.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
       
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
  late ValueNotifier<bool> refreshNotifier;
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    refreshNotifier = ValueNotifier<bool>(false);
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> ds =
          await FirebaseFirestore.instance.collection("User").doc(userId).get();
      userInfo = ds.data();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         CustomSnackBar(
          content: "المعذرة، حصل خطأ",icon: Icons.warning),
      );
    }
  }

  


   
 @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: YourStoryStyle.primarycolor,
        appBar: AppBar(
          leading: const BackButton(color: Colors.white), 
          backgroundColor:YourStoryStyle.primarycolor,
          elevation: 0,
          title: const Text(
            'معلومات الحساب',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: userInfo == null
            ? Center( child: Lottie.asset('assets/loading2.json',width: 200,height: 200))
            : Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 100,
                          right: 20,
                          bottom: 350,
                        ),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 244, 247, 252),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                          ),
                        ),
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Card(
                            elevation: 5,
                            shadowColor: const Color.fromARGB(255, 6, 14, 21),
                            color: const Color.fromARGB(175, 17, 68, 120),
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const CircleAvatar(
                                    backgroundImage: AssetImage('assets/sss.png'),
                                    radius: 50,
                                    backgroundColor: Color.fromARGB(255, 255, 255, 255), 
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'الاسم: ${userInfo?['name'] ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.white),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EditUsernamePage()),
                                          );
                                          if (result == true) {
                                            fetchUserInfo();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'البريد الإلكتروني: ${userInfo?['email'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                    backgroundColor: YourStoryStyle.primarycolor,
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
          content: 'تم تحديث الاسم بنجاح',icon: Icons.check_circle
        ),
      );

      // Navigate back to the profile page
      Navigator.pop(context, true);
    } catch (e) {
      // show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: 'حدث خطأ أثناء تحديث الاسم',icon: Icons.warning
        ),
      );
    }
  }
}
