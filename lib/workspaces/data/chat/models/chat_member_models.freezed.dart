// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_member_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddChatMembersPayload {

 List<String>? get userIds;
/// Create a copy of AddChatMembersPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddChatMembersPayloadCopyWith<AddChatMembersPayload> get copyWith => _$AddChatMembersPayloadCopyWithImpl<AddChatMembersPayload>(this as AddChatMembersPayload, _$identity);

  /// Serializes this AddChatMembersPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddChatMembersPayload&&const DeepCollectionEquality().equals(other.userIds, userIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(userIds));

@override
String toString() {
  return 'AddChatMembersPayload(userIds: $userIds)';
}


}

/// @nodoc
abstract mixin class $AddChatMembersPayloadCopyWith<$Res>  {
  factory $AddChatMembersPayloadCopyWith(AddChatMembersPayload value, $Res Function(AddChatMembersPayload) _then) = _$AddChatMembersPayloadCopyWithImpl;
@useResult
$Res call({
 List<String>? userIds
});




}
/// @nodoc
class _$AddChatMembersPayloadCopyWithImpl<$Res>
    implements $AddChatMembersPayloadCopyWith<$Res> {
  _$AddChatMembersPayloadCopyWithImpl(this._self, this._then);

  final AddChatMembersPayload _self;
  final $Res Function(AddChatMembersPayload) _then;

/// Create a copy of AddChatMembersPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userIds = freezed,}) {
  return _then(_self.copyWith(
userIds: freezed == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddChatMembersPayload].
extension AddChatMembersPayloadPatterns on AddChatMembersPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddChatMembersPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddChatMembersPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddChatMembersPayload value)  $default,){
final _that = this;
switch (_that) {
case _AddChatMembersPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddChatMembersPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AddChatMembersPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String>? userIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddChatMembersPayload() when $default != null:
return $default(_that.userIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String>? userIds)  $default,) {final _that = this;
switch (_that) {
case _AddChatMembersPayload():
return $default(_that.userIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String>? userIds)?  $default,) {final _that = this;
switch (_that) {
case _AddChatMembersPayload() when $default != null:
return $default(_that.userIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddChatMembersPayload implements AddChatMembersPayload {
  const _AddChatMembersPayload({this.userIds});
  factory _AddChatMembersPayload.fromJson(Map<String, dynamic> json) => _$AddChatMembersPayloadFromJson(json);

@override final  List<String>? userIds;

/// Create a copy of AddChatMembersPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddChatMembersPayloadCopyWith<_AddChatMembersPayload> get copyWith => __$AddChatMembersPayloadCopyWithImpl<_AddChatMembersPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddChatMembersPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddChatMembersPayload&&const DeepCollectionEquality().equals(other.userIds, userIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(userIds));

@override
String toString() {
  return 'AddChatMembersPayload(userIds: $userIds)';
}


}

/// @nodoc
abstract mixin class _$AddChatMembersPayloadCopyWith<$Res> implements $AddChatMembersPayloadCopyWith<$Res> {
  factory _$AddChatMembersPayloadCopyWith(_AddChatMembersPayload value, $Res Function(_AddChatMembersPayload) _then) = __$AddChatMembersPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String>? userIds
});




}
/// @nodoc
class __$AddChatMembersPayloadCopyWithImpl<$Res>
    implements _$AddChatMembersPayloadCopyWith<$Res> {
  __$AddChatMembersPayloadCopyWithImpl(this._self, this._then);

  final _AddChatMembersPayload _self;
  final $Res Function(_AddChatMembersPayload) _then;

/// Create a copy of AddChatMembersPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userIds = freezed,}) {
  return _then(_AddChatMembersPayload(
userIds: freezed == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$UpdateChatMemberRolePayload {

 String get role;
/// Create a copy of UpdateChatMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateChatMemberRolePayloadCopyWith<UpdateChatMemberRolePayload> get copyWith => _$UpdateChatMemberRolePayloadCopyWithImpl<UpdateChatMemberRolePayload>(this as UpdateChatMemberRolePayload, _$identity);

  /// Serializes this UpdateChatMemberRolePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChatMemberRolePayload&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'UpdateChatMemberRolePayload(role: $role)';
}


}

/// @nodoc
abstract mixin class $UpdateChatMemberRolePayloadCopyWith<$Res>  {
  factory $UpdateChatMemberRolePayloadCopyWith(UpdateChatMemberRolePayload value, $Res Function(UpdateChatMemberRolePayload) _then) = _$UpdateChatMemberRolePayloadCopyWithImpl;
@useResult
$Res call({
 String role
});




}
/// @nodoc
class _$UpdateChatMemberRolePayloadCopyWithImpl<$Res>
    implements $UpdateChatMemberRolePayloadCopyWith<$Res> {
  _$UpdateChatMemberRolePayloadCopyWithImpl(this._self, this._then);

  final UpdateChatMemberRolePayload _self;
  final $Res Function(UpdateChatMemberRolePayload) _then;

/// Create a copy of UpdateChatMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateChatMemberRolePayload].
extension UpdateChatMemberRolePayloadPatterns on UpdateChatMemberRolePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateChatMemberRolePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateChatMemberRolePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateChatMemberRolePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload() when $default != null:
return $default(_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role)  $default,) {final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload():
return $default(_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role)?  $default,) {final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload() when $default != null:
return $default(_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateChatMemberRolePayload implements UpdateChatMemberRolePayload {
  const _UpdateChatMemberRolePayload({required this.role});
  factory _UpdateChatMemberRolePayload.fromJson(Map<String, dynamic> json) => _$UpdateChatMemberRolePayloadFromJson(json);

@override final  String role;

/// Create a copy of UpdateChatMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateChatMemberRolePayloadCopyWith<_UpdateChatMemberRolePayload> get copyWith => __$UpdateChatMemberRolePayloadCopyWithImpl<_UpdateChatMemberRolePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateChatMemberRolePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateChatMemberRolePayload&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'UpdateChatMemberRolePayload(role: $role)';
}


}

/// @nodoc
abstract mixin class _$UpdateChatMemberRolePayloadCopyWith<$Res> implements $UpdateChatMemberRolePayloadCopyWith<$Res> {
  factory _$UpdateChatMemberRolePayloadCopyWith(_UpdateChatMemberRolePayload value, $Res Function(_UpdateChatMemberRolePayload) _then) = __$UpdateChatMemberRolePayloadCopyWithImpl;
@override @useResult
$Res call({
 String role
});




}
/// @nodoc
class __$UpdateChatMemberRolePayloadCopyWithImpl<$Res>
    implements _$UpdateChatMemberRolePayloadCopyWith<$Res> {
  __$UpdateChatMemberRolePayloadCopyWithImpl(this._self, this._then);

  final _UpdateChatMemberRolePayload _self;
  final $Res Function(_UpdateChatMemberRolePayload) _then;

/// Create a copy of UpdateChatMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,}) {
  return _then(_UpdateChatMemberRolePayload(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ChatMemberResponse {

 String get userId; String get role; DateTime get joinedAtUtc; String? get login; String? get displayName; String? get avatarUrl;
/// Create a copy of ChatMemberResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMemberResponseCopyWith<ChatMemberResponse> get copyWith => _$ChatMemberResponseCopyWithImpl<ChatMemberResponse>(this as ChatMemberResponse, _$identity);

  /// Serializes this ChatMemberResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMemberResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAtUtc, joinedAtUtc) || other.joinedAtUtc == joinedAtUtc)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,role,joinedAtUtc,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatMemberResponse(userId: $userId, role: $role, joinedAtUtc: $joinedAtUtc, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ChatMemberResponseCopyWith<$Res>  {
  factory $ChatMemberResponseCopyWith(ChatMemberResponse value, $Res Function(ChatMemberResponse) _then) = _$ChatMemberResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String role, DateTime joinedAtUtc, String? login, String? displayName, String? avatarUrl
});




}
/// @nodoc
class _$ChatMemberResponseCopyWithImpl<$Res>
    implements $ChatMemberResponseCopyWith<$Res> {
  _$ChatMemberResponseCopyWithImpl(this._self, this._then);

  final ChatMemberResponse _self;
  final $Res Function(ChatMemberResponse) _then;

/// Create a copy of ChatMemberResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? role = null,Object? joinedAtUtc = null,Object? login = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,joinedAtUtc: null == joinedAtUtc ? _self.joinedAtUtc : joinedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,login: freezed == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMemberResponse].
extension ChatMemberResponsePatterns on ChatMemberResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMemberResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMemberResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMemberResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatMemberResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMemberResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMemberResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String role,  DateTime joinedAtUtc,  String? login,  String? displayName,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMemberResponse() when $default != null:
return $default(_that.userId,_that.role,_that.joinedAtUtc,_that.login,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String role,  DateTime joinedAtUtc,  String? login,  String? displayName,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ChatMemberResponse():
return $default(_that.userId,_that.role,_that.joinedAtUtc,_that.login,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String role,  DateTime joinedAtUtc,  String? login,  String? displayName,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ChatMemberResponse() when $default != null:
return $default(_that.userId,_that.role,_that.joinedAtUtc,_that.login,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMemberResponse implements ChatMemberResponse {
  const _ChatMemberResponse({required this.userId, required this.role, required this.joinedAtUtc, this.login, this.displayName, this.avatarUrl});
  factory _ChatMemberResponse.fromJson(Map<String, dynamic> json) => _$ChatMemberResponseFromJson(json);

@override final  String userId;
@override final  String role;
@override final  DateTime joinedAtUtc;
@override final  String? login;
@override final  String? displayName;
@override final  String? avatarUrl;

/// Create a copy of ChatMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMemberResponseCopyWith<_ChatMemberResponse> get copyWith => __$ChatMemberResponseCopyWithImpl<_ChatMemberResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMemberResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMemberResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAtUtc, joinedAtUtc) || other.joinedAtUtc == joinedAtUtc)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,role,joinedAtUtc,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatMemberResponse(userId: $userId, role: $role, joinedAtUtc: $joinedAtUtc, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ChatMemberResponseCopyWith<$Res> implements $ChatMemberResponseCopyWith<$Res> {
  factory _$ChatMemberResponseCopyWith(_ChatMemberResponse value, $Res Function(_ChatMemberResponse) _then) = __$ChatMemberResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String role, DateTime joinedAtUtc, String? login, String? displayName, String? avatarUrl
});




}
/// @nodoc
class __$ChatMemberResponseCopyWithImpl<$Res>
    implements _$ChatMemberResponseCopyWith<$Res> {
  __$ChatMemberResponseCopyWithImpl(this._self, this._then);

  final _ChatMemberResponse _self;
  final $Res Function(_ChatMemberResponse) _then;

/// Create a copy of ChatMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? role = null,Object? joinedAtUtc = null,Object? login = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_ChatMemberResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,joinedAtUtc: null == joinedAtUtc ? _self.joinedAtUtc : joinedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,login: freezed == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChatMentionSuggestionResponse {

 String get userId; String get login; String get displayName; String? get avatarUrl;
/// Create a copy of ChatMentionSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMentionSuggestionResponseCopyWith<ChatMentionSuggestionResponse> get copyWith => _$ChatMentionSuggestionResponseCopyWithImpl<ChatMentionSuggestionResponse>(this as ChatMentionSuggestionResponse, _$identity);

  /// Serializes this ChatMentionSuggestionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMentionSuggestionResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatMentionSuggestionResponse(userId: $userId, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ChatMentionSuggestionResponseCopyWith<$Res>  {
  factory $ChatMentionSuggestionResponseCopyWith(ChatMentionSuggestionResponse value, $Res Function(ChatMentionSuggestionResponse) _then) = _$ChatMentionSuggestionResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String login, String displayName, String? avatarUrl
});




}
/// @nodoc
class _$ChatMentionSuggestionResponseCopyWithImpl<$Res>
    implements $ChatMentionSuggestionResponseCopyWith<$Res> {
  _$ChatMentionSuggestionResponseCopyWithImpl(this._self, this._then);

  final ChatMentionSuggestionResponse _self;
  final $Res Function(ChatMentionSuggestionResponse) _then;

/// Create a copy of ChatMentionSuggestionResponse
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


/// Adds pattern-matching-related methods to [ChatMentionSuggestionResponse].
extension ChatMentionSuggestionResponsePatterns on ChatMentionSuggestionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMentionSuggestionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMentionSuggestionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMentionSuggestionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatMentionSuggestionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMentionSuggestionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMentionSuggestionResponse() when $default != null:
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
case _ChatMentionSuggestionResponse() when $default != null:
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
case _ChatMentionSuggestionResponse():
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
case _ChatMentionSuggestionResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMentionSuggestionResponse implements ChatMentionSuggestionResponse {
  const _ChatMentionSuggestionResponse({required this.userId, required this.login, required this.displayName, this.avatarUrl});
  factory _ChatMentionSuggestionResponse.fromJson(Map<String, dynamic> json) => _$ChatMentionSuggestionResponseFromJson(json);

@override final  String userId;
@override final  String login;
@override final  String displayName;
@override final  String? avatarUrl;

/// Create a copy of ChatMentionSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMentionSuggestionResponseCopyWith<_ChatMentionSuggestionResponse> get copyWith => __$ChatMentionSuggestionResponseCopyWithImpl<_ChatMentionSuggestionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMentionSuggestionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMentionSuggestionResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatMentionSuggestionResponse(userId: $userId, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ChatMentionSuggestionResponseCopyWith<$Res> implements $ChatMentionSuggestionResponseCopyWith<$Res> {
  factory _$ChatMentionSuggestionResponseCopyWith(_ChatMentionSuggestionResponse value, $Res Function(_ChatMentionSuggestionResponse) _then) = __$ChatMentionSuggestionResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String login, String displayName, String? avatarUrl
});




}
/// @nodoc
class __$ChatMentionSuggestionResponseCopyWithImpl<$Res>
    implements _$ChatMentionSuggestionResponseCopyWith<$Res> {
  __$ChatMentionSuggestionResponseCopyWithImpl(this._self, this._then);

  final _ChatMentionSuggestionResponse _self;
  final $Res Function(_ChatMentionSuggestionResponse) _then;

/// Create a copy of ChatMentionSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? login = null,Object? displayName = null,Object? avatarUrl = freezed,}) {
  return _then(_ChatMentionSuggestionResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
