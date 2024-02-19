import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/style.dart';
import 'package:your_story/pages/MyStories_page/pdf_methods.dart';

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

   void showMoreOptionsBottomSheet(BuildContext context, String docId, String pdfUrl, String title, bool status) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('حذف القصة'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the bottom sheet
                    deleteStory(docId,context);
                  }),
              ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('مشاركة القصه'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the bottom sheet
                    sharePdf(pdfUrl, title,context);
                  }),
              ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('تحميل القصة'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the bottom sheet
                    downloadAndSaveFile(pdfUrl, title, context);
                  }),
                  ListTile(
                  leading: const Icon(Icons.public),
                  title:Text(status?'ايقاف نشر القصة':'نشر القصة'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the bottom sheet
                    publishStory(docId,status,context);
                  }),
            ],
          ),
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
                final bool status = pdfData?['published'] ?? false;
                final String docId = stories[index].id;
                
              return Card(color: YourStoryStyle.backgroundColor,
                child:Center(
                child: ListTile(           
              title: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475269),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              ),
              subtitle: Row(
                  mainAxisSize: MainAxisSize.min, // This makes the Row as small as possible

                children: [
                  Container(
                  
                         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                         margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey,width: 2),
                  
                  
                              ),
                              child: Text(status?'منشوره': 'غير منشوره' , style: const TextStyle(fontSize: 9),),
                              
                      ),
                ],
              ),
                trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => showMoreOptionsBottomSheet(context, docId, pdfUrl, title,status),
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
      
  
