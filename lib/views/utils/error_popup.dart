import 'package:flutter/material.dart';

class ErrorDisplayIsolate {
  // Add the showErrorDialog method
  static void showErrorDialog(BuildContext context, String message) {

    // Add the AlertDialog widget
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Add the title and content
        title: const Text(
          'Error Message',
          style: TextStyle(color: Colors.red, fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        content: Text(message,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: <Widget>[
          ElevatedButton(
            // Add the onPressed method to close the dialog
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.5),
        ),
      ),
    );
  }

  // Add the showErrorSnackBar method to display a SnackBar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        padding: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        width: 500,
      ),
    );
  }

}

