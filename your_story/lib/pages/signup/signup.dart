import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_story/pages/MainPage.dart';
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
     final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(child:  Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
       backgroundColor: Colors.white, 
        body: SingleChildScrollView(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: height*0.33,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top:-40,
                    height: height,
                    width: width,
                    child: FadeInUp(duration: const Duration(seconds: 1), child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/bg19.png'),//ما تطلع لان مب شفافه
                          fit: BoxFit.fill
                        )
                      ),
                    )),
                  ),
                  Positioned(
                    top: -40,
                    height: height,
                    width: width,
                    child: FadeInUp(duration: const Duration(milliseconds: 1000), child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/bg18.png'),
                          fit: BoxFit.fill
                        )
                      ),
                    )),
                  )
                ],
              ),
            ),Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child:Form(
                     key: _formKey,
                       child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                         
                         // child:ListView(
                children: <Widget>[
                  FadeInUp(duration: const Duration(milliseconds: 1500), 
                  child:Center(child:  Text("تسجيل حساب جديد", style: TextStyle( color: Color.fromRGBO(49, 39, 79, 1), fontWeight: FontWeight.bold, fontSize: 30),))),
                   SizedBox(height: height*0.003,),
                  
                  FadeInUp(duration: const Duration(milliseconds: 1700), child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Color.fromARGB(75, 135, 145, 198)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(122, 121, 194, 0.298),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                                                
                   child: TextFormField(
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
                    }),),
                    Container(
                       padding: const EdgeInsets.all(10),
                          child:TextFormField(
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
                ), ),
                Container(
                  padding: const EdgeInsets.all(10),
                          child:
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
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                          child:TextFormField(
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
                )]))),

            //autovalidateMode: AutovalidateMode.onUserInteraction,
            //
            // child: ListView(
              // children: <Widget>[
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
                
                
                
                
                SizedBox(height: height*0.01,),
                  FadeInUp(duration: const Duration(milliseconds: 1700), 
                  child:Center(child:Container( decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50), // Adjust the border radius as needed
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 27, 29, 117).withOpacity(0.2), // Shadow color
            spreadRadius: 3, 
            blurRadius: 5, 
            offset: Offset(0, 3), 
          ),
        ],
      ),

                  
               child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                    //   Form is valid, you can process the data here
                       //String username = _usernameController.text;
                       String fullName = _fullNameController.text.trim();
                       String email = _emailController.text.trim();
                       String password = _passwordController1.text.trim();

                      // You can save or process the data as needed
                      // For now, just print it
                      //print('Username: $username');
                      // print('Full Name: $fullName');
                      // print('Email: $email');
                      // print('Password: $password');

                      try {
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                          final user = FirebaseAuth.instance.currentUser!.uid;
                          final userRef = FirebaseFirestore.instance
                              .collection("User")
                              .doc(user);

                              await FirebaseFirestore.instance.collection('User').doc(user).set(({
                                'userID': user,
                                'name': fullName,
                                'email': email,
                              }));
                        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));      
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 15, 26, 107), // Background color
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(50), // Border radius
                        ),),
                  child: Text('اصنع الحساب'),
                ),)),),
                  SizedBox(height: height*0.003,),
                  FadeInUp(duration: const Duration(milliseconds: 2000), child: Center(child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("تملك حساب بالفعل؟"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        },style: TextButton.styleFrom(
                          primary: const Color.fromARGB(255, 15, 26, 107),                         ),
                        child: Text("تسجيل الدخول"))
                  ],
                )))
              ],
            ),
          ),
         )]
        )
        )
        ),
        ));
         
    
  }
}
