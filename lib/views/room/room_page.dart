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
  final RoomController roomController;
  final LogoutController logoutController;
  final UserRoomsController userRoomsController;
  final void Function(List<Room?>?) updateRoomsCallback;
  final ValueNotifier<List<Room>> roomsNotifier;

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

class _RoomPageState extends State<RoomPage> {
  late Future<List<Room>> roomsFuture;
  List<bool> isExpandedList = [];
  List<bool> isLoadingList = [];
  String? userId;
  TextEditingController searchController = TextEditingController();
  List<Room> allRooms = [];
  ValueNotifier<List<Room>> searchResultsNotifier = ValueNotifier([]);
  String sortBy = 'name'; // Default sort by name

  @override
  void initState() {
    super.initState();
    _loadUserId();
    roomsFuture = widget.roomController.getRooms(context);
    roomsFuture.then((rooms) {
      setState(() {
        isExpandedList = List.filled(rooms.length, false);
        isLoadingList = List.filled(rooms.length, false);
        widget.roomsNotifier.value = rooms;
        allRooms = rooms;
      });
    });
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    userId = await const FlutterSecureStorage().read(key: 'userId');
  }

  Future<void> _refreshRoom(int index, Room updatedRoom) async {
    setState(() {
      isLoadingList[index] = true;
      isExpandedList[index] = updatedRoom.members!.contains(userId);
    });

    final newRooms = await widget.userRoomsController.getUserRooms(context);

    if (mounted) {
      setState(() {
        if (index < widget.roomsNotifier.value.length) {
          widget.roomsNotifier.value[index] = updatedRoom;
          isLoadingList[index] = false;
        }
      });

      widget.updateRoomsCallback(newRooms);
      widget.roomsNotifier.value = (newRooms as List<Room>);
    }
  }

  void _enterRoom(Room room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(room: room),
      ),
    );
  }

  void _onSearchChanged() {
    _performSearch(searchController.text);
  }

  void _performSearch(String query) {
    // Filter rooms based on query
    List<Room> filteredRooms = allRooms.where((room) {
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
    List<Room> sortedRooms = searchResultsNotifier.value.isNotEmpty ? searchResultsNotifier.value : allRooms;
    if (sortBy == 'name') {
      sortedRooms.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortBy == 'description') {
      sortedRooms.sort((a, b) => a.description!.compareTo(b.description!));
    } else if (sortBy == 'hashtags') {
      sortedRooms.sort((a, b) => a.hashtags!.join().compareTo(b.hashtags!.join()));
    }
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
    _sortRooms(value!);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showFooter: true,
      logoutController: widget.logoutController,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            roomsFuture = widget.roomController.getRooms(context) ;
            await roomsFuture.then((rooms) {
              setState(() {
                isExpandedList = List.filled(rooms.length, false);
                isLoadingList = List.filled(rooms.length, false);
                widget.roomsNotifier.value = rooms;
                searchResultsNotifier.value = [];
                allRooms = rooms;
              });
            });
            setState(() {});
          },
          child: FutureBuilder<List<Room>>(
            future: roomsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                ErrorDisplayIsolate.showErrorDialog(
                    context, '${snapshot.error}');
                return const Center(child: Text('Failed to load rooms'));
              } else if (snapshot.hasData ||
                  searchResultsNotifier.value.isNotEmpty) {
                List<Room> rooms = searchResultsNotifier.value.isNotEmpty ? searchResultsNotifier.value : (snapshot.data ?? []);

                return Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search rooms',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sort by',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: sortBy,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                              items: <String>['name', 'description', 'hashtags', 'all'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              }).toList(),
                              onChanged: _onSortChanged,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          Room room = rooms[index];
                          bool isExpanded = isExpandedList[index];
                          final bool isMember =
                              room.members?.contains(userId) ?? false;
                          final bool isCreator = room.creator == userId;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpandedList[index] = !isExpandedList[index];
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                Colors.blueAccent.shade100.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    room.name ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedCrossFade(
                                    firstChild: const SizedBox.shrink(),
                                    secondChild: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          room.description ?? "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 6,
                                          children: room.hashtags?.map((tag) {
                                            return Chip(
                                              label: Text(
                                                tag,
                                                style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor:
                                              Colors.blueGrey,
                                            );
                                          }).toList() ??
                                              [],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Created At: ${DateFormat('MMMM dd, yyyy - HH:mm:ss').format(room.createdAt ?? DateTime.now()).substring(0, 13)}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    crossFadeState: isExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: const Duration(milliseconds: 150),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isLoadingList[index] = true;
                                            });
                                            if (isMember) {
                                              _enterRoom(room);
                                            } else {
                                              String? response = await widget
                                                  .roomController
                                                  .addMemberToRoom(
                                                  context, room.roomID);
                                              if (response != null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    content: Text(response),
                                                    duration:
                                                    const Duration(
                                                        seconds: 2)));
                                              }
                                              // Update the local room data after joining
                                              room.members?.add(userId!);
                                            }
                                            await _refreshRoom(index, room);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isMember
                                                ? Colors.blue
                                                : Colors.greenAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                              isMember ? "Enter" : "Join",
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (!isMember) {
                                              return;
                                            }
                                            if (isCreator) {
                                              return;
                                            }
                                            String? response = await widget
                                                .roomController
                                                .removeMemberFromRoom(
                                                context, room.roomID);
                                            if (response != null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                  content: Text(response),
                                                  duration: const Duration(
                                                      seconds: 2)));
                                            }
                                            // Update the local room data after leaving
                                            room.members?.remove(userId);
                                            await _refreshRoom(index, room);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isMember
                                                ? ( isCreator ? Colors.grey : Colors.redAccent)
                                                : Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                              isMember
                                                  ? (isCreator ? "Creator" : "Leave")
                                                  : "Not a Member",
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No rooms available'));
              }
            },
          ),
        ),
      ),
    );
  }
}

