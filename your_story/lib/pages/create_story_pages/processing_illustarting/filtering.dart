import 'package:flutter/material.dart';
import 'global_story.dart';

class Filtering extends StatefulWidget {
  Filtering({Key? key}) : super(key: key);

  @override
  State<Filtering> createState() => _Filtering();
}

class _Filtering extends State<Filtering> {
  Map<String, bool> selections = {};

  @override
  void initState() {
    super.initState();
    // Initialize all selections to false based on the clauses in globaltopsisScoresList.
    for (var sentenceMap in globaltopsisScoresList) {
      for (var clauseMap in sentenceMap['clauses']) {
        String clause = clauseMap['clause'];
        selections[clause] = false;
      }
    }
  }

  int get totalSelected => selections.values.where((selected) => selected).length;

  void toggleSelection(String clause) {
    setState(() {
      selections[clause] = !selections[clause]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildSentenceWidgets() {
      List<Widget> sentenceWidgets = [];
      for (var sentenceMap in globaltopsisScoresList) {
        String sentence = sentenceMap['sentence'];
        List<Widget> clauseWidgets = (sentenceMap['clauses'] as List<dynamic>).map((clauseMap) {
          String clause = clauseMap['clause'];
          return CheckboxListTile(
            title: Text(clause.replaceAll(RegExp(r'[،ـ:\.\s]+$'), '')),
            value: selections[clause],
            onChanged: (bool? value) {
              toggleSelection(clause);
            },
          );
        }).toList();

        sentenceWidgets.add(ExpansionTile(
          title: Text(sentence),
          children: clauseWidgets,
        ));
      }
      return sentenceWidgets;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('التصوير يدويا'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('اختر ما ترغب بتصويره من القصه (سيتم تصوير $totalSelected صور)'),
            ),
            Expanded(
              child: ListView(
                children: buildSentenceWidgets(),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: totalSelected > 0 ? () {
                  final selectedClauses = selections.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();
                  print("Selected clauses: $selectedClauses");
                } : null,
                child: Text('البدأ بالتصوير'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}