import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/welcome_page.dart';
import 'package:your_story/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          // const Color.fromARGB(255, 238, 245, 255),
          title: const Text('المزيد'),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
          leading: IconButton(
            icon:
                FaIcon(FontAwesomeIcons.bars, color: YourStoryStyle.titleColor),
            onPressed: () => {},
          ),
        ),
        body: Stack(
          children: [
            // Positioned.fill(
            //   child: Image.asset(
            //     'assets/background3.png',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Column(
              children: [
                const SizedBox(height: 16),
                customListTile(
                  FontAwesomeIcons.user,
                  'معلومات الحساب',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),
                customListTile(
                  FontAwesomeIcons.circleQuestion,
                  'عن تطبيق قصتك',
                  () {
                    _showCustomModalBottomSheet(context, 'عن تطبيق قصتك');
                  },
                ),
                customListTile(
                  FontAwesomeIcons.envelope,
                  'تواصل معنا',
                  () {
                    _showCustomModalBottomSheet(context, 'تواصل معنا');
                  },
                ),
                customListTile(
                  FontAwesomeIcons.file,
                  'الشروط والأحكام',
                  () {
                    _showCustomModalBottomSheet(context, 'الشروط والأحكام');
                  },
                ),
                customListTile(
                  FontAwesomeIcons.penToSquare,
                  'سياية الخصوصية',
                  () {
                    _showCustomModalBottomSheet(context, 'سياسة الخصوصية');
                  },
                ),
                customListTile(
                  FontAwesomeIcons.arrowRightFromBracket,
                  'تسجيل خروج',
                  () {
                    // Handle the sign-out logic
                    ConfirmationDialog.show(context, "هل أنت متأكد؟", () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomePage()));
                        // The user has been successfully signed out
                      } catch (e) {
                        // Handle sign-out errors, if any
                        Alert.show(
                            context, "لا يمكنك تسجيل الخروج الآن حاول لاحقا");
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customListTile(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(icon,
              color:
                  Color.fromARGB(255, 57, 96, 130)), // Customize the icon color
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black, // Customize the title color
              fontSize: 20,
            ),
          ),
          onTap: onTap,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('معلومات الحساب'),
        ),
        body:
            ProfileUpdateForm(), // Directly embedding the ProfileUpdateForm here
      ),
    );
  }
}

void _showCustomModalBottomSheet(BuildContext context, String text) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0)), // Adjust the radius as needed
    ),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(
                text,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
              // Add more widgets as needed
            ],
          ),
        ),
      );
    },
  );
}

class ProfileUpdateForm extends StatefulWidget {
  @override
  _ProfileUpdateFormState createState() => _ProfileUpdateFormState();
}

class _ProfileUpdateFormState extends State<ProfileUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';
  String _password = '';

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      // Add your logic to save profile information here
      // For example, sending data to a server
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'الاسم'),
                onSaved: (value) => _name = value!,
                validator: (value) =>
                    value!.isEmpty ? 'الرجاء إدخال الاسم' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'الايميل'),
                onSaved: (value) => _email = value!,
                validator: (value) =>
                    !value!.contains('@') ? 'الرجاء إدخال ايميل صحيح' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'رقم الهاتف'),
                onSaved: (value) => _phone = value!,
                validator: (value) =>
                    value!.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'الرقم السري'),
                obscureText: true,
                onSaved: (value) => _password = value!,
                validator: (value) => value!.length < 6
                    ? 'الرقم السري يجب ان يحتوي على 6 احرف على الاقل'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: ProfileUpdateForm()));
