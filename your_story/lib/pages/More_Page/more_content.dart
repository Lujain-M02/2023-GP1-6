import 'package:flutter/material.dart';

Widget aboutAppContent() {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'عن تطبيق قصتك',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Image.asset("assets/LogoDark.png"),
          const Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
          const SizedBox(height: 8),
          const Text(
            'ما هو تطبيق قصتك:',
            style: TextStyle(fontSize: 20),
          ),
          const Text(
              'تطبيق قصـTech هو تطبيق عربي يتيح لمستخدميه حرية كتابة القصص باللغة العربية وتوليد صور مدعِّمة للقصة باستخدام الذكاء الاصطناعي، كما يتيح التطبيق لمستخدميه امكانية حفظ ومشاركة القصص بصيغة PDF ويسمح بتنزيل القصص المنشورة لقراءتها على جهازهم المحمول.'),
          const SizedBox(height: 8),
          // Add more content as needed
        ],
      ),
    ),
  );
}

Widget contactUs() {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'للتواصل معنا',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'اخبرنا اذا كان لديك استفسارات أو أسئلة',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.grey,
                width: 3.0,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10)
              )
            ),
            child: ListTile(
              leading: Image.asset("assets/Xlogo.png",
                width: 30,  // Width in logical pixels
                height: 30, // Height in logical pixels
              ),
              title: const Text("@YourStory2023"),
            ),
          )
          // Add more content as needed
        ],
      ),
    ),
  );
}

Widget termsAndCondition() {
  return Directionality(
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
              'تطبيق قصـTech هو تطبيق عربي يتيح لمستخدميه حرية كتابة القصص باللغة العربية وتوليد صور مدعِّمة للقصة باستخدام الذكاء الاصطناعي.'),
          SizedBox(height: 8),
          Text(
            'تعهدات المستخدم:',
            style: TextStyle(fontSize: 20),
          ),
          Text(
              'إن دخول المستخدم إلى التطبيق واستخدامه يعتبر إقرارا منه بالموافقة على شروط الاستخدام، كما يوافق على الالتزام بكل مما يلي:'),
          Text(
              '‌أ. عدم الإدلاء بمعلومات أو بيانات خاطئة أو مظللة أو تشكل احتيالاً.\n‌ب. المحافظة على سرية بيانات الدخول للمنصة الخاصة به وعدم إتاحتها للاستخدام من قبل أشخاص آخرين.\n‌ج. عدم تقديم أو تحميل ملفات على هذه المنصة تحتوي على برمجيات ضارة أو فيروسات أو بيانات تالفة.\nد. الامتناع عن الوصول أو محاولة الوصول إلى أي بيانات أو معلومات على نحو غير مشروع.\n‌هـ. عدم استخدام أية وسيلة أو برنامج أو إجراء لاعتراض أو محاولة اعتراض التشغيل الصحيح للمنصة.\n‌‌و. عدم القيام بأي إجراء يفرض حملاً غير معقول أو كبير أو بصورة غير مناسبة على البنية التحتية للمنصة.\n‌ط. الامتناع عن نشر أو إعلان أو توزيع أو تعميم مواد أو معلومات تحتوي تشويهاً للسمعة أو انتهاكاً للقوانين أو مواد إباحية أو بذيئة أو مخالفة للتعاليم الإسلامية أو للآداب العامة من خلال المنصة، أو تضع المنصة في وضع انتهاك لأي قانون أو نظام مطبق في أي مجال.'),
        ],
      ),
    ),
  );
}

Widget privacyPolicy() {
  return Directionality(
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
          Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
          SizedBox(height: 8),
          Text(
            'خصوصية البيانات:',
            style: TextStyle(fontSize: 20),
          ),
          Text(
              'يهمنا في تطبيق قصـTech بيانات مستخدمينا ونهدف لتقديم أفضل انواع الحماية للبيانات.'),
          SizedBox(height: 8),
          Text(
            "البيانات المجموعة:",
            style: TextStyle(fontSize: 20),
          ),
          Text(
              "ونود التوضيح أن البيانات المجموعة هي ما يقوم بادخالها المستخدم عند التسجيل ولا يتم استخدامها خارج التطبيق ابدا."),
          SizedBox(height: 8),
          // Add more content as needed
        ],
      ),
    ),
  );
}
