import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/user/user_rooms_controller.dart';
import 'package:my_app/views/home/base_page.dart';
import 'package:my_app/views/utils/error_popup.dart';
import 'package:my_app/views/home/welcome_page.dart';
import '../../controllers/authentification/logout_controller.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/room.dart';
import '../../models/user.dart';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  // Add the UserController, userRoomsController, logoutController, and roomsNotifier properties
  final UserController userController;
  final UserRoomsController userRoomsController;
  final LogoutController logoutController;
  final ValueNotifier<List<Room>> roomsNotifier;

  // Add the UserController, userRoomsController, logoutController, and roomsNotifier to the constructor
  const ProfilePage({
    super.key,
    required this.userController,
    required this.userRoomsController,
    required this.logoutController,
    required this.roomsNotifier,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// Add the _ProfilePageState class
class _ProfilePageState extends State<ProfilePage> {
  // Add the userFuture, currentUser, showRooms, showPasswords, isEditingUsername, usernameController, oldPasswordController, and newPasswordController properties
  late Future<User?> userFuture;
  User? currentUser;
  bool showRooms = false;
  bool showPasswords = false;
  bool isEditingUsername = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  // Add the initState method
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  // Add the _loadUserData method to load the user data
  void _loadUserData() {
    // load the user data from secure storage
    const secureStorage = FlutterSecureStorage();
    userFuture = secureStorage.read(key: 'token').then((token) {
      if (token == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomePage()));
        return null;
      } else {
        // load the user data from the server
       // return widget.userController.getProfile(context);
      }
    }).then((user) {
      setState(() {
        // set the currentUser to the user data
        currentUser = user as User;
      });
     return null;
      // return user;
    });
  }

  // Add the _refreshRooms method to refresh the user rooms
  Future<void> _refreshRooms() async {
    setState(() {
      widget.roomsNotifier.value = [];
    });
    var rooms = await widget.userRoomsController.getUserRooms();
    widget.roomsNotifier.value = rooms as List<Room>;
  }

  // Add the _toggleShowRooms method to toggle the display of rooms
  void _toggleShowRooms() {
    setState(() {
      showRooms = !showRooms;
      if (showRooms) {
        _refreshRooms();
      }
    });
  }

  // Add the _toggleShowPasswords method to toggle the display of password update fields
  void _toggleShowPasswords() {
    setState(() {
      showPasswords = !showPasswords;
    });
  }

  // Add the _toggleEditUsername method to toggle the editing of the username
  void _toggleEditUsername() {
    setState(() {
      isEditingUsername = !isEditingUsername;
      if (!isEditingUsername) {
        usernameController.text = '';
      }
    });
  }

  // Add the _updateUsername method to update the username
  Future<void> _updateUsername() async {
    // update the username if it is not empty
    if (usernameController.text.isNotEmpty) {
      // update the username by calling the updateUsername method from the UserController
      String result = await widget.userController
          .updateUsername(usernameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          duration: const Duration(seconds: 3),
        ),
      );
      // update the username in the currentUser if the update is successful
      setState(() {
        isEditingUsername = false;
        if (result == 'Username updated successfully') {
          currentUser?.username = usernameController.text;
        }
      });
    }
  }

  // Add the _updatePassword method to update the password
  Future<void> _updatePassword() async {
    // update the password if the old password and new password are not empty
    if (oldPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty) {
      // update the password by calling the updatePassword method from the UserController
      String result = await widget.userController.updatePassword(
          oldPasswordController.text, newPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          duration: const Duration(seconds: 3),
        ),
      );
      // clear the password fields if the update is successful
      if (result == 'Password updated successfully') {
        // clear the password fields
        oldPasswordController.clear();
        newPasswordController.clear();
        setState(() {
          showPasswords = false;
        });
      }
    }
  }

  // Add the _getRandomColor method to generate a random color
  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    ).withOpacity(0.5);
  }


  // Add the build method
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
