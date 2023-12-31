import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/welcome_page.dart';
import 'package:your_story/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'user_info.dart';
import 'more_content.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'المزيد',
          ),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                customListTile(
                  FontAwesomeIcons.user,
                  'معلومات الحساب',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
                customListTile(
                  FontAwesomeIcons.circleQuestion,
                  'عن تطبيق قصتك',
                  () {
                    showCustomModalBottomSheet(context, aboutAppContent());
                  },
                ),
                customListTile(
                  FontAwesomeIcons.envelope,
                  'تواصل معنا',
                  () {
                    showCustomModalBottomSheet(context, contactUs());
                  },
                ),
                customListTile(
                  FontAwesomeIcons.file,
                  'الشروط والأحكام',
                  () {
                    showCustomModalBottomSheet(context, termsAndCondition());
                  },
                ),
                customListTile(
                  FontAwesomeIcons.penToSquare,
                  'سياسة الخصوصية',
                  () {
                    showCustomModalBottomSheet(context, privacyPolicy());
                  },
                ),
                customListTile(
                  FontAwesomeIcons.arrowRightFromBracket,
                  'تسجيل خروج',
                  () {
                    // Handle the sign-out logic
                    ConfirmationDialog.show(
                        context, "هل أنت متأكد من تسجيل الخروج؟", () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomePage()),
                          (Route<dynamic> route) =>
                              false, // this removes all routes below MainPage
                        );
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
          leading: Icon(icon, color: YourStoryStyle.titleColor),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black, 
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
