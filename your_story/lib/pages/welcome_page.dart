import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/style.dart';
import 'package:your_story/pages/create_account.dart';
//import 'create_story_pages/create_story.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: your_story_Style.backgroundColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),
            FadeInRight(
              duration: const Duration(milliseconds: 100),
              child: Image.asset(
                'assets/wel.png',
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 30,
                  right: 20,
                  bottom: 40,
                ),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 22, 62, 95),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                      child: const Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'أهلا بك يا صانع القصص',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decorationThickness: BorderSide.strokeAlignCenter,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                      child: Image.asset(
                        //Padding:EdgeInsets,
                        'assets/white.png',
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const MainPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: your_story_Style.buttonColor,
                                textStyle: const TextStyle(fontSize: 20),
                                elevation: 10,
                                shadowColor: your_story_Style.buttonShadowColor,
                              ),
                              child: const Text(
                                'سجل دخولك',
                                style: TextStyle(
                                  color:
                                      Color.fromARGB(255, 1, 16, 87), // Text color
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => create_account()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: your_story_Style.buttonColor,
                                textStyle: const TextStyle(fontSize: 20),
                                elevation: 10,
                                shadowColor: your_story_Style.buttonShadowColor,
                              ),
                              child: const Text(
                                'اصنع حسابك',
                                style: TextStyle(
                                  color:
                                      Color.fromARGB(255, 1, 16, 87), // Text color
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class MainPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// /*
//       appBar: AppBar(
//         title: const Text(''),
//       ),*/

//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/background1.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               GradientButton(
//                 iconData: Icons.add,
//                 onPressed: () {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (_) => const CreateStory()),
//                   );
//                 },
//                 text: 'ابدأ بكتابة قصتك',
//               ),
//               const SizedBox(height: 60),
//               GradientButton(
//                 iconData: Icons.share, //
//                 onPressed: () {},
//                 text: 'القصص المنشورة',
//               ),
//               const SizedBox(height: 60),
//               GradientButton(
//                 iconData: Icons.edit, //
//                 onPressed: () {},
//                 text: '       مسودّة       ',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class GradientButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String text;
//   final IconData iconData; //

//   GradientButton({
//     required this.onPressed,
//     required this.text,
//     required this.iconData, //
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient:const LinearGradient(
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
//             primary: Colors
//                 .transparent, // Set the button background color to transparent
//             onPrimary: Colors.white, // Text color
//             shadowColor: Colors.lightBlueAccent, // Shadow color
//             elevation: 10, // Shadow elevation
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30),
//             ),
//             //padding: const EdgeInsets.all(5),
//             padding: const EdgeInsets.all(15.0)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(iconData, color: Colors.white), // Display the icon
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
