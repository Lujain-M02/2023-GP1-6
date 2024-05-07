import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/illustarting.dart';
import 'package:your_story/style.dart';
import 'global_story.dart';

class Filtering extends StatefulWidget {
  final bool shouldPopulate;

  const Filtering({Key? key, required this.shouldPopulate}) : super(key: key);

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
    //   if (widget.shouldPopulate) {
    //     // Populate initial selections
    //     for (var sentenceMap in globaltopsisScoresList) {
    //       for (var clauseMap in sentenceMap['clauses']) {
    //         String clause = clauseMap['clause'];
    //         // Check if the clause is one of the illustrated ones
    //         selections[clause] = globaltopClausesToIllustrate.contains(clause);
    //       }
    //     }
    //   } else {
    //     // Initialize all selections to false based on the clauses in globaltopsisScoresList
    //     for (var sentenceMap in globaltopsisScoresList) {
    //       for (var clauseMap in sentenceMap['clauses']) {
    //         String clause = clauseMap['clause'];
    //         selections[clause] = false;
    //       }
    //     }
    //   }
    // }

    for (var sentenceMap in globaltopsisScoresList) {
      for (var clauseMap in sentenceMap['clauses']) {
        String clause = clauseMap['clause'];
        // if (widget.shouldPopulate) {
        //   selections[clause] = globaltopClausesToIllustrate.contains(clause);
        // } else {
        //   selections[clause] = false;
        // }
        bool isIllustrated = globaltopClausesToIllustrate.contains(clause);
        selections[clause] = widget.shouldPopulate && isIllustrated;

        // If coming from the PDF edit screen, do not count pre-selected clauses
        if (!widget.shouldPopulate || !isIllustrated) {
          totalSelected += selections[clause]! ? 1 : 0;
        }
      }
    }
  }

  // int get totalSelected =>
  //     selections.values.where((selected) => selected).length;

  void toggleSelection(String clause) {
    setState(() {
      selections[clause] = !selections[clause]!;
      totalSelected += selections[clause]! ? 1 : -1;
    });
  }

  // // Function to categorize scores into high, medium, or low dynamically based on the range
  // String getCategoryFromScore(double score) {
  //   // Calculate thresholds based on the maximum score
  //   double highThreshold = maxScore * 0.75;
  //   double mediumThreshold = maxScore * 0.5;
  //   // Categorize the score
  //   if (score >= highThreshold) {
  //     return 'عالية الأهمية';
  //   } else if (score >= mediumThreshold) {
  //     return 'متوسطة الأهمية';
  //   } else {
  //     return 'منخفضة الأهمية';
  //   }
  // }

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
            // subtitle: Text(
            //     'الدرجة: ${score.toStringAsFixed(2)}'), // only the score as a subtitle
            subtitle: Text(
              'التصنيف: $scoreCategory', // without score
              //'التصنيف: $scoreCategory - الدرجة: ${score.toStringAsFixed(2)}',
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
                        ConfirmationDialog.show(context,
                            "لن يمكنك التعديل على نص القصة لاحقا، هل أنت متاكد أنك ترغب بالاستمرار؟",
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
