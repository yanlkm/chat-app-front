import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/rooms/room_entity.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import 'package:my_app/presentation/cubits/admin/admin_code_cubit.dart';
import 'package:my_app/presentation/pages/home/base/base_page.dart';
import '../../_widgets/admin/admin_code_widget.dart';
import '../../_widgets/admin/admin_room_widget.dart';
import '../../_widgets/admin/admin_user_widget.dart';
import '../../cubits/admin/admin_rooms_cubit.dart';
import '../../cubits/admin/admin_users_cubit.dart';

// AdminView : Admin view widget
class AdminView extends StatefulWidget {

  // useCase
  final AuthUseCases authUseCases;
  // notifiers
  final ValueNotifier<List<RoomEntity>> adminRoomNotifier;
  final ValueNotifier<List<UserEntity>> userNotifier;
  final ValueNotifier<UserEntity> userFoundNotifier;
  final ValueNotifier<UserEntity> selectedUserNotifier;
 // Constructor
  const AdminView({
    super.key,
    required this.adminRoomNotifier,
    required this.userNotifier,
    required this.selectedUserNotifier,
    required this.userFoundNotifier,
    required this.authUseCases,
  });
  // createState method
  @override
  AdminViewState createState() => AdminViewState();
}

// AdminViewState : AdminView state class
class AdminViewState extends State<AdminView> {
  // text controllers
  final TextEditingController userSearchController = TextEditingController();
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController roomDescriptionController =
      TextEditingController();
  final Map<String, TextEditingController> hashtagControllers = {};
  final Map<String, String?> selectedHashtag = {};
  final TextEditingController codeController = TextEditingController();
  // attributes to store the current code
  String currentCode = '';
  bool isCodeCopied = false;

  // initState method : initialize the state, controllers and listeners
  @override
  void initState() {
    super.initState();
    _initializeHashtagControllers();
    _initializeSearchController();
  }

  // initializeSearchController method : initialize the search controller
  void _initializeSearchController() {
    userSearchController.addListener(_onSearchChanged);
  }

  //  initializeHashtagControllers method : initialize the hashtag controllers
  void _initializeHashtagControllers() {
    for (RoomEntity room in widget.adminRoomNotifier.value) {
      hashtagControllers[room.roomID] = TextEditingController();
      selectedHashtag[room.roomID] = null;
    }
  }
  // initializeHashtagControllersManual method : initialize the hashtag controllers manually
  void _initializeHashtagControllersManual(List<RoomEntity> rooms) {
    for (RoomEntity room in rooms) {
      hashtagControllers[room.roomID] = TextEditingController();
      selectedHashtag[room.roomID] = null;
    }
  }

