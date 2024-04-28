import 'dart:io';
import 'package:flutter/material.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/pdf_pages/createPdf.dart';
import '../../style.dart';
import '../create_story_pages/processing_illustarting/filtering.dart';
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
    var clauseText = sentenceImagePairs[sentenceIndex].clauses[imageIndex].text;
    ConfirmationDialog.show(context, "هل أنت متأكد من أنك تريد حذف هذه الصورة؟",
        () {
      setState(() {
        sentenceImagePairs[sentenceIndex].clauses[imageIndex].image = null;
        globaltopClausesToIllustrate.remove(clauseText);
      });
      Navigator.of(context)
          .pop(); // Close the confirmation dialog after deletion
    });
  }

  // void _regenerateImage(int sentenceIndex, int imageIndex) async {
  //   String paragraph = sentenceImagePairs[sentenceIndex]['sentence'];
  //   String prompt = '';
  //   bool isRegenerated = true;

  //   for (var clause in globaltopClausesToIllustrate) {
  //     if (paragraph.contains(clause)) {
  //       prompt = clause + " With a different POV";
  //     }
  //   }

  //   // Show the confirmation dialog
  //   ConfirmationDialog.show(
  //     context,
  //     "هل أنت متأكد أنك تريد إعادة إنشاء الصورة؟",
  //     () async {
  //       Navigator.of(context).pop(); // Close the confirmation dialog
  //       try {
  //         IllustrationState illustrationState = IllustrationState();
  //         // int seed = illustrationState.seed + 1; // Increment the seed value by one
  //         int seed = illustrationState.seed;
  //         setState(() {
  //           isLoading = true; // Set loading state to true
  //         });
  //         File newImage = await IllustrationState.generateImage(
  //             prompt, paragraph, seed, isRegenerated);
  //         setState(() {
  //           sentenceImagePairs[sentenceIndex]['images'][imageIndex] = newImage;
  //           print(prompt + "---" + paragraph);
  //           isLoading =
  //               false; // Set loading state to false after image is regenerated
  //         });
  //       } catch (error) {
  //         // Handle error
  //         print("Error regenerating image: $error");
  //       }
  //     },
  //   );
  // }
  void _regenerateImage(int sentenceIndex, int imageIndex) async {
    String sentence = sentenceImagePairs[sentenceIndex].sentence;
    String prompt = sentenceImagePairs[sentenceIndex].clauses[imageIndex].text;
    bool isRegenerated = true;

    // Show the confirmation dialog
    ConfirmationDialog.show(
      context,
      "هل أنت متأكد أنك تريد إعادة إنشاء الصورة؟",
      () async {
        Navigator.of(context).pop(); // Close the confirmation dialog
        try {
          IllustrationState illustrationState = IllustrationState();
          int seed = illustrationState.seed;
          setState(() {
            isLoading = true; // Set loading state to true
          });
          File newImage = await IllustrationState.generateImage(
              sentence, prompt, seed, isRegenerated);
          setState(() {
            sentenceImagePairs[sentenceIndex].clauses[imageIndex].image =
                newImage;
            isLoading =
                false; // Set loading state to false after image is regenerated
          });
        } catch (error) {
          print("Error regenerating image: $error");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Sets the direction to right-to-left
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 48, 96),
          title: Text('التعديل قبل إنشاء القصة',
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Filtering(shouldPopulate: true)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                globalDraftID = null;
                ConfirmationDialog.show(
                    context, "هل أنت متأكد؟ لن يتم حفظ انجازك", () {
                  globalTitle = "";
                  globalContent = "";
                  globalTotalNumberOfClauses = 0;
                  globaltopsisScoresList = [];
                  globaltopClausesToIllustrate = [];
                  globalImagesUrls = [];
                  sentenceImagePairs = [];
                  firstImg = '';
                  globalDraftID = null;
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
        // body: isLoading
        //     ? Center(child: CircularProgressIndicator())
        //     : ListView.builder(
        //         itemCount: sentenceImagePairs.length,
        //         itemBuilder: (context, index) {
        //           var pair = sentenceImagePairs[index];
        //           // return ListTile(
        //           //   title: Text(pair['sentence'], textAlign: TextAlign.right),
        //           //   subtitle: Column(
        //           //     children: List.generate(
        //           //       pair['images'].length,
        //           //       (imgIndex) {
        //           //         File imageFile = pair['images'][imgIndex];
        //           //         return Column(
        //           //           mainAxisSize: MainAxisSize.min,
        //           //           children: [
        //           //             Image.file(
        //           //               imageFile,
        //           //               fit: BoxFit.scaleDown,
        //           //               width: MediaQuery.of(context).size.width - 40,
        //           //             ),return ListTile(
        //           var sentencePair = sentenceImagePairs[index];
        //           return ListTile(
        //             title:
        //                 Text(sentencePair.sentence, textAlign: TextAlign.right),
        //             subtitle: Column(
        //               children: List.generate(
        //                 sentencePair.clauses.length,
        //                 (clauseIndex) {
        //                   File? imageFile =
        //                       sentencePair.clauses[clauseIndex].image;
        //                   return Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: [
        //                       imageFile != null
        //                           ? Image.file(
        //                               imageFile,
        //                               fit: BoxFit.scaleDown,
        //                               width:
        //                                   MediaQuery.of(context).size.width - 40,
        //                             )
        //                           : Container(),
        //                       IconButton(
        //                         icon: Icon(Icons.delete,
        //                             color:
        //                                 const Color.fromARGB(255, 179, 36, 25)),
        //                         onPressed: () => _removeImage(index, imgIndex),
        //                       ),
        //                       IconButton(
        //                         icon: Icon(Icons.refresh, color: Colors.blue),
        //                         onPressed: () =>
        //                             _regenerateImage(index, imgIndex),
        //                       )
        //                     ],
        //                   );
        //                 },
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        // body: isLoading
        //     ? Center(child: CircularProgressIndicator())
        //     : ListView.builder(
        //         itemCount: sentenceImagePairs.length,
        //         itemBuilder: (context, index) {
        //           var sentencePair = sentenceImagePairs[index];
        //           print("Building item for: ${sentencePair}");

        //           return ListTile(
        //             title:
        //                 Text(sentencePair.sentence, textAlign: TextAlign.right),
        //             subtitle: Column(
        //               children: List.generate(
        //                 sentencePair.clauses.length,
        //                 (clauseIndex) {
        //                   File? imageFile =
        //                       sentencePair.clauses[clauseIndex].image;
        //                   return Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     children: [
        //                       imageFile != null
        //                           ? Image.file(
        //                               imageFile,
        //                               fit: BoxFit.scaleDown,
        //                               width:
        //                                   MediaQuery.of(context).size.width - 40,
        //                             )
        //                           : Container(),
        //                       IconButton(
        //                         icon: Icon(Icons.delete,
        //                             color:
        //                                 const Color.fromARGB(255, 179, 36, 25)),
        //                         onPressed: () => _removeImage(index, clauseIndex),
        //                       ),
        //                       IconButton(
        //                         icon: Icon(Icons.refresh, color: Colors.blue),
        //                         onPressed: () =>
        //                             _regenerateImage(index, clauseIndex),
        //                       )
        //                     ],
        //                   );
        //                 },
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => PdfGenerationPage()),
        //     );
        //   },
        //   child: Icon(Icons.picture_as_pdf),
        //   backgroundColor: Colors.blue,
        // ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: sentenceImagePairs.length,
                itemBuilder: (context, index) {
                  var sentencePair = sentenceImagePairs[index];
                  return ListTile(
                    title:
                        Text(sentencePair.sentence, textAlign: TextAlign.right),
                    subtitle: Column(
                      children: List.generate(
                        sentencePair.clauses.length,
                        (clauseIndex) {
                          File? imageFile =
                              sentencePair.clauses[clauseIndex].image;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Display the image if it exists
                              imageFile != null
                                  ? Image.file(
                                      imageFile,
                                      fit: BoxFit.scaleDown,
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                    )
                                  : Container(
                                      height:
                                          0), // No image, so no space allocated
                              // Show buttons only if there is an image
                              imageFile != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 179, 36, 25)),
                                          onPressed: () =>
                                              _removeImage(index, clauseIndex),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.refresh,
                                              color: Color.fromARGB(
                                                  255, 0, 48, 96)),
                                          onPressed: () => _regenerateImage(
                                              index, clauseIndex),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      height: 0), // No buttons if no image
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(YourStoryStyle.primarycolor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                )),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PdfGenerationPage()),
              );
            },
            child: Text("الاستمرار لإنشاء ملف القصة",
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
