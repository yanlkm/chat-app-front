import 'package:flutter/material.dart';
import '../../../models/room.dart';

class RoomWidget extends StatelessWidget {
  final TextEditingController roomNameController;
  final TextEditingController roomDescriptionController;
  final Map<String, TextEditingController> hashtagControllers;
  final List<Room> rooms;
  final Function(String name, String description) onCreateRoom;
  final Function(Room room, String hashtag) onAddHashtagToRoom;
  final Function(Room room, String hashtag) onRemoveHashtagFromRoom;
  final void Function(String roomID, String hashtag) selectHashtag;
  final Map<String, String?> selectedHashtag;

  const RoomWidget({
    super.key,
    required this.roomNameController,
    required this.roomDescriptionController,
    required this.hashtagControllers,
    required this.rooms,
    required this.onCreateRoom,
    required this.onAddHashtagToRoom,
    required this.onRemoveHashtagFromRoom,
    required this.selectHashtag,
    required this.selectedHashtag,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Room Management',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 10),
        _buildCreateRoomSection(),
        const SizedBox(height: 16),
        _buildRoomList(),
      ],
    );
  }

  Widget _buildCreateRoomSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create a New Room',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: roomNameController,
            decoration: InputDecoration(
              labelText: 'Room Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: roomDescriptionController,
            decoration: InputDecoration(
              labelText: 'Room Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                onCreateRoom(
                  roomNameController.text,
                  roomDescriptionController.text,
                );
                roomNameController.clear();
                roomDescriptionController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(120, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Create Room',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rooms.length,
      itemBuilder: (context, index) {

        final room = rooms[index];
        final hashtagController = hashtagControllers[room.roomID]!;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                room.name ?? 'No Name',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                room.description ?? 'No Description',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              _buildHashtagSection(room, hashtagController),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHashtagSection(Room room, TextEditingController hashtagController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hashtags',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: room.hashtags?.map((hashtag) {
            bool isSelected = selectedHashtag[room.roomID] == hashtag;
            return GestureDetector(
              onTap: () {
                selectHashtag(room.roomID, hashtag); // Pass roomID and hashtag here
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hashtag,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }).toList() ?? [],
        ),
        const SizedBox(height: 4),
        if (selectedHashtag[room.roomID] != null)
          ElevatedButton(
            onPressed: () => onRemoveHashtagFromRoom(room, selectedHashtag[room.roomID]!),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(100, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Remove',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        const SizedBox(height: 4),
        const Divider(color: Colors.grey, thickness: 1),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              child: TextField(
                controller: hashtagController,
                decoration: const InputDecoration(
                  labelText: 'Add Hashtag',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => onAddHashtagToRoom(room, hashtagController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(60, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
