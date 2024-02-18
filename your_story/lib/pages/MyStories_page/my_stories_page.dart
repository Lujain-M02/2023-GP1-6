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
  late final Stream<List<QueryDocumentSnapshot>> storiesList;
  

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    storiesList = FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Story")
        .where('type', isEqualTo: 'illustrated') // Filter by type
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
      // ignore: use_build_context_synchronously
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

  final downloadsDirectory = await getDownloadsDirectory();
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
        stream: storiesList,
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

   void showMoreOptionsBottomSheet(BuildContext context, String docId, String pdfUrl, String title) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  deleteStory(docId);
                }),
            ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  sharePdf(pdfUrl, title);
                }),
            ListTile(
                leading: Icon(Icons.download),
                title: Text('Download'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  downloadAndSaveFile(pdfUrl, title, context);
                }),
          ],
        ),
      );
    },
  );
}


          final stories = snapshot.data!;
           return Container(
            padding: const EdgeInsets.only(
              left: 20,
              top: 30,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
            ),
            child: ListView.builder(
                  itemCount: stories.length,
              itemBuilder: (context, index) {
                final pdfData = stories[index].data() as Map<String, dynamic>?;
                final String title = pdfData?['title'] ?? 'Untitled';
                final String pdfUrl = pdfData?['url'] ?? '#';
                final bool published = pdfData?['published'] ?? false;
                final String docId = stories[index].id;
                
              return Card(color: YourStoryStyle.backgroundColor,
                child:Center(
                child: ListTile(           
              title: Row(
                children: [
                  Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475269),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                     margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey,width: 2),
              
              
            ),
            child: Text(published?'منشوره': 'غير منشوره' , style: TextStyle(fontSize: 9),),
            
                  )
                ],
              ),
                trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => showMoreOptionsBottomSheet(context, docId, pdfUrl, title),
               ),
              )
              )
            );
            },
          ));
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
      
  
