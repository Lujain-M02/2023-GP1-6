import 'package:flutter/material.dart';

Widget aboutAppContent() {
  return 
  Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      padding: EdgeInsets.all(16),
      child: Column(
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
