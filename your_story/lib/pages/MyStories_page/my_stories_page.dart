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
      backgroundColor: const Color.fromARGB(255, 0, 48, 96),
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
              top: 30,
              right: 20,
              bottom: 20,
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
                final String docId = stories[index].id;

                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.picture_as_pdf,
                      color: Color.fromARGB(255, 31, 47, 195),
                    ),
                    title: Text(
                      title,
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                    onTap: () {
                      // Preview
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            // Share the PDF file
                            sharePdf(pdfUrl, title);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteStory(docId),
                        ),
                      ],
                    ),
                  ),
                );
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


/*

  late final String userId;
  late final Stream<List<QueryDocumentSnapshot>> storiesStream;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    storiesStream = FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Stories")
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  void deleteStory(String docId) {
    ConfirmationDialog.show(context, "عملية الحذف نهائية هل أنت متأكد؟",
        () async {
      try {
        await FirebaseFirestore.instance
            .collection("User")
            .doc(userId)
            .collection("Stories")
            .doc(docId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(content: 'تم الحذف بنجاح',icon: Icons.check_circle,),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(content: 'حدث خطأ اثناء الحذف',icon: Icons.warning,),
        );
      }
      Navigator.pop(context); // Close the dialog
    });
  }

  @override
  Widget build(BuildContext context) {*/
//  return SafeArea(
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(backgroundColor: YourStoryStyle.s2Color,
//           appBar: AppBar(
//             title: const Text("قصصي",
//                 style: TextStyle(fontSize: 24, color: Colors.white)),
//             centerTitle: true,
//             backgroundColor: YourStoryStyle.s2Color,
//             automaticallyImplyLeading: false,
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => const CreateStory())),
//             backgroundColor: const Color.fromARGB(255, 15, 26, 107),
//             child: const Icon(Icons.add,color: Colors.white,),
//           ),
//           body: StreamBuilder<List<QueryDocumentSnapshot>>(
//             stream: storiesStream,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: Lottie.asset('assets/loading2.json',width: 200,height: 200),
//                 );
//               }
//               if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return Container(padding: const EdgeInsets.only(
//                 left: 20,
//                 top: 30,
//                 right: 20,
//                 bottom: 700,
//               ),
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Color.fromARGB(255, 244, 247, 252),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(60),

//                 ),
//               ),
//                 child: Center(
//                   child: Text(
//                       "يبدو أنه لا يوجد لديك قصص\nاضغط زر الاضافة وابدأ صناعة قصتك الآن",
//                       textAlign: TextAlign.center),
//                 ));
//               }

//               //   return const Center(
//               //     child: Text(
//               //         "يبدو أنه لا يوجد لديك قصص\nاضغط زر الاضافة وابدأ صناعة قصتك الآن",
//               //         textAlign: TextAlign.center),
//               //   );
//               // }
//               final stories = snapshot.data!;
//               return Container(
//                 padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 20),
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(255, 244, 247, 252),
//                   borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
//                 ),
//                 child:
//                ListView.builder(
//                 itemCount: stories.length,
//                 itemBuilder: (context, index) {
//                   final story = stories[index];
//                   return StoryTile(
//                     story: story,
//                     onDelete: () => deleteStory(story.id),
//                   );
//                 },
//               ));
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class StoryTile extends StatelessWidget {
//   final QueryDocumentSnapshot story;
//   final VoidCallback onDelete;

//   const StoryTile({
//     Key? key,
//     required this.story,
//     required this.onDelete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String shortTitle = story['title'].length > 20
//         ? story['title'].substring(0, 17) + '...'
//         : story['title'];

//     String shortContent = story['content'].length > 20
//         ? story['content'].substring(0, 20) + '...'
//         : story['content'];

//     return Container(
//       height: 120,
//       margin: const EdgeInsets.all(12),
//       decoration: const BoxDecoration(
//         color: Color.fromARGB(255, 187, 208, 238),
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//       ),
//       child: Center(
//         child: ListTile(
//           onTap: () {
//             showCustomModalBottomSheet(
//                 context,
//                 Directionality(
//                   textDirection: TextDirection.rtl,
//                   child: Column(
//                     children: [
//                       Center(
//                         child: Text(
//                           story['title'],
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         story['content'],
//                         style: const TextStyle(fontSize: 15),
//                       ),
//                     ],
//                   ),
//                 ));
//           },
//           leading: Image.asset("assets/white.png"),
//           title: Text(
//             shortTitle,
//             style: const TextStyle(fontSize: 20),
//           ),
//           subtitle: Text(
//             shortContent,
//             style: const TextStyle(fontSize: 12),
//           ),
//           trailing:
//               IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
//         ),
//       ),
//     );

// class StoryTile extends StatelessWidget {
//   final QueryDocumentSnapshot story;
//   final VoidCallback onDelete;

//   const StoryTile({
//     Key? key,
//     required this.story,
//     required this.onDelete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       margin: const EdgeInsets.all(12),
//       decoration: const BoxDecoration(
//         color: Color.fromARGB(255, 187, 208, 238),
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//       ),
//       child: Center(
//         child: ListTile(
//           onTap: () {
//             showCustomModalBottomSheet(
//                 context,
//                 Directionality(
//                   textDirection: TextDirection.rtl,
//                   child: Column(
//                     children: [
//                       Center(
//                           child: Text(
//                         story['title'],
//                         style: const TextStyle(fontSize: 25),
//                       )),
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       Text(story['content'])
//                     ],
//                   ),
//                 ));
//           },
//           leading: Image.asset("assets/white.png"),
//           title: Text(story['title'], style: const TextStyle(fontSize: 25)),
//           subtitle: Text(story['content'],
//               style: const TextStyle(fontSize: 20), maxLines: 1),
//           trailing:
//               IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
//         ),
//       ),
//     );
//   }
// }
