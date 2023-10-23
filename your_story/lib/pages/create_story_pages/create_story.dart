import 'package:flutter/material.dart';
import 'package:your_story/pages/MainPage.dart';
import 'package:your_story/pages/create_story_pages/create_story_title.dart';
import 'package:your_story/pages/create_story_pages/create_story_content.dart';
import 'package:your_story/pages/create_story_pages/create_story_final.dart';
import 'package:your_story/pages/alerts.dart';

class CreateStory extends StatefulWidget {
  const CreateStory({Key? key}) : super(key: key);

  @override
  State<CreateStory> createState() => _CreateStory();
}

class _CreateStory extends State<CreateStory> {
  int _activeStepIndex = 0;
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
              titleController: storyTitel), //this is a method from another file
          state: stepState(0),
          isActive: _activeStepIndex >= 0,
        ),
        Step(
          title: const Text('اكتب قصتك'),
          content: CreateStoryContent(
              contentController: storyContent, title: storyTitel.text),
          state: stepState(1),
          isActive: _activeStepIndex >= 1,
        ),
        Step(
          title: const Text('معالجة قصتك'),
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
          backgroundColor: const Color.fromARGB(255, 238, 245, 255),
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background3.png'),
                    fit: BoxFit.cover)),
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
                                builder: (context) => MainPage(),
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
                            return const Color.fromARGB(255, 5, 34, 57);
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
                color: const Color.fromARGB(255, 9, 37, 59),
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
              IconButton(
                iconSize: 40,
                color: const Color.fromARGB(255, 9, 37, 59),
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
                              } else if (!RegExp(
                                      r'^[ء-ي\s!"٠٩٨٧٦٥٤٣٢١#\.٪$؛/\|؟؛±§<،…>ًٌٍَُِّْ«»ـ&()*+,\\\-./ﻻ؛<=>:?@[\]^_`{|}~]+$')
                                  .hasMatch(storyTitel.text)) {
                                Alert.show(context,
                                    "يجب أن يكون العنوان بالعربية" // Customize the button text color
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
                              } else if (!RegExp(
                                      r'^[ء-ي\s!"٠٩٨٧٦٥٤٣٢١#\.٪$؛/\|؟؛±§<،…>ًٌٍَُِّْ«»ـ&()*+,\\\-./ﻻ؛<=>:?@[\]^_`{|}~]+$')
                                  .hasMatch(storyContent.text)) {
                                Alert.show(context,
                                    "يجب أن تكون القصة بالعربية" // Customize the button text color
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

class Alert {
  static void show(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: const Color.fromARGB(201, 232, 242, 255),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(content),
                const SizedBox(height: 20), // Adjust as needed for spacing
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 5, 34, 57), // Button background color
                  ),
                  child: const Text(
                    "حسنا",
                    style: TextStyle(
                      color: Colors.white, // Button text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
