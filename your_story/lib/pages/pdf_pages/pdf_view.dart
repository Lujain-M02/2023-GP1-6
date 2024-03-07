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

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class ViewPDFPage extends StatelessWidget {
  final String pdfUrl;
  final String storyTitle;

  const ViewPDFPage({
    Key? key,
    required this.pdfUrl,
    required this.storyTitle,
  }) : super(key: key);

  @override
Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(storyTitle),
        ),
        body: const PDF().cachedFromUrl(
          pdfUrl,
          placeholder: (progress) => Center(child: Text('جاري التحميل: $progress %')),
          errorWidget: (error) => Center(child: Text("حصل خطأ: ${error.toString()}")),
        ),
      ),
    );
  }
}
