import 'package:flutter/material.dart';
import 'package:your_story/pages/login%20page/login.dart';

// class create_account extends StatelessWidget {
//   const create_account({Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(

//       ),
//     );
//   }
// }

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  //final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  bool isPasswordObscured1 = true;
  bool isPasswordObscured2 = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Account'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: ListView(
              children: <Widget>[
                // TextFormField(
                //   controller: _usernameController,
                //   decoration: InputDecoration(labelText: 'اسم المستخدم',
                //   prefixIcon: Icon(Icons.person_outlined),
                //   ),
                //   // validator: (value) {
                //   //   if (value.isEmpty) {
                //   //     return 'Please enter a username';
                //   //   }
                //   //   return null;
                //   // },
                // ),
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'الاسم',
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          _fullNameController.text.trim() == "") {
                        return "الحقل مطلوب";
                      } else if (value.length == 1) {
                        return " يجب أن يحتوي الاسم أكثر من حرف على الأقل";
                      } else if (!RegExp(
                              r"^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+(?:\s[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+)?$")
                          .hasMatch(value)) {
                        return 'أدخل اسم يحتوي على أحرف فقط';
                      }
                      return null;
                    }),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'الايميل',
                      prefixIcon: Icon(Icons.email_outlined)),
                  validator: (value) {
                    if (value!.isEmpty || _emailController.text.trim() == "") {
                      return "الحقل مطلوب";
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'أدخل بريد إلكتروني صالح';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController1,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordObscured1
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordObscured1 = !isPasswordObscured1;
                        });
                      },
                    ),
                  ),
                  obscureText: isPasswordObscured1,
                  validator: (value) {
                          RegExp regex = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])'); //Min 1 uppercase, 1 lowercase and 1 numeric number
                          if (value!.isEmpty || _passwordController1.text.trim() == "") {
                            return "الحقل مطلوب";
                          } else if (!regex.hasMatch(value)) {
                            return"كلمة المرور يجب ان تحتوي على حرف كبير وصغير باللغة الانجليزية ورقم";
                          } else if (value.length < 8) {
                            return "كلمة المرور يجب أن تكون ثمانية خانات على الأقل";
                          }
                          return null;
                        },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController2,
                  decoration: InputDecoration(
                      labelText: 'ادخل كلمة المرور مرة اخرى',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordObscured2
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordObscured2 = !isPasswordObscured2;
                        });
                      },
                    ),
                      ),
                  obscureText: isPasswordObscured2,
                  validator: (value) {
                          if (value!.isEmpty || _passwordController2.text.trim() == "") {
                            return "الحقل مطلوب";
                          } else if (_passwordController2.text.trim() != _passwordController1.text.trim()) {
                            return"يجب أن تكون كلمة المرور مطابقة";
                          }
                          return null;
                        },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState.validate()) {
                    //   // Form is valid, you can process the data here
                    //   String username = _usernameController.text;
                    //   String fullName = _fullNameController.text;
                    //   String email = _emailController.text;
                    //   String password = _passwordController.text;

                    //   // You can save or process the data as needed
                    //   // For now, just print it
                    //   print('Username: $username');
                    //   print('Full Name: $fullName');
                    //   print('Email: $email');
                    //   print('Password: $password');
                    // }
                  },
                  child: Text('اصنع الحساب'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("تملك حساب بالفعل؟"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        },
                        child: Text("تسجيل الدخول"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
