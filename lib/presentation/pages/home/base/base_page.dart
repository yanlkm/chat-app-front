import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/pages/home/welcome/welcome_page.dart';

import '../../../../controllers/authentification/logout_controller.dart';
import '../../../cubits/home/base/base_page_cubit.dart';
import '../../../views/home/base/base_page_view.dart';


class BasePage extends StatelessWidget {
  final Widget child;
  final bool showFooter;
  final LogoutController logoutController;

  const BasePage({
    super.key,
    required this.child,
    this.showFooter = true,
    required this.logoutController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BasePageCubit(logoutController: logoutController),
      child: BlocListener<BasePageCubit, void>(
        listener: (context, state) {
          // Handle state changes if necessary
        },
        child: BasePageView(
          showFooter: showFooter,
          onLogout: () async {
            await context.read<BasePageCubit>().logoutUser();
            // Navigate to WelcomePage
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomePage()),
            );
          },
          child: child,
        ),
      ),
    );
  }
}
