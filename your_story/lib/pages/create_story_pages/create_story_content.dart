import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'error_message_holder.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';
import 'package:your_story/pages/create_story_pages/custom_text_form.dart';

class CreateStoryContent extends StatefulWidget {
  const CreateStoryContent(
      {Key? key,
      required this.contentController,
      required this.title,
      required this.errorMessageHolder,
      this.initialContent})
      : super(key: key);
  final LanguageToolController contentController;
  final String title;
  final ErrorMessageHolder errorMessageHolder;
  final String? initialContent;

  @override
  _CreateStoryContentState createState() => _CreateStoryContentState();
}

class _CreateStoryContentState extends State<CreateStoryContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool attemptedNavigation = false;

  @override
  void initState() {
    super.initState();
    // Check if globalTitle is not empty, then set it to the controller's text
    if (widget.initialContent != null) {
      widget.contentController.text = widget.initialContent!;
    }
    widget.contentController.addListener(_validateContent);
    widget.errorMessageHolder.contentErrorMessage = null;
  }

  @override
  void dispose() {
    widget.contentController.removeListener(_validateContent);
    super.dispose();
  }

  void _validateContent() {
    final value = widget.contentController.text;
    final errorMessage = validateContent(value);
    setState(() {
      widget.errorMessageHolder.contentErrorMessage = errorMessage;
    });
  }

  String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      widget.errorMessageHolder.contentErrorMessage = "الرجاء إدخال نص القصة";
    } else if (!RegExp(r'^[ء-ي٠-٩،؛."!ﻻ؟\s)():\-\[\]\{\}ًٌٍَُِّْ]+$')
        .hasMatch(value)) {
      widget.errorMessageHolder.contentErrorMessage =
          "يجب أن تكون قصتك باللغة العربية فقط\n (حروف، أرقام، علامات ترقيم)";
    } else {
      widget.errorMessageHolder.contentErrorMessage = null;
    }
    return widget.errorMessageHolder.contentErrorMessage;
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
            horizontalTitleGap: -5,
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
              color: Color.fromARGB(132, 187, 222, 251),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),

        // Text Form Field
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () {
            _formKey.currentState?.validate();
          },
          onWillPop: () async {
            final form = _formKey.currentState;
            if (form != null && form.validate()) {
              // Form is valid, allow the user to leave the screen
              return true;
            } else {
              // Form is invalid, show error messages and prevent leaving
              setState(() {
                widget.errorMessageHolder.contentErrorMessage =
                    validateContent(widget.contentController.text);
              });
              return false;
            }
          },
          child: Container(
            width: double.infinity,
            child: Stack(
              children: [
                CustomLanguageToolTextField(
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: widget.contentController,
                  maxLines: null,
                  minLines: 20,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(132, 187, 222, 251),
                    hintText: "اكتب قصتك هنا وأطلق العنان لإبداعاتك!",
                    contentPadding: EdgeInsets.only(
                      left: 40,
                      bottom: 30,
                      top: 15,
                      right: 10,
                    ),
                  ),
                  // validator: validateTitle,
                ),
                if (attemptedNavigation &&
                    widget.errorMessageHolder.contentErrorMessage != null)
                  Text(
                    widget.errorMessageHolder.contentErrorMessage!,
                    style: const TextStyle(color: Colors.red),
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
                            ClipboardData? data =
                                await Clipboard.getData('text/plain');
                            if (data != null && data.text != null) {
                              widget.contentController.text = data.text!;
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
            ),
          ),
        ),
      ],
    );
  }
}
