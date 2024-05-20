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
  late Future<List<Room?>?> roomsFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    widget.roomsNotifier.addListener(_onRoomsChanged);
  }

  @override
  void dispose() {
    widget.roomsNotifier.removeListener(_onRoomsChanged);
    super.dispose();
  }

  void _loadUserData() {
    const secureStorage = FlutterSecureStorage();
    userFuture = secureStorage.read(key: 'token').then((token) {
      if (token == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WelcomePage()));
        return null;
      } else {
        roomsFuture = widget.userRoomsController.getUserRooms(context);
        return widget.profileController.getProfile(context);
      }
    });
  }

  void _onRoomsChanged() {
    setState(() {
      roomsFuture = Future.value(widget.roomsNotifier.value);
    });
  }

  Future<void> refreshData() async {
    setState(() {
      _loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        showFooter: true,
        logoutController: widget.logoutController,
        child: Scaffold(
        body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<User?>(
        future: userFuture,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        ErrorDisplayIsolate.showErrorDialog(context, '${snapshot.error}');
        return const Center(child: Text('An error occurred'));
      } else if (snapshot.hasData) {
        User? user = snapshot.data;
        return FutureBuilder<List<Room?>?>(
            future: roomsFuture,
            builder: (context, roomsSnapshot) {
          if (roomsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (roomsSnapshot.hasError) {
            ErrorDisplayIsolate.showErrorDialog(context, '${roomsSnapshot.error}');
            return const Center(child: Text('An error occurred'));
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
                      title: const Text('Profile created at:'),
                      subtitle: Text(createdAtFormatted),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Last profile update:'),
                      subtitle: Text(updatedAtFormatted),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
            },
        );
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WelcomePage()));
        return const Center(child: Text('No data available'));
      }
        },
        ),
        ),
        ),
    );
  }
}
