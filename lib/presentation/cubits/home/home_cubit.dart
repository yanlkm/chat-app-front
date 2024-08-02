
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(selectedIndex: 0, isAdmin: false)) {
    _checkIfUserIsAdmin();
  }

  void selectTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  Future<void> _checkIfUserIsAdmin() async {
    const secureStorage = FlutterSecureStorage();
    String? role = await secureStorage.read(key: 'role');
    if (role == 'admin') {
      emit(state.copyWith(isAdmin: true));
    }
  }
}
