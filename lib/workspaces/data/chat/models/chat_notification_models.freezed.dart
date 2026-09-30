// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_notification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatUserNotificationPreferenceResponse {

 String get userId; bool get inAppEnabled; bool get emailEnabled; bool get pushEnabled; bool get digestEnabled;
/// Create a copy of ChatUserNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatUserNotificationPreferenceResponseCopyWith<ChatUserNotificationPreferenceResponse> get copyWith => _$ChatUserNotificationPreferenceResponseCopyWithImpl<ChatUserNotificationPreferenceResponse>(this as ChatUserNotificationPreferenceResponse, _$identity);

  /// Serializes this ChatUserNotificationPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatUserNotificationPreferenceResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.digestEnabled, digestEnabled) || other.digestEnabled == digestEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,inAppEnabled,emailEnabled,pushEnabled,digestEnabled);

@override
String toString() {
  return 'ChatUserNotificationPreferenceResponse(userId: $userId, inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, pushEnabled: $pushEnabled, digestEnabled: $digestEnabled)';
}


}

/// @nodoc
abstract mixin class $ChatUserNotificationPreferenceResponseCopyWith<$Res>  {
  factory $ChatUserNotificationPreferenceResponseCopyWith(ChatUserNotificationPreferenceResponse value, $Res Function(ChatUserNotificationPreferenceResponse) _then) = _$ChatUserNotificationPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String userId, bool inAppEnabled, bool emailEnabled, bool pushEnabled, bool digestEnabled
});




}
/// @nodoc
class _$ChatUserNotificationPreferenceResponseCopyWithImpl<$Res>
    implements $ChatUserNotificationPreferenceResponseCopyWith<$Res> {
  _$ChatUserNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final ChatUserNotificationPreferenceResponse _self;
  final $Res Function(ChatUserNotificationPreferenceResponse) _then;

/// Create a copy of ChatUserNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? inAppEnabled = null,Object? emailEnabled = null,Object? pushEnabled = null,Object? digestEnabled = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,inAppEnabled: null == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool,emailEnabled: null == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,digestEnabled: null == digestEnabled ? _self.digestEnabled : digestEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatUserNotificationPreferenceResponse].
extension ChatUserNotificationPreferenceResponsePatterns on ChatUserNotificationPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatUserNotificationPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatUserNotificationPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatUserNotificationPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool inAppEnabled,  bool emailEnabled,  bool pushEnabled,  bool digestEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse() when $default != null:
return $default(_that.userId,_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool inAppEnabled,  bool emailEnabled,  bool pushEnabled,  bool digestEnabled)  $default,) {final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse():
return $default(_that.userId,_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool inAppEnabled,  bool emailEnabled,  bool pushEnabled,  bool digestEnabled)?  $default,) {final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse() when $default != null:
return $default(_that.userId,_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatUserNotificationPreferenceResponse implements ChatUserNotificationPreferenceResponse {
  const _ChatUserNotificationPreferenceResponse({required this.userId, required this.inAppEnabled, required this.emailEnabled, required this.pushEnabled, required this.digestEnabled});
  factory _ChatUserNotificationPreferenceResponse.fromJson(Map<String, dynamic> json) => _$ChatUserNotificationPreferenceResponseFromJson(json);

@override final  String userId;
@override final  bool inAppEnabled;
@override final  bool emailEnabled;
@override final  bool pushEnabled;
@override final  bool digestEnabled;

/// Create a copy of ChatUserNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatUserNotificationPreferenceResponseCopyWith<_ChatUserNotificationPreferenceResponse> get copyWith => __$ChatUserNotificationPreferenceResponseCopyWithImpl<_ChatUserNotificationPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatUserNotificationPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatUserNotificationPreferenceResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.digestEnabled, digestEnabled) || other.digestEnabled == digestEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,inAppEnabled,emailEnabled,pushEnabled,digestEnabled);

@override
String toString() {
  return 'ChatUserNotificationPreferenceResponse(userId: $userId, inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, pushEnabled: $pushEnabled, digestEnabled: $digestEnabled)';
}


}

/// @nodoc
abstract mixin class _$ChatUserNotificationPreferenceResponseCopyWith<$Res> implements $ChatUserNotificationPreferenceResponseCopyWith<$Res> {
  factory _$ChatUserNotificationPreferenceResponseCopyWith(_ChatUserNotificationPreferenceResponse value, $Res Function(_ChatUserNotificationPreferenceResponse) _then) = __$ChatUserNotificationPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool inAppEnabled, bool emailEnabled, bool pushEnabled, bool digestEnabled
});




}
/// @nodoc
class __$ChatUserNotificationPreferenceResponseCopyWithImpl<$Res>
    implements _$ChatUserNotificationPreferenceResponseCopyWith<$Res> {
  __$ChatUserNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final _ChatUserNotificationPreferenceResponse _self;
  final $Res Function(_ChatUserNotificationPreferenceResponse) _then;

/// Create a copy of ChatUserNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? inAppEnabled = null,Object? emailEnabled = null,Object? pushEnabled = null,Object? digestEnabled = null,}) {
  return _then(_ChatUserNotificationPreferenceResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,inAppEnabled: null == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool,emailEnabled: null == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,digestEnabled: null == digestEnabled ? _self.digestEnabled : digestEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UpdateChatUserNotificationPreferencePayload {

 bool? get inAppEnabled; bool? get emailEnabled; bool? get pushEnabled; bool? get digestEnabled;
/// Create a copy of UpdateChatUserNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateChatUserNotificationPreferencePayloadCopyWith<UpdateChatUserNotificationPreferencePayload> get copyWith => _$UpdateChatUserNotificationPreferencePayloadCopyWithImpl<UpdateChatUserNotificationPreferencePayload>(this as UpdateChatUserNotificationPreferencePayload, _$identity);

  /// Serializes this UpdateChatUserNotificationPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChatUserNotificationPreferencePayload&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.digestEnabled, digestEnabled) || other.digestEnabled == digestEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inAppEnabled,emailEnabled,pushEnabled,digestEnabled);

@override
String toString() {
  return 'UpdateChatUserNotificationPreferencePayload(inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, pushEnabled: $pushEnabled, digestEnabled: $digestEnabled)';
}


}

/// @nodoc
abstract mixin class $UpdateChatUserNotificationPreferencePayloadCopyWith<$Res>  {
  factory $UpdateChatUserNotificationPreferencePayloadCopyWith(UpdateChatUserNotificationPreferencePayload value, $Res Function(UpdateChatUserNotificationPreferencePayload) _then) = _$UpdateChatUserNotificationPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 bool? inAppEnabled, bool? emailEnabled, bool? pushEnabled, bool? digestEnabled
});




}
/// @nodoc
class _$UpdateChatUserNotificationPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateChatUserNotificationPreferencePayloadCopyWith<$Res> {
  _$UpdateChatUserNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateChatUserNotificationPreferencePayload _self;
  final $Res Function(UpdateChatUserNotificationPreferencePayload) _then;

/// Create a copy of UpdateChatUserNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inAppEnabled = freezed,Object? emailEnabled = freezed,Object? pushEnabled = freezed,Object? digestEnabled = freezed,}) {
  return _then(_self.copyWith(
inAppEnabled: freezed == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool?,emailEnabled: freezed == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool?,pushEnabled: freezed == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool?,digestEnabled: freezed == digestEnabled ? _self.digestEnabled : digestEnabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateChatUserNotificationPreferencePayload].
extension UpdateChatUserNotificationPreferencePayloadPatterns on UpdateChatUserNotificationPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateChatUserNotificationPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateChatUserNotificationPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateChatUserNotificationPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? inAppEnabled,  bool? emailEnabled,  bool? pushEnabled,  bool? digestEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload() when $default != null:
return $default(_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? inAppEnabled,  bool? emailEnabled,  bool? pushEnabled,  bool? digestEnabled)  $default,) {final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload():
return $default(_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? inAppEnabled,  bool? emailEnabled,  bool? pushEnabled,  bool? digestEnabled)?  $default,) {final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload() when $default != null:
return $default(_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateChatUserNotificationPreferencePayload implements UpdateChatUserNotificationPreferencePayload {
  const _UpdateChatUserNotificationPreferencePayload({this.inAppEnabled, this.emailEnabled, this.pushEnabled, this.digestEnabled});
  factory _UpdateChatUserNotificationPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateChatUserNotificationPreferencePayloadFromJson(json);

@override final  bool? inAppEnabled;
@override final  bool? emailEnabled;
@override final  bool? pushEnabled;
@override final  bool? digestEnabled;

/// Create a copy of UpdateChatUserNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateChatUserNotificationPreferencePayloadCopyWith<_UpdateChatUserNotificationPreferencePayload> get copyWith => __$UpdateChatUserNotificationPreferencePayloadCopyWithImpl<_UpdateChatUserNotificationPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateChatUserNotificationPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateChatUserNotificationPreferencePayload&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.digestEnabled, digestEnabled) || other.digestEnabled == digestEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inAppEnabled,emailEnabled,pushEnabled,digestEnabled);

@override
String toString() {
  return 'UpdateChatUserNotificationPreferencePayload(inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, pushEnabled: $pushEnabled, digestEnabled: $digestEnabled)';
}


}

/// @nodoc
abstract mixin class _$UpdateChatUserNotificationPreferencePayloadCopyWith<$Res> implements $UpdateChatUserNotificationPreferencePayloadCopyWith<$Res> {
  factory _$UpdateChatUserNotificationPreferencePayloadCopyWith(_UpdateChatUserNotificationPreferencePayload value, $Res Function(_UpdateChatUserNotificationPreferencePayload) _then) = __$UpdateChatUserNotificationPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 bool? inAppEnabled, bool? emailEnabled, bool? pushEnabled, bool? digestEnabled
});




}
/// @nodoc
class __$UpdateChatUserNotificationPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateChatUserNotificationPreferencePayloadCopyWith<$Res> {
  __$UpdateChatUserNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateChatUserNotificationPreferencePayload _self;
  final $Res Function(_UpdateChatUserNotificationPreferencePayload) _then;

/// Create a copy of UpdateChatUserNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inAppEnabled = freezed,Object? emailEnabled = freezed,Object? pushEnabled = freezed,Object? digestEnabled = freezed,}) {
  return _then(_UpdateChatUserNotificationPreferencePayload(
inAppEnabled: freezed == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool?,emailEnabled: freezed == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool?,pushEnabled: freezed == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool?,digestEnabled: freezed == digestEnabled ? _self.digestEnabled : digestEnabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$ChatNotificationPreferenceResponse {

 String get conversationId; String get userId; ChatNotificationPreference get preference;
/// Create a copy of ChatNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatNotificationPreferenceResponseCopyWith<ChatNotificationPreferenceResponse> get copyWith => _$ChatNotificationPreferenceResponseCopyWithImpl<ChatNotificationPreferenceResponse>(this as ChatNotificationPreferenceResponse, _$identity);

  /// Serializes this ChatNotificationPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatNotificationPreferenceResponse&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.preference, preference) || other.preference == preference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,userId,preference);

@override
String toString() {
  return 'ChatNotificationPreferenceResponse(conversationId: $conversationId, userId: $userId, preference: $preference)';
}


}

/// @nodoc
abstract mixin class $ChatNotificationPreferenceResponseCopyWith<$Res>  {
  factory $ChatNotificationPreferenceResponseCopyWith(ChatNotificationPreferenceResponse value, $Res Function(ChatNotificationPreferenceResponse) _then) = _$ChatNotificationPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String conversationId, String userId, ChatNotificationPreference preference
});




}
/// @nodoc
class _$ChatNotificationPreferenceResponseCopyWithImpl<$Res>
    implements $ChatNotificationPreferenceResponseCopyWith<$Res> {
  _$ChatNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final ChatNotificationPreferenceResponse _self;
  final $Res Function(ChatNotificationPreferenceResponse) _then;

/// Create a copy of ChatNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? userId = null,Object? preference = null,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as ChatNotificationPreference,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatNotificationPreferenceResponse].
extension ChatNotificationPreferenceResponsePatterns on ChatNotificationPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatNotificationPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatNotificationPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatNotificationPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String conversationId,  String userId,  ChatNotificationPreference preference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse() when $default != null:
return $default(_that.conversationId,_that.userId,_that.preference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String conversationId,  String userId,  ChatNotificationPreference preference)  $default,) {final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse():
return $default(_that.conversationId,_that.userId,_that.preference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String conversationId,  String userId,  ChatNotificationPreference preference)?  $default,) {final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse() when $default != null:
return $default(_that.conversationId,_that.userId,_that.preference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatNotificationPreferenceResponse implements ChatNotificationPreferenceResponse {
  const _ChatNotificationPreferenceResponse({required this.conversationId, required this.userId, required this.preference});
  factory _ChatNotificationPreferenceResponse.fromJson(Map<String, dynamic> json) => _$ChatNotificationPreferenceResponseFromJson(json);

@override final  String conversationId;
@override final  String userId;
@override final  ChatNotificationPreference preference;

/// Create a copy of ChatNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatNotificationPreferenceResponseCopyWith<_ChatNotificationPreferenceResponse> get copyWith => __$ChatNotificationPreferenceResponseCopyWithImpl<_ChatNotificationPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatNotificationPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatNotificationPreferenceResponse&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.preference, preference) || other.preference == preference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,userId,preference);

@override
String toString() {
  return 'ChatNotificationPreferenceResponse(conversationId: $conversationId, userId: $userId, preference: $preference)';
}


}

/// @nodoc
abstract mixin class _$ChatNotificationPreferenceResponseCopyWith<$Res> implements $ChatNotificationPreferenceResponseCopyWith<$Res> {
  factory _$ChatNotificationPreferenceResponseCopyWith(_ChatNotificationPreferenceResponse value, $Res Function(_ChatNotificationPreferenceResponse) _then) = __$ChatNotificationPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String conversationId, String userId, ChatNotificationPreference preference
});




}
/// @nodoc
class __$ChatNotificationPreferenceResponseCopyWithImpl<$Res>
    implements _$ChatNotificationPreferenceResponseCopyWith<$Res> {
  __$ChatNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final _ChatNotificationPreferenceResponse _self;
  final $Res Function(_ChatNotificationPreferenceResponse) _then;

/// Create a copy of ChatNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? userId = null,Object? preference = null,}) {
  return _then(_ChatNotificationPreferenceResponse(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as ChatNotificationPreference,
  ));
}


}


/// @nodoc
mixin _$UpdateChatNotificationPreferencePayload {

 ChatNotificationPreference get preference;
/// Create a copy of UpdateChatNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateChatNotificationPreferencePayloadCopyWith<UpdateChatNotificationPreferencePayload> get copyWith => _$UpdateChatNotificationPreferencePayloadCopyWithImpl<UpdateChatNotificationPreferencePayload>(this as UpdateChatNotificationPreferencePayload, _$identity);

  /// Serializes this UpdateChatNotificationPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChatNotificationPreferencePayload&&(identical(other.preference, preference) || other.preference == preference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preference);

@override
String toString() {
  return 'UpdateChatNotificationPreferencePayload(preference: $preference)';
}


}

/// @nodoc
abstract mixin class $UpdateChatNotificationPreferencePayloadCopyWith<$Res>  {
  factory $UpdateChatNotificationPreferencePayloadCopyWith(UpdateChatNotificationPreferencePayload value, $Res Function(UpdateChatNotificationPreferencePayload) _then) = _$UpdateChatNotificationPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 ChatNotificationPreference preference
});




}
/// @nodoc
class _$UpdateChatNotificationPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateChatNotificationPreferencePayloadCopyWith<$Res> {
  _$UpdateChatNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateChatNotificationPreferencePayload _self;
  final $Res Function(UpdateChatNotificationPreferencePayload) _then;

/// Create a copy of UpdateChatNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preference = null,}) {
  return _then(_self.copyWith(
preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as ChatNotificationPreference,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateChatNotificationPreferencePayload].
extension UpdateChatNotificationPreferencePayloadPatterns on UpdateChatNotificationPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateChatNotificationPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateChatNotificationPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateChatNotificationPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatNotificationPreference preference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload() when $default != null:
return $default(_that.preference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatNotificationPreference preference)  $default,) {final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload():
return $default(_that.preference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatNotificationPreference preference)?  $default,) {final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload() when $default != null:
return $default(_that.preference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateChatNotificationPreferencePayload implements UpdateChatNotificationPreferencePayload {
  const _UpdateChatNotificationPreferencePayload({required this.preference});
  factory _UpdateChatNotificationPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateChatNotificationPreferencePayloadFromJson(json);

@override final  ChatNotificationPreference preference;

/// Create a copy of UpdateChatNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateChatNotificationPreferencePayloadCopyWith<_UpdateChatNotificationPreferencePayload> get copyWith => __$UpdateChatNotificationPreferencePayloadCopyWithImpl<_UpdateChatNotificationPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateChatNotificationPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateChatNotificationPreferencePayload&&(identical(other.preference, preference) || other.preference == preference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preference);

@override
String toString() {
  return 'UpdateChatNotificationPreferencePayload(preference: $preference)';
}


}

/// @nodoc
abstract mixin class _$UpdateChatNotificationPreferencePayloadCopyWith<$Res> implements $UpdateChatNotificationPreferencePayloadCopyWith<$Res> {
  factory _$UpdateChatNotificationPreferencePayloadCopyWith(_UpdateChatNotificationPreferencePayload value, $Res Function(_UpdateChatNotificationPreferencePayload) _then) = __$UpdateChatNotificationPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 ChatNotificationPreference preference
});




}
/// @nodoc
class __$UpdateChatNotificationPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateChatNotificationPreferencePayloadCopyWith<$Res> {
  __$UpdateChatNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateChatNotificationPreferencePayload _self;
  final $Res Function(_UpdateChatNotificationPreferencePayload) _then;

/// Create a copy of UpdateChatNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preference = null,}) {
  return _then(_UpdateChatNotificationPreferencePayload(
preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as ChatNotificationPreference,
  ));
}


}

// dart format on
