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
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:your_story/pages/MainPage.dart';
import '../MyStories_page/pdf_methods.dart';

class ViewPDFPage extends StatefulWidget {
  final String pdfUrl;
  final String storyTitle;

  const ViewPDFPage({
    Key? key,
    required this.pdfUrl,
    required this.storyTitle,
  }) : super(key: key);

  @override
  _ViewPDFPageState createState() => _ViewPDFPageState();
}

class _ViewPDFPageState extends State<ViewPDFPage> {
  int currentPage = 0;
  int totalPages = 0;

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
              if (Navigator.of(context).canPop()) {
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
              icon: Icon(Icons.share),
              color: Colors.white,
              onPressed: () {
                sharePdf(widget.pdfUrl, widget.storyTitle, context);
              },
            ),
            IconButton(
              icon: Icon(Icons.download),
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
