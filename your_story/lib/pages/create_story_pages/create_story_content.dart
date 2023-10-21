import 'package:flutter/material.dart';

class CreateStoryContent extends StatelessWidget {
  const CreateStoryContent(
      {Key? key, required this.contentController, required this.title})
      : super(key: key);
  final TextEditingController contentController;
  final String title;

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الرجاء إدخال نص القصة";
    } else if (!RegExp(
            r'^[ء-ي\s!"٠٩٨٧٦٥٤٣٢١#\.٪$؛/\|؟؛±§<،>ًٌٍَُِّْ«»ـ&()*+,\\\.-…/؛<=>:?@[\]^_`{|}~]+$')
        .hasMatch(value)) {
      return "القصة يجب أن تكون باللغة العربية فقط";
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
              "حاول أن تكون كتابتك واضحة وصحيحة!",
              style: TextStyle(fontSize: 14),
            ),
          ),
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
