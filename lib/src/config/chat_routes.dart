import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/chat_module.dart';
import '../data/models/models.dart';
import '../ui/screens/chat_list_screen.dart';
import '../ui/screens/chat_screen.dart';
import '../ui/screens/group_settings_screen.dart';
import '../ui/screens/new_chat_screen.dart';

/// Wraps [child] with the parent app's [ThemeData] if available via [ChatModule.parentTheme].
/// This ensures all chat screens inherit the parent app's fonts, input styles, etc.
Widget _withParentTheme(Widget child) {
  final parentTheme = ChatModule.parentTheme;
  if (parentTheme == null) return child;
  return Theme(data: parentTheme, child: child);
}

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
      builder: (context, state) => _withParentTheme(ChatListScreen(
        onRoomTap: (room) =>
            context.push('$chatsPath/${room.id}', extra: room),
        onNewChat: showNewChatButton ? () => context.push(newChatPath) : null,
      )),
    ),
    GoRoute(
      path: '$chatsPath/:roomId',
      builder: (context, state) {
        final roomId = int.parse(state.pathParameters['roomId']!);
        final room = state.extra as ChatRoom?;
        return _withParentTheme(ChatScreen(
          roomId: roomId,
          initialRoom: room,
          onGroupSettings: room?.isGroup == true
              ? () =>
                  context.push('$chatsPath/$roomId/settings', extra: room)
              : null,
        ));
      },
    ),
    GoRoute(
      path: '$chatsPath/:roomId/settings',
      builder: (context, state) {
        final room = state.extra as ChatRoom;
        return _withParentTheme(GroupSettingsScreen(
          room: room,
          onRoomLeft: () => context.go(chatsPath),
          onRoomDeleted: () => context.go(chatsPath),
        ));
      },
    ),
    GoRoute(
      path: newChatPath,
      builder: (context, state) => _withParentTheme(NewChatScreen(
        onRoomCreated: (room) {
          context.pop();
          context.push('$chatsPath/${room.id}', extra: room);
        },
      )),
    ),
  ];
}
