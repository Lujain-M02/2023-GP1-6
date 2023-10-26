import 'package:flutter/material.dart';

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

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _AccountPageState();
}

class _AccountPageState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'اسم المستخدم'),
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Please enter a username';
                  //   }
                  //   return null;
                  // },
                ),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'الاسم الكامل'),
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter your full name';
                  //   }
                  //   return null;
                  // },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'الايميل'),
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter an email';
                  //   } else if (!value.contains('@')) {
                  //     return 'Please enter a valid email address';
                  //   }
                  //   return null;
                  // },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'كلمة المرور'),
                  obscureText: true,
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Please enter a password';
                  //   }
                  //   return null;
                  // },
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
                      onPressed: (){

                    }, child: Text("تسجيل الدخول"))
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