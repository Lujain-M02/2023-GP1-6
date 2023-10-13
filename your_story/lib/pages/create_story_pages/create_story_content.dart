import 'package:flutter/material.dart';

class CreateStoryContent extends StatelessWidget {
  const CreateStoryContent(
      {Key? key, required this.contentController, required this.title})
      : super(key: key);
  final TextEditingController contentController;
  final String title;

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الرجاء إدخال نص القصة";
    } else if (!RegExp(r'^[ء-ي\s]+$').hasMatch(value)) {
      return "القصة يجب أن تكون باللغة العربية فقط";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hint Card
        const Card(
          color: Colors.transparent,
          elevation: 0,
          child: ListTile(
            horizontalTitleGap: -15,
            contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
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

        // Text Form Field
        Form(
          autovalidateMode: AutovalidateMode.always,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              controller: contentController,
              maxLines: null, // This allows multiple lines for long text
              decoration: const InputDecoration(
                labelText: "أطلق العنان لإبداعات!",
                contentPadding: EdgeInsets.all(10),
              ),
              validator: validateTitle,
            ),
          ),
        ),
      ],
    );
  }
}

/*class CreateStoryContent extends StatelessWidget {
  const CreateStoryContent(
      {Key? key, required this.contentController, required this.title})
      : super(key: key);
  final TextEditingController contentController;
  final String title;
  Widget build(BuildContext context) {
    return Column(
      children: [
        // this widget for the hint above the container
        Card(
          color: Colors.transparent,
          elevation: 0,
          child: ListTile(
            horizontalTitleGap: -15,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 0.0), // Adjust the padding here
            leading: const Icon(
              Icons.lightbulb,
              color: Colors.amber,
              size: 20,
            ),
            title: Text(
              "حاول أن تكون كتابتك واضحة وصحيحة!\n    ${title}",
              style: const TextStyle(fontSize: 14),
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
            controller: contentController,
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
              if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
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
}*/
