import 'package:flutter/material.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/filtering.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/illustarting.dart';
import '../../../style.dart';
import '../../../alerts.dart';
import 'global_story.dart';

class SystemRecom extends StatefulWidget {
  const SystemRecom({Key? key}) : super(key: key);

  @override
  State<SystemRecom> createState() => _SystemRecom();
}

class _SystemRecom extends State<SystemRecom> {
  bool isChoosing = false;
  int numberOfImages = globaltopsisScoresList.length;
  List<String> topClausesToIllustrate = [];

  void _showNumberPickerDialog(BuildContext context) {
    NumberPickerAlertDialog.show(context,
        ' رجاء قم باختيار عدد الصور الذي ترغب به في قصتك',
        (selectedNumber) {
      numberOfImages = selectedNumber!;
      // print('Selected number: $selectedNumber');
      // print('NumberOfImages: $NumberOfImages');
      setState(() {
        isChoosing = false; // Set loading to false when the request completes
        topClausesToIllustrate = getTopClauses(
            globaltopsisScoresList); // Update topClausesToIllustrate
        globaltopClausesToIllustrate = topClausesToIllustrate;
      });
    }, globalTotalNumberOfClauses,globaltopsisScoresList.length);
  }

  @override
  void initState() {
    super.initState();
    isChoosing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNumberPickerDialog(context);
    });
  }

  List<String> getTopClauses(List<Map<String, dynamic>> data) {
    // Create a list to store clauses and their scores
    List<Map<String, dynamic>> allClausesWithScores = [];

    // Extract clauses and their scores
    for (var item in data) {
      List<dynamic> clauses = item['clauses'];
      for (var clause in clauses) {
        allClausesWithScores.add({
          'clause': clause['clause'],
          'score': clause['score'],
        });
      }
    }

    // Sort the list by score in descending order
    allClausesWithScores.sort((a, b) => b['score'].compareTo(a['score']));

    // Get the top two clauses (without scores) if available
    return allClausesWithScores
        .take(numberOfImages)
        .map((item) => item['clause'].toString())
        .toList();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'معالجة القصة',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: isChoosing
            ? const Center()
            : SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'نتائج المعالجة :',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                            "قام النظام باقتراح الـ $numberOfImages عبارات التاليه ليقوم بتصويرها "),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton.icon(
                            onPressed: () {
                              Alert.show(context,
                                  "في قصتك نقوم بتقييم أجزاء القصة بمعايير مختلفة مثل: المشاعر، أهمية الأسماء في الجملة، مدى اختلاف الجملة، والمزيد.");
                            },
                            label: Text(
                              "معرفة معايير التقييم",
                              style: TextStyle(color: YourStoryStyle.s2Color),
                            ),
                            icon: Icon(Icons.announcement_outlined,color: YourStoryStyle.s2Color,),
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: topClausesToIllustrate
                              .map((clause) => Container(
                                    decoration: const BoxDecoration(
                                        color: Color.fromARGB(123, 187, 222, 251),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(
                                        bottom:
                                            10), // Adds space between containers
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          8.0), // Padding inside each container for the text
                                      child: Text(
                                        "عبارة: ${clause.replaceAll(RegExp(r'[،ـ:\.\s]+$'), '')}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      YourStoryStyle.primarycolor),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  )),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Illustration(),
                                  ),
                                );
                              },
                              child: const Text(
                                "الاستمرار مع مقترحات النظام",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: BorderSide(
                                          color: YourStoryStyle
                                              .primarycolor), // Set border color and width
                                    ),
                                  )),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Filtering(),
                                  ),
                                );
                              },
                              child: Text(
                                "الاختيار يدويا",
                                style:
                                    TextStyle(color: YourStoryStyle.primarycolor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ),
      ),
    );
  }
}
