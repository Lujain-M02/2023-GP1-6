import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';
import 'package:your_story/pages/create_story_pages/custom_text_form.dart';
//import 'package:your_story/pages/create_story_pages/processing_illustarting/global_story.dart';
import 'error_message_holder.dart';
import 'dart:async';

class CreateStoryTitle extends StatefulWidget {
  const CreateStoryTitle({
    Key? key,
    required this.titleController,
    required this.errorMessageHolder,
    this.initialTitle,
  }) : super(key: key);

  final LanguageToolController titleController;
  final ErrorMessageHolder errorMessageHolder;
  final String? initialTitle;

  @override
  _CreateStoryTitleState createState() => _CreateStoryTitleState();
}

class _CreateStoryTitleState extends State<CreateStoryTitle> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StreamController<String?> _errorStreamController = StreamController<String?>();
  bool _isCheckingTitle = false;
  Timer? _titleValidationTimer;
  bool _isLoading = false;


  List<String> allTitles = [];

  Future<void> loadTitles() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    allTitles.clear();

    QuerySnapshot<Map<String, dynamic>> usersSnapshot =
        await FirebaseFirestore.instance.collection('User').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> userDoc in usersSnapshot.docs) {
      QuerySnapshot<Map<String, dynamic>> storiesSnapshot =
          await userDoc.reference.collection('Story').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> storyDoc in storiesSnapshot.docs) {
        String title = storyDoc['title'];
        allTitles.add(title);
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    print(widget.initialTitle);
  }



  Future<bool> isTitleAvailable(String title) async {
    title = title.trim();
    if (title==widget.initialTitle){
    return true;
    }
    else {
    return !allTitles.contains(title);
    }
  }

Future<void> _validateTitle() async {
  if (_titleValidationTimer != null && _titleValidationTimer!.isActive) {
    _titleValidationTimer!.cancel();
  }

  _titleValidationTimer = Timer(const Duration(milliseconds: 500), () async {
    final value = widget.titleController.text;
    setState(() {
      _isCheckingTitle = true;
    });

    bool isAvailable = await isTitleAvailable(value);
    String? errorMessage;

    if (!isAvailable) {
      errorMessage = "العنوان مستخدم بالفعل، يرجى اختيار عنوان آخر";
    } else {
      errorMessage = await validateTitle(value);
      if (!_isLoading) {
        errorMessage = null; // Set error message to null when loading is done
      }
    }

    _errorStreamController.add(errorMessage);
    setState(() {
      widget.errorMessageHolder.titleErrorMessage = errorMessage;
      _isCheckingTitle = false;
    });
  });
}



Future<String?> validateTitle(String? value) async {
  if (value == null || value.trim().isEmpty) {
    return "الرجاء إدخال العنوان";
  } else if (!RegExp(r'^[ء-ي٠-٩،؛."!ﻻ؟\s)():\-\[\]\{\}ًٌٍَُِّْ]+$').hasMatch(value)) {
    return "يجب أن يكون عنوان قصتك باللغة العربية فقط\n (حروف، أرقام، علامات ترقيم)";
  } else {
    if (_isLoading) {
      return "الرجاء الانتظار، جاري التحقق من العنوان...";
    } else {
      bool isAvailable = await isTitleAvailable(value);
      if (!isAvailable) {
        return "العنوان مستخدم بالفعل، يرجى اختيار عنوان آخر";
      }
    }
    // Clear error
    return null;
  }
}


  @override
  void initState() {
    super.initState();

    if (widget.initialTitle != null) {
      widget.titleController.text = widget.initialTitle!;
    }
    widget.titleController.addListener(_validateTitle);
    widget.errorMessageHolder.titleErrorMessage = null;

    loadTitles().then((_) {
      // Titles are loaded, trigger the UI rebuild
      if (mounted) {
        setState(() {});
        _validateTitle();
      }
    });
  }

  @override
  void dispose() {
    widget.titleController.removeListener(_validateTitle);
    _errorStreamController.close();
    _titleValidationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () {
            _formKey.currentState?.validate();
          },
          onWillPop: () async {
            final form = _formKey.currentState;
            if (form != null && form.validate()) {
              return true;
            } else if (_isCheckingTitle) {
              return false;
            } else {
              setState(() async {
                widget.errorMessageHolder.titleErrorMessage =
                    await validateTitle(widget.titleController.text);
              });
              return false;
            }
          },
          child: Container(
            child: Column(
              children: [
                // Display the text field for the title input
                CustomLanguageToolTextField(
                  controller: widget.titleController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(132, 187, 222, 251),
                    hintText: "أدخل العنوان هنا",
                    contentPadding: EdgeInsets.all(10),
                  ),
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  onChanged: (_) => _validateTitle(),
                ),
                //Display the error message if available
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