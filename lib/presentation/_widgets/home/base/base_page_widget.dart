import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_app_bar_widget.dart';
import 'footer_widget.dart';

class BasePageWidget extends StatelessWidget {
  final Widget child;
  final bool showFooter;
  final VoidCallback onLogout;

  const BasePageWidget({
    super.key,
    required this.child,
    this.showFooter = true,
    required this.onLogout,
  });

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