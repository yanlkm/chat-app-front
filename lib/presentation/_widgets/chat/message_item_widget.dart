import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';

// MessageItemWidget
class MessageItemWidget extends StatelessWidget {
  // MessageDBEntity as attribute
  final MessageDBEntity message;
  // currentUserId as attribute
  final String? currentUserId;

  // Constructor
  const MessageItemWidget({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  // main build method
  @override
  Widget build(BuildContext context) {
    // check if the message is from the current user
    final isCurrentUser = message.userId == currentUserId;
    // format the time
    final formattedTime = DateFormat('HH:mm').format(message.createdAt!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment:
        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // ConstrainedBox to limit the width of the message
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 2 / 3,
            ),
            // Container to wrap the message
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.blue[100] : Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: !isCurrentUser ? Border.all(color: Colors.black) : null,
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.username!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        message.content!,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  // Positioned to place the time at the bottom right
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      formattedTime,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
