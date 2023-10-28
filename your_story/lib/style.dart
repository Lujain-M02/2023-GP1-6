import 'package:flutter/material.dart';

class YourStoryStyle {
  static Color backgroundColor = const Color.fromARGB(
      255, 238, 245, 255); // Replace with your desired background color
  static Color buttonColor = const Color.fromARGB(
      255, 238, 239, 223); // Replace with your desired button color
  static Color buttonShadowColor = const Color.fromARGB(
      255, 230, 224, 224); // Replace with your desired button shadow color
  static Color titleColor = const
      Color.fromARGB(255, 1, 16, 87); // Replace with your desired title color
  static Color textColor = const
      Color.fromARGB(255, 37, 53, 120); // Replace with your desired text color

  static BoxDecoration buttonDecoration = BoxDecoration(
    color: buttonColor,
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: [
      BoxShadow(
        color: buttonShadowColor,
        blurRadius: 4.0,
        offset:const Offset(0, 4),
      ),
    ],
  );
}
