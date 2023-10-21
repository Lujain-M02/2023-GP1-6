import 'package:flutter/material.dart';

class CreateStoryTitle extends StatelessWidget {
  const CreateStoryTitle({Key? key, required this.titleController})
      : super(key: key);

  final TextEditingController titleController;

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الرجاء إدخال العنوان";
    } else if (!RegExp(
            r'^[ء-ي\s!"٠٩٨٧٦٥٤٣٢١#\.٪$؛/\|؟؛±§<،…>ًٌٍَُِّْ«»ـ&()*+,\\\-./؛<=>:?@[\]^_`{|}~]+$')
        .hasMatch(value)) {
      return "العنوان يجب أن يكون عنوان قصتك باللغة العربية فقط";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hint Card
        const Card(
          color: Colors.transparent,
          elevation: 0,
          child: ListTile(
            horizontalTitleGap: -15,
            contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
            leading: Icon(
              Icons.lightbulb,
              color: Colors.amber,
              size: 20,
            ),
            title: Text(
              "أبق عنوانك قصيرًا، معبرًا وواضحًا!",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),

        // Text Form Field
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            /* decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),*/
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: titleController,

              //maxLines: null, // This allows multiple lines for long text
              decoration: const InputDecoration(
                filled: true,
                //fillColor: Color.fromARGB(132, 102, 112, 120),
                fillColor: Color.fromARGB(132, 187, 222, 251),
                //labelText: "أدخل العنوان هنا",
                hintText: "أدخل العنوان هنا",
                contentPadding: EdgeInsets.all(10),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              validator: validateTitle,
            ),
          ),
        ),
      ],
    );
  }
}
