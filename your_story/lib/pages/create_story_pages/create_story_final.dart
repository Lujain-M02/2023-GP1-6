import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:your_story/pages/style.dart';

class CreateStoryFinal extends StatefulWidget {
  const CreateStoryFinal({Key? key, required this.title, required this.content})
      : super(key: key);
  final String title, content;

  @override
  _CreateStoryFinalState createState() => _CreateStoryFinalState();
}

class _CreateStoryFinalState extends State<CreateStoryFinal> {
  String highestScoringSentences = "";
  bool isLoading = false;

  Future<void> processArabicText() async {
    // Create a JSON request payload
    setState(() {
      isLoading = true; // Set loading to true when the request starts
    });
    final Map<String, String> data = {
      'arabic_text': widget.content,
    };

    final response = await http.post(
      Uri.parse(
          "http://192.168.100.4:5000/process"), // Update with your Flask server URL
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
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Text(
        "العنوان : ${widget.title}",
        style: TextStyle(fontSize: 20, color: your_story_Style.titleColor),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        width: 200,
        child: ElevatedButton(
          onPressed: () {
            if (widget.content.isNotEmpty) {
              processArabicText();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors
                .transparent, // Set the button's background color to transparent
            disabledBackgroundColor: Colors
                .transparent, // Set the button's text color to transparent
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            elevation: 0,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 189, 189, 220),
                  Color.fromARGB(255, 243, 114, 157),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                "معالجة القصة",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set the text color to white
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      if (isLoading) // Display the custom progress bar when loading is true
        const CircularProgressIndicator(
          color: Colors.grey,
        ),
      if (!isLoading) // Display the Text when loading is false
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(
                255,
                238,
                245,
                255,
              )),
          child: Text(
            highestScoringSentences,
            style: TextStyle(fontSize: 20, color: your_story_Style.titleColor),
          ),
        ),
    ]);
  }
}
