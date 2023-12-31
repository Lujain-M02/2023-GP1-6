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
          Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height:
              MediaQuery.of(context).size.height * 0.06,
            decoration: const BoxDecoration(
              color: Color.fromARGB(123, 187, 222, 251),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 20, color: Colors.black ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
          width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              color: Color.fromARGB(123, 187, 222, 251),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                content,
                style: const TextStyle(fontSize: 20, color: Colors.black ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
