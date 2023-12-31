import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'error_message_holder.dart';

class CreateStoryContent extends StatelessWidget {
  const CreateStoryContent(
      {Key? key,
      required this.contentController,
      required this.title,
      required this.errorMessageHolder})
      : super(key: key);
  final TextEditingController contentController;
  final String title;
  final ErrorMessageHolder errorMessageHolder;

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      errorMessageHolder.contentErrorMessage = "الرجاء إدخال نص القصة";
    } else if (!RegExp(r'^[ء-ي٠-٩،؛."!ﻻ؟\s)():\-\[\]\{\}ًٌٍَُِّْ]+$')
        .hasMatch(value)) {
      errorMessageHolder.contentErrorMessage =
          "يجب أن تكون قصتك باللغة العربية فقط\n (حروف، أرقام، علامات ترقيم)";
    } else {
      errorMessageHolder.contentErrorMessage = null;
    }
    return errorMessageHolder.contentErrorMessage;
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
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: const BoxDecoration(
              color: Color.fromARGB(123, 187, 222, 251),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),

        // Text Form Field
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            child: Stack(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: contentController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(132, 187, 222, 251),
                    hintText: " اكتب قصتك هنا وأطلق العنان لإبداعاتك!",
                    contentPadding: EdgeInsets.only(
                        left: 40, bottom: 30, top: 15, right: 10),
                  ),
                  validator: validateTitle,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                   child: Center(
          child: Column(
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.paste),
                onPressed: () async {
                  ClipboardData? data = await Clipboard.getData('text/plain');
                  if (data != null && data.text != null) {
                    contentController.text = data.text!;
                  }
                },
              ),
              const Text(
                "لصق",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        ),
      ],
    )
    ))]
    
    );
  }
}
