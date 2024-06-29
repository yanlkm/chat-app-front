import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/user/profile_service.dart';

import '../../models/user.dart';

class ProfileController {
  final ProfileService profileService;
  // Constructor
  ProfileController({required this.profileService});
  // Get user profile
  Future<User?> getProfile(BuildContext context) async {
    try {
      // Call the get user profile service
      final response = await profileService.getUserProfile();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User profile loaded successfully.'),
          duration: Duration(seconds: 3),
        ),
      );
      return response;

        } catch (e) {
      if (kDebugMode) {
        print('Failed to load user profile: $e');
      }
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connexion error. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
      // TODO : Add a condition to check if user is empty redirect, then redirect
      return User();

    }
  }
  Future<String> updateUsername(String username) async {
    try {
      // Call the update username service
      final response = await profileService.updateUsername(username);
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
      final response = await profileService.updatePassword(oldPassword, newPassword);
      return response;
    } catch (e) {
      // return the error message
      return 'Failed to update password';
    }
  }
}