import 'dart:math';
import 'package:flutter/material.dart';
import '../../../domain/entities/rooms/room_entity.dart';

// UserRoomsWidget
class UserRoomsWidget extends StatelessWidget {
  // ValueNotifier of List of RoomEntity as attribute
  final ValueNotifier<List<RoomEntity>> userRoomNotifier;
  // Show Rooms as attribute
  final bool showRooms;
  // On Toggle Rooms action as a callback function
  final Function onToggleRooms;

  // Constructor
  const UserRoomsWidget({
    super.key,
    required this.userRoomNotifier,
    required this.showRooms,
    required this.onToggleRooms,
  });

  // Get Random Color method to generate random colors
  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    ).withOpacity(0.5);
  }

  // main build method
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Elevated Button to toggle rooms : Show or Hide
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
          onPressed: () => onToggleRooms(),
          child: Text(showRooms ? 'Hide your rooms' : 'Show your rooms'),
        ),
        // ValueListenableBuilder to listen to the userRoomNotifier : List of RoomEntities
        if (showRooms)
          ValueListenableBuilder<List<RoomEntity>>(
            valueListenable: userRoomNotifier,
            builder: (context, rooms, child) {
              if (showRooms) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),  // Add general padding to the Column
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person, color: Colors.black),
                          const SizedBox(width: 2),
                          Text(
                            'Member of ${rooms.length} rooms',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // GridView to show the rooms
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 10,
                          childAspectRatio: 3, // Adjust the aspect ratio to reduce the height
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          return IntrinsicHeight(
                            child: Card(
                              color: _getRandomColor(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    rooms[index].name ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              // Return a SizedBox.shrink() if showRooms is false
              return const SizedBox.shrink();
            },
          ),
      ],
    );

  }
}