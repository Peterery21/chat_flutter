import '../api/chat_api_client.dart';
import '../models/models.dart';

class ChatRoomRepository {
  const ChatRoomRepository(this._api);
  final ChatApiClient _api;

  Future<List<ChatRoom>> getRooms(int userId) => _api.getRoomsByUser(userId);
  Future<List<ChatRoom>> getArchivedRooms() => _api.getArchivedRooms();

  Future<ChatRoom> createDirectRoom(int userId, int targetUserId) =>
      _api.createRoom(userId: userId, targetUserId: targetUserId);

  Future<ChatRoom> createGroupRoom({
    required int userId,
    required String groupName,
    required List<int> participantIds,
  }) =>
      _api.createRoom(
        userId: userId,
        isGroup: true,
        groupName: groupName,
        participantIds: participantIds,
      );

  Future<void> updateName(int roomId, String name) =>
      _api.updateRoomName(roomId, name);

  Future<void> archive(int roomId) => _api.archiveRoom(roomId);
  Future<void> unarchive(int roomId) => _api.unarchiveRoom(roomId);
  Future<void> leave(int roomId) => _api.leaveRoom(roomId);
  Future<void> deleteGroup(int groupId) => _api.deleteGroup(groupId);

  Future<void> addParticipant(int roomId, int userId) =>
      _api.addParticipant(roomId, userId);

  Future<void> kickParticipant(int roomId, int userId) =>
      _api.kickParticipant(roomId, userId);

  Future<void> updateRole(int roomId, int chatUserId, String role) =>
      _api.updateParticipantRole(roomId, chatUserId, role);

  Future<void> pin(int roomId, int messageId) =>
      _api.pinMessage(roomId, messageId);

  Future<void> unpin(int roomId) => _api.unpinMessage(roomId);

  Future<void> setBot(int roomId, int botId) => _api.setRoomBot(roomId, botId);
  Future<void> removeBot(int roomId) => _api.removeRoomBot(roomId);
}
