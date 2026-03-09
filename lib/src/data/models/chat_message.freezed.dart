// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  int get id => throw _privateConstructorUsedError;
  int get chatRoomId => throw _privateConstructorUsedError;
  int get senderId => throw _privateConstructorUsedError;
  String? get senderName => throw _privateConstructorUsedError;
  String? get senderAvatar => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  String? get mediaType => throw _privateConstructorUsedError;
  int? get replyToMessageId => throw _privateConstructorUsedError;
  String? get replyToContent => throw _privateConstructorUsedError;
  String? get replyToSenderName => throw _privateConstructorUsedError;
  int? get sondageId => throw _privateConstructorUsedError;
  bool get deleted => throw _privateConstructorUsedError;
  bool get edited => throw _privateConstructorUsedError;
  bool get read => throw _privateConstructorUsedError;
  List<String> get mentions => throw _privateConstructorUsedError;
  List<ChatReaction> get reactions => throw _privateConstructorUsedError;
  bool get fromBot => throw _privateConstructorUsedError;
  String? get botName => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
    ChatMessage value,
    $Res Function(ChatMessage) then,
  ) = _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({
    int id,
    int chatRoomId,
    int senderId,
    String? senderName,
    String? senderAvatar,
    String content,
    String createdAt,
    String? updatedAt,
    String? mediaUrl,
    String? mediaType,
    int? replyToMessageId,
    String? replyToContent,
    String? replyToSenderName,
    int? sondageId,
    bool deleted,
    bool edited,
    bool read,
    List<String> mentions,
    List<ChatReaction> reactions,
    bool fromBot,
    String? botName,
  });
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatRoomId = null,
    Object? senderId = null,
    Object? senderName = freezed,
    Object? senderAvatar = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? mediaUrl = freezed,
    Object? mediaType = freezed,
    Object? replyToMessageId = freezed,
    Object? replyToContent = freezed,
    Object? replyToSenderName = freezed,
    Object? sondageId = freezed,
    Object? deleted = null,
    Object? edited = null,
    Object? read = null,
    Object? mentions = null,
    Object? reactions = null,
    Object? fromBot = null,
    Object? botName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            chatRoomId: null == chatRoomId
                ? _value.chatRoomId
                : chatRoomId // ignore: cast_nullable_to_non_nullable
                      as int,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as int,
            senderName: freezed == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String?,
            senderAvatar: freezed == senderAvatar
                ? _value.senderAvatar
                : senderAvatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            mediaUrl: freezed == mediaUrl
                ? _value.mediaUrl
                : mediaUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            mediaType: freezed == mediaType
                ? _value.mediaType
                : mediaType // ignore: cast_nullable_to_non_nullable
                      as String?,
            replyToMessageId: freezed == replyToMessageId
                ? _value.replyToMessageId
                : replyToMessageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            replyToContent: freezed == replyToContent
                ? _value.replyToContent
                : replyToContent // ignore: cast_nullable_to_non_nullable
                      as String?,
            replyToSenderName: freezed == replyToSenderName
                ? _value.replyToSenderName
                : replyToSenderName // ignore: cast_nullable_to_non_nullable
                      as String?,
            sondageId: freezed == sondageId
                ? _value.sondageId
                : sondageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            deleted: null == deleted
                ? _value.deleted
                : deleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            edited: null == edited
                ? _value.edited
                : edited // ignore: cast_nullable_to_non_nullable
                      as bool,
            read: null == read
                ? _value.read
                : read // ignore: cast_nullable_to_non_nullable
                      as bool,
            mentions: null == mentions
                ? _value.mentions
                : mentions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            reactions: null == reactions
                ? _value.reactions
                : reactions // ignore: cast_nullable_to_non_nullable
                      as List<ChatReaction>,
            fromBot: null == fromBot
                ? _value.fromBot
                : fromBot // ignore: cast_nullable_to_non_nullable
                      as bool,
            botName: freezed == botName
                ? _value.botName
                : botName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
    _$ChatMessageImpl value,
    $Res Function(_$ChatMessageImpl) then,
  ) = __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int chatRoomId,
    int senderId,
    String? senderName,
    String? senderAvatar,
    String content,
    String createdAt,
    String? updatedAt,
    String? mediaUrl,
    String? mediaType,
    int? replyToMessageId,
    String? replyToContent,
    String? replyToSenderName,
    int? sondageId,
    bool deleted,
    bool edited,
    bool read,
    List<String> mentions,
    List<ChatReaction> reactions,
    bool fromBot,
    String? botName,
  });
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
    _$ChatMessageImpl _value,
    $Res Function(_$ChatMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatRoomId = null,
    Object? senderId = null,
    Object? senderName = freezed,
    Object? senderAvatar = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? mediaUrl = freezed,
    Object? mediaType = freezed,
    Object? replyToMessageId = freezed,
    Object? replyToContent = freezed,
    Object? replyToSenderName = freezed,
    Object? sondageId = freezed,
    Object? deleted = null,
    Object? edited = null,
    Object? read = null,
    Object? mentions = null,
    Object? reactions = null,
    Object? fromBot = null,
    Object? botName = freezed,
  }) {
    return _then(
      _$ChatMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        chatRoomId: null == chatRoomId
            ? _value.chatRoomId
            : chatRoomId // ignore: cast_nullable_to_non_nullable
                  as int,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as int,
        senderName: freezed == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String?,
        senderAvatar: freezed == senderAvatar
            ? _value.senderAvatar
            : senderAvatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        mediaUrl: freezed == mediaUrl
            ? _value.mediaUrl
            : mediaUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        mediaType: freezed == mediaType
            ? _value.mediaType
            : mediaType // ignore: cast_nullable_to_non_nullable
                  as String?,
        replyToMessageId: freezed == replyToMessageId
            ? _value.replyToMessageId
            : replyToMessageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        replyToContent: freezed == replyToContent
            ? _value.replyToContent
            : replyToContent // ignore: cast_nullable_to_non_nullable
                  as String?,
        replyToSenderName: freezed == replyToSenderName
            ? _value.replyToSenderName
            : replyToSenderName // ignore: cast_nullable_to_non_nullable
                  as String?,
        sondageId: freezed == sondageId
            ? _value.sondageId
            : sondageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        deleted: null == deleted
            ? _value.deleted
            : deleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        edited: null == edited
            ? _value.edited
            : edited // ignore: cast_nullable_to_non_nullable
                  as bool,
        read: null == read
            ? _value.read
            : read // ignore: cast_nullable_to_non_nullable
                  as bool,
        mentions: null == mentions
            ? _value._mentions
            : mentions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        reactions: null == reactions
            ? _value._reactions
            : reactions // ignore: cast_nullable_to_non_nullable
                  as List<ChatReaction>,
        fromBot: null == fromBot
            ? _value.fromBot
            : fromBot // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.mediaUrl,
    this.mediaType,
    this.replyToMessageId,
    this.replyToContent,
    this.replyToSenderName,
    this.sondageId,
    this.deleted = false,
    this.edited = false,
    this.read = false,
    final List<String> mentions = const [],
    final List<ChatReaction> reactions = const [],
    this.fromBot = false,
    this.botName,
  }) : _mentions = mentions,
       _reactions = reactions;

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final int id;
  @override
  final int chatRoomId;
  @override
  final int senderId;
  @override
  final String? senderName;
  @override
  final String? senderAvatar;
  @override
  final String content;
  @override
  final String createdAt;
  @override
  final String? updatedAt;
  @override
  final String? mediaUrl;
  @override
  final String? mediaType;
  @override
  final int? replyToMessageId;
  @override
  final String? replyToContent;
  @override
  final String? replyToSenderName;
  @override
  final int? sondageId;
  @override
  @JsonKey()
  final bool deleted;
  @override
  @JsonKey()
  final bool edited;
  @override
  @JsonKey()
  final bool read;
  final List<String> _mentions;
  @override
  @JsonKey()
  List<String> get mentions {
    if (_mentions is EqualUnmodifiableListView) return _mentions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentions);
  }

  final List<ChatReaction> _reactions;
  @override
  @JsonKey()
  List<ChatReaction> get reactions {
    if (_reactions is EqualUnmodifiableListView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactions);
  }

  @override
  @JsonKey()
  final bool fromBot;
  @override
  final String? botName;

  @override
  String toString() {
    return 'ChatMessage(id: $id, chatRoomId: $chatRoomId, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, mediaUrl: $mediaUrl, mediaType: $mediaType, replyToMessageId: $replyToMessageId, replyToContent: $replyToContent, replyToSenderName: $replyToSenderName, sondageId: $sondageId, deleted: $deleted, edited: $edited, read: $read, mentions: $mentions, reactions: $reactions, fromBot: $fromBot, botName: $botName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatRoomId, chatRoomId) ||
                other.chatRoomId == chatRoomId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderAvatar, senderAvatar) ||
                other.senderAvatar == senderAvatar) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.replyToMessageId, replyToMessageId) ||
                other.replyToMessageId == replyToMessageId) &&
            (identical(other.replyToContent, replyToContent) ||
                other.replyToContent == replyToContent) &&
            (identical(other.replyToSenderName, replyToSenderName) ||
                other.replyToSenderName == replyToSenderName) &&
            (identical(other.sondageId, sondageId) ||
                other.sondageId == sondageId) &&
            (identical(other.deleted, deleted) || other.deleted == deleted) &&
            (identical(other.edited, edited) || other.edited == edited) &&
            (identical(other.read, read) || other.read == read) &&
            const DeepCollectionEquality().equals(other._mentions, _mentions) &&
            const DeepCollectionEquality().equals(
              other._reactions,
              _reactions,
            ) &&
            (identical(other.fromBot, fromBot) || other.fromBot == fromBot) &&
            (identical(other.botName, botName) || other.botName == botName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    chatRoomId,
    senderId,
    senderName,
    senderAvatar,
    content,
    createdAt,
    updatedAt,
    mediaUrl,
    mediaType,
    replyToMessageId,
    replyToContent,
    replyToSenderName,
    sondageId,
    deleted,
    edited,
    read,
    const DeepCollectionEquality().hash(_mentions),
    const DeepCollectionEquality().hash(_reactions),
    fromBot,
    botName,
  ]);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(this);
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage({
    required final int id,
    required final int chatRoomId,
    required final int senderId,
    final String? senderName,
    final String? senderAvatar,
    required final String content,
    required final String createdAt,
    final String? updatedAt,
    final String? mediaUrl,
    final String? mediaType,
    final int? replyToMessageId,
    final String? replyToContent,
    final String? replyToSenderName,
    final int? sondageId,
    final bool deleted,
    final bool edited,
    final bool read,
    final List<String> mentions,
    final List<ChatReaction> reactions,
    final bool fromBot,
    final String? botName,
  }) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  int get id;
  @override
  int get chatRoomId;
  @override
  int get senderId;
  @override
  String? get senderName;
  @override
  String? get senderAvatar;
  @override
  String get content;
  @override
  String get createdAt;
  @override
  String? get updatedAt;
  @override
  String? get mediaUrl;
  @override
  String? get mediaType;
  @override
  int? get replyToMessageId;
  @override
  String? get replyToContent;
  @override
  String? get replyToSenderName;
  @override
  int? get sondageId;
  @override
  bool get deleted;
  @override
  bool get edited;
  @override
  bool get read;
  @override
  List<String> get mentions;
  @override
  List<ChatReaction> get reactions;
  @override
  bool get fromBot;
  @override
  String? get botName;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
