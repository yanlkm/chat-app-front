import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/room.dart';

class RoomItem extends StatelessWidget {
  final Room room;
  final List<bool> isExpandedList;
  final String userId;
  final int index;
  final VoidCallback onExpand;
  final Function(int, Room) onRefreshRoom;
  final Function(Room) onEnterRoom;
  final Function(String) onJoinRoom;
  final Function(String) onLeaveRoom;
  final Function(Room) updateRoom;

  const RoomItem({
    super.key,
    required this.room,
    required this.isExpandedList,
    required this.userId,
    required this.onExpand,
    required this.onRefreshRoom,
    required this.onEnterRoom,
    required this.index,
    required this.onJoinRoom,
    required this.updateRoom,
    required this.onLeaveRoom,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMember = room.members?.contains(userId) ?? false;
    final bool isCreator = room.creator == userId;

    return GestureDetector(
      onTap: onExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        transform: Matrix4.translationValues(0, isExpandedList[index] ? -8 : 0, 0),
        transformAlignment: Alignment.center,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  room.name ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isExpandedList[index] ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black87,
                  ),
                  onPressed: onExpand,
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedCrossFade(
              alignment: Alignment.topCenter,
              excludeBottomFocus: true,
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
                    }).toList() ??
                        [],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Created At: ${DateFormat('MMMM dd, yyyy - HH:mm:ss').format(room.createdAt ?? DateTime.now()).substring(0, 13)}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              crossFadeState: isExpandedList[index]
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
              layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned(
                      key: bottomChildKey,
                      left: 0,
                      right: 0,
                      child: bottomChild,
                    ),
                    Positioned(
                      key: topChildKey,
                      child: topChild,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isMember) {
                        onEnterRoom(room);
                      } else {
                        onJoinRoom(room.roomID);
                        room.members?.add(userId);

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMember ? Colors.blue : Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(isMember ? "Enter" : "Join",
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!isMember || isCreator) return;
                      onLeaveRoom(room.roomID);
                      room.members?.remove(userId);

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMember ? (isCreator ? Colors.grey : Colors.redAccent) : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                        isMember ? (isCreator ? "Creator" : "Leave") : "Not a Member",
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
