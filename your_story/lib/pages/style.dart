import 'package:flutter/material.dart';

class your_story_Style {
  static Color backgroundColor = const Color.fromARGB(
      255, 238, 245, 255); // Replace with your desired background color
  static Color buttonColor = Color.fromARGB(
      255, 238, 239, 223); // Replace with your desired button color
  static Color buttonShadowColor = Color.fromARGB(
      255, 230, 224, 224); // Replace with your desired button shadow color
  static Color titleColor =
      Color.fromARGB(255, 1, 16, 87); // Replace with your desired title color
  static Color textColor =
      Color.fromARGB(255, 37, 53, 120); // Replace with your desired text color

  static BoxDecoration buttonDecoration = BoxDecoration(
    color: buttonColor,
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: [
      BoxShadow(
        color: buttonShadowColor,
        blurRadius: 4.0,
        offset: Offset(0, 4),
      ),
    ],
  );
}
