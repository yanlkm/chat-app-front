import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/authentification/register_service.dart';
import 'package:my_app/views/utils/error_popup.dart';

import '../../models/utils/error.dart';
import '../../models/user.dart';

class RegisterController {
  final RegisterService registerService;

  RegisterController({required this.registerService});

  Future<dynamic> register(BuildContext context, String username, String password, String code) async {
    try {
      // Call the register service
      final result = await registerService.register(username, password, code);

     return result;
    } catch (e) {
     return ErrorResponse(error: 'An error occurred. Please try again.');
    }
  }
}
