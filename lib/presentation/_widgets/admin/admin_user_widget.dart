import 'package:flutter/material.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';

// User Widget
class UserWidget extends StatelessWidget {
  // Search Controller
  final TextEditingController searchController;

  // User Notifier
  final ValueNotifier<UserEntity> userNotifier;
  // Users
  final List<UserEntity> users;
  // Functions
  final Function(String) onSearchChanged;
  final Function(String userId) onBanUser;
  final Function(String userId) onUnbanUser;

  // Constructor
  const UserWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.userNotifier,
    required this.users,
    required this.onBanUser,
    required this.onUnbanUser,
  });

  // main build widget function
  @override
  Widget build(BuildContext context) {
    // get banned users and not banned users
    final bannedUsers = users.where((user) => user.validity != 'valid').toList();
    final notBannedUsers = users.where((user) => user.validity == 'valid').toList();

    // return the main column widget
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'User Management',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildUserList(bannedUsers, 'Banned users ⛓️', Colors.red, onUnbanUser),
            const SizedBox(width: 16),
            _buildUserList(notBannedUsers, 'Not banned users ✅', Colors.green, onBanUser),
          ],
        ),
        const SizedBox(height: 16),
        // Search TextField
        TextField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            prefixIcon: Icon(Icons.search),
          ),
        onChanged: onSearchChanged,
        ),
        const SizedBox(height: 16),
        // User Details on Search with ValueListenableBuilder
        ValueListenableBuilder<UserEntity>(
          valueListenable: userNotifier,
          builder: (context, user, _) {
            // if user is not null or empty call _buildUserDetails widget method
            return (user.username != null && user.username!.isNotEmpty)
                ? _buildUserDetails(user)
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // define the _buildUserList widget
  Widget _buildUserList(List<UserEntity> users, String title, Color color, Function(String) onButtonPressed) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
          ),
          Divider(color: color, thickness: 2),
          SizedBox(
            height: 200.0,
            // List View Builder on users list with ListTile
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                // return the container with ListTile
                return Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(
                      user.username ?? 'No Name',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    trailing: IconButton(
                      icon: user.validity=="invalid" ? Icon(Icons.block, color: color) :
                      Icon(Icons.check_circle, color: color),
                      // onButtonPressed function
                      onPressed: () => onButtonPressed(user.userID as String),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // define the _buildUserDetails widget
  Widget _buildUserDetails(UserEntity user) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color:Colors.transparent),
      ),
      child: Row(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            user.username ?? 'No Name',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
      // Animated Cross Fade for Ban and Unban : Lock and Lock Open Icons
      AnimatedCrossFade(
        alignment: Alignment.topCenter,
        excludeBottomFocus: true,
        firstChild: IconButton(
          onPressed: () => onBanUser(user.userID as String),
          icon: const Icon(Icons.lock, color : Colors.red),
        ),
        secondChild: IconButton(
          onPressed: () => onUnbanUser(user.userID as String),
          icon: const Icon(Icons.lock_open_sharp, color : Colors.green),
        ),
        crossFadeState: user.validity =="invalid"
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200),
        // layout builder to define logic for top and bottom child (ban and unban)
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
      )
        ],
      ),
    );
  }
}
