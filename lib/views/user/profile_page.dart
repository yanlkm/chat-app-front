import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/user/user_rooms_controller.dart';
import 'package:my_app/views/base_page.dart';
import 'package:my_app/views/utils/error_popup.dart';
import 'package:my_app/views/welcome_page.dart';
import '../../controllers/authentification/logout_controller.dart';
import '../../controllers/user/profile_controller.dart';
import '../../models/room.dart';
import '../../models/user.dart';


class ProfilePage extends StatelessWidget {
  final ProfileController profileController;
  final UserRoomsController userRoomsController;
  final LogoutController logoutController;


  const ProfilePage({super.key, required this.profileController, required this.userRoomsController, required this.logoutController,});

  @override
  Widget build(BuildContext context) {
    // Check if a token is present in secureStorage
    const secureStorage = FlutterSecureStorage();
    Future<User?> userFuture = secureStorage.read(key: 'token').then((token) {
      if (token == null) {
        // If no token is found, navigate to WelcomePage
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WelcomePage()));
        return null; // Return null to avoid loading profile data
      } else {
        return profileController.getProfile(context);
      }
    });

    return BasePage(
      showFooter: true,
      logoutController: logoutController,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: FutureBuilder<User?>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Placeholder for loading state
            } else if (snapshot.hasError) {
              ErrorDisplayIsolate.showErrorDialog(context, '${snapshot.error}');
              return const Text('An error occurred'); // Placeholder for error state
            } else if (snapshot.hasData) {
              User? user = snapshot.data;
              return FutureBuilder<List<Room?>?>(
                future: userRoomsController.getUserRooms(context),
                builder: (context, roomsSnapshot) {
                  if (roomsSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Placeholder for loading state
                  } else if (roomsSnapshot.hasError) {
                    ErrorDisplayIsolate.showErrorDialog(context, '${roomsSnapshot.error}');
                    return const Text('An error occurred'); // Placeholder for error state
                  } else if (roomsSnapshot.hasData) {
                    List<Room?>? rooms = roomsSnapshot.data;
                    DateFormat dateFormat = DateFormat('MMMM dd, yyyy - HH:mm:ss');
                    String createdAtFormatted = dateFormat.format(user?.createdAt ?? DateTime.now());
                    String updatedAtFormatted = dateFormat.format(user?.updatedAt ?? DateTime.now());
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, ${user?.username ?? ''}!',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Your Rooms',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: rooms?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(rooms?[index]?.name ?? ''),
                                    // TODO : add onTap functionality to navigate to specific room if needed
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Profile Information',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Card(
                            child: ListTile(
                              title: const Text('Profile created at :'),
                              subtitle: Text(createdAtFormatted),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: const Text('Last profile update :'),
                              subtitle: Text(updatedAtFormatted),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Text('No data available'); // Placeholder for empty data state
                  }
                },
              );
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WelcomePage()));
              return const Text('No data available'); // Placeholder for empty data state
            }
          },
        ),
      ),
    ),
    );
  }
}
