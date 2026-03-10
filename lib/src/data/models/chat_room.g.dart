// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatRoomImpl _$$ChatRoomImplFromJson(Map<String, dynamic> json) =>
    _$ChatRoomImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isGroup: json['isGroup'] as bool? ?? false,
      groupId: (json['groupId'] as num?)?.toInt(),
      avatar: json['photo'] as String?,
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map((e) => ChatParticipant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pinnedMessageId: (json['pinnedMessageId'] as num?)?.toInt(),
      pinnedMessageContent: json['pinnedMessageContent'] as String?,
      archived: json['archived'] as bool?,
      botId: (json['botId'] as num?)?.toInt(),
      botName: json['botName'] as String?,
    );

Map<String, dynamic> _$$ChatRoomImplToJson(_$ChatRoomImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isGroup': instance.isGroup,
      'groupId': instance.groupId,
      'photo': instance.avatar,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'participants': instance.participants,
      'pinnedMessageId': instance.pinnedMessageId,
      'pinnedMessageContent': instance.pinnedMessageContent,
      'archived': instance.archived,
      'botId': instance.botId,
      'botName': instance.botName,
    };
