import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/chat_room/chat_room_bloc.dart';
import '../../blocs/chat_room/chat_room_event.dart';
import '../../blocs/chat_room/chat_room_state.dart';
import '../../blocs/typing/typing_cubit.dart';
import '../../config/chat_module.dart';
import '../../data/models/models.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/message_bubble.dart';
import '../widgets/pinned_message_bar.dart';
import '../widgets/typing_indicator.dart';

/// Full chat screen for a single room.
///
/// Usage:
/// ```dart
/// ChatScreen(roomId: room.id, onGroupSettings: () => context.push('/settings'))
/// ```
class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.roomId,
    this.onGroupSettings,
    this.onUserTap,
  });

  final int roomId;
  final VoidCallback? onGroupSettings;
  final Function(int chatUserId)? onUserTap;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ChatRoomBloc()
            ..add(ChatRoomLoadRequested(
              roomId: roomId,
              userId: ChatModule.currentUserId,
            )),
        ),
        BlocProvider(create: (_) => TypingCubit(roomId)),
      ],
      child: _ChatScreenBody(
        roomId: roomId,
        onGroupSettings: onGroupSettings,
        onUserTap: onUserTap,
      ),
    );
  }
}

class _ChatScreenBody extends StatefulWidget {
  const _ChatScreenBody({
    required this.roomId,
    this.onGroupSettings,
    this.onUserTap,
  });

  final int roomId;
  final VoidCallback? onGroupSettings;
  final Function(int chatUserId)? onUserTap;

