import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/pages/More_Page/more_page.dart';
import 'package:your_story/pages/MyStories_Page/my_stories_page.dart';
import 'package:your_story/style.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(textDirection: TextDirection.rtl, child: Scaffold(
    
      body: _buildBody(_currentIndex),
       bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <Widget>[
          Icon(Icons.home, size: 30,color: Colors.white),
          Icon(Icons.library_books, size: 30,color: Colors.white),
          Icon(Icons.more_vert_sharp, size: 30 , color: Colors.white,),
        ],
        color: const Color.fromARGB(199, 0, 29, 57),
        buttonBackgroundColor:YourStoryStyle.primarycolor,
        // You can customize the appearance more if needed
      ),
    )));
  }
       
  }

  Widget _buildBody(int currentIndex) {
    if (currentIndex == 0) {
      // Home Page
      return  const StoriesPage();
    } else if (currentIndex == 1) {
      // stories Page 
      return const MyStories();
    } else if (currentIndex == 2) {
        return const MorePage();       
        }
    return Container();
  }

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  late final String userId;
  late final Stream<List<QueryDocumentSnapshot>> pdfS;

  @override

   // futurePdfs = fetchUserPdfs();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
            title: const Text( "القصص المنشورة",
                style: TextStyle(fontSize: 24, color: Colors.white)),
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
                  child: Lottie.asset('assets/loading2.json',width: 200,height: 200),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(padding: const EdgeInsets.only(
                left: 20,
                top: 30,
                right: 20,
                bottom: 700, 
              ),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 244, 247, 252),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  
                ),
              ),
                child: Center(
                  child: Text(
                      "يبدو أنه لا يوجد لديك قصص\nاضغط زر الاضافة وابدأ صناعة قصتك الآن",
                      textAlign: TextAlign.center),
                ));
              }
                  
              final stories = snapshot.data!;
              return Container(
                padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 20),
                decoration: const BoxDecoration(
                   color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child:
               ListView.builder(
                itemCount: stories.length,
  itemBuilder: (context, index) {
    final pdfData = stories[index].data() as Map<String, dynamic>?;
    final String title = pdfData?['title'] ?? 'Untitled';
    // ignore: unused_local_variable
    final String pdfUrl = pdfData?['url'] ?? '#';



    return Card(
      child: ListTile(
        leading: Icon(Icons.picture_as_pdf, color: Colors.red), // PDF Icon
        title: Text(title, style: TextStyle(color: Colors.black)),
        onTap: () {
          //تنزيل الملف 
        },
      ),
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