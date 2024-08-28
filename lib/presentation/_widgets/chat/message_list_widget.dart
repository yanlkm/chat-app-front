import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/domain/entities/chat/db/message_db_entity.dart';
import 'message_item_widget.dart';

// MessageListWidget
class MessageListWidget extends StatelessWidget {
  // List of MessageDBEntity as attribute
  final List<MessageDBEntity> messages;
  final String? currentUserId;
  final ScrollController scrollController;

  // Constructor
  const MessageListWidget({
    super.key,
    required this.messages,
    required this.currentUserId,
    required this.scrollController,
  });

  // Add the _formatDateIndicator method to format the date and indicate if it is today or yesterday or another date
  String _formatDateIndicator(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    // checks on the date
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM dd, yyyy').format(date);
    }
  }

  // main build method
  @override
  Widget build(BuildContext context) {
    // DateTime as attribute
    DateTime? lastDate;

    // ListView builder to build the list of messages
    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // get the message at the index
        final msg = messages[index];
        final msgDate = msg.createdAt!;
        // List of message widgets
        List<Widget> messageWidgets = [];

        // check if the date is different from the last date
        if (lastDate == null ||
            msgDate.day != lastDate!.day ||
            msgDate.month != lastDate!.month ||
            msgDate.year != lastDate!.year) {
          // add the date indicator
          messageWidgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Text(
                  _formatDateIndicator(msgDate),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
          // update the last date
          lastDate = msgDate;
        }

        messageWidgets.add(
          MessageItemWidget(
            message: msg,
            currentUserId: currentUserId,
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: messageWidgets,
        );
      },
    );
  }
}