  @override
  State<_ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<_ChatScreenBody> {
  final _scrollController = ScrollController();
  ChatMessage? _replyToMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load older messages when scrolled near the top
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ChatRoomBloc>().add(const ChatRoomLoadOlderMessages());
    }
  }

  void _setReply(ChatMessage msg) => setState(() => _replyToMessage = msg);
  void _cancelReply() => setState(() => _replyToMessage = null);

  void _sendMessage(String content,
      {int? replyToId, File? mediaFile, String? mediaFilename, List<int>? mentionedUserIds}) {
    context.read<ChatRoomBloc>().add(
          ChatRoomSendMessage(
            content: content,
            replyToMessageId: replyToId,
            mediaFile: mediaFile,
            mediaFilename: mediaFilename,
            mentionedUserIds: mentionedUserIds,
          ),
        );
    context.read<TypingCubit>().stopTyping(
          ChatModule.currentUserId,
          ChatModule.currentUserName,
        );
    _cancelReply();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;

    return BlocBuilder<ChatRoomBloc, ChatRoomState>(
      builder: (context, state) {
        if (state is ChatRoomLoading) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: theme.appBarColor,
              iconTheme: IconThemeData(color: theme.appBarTextColor),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ChatRoomError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }

        if (state is ChatRoomLoaded) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: _buildAppBar(context, state.room, theme),
            body: Column(
              children: [
                PinnedMessageBar(
                  room: state.room,
                  onTap: () => _scrollToMessage(state, state.room.pinnedMessageId!),
                  onUnpin: state.room.isGroup ? () {
                    ChatModule.rooms.unpin(widget.roomId);
                  } : null,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.messages.length,
                      itemBuilder: (_, i) {
                        final msg = state.messages[i];
                        final showDate = i == state.messages.length - 1 ||
                            !_sameDay(
                                msg.createdAt,
                                state.messages[i + 1].createdAt);
                        return Column(
                          children: [
                            if (showDate) _DateSeparator(createdAt: msg.createdAt),
                            MessageBubble(
                              message: msg,
                              onReply: () => _setReply(msg),
                              onEdit: msg.senderId == ChatModule.currentUserId
                                  ? () => _showEditDialog(context, msg)
                                  : null,
                              onDelete: () => _showDeleteDialog(context, msg),
                              onReact: (emoji) => context
                                  .read<ChatRoomBloc>()
                                  .add(ChatRoomAddReaction(
                                    messageId: msg.id,
                                    emoji: emoji,
                                  )),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                BlocBuilder<TypingCubit, Map<int, String>>(
                  builder: (_, typingUsers) => TypingIndicator(
                    typingUsers: Map.fromEntries(
                      typingUsers.entries.where(
                          (e) => e.key != ChatModule.currentUserId),
                    ),
                  ),
                ),
                ChatInputBar(
                  onSend: _sendMessage,
                  participants: state.room.participants,
                  replyToMessage: _replyToMessage,
                  onCancelReply: _cancelReply,
                ),
              ],
            ),
          );
        }

        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ChatRoom room, theme) {
    final displayName =
        room.botId != null ? (room.botName ?? room.name) : room.name;
    return AppBar(
      backgroundColor: theme.appBarColor,
      iconTheme: IconThemeData(color: theme.appBarTextColor),
      titleSpacing: 0,
      title: GestureDetector(
        onTap: room.isGroup ? widget.onGroupSettings : null,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: room.botId != null
                  ? const Color(0xFF00897B).withOpacity(0.2)
                  : theme.primaryColor.withOpacity(0.2),
              backgroundImage:
                  room.avatar != null ? NetworkImage(room.avatar!) : null,
              child: room.avatar == null
                  ? (room.botId != null
                      ? Icon(Icons.smart_toy,
                          size: 20, color: const Color(0xFF00897B))
                      : Text(displayName.isNotEmpty
                          ? displayName[0].toUpperCase()
                          : '?',
                          style: TextStyle(color: theme.primaryColor)))
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName,
                    style: TextStyle(
                        color: theme.appBarTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                if (room.botId != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        'Assistant IA',
                        style: TextStyle(
                            color: theme.appBarTextColor.withOpacity(0.8),
                            fontSize: 12),
                      ),
                    ],
                  )
                else if (room.isGroup && room.participants.length > 2)
                  Text(
                    '${room.participants.length} membres',
                    style: TextStyle(
                        color: theme.appBarTextColor.withOpacity(0.8),
                        fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        if (room.isGroup && widget.onGroupSettings != null)
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.appBarTextColor),
            onPressed: widget.onGroupSettings,
          ),
      ],
    );
  }

  void _scrollToMessage(ChatRoomLoaded state, int messageId) {
    final idx = state.messages.indexWhere((m) => m.id == messageId);
    if (idx >= 0) {
      _scrollController.animateTo(
        idx * 80.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showEditDialog(BuildContext context, ChatMessage msg) {
    final ctrl = TextEditingController(text: msg.content);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier le message'),
        content: TextField(controller: ctrl, maxLines: null),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              context.read<ChatRoomBloc>().add(ChatRoomEditMessage(
                    messageId: msg.id,
                    content: ctrl.text.trim(),
                  ));
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ChatMessage msg) {
    final isOwn = msg.senderId == ChatModule.currentUserId;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer le message ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          if (isOwn)
            TextButton(
              onPressed: () {
                context.read<ChatRoomBloc>().add(
                    ChatRoomDeleteMessage(messageId: msg.id, forAll: true));
                Navigator.pop(context);
              },
              child: const Text('Pour tout le monde',
                  style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () {
              context.read<ChatRoomBloc>().add(
                  ChatRoomDeleteMessage(messageId: msg.id, forAll: false));
              Navigator.pop(context);
            },
            child: const Text('Pour moi', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool _sameDay(String a, String b) {
    try {
      final da = DateTime.parse(a);
      final db = DateTime.parse(b);
      return da.day == db.day && da.month == db.month && da.year == db.year;
    } catch (_) {
      return false;
    }
  }
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.createdAt});
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    String label;
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      final now = DateTime.now();
      if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
        label = "Aujourd'hui";
      } else if (dt.day == now.day - 1 &&
          dt.month == now.month &&
          dt.year == now.year) {
        label = 'Hier';
      } else {
        label = '${dt.day}/${dt.month}/${dt.year}';
      }
    } catch (_) {
      label = '';
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
