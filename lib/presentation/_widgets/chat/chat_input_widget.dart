import 'package:flutter/material.dart';

// Chat Input Widget
class ChatInputWidget extends StatelessWidget {
  // Text Editing controller
  final TextEditingController messageController;
  // Send action as a Callback function
  final VoidCallback onSend;
//  Constructor
  const ChatInputWidget({
    super.key,
    required this.messageController,
    required this.onSend,
  });

  // main build method
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Enter message',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
