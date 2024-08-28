import 'package:flutter/material.dart';

// Footer Widget
class Footer extends StatelessWidget {
  // Constructor
  const Footer({super.key});

  // main build method
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Text(
        "Footer text goes here",
        style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}