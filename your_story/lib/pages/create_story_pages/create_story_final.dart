import 'package:flutter/material.dart';

class CreateStoryFinal extends StatelessWidget {
  const CreateStoryFinal({Key? key, required this.title, required this.content})
      : super(key: key);
  final String title, content;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Text(
            "العنوان : ${title}",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            "${content}",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
