import 'package:flutter/material.dart';
import 'package:my_app/models/room.dart';
import 'room_item_widget.dart';

class RoomList extends StatelessWidget {
  final List<Room> rooms;
  final List<bool> isExpandedList;
  final String userId;
  final Function(int, Room) onRefreshRoom;
  final Function(Room) onEnterRoom;
  final Function(String) onJoinRoom;
  final Function(String) onLeaveRoom;
  final Function(Room) updateRoom;
  final void Function(int index) setExpanded;

  const RoomList({
    Key? key,
    required this.rooms,
    required this.isExpandedList,
    required this.userId,
    required this.onRefreshRoom,
    required this.onEnterRoom,
    required this.onJoinRoom,
    required this.updateRoom,
    required this.onLeaveRoom,
   required this.setExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        return RoomItem(
          room: rooms[index],
          isExpandedList: isExpandedList,
          userId: userId,
          onRefreshRoom: onRefreshRoom,
          onEnterRoom: onEnterRoom,
          index: index,
          onJoinRoom: onJoinRoom,
          updateRoom: updateRoom,
          onLeaveRoom: onLeaveRoom,
          onExpand: () {
            setExpanded(index);
          },
        );
      },
    );
  }
}
