import 'package:flutter/material.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/filtering.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/illustarting.dart';
import '../../../style.dart';
import '../../../alerts.dart';
import 'global_story.dart';

class IllustRecom extends StatefulWidget {
  const IllustRecom({Key? key}) : super(key: key);

  @override
  State<IllustRecom> createState() => _SystemRecom();
}

class _SystemRecom extends State<IllustRecom> {
  int numberOfImages = globaltopsisScoresList.length;
  List<String> topClausesToIllustrate = [];

  @override
  void initState() {
    super.initState();
    topClausesToIllustrate =
        getTopClauses(globaltopsisScoresList); // Update topClausesToIllustrate
    globaltopClausesToIllustrate = topClausesToIllustrate;
  }

  List<String> getTopClauses(List<Map<String, dynamic>> data) {
    List<Map<String, dynamic>> allClausesWithScores = [];

    for (var item in data) {
      List<dynamic> clauses = List.from(item['clauses']);
      clauses.sort((a, b) => b['score'].compareTo(a['score']));
      if (clauses.isNotEmpty) {
        var clause = clauses.first;
        allClausesWithScores.add({
          'clause': clause['clause'],
          'score': clause['score'],
        });
      }
    }
    print("the array: $allClausesWithScores");
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
            'تحليل القصة',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'نتائج التحليل :',
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
                  child: numberOfImages == 1
                      ? const Text(
                          "قام النظام باقتراح العبارة التالية ليقوم بتصويرها وهي تعتبر العبارة الأهم في القصة:")
                      : numberOfImages == 2
                          ? const Text(
                              "قام النظام باقتراح العبارتين التاليتين ليقوم بتصويرهما وهما تعتبران العبارتين الأكثر أهمية في القصة:")
                          : const Text(
                              "قام النظام باقتراح العبارات التالية ليقوم بتصويرها وهم يعتبرون العبارات الأكثر أهمية في القصة:"),
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
                    icon: Icon(
                      Icons.announcement_outlined,
                      color: YourStoryStyle.s2Color,
                    ),
                  ),
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: [
                    const Text(
                        "يمكنك تغيير عدد الصور كما تريد، قم باختيار عدد الصور الذي ترغب به:"),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(201, 187, 222,
                              251), // Background color for the button area
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: DropdownButton<int>(
                            dropdownColor:
                                const Color.fromARGB(201, 187, 222, 251),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            value: numberOfImages,
                            isExpanded: true,
                            underline: Container(),
                            items: List.generate(
                              globalTotalNumberOfClauses,
                              (index) => DropdownMenuItem(
                                value: index + 1,
                                child: Text('${index + 1}'),
                              ),
                            ),
                            onChanged: (int? newValue) {
                              setState(() {
                                numberOfImages = newValue!;
                                topClausesToIllustrate =
                                    getTopClauses(globaltopsisScoresList);
                                globaltopClausesToIllustrate =
                                    topClausesToIllustrate;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: ListTile(
                    horizontalTitleGap: -5,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    leading: const Icon(
                      Icons.lightbulb,
                      color: Colors.amber,
                      size: 20,
                    ),
                    title: Text(
                      "اضغط على العبارة لمعرفة أين تقع بداخل القصة",
                      style: TextStyle(
                          fontSize: 14, color: YourStoryStyle.s2Color),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: topClausesToIllustrate
                        .map((clause) => Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(123, 187, 222, 251),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () {
                                    showCustomModalBottomSheet(
                                        context, clausesContainer(clause));
                                  },
                                  child: Text(
                                    "عبارة: ${clause.replaceAll(RegExp(r'[،ـ:\.\s]+$'), '')}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: YourStoryStyle.s2Color),
                                  ),
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
                          ConfirmationDialog.show(context,
                              "لن يمكنك التعديل على القصه لاحقا هل أنت متاكد أنك ترغب بالاستمرار؟",
                              () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => Illustration()),
                                (Route<dynamic> route) => false);
                          });
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
                          style: TextStyle(color: YourStoryStyle.primarycolor),
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

  //this method for showing the place of the clause inside the story and make the clause green color
  Widget clausesContainer(String matchingClause) {
    List<TextSpan> textSpans = [];

    for (var item in globaltopsisScoresList) {
      for (var clause in item['clauses']) {
        var textStyle = const TextStyle(color: Colors.black);
        if (clause['clause'] == matchingClause) {
          textStyle = const TextStyle(color: Colors.green);
        }
        textSpans.add(TextSpan(text: clause['clause'] + " ", style: textStyle));
      }
      textSpans.add(const TextSpan(text: "\n\n"));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            children: textSpans,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
