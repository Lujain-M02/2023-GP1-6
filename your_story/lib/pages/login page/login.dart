import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/mainpage.dart';
import 'package:your_story/pages/login%20page/reset_password.dart';
import 'package:your_story/pages/signup/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController EmailController = TextEditingController();
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
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: height * 0.33,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: -40,
                          height: height,
                          width: width,
                          child: FadeInUp(
                              duration: const Duration(seconds: 1),
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/bg19.png'),
                                        fit: BoxFit.fill)),
                              )),
                        ),
                        Positioned(
                          top: -40,
                          height: height,
                          width: width,
                          child: FadeInUp(
                              duration: const Duration(milliseconds: 1000),
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/bg18.png'),
                                        fit: BoxFit.fill)),
                              )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            FadeInUp(
                                duration: const Duration(milliseconds: 1500),
                                child: const Center(
                                    child: Text(
                                  " الدخول الى الحساب",
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
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: EmailController,
                                          decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                FontAwesomeIcons.envelope,
                                              ),
                                              border: InputBorder.none,
                                              hintText: "الحساب الالكتروني",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade700)),
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                EmailController.text.trim() ==
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
                                                email: EmailController.text.trim(),
                                                password:
                                                    passwordController.text.trim());
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
                                                "البريد او كلمة المرور غير صحيح/ة",
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 15, 26, 107),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("تسجيل الدخول"),
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
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => const SignUp()),
                                          );
                                        },
                                        child: const Text(
                                          "مستخدم جديد؟ تسجيل حساب",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  49, 39, 79, .6)),
                                        )))),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
