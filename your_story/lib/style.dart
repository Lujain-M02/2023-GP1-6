import 'package:flutter/material.dart';

class YourStoryStyle {
  static Color s2Color = const Color.fromARGB(
      255, 0, 48, 96);//1, 16, 87
  static Color backgroundColor = const Color.fromARGB(
      255, 238, 245, 255); //  background color
  static Color buttonColor = const Color.fromARGB(
      255, 238, 239, 223); // button color
  static Color buttonShadowColor = const Color.fromARGB(
      255, 230, 224, 224); //  button shadow color
  static Color primarycolor = const
      Color.fromARGB(255, 1, 16, 87); //  title color
  static Color textColor = const
      Color.fromARGB(255, 37, 53, 120); // text color

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
const kBackgroundColor = Color(0xFFF1EFF1);
const kPrimaryColor = Color.fromARGB(255, 2, 58, 107);
const kSecondaryColor = Color.fromARGB(255, 206, 225, 248);
const kTextColor = Color(0xFF000839);
const kTextLightColor = Color(0xFF747474);
const kBlueColor = Color.fromRGBO(5, 0, 140, 1);

const kDefaultPadding = 20.0;

// our default Shadow
const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12, // Black color with 12% opacity
);
