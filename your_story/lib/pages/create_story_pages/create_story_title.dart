import 'package:flutter/material.dart';

class CreateStoryTitle extends StatefulWidget {
  const CreateStoryTitle({Key? key}) : super(key: key);

  @override
  State<CreateStoryTitle> createState() => _CreateStoryTitle();
}

class _CreateStoryTitle extends State<CreateStoryTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
         height: 50,
         width: MediaQuery.of(context).size.width,
         color: Colors.blueGrey,
    //     child: Center(
    //       child: Text("Step One",style: TextStyle(fontSize: 20,color: Colors.white),),
    //     ),
     );
  }
}