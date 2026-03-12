// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_bot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatBotImpl _$$ChatBotImplFromJson(Map<String, dynamic> json) =>
    _$ChatBotImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      active: json['active'] as bool? ?? false,
      topicRestricted: json['topicRestricted'] as bool? ?? false,
      topicDescription: json['topicDescription'] as String?,
      knowledgeBaseId: (json['knowledgeBaseId'] as num?)?.toInt(),
      toolNames:
          (json['toolNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isPrimary: json['isPrimary'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatBotImplToJson(_$ChatBotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'avatar': instance.avatar,
      'active': instance.active,
      'topicRestricted': instance.topicRestricted,
      'topicDescription': instance.topicDescription,
      'knowledgeBaseId': instance.knowledgeBaseId,
      'toolNames': instance.toolNames,
      'isPrimary': instance.isPrimary,
    };
