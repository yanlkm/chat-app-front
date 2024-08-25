import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';

import '../../../cubits/home/base/base_page_cubit.dart';
import '../../../views/home/base/base_page_view.dart';


class BasePage extends StatelessWidget {
  final Widget child;
  final bool showFooter;
  final AuthUseCases authUseCases;

  const BasePage({
    super.key,
    required this.child,
    required this.showFooter ,
    required this.authUseCases,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BasePageCubit(authUseCases: authUseCases),
      child: BasePageView(
        showFooter: showFooter,
        child: child,
      ),
    );
  }
}
