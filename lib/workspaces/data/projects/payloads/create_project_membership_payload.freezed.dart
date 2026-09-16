// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_project_membership_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateProjectMembershipPayload {

/// UUID aktywnego członkostwa workspace dodawanej osoby.
 String get workspaceMembershipId;/// Rola nadawana w projekcie.
 ProjectRole get role;
/// Create a copy of CreateProjectMembershipPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProjectMembershipPayloadCopyWith<CreateProjectMembershipPayload> get copyWith => _$CreateProjectMembershipPayloadCopyWithImpl<CreateProjectMembershipPayload>(this as CreateProjectMembershipPayload, _$identity);

  /// Serializes this CreateProjectMembershipPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProjectMembershipPayload&&(identical(other.workspaceMembershipId, workspaceMembershipId) || other.workspaceMembershipId == workspaceMembershipId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceMembershipId,role);

@override
String toString() {
  return 'CreateProjectMembershipPayload(workspaceMembershipId: $workspaceMembershipId, role: $role)';
}


}

/// @nodoc
abstract mixin class $CreateProjectMembershipPayloadCopyWith<$Res>  {
  factory $CreateProjectMembershipPayloadCopyWith(CreateProjectMembershipPayload value, $Res Function(CreateProjectMembershipPayload) _then) = _$CreateProjectMembershipPayloadCopyWithImpl;
@useResult
$Res call({
 String workspaceMembershipId, ProjectRole role
});




}
/// @nodoc
class _$CreateProjectMembershipPayloadCopyWithImpl<$Res>
    implements $CreateProjectMembershipPayloadCopyWith<$Res> {
  _$CreateProjectMembershipPayloadCopyWithImpl(this._self, this._then);

  final CreateProjectMembershipPayload _self;
  final $Res Function(CreateProjectMembershipPayload) _then;

/// Create a copy of CreateProjectMembershipPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workspaceMembershipId = null,Object? role = null,}) {
  return _then(_self.copyWith(
workspaceMembershipId: null == workspaceMembershipId ? _self.workspaceMembershipId : workspaceMembershipId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProjectMembershipPayload].
extension CreateProjectMembershipPayloadPatterns on CreateProjectMembershipPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProjectMembershipPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProjectMembershipPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProjectMembershipPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateProjectMembershipPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProjectMembershipPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProjectMembershipPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workspaceMembershipId,  ProjectRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProjectMembershipPayload() when $default != null:
return $default(_that.workspaceMembershipId,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workspaceMembershipId,  ProjectRole role)  $default,) {final _that = this;
switch (_that) {
case _CreateProjectMembershipPayload():
return $default(_that.workspaceMembershipId,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workspaceMembershipId,  ProjectRole role)?  $default,) {final _that = this;
switch (_that) {
case _CreateProjectMembershipPayload() when $default != null:
return $default(_that.workspaceMembershipId,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProjectMembershipPayload implements CreateProjectMembershipPayload {
  const _CreateProjectMembershipPayload({required this.workspaceMembershipId, required this.role});
  factory _CreateProjectMembershipPayload.fromJson(Map<String, dynamic> json) => _$CreateProjectMembershipPayloadFromJson(json);

/// UUID aktywnego członkostwa workspace dodawanej osoby.
@override final  String workspaceMembershipId;
/// Rola nadawana w projekcie.
@override final  ProjectRole role;

/// Create a copy of CreateProjectMembershipPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProjectMembershipPayloadCopyWith<_CreateProjectMembershipPayload> get copyWith => __$CreateProjectMembershipPayloadCopyWithImpl<_CreateProjectMembershipPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProjectMembershipPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProjectMembershipPayload&&(identical(other.workspaceMembershipId, workspaceMembershipId) || other.workspaceMembershipId == workspaceMembershipId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceMembershipId,role);

@override
String toString() {
  return 'CreateProjectMembershipPayload(workspaceMembershipId: $workspaceMembershipId, role: $role)';
}


}

/// @nodoc
abstract mixin class _$CreateProjectMembershipPayloadCopyWith<$Res> implements $CreateProjectMembershipPayloadCopyWith<$Res> {
  factory _$CreateProjectMembershipPayloadCopyWith(_CreateProjectMembershipPayload value, $Res Function(_CreateProjectMembershipPayload) _then) = __$CreateProjectMembershipPayloadCopyWithImpl;
@override @useResult
$Res call({
 String workspaceMembershipId, ProjectRole role
});




}
/// @nodoc
class __$CreateProjectMembershipPayloadCopyWithImpl<$Res>
    implements _$CreateProjectMembershipPayloadCopyWith<$Res> {
  __$CreateProjectMembershipPayloadCopyWithImpl(this._self, this._then);

  final _CreateProjectMembershipPayload _self;
  final $Res Function(_CreateProjectMembershipPayload) _then;

/// Create a copy of CreateProjectMembershipPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workspaceMembershipId = null,Object? role = null,}) {
  return _then(_CreateProjectMembershipPayload(
workspaceMembershipId: null == workspaceMembershipId ? _self.workspaceMembershipId : workspaceMembershipId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,
  ));
}


}

// dart format on
