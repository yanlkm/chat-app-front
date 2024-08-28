import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/users/user_usecases.dart';

import '../../../domain/entities/users/user_entity.dart';
import '../../../utils/errors/handlers/network_error_handler.dart';

// ProfileState
abstract class ProfileState {}

// ProfileInitial : initial state
class ProfileInitial extends ProfileState {
  ProfileInitial();
}

// ProfileLoading : loading state
class ProfileLoading extends ProfileState {
  ProfileLoading();
}

// ProfileLoaded : loaded state
class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final String message;
  final bool hasError;

  ProfileLoaded(this.user, this.message, this.hasError);
}

// ProfileError : error state
class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

// ProfileCubit : cubit for profile
class ProfileCubit extends Cubit<ProfileState> {
  final UserUseCases userUseCases;

  ProfileCubit(this.userUseCases) : super(ProfileInitial());

  // loadProfile method : load profile dynamically
  Future<void> loadDynamically(UserEntity user, String message) async {
    if(state is ProfileLoaded){
      emit(ProfileLoaded(user, message, false));
    }
  }

  // loadProfile method : load profile using userUseCases
  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      // get user
      final Either<NetworkErrorHandler, UserEntity> result = await userUseCases.getUser();

      // fold result
      result.fold(
            (error) => emit(ProfileError(error.message)),
            (user) {
          if (user.userID == null) {
            emit(ProfileError('Failed to load profile'));
          } else {
            emit(ProfileLoaded(user, 'Profile loaded successfully', false));
          }
        },
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // updateUsername method : update username
  Future<void> updateUsername(String username) async {
    if (state is ProfileLoaded) {
      try {
        final user = (state as ProfileLoaded).user;

        // update username
        final result = await userUseCases.updateUsername(username);

        // fold result
        result.fold(
              (error) => emit(ProfileLoaded(user, error.message, true)),
              (successMessage) {
            UserEntity updatedUser = user.copyWith(username: username, updatedAt: DateTime.now());
            emit(ProfileLoaded(updatedUser, successMessage, false));
          },
        );
        // catch error
      } catch (e) {
        if (state is ProfileLoaded) {
          final user = (state as ProfileLoaded).user;
          emit(ProfileLoaded(user, e.toString(), true));
        } else {
          emit(ProfileError(e.toString()));
        }
      }
    }
  }
}
