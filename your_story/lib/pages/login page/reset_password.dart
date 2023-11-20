import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/style.dart';

class ResetPasswordPage extends StatefulWidget {
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
            content:
                'تم إرسال رسالة إعادة تعيين  كلمة المرور إلى بريدك الإلكتروني',
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
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'اعادة تعيين كلمة المرور',
              style: TextStyle(
                color: Colors.black, // Set the AppBar title text color to black
              ),
            ),
            leading: const BackButton(
              color: Colors.black,
            )),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    labelText: "البريد الإلكتروني",
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(YourStoryStyle.titleColor),
                  ),
                  onPressed: _isResettingPassword ? null : _resetPassword,
                  child: _isResettingPassword
                      ? const CircularProgressIndicator()
                      : const Text("إرسال"),
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
    );
  }
}
