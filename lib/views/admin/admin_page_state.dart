import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/views/admin/admin_page.dart';
import '../../models/room.dart';
import '../../models/user.dart';
import '../home/base_page.dart';
import '../utils/error_popup.dart';

class AdminPageState extends State<AdminPage> {
  // initialize the variables
  // create a future to load the users & rooms
  late Future<List<User>> usersFuture;
  late Future<List<Room>> roomsFuture;
  //  create controllers for the search
  final TextEditingController searchController = TextEditingController();
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController roomDescriptionController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  // create a value notifier for the user
  ValueNotifier<User> userNotifier = ValueNotifier<User>(User());
  // create a map to store the hashtag controllers
  final Map<String, TextEditingController> hashtagControllers = {};
  final Map<String, String?> selectedHashtag = {};
  // create local variables for the user id, current code and is code copied
  String? userId;
  String currentCode = '';
  bool isCodeCopied = false;

  // initialize the state
  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    usersFuture = _loadUsers();
    roomsFuture = _loadRooms();
    _loadUserId();
  }

  // load the users
  Future<List<User>> _loadUsers() async {
    try {
      // Call the get users service
      List<User> users = await widget.userController.getUsers();
      widget.usersNotifier.value = users;
      return users;
    } catch (e) {
      // display an error message
      if (!mounted) return [];
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to load users');
      rethrow;
    }
  }

  //  load the rooms
  Future<List<Room>> _loadRooms() async {
    try {
      // Call the get rooms service
      List<Room> rooms =
          await widget.roomController.getRoomCreatedByAdmin(context);
      // iterate through the rooms
      for (Room room in rooms) {
        // add the room id to the hashtag controller
        hashtagControllers[room.roomID] = TextEditingController();
        // set the selected hashtag to null
        selectedHashtag[room.roomID] = null;
      }
      widget.roomsNotifier.value = rooms;
      return rooms;
    } catch (e) {
      // display an error message
      if (!mounted) return [];
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to load rooms');
      rethrow;
    }
  }

  // load the user id
  Future<void> _loadUserId() async {
    userId = await const FlutterSecureStorage().read(key: 'userId');
  }

  // search for a user
  void _searchUser(String searchString) async {
    // Call the get users service
    List<User> users = await widget.userController.getUsers();
    if (searchString.isEmpty) {
      // if the search string is empty, set the userNotifier value to an empty user
      setState(() {
        userNotifier.value = User();
      });
      return;
    }
    // find the user by username or user id
    User user = users.firstWhere(
        (user) => user.username == searchString || user.userID == searchString,
        orElse: () => User());
    setState(() {
      userNotifier.value = user;
    });
  }

 // search for a specific user
  void _onSearchChanged() {
    _searchUser(searchController.text);
  }

  //  ban a user
  Future<void> _banUser(String userId) async {
    try {
      // Call the ban user service
      String response = await widget.userController.banUser(userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response)));
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to ban user')));
    }
  }

  // unban a user
  Future<void> _unbanUser(String userId) async {
    try {
      String response = await widget.userController.unbanUser(userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response)));
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to unban user')));
    }
  }

  // create a code
  Future<void> _createCode() async {
    // get the code from the code controller
    String code = codeController.text;
    if (code.isNotEmpty) {
      try {
        String response =
            await widget.userController.createRegistrationCode(code);
        if (!mounted) return;
        //  set the state : is code copied to false, current code to the code and clear the code controller
        setState(() {
          isCodeCopied = false;
          currentCode = code;
          codeController.clear();
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create code')));
      }
    }
  }

  // create a room
  Future<void> _createRoom() async {
    String roomName = roomNameController.text;
    String roomDescription = roomDescriptionController.text;
    // check if the room name and description are not empty
    if (roomName.isEmpty || roomDescription.isEmpty) {
      ErrorDisplayIsolate.showErrorDialog(
          context, 'Please enter room name and description');
      return;
    }
  // create a room
    try {
      Room? createdRoom = await widget.roomController
          .createRoom(context, roomName, roomDescription);
      // if the room is created : clear the room description and name controller, update the room and display a success message
      if (createdRoom != null) {
        roomDescriptionController.clear();
        roomNameController.clear();
        widget.updateOneRoomCallback(createdRoom);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Room created successfully')));
        setState(() {
          roomsFuture = _loadRooms();
        });
      }
    } catch (e) {
      if (!mounted) return;
      ErrorDisplayIsolate.showErrorDialog(context, 'Failed to create room');
    }
  }

  // add a hashtag to a room
  Future<void> _addHashtagToRoom(Room room, String hashtag) async {
    if (hashtag.isEmpty) {
      ErrorDisplayIsolate.showErrorDialog(context, 'Please enter a hashtag');
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
        ErrorDisplayIsolate.showErrorDialog(
            context, 'Hashtag must start with # and contain only letters');
        return;
      }
    }
  // add the hashtag to the room
    try {
      String? response = await widget.roomController
          .addHashtagToRoom(context, room.roomID, hashtag);
      //  if the response is not null : clear the hashtag controller, add the hashtag to the room, update the room, update the roomsNotifier and display a success message
      if (response != null) {
        hashtagControllers[room.roomID]!.clear();
        room.hashtags?.add(hashtag);
        widget.updateOneRoomCallback(room);
        widget.roomsNotifier.value = widget.roomsNotifier.value
            .map((r) => r.roomID == room.roomID ? room : r)
            .toList();
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add hashtag to room')));
    }
  }
  // remove a hashtag from a room
  Future<void> _removeHashtagFromRoom(Room room, String hashtag) async {
    if (hashtag.isEmpty) {
      ErrorDisplayIsolate.showErrorDialog(context, 'Please enter a hashtag');
      return;
    }

    try {
      String? response = await widget.roomController
          .removeHashtagFromRoom(context, room.roomID, hashtag);
      if (response != null) {
        // remove the hashtag from the room
        room.hashtags?.remove(hashtag);
        // update the room
        widget.updateOneRoomCallback(room);
        // update the roomsNotifier
        widget.roomsNotifier.value = widget.roomsNotifier.value
            .map((r) => r.roomID == room.roomID ? room : r)
            .toList();
        // clear the hashtag controller and disable the remove button
        selectedHashtag[room.roomID] = null;
        // display a success message
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove hashtag from room')));
    }
  }

  // dispose the controllers : searchController, codeController, roomNameController, roomDescriptionController and hashtagControllers
  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    codeController.dispose();
    roomNameController.dispose();
    roomDescriptionController.dispose();
    for (var controller in hashtagControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showFooter: true,
      logoutController: widget.logoutController,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await _loadUsers();
            setState(() {
              roomsFuture = _loadRooms();
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Divider(
                    color: Colors.blue,
                    thickness: 3,
                  ),
                  const SizedBox(height: 10),
                  // display the user management
                  const Text(
                    'User Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // display the banned users and not banned users through a valueListenableBuilder & usersNotifier
                  ValueListenableBuilder<List<User>>(
                    valueListenable: widget.usersNotifier,
                    builder: (context, users, _) {
                      // if the users list is empty, display a message
                      if (users.isEmpty) {
                        return const Text('No users found',
                            style: TextStyle(fontSize: 18, color: Colors.red));
                      } else {
                        // create a list of banned users and not banned users
                        List<User> bannedUsers = users
                            .where((user) => user.validity != 'valid')
                            .toList();
                        List<User> notBannedUsers = users
                            .where((user) => user.validity == 'valid')
                            .toList();
                        // return a column with the banned users and not banned users
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // display the banned users
                                      const Text(
                                        'Banned users ⛓️',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.redAccent,
                                        thickness: 2,
                                      ),
                                      SizedBox(
                                        height: 200.0,
                                        // display the banned users
                                        child: ListView.builder(
                                          itemCount: bannedUsers.length,
                                          itemBuilder: (context, index) {
                                            User user = bannedUsers[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red[50],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: ListTile(
                                                // display the user name
                                                title: Text(
                                                  user.username ?? 'No Name',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                // display the unban button
                                                trailing: IconButton(
                                                  icon: const Icon(Icons.block,
                                                      color: Colors.red),
                                                  onPressed: () => _unbanUser(
                                                      user.userID as String),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // display the not banned users
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Not banned users ✅',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.green,
                                        thickness: 2,
                                      ),
                                      SizedBox(
                                        height: 200.0,
                                        child: ListView.builder(
                                          itemCount: notBannedUsers.length,
                                          itemBuilder: (context, index) {
                                            User user = notBannedUsers[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green[50],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: ListTile(
                                                title: Text(
                                                  user.username ?? 'No Name',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green),
                                                  onPressed: () => _banUser(
                                                      user.userID as String),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  // display the search field
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
                  // display the user found by the search
                  if (userNotifier.value.username != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // if the userNotifier value is not null, display the user
                      child: ValueListenableBuilder<User>(
                        valueListenable: userNotifier,
                        builder: (context, user, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    user.username ?? 'No Name',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // display the ban or unban button depending on the user validity
                                  ElevatedButton(
                                    onPressed: () =>
                                        _banUser(user.userID as String),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      minimumSize: const Size(100, 36),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Ban',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _unbanUser(user.userID as String),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      minimumSize: const Size(100, 36),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Unban',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 18),
                  // display the code generation
                  const Text(
                    'Generate Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      // display the code field and the generate button
                      Expanded(
                        child: TextField(
                          controller: codeController,
                          decoration: const InputDecoration(
                            labelText: 'CODE',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _createCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(90, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // display the generated code
                  if (currentCode.isNotEmpty)
                    // create a container with 50% width
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      // display the current code
                      child: ListTile(
                          title: Text(
                            currentCode,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // display the copy icon
                          trailing: IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: currentCode));
                              setState(() {
                                isCodeCopied = true;
                              });
                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  isCodeCopied = false;
                                });
                              });
                            },
                            // display the copy icon or the check icon
                            icon: Icon(
                              isCodeCopied ? Icons.check : Icons.copy,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  // display the room management
                  const Divider(
                    color: Colors.blue,
                    thickness: 3,
                  ),
                  const SizedBox(height: 10),
                  // display the room management
                  const Text(
                    'Room Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // display the create room field : room name, room description and create room button
                  Container(
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: roomNameController,
                          decoration: InputDecoration(
                            labelText: 'Room Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
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
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          maxLines: 3,
                        ),
                        // display the create room button
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _createRoom,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Create Room',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // display the rooms : room name, hashtags, add hashtag field and add hashtag button
                  ValueListenableBuilder<List<Room>>(
                    valueListenable: widget.roomsNotifier,
                    builder: (context, rooms, _) {
                      if (rooms.isEmpty) {
                        return const Text('No rooms found');
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            Room room = rooms[index];
                            final hashtagController =
                                hashtagControllers[room.roomID]!;
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
                                    room.name ?? 'No problem',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 8),
                                  // display the hashtags
                                  Column(
                                    children: [
                                      // display the hashtags in a wrap widget
                                      Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        // if the room has hashtags, map through the hashtags and display them
                                        children: room.hashtags?.map((hashtag) {
                                              bool isSelected = selectedHashtag[
                                                      room.roomID] ==
                                                  hashtag;
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedHashtag[
                                                            room.roomID] =
                                                        isSelected
                                                            ? null
                                                            : hashtag;
                                                  });
                                                },
                                                // display the hashtag depending on the isSelected value : red if isSelected, blue if not
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? Colors.red
                                                        : Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    hashtag,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              );
                                            }).toList() ??
                                            [],
                                      ),
                                      // if the room has no hashtags, display a message
                                      const SizedBox(height: 4),
                                      if (selectedHashtag[room.roomID] != null)
                                        ElevatedButton(
                                          onPressed: () =>
                                              _removeHashtagFromRoom(
                                                  room,
                                                  selectedHashtag[
                                                      room.roomID]!),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            minimumSize: const Size(100, 36),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Remove',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 8),
                                  // display the add hashtag field and add hashtag button
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextField(
                                          controller: hashtagController,
                                          decoration: const InputDecoration(
                                            labelText: 'Add Hashtag',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () => _addHashtagToRoom(
                                            room, hashtagController.text),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          minimumSize: const Size(60, 36),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Add',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
