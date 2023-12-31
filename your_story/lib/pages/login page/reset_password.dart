import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/style.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String _errorMessage = '';
  bool _isResettingPassword = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'أدخل بريدك الإلكتروني هنا';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isResettingPassword = true;
      });

      try {
        // Reset password using Firebase Auth API
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            content: 'تم إرسال إعادة تعيين كلمة المرور ',
          ),
        );
      } catch (error) {
        setState(() {
          _errorMessage = error.toString();
        });
      }

      setState(() {
        _isResettingPassword = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            //image: AssetImage('assets/resetPassBG.png'),
            image: AssetImage('assets/bg18.png'),

            fit: BoxFit.cover,
          )),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //const SizedBox(height: 300),
                    const Text(
                      "إعادة تعيين كلمة المرور:",
                      style: TextStyle(fontSize: 30),
                    ),
                    const Text(
                        "أدخل بريدك الالكتروني المرتبط بحسابك وسنقوم بإرسال رابط إعادة تعيين كلمة المرور إليك."),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      decoration: const InputDecoration(
                          labelText: "البريد الإلكتروني",
                          prefixIcon: Icon(
                            FontAwesomeIcons.envelope,
                          )),
                    ),
                    const SizedBox(height: 16.0),

                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            YourStoryStyle.titleColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      onPressed: _isResettingPassword ? null : _resetPassword,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "ارسال",
                            style: TextStyle(color: Colors.white),
                          ),
                          if (_isResettingPassword)
                            (Container(
                                height: 15,
                                width: 15,
                                margin: const EdgeInsets.all(5),
                                child: const CircularProgressIndicator(
                                    color: Colors.white)))
                        ],
                      ),
                    ),

                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(
                                  color: YourStoryStyle
                                      .titleColor), // Set border color and width
                            ),
                          )),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "العودة لتسجيل الدخول",
                        style: TextStyle(color: YourStoryStyle.titleColor),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
