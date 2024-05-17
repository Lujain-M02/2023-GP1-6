import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/illustarting.dart';
import 'package:your_story/style.dart';
import 'global_story.dart';

class Filtering extends StatefulWidget {
  final bool shouldPopulate;
  final bool comingFromEditBeforePdf;
  const Filtering(
      {Key? key,
      required this.shouldPopulate,
      required this.comingFromEditBeforePdf})
      : super(key: key);

  @override
  State<Filtering> createState() => _Filtering();
}

class _Filtering extends State<Filtering> {
  Map<String, bool> selections = {};
  double maxScore = 0;
  double minScore = 0;
  int totalSelected = 0;
  @override
  void initState() {
    super.initState();
    maxScore = getMaxScore();
    minScore = getMinScore();

    for (var sentenceMap in globaltopsisScoresList) {
      for (var clauseMap in sentenceMap['clauses']) {
        String clause = clauseMap['clause'];
        bool isIllustrated = globaltopClausesToIllustrate.contains(clause);
        selections[clause] = widget.shouldPopulate && isIllustrated;

        // If coming from the PDF edit screen, do not count pre-selected clauses
        if (!widget.shouldPopulate || !isIllustrated) {
          totalSelected += selections[clause]! ? 1 : 0;
        }
      }
    }
  }

  void toggleSelection(String clause) {
    setState(() {
      selections[clause] = !selections[clause]!;
      totalSelected += selections[clause]! ? 1 : -1;
    });
  }

  String getCategoryFromScore(double score) {
    // Calculate the range and divide it into thirds
    double rangeThird = (maxScore - minScore) / 3.0;
    double firstThreshold = minScore + rangeThird;
    double secondThreshold = minScore + rangeThird * 2;

    // Categorize the score based on the thresholds
    if (score >= secondThreshold) {
      return "عالية الأهمية"; // High importance
    } else if (score >= firstThreshold) {
      return "متوسطة الأهمية"; // Medium importance
    } else {
      return "منخفضة الأهمية"; // Low importance
    }
  }

  double getMaxScore() {
    double maxScore =
        double.negativeInfinity; // Initialize maxScore to negative infinity

    // Iterate through each item in the list
    for (var item in globaltopsisScoresList) {
      // Iterate through each clause in the item
      for (var clauseMap in item['clauses']) {
        double score = clauseMap['score']; // Extract the score
        if (score > maxScore) {
          maxScore = score; // Update maxScore if a higher score is found
        }
      }
    }

    return maxScore;
  }

  double getMinScore() {
    double minScore = 100;

    // Iterate through each item in the list
    for (var item in globaltopsisScoresList) {
      // Iterate through each clause in the item
      for (var clauseMap in item['clauses']) {
        double score = clauseMap['score']; // Extract the score
        if (score < minScore) {
          minScore = score; // Update minScore if a higher score is found
        }
      }
    }

    return minScore;
  }

  Color getColorForCategory(String category) {
    switch (category) {
      case 'عالية الأهمية':
        return Colors.green;
      case 'متوسطة الأهمية':
        return const Color.fromARGB(255, 159, 138, 0);
      case 'منخفضة الأهمية':
        return Colors.orange;
      default:
        return Colors.black; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
//with score
    List<Widget> buildSentenceWidgets() {
      int index = 1;
      List<Widget> sentenceWidgets = [];
      for (var sentenceMap in globaltopsisScoresList) {
        String sentence = sentenceMap['sentence'];
        List<Widget> clauseWidgets =
            (sentenceMap['clauses'] as List<dynamic>).map((clauseMap) {
          String clause = clauseMap['clause'];
          double score =
              clauseMap['score']; // Extract the score for each clause
          String scoreCategory =
              getCategoryFromScore(score); // Get category based on score
          bool isPreChecked = globaltopClausesToIllustrate.contains(clause);
          return CheckboxListTile(
            title: Text(clause.replaceAll(RegExp(r'[،ـ:\.\s]+$'), '')),
            subtitle: Text(
              'التصنيف: $scoreCategory', // without score
              style: TextStyle(
                color: getColorForCategory(scoreCategory),
              ),
            ), // Display the score category as a subtitle
            value: selections[clause],
            onChanged: isPreChecked
                ? null
                : (bool? value) {
                    toggleSelection(clause);
                  },
          );
        }).toList();

        sentenceWidgets.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: YourStoryStyle.primarycolor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "فقرة-$index",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  ExpansionTile(
                    title: Text(
                      sentence,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 187, 222, 251),
                    collapsedBackgroundColor:
                        const Color.fromARGB(255, 187, 222, 251),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    collapsedShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    children: clauseWidgets,
                  ),
                ],
              ),
            ),
          ),
        ));
        index++;
      }
      return sentenceWidgets;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('التصوير يدويًّا'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'اختر ما ترغب بتصويره من القصه (سيتم تصوير $totalSelected صور)'),
                  TextButton.icon(
                    onPressed: () {
                      Alert.show(context,
                          'في قصتك نقوم بتقييم أجزاء القصة بمعايير مختلفة مثل: المشاعر، أهمية الأسماء في الجملة، مدى اختلاف الجملة، والمزيد.\n يتم تصنيف كل جملة بناءً على أدائها في كل معيار إلى فئات عالية، متوسطة، ومنخفضة، ونوصي بتصوير الجمل ذات التصنيف العالي.');
                    },
                    label: Text(
                      "معرفة معايير التصنيف",
                      style: TextStyle(color: YourStoryStyle.s2Color),
                    ),
                    icon: Icon(
                      Icons.announcement_outlined,
                      color: YourStoryStyle.s2Color,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: buildSentenceWidgets(),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(YourStoryStyle.primarycolor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    )),
                onPressed: totalSelected > 0
                    ? () {
                        final selectedClauses = selections.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .toList();
                        globaltopClausesToIllustrate = selectedClauses;
                        print("title: $globalTitle");
                        print("content: $globalContent");
                        print(
                            "Selected clauses: $globaltopClausesToIllustrate");
                        String confirmationMessage = widget
                                .comingFromEditBeforePdf
                            ? "هل أنت متأكد من أنك تريد تصوير جميع العبارات المختارة؟"
                            : "لن يمكنك التعديل على نص القصة لاحقًا، هل أنت متأكد أنك ترغب بالاستمرار؟";
                        ConfirmationDialog.show(context, confirmationMessage,
                            () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Illustration()),
                              (Route<dynamic> route) => false);
                        });
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                              content: "قم باختيار عبارة واحدة على الاقل",
                              icon: Icons.warning),
                        );
                      },
                child: const Text(
                  'البدء بالتصوير',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
