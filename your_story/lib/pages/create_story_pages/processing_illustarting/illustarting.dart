import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
// import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
//import 'package:lottie/lottie.dart';
import 'package:your_story/alerts.dart';
import '../../pdf_pages/edit_beforePdf.dart';
import 'global_story.dart';

class Illustration extends StatefulWidget {
  //final List<dynamic> clausesToIllujstrate;

  Illustration({
    Key? key,
    //required this.clausesToIllujstrate
  }) : super(key: key);

  @override
  State<Illustration> createState() => IllustrationState();
}

class IllustrationState extends State<Illustration> {
  List<String> imageUrls = [];
  bool isLoading = false;
  //String translatedStory = "";
  int generatedImagesCount = 0;
  int numberOfImages = 0; //globaltopClausesToIllustrate.length;
  int seed = Random().nextInt(100000);
  bool isRegenerated = false;

  @override
  void initState() {
    super.initState();
    //translateStory();
    calculateUnillustratedClauses();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //selectedImageStyle = await ImageStylePickerDialog.show(context);
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

  // Future<File> generateImage(String sentence, String prompt) async {
  //   String apiKey = dotenv.env['API_KEY']!;
  //   String url = 'https://api.stability.ai/v2beta/stable-image/generate/sd3';
  //   String Tsentence = translateClause(sentence) as String;
  //   String Tprompt = translateClause(prompt) as String;
  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse(url))
  //       ..fields['prompt'] =
  //           "Draw this clause: '$Tprompt' based on this context: '$Tsentence' in anime style"
  //       ..fields['output_format'] = 'jpeg'
  //       ..fields['seed'] = '12345'
  //       ..headers['Authorization'] = 'Bearer $apiKey';

  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);

  //     if (response.statusCode == 200) {
  //       Directory appDocDir = await getApplicationDocumentsDirectory();
  //       String appDocPath = appDocDir.path;
  //       File imageFile = File('$appDocPath/generated_image.jpeg');
  //       await imageFile.writeAsBytes(response.bodyBytes);
  //       return imageFile; // Return the image file
  //     } else {
  //       throw Exception('Failed to load image: ${response.body}');
  //     }
  //   } catch (e) {
  //     print("Failed to generate image: $e");
  //     rethrow;
  //   }
  // }
  static Future<File> generateImage(String sentence, String clause,
      int seedNumber, bool isRegenerated) async {
    String apiKey = dotenv.env['API_KEY']!;
    String seed = seedNumber.toString();

    String translatedSentence = await translation(sentence);
    String translatedClause = await translation(clause);
    String text = "";

    if (isRegenerated) {
      text =
          "Generate an image of '$translatedClause' based on this context '$translatedSentence' in $selectedImageStyle style, with different POV ";
    } else {
      text =
          "Generate an image of '$translatedClause' based on this context '$translatedSentence' in $selectedImageStyle style";
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
  // Future<void> generateAllImages() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   List<Map<String, dynamic>> tempSentenceImagePairs = [];
  //   List<String> clauses = [];

  //   if (selectedImageStyle != null) {
  //     for (var sentenceMap in globaltopsisScoresList) {
  //       String sentence = sentenceMap['sentence'];
  //       //print("sentence: $sentence");
  //       List<File> imagesForSentence = [];
  //       print("sentence: $sentence");
  //       for (var clause in globaltopClausesToIllustrate) {
  //         if (sentence.contains(clause)) {
  //           clauses.add(clause);
  //           try {
  //             // Generate an image for the sentence containing the clause
  //             File imageFile = await generateImage(sentence, clause, seed, isRegenerated);
  //             imagesForSentence.add(imageFile);
  //             setState(() {
  //               generatedImagesCount++;
  //             });
  //           } catch (error) {
  //             print("Error generating image for sentence '$sentence': $error");
  //           }
  //         }
  //       }

  //       // Add the sentence to tempSentenceImagePairs regardless of whether images were generated
  //       tempSentenceImagePairs.add({
  //         "sentence": sentence.trim(),
  //         "images":
  //             imagesForSentence, // This could be an empty list if no images were generated
  //       });
  //       print("tempSentenceImagePairs: $tempSentenceImagePairs");
  //       print("clauses: $clauses");
  //     }
  //   }
  //   // Update the global sentenceImagePairs with the generated data
  //   setState(() {
  //     sentenceImagePairs = tempSentenceImagePairs;
  //     //print(sentenceImagePairs);
  //     isLoading = false;
  //   });

  //   // You might want to navigate or update UI here to reflect that the process is complete
  //   print("Completed image generation for sentences.");
  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => const EditBeforePdf()),
  //       (Route<dynamic> route) => false);
  // }

  Future<void> generateAllImages() async {
    setState(() {
      isLoading = true;
    });

    for (var sentencePair in sentenceImagePairs) {
      for (var clause in sentencePair.clauses) {
        if (globaltopClausesToIllustrate.contains(clause.text) &&
            clause.image == null) {
          // Only generate if there's no image
          try {
            File newImage = await generateImage(
                sentencePair.sentence, clause.text, seed, isRegenerated);
            clause.image = newImage;
            setState(() {
              generatedImagesCount++;
            });
          } catch (error) {
            print("Error generating image for clause '${clause.text}': $error");
          }
        }
      }
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

Future<String> OLDgenerateImage(String sentence, String prompt) async {
  OpenAI.apiKey = dotenv.env['OPENAI_KEY']!;
  //OpenAI.apiKey =FlutterConfig.get('OPENAI_KEY'); // Accessing the OpenAI API Key
  // String imageStylePrompt =
  //     selectedImageStyle != null ? " in style $selectedImageStyle" : "";

  try {
    final OpenAIImageModel image = await OpenAI.instance.image.create(
      //prompt: "from this sentence:'$sentence' generate:'$prompt'",
      prompt:
          "أنشئ صورة  $selectedImageStyle لهذه العبارة: '$prompt' من هذة الجملة: '$sentence'",

      //"Generate a $selectedImageStyle image for '$prompt' from this story:'$sentence'",
      model: "dall-e-3", // Explicitly specifying the model
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

Future<String> translation(String text) async {
  var API_key = dotenv.env['GOOGLE_TRANSLATE_KEY']!;

  //var API_key = FlutterConfig.get('GOOGLE_TRANSLATE_KEY'); // Accessing the Google Translate API Key
  //const API_key = 'AIzaSyBPai8q0ugOh1-wowQBpa2k0Gae1N5e-_k';
  const to = 'en'; //Destination language

  final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?q=$text&target=$to&key=$API_key');

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
