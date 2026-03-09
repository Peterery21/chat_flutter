import 'package:flutter_test/flutter_test.dart';
import 'package:chat_flutter/chat_flutter.dart';

void main() {
  group('ChatTheme', () {
    test('default theme has correct primary color', () {
      const theme = ChatTheme.defaultTheme;
      expect(theme.primaryColor.value, 0xFF075E54);
    });

    test('copyWith overrides values', () {
      const theme = ChatTheme.defaultTheme;
      final updated = theme.copyWith(messageFontSize: 18.0);
      expect(updated.messageFontSize, 18.0);
      expect(updated.primaryColor, theme.primaryColor);
    });
  });

  group('ChatRoom model', () {
    test('fromJson parses correctly', () {
      final room = ChatRoom.fromJson({
        'id': 1,
        'name': 'Test Room',
        'isGroup': false,
      });
      expect(room.id, 1);
      expect(room.name, 'Test Room');
      expect(room.isGroup, false);
      expect(room.unreadCount, 0);
    });
  });

  group('ChatMessage model', () {
    test('fromJson parses correctly', () {
      final msg = ChatMessage.fromJson({
        'id': 42,
        'chatRoomId': 1,
        'senderId': 7,
        'content': 'Hello world',
        'createdAt': '2024-01-01T10:00:00',
      });
      expect(msg.id, 42);
      expect(msg.content, 'Hello world');
      expect(msg.deleted, false);
      expect(msg.reactions, isEmpty);
    });
  });
}
