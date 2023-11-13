import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';

class MyStories extends StatefulWidget {
  const MyStories({super.key});

  @override
  State<MyStories> createState() => _MyStories();
}

class _MyStories extends State<MyStories> {
  List<QueryDocumentSnapshot> stories = [];
  final user = FirebaseAuth.instance.currentUser!.uid;
    bool isLoaded = false; // Add a boolean variable

  getStoried() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("User")
        .doc(user)
        .collection("Stories")
        .get();
    stories.addAll(querySnapshot.docs);
    setState(() {
      isLoaded = true;
    });

  }

  deleteStory(int i){
    ConfirmationDialog.show(context, "عملية الحذف نهائية هل أنت متأكد؟", ()async{
       await FirebaseFirestore.instance
        .collection("User")
        .doc(user)
        .collection("Stories").doc(stories[i].id).delete();
            setState(() {
      stories.removeAt(i); // Remove the deleted item from 'stories'
    });
    Navigator.pop(context); // Close the dialog
    });


  }

  @override
  void initState() {
    getStoried();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigate to the CreateStory page when the FAB is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateStory()),
              );
            },
            backgroundColor: Color.fromARGB(255, 15, 26, 107),
            child: Icon(Icons.add),
          ),
            body:!isLoaded
          ? const Center(
                child: CircularProgressIndicator(), // or any loading widget
          )
          : stories.isEmpty
          ? const Center(
            child: Text(
                  "يبدو أنه لا يوجد لديك قصص\nانتقل للصفحة الرئيسية وأبدأ صناعة قصتك الآن",
                  textAlign: TextAlign.center,
                ),
          )
          : ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, i) {
                return Container(
                  height: 120,
                  margin: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 187, 208, 238) ,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Center(
                    child: ListTile(
                          leading: Image.asset("assets/white.png") ,
                          title: Text("${stories[i]['title']}",style: TextStyle(fontSize: 25),) ,
                          subtitle: Text("${stories[i]['content']}" ,style: TextStyle(fontSize: 20),maxLines: 1,),
                          trailing: IconButton(onPressed: (){
                            deleteStory(i);
                          }
                          , icon: const Icon(Icons.delete)),
                        ),
                  ),
                );
              })
          ),
    ));
  }
}
