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
      if (user == null || user.userID == null) {
        emit(ProfileError('Failed to load profile'));
        return;
      }
      emit(ProfileLoaded(user, 'Profile loaded successfully'));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateUsername(String username) async {
    if (state is ProfileLoaded) {
      try {
        final result = await userController.updateUsername(username);
        // TODO : change the way we check if the username was updated (check if the result has right status code)
          if (result.contains('successfully')) {
            User updatedUser = (state as ProfileLoaded) .user..username = username;
            updatedUser.updatedAt = DateTime.now();
            emit(ProfileLoaded(updatedUser, result));
          } else {
            final user = (state as ProfileLoaded).user;
            emit(ProfileLoaded(user,result));
          }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }
}
