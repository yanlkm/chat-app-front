import 'dart:async';

import 'package:flutter/material.dart';
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
    Key? key,
    required this.roomController,
    required this.logoutController,
    required this.updateRoomsCallback,
    required this.userRoomsController,
    required this.roomsNotifier,
  }) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late Future<List<Room>> roomsFuture;
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    roomsFuture = widget.roomController.getRooms(context);
    roomsFuture.then((rooms) {
      setState(() {
        isExpandedList = List.filled(rooms.length, false);
      });
    });
  }

  Future<void> _refreshRooms() async {
    final newRooms = await widget.userRoomsController.getUserRooms(context);
    setState(() {
      roomsFuture = widget.roomController.getRooms(context);
      isExpandedList = List.filled(newRooms!.length, false);
    });
    widget.updateRoomsCallback(newRooms);
    widget.roomsNotifier.value = (newRooms as List<Room>);
  }

  void _enterRoom(Room room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showFooter: true,
      logoutController: widget.logoutController,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshRooms,
          child: FutureBuilder<List<Room>>(
            future: roomsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                ErrorDisplayIsolate.showErrorDialog(context, '${snapshot.error}');
                return const Center(child: Text('Failed to load rooms'));
              } else if (snapshot.hasData) {
                List<Room> rooms = snapshot.data!;
                if (isExpandedList.length != rooms.length) {
                  isExpandedList = List.filled(rooms.length, false);
                }
                return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    Room room = rooms[index];
                    bool isExpanded = isExpandedList[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpandedList[index] = !isExpandedList[index];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const  Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const  EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.shade100.withOpacity(0.8),
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
                            ElevatedButton(
                              onPressed: () => _enterRoom(room),
                              child: Text('Entrer'),
                            ),
                            const SizedBox(height: 8),
                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.blueGrey,
                                      );
                                    }).toList() ?? [],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Created At: ${DateFormat('MMMM dd, yyyy - HH:mm:ss').format(room.createdAt ?? DateTime.now()).substring(0,13)}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 150),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      String? response = await widget.roomController.addMemberToRoom(context, room.roomID);
                                      if (response != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response), duration: const Duration(seconds: 2)));
                                      }
                                      _refreshRooms();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.greenAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text("Join", style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      String? response = await widget.roomController.removeMemberFromRoom(context, room.roomID);
                                      if (response != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response), duration: const Duration(seconds: 2)));
                                      }
                                      _refreshRooms();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    // TODO : If user is already in the room, disable the button
                                    child: const Text("Leave", style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
