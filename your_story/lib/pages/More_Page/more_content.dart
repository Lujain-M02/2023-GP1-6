import 'package:flutter/material.dart';
//import '../../style.dart';

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
          Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
          SizedBox(height: 8),
          Text(
            'المقدمة:',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'تطبيق قصـTech هو تطبيق عربي يتيح لمستخدميه حرية كتابة القصص باللغة العربية وتوليد صور مدعِّمة للقصة باستخدام الذكاء الاصطناعي.'
          ),
          SizedBox(height: 8),
          Text(
            'تعهدات المستخدم:',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'إن دخول المستخدم إلى التطبيق واستخدامه يعتبر إقرارا منه بالموافقة على شروط الاستخدام، كما يوافق على الالتزام بكل مما يلي:'
          ),
          Text(
            '‌أ. عدم الإدلاء بمعلومات أو بيانات خاطئة أو مظللة أو تشكل احتيالاً.\n‌ب. المحافظة على سرية بيانات الدخول للمنصة الخاصة به وعدم إتاحتها للاستخدام من قبل أشخاص آخرين.\n‌ج. عدم تقديم أو تحميل ملفات على هذه المنصة تحتوي على برمجيات ضارة أو فيروسات أو بيانات تالفة.\nد. الامتناع عن الوصول أو محاولة الوصول إلى أي بيانات أو معلومات على نحو غير مشروع.\n‌هـ. عدم استخدام أية وسيلة أو برنامج أو إجراء لاعتراض أو محاولة اعتراض التشغيل الصحيح للمنصة.\n‌‌و. عدم القيام بأي إجراء يفرض حملاً غير معقول أو كبير أو بصورة غير مناسبة على البنية التحتية للمنصة.\n‌ط. الامتناع عن نشر أو إعلان أو توزيع أو تعميم مواد أو معلومات تحتوي تشويهاً للسمعة أو انتهاكاً للقوانين أو مواد إباحية أو بذيئة أو مخالفة للتعاليم الإسلامية أو للآداب العامة من خلال المنصة، أو تضع المنصة في وضع انتهاك لأي قانون أو نظام مطبق في أي مجال.'
          ),
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
