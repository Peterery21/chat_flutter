// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_bot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatBot _$ChatBotFromJson(Map<String, dynamic> json) {
  return _ChatBot.fromJson(json);
}

/// @nodoc
mixin _$ChatBot {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  bool get topicRestricted => throw _privateConstructorUsedError;
  String? get topicDescription => throw _privateConstructorUsedError;
  int? get knowledgeBaseId => throw _privateConstructorUsedError;
  List<String> get toolNames => throw _privateConstructorUsedError;

  /// Serializes this ChatBot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatBot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatBotCopyWith<ChatBot> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatBotCopyWith<$Res> {
  factory $ChatBotCopyWith(ChatBot value, $Res Function(ChatBot) then) =
      _$ChatBotCopyWithImpl<$Res, ChatBot>;
  @useResult
  $Res call({
    int id,
    String name,
    String? description,
    String? avatar,
    bool active,
    bool topicRestricted,
    String? topicDescription,
    int? knowledgeBaseId,
    List<String> toolNames,
  });
}

/// @nodoc
class _$ChatBotCopyWithImpl<$Res, $Val extends ChatBot>
    implements $ChatBotCopyWith<$Res> {
  _$ChatBotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatBot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? avatar = freezed,
    Object? active = null,
    Object? topicRestricted = null,
    Object? topicDescription = freezed,
    Object? knowledgeBaseId = freezed,
    Object? toolNames = null,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            active: null == active
                ? _value.active
                : active // ignore: cast_nullable_to_non_nullable
                      as bool,
            topicRestricted: null == topicRestricted
                ? _value.topicRestricted
                : topicRestricted // ignore: cast_nullable_to_non_nullable
                      as bool,
            topicDescription: freezed == topicDescription
                ? _value.topicDescription
                : topicDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            knowledgeBaseId: freezed == knowledgeBaseId
                ? _value.knowledgeBaseId
                : knowledgeBaseId // ignore: cast_nullable_to_non_nullable
                      as int?,
            toolNames: null == toolNames
                ? _value.toolNames
                : toolNames // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatBotImplCopyWith<$Res> implements $ChatBotCopyWith<$Res> {
  factory _$$ChatBotImplCopyWith(
    _$ChatBotImpl value,
    $Res Function(_$ChatBotImpl) then,
  ) = __$$ChatBotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? description,
    String? avatar,
    bool active,
    bool topicRestricted,
    String? topicDescription,
    int? knowledgeBaseId,
    List<String> toolNames,
  });
}

/// @nodoc
class __$$ChatBotImplCopyWithImpl<$Res>
    extends _$ChatBotCopyWithImpl<$Res, _$ChatBotImpl>
    implements _$$ChatBotImplCopyWith<$Res> {
  __$$ChatBotImplCopyWithImpl(
    _$ChatBotImpl _value,
    $Res Function(_$ChatBotImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatBot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? avatar = freezed,
    Object? active = null,
    Object? topicRestricted = null,
    Object? topicDescription = freezed,
    Object? knowledgeBaseId = freezed,
    Object? toolNames = null,
  }) {
    return _then(
      _$ChatBotImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        active: null == active
            ? _value.active
            : active // ignore: cast_nullable_to_non_nullable
                  as bool,
        topicRestricted: null == topicRestricted
            ? _value.topicRestricted
            : topicRestricted // ignore: cast_nullable_to_non_nullable
                  as bool,
        topicDescription: freezed == topicDescription
            ? _value.topicDescription
            : topicDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        knowledgeBaseId: freezed == knowledgeBaseId
            ? _value.knowledgeBaseId
            : knowledgeBaseId // ignore: cast_nullable_to_non_nullable
                  as int?,
        toolNames: null == toolNames
            ? _value._toolNames
            : toolNames // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatBotImpl implements _ChatBot {
  const _$ChatBotImpl({
    required this.id,
    required this.name,
    this.description,
    this.avatar,
    this.active = false,
    this.topicRestricted = false,
    this.topicDescription,
    this.knowledgeBaseId,
    final List<String> toolNames = const [],
  }) : _toolNames = toolNames;

  factory _$ChatBotImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatBotImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? avatar;
  @override
  @JsonKey()
  final bool active;
  @override
  @JsonKey()
  final bool topicRestricted;
  @override
  final String? topicDescription;
  @override
  final int? knowledgeBaseId;
  final List<String> _toolNames;
  @override
  @JsonKey()
  List<String> get toolNames {
    if (_toolNames is EqualUnmodifiableListView) return _toolNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_toolNames);
  }

  @override
  String toString() {
    return 'ChatBot(id: $id, name: $name, description: $description, avatar: $avatar, active: $active, topicRestricted: $topicRestricted, topicDescription: $topicDescription, knowledgeBaseId: $knowledgeBaseId, toolNames: $toolNames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatBotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.topicRestricted, topicRestricted) ||
                other.topicRestricted == topicRestricted) &&
            (identical(other.topicDescription, topicDescription) ||
                other.topicDescription == topicDescription) &&
            (identical(other.knowledgeBaseId, knowledgeBaseId) ||
                other.knowledgeBaseId == knowledgeBaseId) &&
            const DeepCollectionEquality().equals(
              other._toolNames,
              _toolNames,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    avatar,
    active,
    topicRestricted,
    topicDescription,
    knowledgeBaseId,
    const DeepCollectionEquality().hash(_toolNames),
  );

  /// Create a copy of ChatBot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatBotImplCopyWith<_$ChatBotImpl> get copyWith =>
      __$$ChatBotImplCopyWithImpl<_$ChatBotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatBotImplToJson(this);
  }
}

abstract class _ChatBot implements ChatBot {
  const factory _ChatBot({
    required final int id,
    required final String name,
    final String? description,
    final String? avatar,
    final bool active,
    final bool topicRestricted,
    final String? topicDescription,
    final int? knowledgeBaseId,
    final List<String> toolNames,
  }) = _$ChatBotImpl;

  factory _ChatBot.fromJson(Map<String, dynamic> json) = _$ChatBotImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get avatar;
  @override
  bool get active;
  @override
  bool get topicRestricted;
  @override
  String? get topicDescription;
  @override
  int? get knowledgeBaseId;
  @override
  List<String> get toolNames;

  /// Create a copy of ChatBot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatBotImplCopyWith<_$ChatBotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
