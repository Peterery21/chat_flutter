import 'dart:io';
import '../api/chat_api_client.dart';
import '../models/models.dart';

class ChatMessageRepository {
  const ChatMessageRepository(this._api);
  final ChatApiClient _api;

  Future<List<ChatMessage>> getMessages({
    required int userId,
    required int roomId,
    required int fromMessageId,
    int page = 0,
    int size = 20,
  }) =>
      _api.getMessages(
        userId: userId,
        chatRoomId: roomId,
        messageId: fromMessageId,
        page: page,
        size: size,
      );

  Future<List<ChatMessage>> getOlderMessages({
    required int userId,
    required int roomId,
    required int fromMessageId,
    int page = 0,
    int size = 20,
  }) =>
      _api.getOldMessages(
        userId: userId,
        chatRoomId: roomId,
        messageId: fromMessageId,
        page: page,
        size: size,
      );

  Future<ChatMessage> send({
    required int userId,
    required int roomId,
    required String content,
    int? replyToMessageId,
    File? mediaFile,
  }) =>
      _api.sendMessage(
        userId: userId,
        chatRoomId: roomId,
        content: content,
        replyToMessageId: replyToMessageId,
        mediaFile: mediaFile,
      );

  Future<void> deleteForMe(int id) => _api.deleteMessageForMe(id);
  Future<void> deleteForAll(int id) => _api.deleteMessageForAll(id);
  Future<ChatMessage> edit(int id, String content) =>
      _api.editMessage(id, content);

  Future<void> addReaction(int messageId, String emoji) =>
      _api.addReaction(messageId, emoji);

  Future<void> forward(int messageId, int targetRoomId) =>
      _api.forwardMessage(messageId, targetRoomId);

  Future<List<ChatMessage>> search(String query, int roomId) =>
      _api.searchMessages(query, roomId);
}
