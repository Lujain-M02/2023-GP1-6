import 'package:flutter/material.dart';

class CreateStoryTitle extends StatefulWidget {
  const CreateStoryTitle({Key? key}) : super(key: key);

  @override
  State<CreateStoryTitle> createState() => _CreateStoryTitle();
}

class _CreateStoryTitle extends State<CreateStoryTitle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
             height: 50,
             width: MediaQuery.of(context).size.width,
             color: Colors.blueGrey,
         ),
         // this widget for the hint under the container
         const Card(
          color: Colors.transparent,
          elevation: 0,
          child:  ListTile(
            horizontalTitleGap: -15,
            contentPadding: EdgeInsets.symmetric(horizontal: 0.0), // Adjust the padding here
            leading: Icon(Icons.lightbulb, color: Colors.amber, size: 20,),
            title: Text("اجعله قصيرا معبرا", style: TextStyle(fontSize: 14),),
          ),
         )
      ],
    );
  }
}