  // performSearch method : perform a search
  void _performSearch(UserCubit userCubit) async {

    // get the user unique reference
    String userUniqueReference = userSearchController.text;
    if (userUniqueReference.isNotEmpty) {
      try {
        // perform User search
        await userCubit.searchUser(userUniqueReference);
        if (!mounted) return;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$e')));
        }
      }
    }
  }

  // search for a specific user
  void _onSearchChanged() {
    _performSearch;
  }

  // Create the code
  Future<void> _createCode(AdminCodeCubit adminCodeCubit) async {
    String code = codeController.text;
    if (code.isNotEmpty) {
      try {
        await adminCodeCubit.createCode(code);
        if (!mounted) return;
        setState(() {
          isCodeCopied = false;
          currentCode = code;
          codeController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Code created successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create code')));
      }
    }
  }

  // Copy the code to clipboard
  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: currentCode));
    setState(() {
      isCodeCopied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isCodeCopied = false;
      });
    });
  }

  // Method to create a new room
  void _createRoom(RoomCubit roomCubit, String name, String description) {
    roomCubit.createRoom(name, description).then((_) {
      // Reload rooms and update UI
      roomCubit.loadRooms();
      setState(() {
        roomNameController.clear();
        roomDescriptionController.clear();
      });
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create room'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  // Method to add a hashtag to a room
  void _addHashtagToRoom(RoomCubit roomCubit, RoomEntity room, String hashtag) {
    if (hashtag.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hashtag cannot be empty'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    final hashtagPattern = RegExp(r'^#[a-zA-Z]*$');
    // check if the hashtag is valid
    if (!hashtagPattern.hasMatch(hashtag)) {
      final hashtagOnlyLetters = RegExp(r'^[a-zA-Z]*$');
      if (hashtagOnlyLetters.hasMatch(hashtag)) {
        // add # to the hashtag
        hashtag = '#$hashtag';
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hashtag can only contain letters'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }
    // if hashtag already exists, return
    if (room.hashtags?.contains(hashtag) == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hashtag already exists'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    roomCubit.addHashtagToRoom(room.roomID, hashtag).then((_) {
      // Reload rooms and update UI
      roomCubit.loadRooms();
      setState(() {
        hashtagControllers[room.roomID]?.clear();
      });
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add hashtag: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  // Method to remove a hashtag from a room
  void _removeHashtagFromRoom(RoomCubit roomCubit, RoomEntity room, String hashtag) {
    // if hashtag selected is the last hashtag, return
    if (room.hashtags?.length == 1) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Room must have at least one hashtag'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    // remove the hashtag from the room
    roomCubit.removeHashtagFromRoom(room.roomID, hashtag).then((_) {
      // Reload rooms and update UI
      roomCubit.loadRooms();
      setState(() {
        selectedHashtag[room.roomID] = null;
      });
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove hashtag: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  // Method to ban a user
  void _banUser(UserCubit userCubit, String userId) {
    userCubit.banUser(userId).then((_) {
      // Reload users and update UI
      userCubit.loadUsers();
      setState(() {
        widget.selectedUserNotifier.value = const UserEntity();
        // if the user to (un)ban is on search result
        if (widget.userFoundNotifier.value.userID == userId) {
          widget.userFoundNotifier.value= widget.userFoundNotifier.value.copyWith(validity: "invalid");
        }
      });
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ban user: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  // Method to unban a user
  void _unbanUser(UserCubit userCubit, String userId) {
    userCubit.unbanUser(userId).then((_) {
      // Reload users and update UI
      userCubit.loadUsers();
      setState(() {
        widget.selectedUserNotifier.value = const UserEntity();
        // if the user to (un)ban is on search result
        if (widget.userFoundNotifier.value.userID == userId) {
          widget.userFoundNotifier.value = widget.userFoundNotifier.value.copyWith(validity: "valid");
        }
      });
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to unban user: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  // Method to select a hashtag
  void _selectHashtag(String roomID, String hashtag) {
    setState(() {
      // if the hashtag is already selected, deselect it
      final isSelected = selectedHashtag[roomID] == hashtag;
      if (isSelected) {
        selectedHashtag[roomID] = null;
      } else {
        selectedHashtag[roomID] = hashtag;
      }
    });
  }

  // dispose method : dispose the controllers and listeners when the widget is removed
  @override
  void dispose() {
    userSearchController.removeListener(_onSearchChanged);
    userSearchController.dispose();
    widget.selectedUserNotifier.dispose();
    widget.userFoundNotifier.dispose();
    roomNameController.dispose();
    roomDescriptionController.dispose();
    hashtagControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider : provider for multiple blocs in the widget tree
    final userCubit = context.read<UserCubit>();
    final roomCubit = context.read<RoomCubit>();
    // Reinitialize controllers if new rooms are loaded
    if (roomCubit.state is RoomLoaded) {
      final rooms = (roomCubit.state as RoomLoaded).rooms;
      if (rooms.length != hashtagControllers.length) {
        // Safeguard against multiple initializations
        setState(() {
          _initializeHashtagControllersManual(rooms);
        });
      }
    }
    // BasePage : base page widget
    return BasePage(
      showFooter: false,
      authUseCases: widget.authUseCases,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // BlocListener : listener for UserCubit
              BlocListener<UserCubit, UserState>(
                listener: (context, state) {
                  // if the state is UserError
                  if (state is UserError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Container(),
              ),
              BlocListener<RoomCubit, RoomState>(
                listener: (context, state) {
                  // if the state is RoomError
                  if (state is RoomError) {
                    // show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                    // show load loop for a while
                    Future.delayed(const Duration(seconds: 2), () {
                      // call loadRooms to reload rooms
                      roomCubit.loadRooms();
                    });
                  }
                  if (state is RoomLoaded) {
                    if (state.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Container(),
              ),
              // User Widget Section
              UserWidget(
                searchController: userSearchController,
                userNotifier: widget.userFoundNotifier,
                users: userCubit.state is UserLoaded
                    ? (userCubit.state as UserLoaded).users
                    : [],
                onBanUser: (userId) => _banUser(userCubit, userId),
                onUnbanUser: (userId) => _unbanUser(userCubit, userId),
                onSearchChanged: (String userUniqueReference) =>
                    _performSearch(userCubit),
              ),
              const SizedBox(height: 30),
              // Code Widget Section
              AdminCodeWidget(
                codeController: codeController,
                currentCode: currentCode,
                isCodeCopied: isCodeCopied,
                onCreateCode: () => _createCode(context.read<AdminCodeCubit>()),
                onCopyCode: _copyCode,
              ),
              // Room Widget Section
              // if the state is RoomLoaded and hashtagControllers is not empty then show RoomWidget
              if (roomCubit.state is RoomLoaded &&
                  hashtagControllers.isNotEmpty)
                RoomWidget(
                  roomNameController: roomNameController,
                  roomDescriptionController: roomDescriptionController,
                  hashtagControllers: hashtagControllers,
                  rooms: (roomCubit.state as RoomLoaded).rooms,
                  onCreateRoom: (name, description) =>
                      _createRoom(roomCubit, name, description),
                  selectedHashtag: selectedHashtag,
                  onAddHashtagToRoom: (RoomEntity room, String hashtag) =>
                      _addHashtagToRoom(roomCubit, room, hashtag),
                  onRemoveHashtagFromRoom: (RoomEntity room, String hashtag) =>
                      _removeHashtagFromRoom(roomCubit, room, hashtag),
                  selectHashtag: _selectHashtag, // Pass the callback here
                )
                // else : show CircularProgressIndicator
              else

                const Center(
                  child: CircularProgressIndicator(),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
