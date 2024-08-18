import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../models/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final User? userFound;
  final String message;

  UserLoaded(this.users,
      this.userFound,
      this.message);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class UserCubit extends Cubit<UserState> {
  final UserController userController;
  final ValueNotifier<List<User>> userNotifier;
  final ValueNotifier<User> userFoundNotifier;


  UserCubit(this.userController, this.userFoundNotifier, this.userNotifier) :
        super(UserInitial());

  Future<void> loadUsers() async {
    try {
      List<User> users = await userController.getUsers();
      if (users.isEmpty) {
        emit(UserError('No users found'));
        return;
      }
      userNotifier.value = users;
      emit(UserLoaded(userNotifier.value,null, 'Users loaded successfully'));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> searchUser(String userUniqueReference) async{
    try {
      print("PERFORMING USER SEARCH");
      // Call the get users service
      List<User> users = await userController.getUsers();
      if (userUniqueReference.isEmpty) {
        // if the search string is empty, set the userNotifier value to an empty user
        return;
      }
      // find the user by username or user id
      User user = users.firstWhere(
              (user) => user.username == userUniqueReference || user.userID == userUniqueReference,
              orElse: () => User());
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
      await userController.banUser(userId);
      await loadUsers(); // Reload users after banning
    } catch (e) {
      // Handle the error
      emit(UserError(e.toString()));
    }
  }

  Future<void> unbanUser(String userId) async {
    try {
      await userController.unbanUser(userId);
      await loadUsers(); // Reload users after unbanning
    } catch (e) {
      // Handle the error
      emit(UserError(e.toString()));
    }
  }
}
