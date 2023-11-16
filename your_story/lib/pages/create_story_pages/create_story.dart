import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            title: storyTitel.text,
            errorMessageHolder: errorMessageHolder,
          ),
          state: stepState(1),
          isActive: _activeStepIndex >= 1,
        ),
        Step(
          title: const Text('اقرا قصتك'),
          content: CreateStoryFinal(
              title: storyTitel.text, content: storyContent.text),
          state: stepState(2),
          isActive: _activeStepIndex >= 2,
        )
      ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          //backgroundColor: const Color.fromARGB(255, 238, 245, 255),
          body: Container(
            // decoration: const BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage('assets/background3.png'),
            //         fit: BoxFit.cover)),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          ConfirmationDialog.show(
                              context, "هل أنت متأكد؟ لن يتم حفظ انجازك", () {
                            // Perform your action on confirmation (e.g., navigate to MainPage)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainPage(),
                              ),
                            );
                          });
                        },
                      ),
                      const Text(
                        "اصنع قصتك",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(
                        height: 1,
                        width: 40,
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 0.5,
                    color: Color.fromARGB(255, 5, 34, 57),
                  ),
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
              if (_activeStepIndex == stepList().length - 1)
                Container(
                  margin: const EdgeInsets.all(3),
                  child: OutlinedButton(
                    onPressed: () {
                      addStoryToCurrentUser(storyTitel.text, storyContent.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryClauses(
                            storyTitle: storyTitel.text,
                            storyContent: storyContent.text,
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
                                  Alert.show(context,
                                      "الرجاء إدخال العنوان" // Customize the button text color
                                      );
                                } else if (errorMessageHolder.errorMessage !=
                                    null) {
                                  Alert.show(
                                      context,
                                      errorMessageHolder
                                          .errorMessage! // Customize the button text color
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
                                  Alert.show(context,
                                      "الرجاء إدخال القصة" // Customize the button text color
                                      );
                                } else if (errorMessageHolder.errorMessage !=
                                    null) {
                                  Alert.show(
                                      context,
                                      errorMessageHolder
                                          .errorMessage! // Customize the button text color
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
    );
  }
}

// Function to add a story to the current user's "Stories" subcollection
Future<void> addStoryToCurrentUser(String title, String content) async {
  try {
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the current user's document
      DocumentReference userRef =
          FirebaseFirestore.instance.collection("User").doc(user.uid);

      // Create the "Stories" subcollection reference
      CollectionReference storiesCollection = userRef.collection("Stories");

      // Add a new story document to the subcollection
      await storiesCollection.add({
        'title': title,
        'content': content,
      });

      print("Story added successfully!");
    } else {
      print("No user is currently signed in.");
    }
  } catch (e) {
    print("Error adding story: $e");
  }
}