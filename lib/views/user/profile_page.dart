import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/user/user_rooms_controller.dart';
import 'package:my_app/views/home/base_page.dart';
import 'package:my_app/views/utils/error_popup.dart';
import 'package:my_app/views/home/welcome_page.dart';
import '../../controllers/authentification/logout_controller.dart';
import '../../controllers/user/profile_controller.dart';
import '../../models/room.dart';
import '../../models/user.dart';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  // Add the profileController, userRoomsController, logoutController, and roomsNotifier properties
  final ProfileController profileController;
  final UserRoomsController userRoomsController;
  final LogoutController logoutController;
  final ValueNotifier<List<Room>> roomsNotifier;

  // Add the profileController, userRoomsController, logoutController, and roomsNotifier to the constructor
  const ProfilePage({
    super.key,
    required this.profileController,
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
        return widget.profileController.getProfile(context);
      }
    }).then((user) {
      setState(() {
        // set the currentUser to the user data
        currentUser = user as User;
      });
      return user;
    });
  }

  // Add the _refreshRooms method to refresh the user rooms
  Future<void> _refreshRooms() async {
    setState(() {
      widget.roomsNotifier.value = [];
    });
    var rooms = await widget.userRoomsController.getUserRooms(context);
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
      // update the username by calling the updateUsername method from the profileController
      String result = await widget.profileController
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
      // update the password by calling the updatePassword method from the profileController
      String result = await widget.profileController.updatePassword(
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
    return BasePage(
      showFooter: true,
      logoutController: widget.logoutController,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshRooms,
          // Add the FutureBuilder widget
          child: FutureBuilder<User?>(
            future: userFuture,
            builder: (context, snapshot) {
              // check the connection state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // show an error dialog if the snapshot has an error
                ErrorDisplayIsolate.showErrorDialog(
                    context, '${snapshot.error}');
                return const Center(child: Text('An error occurred'));
              } else if (snapshot.hasData || currentUser != null) {
                // get the user data from the snapshot or the currentUser
                User? user = snapshot.data ?? currentUser;
                // format the createdAt and updatedAt dates
                DateFormat dateFormat = DateFormat('MMMM dd, yyyy');
                String createdAtFormatted = dateFormat
                    .format(user?.createdAt ?? DateTime.now());
                String updatedAtFormatted = dateFormat
                    .format(user?.updatedAt ?? DateTime.now());

                return Padding(
                  // Add the profile page content
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // create a stack to fix the profile title
                         Text(
                          'Welcome back, ${user?.username ?? ''} !',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),

                        ),
                        const SizedBox(height: 10),
                        Card(
                          // Add the user profile card
                          color: Colors.white,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 80,
                                      color: Colors.transparent,

                                    ),
                                    Positioned(
                                      top: 0,
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey.shade300,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey.shade800,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  children: [
                                    // Add the username field to display the username
                                    isEditingUsername
                                        ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child:
                                          SizedBox(
                                            width: 250,
                                            child: TextField(
                                              controller: usernameController,
                                              decoration: InputDecoration(
                                                labelText: 'Enter new username',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon:const Icon(Icons.check, color: Colors.blueGrey),
                                          onPressed: _updateUsername,
                                        ),
                                      ],
                                    )
                                        :
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        //  edit it if needed the username
                                        Text(
                                          user?.username ?? '',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        IconButton(
                                          icon:const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () {
                                            usernameController.text = user?.username ?? '';
                                            _toggleEditUsername();
                                          },
                                        ),
                                        // Add the IconButton widget to display the password fields to update the password
                                        IconButton(
                                          icon:const Icon(Icons.key, color: Colors.blue),
                                          onPressed: _toggleShowPasswords,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                  indent: 20,
                                  endIndent: 20,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 10),
                               Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 8),
                                        Text(
                                          'Member since ',
                                          style:
                                          TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),

                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    // Add the createdAtFormatted date and updatedAtFormatted date
                                    Row (
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.calendar_today, color: Colors.black, size: 16),
                                        const SizedBox(width: 8),
                                        Text(
                                          createdAtFormatted,
                                          style:const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 8),
                                        Text(
                                          'Last update on ',
                                          style: TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                      ),
                                      const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.update, color: Colors.black, size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              updatedAtFormatted,
                                              style:const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                    ),
                                  ],
                                ),
                                if (showPasswords) ...[
                                  const SizedBox(height: 16),
                                  const Divider(
                                    height: 10,
                                    thickness: 1,
                                    indent: 20,
                                    endIndent: 20,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Change your password',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily : 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                   SizedBox(
                                    width: 300, // Adjust the width as needed
                                    child: TextField(
                                      controller: oldPasswordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'Old Password',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: 300, // Adjust the width as needed
                                    child: TextField(
                                      controller: newPasswordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'New Password',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _updatePassword,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Text(
                                        'Change',
                                        style: TextStyle(fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        // Add the SizedBox widget to add space between the user profile card and the Display rooms button
                        const SizedBox(height: 20),
                        // Add the ElevatedButton widget to display the rooms of the user
                        ElevatedButton(
                          onPressed: _toggleShowRooms,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          // change the button text based on the showRooms value
                          child: Text(
                            // Add the Display rooms button
                            showRooms ? 'Hide rooms' : 'Display rooms',
                            style: const TextStyle(
                                color: Colors.white , fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Add the ValueListenableBuilder widget to display the rooms of the user
                        ValueListenableBuilder<List<Room>>(
                          valueListenable: widget.roomsNotifier,
                          builder: (context, rooms, child) {
                            // if showRooms is true, display the rooms
                            if (showRooms) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row (
                                    children: [
                                      const Icon(Icons.person, color: Colors.black),
                                      const SizedBox(width: 2),
                                      Text(
                                        'Member of ${rooms.length} rooms',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),
                                  // Add the GridView.builder widget to display the rooms with a grid view
                                  GridView.builder(
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 4 / 3,
                                    ),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: rooms.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: _getRandomColor(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                rooms[index].name ?? '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                rooms[index].description ?? '',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                            // return an empty SizedBox if showRooms is false
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // navigate to the WelcomePage if there is no user data
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const WelcomePage()));
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ),
      ),
    );
  }
}
