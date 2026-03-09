import 'dart:async';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../models/models.dart';
import '../models/chat_message.dart';
import '../models/chat_room.dart';
import 'dart:convert';

/// Typing event from a WebSocket STOMP subscription.
class TypingEvent {
  const TypingEvent({
    required this.userId,
    required this.username,
    required this.typing,
  });
  final int userId;
  final String username;
  final bool typing;
}

/// Manages the STOMP WebSocket connection to chat-api.
///
/// Subscribes to:
/// - `/topic/chat/room/{roomId}` — new messages in a room
/// - `/queue/chat/user/{userId}/rooms` — room list updates
/// - `/topic/chat/room/{roomId}/typing` — typing indicators
class ChatStompClient {
  ChatStompClient({
    required String baseUrl,
    required Future<String?> Function() authTokenProvider,
  })  : _authTokenProvider = authTokenProvider,
        _wsUrl = _toWsUrl(baseUrl);

  final Future<String?> Function() _authTokenProvider;
  final String _wsUrl;

  late StompClient _client;
  bool _connected = false;

  final _messageControllers = <int, StreamController<ChatMessage>>{};
  final _roomListControllers = <int, StreamController<List<ChatRoom>>>{};
  final _typingControllers = <int, StreamController<TypingEvent>>{};

  Future<void> connect() async {
    final token = await _authTokenProvider();
    final completer = Completer<void>();

    _client = StompClient(
      config: StompConfig(
        url: _wsUrl,
        onConnect: (frame) {
          _connected = true;
          if (!completer.isCompleted) completer.complete();
        },
        onDisconnect: (_) => _connected = false,
        onStompError: (frame) {
          if (!completer.isCompleted) {
            completer.completeError(Exception(frame.body));
          }
        },
        onWebSocketError: (error) {
          if (!completer.isCompleted) completer.completeError(error);
        },
        reconnectDelay: const Duration(seconds: 5),
        stompConnectHeaders: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
        webSocketConnectHeaders: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );

    _client.activate();
    await completer.future.timeout(const Duration(seconds: 15));
  }

  Future<void> disconnect() async {
    _client.deactivate();
    _connected = false;
    for (final c in _messageControllers.values) {
      await c.close();
    }
    for (final c in _roomListControllers.values) {
      await c.close();
    }
    for (final c in _typingControllers.values) {
      await c.close();
    }
  }

  /// Stream of new messages for [roomId].
  Stream<ChatMessage> messagesFor(int roomId) {
    final controller = _messageControllers.putIfAbsent(
      roomId,
      () => StreamController<ChatMessage>.broadcast(),
    );

    if (_connected) {
      _client.subscribe(
        destination: '/topic/chat/room/$roomId',
        callback: (frame) {
          if (frame.body != null) {
            final msg = ChatMessage.fromJson(
                jsonDecode(frame.body!) as Map<String, dynamic>);
            controller.add(msg);
          }
        },
      );
    }

    return controller.stream;
  }

  /// Stream of room list updates for [userId].
  Stream<List<ChatRoom>> roomListFor(int userId) {
    final controller = _roomListControllers.putIfAbsent(
      userId,
      () => StreamController<List<ChatRoom>>.broadcast(),
    );

    if (_connected) {
      _client.subscribe(
        destination: '/queue/chat/user/$userId/rooms',
        callback: (frame) {
          if (frame.body != null) {
            final rooms = (jsonDecode(frame.body!) as List)
                .map((e) => ChatRoom.fromJson(e as Map<String, dynamic>))
                .toList();
            controller.add(rooms);
          }
        },
      );
    }

    return controller.stream;
  }

  /// Stream of typing events for [roomId].
  Stream<TypingEvent> typingFor(int roomId) {
    final controller = _typingControllers.putIfAbsent(
      roomId,
      () => StreamController<TypingEvent>.broadcast(),
    );

    if (_connected) {
      _client.subscribe(
        destination: '/topic/chat/room/$roomId/typing',
        callback: (frame) {
          if (frame.body != null) {
            final data = jsonDecode(frame.body!) as Map<String, dynamic>;
            controller.add(TypingEvent(
              userId: data['userId'] as int,
              username: data['username'] as String,
              typing: data['typing'] as bool,
            ));
          }
        },
      );
    }

    return controller.stream;
  }

  /// Sends a message via STOMP (alternative to REST).
  void sendMessage(int roomId, String content, int senderId) {
    if (!_connected) return;
    _client.send(
      destination: '/app/send_message',
      body: jsonEncode({
        'chatRoomId': roomId,
        'content': content,
        'senderId': senderId,
      }),
    );
  }

  /// Broadcasts typing status.
  void sendTyping(int roomId, int userId, String username, bool typing) {
    if (!_connected) return;
    _client.send(
      destination: '/app/typing',
      body: jsonEncode({
        'chatRoomId': roomId,
        'userId': userId,
        'username': username,
        'typing': typing,
      }),
    );
  }

  bool get isConnected => _connected;

  static String _toWsUrl(String baseUrl) {
    return baseUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');
  }
}
