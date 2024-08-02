import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllers/user/user_controller.dart';
import '../../../models/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {

}

class ProfileLoaded extends ProfileState {
  final User user;
  final String message;

  ProfileLoaded(this.user, this.message);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

}

class ProfileCubit extends Cubit<ProfileState> {
  final UserController userController;

  ProfileCubit(this.userController) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final user = await userController.getProfile();
      emit(ProfileLoaded(user!, 'Profile loaded successfully'));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateUsername(String username) async {
    if (state is ProfileLoaded) {
      try {
        final result = await userController.updateUsername(username);
          if (result.contains('Failed to update username')) {
            final user = (state as ProfileLoaded).user;
            emit(ProfileLoaded(user,result));
          } else {
            final updatedUser = (state as ProfileLoaded) .user..username = username;
            emit(ProfileLoaded(updatedUser, result));
          }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }
}
