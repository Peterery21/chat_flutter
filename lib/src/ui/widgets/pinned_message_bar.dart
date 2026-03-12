import 'package:flutter/material.dart';
import '../../config/chat_module.dart';
import '../../data/models/models.dart';

/// Sticky bar at the top of ChatScreen showing the pinned message.
class PinnedMessageBar extends StatelessWidget {
  const PinnedMessageBar({
    super.key,
    required this.room,
    this.onTap,
    this.onUnpin,
  });

  final ChatRoom room;
  final VoidCallback? onTap;
  final VoidCallback? onUnpin;

  @override
  Widget build(BuildContext context) {
    if (room.pinnedMessageId == null) return const SizedBox.shrink();

    final theme = ChatModule.theme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.surfaceColor,
          border: Border(
            bottom: BorderSide(color: theme.dividerColor),
            left: BorderSide(color: theme.primaryColor, width: 3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.push_pin, size: 16, color: theme.primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                room.pinnedMessageContent ?? 'Message épinglé',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: theme.primaryTextColor),
              ),
            ),
            if (onUnpin != null)
              GestureDetector(
                onTap: onUnpin,
                child: Icon(Icons.close, size: 18, color: theme.secondaryTextColor),
              ),
          ],
        ),
      ),
    );
  }
}
