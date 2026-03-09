// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatParticipant _$ChatParticipantFromJson(Map<String, dynamic> json) {
  return _ChatParticipant.fromJson(json);
}

/// @nodoc
mixin _$ChatParticipant {
  int get id => throw _privateConstructorUsedError;
  int get chatUserId => throw _privateConstructorUsedError;
  int get chatRoomId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this ChatParticipant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatParticipantCopyWith<ChatParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatParticipantCopyWith<$Res> {
  factory $ChatParticipantCopyWith(
    ChatParticipant value,
    $Res Function(ChatParticipant) then,
  ) = _$ChatParticipantCopyWithImpl<$Res, ChatParticipant>;
  @useResult
  $Res call({
    int id,
    int chatUserId,
    int chatRoomId,
    String username,
    String? avatar,
    String role,
  });
}

/// @nodoc
class _$ChatParticipantCopyWithImpl<$Res, $Val extends ChatParticipant>
    implements $ChatParticipantCopyWith<$Res> {
  _$ChatParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatUserId = null,
    Object? chatRoomId = null,
    Object? username = null,
    Object? avatar = freezed,
    Object? role = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            chatUserId: null == chatUserId
                ? _value.chatUserId
                : chatUserId // ignore: cast_nullable_to_non_nullable
                      as int,
            chatRoomId: null == chatRoomId
                ? _value.chatRoomId
                : chatRoomId // ignore: cast_nullable_to_non_nullable
                      as int,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatParticipantImplCopyWith<$Res>
    implements $ChatParticipantCopyWith<$Res> {
  factory _$$ChatParticipantImplCopyWith(
    _$ChatParticipantImpl value,
    $Res Function(_$ChatParticipantImpl) then,
  ) = __$$ChatParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int chatUserId,
    int chatRoomId,
    String username,
    String? avatar,
    String role,
  });
}

/// @nodoc
class __$$ChatParticipantImplCopyWithImpl<$Res>
    extends _$ChatParticipantCopyWithImpl<$Res, _$ChatParticipantImpl>
    implements _$$ChatParticipantImplCopyWith<$Res> {
  __$$ChatParticipantImplCopyWithImpl(
    _$ChatParticipantImpl _value,
    $Res Function(_$ChatParticipantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatUserId = null,
    Object? chatRoomId = null,
    Object? username = null,
    Object? avatar = freezed,
    Object? role = null,
  }) {
    return _then(
      _$ChatParticipantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        chatUserId: null == chatUserId
            ? _value.chatUserId
            : chatUserId // ignore: cast_nullable_to_non_nullable
                  as int,
        chatRoomId: null == chatRoomId
            ? _value.chatRoomId
            : chatRoomId // ignore: cast_nullable_to_non_nullable
                  as int,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatParticipantImpl implements _ChatParticipant {
  const _$ChatParticipantImpl({
    required this.id,
    required this.chatUserId,
    required this.chatRoomId,
    required this.username,
    this.avatar,
    this.role = 'MEMBER',
  });

  factory _$ChatParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatParticipantImplFromJson(json);

  @override
  final int id;
  @override
  final int chatUserId;
  @override
  final int chatRoomId;
  @override
  final String username;
  @override
  final String? avatar;
  @override
  @JsonKey()
  final String role;

  @override
  String toString() {
    return 'ChatParticipant(id: $id, chatUserId: $chatUserId, chatRoomId: $chatRoomId, username: $username, avatar: $avatar, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatParticipantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatUserId, chatUserId) ||
                other.chatUserId == chatUserId) &&
            (identical(other.chatRoomId, chatRoomId) ||
                other.chatRoomId == chatRoomId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    chatUserId,
    chatRoomId,
    username,
    avatar,
    role,
  );

  /// Create a copy of ChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatParticipantImplCopyWith<_$ChatParticipantImpl> get copyWith =>
      __$$ChatParticipantImplCopyWithImpl<_$ChatParticipantImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatParticipantImplToJson(this);
  }
}

abstract class _ChatParticipant implements ChatParticipant {
  const factory _ChatParticipant({
    required final int id,
    required final int chatUserId,
    required final int chatRoomId,
    required final String username,
    final String? avatar,
    final String role,
  }) = _$ChatParticipantImpl;

  factory _ChatParticipant.fromJson(Map<String, dynamic> json) =
      _$ChatParticipantImpl.fromJson;

  @override
  int get id;
  @override
  int get chatUserId;
  @override
  int get chatRoomId;
  @override
  String get username;
  @override
  String? get avatar;
  @override
  String get role;

  /// Create a copy of ChatParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatParticipantImplCopyWith<_$ChatParticipantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
