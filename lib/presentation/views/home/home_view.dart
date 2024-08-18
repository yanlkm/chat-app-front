import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/presentation/_widgets/home/bottom_navigation_widget.dart';

import '../../../controllers/authentification/logout_controller.dart';
import '../../../controllers/room/room_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../controllers/user/user_rooms_controller.dart';
import '../../../models/room.dart';
import '../../../services/user/user_rooms_service.dart';
import '../../../models/user.dart';
import '../../_widgets/home/page_content.dart';

class HomePage extends StatefulWidget {
  final UserController userController;
  final RoomController roomController;
  final LogoutController logoutController;
  final UserRoomsService userRoomsService;
  final UserRoomsController userRoomsController;


  const HomePage({
    super.key,
    required this.userController,
    required this.roomController,
    required this.logoutController,
    required this.userRoomsService,
    required this.userRoomsController,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late ValueNotifier<List<Room>> roomsNotifier;
  late ValueNotifier<List<User>> usersNotifier;
  late ValueNotifier<List<Room>> userRoomsNotifier;
  late ValueNotifier<User> selectedUserNotifier;
  late ValueNotifier<User> userFoundNotifier;
  late ValueNotifier<List<Room>> adminRoomNotifier;

  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    roomsNotifier = ValueNotifier<List<Room>>([]);
    usersNotifier = ValueNotifier<List<User>>([]);
    selectedUserNotifier = ValueNotifier(User());
    userFoundNotifier = ValueNotifier(User());
    userRoomsNotifier = ValueNotifier<List<Room>>([]);
    adminRoomNotifier = ValueNotifier<List<Room>>([]);

    _checkIfUserIsAdmin();
  }

  Future<void> _checkIfUserIsAdmin() async {
    const secureStorage = FlutterSecureStorage();
    String? role = await secureStorage.read(key: 'role');
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

  void _updateOneRoom(Room updatedRoom) {
    List<Room> rooms = roomsNotifier.value;
    final int index =
        rooms.indexWhere((room) => room.roomID == updatedRoom.roomID);
    if (index != -1) {
      rooms[index] = updatedRoom;
      roomsNotifier.value = rooms;
    } else {
      rooms = [...rooms, updatedRoom];
      roomsNotifier.value = rooms;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageContent(
        selectedIndex: _selectedIndex,
        isAdmin: isAdmin,
        userController: widget.userController,
        userRoomsController: widget.userRoomsController,
        logoutController: widget.logoutController,
        roomsNotifier: roomsNotifier,
        usersNotifier: usersNotifier,
        roomController: widget.roomController,
        selectedUserNotifier: selectedUserNotifier,
        userRoomsNotifier: userRoomsNotifier,
        adminRoomNotifier: adminRoomNotifier,
        userFoundNotifier: userFoundNotifier,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        isAdmin: isAdmin,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
