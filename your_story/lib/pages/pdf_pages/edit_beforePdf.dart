import 'dart:io';
import 'package:flutter/material.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/error.dart';
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
  Set<String> selectedIndices = {};

  void toggleSelection(String key) {
    if (selectedIndices.contains(key)) {
      selectedIndices.remove(key);
    } else {
      selectedIndices.add(key);
    }
    setState(() {});
  }

  void executeAction(String choice) {
    switch (choice) {
      case 'Select All':
        sentenceImagePairs.asMap().forEach((index, sentencePair) {
          sentencePair.clauses.asMap().forEach((clauseIndex, clause) {
            if (clause.image != null) {
              selectedIndices.add("$index" + "_" + "$clauseIndex");
            }
          });
        });
        showSnackBar('تم تحديد جميع الصور');
        break;
      case 'Deselect All':
        selectedIndices.clear();
        showSnackBar('تم إلغاء تحديد جميع الصور');
        break;
      case 'Delete':
      case 'Regenerate':
        if (selectedIndices.isEmpty) {
          showSnackBar('يجب اختيار صورة على الأقل');
        } else {
          String confirmationMessage = choice == 'Delete'
              ? "هل أنت متأكد من أنك تريد حذف الصورة / الصور المختارة؟"
              : "هل أنت متأكد أنك تريد إعادة إنشاء الصورة / الصور المختارة؟";

          ConfirmationDialog.show(context, confirmationMessage, () {
            processBulkActions(choice);
          });
        }
        break;
    }
    setState(() {});
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(content: message, icon: Icons.info_outline));
  }

  void processBulkActions(String choice) async {
    if (selectedIndices.isEmpty) {
      showSnackBar('يجب اختيار صورة على الأقل');
      return;
    }

    Navigator.pop(context); // To close the confirmationMessage
    // Show the loading dialog once before starting the bulk operations
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return const LoadingScreen(
            loadingMessage: "يتم إعادة إنشاء جميع الصور المحددة");
      },
    );

    try {
      List<Future> tasks = [];
      // Iterate over each selected item and prepare the tasks
      for (var key in selectedIndices.toList()) {
        var parts = key.split('_');
        var index = int.parse(parts[0]);
        var clauseIndex = int.parse(parts[1]);

        if (choice == 'Delete') {
          _removeImage(index, clauseIndex, bulkAction: true);
        } else if (choice == 'Regenerate') {
          tasks.add(_regenerateImage(index, clauseIndex, bulkAction: true));
        }
      }

      // Wait for all regeneration tasks to complete
      await Future.wait(tasks);

      if (choice == 'Delete') showSnackBar('تم حذف جميع الصور المختارة بنجاح');
    } catch (e) {
      showSnackBar('حدث خطأ أثناء العملية');
    } finally {
      Navigator.of(context).pop();
      selectedIndices.clear();

      setState(() {});
    }
  }

  void _removeImage(int sentenceIndex, int imageIndex,
      {bool bulkAction = false}) {
    void remove() {
      setState(() {
        if (sentenceImagePairs[sentenceIndex].clauses.length > imageIndex) {
          var clauseText =
              sentenceImagePairs[sentenceIndex].clauses[imageIndex].text;
          sentenceImagePairs[sentenceIndex].clauses[imageIndex].image = null;
          globaltopClausesToIllustrate.remove(clauseText);
        } else {
          showSnackBar('حدث خطأ أثناء حذف الصورة');
        }
      });
      if (!bulkAction) {
        showSnackBar('تم حذف الصورة بنجاح');
      }
    }

    if (!bulkAction) {
      // Individual deletion confirmation dialog
      ConfirmationDialog.show(
          context, "هل أنت متأكد من أنك تريد حذف هذه الصورة؟", () {
        remove();
        Navigator.of(context).pop();
      });
    } else {
      // Bulk deletion
      remove();
    }
  }

  Future<void> _regenerateImage(int index, int clauseIndex,
      {bool bulkAction = false}) async {
    Future<void> regenerate() async {
      try {
        if (!bulkAction) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return LoadingScreen(loadingMessage: "يتم إعادة إنشاء الصورة");
            },
          );
        } else if (bulkAction) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return LoadingScreen(
                  loadingMessage: "يتم إعادة إنشاء جميع الصور المحددة");
            },
          );
        }

        File newImage = await IllustrationState.generateImage(
            sentenceImagePairs[index].sentence,
            sentenceImagePairs[index].clauses[clauseIndex].text,
            IllustrationState().seed,
            true);
        setState(() {
          sentenceImagePairs[index].clauses[clauseIndex].image = newImage;
        });
        Navigator.of(context).pop();
      } catch (e) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const ErrorPage(
                errorMessage:
                    "حدث خطأ أثناء إعادة إنتاج الصورة، يرجى إعادة المحاولة لاحقًا")));
      }
    }

    if (!bulkAction) {
      ConfirmationDialog.show(
          context, "هل أنت متأكد من أنك تريد إعادة إنشاء هذه الصورة؟", () {
        Navigator.of(context).pop();
        regenerate();
      });
    } else {
      regenerate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: YourStoryStyle.primarycolor,
          leading: IconButton(
            color: Colors.black,
            iconSize: 27,
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              globalTitle = "";
              globalContent = "";
              globalTotalNumberOfClauses = 0;
              globaltopsisScoresList = [];
              globaltopClausesToIllustrate = [];
              globalImagesUrls = [];
              sentenceImagePairs = [];
              globalDraftID = null;
              selectedImageStyle = null;
              ConfirmationDialog.show(context, "هل أنت متأكد؟ لن يتم حفظ قصتك",
                  () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (Route<dynamic> route) =>
                      false, // this removes all routes below MainPage
                );
              });
            },
          ),
          title: const Text('التعديل قبل إنشاء القصة',
              style: TextStyle(color: Colors.white)),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : buildListView(),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildBottomAppBar(),
          ],
        ),
      ),
    );
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: sentenceImagePairs.length,
      itemBuilder: (context, index) {
        var sentencePair = sentenceImagePairs[index];
        return ListTile(
          title: Text(sentencePair.sentence, textAlign: TextAlign.right),
          subtitle: buildImageRow(sentencePair, index),
        );
      },
    );
  }

  Widget buildBottomAppBar() {
    bool anySelected = selectedIndices.isNotEmpty;

    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(anySelected ? Icons.deselect : Icons.select_all,
                color: YourStoryStyle.primarycolor),
            onPressed: () =>
                executeAction(anySelected ? 'Deselect All' : 'Select All'),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: YourStoryStyle.primarycolor),
            onPressed: () => executeAction('Delete'),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: YourStoryStyle.primarycolor),
            onPressed: () => executeAction('Regenerate'),
          ),
          IconButton(
              icon: Icon(Icons.add_photo_alternate,
                  color: YourStoryStyle.primarycolor),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Filtering(
                          shouldPopulate: true,
                          comingFromEditBeforePdf: true)))),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(YourStoryStyle.primarycolor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
            ),
            onPressed: confirmAndContinue,
            child:
                Text("إنشاء ملف القصة", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void confirmAndContinue() {
    bool hasImage = false;

    // Check for any image
    for (var sentencePair in sentenceImagePairs) {
      for (var clause in sentencePair.clauses) {
        if (clause.image != null) {
          hasImage = true;
          break;
        }
      }
      if (hasImage) {
        break;
      }
    }

    // No image is found
    if (!hasImage) {
      showSnackBar('يجب أن تحتوي قصتك على صورة واحدة على الأقل');
      return;
    }

    // Continue if there is at least one image
    ConfirmationDialog.show(context,
        "هل أنت متأكد من أنك تريد إنشاء ملف القصة، لن يمكنك التعديل بعد ذلك",
        () async {
      Navigator.of(context).pop(); // Close the confirmation dialog
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PdfGenerationPage()));
    });
  }

  Widget buildImageRow(SentencePair sentencePair, int index) {
    return Column(
      children: List.generate(
        sentencePair.clauses.length,
        (clauseIndex) {
          var clause = sentencePair.clauses[clauseIndex];
          File? imageFile = clause.image;
          String key = "$index" + "_" + "$clauseIndex";
          return imageFile != null
              ? buildImageWidget(imageFile, key, index, clauseIndex)
              : Container();
        },
      ),
    );
  }

  Widget buildImageWidget(
      File? imageFile, String key, int index, int clauseIndex) {
    return Row(
      children: [
        Expanded(
          child: imageFile != null ? Image.file(imageFile) : Container(),
        ),
        Checkbox(
          value: selectedIndices.contains(key),
          onChanged: (bool? value) {
            toggleSelection(key);
          },
        ),
      ],
    );
  }
}

class LoadingScreen extends StatelessWidget {
  final String loadingMessage;

  const LoadingScreen({
    Key? key,
    this.loadingMessage = "معالجة ...",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(globalTitle),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/loadingLogo.gif"),
              const SizedBox(height: 20),
              const Text(
                'من فضلك انتظر قليلا لإعادة إنشاء جميع الصور المختارة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
