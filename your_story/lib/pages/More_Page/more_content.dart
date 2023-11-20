import 'package:flutter/material.dart';

Widget aboutAppContent() {
  return 
  Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'عن تطبيق قصتك',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'هنا يمكنك إضافة معلومات حول التطبيق...',
            style: TextStyle(fontSize: 18),
          ),
          // Add more content as needed
        ],
      ),
    ),
  );
}

Widget contactUs() {
  return 
  Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'للتواصل معنا',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'هنا يمكنك إضافة معلومات حول التطبيق...',
            style: TextStyle(fontSize: 18),
          ),
          // Add more content as needed
        ],
      ),
    ),
  );
}

Widget termsAndCondition() {
  return 
  Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'الشروط والأحكام',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'هنا يمكنك إضافة معلومات حول التطبيق...',
            style: TextStyle(fontSize: 18),
          ),
          // Add more content as needed
        ],
      ),
    ),
  );
}

Widget privacyPolicy() {
  return 
  Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'سياسة الخصوصية',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'هنا يمكنك إضافة معلومات حول التطبيق...',
            style: TextStyle(fontSize: 18),
          ),
          // Add more content as needed
        ],
      ),
    ),
  );
}
