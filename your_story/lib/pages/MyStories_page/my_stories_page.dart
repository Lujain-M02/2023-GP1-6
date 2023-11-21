// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:your_story/alerts.dart';
// import 'package:your_story/pages/create_story_pages/create_story.dart';
// import 'package:your_story/style.dart';

// class MyStories extends StatefulWidget {
//   const MyStories({super.key});

//   @override
//   State<MyStories> createState() => _MyStories();
// }

// class _MyStories extends State<MyStories> {
//   List<QueryDocumentSnapshot> stories = [];
//   final user = FirebaseAuth.instance.currentUser!.uid;
//   bool isLoaded = false; // Add a boolean variable

//   getStoried() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection("User")
//         .doc(user)
//         .collection("Stories")
//         .get();
//     stories.addAll(querySnapshot.docs);
//     setState(() {
//       isLoaded = true;
//     });
//   }

//   void deleteStory(int i) {
//     ConfirmationDialog.show(context, "عملية الحذف نهائية هل أنت متأكد؟",
//         () async {
//       try {
//         await FirebaseFirestore.instance
//             .collection("User")
//             .doc(user)
//             .collection("Stories")
//             .doc(stories[i].id)
//             .delete();

//         setState(() {
//           stories.removeAt(i); // Remove the deleted item from 'stories'
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           CustomSnackBar(
//             content: 'تم الحذف بنجاح',
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           CustomSnackBar(
//             content: ' حدث خطأ اثناء الحذف ',
//           ),
//         );
//       }

//       Navigator.pop(context); // Close the dialog
//     });
//   }

//   @override
//   void initState() {
//     getStoried();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               "قصصي",
//               style: TextStyle(fontSize: 25, color: Colors.black),
//             ),
//             centerTitle: true,
//             backgroundColor: Colors.white,
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               // Navigate to the CreateStory page when the FAB is pressed
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const CreateStory()),
//               );
//             },
//             backgroundColor: const Color.fromARGB(255, 15, 26, 107),
//             child: const Icon(Icons.add),
//           ),
//           body: !isLoaded
//               ? Center(
//                   child: CircularProgressIndicator(
//                     color: YourStoryStyle.titleColor,
//                   ),
//                 )
//               : stories.isEmpty
//                   ? const Center(
//                       child: Text(
//                         "يبدو أنه لا يوجد لديك قصص\nانتقل للصفحة الرئيسية وأبدأ صناعة قصتك الآن",
//                         textAlign: TextAlign.center,
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: stories.length,
//                       itemBuilder: (context, i) {
//                         return Container(
//                           height: 120,
//                           margin: const EdgeInsets.all(12),
//                           decoration: const BoxDecoration(
//                               color: Color.fromARGB(255, 187, 208, 238),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10))),
//                           child: Center(
//                             child: ListTile(
//                               onTap: () {
//                                 showCustomModalBottomSheet(
//                                     context,
//                                     Directionality(
//                                       textDirection: TextDirection.rtl,
//                                       child: Column(
//                                         children: [
//                                           Center(
//                                               child: Text(
//                                             stories[i]['title'],
//                                             style:
//                                                 const TextStyle(fontSize: 25),
//                                           )),
//                                           const SizedBox(
//                                             height: 8,
//                                           ),
//                                           Text(stories[i]['content'])
//                                         ],
//                                       ),
//                                     ));
//                               },
//                               leading: Image.asset("assets/white.png"),
//                               title: Text(
//                                 "${stories[i]['title']}",
//                                 style: const TextStyle(fontSize: 25),
//                               ),
//                               subtitle: Text(
//                                 "${stories[i]['content']}",
//                                 style: const TextStyle(fontSize: 20),
//                                 maxLines: 1,
//                               ),
//                               trailing: IconButton(
//                                   onPressed: () {
//                                     deleteStory(i);
//                                   },
//                                   icon: const Icon(Icons.delete)),
//                             ),
//                           ),
//                         );
//                       })),
//     ));
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          CustomSnackBar(content: 'تم الحذف بنجاح'),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(content: 'حدث خطأ اثناء الحذف'),
        );
      }
      Navigator.pop(context); // Close the dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("قصصي",
                style: TextStyle(fontSize: 25, color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CreateStory())),
            backgroundColor: const Color.fromARGB(255, 15, 26, 107),
            child: const Icon(Icons.add),
          ),
          body: StreamBuilder<List<QueryDocumentSnapshot>>(
            stream: storiesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                      color: YourStoryStyle.titleColor),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                      "يبدو أنه لا يوجد لديك قصص\nانتقل للصفحة الرئيسية وأبدأ صناعة قصتك الآن",
                      textAlign: TextAlign.center),
                );
              }
              final stories = snapshot.data!;
              return ListView.builder(
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return StoryTile(
                    story: story,
                    onDelete: () => deleteStory(story.id),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class StoryTile extends StatelessWidget {
  final QueryDocumentSnapshot story;
  final VoidCallback onDelete;

  const StoryTile({
    Key? key,
    required this.story,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 187, 208, 238),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: ListTile(
          onTap: () {
            showCustomModalBottomSheet(
                context,
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        story['title'],
                        style: const TextStyle(fontSize: 25),
                      )),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(story['content'])
                    ],
                  ),
                ));
          },
          leading: Image.asset("assets/white.png"),
          title: Text(story['title'], style: const TextStyle(fontSize: 25)),
          subtitle: Text(story['content'],
              style: const TextStyle(fontSize: 20), maxLines: 1),
          trailing:
              IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
        ),
      ),
    );
  }
}
