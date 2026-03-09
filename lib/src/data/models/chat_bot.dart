import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_bot.freezed.dart';
part 'chat_bot.g.dart';

@freezed
class ChatBot with _$ChatBot {
  const factory ChatBot({
    required int id,
    required String name,
    String? description,
    String? avatar,
    @Default(false) bool active,
    @Default(false) bool topicRestricted,
    String? topicDescription,
    int? knowledgeBaseId,
    @Default([]) List<String> toolNames,
  }) = _ChatBot;

  factory ChatBot.fromJson(Map<String, dynamic> json) =>
      _$ChatBotFromJson(json);
}
