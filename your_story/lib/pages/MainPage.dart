import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:your_story/pages/More_Page/more_page.dart';
import 'package:your_story/pages/MyStories_Page/my_stories_page.dart';
import 'package:your_story/style.dart';
import 'package:your_story/pages/published_stories.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;
  MainPage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

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
              Icon(Icons.more_vert_sharp, size: 30, color: Colors.white),
            ],
            color: const Color.fromARGB(199, 0, 29, 57),
            buttonBackgroundColor: YourStoryStyle.primarycolor,
          ),
        ),
      ),
    );
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
