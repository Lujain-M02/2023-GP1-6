import 'package:flutter/material.dart';
import 'package:your_story/style.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 238, 245, 255),
          title: const Text('المزيد'),
          titleTextStyle: TextStyle(
            color: YourStoryStyle.titleColor,
            fontSize: 24,
          ),
          leading: IconButton(
            icon: Icon(Icons.menu, color: YourStoryStyle.titleColor),
            onPressed: () => {},
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/background3.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                customListTile(
                  Icons.account_box,
                  'معلومات الحساب',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),
                customListTile(
                  Icons.info,
                  'عن تطبيق قصتك',
                  () {
                    _showCustomModalBottomSheet(context, 'عن تطبيق قصتك');
                  },
                ),
                customListTile(
                  Icons.mail,
                  'تواصل معنا',
                  () {
                    _showCustomModalBottomSheet(context, 'تواصل معنا');
                  },
                ),
                customListTile(
                  Icons.insert_drive_file,
                  'الشروط والأحكام',
                  () {
                    _showCustomModalBottomSheet(context, 'الشروط والأحكام');
                  },
                ),
                customListTile(
                  Icons.lock_open,
                  'سياية الخصوصية',
                  () {
                    _showCustomModalBottomSheet(context, 'سياسة الخصوصية');
                  },
                ),
                customListTile(
                  Icons.logout,
                  'تسجيل خروج',
                  () {
                    // Handle the sign-out logic
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
          leading: Icon(icon, color: YourStoryStyle.titleColor), // Customize the icon color
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
        body: const Center(
          child: Text('معلومات الحساب'),
        ),
      ),
    );
  }
}

void _showCustomModalBottomSheet(BuildContext context, String text) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // Adjust the radius as needed
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
                style: TextStyle(
                  color: YourStoryStyle.textColor,
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