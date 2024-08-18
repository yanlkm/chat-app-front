import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/message.dart';
import 'message_item_widget.dart';

class MessageListWidget extends StatelessWidget {
  final List<Message> messages;
  final String? currentUserId;
  final ScrollController scrollController;

  const MessageListWidget({
    Key? key,
    required this.messages,
    required this.currentUserId,
    required this.scrollController,
  }) : super(key: key);

  // Add the _formatDateIndicator method to format the date and indicate if it is today or yesterday or another date
  String _formatDateIndicator(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM dd, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastDate;

    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final msgDate = msg.createdAt!;
        List<Widget> messageWidgets = [];

        if (lastDate == null ||
            msgDate.day != lastDate!.day ||
            msgDate.month != lastDate!.month ||
            msgDate.year != lastDate!.year) {
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
