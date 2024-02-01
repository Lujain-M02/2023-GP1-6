import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
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

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 48, 96),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "القصص المنشورة",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 10), // space between the text and the box
            Container(
              padding: const EdgeInsets.only(
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
              child: const Text(
                "سيتم نشر القصص هنا مستقبلاً",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 15, 26, 107),
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the CreateStory Page when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateStory()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 15, 26, 107),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
   }}


