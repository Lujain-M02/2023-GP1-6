import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_story/alerts.dart';

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
          child: !isLoaded
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
                  color: const Color.fromARGB(255, 187, 208, 238),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                        leading: Image.asset("assets/white.png") ,
                        title: Text("${stories[i]['title']}") ,
                        subtitle: Text("${stories[i]['content']}",maxLines: 1,),
                        trailing: IconButton(onPressed: (){
                          deleteStory(i);
                        }
                        , icon: const Icon(Icons.delete)),
                      ),
                );
              })
          ),
    );
  }
}
