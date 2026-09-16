// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CurrentUserResponse {

 String get coreUserId; int? get readyUserId; String? get login; List<String> get permissions;
/// Create a copy of CurrentUserResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentUserResponseCopyWith<CurrentUserResponse> get copyWith => _$CurrentUserResponseCopyWithImpl<CurrentUserResponse>(this as CurrentUserResponse, _$identity);

  /// Serializes this CurrentUserResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentUserResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.readyUserId, readyUserId) || other.readyUserId == readyUserId)&&(identical(other.login, login) || other.login == login)&&const DeepCollectionEquality().equals(other.permissions, permissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,readyUserId,login,const DeepCollectionEquality().hash(permissions));

@override
String toString() {
  return 'CurrentUserResponse(coreUserId: $coreUserId, readyUserId: $readyUserId, login: $login, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class $CurrentUserResponseCopyWith<$Res>  {
  factory $CurrentUserResponseCopyWith(CurrentUserResponse value, $Res Function(CurrentUserResponse) _then) = _$CurrentUserResponseCopyWithImpl;
@useResult
$Res call({
 String coreUserId, int? readyUserId, String? login, List<String> permissions
});




}
/// @nodoc
class _$CurrentUserResponseCopyWithImpl<$Res>
    implements $CurrentUserResponseCopyWith<$Res> {
  _$CurrentUserResponseCopyWithImpl(this._self, this._then);

  final CurrentUserResponse _self;
  final $Res Function(CurrentUserResponse) _then;

/// Create a copy of CurrentUserResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coreUserId = null,Object? readyUserId = freezed,Object? login = freezed,Object? permissions = null,}) {
  return _then(_self.copyWith(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,readyUserId: freezed == readyUserId ? _self.readyUserId : readyUserId // ignore: cast_nullable_to_non_nullable
as int?,login: freezed == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentUserResponse].
extension CurrentUserResponsePatterns on CurrentUserResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentUserResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentUserResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentUserResponse value)  $default,){
final _that = this;
switch (_that) {
case _CurrentUserResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentUserResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentUserResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coreUserId,  int? readyUserId,  String? login,  List<String> permissions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentUserResponse() when $default != null:
return $default(_that.coreUserId,_that.readyUserId,_that.login,_that.permissions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coreUserId,  int? readyUserId,  String? login,  List<String> permissions)  $default,) {final _that = this;
switch (_that) {
case _CurrentUserResponse():
return $default(_that.coreUserId,_that.readyUserId,_that.login,_that.permissions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coreUserId,  int? readyUserId,  String? login,  List<String> permissions)?  $default,) {final _that = this;
switch (_that) {
case _CurrentUserResponse() when $default != null:
return $default(_that.coreUserId,_that.readyUserId,_that.login,_that.permissions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentUserResponse implements CurrentUserResponse {
  const _CurrentUserResponse({required this.coreUserId, this.readyUserId, this.login, required this.permissions});
  factory _CurrentUserResponse.fromJson(Map<String, dynamic> json) => _$CurrentUserResponseFromJson(json);

@override final  String coreUserId;
@override final  int? readyUserId;
@override final  String? login;
@override final  List<String> permissions;

/// Create a copy of CurrentUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentUserResponseCopyWith<_CurrentUserResponse> get copyWith => __$CurrentUserResponseCopyWithImpl<_CurrentUserResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentUserResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentUserResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.readyUserId, readyUserId) || other.readyUserId == readyUserId)&&(identical(other.login, login) || other.login == login)&&const DeepCollectionEquality().equals(other.permissions, permissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,readyUserId,login,const DeepCollectionEquality().hash(permissions));

@override
String toString() {
  return 'CurrentUserResponse(coreUserId: $coreUserId, readyUserId: $readyUserId, login: $login, permissions: $permissions)';
}


}

/// @nodoc
abstract mixin class _$CurrentUserResponseCopyWith<$Res> implements $CurrentUserResponseCopyWith<$Res> {
  factory _$CurrentUserResponseCopyWith(_CurrentUserResponse value, $Res Function(_CurrentUserResponse) _then) = __$CurrentUserResponseCopyWithImpl;
@override @useResult
$Res call({
 String coreUserId, int? readyUserId, String? login, List<String> permissions
});




}
/// @nodoc
class __$CurrentUserResponseCopyWithImpl<$Res>
    implements _$CurrentUserResponseCopyWith<$Res> {
  __$CurrentUserResponseCopyWithImpl(this._self, this._then);

  final _CurrentUserResponse _self;
  final $Res Function(_CurrentUserResponse) _then;

/// Create a copy of CurrentUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coreUserId = null,Object? readyUserId = freezed,Object? login = freezed,Object? permissions = null,}) {
  return _then(_CurrentUserResponse(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,readyUserId: freezed == readyUserId ? _self.readyUserId : readyUserId // ignore: cast_nullable_to_non_nullable
as int?,login: freezed == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
