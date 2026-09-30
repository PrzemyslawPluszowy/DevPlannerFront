// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_presence_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpsertChatUserStatusPayload {

 String? get emoji; String? get text; DateTime? get expiresAtUtc; bool get isDnd;
/// Create a copy of UpsertChatUserStatusPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpsertChatUserStatusPayloadCopyWith<UpsertChatUserStatusPayload> get copyWith => _$UpsertChatUserStatusPayloadCopyWithImpl<UpsertChatUserStatusPayload>(this as UpsertChatUserStatusPayload, _$identity);

  /// Serializes this UpsertChatUserStatusPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpsertChatUserStatusPayload&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.text, text) || other.text == text)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.isDnd, isDnd) || other.isDnd == isDnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,text,expiresAtUtc,isDnd);

@override
String toString() {
  return 'UpsertChatUserStatusPayload(emoji: $emoji, text: $text, expiresAtUtc: $expiresAtUtc, isDnd: $isDnd)';
}


}

/// @nodoc
abstract mixin class $UpsertChatUserStatusPayloadCopyWith<$Res>  {
  factory $UpsertChatUserStatusPayloadCopyWith(UpsertChatUserStatusPayload value, $Res Function(UpsertChatUserStatusPayload) _then) = _$UpsertChatUserStatusPayloadCopyWithImpl;
@useResult
$Res call({
 String? emoji, String? text, DateTime? expiresAtUtc, bool isDnd
});




}
/// @nodoc
class _$UpsertChatUserStatusPayloadCopyWithImpl<$Res>
    implements $UpsertChatUserStatusPayloadCopyWith<$Res> {
  _$UpsertChatUserStatusPayloadCopyWithImpl(this._self, this._then);

  final UpsertChatUserStatusPayload _self;
  final $Res Function(UpsertChatUserStatusPayload) _then;

/// Create a copy of UpsertChatUserStatusPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = freezed,Object? text = freezed,Object? expiresAtUtc = freezed,Object? isDnd = null,}) {
  return _then(_self.copyWith(
emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,isDnd: null == isDnd ? _self.isDnd : isDnd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UpsertChatUserStatusPayload].
extension UpsertChatUserStatusPayloadPatterns on UpsertChatUserStatusPayload {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpsertChatUserStatusPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpsertChatUserStatusPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpsertChatUserStatusPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload() when $default != null:
return $default(_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd)  $default,) {final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload():
return $default(_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd)?  $default,) {final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload() when $default != null:
return $default(_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpsertChatUserStatusPayload implements UpsertChatUserStatusPayload {
  const _UpsertChatUserStatusPayload({this.emoji, this.text, this.expiresAtUtc, this.isDnd = false});
  factory _UpsertChatUserStatusPayload.fromJson(Map<String, dynamic> json) => _$UpsertChatUserStatusPayloadFromJson(json);

@override final  String? emoji;
@override final  String? text;
@override final  DateTime? expiresAtUtc;
@override@JsonKey() final  bool isDnd;

/// Create a copy of UpsertChatUserStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpsertChatUserStatusPayloadCopyWith<_UpsertChatUserStatusPayload> get copyWith => __$UpsertChatUserStatusPayloadCopyWithImpl<_UpsertChatUserStatusPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpsertChatUserStatusPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpsertChatUserStatusPayload&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.text, text) || other.text == text)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.isDnd, isDnd) || other.isDnd == isDnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,text,expiresAtUtc,isDnd);

@override
String toString() {
  return 'UpsertChatUserStatusPayload(emoji: $emoji, text: $text, expiresAtUtc: $expiresAtUtc, isDnd: $isDnd)';
}


}

/// @nodoc
abstract mixin class _$UpsertChatUserStatusPayloadCopyWith<$Res> implements $UpsertChatUserStatusPayloadCopyWith<$Res> {
  factory _$UpsertChatUserStatusPayloadCopyWith(_UpsertChatUserStatusPayload value, $Res Function(_UpsertChatUserStatusPayload) _then) = __$UpsertChatUserStatusPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? emoji, String? text, DateTime? expiresAtUtc, bool isDnd
});




}
/// @nodoc
class __$UpsertChatUserStatusPayloadCopyWithImpl<$Res>
    implements _$UpsertChatUserStatusPayloadCopyWith<$Res> {
  __$UpsertChatUserStatusPayloadCopyWithImpl(this._self, this._then);

  final _UpsertChatUserStatusPayload _self;
  final $Res Function(_UpsertChatUserStatusPayload) _then;

/// Create a copy of UpsertChatUserStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = freezed,Object? text = freezed,Object? expiresAtUtc = freezed,Object? isDnd = null,}) {
  return _then(_UpsertChatUserStatusPayload(
emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,isDnd: null == isDnd ? _self.isDnd : isDnd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatUserStatusResponse {

 String get userId; String? get emoji; String? get text; DateTime? get expiresAtUtc; bool get isDnd; DateTime get updatedAtUtc;
/// Create a copy of ChatUserStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatUserStatusResponseCopyWith<ChatUserStatusResponse> get copyWith => _$ChatUserStatusResponseCopyWithImpl<ChatUserStatusResponse>(this as ChatUserStatusResponse, _$identity);

  /// Serializes this ChatUserStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatUserStatusResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.text, text) || other.text == text)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.isDnd, isDnd) || other.isDnd == isDnd)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,emoji,text,expiresAtUtc,isDnd,updatedAtUtc);

@override
String toString() {
  return 'ChatUserStatusResponse(userId: $userId, emoji: $emoji, text: $text, expiresAtUtc: $expiresAtUtc, isDnd: $isDnd, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatUserStatusResponseCopyWith<$Res>  {
  factory $ChatUserStatusResponseCopyWith(ChatUserStatusResponse value, $Res Function(ChatUserStatusResponse) _then) = _$ChatUserStatusResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String? emoji, String? text, DateTime? expiresAtUtc, bool isDnd, DateTime updatedAtUtc
});




}
/// @nodoc
class _$ChatUserStatusResponseCopyWithImpl<$Res>
    implements $ChatUserStatusResponseCopyWith<$Res> {
  _$ChatUserStatusResponseCopyWithImpl(this._self, this._then);

  final ChatUserStatusResponse _self;
  final $Res Function(ChatUserStatusResponse) _then;

/// Create a copy of ChatUserStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? emoji = freezed,Object? text = freezed,Object? expiresAtUtc = freezed,Object? isDnd = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,isDnd: null == isDnd ? _self.isDnd : isDnd // ignore: cast_nullable_to_non_nullable
as bool,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatUserStatusResponse].
extension ChatUserStatusResponsePatterns on ChatUserStatusResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatUserStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatUserStatusResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatUserStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatUserStatusResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatUserStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatUserStatusResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatUserStatusResponse() when $default != null:
return $default(_that.userId,_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd,_that.updatedAtUtc);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatUserStatusResponse():
return $default(_that.userId,_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd,_that.updatedAtUtc);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatUserStatusResponse() when $default != null:
return $default(_that.userId,_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatUserStatusResponse implements ChatUserStatusResponse {
  const _ChatUserStatusResponse({required this.userId, this.emoji, this.text, this.expiresAtUtc, required this.isDnd, required this.updatedAtUtc});
  factory _ChatUserStatusResponse.fromJson(Map<String, dynamic> json) => _$ChatUserStatusResponseFromJson(json);

@override final  String userId;
@override final  String? emoji;
@override final  String? text;
@override final  DateTime? expiresAtUtc;
@override final  bool isDnd;
@override final  DateTime updatedAtUtc;

/// Create a copy of ChatUserStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatUserStatusResponseCopyWith<_ChatUserStatusResponse> get copyWith => __$ChatUserStatusResponseCopyWithImpl<_ChatUserStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatUserStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatUserStatusResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.text, text) || other.text == text)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.isDnd, isDnd) || other.isDnd == isDnd)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,emoji,text,expiresAtUtc,isDnd,updatedAtUtc);

@override
String toString() {
  return 'ChatUserStatusResponse(userId: $userId, emoji: $emoji, text: $text, expiresAtUtc: $expiresAtUtc, isDnd: $isDnd, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatUserStatusResponseCopyWith<$Res> implements $ChatUserStatusResponseCopyWith<$Res> {
  factory _$ChatUserStatusResponseCopyWith(_ChatUserStatusResponse value, $Res Function(_ChatUserStatusResponse) _then) = __$ChatUserStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? emoji, String? text, DateTime? expiresAtUtc, bool isDnd, DateTime updatedAtUtc
});




}
/// @nodoc
class __$ChatUserStatusResponseCopyWithImpl<$Res>
    implements _$ChatUserStatusResponseCopyWith<$Res> {
  __$ChatUserStatusResponseCopyWithImpl(this._self, this._then);

  final _ChatUserStatusResponse _self;
  final $Res Function(_ChatUserStatusResponse) _then;

/// Create a copy of ChatUserStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? emoji = freezed,Object? text = freezed,Object? expiresAtUtc = freezed,Object? isDnd = null,Object? updatedAtUtc = null,}) {
  return _then(_ChatUserStatusResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,isDnd: null == isDnd ? _self.isDnd : isDnd // ignore: cast_nullable_to_non_nullable
as bool,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
