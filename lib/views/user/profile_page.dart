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
  final ProfileController profileController;
  final UserRoomsController userRoomsController;
  final LogoutController logoutController;
  final ValueNotifier<List<Room>> roomsNotifier;

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

class _ProfilePageState extends State<ProfilePage> {
  late Future<User?> userFuture;
  User? currentUser;
  bool showRooms = false;
  bool showPasswords = false;
  bool isEditingUsername = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    const secureStorage = FlutterSecureStorage();
    userFuture = secureStorage.read(key: 'token').then((token) {
      if (token == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomePage()));
        return null;
      } else {
        return widget.profileController.getProfile(context);
      }
    }).then((user) {
      setState(() {
        currentUser = user as User;
      });
      return user;
    });
  }

  Future<void> _refreshRooms() async {
    setState(() {
      widget.roomsNotifier.value = [];
    });
    var rooms = await widget.userRoomsController.getUserRooms(context);
    widget.roomsNotifier.value = rooms as List<Room>;
  }

  void _toggleShowRooms() {
    setState(() {
      showRooms = !showRooms;
      if (showRooms) {
        _refreshRooms();
      }
    });
  }

  void _toggleShowPasswords() {
    setState(() {
      showPasswords = !showPasswords;
    });
  }

  void _toggleEditUsername() {
    setState(() {
      isEditingUsername = !isEditingUsername;
      if (!isEditingUsername) {
        usernameController.text = '';
      }
    });
  }

  Future<void> _updateUsername() async {
    if (usernameController.text.isNotEmpty) {
      String result = await widget.profileController
          .updateUsername(usernameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          duration: const Duration(seconds: 3),
        ),
      );
      setState(() {
        isEditingUsername = false;
        if (result == 'Username updated successfully') {
          currentUser?.username = usernameController.text;
        }
      });
    }
  }

  Future<void> _updatePassword() async {
    if (oldPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty) {
      String result = await widget.profileController.updatePassword(
          oldPasswordController.text, newPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          duration: const Duration(seconds: 3),
        ),
      );
      if (result == 'Password updated successfully') {
        oldPasswordController.clear();
        newPasswordController.clear();
        setState(() {
          showPasswords = false;
        });
      }
    }
  }

  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    ).withOpacity(0.5);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showFooter: true,
      logoutController: widget.logoutController,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshRooms,
          child: FutureBuilder<User?>(
            future: userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                ErrorDisplayIsolate.showErrorDialog(
                    context, '${snapshot.error}');
                return const Center(child: Text('An error occurred'));
              } else if (snapshot.hasData || currentUser != null) {
                User? user = snapshot.data ?? currentUser;
                DateFormat dateFormat = DateFormat('MMMM dd, yyyy');
                String createdAtFormatted = dateFormat
                    .format(user?.createdAt ?? DateTime.now());
                String updatedAtFormatted = dateFormat
                    .format(user?.updatedAt ?? DateTime.now());

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  title: isEditingUsername
                                      ? Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: usernameController,
                                          decoration:
                                          const InputDecoration(
                                            hintText: 'Enter new username',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.check),
                                        onPressed: _updateUsername,
                                      ),
                                    ],
                                  )
                                      : Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          user?.username ?? '',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          usernameController.text =
                                              user?.username ?? '';
                                          _toggleEditUsername();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.key),
                                        onPressed: _toggleShowPasswords,
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text('Since '),
                                      Text(createdAtFormatted,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      const Text('Last update on '),
                                      Text(updatedAtFormatted,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                if (showPasswords) ...[
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Change your password',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: oldPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Old Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: newPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'New Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Text(
                                        'Change',
                                        style: TextStyle(fontSize: 16, color : Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _toggleShowRooms,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            showRooms ? 'Hide rooms' : 'Display rooms',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<List<Room>>(
                          valueListenable: widget.roomsNotifier,
                          builder: (context, rooms, child) {
                            if (showRooms) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Member of ${rooms.length} rooms',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
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
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
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
