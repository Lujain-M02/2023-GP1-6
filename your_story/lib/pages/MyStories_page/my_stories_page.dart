import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/pages/MyStories_page/searchBox.dart';
import 'package:your_story/pages/MyStories_page/typeBar.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/style.dart';
import 'package:your_story/pages/MyStories_page/pdf_methods.dart';
import 'package:your_story/pages/pdf_pages/pdf_view.dart';

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
        Size size = MediaQuery.of(context).size;

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
                  ListTile(
                  leading: const Icon(Icons.remove_red_eye),
                  title: const Text('قراءة'),
                  onTap: () {
                 Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Pdfviewerpage(pdfUrl:pdfUrl,storyTitle:title)),
                    );
               }),
            ],
          ),
        ),
      );
    },
  );
}


          final stories = snapshot.data!;
          return Column(
         children: <Widget>[
          SearchBox(onChanged: (value) {}, ),
          storyType(),
          SizedBox(height: kDefaultPadding / 2),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 70),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                final pdfData = stories[index].data() as Map<String, dynamic>?;
                final String title = pdfData?['title'] ?? 'Untitled';
                final String pdfUrl = pdfData?['url'] ?? '#';
                final bool status = pdfData?['published'] ?? false;
                final String docId = stories[index].id;
                return Container(
                margin: EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding / 2,
                ),
                   height: 160,
               child: InkWell(
                 child: Stack(
                   alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        height: 136,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: index.isEven ? kBlueColor : kSecondaryColor,
                        boxShadow: [kDefaultShadow],
                         ),
              child: Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            // PDF image
            Positioned(
              top: 0,
              right: 0,
              child: Hero(
               tag:index,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  height: 160,
                  width: 200,
                  child: Image.asset(
                    "assets/pdfimg.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // card title and type of PDF
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 136,
                width: size.width - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Text(
                        title,
                        style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475269),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              
                        // style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 0.5, 
                            vertical: kDefaultPadding / 6, 
                          ),
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(22),
                              topRight: Radius.circular(22),
                            ),
                          ),
                          child: Row(
                children: [
                  Text(
                     status?'منشوره': 'غير منشوره' ,
                     style: Theme.of(context).textTheme.labelLarge,
                        ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),                    
                    onPressed: () => showMoreOptionsBottomSheet(context, docId, pdfUrl, title,status),
                  ),
                ],
                          
                          ),
                    )
                    ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
                );
        }
            )
            ]
          )
          )
          ]
          );
  }
  ),
                );
              }}








    //         padding: const EdgeInsets.only(
    //           left: 20,
    //           top: 30,
    //           right: 20,
    //         ),
    //         decoration: const BoxDecoration(
    //           color: Color.fromARGB(255, 255, 255, 255),
    //           borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
    //         ),
    //         child: ListView.builder(
    //               itemCount: stories.length,
    //           itemBuilder: (context, index) {
    //             final pdfData = stories[index].data() as Map<String, dynamic>?;
    //             final String title = pdfData?['title'] ?? 'Untitled';
    //             final String pdfUrl = pdfData?['url'] ?? '#';
    //             final bool status = pdfData?['published'] ?? false;
    //             final String docId = stories[index].id;
                
    //           return Card(color: YourStoryStyle.backgroundColor,
    //             child:Center(
    //             child: ListTile(           
    //           title: Text(
    //           title,
    //           style: const TextStyle(
    //             fontSize: 20,
    //             fontWeight: FontWeight.bold,
    //             color: Color(0xFF475269),
    //           ),
    //           maxLines: 1,
    //           overflow: TextOverflow.ellipsis,
    //           ),
    //           subtitle: Row(
    //               mainAxisSize: MainAxisSize.min, // This makes the Row as small as possible

    //             children: [
    //               Container(
                  
    //                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    //                      margin: const EdgeInsets.all(6),
    //                           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10),
    //               border: Border.all(color: Colors.grey,width: 2),
                  
                  
    //                           ),
    //                           child: Text(status?'منشوره': 'غير منشوره' , style: const TextStyle(fontSize: 9),),
                              
    //                   ),
    //             ],
    //           ),
    //             trailing: IconButton(
    //             icon: const Icon(Icons.more_vert),
    //             onPressed: () => showMoreOptionsBottomSheet(context, docId, pdfUrl, title,status),
    //            ),
    //            onTap: () {
    //              Navigator.push(
    //                   context,
    //                   MaterialPageRoute(builder: (context) => Pdfviewerpage(pdfUrl:pdfUrl,storyTitle:title)),
    //                 );
    //            },
    //           )
    //           )
    //         );
    //         },
    //       ));
    //     },
    //   ),    
          
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => const CreateStory()),
    //       );
    //     },
    //     backgroundColor: const Color.fromARGB(255, 15, 26, 107),
    //     child: const Icon(Icons.add, color: Colors.white),
    //   ),
    // );
    //     }
    //     }
      
  
