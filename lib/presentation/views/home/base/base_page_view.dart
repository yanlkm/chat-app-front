import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_widgets/home/base/base_page_widget.dart';
import '../../../cubits/home/base/base_page_cubit.dart';
import '../../../pages/home/welcome/welcome_page.dart';

// BasePageView : base page view
class BasePageView extends StatefulWidget {
  // attributes : child, showFooter
  final Widget child;
  final bool showFooter;

  // Constructor
  const BasePageView({
    super.key,
    required this.child,
    this.showFooter = true,
  });

  // createState method
  @override
  BasePageViewState createState() => BasePageViewState();
}


// BasePageViewState : base page view state
class BasePageViewState extends State<BasePageView> {
  @override
  Widget build(BuildContext context) {
    const secureStorage = FlutterSecureStorage();

    return BlocListener<BasePageCubit, void>(
      listener: (context, state) {
        // Handle state changes if necessary
      },
      child: BasePageWidget(
        showFooter: widget.showFooter,
        onLogout: () async {
          await context.read<BasePageCubit>().logoutUser();
          // Clear secure storage
          await secureStorage.delete(key: 'token');
          await secureStorage.delete(key: 'userId');
          await secureStorage.delete(key: 'username');
          await secureStorage.delete(key: 'role');
          // Navigate to WelcomePage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        },
        child: widget.child,
      ),
    );
  }
}
