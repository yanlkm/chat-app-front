import 'package:flutter/material.dart';
import '../../../domain/entities/rooms/room_entity.dart';
import 'room_item_widget.dart';

class RoomList extends StatelessWidget {

  // List of RoomEntity, List of bool, userId, onRefreshRoom, onEnterRoom, onJoinRoom, updateRoom, setExpanded as attributes
  final List<RoomEntity> rooms;
  final List<bool> isExpandedList;
  final String userId;
  // onRefreshRoom, onEnterRoom, onJoinRoom, updateRoom, setExpanded as functions
  final Function(int, RoomEntity) onRefreshRoom;
  final Function(RoomEntity) onEnterRoom;
  final Function(String) onJoinRoom;
  final Function(String) onLeaveRoom;
  final Function(RoomEntity) updateRoom;
  final void Function(int index) setExpanded;

  // Constructor
  const RoomList({
    super.key,
    required this.rooms,
    required this.isExpandedList,
    required this.userId,
    required this.onRefreshRoom,
    required this.onEnterRoom,
    required this.onJoinRoom,
    required this.updateRoom,
    required this.onLeaveRoom,
   required this.setExpanded,
  });

  // main build method
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
