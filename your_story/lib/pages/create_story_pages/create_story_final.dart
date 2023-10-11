import 'package:flutter/material.dart';

class CreateStoryFinal extends StatefulWidget {
  const CreateStoryFinal({Key? key}) : super(key: key);

  @override
  State<CreateStoryFinal> createState() => _CreateStoryFinal();
}

class _CreateStoryFinal extends State<CreateStoryFinal> {
  @override
  Widget build(BuildContext context) {
    return Container(
         height: 550,
         width: MediaQuery.of(context).size.width,
         color: Colors.amber,
    //     child: Center(
    //       child: Text("Step One",style: TextStyle(fontSize: 20,color: Colors.white),),
    //     ),
     );
  }
}