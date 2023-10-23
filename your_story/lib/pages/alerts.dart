
import 'package:flutter/material.dart';


class ConfirmationDialog {
  static void show(BuildContext context, String alertMessage,  Function onConfirm) {
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
                onConfirm();//this function received as class parameter
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