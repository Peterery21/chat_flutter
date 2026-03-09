import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_reaction.freezed.dart';
part 'chat_reaction.g.dart';

@freezed
class ChatReaction with _$ChatReaction {
  const factory ChatReaction({
    required String emoji,
    required int count,
    @Default([]) List<int> userIds,
  }) = _ChatReaction;

  factory ChatReaction.fromJson(Map<String, dynamic> json) =>
      _$ChatReactionFromJson(json);
}
