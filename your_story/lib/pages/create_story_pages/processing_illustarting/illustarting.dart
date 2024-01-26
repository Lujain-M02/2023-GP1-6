import 'package:flutter/material.dart';

class Illustration extends StatefulWidget {
    final String title;
  final String content;
  final List<dynamic> clausesToIllujstrate;

  Illustration({Key? key, required this.title, required this.content, required this.clausesToIllujstrate}) : super(key: key);


  @override
  State <Illustration> createState() => _IllustrationState();
}

class _IllustrationState extends State<Illustration> {
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
}