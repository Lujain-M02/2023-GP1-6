import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:your_story/pages/create_story_pages/processing_illustarting/filtering.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/illustarting.dart';
import '../../../style.dart';
import '../../../alerts.dart';
import 'global_story.dart';

class ProcessStory extends StatefulWidget {
  ProcessStory({required this.title, required this.content});
  final String title;
  final String content;
  @override
  _ProcessStoryState createState() => _ProcessStoryState();
}

class _ProcessStoryState extends State<ProcessStory> {
  List<Map<String, dynamic>> topsisScoresList = [];
  bool isLoading = false;
  String responseMessage = ''; // To store the response message
  int numberOfImages = 1;
  List<String> topClausesToIllustrate =
      []; // this array stores the top clauses and send it to other page

  void _showNumberPickerDialog(BuildContext context) {
    NumberPickerAlertDialog.show(context,
        'لقد انتهت المعالجة بنجاح! رجاء قم باختبار عدد الصور الذي ترغب به في قصتك',
        (selectedNumber) {
      numberOfImages = selectedNumber!;
      // print('Selected number: $selectedNumber');
      // print('NumberOfImages: $NumberOfImages');
      setState(() {
        isLoading = false; // Set loading to false when the request completes
        topClausesToIllustrate =
            getTopClauses(topsisScoresList); // Update topClausesToIllustrate
        //update the global variables
        globalTitle = widget.title;
        globalContent = widget.content;
        globaltopClausesToIllustrate = topClausesToIllustrate;
        globaltopsisScoresList = topsisScoresList;
      });
    }, topsisScoresList.length);
  }

  @override
  void initState() {
    super.initState();
    // Initiate the TOPSIS scores request here
    sendPostRequest();
  }

  Future<void> sendPostRequest() async {
    setState(() {
      isLoading = true; // Set loading to true when the request starts
    });

    final Map<String, String> data = {
      'story': widget.content,
      'title': widget.title,
    };

    final response = await http.post(
      Uri.parse("http://192.168.100.244:5000/calculate_topsis"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      // Check if any score is "NaN" or null
      bool hasInvalidScore = responseData.any((sentenceData) {
        List<dynamic> clauses = sentenceData['clauses'];
        return clauses.any((clauseData) => clauseData['score'] == "NaN");
      });

      if (hasInvalidScore) {
        setState(() {
          isLoading = false;
          responseMessage = 'تعذر معالجة القصة. يرجى المحاولة مرة أخرى.';
        });
        return; // Exit the function early
      } else {
        setState(() {
          topsisScoresList = List<Map<String, dynamic>>.from(responseData);
          responseMessage = ''; // Clear the response message
          _showNumberPickerDialog(context);
        });
      }
    } else {
      setState(() {
        topsisScoresList = [];
        responseMessage = 'حدث خطأ أثناء الاستجابة';
      });
    }

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: YourStoryStyle.primarycolor,
              ))
            : responseMessage.isNotEmpty
                ? Center(child: Text(responseMessage))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: TextButton(
                              onPressed: () {
                                Alert.show(context,
                                    "في قصتك نقوم بتقييم أجزاء القصة بمعايير مختلفة مثل: المشاعر، أهمية الأسماء في الجملة، مدى اختلاف الجملة، والمزيد. \n\n قد لا يكون تقييما شاملا لكن نطمح بأن يكون قادرا على تصوير قصتكم بشكل صحيح.");
                              },
                              child: Text(
                                "معرفة معايير التقييم",
                                style: TextStyle(color: YourStoryStyle.s2Color),
                              )),
                        ),
                        const SizedBox(
                          height: 8,
                        )
                        // Expanded(
                        //   child: ListView.builder(
                        //     itemCount: topsisScoresList.length,
                        //     itemBuilder: (context, sentenceIndex) {
                        //       final sentence = topsisScoresList[sentenceIndex];
                        //       final clauses = sentence['clauses'] as List<dynamic>;

                        //       return ExpansionTile(
                        //         title: Text('جملة ${sentenceIndex + 1}: ${sentence['sentence']}'),
                        //         children: clauses.map((clauseData) {
                        //           // Clean up each clause using replaceAll
                        //           final cleanedClause = clauseData['clause'].replaceAll(RegExp(r'[،ـ:\.\s]+$'), '');
                        //           final score = clauseData['score'];

                        //           //translate clauses
                        //           translateClause(cleanedClause);

                        //           return ListTile(
                        //             title: Text('عبارة: $cleanedClause'),
                        //             subtitle: Text('الدرجة: $score'),
                        //           );
                        //         }).toList(),
                        //       );
                        //     },
                        //   ),
                        // ),
                        ,
                        Container(
                          padding: EdgeInsets.all(
                              10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: topClausesToIllustrate
                                .map((clause) => Container(
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              123, 187, 222, 251),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(
                                          bottom:
                                              10), // Adds space between containers
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            8.0), // Padding inside each container for the text
                                        child: Text(
                                          "عبارة: ${clause.replaceAll(RegExp(r'[،ـ:\.\s]+$'), '')}",
                                          style: TextStyle(fontSize: 14),
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
                                  style: TextStyle(
                                      color: YourStoryStyle.primarycolor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
