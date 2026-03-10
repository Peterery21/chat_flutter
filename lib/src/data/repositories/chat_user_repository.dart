import '../api/chat_api_client.dart';
import '../models/models.dart';

class ChatUserRepository {
  const ChatUserRepository(this._api);
  final ChatApiClient _api;

  Future<ChatUser> syncUser({
    required int userId,
    required String username,
    String? avatar,
  }) =>
      _api.createOrUpdateUser(
          userId: userId, username: username, avatar: avatar);

  Future<bool> exists(int userId) => _api.userExists(userId);

  Future<Map<String, dynamic>> getPresence(int chatUserId) =>
      _api.getPresence(chatUserId);

  Future<List<ChatUserResult>> searchUsers(String query) =>
      _api.searchUsers(query);

  Future<void> block(int blockerId, int blockedId) =>
      _api.blockUser(blockerId, blockedId);

  Future<void> unblock(int blockerId, int blockedId) =>
      _api.unblockUser(blockerId, blockedId);
}
