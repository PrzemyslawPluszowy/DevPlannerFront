// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_project_member_role_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChangeProjectMemberRolePayload {

/// Nowa rola członka projektu.
 ProjectRole get role;
/// Create a copy of ChangeProjectMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeProjectMemberRolePayloadCopyWith<ChangeProjectMemberRolePayload> get copyWith => _$ChangeProjectMemberRolePayloadCopyWithImpl<ChangeProjectMemberRolePayload>(this as ChangeProjectMemberRolePayload, _$identity);

  /// Serializes this ChangeProjectMemberRolePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeProjectMemberRolePayload&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'ChangeProjectMemberRolePayload(role: $role)';
}


}

/// @nodoc
abstract mixin class $ChangeProjectMemberRolePayloadCopyWith<$Res>  {
  factory $ChangeProjectMemberRolePayloadCopyWith(ChangeProjectMemberRolePayload value, $Res Function(ChangeProjectMemberRolePayload) _then) = _$ChangeProjectMemberRolePayloadCopyWithImpl;
@useResult
$Res call({
 ProjectRole role
});




}
/// @nodoc
class _$ChangeProjectMemberRolePayloadCopyWithImpl<$Res>
    implements $ChangeProjectMemberRolePayloadCopyWith<$Res> {
  _$ChangeProjectMemberRolePayloadCopyWithImpl(this._self, this._then);

  final ChangeProjectMemberRolePayload _self;
  final $Res Function(ChangeProjectMemberRolePayload) _then;

/// Create a copy of ChangeProjectMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangeProjectMemberRolePayload].
extension ChangeProjectMemberRolePayloadPatterns on ChangeProjectMemberRolePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeProjectMemberRolePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeProjectMemberRolePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeProjectMemberRolePayload value)  $default,){
final _that = this;
switch (_that) {
case _ChangeProjectMemberRolePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeProjectMemberRolePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeProjectMemberRolePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeProjectMemberRolePayload() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectRole role)  $default,) {final _that = this;
switch (_that) {
case _ChangeProjectMemberRolePayload():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectRole role)?  $default,) {final _that = this;
switch (_that) {
case _ChangeProjectMemberRolePayload() when $default != null:
return $default(_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChangeProjectMemberRolePayload implements ChangeProjectMemberRolePayload {
  const _ChangeProjectMemberRolePayload({required this.role});
  factory _ChangeProjectMemberRolePayload.fromJson(Map<String, dynamic> json) => _$ChangeProjectMemberRolePayloadFromJson(json);

/// Nowa rola członka projektu.
@override final  ProjectRole role;

/// Create a copy of ChangeProjectMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeProjectMemberRolePayloadCopyWith<_ChangeProjectMemberRolePayload> get copyWith => __$ChangeProjectMemberRolePayloadCopyWithImpl<_ChangeProjectMemberRolePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangeProjectMemberRolePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeProjectMemberRolePayload&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'ChangeProjectMemberRolePayload(role: $role)';
}


}

/// @nodoc
abstract mixin class _$ChangeProjectMemberRolePayloadCopyWith<$Res> implements $ChangeProjectMemberRolePayloadCopyWith<$Res> {
  factory _$ChangeProjectMemberRolePayloadCopyWith(_ChangeProjectMemberRolePayload value, $Res Function(_ChangeProjectMemberRolePayload) _then) = __$ChangeProjectMemberRolePayloadCopyWithImpl;
@override @useResult
$Res call({
 ProjectRole role
});




}
/// @nodoc
class __$ChangeProjectMemberRolePayloadCopyWithImpl<$Res>
    implements _$ChangeProjectMemberRolePayloadCopyWith<$Res> {
  __$ChangeProjectMemberRolePayloadCopyWithImpl(this._self, this._then);

  final _ChangeProjectMemberRolePayload _self;
  final $Res Function(_ChangeProjectMemberRolePayload) _then;

/// Create a copy of ChangeProjectMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,}) {
  return _then(_ChangeProjectMemberRolePayload(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,
  ));
}


}

// dart format on
