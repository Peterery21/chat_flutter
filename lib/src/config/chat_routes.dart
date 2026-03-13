import 'package:go_router/go_router.dart';

import '../data/models/models.dart';
import '../ui/screens/chat_list_screen.dart';
import '../ui/screens/chat_screen.dart';
import '../ui/screens/group_settings_screen.dart';
import '../ui/screens/new_chat_screen.dart';

/// Returns pre-wired GoRouter routes for the full chat feature.
///
/// Embed in your app's GoRouter with the spread operator:
/// ```dart
/// GoRouter(routes: [
///   ...chatGoRoutes(),
///   // your other routes...
/// ])
/// ```
///
/// Parameters:
/// - [chatsPath]: base path for the chat list (default: `/chats`)
/// - [newChatPath]: path for creating a new chat (default: `/new-chat`)
/// - [showNewChatButton]: whether to show the FloatingActionButton to create a
///   new chat on [ChatListScreen] (default: `true`)
///
/// Generated routes:
/// - `chatsPath`                     → [ChatListScreen]
/// - `chatsPath/:roomId`             → [ChatScreen]
/// - `chatsPath/:roomId/settings`    → [GroupSettingsScreen]
/// - `newChatPath`                   → [NewChatScreen]
///
/// Pass a [ChatRoom] object as `extra` when navigating to `chatsPath/:roomId`
/// to enable the group settings button for group rooms.
List<RouteBase> chatGoRoutes({
  String chatsPath = '/chats',
  String newChatPath = '/new-chat',
  bool showNewChatButton = true,
}) {
  return [
    GoRoute(
      path: chatsPath,
      builder: (context, state) => ChatListScreen(
        onRoomTap: (room) =>
            context.push('$chatsPath/${room.id}', extra: room),
        onNewChat: showNewChatButton ? () => context.push(newChatPath) : null,
      ),
    ),
    GoRoute(
      path: '$chatsPath/:roomId',
      builder: (context, state) {
        final roomId = int.parse(state.pathParameters['roomId']!);
        final room = state.extra as ChatRoom?;
        return ChatScreen(
          roomId: roomId,
          initialRoom: room,
          onGroupSettings: room?.isGroup == true
              ? () =>
                  context.push('$chatsPath/$roomId/settings', extra: room)
              : null,
        );
      },
    ),
    GoRoute(
      path: '$chatsPath/:roomId/settings',
      builder: (context, state) {
        final room = state.extra as ChatRoom;
        return GroupSettingsScreen(
          room: room,
          onRoomLeft: () => context.go(chatsPath),
          onRoomDeleted: () => context.go(chatsPath),
        );
      },
    ),
    GoRoute(
      path: newChatPath,
      builder: (context, state) => NewChatScreen(
        onRoomCreated: (room) {
          context.pop();
          context.push('$chatsPath/${room.id}', extra: room);
        },
      ),
    ),
  ];
}
