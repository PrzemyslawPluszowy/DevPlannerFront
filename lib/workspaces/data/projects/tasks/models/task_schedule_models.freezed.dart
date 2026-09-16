// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_schedule_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectScheduleSettingsResponse {

 AutoScheduleMode get mode;
/// Create a copy of ProjectScheduleSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectScheduleSettingsResponseCopyWith<ProjectScheduleSettingsResponse> get copyWith => _$ProjectScheduleSettingsResponseCopyWithImpl<ProjectScheduleSettingsResponse>(this as ProjectScheduleSettingsResponse, _$identity);

  /// Serializes this ProjectScheduleSettingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectScheduleSettingsResponse&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'ProjectScheduleSettingsResponse(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $ProjectScheduleSettingsResponseCopyWith<$Res>  {
  factory $ProjectScheduleSettingsResponseCopyWith(ProjectScheduleSettingsResponse value, $Res Function(ProjectScheduleSettingsResponse) _then) = _$ProjectScheduleSettingsResponseCopyWithImpl;
@useResult
$Res call({
 AutoScheduleMode mode
});




}
/// @nodoc
class _$ProjectScheduleSettingsResponseCopyWithImpl<$Res>
    implements $ProjectScheduleSettingsResponseCopyWith<$Res> {
  _$ProjectScheduleSettingsResponseCopyWithImpl(this._self, this._then);

  final ProjectScheduleSettingsResponse _self;
  final $Res Function(ProjectScheduleSettingsResponse) _then;

/// Create a copy of ProjectScheduleSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AutoScheduleMode,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectScheduleSettingsResponse].
extension ProjectScheduleSettingsResponsePatterns on ProjectScheduleSettingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectScheduleSettingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectScheduleSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectScheduleSettingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectScheduleSettingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectScheduleSettingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectScheduleSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AutoScheduleMode mode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectScheduleSettingsResponse() when $default != null:
return $default(_that.mode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AutoScheduleMode mode)  $default,) {final _that = this;
switch (_that) {
case _ProjectScheduleSettingsResponse():
return $default(_that.mode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AutoScheduleMode mode)?  $default,) {final _that = this;
switch (_that) {
case _ProjectScheduleSettingsResponse() when $default != null:
return $default(_that.mode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectScheduleSettingsResponse implements ProjectScheduleSettingsResponse {
  const _ProjectScheduleSettingsResponse({required this.mode});
  factory _ProjectScheduleSettingsResponse.fromJson(Map<String, dynamic> json) => _$ProjectScheduleSettingsResponseFromJson(json);

@override final  AutoScheduleMode mode;

/// Create a copy of ProjectScheduleSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectScheduleSettingsResponseCopyWith<_ProjectScheduleSettingsResponse> get copyWith => __$ProjectScheduleSettingsResponseCopyWithImpl<_ProjectScheduleSettingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectScheduleSettingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectScheduleSettingsResponse&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'ProjectScheduleSettingsResponse(mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$ProjectScheduleSettingsResponseCopyWith<$Res> implements $ProjectScheduleSettingsResponseCopyWith<$Res> {
  factory _$ProjectScheduleSettingsResponseCopyWith(_ProjectScheduleSettingsResponse value, $Res Function(_ProjectScheduleSettingsResponse) _then) = __$ProjectScheduleSettingsResponseCopyWithImpl;
@override @useResult
$Res call({
 AutoScheduleMode mode
});




}
/// @nodoc
class __$ProjectScheduleSettingsResponseCopyWithImpl<$Res>
    implements _$ProjectScheduleSettingsResponseCopyWith<$Res> {
  __$ProjectScheduleSettingsResponseCopyWithImpl(this._self, this._then);

  final _ProjectScheduleSettingsResponse _self;
  final $Res Function(_ProjectScheduleSettingsResponse) _then;

/// Create a copy of ProjectScheduleSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(_ProjectScheduleSettingsResponse(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AutoScheduleMode,
  ));
}


}


/// @nodoc
mixin _$PreviewScheduleCascadePayload {

 String get taskId; DateTime get newStartAtUtc; DateTime get newDueAtUtc;
/// Create a copy of PreviewScheduleCascadePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreviewScheduleCascadePayloadCopyWith<PreviewScheduleCascadePayload> get copyWith => _$PreviewScheduleCascadePayloadCopyWithImpl<PreviewScheduleCascadePayload>(this as PreviewScheduleCascadePayload, _$identity);

  /// Serializes this PreviewScheduleCascadePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviewScheduleCascadePayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.newStartAtUtc, newStartAtUtc) || other.newStartAtUtc == newStartAtUtc)&&(identical(other.newDueAtUtc, newDueAtUtc) || other.newDueAtUtc == newDueAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,newStartAtUtc,newDueAtUtc);

@override
String toString() {
  return 'PreviewScheduleCascadePayload(taskId: $taskId, newStartAtUtc: $newStartAtUtc, newDueAtUtc: $newDueAtUtc)';
}


}

/// @nodoc
abstract mixin class $PreviewScheduleCascadePayloadCopyWith<$Res>  {
  factory $PreviewScheduleCascadePayloadCopyWith(PreviewScheduleCascadePayload value, $Res Function(PreviewScheduleCascadePayload) _then) = _$PreviewScheduleCascadePayloadCopyWithImpl;
@useResult
$Res call({
 String taskId, DateTime newStartAtUtc, DateTime newDueAtUtc
});




}
/// @nodoc
class _$PreviewScheduleCascadePayloadCopyWithImpl<$Res>
    implements $PreviewScheduleCascadePayloadCopyWith<$Res> {
  _$PreviewScheduleCascadePayloadCopyWithImpl(this._self, this._then);

  final PreviewScheduleCascadePayload _self;
  final $Res Function(PreviewScheduleCascadePayload) _then;

/// Create a copy of PreviewScheduleCascadePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? newStartAtUtc = null,Object? newDueAtUtc = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,newStartAtUtc: null == newStartAtUtc ? _self.newStartAtUtc : newStartAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,newDueAtUtc: null == newDueAtUtc ? _self.newDueAtUtc : newDueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PreviewScheduleCascadePayload].
extension PreviewScheduleCascadePayloadPatterns on PreviewScheduleCascadePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreviewScheduleCascadePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreviewScheduleCascadePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreviewScheduleCascadePayload value)  $default,){
final _that = this;
switch (_that) {
case _PreviewScheduleCascadePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreviewScheduleCascadePayload value)?  $default,){
final _that = this;
switch (_that) {
case _PreviewScheduleCascadePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  DateTime newStartAtUtc,  DateTime newDueAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreviewScheduleCascadePayload() when $default != null:
return $default(_that.taskId,_that.newStartAtUtc,_that.newDueAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  DateTime newStartAtUtc,  DateTime newDueAtUtc)  $default,) {final _that = this;
switch (_that) {
case _PreviewScheduleCascadePayload():
return $default(_that.taskId,_that.newStartAtUtc,_that.newDueAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  DateTime newStartAtUtc,  DateTime newDueAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _PreviewScheduleCascadePayload() when $default != null:
return $default(_that.taskId,_that.newStartAtUtc,_that.newDueAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreviewScheduleCascadePayload implements PreviewScheduleCascadePayload {
  const _PreviewScheduleCascadePayload({required this.taskId, required this.newStartAtUtc, required this.newDueAtUtc});
  factory _PreviewScheduleCascadePayload.fromJson(Map<String, dynamic> json) => _$PreviewScheduleCascadePayloadFromJson(json);

@override final  String taskId;
@override final  DateTime newStartAtUtc;
@override final  DateTime newDueAtUtc;

/// Create a copy of PreviewScheduleCascadePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreviewScheduleCascadePayloadCopyWith<_PreviewScheduleCascadePayload> get copyWith => __$PreviewScheduleCascadePayloadCopyWithImpl<_PreviewScheduleCascadePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreviewScheduleCascadePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviewScheduleCascadePayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.newStartAtUtc, newStartAtUtc) || other.newStartAtUtc == newStartAtUtc)&&(identical(other.newDueAtUtc, newDueAtUtc) || other.newDueAtUtc == newDueAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,newStartAtUtc,newDueAtUtc);

@override
String toString() {
  return 'PreviewScheduleCascadePayload(taskId: $taskId, newStartAtUtc: $newStartAtUtc, newDueAtUtc: $newDueAtUtc)';
}


}

/// @nodoc
abstract mixin class _$PreviewScheduleCascadePayloadCopyWith<$Res> implements $PreviewScheduleCascadePayloadCopyWith<$Res> {
  factory _$PreviewScheduleCascadePayloadCopyWith(_PreviewScheduleCascadePayload value, $Res Function(_PreviewScheduleCascadePayload) _then) = __$PreviewScheduleCascadePayloadCopyWithImpl;
@override @useResult
$Res call({
 String taskId, DateTime newStartAtUtc, DateTime newDueAtUtc
});




}
/// @nodoc
class __$PreviewScheduleCascadePayloadCopyWithImpl<$Res>
    implements _$PreviewScheduleCascadePayloadCopyWith<$Res> {
  __$PreviewScheduleCascadePayloadCopyWithImpl(this._self, this._then);

  final _PreviewScheduleCascadePayload _self;
  final $Res Function(_PreviewScheduleCascadePayload) _then;

/// Create a copy of PreviewScheduleCascadePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? newStartAtUtc = null,Object? newDueAtUtc = null,}) {
  return _then(_PreviewScheduleCascadePayload(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,newStartAtUtc: null == newStartAtUtc ? _self.newStartAtUtc : newStartAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,newDueAtUtc: null == newDueAtUtc ? _self.newDueAtUtc : newDueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ApplyScheduleCascadePayload {

 String get taskId; DateTime get newStartAtUtc; DateTime get newDueAtUtc; Map<String, int> get expectedTaskVersions;
/// Create a copy of ApplyScheduleCascadePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyScheduleCascadePayloadCopyWith<ApplyScheduleCascadePayload> get copyWith => _$ApplyScheduleCascadePayloadCopyWithImpl<ApplyScheduleCascadePayload>(this as ApplyScheduleCascadePayload, _$identity);

  /// Serializes this ApplyScheduleCascadePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyScheduleCascadePayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.newStartAtUtc, newStartAtUtc) || other.newStartAtUtc == newStartAtUtc)&&(identical(other.newDueAtUtc, newDueAtUtc) || other.newDueAtUtc == newDueAtUtc)&&const DeepCollectionEquality().equals(other.expectedTaskVersions, expectedTaskVersions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,newStartAtUtc,newDueAtUtc,const DeepCollectionEquality().hash(expectedTaskVersions));

@override
String toString() {
  return 'ApplyScheduleCascadePayload(taskId: $taskId, newStartAtUtc: $newStartAtUtc, newDueAtUtc: $newDueAtUtc, expectedTaskVersions: $expectedTaskVersions)';
}


}

/// @nodoc
abstract mixin class $ApplyScheduleCascadePayloadCopyWith<$Res>  {
  factory $ApplyScheduleCascadePayloadCopyWith(ApplyScheduleCascadePayload value, $Res Function(ApplyScheduleCascadePayload) _then) = _$ApplyScheduleCascadePayloadCopyWithImpl;
@useResult
$Res call({
 String taskId, DateTime newStartAtUtc, DateTime newDueAtUtc, Map<String, int> expectedTaskVersions
});




}
/// @nodoc
class _$ApplyScheduleCascadePayloadCopyWithImpl<$Res>
    implements $ApplyScheduleCascadePayloadCopyWith<$Res> {
  _$ApplyScheduleCascadePayloadCopyWithImpl(this._self, this._then);

  final ApplyScheduleCascadePayload _self;
  final $Res Function(ApplyScheduleCascadePayload) _then;

/// Create a copy of ApplyScheduleCascadePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? newStartAtUtc = null,Object? newDueAtUtc = null,Object? expectedTaskVersions = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,newStartAtUtc: null == newStartAtUtc ? _self.newStartAtUtc : newStartAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,newDueAtUtc: null == newDueAtUtc ? _self.newDueAtUtc : newDueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,expectedTaskVersions: null == expectedTaskVersions ? _self.expectedTaskVersions : expectedTaskVersions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplyScheduleCascadePayload].
extension ApplyScheduleCascadePayloadPatterns on ApplyScheduleCascadePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplyScheduleCascadePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplyScheduleCascadePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplyScheduleCascadePayload value)  $default,){
final _that = this;
switch (_that) {
case _ApplyScheduleCascadePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplyScheduleCascadePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ApplyScheduleCascadePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  DateTime newStartAtUtc,  DateTime newDueAtUtc,  Map<String, int> expectedTaskVersions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplyScheduleCascadePayload() when $default != null:
return $default(_that.taskId,_that.newStartAtUtc,_that.newDueAtUtc,_that.expectedTaskVersions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  DateTime newStartAtUtc,  DateTime newDueAtUtc,  Map<String, int> expectedTaskVersions)  $default,) {final _that = this;
switch (_that) {
case _ApplyScheduleCascadePayload():
return $default(_that.taskId,_that.newStartAtUtc,_that.newDueAtUtc,_that.expectedTaskVersions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  DateTime newStartAtUtc,  DateTime newDueAtUtc,  Map<String, int> expectedTaskVersions)?  $default,) {final _that = this;
switch (_that) {
case _ApplyScheduleCascadePayload() when $default != null:
return $default(_that.taskId,_that.newStartAtUtc,_that.newDueAtUtc,_that.expectedTaskVersions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplyScheduleCascadePayload implements ApplyScheduleCascadePayload {
  const _ApplyScheduleCascadePayload({required this.taskId, required this.newStartAtUtc, required this.newDueAtUtc, required this.expectedTaskVersions});
  factory _ApplyScheduleCascadePayload.fromJson(Map<String, dynamic> json) => _$ApplyScheduleCascadePayloadFromJson(json);

@override final  String taskId;
@override final  DateTime newStartAtUtc;
@override final  DateTime newDueAtUtc;
@override final  Map<String, int> expectedTaskVersions;

/// Create a copy of ApplyScheduleCascadePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplyScheduleCascadePayloadCopyWith<_ApplyScheduleCascadePayload> get copyWith => __$ApplyScheduleCascadePayloadCopyWithImpl<_ApplyScheduleCascadePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplyScheduleCascadePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplyScheduleCascadePayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.newStartAtUtc, newStartAtUtc) || other.newStartAtUtc == newStartAtUtc)&&(identical(other.newDueAtUtc, newDueAtUtc) || other.newDueAtUtc == newDueAtUtc)&&const DeepCollectionEquality().equals(other.expectedTaskVersions, expectedTaskVersions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,newStartAtUtc,newDueAtUtc,const DeepCollectionEquality().hash(expectedTaskVersions));

@override
String toString() {
  return 'ApplyScheduleCascadePayload(taskId: $taskId, newStartAtUtc: $newStartAtUtc, newDueAtUtc: $newDueAtUtc, expectedTaskVersions: $expectedTaskVersions)';
}


}

/// @nodoc
abstract mixin class _$ApplyScheduleCascadePayloadCopyWith<$Res> implements $ApplyScheduleCascadePayloadCopyWith<$Res> {
  factory _$ApplyScheduleCascadePayloadCopyWith(_ApplyScheduleCascadePayload value, $Res Function(_ApplyScheduleCascadePayload) _then) = __$ApplyScheduleCascadePayloadCopyWithImpl;
@override @useResult
$Res call({
 String taskId, DateTime newStartAtUtc, DateTime newDueAtUtc, Map<String, int> expectedTaskVersions
});




}
/// @nodoc
class __$ApplyScheduleCascadePayloadCopyWithImpl<$Res>
    implements _$ApplyScheduleCascadePayloadCopyWith<$Res> {
  __$ApplyScheduleCascadePayloadCopyWithImpl(this._self, this._then);

  final _ApplyScheduleCascadePayload _self;
  final $Res Function(_ApplyScheduleCascadePayload) _then;

/// Create a copy of ApplyScheduleCascadePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? newStartAtUtc = null,Object? newDueAtUtc = null,Object? expectedTaskVersions = null,}) {
  return _then(_ApplyScheduleCascadePayload(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,newStartAtUtc: null == newStartAtUtc ? _self.newStartAtUtc : newStartAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,newDueAtUtc: null == newDueAtUtc ? _self.newDueAtUtc : newDueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,expectedTaskVersions: null == expectedTaskVersions ? _self.expectedTaskVersions : expectedTaskVersions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}


/// @nodoc
mixin _$TaskDateShiftResponse {

 String get taskId; String get title; DateTime? get currentStartAtUtc; DateTime get proposedStartAtUtc; DateTime? get currentDueAtUtc; DateTime get proposedDueAtUtc; int get shiftWorkingDays; bool get isOnCriticalPath; int get expectedVersion;
/// Create a copy of TaskDateShiftResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDateShiftResponseCopyWith<TaskDateShiftResponse> get copyWith => _$TaskDateShiftResponseCopyWithImpl<TaskDateShiftResponse>(this as TaskDateShiftResponse, _$identity);

  /// Serializes this TaskDateShiftResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDateShiftResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.currentStartAtUtc, currentStartAtUtc) || other.currentStartAtUtc == currentStartAtUtc)&&(identical(other.proposedStartAtUtc, proposedStartAtUtc) || other.proposedStartAtUtc == proposedStartAtUtc)&&(identical(other.currentDueAtUtc, currentDueAtUtc) || other.currentDueAtUtc == currentDueAtUtc)&&(identical(other.proposedDueAtUtc, proposedDueAtUtc) || other.proposedDueAtUtc == proposedDueAtUtc)&&(identical(other.shiftWorkingDays, shiftWorkingDays) || other.shiftWorkingDays == shiftWorkingDays)&&(identical(other.isOnCriticalPath, isOnCriticalPath) || other.isOnCriticalPath == isOnCriticalPath)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,title,currentStartAtUtc,proposedStartAtUtc,currentDueAtUtc,proposedDueAtUtc,shiftWorkingDays,isOnCriticalPath,expectedVersion);

@override
String toString() {
  return 'TaskDateShiftResponse(taskId: $taskId, title: $title, currentStartAtUtc: $currentStartAtUtc, proposedStartAtUtc: $proposedStartAtUtc, currentDueAtUtc: $currentDueAtUtc, proposedDueAtUtc: $proposedDueAtUtc, shiftWorkingDays: $shiftWorkingDays, isOnCriticalPath: $isOnCriticalPath, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $TaskDateShiftResponseCopyWith<$Res>  {
  factory $TaskDateShiftResponseCopyWith(TaskDateShiftResponse value, $Res Function(TaskDateShiftResponse) _then) = _$TaskDateShiftResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, String title, DateTime? currentStartAtUtc, DateTime proposedStartAtUtc, DateTime? currentDueAtUtc, DateTime proposedDueAtUtc, int shiftWorkingDays, bool isOnCriticalPath, int expectedVersion
});




}
/// @nodoc
class _$TaskDateShiftResponseCopyWithImpl<$Res>
    implements $TaskDateShiftResponseCopyWith<$Res> {
  _$TaskDateShiftResponseCopyWithImpl(this._self, this._then);

  final TaskDateShiftResponse _self;
  final $Res Function(TaskDateShiftResponse) _then;

/// Create a copy of TaskDateShiftResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? title = null,Object? currentStartAtUtc = freezed,Object? proposedStartAtUtc = null,Object? currentDueAtUtc = freezed,Object? proposedDueAtUtc = null,Object? shiftWorkingDays = null,Object? isOnCriticalPath = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,currentStartAtUtc: freezed == currentStartAtUtc ? _self.currentStartAtUtc : currentStartAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,proposedStartAtUtc: null == proposedStartAtUtc ? _self.proposedStartAtUtc : proposedStartAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,currentDueAtUtc: freezed == currentDueAtUtc ? _self.currentDueAtUtc : currentDueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,proposedDueAtUtc: null == proposedDueAtUtc ? _self.proposedDueAtUtc : proposedDueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,shiftWorkingDays: null == shiftWorkingDays ? _self.shiftWorkingDays : shiftWorkingDays // ignore: cast_nullable_to_non_nullable
as int,isOnCriticalPath: null == isOnCriticalPath ? _self.isOnCriticalPath : isOnCriticalPath // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskDateShiftResponse].
extension TaskDateShiftResponsePatterns on TaskDateShiftResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskDateShiftResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskDateShiftResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskDateShiftResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskDateShiftResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskDateShiftResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskDateShiftResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String title,  DateTime? currentStartAtUtc,  DateTime proposedStartAtUtc,  DateTime? currentDueAtUtc,  DateTime proposedDueAtUtc,  int shiftWorkingDays,  bool isOnCriticalPath,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskDateShiftResponse() when $default != null:
return $default(_that.taskId,_that.title,_that.currentStartAtUtc,_that.proposedStartAtUtc,_that.currentDueAtUtc,_that.proposedDueAtUtc,_that.shiftWorkingDays,_that.isOnCriticalPath,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String title,  DateTime? currentStartAtUtc,  DateTime proposedStartAtUtc,  DateTime? currentDueAtUtc,  DateTime proposedDueAtUtc,  int shiftWorkingDays,  bool isOnCriticalPath,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _TaskDateShiftResponse():
return $default(_that.taskId,_that.title,_that.currentStartAtUtc,_that.proposedStartAtUtc,_that.currentDueAtUtc,_that.proposedDueAtUtc,_that.shiftWorkingDays,_that.isOnCriticalPath,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String title,  DateTime? currentStartAtUtc,  DateTime proposedStartAtUtc,  DateTime? currentDueAtUtc,  DateTime proposedDueAtUtc,  int shiftWorkingDays,  bool isOnCriticalPath,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _TaskDateShiftResponse() when $default != null:
return $default(_that.taskId,_that.title,_that.currentStartAtUtc,_that.proposedStartAtUtc,_that.currentDueAtUtc,_that.proposedDueAtUtc,_that.shiftWorkingDays,_that.isOnCriticalPath,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskDateShiftResponse implements TaskDateShiftResponse {
  const _TaskDateShiftResponse({required this.taskId, required this.title, this.currentStartAtUtc, required this.proposedStartAtUtc, this.currentDueAtUtc, required this.proposedDueAtUtc, required this.shiftWorkingDays, required this.isOnCriticalPath, required this.expectedVersion});
  factory _TaskDateShiftResponse.fromJson(Map<String, dynamic> json) => _$TaskDateShiftResponseFromJson(json);

@override final  String taskId;
@override final  String title;
@override final  DateTime? currentStartAtUtc;
@override final  DateTime proposedStartAtUtc;
@override final  DateTime? currentDueAtUtc;
@override final  DateTime proposedDueAtUtc;
@override final  int shiftWorkingDays;
@override final  bool isOnCriticalPath;
@override final  int expectedVersion;

/// Create a copy of TaskDateShiftResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDateShiftResponseCopyWith<_TaskDateShiftResponse> get copyWith => __$TaskDateShiftResponseCopyWithImpl<_TaskDateShiftResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskDateShiftResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskDateShiftResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.currentStartAtUtc, currentStartAtUtc) || other.currentStartAtUtc == currentStartAtUtc)&&(identical(other.proposedStartAtUtc, proposedStartAtUtc) || other.proposedStartAtUtc == proposedStartAtUtc)&&(identical(other.currentDueAtUtc, currentDueAtUtc) || other.currentDueAtUtc == currentDueAtUtc)&&(identical(other.proposedDueAtUtc, proposedDueAtUtc) || other.proposedDueAtUtc == proposedDueAtUtc)&&(identical(other.shiftWorkingDays, shiftWorkingDays) || other.shiftWorkingDays == shiftWorkingDays)&&(identical(other.isOnCriticalPath, isOnCriticalPath) || other.isOnCriticalPath == isOnCriticalPath)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,title,currentStartAtUtc,proposedStartAtUtc,currentDueAtUtc,proposedDueAtUtc,shiftWorkingDays,isOnCriticalPath,expectedVersion);

@override
String toString() {
  return 'TaskDateShiftResponse(taskId: $taskId, title: $title, currentStartAtUtc: $currentStartAtUtc, proposedStartAtUtc: $proposedStartAtUtc, currentDueAtUtc: $currentDueAtUtc, proposedDueAtUtc: $proposedDueAtUtc, shiftWorkingDays: $shiftWorkingDays, isOnCriticalPath: $isOnCriticalPath, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$TaskDateShiftResponseCopyWith<$Res> implements $TaskDateShiftResponseCopyWith<$Res> {
  factory _$TaskDateShiftResponseCopyWith(_TaskDateShiftResponse value, $Res Function(_TaskDateShiftResponse) _then) = __$TaskDateShiftResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String title, DateTime? currentStartAtUtc, DateTime proposedStartAtUtc, DateTime? currentDueAtUtc, DateTime proposedDueAtUtc, int shiftWorkingDays, bool isOnCriticalPath, int expectedVersion
});




}
/// @nodoc
class __$TaskDateShiftResponseCopyWithImpl<$Res>
    implements _$TaskDateShiftResponseCopyWith<$Res> {
  __$TaskDateShiftResponseCopyWithImpl(this._self, this._then);

  final _TaskDateShiftResponse _self;
  final $Res Function(_TaskDateShiftResponse) _then;

/// Create a copy of TaskDateShiftResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? title = null,Object? currentStartAtUtc = freezed,Object? proposedStartAtUtc = null,Object? currentDueAtUtc = freezed,Object? proposedDueAtUtc = null,Object? shiftWorkingDays = null,Object? isOnCriticalPath = null,Object? expectedVersion = null,}) {
  return _then(_TaskDateShiftResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,currentStartAtUtc: freezed == currentStartAtUtc ? _self.currentStartAtUtc : currentStartAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,proposedStartAtUtc: null == proposedStartAtUtc ? _self.proposedStartAtUtc : proposedStartAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,currentDueAtUtc: freezed == currentDueAtUtc ? _self.currentDueAtUtc : currentDueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,proposedDueAtUtc: null == proposedDueAtUtc ? _self.proposedDueAtUtc : proposedDueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,shiftWorkingDays: null == shiftWorkingDays ? _self.shiftWorkingDays : shiftWorkingDays // ignore: cast_nullable_to_non_nullable
as int,isOnCriticalPath: null == isOnCriticalPath ? _self.isOnCriticalPath : isOnCriticalPath // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TaskFloatResponse {

 String get taskId; DateTime get earlyStartUtc; DateTime get earlyFinishUtc; DateTime get lateStartUtc; DateTime get lateFinishUtc; int get totalFloatDays; bool get isCritical;
/// Create a copy of TaskFloatResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFloatResponseCopyWith<TaskFloatResponse> get copyWith => _$TaskFloatResponseCopyWithImpl<TaskFloatResponse>(this as TaskFloatResponse, _$identity);

  /// Serializes this TaskFloatResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFloatResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.earlyStartUtc, earlyStartUtc) || other.earlyStartUtc == earlyStartUtc)&&(identical(other.earlyFinishUtc, earlyFinishUtc) || other.earlyFinishUtc == earlyFinishUtc)&&(identical(other.lateStartUtc, lateStartUtc) || other.lateStartUtc == lateStartUtc)&&(identical(other.lateFinishUtc, lateFinishUtc) || other.lateFinishUtc == lateFinishUtc)&&(identical(other.totalFloatDays, totalFloatDays) || other.totalFloatDays == totalFloatDays)&&(identical(other.isCritical, isCritical) || other.isCritical == isCritical));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,earlyStartUtc,earlyFinishUtc,lateStartUtc,lateFinishUtc,totalFloatDays,isCritical);

@override
String toString() {
  return 'TaskFloatResponse(taskId: $taskId, earlyStartUtc: $earlyStartUtc, earlyFinishUtc: $earlyFinishUtc, lateStartUtc: $lateStartUtc, lateFinishUtc: $lateFinishUtc, totalFloatDays: $totalFloatDays, isCritical: $isCritical)';
}


}

/// @nodoc
abstract mixin class $TaskFloatResponseCopyWith<$Res>  {
  factory $TaskFloatResponseCopyWith(TaskFloatResponse value, $Res Function(TaskFloatResponse) _then) = _$TaskFloatResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, DateTime earlyStartUtc, DateTime earlyFinishUtc, DateTime lateStartUtc, DateTime lateFinishUtc, int totalFloatDays, bool isCritical
});




}
/// @nodoc
class _$TaskFloatResponseCopyWithImpl<$Res>
    implements $TaskFloatResponseCopyWith<$Res> {
  _$TaskFloatResponseCopyWithImpl(this._self, this._then);

  final TaskFloatResponse _self;
  final $Res Function(TaskFloatResponse) _then;

/// Create a copy of TaskFloatResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? earlyStartUtc = null,Object? earlyFinishUtc = null,Object? lateStartUtc = null,Object? lateFinishUtc = null,Object? totalFloatDays = null,Object? isCritical = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,earlyStartUtc: null == earlyStartUtc ? _self.earlyStartUtc : earlyStartUtc // ignore: cast_nullable_to_non_nullable
as DateTime,earlyFinishUtc: null == earlyFinishUtc ? _self.earlyFinishUtc : earlyFinishUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lateStartUtc: null == lateStartUtc ? _self.lateStartUtc : lateStartUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lateFinishUtc: null == lateFinishUtc ? _self.lateFinishUtc : lateFinishUtc // ignore: cast_nullable_to_non_nullable
as DateTime,totalFloatDays: null == totalFloatDays ? _self.totalFloatDays : totalFloatDays // ignore: cast_nullable_to_non_nullable
as int,isCritical: null == isCritical ? _self.isCritical : isCritical // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskFloatResponse].
extension TaskFloatResponsePatterns on TaskFloatResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskFloatResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskFloatResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskFloatResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskFloatResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskFloatResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskFloatResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  DateTime earlyStartUtc,  DateTime earlyFinishUtc,  DateTime lateStartUtc,  DateTime lateFinishUtc,  int totalFloatDays,  bool isCritical)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskFloatResponse() when $default != null:
return $default(_that.taskId,_that.earlyStartUtc,_that.earlyFinishUtc,_that.lateStartUtc,_that.lateFinishUtc,_that.totalFloatDays,_that.isCritical);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  DateTime earlyStartUtc,  DateTime earlyFinishUtc,  DateTime lateStartUtc,  DateTime lateFinishUtc,  int totalFloatDays,  bool isCritical)  $default,) {final _that = this;
switch (_that) {
case _TaskFloatResponse():
return $default(_that.taskId,_that.earlyStartUtc,_that.earlyFinishUtc,_that.lateStartUtc,_that.lateFinishUtc,_that.totalFloatDays,_that.isCritical);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  DateTime earlyStartUtc,  DateTime earlyFinishUtc,  DateTime lateStartUtc,  DateTime lateFinishUtc,  int totalFloatDays,  bool isCritical)?  $default,) {final _that = this;
switch (_that) {
case _TaskFloatResponse() when $default != null:
return $default(_that.taskId,_that.earlyStartUtc,_that.earlyFinishUtc,_that.lateStartUtc,_that.lateFinishUtc,_that.totalFloatDays,_that.isCritical);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskFloatResponse implements TaskFloatResponse {
  const _TaskFloatResponse({required this.taskId, required this.earlyStartUtc, required this.earlyFinishUtc, required this.lateStartUtc, required this.lateFinishUtc, required this.totalFloatDays, required this.isCritical});
  factory _TaskFloatResponse.fromJson(Map<String, dynamic> json) => _$TaskFloatResponseFromJson(json);

@override final  String taskId;
@override final  DateTime earlyStartUtc;
@override final  DateTime earlyFinishUtc;
@override final  DateTime lateStartUtc;
@override final  DateTime lateFinishUtc;
@override final  int totalFloatDays;
@override final  bool isCritical;

/// Create a copy of TaskFloatResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskFloatResponseCopyWith<_TaskFloatResponse> get copyWith => __$TaskFloatResponseCopyWithImpl<_TaskFloatResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskFloatResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskFloatResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.earlyStartUtc, earlyStartUtc) || other.earlyStartUtc == earlyStartUtc)&&(identical(other.earlyFinishUtc, earlyFinishUtc) || other.earlyFinishUtc == earlyFinishUtc)&&(identical(other.lateStartUtc, lateStartUtc) || other.lateStartUtc == lateStartUtc)&&(identical(other.lateFinishUtc, lateFinishUtc) || other.lateFinishUtc == lateFinishUtc)&&(identical(other.totalFloatDays, totalFloatDays) || other.totalFloatDays == totalFloatDays)&&(identical(other.isCritical, isCritical) || other.isCritical == isCritical));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,earlyStartUtc,earlyFinishUtc,lateStartUtc,lateFinishUtc,totalFloatDays,isCritical);

@override
String toString() {
  return 'TaskFloatResponse(taskId: $taskId, earlyStartUtc: $earlyStartUtc, earlyFinishUtc: $earlyFinishUtc, lateStartUtc: $lateStartUtc, lateFinishUtc: $lateFinishUtc, totalFloatDays: $totalFloatDays, isCritical: $isCritical)';
}


}

/// @nodoc
abstract mixin class _$TaskFloatResponseCopyWith<$Res> implements $TaskFloatResponseCopyWith<$Res> {
  factory _$TaskFloatResponseCopyWith(_TaskFloatResponse value, $Res Function(_TaskFloatResponse) _then) = __$TaskFloatResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, DateTime earlyStartUtc, DateTime earlyFinishUtc, DateTime lateStartUtc, DateTime lateFinishUtc, int totalFloatDays, bool isCritical
});




}
/// @nodoc
class __$TaskFloatResponseCopyWithImpl<$Res>
    implements _$TaskFloatResponseCopyWith<$Res> {
  __$TaskFloatResponseCopyWithImpl(this._self, this._then);

  final _TaskFloatResponse _self;
  final $Res Function(_TaskFloatResponse) _then;

/// Create a copy of TaskFloatResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? earlyStartUtc = null,Object? earlyFinishUtc = null,Object? lateStartUtc = null,Object? lateFinishUtc = null,Object? totalFloatDays = null,Object? isCritical = null,}) {
  return _then(_TaskFloatResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,earlyStartUtc: null == earlyStartUtc ? _self.earlyStartUtc : earlyStartUtc // ignore: cast_nullable_to_non_nullable
as DateTime,earlyFinishUtc: null == earlyFinishUtc ? _self.earlyFinishUtc : earlyFinishUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lateStartUtc: null == lateStartUtc ? _self.lateStartUtc : lateStartUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lateFinishUtc: null == lateFinishUtc ? _self.lateFinishUtc : lateFinishUtc // ignore: cast_nullable_to_non_nullable
as DateTime,totalFloatDays: null == totalFloatDays ? _self.totalFloatDays : totalFloatDays // ignore: cast_nullable_to_non_nullable
as int,isCritical: null == isCritical ? _self.isCritical : isCritical // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ScheduleCascadeResponse {

 List<TaskDateShiftResponse> get dateShifts; List<String> get criticalPathTaskIds; int get totalProjectWorkingDays; List<TaskFloatResponse> get taskFloats;
/// Create a copy of ScheduleCascadeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCascadeResponseCopyWith<ScheduleCascadeResponse> get copyWith => _$ScheduleCascadeResponseCopyWithImpl<ScheduleCascadeResponse>(this as ScheduleCascadeResponse, _$identity);

  /// Serializes this ScheduleCascadeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleCascadeResponse&&const DeepCollectionEquality().equals(other.dateShifts, dateShifts)&&const DeepCollectionEquality().equals(other.criticalPathTaskIds, criticalPathTaskIds)&&(identical(other.totalProjectWorkingDays, totalProjectWorkingDays) || other.totalProjectWorkingDays == totalProjectWorkingDays)&&const DeepCollectionEquality().equals(other.taskFloats, taskFloats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dateShifts),const DeepCollectionEquality().hash(criticalPathTaskIds),totalProjectWorkingDays,const DeepCollectionEquality().hash(taskFloats));

@override
String toString() {
  return 'ScheduleCascadeResponse(dateShifts: $dateShifts, criticalPathTaskIds: $criticalPathTaskIds, totalProjectWorkingDays: $totalProjectWorkingDays, taskFloats: $taskFloats)';
}


}

/// @nodoc
abstract mixin class $ScheduleCascadeResponseCopyWith<$Res>  {
  factory $ScheduleCascadeResponseCopyWith(ScheduleCascadeResponse value, $Res Function(ScheduleCascadeResponse) _then) = _$ScheduleCascadeResponseCopyWithImpl;
@useResult
$Res call({
 List<TaskDateShiftResponse> dateShifts, List<String> criticalPathTaskIds, int totalProjectWorkingDays, List<TaskFloatResponse> taskFloats
});




}
/// @nodoc
class _$ScheduleCascadeResponseCopyWithImpl<$Res>
    implements $ScheduleCascadeResponseCopyWith<$Res> {
  _$ScheduleCascadeResponseCopyWithImpl(this._self, this._then);

  final ScheduleCascadeResponse _self;
  final $Res Function(ScheduleCascadeResponse) _then;

/// Create a copy of ScheduleCascadeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dateShifts = null,Object? criticalPathTaskIds = null,Object? totalProjectWorkingDays = null,Object? taskFloats = null,}) {
  return _then(_self.copyWith(
dateShifts: null == dateShifts ? _self.dateShifts : dateShifts // ignore: cast_nullable_to_non_nullable
as List<TaskDateShiftResponse>,criticalPathTaskIds: null == criticalPathTaskIds ? _self.criticalPathTaskIds : criticalPathTaskIds // ignore: cast_nullable_to_non_nullable
as List<String>,totalProjectWorkingDays: null == totalProjectWorkingDays ? _self.totalProjectWorkingDays : totalProjectWorkingDays // ignore: cast_nullable_to_non_nullable
as int,taskFloats: null == taskFloats ? _self.taskFloats : taskFloats // ignore: cast_nullable_to_non_nullable
as List<TaskFloatResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleCascadeResponse].
extension ScheduleCascadeResponsePatterns on ScheduleCascadeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleCascadeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleCascadeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleCascadeResponse value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleCascadeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleCascadeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleCascadeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TaskDateShiftResponse> dateShifts,  List<String> criticalPathTaskIds,  int totalProjectWorkingDays,  List<TaskFloatResponse> taskFloats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleCascadeResponse() when $default != null:
return $default(_that.dateShifts,_that.criticalPathTaskIds,_that.totalProjectWorkingDays,_that.taskFloats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TaskDateShiftResponse> dateShifts,  List<String> criticalPathTaskIds,  int totalProjectWorkingDays,  List<TaskFloatResponse> taskFloats)  $default,) {final _that = this;
switch (_that) {
case _ScheduleCascadeResponse():
return $default(_that.dateShifts,_that.criticalPathTaskIds,_that.totalProjectWorkingDays,_that.taskFloats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TaskDateShiftResponse> dateShifts,  List<String> criticalPathTaskIds,  int totalProjectWorkingDays,  List<TaskFloatResponse> taskFloats)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleCascadeResponse() when $default != null:
return $default(_that.dateShifts,_that.criticalPathTaskIds,_that.totalProjectWorkingDays,_that.taskFloats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleCascadeResponse implements ScheduleCascadeResponse {
  const _ScheduleCascadeResponse({required this.dateShifts, required this.criticalPathTaskIds, required this.totalProjectWorkingDays, required this.taskFloats});
  factory _ScheduleCascadeResponse.fromJson(Map<String, dynamic> json) => _$ScheduleCascadeResponseFromJson(json);

@override final  List<TaskDateShiftResponse> dateShifts;
@override final  List<String> criticalPathTaskIds;
@override final  int totalProjectWorkingDays;
@override final  List<TaskFloatResponse> taskFloats;

/// Create a copy of ScheduleCascadeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCascadeResponseCopyWith<_ScheduleCascadeResponse> get copyWith => __$ScheduleCascadeResponseCopyWithImpl<_ScheduleCascadeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleCascadeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleCascadeResponse&&const DeepCollectionEquality().equals(other.dateShifts, dateShifts)&&const DeepCollectionEquality().equals(other.criticalPathTaskIds, criticalPathTaskIds)&&(identical(other.totalProjectWorkingDays, totalProjectWorkingDays) || other.totalProjectWorkingDays == totalProjectWorkingDays)&&const DeepCollectionEquality().equals(other.taskFloats, taskFloats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dateShifts),const DeepCollectionEquality().hash(criticalPathTaskIds),totalProjectWorkingDays,const DeepCollectionEquality().hash(taskFloats));

@override
String toString() {
  return 'ScheduleCascadeResponse(dateShifts: $dateShifts, criticalPathTaskIds: $criticalPathTaskIds, totalProjectWorkingDays: $totalProjectWorkingDays, taskFloats: $taskFloats)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCascadeResponseCopyWith<$Res> implements $ScheduleCascadeResponseCopyWith<$Res> {
  factory _$ScheduleCascadeResponseCopyWith(_ScheduleCascadeResponse value, $Res Function(_ScheduleCascadeResponse) _then) = __$ScheduleCascadeResponseCopyWithImpl;
@override @useResult
$Res call({
 List<TaskDateShiftResponse> dateShifts, List<String> criticalPathTaskIds, int totalProjectWorkingDays, List<TaskFloatResponse> taskFloats
});




}
/// @nodoc
class __$ScheduleCascadeResponseCopyWithImpl<$Res>
    implements _$ScheduleCascadeResponseCopyWith<$Res> {
  __$ScheduleCascadeResponseCopyWithImpl(this._self, this._then);

  final _ScheduleCascadeResponse _self;
  final $Res Function(_ScheduleCascadeResponse) _then;

/// Create a copy of ScheduleCascadeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dateShifts = null,Object? criticalPathTaskIds = null,Object? totalProjectWorkingDays = null,Object? taskFloats = null,}) {
  return _then(_ScheduleCascadeResponse(
dateShifts: null == dateShifts ? _self.dateShifts : dateShifts // ignore: cast_nullable_to_non_nullable
as List<TaskDateShiftResponse>,criticalPathTaskIds: null == criticalPathTaskIds ? _self.criticalPathTaskIds : criticalPathTaskIds // ignore: cast_nullable_to_non_nullable
as List<String>,totalProjectWorkingDays: null == totalProjectWorkingDays ? _self.totalProjectWorkingDays : totalProjectWorkingDays // ignore: cast_nullable_to_non_nullable
as int,taskFloats: null == taskFloats ? _self.taskFloats : taskFloats // ignore: cast_nullable_to_non_nullable
as List<TaskFloatResponse>,
  ));
}


}


/// @nodoc
mixin _$SetScheduleModePayload {

 AutoScheduleMode get mode;
/// Create a copy of SetScheduleModePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetScheduleModePayloadCopyWith<SetScheduleModePayload> get copyWith => _$SetScheduleModePayloadCopyWithImpl<SetScheduleModePayload>(this as SetScheduleModePayload, _$identity);

  /// Serializes this SetScheduleModePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetScheduleModePayload&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'SetScheduleModePayload(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $SetScheduleModePayloadCopyWith<$Res>  {
  factory $SetScheduleModePayloadCopyWith(SetScheduleModePayload value, $Res Function(SetScheduleModePayload) _then) = _$SetScheduleModePayloadCopyWithImpl;
@useResult
$Res call({
 AutoScheduleMode mode
});




}
/// @nodoc
class _$SetScheduleModePayloadCopyWithImpl<$Res>
    implements $SetScheduleModePayloadCopyWith<$Res> {
  _$SetScheduleModePayloadCopyWithImpl(this._self, this._then);

  final SetScheduleModePayload _self;
  final $Res Function(SetScheduleModePayload) _then;

/// Create a copy of SetScheduleModePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AutoScheduleMode,
  ));
}

}


/// Adds pattern-matching-related methods to [SetScheduleModePayload].
extension SetScheduleModePayloadPatterns on SetScheduleModePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetScheduleModePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetScheduleModePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetScheduleModePayload value)  $default,){
final _that = this;
switch (_that) {
case _SetScheduleModePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetScheduleModePayload value)?  $default,){
final _that = this;
switch (_that) {
case _SetScheduleModePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AutoScheduleMode mode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetScheduleModePayload() when $default != null:
return $default(_that.mode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AutoScheduleMode mode)  $default,) {final _that = this;
switch (_that) {
case _SetScheduleModePayload():
return $default(_that.mode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AutoScheduleMode mode)?  $default,) {final _that = this;
switch (_that) {
case _SetScheduleModePayload() when $default != null:
return $default(_that.mode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetScheduleModePayload implements SetScheduleModePayload {
  const _SetScheduleModePayload({required this.mode});
  factory _SetScheduleModePayload.fromJson(Map<String, dynamic> json) => _$SetScheduleModePayloadFromJson(json);

@override final  AutoScheduleMode mode;

/// Create a copy of SetScheduleModePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetScheduleModePayloadCopyWith<_SetScheduleModePayload> get copyWith => __$SetScheduleModePayloadCopyWithImpl<_SetScheduleModePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetScheduleModePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetScheduleModePayload&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'SetScheduleModePayload(mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$SetScheduleModePayloadCopyWith<$Res> implements $SetScheduleModePayloadCopyWith<$Res> {
  factory _$SetScheduleModePayloadCopyWith(_SetScheduleModePayload value, $Res Function(_SetScheduleModePayload) _then) = __$SetScheduleModePayloadCopyWithImpl;
@override @useResult
$Res call({
 AutoScheduleMode mode
});




}
/// @nodoc
class __$SetScheduleModePayloadCopyWithImpl<$Res>
    implements _$SetScheduleModePayloadCopyWith<$Res> {
  __$SetScheduleModePayloadCopyWithImpl(this._self, this._then);

  final _SetScheduleModePayload _self;
  final $Res Function(_SetScheduleModePayload) _then;

/// Create a copy of SetScheduleModePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(_SetScheduleModePayload(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AutoScheduleMode,
  ));
}


}


/// @nodoc
mixin _$CreateWorkspaceHolidayPayload {

 DateTime get date; String get name;
/// Create a copy of CreateWorkspaceHolidayPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWorkspaceHolidayPayloadCopyWith<CreateWorkspaceHolidayPayload> get copyWith => _$CreateWorkspaceHolidayPayloadCopyWithImpl<CreateWorkspaceHolidayPayload>(this as CreateWorkspaceHolidayPayload, _$identity);

  /// Serializes this CreateWorkspaceHolidayPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWorkspaceHolidayPayload&&(identical(other.date, date) || other.date == date)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,name);

@override
String toString() {
  return 'CreateWorkspaceHolidayPayload(date: $date, name: $name)';
}


}

/// @nodoc
abstract mixin class $CreateWorkspaceHolidayPayloadCopyWith<$Res>  {
  factory $CreateWorkspaceHolidayPayloadCopyWith(CreateWorkspaceHolidayPayload value, $Res Function(CreateWorkspaceHolidayPayload) _then) = _$CreateWorkspaceHolidayPayloadCopyWithImpl;
@useResult
$Res call({
 DateTime date, String name
});




}
/// @nodoc
class _$CreateWorkspaceHolidayPayloadCopyWithImpl<$Res>
    implements $CreateWorkspaceHolidayPayloadCopyWith<$Res> {
  _$CreateWorkspaceHolidayPayloadCopyWithImpl(this._self, this._then);

  final CreateWorkspaceHolidayPayload _self;
  final $Res Function(CreateWorkspaceHolidayPayload) _then;

/// Create a copy of CreateWorkspaceHolidayPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? name = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWorkspaceHolidayPayload].
extension CreateWorkspaceHolidayPayloadPatterns on CreateWorkspaceHolidayPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWorkspaceHolidayPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWorkspaceHolidayPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWorkspaceHolidayPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateWorkspaceHolidayPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWorkspaceHolidayPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWorkspaceHolidayPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWorkspaceHolidayPayload() when $default != null:
return $default(_that.date,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  String name)  $default,) {final _that = this;
switch (_that) {
case _CreateWorkspaceHolidayPayload():
return $default(_that.date,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  String name)?  $default,) {final _that = this;
switch (_that) {
case _CreateWorkspaceHolidayPayload() when $default != null:
return $default(_that.date,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWorkspaceHolidayPayload implements CreateWorkspaceHolidayPayload {
  const _CreateWorkspaceHolidayPayload({required this.date, required this.name});
  factory _CreateWorkspaceHolidayPayload.fromJson(Map<String, dynamic> json) => _$CreateWorkspaceHolidayPayloadFromJson(json);

@override final  DateTime date;
@override final  String name;

/// Create a copy of CreateWorkspaceHolidayPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWorkspaceHolidayPayloadCopyWith<_CreateWorkspaceHolidayPayload> get copyWith => __$CreateWorkspaceHolidayPayloadCopyWithImpl<_CreateWorkspaceHolidayPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWorkspaceHolidayPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWorkspaceHolidayPayload&&(identical(other.date, date) || other.date == date)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,name);

@override
String toString() {
  return 'CreateWorkspaceHolidayPayload(date: $date, name: $name)';
}


}

/// @nodoc
abstract mixin class _$CreateWorkspaceHolidayPayloadCopyWith<$Res> implements $CreateWorkspaceHolidayPayloadCopyWith<$Res> {
  factory _$CreateWorkspaceHolidayPayloadCopyWith(_CreateWorkspaceHolidayPayload value, $Res Function(_CreateWorkspaceHolidayPayload) _then) = __$CreateWorkspaceHolidayPayloadCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, String name
});




}
/// @nodoc
class __$CreateWorkspaceHolidayPayloadCopyWithImpl<$Res>
    implements _$CreateWorkspaceHolidayPayloadCopyWith<$Res> {
  __$CreateWorkspaceHolidayPayloadCopyWithImpl(this._self, this._then);

  final _CreateWorkspaceHolidayPayload _self;
  final $Res Function(_CreateWorkspaceHolidayPayload) _then;

/// Create a copy of CreateWorkspaceHolidayPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? name = null,}) {
  return _then(_CreateWorkspaceHolidayPayload(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WorkspaceHolidayResponse {

 String get id; DateTime get date; String get name;
/// Create a copy of WorkspaceHolidayResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceHolidayResponseCopyWith<WorkspaceHolidayResponse> get copyWith => _$WorkspaceHolidayResponseCopyWithImpl<WorkspaceHolidayResponse>(this as WorkspaceHolidayResponse, _$identity);

  /// Serializes this WorkspaceHolidayResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceHolidayResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,name);

@override
String toString() {
  return 'WorkspaceHolidayResponse(id: $id, date: $date, name: $name)';
}


}

/// @nodoc
abstract mixin class $WorkspaceHolidayResponseCopyWith<$Res>  {
  factory $WorkspaceHolidayResponseCopyWith(WorkspaceHolidayResponse value, $Res Function(WorkspaceHolidayResponse) _then) = _$WorkspaceHolidayResponseCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, String name
});




}
/// @nodoc
class _$WorkspaceHolidayResponseCopyWithImpl<$Res>
    implements $WorkspaceHolidayResponseCopyWith<$Res> {
  _$WorkspaceHolidayResponseCopyWithImpl(this._self, this._then);

  final WorkspaceHolidayResponse _self;
  final $Res Function(WorkspaceHolidayResponse) _then;

/// Create a copy of WorkspaceHolidayResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceHolidayResponse].
extension WorkspaceHolidayResponsePatterns on WorkspaceHolidayResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceHolidayResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceHolidayResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceHolidayResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceHolidayResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceHolidayResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceHolidayResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceHolidayResponse() when $default != null:
return $default(_that.id,_that.date,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  String name)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceHolidayResponse():
return $default(_that.id,_that.date,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  String name)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceHolidayResponse() when $default != null:
return $default(_that.id,_that.date,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceHolidayResponse implements WorkspaceHolidayResponse {
  const _WorkspaceHolidayResponse({required this.id, required this.date, required this.name});
  factory _WorkspaceHolidayResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceHolidayResponseFromJson(json);

@override final  String id;
@override final  DateTime date;
@override final  String name;

/// Create a copy of WorkspaceHolidayResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceHolidayResponseCopyWith<_WorkspaceHolidayResponse> get copyWith => __$WorkspaceHolidayResponseCopyWithImpl<_WorkspaceHolidayResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceHolidayResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceHolidayResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,name);

@override
String toString() {
  return 'WorkspaceHolidayResponse(id: $id, date: $date, name: $name)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceHolidayResponseCopyWith<$Res> implements $WorkspaceHolidayResponseCopyWith<$Res> {
  factory _$WorkspaceHolidayResponseCopyWith(_WorkspaceHolidayResponse value, $Res Function(_WorkspaceHolidayResponse) _then) = __$WorkspaceHolidayResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, String name
});




}
/// @nodoc
class __$WorkspaceHolidayResponseCopyWithImpl<$Res>
    implements _$WorkspaceHolidayResponseCopyWith<$Res> {
  __$WorkspaceHolidayResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceHolidayResponse _self;
  final $Res Function(_WorkspaceHolidayResponse) _then;

/// Create a copy of WorkspaceHolidayResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? name = null,}) {
  return _then(_WorkspaceHolidayResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
