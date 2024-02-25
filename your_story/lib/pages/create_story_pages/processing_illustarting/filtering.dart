import 'package:flutter/material.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/illustarting.dart';
import 'package:your_story/style.dart';
import 'global_story.dart';

class Filtering extends StatefulWidget {
  const Filtering({Key? key}) : super(key: key);

  @override
  State<Filtering> createState() => _Filtering();
}

class _Filtering extends State<Filtering> {
  Map<String, bool> selections = {};
  double maxScore = 0;

  @override
  void initState() {
    super.initState();
    maxScore = getMaxScore();

    // Initialize all selections to false based on the clauses in globaltopsisScoresList.
    for (var sentenceMap in globaltopsisScoresList) {
      for (var clauseMap in sentenceMap['clauses']) {
        String clause = clauseMap['clause'];
        selections[clause] = false;
      }
    }
  }

  int get totalSelected =>
      selections.values.where((selected) => selected).length;

  void toggleSelection(String clause) {
    setState(() {
      selections[clause] = !selections[clause]!;
    });
  }

  // Function to categorize scores into high, medium, or low dynamically based on the range
  String getCategoryFromScore(double score) {
    // Calculate thresholds based on the maximum score
    double highThreshold = maxScore * 0.75;
    double mediumThreshold = maxScore * 0.5;
    // Categorize the score
    if (score >= highThreshold) {
      return 'عالية الأهمية';
    } else if (score >= mediumThreshold) {
      return 'متوسطة الأهمية';
    } else {
      return 'منخفضة الأهمية';
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

  Color getColorForCategory(String category) {
    switch (category) {
      case 'عالية الأهمية':
        return Colors.green;
      case 'متوسطة الأهمية':
        return Colors.orange;
      case 'منخفضة الأهمية':
        return const Color.fromRGBO(255, 241, 147, 1.0);;
      default:
        return Colors.black; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
//with score
    List<Widget> buildSentenceWidgets() {
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

          return CheckboxListTile(
            title: Text(clause.replaceAll(RegExp(r'[،ـ:\.\s]+$'), '')),
            // subtitle: Text(
            //     'الدرجة: ${score.toStringAsFixed(2)}'), // Display the score as a subtitle
            subtitle: Text(
              'التصنيف: $scoreCategory - الدرجة: ${score.toStringAsFixed(2)}',
              style: TextStyle(
                color: getColorForCategory(scoreCategory),
              ),
            ), // Display the score category as a subtitle
            value: selections[clause],
            onChanged: (bool? value) {
              toggleSelection(clause);
            },
          );
        }).toList();

        sentenceWidgets.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Text(sentence),
            backgroundColor: const Color.fromARGB(255, 187, 222, 251),
            collapsedBackgroundColor: const Color.fromARGB(160, 187, 222, 251),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            collapsedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
            children: clauseWidgets,
          ),
        ));
      }
      return sentenceWidgets;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التصوير يدويا'),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Illustration(),
                          ),
                        );
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                              content: "قم باختيار عبارة واحدة على الاقل",
                              icon: Icons.warning),
                        );
                      },
                child: const Text(
                  'البدأ بالتصوير',
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

//without score

// List<Widget> buildSentenceWidgets() {
//   List<Widget> sentenceWidgets = [];
//   for (var sentenceMap in globaltopsisScoresList) {
//     String sentence = sentenceMap['sentence'];
//     List<Widget> clauseWidgets = (sentenceMap['clauses'] as List<dynamic>).map((clauseMap) {
//       String clause = clauseMap['clause'];
//       return CheckboxListTile(
//         title: Text(clause.replaceAll(RegExp(r'[،ـ:\.\s]+$'), '')),
//         value: selections[clause],
//         onChanged: (bool? value) {
//           toggleSelection(clause);
//         },
//       );
//     }).toList();

//     sentenceWidgets.add(Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ExpansionTile(
//         title: Text(sentence),
//         backgroundColor: Color.fromARGB(255, 187, 222, 251),
//         collapsedBackgroundColor: Color.fromARGB(160, 187, 222, 251),
//                         shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(20))),
//             collapsedShape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(50))),
//         children: clauseWidgets,
//       ),
//     ));
//   }
//   return sentenceWidgets;
// }
