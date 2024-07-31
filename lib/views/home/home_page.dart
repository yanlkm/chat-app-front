import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/presentation/cubits/profile/profile_cubit.dart';
import 'package:my_app/views/room/room_page.dart';
import 'package:my_app/presentation/views/profile/profile_view.dart';
import 'package:my_app/views/admin/admin_page.dart'; // Import AdminPage
import '../../controllers/authentification/logout_controller.dart';
import '../../controllers/room/room_controller.dart';
import '../../controllers/user/user_controller.dart';
import '../../controllers/user/user_rooms_controller.dart';
import '../../models/room.dart';
import '../../services/user/user_rooms_service.dart';
import '../../models/user.dart'; // Import User model

class HomePage extends StatefulWidget {
  // Add the UserController, roomController, logoutController, userRoomsService, and userRoomsController properties
  final UserController userController;
  final RoomController roomController;
  final LogoutController logoutController;
  final UserRoomsService userRoomsService;
  final UserRoomsController userRoomsController;

  // Add the UserController, roomController, logoutController, userRoomsService, and userRoomsController to the constructor
  const HomePage({
    super.key,
    required this.userController,
    required this.roomController,
    required this.logoutController,
    required this.userRoomsService,
    required this.userRoomsController
  });

  // Add the createState method
  @override
  _HomePageState createState() => _HomePageState();
}

// Add the _HomePageState class
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late ProfileView _profilePage;
  late RoomPage _roomPage;
  late AdminPage _adminPage; // Declare AdminPage
  late ValueNotifier<List<Room>> roomsNotifier;
  late ValueNotifier<List<User>> usersNotifier; // Declare usersNotifier
  bool isAdmin = false; // Variable to check if user is admin

  @override
  void initState() {
    super.initState();
    // Initialize roomsNotifier & usersNotifier
    roomsNotifier = ValueNotifier<List<Room>>([]);
    usersNotifier = ValueNotifier<List<User>>([]);
    // Initialize ProfilePage
    _roomPage = RoomPage(
      roomController: widget.roomController,
      logoutController: widget.logoutController,
      updateRoomsCallback: _updateRooms,
      userRoomsController: widget.userRoomsController,
      roomsNotifier: roomsNotifier,
    );
    _adminPage = AdminPage( // Initialize AdminPage
      userController: widget.userController,
      roomController: widget.roomController,
      updateOneRoomCallback: _updateOneRoom,
      usersNotifier: usersNotifier,
      logoutController: widget.logoutController,
    );
    _checkIfUserIsAdmin(); // Check if the user is admin
  }

  Future<void> _checkIfUserIsAdmin() async {
    // load secure storage
    const secureStorage = FlutterSecureStorage();
    // get the role from secure storage
    String? role = await secureStorage.read(key: 'role');
    // check if the user is admin
    if (role == 'admin') {
      setState(() {
        isAdmin = true;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateRooms(List<Room?>? updatedRooms) {
    roomsNotifier.value = (updatedRooms as List<Room>) ?? [];
  }

  void _updateOneRoom(Room updatedRoom) {
    List<Room> rooms = roomsNotifier.value;
    final int index = rooms.indexWhere((room) => room.roomID == updatedRoom.roomID);
    if (index != -1) {
      // debug
      print('Room updated: ${updatedRoom.roomID}');
      rooms[index] = updatedRoom;
      roomsNotifier.value = rooms;
    } else {
      // debug
      print('Room not found: ${updatedRoom.roomID}');
      // Add the updated room to the roomsNotifier
      rooms = [...rooms, updatedRoom];
      roomsNotifier.value = rooms;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
        //  BlocProvider(
          //  create: (context) => ProfileCubit(widget.userController),
            //child: const ProfileView(),
          //),
          _roomPage,
          if (isAdmin) _adminPage, // Conditionally include AdminPage
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Rooms',
          ),
          if (isAdmin) const BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts), // Use crown icon for admin
            label: 'Admin',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
