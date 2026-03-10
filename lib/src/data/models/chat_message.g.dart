// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: (json['id'] as num).toInt(),
      chatRoomId: (json['chatRoomId'] as num).toInt(),
      senderId: (json['chatUserId'] as num).toInt(),
      senderName: json['sender'] as String?,
      senderAvatar: json['userPhoto'] as String?,
      content: json['content'] as String,
      createdAt: json['time'] as String,
      updatedAt: json['updatedAt'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String?,
      replyToMessageId: (json['replyToMessageId'] as num?)?.toInt(),
      replyToContent: json['replyToContent'] as String?,
      replyToSenderName: json['replyToSenderName'] as String?,
      sondageId: (json['sondageId'] as num?)?.toInt(),
      deleted: json['deleted'] as bool? ?? false,
      edited: json['edited'] as bool? ?? false,
      read: json['read'] as bool? ?? false,
      mentionedUserIds:
          (json['mentionedUserIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      reactions:
          (json['reactions'] as List<dynamic>?)
              ?.map((e) => ChatReaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      fromBot: json['fromBot'] as bool? ?? false,
      botName: json['botName'] as String?,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatRoomId': instance.chatRoomId,
      'chatUserId': instance.senderId,
      'sender': instance.senderName,
      'userPhoto': instance.senderAvatar,
      'content': instance.content,
      'time': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'mediaUrl': instance.mediaUrl,
      'mediaType': instance.mediaType,
      'replyToMessageId': instance.replyToMessageId,
      'replyToContent': instance.replyToContent,
      'replyToSenderName': instance.replyToSenderName,
      'sondageId': instance.sondageId,
      'deleted': instance.deleted,
      'edited': instance.edited,
      'read': instance.read,
      'mentionedUserIds': instance.mentionedUserIds,
      'reactions': instance.reactions,
      'fromBot': instance.fromBot,
      'botName': instance.botName,
    };
