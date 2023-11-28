import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_story/pages/create_story_pages/story_save.dart';
import 'package:your_story/pages/mainpage.dart';
import 'package:your_story/pages/create_story_pages/create_story_title.dart';
import 'package:your_story/pages/create_story_pages/create_story_content.dart';
import 'package:your_story/pages/create_story_pages/create_story_final.dart';
import 'package:your_story/alerts.dart';
import 'story_clauses.dart';
import 'error_message_holder.dart';
import 'package:your_story/style.dart';

class CreateStory extends StatefulWidget {
  const CreateStory({Key? key}) : super(key: key);

  @override
  State<CreateStory> createState() => _CreateStory();
}

class _CreateStory extends State<CreateStory> {
  int _activeStepIndex = 0;
  final ErrorMessageHolder errorMessageHolder = ErrorMessageHolder();
  TextEditingController storyTitel = TextEditingController();
  TextEditingController storyContent = TextEditingController();
//this method to keep track the user steps
  stepState(int step) {
    if (_activeStepIndex > step) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

//array of steps to use it in the widget
  stepList() => [
        Step(
          title: const Text('أضف عنوانًا'),
          content: CreateStoryTitle(
            titleController: storyTitel,
            errorMessageHolder: errorMessageHolder,
          ), //this is a method from another file
          state: stepState(0),
          isActive: _activeStepIndex >= 0,
        ),
        Step(
          title: const Text('اكتب قصتك'),
          content: CreateStoryContent(
            contentController: storyContent,
            title: storyTitel.text.trim(),
            errorMessageHolder: errorMessageHolder,
          ),
          state: stepState(1),
          isActive: _activeStepIndex >= 1,
        ),
        Step(
          title: const Text('اقرا قصتك'),
          content: CreateStoryFinal(
              title: storyTitel.text.trim(), content: storyContent.text.trim()),
          state: stepState(2),
          isActive: _activeStepIndex >= 2,
        )
      ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();

        // Function to show the confirmation dialog
        void showConfirmationDialog() {
          ConfirmationDialog.show(
            context, 
            "هل أنت متأكد؟ لن يتم حفظ انجازك",
            () {
              // User confirmed
              completer.complete(true);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
                (Route<dynamic> route) => false,
              );
            }
          );
        }

        // Show the dialog
        showConfirmationDialog();

        // Wait for the user's response
        return completer.future;
      },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                color: Colors.black,
                iconSize: 27,
                icon: const Icon(Icons.close),
                onPressed: () {
                  ConfirmationDialog.show(
                      context, "هل أنت متأكد؟ لن يتم حفظ انجازك", () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                      (Route<dynamic> route) =>
                          false, // this removes all routes below MainPage
                    );
                  });
                },
              ),
              title: const Text(
                "اصنع قصتك",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              centerTitle: true,
              actions: const <Widget>[
                SizedBox(
                  width: 40,
                )
              ],
              backgroundColor: Colors.white,
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: Theme(
                      //this theme make the stepper background transparent
                      data: ThemeData(canvasColor: Colors.transparent),
                      child: Stepper(
                        type: StepperType.horizontal,
                        elevation: 0,
                        //this if statment for the circles colors
                        connectorColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return YourStoryStyle.titleColor;
                          } else if (states.contains(MaterialState.disabled)) {
                            return const Color.fromARGB(255, 187, 222, 251);
                          } else {
                            return Colors.grey; // Use the default color.
                          }
                        }),
                        // This control builder is for the buttons it return empty size box because we used other buttons
                        controlsBuilder: (context, controls) {
                          return const SizedBox(
                            height: 0,
                            width: 0,
                          );
                        },
                        // this 3 properties is for stepper widget
                        //onStepTapped: (step) =>
                        //setState(() => _activeStepIndex = step),
                        currentStep: _activeStepIndex,
                        steps: stepList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //this bar is for the buttons to move between steps on press() is the action
            bottomNavigationBar: OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 40,
                  color: YourStoryStyle.titleColor,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _activeStepIndex > 0
                      ? () {
                          //this line to disable the button in the first step and if not return back
                          setState(() {
                            _activeStepIndex -= 1;
                          });
                        }
                      : null,
                ),
                //if it's the last step a new button will apear instead of the arrow
                if (_activeStepIndex == stepList().length - 1)
                  Container(
                    margin: const EdgeInsets.all(3),
                    child: OutlinedButton(
                      onPressed: () {
                        //addStoryToCurrentUser(storyTitel.text, storyContent.text);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => StoryClauses(
                        //       storyTitle: storyTitel.text,
                        //       storyContent: storyContent.text,
                        //     ),
                        //   ),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StorySave(
                              title: storyTitel.text.trim(),
                              content: storyContent.text.trim(),
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: YourStoryStyle.titleColor,
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: YourStoryStyle.titleColor,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text("الحفظ و الاستمرار لمعالجة القصة"),
                    ),
                  )
                else
                  IconButton(
                    iconSize: 40,
                    color: YourStoryStyle.titleColor,
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _activeStepIndex != 2
                        ? () {
                            setState(
                              () {
                                if (_activeStepIndex == 0) {
                                  if (storyTitel.text == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackBar(
                                        content: "الرجاء إدخال العنوان",
                                      ),
                                    );
                                  } else if (errorMessageHolder
                                          .titleErrorMessage !=
                                      null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackBar(
                                        content:
                                            errorMessageHolder.titleErrorMessage!,
                                      ),
                                    );
                                  } else {
                                    // Check if it isn't the last step
                                    setState(
                                      () {
                                        if (_activeStepIndex <
                                            stepList().length - 1) {
                                          _activeStepIndex += 1;
                                        }
                                      },
                                    );
                                  }
                                } else if (_activeStepIndex == 1) {
                                  if (storyContent.text == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackBar(
                                        content: "الرجاء إدخال القصة",
                                      ),
                                    );
                                  } else if (errorMessageHolder
                                          .contentErrorMessage !=
                                      null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackBar(
                                        content: errorMessageHolder
                                            .contentErrorMessage!,
                                      ),
                                    );
                                  } else {
                                    // Check if it isn't the last step
                                    setState(
                                      () {
                                        if (_activeStepIndex <
                                            stepList().length - 1) {
                                          _activeStepIndex += 1;
                                        }
                                      },
                                    );
                                  }
                                }
                              },
                            );
                          }
                        : null,
                  ),
              ],
            )),
      ),
    );
  }
}

// // Function to add a story to the current user's "Stories" subcollection
// Future<void> addStoryToCurrentUser(String title, String content) async {
//   try {
//     // Get the current user
//     final User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       // Reference to the current user's document
//       DocumentReference userRef =
//           FirebaseFirestore.instance.collection("User").doc(user.uid);

//       // Create the "Stories" subcollection reference
//       CollectionReference storiesCollection = userRef.collection("Stories");

//       // Add a new story document to the subcollection
//       await storiesCollection.add({
//         'title': title,
//         'content': content,
//       });

//       print("Story added successfully!");
//     } else {
//       print("No user is currently signed in.");
//     }
//   } catch (e) {
//     print("Error adding story: $e");
//   }
// }
