import 'package:flutter/material.dart';
import 'package:your_story/pages/mainpage.dart';
import 'package:your_story/pages/reset_password.dart';
import 'package:your_story/pages/signup/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isEnglish = true;

  void checkLanguage(String text) {
    isEnglish = text.isEmpty || text.trim().contains(RegExp(r'^[a-zA-Z0-9]+$'));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child:Scaffold(
      appBar: AppBar(
        title: Text('صفحة تسجيل الدخول'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'اسم المستخدم',
                errorText: isEnglish ? null : 'اسم المستخدم يجب ان يكون باللغة الانجليزية فقط',
              ),
              onChanged: (text) {
                setState(() {
                  checkLanguage(text);
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                errorText: isEnglish ? null : ' كلمة المرور يجب ان يكون باللغة الانجليزية فقط ولا تحتوي على مسافة',
              ),
              onChanged: (text) {
                setState(() {
                  checkLanguage(text);
                });
              },
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                 Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) =>  ResetPasswordPage()),
                                );
              },
              child: Text('نسيت كلمة المرور'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
               Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) =>  MainPage()),
                                );
              },
              child: Text('تسجيل الدخول'),
            ),
            SizedBox(height: 20),
            Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("لا تملك حساب بالفعل؟"),
                    TextButton(
                      onPressed: (){
 Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) =>  SignUp()),
                                );
                    }, child: Text("تسجيل "))
                  ],
                ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}