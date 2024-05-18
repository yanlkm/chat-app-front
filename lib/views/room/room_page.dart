import 'package:flutter/material.dart';
import 'package:my_app/models/room.dart';
import 'package:my_app/views/base_page.dart';
import 'package:my_app/views/utils/error_popup.dart';

import '../../controllers/authentification/logout_controller.dart';
import '../../controllers/room/room_controller.dart';

class RoomPage extends StatefulWidget {
  final RoomController roomController;
  final LogoutController logoutController;
  final void Function(List<Room>) updateRoomsCallback;

  const RoomPage({
    super.key,
    required this.roomController,
    required this.logoutController,
    required this.updateRoomsCallback,
  });

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late Future<List<Room>> roomsFuture;

  @override
  void initState() {
    super.initState();
    roomsFuture = widget.roomController.getRooms(context);
  }

  Future<void> _refreshRooms() async {
    setState(() {
      roomsFuture = widget.roomController.getRooms(context);
    });
  }

  Future<void> _handleAddMember(Room room) async {
    String? response = await widget.roomController.addMemberToRoom(context, room.roomID);
    widget.updateRoomsCallback(await widget.roomController.getRooms(context));
  }

  Future<void> _handleRemoveMember(Room room) async {
    String? response = await widget.roomController.removeMemberFromRoom(context, room.roomID);
    widget.updateRoomsCallback(await widget.roomController.getRooms(context));
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
                return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    Room room = rooms[index];
                    return Card(
                      child: ListTile(
                        title: Text(room.name??""),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.person_add,
                                color: Colors.green),
                              onPressed: () async {
                               String? response = await widget.roomController.addMemberToRoom(context, room.roomID);
                               // show response
                               SnackBar snackBar = SnackBar(content: Text(response??""),
                                 duration: const Duration(seconds: 2));
                                _refreshRooms();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.person_remove,
                                color: Colors.red),
                              onPressed: () async {
                                String? response = await widget.roomController.removeMemberFromRoom(context, room.roomID);
                                // show response
                                SnackBar snackBar = SnackBar(content: Text(response??""),
                                  duration: const Duration(seconds: 2));
                                _refreshRooms();
                              },
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
