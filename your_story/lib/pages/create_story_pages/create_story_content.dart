import 'package:flutter/material.dart';

class CreateStoryContent extends StatefulWidget {
  const CreateStoryContent({Key? key}) : super(key: key);

  @override
  State<CreateStoryContent> createState() => _CreateStoryContent();
}

class _CreateStoryContent extends State<CreateStoryContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
         height: 50,
         width: MediaQuery.of(context).size.width,
         color: Colors.blue,
    //     child: Center(
    //       child: Text("Step One",style: TextStyle(fontSize: 20,color: Colors.white),),
    //     ),
     );
  }
}