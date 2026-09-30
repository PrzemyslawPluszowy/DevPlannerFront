// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_directory_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatDirectoryUserResponse {

 String get userId; String get login; String get displayName; String? get avatarUrl;
/// Create a copy of ChatDirectoryUserResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDirectoryUserResponseCopyWith<ChatDirectoryUserResponse> get copyWith => _$ChatDirectoryUserResponseCopyWithImpl<ChatDirectoryUserResponse>(this as ChatDirectoryUserResponse, _$identity);

  /// Serializes this ChatDirectoryUserResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDirectoryUserResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatDirectoryUserResponse(userId: $userId, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ChatDirectoryUserResponseCopyWith<$Res>  {
  factory $ChatDirectoryUserResponseCopyWith(ChatDirectoryUserResponse value, $Res Function(ChatDirectoryUserResponse) _then) = _$ChatDirectoryUserResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String login, String displayName, String? avatarUrl
});




}
/// @nodoc
class _$ChatDirectoryUserResponseCopyWithImpl<$Res>
    implements $ChatDirectoryUserResponseCopyWith<$Res> {
  _$ChatDirectoryUserResponseCopyWithImpl(this._self, this._then);

  final ChatDirectoryUserResponse _self;
  final $Res Function(ChatDirectoryUserResponse) _then;

/// Create a copy of ChatDirectoryUserResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? login = null,Object? displayName = null,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatDirectoryUserResponse].
extension ChatDirectoryUserResponsePatterns on ChatDirectoryUserResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatDirectoryUserResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatDirectoryUserResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatDirectoryUserResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String login,  String displayName,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String login,  String displayName,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse():
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String login,  String displayName,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatDirectoryUserResponse implements ChatDirectoryUserResponse {
  const _ChatDirectoryUserResponse({required this.userId, required this.login, required this.displayName, this.avatarUrl});
  factory _ChatDirectoryUserResponse.fromJson(Map<String, dynamic> json) => _$ChatDirectoryUserResponseFromJson(json);

@override final  String userId;
@override final  String login;
@override final  String displayName;
@override final  String? avatarUrl;

/// Create a copy of ChatDirectoryUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatDirectoryUserResponseCopyWith<_ChatDirectoryUserResponse> get copyWith => __$ChatDirectoryUserResponseCopyWithImpl<_ChatDirectoryUserResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatDirectoryUserResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatDirectoryUserResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatDirectoryUserResponse(userId: $userId, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ChatDirectoryUserResponseCopyWith<$Res> implements $ChatDirectoryUserResponseCopyWith<$Res> {
  factory _$ChatDirectoryUserResponseCopyWith(_ChatDirectoryUserResponse value, $Res Function(_ChatDirectoryUserResponse) _then) = __$ChatDirectoryUserResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String login, String displayName, String? avatarUrl
});




}
/// @nodoc
class __$ChatDirectoryUserResponseCopyWithImpl<$Res>
    implements _$ChatDirectoryUserResponseCopyWith<$Res> {
  __$ChatDirectoryUserResponseCopyWithImpl(this._self, this._then);

  final _ChatDirectoryUserResponse _self;
  final $Res Function(_ChatDirectoryUserResponse) _then;

/// Create a copy of ChatDirectoryUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? login = null,Object? displayName = null,Object? avatarUrl = freezed,}) {
  return _then(_ChatDirectoryUserResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
