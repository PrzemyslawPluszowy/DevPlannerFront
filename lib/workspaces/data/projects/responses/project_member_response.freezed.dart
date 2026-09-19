// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_member_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectMemberResponse {

/// UUID członkostwa projektu.
 String get id;/// UUID członkostwa użytkownika w workspace.
 String get workspaceMembershipId;/// UUID lokalnego użytkownika.
 String get userId;/// Rola użytkownika w projekcie.
 ProjectRole get role;/// Czas utworzenia członkostwa.
 DateTime get createdAtUtc;/// Czas cofnięcia członkostwa albo null.
 DateTime? get revokedAtUtc;
/// Create a copy of ProjectMemberResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectMemberResponseCopyWith<ProjectMemberResponse> get copyWith => _$ProjectMemberResponseCopyWithImpl<ProjectMemberResponse>(this as ProjectMemberResponse, _$identity);

  /// Serializes this ProjectMemberResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectMemberResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceMembershipId, workspaceMembershipId) || other.workspaceMembershipId == workspaceMembershipId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.revokedAtUtc, revokedAtUtc) || other.revokedAtUtc == revokedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceMembershipId,userId,role,createdAtUtc,revokedAtUtc);

@override
String toString() {
  return 'ProjectMemberResponse(id: $id, workspaceMembershipId: $workspaceMembershipId, userId: $userId, role: $role, createdAtUtc: $createdAtUtc, revokedAtUtc: $revokedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ProjectMemberResponseCopyWith<$Res>  {
  factory $ProjectMemberResponseCopyWith(ProjectMemberResponse value, $Res Function(ProjectMemberResponse) _then) = _$ProjectMemberResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceMembershipId, String userId, ProjectRole role, DateTime createdAtUtc, DateTime? revokedAtUtc
});




}
/// @nodoc
class _$ProjectMemberResponseCopyWithImpl<$Res>
    implements $ProjectMemberResponseCopyWith<$Res> {
  _$ProjectMemberResponseCopyWithImpl(this._self, this._then);

  final ProjectMemberResponse _self;
  final $Res Function(ProjectMemberResponse) _then;

/// Create a copy of ProjectMemberResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceMembershipId = null,Object? userId = null,Object? role = null,Object? createdAtUtc = null,Object? revokedAtUtc = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceMembershipId: null == workspaceMembershipId ? _self.workspaceMembershipId : workspaceMembershipId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,revokedAtUtc: freezed == revokedAtUtc ? _self.revokedAtUtc : revokedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectMemberResponse].
extension ProjectMemberResponsePatterns on ProjectMemberResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectMemberResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectMemberResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectMemberResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectMemberResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectMemberResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectMemberResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceMembershipId,  String userId,  ProjectRole role,  DateTime createdAtUtc,  DateTime? revokedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectMemberResponse() when $default != null:
return $default(_that.id,_that.workspaceMembershipId,_that.userId,_that.role,_that.createdAtUtc,_that.revokedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceMembershipId,  String userId,  ProjectRole role,  DateTime createdAtUtc,  DateTime? revokedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ProjectMemberResponse():
return $default(_that.id,_that.workspaceMembershipId,_that.userId,_that.role,_that.createdAtUtc,_that.revokedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceMembershipId,  String userId,  ProjectRole role,  DateTime createdAtUtc,  DateTime? revokedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ProjectMemberResponse() when $default != null:
return $default(_that.id,_that.workspaceMembershipId,_that.userId,_that.role,_that.createdAtUtc,_that.revokedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectMemberResponse implements ProjectMemberResponse {
  const _ProjectMemberResponse({required this.id, required this.workspaceMembershipId, required this.userId, required this.role, required this.createdAtUtc, this.revokedAtUtc});
  factory _ProjectMemberResponse.fromJson(Map<String, dynamic> json) => _$ProjectMemberResponseFromJson(json);

/// UUID członkostwa projektu.
@override final  String id;
/// UUID członkostwa użytkownika w workspace.
@override final  String workspaceMembershipId;
/// UUID lokalnego użytkownika.
@override final  String userId;
/// Rola użytkownika w projekcie.
@override final  ProjectRole role;
/// Czas utworzenia członkostwa.
@override final  DateTime createdAtUtc;
/// Czas cofnięcia członkostwa albo null.
@override final  DateTime? revokedAtUtc;

/// Create a copy of ProjectMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectMemberResponseCopyWith<_ProjectMemberResponse> get copyWith => __$ProjectMemberResponseCopyWithImpl<_ProjectMemberResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectMemberResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectMemberResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceMembershipId, workspaceMembershipId) || other.workspaceMembershipId == workspaceMembershipId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.revokedAtUtc, revokedAtUtc) || other.revokedAtUtc == revokedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceMembershipId,userId,role,createdAtUtc,revokedAtUtc);

@override
String toString() {
  return 'ProjectMemberResponse(id: $id, workspaceMembershipId: $workspaceMembershipId, userId: $userId, role: $role, createdAtUtc: $createdAtUtc, revokedAtUtc: $revokedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ProjectMemberResponseCopyWith<$Res> implements $ProjectMemberResponseCopyWith<$Res> {
  factory _$ProjectMemberResponseCopyWith(_ProjectMemberResponse value, $Res Function(_ProjectMemberResponse) _then) = __$ProjectMemberResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceMembershipId, String userId, ProjectRole role, DateTime createdAtUtc, DateTime? revokedAtUtc
});




}
/// @nodoc
class __$ProjectMemberResponseCopyWithImpl<$Res>
    implements _$ProjectMemberResponseCopyWith<$Res> {
  __$ProjectMemberResponseCopyWithImpl(this._self, this._then);

  final _ProjectMemberResponse _self;
  final $Res Function(_ProjectMemberResponse) _then;

/// Create a copy of ProjectMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceMembershipId = null,Object? userId = null,Object? role = null,Object? createdAtUtc = null,Object? revokedAtUtc = freezed,}) {
  return _then(_ProjectMemberResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceMembershipId: null == workspaceMembershipId ? _self.workspaceMembershipId : workspaceMembershipId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,revokedAtUtc: freezed == revokedAtUtc ? _self.revokedAtUtc : revokedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
