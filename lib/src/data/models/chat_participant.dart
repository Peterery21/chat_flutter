import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_participant.freezed.dart';
part 'chat_participant.g.dart';

@freezed
class ChatParticipant with _$ChatParticipant {
  const factory ChatParticipant({
    required int id,
    required int chatUserId,
    required int chatRoomId,
    required String username,
    String? avatar,
    @Default('MEMBER') String role,
  }) = _ChatParticipant;

  factory ChatParticipant.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantFromJson(json);

  /// Parse from backend ChatParticipantResponse which nests chatUser:
  /// { id, chatRoomId, role, chatUser: { id, userId, name, photo } }
  static ChatParticipant fromBackendJson(Map<String, dynamic> json) {
    final chatUser = json['chatUser'] as Map<String, dynamic>?;
    return ChatParticipant(
      id: (json['id'] as num?)?.toInt() ?? 0,
      chatUserId: (chatUser?['id'] as num?)?.toInt() ?? 0,
      chatRoomId: (json['chatRoomId'] as num?)?.toInt() ?? 0,
      username: (chatUser?['name'] as String?) ?? '',
      avatar: chatUser?['photo'] as String?,
      role: (json['role'] as String?) ?? 'MEMBER',
    );
  }
}
