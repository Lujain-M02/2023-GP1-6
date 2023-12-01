
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:your_story/pages/MainPage.dart';
import '../../style.dart';
import '../../alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorySave extends StatefulWidget {
  final String title;
  final String content;

  StorySave({required this.title, required this.content});

  @override
  _StorySaveState createState() => _StorySaveState();
}

class _StorySaveState extends State<StorySave> {
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
      Uri.parse("http://192.168.100.161:5000/calculate_topsis"),
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
          responseMessage = 'تعذر حساب بعض الدرجات. يرجى المحاولة مرة أخرى.';
        });
        return; // Exit the function early
      } else {
        setState(() {
          topsisScoresList = List<Map<String, dynamic>>.from(responseData);
          responseMessage = ''; // Clear the response message
        });
      }
    } else {
      setState(() {
        topsisScoresList = [];
        responseMessage = 'حدث خطأ أثناء الاستجابة';
      });
    }

    setState(() {
      isLoading = false; // Set loading to false when the request completes
    });

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }

  Future<String> translateClause(String clause) async {
  const API_key = 'AIzaSyBPai8q0ugOh1-wowQBpa2k0Gae1N5e-_k';
  const to = 'en'; //Destination language

  final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?q=$clause&target=$to&key=$API_key');

  final response = await http.post(url);

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    final translations = body['data']['translations'] as List<dynamic>;
    final translation = translations.first['translatedText'];

    // Print the translated text to the console
    print('Original: $clause');
    print('Translated: $translation');

    return translation;
  } else {
    print('Translation Error: ${response.statusCode}');
    return 'Translation Error: ${response.statusCode}';
  }
}


  Future<void> addStoryToCurrentUser(String title, String content, BuildContext context) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection("User").doc(user.uid);

        CollectionReference storiesCollection = userRef.collection("Stories");

        await storiesCollection.add({
          'title': title,
          'content': content,
        });

        print("Story added successfully!");
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            content: "تم الحفظ بنجاح",
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          (Route<dynamic> route) =>
              false, // this removes all routes below MainPage
        );
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error adding story: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          content: "حدث خطأ عند الحفظ",
        ),
      );
    }
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
          ? const Center(child: CircularProgressIndicator())
          : responseMessage.isNotEmpty
              ? Center(child: Text(responseMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'نتائج المعالجة :',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: topsisScoresList.length,
                          itemBuilder: (context, sentenceIndex) {
                            final sentence = topsisScoresList[sentenceIndex];
                            final clauses = sentence['clauses'] as List<dynamic>;

                            return ExpansionTile(
                              title: Text('جملة ${sentenceIndex + 1}: ${sentence['sentence']}'),
                              children: clauses.map((clauseData) {
                                // Clean up each clause using replaceAll
                                final cleanedClause = clauseData['clause'].replaceAll(RegExp(r'[،ـ:\.\s]+$'), '');
                                final score = clauseData['score'];

                                //translate clauses
                                translateClause(cleanedClause);

                                return ListTile(
                                  title: Text('عبارة: $cleanedClause'),
                                  subtitle: Text('الدرجة: $score'),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(YourStoryStyle.titleColor),
                          ),
                          onPressed: () async {
                            await addStoryToCurrentUser(widget.title, widget.content, context);
                          },
                          child: const Text('احفظ القصة وعد للصفحة الرئيسية'),
                        ),
                      ),
                    ],
                  ),
                ),
    ),
  );
}

}
