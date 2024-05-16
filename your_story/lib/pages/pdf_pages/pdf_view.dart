import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:your_story/pages/MainPage.dart';
import '../MyStories_page/pdf_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewPDFPage extends StatefulWidget {
  final String pdfUrl;
  final String storyTitle;
  final String userId;
  final String docId;

  const ViewPDFPage(
      {Key? key,
      required this.pdfUrl,
      required this.storyTitle,
      required this.userId,
      required this.docId})
      : super(key: key);

  @override
  _ViewPDFPageState createState() => _ViewPDFPageState();
}

class _ViewPDFPageState extends State<ViewPDFPage> {
  int currentPage = 0;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    updateViewsInFirestore(widget.docId, widget.userId);
  }

  Future<void> updateViewsInFirestore(String docId, String userId) async {
    try {
      String user = FirebaseAuth.instance.currentUser!.uid;
      if (user != userId) {
        if (userId != '') {
          if (docId != '') {
            DocumentReference userRef =
                FirebaseFirestore.instance.collection("User").doc(userId);
            CollectionReference storiesCollection = userRef.collection("Story");

            await storiesCollection.doc(docId).update({
              'views': FieldValue.increment(1),
            });

            print("Views updated successfully for document: $docId");
          }
        }
      }
    } catch (e) {
      print("Error updating views in Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 48, 96),
          leading: IconButton(
            icon: Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name ==
                  'PdfGenerationPage') {
                // Navigate to MyStoriesPage if coming from PdfGenerationPage
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => MainPage(
                            initialIndex: 1,
                          )), // Correct the destination page as per your project structure
                  (Route<dynamic> route) => false,
                );
                // If he comes from other pages
              } else if (Navigator.of(context).canPop()) {
                // If there are routes in the stack, pop the current route
                Navigator.of(context).pop();
              } else {
                // If the stack is empty, navigate to the MainPage without allowing back navigation
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
          title: Text(
            widget.storyTitle,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.shareFromSquare,
                  color: Colors.white),
              color: Colors.white,
              onPressed: () {
                sharePdf(widget.pdfUrl, widget.storyTitle, context);
              },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.download, color: Colors.white),
              color: Colors.white,
              onPressed: () {
                downloadAndSaveFile(widget.pdfUrl, widget.storyTitle, context);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            PDF(
              enableSwipe: true,
              autoSpacing: false,
              pageFling: false,
              onPageChanged: (current, total) {
                setState(() {
                  currentPage = current!;
                  totalPages = total!;
                });
              },
            ).cachedFromUrl(
              widget.pdfUrl,
              placeholder: (progress) =>
                  Center(child: Text('جاري التحميل: $progress %')),
              errorWidget: (error) =>
                  Center(child: Text("حدث خطأ: ${error.toString()}")),
            ),
            if (totalPages > 0)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'صفحة $totalPages/${currentPage + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
