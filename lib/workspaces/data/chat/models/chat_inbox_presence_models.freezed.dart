// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_inbox_presence_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatInboxPresenceRequest {

 List<String> get userIds;
/// Create a copy of ChatInboxPresenceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInboxPresenceRequestCopyWith<ChatInboxPresenceRequest> get copyWith => _$ChatInboxPresenceRequestCopyWithImpl<ChatInboxPresenceRequest>(this as ChatInboxPresenceRequest, _$identity);

  /// Serializes this ChatInboxPresenceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInboxPresenceRequest&&const DeepCollectionEquality().equals(other.userIds, userIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(userIds));

@override
String toString() {
  return 'ChatInboxPresenceRequest(userIds: $userIds)';
}


}

/// @nodoc
abstract mixin class $ChatInboxPresenceRequestCopyWith<$Res>  {
  factory $ChatInboxPresenceRequestCopyWith(ChatInboxPresenceRequest value, $Res Function(ChatInboxPresenceRequest) _then) = _$ChatInboxPresenceRequestCopyWithImpl;
@useResult
$Res call({
 List<String> userIds
});




}
/// @nodoc
class _$ChatInboxPresenceRequestCopyWithImpl<$Res>
    implements $ChatInboxPresenceRequestCopyWith<$Res> {
  _$ChatInboxPresenceRequestCopyWithImpl(this._self, this._then);

  final ChatInboxPresenceRequest _self;
  final $Res Function(ChatInboxPresenceRequest) _then;

/// Create a copy of ChatInboxPresenceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userIds = null,}) {
  return _then(_self.copyWith(
userIds: null == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatInboxPresenceRequest].
extension ChatInboxPresenceRequestPatterns on ChatInboxPresenceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInboxPresenceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInboxPresenceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInboxPresenceRequest value)  $default,){
final _that = this;
switch (_that) {
case _ChatInboxPresenceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInboxPresenceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInboxPresenceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> userIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInboxPresenceRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> userIds)  $default,) {final _that = this;
switch (_that) {
case _ChatInboxPresenceRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> userIds)?  $default,) {final _that = this;
switch (_that) {
case _ChatInboxPresenceRequest() when $default != null:
return $default(_that.userIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatInboxPresenceRequest implements ChatInboxPresenceRequest {
  const _ChatInboxPresenceRequest({List<String> userIds = const <String>[]}): _userIds = userIds;
  factory _ChatInboxPresenceRequest.fromJson(Map<String, dynamic> json) => _$ChatInboxPresenceRequestFromJson(json);

 final  List<String> _userIds;
@override@JsonKey() List<String> get userIds {
  if (_userIds is EqualUnmodifiableListView) return _userIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userIds);
}


/// Create a copy of ChatInboxPresenceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInboxPresenceRequestCopyWith<_ChatInboxPresenceRequest> get copyWith => __$ChatInboxPresenceRequestCopyWithImpl<_ChatInboxPresenceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatInboxPresenceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInboxPresenceRequest&&const DeepCollectionEquality().equals(other._userIds, _userIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_userIds));

@override
String toString() {
  return 'ChatInboxPresenceRequest(userIds: $userIds)';
}


}

/// @nodoc
abstract mixin class _$ChatInboxPresenceRequestCopyWith<$Res> implements $ChatInboxPresenceRequestCopyWith<$Res> {
  factory _$ChatInboxPresenceRequestCopyWith(_ChatInboxPresenceRequest value, $Res Function(_ChatInboxPresenceRequest) _then) = __$ChatInboxPresenceRequestCopyWithImpl;
@override @useResult
$Res call({
 List<String> userIds
});




}
/// @nodoc
class __$ChatInboxPresenceRequestCopyWithImpl<$Res>
    implements _$ChatInboxPresenceRequestCopyWith<$Res> {
  __$ChatInboxPresenceRequestCopyWithImpl(this._self, this._then);

  final _ChatInboxPresenceRequest _self;
  final $Res Function(_ChatInboxPresenceRequest) _then;

/// Create a copy of ChatInboxPresenceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userIds = null,}) {
  return _then(_ChatInboxPresenceRequest(
userIds: null == userIds ? _self._userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ChatInboxPresenceResponse {

 List<ChatInboxPresenceUserResponse> get users;
/// Create a copy of ChatInboxPresenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInboxPresenceResponseCopyWith<ChatInboxPresenceResponse> get copyWith => _$ChatInboxPresenceResponseCopyWithImpl<ChatInboxPresenceResponse>(this as ChatInboxPresenceResponse, _$identity);

  /// Serializes this ChatInboxPresenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInboxPresenceResponse&&const DeepCollectionEquality().equals(other.users, users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'ChatInboxPresenceResponse(users: $users)';
}


}

/// @nodoc
abstract mixin class $ChatInboxPresenceResponseCopyWith<$Res>  {
  factory $ChatInboxPresenceResponseCopyWith(ChatInboxPresenceResponse value, $Res Function(ChatInboxPresenceResponse) _then) = _$ChatInboxPresenceResponseCopyWithImpl;
@useResult
$Res call({
 List<ChatInboxPresenceUserResponse> users
});




}
/// @nodoc
class _$ChatInboxPresenceResponseCopyWithImpl<$Res>
    implements $ChatInboxPresenceResponseCopyWith<$Res> {
  _$ChatInboxPresenceResponseCopyWithImpl(this._self, this._then);

  final ChatInboxPresenceResponse _self;
  final $Res Function(ChatInboxPresenceResponse) _then;

/// Create a copy of ChatInboxPresenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<ChatInboxPresenceUserResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatInboxPresenceResponse].
extension ChatInboxPresenceResponsePatterns on ChatInboxPresenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInboxPresenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInboxPresenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInboxPresenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatInboxPresenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInboxPresenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInboxPresenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatInboxPresenceUserResponse> users)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInboxPresenceResponse() when $default != null:
return $default(_that.users);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatInboxPresenceUserResponse> users)  $default,) {final _that = this;
switch (_that) {
case _ChatInboxPresenceResponse():
return $default(_that.users);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatInboxPresenceUserResponse> users)?  $default,) {final _that = this;
switch (_that) {
case _ChatInboxPresenceResponse() when $default != null:
return $default(_that.users);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatInboxPresenceResponse implements ChatInboxPresenceResponse {
  const _ChatInboxPresenceResponse({List<ChatInboxPresenceUserResponse> users = const <ChatInboxPresenceUserResponse>[]}): _users = users;
  factory _ChatInboxPresenceResponse.fromJson(Map<String, dynamic> json) => _$ChatInboxPresenceResponseFromJson(json);

 final  List<ChatInboxPresenceUserResponse> _users;
@override@JsonKey() List<ChatInboxPresenceUserResponse> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of ChatInboxPresenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInboxPresenceResponseCopyWith<_ChatInboxPresenceResponse> get copyWith => __$ChatInboxPresenceResponseCopyWithImpl<_ChatInboxPresenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatInboxPresenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInboxPresenceResponse&&const DeepCollectionEquality().equals(other._users, _users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'ChatInboxPresenceResponse(users: $users)';
}


}

/// @nodoc
abstract mixin class _$ChatInboxPresenceResponseCopyWith<$Res> implements $ChatInboxPresenceResponseCopyWith<$Res> {
  factory _$ChatInboxPresenceResponseCopyWith(_ChatInboxPresenceResponse value, $Res Function(_ChatInboxPresenceResponse) _then) = __$ChatInboxPresenceResponseCopyWithImpl;
@override @useResult
$Res call({
 List<ChatInboxPresenceUserResponse> users
});




}
/// @nodoc
class __$ChatInboxPresenceResponseCopyWithImpl<$Res>
    implements _$ChatInboxPresenceResponseCopyWith<$Res> {
  __$ChatInboxPresenceResponseCopyWithImpl(this._self, this._then);

  final _ChatInboxPresenceResponse _self;
  final $Res Function(_ChatInboxPresenceResponse) _then;

/// Create a copy of ChatInboxPresenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,}) {
  return _then(_ChatInboxPresenceResponse(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<ChatInboxPresenceUserResponse>,
  ));
}


}


/// @nodoc
mixin _$ChatInboxPresenceUserResponse {

 String get userId; bool get isOnline;
/// Create a copy of ChatInboxPresenceUserResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInboxPresenceUserResponseCopyWith<ChatInboxPresenceUserResponse> get copyWith => _$ChatInboxPresenceUserResponseCopyWithImpl<ChatInboxPresenceUserResponse>(this as ChatInboxPresenceUserResponse, _$identity);

  /// Serializes this ChatInboxPresenceUserResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInboxPresenceUserResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,isOnline);

@override
String toString() {
  return 'ChatInboxPresenceUserResponse(userId: $userId, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class $ChatInboxPresenceUserResponseCopyWith<$Res>  {
  factory $ChatInboxPresenceUserResponseCopyWith(ChatInboxPresenceUserResponse value, $Res Function(ChatInboxPresenceUserResponse) _then) = _$ChatInboxPresenceUserResponseCopyWithImpl;
@useResult
$Res call({
 String userId, bool isOnline
});




}
/// @nodoc
class _$ChatInboxPresenceUserResponseCopyWithImpl<$Res>
    implements $ChatInboxPresenceUserResponseCopyWith<$Res> {
  _$ChatInboxPresenceUserResponseCopyWithImpl(this._self, this._then);

  final ChatInboxPresenceUserResponse _self;
  final $Res Function(ChatInboxPresenceUserResponse) _then;

/// Create a copy of ChatInboxPresenceUserResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? isOnline = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatInboxPresenceUserResponse].
extension ChatInboxPresenceUserResponsePatterns on ChatInboxPresenceUserResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInboxPresenceUserResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInboxPresenceUserResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInboxPresenceUserResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatInboxPresenceUserResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInboxPresenceUserResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInboxPresenceUserResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool isOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInboxPresenceUserResponse() when $default != null:
return $default(_that.userId,_that.isOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool isOnline)  $default,) {final _that = this;
switch (_that) {
case _ChatInboxPresenceUserResponse():
return $default(_that.userId,_that.isOnline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool isOnline)?  $default,) {final _that = this;
switch (_that) {
case _ChatInboxPresenceUserResponse() when $default != null:
return $default(_that.userId,_that.isOnline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatInboxPresenceUserResponse implements ChatInboxPresenceUserResponse {
  const _ChatInboxPresenceUserResponse({required this.userId, required this.isOnline});
  factory _ChatInboxPresenceUserResponse.fromJson(Map<String, dynamic> json) => _$ChatInboxPresenceUserResponseFromJson(json);

@override final  String userId;
@override final  bool isOnline;

/// Create a copy of ChatInboxPresenceUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInboxPresenceUserResponseCopyWith<_ChatInboxPresenceUserResponse> get copyWith => __$ChatInboxPresenceUserResponseCopyWithImpl<_ChatInboxPresenceUserResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatInboxPresenceUserResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInboxPresenceUserResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,isOnline);

@override
String toString() {
  return 'ChatInboxPresenceUserResponse(userId: $userId, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class _$ChatInboxPresenceUserResponseCopyWith<$Res> implements $ChatInboxPresenceUserResponseCopyWith<$Res> {
  factory _$ChatInboxPresenceUserResponseCopyWith(_ChatInboxPresenceUserResponse value, $Res Function(_ChatInboxPresenceUserResponse) _then) = __$ChatInboxPresenceUserResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool isOnline
});




}
/// @nodoc
class __$ChatInboxPresenceUserResponseCopyWithImpl<$Res>
    implements _$ChatInboxPresenceUserResponseCopyWith<$Res> {
  __$ChatInboxPresenceUserResponseCopyWithImpl(this._self, this._then);

  final _ChatInboxPresenceUserResponse _self;
  final $Res Function(_ChatInboxPresenceUserResponse) _then;

/// Create a copy of ChatInboxPresenceUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? isOnline = null,}) {
  return _then(_ChatInboxPresenceUserResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
