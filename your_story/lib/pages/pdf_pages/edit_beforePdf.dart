import 'dart:io';
import 'package:flutter/material.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/pdf_pages/createPdf.dart';
import '../create_story_pages/processing_illustarting/global_story.dart';

class EditBeforePdf extends StatefulWidget {
  const EditBeforePdf({Key? key}) : super(key: key);

  @override
  _EditBeforePdfState createState() => _EditBeforePdfState();
}

class _EditBeforePdfState extends State<EditBeforePdf> {
  void _removeImage(int sentenceIndex, int imageIndex) {
    ConfirmationDialog.show(context, "هل أنت متأكد من أنك تريد حذف هذه الصورة؟",
        () {
      setState(() {
        sentenceImagePairs[sentenceIndex]['images'].removeAt(imageIndex);
      });
      Navigator.of(context)
          .pop(); // Close the confirmation dialog after deletion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التعديل قبل إنشاء الملف'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              globalDraftID = null;
              ConfirmationDialog.show(
                  context, "هل أنت متأكد؟ لن يتم حفظ انجازك", () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (Route<dynamic> route) => false,
                );
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sentenceImagePairs.length,
        itemBuilder: (context, index) {
          var pair = sentenceImagePairs[index];
          return ListTile(
            title: Text(pair['sentence'], textAlign: TextAlign.right),
            subtitle: Column(
              children: List.generate(
                pair['images'].length,
                (imgIndex) {
                  File imageFile = pair['images'][imgIndex];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.file(
                        imageFile,
                        fit: BoxFit.scaleDown,
                        width: MediaQuery.of(context).size.width - 40,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: const Color.fromARGB(255, 179, 36, 25)),
                        onPressed: () => _removeImage(index, imgIndex),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PdfGenerationPage()),
          );
        },
        child: Icon(Icons.picture_as_pdf),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
