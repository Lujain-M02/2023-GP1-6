import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/pages/More_Page/more_page.dart';
import 'package:your_story/pages/MyStories_Page/my_stories_page.dart';

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
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
    
      body: _buildBody(_currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("القصص المنشورة"),
            selectedColor: const Color.fromARGB(255, 1, 16, 87),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.library_books),
            title: const Text("قصصي"),
            selectedColor: const Color.fromARGB(255, 1, 16, 87),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.more_vert_sharp),
            title: const Text("المزيد"),
            selectedColor: const Color.fromARGB(255, 1, 16, 87),
          ),
        ],
      ),
    )
  );
  }

  Widget _buildBody(int currentIndex) {
    if (currentIndex == 0) {
      // Home Page
      return  const StoriesPage();
    } else if (currentIndex == 1) {
      // stories Page 
      return const MyStories();
    } else if (currentIndex == 2) {
        return MorePage();       
        }
    return Container();
  }
}

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

   Widget build(BuildContext context) {
    return Scaffold(
      
      body: const Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
           SizedBox(height: 16),
            Text(
              "سيتم نشر القصص هنا مستقبلاً",
              style: TextStyle(
                color: Color.fromARGB(255, 15, 26, 107),
                fontSize: 25,
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
