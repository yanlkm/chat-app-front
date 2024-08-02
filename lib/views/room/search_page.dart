import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/controllers/room/room_controller.dart';
import '../../models/room.dart';
import 'dart:math';

class SearchPage extends StatefulWidget {
  final RoomController roomController;
  final ValueNotifier<List<Room>> roomsNotifier;

  const SearchPage(
      {super.key, required this.roomController, required this.roomsNotifier});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<Room> allRooms = [];
  ValueNotifier<List<Room>> searchResultsNotifier = ValueNotifier([]);
  String sortBy = 'name'; // Default sort by name
  String? userId;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    widget.roomsNotifier.addListener(_onRoomsNotifierChanged);
    _loadUserId();
    _loadRooms();
  }

  Future<void> _loadUserId() async {
    userId = await const FlutterSecureStorage().read(key: 'userId');
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    widget.roomsNotifier.removeListener(_onRoomsNotifierChanged);
    searchController.dispose();
    searchResultsNotifier.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _performSearch(searchController.text);
  }

  void _onRoomsNotifierChanged() {
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    List<Room> roomsByController =
        await widget.roomController.getRooms(context);
    List<Room> rooms = roomsByController;

    setState(() {
      allRooms = rooms.map((room) {
        Room updatedRoom = roomsByController.firstWhere(
          (r) => r.roomID == room.roomID,
          orElse: () => room,
        );
        return updatedRoom;
      }).toList();
    });

    _performSearch(searchController.text);
  }

  void _performSearch(String query) {
    List<Room> filteredRooms = allRooms.where((room) {
      return room.name!.toLowerCase().contains(query.toLowerCase()) ||
          room.description!.toLowerCase().contains(query.toLowerCase()) ||
          room.hashtags!
              .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
    _sortResults(filteredRooms);
  }

  void _sortResults(List<Room> rooms) {
    switch (sortBy) {
      case 'name':
        rooms.sort((a, b) => a.name!.compareTo(b.name as String));
        break;
      case 'hashtag':
        rooms.sort((a, b) => b.hashtags!.length.compareTo(a.hashtags!.length));
        break;
      case 'members':
        rooms.sort((a, b) => b.members!.length.compareTo(a.members!.length));
        break;
    }
    searchResultsNotifier.value = rooms;
  }

  void _onSortChanged(String? newSortBy) {
    if (newSortBy != null) {
      setState(() {
        sortBy = newSortBy;
      });
      _sortResults(searchResultsNotifier.value);
    }
  }

  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    ).withOpacity(0.5);
  }

  void _goBackToRooms() {
    Navigator.pop(context);
    // Refresh the rooms page
    widget.roomsNotifier.value = [];
    _loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Rooms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: sortBy,
                  items: const [
                    DropdownMenuItem(
                      value: 'name',
                      child: Text('Sort by Name'),
                    ),
                    DropdownMenuItem(
                      value: 'hashtag',
                      child: Text('Sort by Hashtag'),
                    ),
                    DropdownMenuItem(
                      value: 'members',
                      child: Text('Sort by Members'),
                    ),
                  ],
                  onChanged: _onSortChanged,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder<List<Room>>(
                valueListenable: searchResultsNotifier,
                builder: (context, rooms, child) {
                  if (rooms.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }
                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      bool isMember =
                          rooms[index].members?.contains(userId) ?? false;
                      return Card(
                        color: _getRandomColor(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      rooms[index].name ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (!isMember)
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () async {
                                          await widget.roomController
                                              .addMemberToRoom(
                                                  context, rooms[index].roomID);
                                          setState(() {
                                            rooms[index].members?.add(userId!);
                                          });
                                          widget.roomsNotifier.value[index] =
                                              rooms[index];
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rooms[index].description ?? '',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Members: ${rooms[index].members!.length}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Hashtags: ${rooms[index].hashtags!.join(', ')}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
