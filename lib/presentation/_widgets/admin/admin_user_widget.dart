import 'package:flutter/material.dart';
import '../../../models/user.dart';

class UserWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final ValueNotifier<User> userNotifier;
  final List<User> users;
  final Function(String userId) onBanUser;
  final Function(String userId) onUnbanUser;

  const UserWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.userNotifier,
    required this.users,
    required this.onBanUser,
    required this.onUnbanUser,
  });

  @override
  Widget build(BuildContext context) {
    final bannedUsers = users.where((user) => user.validity != 'valid').toList();
    final notBannedUsers = users.where((user) => user.validity == 'valid').toList();

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
        ValueListenableBuilder<User>(
          valueListenable: userNotifier,
          builder: (context, user, _) {
            return user.username != null
                ? _buildUserDetails(user)
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildUserList(List<User> users, String title, Color color, Function(String) onButtonPressed) {
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
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
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

  Widget _buildUserDetails(User user) {
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
