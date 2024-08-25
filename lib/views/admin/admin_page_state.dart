import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/views/admin/admin_page.dart';
import '../../models/room.dart';
import '../../models/user.dart';
import '../home/base_page.dart';
import '../utils/error_popup.dart';

class AdminPageState extends State<AdminPage> {
  // initialize the variables
  // create a future to load the users & rooms
  late Future<List<User>> usersFuture;
  late Future<List<Room>> roomsFuture;
  //  create controllers for the search
  final TextEditingController searchController = TextEditingController();
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController roomDescriptionController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  // create a value notifier for the user
  ValueNotifier<User> userNotifier = ValueNotifier<User>(User());
  // create a map to store the hashtag controllers
  final Map<String, TextEditingController> hashtagControllers = {};
  final Map<String, String?> selectedHashtag = {};
  // create local variables for the user id, current code and is code copied
  String? userId;
  String currentCode = '';
  bool isCodeCopied = false;

  // initialize the state
  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    usersFuture = _loadUsers();
    roomsFuture = _loadRooms();
    _loadUserId();
  }

  // load the users
  Future<List<User>> _loadUsers() async {
    try {
      // Call the get users service
      List<User> users = await widget.userController.getUsers();
      widget.usersNotifier.value = users;
      return users;
    } catch (e) {
      // display an error message
      if (!mounted) return [];
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to load users');
      rethrow;
    }
  }

  //  load the rooms
  Future<List<Room>> _loadRooms() async {
    try {
      // Call the get rooms service
      List<Room> rooms =
          await widget.roomController.getRoomCreatedByAdmin();
      // iterate through the rooms
      for (Room room in rooms) {
        // add the room id to the hashtag controller
        hashtagControllers[room.roomID] = TextEditingController();
        // set the selected hashtag to null
        selectedHashtag[room.roomID] = null;
      }
      widget.roomsNotifier.value = rooms;
      return rooms;
    } catch (e) {
      // display an error message
      if (!mounted) return [];
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to load rooms');
      rethrow;
    }
  }

  // load the user id
  Future<void> _loadUserId() async {
    userId = await const FlutterSecureStorage().read(key: 'userId');
  }

  // search for a user
  void _searchUser(String searchString) async {
    // Call the get users service
    List<User> users = await widget.userController.getUsers();
    if (searchString.isEmpty) {
      // if the search string is empty, set the userNotifier value to an empty user
      setState(() {
        userNotifier.value = User();
      });
      return;
    }
    // find the user by username or user id
    User user = users.firstWhere(
        (user) => user.username == searchString || user.userID == searchString,
        orElse: () => User());
    setState(() {
      userNotifier.value = user;
    });
  }

 // search for a specific user
  void _onSearchChanged() {
    _searchUser(searchController.text);
  }

  //  ban a user
  Future<void> _banUser(String userId) async {
    try {
      // Call the ban user service
      String response = await widget.userController.banUser(userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response)));
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to ban user')));
    }
  }

  // unban a user
  Future<void> _unbanUser(String userId) async {
    try {
      String response = await widget.userController.unbanUser(userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response)));
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to unban user')));
    }
  }

  // create a code
  Future<void> _createCode() async {
    // get the code from the code controller
    String code = codeController.text;
    if (code.isNotEmpty) {
      try {
        String response =
            await widget.userController.createRegistrationCode(code);
        if (!mounted) return;
        //  set the state : is code copied to false, current code to the code and clear the code controller
        setState(() {
          isCodeCopied = false;
          currentCode = code;
          codeController.clear();
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create code')));
      }
    }
  }

  // create a room
  Future<void> _createRoom() async {
    String roomName = roomNameController.text;
    String roomDescription = roomDescriptionController.text;
    // check if the room name and description are not empty
    if (roomName.isEmpty || roomDescription.isEmpty) {
      ErrorDisplayIsolate.showErrorDialog(
          context, 'Please enter room name and description');
      return;
    }
  // create a room
    try {
      Room? createdRoom = await widget.roomController
          .createRoom( roomName, roomDescription);
      // if the room is created : clear the room description and name controller, update the room and display a success message
      if (createdRoom != null) {
        roomDescriptionController.clear();
        roomNameController.clear();
        widget.updateOneRoomCallback(createdRoom);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Room created successfully')));
        setState(() {
          roomsFuture = _loadRooms();
        });
      }
    } catch (e) {
      if (!mounted) return;
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to create room');
    }
  }

  // add a hashtag to a room
  Future<void> _addHashtagToRoom(Room room, String hashtag) async {
    if (hashtag.isEmpty) {
      ErrorDisplayIsolate.showErrorDialog(context, 'Please enter a hashtag');
      return;
    }
    final hashtagPattern = RegExp(r'^#[a-zA-Z]*$');
    // check if the hashtag is valid
    if (!hashtagPattern.hasMatch(hashtag)) {
      final hashtagOnlyLetters = RegExp(r'^[a-zA-Z]*$');
      if (hashtagOnlyLetters.hasMatch(hashtag)) {
        // add # to the hashtag
        hashtag = '#$hashtag';
      } else {
        ErrorDisplayIsolate.showErrorDialog(
            context, 'Hashtag must start with # and contain only letters');
        return;
      }
    }
  // add the hashtag to the room
    try {
      String? response = await widget.roomController
          .addHashtagToRoom( room.roomID, hashtag);
      //  if the response is not null : clear the hashtag controller, add the hashtag to the room, update the room, update the roomsNotifier and display a success message
      if (response != null) {
        hashtagControllers[room.roomID]!.clear();
        room.hashtags?.add(hashtag);
        widget.updateOneRoomCallback(room);
        widget.roomsNotifier.value = widget.roomsNotifier.value
            .map((r) => r.roomID == room.roomID ? room : r)
            .toList();
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add hashtag to room')));
    }
  }
  // remove a hashtag from a room
  Future<void> _removeHashtagFromRoom(Room room, String hashtag) async {
    if (hashtag.isEmpty) {
      ErrorDisplayIsolate.showErrorDialog(context, 'Please enter a hashtag');
      return;
    }

    try {
      String? response = await widget.roomController
          .removeHashtagFromRoom( room.roomID, hashtag);
      if (response != null) {
        // remove the hashtag from the room
        room.hashtags?.remove(hashtag);
        // update the room
        widget.updateOneRoomCallback(room);
        // update the roomsNotifier
        widget.roomsNotifier.value = widget.roomsNotifier.value
            .map((r) => r.roomID == room.roomID ? room : r)
            .toList();
        // clear the hashtag controller and disable the remove button
        selectedHashtag[room.roomID] = null;
        // display a success message
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove hashtag from room')));
    }
  }

  // dispose the controllers : searchController, codeController, roomNameController, roomDescriptionController and hashtagControllers
  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    codeController.dispose();
    roomNameController.dispose();
    roomDescriptionController.dispose();
    for (var controller in hashtagControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
