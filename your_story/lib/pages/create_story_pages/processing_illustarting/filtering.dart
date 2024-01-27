import 'package:flutter/material.dart';
import 'global_story.dart';

class Filtering extends StatefulWidget {

  Filtering({Key? key}) : super(key: key);


  @override
  State <Filtering> createState() => _IllustrationState();
}

class _IllustrationState extends State<Filtering> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحة الفلتر'),
      ),
      body: Column(
        children: [
          Text(globalContent),
          Text(globaltopClausesToIllustrate[0])
        ]
        

      ),
    );
  }
}