import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:your_story/alerts.dart';
import 'package:your_story/pages/create_story_pages/processing_illustarting/error.dart';
import '../../pdf_pages/edit_beforePdf.dart';
import 'global_story.dart';

class Illustration extends StatefulWidget {
  Illustration({
    Key? key,
  }) : super(key: key);

  @override
  State<Illustration> createState() => IllustrationState();
}

class IllustrationState extends State<Illustration> {
  List<String> imageUrls = [];
  bool isLoading = false;
  int generatedImagesCount = 0;
  int numberOfImages = 0;
  int seed = Random().nextInt(100000);
  bool isRegenerated = false;

  @override
  void initState() {
    super.initState();
    calculateUnillustratedClauses();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<ImageStyle> imageStyles = [
        ImageStyle(
            title: "واقعية",
            style: "Photorealistic",
            imagePath: "assets/Photorealistic.png"),
        ImageStyle(
            title: "فنية", style: "Artistic", imagePath: "assets/Artistic.png"),
        ImageStyle(
            title: "سريالية",
            style: "Surreal",
            imagePath: "assets/Surreal.png"),
        ImageStyle(
            title: "كرتونية",
            style: "Cartoon",
            imagePath: "assets/Cartoon.png"),
      ];
      print(selectedImageStyle);
      selectedImageStyle ??=
          await ImageStylePickerDialog.show(context, imageStyles);
      print(selectedImageStyle);
      if (selectedImageStyle != null) {
        generateAllImages();
      }
    });
  }

  void calculateUnillustratedClauses() {
    int count = 0;
    for (var sentencePair in sentenceImagePairs) {
      for (var clause in sentencePair.clauses) {
        if (globaltopClausesToIllustrate.contains(clause.text) &&
            clause.image == null) {
          count++; // Increment count if clause is in the list to be illustrated but has no image
        }
      }
    }
    setState(() {
      numberOfImages =
          count; // Update state with the counted number of unillustrated clauses
    });
  }

  static Future<File> generateImage(String sentence, String clause,
      int seedNumber, bool isRegenerated) async {
    String apiKey = dotenv.env['API_KEY']!;
    String seed = seedNumber.toString();

    String translatedSentence = await translation(sentence);
    String translatedClause = await translation(clause);
    String text = "";

    if (isRegenerated) {
      text =
          "Generate a descriptive image of '$translatedClause' based on this context '$translatedSentence' in $selectedImageStyle style, with different POV ";
    } else {
      text =
          "Generate a descriptive image of '$translatedClause' based on this context '$translatedSentence' in $selectedImageStyle style";
    }
    String url = 'https://api.stability.ai/v2beta/stable-image/generate/sd3';
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['prompt'] = text
      ..fields['output_format'] = 'jpeg'
      ..fields['seed'] = seed
      ..fields['model'] = "sd3"
      ..fields['negative_prompt'] = 'text in the image, Blurry, distorted '
      ..headers['Authorization'] = 'Bearer $apiKey';

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      File imageFile = File(
          '$appDocPath/generated_image_${DateTime.now().millisecondsSinceEpoch}.jpeg');
      await imageFile.writeAsBytes(response.bodyBytes);
      return imageFile;
    } else {
      throw Exception('Failed to load image: ${response.body}');
    }
  }

  Future<void> generateAllImages() async {
    setState(() {
      isLoading = true;
    });
    try {
      for (var sentencePair in sentenceImagePairs) {
        for (var clause in sentencePair.clauses) {
          if (globaltopClausesToIllustrate.contains(clause.text) &&
              clause.image == null) {
            // Only generate if there's no image

            File newImage = await generateImage(
                sentencePair.sentence, clause.text, seed, isRegenerated);
            clause.image = newImage;
            setState(() {
              generatedImagesCount++;
            });
          }
        }
      }
    } catch (e) {
      isLoading = false;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ErrorPage(
              errorMessage:
                  "حدث خطأ أثناء إنتاج الصورة، يرجى إعادة المحاولة لاحقًا")));
    }
    setState(() {
      isLoading = false;
    });

    // Navigate to the next page or update UI
    print("Completed image generation for all clauses.");
    print(
        "Navigating to EditBeforePdf with pairs: ${sentenceImagePairs.length}");

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const EditBeforePdf()),
        (Route<dynamic> route) => false);
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(globalTitle),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/loadingLogo.gif"),
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

Future<String> translation(String text) async {
  var API_key = dotenv.env['GOOGLE_TRANSLATE_KEY']!;

  const to = 'en'; //Destination language

  final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?q=$text&target=$to&key=$API_key');

  final response = await http.post(url);

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    final translations = body['data']['translations'] as List<dynamic>;
    final translation = translations.first['translatedText'];

    return translation;
  } else {
    print('Translation Error: ${response.statusCode}');
    return 'Translation Error: ${response.statusCode}';
  }
}
