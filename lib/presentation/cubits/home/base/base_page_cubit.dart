import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../controllers/authentification/logout_controller.dart';

class BasePageCubit extends Cubit<void> {
  final LogoutController logoutController;

  BasePageCubit({required this.logoutController}) : super(null);

  Future<void> logoutUser() async {
    await logoutController.Logout();
  }
}
