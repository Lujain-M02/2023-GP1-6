import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_story/alerts.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

void deleteStory(String docId, BuildContext context, String storyType) {
  if (storyType == "illustrated") {
    storyType = "قصة";
  } else if (storyType == "drafted") {
    storyType = "مسودة";
  }

  ConfirmationDialog.show(
    context,
    "هل أنت متأكد من أنك تريد حذف هذه ال$storyType؟ لا يمكنك التراجع بعد ذلك.",
    () async {
      Navigator.of(context).pop();

      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection("User")
            .doc(userId)
            .collection("Story")
            .doc(docId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            content: 'تم حذف القصة بنجاح',
            icon: Icons.check_circle,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            content: 'حدث خطأ أثناء حذف ال$storyType',
            icon: Icons.error,
          ),
        );
      }
    },
  );
}

void publishStory(String docId, bool status, BuildContext context) {
  ConfirmationDialog.show(
    context,
    status
        ? 'هل أنت متأكد من إيقاف نشر القصة؟ لن يتمكن المستخدمون الآخرون من قرائتها'
        : "هل أنت متأكد من نشر القصة؟ سيتمكن جميع المستخدمون من قراءتها",
    () async {
      Navigator.of(context).pop();

      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection("User")
            .doc(userId)
            .collection("Story")
            .doc(docId)
            .update({'published': !status});
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            content: 'تم تحديث حالة القصة بنجاح',
            icon: Icons.check_circle,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            content: 'تعذر تحديث حالة القصة، حاول لاحقا',
            icon: Icons.error,
          ),
        );
      }
    },
  );
}

Future<void> sharePdf(String pdfUrl, String title, BuildContext context) async {
  try {
    final response = await http.get(Uri.parse(pdfUrl));
    final bytes = response.bodyBytes;

    // Get the temporary directory and save the PDF file
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$title.pdf');
    await file.writeAsBytes(bytes);

    // Share the local file path
    Share.shareFiles([file.path], text: 'ملف القصة: $title.pdf');
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        content: 'المعذرة، لا يمكن مشاركة القصة حاول لاحقا',
        icon: Icons.error,
      ),
    );
  }
}

// Future<void> downloadAndSaveFile(String url, String fileName, BuildContext context) async {
//   final dio = Dio();
//   final response = await dio.get(
//     url,
//     options: Options(responseType: ResponseType.bytes),
//   );
//   final bytes = response.data;

//   final downloadsDirectory = await getDownloadsDirectory();
//   final filePath = '${downloadsDirectory!.path}/$fileName.pdf';

//   File file = File(filePath);
//   await file.writeAsBytes(bytes);

//   if (file.existsSync()) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       CustomSnackBar(
//         content: 'تم تحميل القصة بنجاح',
//         icon: Icons.check_circle,
//       ),
//     );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       CustomSnackBar(
//         content: 'فشل تحميل القصة',
//         icon: Icons.error,
//       ),
//     );
//   }
// }

void downloadAndSaveFile(String url, String fileName, BuildContext context) {
  FileDownloader.downloadFile(
      url: url,
      name: fileName, //(optional)
      onDownloadCompleted: (String path) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            content: 'تم تحميل القصة بنجاح',
            icon: Icons.check_circle,
          ),
        );
      },
      onDownloadError: (String error) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            content: "فشل تحميل القصة، حاول لاحقا",
            icon: Icons.error,
          ),
        );
      });
}
