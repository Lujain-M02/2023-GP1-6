import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
// import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:your_story/pages/pdf_pages/createPdf.dart';
import 'global_story.dart';

class Illustration extends StatefulWidget {
  //final List<dynamic> clausesToIllujstrate;

  Illustration({
    Key? key,
    //required this.clausesToIllujstrate
  }) : super(key: key);

  @override
  State<Illustration> createState() => _IllustrationState();
}

/*class _IllustrationState extends State<Illustration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحه الامج جنريشن'),
      ),
      body: Container(
        color: Colors.blue, 
        alignment: Alignment.center,
        child: Text(widget.clausesToIllujstrate[0]),

      ),
    );
  }
}*/

class _IllustrationState extends State<Illustration> {
  List<String> imageUrls = [];
  bool isLoading = false;
  //String translatedStory = "";
  int generatedImagesCount = 0;
  int numberOfImages = globaltopClausesToIllustrate.length;
  @override
  void initState() {
    super.initState();
    //translateStory();
    generateAllImages();
  }

  /*void translateStory() async {
    translatedStory = await translateClause(globalContent);
  }*/

  /*void generateAllImages() async {
    setState(() {
      isLoading = true;
    });
    //List<String> urls = [];
    for (var clause in globaltopClausesToIllustrate) {
      // Translate the clause first
      //String translatedClause = await translateClause(clause);
      String sentence = findSentenceContainingClause(clause);

      String translatedClause = await translateClause(clause);
      String translatedSentence = await translateClause(sentence);
      //String translatedStory = await translateClause(globalContent);
      // Then generate image for the translated clause
      /*String imageUrl =
          await generateImage(translatedSentence, translatedClause);
      globalImagesUrls.add(imageUrl);*/
      //urls.add(imageUrl);
      await generateImage(translatedSentence, translatedClause)
          .then((imageUrl) {
        setState(() {
          generatedImagesCount++;
          globalImagesUrls.add(imageUrl);
        });
      }).catchError((error) {
        print("Error generating image: $error");
      });
    }
    // Navigate to the PdfGenerationPage (which should be your waiting screen)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PdfGenerationPage(),
      ),
    );*/

  /*setState(() {
      //imageUrls = urls;
      isLoading = false;
    });
  }*/
  Future<void> generateAllImages() async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> tempSentenceImagePairs = [];
    List<String> clauses = [];

    for (var sentenceMap in globaltopsisScoresList) {
      String sentence = sentenceMap['sentence'];
      //print("sentence: $sentence");
      List<String> imagesForSentence = [];
      print("sentence: $sentence");
      for (var clause in globaltopClausesToIllustrate) {
        if (sentence.contains(clause)) {
          clauses.add(clause);
          try {
            // Generate an image for the sentence containing the clause
            String imageUrl = await generateImage(sentence, clause);
            imagesForSentence.add(imageUrl);
            setState(() {
              generatedImagesCount++;
            });
          } catch (error) {
            print("Error generating image for sentence '$sentence': $error");
          }
        }
      }

      // Add the sentence to tempSentenceImagePairs regardless of whether images were generated
      tempSentenceImagePairs.add({
        "sentence": sentence.trim(),
        "images":
            imagesForSentence, // This could be an empty list if no images were generated
      });
      print("tempSentenceImagePairs: $tempSentenceImagePairs");
      print("clauses: $clauses");
    }

    // Update the global sentenceImagePairs with the generated data
    setState(() {
      sentenceImagePairs = tempSentenceImagePairs;
      //print(sentenceImagePairs);
      isLoading = false;
    });

    // You might want to navigate or update UI here to reflect that the process is complete
    print("Completed image generation for sentences.");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PdfGenerationPage(),
      ),
    );
  }

// Function to find and return the sentence that contains the clause
  String findSentenceContainingClause(String clause) {
    // Split the story into sentences
    var sentences = globalContent.split(RegExp(r'[.؟!]\s', multiLine: true));

    // Find the sentence that contains the clause
    for (var sentence in sentences) {
      if (sentence.contains(clause)) {
        print("sentence: $sentence");
        return sentence;
      }
    }

    // If no sentence contains the clause, return the clause itself or handle as needed
    return clause;
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحه الامج جنريشن'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.blue,
              child: ListView.builder(
                itemCount: globalImagesUrls.length,
                itemBuilder: (context, index) {
                  return globalImagesUrls[index].isNotEmpty
                      ? Image.network(globalImagesUrls[index])
                      : Text("No image available");
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PdfGenerationPage(),
            ),
          );
        },
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(globalTitle),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Image.asset("assets/log.gif"),
              // Lottie.asset('assets/loading.json', width: 200, height: 200),
              const SizedBox(height: 20),
              Text(
                'تم إنشاء $generatedImagesCount / $numberOfImages صورة حتى الآن',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'من فضلك انتظر قليلا لإنتاج جميع الصور',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> generateImage(String sentence, String prompt) async {
  OpenAI.apiKey = dotenv.env['OPENAI_KEY']!;
  //OpenAI.apiKey =FlutterConfig.get('OPENAI_KEY'); // Accessing the OpenAI API Key
  try {
    final OpenAIImageModel image = await OpenAI.instance.image.create(
      //prompt: "from this sentence:'$sentence' generate:'$prompt'",
      prompt: "from this story:'$sentence' generate:'$prompt'",
      model: "dall-e-2", // Explicitly specifying the model
      n: 1,
      size: OpenAIImageSize.size1024,
      responseFormat: OpenAIImageResponseFormat.url,
    );

    if (image.data.isNotEmpty) {
      return image.data.first.url ??
          ''; // Return an empty string if the url is null
    } else {
      throw Exception('No image data received');
    }
  } catch (e) {
    print("Failed to generate image: $e");
    rethrow; // Rethrow the exception for the calling widget to handle
  }
}

Future<String> translateClause(String clause) async {
  var API_key = dotenv.env['GOOGLE_TRANSLATE_KEY']!;

  //var API_key = FlutterConfig.get('GOOGLE_TRANSLATE_KEY'); // Accessing the Google Translate API Key
  //const API_key = 'AIzaSyBPai8q0ugOh1-wowQBpa2k0Gae1N5e-_k';
  const to = 'en'; //Destination language

  final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?q=$clause&target=$to&key=$API_key');

  final response = await http.post(url);

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    final translations = body['data']['translations'] as List<dynamic>;
    final translation = translations.first['translatedText'];

    // Print the translated text to the console
    //print('Original: $clause');
    //print('Translated: $translation');

    return translation;
  } else {
    print('Translation Error: ${response.statusCode}');
    return 'Translation Error: ${response.statusCode}';
  }
}
