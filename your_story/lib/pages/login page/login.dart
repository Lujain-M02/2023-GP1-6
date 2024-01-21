import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/mainpage.dart';
import 'package:your_story/pages/login%20page/reset_password.dart';
import 'package:your_story/pages/signup/signup.dart';
import 'package:your_story/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordObscured1 = true;
  bool isEnglish = true;
  bool isLogging = false;

  void checkLanguage(String text) {
    isEnglish = text.isEmpty || text.trim().contains(RegExp(r'^[a-zA-Z0-9]+$'));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 0, 48, 96),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                const SizedBox(  height: 10),
                  SizedBox(
                    height: height * 0.33,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          // top: -40,
                          // height: height,
                          // width: width,
                          child: FadeInUp(
                              duration: const Duration(seconds: 1),
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/login1'),
                                        )),
                              )),
                        ),
                        // Positioned(
                        //   top: -40,
                        //   height: height,
                        //   width: width,
                        //   child: FadeInUp(
                        //       duration: const Duration(milliseconds: 1000),
                        //       child: Container(
                        //         decoration: const BoxDecoration(
                        //             image: DecorationImage(
                        //                 image: AssetImage('assets/bg18.png'),
                        //                 fit: BoxFit.fill)),
                        //       )),
                        // )
                      ],
                    ),
                  ),
                   FadeInUp(duration: const Duration(milliseconds: 1500),
                
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
                  child: 
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                          height: height * 0.03,    ),
                            FadeInUp(
                                duration: const Duration(milliseconds: 1500),
                                child: const Center(
                                    child: Text(
                                  " الدخول إلى الحساب",
                                  style: TextStyle(
                                      color: Color.fromRGBO(49, 39, 79, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ))),
                            const SizedBox(
                              height: 30,
                            ),
                            FadeInUp(
                                duration: const Duration(milliseconds: 1700),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Color.fromRGBO(
                                                        37, 23, 118, 0.294)))),
                                        child: TextFormField(
                                            keyboardType:
                                              TextInputType.emailAddress,
                                          controller: emailController,
                                          decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                FontAwesomeIcons.envelope,
                                              ),
                                              border: InputBorder.none,
                                              hintText: "البريد الإلكتروني",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade700)),
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                emailController.text.trim() ==
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
                                          controller: passwordController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "كلمة المرور",
                                            hintStyle: TextStyle(
                                                color: Colors.grey.shade700),
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
                                            RegExp(
                                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])'); //Min 1 uppercase, 1 lowercase and 1 numeric number
                                            if (value!.isEmpty ||
                                                passwordController.text
                                                        .trim() ==
                                                    "") {
                                              return "الحقل مطلوب";
                                            }
                                            return null;
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            FadeInUp(
                                duration: const Duration(milliseconds: 1700),
                                child: Center(
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ResetPasswordPage()),
                                          );
                                        },
                                        child: const Text(
                                          "نسيت كلمة المرور؟",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  73, 68, 124, 1)),
                                        )))),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1900),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      isLogging = true;
                                      setState(() {});

                                      try {
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email:
                                                    emailController.text.trim(),
                                                password: passwordController
                                                    .text
                                                    .trim());
                                        isLogging = false;
                                        setState(() {});
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const MainPage();
                                            },
                                          ),
                                        );
                                      } catch (e) {
                                        isLogging = false;
                                        setState(() {});
                                        print("pass/email is wrong");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          CustomSnackBar(
                                            content:
                                                "البريد أو كلمة المرور غير صحيح/ة",
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(elevation: 10,
                                shadowColor: YourStoryStyle.buttonShadowColor,
                                    backgroundColor:
                                        const Color.fromARGB(255, 15, 26, 107),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("تسجيل الدخول",style: TextStyle(color: Colors.white)),
                                      if (isLogging)
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
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FadeInUp(
                                duration: const Duration(milliseconds: 2000),
                                 child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("مستخدم جديد؟",style: TextStyle(color: Colors.black),),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => SignUp()),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color.fromARGB(255, 21, 0, 98),
                                    ),
                                    child: const Text("انشئ حساب"))
                              ],
                            )),
                                        ),
                          ],
                        ),
                      ))
              ))],
              ),
            ),
          )),
    );
  }
}
