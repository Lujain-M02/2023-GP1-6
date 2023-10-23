import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:your_story/pages/style.dart';

class StoryClauses extends StatefulWidget {
const StoryClauses({Key? key, required this.storyTitle, required this.storyContent})
      : super(key: key);
  final String storyTitle, storyContent;
  @override
  _StoryClausesState createState() => _StoryClausesState();
}

class _StoryClausesState extends State<StoryClauses> {
  String highestScoringSentences = "";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // Initiate your request here
    processArabicText();
  }

   Future<void> processArabicText() async {
    // Create a JSON request payload
    setState(() {
      isLoading = true; // Set loading to true when the request starts
    });
    final Map<String, String> data = {
      'arabic_text': widget.storyContent,
    };

    final response = await http.post(
      Uri.parse(
          "http://192.168.100.161:5000/process"), // Update with your Flask server URL
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Parse the response data
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> highestScoringSentencesList =
          responseData['highest_scoring_sentences'];

      // Set the highestScoringSentences variable with the result
      setState(() {
        highestScoringSentences = highestScoringSentencesList.join('\n');
      });

      //Translate the highestScoringSentences
      //check that highestScoringSentences is Not Empty
      if (highestScoringSentences.isNotEmpty) {
        const API_key = 'AIzaSyBPai8q0ugOh1-wowQBpa2k0Gae1N5e-_k';
        const to = 'en'; //Destination language

        //HTTP POST request to the Google Cloud Translation API
        final url = Uri.parse(
            'https://translation.googleapis.com/language/translate/v2?q=$highestScoringSentences&target=$to&key=$API_key');
        final responseAPI = await http.post(url);

        if (responseAPI.statusCode == 200) {
          final body =
              json.decode(responseAPI.body); //convert JSON to dart object

          //Extracting the 'translations' data from the JSON response and converting it into a List
          final translations = body['data']['translations'] as List<dynamic>;

          //Extracts the value associated with the 'translatedText' key from the 1st item in the "Translations" list
          final translation = translations.first['translatedText'];

          print("Translated Text: $translation");
        } else {
          print("Error: ${responseAPI.statusCode}");
        }
      } //End of translation
    } else {
      // Handle the error
      setState(() {
        highestScoringSentences = "Error: ${response.statusCode}";
      });
    }
    setState(() {
      isLoading = false; // Set loading to false when the request completes
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(),
    body: Center(
      child: Container(
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.grey,
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 238, 245, 255),
                ),
                child: Text(
                  highestScoringSentences,
                  style: TextStyle(
                    fontSize: 20,
                    color: your_story_Style.titleColor,
                  ),
                ),
              ),
      ),
    ),
  );
}
    
  }
