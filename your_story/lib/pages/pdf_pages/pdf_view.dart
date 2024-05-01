// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:your_story/style.dart';

// class Pdfviewerpage extends StatefulWidget {
//   final String pdfUrl;
//   final String storyTitle;

//   const Pdfviewerpage({
//     Key? key,
//     required this.pdfUrl,
//     required this.storyTitle,
//   }) : super(key: key);

//   @override
//   State<Pdfviewerpage> createState() => _Pdfviewerpage();
// }

// class _Pdfviewerpage extends State<Pdfviewerpage> {
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.storyTitle),
//         ),
//         body: Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: Theme.of(context).colorScheme.copyWith(
//                   primary: YourStoryStyle
//                       .s2Color, // Your desired color for the loading indicator
//                 ),
//           ),
//           child: SfPdfViewer.network(
//             widget.pdfUrl,
//             key: _pdfViewerKey,
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:your_story/pages/MainPage.dart';

// class ViewPDFPage extends StatelessWidget {
//   final String pdfUrl;
//   final String storyTitle;

//   const ViewPDFPage({
//     Key? key,
//     required this.pdfUrl,
//     required this.storyTitle,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               if (Navigator.of(context).canPop()) {
//                 // If there are routes in the stack, pop the current route
//                 Navigator.of(context).pop();
//               } else {
//                 // If the stack is empty, navigate to the MainPage without allowing back navigation
//                 Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (context) => MainPage()),
//                   (Route<dynamic> route) => false,
//                 );
//               }
//             },
//           ),
//           title: Text(storyTitle),
//           automaticallyImplyLeading: false,
//         ),
//         body: const PDF().cachedFromUrl(
//           pdfUrl,
//           placeholder: (progress) =>
//               Center(child: Text('جاري التحميل: $progress %')),
//           errorWidget: (error) =>
//               Center(child: Text("حصل خطأ: ${error.toString()}")),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:your_story/pages/MainPage.dart';

// class ViewPDFPage extends StatefulWidget {
//   final String pdfUrl;
//   final String storyTitle;

//   const ViewPDFPage({
//     Key? key,
//     required this.pdfUrl,
//     required this.storyTitle,
//   }) : super(key: key);

//   @override
//   _ViewPDFPageState createState() => _ViewPDFPageState();
// }

// class _ViewPDFPageState extends State<ViewPDFPage> {
//   int currentPage = 0;
//   int totalPages = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               if (Navigator.of(context).canPop()) {
//                 // If there are routes in the stack, pop the current route
//                 Navigator.of(context).pop();
//               } else {
//                 // If the stack is empty, navigate to the MainPage without allowing back navigation
//                 Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (context) => MainPage()),
//                   (Route<dynamic> route) => false,
//                 );
//               }
//             },
//           ),
//           title: Text(widget.storyTitle),
//           automaticallyImplyLeading: false,
//         ),
//         body: Stack(
//           children: [
//             PDF(
//               enableSwipe: true,
//               autoSpacing: false,
//               pageFling: false,
//               onPageChanged: (current, total) => setState(() {
//                 currentPage = current!;
//                 totalPages = total!;
//               }),
//             ).cachedFromUrl(
//               widget.pdfUrl,
//               placeholder: (progress) =>
//                   Center(child: Text('جاري التحميل: $progress %')),
//               errorWidget: (error) =>
//                   Center(child: Text("حدث خطأ: ${error.toString()}")),
//             ),
//             // Only show page numbers if total pages are greater than 0
//             if (totalPages > 0)
//               Positioned(
//                 top: 10,
//                 left: 10,
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   color: Colors.black54,
//                   child: Text(
//                     'صفحة ${currentPage + 1} من $totalPages',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/MyStories_page/my_stories_page.dart';
import '../MyStories_page/pdf_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewPDFPage extends StatefulWidget {
  final String pdfUrl;
  final String storyTitle;
  final String userId;
  final String docId;

  const ViewPDFPage({
    Key? key,
    required this.pdfUrl,
    required this.storyTitle,
    required this.userId,
    required this.docId
  }) : super(key: key);

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
     if (userId != '') {
      if(docId!= ''){
      DocumentReference userRef = FirebaseFirestore.instance.collection("User").doc(userId);
      CollectionReference storiesCollection = userRef.collection("Story");

      // Get the document snapshot to check if 'views' attribute exists
      // DocumentSnapshot docSnapshot = await storiesCollection.doc(docId).get();
    //    Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

      
    //   if (docSnapshot.exists) {
    //     // Document exists, check if 'views' attribute is present
    //     if (data != null &&data.containsKey('views')) {
    //       // 'views' attribute exists, update it
    //       await storiesCollection.doc(docId).update({
    //         'views':FieldValue.increment(1) ,
    //       });
    //       print("Views updated successfully for document: $docId");
    //     } 
    //   }}} 
    // }

    
      await storiesCollection.doc(docId).update({
        'views':FieldValue.increment(1),
      });

      print("Views updated successfully for document: $docId");
      }}}
  catch (e) {
    print("Error updating views in Firestore: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 48, 96),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
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
