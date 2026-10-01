// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_member_profile_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectMemberProfileResponse {

/// Kanoniczny lokalny identyfikator użytkownika DevPlanner.
 String get userId;/// Nazwa do pokazania w presence i selektorach osób.
 String? get displayName;/// Bezpieczny URL avatara, jeśli katalog go udostępnia.
 String? get avatarUrl;/// Presence całej aplikacji; null oznacza brak aktualnego kontraktu danych.
 bool? get isOnline;/// Skuteczna rola użytkownika w projekcie.
 ProjectRole get role;
/// Create a copy of ProjectMemberProfileResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectMemberProfileResponseCopyWith<ProjectMemberProfileResponse> get copyWith => _$ProjectMemberProfileResponseCopyWithImpl<ProjectMemberProfileResponse>(this as ProjectMemberProfileResponse, _$identity);

  /// Serializes this ProjectMemberProfileResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectMemberProfileResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,avatarUrl,isOnline,role);

@override
String toString() {
  return 'ProjectMemberProfileResponse(userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, isOnline: $isOnline, role: $role)';
}


}

/// @nodoc
abstract mixin class $ProjectMemberProfileResponseCopyWith<$Res>  {
  factory $ProjectMemberProfileResponseCopyWith(ProjectMemberProfileResponse value, $Res Function(ProjectMemberProfileResponse) _then) = _$ProjectMemberProfileResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String? displayName, String? avatarUrl, bool? isOnline, ProjectRole role
});




}
/// @nodoc
class _$ProjectMemberProfileResponseCopyWithImpl<$Res>
    implements $ProjectMemberProfileResponseCopyWith<$Res> {
  _$ProjectMemberProfileResponseCopyWithImpl(this._self, this._then);

  final ProjectMemberProfileResponse _self;
  final $Res Function(ProjectMemberProfileResponse) _then;

/// Create a copy of ProjectMemberProfileResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? isOnline = freezed,Object? role = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isOnline: freezed == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectMemberProfileResponse].
extension ProjectMemberProfileResponsePatterns on ProjectMemberProfileResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectMemberProfileResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectMemberProfileResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectMemberProfileResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectMemberProfileResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectMemberProfileResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectMemberProfileResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? displayName,  String? avatarUrl,  bool? isOnline,  ProjectRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectMemberProfileResponse() when $default != null:
return $default(_that.userId,_that.displayName,_that.avatarUrl,_that.isOnline,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? displayName,  String? avatarUrl,  bool? isOnline,  ProjectRole role)  $default,) {final _that = this;
switch (_that) {
case _ProjectMemberProfileResponse():
return $default(_that.userId,_that.displayName,_that.avatarUrl,_that.isOnline,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? displayName,  String? avatarUrl,  bool? isOnline,  ProjectRole role)?  $default,) {final _that = this;
switch (_that) {
case _ProjectMemberProfileResponse() when $default != null:
return $default(_that.userId,_that.displayName,_that.avatarUrl,_that.isOnline,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectMemberProfileResponse implements ProjectMemberProfileResponse {
  const _ProjectMemberProfileResponse({required this.userId, this.displayName, this.avatarUrl, this.isOnline, required this.role});
  factory _ProjectMemberProfileResponse.fromJson(Map<String, dynamic> json) => _$ProjectMemberProfileResponseFromJson(json);

/// Kanoniczny lokalny identyfikator użytkownika DevPlanner.
@override final  String userId;
/// Nazwa do pokazania w presence i selektorach osób.
@override final  String? displayName;
/// Bezpieczny URL avatara, jeśli katalog go udostępnia.
@override final  String? avatarUrl;
/// Presence całej aplikacji; null oznacza brak aktualnego kontraktu danych.
@override final  bool? isOnline;
/// Skuteczna rola użytkownika w projekcie.
@override final  ProjectRole role;

/// Create a copy of ProjectMemberProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectMemberProfileResponseCopyWith<_ProjectMemberProfileResponse> get copyWith => __$ProjectMemberProfileResponseCopyWithImpl<_ProjectMemberProfileResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectMemberProfileResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectMemberProfileResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,avatarUrl,isOnline,role);

@override
String toString() {
  return 'ProjectMemberProfileResponse(userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, isOnline: $isOnline, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ProjectMemberProfileResponseCopyWith<$Res> implements $ProjectMemberProfileResponseCopyWith<$Res> {
  factory _$ProjectMemberProfileResponseCopyWith(_ProjectMemberProfileResponse value, $Res Function(_ProjectMemberProfileResponse) _then) = __$ProjectMemberProfileResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? displayName, String? avatarUrl, bool? isOnline, ProjectRole role
});




}
/// @nodoc
class __$ProjectMemberProfileResponseCopyWithImpl<$Res>
    implements _$ProjectMemberProfileResponseCopyWith<$Res> {
  __$ProjectMemberProfileResponseCopyWithImpl(this._self, this._then);

  final _ProjectMemberProfileResponse _self;
  final $Res Function(_ProjectMemberProfileResponse) _then;

/// Create a copy of ProjectMemberProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? isOnline = freezed,Object? role = null,}) {
  return _then(_ProjectMemberProfileResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isOnline: freezed == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,
  ));
}


}

// dart format on
