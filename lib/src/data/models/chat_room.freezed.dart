// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) {
  return _ChatRoom.fromJson(json);
}

/// @nodoc
mixin _$ChatRoom {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isGroup => throw _privateConstructorUsedError;
  int? get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo')
  String? get avatar => throw _privateConstructorUsedError;
  ChatMessage? get lastMessage => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  List<ChatParticipant> get participants => throw _privateConstructorUsedError;
  int? get pinnedMessageId => throw _privateConstructorUsedError;
  String? get pinnedMessageContent => throw _privateConstructorUsedError;
  bool? get archived => throw _privateConstructorUsedError;
  int? get botId => throw _privateConstructorUsedError;
  String? get botName => throw _privateConstructorUsedError;

  /// Serializes this ChatRoom to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatRoomCopyWith<ChatRoom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomCopyWith<$Res> {
  factory $ChatRoomCopyWith(ChatRoom value, $Res Function(ChatRoom) then) =
      _$ChatRoomCopyWithImpl<$Res, ChatRoom>;
  @useResult
  $Res call({
    int id,
    String name,
    bool isGroup,
    int? groupId,
    @JsonKey(name: 'photo') String? avatar,
    ChatMessage? lastMessage,
    int unreadCount,
    List<ChatParticipant> participants,
    int? pinnedMessageId,
    String? pinnedMessageContent,
    bool? archived,
    int? botId,
    String? botName,
  });

  $ChatMessageCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class _$ChatRoomCopyWithImpl<$Res, $Val extends ChatRoom>
    implements $ChatRoomCopyWith<$Res> {
  _$ChatRoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isGroup = null,
    Object? groupId = freezed,
    Object? avatar = freezed,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? participants = null,
    Object? pinnedMessageId = freezed,
    Object? pinnedMessageContent = freezed,
    Object? archived = freezed,
    Object? botId = freezed,
    Object? botName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            isGroup: null == isGroup
                ? _value.isGroup
                : isGroup // ignore: cast_nullable_to_non_nullable
                      as bool,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as int?,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastMessage: freezed == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                      as ChatMessage?,
            unreadCount: null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                      as int,
            participants: null == participants
                ? _value.participants
                : participants // ignore: cast_nullable_to_non_nullable
                      as List<ChatParticipant>,
            pinnedMessageId: freezed == pinnedMessageId
                ? _value.pinnedMessageId
                : pinnedMessageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            pinnedMessageContent: freezed == pinnedMessageContent
                ? _value.pinnedMessageContent
                : pinnedMessageContent // ignore: cast_nullable_to_non_nullable
                      as String?,
            archived: freezed == archived
                ? _value.archived
                : archived // ignore: cast_nullable_to_non_nullable
                      as bool?,
            botId: freezed == botId
                ? _value.botId
                : botId // ignore: cast_nullable_to_non_nullable
                      as int?,
            botName: freezed == botName
                ? _value.botName
                : botName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res>? get lastMessage {
    if (_value.lastMessage == null) {
      return null;
    }

    return $ChatMessageCopyWith<$Res>(_value.lastMessage!, (value) {
      return _then(_value.copyWith(lastMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatRoomImplCopyWith<$Res>
    implements $ChatRoomCopyWith<$Res> {
  factory _$$ChatRoomImplCopyWith(
    _$ChatRoomImpl value,
    $Res Function(_$ChatRoomImpl) then,
  ) = __$$ChatRoomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    bool isGroup,
    int? groupId,
    @JsonKey(name: 'photo') String? avatar,
    ChatMessage? lastMessage,
    int unreadCount,
    List<ChatParticipant> participants,
    int? pinnedMessageId,
    String? pinnedMessageContent,
    bool? archived,
    int? botId,
    String? botName,
  });

  @override
  $ChatMessageCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class __$$ChatRoomImplCopyWithImpl<$Res>
    extends _$ChatRoomCopyWithImpl<$Res, _$ChatRoomImpl>
    implements _$$ChatRoomImplCopyWith<$Res> {
  __$$ChatRoomImplCopyWithImpl(
    _$ChatRoomImpl _value,
    $Res Function(_$ChatRoomImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isGroup = null,
    Object? groupId = freezed,
    Object? avatar = freezed,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? participants = null,
    Object? pinnedMessageId = freezed,
    Object? pinnedMessageContent = freezed,
    Object? archived = freezed,
    Object? botId = freezed,
    Object? botName = freezed,
  }) {
    return _then(
      _$ChatRoomImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        isGroup: null == isGroup
            ? _value.isGroup
            : isGroup // ignore: cast_nullable_to_non_nullable
                  as bool,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as int?,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastMessage: freezed == lastMessage
            ? _value.lastMessage
            : lastMessage // ignore: cast_nullable_to_non_nullable
                  as ChatMessage?,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        participants: null == participants
            ? _value._participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<ChatParticipant>,
        pinnedMessageId: freezed == pinnedMessageId
            ? _value.pinnedMessageId
            : pinnedMessageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        pinnedMessageContent: freezed == pinnedMessageContent
            ? _value.pinnedMessageContent
            : pinnedMessageContent // ignore: cast_nullable_to_non_nullable
                  as String?,
        archived: freezed == archived
            ? _value.archived
            : archived // ignore: cast_nullable_to_non_nullable
                  as bool?,
        botId: freezed == botId
            ? _value.botId
            : botId // ignore: cast_nullable_to_non_nullable
                  as int?,
        botName: freezed == botName
            ? _value.botName
            : botName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatRoomImpl implements _ChatRoom {
  const _$ChatRoomImpl({
    required this.id,
    required this.name,
    this.isGroup = false,
    this.groupId,
    @JsonKey(name: 'photo') this.avatar,
    this.lastMessage,
    this.unreadCount = 0,
    final List<ChatParticipant> participants = const [],
    this.pinnedMessageId,
    this.pinnedMessageContent,
    this.archived,
    this.botId,
    this.botName,
  }) : _participants = participants;

  factory _$ChatRoomImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatRoomImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey()
  final bool isGroup;
  @override
  final int? groupId;
  @override
  @JsonKey(name: 'photo')
  final String? avatar;
  @override
  final ChatMessage? lastMessage;
  @override
  @JsonKey()
  final int unreadCount;
  final List<ChatParticipant> _participants;
  @override
  @JsonKey()
  List<ChatParticipant> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final int? pinnedMessageId;
  @override
  final String? pinnedMessageContent;
  @override
  final bool? archived;
  @override
  final int? botId;
  @override
  final String? botName;

  @override
  String toString() {
    return 'ChatRoom(id: $id, name: $name, isGroup: $isGroup, groupId: $groupId, avatar: $avatar, lastMessage: $lastMessage, unreadCount: $unreadCount, participants: $participants, pinnedMessageId: $pinnedMessageId, pinnedMessageContent: $pinnedMessageContent, archived: $archived, botId: $botId, botName: $botName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatRoomImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isGroup, isGroup) || other.isGroup == isGroup) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            const DeepCollectionEquality().equals(
              other._participants,
              _participants,
            ) &&
            (identical(other.pinnedMessageId, pinnedMessageId) ||
                other.pinnedMessageId == pinnedMessageId) &&
            (identical(other.pinnedMessageContent, pinnedMessageContent) ||
                other.pinnedMessageContent == pinnedMessageContent) &&
            (identical(other.archived, archived) ||
                other.archived == archived) &&
            (identical(other.botId, botId) || other.botId == botId) &&
            (identical(other.botName, botName) || other.botName == botName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    isGroup,
    groupId,
    avatar,
    lastMessage,
    unreadCount,
    const DeepCollectionEquality().hash(_participants),
    pinnedMessageId,
    pinnedMessageContent,
    archived,
    botId,
    botName,
  );

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatRoomImplCopyWith<_$ChatRoomImpl> get copyWith =>
      __$$ChatRoomImplCopyWithImpl<_$ChatRoomImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatRoomImplToJson(this);
  }
}

abstract class _ChatRoom implements ChatRoom {
  const factory _ChatRoom({
    required final int id,
    required final String name,
    final bool isGroup,
    final int? groupId,
    @JsonKey(name: 'photo') final String? avatar,
    final ChatMessage? lastMessage,
    final int unreadCount,
    final List<ChatParticipant> participants,
    final int? pinnedMessageId,
    final String? pinnedMessageContent,
    final bool? archived,
    final int? botId,
    final String? botName,
  }) = _$ChatRoomImpl;

  factory _ChatRoom.fromJson(Map<String, dynamic> json) =
      _$ChatRoomImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  bool get isGroup;
  @override
  int? get groupId;
  @override
  @JsonKey(name: 'photo')
  String? get avatar;
  @override
  ChatMessage? get lastMessage;
  @override
  int get unreadCount;
  @override
  List<ChatParticipant> get participants;
  @override
  int? get pinnedMessageId;
  @override
  String? get pinnedMessageContent;
  @override
  bool? get archived;
  @override
  int? get botId;
  @override
  String? get botName;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatRoomImplCopyWith<_$ChatRoomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
