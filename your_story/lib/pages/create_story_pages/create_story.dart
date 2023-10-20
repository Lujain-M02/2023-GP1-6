import 'package:flutter/material.dart';
import 'package:your_story/pages/create_story_pages/create_story_title.dart';
import 'package:your_story/pages/create_story_pages/create_story_content.dart';
import 'package:your_story/pages/create_story_pages/create_story_final.dart';
import 'package:your_story/pages/welcome_page.dart';

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
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("هل أنت متأكد؟ لن يتم حفظ انجازك"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainPage(),
                                        ),
                                      );
                                    },
                                    child: Text("متأكد"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("الغاء"),
                                  ),
                                ],
                              );
                            },
                          );
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
                        onStepTapped: (step) =>
                            setState(() => _activeStepIndex = step),
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
                onPressed: () {
                  setState(
                    () {
                      if (_activeStepIndex == 0 &&
                          (storyTitel.text == "" ||
                              (!RegExp(
                                      r'^[ء-ي\s!"٠٩٨٧٦٥٤٣٢١#\.٪$؛/\|؟؛±§<،>ًٌٍَُِّْ«»ـ&()*+,\\\-./؛<=>:?@[\]^_`{|}~]+$')
                                  .hasMatch(storyTitel.text)))) {
                        //nothing happen
                      } else if (_activeStepIndex == 1 &&
                          (storyContent.text == "" ||
                              (!RegExp(
                                      r'^[ء-ي\s!"٠٩٨٧٦٥٤٣٢١#\.٪$؛/\|؟؛±§<،>ًٌٍَُِّْ«»ـ&()*+,\\\-./؛<=>:?@[\]^_`{|}~]+$')
                                  .hasMatch(storyContent.text)))) {
                        //nothing happen
                      } else {
                        // Check if it isn't the last step
                        setState(
                          () {
                            if (_activeStepIndex < stepList().length - 1) {
                              _activeStepIndex = _activeStepIndex += 1;
                            }
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ],
          )),
    );
  }
}
