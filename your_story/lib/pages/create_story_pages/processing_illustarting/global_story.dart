import 'dart:io';
import 'dart:typed_data';

String globalTitle = "";
String globalContent = "";
int globalTotalNumberOfClauses = 0;
List<Map<String, dynamic>> globaltopsisScoresList = [];
List<String> globaltopClausesToIllustrate = [];
List<String> globalImagesUrls = [];
String? globalDraftID = null;
List<SentencePair> sentenceImagePairs = [];
String searchQuery1 = '';
String? selectedImageStyle;

class SentencePair {
  String sentence;
  List<Clause> clauses;

  SentencePair({required this.sentence, required this.clauses});

  Object? get text => null;

  get image => null;
}

class Clause {
  String text;
  File? image;
  Uint8List? imageData;
  Clause({required this.text, this.image});
}
