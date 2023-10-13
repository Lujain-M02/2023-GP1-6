import 'package:flutter/material.dart';

class CreateStoryTitle extends StatelessWidget {
  const CreateStoryTitle({super.key, required this.titleController});

  final TextEditingController titleController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // this widget for the hint under the container
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
              "أبق عنوانك قصيرًا، معبرًا وواضحًا!",
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
            controller: titleController,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: "أدخل العنوان هنا",
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
}

/*class _CreateStoryTitle extends State<CreateStoryTitle> {
  final formKey = GlobalKey<FormState>();
  String name = "";
  @override
  /*Widget build(BuildContext context) {
    return Container(
         height: 550,
         width: MediaQuery.of(context).size.width,
         color: Colors.blueGrey,
    //     child: Center(
    //       child: Text("Step One",style: TextStyle(fontSize: 20,color: Colors.white),),
    //     ),
     );
  }*/
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return SingleChildScrollView(
      // Wrap with SingleChildScrollView
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20), // Reduce padding
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: height * 0.04),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: "أدخل العنوان هنا",
                    hintText: "أبق عنوانك قصيرًا، معبرًا وواضحًا!",
                    prefixIcon: Icon(Icons.book),
                    contentPadding: EdgeInsets.all(10), // Add content padding
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value!)) {
                      return "enter correct name";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
