import 'package:flutter/material.dart';
import 'package:my_app/views/room/room_page.dart';
import 'package:my_app/views/user/profile_page.dart';
import '../../controllers/authentification/logout_controller.dart';
import '../../controllers/room/room_controller.dart';
import '../../controllers/user/profile_controller.dart';
import '../../controllers/user/user_rooms_controller.dart';
import '../../models/room.dart';
import '../../services/user/user_rooms_service.dart';

class HomePage extends StatefulWidget {
  // Add the profileController, roomController, logoutController, userRoomsService, and userRoomsController properties
  final ProfileController profileController;
  final RoomController roomController;
  final LogoutController logoutController;
  final UserRoomsService userRoomsService;
  final UserRoomsController userRoomsController;

  // Add the profileController, roomController, logoutController, userRoomsService, and userRoomsController to the constructor
  const HomePage({
    super.key,
    required this.profileController,
    required this.roomController,
    required this.logoutController,
    required this.userRoomsService,
    required this.userRoomsController,
  });

  // Add the createState method
  @override
  _HomePageState createState() => _HomePageState();
}

// Add the _HomePageState class
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late ProfilePage _profilePage;
  late RoomPage _roomPage;
  late ValueNotifier<List<Room>> roomsNotifier;

  // Add the initState method
  @override
  // Add the initState method
  void initState() {
    super.initState();
    // Add the _profilePage and _roomPage
    roomsNotifier = ValueNotifier<List<Room>>([]);
    _profilePage = ProfilePage(
      profileController: widget.profileController,
      userRoomsController: widget.userRoomsController,
      logoutController: widget.logoutController,
      roomsNotifier: roomsNotifier,
    );
    _roomPage = RoomPage(
      roomController: widget.roomController,
      logoutController: widget.logoutController,
      updateRoomsCallback: _updateRooms,
      userRoomsController: widget.userRoomsController,
      roomsNotifier: roomsNotifier,
    );
  }
  // Add the _onItemTapped method to handle the bottom navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  // Add the _updateRooms method to update the roomsNotifier
  void _updateRooms(List<Room?>? updatedRooms ) {
    roomsNotifier.value = (updatedRooms as List<Room>) ?? [];
  }

  // Add the build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Add the selectedIndex and children properties
        index: _selectedIndex,
        children: [
          // Add the profilePage and roomPage
          _profilePage,
          _roomPage,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Add the bottom navigation bar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Rooms',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
