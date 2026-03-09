import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/chat_list/chat_list_bloc.dart';
import '../../blocs/chat_list/chat_list_event.dart';
import '../../blocs/chat_list/chat_list_state.dart';
import '../../config/chat_module.dart';
import '../../data/models/models.dart';
import '../widgets/typing_indicator.dart';

/// Main chat list screen — shows all conversations for the current user.
///
/// Usage:
/// ```dart
/// ChatListScreen(onRoomTap: (room) => context.push('/chat/${room.id}'))
/// ```
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({
    super.key,
    required this.onRoomTap,
    this.onNewChat,
    this.title = 'Discussions',
  });

  final Function(ChatRoom room) onRoomTap;
  final VoidCallback? onNewChat;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatListBloc()
        ..add(ChatListLoadRequested(ChatModule.currentUserId)),
      child: _ChatListView(
        onRoomTap: onRoomTap,
        onNewChat: onNewChat,
        title: title,
      ),
    );
  }
}

class _ChatListView extends StatelessWidget {
  const _ChatListView({
    required this.onRoomTap,
    this.onNewChat,
    required this.title,
  });

  final Function(ChatRoom room) onRoomTap;
  final VoidCallback? onNewChat;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        title: Text(title,
            style: TextStyle(color: theme.appBarTextColor)),
        iconTheme: IconThemeData(color: theme.appBarTextColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {/* TODO: search */ },
            color: theme.appBarTextColor,
          ),
        ],
      ),
      floatingActionButton: onNewChat != null
          ? FloatingActionButton(
              backgroundColor: theme.primaryColor,
              onPressed: onNewChat,
              child: const Icon(Icons.chat, color: Colors.white),
            )
          : null,
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state is ChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ChatListError) {
            return Center(child: Text(state.message));
          }
          if (state is ChatListLoaded) {
            if (state.rooms.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text('Aucune discussion',
                        style: TextStyle(color: Colors.grey.shade500)),
                    if (onNewChat != null) ...[
                      const SizedBox(height: 8),
                      TextButton(
                          onPressed: onNewChat,
                          child: const Text('Démarrer une discussion')),
                    ],
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ChatListBloc>()
                    .add(ChatListLoadRequested(ChatModule.currentUserId));
              },
              child: ListView.separated(
                itemCount: state.rooms.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, indent: 72, color: Colors.grey.shade200),
                itemBuilder: (_, i) => _RoomTile(
                  room: state.rooms[i],
                  typingUsername: state.typingByRoom[state.rooms[i].id],
                  onTap: () => onRoomTap(state.rooms[i]),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  const _RoomTile({
    required this.room,
    this.typingUsername,
    required this.onTap,
  });

  final ChatRoom room;
  final String? typingUsername;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;
    final last = room.lastMessage;

    return ListTile(
      onTap: onTap,
      leading: _RoomAvatar(room: room),
      title: Text(
        room.name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: typingUsername != null
          ? Text(
              '$typingUsername écrit...',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: theme.primaryColor,
                fontSize: 13,
              ),
            )
          : (last != null
              ? Text(
                  last.deleted ? 'Message supprimé' : last.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.secondaryTextColor,
                    fontStyle:
                        last.deleted ? FontStyle.italic : FontStyle.normal,
                  ),
                )
              : null),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (last != null)
            Text(
              _formatDate(last.createdAt),
              style: TextStyle(
                fontSize: 11,
                color: room.unreadCount > 0
                    ? theme.primaryColor
                    : theme.secondaryTextColor,
              ),
            ),
          if (room.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.unreadBadgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                room.unreadCount > 99 ? '99+' : room.unreadCount.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      final now = DateTime.now();
      if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
      return '${dt.day}/${dt.month}';
    } catch (_) {
      return '';
    }
  }
}

class _RoomAvatar extends StatelessWidget {
  const _RoomAvatar({required this.room});
  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.primaryColor.withOpacity(0.15),
          backgroundImage:
              room.avatar != null ? NetworkImage(room.avatar!) : null,
          child: room.avatar == null
              ? Text(
                  room.name.isNotEmpty ? room.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              : null,
        ),
        if (room.botId != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(Icons.smart_toy, size: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
