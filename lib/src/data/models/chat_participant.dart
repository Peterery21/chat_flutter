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
}
