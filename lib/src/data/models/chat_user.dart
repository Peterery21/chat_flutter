import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_user.freezed.dart';
part 'chat_user.g.dart';

@freezed
class ChatUser with _$ChatUser {
  const factory ChatUser({
    required int id,
    required int userId,
    required String username,
    String? avatar,
    bool? online,
    String? lastSeen,
  }) = _ChatUser;

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);
}
