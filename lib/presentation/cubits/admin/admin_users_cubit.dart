import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/domain/use_cases/users/user_usecases.dart';

// UserState
abstract class UserState {
  UserState();
}

// UserInitial : initial state
class UserInitial extends UserState {
  UserInitial();
}

// UserLoading : loading state
class UserLoading extends UserState {
  UserLoading();
}

// UserLoaded : loaded state
class UserLoaded extends UserState {
  final List<UserEntity> users;
  final UserEntity? userFound;
  final String message;

  UserLoaded(this.users,
      this.userFound,
      this.message);
}

// UserError : error state
class UserError extends UserState {
  final String message;

  UserError(this.message);
}

// UserCubit : cubit for user
class UserCubit extends Cubit<UserState> {
  final UserUseCases userUseCases;
  final ValueNotifier<List<UserEntity>> userNotifier;
  final ValueNotifier<UserEntity> userFoundNotifier;


  // Constructor
  UserCubit(this.userUseCases, this.userFoundNotifier, this.userNotifier) :
        super(UserInitial());

  // loadUsers method
  Future<void> loadUsers() async {
    try {
      // eitherUsersOrError as attribute : get users
      final eitherUsersOrError = await userUseCases.getUsers();
      eitherUsersOrError.fold(
        // if error emit UserError
              (error) => emit(UserError(error.message)),
              (userEntities) {
            // if success emit UserLoaded
            userNotifier.value = userEntities;
            emit(UserLoaded(userNotifier.value, const UserEntity(), "Users loaded successfully"));
          });
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // searchUser method
  Future<void> searchUser(String userUniqueReference) async{
    try {
      // define users as empty list
      List<UserEntity> users = [];
      // get users
      final eitherUsersOrError = await userUseCases.getUsers();
      // if error emit UserError
      eitherUsersOrError.fold(
              (error) => emit(UserError(error.message)),
              (userEntities) {
                // if success set users to userEntities
                users = userEntities;
              }
      );
      if (userUniqueReference.isEmpty) {
        // if the search string is empty, set the userNotifier value to an empty user
        userFoundNotifier.value = const UserEntity();
        return;
      }
      // find the user by username or user id
      UserEntity user = users.firstWhere(
              (user) => user.username == userUniqueReference || user.userID == userUniqueReference,
              orElse: () => const UserEntity());
      if(user == const UserEntity()){
        // if the user is not found set the userNotifier value to an empty user
        userFoundNotifier.value = const UserEntity();
        return;
      }
      //update userNotifier
      userFoundNotifier.value = user;
      UserLoaded(users,user,"User found successfully");
    } catch(e) {
      // throw error while during search
      UserError("Error occurred performing research");
      return;
    }
  }

  Future<void> banUser(String userId) async {
    try {
      // Optimistically update state
      final updatedUsers = userNotifier.value.map((user) {
        if (user.userID == userId) {
          return user.copyWith(validity: 'invalid');
        }
        return user;
      }).toList();

      emit(UserLoaded(updatedUsers, userFoundNotifier.value, "User banned successfully"));

      // Call the use case to ban the user
      await userUseCases.banUser(userId);
    } catch (e) {
      // Revert the state if there's an error
      emit(UserError("Failed to ban user: $e"));
    }
  }

  Future<void> unbanUser(String userId) async {
    try {
      // Optimistically update state
      final updatedUsers = userNotifier.value.map((user) {
        if (user.userID == userId) {
          return user.copyWith(validity: 'valid');
        }
        return user;
      }).toList();

      emit(UserLoaded(updatedUsers, userFoundNotifier.value, "User unbanned successfully"));

      // Call the use case to unban the user
      await userUseCases.unbanUser(userId);
    } catch (e) {
      // Revert the state if there's an error
      emit(UserError("Failed to unban user: $e"));
    }
  }

}
