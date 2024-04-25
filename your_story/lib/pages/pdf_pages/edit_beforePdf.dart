import 'dart:io';
import 'package:flutter/material.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/pdf_pages/createPdf.dart';
import '../create_story_pages/processing_illustarting/global_story.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/illustarting.dart';


class EditBeforePdf extends StatefulWidget {
  const EditBeforePdf({Key? key}) : super(key: key);

  @override
  _EditBeforePdfState createState() => _EditBeforePdfState();
}

class _EditBeforePdfState extends State<EditBeforePdf> {

  bool isLoading = false; 


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
  
void _regenerateImage(int sentenceIndex, int imageIndex) async {

  String paragraph = sentenceImagePairs[sentenceIndex]['sentence'];
  String prompt = '';
  bool isRegenerated= true;

  for (var clause in globaltopClausesToIllustrate) {
    if (paragraph.contains(clause)) {
      prompt = clause+" With a different POV";
    }
  }

  // Show the confirmation dialog
  ConfirmationDialog.show(
    context,
    "هل أنت متأكد أنك تريد إعادة إنشاء الصورة؟",
    () async {
            Navigator.of(context)
          .pop(); // Close the confirmation dialog 
      try {
        IllustrationState illustrationState = IllustrationState();
        // int seed = illustrationState.seed + 1; // Increment the seed value by one
        int seed = illustrationState.seed;
        setState(() {
          isLoading = true; // Set loading state to true
        });
        File newImage =
            await IllustrationState.generateImage(prompt, paragraph,seed, isRegenerated);
        setState(() {
          sentenceImagePairs[sentenceIndex]['images'][imageIndex] = newImage;
          print(prompt + "---" + paragraph);
          isLoading = false; // Set loading state to false after image is regenerated
        });
      } catch (error) {
        // Handle error
        print("Error regenerating image: $error");
      }
    },
  );
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
      body:isLoading?
      Center(child: CircularProgressIndicator() ): ListView.builder(
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
                      IconButton(
                      icon: Icon(Icons.refresh,
                          color: Colors.blue),
                      onPressed: () => _regenerateImage(index, imgIndex),)
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
