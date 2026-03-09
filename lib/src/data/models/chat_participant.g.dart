// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatParticipantImpl _$$ChatParticipantImplFromJson(
  Map<String, dynamic> json,
) => _$ChatParticipantImpl(
  id: (json['id'] as num).toInt(),
  chatUserId: (json['chatUserId'] as num).toInt(),
  chatRoomId: (json['chatRoomId'] as num).toInt(),
  username: json['username'] as String,
  avatar: json['avatar'] as String?,
  role: json['role'] as String? ?? 'MEMBER',
);

Map<String, dynamic> _$$ChatParticipantImplToJson(
  _$ChatParticipantImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'chatUserId': instance.chatUserId,
  'chatRoomId': instance.chatRoomId,
  'username': instance.username,
  'avatar': instance.avatar,
  'role': instance.role,
};
