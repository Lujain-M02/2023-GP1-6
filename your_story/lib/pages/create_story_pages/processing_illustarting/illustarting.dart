import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
// import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    generateAllImages();
  }

  void generateAllImages() async {
    setState(() {
      isLoading = true;
    });
    //List<String> urls = [];
    for (var clause in globaltopClausesToIllustrate) {
      // Translate the clause first
      String translatedClause = await translateClause(clause);

      // Then generate image for the translated clause
      String imageUrl = await generateImage(translatedClause);
      globalImagesUrls.add(imageUrl);
      //urls.add(imageUrl);
    }
    setState(() {
      //imageUrls = urls;
      isLoading = false;
    });
  }

  @override
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
        onPressed: () async {Navigator.of(context).push(
               MaterialPageRoute(
               builder: (context) => PdfGenerationPage(
                 ),
               ),
             );  
           },
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }
}

Future<String> generateImage(String prompt) async {
  OpenAI.apiKey = dotenv.env['OPENAI_KEY']!;
  //OpenAI.apiKey =FlutterConfig.get('OPENAI_KEY'); // Accessing the OpenAI API Key
  try {
    final OpenAIImageModel image = await OpenAI.instance.image.create(
      prompt: prompt,
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
    print('Original: $clause');
    print('Translated: $translation');

    return translation;
  } else {
    print('Translation Error: ${response.statusCode}');
    return 'Translation Error: ${response.statusCode}';
  }
}
