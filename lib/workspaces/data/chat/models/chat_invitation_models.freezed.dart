// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_invitation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateChatInvitePayload {

 String get email; int get ttlHours;
/// Create a copy of CreateChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateChatInvitePayloadCopyWith<CreateChatInvitePayload> get copyWith => _$CreateChatInvitePayloadCopyWithImpl<CreateChatInvitePayload>(this as CreateChatInvitePayload, _$identity);

  /// Serializes this CreateChatInvitePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateChatInvitePayload&&(identical(other.email, email) || other.email == email)&&(identical(other.ttlHours, ttlHours) || other.ttlHours == ttlHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,ttlHours);

@override
String toString() {
  return 'CreateChatInvitePayload(email: $email, ttlHours: $ttlHours)';
}


}

/// @nodoc
abstract mixin class $CreateChatInvitePayloadCopyWith<$Res>  {
  factory $CreateChatInvitePayloadCopyWith(CreateChatInvitePayload value, $Res Function(CreateChatInvitePayload) _then) = _$CreateChatInvitePayloadCopyWithImpl;
@useResult
$Res call({
 String email, int ttlHours
});




}
/// @nodoc
class _$CreateChatInvitePayloadCopyWithImpl<$Res>
    implements $CreateChatInvitePayloadCopyWith<$Res> {
  _$CreateChatInvitePayloadCopyWithImpl(this._self, this._then);

  final CreateChatInvitePayload _self;
  final $Res Function(CreateChatInvitePayload) _then;

/// Create a copy of CreateChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? ttlHours = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,ttlHours: null == ttlHours ? _self.ttlHours : ttlHours // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateChatInvitePayload].
extension CreateChatInvitePayloadPatterns on CreateChatInvitePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateChatInvitePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateChatInvitePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateChatInvitePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateChatInvitePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateChatInvitePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateChatInvitePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  int ttlHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateChatInvitePayload() when $default != null:
return $default(_that.email,_that.ttlHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  int ttlHours)  $default,) {final _that = this;
switch (_that) {
case _CreateChatInvitePayload():
return $default(_that.email,_that.ttlHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  int ttlHours)?  $default,) {final _that = this;
switch (_that) {
case _CreateChatInvitePayload() when $default != null:
return $default(_that.email,_that.ttlHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateChatInvitePayload implements CreateChatInvitePayload {
  const _CreateChatInvitePayload({required this.email, this.ttlHours = 72});
  factory _CreateChatInvitePayload.fromJson(Map<String, dynamic> json) => _$CreateChatInvitePayloadFromJson(json);

@override final  String email;
@override@JsonKey() final  int ttlHours;

/// Create a copy of CreateChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateChatInvitePayloadCopyWith<_CreateChatInvitePayload> get copyWith => __$CreateChatInvitePayloadCopyWithImpl<_CreateChatInvitePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateChatInvitePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateChatInvitePayload&&(identical(other.email, email) || other.email == email)&&(identical(other.ttlHours, ttlHours) || other.ttlHours == ttlHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,ttlHours);

@override
String toString() {
  return 'CreateChatInvitePayload(email: $email, ttlHours: $ttlHours)';
}


}

/// @nodoc
abstract mixin class _$CreateChatInvitePayloadCopyWith<$Res> implements $CreateChatInvitePayloadCopyWith<$Res> {
  factory _$CreateChatInvitePayloadCopyWith(_CreateChatInvitePayload value, $Res Function(_CreateChatInvitePayload) _then) = __$CreateChatInvitePayloadCopyWithImpl;
@override @useResult
$Res call({
 String email, int ttlHours
});




}
/// @nodoc
class __$CreateChatInvitePayloadCopyWithImpl<$Res>
    implements _$CreateChatInvitePayloadCopyWith<$Res> {
  __$CreateChatInvitePayloadCopyWithImpl(this._self, this._then);

  final _CreateChatInvitePayload _self;
  final $Res Function(_CreateChatInvitePayload) _then;

/// Create a copy of CreateChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? ttlHours = null,}) {
  return _then(_CreateChatInvitePayload(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,ttlHours: null == ttlHours ? _self.ttlHours : ttlHours // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AcceptChatInvitePayload {

 String get token;
/// Create a copy of AcceptChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcceptChatInvitePayloadCopyWith<AcceptChatInvitePayload> get copyWith => _$AcceptChatInvitePayloadCopyWithImpl<AcceptChatInvitePayload>(this as AcceptChatInvitePayload, _$identity);

  /// Serializes this AcceptChatInvitePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcceptChatInvitePayload&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'AcceptChatInvitePayload(token: $token)';
}


}

/// @nodoc
abstract mixin class $AcceptChatInvitePayloadCopyWith<$Res>  {
  factory $AcceptChatInvitePayloadCopyWith(AcceptChatInvitePayload value, $Res Function(AcceptChatInvitePayload) _then) = _$AcceptChatInvitePayloadCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class _$AcceptChatInvitePayloadCopyWithImpl<$Res>
    implements $AcceptChatInvitePayloadCopyWith<$Res> {
  _$AcceptChatInvitePayloadCopyWithImpl(this._self, this._then);

  final AcceptChatInvitePayload _self;
  final $Res Function(AcceptChatInvitePayload) _then;

/// Create a copy of AcceptChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AcceptChatInvitePayload].
extension AcceptChatInvitePayloadPatterns on AcceptChatInvitePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcceptChatInvitePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcceptChatInvitePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcceptChatInvitePayload value)  $default,){
final _that = this;
switch (_that) {
case _AcceptChatInvitePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcceptChatInvitePayload value)?  $default,){
final _that = this;
switch (_that) {
case _AcceptChatInvitePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcceptChatInvitePayload() when $default != null:
return $default(_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token)  $default,) {final _that = this;
switch (_that) {
case _AcceptChatInvitePayload():
return $default(_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token)?  $default,) {final _that = this;
switch (_that) {
case _AcceptChatInvitePayload() when $default != null:
return $default(_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AcceptChatInvitePayload implements AcceptChatInvitePayload {
  const _AcceptChatInvitePayload({required this.token});
  factory _AcceptChatInvitePayload.fromJson(Map<String, dynamic> json) => _$AcceptChatInvitePayloadFromJson(json);

@override final  String token;

/// Create a copy of AcceptChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcceptChatInvitePayloadCopyWith<_AcceptChatInvitePayload> get copyWith => __$AcceptChatInvitePayloadCopyWithImpl<_AcceptChatInvitePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AcceptChatInvitePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcceptChatInvitePayload&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'AcceptChatInvitePayload(token: $token)';
}


}

/// @nodoc
abstract mixin class _$AcceptChatInvitePayloadCopyWith<$Res> implements $AcceptChatInvitePayloadCopyWith<$Res> {
  factory _$AcceptChatInvitePayloadCopyWith(_AcceptChatInvitePayload value, $Res Function(_AcceptChatInvitePayload) _then) = __$AcceptChatInvitePayloadCopyWithImpl;
@override @useResult
$Res call({
 String token
});




}
/// @nodoc
class __$AcceptChatInvitePayloadCopyWithImpl<$Res>
    implements _$AcceptChatInvitePayloadCopyWith<$Res> {
  __$AcceptChatInvitePayloadCopyWithImpl(this._self, this._then);

  final _AcceptChatInvitePayload _self;
  final $Res Function(_AcceptChatInvitePayload) _then;

/// Create a copy of AcceptChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(_AcceptChatInvitePayload(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
