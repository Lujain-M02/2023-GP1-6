import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';

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
        backgroundColor: const Color.fromARGB(255, 238, 245, 255),
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
            title: const Text("الرئيسية"),
            selectedColor: const Color.fromARGB(255, 1, 16, 87),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.library_books),
            title: const Text("القصص المنشورة"),
            selectedColor: const Color.fromARGB(255, 1, 16, 87),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.more_vert_sharp),
            title: const Text("المزيد"),
            selectedColor: const Color.fromARGB(255, 1, 16, 87),
          ),
        ],
      ),
    ));
  }

  Widget _buildBody(int currentIndex) {
    if (currentIndex == 0) {
      // Home Page
      return const HomePage();
    } else if (currentIndex == 1) {
      // Search Page (White Page)
      return Container(color: Colors.white);
    } else if (currentIndex == 2) {
      // Profile Page (White Page)
      return Container(color: Colors.white);
    }
    return Container();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/back1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GradientButton(
              iconData: Icons.add,
              onPressed: () {
                // Navigate to CreateStory page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) =>  const CreateStory()),
                );
              },
              text: 'ابدأ بكتابة قصتك',
            ),
            const SizedBox(height: 60),
            GradientButton(
              iconData: Icons.share,
              onPressed: () {},
              text: 'القصص المنشورة',
            ),
            const SizedBox(height: 60),
            GradientButton(
              iconData: Icons.edit,
              onPressed: () {},
              text: 'مسودّة',
            ),
          ],
        ),
      ),
    );
  }
}

// class CreateStory extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Replace with the content of your CreateStory page
//     return Container(color: Colors.white);
//   }
// }

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData iconData;

  const GradientButton({super.key, 
    required this.onPressed,
    required this.text,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 224, 224, 243),
            Color.fromARGB(184, 4, 63, 190),
          ],
          begin: Alignment.center,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.transparent,
          shadowColor: Colors.lightBlueAccent,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: Colors.white),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 247, 246, 246),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
