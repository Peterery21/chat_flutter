import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message.dart';
import 'chat_participant.dart';

part 'chat_room.freezed.dart';
part 'chat_room.g.dart';

@freezed
class ChatRoom with _$ChatRoom {
  const factory ChatRoom({
    required int id,
    String? name,
    @Default(false) bool isGroup,
    int? groupId,
    @JsonKey(name: 'photo') String? avatar,
    ChatMessage? lastMessage,
    @Default(0) int unreadCount,
    @Default([]) List<ChatParticipant> participants,
    int? pinnedMessageId,
    String? pinnedMessageContent,
    bool? archived,
    int? botId,
    String? botName,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);
}
