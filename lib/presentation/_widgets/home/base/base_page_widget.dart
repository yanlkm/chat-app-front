import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_app_bar_widget.dart';
import 'footer_widget.dart';

// Base Page Widget
class BasePageWidget extends StatelessWidget {
  // Child widget
  final Widget child;
  // Show Footer
  final bool showFooter;
  // Logout action as a callback function
  final VoidCallback onLogout;

  // Constructor
  const BasePageWidget({
    super.key,
    required this.child,
    this.showFooter = true,
    required this.onLogout,
  });

  // main build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onLogout: onLogout),
      body: Column(
        children: [
          Expanded(child: child),
          if (showFooter) const Footer(),
        ],
      ),
    );
  }
}