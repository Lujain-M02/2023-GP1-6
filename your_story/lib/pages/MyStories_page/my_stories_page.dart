import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; 
import 'package:share/share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/style.dart';
import 'package:dio/dio.dart';

class MyStories extends StatefulWidget {
  const MyStories({super.key});

  @override
  State<MyStories> createState() => _MyStoriesState();
}

class _MyStoriesState extends State<MyStories> {
  late final String userId;
  late final Stream<List<QueryDocumentSnapshot>> pdfS;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    pdfS = FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("pdf")
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  void deleteStory(String docId) {
    ConfirmationDialog.show(
      context,
      "هل أنت متأكد من أنك تريد حذف هذه القصة؟ لا يمكنك التراجع بعد ذلك.",
      () async {
        Navigator.of(context).pop();

        try {
          await FirebaseFirestore.instance
              .collection("User")
              .doc(userId)
              .collection("pdf")
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
              content: 'حدث خطأ أثناء حذف القصة: $e',
              icon: Icons.error,
            ),
          );
        }
      },
    );
  }

  Future<void> sharePdf(String pdfUrl, String title) async {
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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('خطأ'),
          content: Text('لا يمكن مشاركة الملف: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('حسنًا'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> downloadAndSaveFile(String url, String fileName, BuildContext context) async {
    final dio = Dio();
    final response = await dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data;

    final downloadsDirectory = await getExternalStorageDirectory();
    final filePath = '${downloadsDirectory!.path}/$fileName.pdf';

    File file = File(filePath);
    await file.writeAsBytes(bytes);

    if (file.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: 'تم تحميل القصة بنجاح',
          icon: Icons.check_circle,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: 'فشل تحميل القصة',
          icon: Icons.error,
        ),
      );
    }
  }

  Widget _buildPdfCard(String title, String pdfUrl, String docId, int index) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF5F9FD),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF475269).withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // preview
              },
                  child: Image.asset( 
                  "assets/6.png",                                  
                ),
              ),
            ),
        
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475269),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.share, color: Color.fromARGB(255, 5, 0, 58)),
                  onPressed: () => sharePdf(pdfUrl, title),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.delete,),
                  onPressed: () => deleteStory(docId),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.arrow_downward,),
                  onPressed: () => downloadAndSaveFile(pdfUrl, title, context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "قصصي",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: YourStoryStyle.s2Color,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: YourStoryStyle.s2Color,
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: pdfS,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset('assets/loading2.json', width: 200, height: 200),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              padding: const EdgeInsets.only(
                left: 20,
                top: 30,
                right: 20,
              ),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 244, 247, 252),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),
              child: const Center(
                child: Text(
                  "يبدو أنه لا يوجد لديك قصص\nاضغط زر الاضافة وابدأ صناعة قصتك الآن",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final stories = snapshot.data!;
          
          return Container(
            padding: const EdgeInsets.only(
                left: 20,               
                right: 20,
              ),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 244, 247, 252),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
              ),

            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.68,
              ),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final pdfData = stories[index].data() as Map<String, dynamic>?;
                final String title = pdfData?['title'] ?? 'Untitled';
                final String pdfUrl = pdfData?['url'] ?? '#';
                final String docId = stories[index].id;
            
                return _buildPdfCard(title, pdfUrl, docId, index);
              },
            ),
          );
              },
            ),
          
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateStory()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 15, 26, 107),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

