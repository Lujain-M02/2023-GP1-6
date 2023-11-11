import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/pages/more_page.dart';
import 'package:your_story/style.dart';
import 'package:your_story/pages/my_stories_page.dart';

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
        // const Color.fromARGB(255, 238, 245, 255),
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

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              size: 80,
              color: Color.fromARGB(255, 15, 26, 107),
            ),
            SizedBox(height: 16),
            Text(
              "المعذرة، لم يتم نشر أي قصة حتى الآن",
              style: TextStyle(
                color: Color.fromARGB(255, 15, 26, 107),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the CreateStoryPage when the button is pressed
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

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("assets/back1.png"),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             GradientButton(
//               iconData: Icons.add,
//               onPressed: () {
//                 // Navigate to CreateStory page
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (_) =>  const CreateStory()),
//                 );
//               },
//               text: 'ابدأ بكتابة قصتك',
//             ),
//             const SizedBox(height: 60),
//             GradientButton(
//               iconData: Icons.share,
//               onPressed: () {},
//               text: 'القصص المنشورة',
//             ),
//             const SizedBox(height: 60),
//             GradientButton(
//               iconData: Icons.edit,
//               onPressed: () {},
//               text: 'مسودّة',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GradientButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String text;
//   final IconData iconData;

//   const GradientButton({super.key, 
//     required this.onPressed,
//     required this.text,
//     required this.iconData,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [
//             Color.fromARGB(255, 224, 224, 243),
//             Color.fromARGB(184, 4, 63, 190),
//           ],
//           begin: Alignment.center,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.white, backgroundColor: Colors.transparent,
//           shadowColor: Colors.lightBlueAccent,
//           elevation: 10,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           padding: const EdgeInsets.all(15.0),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(iconData, color: Colors.white),
//             const SizedBox(width: 15),
//             Text(
//               text,
//               style: const TextStyle(
//                 fontSize: 30,
//                 color: Color.fromARGB(255, 247, 246, 246),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
