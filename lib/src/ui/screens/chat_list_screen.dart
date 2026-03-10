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

class _ChatListView extends StatefulWidget {
  const _ChatListView({
    required this.onRoomTap,
    this.onNewChat,
    required this.title,
  });

  final Function(ChatRoom room) onRoomTap;
  final VoidCallback? onNewChat;
  final String title;

  @override
  State<_ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<_ChatListView> {
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        title: Text(widget.title,
            style: TextStyle(color: theme.appBarTextColor)),
        iconTheme: IconThemeData(color: theme.appBarTextColor),
      ),
      floatingActionButton: widget.onNewChat != null
          ? FloatingActionButton(
              backgroundColor: theme.primaryColor,
              onPressed: widget.onNewChat,
              child: const Icon(Icons.chat, color: Colors.white),
            )
          : null,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide:
                      BorderSide(color: theme.primaryColor.withOpacity(0.4)),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ChatListBloc, ChatListState>(
              builder: (context, state) {
                if (state is ChatListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatListError) {
                  return Center(child: Text(state.message));
                }
                if (state is ChatListLoaded) {
                  final rooms = _searchQuery.isEmpty
                      ? state.rooms
                      : state.rooms.where((r) {
                          final name = (r.botId != null
                                  ? (r.botName ?? r.name)
                                  : r.name)
                              .toLowerCase();
                          return name.contains(_searchQuery);
                        }).toList();

                  if (rooms.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline,
                              size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Aucun résultat'
                                : 'Aucune discussion',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          if (widget.onNewChat != null &&
                              _searchQuery.isEmpty) ...[
                            const SizedBox(height: 8),
                            TextButton(
                                onPressed: widget.onNewChat,
                                child: const Text('Démarrer une discussion')),
                          ],
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ChatListBloc>().add(
                          ChatListLoadRequested(ChatModule.currentUserId));
                    },
                    child: ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (_, i) => _RoomTile(
                        room: rooms[i],
                        typingUsername: state.typingByRoom[rooms[i].id],
                        onTap: () => widget.onRoomTap(rooms[i]),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _RoomAvatar(room: room),
      title: Row(
        children: [
          Flexible(
            child: Text(
              room.botId != null ? (room.botName ?? room.name) : room.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (room.botId != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF00897B).withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('IA',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00897B))),
            ),
          ],
        ],
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

  static Color _colorFromName(String name) {
    const colors = [
      Color(0xFF1976D2), Color(0xFF388E3C), Color(0xFF7B1FA2),
      Color(0xFFE64A19), Color(0xFF0288D1), Color(0xFF00796B),
      Color(0xFFC2185B), Color(0xFF5D4037),
    ];
    if (name.isEmpty) return colors[0];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final displayName =
        room.botId != null ? (room.botName ?? room.name) : room.name;
    final avatarColor = room.botId != null
        ? const Color(0xFF00897B)
        : _colorFromName(displayName);

    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: avatarColor.withOpacity(0.15),
          backgroundImage:
              room.avatar != null ? NetworkImage(room.avatar!) : null,
          child: room.avatar == null
              ? (room.botId != null
                  ? Icon(Icons.smart_toy, color: avatarColor, size: 24)
                  : Text(
                      displayName.isNotEmpty
                          ? displayName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: avatarColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ))
              : null,
        ),
        if (room.isGroup)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(Icons.group, size: 8, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
