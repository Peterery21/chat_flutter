import 'dart:io';
import 'package:dio/dio.dart';
import '../models/models.dart';

/// Dio-based REST client for all chat-api endpoints.
///
/// Automatically injects the Bearer token from [authTokenProvider]
/// on every request via an interceptor.
///
/// When [onUnauthorized] is provided, a 401 response triggers a call to this
/// callback. If it returns a new token, the original request is retried once
/// with the refreshed token. This allows the host app to plug in its own
/// token-refresh logic (e.g., using a refresh token).
class ChatApiClient {
  ChatApiClient({
    required String baseUrl,
    required Future<String?> Function() authTokenProvider,
    required int currentUserId,
    required String currentUserName,
    Future<String?> Function()? onUnauthorized,
  })  : _baseUrl = baseUrl,
        _currentUserId = currentUserId,
        _currentUserName = currentUserName {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await authTokenProvider();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && onUnauthorized != null) {
            try {
              final newToken = await onUnauthorized();
              if (newToken != null && newToken.isNotEmpty) {
                final retryOptions = error.requestOptions;
                retryOptions.headers['Authorization'] = 'Bearer $newToken';
                final response = await _dio.fetch(retryOptions);
                return handler.resolve(response);
              }
            } catch (_) {
              // Refresh failed — fall through to reject with original error
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  final String _baseUrl;
  final int _currentUserId;
  final String _currentUserName;
  late final Dio _dio;

  // ─── ChatUser ────────────────────────────────────────────────────────────

  Future<ChatUser> createOrUpdateUser({
    required int userId,
    required String username,
    String? avatar,
  }) async {
    final res = await _dio.post('/chats/user/createUpdate', data: {
      'userId': userId,
      'name': username,
      if (avatar != null) 'avatar': avatar,
    });
    return ChatUser.fromJson(res.data);
  }

  Future<bool> userExists(int userId) async {
    final res = await _dio.get('/chats/user/exists/$userId');
    return res.data == true;
  }

  // ─── ChatRoom ─────────────────────────────────────────────────────────────

  /// Parses a ChatRoom from backend JSON, mapping nested chatUser participants.
  static ChatRoom parseRoomJson(Map<String, dynamic> json) {
    final rawParticipants = json['participants'] as List<dynamic>?;
    // Strip participants before fromJson — backend format uses nested chatUser,
    // which is incompatible with the flat ChatParticipant.fromJson schema.
    final jsonWithoutParticipants = Map<String, dynamic>.from(json)
      ..remove('participants');
    final room = ChatRoom.fromJson(jsonWithoutParticipants);
    if (rawParticipants == null || rawParticipants.isEmpty) return room;
    return room.copyWith(
      participants: rawParticipants
          .map((e) => ChatParticipant.fromBackendJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<List<ChatRoom>> getRoomsByUser(int userId) async {
    final res = await _dio.get('/chats/room/byUser/$userId');
    return (res.data as List).map((e) => parseRoomJson(e)).toList();
  }

  Future<ChatRoom> createRoom({
    required int userId,
    int? targetUserId,
    bool isGroup = false,
    String? groupName,
    int? groupId,
    List<int> participantIds = const [],
  }) async {
    final res = await _dio.post('/chats/room/create', data: {
      'userId': userId,
      if (targetUserId != null) 'targetUserId': targetUserId,
      'isGroup': isGroup,
      if (groupName != null) 'groupName': groupName,
      if (groupId != null) 'groupId': groupId,
      'participantIds': participantIds,
    });
    return parseRoomJson(res.data as Map<String, dynamic>);
  }

  Future<ChatRoom> getRoom(int roomId, int userId) async {
    final res = await _dio.post('/chats/room/get', data: {
      'roomId': roomId,
      'userId': userId,
    });
    return parseRoomJson(res.data as Map<String, dynamic>);
  }

  Future<void> addParticipant(int roomId, int userId) async {
    await _dio.post('/chats/room/addParticipant', data: {
      'roomId': roomId,
      'userId': userId,
    });
  }

  Future<void> deleteGroup(int groupId) async {
    await _dio.delete('/chats/room/group/$groupId');
  }

  Future<void> updateRoomName(int roomId, String name) async {
    await _dio.patch('/chats/rooms/$roomId/name', data: {'name': name});
  }

  Future<void> updateParticipantRole(
      int roomId, int chatUserId, String role) async {
    await _dio.patch(
        '/chats/rooms/$roomId/participants/$chatUserId/role',
        data: {'role': role});
  }

  Future<void> kickParticipant(int roomId, int targetUserId) async {
    await _dio.delete('/chats/rooms/$roomId/participants/$targetUserId/kick');
  }

  Future<void> leaveRoom(int roomId) async {
    await _dio.delete('/chats/rooms/$roomId/leave');
  }

  Future<void> archiveRoom(int roomId) async {
    await _dio.post('/chats/rooms/$roomId/archive');
  }

  Future<void> unarchiveRoom(int roomId) async {
    await _dio.delete('/chats/rooms/$roomId/archive');
  }

  Future<List<ChatRoom>> getArchivedRooms() async {
    final res = await _dio.get('/chats/rooms/archived');
    return (res.data as List).map((e) => parseRoomJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> pinMessage(int roomId, int messageId) async {
    await _dio.post('/chats/rooms/$roomId/pin/$messageId');
  }

  Future<void> unpinMessage(int roomId) async {
    await _dio.delete('/chats/rooms/$roomId/pin');
  }

  // ─── ChatMessage ──────────────────────────────────────────────────────────

  Future<ChatMessage> sendMessage({
    required int userId,
    required int chatRoomId,
    required String content,
    int? replyToMessageId,
    File? mediaFile,
    String? mediaFilename,
    String? mediaBase64,
    String? mediaCategory,
    List<int>? mentionedUserIds,
  }) async {
    // Backend uses @ModelAttribute → always multipart/form-data
    // Field name is `chatUserId` (internal chat user id), not `userId`
    final formData = FormData.fromMap({
      'chatUserId': userId,
      'chatRoomId': chatRoomId,
      'content': content,
      if (replyToMessageId != null) 'replyToMessageId': replyToMessageId,
      if (mediaCategory != null) 'mediaCategory': mediaCategory,
      if (mediaFile != null)
        'mediaFile': await MultipartFile.fromFile(
          mediaFile.path,
          filename: mediaFilename ?? mediaFile.path.split('/').last,
        ),
      if (mediaFilename != null) 'mediaFilename': mediaFilename,
      if (mediaBase64 != null) 'mediaBytes': mediaBase64,
    });
    // Spring @ModelAttribute with List<Long>: repeated fields
    if (mentionedUserIds != null && mentionedUserIds.isNotEmpty) {
      formData.fields.addAll(
        mentionedUserIds.map((id) => MapEntry('mentionedUserIds', id.toString())),
      );
    }
    final res = await _dio.post('/chats/messages/send', data: formData);
    return ChatMessage.fromJson(res.data);
  }

  Future<List<ChatUserResult>> searchUsers(String query) async {
    final res = await _dio.get(
      '/chats/user/search',
      queryParameters: {'q': query},
    );
    return (res.data as List)
        .map((e) => ChatUserResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChatMessage>> getMessages({
    required int userId,
    required int chatRoomId,
    required int messageId,
    int page = 0,
    int size = 20,
  }) async {
    final res = await _dio.get(
        '/chats/messages/$userId/$chatRoomId/$messageId/$page/$size');
    return (res.data as List).map((e) => ChatMessage.fromJson(e)).toList();
  }

  Future<List<ChatMessage>> getOldMessages({
    required int userId,
    required int chatRoomId,
    required int messageId,
    int page = 0,
    int size = 20,
  }) async {
    final res = await _dio.get(
        '/chats/oldMessages/$userId/$chatRoomId/$messageId/$page/$size');
    return (res.data as List).map((e) => ChatMessage.fromJson(e)).toList();
  }

  Future<ChatMessage> getMessage(int id) async {
    final res = await _dio.get('/chats/messages/$id');
    return ChatMessage.fromJson(res.data);
  }

  Future<void> deleteMessageForMe(int id) async {
    await _dio.delete('/chats/messages/$id/me');
  }

  Future<void> deleteMessageForAll(int id) async {
    await _dio.delete('/chats/messages/$id');
  }

  Future<ChatMessage> editMessage(int id, String content) async {
    final res = await _dio.patch('/chats/messages/$id',
        data: {'content': content});
    return ChatMessage.fromJson(res.data);
  }

  Future<void> addReaction(int messageId, String emoji) async {
    await _dio.post('/chats/messages/$messageId/reactions',
        data: {'emoji': emoji});
  }

  Future<void> forwardMessage(int messageId, int targetRoomId) async {
    await _dio.post('/chats/messages/$messageId/forward',
        data: {'targetRoomId': targetRoomId});
  }

  Future<List<ChatMessage>> searchMessages(String query, int roomId) async {
    final res = await _dio.get('/chats/messages/search',
        queryParameters: {'q': query, 'roomId': roomId});
    return (res.data as List).map((e) => ChatMessage.fromJson(e)).toList();
  }

  // ─── Presence & Blocking ─────────────────────────────────────────────────

  Future<Map<String, dynamic>> getPresence(int chatUserId) async {
    final res = await _dio.get('/chats/users/$chatUserId/presence');
    return res.data as Map<String, dynamic>;
  }

  Future<void> blockUser(int blockerId, int blockedId) async {
    await _dio.post('/chats/users/$blockerId/block/$blockedId');
  }

  Future<void> unblockUser(int blockerId, int blockedId) async {
    await _dio.delete('/chats/users/$blockerId/block/$blockedId');
  }

  // ─── AI Bot ───────────────────────────────────────────────────────────────

  Future<void> setRoomBot(int roomId, int botId) async {
    await _dio.post('/chats/rooms/$roomId/bot/$botId');
  }

  Future<void> removeRoomBot(int roomId) async {
    await _dio.delete('/chats/rooms/$roomId/bot');
  }

  Future<void> updateAiSystemPrompt(int roomId, String prompt) async {
    await _dio.put('/chats/rooms/$roomId/ai/system-prompt',
        data: {'systemPrompt': prompt});
  }

  Future<void> clearAiHistory(int roomId) async {
    await _dio.delete('/chats/rooms/$roomId/ai/history');
  }

  /// Returns the SSE stream URL for AI streaming responses.
  String aiStreamUrl(int roomId) => '$_baseUrl/chats/rooms/$roomId/ai/stream';

  // ─── Chat Bots CRUD ──────────────────────────────────────────────────────

  Future<List<ChatBot>> getBots() async {
    final res = await _dio.get('/api/chat/bots');
    return (res.data as List).map((e) => ChatBot.fromJson(e)).toList();
  }

  Future<ChatBot> getBot(int id) async {
    final res = await _dio.get('/api/chat/bots/$id');
    return ChatBot.fromJson(res.data);
  }

  Future<ChatBot> createBot(Map<String, dynamic> data) async {
    final res = await _dio.post('/api/chat/bots', data: data);
    return ChatBot.fromJson(res.data);
  }

  Future<ChatBot> updateBot(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/api/chat/bots/$id', data: data);
    return ChatBot.fromJson(res.data);
  }

  Future<void> deleteBot(int id) async {
    await _dio.delete('/api/chat/bots/$id');
  }

  Future<void> toggleBot(int id) async {
    await _dio.patch('/api/chat/bots/$id/toggle');
  }

  Future<ChatRoom> startBotChat(int botId, int userId) async {
    // Auto-sync the current user in the chat system before starting the bot session.
    // This ensures a ChatUser record exists even if the parent app hasn't called
    // createOrUpdateUser explicitly (e.g. on first bot usage after signup).
    await createOrUpdateUser(
      userId: _currentUserId,
      username: _currentUserName,
    );
    final res = await _dio.post('/api/chat/bots/$botId/start-chat',
        queryParameters: {'userId': userId});
    return parseRoomJson(res.data as Map<String, dynamic>);
  }

  Future<ChatBot> getPrimaryBot() async {
    final res = await _dio.get('/api/chat/bots/primary');
    return ChatBot.fromJson(res.data as Map<String, dynamic>);
  }
}
