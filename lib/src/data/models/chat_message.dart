import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_reaction.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required int id,
    required int chatRoomId,
    required int senderId,
    String? senderName,
    String? senderAvatar,
    required String content,
    required String createdAt,
    String? updatedAt,
    String? mediaUrl,
    String? mediaType,
    int? replyToMessageId,
    String? replyToContent,
    String? replyToSenderName,
    int? sondageId,
    @Default(false) bool deleted,
    @Default(false) bool edited,
    @Default(false) bool read,
    @Default([]) List<int> mentionedUserIds,
    @Default([]) List<ChatReaction> reactions,
    @Default(false) bool fromBot,
    String? botName,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
