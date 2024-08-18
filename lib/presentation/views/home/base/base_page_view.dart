import 'package:flutter/material.dart';
import '../../../_widgets/home/base/custom_app_bar_widget.dart';
import '../../../_widgets/home/base/footer_widget.dart';

class BasePageView extends StatelessWidget {
  final Widget child;
  final bool showFooter;
  final VoidCallback onLogout;

  const BasePageView({
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
