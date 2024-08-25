import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/user/user_rooms_controller.dart';
import 'package:my_app/models/room.dart';
import 'package:my_app/views/home/base_page.dart';
import 'package:my_app/views/utils/error_popup.dart';
import '../../controllers/authentification/logout_controller.dart';
import '../../controllers/room/room_controller.dart';
import '../chat/chat_page.dart';

class RoomPage extends StatefulWidget {
  // Add the roomController, logoutController, userRoomsController, updateRoomsCallback, and roomsNotifier properties
  final RoomController roomController;
  final LogoutController logoutController;
  final UserRoomsController userRoomsController;
  final void Function(List<Room?>?) updateRoomsCallback;
  final ValueNotifier<List<Room>> roomsNotifier;

  // Add the roomController, logoutController, userRoomsController, updateRoomsCallback, and roomsNotifier to the constructor
  const RoomPage({
    super.key,
    required this.roomController,
    required this.logoutController,
    required this.updateRoomsCallback,
    required this.userRoomsController,
    required this.roomsNotifier,
  });

  @override
  _RoomPageState createState() => _RoomPageState();
}

// Add the _RoomPageState class
class _RoomPageState extends State<RoomPage> {
  // Add the roomsFuture, isExpandedList, isLoadingList, userId, searchController, allRooms, searchResultsNotifier, and sortBy properties
  late Future<List<Room>> roomsFuture;
  List<bool> isExpandedList = [];
  List<bool> isLoadingList = [];
  String? userId;
  TextEditingController searchController = TextEditingController();
  List<Room> allRooms = []; // All rooms
  ValueNotifier<List<Room>> searchResultsNotifier = ValueNotifier([]);
  String sortBy = 'name'; // Default sort by name

  @override
  // Add the initState method
  void initState() {
    super.initState();
    _loadUserId();
    // Add the roomsFuture for fetching rooms
    roomsFuture = widget.roomController.getRooms(context);
    // Add the roomsFuture.then method to update the roomsNotifier and allRooms
    roomsFuture.then((rooms) {
      setState(() {
        isExpandedList = List.filled(rooms.length, false);
        isLoadingList = List.filled(rooms.length, false);
        allRooms = rooms;
      });
    });
    // Add the searchController listener
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // Add the searchController dispose method
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  // Add the _loadUserId method to load the userId
  Future<void> _loadUserId() async {
    userId = await const FlutterSecureStorage().read(key: 'userId');
  }

  // Add the _refreshRoom method to refresh the room
  Future<void> _refreshRoom(int index, Room updatedRoom) async {
    setState(() {
      isLoadingList[index] = true;
      isExpandedList[index] = updatedRoom.members!.contains(userId);
    });
    // Add the newRooms to update the roomsNotifier
    final newRooms = await widget.userRoomsController.getUserRooms();

    // Update the room data
    if (mounted) {
      setState(() {
        if (index < widget.roomsNotifier.value.length) {
          widget.roomsNotifier.value[index] = updatedRoom;
          isLoadingList[index] = false;
        }
      });
      // Update the roomsNotifier
      widget.updateRoomsCallback(newRooms);
      //widget.roomsNotifier.value = (newRooms as List<Room>);
    }
  }

  // Add the _enterRoom method to enter the room
  void _enterRoom(Room room) {
    Navigator.push(
      context,
        // Add the ChatPage with the room
      MaterialPageRoute(
        builder: (context) => ChatPage(room: room),
      ),
    );
  }

  // Add the _onSearchChanged method to perform the search
  void _onSearchChanged() {
    _performSearch(searchController.text);
  }

  void _performSearch(String query) {
    // Filter rooms based on query
    List<Room> filteredRooms = allRooms.where((room) {
      // Check if the room name, description or hashtags contain the query
      return room.name!.toLowerCase().contains(query.toLowerCase()) ||
          room.description!.toLowerCase().contains(query.toLowerCase()) ||
          room.hashtags!
              .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    // Directly update search results without sorting
    setState(() {
      searchResultsNotifier.value = filteredRooms;
    });
  }

  // sort rooms by name, description or hashtags
  void _sortRooms(String sortBy) {
    // Sort the rooms based on the sortBy value
    List<Room> sortedRooms = searchResultsNotifier.value.isNotEmpty ? searchResultsNotifier.value : allRooms;
    if (sortBy == 'name') {
      // Sort the rooms by name
      sortedRooms.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortBy == 'description') {
      // Sort the rooms by description
      sortedRooms.sort((a, b) => a.description!.compareTo(b.description!));
    } else if (sortBy == 'hashtags') {
      //  Sort the rooms by hashtags
      sortedRooms.sort((a, b) => a.hashtags!.join().compareTo(b.hashtags!.join()));
    }
    // Update the search results
    setState(() {
      searchResultsNotifier.value = sortedRooms;
    });
  }

  // change the sortBy value and update the rooms
  void _onSortChanged(String? value) {
    setState(() {
      if (value != null) {
        sortBy = value;
      }
    });
    // Sort the rooms
    _sortRooms(value!);
  }

  // Add the build method
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

