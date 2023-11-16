import 'package:flutter/material.dart';
import 'error_message_holder.dart';

class CreateStoryContent extends StatelessWidget {
  const CreateStoryContent(
      {Key? key, required this.contentController, required this.title,required this.errorMessageHolder})
      : super(key: key);
  final TextEditingController contentController;
  final String title;
  final ErrorMessageHolder errorMessageHolder;

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      errorMessageHolder.errorMessage= "الرجاء إدخال نص القصة";
    } else if (!RegExp(
            r'^[ء-ي\s!"٠٩٨٧٦٥٤٣٢١#\.٪$؛/\|؟؛±§<،…>ًٌٍَُِّْ«»ـ&()*+,\\\-./ﻻ؛<=>:?@[\]^_`{|}~]+$')
        .hasMatch(value)) {
      errorMessageHolder.errorMessage= "القصة يجب أن تكون باللغة العربية فقط";
    }else{
      errorMessageHolder.errorMessage=null;
    }
    return errorMessageHolder.errorMessage;
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
              "حاول أن تكون كتابتك واضحة وصحيحة!",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        Container(
            height: 50,
            width: 350,
            decoration: const BoxDecoration(
              color: Color.fromARGB(123, 187, 222, 251),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, color: Colors.black ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

        /*Form(
          autovalidateMode: AutovalidateMode.always,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 17, 53, 70)
                      .withOpacity(0.5), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 2), // Offset of the shadow
                ),
              ],
            ),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              controller: contentController,
              maxLines: null, // This allows multiple lines for long text
              decoration: const InputDecoration(
                labelText: "أطلق العنان لإبداعاتك!",
                contentPadding: EdgeInsets.all(10),
              ),
              validator: validateTitle,
            ),
          ),
        ),*/

        // Text Form Field
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            //child: Container(
            /*decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),*/
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: contentController,
              maxLines: null, // This allows multiple lines for long text
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(132, 187, 222, 251),
                hintText: " اكتب قصتك هنا وأطلق العنان لإبداعاتك!",
                //labelText: "أطلق العنان لإبداعاتك!",
                //labelStyle: TextStyle(color: Color.fromARGB(255, 108, 26, 17)),
                contentPadding: EdgeInsets.all(10),
              ),
              validator: validateTitle,
            ),
            //),
          ),
        ),
      ],
    );
  }
}
