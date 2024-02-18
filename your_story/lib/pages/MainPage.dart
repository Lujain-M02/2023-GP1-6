import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:your_story/pages/More_Page/more_page.dart';
import 'package:your_story/pages/MyStories_Page/my_stories_page.dart';
import 'package:your_story/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_story/pages/published_stories.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}


class _MainPage extends State<MainPage> {
  late final Stream<List<QueryDocumentSnapshot>> pdfS;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
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
                  Icon(Icons.home, size: 30, color: Colors.white),
                  Icon(Icons.library_books, size: 30, color: Colors.white),
                  Icon(
                    Icons.more_vert_sharp,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
                color: const Color.fromARGB(199, 0, 29, 57),
                buttonBackgroundColor: YourStoryStyle.primarycolor,
                // You can customize the appearance more if needed
              ),
            )));
  }

  Widget _buildBody(int currentIndex) {

    if (currentIndex == 0) {
      // Home Page
      return const StoriesPage();
    } else if (currentIndex == 1) {
      // stories Page
      return const MyStories();
    } else if (currentIndex == 2) {
      return const MorePage();
    }
    return Container();
  }
}