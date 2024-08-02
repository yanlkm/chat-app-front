import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/user/user_service.dart';

import '../../models/user.dart';

class UserController {
  final UserService userService;
  // Constructor
  UserController({required this.userService});
  // Get user profile
  Future<User?> getProfile() async {
    try {
      // Call the get user profile service
      final response = await userService.getUserProfile();
      // Display success message
      return response;

        } catch (e) {
      if (kDebugMode) {
        print('Failed to load user profile: $e');
      }
      // TODO : Add a condition to check if user is empty redirect, then redirect
      return User();

    }
  }
  Future<String> updateUsername(String username) async {
    try {
      // Call the update username service
      final response = await userService.updateUsername(username);
      // return the response
      return response;
    } catch (e) {
      return 'Failed to update username $e';
    }
  }

  // Update password
  Future<String> updatePassword(String oldPassword, String newPassword) async {
    try {
      // Call the update password service
      final response = await userService.updatePassword(oldPassword, newPassword);
      return response;
    } catch (e) {
      // return the error message
      return 'Failed to update password';
    }
  }

  // get users : call in the admin page
  Future<List<User>> getUsers() async {
    try {
      // Call the get users service
      final response = await userService.getUsers();
      // debug
      print("Users: $response");
      return response;

    } catch (e) {
      // return the error message
      return [];
    }
  }

  // ban user : call in the admin page
  Future<String> banUser(String userId) async {
    try {
      // Call the ban user service
      final response = await userService.banUser(userId);
      return response;
    } catch (e) {
      // return the error message
      return 'Failed to ban user';
    }
  }

  // unban user : call in the admin page
  Future<String> unbanUser(String userId) async {
    try {
      // Call the unban user service
      final response = await userService.unbanUser(userId);
      return response;
    } catch (e) {
      // return the error message
      return 'Failed to unban user';
    }
  }

  // create userRegister code
  Future<String> createRegistrationCode(String code) async {
    try {
      final response = await userService.createRegistrationCode(code);
      return response;

    } catch(e) {
      // return the error message
      return 'Failed to create registration code';
    }
  }
}