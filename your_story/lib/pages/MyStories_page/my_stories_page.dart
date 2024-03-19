import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/pages/MyStories_page/searchBox.dart';
import 'package:your_story/pages/MyStories_page/typeBar.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/style.dart';
import 'package:your_story/pages/MyStories_page/pdf_methods.dart';
import 'package:your_story/pages/pdf_pages/pdf_view.dart';
// import '../create_story_pages/processing_illustarting/global_story.dart';

class MyStories extends StatefulWidget {
  const MyStories({super.key});

  @override
  State<MyStories> createState() => _MyStoriesState();
}

class _MyStoriesState extends State<MyStories> {
  final StreamController<List<QueryDocumentSnapshot>> _storiesStreamController =
      StreamController.broadcast();
  late Stream<List<QueryDocumentSnapshot>> storiesList;
  late final String userId;
  List<QueryDocumentSnapshot> _allStories = [];

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    storiesList = _storiesStreamController.stream;
    updateStoriesList('جميع القصص');
    storiesList.listen((list) {
      _allStories = list;
    });
  }

  void updateStoriesList(String category) {
    String filter = '';
    switch (category) {
      case 'مصورة':
        filter = 'illustrated';
        break;
      case 'مسودة':
        filter = 'drafted';
        break;
      case 'جميع القصص':
      default:
        filter = '';
        break;
    }

    var collection = FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Story");
    var query = filter.isNotEmpty
        ? collection.where('type', isEqualTo: filter)
        : collection;

    query.snapshots().listen((snapshot) {
      _storiesStreamController.add(snapshot.docs);
    });
  }

  void filterStories(String searchTerm) {
    if (searchTerm.isEmpty) {
      updateStoriesList(''); // Show all stories if search term is empty
      return;
    }
    final filteredStories = _allStories.where((doc) {
    final data = doc.data() as Map<String, dynamic>?;
    final title = data?['title']?.toString().toLowerCase() ?? '';
    return title.contains(searchTerm.toLowerCase());
    }).toList();
    _storiesStreamController.add(filteredStories);
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
      body: Column(children:[
               SearchBox(onChanged: (value) {
                  setState(() {
                    filterStories(value);
                  });
                },),
                  
              storyType(onCategorySelected: updateStoriesList),
              const SizedBox(height: kDefaultPadding / 2),   
          StreamBuilder<List<QueryDocumentSnapshot>>(
          stream: storiesList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset('assets/loading_white.json',
                    width: 200, height: 200),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Expanded(
                child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  child: const Center(
                    child: Text(
                      "يبدو أنه لا يوجد لديك قصص\nاضغط زر الاضافة وابدأ صناعة قصتك الآن",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            }
          
            void showMoreOptionsBottomSheet(
                BuildContext context,
                String docId,
                String pdfUrl,
                String title,
                String content,
                bool status,
                String storyType,
                String fimg) {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return SafeArea(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Wrap(
                        children: <Widget>[                         
                          if (storyType == "drafted")...[
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('تعديل'),
                              onTap: () {
                                // globalTitle = title;
                                // globalContent = content;
                                // globalId = docId;
                                Navigator.of(context)
                                    .pop(); // Close the bottom sheet
                                // Navigate to CreateStory with initial values for editing
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateStory(
                                      initialTitle: title,
                                      initialContent: content,
                                      draftID: docId,
                                    ),
                                  ),
                                );
                              },
                            ),
                           ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('حذف القصة'),
                              onTap: () {
                                Navigator.of(context)
                                    .pop(); // Close the bottom sheet
                                deleteStory(docId, context, storyType);
                              }),],
                           if (storyType == "illustrated") ...[
                             Padding(padding: const EdgeInsets.all(10),
                            child: Row(
                             mainAxisAlignment: MainAxisAlignment.start, 
                             crossAxisAlignment: CrossAxisAlignment.center, 
                              children: <Widget>[                          
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(          
                                    imageUrl: fimg,          
                                    width: 180,           
                                    height: 180,           
                                    fit: BoxFit.cover,
                                      placeholder: (context, url) =>  Center(child: Lottie.asset('assets/loading.json',width: 200,height: 200)),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),const SizedBox(width: 8.0),
                                     Expanded(
                                          child: Text(
                                                   title, 
                                                   style: const TextStyle(
                                                   fontSize: 20,
                                                   fontWeight: FontWeight.bold,                                             
                                                  ),
                                                ),      
                                              ),  
                                  ]
                                ),
                          ),
                          ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('حذف القصة'),
                              onTap: () {
                                Navigator.of(context)
                                    .pop(); // Close the bottom sheet
                                deleteStory(docId, context, storyType);
                              }),
                            ListTile(
                                leading: const Icon(Icons.share),
                                title: const Text('مشاركة القصة'),
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(); // Close the bottom sheet
                                  sharePdf(pdfUrl, title, context);
                                }),
                            ListTile(
                                leading: const Icon(Icons.download),
                                title: const Text('تحميل القصة'),
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(); // Close the bottom sheet
                                  downloadAndSaveFile(
                                    pdfUrl,
                                    title,
                                    context,
                                  );
                                }),
                            ListTile(
                                leading: const Icon(Icons.public),
                                title: Text(
                                    status ? 'ايقاف نشر القصة' : 'نشر القصة'),
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(); // Close the bottom sheet
                                  publishStory(docId, status, context);
                                }),
                                              
                                ],
                              ],
                            ),
                          ),
                        );
                     },
                   );
                 }
          
            final stories = snapshot.data!;
            return 
              Expanded(
                  child: Stack(children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 70),
                  decoration: const BoxDecoration(
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
                      final pdfData =
                          stories[index].data() as Map<String, dynamic>?;
                      final String title = pdfData?['title'] ?? 'Untitled';
                      final String content = pdfData?['content'] ?? '';
                      final String pdfUrl = pdfData?['url'] ?? '#';
                      final String fimg = pdfData?['imageUrl'] ?? '#';
                      final bool status = pdfData?['published'] ?? false;
                      final String docId = stories[index].id;
                      final String storyType = pdfData?['type'];                      
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 2,
                        ),
                        height: 140, //140
                        child: InkWell(
                          onTap:(){
                            if(storyType=="illustrated"){     
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                               builder: (context) => ViewPDFPage(pdfUrl: pdfUrl, storyTitle: title),
                               )
                             );
                            }
                             else {
                              showMoreOptionsBottomSheet(
                                       context,
                                       docId,
                                       pdfUrl,
                                       title,
                                       content,
                                       status,
                                       storyType,
                                       fimg);
                            }                
                          } ,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                height: 116, //116
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: index.isEven
                                      ? kBlueColor
                                      : kSecondaryColor,
                                  boxShadow: const [kDefaultShadow],
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
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
                                  tag: index,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding),
                                      height: 140, //140
                                      width: 250, //180
                                      child: Stack(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/under.png",
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            top: 20,
                                            left: 82,
                                            child: fimg != "#"
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: fimg,
                                                      width: 90,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(child: Lottie.asset('assets/loading.json',width: 200,height: 200)),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        "assets/errorimg.png", // An error placeholder image
                                                        width: 45,
                                                        height: 45,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : Image.asset(
                                                    "assets/draft_under.png", // The asset image to show draft image
                                                    width: 90,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),                                          
                                          Positioned(
                                            top: 80,
                                            left: 140,
                                            child: storyType=="drafted"
                                            ? Image.asset(
                                              "assets/draft_upper.png",
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.asset(
                                              "assets/pdfupper.png",
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        ],
                                      )
          
                                      // child: Image.asset(
                                      //   "assets/pdfimg.png",
                                      //   fit: BoxFit.cover,
                                      // ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Spacer(),
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
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: kDefaultPadding * 0.4,
                                              vertical:
                                                  kDefaultPadding * 0.0007,
                                            ),
                                            decoration: const BoxDecoration(
                                              color: kSecondaryColor,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(22),
                                                topRight: Radius.circular(22),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                if(storyType=="illustrated")
                                                 Text(
                                                  status
                                                      ? 'منشوره'
                                                      : 'غير منشوره',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                  )
                                                else
                                                 Text(
                                                   "الخيارات",
                                                   style: Theme.of(context).textTheme.labelLarge,
                                                  ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.more_vert,
                                                      color: Colors.white),
                                                  onPressed: () =>
                                                      showMoreOptionsBottomSheet(
                                                          context,
                                                          docId,
                                                          pdfUrl,
                                                          title,
                                                          content,
                                                          status,
                                                          storyType,
                                                          fimg),
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
                    })
              ])            
            );
          }),
        ]
    ),
  floatingActionButton:    FloatingActionButton(
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







// class _MyStoriesState extends State<MyStories> {
//   late final String userId;
//   late final Stream<List<QueryDocumentSnapshot>> storiesList;

//   @override
//   void initState() {
//     super.initState();
//     userId = FirebaseAuth.instance.currentUser!.uid;
//     updateStoriesList('الجميع'); // Initially show all stories
//     // storiesList = FirebaseFirestore.instance
//     //     .collection("User")
//     //     .doc(userId)
//     //     .collection("Story")
//     //     .where('type', isEqualTo: 'illustrated') // Filter by type
//     //     .snapshots()
//     //     .map((snapshot) => snapshot.docs);
//   }

//   void updateStoriesList(String category) {
//     print("Updating stories list for category: $category");
//     String filter = '';
//     switch (category) {
//       case 'مصورة':
//         filter = 'illustrated';
//         break;
//       case 'غير مصورة':
//         filter = 'drafted';
//         break;
//       case 'الجميع':
//         filter = ''; // Fetch all stories without filtering
//         break;
//     }

//     setState(() {
//       if (filter.isEmpty) {
//         storiesList = FirebaseFirestore.instance
//             .collection("User")
//             .doc(userId)
//             .collection("Story")
//             .snapshots()
//             .map((snapshot) => snapshot.docs);
//       } else {
//         storiesList = FirebaseFirestore.instance
//             .collection("User")
//             .doc(userId)
//             .collection("Story")
//             .where('type', isEqualTo: filter) // Apply filter based on type
//             .snapshots()
//             .map((snapshot) => snapshot.docs);
//       }
//     });
//   }

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
      
  
