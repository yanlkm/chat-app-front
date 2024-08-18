import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/cubits/admin/admin_code_cubit.dart';
import '../../../controllers/room/room_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';
import '../../_widgets/admin/admin_code_widget.dart';
import '../../_widgets/admin/admin_room_widget.dart';
import '../../_widgets/admin/admin_user_widget.dart';
import '../../cubits/admin/admin_rooms_cubit.dart';
import '../../cubits/admin/admin_users_cubit.dart';

class AdminPage extends StatelessWidget {
  final UserController userController;
  final RoomController roomController;
  final ValueNotifier<List<Room>> adminRoomNotifier;
  final ValueNotifier<User> selectedUserNotifier;
  final ValueNotifier<User> userFoundNotifier;
  final ValueNotifier<List<User>> userNotifier;
  final ValueNotifier<List<Room>> roomsNotifier;

  const AdminPage({
    super.key,
    required this.userController,
    required this.roomController,
    required this.adminRoomNotifier,
    required this.roomsNotifier,
    required this.selectedUserNotifier,
    required this.userFoundNotifier,
    required this.userNotifier,
  }) ;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(userController, userFoundNotifier,
              userNotifier)..loadUsers(),
        ),
        BlocProvider(
          create: (context) =>
          RoomCubit(roomController, adminRoomNotifier, roomsNotifier)..loadRooms(),
        ),
        BlocProvider(
          create: (context) => AdminCodeCubit(userController),
        ),
      ],
      child: AdminPageView(
        adminRoomNotifier: adminRoomNotifier,
        userNotifier: userNotifier,
        selectedUserNotifier: selectedUserNotifier,
        userFoundNotifier: userFoundNotifier,

      ),
    );
  }
}

class AdminPageView extends StatefulWidget {
  final ValueNotifier<List<Room>> adminRoomNotifier;
  final ValueNotifier<List<User>> userNotifier;
  final ValueNotifier<User> userFoundNotifier;
  final ValueNotifier<User> selectedUserNotifier;

  const AdminPageView({
    super.key,
    required this.adminRoomNotifier,
    required this.userNotifier,
    required this.selectedUserNotifier,
    required this.userFoundNotifier,
  });

  @override
  AdminPageViewState createState() => AdminPageViewState();
}

class AdminPageViewState extends State<AdminPageView> {
  final TextEditingController userSearchController = TextEditingController();
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController roomDescriptionController = TextEditingController();
  final Map<String, TextEditingController> hashtagControllers = {};
  final Map<String, String?> selectedHashtag = {};
  final TextEditingController codeController = TextEditingController();
  String currentCode = '';
  bool isCodeCopied = false;

  @override
  void initState() {
    super.initState();
    _initializeHashtagControllers();
    _initializeSearchController();
  }

  void _initializeSearchController() {
    userSearchController.addListener(_onSearchChanged);
  }

  void _initializeHashtagControllers() {
    // Initialize controllers for each room
    for (Room room in widget.adminRoomNotifier.value) {
      hashtagControllers[room.roomID] = TextEditingController();
      selectedHashtag[room.roomID] = null;
    }
  }

  void _performSearch(UserCubit userCubit) async {
    print("Debug 2 : call on _performSearch");

    String userUniqueReference = userSearchController.text;
    if( userUniqueReference.isNotEmpty) {
      try {
        // perform User search
        await userCubit.searchUser(userUniqueReference);
        if(!mounted) return;

      }catch(e) {
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$e')));
        }
      }
    }
  }

  // search for a specific user
  void _onSearchChanged() {
    print("Debug : call on _onSearchChanged");
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
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Code created successfully')));
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
      if(mounted) {
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
  void _addHashtagToRoom(RoomCubit roomCubit, Room room, String hashtag) {

    if (hashtag.isEmpty) {
      if(mounted) {
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
        if(mounted) {
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
      if(mounted) {
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
  void _removeHashtagFromRoom(RoomCubit roomCubit, Room room, String hashtag) {
    // if hashtag selected is the last hashtag, return
    if (room.hashtags?.length == 1) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Room must have at least one hashtag'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    roomCubit.removeHashtagFromRoom(room.roomID, hashtag).then((_) {
      // Reload rooms and update UI
      roomCubit.loadRooms();
      setState(() {
        selectedHashtag[room.roomID] = null;
      });
    }).catchError((error) {
      if(mounted) {
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
        widget.selectedUserNotifier.value = User();
        // if the user to (un)ban is on search result
        if(widget.userFoundNotifier.value.userID == userId) {
          widget.userFoundNotifier.value.validity="invalid";
        }
      });
    }).catchError((error) {
      if(mounted) {
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
        widget.selectedUserNotifier.value = User();
        // if the user to (un)ban is on search result
        if(widget.userFoundNotifier.value.userID == userId) {
          widget.userFoundNotifier.value.validity="valid";
        }
      });
    }).catchError((error) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to unban user: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _selectHashtag(String roomID, String hashtag) {
    setState(() {
      final isSelected = selectedHashtag[roomID] == hashtag;
      if (isSelected) {
        selectedHashtag[roomID] = null;
      } else {
        selectedHashtag[roomID] = hashtag;
      }
    });
  }

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
    final userCubit = context.read<UserCubit>();
    final roomCubit = context.read<RoomCubit>();

    // Reinitialize controllers if new rooms are loaded
    if (roomCubit.state is RoomLoaded) {
      final rooms = (roomCubit.state as RoomLoaded).rooms;
      if (rooms.length != hashtagControllers.length) {
        setState(() {
          _initializeHashtagControllers();
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocListener<UserCubit, UserState>(
              listener: (context, state) {
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
                if (state is RoomError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                  // show load loop for a while
                  Future.delayed(const Duration(seconds: 2), () {
                    print("Debug : call loadRooms");
                  // call loadRooms to reload rooms
                  roomCubit.loadRooms();
                  });
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
              onSearchChanged: (String userUniqueReference) => _performSearch(userCubit),
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
            if (roomCubit.state is RoomLoaded && hashtagControllers.isNotEmpty)
              RoomWidget(
                roomNameController: roomNameController,
                roomDescriptionController: roomDescriptionController,
                hashtagControllers: hashtagControllers,
                rooms: (roomCubit.state as RoomLoaded).rooms,
                onCreateRoom: (name, description) => _createRoom(roomCubit, name, description),
                selectedHashtag: selectedHashtag,
                onAddHashtagToRoom: (Room room, String hashtag) => _addHashtagToRoom(roomCubit, room, hashtag),
                onRemoveHashtagFromRoom: (Room room, String hashtag) => _removeHashtagFromRoom(roomCubit, room, hashtag),
                selectHashtag: _selectHashtag, // Pass the callback here
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
