import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import 'package:my_app/domain/use_cases/chat/db/message_db_usecases.dart';
import 'package:my_app/domain/use_cases/chat/socket/message_socket_usescases.dart';
import '../../../domain/use_cases/rooms/room_usecases.dart';
import '../../../domain/use_cases/users/user_usecases.dart';
import '../../views/home/home_view.dart';

// HomePage : home page entry point
class HomePage extends StatefulWidget {


  // usesCases
  final UserUseCases userUseCases;
  final RoomUsesCases roomUsesCases;
  final AuthUseCases authUseCases;
  final MessageDBUseCases messageDBUseCases;
  final MessageSocketUseCases   messageSocketUseCases;


  // Constructor
  const HomePage({
    super.key,
    required this.userUseCases,
    required this.roomUsesCases,
    required this.authUseCases,
    required this.messageDBUseCases,
    required this.messageSocketUseCases,
  });

  // createState method
  @override
  _HomePageState createState() => _HomePageState();
}

// _HomePageState : HomePage state class
class _HomePageState extends State<HomePage> {
  // attributes
  // index of the selected item
  int _selectedIndex = 0;
// notifiers
  late ValueNotifier<List<RoomEntity>> roomsNotifier;
  late ValueNotifier<List<UserEntity>> usersNotifier;
  late ValueNotifier<List<RoomEntity>> userRoomsNotifier;
  late ValueNotifier<UserEntity> selectedUserNotifier;
  late ValueNotifier<UserEntity> userFoundNotifier;
  late ValueNotifier<List<RoomEntity>> adminRoomNotifier;

  // isAdmin
  bool isAdmin = false;

  // initState method : initialize the state and check if the user is admin
  @override
  void initState() {
    super.initState();
    roomsNotifier = ValueNotifier<List<RoomEntity>>([]);
    usersNotifier = ValueNotifier<List<UserEntity>>([]);
    selectedUserNotifier = ValueNotifier(const UserEntity());
    userFoundNotifier = ValueNotifier(const UserEntity());
    userRoomsNotifier = ValueNotifier<List<RoomEntity>>([]);
    adminRoomNotifier = ValueNotifier<List<RoomEntity>>([]);

    _checkIfUserIsAdmin();
  }

  // _checkIfUserIsAdmin method : check if the user is admin
  Future<void> _checkIfUserIsAdmin() async {
    const secureStorage = FlutterSecureStorage();
    String? role = await secureStorage.read(key: 'role');
    if (role == 'admin') {
      setState(() {
        isAdmin = true;
      });
    }
  }

  // _onItemTapped method : handle the tap event on the bottom navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // build method
  @override
  Widget build(BuildContext context) {
    // HomeView : home view
    return HomeView(
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      isAdmin: isAdmin,
      roomsNotifier: roomsNotifier,
      usersNotifier: usersNotifier,
      selectedUserNotifier: selectedUserNotifier,
      userRoomsNotifier: userRoomsNotifier,
      adminRoomNotifier: adminRoomNotifier,
      userFoundNotifier: userFoundNotifier,
      userUseCases: widget.userUseCases,
      roomUsesCases: widget.roomUsesCases,
      authUseCases: widget.authUseCases,
      messageDBUseCases: widget.messageDBUseCases,
      messageSocketUseCases: widget.messageSocketUseCases,
    );
  }
}
