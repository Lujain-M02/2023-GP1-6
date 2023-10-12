import 'package:flutter/material.dart';

class CreateStoryContent extends StatefulWidget {
  const CreateStoryContent({Key? key}) : super(key: key);

  @override
  State<CreateStoryContent> createState() => _CreateStoryContent();
}

/*class _CreateStoryContent extends State<CreateStoryContent> {
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
}*/
class _CreateStoryContent extends State<CreateStoryContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // this widget for the hint above the container
        const Card(
          color: Colors.transparent,
          elevation: 0,
          child: ListTile(
            horizontalTitleGap: -15,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0), // Adjust the padding here
            leading: Icon(
              Icons.lightbulb,
              color: Colors.amber,
              size: 20,
            ),
            title: Text(
              "حاول أن تكون كتابتك واضحة وصحيحة!",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),

        Container(
          // height: 50,
          //width: MediaQuery.of(context).size.width,
          //color: Colors.blueGrey,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            maxLines: null,
            decoration: const InputDecoration(
              labelText: "أطلق العنان لإبداعاتك!",
              //hintText: "أبق عنوانك قصيرًا، معبرًا وواضحًا!",
              /*prefixIcon: Icon(
                Icons.lightbulb,
                color: Colors.amber,
                size: 20,
              ),*/
              contentPadding: EdgeInsets.all(10), // Add content padding
            ),
            validator: (value) {
              if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value!)) {
                return "enter correct name";
              } else {
                return null;
              }
            },
          ),
        ),
      ],
    );
  }
}
