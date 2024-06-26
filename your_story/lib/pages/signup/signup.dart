import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/login%20page/login.dart';
import '../More_Page/more_content.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  bool isPasswordObscured1 = true;
  bool isPasswordObscured2 = true;
  bool _isAgreedToTerms = false;
  bool isSigning = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 48, 96),
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                const SizedBox(height: 10),
                SizedBox(
                  height: height * 0.25,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: FadeInUp(
                            duration: const Duration(seconds: 1),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/login2.gif'),
                              )),
                            )),
                      ),
                    ],
                  ),
                ),
                FadeInUp(
                    duration: const Duration(milliseconds: 1500),
                    child: Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 100,
                        ),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 244, 247, 252),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: const Center(
                                        child: Text(
                                      "إنشاء حساب جديد",
                                      style: TextStyle(
                                          color: Color.fromRGBO(49, 39, 79, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ))),
                                SizedBox(
                                  height: height * 0.003,
                                ),
                                FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 1700),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    75, 135, 145, 198)),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    122, 121, 194, 0.298),
                                                blurRadius: 20,
                                                offset: Offset(0, 10),
                                              )
                                            ]),
                                        child: Column(children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                                controller: _fullNameController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'الاسم',
                                                  prefixIcon: Icon(
                                                      FontAwesomeIcons.user),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty ||
                                                      _fullNameController.text
                                                              .trim() ==
                                                          "") {
                                                    return "الحقل مطلوب";
                                                  } else if (value
                                                          .trim()
                                                          .length ==
                                                      1) {
                                                    return " يجب أن يحتوي الاسم أكثر من حرف على الأقل";
                                                  } else if (!RegExp(
                                                          r"^[ء-يa-zA-Z]+(?:\s[ء-يa-zA-Z]+)?$")
                                                      .hasMatch(value.trim())) {
                                                    return 'أدخل اسم يحتوي على أحرف فقط';
                                                  }
                                                  return null;
                                                }),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              controller: _emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: const InputDecoration(
                                                  labelText:
                                                      'البريد الإلكتروني',
                                                  prefixIcon: Icon(
                                                      FontAwesomeIcons
                                                          .envelope)),
                                              validator: (value) {
                                                if (value!.isEmpty ||
                                                    _emailController.text
                                                            .trim() ==
                                                        "") {
                                                  return "الحقل مطلوب";
                                                } else if (!RegExp(
                                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.[a-zA-Z]+")
                                                    .hasMatch(value)) {
                                                  return 'أدخل بريد إلكتروني صالح';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: _passwordController1,
                                              decoration: InputDecoration(
                                                labelText: 'كلمة المرور',
                                                prefixIcon: const Icon(
                                                    FontAwesomeIcons.lock),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    isPasswordObscured1
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      isPasswordObscured1 =
                                                          !isPasswordObscured1;
                                                    });
                                                  },
                                                ),
                                              ),
                                              obscureText: isPasswordObscured1,
                                              validator: (value) {
                                                RegExp regexCapital =
                                                    RegExp(r'(?=.*?[A-Z])');
                                                RegExp regexSmall =
                                                    RegExp(r'(?=.*?[a-z])');
                                                RegExp regexdigit =
                                                    RegExp(r'(?=.*?\d)');
                                                RegExp regexSpecialChar =
                                                    RegExp(
                                                        r'(?=.*?[@#$%^&+=])');

                                                if (value!.isEmpty ||
                                                    _passwordController1.text
                                                            .trim() ==
                                                        "") {
                                                  return "الحقل مطلوب";
                                                } else if (!regexCapital
                                                    .hasMatch(value)) {
                                                  return "كلمة المرور يجب أن تحتوي على حرف كبير";
                                                } else if (!regexdigit
                                                    .hasMatch(value)) {
                                                  return "كلمة المرور يجب أن تحتوي على رقم";
                                                } else if (!regexSmall
                                                    .hasMatch(value)) {
                                                  return "كلمة المرور يجب أن تحتوي على حرف صغير";
                                                } else if (!regexSpecialChar
                                                    .hasMatch(value)) {
                                                  return "كلمة المرور يجب ان تحتوي على رمز \nخاص مثل: (@#%^&+=)";
                                                } else if (value ==
                                                    _emailController.text) {
                                                  return "كلمة المرور لا يمكن أن تشابه البريد الالكتروني";
                                                } else if (value.length < 8) {
                                                  return "كلمة المرور يجب أن تكون ثمانية خانات\n على الأقل";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: _passwordController2,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'أدخل كلمة المرور مرة اخرى',
                                                prefixIcon: const Icon(
                                                    FontAwesomeIcons.lock),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    isPasswordObscured2
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      isPasswordObscured2 =
                                                          !isPasswordObscured2;
                                                    });
                                                  },
                                                ),
                                              ),
                                              obscureText: isPasswordObscured2,
                                              validator: (value) {
                                                if (value!.isEmpty ||
                                                    _passwordController2.text
                                                            .trim() ==
                                                        "") {
                                                  return "الحقل مطلوب";
                                                } else if (_passwordController2
                                                        .text
                                                        .trim() !=
                                                    _passwordController1.text
                                                        .trim()) {
                                                  return "يجب أن تكون كلمة المرور مطابقة";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.all(width * 0.0234),
                                            child: Row(
                                              children: <Widget>[
                                                Checkbox(
                                                    value: _isAgreedToTerms,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _isAgreedToTerms =
                                                            newValue!;
                                                      });
                                                    },
                                                    activeColor:
                                                        const Color.fromARGB(
                                                            255, 15, 26, 107)),
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    children: <TextSpan>[
                                                      const TextSpan(
                                                        text:
                                                            'أوافق على ', // Your first piece of text
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      TextSpan(
                                                        text: 'الشروط والأحكام',
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 36, 51, 109),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                // Your tap action. For example:
                                                                showCustomModalBottomSheet(
                                                                    context,
                                                                    termsAndCondition());
                                                              },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ]))),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                FadeInUp(
                                  duration: const Duration(milliseconds: 1700),
                                  child: Center(
                                      child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                                  255, 27, 29, 117)
                                              .withOpacity(0.2), // Shadow color
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (!_isAgreedToTerms) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            CustomSnackBar(
                                                content:
                                                    'يجب أن توافق على الشروط والأحكام أولاً.',
                                                icon: Icons.warning),
                                          );
                                          return;
                                        }
                                        if (_formKey.currentState!.validate()) {
                                          String fullName =
                                              _fullNameController.text.trim();
                                          String email =
                                              _emailController.text.trim();
                                          String password =
                                              _passwordController1.text.trim();

                                          isSigning = true;
                                          setState(() {});
                                          try {
                                            await FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                              email: email,
                                              password: password,
                                            );
                                            final user = FirebaseAuth
                                                .instance.currentUser!.uid;
                                            final userRef = FirebaseFirestore
                                                .instance
                                                .collection("User")
                                                .doc(user);

                                            userRef.set(({
                                              'userID': user,
                                              'name': fullName,
                                              'email': email,
                                            }));
                                            // Create the "Stories" subcollection
                                            isSigning = false;
                                            setState(() {});
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainPage()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          } on FirebaseAuthException catch (e) {
                                            isSigning = false;
                                            setState(() {});
                                            if (e.code == 'weak-password') {
                                              print(
                                                  'The password provided is too weak.');
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                CustomSnackBar(
                                                    content:
                                                        "كلمة المرور ضعيفة",
                                                    icon: Icons.warning),
                                              );
                                            } else if (e.code ==
                                                'email-already-in-use') {
                                              print(
                                                  'The account already exists for that email.');
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                CustomSnackBar(
                                                    content:
                                                        "البريد الإلكتروني موجود مسبقًا",
                                                    icon: Icons.warning),
                                              );
                                            }
                                          } catch (e) {
                                            isSigning = false;
                                            setState(() {});
                                            print(e);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              CustomSnackBar(
                                                  content: "يوجد خطأ",
                                                  icon: Icons.warning),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255,
                                            15,
                                            26,
                                            107), // Background color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('إنشاء الحساب',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          if (isSigning)
                                            (Container(
                                                height: 15,
                                                width: 15,
                                                margin: const EdgeInsets.all(5),
                                                child:
                                                    const CircularProgressIndicator(
                                                        color: Colors.white)))
                                        ],
                                      ),
                                    ),
                                  )),
                                ),
                                SizedBox(
                                  height: height * 0.003,
                                ),
                                FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 2000),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("تملك حساب بالفعل؟"),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const LoginPage()),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  const Color.fromARGB(
                                                      255, 15, 26, 107),
                                            ),
                                            child: const Text("تسجيل الدخول"))
                                      ],
                                    )))
                              ],
                            ),
                          ),
                        )))
              ]))),
    ));
  }
}
