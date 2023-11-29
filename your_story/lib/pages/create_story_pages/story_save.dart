
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
      Uri.parse("http://192.168.100.161:5000/calculate_topsis"), // Update with your Flask server URL
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Parse the response data
      final List<dynamic> responseData = jsonDecode(response.body);

      // Set the topsisScoresList variable with the structured data
      setState(() {
        topsisScoresList = List<Map<String, dynamic>>.from(responseData);
        responseMessage = ''; // Clear the response message
        topsisScoresList.sort((a, b) => b['score'].compareTo(a['score'])); //sort the clauses based on the scores
      });

      // Check if topsisScoresList is empty after processing
      if (topsisScoresList.isEmpty) {
        // Handle the case when topsisScoresList is empty
        // You can display a message here
      }
    } else {
      // Handle the error
      topsisScoresList = []; // Clear the data in case of an error
      responseMessage = 'حدث خطأ أثناء الاستجابة'; // Set an error message
    }

    setState(() {
      isLoading = false; // Set loading to false when the request completes
    });

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
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
 Widget build(BuildContext context) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:const Icon(
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
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
                    itemBuilder: (context, i) {
                      final cleanedClause = topsisScoresList[i]['clause'].replaceAll(RegExp(r'[،ـ:\.\s]+$'), '');
                      final score = topsisScoresList[i]['score'];
                      return ListTile(
                        title: Text('عبارة ${i + 1}: $cleanedClause'),
                        subtitle: Text('الدرجة: $score'),
                      );
                    },
                  )
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
