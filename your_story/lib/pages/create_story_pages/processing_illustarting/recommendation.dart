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
  List<Map<String, dynamic>> recommendedClauses = [];

  @override
  void initState() {
    super.initState();
    populateSentenceImagePairs();

    recommendedClauses = getSelectedClauses(
        globaltopsisScoresList); // Update topClausesToIllustrate
  }

  void populateSentenceImagePairs() {
    if (sentenceImagePairs.isEmpty) {
      for (var item in globaltopsisScoresList) {
        String sentence = item['sentence'];
        List<Clause> clauses = [];

        for (var clauseMap in item['clauses']) {
          String clauseText = clauseMap['clause'];
          clauses.add(Clause(text: clauseText)); // Create a Clause instance
        }

        sentenceImagePairs
            .add(SentencePair(sentence: sentence, clauses: clauses));
      }
    }
  }

  List<Map<String, dynamic>> getSelectedClauses(
      List<Map<String, dynamic>> scoresList) {
    if (numberOfImages <= scoresList.length) {
      List<Map<String, dynamic>> withHighestClauses = scoresList.map((map) {
        // Find the highest scoring clause for each sentence
        var highestScoringClause = (map['clauses'] as List<dynamic>)
            .map((item) => Map<String, dynamic>.from(item))
            .reduce(
                (curr, next) => curr['score'] > next['score'] ? curr : next);

        // Initially add only the highest scoring clause
        return {
          "sentence": map['sentence'],
          "clauses": [
            highestScoringClause
          ], // Store clause in a list to accommodate multiple items
        };
      }).toList();

      // Find the top X scoring clauses without altering the original order
      List<dynamic> scores = withHighestClauses
          .expand((e) => e['clauses'].map((clause) => clause['score']))
          .toList();
      scores.sort((a, b) => b.compareTo(a));

      double cutoffScore = scores.length > numberOfImages
          ? scores[numberOfImages - 1]
          : scores.last;

      // Clear clauses that are not in the top X scores
      withHighestClauses = withHighestClauses.map((e) {
        var clauses = e['clauses'] as List;
        var topClauses =
            clauses.where((clause) => clause['score'] >= cutoffScore).toList();
        return {
          "sentence": e['sentence'],
          "clauses": topClauses.isEmpty
              ? []
              : topClauses, // Ensure clause key is always a list
        };
      }).toList();
      return withHighestClauses;
    } else {
      List<Map<String, dynamic>> sentencesWithHighestClauses = [];
      List<Map<String, dynamic>> remainingClauses = [];

      int index =
          0; // Initialize a counter to track the original order of clauses to reorder them later
      for (var sentenceData in scoresList) {
        List<Map<String, dynamic>> clauses =
            List<Map<String, dynamic>>.from(sentenceData['clauses']);
        for (var clause in clauses) {
          // Add an order index to each clause
          clause['order'] = index++;
        }

        clauses.sort((a, b) => b['score'].compareTo(a['score']));

        sentencesWithHighestClauses.add({
          'sentence': sentenceData['sentence'],
          'clauses': [clauses.first],
        });

        for (var clause in clauses.skip(1)) {
          var clauseWithReference = Map<String, dynamic>.from(clause);
          clauseWithReference['originalSentence'] = sentenceData['sentence'];
          remainingClauses.add(clauseWithReference);
        }
      }

      remainingClauses.sort((a, b) => b['score'].compareTo(a['score']));
      List<Map<String, dynamic>> topRemainingClauses =
          remainingClauses.take(numberOfImages - scoresList.length).toList();

      for (var topClause in topRemainingClauses) {
        var matchingSentence = sentencesWithHighestClauses.firstWhere(
            (sentenceMap) =>
                sentenceMap['sentence'] == topClause['originalSentence'],
            orElse: () => {'sentence': '', 'clauses': []});

        if (matchingSentence.isNotEmpty) {
          matchingSentence['clauses'].add(topClause);
        }
      }

// Before returning, sort the clauses within each sentence by their original order in the story
      for (var sentenceMap in sentencesWithHighestClauses) {
        sentenceMap['clauses'].sort((a, b) {
          int orderA = a['order'];
          int orderB = b['order'];
          return orderA.compareTo(orderB);
        });
      }

      return sentencesWithHighestClauses;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
                        "هذا الرقم يمثل عدد الصور الذي سيتم انتاجه ويمكنك تغييره كما تريد، قم باختيار عدد الصور الذي ترغب به:"),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.all(8),
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
                                recommendedClauses =
                                    getSelectedClauses(globaltopsisScoresList);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
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
                      children: recommendedClauses.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> sentenceData = entry.value;

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: YourStoryStyle.primarycolor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'فقرة -${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              // Check if clause data exists and is a list
                              if (sentenceData['clauses'] != null &&
                                  sentenceData['clauses'] is List &&
                                  sentenceData['clauses'].isNotEmpty)
                                ...sentenceData['clauses'].map((clause) {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 187, 222, 251),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: TextButton(
                                        onPressed: () {
                                          showCustomModalBottomSheet(
                                              context,
                                              clausesContainer(
                                                  clause['clause']));
                                        },
                                        child: Text(
                                          clause['clause'].replaceAll(
                                              RegExp(r'[،ـ:\.\s]+$'), ''),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList()
                              else
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "يبدو أنه لم يتم ترشيح أي عبارة من هذه الفقرة",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    )),
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
                              "لن يمكنك التعديل على نص القصة لاحقا، هل أنت متاكد أنك ترغب بالاستمرار؟",
                              () {
                            globaltopClausesToIllustrate = [];
                            for (var sentence in recommendedClauses) {
                              for (var clause in sentence['clauses']) {
                                globaltopClausesToIllustrate
                                    .add(clause['clause']);
                              }
                            }
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
                              builder: (context) => Filtering(
                                  shouldPopulate: true,
                                  comingFromEditBeforePdf: false),
                            ),
                          );
                        },
                        child: Text(
                          "الاختيار يدويًّا",
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
