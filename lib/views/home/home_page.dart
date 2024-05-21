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
  final ProfileController profileController;
  final RoomController roomController;
  final LogoutController logoutController;
  final UserRoomsService userRoomsService;
  final UserRoomsController userRoomsController;

  const HomePage({
    Key? key,
    required this.profileController,
    required this.roomController,
    required this.logoutController,
    required this.userRoomsService,
    required this.userRoomsController,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late ProfilePage _profilePage;
  late RoomPage _roomPage;
  late ValueNotifier<List<Room>> roomsNotifier;

  @override
  void initState() {
    super.initState();
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateRooms(List<Room?>? updatedRooms ) {
    roomsNotifier.value = (updatedRooms as List<Room>) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _profilePage,
          _roomPage,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
