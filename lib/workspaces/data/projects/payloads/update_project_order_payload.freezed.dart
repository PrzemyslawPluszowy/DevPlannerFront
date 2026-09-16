// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_project_order_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateProjectOrderPayload {

/// UUID-y wszystkich widocznych projektów w docelowej kolejności.
 List<String> get projectIds;
/// Create a copy of UpdateProjectOrderPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProjectOrderPayloadCopyWith<UpdateProjectOrderPayload> get copyWith => _$UpdateProjectOrderPayloadCopyWithImpl<UpdateProjectOrderPayload>(this as UpdateProjectOrderPayload, _$identity);

  /// Serializes this UpdateProjectOrderPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProjectOrderPayload&&const DeepCollectionEquality().equals(other.projectIds, projectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(projectIds));

@override
String toString() {
  return 'UpdateProjectOrderPayload(projectIds: $projectIds)';
}


}

/// @nodoc
abstract mixin class $UpdateProjectOrderPayloadCopyWith<$Res>  {
  factory $UpdateProjectOrderPayloadCopyWith(UpdateProjectOrderPayload value, $Res Function(UpdateProjectOrderPayload) _then) = _$UpdateProjectOrderPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> projectIds
});




}
/// @nodoc
class _$UpdateProjectOrderPayloadCopyWithImpl<$Res>
    implements $UpdateProjectOrderPayloadCopyWith<$Res> {
  _$UpdateProjectOrderPayloadCopyWithImpl(this._self, this._then);

  final UpdateProjectOrderPayload _self;
  final $Res Function(UpdateProjectOrderPayload) _then;

/// Create a copy of UpdateProjectOrderPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectIds = null,}) {
  return _then(_self.copyWith(
projectIds: null == projectIds ? _self.projectIds : projectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProjectOrderPayload].
extension UpdateProjectOrderPayloadPatterns on UpdateProjectOrderPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProjectOrderPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProjectOrderPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProjectOrderPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectOrderPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProjectOrderPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectOrderPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> projectIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProjectOrderPayload() when $default != null:
return $default(_that.projectIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> projectIds)  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectOrderPayload():
return $default(_that.projectIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> projectIds)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectOrderPayload() when $default != null:
return $default(_that.projectIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProjectOrderPayload implements UpdateProjectOrderPayload {
  const _UpdateProjectOrderPayload({required this.projectIds});
  factory _UpdateProjectOrderPayload.fromJson(Map<String, dynamic> json) => _$UpdateProjectOrderPayloadFromJson(json);

/// UUID-y wszystkich widocznych projektów w docelowej kolejności.
@override final  List<String> projectIds;

/// Create a copy of UpdateProjectOrderPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProjectOrderPayloadCopyWith<_UpdateProjectOrderPayload> get copyWith => __$UpdateProjectOrderPayloadCopyWithImpl<_UpdateProjectOrderPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProjectOrderPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProjectOrderPayload&&const DeepCollectionEquality().equals(other.projectIds, projectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(projectIds));

@override
String toString() {
  return 'UpdateProjectOrderPayload(projectIds: $projectIds)';
}


}

/// @nodoc
abstract mixin class _$UpdateProjectOrderPayloadCopyWith<$Res> implements $UpdateProjectOrderPayloadCopyWith<$Res> {
  factory _$UpdateProjectOrderPayloadCopyWith(_UpdateProjectOrderPayload value, $Res Function(_UpdateProjectOrderPayload) _then) = __$UpdateProjectOrderPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> projectIds
});




}
/// @nodoc
class __$UpdateProjectOrderPayloadCopyWithImpl<$Res>
    implements _$UpdateProjectOrderPayloadCopyWith<$Res> {
  __$UpdateProjectOrderPayloadCopyWithImpl(this._self, this._then);

  final _UpdateProjectOrderPayload _self;
  final $Res Function(_UpdateProjectOrderPayload) _then;

/// Create a copy of UpdateProjectOrderPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectIds = null,}) {
  return _then(_UpdateProjectOrderPayload(
projectIds: null == projectIds ? _self.projectIds : projectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
