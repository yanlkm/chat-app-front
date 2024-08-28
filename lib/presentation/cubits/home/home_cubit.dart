
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
part 'home_state.dart';

// HomeCubit
class HomeCubit extends Cubit<HomeState> {
  // Constructor
  HomeCubit() : super(const HomeState(selectedIndex: 0, isAdmin: false)) {
    _checkIfUserIsAdmin();
  }

  // selectTab method
  void selectTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  // _checkIfUserIsAdmin method
  Future<void> _checkIfUserIsAdmin() async {
    const secureStorage = FlutterSecureStorage();
    String? role = await secureStorage.read(key: 'role');
    if (role == 'admin') {
      emit(state.copyWith(isAdmin: true));
    }
  }
}
