import 'package:flutter/material.dart';

class CreateStoryFinal extends StatelessWidget {
  const CreateStoryFinal({Key? key, required this.title, required this.content})
      : super(key: key);
  final String title, content;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "العنوان : ${title}",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Text(
            "المحتوى : ${content}",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
