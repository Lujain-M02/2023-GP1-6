import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/MyStories_page/my_stories_page.dart';
import '../create_story_pages/processing_illustarting/global_story.dart';

class PdfGenerationPage extends StatefulWidget {
  final String title;
  final String content;
  // final List<String> imageUrls;

  const PdfGenerationPage({
    Key? key,
    required this.title,
    required this.content,
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

  /*Future<Uint8List> generatePdf(String title, String content,) async {
    final Uint8List backgroundImageData = await _loadImage('assets/pdfback.png');
    final pw.MemoryImage backgroundImage = pw.MemoryImage(backgroundImageData);


    final pdf = pw.Document();
  //   final List<pw.MemoryImage> images = [];
  //    for (String url in imageUrls) {
  //   final imageBytes = await downloadImage(url);
  //   images.add(pw.MemoryImage(imageBytes));
  // }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
         build: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Stack(
            children:   [
              pw.Positioned.fill(
                child: pw.Image(backgroundImage, fit: pw.BoxFit.cover),
              ),
               pw.Directionality(
            textDirection: pw.TextDirection.rtl, 
            child: pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30), // Adjust padding as needed
                child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
              pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 50)),              
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Text(title, style: pw.TextStyle(font: customFont, fontSize: 20)),
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 10)),
                      pw.Text(content, style: pw.TextStyle(font: customFont, fontSize: 12)),
                       //for (var image in images) pw.Image(image),
                    ],
                  ),
                ),
                
              ],
                ),
              ),
          )],
          ),
        );
      },
    ),
  );
    

    return (pdf.save());
  }*/
  // Modified generatePdf method

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
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Stack(
              children: [
                pw.Positioned.fill(
                  child: pw.Image(backgroundImage, fit: pw.BoxFit.cover),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(vertical: 50)),
                        pw.Text(title,
                            style:
                                pw.TextStyle(font: customFont, fontSize: 20)),
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(vertical: 10)),
                        pw.Text(content,
                            style:
                                pw.TextStyle(font: customFont, fontSize: 12)),
                        // Add images to the PDF
                        for (var image in images)
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(vertical: 10),
                            child: pw.Image(image, width: 400, height: 300),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> generateAndUploadPdf() async {
    try {
      final pdfBytes = await generatePdf(widget.title, widget.content);
      await addPdfToCurrentUser(widget.title, pdfBytes);
     // After successful generation and upload, navigate to the "My Stories" page.
    _navigateToMyStoriesPage();
    } catch (e) {
      print("Error generating or uploading PDF: $e");
    }
  }
  
   void _navigateToMyStoriesPage() {    Navigator.of(context).pushAndRemoveUntil(
        //       MaterialPageRoute(builder: (context) => const StoriesPage()),
        //       
        //     );
    MaterialPageRoute(   builder: (context) => const MainPage(),),(Route<dynamic> route) => false,) ;  
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
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error adding story: $e");
    }
  }

  Future<Uint8List> _loadImage(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
         automaticallyImplyLeading: false,

      ),
      body: Center(
  child: Column(
    mainAxisSize: MainAxisSize.min, 
    children: [
      Lottie.asset('assets/loading.json', width: 200, height: 200),
      const SizedBox(height: 20), //  space between the Lottie animation and the text
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
    );
  }

}
