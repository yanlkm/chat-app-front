import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/controllers/authentification/logout_controller.dart';
import 'package:my_app/models/room.dart';
import 'package:my_app/presentation/_widgets/rooms/search_bar_widget.dart';
import 'package:my_app/views/home/base_page.dart';
import 'package:my_app/presentation/views/chat/chat_view.dart';
import '../../_widgets/rooms/room_list_widget.dart';
import '../../cubits/rooms/rooms_cubit.dart';

class RoomView extends StatefulWidget {
  final LogoutController logoutController;
  final ValueNotifier<List<Room>> roomsNotifier;

  const RoomView({
    super.key,
    required this.logoutController,
    required this.roomsNotifier,
  });

  @override
  RoomPageViewState createState() => RoomPageViewState();
}

class RoomPageViewState extends State<RoomView> {
List<bool> isExpandedList = [];
  String userId = '';
  TextEditingController searchController = TextEditingController();
  ValueNotifier<List<Room>> searchResultsNotifier = ValueNotifier([]);
  String sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _loadUserId();
    searchController.addListener(_onSearchChanged);
    widget.roomsNotifier.addListener(() {
        isExpandedList = List.filled(widget.roomsNotifier.value.length, false);
    });
    // load rooms
    final cubit = context.read<RoomsCubit>();
    cubit.loadRooms(context);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    userId = await const FlutterSecureStorage().read(key: 'userId') ?? '';
  }

  void _onSearchChanged() {
    _performSearch(searchController.text);
  }
  void _onSearchChangedCaller(String query) {
      _onSearchChanged();
  }

  void _performSearch(String query) {
    List<Room> filteredRooms = widget.roomsNotifier.value.where((room) {
      return room.name!.toLowerCase().contains(query.toLowerCase()) ||
          room.description!.toLowerCase().contains(query.toLowerCase()) ||
          room.hashtags!.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    setState(() {
      searchResultsNotifier.value = filteredRooms;
    });
  }

  void _sortRooms(String sortBy) {
    List<Room> sortedRooms = searchResultsNotifier.value.isNotEmpty ? searchResultsNotifier.value : widget.roomsNotifier.value;
    if (sortBy == 'name') {
      sortedRooms.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortBy == 'description') {
      sortedRooms.sort((a, b) => a.description!.compareTo(b.description!));
    } else if (sortBy == 'hashtags') {
      sortedRooms.sort((a, b) => a.hashtags!.join().compareTo(b.hashtags!.join()));
    } else {
      print('all');
      sortedRooms =widget.roomsNotifier.value;
    }
    setState(() {
      searchResultsNotifier.value = sortedRooms;
    });
  }

  void _onSortChanged(String? value) {
    setState(() {
      if (value != null) {
        sortBy = value;
      }
    });
    _sortRooms(value!);
  }

  void _updateExpanded(int index) {
    setState(() {
      isExpandedList[index] = !isExpandedList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showFooter: true,
      logoutController: widget.logoutController,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            final cubit = context.read<RoomsCubit>();
            await cubit.loadRooms(context);
          },
          child: ValueListenableBuilder<List<Room>>(
            valueListenable: widget.roomsNotifier,
            builder: (context, rooms, _) {
              return Column(
                children: [
                  SearchBarWidget(
                    searchController: searchController,
                    onSearchChanged: _onSearchChangedCaller,
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
                    child: RoomList(
                      rooms: searchResultsNotifier.value.isNotEmpty ? searchResultsNotifier.value : rooms,
                      isExpandedList: isExpandedList,
                      userId: userId,
                      onRefreshRoom: (index, room) async {
                        final cubit = context.read<RoomsCubit>();
                        await cubit.refreshRoom(context, index, room);
                      },
                      onEnterRoom: (room) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(room: room),
                          ),
                        );
                      },
                      onJoinRoom: (roomID) async {
                        final cubit = context.read<RoomsCubit>();
                        await cubit.addMemberToRoom(context, roomID);
                      },
                      updateRoom: (updatedRoom) {
                        final cubit = context.read<RoomsCubit>();
                        cubit.updateRoom(updatedRoom);
                      },
                      onLeaveRoom: (roomID) async {
                        final cubit = context.read<RoomsCubit>();
                        await cubit.removeMemberFromRoom(context, roomID);
                      },
                      setExpanded: (index) {
                        _updateExpanded(index);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
