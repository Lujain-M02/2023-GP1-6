import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';
import 'package:your_story/pages/create_story_pages/custom_text_form.dart';
import 'error_message_holder.dart';

class CreateStoryTitle extends StatefulWidget {
  const CreateStoryTitle({
    Key? key,
    required this.titleController,
    required this.errorMessageHolder,
  }) : super(key: key);

  final LanguageToolController titleController;
  final ErrorMessageHolder errorMessageHolder;

  @override
  _CreateStoryTitleState createState() => _CreateStoryTitleState();
}

class _CreateStoryTitleState extends State<CreateStoryTitle> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.titleController.addListener(_validateTitle);
    widget.errorMessageHolder.titleErrorMessage = null;
  }

  @override
  void dispose() {
    widget.titleController.removeListener(_validateTitle);
    super.dispose();
  }

  void _validateTitle() {
    final value = widget.titleController.text;
    final errorMessage = validateTitle(value);
    setState(() {
      widget.errorMessageHolder.titleErrorMessage = errorMessage;
    });
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الرجاء إدخال العنوان";
    } else if (!RegExp(r'^[ء-ي٠-٩،؛."!ﻻ؟\s)():\-\[\]\{\}ًٌٍَُِّْ]+$').hasMatch(value)) {
      return "يجب أن يكون عنوان قصتك باللغة العربية فقط\n (حروف، أرقام، علامات ترقيم)";
    } else {
      return null;
    }
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
              "أبق عنوانك قصيرًا، معبرًا وواضحًا!",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),

        // Form with onChanged and onWillPop callbacks
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
              widget.errorMessageHolder.titleErrorMessage =
                  validateTitle(widget.titleController.text);
            });
            return false;
          }
        },
          child: Container(
            child: Column(
              children: [
                CustomLanguageToolTextField(
                  controller: widget.titleController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(132, 187, 222, 251),
                    hintText: "أدخل العنوان هنا",
                    contentPadding: EdgeInsets.all(10),
                  ),
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),

                // Error message widget
                // if (widget.errorMessageHolder.titleErrorMessage != null)
                //   Text(
                //     widget.errorMessageHolder.titleErrorMessage!,
                //     style: TextStyle(color: Colors.red),
                //   ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

