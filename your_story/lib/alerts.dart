import 'package:flutter/material.dart';
import 'package:your_story/style.dart';

//this class shows a message with two buttons متأكد و الغاء
class ConfirmationDialog {
  static void show(
      BuildContext context, String alertMessage, Function onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text(alertMessage),
            backgroundColor: const Color.fromARGB(201, 232, 242, 255),
            actions: [
              OutlinedButton(
                onPressed: () {
                  onConfirm(); //this function received as class parameter
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: YourStoryStyle.primarycolor,
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: YourStoryStyle.primarycolor,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text("متأكد", style: TextStyle(fontSize: 20)),
              ),
              OutlinedButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: YourStoryStyle.primarycolor,
                  side: BorderSide(
                    color: YourStoryStyle.primarycolor,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text("الغاء", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        );
      },
    );
  }
}

//this class shows a message with only one button "حسنا"
class Alert {
  static void show(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: const Color.fromARGB(201, 232, 242, 255),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(content,style: const TextStyle(fontSize: 20),),
                  const SizedBox(height: 20), // Adjust as needed for spacing
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: YourStoryStyle
                          .primarycolor, // Button background color
                    ),
                    child: const Text(
                      "حسنا",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20 // Button text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

//class for styling snackBar
class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    Key? key,
    required String content,
    required IconData icon,
  }) : super(
          key: key,
          content: Row(
            children: <Widget>[
              Icon(
                icon,
                color: const Color.fromARGB(255, 248, 243, 212),
              ),
              const SizedBox(width: 8),
              Text(
                content,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 15, 26, 107),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
}

void showCustomModalBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0)), // Adjust the radius as needed
    ),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: SingleChildScrollView(
          child: Container(padding: const EdgeInsets.all(16), child: child),
        ),
      );
    },
  );
}

//this alert is special for choosing the images number for story
class NumberPickerAlertDialog {
  static void show(BuildContext context, String title, Function(int?) onConfirm,
      int size, int selectedDefault) {
    int? selectedNumber = selectedDefault; // Default selected number

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: const Color.fromARGB(201, 232, 242, 255),
              title: Text(title),
              content: DropdownButton<int>(
                value: selectedNumber,
                items: List.generate(
                  size,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedNumber = newValue;
                  });
                },
              ),
              actions: [
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (selectedNumber != null) {
                        onConfirm(selectedNumber);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: YourStoryStyle.primarycolor,
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: YourStoryStyle.primarycolor,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text("متأكد", style: TextStyle(fontSize: 20)),
                  ),
                ),
                // OutlinedButton(
                //   onPressed: () => Navigator.of(context).pop(),
                //   style: OutlinedButton.styleFrom(
                //     foregroundColor: Colors.black,
                //     side: BorderSide(
                //       color: YourStoryStyle.primarycolor,
                //       width: 2,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(15.0),
                //     ),
                //   ),
                //   child: const Text("الغاء", style: TextStyle(fontSize: 20)),
                // ),
              ],
            ),
          );
        });
      },
    );
  }
}

// //This alert is special for choosing the images style
// class ImageStylePickerDialog {
//   static Future<String?> show(BuildContext context) async {
//     String? selectedStyle = 'واقعية'; //the default style

//     // Define the styles available for selection
//     final Map<String, String> stylesMap = {
//       'واقعية': 'Photorealistic',
//       'فنية': 'Artistic',
//       'سريالية': 'Surreal',
//       'كرتون': 'Cartoon',
//     };

//     return showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           title: Text('اختر نمط الصورة', textAlign: TextAlign.center),
//           backgroundColor: const Color.fromARGB(201, 232, 242, 255),
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   DropdownButton<String>(
//                     isExpanded: true,
//                     value: selectedStyle,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedStyle = newValue!;
//                       });
//                     },
//                     items: stylesMap.entries
//                         .map<DropdownMenuItem<String>>((entry) {
//                       return DropdownMenuItem<String>(
//                         value: entry.key,
//                         child: Text(entry.key, textAlign: TextAlign.center),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               );
//             },
//           ),
//           actions: <Widget>[
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(stylesMap[selectedStyle]);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   primary: YourStoryStyle.primarycolor,
//                 ),
//                 child: Text('حسنا', style: TextStyle(color: Colors.white)),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class ImageStyle {
  final String title;
  final String style;
  final String imagePath;

  ImageStyle(
      {required this.title, required this.style, required this.imagePath});
}

class ImageStylePickerDialog {
  static Future<String?> show(
      BuildContext context, List<ImageStyle> imageStyles) async {
    String? selectedStyle;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'اختر نمط الصورة',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 20, // Horizontal space between buttons
                  runSpacing: 20, // Vertical space between buttons
                  children: imageStyles.map((imageStyle) {
                    bool isSelected = imageStyle.style == selectedStyle;
                    return InkWell(
                      onTap: () =>
                          setState(() => selectedStyle = imageStyle.style),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      isSelected ? Colors.green : Colors.grey,
                                  width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  imageStyle.imagePath,
                                  width: 80,
                                  height: 80,
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Icon(Icons.check_circle,
                                        color: Colors.green),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(imageStyle.title),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(selectedStyle),
                  style: ElevatedButton.styleFrom(
                    primary: YourStoryStyle.primarycolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child:
                      const Text("حسنا", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
