// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_mutation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTaskDependencyPayload {

 String get targetTaskId; TaskDependencyType get type; int get expectedVersion; TaskDependencyKind get dependencyKind; int get lagDays;
/// Create a copy of CreateTaskDependencyPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskDependencyPayloadCopyWith<CreateTaskDependencyPayload> get copyWith => _$CreateTaskDependencyPayloadCopyWithImpl<CreateTaskDependencyPayload>(this as CreateTaskDependencyPayload, _$identity);

  /// Serializes this CreateTaskDependencyPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskDependencyPayload&&(identical(other.targetTaskId, targetTaskId) || other.targetTaskId == targetTaskId)&&(identical(other.type, type) || other.type == type)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.dependencyKind, dependencyKind) || other.dependencyKind == dependencyKind)&&(identical(other.lagDays, lagDays) || other.lagDays == lagDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetTaskId,type,expectedVersion,dependencyKind,lagDays);

@override
String toString() {
  return 'CreateTaskDependencyPayload(targetTaskId: $targetTaskId, type: $type, expectedVersion: $expectedVersion, dependencyKind: $dependencyKind, lagDays: $lagDays)';
}


}

/// @nodoc
abstract mixin class $CreateTaskDependencyPayloadCopyWith<$Res>  {
  factory $CreateTaskDependencyPayloadCopyWith(CreateTaskDependencyPayload value, $Res Function(CreateTaskDependencyPayload) _then) = _$CreateTaskDependencyPayloadCopyWithImpl;
@useResult
$Res call({
 String targetTaskId, TaskDependencyType type, int expectedVersion, TaskDependencyKind dependencyKind, int lagDays
});




}
/// @nodoc
class _$CreateTaskDependencyPayloadCopyWithImpl<$Res>
    implements $CreateTaskDependencyPayloadCopyWith<$Res> {
  _$CreateTaskDependencyPayloadCopyWithImpl(this._self, this._then);

  final CreateTaskDependencyPayload _self;
  final $Res Function(CreateTaskDependencyPayload) _then;

/// Create a copy of CreateTaskDependencyPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetTaskId = null,Object? type = null,Object? expectedVersion = null,Object? dependencyKind = null,Object? lagDays = null,}) {
  return _then(_self.copyWith(
targetTaskId: null == targetTaskId ? _self.targetTaskId : targetTaskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskDependencyType,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,dependencyKind: null == dependencyKind ? _self.dependencyKind : dependencyKind // ignore: cast_nullable_to_non_nullable
as TaskDependencyKind,lagDays: null == lagDays ? _self.lagDays : lagDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskDependencyPayload].
extension CreateTaskDependencyPayloadPatterns on CreateTaskDependencyPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskDependencyPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskDependencyPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskDependencyPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskDependencyPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskDependencyPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskDependencyPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String targetTaskId,  TaskDependencyType type,  int expectedVersion,  TaskDependencyKind dependencyKind,  int lagDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskDependencyPayload() when $default != null:
return $default(_that.targetTaskId,_that.type,_that.expectedVersion,_that.dependencyKind,_that.lagDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String targetTaskId,  TaskDependencyType type,  int expectedVersion,  TaskDependencyKind dependencyKind,  int lagDays)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskDependencyPayload():
return $default(_that.targetTaskId,_that.type,_that.expectedVersion,_that.dependencyKind,_that.lagDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String targetTaskId,  TaskDependencyType type,  int expectedVersion,  TaskDependencyKind dependencyKind,  int lagDays)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskDependencyPayload() when $default != null:
return $default(_that.targetTaskId,_that.type,_that.expectedVersion,_that.dependencyKind,_that.lagDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskDependencyPayload implements CreateTaskDependencyPayload {
  const _CreateTaskDependencyPayload({required this.targetTaskId, required this.type, required this.expectedVersion, this.dependencyKind = TaskDependencyKind.finishToStart, this.lagDays = 0});
  factory _CreateTaskDependencyPayload.fromJson(Map<String, dynamic> json) => _$CreateTaskDependencyPayloadFromJson(json);

@override final  String targetTaskId;
@override final  TaskDependencyType type;
@override final  int expectedVersion;
@override@JsonKey() final  TaskDependencyKind dependencyKind;
@override@JsonKey() final  int lagDays;

/// Create a copy of CreateTaskDependencyPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskDependencyPayloadCopyWith<_CreateTaskDependencyPayload> get copyWith => __$CreateTaskDependencyPayloadCopyWithImpl<_CreateTaskDependencyPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskDependencyPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskDependencyPayload&&(identical(other.targetTaskId, targetTaskId) || other.targetTaskId == targetTaskId)&&(identical(other.type, type) || other.type == type)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.dependencyKind, dependencyKind) || other.dependencyKind == dependencyKind)&&(identical(other.lagDays, lagDays) || other.lagDays == lagDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetTaskId,type,expectedVersion,dependencyKind,lagDays);

@override
String toString() {
  return 'CreateTaskDependencyPayload(targetTaskId: $targetTaskId, type: $type, expectedVersion: $expectedVersion, dependencyKind: $dependencyKind, lagDays: $lagDays)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskDependencyPayloadCopyWith<$Res> implements $CreateTaskDependencyPayloadCopyWith<$Res> {
  factory _$CreateTaskDependencyPayloadCopyWith(_CreateTaskDependencyPayload value, $Res Function(_CreateTaskDependencyPayload) _then) = __$CreateTaskDependencyPayloadCopyWithImpl;
@override @useResult
$Res call({
 String targetTaskId, TaskDependencyType type, int expectedVersion, TaskDependencyKind dependencyKind, int lagDays
});




}
/// @nodoc
class __$CreateTaskDependencyPayloadCopyWithImpl<$Res>
    implements _$CreateTaskDependencyPayloadCopyWith<$Res> {
  __$CreateTaskDependencyPayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskDependencyPayload _self;
  final $Res Function(_CreateTaskDependencyPayload) _then;

/// Create a copy of CreateTaskDependencyPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetTaskId = null,Object? type = null,Object? expectedVersion = null,Object? dependencyKind = null,Object? lagDays = null,}) {
  return _then(_CreateTaskDependencyPayload(
targetTaskId: null == targetTaskId ? _self.targetTaskId : targetTaskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskDependencyType,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,dependencyKind: null == dependencyKind ? _self.dependencyKind : dependencyKind // ignore: cast_nullable_to_non_nullable
as TaskDependencyKind,lagDays: null == lagDays ? _self.lagDays : lagDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskDependencyPayload {

 TaskDependencyKind get dependencyKind; int get lagDays; int get expectedVersion;
/// Create a copy of UpdateTaskDependencyPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskDependencyPayloadCopyWith<UpdateTaskDependencyPayload> get copyWith => _$UpdateTaskDependencyPayloadCopyWithImpl<UpdateTaskDependencyPayload>(this as UpdateTaskDependencyPayload, _$identity);

  /// Serializes this UpdateTaskDependencyPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskDependencyPayload&&(identical(other.dependencyKind, dependencyKind) || other.dependencyKind == dependencyKind)&&(identical(other.lagDays, lagDays) || other.lagDays == lagDays)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dependencyKind,lagDays,expectedVersion);

@override
String toString() {
  return 'UpdateTaskDependencyPayload(dependencyKind: $dependencyKind, lagDays: $lagDays, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskDependencyPayloadCopyWith<$Res>  {
  factory $UpdateTaskDependencyPayloadCopyWith(UpdateTaskDependencyPayload value, $Res Function(UpdateTaskDependencyPayload) _then) = _$UpdateTaskDependencyPayloadCopyWithImpl;
@useResult
$Res call({
 TaskDependencyKind dependencyKind, int lagDays, int expectedVersion
});




}
/// @nodoc
class _$UpdateTaskDependencyPayloadCopyWithImpl<$Res>
    implements $UpdateTaskDependencyPayloadCopyWith<$Res> {
  _$UpdateTaskDependencyPayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskDependencyPayload _self;
  final $Res Function(UpdateTaskDependencyPayload) _then;

/// Create a copy of UpdateTaskDependencyPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dependencyKind = null,Object? lagDays = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
dependencyKind: null == dependencyKind ? _self.dependencyKind : dependencyKind // ignore: cast_nullable_to_non_nullable
as TaskDependencyKind,lagDays: null == lagDays ? _self.lagDays : lagDays // ignore: cast_nullable_to_non_nullable
as int,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskDependencyPayload].
extension UpdateTaskDependencyPayloadPatterns on UpdateTaskDependencyPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskDependencyPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskDependencyPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskDependencyPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskDependencyPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskDependencyPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskDependencyPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskDependencyKind dependencyKind,  int lagDays,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskDependencyPayload() when $default != null:
return $default(_that.dependencyKind,_that.lagDays,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskDependencyKind dependencyKind,  int lagDays,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskDependencyPayload():
return $default(_that.dependencyKind,_that.lagDays,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskDependencyKind dependencyKind,  int lagDays,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskDependencyPayload() when $default != null:
return $default(_that.dependencyKind,_that.lagDays,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskDependencyPayload implements UpdateTaskDependencyPayload {
  const _UpdateTaskDependencyPayload({required this.dependencyKind, required this.lagDays, required this.expectedVersion});
  factory _UpdateTaskDependencyPayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskDependencyPayloadFromJson(json);

@override final  TaskDependencyKind dependencyKind;
@override final  int lagDays;
@override final  int expectedVersion;

/// Create a copy of UpdateTaskDependencyPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskDependencyPayloadCopyWith<_UpdateTaskDependencyPayload> get copyWith => __$UpdateTaskDependencyPayloadCopyWithImpl<_UpdateTaskDependencyPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskDependencyPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskDependencyPayload&&(identical(other.dependencyKind, dependencyKind) || other.dependencyKind == dependencyKind)&&(identical(other.lagDays, lagDays) || other.lagDays == lagDays)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dependencyKind,lagDays,expectedVersion);

@override
String toString() {
  return 'UpdateTaskDependencyPayload(dependencyKind: $dependencyKind, lagDays: $lagDays, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskDependencyPayloadCopyWith<$Res> implements $UpdateTaskDependencyPayloadCopyWith<$Res> {
  factory _$UpdateTaskDependencyPayloadCopyWith(_UpdateTaskDependencyPayload value, $Res Function(_UpdateTaskDependencyPayload) _then) = __$UpdateTaskDependencyPayloadCopyWithImpl;
@override @useResult
$Res call({
 TaskDependencyKind dependencyKind, int lagDays, int expectedVersion
});




}
/// @nodoc
class __$UpdateTaskDependencyPayloadCopyWithImpl<$Res>
    implements _$UpdateTaskDependencyPayloadCopyWith<$Res> {
  __$UpdateTaskDependencyPayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskDependencyPayload _self;
  final $Res Function(_UpdateTaskDependencyPayload) _then;

/// Create a copy of UpdateTaskDependencyPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dependencyKind = null,Object? lagDays = null,Object? expectedVersion = null,}) {
  return _then(_UpdateTaskDependencyPayload(
dependencyKind: null == dependencyKind ? _self.dependencyKind : dependencyKind // ignore: cast_nullable_to_non_nullable
as TaskDependencyKind,lagDays: null == lagDays ? _self.lagDays : lagDays // ignore: cast_nullable_to_non_nullable
as int,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskAssigneesPayload {

 List<String> get userIds; int get expectedVersion;
/// Create a copy of UpdateTaskAssigneesPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskAssigneesPayloadCopyWith<UpdateTaskAssigneesPayload> get copyWith => _$UpdateTaskAssigneesPayloadCopyWithImpl<UpdateTaskAssigneesPayload>(this as UpdateTaskAssigneesPayload, _$identity);

  /// Serializes this UpdateTaskAssigneesPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskAssigneesPayload&&const DeepCollectionEquality().equals(other.userIds, userIds)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(userIds),expectedVersion);

@override
String toString() {
  return 'UpdateTaskAssigneesPayload(userIds: $userIds, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskAssigneesPayloadCopyWith<$Res>  {
  factory $UpdateTaskAssigneesPayloadCopyWith(UpdateTaskAssigneesPayload value, $Res Function(UpdateTaskAssigneesPayload) _then) = _$UpdateTaskAssigneesPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> userIds, int expectedVersion
});




}
/// @nodoc
class _$UpdateTaskAssigneesPayloadCopyWithImpl<$Res>
    implements $UpdateTaskAssigneesPayloadCopyWith<$Res> {
  _$UpdateTaskAssigneesPayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskAssigneesPayload _self;
  final $Res Function(UpdateTaskAssigneesPayload) _then;

/// Create a copy of UpdateTaskAssigneesPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userIds = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
userIds: null == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskAssigneesPayload].
extension UpdateTaskAssigneesPayloadPatterns on UpdateTaskAssigneesPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskAssigneesPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskAssigneesPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskAssigneesPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskAssigneesPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskAssigneesPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskAssigneesPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> userIds,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskAssigneesPayload() when $default != null:
return $default(_that.userIds,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> userIds,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskAssigneesPayload():
return $default(_that.userIds,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> userIds,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskAssigneesPayload() when $default != null:
return $default(_that.userIds,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskAssigneesPayload implements UpdateTaskAssigneesPayload {
  const _UpdateTaskAssigneesPayload({required this.userIds, required this.expectedVersion});
  factory _UpdateTaskAssigneesPayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskAssigneesPayloadFromJson(json);

@override final  List<String> userIds;
@override final  int expectedVersion;

/// Create a copy of UpdateTaskAssigneesPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskAssigneesPayloadCopyWith<_UpdateTaskAssigneesPayload> get copyWith => __$UpdateTaskAssigneesPayloadCopyWithImpl<_UpdateTaskAssigneesPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskAssigneesPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskAssigneesPayload&&const DeepCollectionEquality().equals(other.userIds, userIds)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(userIds),expectedVersion);

@override
String toString() {
  return 'UpdateTaskAssigneesPayload(userIds: $userIds, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskAssigneesPayloadCopyWith<$Res> implements $UpdateTaskAssigneesPayloadCopyWith<$Res> {
  factory _$UpdateTaskAssigneesPayloadCopyWith(_UpdateTaskAssigneesPayload value, $Res Function(_UpdateTaskAssigneesPayload) _then) = __$UpdateTaskAssigneesPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> userIds, int expectedVersion
});




}
/// @nodoc
class __$UpdateTaskAssigneesPayloadCopyWithImpl<$Res>
    implements _$UpdateTaskAssigneesPayloadCopyWith<$Res> {
  __$UpdateTaskAssigneesPayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskAssigneesPayload _self;
  final $Res Function(_UpdateTaskAssigneesPayload) _then;

/// Create a copy of UpdateTaskAssigneesPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userIds = null,Object? expectedVersion = null,}) {
  return _then(_UpdateTaskAssigneesPayload(
userIds: null == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateTaskChecklistItemPayload {

 String get title; int get expectedVersion;
/// Create a copy of CreateTaskChecklistItemPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskChecklistItemPayloadCopyWith<CreateTaskChecklistItemPayload> get copyWith => _$CreateTaskChecklistItemPayloadCopyWithImpl<CreateTaskChecklistItemPayload>(this as CreateTaskChecklistItemPayload, _$identity);

  /// Serializes this CreateTaskChecklistItemPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskChecklistItemPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,expectedVersion);

@override
String toString() {
  return 'CreateTaskChecklistItemPayload(title: $title, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $CreateTaskChecklistItemPayloadCopyWith<$Res>  {
  factory $CreateTaskChecklistItemPayloadCopyWith(CreateTaskChecklistItemPayload value, $Res Function(CreateTaskChecklistItemPayload) _then) = _$CreateTaskChecklistItemPayloadCopyWithImpl;
@useResult
$Res call({
 String title, int expectedVersion
});




}
/// @nodoc
class _$CreateTaskChecklistItemPayloadCopyWithImpl<$Res>
    implements $CreateTaskChecklistItemPayloadCopyWith<$Res> {
  _$CreateTaskChecklistItemPayloadCopyWithImpl(this._self, this._then);

  final CreateTaskChecklistItemPayload _self;
  final $Res Function(CreateTaskChecklistItemPayload) _then;

/// Create a copy of CreateTaskChecklistItemPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskChecklistItemPayload].
extension CreateTaskChecklistItemPayloadPatterns on CreateTaskChecklistItemPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskChecklistItemPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskChecklistItemPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskChecklistItemPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskChecklistItemPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskChecklistItemPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskChecklistItemPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskChecklistItemPayload() when $default != null:
return $default(_that.title,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskChecklistItemPayload():
return $default(_that.title,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskChecklistItemPayload() when $default != null:
return $default(_that.title,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskChecklistItemPayload implements CreateTaskChecklistItemPayload {
  const _CreateTaskChecklistItemPayload({required this.title, required this.expectedVersion});
  factory _CreateTaskChecklistItemPayload.fromJson(Map<String, dynamic> json) => _$CreateTaskChecklistItemPayloadFromJson(json);

@override final  String title;
@override final  int expectedVersion;

/// Create a copy of CreateTaskChecklistItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskChecklistItemPayloadCopyWith<_CreateTaskChecklistItemPayload> get copyWith => __$CreateTaskChecklistItemPayloadCopyWithImpl<_CreateTaskChecklistItemPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskChecklistItemPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskChecklistItemPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,expectedVersion);

@override
String toString() {
  return 'CreateTaskChecklistItemPayload(title: $title, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskChecklistItemPayloadCopyWith<$Res> implements $CreateTaskChecklistItemPayloadCopyWith<$Res> {
  factory _$CreateTaskChecklistItemPayloadCopyWith(_CreateTaskChecklistItemPayload value, $Res Function(_CreateTaskChecklistItemPayload) _then) = __$CreateTaskChecklistItemPayloadCopyWithImpl;
@override @useResult
$Res call({
 String title, int expectedVersion
});




}
/// @nodoc
class __$CreateTaskChecklistItemPayloadCopyWithImpl<$Res>
    implements _$CreateTaskChecklistItemPayloadCopyWith<$Res> {
  __$CreateTaskChecklistItemPayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskChecklistItemPayload _self;
  final $Res Function(_CreateTaskChecklistItemPayload) _then;

/// Create a copy of CreateTaskChecklistItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? expectedVersion = null,}) {
  return _then(_CreateTaskChecklistItemPayload(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskChecklistItemPayload {

 String get title; int get position; bool get isCompleted; int get expectedVersion;
/// Create a copy of UpdateTaskChecklistItemPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskChecklistItemPayloadCopyWith<UpdateTaskChecklistItemPayload> get copyWith => _$UpdateTaskChecklistItemPayloadCopyWithImpl<UpdateTaskChecklistItemPayload>(this as UpdateTaskChecklistItemPayload, _$identity);

  /// Serializes this UpdateTaskChecklistItemPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskChecklistItemPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.position, position) || other.position == position)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,position,isCompleted,expectedVersion);

@override
String toString() {
  return 'UpdateTaskChecklistItemPayload(title: $title, position: $position, isCompleted: $isCompleted, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskChecklistItemPayloadCopyWith<$Res>  {
  factory $UpdateTaskChecklistItemPayloadCopyWith(UpdateTaskChecklistItemPayload value, $Res Function(UpdateTaskChecklistItemPayload) _then) = _$UpdateTaskChecklistItemPayloadCopyWithImpl;
@useResult
$Res call({
 String title, int position, bool isCompleted, int expectedVersion
});




}
/// @nodoc
class _$UpdateTaskChecklistItemPayloadCopyWithImpl<$Res>
    implements $UpdateTaskChecklistItemPayloadCopyWith<$Res> {
  _$UpdateTaskChecklistItemPayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskChecklistItemPayload _self;
  final $Res Function(UpdateTaskChecklistItemPayload) _then;

/// Create a copy of UpdateTaskChecklistItemPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? position = null,Object? isCompleted = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskChecklistItemPayload].
extension UpdateTaskChecklistItemPayloadPatterns on UpdateTaskChecklistItemPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskChecklistItemPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskChecklistItemPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskChecklistItemPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskChecklistItemPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskChecklistItemPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskChecklistItemPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int position,  bool isCompleted,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskChecklistItemPayload() when $default != null:
return $default(_that.title,_that.position,_that.isCompleted,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int position,  bool isCompleted,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskChecklistItemPayload():
return $default(_that.title,_that.position,_that.isCompleted,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int position,  bool isCompleted,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskChecklistItemPayload() when $default != null:
return $default(_that.title,_that.position,_that.isCompleted,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskChecklistItemPayload implements UpdateTaskChecklistItemPayload {
  const _UpdateTaskChecklistItemPayload({required this.title, required this.position, required this.isCompleted, required this.expectedVersion});
  factory _UpdateTaskChecklistItemPayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskChecklistItemPayloadFromJson(json);

@override final  String title;
@override final  int position;
@override final  bool isCompleted;
@override final  int expectedVersion;

/// Create a copy of UpdateTaskChecklistItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskChecklistItemPayloadCopyWith<_UpdateTaskChecklistItemPayload> get copyWith => __$UpdateTaskChecklistItemPayloadCopyWithImpl<_UpdateTaskChecklistItemPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskChecklistItemPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskChecklistItemPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.position, position) || other.position == position)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,position,isCompleted,expectedVersion);

@override
String toString() {
  return 'UpdateTaskChecklistItemPayload(title: $title, position: $position, isCompleted: $isCompleted, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskChecklistItemPayloadCopyWith<$Res> implements $UpdateTaskChecklistItemPayloadCopyWith<$Res> {
  factory _$UpdateTaskChecklistItemPayloadCopyWith(_UpdateTaskChecklistItemPayload value, $Res Function(_UpdateTaskChecklistItemPayload) _then) = __$UpdateTaskChecklistItemPayloadCopyWithImpl;
@override @useResult
$Res call({
 String title, int position, bool isCompleted, int expectedVersion
});




}
/// @nodoc
class __$UpdateTaskChecklistItemPayloadCopyWithImpl<$Res>
    implements _$UpdateTaskChecklistItemPayloadCopyWith<$Res> {
  __$UpdateTaskChecklistItemPayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskChecklistItemPayload _self;
  final $Res Function(_UpdateTaskChecklistItemPayload) _then;

/// Create a copy of UpdateTaskChecklistItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? position = null,Object? isCompleted = null,Object? expectedVersion = null,}) {
  return _then(_UpdateTaskChecklistItemPayload(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateTaskLabelPayload {

 String get name; String get color;
/// Create a copy of CreateTaskLabelPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskLabelPayloadCopyWith<CreateTaskLabelPayload> get copyWith => _$CreateTaskLabelPayloadCopyWithImpl<CreateTaskLabelPayload>(this as CreateTaskLabelPayload, _$identity);

  /// Serializes this CreateTaskLabelPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskLabelPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,color);

@override
String toString() {
  return 'CreateTaskLabelPayload(name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class $CreateTaskLabelPayloadCopyWith<$Res>  {
  factory $CreateTaskLabelPayloadCopyWith(CreateTaskLabelPayload value, $Res Function(CreateTaskLabelPayload) _then) = _$CreateTaskLabelPayloadCopyWithImpl;
@useResult
$Res call({
 String name, String color
});




}
/// @nodoc
class _$CreateTaskLabelPayloadCopyWithImpl<$Res>
    implements $CreateTaskLabelPayloadCopyWith<$Res> {
  _$CreateTaskLabelPayloadCopyWithImpl(this._self, this._then);

  final CreateTaskLabelPayload _self;
  final $Res Function(CreateTaskLabelPayload) _then;

/// Create a copy of CreateTaskLabelPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? color = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskLabelPayload].
extension CreateTaskLabelPayloadPatterns on CreateTaskLabelPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskLabelPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskLabelPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskLabelPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskLabelPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskLabelPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskLabelPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskLabelPayload() when $default != null:
return $default(_that.name,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String color)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskLabelPayload():
return $default(_that.name,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String color)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskLabelPayload() when $default != null:
return $default(_that.name,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskLabelPayload implements CreateTaskLabelPayload {
  const _CreateTaskLabelPayload({required this.name, required this.color});
  factory _CreateTaskLabelPayload.fromJson(Map<String, dynamic> json) => _$CreateTaskLabelPayloadFromJson(json);

@override final  String name;
@override final  String color;

/// Create a copy of CreateTaskLabelPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskLabelPayloadCopyWith<_CreateTaskLabelPayload> get copyWith => __$CreateTaskLabelPayloadCopyWithImpl<_CreateTaskLabelPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskLabelPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskLabelPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,color);

@override
String toString() {
  return 'CreateTaskLabelPayload(name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskLabelPayloadCopyWith<$Res> implements $CreateTaskLabelPayloadCopyWith<$Res> {
  factory _$CreateTaskLabelPayloadCopyWith(_CreateTaskLabelPayload value, $Res Function(_CreateTaskLabelPayload) _then) = __$CreateTaskLabelPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String color
});




}
/// @nodoc
class __$CreateTaskLabelPayloadCopyWithImpl<$Res>
    implements _$CreateTaskLabelPayloadCopyWith<$Res> {
  __$CreateTaskLabelPayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskLabelPayload _self;
  final $Res Function(_CreateTaskLabelPayload) _then;

/// Create a copy of CreateTaskLabelPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? color = null,}) {
  return _then(_CreateTaskLabelPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskLabelPayload {

 String get name; String get color;
/// Create a copy of UpdateTaskLabelPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskLabelPayloadCopyWith<UpdateTaskLabelPayload> get copyWith => _$UpdateTaskLabelPayloadCopyWithImpl<UpdateTaskLabelPayload>(this as UpdateTaskLabelPayload, _$identity);

  /// Serializes this UpdateTaskLabelPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskLabelPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,color);

@override
String toString() {
  return 'UpdateTaskLabelPayload(name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskLabelPayloadCopyWith<$Res>  {
  factory $UpdateTaskLabelPayloadCopyWith(UpdateTaskLabelPayload value, $Res Function(UpdateTaskLabelPayload) _then) = _$UpdateTaskLabelPayloadCopyWithImpl;
@useResult
$Res call({
 String name, String color
});




}
/// @nodoc
class _$UpdateTaskLabelPayloadCopyWithImpl<$Res>
    implements $UpdateTaskLabelPayloadCopyWith<$Res> {
  _$UpdateTaskLabelPayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskLabelPayload _self;
  final $Res Function(UpdateTaskLabelPayload) _then;

/// Create a copy of UpdateTaskLabelPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? color = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskLabelPayload].
extension UpdateTaskLabelPayloadPatterns on UpdateTaskLabelPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskLabelPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskLabelPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskLabelPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskLabelPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskLabelPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskLabelPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskLabelPayload() when $default != null:
return $default(_that.name,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String color)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskLabelPayload():
return $default(_that.name,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String color)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskLabelPayload() when $default != null:
return $default(_that.name,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskLabelPayload implements UpdateTaskLabelPayload {
  const _UpdateTaskLabelPayload({required this.name, required this.color});
  factory _UpdateTaskLabelPayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskLabelPayloadFromJson(json);

@override final  String name;
@override final  String color;

/// Create a copy of UpdateTaskLabelPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskLabelPayloadCopyWith<_UpdateTaskLabelPayload> get copyWith => __$UpdateTaskLabelPayloadCopyWithImpl<_UpdateTaskLabelPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskLabelPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskLabelPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,color);

@override
String toString() {
  return 'UpdateTaskLabelPayload(name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskLabelPayloadCopyWith<$Res> implements $UpdateTaskLabelPayloadCopyWith<$Res> {
  factory _$UpdateTaskLabelPayloadCopyWith(_UpdateTaskLabelPayload value, $Res Function(_UpdateTaskLabelPayload) _then) = __$UpdateTaskLabelPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String color
});




}
/// @nodoc
class __$UpdateTaskLabelPayloadCopyWithImpl<$Res>
    implements _$UpdateTaskLabelPayloadCopyWith<$Res> {
  __$UpdateTaskLabelPayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskLabelPayload _self;
  final $Res Function(_UpdateTaskLabelPayload) _then;

/// Create a copy of UpdateTaskLabelPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? color = null,}) {
  return _then(_UpdateTaskLabelPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReplaceTaskLabelsPayload {

 List<String> get labelIds; int get expectedVersion;
/// Create a copy of ReplaceTaskLabelsPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplaceTaskLabelsPayloadCopyWith<ReplaceTaskLabelsPayload> get copyWith => _$ReplaceTaskLabelsPayloadCopyWithImpl<ReplaceTaskLabelsPayload>(this as ReplaceTaskLabelsPayload, _$identity);

  /// Serializes this ReplaceTaskLabelsPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplaceTaskLabelsPayload&&const DeepCollectionEquality().equals(other.labelIds, labelIds)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(labelIds),expectedVersion);

@override
String toString() {
  return 'ReplaceTaskLabelsPayload(labelIds: $labelIds, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $ReplaceTaskLabelsPayloadCopyWith<$Res>  {
  factory $ReplaceTaskLabelsPayloadCopyWith(ReplaceTaskLabelsPayload value, $Res Function(ReplaceTaskLabelsPayload) _then) = _$ReplaceTaskLabelsPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> labelIds, int expectedVersion
});




}
/// @nodoc
class _$ReplaceTaskLabelsPayloadCopyWithImpl<$Res>
    implements $ReplaceTaskLabelsPayloadCopyWith<$Res> {
  _$ReplaceTaskLabelsPayloadCopyWithImpl(this._self, this._then);

  final ReplaceTaskLabelsPayload _self;
  final $Res Function(ReplaceTaskLabelsPayload) _then;

/// Create a copy of ReplaceTaskLabelsPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? labelIds = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
labelIds: null == labelIds ? _self.labelIds : labelIds // ignore: cast_nullable_to_non_nullable
as List<String>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReplaceTaskLabelsPayload].
extension ReplaceTaskLabelsPayloadPatterns on ReplaceTaskLabelsPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReplaceTaskLabelsPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReplaceTaskLabelsPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReplaceTaskLabelsPayload value)  $default,){
final _that = this;
switch (_that) {
case _ReplaceTaskLabelsPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReplaceTaskLabelsPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ReplaceTaskLabelsPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> labelIds,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReplaceTaskLabelsPayload() when $default != null:
return $default(_that.labelIds,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> labelIds,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _ReplaceTaskLabelsPayload():
return $default(_that.labelIds,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> labelIds,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _ReplaceTaskLabelsPayload() when $default != null:
return $default(_that.labelIds,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReplaceTaskLabelsPayload implements ReplaceTaskLabelsPayload {
  const _ReplaceTaskLabelsPayload({required this.labelIds, required this.expectedVersion});
  factory _ReplaceTaskLabelsPayload.fromJson(Map<String, dynamic> json) => _$ReplaceTaskLabelsPayloadFromJson(json);

@override final  List<String> labelIds;
@override final  int expectedVersion;

/// Create a copy of ReplaceTaskLabelsPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplaceTaskLabelsPayloadCopyWith<_ReplaceTaskLabelsPayload> get copyWith => __$ReplaceTaskLabelsPayloadCopyWithImpl<_ReplaceTaskLabelsPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReplaceTaskLabelsPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplaceTaskLabelsPayload&&const DeepCollectionEquality().equals(other.labelIds, labelIds)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(labelIds),expectedVersion);

@override
String toString() {
  return 'ReplaceTaskLabelsPayload(labelIds: $labelIds, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$ReplaceTaskLabelsPayloadCopyWith<$Res> implements $ReplaceTaskLabelsPayloadCopyWith<$Res> {
  factory _$ReplaceTaskLabelsPayloadCopyWith(_ReplaceTaskLabelsPayload value, $Res Function(_ReplaceTaskLabelsPayload) _then) = __$ReplaceTaskLabelsPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> labelIds, int expectedVersion
});




}
/// @nodoc
class __$ReplaceTaskLabelsPayloadCopyWithImpl<$Res>
    implements _$ReplaceTaskLabelsPayloadCopyWith<$Res> {
  __$ReplaceTaskLabelsPayloadCopyWithImpl(this._self, this._then);

  final _ReplaceTaskLabelsPayload _self;
  final $Res Function(_ReplaceTaskLabelsPayload) _then;

/// Create a copy of ReplaceTaskLabelsPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? labelIds = null,Object? expectedVersion = null,}) {
  return _then(_ReplaceTaskLabelsPayload(
labelIds: null == labelIds ? _self.labelIds : labelIds // ignore: cast_nullable_to_non_nullable
as List<String>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateTaskCustomFieldPayload {

 String get name; TaskCustomFieldType get type;@JsonKey(name: 'required') bool get isRequired; int get position; List<String>? get options;
/// Create a copy of CreateTaskCustomFieldPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskCustomFieldPayloadCopyWith<CreateTaskCustomFieldPayload> get copyWith => _$CreateTaskCustomFieldPayloadCopyWithImpl<CreateTaskCustomFieldPayload>(this as CreateTaskCustomFieldPayload, _$identity);

  /// Serializes this CreateTaskCustomFieldPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskCustomFieldPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,isRequired,position,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'CreateTaskCustomFieldPayload(name: $name, type: $type, isRequired: $isRequired, position: $position, options: $options)';
}


}

/// @nodoc
abstract mixin class $CreateTaskCustomFieldPayloadCopyWith<$Res>  {
  factory $CreateTaskCustomFieldPayloadCopyWith(CreateTaskCustomFieldPayload value, $Res Function(CreateTaskCustomFieldPayload) _then) = _$CreateTaskCustomFieldPayloadCopyWithImpl;
@useResult
$Res call({
 String name, TaskCustomFieldType type,@JsonKey(name: 'required') bool isRequired, int position, List<String>? options
});




}
/// @nodoc
class _$CreateTaskCustomFieldPayloadCopyWithImpl<$Res>
    implements $CreateTaskCustomFieldPayloadCopyWith<$Res> {
  _$CreateTaskCustomFieldPayloadCopyWithImpl(this._self, this._then);

  final CreateTaskCustomFieldPayload _self;
  final $Res Function(CreateTaskCustomFieldPayload) _then;

/// Create a copy of CreateTaskCustomFieldPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? isRequired = null,Object? position = null,Object? options = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskCustomFieldType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskCustomFieldPayload].
extension CreateTaskCustomFieldPayloadPatterns on CreateTaskCustomFieldPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskCustomFieldPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskCustomFieldPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskCustomFieldPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskCustomFieldPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskCustomFieldPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskCustomFieldPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  TaskCustomFieldType type, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskCustomFieldPayload() when $default != null:
return $default(_that.name,_that.type,_that.isRequired,_that.position,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  TaskCustomFieldType type, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskCustomFieldPayload():
return $default(_that.name,_that.type,_that.isRequired,_that.position,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  TaskCustomFieldType type, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskCustomFieldPayload() when $default != null:
return $default(_that.name,_that.type,_that.isRequired,_that.position,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskCustomFieldPayload implements CreateTaskCustomFieldPayload {
  const _CreateTaskCustomFieldPayload({required this.name, required this.type, @JsonKey(name: 'required') required this.isRequired, required this.position, this.options});
  factory _CreateTaskCustomFieldPayload.fromJson(Map<String, dynamic> json) => _$CreateTaskCustomFieldPayloadFromJson(json);

@override final  String name;
@override final  TaskCustomFieldType type;
@override@JsonKey(name: 'required') final  bool isRequired;
@override final  int position;
@override final  List<String>? options;

/// Create a copy of CreateTaskCustomFieldPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskCustomFieldPayloadCopyWith<_CreateTaskCustomFieldPayload> get copyWith => __$CreateTaskCustomFieldPayloadCopyWithImpl<_CreateTaskCustomFieldPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskCustomFieldPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskCustomFieldPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,isRequired,position,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'CreateTaskCustomFieldPayload(name: $name, type: $type, isRequired: $isRequired, position: $position, options: $options)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskCustomFieldPayloadCopyWith<$Res> implements $CreateTaskCustomFieldPayloadCopyWith<$Res> {
  factory _$CreateTaskCustomFieldPayloadCopyWith(_CreateTaskCustomFieldPayload value, $Res Function(_CreateTaskCustomFieldPayload) _then) = __$CreateTaskCustomFieldPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, TaskCustomFieldType type,@JsonKey(name: 'required') bool isRequired, int position, List<String>? options
});




}
/// @nodoc
class __$CreateTaskCustomFieldPayloadCopyWithImpl<$Res>
    implements _$CreateTaskCustomFieldPayloadCopyWith<$Res> {
  __$CreateTaskCustomFieldPayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskCustomFieldPayload _self;
  final $Res Function(_CreateTaskCustomFieldPayload) _then;

/// Create a copy of CreateTaskCustomFieldPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? isRequired = null,Object? position = null,Object? options = freezed,}) {
  return _then(_CreateTaskCustomFieldPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskCustomFieldType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskCustomFieldPayload {

 String get name;@JsonKey(name: 'required') bool get isRequired; int get position; List<String>? get options;
/// Create a copy of UpdateTaskCustomFieldPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskCustomFieldPayloadCopyWith<UpdateTaskCustomFieldPayload> get copyWith => _$UpdateTaskCustomFieldPayloadCopyWithImpl<UpdateTaskCustomFieldPayload>(this as UpdateTaskCustomFieldPayload, _$identity);

  /// Serializes this UpdateTaskCustomFieldPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskCustomFieldPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,isRequired,position,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'UpdateTaskCustomFieldPayload(name: $name, isRequired: $isRequired, position: $position, options: $options)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskCustomFieldPayloadCopyWith<$Res>  {
  factory $UpdateTaskCustomFieldPayloadCopyWith(UpdateTaskCustomFieldPayload value, $Res Function(UpdateTaskCustomFieldPayload) _then) = _$UpdateTaskCustomFieldPayloadCopyWithImpl;
@useResult
$Res call({
 String name,@JsonKey(name: 'required') bool isRequired, int position, List<String>? options
});




}
/// @nodoc
class _$UpdateTaskCustomFieldPayloadCopyWithImpl<$Res>
    implements $UpdateTaskCustomFieldPayloadCopyWith<$Res> {
  _$UpdateTaskCustomFieldPayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskCustomFieldPayload _self;
  final $Res Function(UpdateTaskCustomFieldPayload) _then;

/// Create a copy of UpdateTaskCustomFieldPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? isRequired = null,Object? position = null,Object? options = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskCustomFieldPayload].
extension UpdateTaskCustomFieldPayloadPatterns on UpdateTaskCustomFieldPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskCustomFieldPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskCustomFieldPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskCustomFieldPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskCustomFieldPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskCustomFieldPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskCustomFieldPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskCustomFieldPayload() when $default != null:
return $default(_that.name,_that.isRequired,_that.position,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskCustomFieldPayload():
return $default(_that.name,_that.isRequired,_that.position,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskCustomFieldPayload() when $default != null:
return $default(_that.name,_that.isRequired,_that.position,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskCustomFieldPayload implements UpdateTaskCustomFieldPayload {
  const _UpdateTaskCustomFieldPayload({required this.name, @JsonKey(name: 'required') required this.isRequired, required this.position, this.options});
  factory _UpdateTaskCustomFieldPayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskCustomFieldPayloadFromJson(json);

@override final  String name;
@override@JsonKey(name: 'required') final  bool isRequired;
@override final  int position;
@override final  List<String>? options;

/// Create a copy of UpdateTaskCustomFieldPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskCustomFieldPayloadCopyWith<_UpdateTaskCustomFieldPayload> get copyWith => __$UpdateTaskCustomFieldPayloadCopyWithImpl<_UpdateTaskCustomFieldPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskCustomFieldPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskCustomFieldPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,isRequired,position,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'UpdateTaskCustomFieldPayload(name: $name, isRequired: $isRequired, position: $position, options: $options)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskCustomFieldPayloadCopyWith<$Res> implements $UpdateTaskCustomFieldPayloadCopyWith<$Res> {
  factory _$UpdateTaskCustomFieldPayloadCopyWith(_UpdateTaskCustomFieldPayload value, $Res Function(_UpdateTaskCustomFieldPayload) _then) = __$UpdateTaskCustomFieldPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name,@JsonKey(name: 'required') bool isRequired, int position, List<String>? options
});




}
/// @nodoc
class __$UpdateTaskCustomFieldPayloadCopyWithImpl<$Res>
    implements _$UpdateTaskCustomFieldPayloadCopyWith<$Res> {
  __$UpdateTaskCustomFieldPayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskCustomFieldPayload _self;
  final $Res Function(_UpdateTaskCustomFieldPayload) _then;

/// Create a copy of UpdateTaskCustomFieldPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? isRequired = null,Object? position = null,Object? options = freezed,}) {
  return _then(_UpdateTaskCustomFieldPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$TaskCustomFieldResponse {

 String get id; String get name; TaskCustomFieldType get type;@JsonKey(name: 'required') bool get isRequired; int get position; List<String>? get options;
/// Create a copy of TaskCustomFieldResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCustomFieldResponseCopyWith<TaskCustomFieldResponse> get copyWith => _$TaskCustomFieldResponseCopyWithImpl<TaskCustomFieldResponse>(this as TaskCustomFieldResponse, _$identity);

  /// Serializes this TaskCustomFieldResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskCustomFieldResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,isRequired,position,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'TaskCustomFieldResponse(id: $id, name: $name, type: $type, isRequired: $isRequired, position: $position, options: $options)';
}


}

/// @nodoc
abstract mixin class $TaskCustomFieldResponseCopyWith<$Res>  {
  factory $TaskCustomFieldResponseCopyWith(TaskCustomFieldResponse value, $Res Function(TaskCustomFieldResponse) _then) = _$TaskCustomFieldResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, TaskCustomFieldType type,@JsonKey(name: 'required') bool isRequired, int position, List<String>? options
});




}
/// @nodoc
class _$TaskCustomFieldResponseCopyWithImpl<$Res>
    implements $TaskCustomFieldResponseCopyWith<$Res> {
  _$TaskCustomFieldResponseCopyWithImpl(this._self, this._then);

  final TaskCustomFieldResponse _self;
  final $Res Function(TaskCustomFieldResponse) _then;

/// Create a copy of TaskCustomFieldResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? isRequired = null,Object? position = null,Object? options = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskCustomFieldType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskCustomFieldResponse].
extension TaskCustomFieldResponsePatterns on TaskCustomFieldResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskCustomFieldResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskCustomFieldResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskCustomFieldResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskCustomFieldResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskCustomFieldResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskCustomFieldResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  TaskCustomFieldType type, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskCustomFieldResponse() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isRequired,_that.position,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  TaskCustomFieldType type, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options)  $default,) {final _that = this;
switch (_that) {
case _TaskCustomFieldResponse():
return $default(_that.id,_that.name,_that.type,_that.isRequired,_that.position,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  TaskCustomFieldType type, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options)?  $default,) {final _that = this;
switch (_that) {
case _TaskCustomFieldResponse() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isRequired,_that.position,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskCustomFieldResponse implements TaskCustomFieldResponse {
  const _TaskCustomFieldResponse({required this.id, required this.name, required this.type, @JsonKey(name: 'required') required this.isRequired, required this.position, this.options});
  factory _TaskCustomFieldResponse.fromJson(Map<String, dynamic> json) => _$TaskCustomFieldResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  TaskCustomFieldType type;
@override@JsonKey(name: 'required') final  bool isRequired;
@override final  int position;
@override final  List<String>? options;

/// Create a copy of TaskCustomFieldResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCustomFieldResponseCopyWith<_TaskCustomFieldResponse> get copyWith => __$TaskCustomFieldResponseCopyWithImpl<_TaskCustomFieldResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskCustomFieldResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskCustomFieldResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,isRequired,position,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'TaskCustomFieldResponse(id: $id, name: $name, type: $type, isRequired: $isRequired, position: $position, options: $options)';
}


}

/// @nodoc
abstract mixin class _$TaskCustomFieldResponseCopyWith<$Res> implements $TaskCustomFieldResponseCopyWith<$Res> {
  factory _$TaskCustomFieldResponseCopyWith(_TaskCustomFieldResponse value, $Res Function(_TaskCustomFieldResponse) _then) = __$TaskCustomFieldResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, TaskCustomFieldType type,@JsonKey(name: 'required') bool isRequired, int position, List<String>? options
});




}
/// @nodoc
class __$TaskCustomFieldResponseCopyWithImpl<$Res>
    implements _$TaskCustomFieldResponseCopyWith<$Res> {
  __$TaskCustomFieldResponseCopyWithImpl(this._self, this._then);

  final _TaskCustomFieldResponse _self;
  final $Res Function(_TaskCustomFieldResponse) _then;

/// Create a copy of TaskCustomFieldResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? isRequired = null,Object? position = null,Object? options = freezed,}) {
  return _then(_TaskCustomFieldResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskCustomFieldType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$ReplaceTaskCustomFieldValuesPayload {

 Map<String, dynamic> get values; int get expectedVersion;
/// Create a copy of ReplaceTaskCustomFieldValuesPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplaceTaskCustomFieldValuesPayloadCopyWith<ReplaceTaskCustomFieldValuesPayload> get copyWith => _$ReplaceTaskCustomFieldValuesPayloadCopyWithImpl<ReplaceTaskCustomFieldValuesPayload>(this as ReplaceTaskCustomFieldValuesPayload, _$identity);

  /// Serializes this ReplaceTaskCustomFieldValuesPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplaceTaskCustomFieldValuesPayload&&const DeepCollectionEquality().equals(other.values, values)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(values),expectedVersion);

@override
String toString() {
  return 'ReplaceTaskCustomFieldValuesPayload(values: $values, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $ReplaceTaskCustomFieldValuesPayloadCopyWith<$Res>  {
  factory $ReplaceTaskCustomFieldValuesPayloadCopyWith(ReplaceTaskCustomFieldValuesPayload value, $Res Function(ReplaceTaskCustomFieldValuesPayload) _then) = _$ReplaceTaskCustomFieldValuesPayloadCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> values, int expectedVersion
});




}
/// @nodoc
class _$ReplaceTaskCustomFieldValuesPayloadCopyWithImpl<$Res>
    implements $ReplaceTaskCustomFieldValuesPayloadCopyWith<$Res> {
  _$ReplaceTaskCustomFieldValuesPayloadCopyWithImpl(this._self, this._then);

  final ReplaceTaskCustomFieldValuesPayload _self;
  final $Res Function(ReplaceTaskCustomFieldValuesPayload) _then;

/// Create a copy of ReplaceTaskCustomFieldValuesPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? values = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReplaceTaskCustomFieldValuesPayload].
extension ReplaceTaskCustomFieldValuesPayloadPatterns on ReplaceTaskCustomFieldValuesPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReplaceTaskCustomFieldValuesPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReplaceTaskCustomFieldValuesPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReplaceTaskCustomFieldValuesPayload value)  $default,){
final _that = this;
switch (_that) {
case _ReplaceTaskCustomFieldValuesPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReplaceTaskCustomFieldValuesPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ReplaceTaskCustomFieldValuesPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> values,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReplaceTaskCustomFieldValuesPayload() when $default != null:
return $default(_that.values,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> values,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _ReplaceTaskCustomFieldValuesPayload():
return $default(_that.values,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> values,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _ReplaceTaskCustomFieldValuesPayload() when $default != null:
return $default(_that.values,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReplaceTaskCustomFieldValuesPayload implements ReplaceTaskCustomFieldValuesPayload {
  const _ReplaceTaskCustomFieldValuesPayload({required this.values, required this.expectedVersion});
  factory _ReplaceTaskCustomFieldValuesPayload.fromJson(Map<String, dynamic> json) => _$ReplaceTaskCustomFieldValuesPayloadFromJson(json);

@override final  Map<String, dynamic> values;
@override final  int expectedVersion;

/// Create a copy of ReplaceTaskCustomFieldValuesPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplaceTaskCustomFieldValuesPayloadCopyWith<_ReplaceTaskCustomFieldValuesPayload> get copyWith => __$ReplaceTaskCustomFieldValuesPayloadCopyWithImpl<_ReplaceTaskCustomFieldValuesPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReplaceTaskCustomFieldValuesPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplaceTaskCustomFieldValuesPayload&&const DeepCollectionEquality().equals(other.values, values)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(values),expectedVersion);

@override
String toString() {
  return 'ReplaceTaskCustomFieldValuesPayload(values: $values, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$ReplaceTaskCustomFieldValuesPayloadCopyWith<$Res> implements $ReplaceTaskCustomFieldValuesPayloadCopyWith<$Res> {
  factory _$ReplaceTaskCustomFieldValuesPayloadCopyWith(_ReplaceTaskCustomFieldValuesPayload value, $Res Function(_ReplaceTaskCustomFieldValuesPayload) _then) = __$ReplaceTaskCustomFieldValuesPayloadCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> values, int expectedVersion
});




}
/// @nodoc
class __$ReplaceTaskCustomFieldValuesPayloadCopyWithImpl<$Res>
    implements _$ReplaceTaskCustomFieldValuesPayloadCopyWith<$Res> {
  __$ReplaceTaskCustomFieldValuesPayloadCopyWithImpl(this._self, this._then);

  final _ReplaceTaskCustomFieldValuesPayload _self;
  final $Res Function(_ReplaceTaskCustomFieldValuesPayload) _then;

/// Create a copy of ReplaceTaskCustomFieldValuesPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? values = null,Object? expectedVersion = null,}) {
  return _then(_ReplaceTaskCustomFieldValuesPayload(
values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TaskCustomFieldValueResponse {

 String get fieldId; Object? get value; DateTime get updatedAtUtc;
/// Create a copy of TaskCustomFieldValueResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCustomFieldValueResponseCopyWith<TaskCustomFieldValueResponse> get copyWith => _$TaskCustomFieldValueResponseCopyWithImpl<TaskCustomFieldValueResponse>(this as TaskCustomFieldValueResponse, _$identity);

  /// Serializes this TaskCustomFieldValueResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskCustomFieldValueResponse&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldId,const DeepCollectionEquality().hash(value),updatedAtUtc);

@override
String toString() {
  return 'TaskCustomFieldValueResponse(fieldId: $fieldId, value: $value, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskCustomFieldValueResponseCopyWith<$Res>  {
  factory $TaskCustomFieldValueResponseCopyWith(TaskCustomFieldValueResponse value, $Res Function(TaskCustomFieldValueResponse) _then) = _$TaskCustomFieldValueResponseCopyWithImpl;
@useResult
$Res call({
 String fieldId, Object? value, DateTime updatedAtUtc
});




}
/// @nodoc
class _$TaskCustomFieldValueResponseCopyWithImpl<$Res>
    implements $TaskCustomFieldValueResponseCopyWith<$Res> {
  _$TaskCustomFieldValueResponseCopyWithImpl(this._self, this._then);

  final TaskCustomFieldValueResponse _self;
  final $Res Function(TaskCustomFieldValueResponse) _then;

/// Create a copy of TaskCustomFieldValueResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fieldId = null,Object? value = freezed,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
fieldId: null == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value ,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskCustomFieldValueResponse].
extension TaskCustomFieldValueResponsePatterns on TaskCustomFieldValueResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskCustomFieldValueResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskCustomFieldValueResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskCustomFieldValueResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskCustomFieldValueResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskCustomFieldValueResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskCustomFieldValueResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fieldId,  Object? value,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskCustomFieldValueResponse() when $default != null:
return $default(_that.fieldId,_that.value,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fieldId,  Object? value,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskCustomFieldValueResponse():
return $default(_that.fieldId,_that.value,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fieldId,  Object? value,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskCustomFieldValueResponse() when $default != null:
return $default(_that.fieldId,_that.value,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskCustomFieldValueResponse implements TaskCustomFieldValueResponse {
  const _TaskCustomFieldValueResponse({required this.fieldId, required this.value, required this.updatedAtUtc});
  factory _TaskCustomFieldValueResponse.fromJson(Map<String, dynamic> json) => _$TaskCustomFieldValueResponseFromJson(json);

@override final  String fieldId;
@override final  Object? value;
@override final  DateTime updatedAtUtc;

/// Create a copy of TaskCustomFieldValueResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCustomFieldValueResponseCopyWith<_TaskCustomFieldValueResponse> get copyWith => __$TaskCustomFieldValueResponseCopyWithImpl<_TaskCustomFieldValueResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskCustomFieldValueResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskCustomFieldValueResponse&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldId,const DeepCollectionEquality().hash(value),updatedAtUtc);

@override
String toString() {
  return 'TaskCustomFieldValueResponse(fieldId: $fieldId, value: $value, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskCustomFieldValueResponseCopyWith<$Res> implements $TaskCustomFieldValueResponseCopyWith<$Res> {
  factory _$TaskCustomFieldValueResponseCopyWith(_TaskCustomFieldValueResponse value, $Res Function(_TaskCustomFieldValueResponse) _then) = __$TaskCustomFieldValueResponseCopyWithImpl;
@override @useResult
$Res call({
 String fieldId, Object? value, DateTime updatedAtUtc
});




}
/// @nodoc
class __$TaskCustomFieldValueResponseCopyWithImpl<$Res>
    implements _$TaskCustomFieldValueResponseCopyWith<$Res> {
  __$TaskCustomFieldValueResponseCopyWithImpl(this._self, this._then);

  final _TaskCustomFieldValueResponse _self;
  final $Res Function(_TaskCustomFieldValueResponse) _then;

/// Create a copy of TaskCustomFieldValueResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fieldId = null,Object? value = freezed,Object? updatedAtUtc = null,}) {
  return _then(_TaskCustomFieldValueResponse(
fieldId: null == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value ,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ReorderProjectTasksPayload {

 List<String> get taskIds; String? get parentTaskId; ProjectTaskStatus? get status; Map<String, int> get expectedVersions;
/// Create a copy of ReorderProjectTasksPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReorderProjectTasksPayloadCopyWith<ReorderProjectTasksPayload> get copyWith => _$ReorderProjectTasksPayloadCopyWithImpl<ReorderProjectTasksPayload>(this as ReorderProjectTasksPayload, _$identity);

  /// Serializes this ReorderProjectTasksPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReorderProjectTasksPayload&&const DeepCollectionEquality().equals(other.taskIds, taskIds)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.expectedVersions, expectedVersions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(taskIds),parentTaskId,status,const DeepCollectionEquality().hash(expectedVersions));

@override
String toString() {
  return 'ReorderProjectTasksPayload(taskIds: $taskIds, parentTaskId: $parentTaskId, status: $status, expectedVersions: $expectedVersions)';
}


}

/// @nodoc
abstract mixin class $ReorderProjectTasksPayloadCopyWith<$Res>  {
  factory $ReorderProjectTasksPayloadCopyWith(ReorderProjectTasksPayload value, $Res Function(ReorderProjectTasksPayload) _then) = _$ReorderProjectTasksPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> taskIds, String? parentTaskId, ProjectTaskStatus? status, Map<String, int> expectedVersions
});




}
/// @nodoc
class _$ReorderProjectTasksPayloadCopyWithImpl<$Res>
    implements $ReorderProjectTasksPayloadCopyWith<$Res> {
  _$ReorderProjectTasksPayloadCopyWithImpl(this._self, this._then);

  final ReorderProjectTasksPayload _self;
  final $Res Function(ReorderProjectTasksPayload) _then;

/// Create a copy of ReorderProjectTasksPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskIds = null,Object? parentTaskId = freezed,Object? status = freezed,Object? expectedVersions = null,}) {
  return _then(_self.copyWith(
taskIds: null == taskIds ? _self.taskIds : taskIds // ignore: cast_nullable_to_non_nullable
as List<String>,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,expectedVersions: null == expectedVersions ? _self.expectedVersions : expectedVersions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReorderProjectTasksPayload].
extension ReorderProjectTasksPayloadPatterns on ReorderProjectTasksPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReorderProjectTasksPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReorderProjectTasksPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReorderProjectTasksPayload value)  $default,){
final _that = this;
switch (_that) {
case _ReorderProjectTasksPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReorderProjectTasksPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ReorderProjectTasksPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> taskIds,  String? parentTaskId,  ProjectTaskStatus? status,  Map<String, int> expectedVersions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReorderProjectTasksPayload() when $default != null:
return $default(_that.taskIds,_that.parentTaskId,_that.status,_that.expectedVersions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> taskIds,  String? parentTaskId,  ProjectTaskStatus? status,  Map<String, int> expectedVersions)  $default,) {final _that = this;
switch (_that) {
case _ReorderProjectTasksPayload():
return $default(_that.taskIds,_that.parentTaskId,_that.status,_that.expectedVersions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> taskIds,  String? parentTaskId,  ProjectTaskStatus? status,  Map<String, int> expectedVersions)?  $default,) {final _that = this;
switch (_that) {
case _ReorderProjectTasksPayload() when $default != null:
return $default(_that.taskIds,_that.parentTaskId,_that.status,_that.expectedVersions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReorderProjectTasksPayload implements ReorderProjectTasksPayload {
  const _ReorderProjectTasksPayload({required this.taskIds, this.parentTaskId, this.status, required this.expectedVersions});
  factory _ReorderProjectTasksPayload.fromJson(Map<String, dynamic> json) => _$ReorderProjectTasksPayloadFromJson(json);

@override final  List<String> taskIds;
@override final  String? parentTaskId;
@override final  ProjectTaskStatus? status;
@override final  Map<String, int> expectedVersions;

/// Create a copy of ReorderProjectTasksPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReorderProjectTasksPayloadCopyWith<_ReorderProjectTasksPayload> get copyWith => __$ReorderProjectTasksPayloadCopyWithImpl<_ReorderProjectTasksPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReorderProjectTasksPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReorderProjectTasksPayload&&const DeepCollectionEquality().equals(other.taskIds, taskIds)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.expectedVersions, expectedVersions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(taskIds),parentTaskId,status,const DeepCollectionEquality().hash(expectedVersions));

@override
String toString() {
  return 'ReorderProjectTasksPayload(taskIds: $taskIds, parentTaskId: $parentTaskId, status: $status, expectedVersions: $expectedVersions)';
}


}

/// @nodoc
abstract mixin class _$ReorderProjectTasksPayloadCopyWith<$Res> implements $ReorderProjectTasksPayloadCopyWith<$Res> {
  factory _$ReorderProjectTasksPayloadCopyWith(_ReorderProjectTasksPayload value, $Res Function(_ReorderProjectTasksPayload) _then) = __$ReorderProjectTasksPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> taskIds, String? parentTaskId, ProjectTaskStatus? status, Map<String, int> expectedVersions
});




}
/// @nodoc
class __$ReorderProjectTasksPayloadCopyWithImpl<$Res>
    implements _$ReorderProjectTasksPayloadCopyWith<$Res> {
  __$ReorderProjectTasksPayloadCopyWithImpl(this._self, this._then);

  final _ReorderProjectTasksPayload _self;
  final $Res Function(_ReorderProjectTasksPayload) _then;

/// Create a copy of ReorderProjectTasksPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskIds = null,Object? parentTaskId = freezed,Object? status = freezed,Object? expectedVersions = null,}) {
  return _then(_ReorderProjectTasksPayload(
taskIds: null == taskIds ? _self.taskIds : taskIds // ignore: cast_nullable_to_non_nullable
as List<String>,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,expectedVersions: null == expectedVersions ? _self.expectedVersions : expectedVersions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
