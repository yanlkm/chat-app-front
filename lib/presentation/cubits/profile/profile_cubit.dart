import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/users/user_usecases.dart';

import '../../../domain/entities/users/user_entity.dart';
import '../../../utils/errors/handlers/network_error_handler.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {
  ProfileInitial();
}

class ProfileLoading extends ProfileState {
  ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final String message;
  final bool hasError;

  ProfileLoaded(this.user, this.message, this.hasError);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final UserUseCases userUseCases;

  ProfileCubit(this.userUseCases) : super(ProfileInitial());

  Future<void> loadDynamically(UserEntity user, String message) async {
    if(state is ProfileLoaded){
      emit(ProfileLoaded(user, message, false));
    }
  }

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final Either<NetworkErrorHandler, UserEntity> result = await userUseCases.getUser();

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

  Future<void> updateUsername(String username) async {
    if (state is ProfileLoaded) {
      try {
        final user = (state as ProfileLoaded).user;

        // Assuming you have an updateUsername use case
        final result = await userUseCases.updateUsername(username);

        result.fold(
              (error) => emit(ProfileLoaded(user, error.message, true)),
              (successMessage) {
            UserEntity updatedUser = user.copyWith(username: username, updatedAt: DateTime.now());
            emit(ProfileLoaded(updatedUser, successMessage, false));
          },
        );
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
