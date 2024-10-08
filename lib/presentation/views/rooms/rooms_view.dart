import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import 'package:my_app/domain/use_cases/chat/db/message_db_usecases.dart';
import 'package:my_app/presentation/_widgets/rooms/search_bar_widget.dart';
import 'package:my_app/presentation/pages/chat/chat_page.dart';
import 'package:my_app/presentation/pages/home/base/base_page.dart';
import '../../../domain/entities/rooms/room_entity.dart';
import '../../../domain/use_cases/chat/socket/message_socket_usescases.dart';
import '../../_widgets/rooms/room_list_widget.dart';
import '../../cubits/rooms/rooms_cubit.dart';

// RoomView : room view page
class RoomView extends StatefulWidget {
// useCases
  final MessageDBUseCases messageDBUseCases;
  final MessageSocketUseCases messageSocketUseCases;
  final AuthUseCases authUseCases;

  // notifier
  final ValueNotifier<List<RoomEntity>> roomsNotifier;

  // constructor
  const RoomView({
    super.key,
    required this.authUseCases,
    required this.roomsNotifier,
    required this.messageDBUseCases,
    required this.messageSocketUseCases,
  });

  @override
  RoomViewState createState() => RoomViewState();
}

// Room View State
class RoomViewState extends State<RoomView> {
  // view state attributes
  List<bool> isExpandedList = [];
  String userId = '';
  // text controller
  TextEditingController searchController = TextEditingController();
  // room search notifier
  ValueNotifier<List<RoomEntity>> searchResultsNotifier = ValueNotifier([]);
  // default search param
  String sortBy = 'name';

  // initialize states, listener and rooms
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

  // dispose elements if context closed
  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
  // load user logged in id
  Future<void> _loadUserId() async {
    userId = await const FlutterSecureStorage().read(key: 'userId') ?? '';
  }

  // search performance on controller
  void _onSearchChanged() {
    _performSearch(searchController.text);
  }

  // call _onSearchChanged
  void _onSearchChangedCaller(String query) {
    _onSearchChanged();
  }

  // perform search on : name, description, hashtags
  void _performSearch(String query) {
    // filter rooms and update search results
    List<RoomEntity> filteredRooms = widget.roomsNotifier.value.where((room) {
      return room.name!.toLowerCase().contains(query.toLowerCase()) ||
          room.description!.toLowerCase().contains(query.toLowerCase()) ||
          room.hashtags!
              .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    setState(() {
      searchResultsNotifier.value = filteredRooms;
    });
  }

  // sort rooms : sort rooms by name, description, hashtags or all
  void _sortRooms(String sortBy) {
    List<RoomEntity> sortedRooms = searchResultsNotifier.value.isNotEmpty
        ? searchResultsNotifier.value
        : widget.roomsNotifier.value;
    if (sortBy == 'name') {
      sortedRooms.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortBy == 'description') {
      sortedRooms.sort((a, b) => a.description!.compareTo(b.description!));
    } else if (sortBy == 'hashtags') {
      sortedRooms
          .sort((a, b) => a.hashtags!.join().compareTo(b.hashtags!.join()));
    } else {
      sortedRooms = widget.roomsNotifier.value;
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
      showFooter: false,
      authUseCases: widget.authUseCases,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            final cubit = context.read<RoomsCubit>();
            await cubit.loadRooms(context);
          },
          // child : ValueListenableBuilder
          child: ValueListenableBuilder<List<RoomEntity>>(
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: sortBy,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.blue),
                            items: <String>[
                              'name',
                              'description',
                              'hashtags',
                              'all'
                            ].map((String value) {
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
                      rooms: searchResultsNotifier.value.isNotEmpty
                          ? searchResultsNotifier.value
                          : rooms,
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
                            builder: (context) => ChatPage(
                              room: room,
                              messageDBUseCases: widget.messageDBUseCases,
                              messageSocketUseCases:
                                  widget.messageSocketUseCases,
                            ),
                          ),
                        );
                      },
                      // onJoinRoom : add member to room
                      onJoinRoom: (roomID) async {
                        final cubit = context.read<RoomsCubit>();
                        await cubit.addMemberToRoom(context, roomID);
                      },
                      // updateRoom : update room after changes
                      updateRoom: (updatedRoom) {
                        final cubit = context.read<RoomsCubit>();
                        cubit.updateRoom(updatedRoom);
                      },
                      // onLeaveRoom : remove member from room
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
