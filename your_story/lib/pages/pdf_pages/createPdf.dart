import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/global_story.dart';
import 'package:your_story/pages/pdf_pages/pdf_view.dart';

String? firstImg;

class PdfGenerationPage extends StatefulWidget {
  const PdfGenerationPage({
    Key? key,
  }) : super(key: key);

  @override
  _PdfGenerationPageState createState() => _PdfGenerationPageState();
}

class _PdfGenerationPageState extends State<PdfGenerationPage> {
  late pw.Font customFont;

  @override
  void initState() {
    super.initState();
    _loadCustomFont().then((_) {
      // Continue with other operations after the font has loaded
      preloadImagesForPdf().then((_) {
        generateAndUploadPdf();
      });
    });
  }

  Future<void> _loadCustomFont() async {
    final fontData =
        await rootBundle.load('assets/fonts/Vazirmatn-VariableFont_wght.ttf');
    customFont = pw.Font.ttf(fontData.buffer.asByteData());
  }

  Future<Uint8List> downloadImageData(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return Uint8List.fromList(response.bodyBytes);
    } else {
      throw Exception('Failed to download image');
    }
  }

  Future<void> preloadImagesForPdf() async {
    bool isFirstImage = true;
    for (var sentencePair in sentenceImagePairs) {
      for (var clause in sentencePair.clauses) {
        if (clause.image != null && clause.imageData == null) {
          try {
            clause.imageData = await clause.image!.readAsBytes();
            if (isFirstImage) {
              isFirstImage = false;
              firstImg = await uploadImageToFirebaseStorage(clause.imageData!);
            }
          } catch (e) {
            print("Error reading image file: $e");
          }
        }
      }
    }
  }

  Future<String> uploadImageToFirebaseStorage(
    Uint8List imageFile,
  ) async {
    // Create a reference to the Firebase Storage bucket with a path that includes the story title and user ID
    final imageRef =
        FirebaseStorage.instance.ref().child("images/${globalTitle}.png");

    // Upload the file
    await imageRef.putData(imageFile);

    // Get the download URL
    String downloadUrl = await imageRef.getDownloadURL();
    return downloadUrl;
  }

  Future<Uint8List> generatePdf(String title) async {
    await _loadCustomFont();
    final pdf = pw.Document();
    final pw.MemoryImage backgroundImage =
        pw.MemoryImage(await _loadImage('assets/pdfback.png'));

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.symmetric(vertical: 100, horizontal: 40),
          theme: pw.ThemeData.withFont(base: customFont),
          buildBackground: (pw.Context context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Image(backgroundImage, fit: pw.BoxFit.cover),
          ),
        ),
        build: (pw.Context context) => [
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8.0),
            child: pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                title,
                style: pw.TextStyle(font: customFont, fontSize: 24),
                textAlign: pw.TextAlign.center,
                textDirection: pw.TextDirection.rtl,
              ),
            ),
          ),
          for (var sentencePair in sentenceImagePairs) ...[
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 10),
              child: pw.Text(
                sentencePair.sentence,
                style: pw.TextStyle(font: customFont, fontSize: 18),
                textAlign: pw.TextAlign.center,
                textDirection: pw.TextDirection.rtl,
              ),
            ),
            for (var clause in sentencePair.clauses)
              if (clause.imageData != null)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 10, bottom: 10),
                  child: pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Image(
                      pw.MemoryImage(clause.imageData!),
                      height: 300.0,
                    ),
                  ),
                ),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  Future<void> generateAndUploadPdf() async {
    try {
      final pdfBytes = await generatePdf(globalTitle);

      final String pdfUrl =
          await addPdfToCurrentUser(globalTitle, pdfBytes, firstImg!);

      // Navigate to the ViewPDFPage with the generated PDF URL
      _navigateToViewPage(pdfUrl, globalTitle);

      // After successful generation and upload, clear global variables
      clearGlobalVariables();
      // After successful generation and upload, navigate to the "My Stories" page.
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: 'تم صناعة القصة بنجاح',
          icon: Icons.check_circle,
        ),
      );
    } catch (e) {
      print("Error generating or uploading PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: 'حصل خطأ حاول مرة أخرى',
          icon: Icons.error,
        ),
      );
    }
  }

  void clearGlobalVariables() {
    globalTitle = "";
    globalContent = "";
    globalTotalNumberOfClauses = 0;
    globaltopsisScoresList = [];
    globaltopClausesToIllustrate = [];
    globalImagesUrls = [];
    sentenceImagePairs = [];
    globalDraftID = null;
    selectedImageStyle = null;
  }

  void _navigateToViewPage(String pdfUrl, String title) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewPDFPage(
            pdfUrl: pdfUrl,
            storyTitle: title,
            userId: '',
            docId: '',
          ),
          settings: RouteSettings(name: 'PdfGenerationPage'),
        ));
  }

  Future<String> uploadPdfToFirebaseStorage(
      Uint8List pdfFile, String fileName) async {
    // Create a reference to the Firebase Storage bucket
    final pdfRef = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");

    // Upload the file
    await pdfRef.putData(pdfFile);

    // Get the download URL
    String downloadUrl = await pdfRef.getDownloadURL();
    return downloadUrl;
  }

  Future<String> addPdfToCurrentUser(
    String title,
    Uint8List pdfFile,
    String firstImageFile,
  ) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection("User").doc(user.uid);
        // Upload PDF to Firebase Storage and get the download URL
        String pdfUrl = await uploadPdfToFirebaseStorage(pdfFile, title);

        // Add PDF reference to Firestore
        CollectionReference storiesCollection = userRef.collection("Story");

        if (globalDraftID != null) {
          // Draft ID exists, so update it to be illustrated
          await storiesCollection.doc(globalDraftID).update({
            'title': title,
            'type': 'illustrated',
            'published': false, // Use a boolean for published status
            'url': pdfUrl, // Store the URL
            'imageUrl': firstImageFile, // Store the image URL
          });
        } else {
          await storiesCollection.add({
            'title': title,
            'type': 'illustrated',
            'published': false, // Use a boolean for published status
            'url': pdfUrl, // Store the URL
            'imageUrl': firstImageFile, // Store the image URL
            'userId': user.uid,
            'views': 0,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        print("Story added successfully!");
        return pdfUrl; // Return the PDF URL after successful addition
      }
    } catch (e) {
      print("Error adding PDF: $e");
      throw e; // Re-throw the exception to handle it in the calling function if needed
    }
    return ''; // Return an empty string if there's an issue
  }

  Future<Uint8List> _loadImage(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

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
              // Lottie.asset('assets/loading.json', width: 200, height: 200),
              Image.asset("assets/loadingLogo.gif"),
              const SizedBox(height: 20),
              const Text(
                'من فضلك انتظر قليلا لإنتاج الملف',
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
