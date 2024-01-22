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
                  Text(content),
                  const SizedBox(height: 20), // Adjust as needed for spacing
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: YourStoryStyle.primarycolor, // Button background color
                    ),
                    child: const Text(
                      "حسنا",
                      style: TextStyle(
                        color: Colors.white, // Button text color
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
  }) : super(
          key: key,
          content: Row(
            children: <Widget>[
              const Icon(
                Icons.warning,
                color: Color.fromARGB(255, 248, 243, 212),
              ),
              const SizedBox(width: 8), 
              Text(
                content,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB( 255, 15, 26, 107),
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
          child: Container(
            padding: const EdgeInsets.all(16),
            child: child
          ),
        ),
      );
    },
  );
}