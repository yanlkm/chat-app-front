import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/user/profile_service.dart';

import '../../models/user.dart';

class ProfileController {
  final ProfileService profileService;

  ProfileController({required this.profileService});

  Future<User?> getProfile(BuildContext context) async {
    try {
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
}