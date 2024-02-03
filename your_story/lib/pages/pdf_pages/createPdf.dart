import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/global_story.dart';

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
    _loadCustomFont();
    generateAndUploadPdf();
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

  Future<Uint8List> generatePdf(
    String title,
    String content,
  ) async {
    final Uint8List backgroundImageData =
        await _loadImage('assets/pdfback.png');
    final pw.MemoryImage backgroundImage = pw.MemoryImage(backgroundImageData);

    final pdf = pw.Document();

    // Download images from globalImagesUrls
    final List<pw.MemoryImage> images = [];
    for (String url in globalImagesUrls) {
      final imageBytes = await downloadImageData(url);
      images.add(pw.MemoryImage(imageBytes));
    }

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.symmetric(vertical: 100, horizontal: 40),
          theme: pw.ThemeData.withFont(
            base: customFont,
          ),
          buildBackground: (pw.Context context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Image(backgroundImage, fit: pw.BoxFit.cover),
          ),
        ),
        build: (pw.Context context) => [
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8.0),
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  title,
                  style: pw.TextStyle(font: customFont, fontSize: 20),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ),
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 10),
              child: pw.Text(content,
                  style: pw.TextStyle(font: customFont, fontSize: 12)),
            ),
          ),
          ...images.map((image) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Image(image, width: 200, height: 200),
              )),
        ],
      ),
    );
    return pdf.save();
  }

  Future<void> generateAndUploadPdf() async {
    try {
      final pdfBytes = await generatePdf(globalTitle, globalContent);
      await addPdfToCurrentUser(globalTitle, pdfBytes);
      // After successful generation and upload, clear global variables
      clearGlobalVariables();
      // After successful generation and upload, navigate to the "My Stories" page.
      _navigateToMyStoriesPage();
    } catch (e) {
      print("Error generating or uploading PDF: $e");
    }
  }

  void clearGlobalVariables() {
    globalTitle = "";
    globalContent = "";
    globaltopsisScoresList = [];
    globaltopClausesToIllustrate = [];
    globalImagesUrls = [];
  }

  void _navigateToMyStoriesPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainPage()),
        (Route<dynamic> route) => false);
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

  Future<void> addPdfToCurrentUser(
    String title,
    Uint8List pdfFile,
  ) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection("User").doc(user.uid);
        // Upload PDF to Firebase Storage and get the download URL
        String pdfUrl = await uploadPdfToFirebaseStorage(pdfFile, title);

        // Add PDF reference to Firestore
        CollectionReference pdfCollection = userRef.collection("pdf");

        await pdfCollection.add({
          'title': title,
          'url': pdfUrl, // Store the URL
        });

        print("Story added successfully!");
      }
    } catch (e) {
      print("Error adding PDF: $e");
    }
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
          title: Text(globalTitle),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/loading.json', width: 200, height: 200),
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
