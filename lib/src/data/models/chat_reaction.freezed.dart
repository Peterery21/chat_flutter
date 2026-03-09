// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_reaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatReaction _$ChatReactionFromJson(Map<String, dynamic> json) {
  return _ChatReaction.fromJson(json);
}

/// @nodoc
mixin _$ChatReaction {
  String get emoji => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  List<int> get userIds => throw _privateConstructorUsedError;

  /// Serializes this ChatReaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatReactionCopyWith<ChatReaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatReactionCopyWith<$Res> {
  factory $ChatReactionCopyWith(
    ChatReaction value,
    $Res Function(ChatReaction) then,
  ) = _$ChatReactionCopyWithImpl<$Res, ChatReaction>;
  @useResult
  $Res call({String emoji, int count, List<int> userIds});
}

/// @nodoc
class _$ChatReactionCopyWithImpl<$Res, $Val extends ChatReaction>
    implements $ChatReactionCopyWith<$Res> {
  _$ChatReactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emoji = null,
    Object? count = null,
    Object? userIds = null,
  }) {
    return _then(
      _value.copyWith(
            emoji: null == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            userIds: null == userIds
                ? _value.userIds
                : userIds // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatReactionImplCopyWith<$Res>
    implements $ChatReactionCopyWith<$Res> {
  factory _$$ChatReactionImplCopyWith(
    _$ChatReactionImpl value,
    $Res Function(_$ChatReactionImpl) then,
  ) = __$$ChatReactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String emoji, int count, List<int> userIds});
}

/// @nodoc
class __$$ChatReactionImplCopyWithImpl<$Res>
    extends _$ChatReactionCopyWithImpl<$Res, _$ChatReactionImpl>
    implements _$$ChatReactionImplCopyWith<$Res> {
  __$$ChatReactionImplCopyWithImpl(
    _$ChatReactionImpl _value,
    $Res Function(_$ChatReactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emoji = null,
    Object? count = null,
    Object? userIds = null,
  }) {
    return _then(
      _$ChatReactionImpl(
        emoji: null == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        userIds: null == userIds
            ? _value._userIds
            : userIds // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatReactionImpl implements _ChatReaction {
  const _$ChatReactionImpl({
    required this.emoji,
    required this.count,
    final List<int> userIds = const [],
  }) : _userIds = userIds;

  factory _$ChatReactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatReactionImplFromJson(json);

  @override
  final String emoji;
  @override
  final int count;
  final List<int> _userIds;
  @override
  @JsonKey()
  List<int> get userIds {
    if (_userIds is EqualUnmodifiableListView) return _userIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userIds);
  }

  @override
  String toString() {
    return 'ChatReaction(emoji: $emoji, count: $count, userIds: $userIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatReactionImpl &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._userIds, _userIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    emoji,
    count,
    const DeepCollectionEquality().hash(_userIds),
  );

  /// Create a copy of ChatReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatReactionImplCopyWith<_$ChatReactionImpl> get copyWith =>
      __$$ChatReactionImplCopyWithImpl<_$ChatReactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatReactionImplToJson(this);
  }
}

abstract class _ChatReaction implements ChatReaction {
  const factory _ChatReaction({
    required final String emoji,
    required final int count,
    final List<int> userIds,
  }) = _$ChatReactionImpl;

  factory _ChatReaction.fromJson(Map<String, dynamic> json) =
      _$ChatReactionImpl.fromJson;

  @override
  String get emoji;
  @override
  int get count;
  @override
  List<int> get userIds;

  /// Create a copy of ChatReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatReactionImplCopyWith<_$ChatReactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
