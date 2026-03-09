// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatReactionImpl _$$ChatReactionImplFromJson(Map<String, dynamic> json) =>
    _$ChatReactionImpl(
      emoji: json['emoji'] as String,
      count: (json['count'] as num).toInt(),
      userIds:
          (json['userIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ChatReactionImplToJson(_$ChatReactionImpl instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'count': instance.count,
      'userIds': instance.userIds,
    };
