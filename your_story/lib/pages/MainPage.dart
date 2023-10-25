import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:your_story/pages/create_story_pages/create_story.dart';
import 'package:your_story/pages/style.dart';

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
    )
  );
  }

  Widget _buildBody(int currentIndex) {
    if (currentIndex == 0) {
      // Home Page
      return const HomePage();
    } else if (currentIndex == 1) {
      // stories Page 
      return Container(color: Colors.white);
    } else if (currentIndex == 2) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 238, 245, 255),
                title: const Text('المزيد'),
                titleTextStyle: TextStyle(
                  color: your_story_Style.titleColor,
                  fontSize: 24,
                ),
                leading: IconButton(
                  icon: Icon(Icons.menu, color: your_story_Style.titleColor),
                  onPressed: () => {},
                ),
              ),
              body: Stack(
                children:[
                    Positioned.fill(
                      child: Image.asset('assets/background3.png',
                      fit: BoxFit.cover,),
                    ),
                  Column(
                      children: [
                        const SizedBox(height: 16),
                        customListTile(
                          Icons.account_box,
                          'معلومات الحساب',
                          () {
                            // Handle the tap
                            // For example, navigate to the settings screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SettingsScreen()),
                            );
                          },
                        ),
                            customListTile(
                              Icons.info,
                              'عن تطبيق قصتك',
                              () {
                                _showCustomModalBottomSheet(context, 'عن تطبيق قصتك');
                              },
                            ),
                            customListTile(
                              Icons.mail,
                              'تواصل معنا',
                              () {
                                _showCustomModalBottomSheet(context, 'تواصل معنا');
                              },
                            ),
                            customListTile(
                              Icons.insert_drive_file,
                              'الشروط والأحكام',
                              () {
                                _showCustomModalBottomSheet(context, 'الشروط والأحكام');
                              },
                            ),
                            customListTile(
                              Icons.lock_open,
                              'سياية الخصوصية',
                              () {
                                _showCustomModalBottomSheet(context, 'سياسة الخصوصية');
                              },
                            ),
                            customListTile(
                              Icons.logout,
                              'تسجيل خروج',
                              () {
                                // Handle the sign-out logic
                              },
                            ),
                          ],
                        ),
                    ],
                ),
              ),
            );
          
        }
    return Container();
  }
}

  Widget customListTile(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(icon, color: your_story_Style.titleColor), // Customize the icon color
          title: Text(
            title,
            style: TextStyle(
              color: your_story_Style.titleColor, // Customize the title color
              fontSize: 20,
            ),
          ),
          onTap: onTap,
        ),
        const SizedBox(height: 12),
      ],
    );
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

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('معلومات الحساب'),
        ),
        body: const Center(
          child: Text('معلومات الحساب'),
        ),
      ),
    );
  }
}


 void _showCustomModalBottomSheet(BuildContext context, String text) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // Adjust the radius as needed
    ),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(
              text, 
              style:TextStyle(
                color: your_story_Style.textColor,
                fontSize: 20
              ) ,),
              // Add more widgets as needed
            ],
          ),
        ),
      );
    },
  );
}



