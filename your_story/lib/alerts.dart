import 'package:flutter/material.dart';

//this class shows a message with two buttons متأكد و الغاء
class ConfirmationDialog {
  static void show(
      BuildContext context, String alertMessage, Function onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                backgroundColor: const Color.fromARGB(255, 5, 34, 57),
                foregroundColor: Colors.white,
                side: const BorderSide(
                  color: Color.fromARGB(255, 5, 34, 57),
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
                foregroundColor: const Color.fromARGB(255, 5, 34, 57),
                side: const BorderSide(
                  color: Color.fromARGB(255, 5, 34, 57),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: const Text("الغاء", style: TextStyle(fontSize: 20)),
            ),
          ],
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
        return Center(
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
                    backgroundColor: const Color.fromARGB(
                        255, 5, 34, 57), // Button background color
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
              Icon(
                Icons.warning,
                color: Color.fromARGB(255, 248, 212, 212),
              ),
              SizedBox(width: 8), 
              Text(
                content,
                style: TextStyle(color: Colors.white),
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