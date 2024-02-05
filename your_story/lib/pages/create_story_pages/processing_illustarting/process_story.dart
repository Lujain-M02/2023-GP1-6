import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:your_story/pages/create_story_pages/processing_illustarting/system_recom.dart';
import '../../../style.dart';
import 'global_story.dart';
import 'package:lottie/lottie.dart';

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
          //_showNumberPickerDialog(context);

          //update the global variables
          globalTitle = widget.title;
          globalContent = widget.content;
          globaltopsisScoresList = topsisScoresList;
        });
      }
    } else {
      setState(() {
        topsisScoresList = [];
        responseMessage = 'حدث خطأ أثناء الاستجابة';
      });
    }

    setState(() {
      isLoading = false;
    });

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    int totalClauses = globaltopsisScoresList.fold<int>(
        0,
        (previousValue, element) =>
            previousValue + (element['clauses'] as List).length);
    globalTotalNumberOfClauses=totalClauses;        

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/loading.json',
                        width: 200, height: 200),
                    const SizedBox(height: 20),
                    const Text(
                      'من فضلك انتظر قليلا لمعالجة القصة ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : responseMessage.isNotEmpty
                ? Center(child: Text(responseMessage))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: ListTile(
                            horizontalTitleGap: -5,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 0.0),
                            leading: Icon(
                              Icons.lightbulb,
                              color: Colors.amber,
                              size: 20,
                            ),
                            title: Text(
                              "تبدو قصتك رائعة !",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('نتائج المعالجة لقصة ${globalTitle}:',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              'عدد الفقرات في القصة: ${globaltopsisScoresList.length}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              'عدد العبارات في القصة: $totalClauses',
                              style: const TextStyle(
                                  fontSize: 16,
                                  )),
                        ),
                        Expanded(
                              child: ListView.builder(
                                itemCount: globaltopsisScoresList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text('الفقرة ${index + 1}'),
                                    subtitle: Text(
                                        'عدد العبارات: ${globaltopsisScoresList[index]['clauses'].length}'),
                                  );
                                },
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
                                      builder: (context) => const SystemRecom(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "الاستمرار لتصوير القصة",
                                  style: TextStyle(color: Colors.white),
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