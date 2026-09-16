// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_advanced_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTaskRecurrencePayload {

 TaskRecurrenceMode get mode; TaskRecurrenceFrequency get frequency; int get interval; String get timeZoneId; DateTime? get firstOccurrenceAtUtc; int get expectedVersion; ProjectTaskStatus get occurrenceStatus; bool get skipIfPreviousOpen;
/// Create a copy of CreateTaskRecurrencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskRecurrencePayloadCopyWith<CreateTaskRecurrencePayload> get copyWith => _$CreateTaskRecurrencePayloadCopyWithImpl<CreateTaskRecurrencePayload>(this as CreateTaskRecurrencePayload, _$identity);

  /// Serializes this CreateTaskRecurrencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskRecurrencePayload&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.firstOccurrenceAtUtc, firstOccurrenceAtUtc) || other.firstOccurrenceAtUtc == firstOccurrenceAtUtc)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.occurrenceStatus, occurrenceStatus) || other.occurrenceStatus == occurrenceStatus)&&(identical(other.skipIfPreviousOpen, skipIfPreviousOpen) || other.skipIfPreviousOpen == skipIfPreviousOpen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,frequency,interval,timeZoneId,firstOccurrenceAtUtc,expectedVersion,occurrenceStatus,skipIfPreviousOpen);

@override
String toString() {
  return 'CreateTaskRecurrencePayload(mode: $mode, frequency: $frequency, interval: $interval, timeZoneId: $timeZoneId, firstOccurrenceAtUtc: $firstOccurrenceAtUtc, expectedVersion: $expectedVersion, occurrenceStatus: $occurrenceStatus, skipIfPreviousOpen: $skipIfPreviousOpen)';
}


}

/// @nodoc
abstract mixin class $CreateTaskRecurrencePayloadCopyWith<$Res>  {
  factory $CreateTaskRecurrencePayloadCopyWith(CreateTaskRecurrencePayload value, $Res Function(CreateTaskRecurrencePayload) _then) = _$CreateTaskRecurrencePayloadCopyWithImpl;
@useResult
$Res call({
 TaskRecurrenceMode mode, TaskRecurrenceFrequency frequency, int interval, String timeZoneId, DateTime? firstOccurrenceAtUtc, int expectedVersion, ProjectTaskStatus occurrenceStatus, bool skipIfPreviousOpen
});




}
/// @nodoc
class _$CreateTaskRecurrencePayloadCopyWithImpl<$Res>
    implements $CreateTaskRecurrencePayloadCopyWith<$Res> {
  _$CreateTaskRecurrencePayloadCopyWithImpl(this._self, this._then);

  final CreateTaskRecurrencePayload _self;
  final $Res Function(CreateTaskRecurrencePayload) _then;

/// Create a copy of CreateTaskRecurrencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? frequency = null,Object? interval = null,Object? timeZoneId = null,Object? firstOccurrenceAtUtc = freezed,Object? expectedVersion = null,Object? occurrenceStatus = null,Object? skipIfPreviousOpen = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceMode,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceFrequency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,firstOccurrenceAtUtc: freezed == firstOccurrenceAtUtc ? _self.firstOccurrenceAtUtc : firstOccurrenceAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,occurrenceStatus: null == occurrenceStatus ? _self.occurrenceStatus : occurrenceStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,skipIfPreviousOpen: null == skipIfPreviousOpen ? _self.skipIfPreviousOpen : skipIfPreviousOpen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskRecurrencePayload].
extension CreateTaskRecurrencePayloadPatterns on CreateTaskRecurrencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskRecurrencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskRecurrencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskRecurrencePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskRecurrencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskRecurrencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskRecurrencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? firstOccurrenceAtUtc,  int expectedVersion,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskRecurrencePayload() when $default != null:
return $default(_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.firstOccurrenceAtUtc,_that.expectedVersion,_that.occurrenceStatus,_that.skipIfPreviousOpen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? firstOccurrenceAtUtc,  int expectedVersion,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskRecurrencePayload():
return $default(_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.firstOccurrenceAtUtc,_that.expectedVersion,_that.occurrenceStatus,_that.skipIfPreviousOpen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? firstOccurrenceAtUtc,  int expectedVersion,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskRecurrencePayload() when $default != null:
return $default(_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.firstOccurrenceAtUtc,_that.expectedVersion,_that.occurrenceStatus,_that.skipIfPreviousOpen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskRecurrencePayload implements CreateTaskRecurrencePayload {
  const _CreateTaskRecurrencePayload({required this.mode, required this.frequency, required this.interval, required this.timeZoneId, this.firstOccurrenceAtUtc, required this.expectedVersion, this.occurrenceStatus = ProjectTaskStatus.todo, this.skipIfPreviousOpen = true});
  factory _CreateTaskRecurrencePayload.fromJson(Map<String, dynamic> json) => _$CreateTaskRecurrencePayloadFromJson(json);

@override final  TaskRecurrenceMode mode;
@override final  TaskRecurrenceFrequency frequency;
@override final  int interval;
@override final  String timeZoneId;
@override final  DateTime? firstOccurrenceAtUtc;
@override final  int expectedVersion;
@override@JsonKey() final  ProjectTaskStatus occurrenceStatus;
@override@JsonKey() final  bool skipIfPreviousOpen;

/// Create a copy of CreateTaskRecurrencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskRecurrencePayloadCopyWith<_CreateTaskRecurrencePayload> get copyWith => __$CreateTaskRecurrencePayloadCopyWithImpl<_CreateTaskRecurrencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskRecurrencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskRecurrencePayload&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.firstOccurrenceAtUtc, firstOccurrenceAtUtc) || other.firstOccurrenceAtUtc == firstOccurrenceAtUtc)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.occurrenceStatus, occurrenceStatus) || other.occurrenceStatus == occurrenceStatus)&&(identical(other.skipIfPreviousOpen, skipIfPreviousOpen) || other.skipIfPreviousOpen == skipIfPreviousOpen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,frequency,interval,timeZoneId,firstOccurrenceAtUtc,expectedVersion,occurrenceStatus,skipIfPreviousOpen);

@override
String toString() {
  return 'CreateTaskRecurrencePayload(mode: $mode, frequency: $frequency, interval: $interval, timeZoneId: $timeZoneId, firstOccurrenceAtUtc: $firstOccurrenceAtUtc, expectedVersion: $expectedVersion, occurrenceStatus: $occurrenceStatus, skipIfPreviousOpen: $skipIfPreviousOpen)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskRecurrencePayloadCopyWith<$Res> implements $CreateTaskRecurrencePayloadCopyWith<$Res> {
  factory _$CreateTaskRecurrencePayloadCopyWith(_CreateTaskRecurrencePayload value, $Res Function(_CreateTaskRecurrencePayload) _then) = __$CreateTaskRecurrencePayloadCopyWithImpl;
@override @useResult
$Res call({
 TaskRecurrenceMode mode, TaskRecurrenceFrequency frequency, int interval, String timeZoneId, DateTime? firstOccurrenceAtUtc, int expectedVersion, ProjectTaskStatus occurrenceStatus, bool skipIfPreviousOpen
});




}
/// @nodoc
class __$CreateTaskRecurrencePayloadCopyWithImpl<$Res>
    implements _$CreateTaskRecurrencePayloadCopyWith<$Res> {
  __$CreateTaskRecurrencePayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskRecurrencePayload _self;
  final $Res Function(_CreateTaskRecurrencePayload) _then;

/// Create a copy of CreateTaskRecurrencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? frequency = null,Object? interval = null,Object? timeZoneId = null,Object? firstOccurrenceAtUtc = freezed,Object? expectedVersion = null,Object? occurrenceStatus = null,Object? skipIfPreviousOpen = null,}) {
  return _then(_CreateTaskRecurrencePayload(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceMode,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceFrequency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,firstOccurrenceAtUtc: freezed == firstOccurrenceAtUtc ? _self.firstOccurrenceAtUtc : firstOccurrenceAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,occurrenceStatus: null == occurrenceStatus ? _self.occurrenceStatus : occurrenceStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,skipIfPreviousOpen: null == skipIfPreviousOpen ? _self.skipIfPreviousOpen : skipIfPreviousOpen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskRecurrencePayload {

 TaskRecurrenceMode get mode; TaskRecurrenceFrequency get frequency; int get interval; String get timeZoneId; DateTime? get nextOccurrenceAtUtc; ProjectTaskStatus get occurrenceStatus; bool get skipIfPreviousOpen; int get expectedVersion;
/// Create a copy of UpdateTaskRecurrencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskRecurrencePayloadCopyWith<UpdateTaskRecurrencePayload> get copyWith => _$UpdateTaskRecurrencePayloadCopyWithImpl<UpdateTaskRecurrencePayload>(this as UpdateTaskRecurrencePayload, _$identity);

  /// Serializes this UpdateTaskRecurrencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskRecurrencePayload&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.nextOccurrenceAtUtc, nextOccurrenceAtUtc) || other.nextOccurrenceAtUtc == nextOccurrenceAtUtc)&&(identical(other.occurrenceStatus, occurrenceStatus) || other.occurrenceStatus == occurrenceStatus)&&(identical(other.skipIfPreviousOpen, skipIfPreviousOpen) || other.skipIfPreviousOpen == skipIfPreviousOpen)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,frequency,interval,timeZoneId,nextOccurrenceAtUtc,occurrenceStatus,skipIfPreviousOpen,expectedVersion);

@override
String toString() {
  return 'UpdateTaskRecurrencePayload(mode: $mode, frequency: $frequency, interval: $interval, timeZoneId: $timeZoneId, nextOccurrenceAtUtc: $nextOccurrenceAtUtc, occurrenceStatus: $occurrenceStatus, skipIfPreviousOpen: $skipIfPreviousOpen, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskRecurrencePayloadCopyWith<$Res>  {
  factory $UpdateTaskRecurrencePayloadCopyWith(UpdateTaskRecurrencePayload value, $Res Function(UpdateTaskRecurrencePayload) _then) = _$UpdateTaskRecurrencePayloadCopyWithImpl;
@useResult
$Res call({
 TaskRecurrenceMode mode, TaskRecurrenceFrequency frequency, int interval, String timeZoneId, DateTime? nextOccurrenceAtUtc, ProjectTaskStatus occurrenceStatus, bool skipIfPreviousOpen, int expectedVersion
});




}
/// @nodoc
class _$UpdateTaskRecurrencePayloadCopyWithImpl<$Res>
    implements $UpdateTaskRecurrencePayloadCopyWith<$Res> {
  _$UpdateTaskRecurrencePayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskRecurrencePayload _self;
  final $Res Function(UpdateTaskRecurrencePayload) _then;

/// Create a copy of UpdateTaskRecurrencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? frequency = null,Object? interval = null,Object? timeZoneId = null,Object? nextOccurrenceAtUtc = freezed,Object? occurrenceStatus = null,Object? skipIfPreviousOpen = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceMode,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceFrequency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,nextOccurrenceAtUtc: freezed == nextOccurrenceAtUtc ? _self.nextOccurrenceAtUtc : nextOccurrenceAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,occurrenceStatus: null == occurrenceStatus ? _self.occurrenceStatus : occurrenceStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,skipIfPreviousOpen: null == skipIfPreviousOpen ? _self.skipIfPreviousOpen : skipIfPreviousOpen // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskRecurrencePayload].
extension UpdateTaskRecurrencePayloadPatterns on UpdateTaskRecurrencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskRecurrencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskRecurrencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskRecurrencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskRecurrencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskRecurrencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskRecurrencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskRecurrencePayload() when $default != null:
return $default(_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskRecurrencePayload():
return $default(_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskRecurrencePayload() when $default != null:
return $default(_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskRecurrencePayload implements UpdateTaskRecurrencePayload {
  const _UpdateTaskRecurrencePayload({required this.mode, required this.frequency, required this.interval, required this.timeZoneId, this.nextOccurrenceAtUtc, required this.occurrenceStatus, required this.skipIfPreviousOpen, required this.expectedVersion});
  factory _UpdateTaskRecurrencePayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskRecurrencePayloadFromJson(json);

@override final  TaskRecurrenceMode mode;
@override final  TaskRecurrenceFrequency frequency;
@override final  int interval;
@override final  String timeZoneId;
@override final  DateTime? nextOccurrenceAtUtc;
@override final  ProjectTaskStatus occurrenceStatus;
@override final  bool skipIfPreviousOpen;
@override final  int expectedVersion;

/// Create a copy of UpdateTaskRecurrencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskRecurrencePayloadCopyWith<_UpdateTaskRecurrencePayload> get copyWith => __$UpdateTaskRecurrencePayloadCopyWithImpl<_UpdateTaskRecurrencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskRecurrencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskRecurrencePayload&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.nextOccurrenceAtUtc, nextOccurrenceAtUtc) || other.nextOccurrenceAtUtc == nextOccurrenceAtUtc)&&(identical(other.occurrenceStatus, occurrenceStatus) || other.occurrenceStatus == occurrenceStatus)&&(identical(other.skipIfPreviousOpen, skipIfPreviousOpen) || other.skipIfPreviousOpen == skipIfPreviousOpen)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,frequency,interval,timeZoneId,nextOccurrenceAtUtc,occurrenceStatus,skipIfPreviousOpen,expectedVersion);

@override
String toString() {
  return 'UpdateTaskRecurrencePayload(mode: $mode, frequency: $frequency, interval: $interval, timeZoneId: $timeZoneId, nextOccurrenceAtUtc: $nextOccurrenceAtUtc, occurrenceStatus: $occurrenceStatus, skipIfPreviousOpen: $skipIfPreviousOpen, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskRecurrencePayloadCopyWith<$Res> implements $UpdateTaskRecurrencePayloadCopyWith<$Res> {
  factory _$UpdateTaskRecurrencePayloadCopyWith(_UpdateTaskRecurrencePayload value, $Res Function(_UpdateTaskRecurrencePayload) _then) = __$UpdateTaskRecurrencePayloadCopyWithImpl;
@override @useResult
$Res call({
 TaskRecurrenceMode mode, TaskRecurrenceFrequency frequency, int interval, String timeZoneId, DateTime? nextOccurrenceAtUtc, ProjectTaskStatus occurrenceStatus, bool skipIfPreviousOpen, int expectedVersion
});




}
/// @nodoc
class __$UpdateTaskRecurrencePayloadCopyWithImpl<$Res>
    implements _$UpdateTaskRecurrencePayloadCopyWith<$Res> {
  __$UpdateTaskRecurrencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskRecurrencePayload _self;
  final $Res Function(_UpdateTaskRecurrencePayload) _then;

/// Create a copy of UpdateTaskRecurrencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? frequency = null,Object? interval = null,Object? timeZoneId = null,Object? nextOccurrenceAtUtc = freezed,Object? occurrenceStatus = null,Object? skipIfPreviousOpen = null,Object? expectedVersion = null,}) {
  return _then(_UpdateTaskRecurrencePayload(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceMode,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceFrequency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,nextOccurrenceAtUtc: freezed == nextOccurrenceAtUtc ? _self.nextOccurrenceAtUtc : nextOccurrenceAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,occurrenceStatus: null == occurrenceStatus ? _self.occurrenceStatus : occurrenceStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,skipIfPreviousOpen: null == skipIfPreviousOpen ? _self.skipIfPreviousOpen : skipIfPreviousOpen // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TaskRecurrenceResponse {

 String get id; String get workspaceId; String get projectId; String get sourceTaskId; TaskRecurrenceMode get mode; TaskRecurrenceFrequency get frequency; int get interval; String get timeZoneId; DateTime? get nextOccurrenceAtUtc; String? get lastCompletedTaskId; String? get lastCreatedTaskId; ProjectTaskStatus get occurrenceStatus; bool get skipIfPreviousOpen; bool get isActive; DateTime get createdAtUtc; DateTime get updatedAtUtc; int get version;
/// Create a copy of TaskRecurrenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskRecurrenceResponseCopyWith<TaskRecurrenceResponse> get copyWith => _$TaskRecurrenceResponseCopyWithImpl<TaskRecurrenceResponse>(this as TaskRecurrenceResponse, _$identity);

  /// Serializes this TaskRecurrenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskRecurrenceResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.nextOccurrenceAtUtc, nextOccurrenceAtUtc) || other.nextOccurrenceAtUtc == nextOccurrenceAtUtc)&&(identical(other.lastCompletedTaskId, lastCompletedTaskId) || other.lastCompletedTaskId == lastCompletedTaskId)&&(identical(other.lastCreatedTaskId, lastCreatedTaskId) || other.lastCreatedTaskId == lastCreatedTaskId)&&(identical(other.occurrenceStatus, occurrenceStatus) || other.occurrenceStatus == occurrenceStatus)&&(identical(other.skipIfPreviousOpen, skipIfPreviousOpen) || other.skipIfPreviousOpen == skipIfPreviousOpen)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,projectId,sourceTaskId,mode,frequency,interval,timeZoneId,nextOccurrenceAtUtc,lastCompletedTaskId,lastCreatedTaskId,occurrenceStatus,skipIfPreviousOpen,isActive,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'TaskRecurrenceResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, sourceTaskId: $sourceTaskId, mode: $mode, frequency: $frequency, interval: $interval, timeZoneId: $timeZoneId, nextOccurrenceAtUtc: $nextOccurrenceAtUtc, lastCompletedTaskId: $lastCompletedTaskId, lastCreatedTaskId: $lastCreatedTaskId, occurrenceStatus: $occurrenceStatus, skipIfPreviousOpen: $skipIfPreviousOpen, isActive: $isActive, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $TaskRecurrenceResponseCopyWith<$Res>  {
  factory $TaskRecurrenceResponseCopyWith(TaskRecurrenceResponse value, $Res Function(TaskRecurrenceResponse) _then) = _$TaskRecurrenceResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String projectId, String sourceTaskId, TaskRecurrenceMode mode, TaskRecurrenceFrequency frequency, int interval, String timeZoneId, DateTime? nextOccurrenceAtUtc, String? lastCompletedTaskId, String? lastCreatedTaskId, ProjectTaskStatus occurrenceStatus, bool skipIfPreviousOpen, bool isActive, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$TaskRecurrenceResponseCopyWithImpl<$Res>
    implements $TaskRecurrenceResponseCopyWith<$Res> {
  _$TaskRecurrenceResponseCopyWithImpl(this._self, this._then);

  final TaskRecurrenceResponse _self;
  final $Res Function(TaskRecurrenceResponse) _then;

/// Create a copy of TaskRecurrenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = null,Object? sourceTaskId = null,Object? mode = null,Object? frequency = null,Object? interval = null,Object? timeZoneId = null,Object? nextOccurrenceAtUtc = freezed,Object? lastCompletedTaskId = freezed,Object? lastCreatedTaskId = freezed,Object? occurrenceStatus = null,Object? skipIfPreviousOpen = null,Object? isActive = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceMode,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceFrequency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,nextOccurrenceAtUtc: freezed == nextOccurrenceAtUtc ? _self.nextOccurrenceAtUtc : nextOccurrenceAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastCompletedTaskId: freezed == lastCompletedTaskId ? _self.lastCompletedTaskId : lastCompletedTaskId // ignore: cast_nullable_to_non_nullable
as String?,lastCreatedTaskId: freezed == lastCreatedTaskId ? _self.lastCreatedTaskId : lastCreatedTaskId // ignore: cast_nullable_to_non_nullable
as String?,occurrenceStatus: null == occurrenceStatus ? _self.occurrenceStatus : occurrenceStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,skipIfPreviousOpen: null == skipIfPreviousOpen ? _self.skipIfPreviousOpen : skipIfPreviousOpen // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskRecurrenceResponse].
extension TaskRecurrenceResponsePatterns on TaskRecurrenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskRecurrenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskRecurrenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskRecurrenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskRecurrenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskRecurrenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskRecurrenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String projectId,  String sourceTaskId,  TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  String? lastCompletedTaskId,  String? lastCreatedTaskId,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  bool isActive,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskRecurrenceResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.sourceTaskId,_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.lastCompletedTaskId,_that.lastCreatedTaskId,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.isActive,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String projectId,  String sourceTaskId,  TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  String? lastCompletedTaskId,  String? lastCreatedTaskId,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  bool isActive,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _TaskRecurrenceResponse():
return $default(_that.id,_that.workspaceId,_that.projectId,_that.sourceTaskId,_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.lastCompletedTaskId,_that.lastCreatedTaskId,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.isActive,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String projectId,  String sourceTaskId,  TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  String? lastCompletedTaskId,  String? lastCreatedTaskId,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  bool isActive,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _TaskRecurrenceResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.sourceTaskId,_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.lastCompletedTaskId,_that.lastCreatedTaskId,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.isActive,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskRecurrenceResponse implements TaskRecurrenceResponse {
  const _TaskRecurrenceResponse({required this.id, required this.workspaceId, required this.projectId, required this.sourceTaskId, required this.mode, required this.frequency, required this.interval, required this.timeZoneId, this.nextOccurrenceAtUtc, this.lastCompletedTaskId, this.lastCreatedTaskId, required this.occurrenceStatus, required this.skipIfPreviousOpen, required this.isActive, required this.createdAtUtc, required this.updatedAtUtc, required this.version});
  factory _TaskRecurrenceResponse.fromJson(Map<String, dynamic> json) => _$TaskRecurrenceResponseFromJson(json);

@override final  String id;
@override final  String workspaceId;
@override final  String projectId;
@override final  String sourceTaskId;
@override final  TaskRecurrenceMode mode;
@override final  TaskRecurrenceFrequency frequency;
@override final  int interval;
@override final  String timeZoneId;
@override final  DateTime? nextOccurrenceAtUtc;
@override final  String? lastCompletedTaskId;
@override final  String? lastCreatedTaskId;
@override final  ProjectTaskStatus occurrenceStatus;
@override final  bool skipIfPreviousOpen;
@override final  bool isActive;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of TaskRecurrenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskRecurrenceResponseCopyWith<_TaskRecurrenceResponse> get copyWith => __$TaskRecurrenceResponseCopyWithImpl<_TaskRecurrenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskRecurrenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskRecurrenceResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.nextOccurrenceAtUtc, nextOccurrenceAtUtc) || other.nextOccurrenceAtUtc == nextOccurrenceAtUtc)&&(identical(other.lastCompletedTaskId, lastCompletedTaskId) || other.lastCompletedTaskId == lastCompletedTaskId)&&(identical(other.lastCreatedTaskId, lastCreatedTaskId) || other.lastCreatedTaskId == lastCreatedTaskId)&&(identical(other.occurrenceStatus, occurrenceStatus) || other.occurrenceStatus == occurrenceStatus)&&(identical(other.skipIfPreviousOpen, skipIfPreviousOpen) || other.skipIfPreviousOpen == skipIfPreviousOpen)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,projectId,sourceTaskId,mode,frequency,interval,timeZoneId,nextOccurrenceAtUtc,lastCompletedTaskId,lastCreatedTaskId,occurrenceStatus,skipIfPreviousOpen,isActive,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'TaskRecurrenceResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, sourceTaskId: $sourceTaskId, mode: $mode, frequency: $frequency, interval: $interval, timeZoneId: $timeZoneId, nextOccurrenceAtUtc: $nextOccurrenceAtUtc, lastCompletedTaskId: $lastCompletedTaskId, lastCreatedTaskId: $lastCreatedTaskId, occurrenceStatus: $occurrenceStatus, skipIfPreviousOpen: $skipIfPreviousOpen, isActive: $isActive, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$TaskRecurrenceResponseCopyWith<$Res> implements $TaskRecurrenceResponseCopyWith<$Res> {
  factory _$TaskRecurrenceResponseCopyWith(_TaskRecurrenceResponse value, $Res Function(_TaskRecurrenceResponse) _then) = __$TaskRecurrenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String projectId, String sourceTaskId, TaskRecurrenceMode mode, TaskRecurrenceFrequency frequency, int interval, String timeZoneId, DateTime? nextOccurrenceAtUtc, String? lastCompletedTaskId, String? lastCreatedTaskId, ProjectTaskStatus occurrenceStatus, bool skipIfPreviousOpen, bool isActive, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$TaskRecurrenceResponseCopyWithImpl<$Res>
    implements _$TaskRecurrenceResponseCopyWith<$Res> {
  __$TaskRecurrenceResponseCopyWithImpl(this._self, this._then);

  final _TaskRecurrenceResponse _self;
  final $Res Function(_TaskRecurrenceResponse) _then;

/// Create a copy of TaskRecurrenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = null,Object? sourceTaskId = null,Object? mode = null,Object? frequency = null,Object? interval = null,Object? timeZoneId = null,Object? nextOccurrenceAtUtc = freezed,Object? lastCompletedTaskId = freezed,Object? lastCreatedTaskId = freezed,Object? occurrenceStatus = null,Object? skipIfPreviousOpen = null,Object? isActive = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_TaskRecurrenceResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceMode,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceFrequency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,nextOccurrenceAtUtc: freezed == nextOccurrenceAtUtc ? _self.nextOccurrenceAtUtc : nextOccurrenceAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastCompletedTaskId: freezed == lastCompletedTaskId ? _self.lastCompletedTaskId : lastCompletedTaskId // ignore: cast_nullable_to_non_nullable
as String?,lastCreatedTaskId: freezed == lastCreatedTaskId ? _self.lastCreatedTaskId : lastCreatedTaskId // ignore: cast_nullable_to_non_nullable
as String?,occurrenceStatus: null == occurrenceStatus ? _self.occurrenceStatus : occurrenceStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,skipIfPreviousOpen: null == skipIfPreviousOpen ? _self.skipIfPreviousOpen : skipIfPreviousOpen // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskRecurrenceItemResponse {

 String get id; String get workspaceId; String get projectId; String get sourceTaskId; String get taskKey; String get taskTitle; ProjectTaskStatus get taskStatus; TaskPriority get priority; List<String> get assigneeIds; TaskRecurrenceMode get mode; TaskRecurrenceFrequency get frequency; int get interval; String get timeZoneId; DateTime? get nextOccurrenceAtUtc; String? get lastCompletedTaskId; String? get lastCreatedTaskId; ProjectTaskStatus get occurrenceStatus; bool get skipIfPreviousOpen; bool get isActive; DateTime get createdAtUtc; DateTime get updatedAtUtc; int get version;
/// Create a copy of ProjectTaskRecurrenceItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskRecurrenceItemResponseCopyWith<ProjectTaskRecurrenceItemResponse> get copyWith => _$ProjectTaskRecurrenceItemResponseCopyWithImpl<ProjectTaskRecurrenceItemResponse>(this as ProjectTaskRecurrenceItemResponse, _$identity);

  /// Serializes this ProjectTaskRecurrenceItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskRecurrenceItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.taskKey, taskKey) || other.taskKey == taskKey)&&(identical(other.taskTitle, taskTitle) || other.taskTitle == taskTitle)&&(identical(other.taskStatus, taskStatus) || other.taskStatus == taskStatus)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.assigneeIds, assigneeIds)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.nextOccurrenceAtUtc, nextOccurrenceAtUtc) || other.nextOccurrenceAtUtc == nextOccurrenceAtUtc)&&(identical(other.lastCompletedTaskId, lastCompletedTaskId) || other.lastCompletedTaskId == lastCompletedTaskId)&&(identical(other.lastCreatedTaskId, lastCreatedTaskId) || other.lastCreatedTaskId == lastCreatedTaskId)&&(identical(other.occurrenceStatus, occurrenceStatus) || other.occurrenceStatus == occurrenceStatus)&&(identical(other.skipIfPreviousOpen, skipIfPreviousOpen) || other.skipIfPreviousOpen == skipIfPreviousOpen)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,workspaceId,projectId,sourceTaskId,taskKey,taskTitle,taskStatus,priority,const DeepCollectionEquality().hash(assigneeIds),mode,frequency,interval,timeZoneId,nextOccurrenceAtUtc,lastCompletedTaskId,lastCreatedTaskId,occurrenceStatus,skipIfPreviousOpen,isActive,createdAtUtc,updatedAtUtc,version]);

@override
String toString() {
  return 'ProjectTaskRecurrenceItemResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, sourceTaskId: $sourceTaskId, taskKey: $taskKey, taskTitle: $taskTitle, taskStatus: $taskStatus, priority: $priority, assigneeIds: $assigneeIds, mode: $mode, frequency: $frequency, interval: $interval, timeZoneId: $timeZoneId, nextOccurrenceAtUtc: $nextOccurrenceAtUtc, lastCompletedTaskId: $lastCompletedTaskId, lastCreatedTaskId: $lastCreatedTaskId, occurrenceStatus: $occurrenceStatus, skipIfPreviousOpen: $skipIfPreviousOpen, isActive: $isActive, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskRecurrenceItemResponseCopyWith<$Res>  {
  factory $ProjectTaskRecurrenceItemResponseCopyWith(ProjectTaskRecurrenceItemResponse value, $Res Function(ProjectTaskRecurrenceItemResponse) _then) = _$ProjectTaskRecurrenceItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String projectId, String sourceTaskId, String taskKey, String taskTitle, ProjectTaskStatus taskStatus, TaskPriority priority, List<String> assigneeIds, TaskRecurrenceMode mode, TaskRecurrenceFrequency frequency, int interval, String timeZoneId, DateTime? nextOccurrenceAtUtc, String? lastCompletedTaskId, String? lastCreatedTaskId, ProjectTaskStatus occurrenceStatus, bool skipIfPreviousOpen, bool isActive, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$ProjectTaskRecurrenceItemResponseCopyWithImpl<$Res>
    implements $ProjectTaskRecurrenceItemResponseCopyWith<$Res> {
  _$ProjectTaskRecurrenceItemResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskRecurrenceItemResponse _self;
  final $Res Function(ProjectTaskRecurrenceItemResponse) _then;

/// Create a copy of ProjectTaskRecurrenceItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = null,Object? sourceTaskId = null,Object? taskKey = null,Object? taskTitle = null,Object? taskStatus = null,Object? priority = null,Object? assigneeIds = null,Object? mode = null,Object? frequency = null,Object? interval = null,Object? timeZoneId = null,Object? nextOccurrenceAtUtc = freezed,Object? lastCompletedTaskId = freezed,Object? lastCreatedTaskId = freezed,Object? occurrenceStatus = null,Object? skipIfPreviousOpen = null,Object? isActive = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,taskKey: null == taskKey ? _self.taskKey : taskKey // ignore: cast_nullable_to_non_nullable
as String,taskTitle: null == taskTitle ? _self.taskTitle : taskTitle // ignore: cast_nullable_to_non_nullable
as String,taskStatus: null == taskStatus ? _self.taskStatus : taskStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,assigneeIds: null == assigneeIds ? _self.assigneeIds : assigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceMode,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceFrequency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,nextOccurrenceAtUtc: freezed == nextOccurrenceAtUtc ? _self.nextOccurrenceAtUtc : nextOccurrenceAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastCompletedTaskId: freezed == lastCompletedTaskId ? _self.lastCompletedTaskId : lastCompletedTaskId // ignore: cast_nullable_to_non_nullable
as String?,lastCreatedTaskId: freezed == lastCreatedTaskId ? _self.lastCreatedTaskId : lastCreatedTaskId // ignore: cast_nullable_to_non_nullable
as String?,occurrenceStatus: null == occurrenceStatus ? _self.occurrenceStatus : occurrenceStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,skipIfPreviousOpen: null == skipIfPreviousOpen ? _self.skipIfPreviousOpen : skipIfPreviousOpen // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskRecurrenceItemResponse].
extension ProjectTaskRecurrenceItemResponsePatterns on ProjectTaskRecurrenceItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskRecurrenceItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskRecurrenceItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskRecurrenceItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String projectId,  String sourceTaskId,  String taskKey,  String taskTitle,  ProjectTaskStatus taskStatus,  TaskPriority priority,  List<String> assigneeIds,  TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  String? lastCompletedTaskId,  String? lastCreatedTaskId,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  bool isActive,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceItemResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.sourceTaskId,_that.taskKey,_that.taskTitle,_that.taskStatus,_that.priority,_that.assigneeIds,_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.lastCompletedTaskId,_that.lastCreatedTaskId,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.isActive,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String projectId,  String sourceTaskId,  String taskKey,  String taskTitle,  ProjectTaskStatus taskStatus,  TaskPriority priority,  List<String> assigneeIds,  TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  String? lastCompletedTaskId,  String? lastCreatedTaskId,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  bool isActive,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceItemResponse():
return $default(_that.id,_that.workspaceId,_that.projectId,_that.sourceTaskId,_that.taskKey,_that.taskTitle,_that.taskStatus,_that.priority,_that.assigneeIds,_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.lastCompletedTaskId,_that.lastCreatedTaskId,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.isActive,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String projectId,  String sourceTaskId,  String taskKey,  String taskTitle,  ProjectTaskStatus taskStatus,  TaskPriority priority,  List<String> assigneeIds,  TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  String? lastCompletedTaskId,  String? lastCreatedTaskId,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  bool isActive,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceItemResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.sourceTaskId,_that.taskKey,_that.taskTitle,_that.taskStatus,_that.priority,_that.assigneeIds,_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.lastCompletedTaskId,_that.lastCreatedTaskId,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.isActive,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskRecurrenceItemResponse implements ProjectTaskRecurrenceItemResponse {
  const _ProjectTaskRecurrenceItemResponse({required this.id, required this.workspaceId, required this.projectId, required this.sourceTaskId, required this.taskKey, required this.taskTitle, required this.taskStatus, required this.priority, this.assigneeIds = const [], required this.mode, required this.frequency, required this.interval, required this.timeZoneId, this.nextOccurrenceAtUtc, this.lastCompletedTaskId, this.lastCreatedTaskId, required this.occurrenceStatus, required this.skipIfPreviousOpen, required this.isActive, required this.createdAtUtc, required this.updatedAtUtc, required this.version});
  factory _ProjectTaskRecurrenceItemResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskRecurrenceItemResponseFromJson(json);

@override final  String id;
@override final  String workspaceId;
@override final  String projectId;
@override final  String sourceTaskId;
@override final  String taskKey;
@override final  String taskTitle;
@override final  ProjectTaskStatus taskStatus;
@override final  TaskPriority priority;
@override@JsonKey() final  List<String> assigneeIds;
@override final  TaskRecurrenceMode mode;
@override final  TaskRecurrenceFrequency frequency;
@override final  int interval;
@override final  String timeZoneId;
@override final  DateTime? nextOccurrenceAtUtc;
@override final  String? lastCompletedTaskId;
@override final  String? lastCreatedTaskId;
@override final  ProjectTaskStatus occurrenceStatus;
@override final  bool skipIfPreviousOpen;
@override final  bool isActive;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of ProjectTaskRecurrenceItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskRecurrenceItemResponseCopyWith<_ProjectTaskRecurrenceItemResponse> get copyWith => __$ProjectTaskRecurrenceItemResponseCopyWithImpl<_ProjectTaskRecurrenceItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskRecurrenceItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskRecurrenceItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.taskKey, taskKey) || other.taskKey == taskKey)&&(identical(other.taskTitle, taskTitle) || other.taskTitle == taskTitle)&&(identical(other.taskStatus, taskStatus) || other.taskStatus == taskStatus)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.assigneeIds, assigneeIds)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.nextOccurrenceAtUtc, nextOccurrenceAtUtc) || other.nextOccurrenceAtUtc == nextOccurrenceAtUtc)&&(identical(other.lastCompletedTaskId, lastCompletedTaskId) || other.lastCompletedTaskId == lastCompletedTaskId)&&(identical(other.lastCreatedTaskId, lastCreatedTaskId) || other.lastCreatedTaskId == lastCreatedTaskId)&&(identical(other.occurrenceStatus, occurrenceStatus) || other.occurrenceStatus == occurrenceStatus)&&(identical(other.skipIfPreviousOpen, skipIfPreviousOpen) || other.skipIfPreviousOpen == skipIfPreviousOpen)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,workspaceId,projectId,sourceTaskId,taskKey,taskTitle,taskStatus,priority,const DeepCollectionEquality().hash(assigneeIds),mode,frequency,interval,timeZoneId,nextOccurrenceAtUtc,lastCompletedTaskId,lastCreatedTaskId,occurrenceStatus,skipIfPreviousOpen,isActive,createdAtUtc,updatedAtUtc,version]);

@override
String toString() {
  return 'ProjectTaskRecurrenceItemResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, sourceTaskId: $sourceTaskId, taskKey: $taskKey, taskTitle: $taskTitle, taskStatus: $taskStatus, priority: $priority, assigneeIds: $assigneeIds, mode: $mode, frequency: $frequency, interval: $interval, timeZoneId: $timeZoneId, nextOccurrenceAtUtc: $nextOccurrenceAtUtc, lastCompletedTaskId: $lastCompletedTaskId, lastCreatedTaskId: $lastCreatedTaskId, occurrenceStatus: $occurrenceStatus, skipIfPreviousOpen: $skipIfPreviousOpen, isActive: $isActive, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskRecurrenceItemResponseCopyWith<$Res> implements $ProjectTaskRecurrenceItemResponseCopyWith<$Res> {
  factory _$ProjectTaskRecurrenceItemResponseCopyWith(_ProjectTaskRecurrenceItemResponse value, $Res Function(_ProjectTaskRecurrenceItemResponse) _then) = __$ProjectTaskRecurrenceItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String projectId, String sourceTaskId, String taskKey, String taskTitle, ProjectTaskStatus taskStatus, TaskPriority priority, List<String> assigneeIds, TaskRecurrenceMode mode, TaskRecurrenceFrequency frequency, int interval, String timeZoneId, DateTime? nextOccurrenceAtUtc, String? lastCompletedTaskId, String? lastCreatedTaskId, ProjectTaskStatus occurrenceStatus, bool skipIfPreviousOpen, bool isActive, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$ProjectTaskRecurrenceItemResponseCopyWithImpl<$Res>
    implements _$ProjectTaskRecurrenceItemResponseCopyWith<$Res> {
  __$ProjectTaskRecurrenceItemResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskRecurrenceItemResponse _self;
  final $Res Function(_ProjectTaskRecurrenceItemResponse) _then;

/// Create a copy of ProjectTaskRecurrenceItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = null,Object? sourceTaskId = null,Object? taskKey = null,Object? taskTitle = null,Object? taskStatus = null,Object? priority = null,Object? assigneeIds = null,Object? mode = null,Object? frequency = null,Object? interval = null,Object? timeZoneId = null,Object? nextOccurrenceAtUtc = freezed,Object? lastCompletedTaskId = freezed,Object? lastCreatedTaskId = freezed,Object? occurrenceStatus = null,Object? skipIfPreviousOpen = null,Object? isActive = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_ProjectTaskRecurrenceItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,taskKey: null == taskKey ? _self.taskKey : taskKey // ignore: cast_nullable_to_non_nullable
as String,taskTitle: null == taskTitle ? _self.taskTitle : taskTitle // ignore: cast_nullable_to_non_nullable
as String,taskStatus: null == taskStatus ? _self.taskStatus : taskStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,assigneeIds: null == assigneeIds ? _self.assigneeIds : assigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceMode,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceFrequency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,nextOccurrenceAtUtc: freezed == nextOccurrenceAtUtc ? _self.nextOccurrenceAtUtc : nextOccurrenceAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastCompletedTaskId: freezed == lastCompletedTaskId ? _self.lastCompletedTaskId : lastCompletedTaskId // ignore: cast_nullable_to_non_nullable
as String?,lastCreatedTaskId: freezed == lastCreatedTaskId ? _self.lastCreatedTaskId : lastCreatedTaskId // ignore: cast_nullable_to_non_nullable
as String?,occurrenceStatus: null == occurrenceStatus ? _self.occurrenceStatus : occurrenceStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,skipIfPreviousOpen: null == skipIfPreviousOpen ? _self.skipIfPreviousOpen : skipIfPreviousOpen // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskRecurrenceRunResponse {

 String get id; String get recurrenceRuleId; String get sourceTaskId; String get taskKey; String get taskTitle; DateTime get scheduledAtUtc; DateTime get executedAtUtc; TaskRecurrenceRunOutcome get outcome; String? get createdTaskId; String? get createdTaskKey;
/// Create a copy of ProjectTaskRecurrenceRunResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskRecurrenceRunResponseCopyWith<ProjectTaskRecurrenceRunResponse> get copyWith => _$ProjectTaskRecurrenceRunResponseCopyWithImpl<ProjectTaskRecurrenceRunResponse>(this as ProjectTaskRecurrenceRunResponse, _$identity);

  /// Serializes this ProjectTaskRecurrenceRunResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskRecurrenceRunResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.recurrenceRuleId, recurrenceRuleId) || other.recurrenceRuleId == recurrenceRuleId)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.taskKey, taskKey) || other.taskKey == taskKey)&&(identical(other.taskTitle, taskTitle) || other.taskTitle == taskTitle)&&(identical(other.scheduledAtUtc, scheduledAtUtc) || other.scheduledAtUtc == scheduledAtUtc)&&(identical(other.executedAtUtc, executedAtUtc) || other.executedAtUtc == executedAtUtc)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.createdTaskId, createdTaskId) || other.createdTaskId == createdTaskId)&&(identical(other.createdTaskKey, createdTaskKey) || other.createdTaskKey == createdTaskKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recurrenceRuleId,sourceTaskId,taskKey,taskTitle,scheduledAtUtc,executedAtUtc,outcome,createdTaskId,createdTaskKey);

@override
String toString() {
  return 'ProjectTaskRecurrenceRunResponse(id: $id, recurrenceRuleId: $recurrenceRuleId, sourceTaskId: $sourceTaskId, taskKey: $taskKey, taskTitle: $taskTitle, scheduledAtUtc: $scheduledAtUtc, executedAtUtc: $executedAtUtc, outcome: $outcome, createdTaskId: $createdTaskId, createdTaskKey: $createdTaskKey)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskRecurrenceRunResponseCopyWith<$Res>  {
  factory $ProjectTaskRecurrenceRunResponseCopyWith(ProjectTaskRecurrenceRunResponse value, $Res Function(ProjectTaskRecurrenceRunResponse) _then) = _$ProjectTaskRecurrenceRunResponseCopyWithImpl;
@useResult
$Res call({
 String id, String recurrenceRuleId, String sourceTaskId, String taskKey, String taskTitle, DateTime scheduledAtUtc, DateTime executedAtUtc, TaskRecurrenceRunOutcome outcome, String? createdTaskId, String? createdTaskKey
});




}
/// @nodoc
class _$ProjectTaskRecurrenceRunResponseCopyWithImpl<$Res>
    implements $ProjectTaskRecurrenceRunResponseCopyWith<$Res> {
  _$ProjectTaskRecurrenceRunResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskRecurrenceRunResponse _self;
  final $Res Function(ProjectTaskRecurrenceRunResponse) _then;

/// Create a copy of ProjectTaskRecurrenceRunResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recurrenceRuleId = null,Object? sourceTaskId = null,Object? taskKey = null,Object? taskTitle = null,Object? scheduledAtUtc = null,Object? executedAtUtc = null,Object? outcome = null,Object? createdTaskId = freezed,Object? createdTaskKey = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recurrenceRuleId: null == recurrenceRuleId ? _self.recurrenceRuleId : recurrenceRuleId // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,taskKey: null == taskKey ? _self.taskKey : taskKey // ignore: cast_nullable_to_non_nullable
as String,taskTitle: null == taskTitle ? _self.taskTitle : taskTitle // ignore: cast_nullable_to_non_nullable
as String,scheduledAtUtc: null == scheduledAtUtc ? _self.scheduledAtUtc : scheduledAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,executedAtUtc: null == executedAtUtc ? _self.executedAtUtc : executedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceRunOutcome,createdTaskId: freezed == createdTaskId ? _self.createdTaskId : createdTaskId // ignore: cast_nullable_to_non_nullable
as String?,createdTaskKey: freezed == createdTaskKey ? _self.createdTaskKey : createdTaskKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskRecurrenceRunResponse].
extension ProjectTaskRecurrenceRunResponsePatterns on ProjectTaskRecurrenceRunResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskRecurrenceRunResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceRunResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskRecurrenceRunResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceRunResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskRecurrenceRunResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceRunResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String recurrenceRuleId,  String sourceTaskId,  String taskKey,  String taskTitle,  DateTime scheduledAtUtc,  DateTime executedAtUtc,  TaskRecurrenceRunOutcome outcome,  String? createdTaskId,  String? createdTaskKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceRunResponse() when $default != null:
return $default(_that.id,_that.recurrenceRuleId,_that.sourceTaskId,_that.taskKey,_that.taskTitle,_that.scheduledAtUtc,_that.executedAtUtc,_that.outcome,_that.createdTaskId,_that.createdTaskKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String recurrenceRuleId,  String sourceTaskId,  String taskKey,  String taskTitle,  DateTime scheduledAtUtc,  DateTime executedAtUtc,  TaskRecurrenceRunOutcome outcome,  String? createdTaskId,  String? createdTaskKey)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceRunResponse():
return $default(_that.id,_that.recurrenceRuleId,_that.sourceTaskId,_that.taskKey,_that.taskTitle,_that.scheduledAtUtc,_that.executedAtUtc,_that.outcome,_that.createdTaskId,_that.createdTaskKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String recurrenceRuleId,  String sourceTaskId,  String taskKey,  String taskTitle,  DateTime scheduledAtUtc,  DateTime executedAtUtc,  TaskRecurrenceRunOutcome outcome,  String? createdTaskId,  String? createdTaskKey)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskRecurrenceRunResponse() when $default != null:
return $default(_that.id,_that.recurrenceRuleId,_that.sourceTaskId,_that.taskKey,_that.taskTitle,_that.scheduledAtUtc,_that.executedAtUtc,_that.outcome,_that.createdTaskId,_that.createdTaskKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskRecurrenceRunResponse implements ProjectTaskRecurrenceRunResponse {
  const _ProjectTaskRecurrenceRunResponse({required this.id, required this.recurrenceRuleId, required this.sourceTaskId, required this.taskKey, required this.taskTitle, required this.scheduledAtUtc, required this.executedAtUtc, required this.outcome, this.createdTaskId, this.createdTaskKey});
  factory _ProjectTaskRecurrenceRunResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskRecurrenceRunResponseFromJson(json);

@override final  String id;
@override final  String recurrenceRuleId;
@override final  String sourceTaskId;
@override final  String taskKey;
@override final  String taskTitle;
@override final  DateTime scheduledAtUtc;
@override final  DateTime executedAtUtc;
@override final  TaskRecurrenceRunOutcome outcome;
@override final  String? createdTaskId;
@override final  String? createdTaskKey;

/// Create a copy of ProjectTaskRecurrenceRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskRecurrenceRunResponseCopyWith<_ProjectTaskRecurrenceRunResponse> get copyWith => __$ProjectTaskRecurrenceRunResponseCopyWithImpl<_ProjectTaskRecurrenceRunResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskRecurrenceRunResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskRecurrenceRunResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.recurrenceRuleId, recurrenceRuleId) || other.recurrenceRuleId == recurrenceRuleId)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.taskKey, taskKey) || other.taskKey == taskKey)&&(identical(other.taskTitle, taskTitle) || other.taskTitle == taskTitle)&&(identical(other.scheduledAtUtc, scheduledAtUtc) || other.scheduledAtUtc == scheduledAtUtc)&&(identical(other.executedAtUtc, executedAtUtc) || other.executedAtUtc == executedAtUtc)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.createdTaskId, createdTaskId) || other.createdTaskId == createdTaskId)&&(identical(other.createdTaskKey, createdTaskKey) || other.createdTaskKey == createdTaskKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recurrenceRuleId,sourceTaskId,taskKey,taskTitle,scheduledAtUtc,executedAtUtc,outcome,createdTaskId,createdTaskKey);

@override
String toString() {
  return 'ProjectTaskRecurrenceRunResponse(id: $id, recurrenceRuleId: $recurrenceRuleId, sourceTaskId: $sourceTaskId, taskKey: $taskKey, taskTitle: $taskTitle, scheduledAtUtc: $scheduledAtUtc, executedAtUtc: $executedAtUtc, outcome: $outcome, createdTaskId: $createdTaskId, createdTaskKey: $createdTaskKey)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskRecurrenceRunResponseCopyWith<$Res> implements $ProjectTaskRecurrenceRunResponseCopyWith<$Res> {
  factory _$ProjectTaskRecurrenceRunResponseCopyWith(_ProjectTaskRecurrenceRunResponse value, $Res Function(_ProjectTaskRecurrenceRunResponse) _then) = __$ProjectTaskRecurrenceRunResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String recurrenceRuleId, String sourceTaskId, String taskKey, String taskTitle, DateTime scheduledAtUtc, DateTime executedAtUtc, TaskRecurrenceRunOutcome outcome, String? createdTaskId, String? createdTaskKey
});




}
/// @nodoc
class __$ProjectTaskRecurrenceRunResponseCopyWithImpl<$Res>
    implements _$ProjectTaskRecurrenceRunResponseCopyWith<$Res> {
  __$ProjectTaskRecurrenceRunResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskRecurrenceRunResponse _self;
  final $Res Function(_ProjectTaskRecurrenceRunResponse) _then;

/// Create a copy of ProjectTaskRecurrenceRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recurrenceRuleId = null,Object? sourceTaskId = null,Object? taskKey = null,Object? taskTitle = null,Object? scheduledAtUtc = null,Object? executedAtUtc = null,Object? outcome = null,Object? createdTaskId = freezed,Object? createdTaskKey = freezed,}) {
  return _then(_ProjectTaskRecurrenceRunResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recurrenceRuleId: null == recurrenceRuleId ? _self.recurrenceRuleId : recurrenceRuleId // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,taskKey: null == taskKey ? _self.taskKey : taskKey // ignore: cast_nullable_to_non_nullable
as String,taskTitle: null == taskTitle ? _self.taskTitle : taskTitle // ignore: cast_nullable_to_non_nullable
as String,scheduledAtUtc: null == scheduledAtUtc ? _self.scheduledAtUtc : scheduledAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,executedAtUtc: null == executedAtUtc ? _self.executedAtUtc : executedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceRunOutcome,createdTaskId: freezed == createdTaskId ? _self.createdTaskId : createdTaskId // ignore: cast_nullable_to_non_nullable
as String?,createdTaskKey: freezed == createdTaskKey ? _self.createdTaskKey : createdTaskKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateProjectTaskWorkflowStatusPayload {

 ProjectTaskStatus get status; String get displayName; String get color; int get position; bool get isInitial; bool get isTerminal; TaskStatusCategory? get category;
/// Create a copy of UpdateProjectTaskWorkflowStatusPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProjectTaskWorkflowStatusPayloadCopyWith<UpdateProjectTaskWorkflowStatusPayload> get copyWith => _$UpdateProjectTaskWorkflowStatusPayloadCopyWithImpl<UpdateProjectTaskWorkflowStatusPayload>(this as UpdateProjectTaskWorkflowStatusPayload, _$identity);

  /// Serializes this UpdateProjectTaskWorkflowStatusPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProjectTaskWorkflowStatusPayload&&(identical(other.status, status) || other.status == status)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.isInitial, isInitial) || other.isInitial == isInitial)&&(identical(other.isTerminal, isTerminal) || other.isTerminal == isTerminal)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,displayName,color,position,isInitial,isTerminal,category);

@override
String toString() {
  return 'UpdateProjectTaskWorkflowStatusPayload(status: $status, displayName: $displayName, color: $color, position: $position, isInitial: $isInitial, isTerminal: $isTerminal, category: $category)';
}


}

/// @nodoc
abstract mixin class $UpdateProjectTaskWorkflowStatusPayloadCopyWith<$Res>  {
  factory $UpdateProjectTaskWorkflowStatusPayloadCopyWith(UpdateProjectTaskWorkflowStatusPayload value, $Res Function(UpdateProjectTaskWorkflowStatusPayload) _then) = _$UpdateProjectTaskWorkflowStatusPayloadCopyWithImpl;
@useResult
$Res call({
 ProjectTaskStatus status, String displayName, String color, int position, bool isInitial, bool isTerminal, TaskStatusCategory? category
});




}
/// @nodoc
class _$UpdateProjectTaskWorkflowStatusPayloadCopyWithImpl<$Res>
    implements $UpdateProjectTaskWorkflowStatusPayloadCopyWith<$Res> {
  _$UpdateProjectTaskWorkflowStatusPayloadCopyWithImpl(this._self, this._then);

  final UpdateProjectTaskWorkflowStatusPayload _self;
  final $Res Function(UpdateProjectTaskWorkflowStatusPayload) _then;

/// Create a copy of UpdateProjectTaskWorkflowStatusPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? displayName = null,Object? color = null,Object? position = null,Object? isInitial = null,Object? isTerminal = null,Object? category = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isInitial: null == isInitial ? _self.isInitial : isInitial // ignore: cast_nullable_to_non_nullable
as bool,isTerminal: null == isTerminal ? _self.isTerminal : isTerminal // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProjectTaskWorkflowStatusPayload].
extension UpdateProjectTaskWorkflowStatusPayloadPatterns on UpdateProjectTaskWorkflowStatusPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProjectTaskWorkflowStatusPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowStatusPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProjectTaskWorkflowStatusPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowStatusPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProjectTaskWorkflowStatusPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowStatusPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectTaskStatus status,  String displayName,  String color,  int position,  bool isInitial,  bool isTerminal,  TaskStatusCategory? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowStatusPayload() when $default != null:
return $default(_that.status,_that.displayName,_that.color,_that.position,_that.isInitial,_that.isTerminal,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectTaskStatus status,  String displayName,  String color,  int position,  bool isInitial,  bool isTerminal,  TaskStatusCategory? category)  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowStatusPayload():
return $default(_that.status,_that.displayName,_that.color,_that.position,_that.isInitial,_that.isTerminal,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectTaskStatus status,  String displayName,  String color,  int position,  bool isInitial,  bool isTerminal,  TaskStatusCategory? category)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowStatusPayload() when $default != null:
return $default(_that.status,_that.displayName,_that.color,_that.position,_that.isInitial,_that.isTerminal,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProjectTaskWorkflowStatusPayload implements UpdateProjectTaskWorkflowStatusPayload {
  const _UpdateProjectTaskWorkflowStatusPayload({required this.status, required this.displayName, required this.color, required this.position, required this.isInitial, required this.isTerminal, this.category});
  factory _UpdateProjectTaskWorkflowStatusPayload.fromJson(Map<String, dynamic> json) => _$UpdateProjectTaskWorkflowStatusPayloadFromJson(json);

@override final  ProjectTaskStatus status;
@override final  String displayName;
@override final  String color;
@override final  int position;
@override final  bool isInitial;
@override final  bool isTerminal;
@override final  TaskStatusCategory? category;

/// Create a copy of UpdateProjectTaskWorkflowStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProjectTaskWorkflowStatusPayloadCopyWith<_UpdateProjectTaskWorkflowStatusPayload> get copyWith => __$UpdateProjectTaskWorkflowStatusPayloadCopyWithImpl<_UpdateProjectTaskWorkflowStatusPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProjectTaskWorkflowStatusPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProjectTaskWorkflowStatusPayload&&(identical(other.status, status) || other.status == status)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.isInitial, isInitial) || other.isInitial == isInitial)&&(identical(other.isTerminal, isTerminal) || other.isTerminal == isTerminal)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,displayName,color,position,isInitial,isTerminal,category);

@override
String toString() {
  return 'UpdateProjectTaskWorkflowStatusPayload(status: $status, displayName: $displayName, color: $color, position: $position, isInitial: $isInitial, isTerminal: $isTerminal, category: $category)';
}


}

/// @nodoc
abstract mixin class _$UpdateProjectTaskWorkflowStatusPayloadCopyWith<$Res> implements $UpdateProjectTaskWorkflowStatusPayloadCopyWith<$Res> {
  factory _$UpdateProjectTaskWorkflowStatusPayloadCopyWith(_UpdateProjectTaskWorkflowStatusPayload value, $Res Function(_UpdateProjectTaskWorkflowStatusPayload) _then) = __$UpdateProjectTaskWorkflowStatusPayloadCopyWithImpl;
@override @useResult
$Res call({
 ProjectTaskStatus status, String displayName, String color, int position, bool isInitial, bool isTerminal, TaskStatusCategory? category
});




}
/// @nodoc
class __$UpdateProjectTaskWorkflowStatusPayloadCopyWithImpl<$Res>
    implements _$UpdateProjectTaskWorkflowStatusPayloadCopyWith<$Res> {
  __$UpdateProjectTaskWorkflowStatusPayloadCopyWithImpl(this._self, this._then);

  final _UpdateProjectTaskWorkflowStatusPayload _self;
  final $Res Function(_UpdateProjectTaskWorkflowStatusPayload) _then;

/// Create a copy of UpdateProjectTaskWorkflowStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? displayName = null,Object? color = null,Object? position = null,Object? isInitial = null,Object? isTerminal = null,Object? category = freezed,}) {
  return _then(_UpdateProjectTaskWorkflowStatusPayload(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isInitial: null == isInitial ? _self.isInitial : isInitial // ignore: cast_nullable_to_non_nullable
as bool,isTerminal: null == isTerminal ? _self.isTerminal : isTerminal // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory?,
  ));
}


}


/// @nodoc
mixin _$UpdateProjectTaskWorkflowPayload {

 List<UpdateProjectTaskWorkflowStatusPayload> get statuses; List<ProjectTaskWorkflowTransitionResponse> get transitions; int get expectedVersion;
/// Create a copy of UpdateProjectTaskWorkflowPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProjectTaskWorkflowPayloadCopyWith<UpdateProjectTaskWorkflowPayload> get copyWith => _$UpdateProjectTaskWorkflowPayloadCopyWithImpl<UpdateProjectTaskWorkflowPayload>(this as UpdateProjectTaskWorkflowPayload, _$identity);

  /// Serializes this UpdateProjectTaskWorkflowPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProjectTaskWorkflowPayload&&const DeepCollectionEquality().equals(other.statuses, statuses)&&const DeepCollectionEquality().equals(other.transitions, transitions)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(statuses),const DeepCollectionEquality().hash(transitions),expectedVersion);

@override
String toString() {
  return 'UpdateProjectTaskWorkflowPayload(statuses: $statuses, transitions: $transitions, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateProjectTaskWorkflowPayloadCopyWith<$Res>  {
  factory $UpdateProjectTaskWorkflowPayloadCopyWith(UpdateProjectTaskWorkflowPayload value, $Res Function(UpdateProjectTaskWorkflowPayload) _then) = _$UpdateProjectTaskWorkflowPayloadCopyWithImpl;
@useResult
$Res call({
 List<UpdateProjectTaskWorkflowStatusPayload> statuses, List<ProjectTaskWorkflowTransitionResponse> transitions, int expectedVersion
});




}
/// @nodoc
class _$UpdateProjectTaskWorkflowPayloadCopyWithImpl<$Res>
    implements $UpdateProjectTaskWorkflowPayloadCopyWith<$Res> {
  _$UpdateProjectTaskWorkflowPayloadCopyWithImpl(this._self, this._then);

  final UpdateProjectTaskWorkflowPayload _self;
  final $Res Function(UpdateProjectTaskWorkflowPayload) _then;

/// Create a copy of UpdateProjectTaskWorkflowPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statuses = null,Object? transitions = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<UpdateProjectTaskWorkflowStatusPayload>,transitions: null == transitions ? _self.transitions : transitions // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskWorkflowTransitionResponse>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProjectTaskWorkflowPayload].
extension UpdateProjectTaskWorkflowPayloadPatterns on UpdateProjectTaskWorkflowPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProjectTaskWorkflowPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProjectTaskWorkflowPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProjectTaskWorkflowPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<UpdateProjectTaskWorkflowStatusPayload> statuses,  List<ProjectTaskWorkflowTransitionResponse> transitions,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowPayload() when $default != null:
return $default(_that.statuses,_that.transitions,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<UpdateProjectTaskWorkflowStatusPayload> statuses,  List<ProjectTaskWorkflowTransitionResponse> transitions,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowPayload():
return $default(_that.statuses,_that.transitions,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<UpdateProjectTaskWorkflowStatusPayload> statuses,  List<ProjectTaskWorkflowTransitionResponse> transitions,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectTaskWorkflowPayload() when $default != null:
return $default(_that.statuses,_that.transitions,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProjectTaskWorkflowPayload implements UpdateProjectTaskWorkflowPayload {
  const _UpdateProjectTaskWorkflowPayload({required this.statuses, required this.transitions, required this.expectedVersion});
  factory _UpdateProjectTaskWorkflowPayload.fromJson(Map<String, dynamic> json) => _$UpdateProjectTaskWorkflowPayloadFromJson(json);

@override final  List<UpdateProjectTaskWorkflowStatusPayload> statuses;
@override final  List<ProjectTaskWorkflowTransitionResponse> transitions;
@override final  int expectedVersion;

/// Create a copy of UpdateProjectTaskWorkflowPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProjectTaskWorkflowPayloadCopyWith<_UpdateProjectTaskWorkflowPayload> get copyWith => __$UpdateProjectTaskWorkflowPayloadCopyWithImpl<_UpdateProjectTaskWorkflowPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProjectTaskWorkflowPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProjectTaskWorkflowPayload&&const DeepCollectionEquality().equals(other.statuses, statuses)&&const DeepCollectionEquality().equals(other.transitions, transitions)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(statuses),const DeepCollectionEquality().hash(transitions),expectedVersion);

@override
String toString() {
  return 'UpdateProjectTaskWorkflowPayload(statuses: $statuses, transitions: $transitions, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateProjectTaskWorkflowPayloadCopyWith<$Res> implements $UpdateProjectTaskWorkflowPayloadCopyWith<$Res> {
  factory _$UpdateProjectTaskWorkflowPayloadCopyWith(_UpdateProjectTaskWorkflowPayload value, $Res Function(_UpdateProjectTaskWorkflowPayload) _then) = __$UpdateProjectTaskWorkflowPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<UpdateProjectTaskWorkflowStatusPayload> statuses, List<ProjectTaskWorkflowTransitionResponse> transitions, int expectedVersion
});




}
/// @nodoc
class __$UpdateProjectTaskWorkflowPayloadCopyWithImpl<$Res>
    implements _$UpdateProjectTaskWorkflowPayloadCopyWith<$Res> {
  __$UpdateProjectTaskWorkflowPayloadCopyWithImpl(this._self, this._then);

  final _UpdateProjectTaskWorkflowPayload _self;
  final $Res Function(_UpdateProjectTaskWorkflowPayload) _then;

/// Create a copy of UpdateProjectTaskWorkflowPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statuses = null,Object? transitions = null,Object? expectedVersion = null,}) {
  return _then(_UpdateProjectTaskWorkflowPayload(
statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<UpdateProjectTaskWorkflowStatusPayload>,transitions: null == transitions ? _self.transitions : transitions // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskWorkflowTransitionResponse>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TaskHistoryActorResponse {

 TaskActorType get type; String? get coreUserId;
/// Create a copy of TaskHistoryActorResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskHistoryActorResponseCopyWith<TaskHistoryActorResponse> get copyWith => _$TaskHistoryActorResponseCopyWithImpl<TaskHistoryActorResponse>(this as TaskHistoryActorResponse, _$identity);

  /// Serializes this TaskHistoryActorResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskHistoryActorResponse&&(identical(other.type, type) || other.type == type)&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,coreUserId);

@override
String toString() {
  return 'TaskHistoryActorResponse(type: $type, coreUserId: $coreUserId)';
}


}

/// @nodoc
abstract mixin class $TaskHistoryActorResponseCopyWith<$Res>  {
  factory $TaskHistoryActorResponseCopyWith(TaskHistoryActorResponse value, $Res Function(TaskHistoryActorResponse) _then) = _$TaskHistoryActorResponseCopyWithImpl;
@useResult
$Res call({
 TaskActorType type, String? coreUserId
});




}
/// @nodoc
class _$TaskHistoryActorResponseCopyWithImpl<$Res>
    implements $TaskHistoryActorResponseCopyWith<$Res> {
  _$TaskHistoryActorResponseCopyWithImpl(this._self, this._then);

  final TaskHistoryActorResponse _self;
  final $Res Function(TaskHistoryActorResponse) _then;

/// Create a copy of TaskHistoryActorResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? coreUserId = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskActorType,coreUserId: freezed == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskHistoryActorResponse].
extension TaskHistoryActorResponsePatterns on TaskHistoryActorResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskHistoryActorResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskHistoryActorResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskHistoryActorResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskHistoryActorResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskHistoryActorResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskHistoryActorResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskActorType type,  String? coreUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskHistoryActorResponse() when $default != null:
return $default(_that.type,_that.coreUserId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskActorType type,  String? coreUserId)  $default,) {final _that = this;
switch (_that) {
case _TaskHistoryActorResponse():
return $default(_that.type,_that.coreUserId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskActorType type,  String? coreUserId)?  $default,) {final _that = this;
switch (_that) {
case _TaskHistoryActorResponse() when $default != null:
return $default(_that.type,_that.coreUserId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskHistoryActorResponse implements TaskHistoryActorResponse {
  const _TaskHistoryActorResponse({required this.type, this.coreUserId});
  factory _TaskHistoryActorResponse.fromJson(Map<String, dynamic> json) => _$TaskHistoryActorResponseFromJson(json);

@override final  TaskActorType type;
@override final  String? coreUserId;

/// Create a copy of TaskHistoryActorResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskHistoryActorResponseCopyWith<_TaskHistoryActorResponse> get copyWith => __$TaskHistoryActorResponseCopyWithImpl<_TaskHistoryActorResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskHistoryActorResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskHistoryActorResponse&&(identical(other.type, type) || other.type == type)&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,coreUserId);

@override
String toString() {
  return 'TaskHistoryActorResponse(type: $type, coreUserId: $coreUserId)';
}


}

/// @nodoc
abstract mixin class _$TaskHistoryActorResponseCopyWith<$Res> implements $TaskHistoryActorResponseCopyWith<$Res> {
  factory _$TaskHistoryActorResponseCopyWith(_TaskHistoryActorResponse value, $Res Function(_TaskHistoryActorResponse) _then) = __$TaskHistoryActorResponseCopyWithImpl;
@override @useResult
$Res call({
 TaskActorType type, String? coreUserId
});




}
/// @nodoc
class __$TaskHistoryActorResponseCopyWithImpl<$Res>
    implements _$TaskHistoryActorResponseCopyWith<$Res> {
  __$TaskHistoryActorResponseCopyWithImpl(this._self, this._then);

  final _TaskHistoryActorResponse _self;
  final $Res Function(_TaskHistoryActorResponse) _then;

/// Create a copy of TaskHistoryActorResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? coreUserId = freezed,}) {
  return _then(_TaskHistoryActorResponse(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskActorType,coreUserId: freezed == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TaskHistoryChangeResponse {

 String get field; Object? get before; Object? get after;
/// Create a copy of TaskHistoryChangeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskHistoryChangeResponseCopyWith<TaskHistoryChangeResponse> get copyWith => _$TaskHistoryChangeResponseCopyWithImpl<TaskHistoryChangeResponse>(this as TaskHistoryChangeResponse, _$identity);

  /// Serializes this TaskHistoryChangeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskHistoryChangeResponse&&(identical(other.field, field) || other.field == field)&&const DeepCollectionEquality().equals(other.before, before)&&const DeepCollectionEquality().equals(other.after, after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,const DeepCollectionEquality().hash(before),const DeepCollectionEquality().hash(after));

@override
String toString() {
  return 'TaskHistoryChangeResponse(field: $field, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class $TaskHistoryChangeResponseCopyWith<$Res>  {
  factory $TaskHistoryChangeResponseCopyWith(TaskHistoryChangeResponse value, $Res Function(TaskHistoryChangeResponse) _then) = _$TaskHistoryChangeResponseCopyWithImpl;
@useResult
$Res call({
 String field, Object? before, Object? after
});




}
/// @nodoc
class _$TaskHistoryChangeResponseCopyWithImpl<$Res>
    implements $TaskHistoryChangeResponseCopyWith<$Res> {
  _$TaskHistoryChangeResponseCopyWithImpl(this._self, this._then);

  final TaskHistoryChangeResponse _self;
  final $Res Function(TaskHistoryChangeResponse) _then;

/// Create a copy of TaskHistoryChangeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? before = freezed,Object? after = freezed,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,before: freezed == before ? _self.before : before ,after: freezed == after ? _self.after : after ,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskHistoryChangeResponse].
extension TaskHistoryChangeResponsePatterns on TaskHistoryChangeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskHistoryChangeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskHistoryChangeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskHistoryChangeResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskHistoryChangeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskHistoryChangeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskHistoryChangeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field,  Object? before,  Object? after)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskHistoryChangeResponse() when $default != null:
return $default(_that.field,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field,  Object? before,  Object? after)  $default,) {final _that = this;
switch (_that) {
case _TaskHistoryChangeResponse():
return $default(_that.field,_that.before,_that.after);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field,  Object? before,  Object? after)?  $default,) {final _that = this;
switch (_that) {
case _TaskHistoryChangeResponse() when $default != null:
return $default(_that.field,_that.before,_that.after);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskHistoryChangeResponse implements TaskHistoryChangeResponse {
  const _TaskHistoryChangeResponse({required this.field, this.before, this.after});
  factory _TaskHistoryChangeResponse.fromJson(Map<String, dynamic> json) => _$TaskHistoryChangeResponseFromJson(json);

@override final  String field;
@override final  Object? before;
@override final  Object? after;

/// Create a copy of TaskHistoryChangeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskHistoryChangeResponseCopyWith<_TaskHistoryChangeResponse> get copyWith => __$TaskHistoryChangeResponseCopyWithImpl<_TaskHistoryChangeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskHistoryChangeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskHistoryChangeResponse&&(identical(other.field, field) || other.field == field)&&const DeepCollectionEquality().equals(other.before, before)&&const DeepCollectionEquality().equals(other.after, after));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,const DeepCollectionEquality().hash(before),const DeepCollectionEquality().hash(after));

@override
String toString() {
  return 'TaskHistoryChangeResponse(field: $field, before: $before, after: $after)';
}


}

/// @nodoc
abstract mixin class _$TaskHistoryChangeResponseCopyWith<$Res> implements $TaskHistoryChangeResponseCopyWith<$Res> {
  factory _$TaskHistoryChangeResponseCopyWith(_TaskHistoryChangeResponse value, $Res Function(_TaskHistoryChangeResponse) _then) = __$TaskHistoryChangeResponseCopyWithImpl;
@override @useResult
$Res call({
 String field, Object? before, Object? after
});




}
/// @nodoc
class __$TaskHistoryChangeResponseCopyWithImpl<$Res>
    implements _$TaskHistoryChangeResponseCopyWith<$Res> {
  __$TaskHistoryChangeResponseCopyWithImpl(this._self, this._then);

  final _TaskHistoryChangeResponse _self;
  final $Res Function(_TaskHistoryChangeResponse) _then;

/// Create a copy of TaskHistoryChangeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? before = freezed,Object? after = freezed,}) {
  return _then(_TaskHistoryChangeResponse(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,before: freezed == before ? _self.before : before ,after: freezed == after ? _self.after : after ,
  ));
}


}


/// @nodoc
mixin _$TaskHistoryEventResponse {

 String get eventId; TaskHistoryEventType get eventType; String get actionLabel; TaskHistoryActorResponse get actor; List<TaskHistoryChangeResponse> get changes; int get taskVersion; String get correlationId; DateTime get createdAtUtc;
/// Create a copy of TaskHistoryEventResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskHistoryEventResponseCopyWith<TaskHistoryEventResponse> get copyWith => _$TaskHistoryEventResponseCopyWithImpl<TaskHistoryEventResponse>(this as TaskHistoryEventResponse, _$identity);

  /// Serializes this TaskHistoryEventResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskHistoryEventResponse&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&(identical(other.actor, actor) || other.actor == actor)&&const DeepCollectionEquality().equals(other.changes, changes)&&(identical(other.taskVersion, taskVersion) || other.taskVersion == taskVersion)&&(identical(other.correlationId, correlationId) || other.correlationId == correlationId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,eventType,actionLabel,actor,const DeepCollectionEquality().hash(changes),taskVersion,correlationId,createdAtUtc);

@override
String toString() {
  return 'TaskHistoryEventResponse(eventId: $eventId, eventType: $eventType, actionLabel: $actionLabel, actor: $actor, changes: $changes, taskVersion: $taskVersion, correlationId: $correlationId, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskHistoryEventResponseCopyWith<$Res>  {
  factory $TaskHistoryEventResponseCopyWith(TaskHistoryEventResponse value, $Res Function(TaskHistoryEventResponse) _then) = _$TaskHistoryEventResponseCopyWithImpl;
@useResult
$Res call({
 String eventId, TaskHistoryEventType eventType, String actionLabel, TaskHistoryActorResponse actor, List<TaskHistoryChangeResponse> changes, int taskVersion, String correlationId, DateTime createdAtUtc
});


$TaskHistoryActorResponseCopyWith<$Res> get actor;

}
/// @nodoc
class _$TaskHistoryEventResponseCopyWithImpl<$Res>
    implements $TaskHistoryEventResponseCopyWith<$Res> {
  _$TaskHistoryEventResponseCopyWithImpl(this._self, this._then);

  final TaskHistoryEventResponse _self;
  final $Res Function(TaskHistoryEventResponse) _then;

/// Create a copy of TaskHistoryEventResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? eventType = null,Object? actionLabel = null,Object? actor = null,Object? changes = null,Object? taskVersion = null,Object? correlationId = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as TaskHistoryEventType,actionLabel: null == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String,actor: null == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as TaskHistoryActorResponse,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as List<TaskHistoryChangeResponse>,taskVersion: null == taskVersion ? _self.taskVersion : taskVersion // ignore: cast_nullable_to_non_nullable
as int,correlationId: null == correlationId ? _self.correlationId : correlationId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of TaskHistoryEventResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskHistoryActorResponseCopyWith<$Res> get actor {
  
  return $TaskHistoryActorResponseCopyWith<$Res>(_self.actor, (value) {
    return _then(_self.copyWith(actor: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskHistoryEventResponse].
extension TaskHistoryEventResponsePatterns on TaskHistoryEventResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskHistoryEventResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskHistoryEventResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskHistoryEventResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskHistoryEventResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskHistoryEventResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskHistoryEventResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  TaskHistoryEventType eventType,  String actionLabel,  TaskHistoryActorResponse actor,  List<TaskHistoryChangeResponse> changes,  int taskVersion,  String correlationId,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskHistoryEventResponse() when $default != null:
return $default(_that.eventId,_that.eventType,_that.actionLabel,_that.actor,_that.changes,_that.taskVersion,_that.correlationId,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  TaskHistoryEventType eventType,  String actionLabel,  TaskHistoryActorResponse actor,  List<TaskHistoryChangeResponse> changes,  int taskVersion,  String correlationId,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskHistoryEventResponse():
return $default(_that.eventId,_that.eventType,_that.actionLabel,_that.actor,_that.changes,_that.taskVersion,_that.correlationId,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  TaskHistoryEventType eventType,  String actionLabel,  TaskHistoryActorResponse actor,  List<TaskHistoryChangeResponse> changes,  int taskVersion,  String correlationId,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskHistoryEventResponse() when $default != null:
return $default(_that.eventId,_that.eventType,_that.actionLabel,_that.actor,_that.changes,_that.taskVersion,_that.correlationId,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskHistoryEventResponse implements TaskHistoryEventResponse {
  const _TaskHistoryEventResponse({required this.eventId, required this.eventType, required this.actionLabel, required this.actor, required this.changes, required this.taskVersion, required this.correlationId, required this.createdAtUtc});
  factory _TaskHistoryEventResponse.fromJson(Map<String, dynamic> json) => _$TaskHistoryEventResponseFromJson(json);

@override final  String eventId;
@override final  TaskHistoryEventType eventType;
@override final  String actionLabel;
@override final  TaskHistoryActorResponse actor;
@override final  List<TaskHistoryChangeResponse> changes;
@override final  int taskVersion;
@override final  String correlationId;
@override final  DateTime createdAtUtc;

/// Create a copy of TaskHistoryEventResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskHistoryEventResponseCopyWith<_TaskHistoryEventResponse> get copyWith => __$TaskHistoryEventResponseCopyWithImpl<_TaskHistoryEventResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskHistoryEventResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskHistoryEventResponse&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&(identical(other.actor, actor) || other.actor == actor)&&const DeepCollectionEquality().equals(other.changes, changes)&&(identical(other.taskVersion, taskVersion) || other.taskVersion == taskVersion)&&(identical(other.correlationId, correlationId) || other.correlationId == correlationId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,eventType,actionLabel,actor,const DeepCollectionEquality().hash(changes),taskVersion,correlationId,createdAtUtc);

@override
String toString() {
  return 'TaskHistoryEventResponse(eventId: $eventId, eventType: $eventType, actionLabel: $actionLabel, actor: $actor, changes: $changes, taskVersion: $taskVersion, correlationId: $correlationId, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskHistoryEventResponseCopyWith<$Res> implements $TaskHistoryEventResponseCopyWith<$Res> {
  factory _$TaskHistoryEventResponseCopyWith(_TaskHistoryEventResponse value, $Res Function(_TaskHistoryEventResponse) _then) = __$TaskHistoryEventResponseCopyWithImpl;
@override @useResult
$Res call({
 String eventId, TaskHistoryEventType eventType, String actionLabel, TaskHistoryActorResponse actor, List<TaskHistoryChangeResponse> changes, int taskVersion, String correlationId, DateTime createdAtUtc
});


@override $TaskHistoryActorResponseCopyWith<$Res> get actor;

}
/// @nodoc
class __$TaskHistoryEventResponseCopyWithImpl<$Res>
    implements _$TaskHistoryEventResponseCopyWith<$Res> {
  __$TaskHistoryEventResponseCopyWithImpl(this._self, this._then);

  final _TaskHistoryEventResponse _self;
  final $Res Function(_TaskHistoryEventResponse) _then;

/// Create a copy of TaskHistoryEventResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? eventType = null,Object? actionLabel = null,Object? actor = null,Object? changes = null,Object? taskVersion = null,Object? correlationId = null,Object? createdAtUtc = null,}) {
  return _then(_TaskHistoryEventResponse(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as TaskHistoryEventType,actionLabel: null == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String,actor: null == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as TaskHistoryActorResponse,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as List<TaskHistoryChangeResponse>,taskVersion: null == taskVersion ? _self.taskVersion : taskVersion // ignore: cast_nullable_to_non_nullable
as int,correlationId: null == correlationId ? _self.correlationId : correlationId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of TaskHistoryEventResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskHistoryActorResponseCopyWith<$Res> get actor {
  
  return $TaskHistoryActorResponseCopyWith<$Res>(_self.actor, (value) {
    return _then(_self.copyWith(actor: value));
  });
}
}


/// @nodoc
mixin _$TaskTimelineItemResponse {

 String get id; int get number; String get key; String? get parentTaskId; String get title; String get taskType; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; int? get estimatedMinutes; int get position; List<TaskAssigneeResponse> get assignees; int get checklistCompletedCount; int get checklistTotalCount; int get version;
/// Create a copy of TaskTimelineItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskTimelineItemResponseCopyWith<TaskTimelineItemResponse> get copyWith => _$TaskTimelineItemResponseCopyWithImpl<TaskTimelineItemResponse>(this as TaskTimelineItemResponse, _$identity);

  /// Serializes this TaskTimelineItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskTimelineItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&(identical(other.checklistCompletedCount, checklistCompletedCount) || other.checklistCompletedCount == checklistCompletedCount)&&(identical(other.checklistTotalCount, checklistTotalCount) || other.checklistTotalCount == checklistTotalCount)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,parentTaskId,title,taskType,status,priority,startAtUtc,dueAtUtc,estimatedMinutes,position,const DeepCollectionEquality().hash(assignees),checklistCompletedCount,checklistTotalCount,version);

@override
String toString() {
  return 'TaskTimelineItemResponse(id: $id, number: $number, key: $key, parentTaskId: $parentTaskId, title: $title, taskType: $taskType, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, estimatedMinutes: $estimatedMinutes, position: $position, assignees: $assignees, checklistCompletedCount: $checklistCompletedCount, checklistTotalCount: $checklistTotalCount, version: $version)';
}


}

/// @nodoc
abstract mixin class $TaskTimelineItemResponseCopyWith<$Res>  {
  factory $TaskTimelineItemResponseCopyWith(TaskTimelineItemResponse value, $Res Function(TaskTimelineItemResponse) _then) = _$TaskTimelineItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String? parentTaskId, String title, String taskType, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, int? estimatedMinutes, int position, List<TaskAssigneeResponse> assignees, int checklistCompletedCount, int checklistTotalCount, int version
});




}
/// @nodoc
class _$TaskTimelineItemResponseCopyWithImpl<$Res>
    implements $TaskTimelineItemResponseCopyWith<$Res> {
  _$TaskTimelineItemResponseCopyWithImpl(this._self, this._then);

  final TaskTimelineItemResponse _self;
  final $Res Function(TaskTimelineItemResponse) _then;

/// Create a copy of TaskTimelineItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? parentTaskId = freezed,Object? title = null,Object? taskType = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? estimatedMinutes = freezed,Object? position = null,Object? assignees = null,Object? checklistCompletedCount = null,Object? checklistTotalCount = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<TaskAssigneeResponse>,checklistCompletedCount: null == checklistCompletedCount ? _self.checklistCompletedCount : checklistCompletedCount // ignore: cast_nullable_to_non_nullable
as int,checklistTotalCount: null == checklistTotalCount ? _self.checklistTotalCount : checklistTotalCount // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskTimelineItemResponse].
extension TaskTimelineItemResponsePatterns on TaskTimelineItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskTimelineItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskTimelineItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskTimelineItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskTimelineItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskTimelineItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskTimelineItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String? parentTaskId,  String title,  String taskType,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  int? estimatedMinutes,  int position,  List<TaskAssigneeResponse> assignees,  int checklistCompletedCount,  int checklistTotalCount,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskTimelineItemResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.parentTaskId,_that.title,_that.taskType,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.estimatedMinutes,_that.position,_that.assignees,_that.checklistCompletedCount,_that.checklistTotalCount,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String? parentTaskId,  String title,  String taskType,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  int? estimatedMinutes,  int position,  List<TaskAssigneeResponse> assignees,  int checklistCompletedCount,  int checklistTotalCount,  int version)  $default,) {final _that = this;
switch (_that) {
case _TaskTimelineItemResponse():
return $default(_that.id,_that.number,_that.key,_that.parentTaskId,_that.title,_that.taskType,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.estimatedMinutes,_that.position,_that.assignees,_that.checklistCompletedCount,_that.checklistTotalCount,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String? parentTaskId,  String title,  String taskType,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  int? estimatedMinutes,  int position,  List<TaskAssigneeResponse> assignees,  int checklistCompletedCount,  int checklistTotalCount,  int version)?  $default,) {final _that = this;
switch (_that) {
case _TaskTimelineItemResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.parentTaskId,_that.title,_that.taskType,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.estimatedMinutes,_that.position,_that.assignees,_that.checklistCompletedCount,_that.checklistTotalCount,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskTimelineItemResponse implements TaskTimelineItemResponse {
  const _TaskTimelineItemResponse({required this.id, required this.number, required this.key, this.parentTaskId, required this.title, required this.taskType, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, this.estimatedMinutes, required this.position, required this.assignees, required this.checklistCompletedCount, required this.checklistTotalCount, required this.version});
  factory _TaskTimelineItemResponse.fromJson(Map<String, dynamic> json) => _$TaskTimelineItemResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String key;
@override final  String? parentTaskId;
@override final  String title;
@override final  String taskType;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  int? estimatedMinutes;
@override final  int position;
@override final  List<TaskAssigneeResponse> assignees;
@override final  int checklistCompletedCount;
@override final  int checklistTotalCount;
@override final  int version;

/// Create a copy of TaskTimelineItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskTimelineItemResponseCopyWith<_TaskTimelineItemResponse> get copyWith => __$TaskTimelineItemResponseCopyWithImpl<_TaskTimelineItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskTimelineItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskTimelineItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&(identical(other.checklistCompletedCount, checklistCompletedCount) || other.checklistCompletedCount == checklistCompletedCount)&&(identical(other.checklistTotalCount, checklistTotalCount) || other.checklistTotalCount == checklistTotalCount)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,parentTaskId,title,taskType,status,priority,startAtUtc,dueAtUtc,estimatedMinutes,position,const DeepCollectionEquality().hash(assignees),checklistCompletedCount,checklistTotalCount,version);

@override
String toString() {
  return 'TaskTimelineItemResponse(id: $id, number: $number, key: $key, parentTaskId: $parentTaskId, title: $title, taskType: $taskType, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, estimatedMinutes: $estimatedMinutes, position: $position, assignees: $assignees, checklistCompletedCount: $checklistCompletedCount, checklistTotalCount: $checklistTotalCount, version: $version)';
}


}

/// @nodoc
abstract mixin class _$TaskTimelineItemResponseCopyWith<$Res> implements $TaskTimelineItemResponseCopyWith<$Res> {
  factory _$TaskTimelineItemResponseCopyWith(_TaskTimelineItemResponse value, $Res Function(_TaskTimelineItemResponse) _then) = __$TaskTimelineItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String? parentTaskId, String title, String taskType, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, int? estimatedMinutes, int position, List<TaskAssigneeResponse> assignees, int checklistCompletedCount, int checklistTotalCount, int version
});




}
/// @nodoc
class __$TaskTimelineItemResponseCopyWithImpl<$Res>
    implements _$TaskTimelineItemResponseCopyWith<$Res> {
  __$TaskTimelineItemResponseCopyWithImpl(this._self, this._then);

  final _TaskTimelineItemResponse _self;
  final $Res Function(_TaskTimelineItemResponse) _then;

/// Create a copy of TaskTimelineItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? parentTaskId = freezed,Object? title = null,Object? taskType = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? estimatedMinutes = freezed,Object? position = null,Object? assignees = null,Object? checklistCompletedCount = null,Object? checklistTotalCount = null,Object? version = null,}) {
  return _then(_TaskTimelineItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<TaskAssigneeResponse>,checklistCompletedCount: null == checklistCompletedCount ? _self.checklistCompletedCount : checklistCompletedCount // ignore: cast_nullable_to_non_nullable
as int,checklistTotalCount: null == checklistTotalCount ? _self.checklistTotalCount : checklistTotalCount // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TaskTimelineDependencyResponse {

 String get id; String get sourceTaskId; String get targetTaskId; TaskDependencyType get type;
/// Create a copy of TaskTimelineDependencyResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskTimelineDependencyResponseCopyWith<TaskTimelineDependencyResponse> get copyWith => _$TaskTimelineDependencyResponseCopyWithImpl<TaskTimelineDependencyResponse>(this as TaskTimelineDependencyResponse, _$identity);

  /// Serializes this TaskTimelineDependencyResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskTimelineDependencyResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.targetTaskId, targetTaskId) || other.targetTaskId == targetTaskId)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceTaskId,targetTaskId,type);

@override
String toString() {
  return 'TaskTimelineDependencyResponse(id: $id, sourceTaskId: $sourceTaskId, targetTaskId: $targetTaskId, type: $type)';
}


}

/// @nodoc
abstract mixin class $TaskTimelineDependencyResponseCopyWith<$Res>  {
  factory $TaskTimelineDependencyResponseCopyWith(TaskTimelineDependencyResponse value, $Res Function(TaskTimelineDependencyResponse) _then) = _$TaskTimelineDependencyResponseCopyWithImpl;
@useResult
$Res call({
 String id, String sourceTaskId, String targetTaskId, TaskDependencyType type
});




}
/// @nodoc
class _$TaskTimelineDependencyResponseCopyWithImpl<$Res>
    implements $TaskTimelineDependencyResponseCopyWith<$Res> {
  _$TaskTimelineDependencyResponseCopyWithImpl(this._self, this._then);

  final TaskTimelineDependencyResponse _self;
  final $Res Function(TaskTimelineDependencyResponse) _then;

/// Create a copy of TaskTimelineDependencyResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceTaskId = null,Object? targetTaskId = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,targetTaskId: null == targetTaskId ? _self.targetTaskId : targetTaskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskDependencyType,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskTimelineDependencyResponse].
extension TaskTimelineDependencyResponsePatterns on TaskTimelineDependencyResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskTimelineDependencyResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskTimelineDependencyResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskTimelineDependencyResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskTimelineDependencyResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskTimelineDependencyResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskTimelineDependencyResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceTaskId,  String targetTaskId,  TaskDependencyType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskTimelineDependencyResponse() when $default != null:
return $default(_that.id,_that.sourceTaskId,_that.targetTaskId,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceTaskId,  String targetTaskId,  TaskDependencyType type)  $default,) {final _that = this;
switch (_that) {
case _TaskTimelineDependencyResponse():
return $default(_that.id,_that.sourceTaskId,_that.targetTaskId,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceTaskId,  String targetTaskId,  TaskDependencyType type)?  $default,) {final _that = this;
switch (_that) {
case _TaskTimelineDependencyResponse() when $default != null:
return $default(_that.id,_that.sourceTaskId,_that.targetTaskId,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskTimelineDependencyResponse implements TaskTimelineDependencyResponse {
  const _TaskTimelineDependencyResponse({required this.id, required this.sourceTaskId, required this.targetTaskId, required this.type});
  factory _TaskTimelineDependencyResponse.fromJson(Map<String, dynamic> json) => _$TaskTimelineDependencyResponseFromJson(json);

@override final  String id;
@override final  String sourceTaskId;
@override final  String targetTaskId;
@override final  TaskDependencyType type;

/// Create a copy of TaskTimelineDependencyResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskTimelineDependencyResponseCopyWith<_TaskTimelineDependencyResponse> get copyWith => __$TaskTimelineDependencyResponseCopyWithImpl<_TaskTimelineDependencyResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskTimelineDependencyResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskTimelineDependencyResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.targetTaskId, targetTaskId) || other.targetTaskId == targetTaskId)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceTaskId,targetTaskId,type);

@override
String toString() {
  return 'TaskTimelineDependencyResponse(id: $id, sourceTaskId: $sourceTaskId, targetTaskId: $targetTaskId, type: $type)';
}


}

/// @nodoc
abstract mixin class _$TaskTimelineDependencyResponseCopyWith<$Res> implements $TaskTimelineDependencyResponseCopyWith<$Res> {
  factory _$TaskTimelineDependencyResponseCopyWith(_TaskTimelineDependencyResponse value, $Res Function(_TaskTimelineDependencyResponse) _then) = __$TaskTimelineDependencyResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceTaskId, String targetTaskId, TaskDependencyType type
});




}
/// @nodoc
class __$TaskTimelineDependencyResponseCopyWithImpl<$Res>
    implements _$TaskTimelineDependencyResponseCopyWith<$Res> {
  __$TaskTimelineDependencyResponseCopyWithImpl(this._self, this._then);

  final _TaskTimelineDependencyResponse _self;
  final $Res Function(_TaskTimelineDependencyResponse) _then;

/// Create a copy of TaskTimelineDependencyResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceTaskId = null,Object? targetTaskId = null,Object? type = null,}) {
  return _then(_TaskTimelineDependencyResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,targetTaskId: null == targetTaskId ? _self.targetTaskId : targetTaskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskDependencyType,
  ));
}


}


/// @nodoc
mixin _$TaskTimelineResponse {

 DateTime get fromUtc; DateTime get toUtc; List<TaskTimelineItemResponse> get items; List<TaskTimelineDependencyResponse> get dependencies; bool get isTruncated; String? get nextCursor;
/// Create a copy of TaskTimelineResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskTimelineResponseCopyWith<TaskTimelineResponse> get copyWith => _$TaskTimelineResponseCopyWithImpl<TaskTimelineResponse>(this as TaskTimelineResponse, _$identity);

  /// Serializes this TaskTimelineResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskTimelineResponse&&(identical(other.fromUtc, fromUtc) || other.fromUtc == fromUtc)&&(identical(other.toUtc, toUtc) || other.toUtc == toUtc)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&(identical(other.isTruncated, isTruncated) || other.isTruncated == isTruncated)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromUtc,toUtc,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(dependencies),isTruncated,nextCursor);

@override
String toString() {
  return 'TaskTimelineResponse(fromUtc: $fromUtc, toUtc: $toUtc, items: $items, dependencies: $dependencies, isTruncated: $isTruncated, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $TaskTimelineResponseCopyWith<$Res>  {
  factory $TaskTimelineResponseCopyWith(TaskTimelineResponse value, $Res Function(TaskTimelineResponse) _then) = _$TaskTimelineResponseCopyWithImpl;
@useResult
$Res call({
 DateTime fromUtc, DateTime toUtc, List<TaskTimelineItemResponse> items, List<TaskTimelineDependencyResponse> dependencies, bool isTruncated, String? nextCursor
});




}
/// @nodoc
class _$TaskTimelineResponseCopyWithImpl<$Res>
    implements $TaskTimelineResponseCopyWith<$Res> {
  _$TaskTimelineResponseCopyWithImpl(this._self, this._then);

  final TaskTimelineResponse _self;
  final $Res Function(TaskTimelineResponse) _then;

/// Create a copy of TaskTimelineResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromUtc = null,Object? toUtc = null,Object? items = null,Object? dependencies = null,Object? isTruncated = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
fromUtc: null == fromUtc ? _self.fromUtc : fromUtc // ignore: cast_nullable_to_non_nullable
as DateTime,toUtc: null == toUtc ? _self.toUtc : toUtc // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TaskTimelineItemResponse>,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<TaskTimelineDependencyResponse>,isTruncated: null == isTruncated ? _self.isTruncated : isTruncated // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskTimelineResponse].
extension TaskTimelineResponsePatterns on TaskTimelineResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskTimelineResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskTimelineResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskTimelineResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskTimelineResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskTimelineResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskTimelineResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime fromUtc,  DateTime toUtc,  List<TaskTimelineItemResponse> items,  List<TaskTimelineDependencyResponse> dependencies,  bool isTruncated,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskTimelineResponse() when $default != null:
return $default(_that.fromUtc,_that.toUtc,_that.items,_that.dependencies,_that.isTruncated,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime fromUtc,  DateTime toUtc,  List<TaskTimelineItemResponse> items,  List<TaskTimelineDependencyResponse> dependencies,  bool isTruncated,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _TaskTimelineResponse():
return $default(_that.fromUtc,_that.toUtc,_that.items,_that.dependencies,_that.isTruncated,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime fromUtc,  DateTime toUtc,  List<TaskTimelineItemResponse> items,  List<TaskTimelineDependencyResponse> dependencies,  bool isTruncated,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _TaskTimelineResponse() when $default != null:
return $default(_that.fromUtc,_that.toUtc,_that.items,_that.dependencies,_that.isTruncated,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskTimelineResponse implements TaskTimelineResponse {
  const _TaskTimelineResponse({required this.fromUtc, required this.toUtc, required this.items, required this.dependencies, required this.isTruncated, this.nextCursor});
  factory _TaskTimelineResponse.fromJson(Map<String, dynamic> json) => _$TaskTimelineResponseFromJson(json);

@override final  DateTime fromUtc;
@override final  DateTime toUtc;
@override final  List<TaskTimelineItemResponse> items;
@override final  List<TaskTimelineDependencyResponse> dependencies;
@override final  bool isTruncated;
@override final  String? nextCursor;

/// Create a copy of TaskTimelineResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskTimelineResponseCopyWith<_TaskTimelineResponse> get copyWith => __$TaskTimelineResponseCopyWithImpl<_TaskTimelineResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskTimelineResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskTimelineResponse&&(identical(other.fromUtc, fromUtc) || other.fromUtc == fromUtc)&&(identical(other.toUtc, toUtc) || other.toUtc == toUtc)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&(identical(other.isTruncated, isTruncated) || other.isTruncated == isTruncated)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromUtc,toUtc,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(dependencies),isTruncated,nextCursor);

@override
String toString() {
  return 'TaskTimelineResponse(fromUtc: $fromUtc, toUtc: $toUtc, items: $items, dependencies: $dependencies, isTruncated: $isTruncated, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$TaskTimelineResponseCopyWith<$Res> implements $TaskTimelineResponseCopyWith<$Res> {
  factory _$TaskTimelineResponseCopyWith(_TaskTimelineResponse value, $Res Function(_TaskTimelineResponse) _then) = __$TaskTimelineResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime fromUtc, DateTime toUtc, List<TaskTimelineItemResponse> items, List<TaskTimelineDependencyResponse> dependencies, bool isTruncated, String? nextCursor
});




}
/// @nodoc
class __$TaskTimelineResponseCopyWithImpl<$Res>
    implements _$TaskTimelineResponseCopyWith<$Res> {
  __$TaskTimelineResponseCopyWithImpl(this._self, this._then);

  final _TaskTimelineResponse _self;
  final $Res Function(_TaskTimelineResponse) _then;

/// Create a copy of TaskTimelineResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromUtc = null,Object? toUtc = null,Object? items = null,Object? dependencies = null,Object? isTruncated = null,Object? nextCursor = freezed,}) {
  return _then(_TaskTimelineResponse(
fromUtc: null == fromUtc ? _self.fromUtc : fromUtc // ignore: cast_nullable_to_non_nullable
as DateTime,toUtc: null == toUtc ? _self.toUtc : toUtc // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TaskTimelineItemResponse>,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<TaskTimelineDependencyResponse>,isTruncated: null == isTruncated ? _self.isTruncated : isTruncated // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TaskTimeEntryResponse {

 String get id; String get taskId; String get userId; TaskTimeEntryKind get kind; DateTime get startedAtUtc; DateTime? get stoppedAtUtc; int? get durationMinutes; String? get description; bool get isBillable; DateTime get createdAtUtc; TaskTimeEntryApprovalStatus get approvalStatus; String? get reviewedByCoreUserId; DateTime? get reviewedAtUtc; String? get reviewComment; int get version;
/// Create a copy of TaskTimeEntryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskTimeEntryResponseCopyWith<TaskTimeEntryResponse> get copyWith => _$TaskTimeEntryResponseCopyWithImpl<TaskTimeEntryResponse>(this as TaskTimeEntryResponse, _$identity);

  /// Serializes this TaskTimeEntryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskTimeEntryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.startedAtUtc, startedAtUtc) || other.startedAtUtc == startedAtUtc)&&(identical(other.stoppedAtUtc, stoppedAtUtc) || other.stoppedAtUtc == stoppedAtUtc)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.description, description) || other.description == description)&&(identical(other.isBillable, isBillable) || other.isBillable == isBillable)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.reviewedByCoreUserId, reviewedByCoreUserId) || other.reviewedByCoreUserId == reviewedByCoreUserId)&&(identical(other.reviewedAtUtc, reviewedAtUtc) || other.reviewedAtUtc == reviewedAtUtc)&&(identical(other.reviewComment, reviewComment) || other.reviewComment == reviewComment)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,userId,kind,startedAtUtc,stoppedAtUtc,durationMinutes,description,isBillable,createdAtUtc,approvalStatus,reviewedByCoreUserId,reviewedAtUtc,reviewComment,version);

@override
String toString() {
  return 'TaskTimeEntryResponse(id: $id, taskId: $taskId, userId: $userId, kind: $kind, startedAtUtc: $startedAtUtc, stoppedAtUtc: $stoppedAtUtc, durationMinutes: $durationMinutes, description: $description, isBillable: $isBillable, createdAtUtc: $createdAtUtc, approvalStatus: $approvalStatus, reviewedByCoreUserId: $reviewedByCoreUserId, reviewedAtUtc: $reviewedAtUtc, reviewComment: $reviewComment, version: $version)';
}


}

/// @nodoc
abstract mixin class $TaskTimeEntryResponseCopyWith<$Res>  {
  factory $TaskTimeEntryResponseCopyWith(TaskTimeEntryResponse value, $Res Function(TaskTimeEntryResponse) _then) = _$TaskTimeEntryResponseCopyWithImpl;
@useResult
$Res call({
 String id, String taskId, String userId, TaskTimeEntryKind kind, DateTime startedAtUtc, DateTime? stoppedAtUtc, int? durationMinutes, String? description, bool isBillable, DateTime createdAtUtc, TaskTimeEntryApprovalStatus approvalStatus, String? reviewedByCoreUserId, DateTime? reviewedAtUtc, String? reviewComment, int version
});




}
/// @nodoc
class _$TaskTimeEntryResponseCopyWithImpl<$Res>
    implements $TaskTimeEntryResponseCopyWith<$Res> {
  _$TaskTimeEntryResponseCopyWithImpl(this._self, this._then);

  final TaskTimeEntryResponse _self;
  final $Res Function(TaskTimeEntryResponse) _then;

/// Create a copy of TaskTimeEntryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? userId = null,Object? kind = null,Object? startedAtUtc = null,Object? stoppedAtUtc = freezed,Object? durationMinutes = freezed,Object? description = freezed,Object? isBillable = null,Object? createdAtUtc = null,Object? approvalStatus = null,Object? reviewedByCoreUserId = freezed,Object? reviewedAtUtc = freezed,Object? reviewComment = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TaskTimeEntryKind,startedAtUtc: null == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,stoppedAtUtc: freezed == stoppedAtUtc ? _self.stoppedAtUtc : stoppedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isBillable: null == isBillable ? _self.isBillable : isBillable // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,approvalStatus: null == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as TaskTimeEntryApprovalStatus,reviewedByCoreUserId: freezed == reviewedByCoreUserId ? _self.reviewedByCoreUserId : reviewedByCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,reviewedAtUtc: freezed == reviewedAtUtc ? _self.reviewedAtUtc : reviewedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewComment: freezed == reviewComment ? _self.reviewComment : reviewComment // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskTimeEntryResponse].
extension TaskTimeEntryResponsePatterns on TaskTimeEntryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskTimeEntryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskTimeEntryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskTimeEntryResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskTimeEntryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskTimeEntryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskTimeEntryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskId,  String userId,  TaskTimeEntryKind kind,  DateTime startedAtUtc,  DateTime? stoppedAtUtc,  int? durationMinutes,  String? description,  bool isBillable,  DateTime createdAtUtc,  TaskTimeEntryApprovalStatus approvalStatus,  String? reviewedByCoreUserId,  DateTime? reviewedAtUtc,  String? reviewComment,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskTimeEntryResponse() when $default != null:
return $default(_that.id,_that.taskId,_that.userId,_that.kind,_that.startedAtUtc,_that.stoppedAtUtc,_that.durationMinutes,_that.description,_that.isBillable,_that.createdAtUtc,_that.approvalStatus,_that.reviewedByCoreUserId,_that.reviewedAtUtc,_that.reviewComment,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskId,  String userId,  TaskTimeEntryKind kind,  DateTime startedAtUtc,  DateTime? stoppedAtUtc,  int? durationMinutes,  String? description,  bool isBillable,  DateTime createdAtUtc,  TaskTimeEntryApprovalStatus approvalStatus,  String? reviewedByCoreUserId,  DateTime? reviewedAtUtc,  String? reviewComment,  int version)  $default,) {final _that = this;
switch (_that) {
case _TaskTimeEntryResponse():
return $default(_that.id,_that.taskId,_that.userId,_that.kind,_that.startedAtUtc,_that.stoppedAtUtc,_that.durationMinutes,_that.description,_that.isBillable,_that.createdAtUtc,_that.approvalStatus,_that.reviewedByCoreUserId,_that.reviewedAtUtc,_that.reviewComment,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskId,  String userId,  TaskTimeEntryKind kind,  DateTime startedAtUtc,  DateTime? stoppedAtUtc,  int? durationMinutes,  String? description,  bool isBillable,  DateTime createdAtUtc,  TaskTimeEntryApprovalStatus approvalStatus,  String? reviewedByCoreUserId,  DateTime? reviewedAtUtc,  String? reviewComment,  int version)?  $default,) {final _that = this;
switch (_that) {
case _TaskTimeEntryResponse() when $default != null:
return $default(_that.id,_that.taskId,_that.userId,_that.kind,_that.startedAtUtc,_that.stoppedAtUtc,_that.durationMinutes,_that.description,_that.isBillable,_that.createdAtUtc,_that.approvalStatus,_that.reviewedByCoreUserId,_that.reviewedAtUtc,_that.reviewComment,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskTimeEntryResponse implements TaskTimeEntryResponse {
  const _TaskTimeEntryResponse({required this.id, required this.taskId, required this.userId, required this.kind, required this.startedAtUtc, this.stoppedAtUtc, this.durationMinutes, this.description, required this.isBillable, required this.createdAtUtc, required this.approvalStatus, this.reviewedByCoreUserId, this.reviewedAtUtc, this.reviewComment, required this.version});
  factory _TaskTimeEntryResponse.fromJson(Map<String, dynamic> json) => _$TaskTimeEntryResponseFromJson(json);

@override final  String id;
@override final  String taskId;
@override final  String userId;
@override final  TaskTimeEntryKind kind;
@override final  DateTime startedAtUtc;
@override final  DateTime? stoppedAtUtc;
@override final  int? durationMinutes;
@override final  String? description;
@override final  bool isBillable;
@override final  DateTime createdAtUtc;
@override final  TaskTimeEntryApprovalStatus approvalStatus;
@override final  String? reviewedByCoreUserId;
@override final  DateTime? reviewedAtUtc;
@override final  String? reviewComment;
@override final  int version;

/// Create a copy of TaskTimeEntryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskTimeEntryResponseCopyWith<_TaskTimeEntryResponse> get copyWith => __$TaskTimeEntryResponseCopyWithImpl<_TaskTimeEntryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskTimeEntryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskTimeEntryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.startedAtUtc, startedAtUtc) || other.startedAtUtc == startedAtUtc)&&(identical(other.stoppedAtUtc, stoppedAtUtc) || other.stoppedAtUtc == stoppedAtUtc)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.description, description) || other.description == description)&&(identical(other.isBillable, isBillable) || other.isBillable == isBillable)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.reviewedByCoreUserId, reviewedByCoreUserId) || other.reviewedByCoreUserId == reviewedByCoreUserId)&&(identical(other.reviewedAtUtc, reviewedAtUtc) || other.reviewedAtUtc == reviewedAtUtc)&&(identical(other.reviewComment, reviewComment) || other.reviewComment == reviewComment)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,userId,kind,startedAtUtc,stoppedAtUtc,durationMinutes,description,isBillable,createdAtUtc,approvalStatus,reviewedByCoreUserId,reviewedAtUtc,reviewComment,version);

@override
String toString() {
  return 'TaskTimeEntryResponse(id: $id, taskId: $taskId, userId: $userId, kind: $kind, startedAtUtc: $startedAtUtc, stoppedAtUtc: $stoppedAtUtc, durationMinutes: $durationMinutes, description: $description, isBillable: $isBillable, createdAtUtc: $createdAtUtc, approvalStatus: $approvalStatus, reviewedByCoreUserId: $reviewedByCoreUserId, reviewedAtUtc: $reviewedAtUtc, reviewComment: $reviewComment, version: $version)';
}


}

/// @nodoc
abstract mixin class _$TaskTimeEntryResponseCopyWith<$Res> implements $TaskTimeEntryResponseCopyWith<$Res> {
  factory _$TaskTimeEntryResponseCopyWith(_TaskTimeEntryResponse value, $Res Function(_TaskTimeEntryResponse) _then) = __$TaskTimeEntryResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskId, String userId, TaskTimeEntryKind kind, DateTime startedAtUtc, DateTime? stoppedAtUtc, int? durationMinutes, String? description, bool isBillable, DateTime createdAtUtc, TaskTimeEntryApprovalStatus approvalStatus, String? reviewedByCoreUserId, DateTime? reviewedAtUtc, String? reviewComment, int version
});




}
/// @nodoc
class __$TaskTimeEntryResponseCopyWithImpl<$Res>
    implements _$TaskTimeEntryResponseCopyWith<$Res> {
  __$TaskTimeEntryResponseCopyWithImpl(this._self, this._then);

  final _TaskTimeEntryResponse _self;
  final $Res Function(_TaskTimeEntryResponse) _then;

/// Create a copy of TaskTimeEntryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? userId = null,Object? kind = null,Object? startedAtUtc = null,Object? stoppedAtUtc = freezed,Object? durationMinutes = freezed,Object? description = freezed,Object? isBillable = null,Object? createdAtUtc = null,Object? approvalStatus = null,Object? reviewedByCoreUserId = freezed,Object? reviewedAtUtc = freezed,Object? reviewComment = freezed,Object? version = null,}) {
  return _then(_TaskTimeEntryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TaskTimeEntryKind,startedAtUtc: null == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,stoppedAtUtc: freezed == stoppedAtUtc ? _self.stoppedAtUtc : stoppedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isBillable: null == isBillable ? _self.isBillable : isBillable // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,approvalStatus: null == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as TaskTimeEntryApprovalStatus,reviewedByCoreUserId: freezed == reviewedByCoreUserId ? _self.reviewedByCoreUserId : reviewedByCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,reviewedAtUtc: freezed == reviewedAtUtc ? _self.reviewedAtUtc : reviewedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewComment: freezed == reviewComment ? _self.reviewComment : reviewComment // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateTaskTimeEntryPayload {

 DateTime? get startedAtUtc; int get durationMinutes; String? get description; bool get isBillable;
/// Create a copy of CreateTaskTimeEntryPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskTimeEntryPayloadCopyWith<CreateTaskTimeEntryPayload> get copyWith => _$CreateTaskTimeEntryPayloadCopyWithImpl<CreateTaskTimeEntryPayload>(this as CreateTaskTimeEntryPayload, _$identity);

  /// Serializes this CreateTaskTimeEntryPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskTimeEntryPayload&&(identical(other.startedAtUtc, startedAtUtc) || other.startedAtUtc == startedAtUtc)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.description, description) || other.description == description)&&(identical(other.isBillable, isBillable) || other.isBillable == isBillable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startedAtUtc,durationMinutes,description,isBillable);

@override
String toString() {
  return 'CreateTaskTimeEntryPayload(startedAtUtc: $startedAtUtc, durationMinutes: $durationMinutes, description: $description, isBillable: $isBillable)';
}


}

/// @nodoc
abstract mixin class $CreateTaskTimeEntryPayloadCopyWith<$Res>  {
  factory $CreateTaskTimeEntryPayloadCopyWith(CreateTaskTimeEntryPayload value, $Res Function(CreateTaskTimeEntryPayload) _then) = _$CreateTaskTimeEntryPayloadCopyWithImpl;
@useResult
$Res call({
 DateTime? startedAtUtc, int durationMinutes, String? description, bool isBillable
});




}
/// @nodoc
class _$CreateTaskTimeEntryPayloadCopyWithImpl<$Res>
    implements $CreateTaskTimeEntryPayloadCopyWith<$Res> {
  _$CreateTaskTimeEntryPayloadCopyWithImpl(this._self, this._then);

  final CreateTaskTimeEntryPayload _self;
  final $Res Function(CreateTaskTimeEntryPayload) _then;

/// Create a copy of CreateTaskTimeEntryPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startedAtUtc = freezed,Object? durationMinutes = null,Object? description = freezed,Object? isBillable = null,}) {
  return _then(_self.copyWith(
startedAtUtc: freezed == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isBillable: null == isBillable ? _self.isBillable : isBillable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskTimeEntryPayload].
extension CreateTaskTimeEntryPayloadPatterns on CreateTaskTimeEntryPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskTimeEntryPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskTimeEntryPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskTimeEntryPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskTimeEntryPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskTimeEntryPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskTimeEntryPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? startedAtUtc,  int durationMinutes,  String? description,  bool isBillable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskTimeEntryPayload() when $default != null:
return $default(_that.startedAtUtc,_that.durationMinutes,_that.description,_that.isBillable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? startedAtUtc,  int durationMinutes,  String? description,  bool isBillable)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskTimeEntryPayload():
return $default(_that.startedAtUtc,_that.durationMinutes,_that.description,_that.isBillable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? startedAtUtc,  int durationMinutes,  String? description,  bool isBillable)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskTimeEntryPayload() when $default != null:
return $default(_that.startedAtUtc,_that.durationMinutes,_that.description,_that.isBillable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskTimeEntryPayload implements CreateTaskTimeEntryPayload {
  const _CreateTaskTimeEntryPayload({this.startedAtUtc, required this.durationMinutes, this.description, required this.isBillable});
  factory _CreateTaskTimeEntryPayload.fromJson(Map<String, dynamic> json) => _$CreateTaskTimeEntryPayloadFromJson(json);

@override final  DateTime? startedAtUtc;
@override final  int durationMinutes;
@override final  String? description;
@override final  bool isBillable;

/// Create a copy of CreateTaskTimeEntryPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskTimeEntryPayloadCopyWith<_CreateTaskTimeEntryPayload> get copyWith => __$CreateTaskTimeEntryPayloadCopyWithImpl<_CreateTaskTimeEntryPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskTimeEntryPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskTimeEntryPayload&&(identical(other.startedAtUtc, startedAtUtc) || other.startedAtUtc == startedAtUtc)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.description, description) || other.description == description)&&(identical(other.isBillable, isBillable) || other.isBillable == isBillable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startedAtUtc,durationMinutes,description,isBillable);

@override
String toString() {
  return 'CreateTaskTimeEntryPayload(startedAtUtc: $startedAtUtc, durationMinutes: $durationMinutes, description: $description, isBillable: $isBillable)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskTimeEntryPayloadCopyWith<$Res> implements $CreateTaskTimeEntryPayloadCopyWith<$Res> {
  factory _$CreateTaskTimeEntryPayloadCopyWith(_CreateTaskTimeEntryPayload value, $Res Function(_CreateTaskTimeEntryPayload) _then) = __$CreateTaskTimeEntryPayloadCopyWithImpl;
@override @useResult
$Res call({
 DateTime? startedAtUtc, int durationMinutes, String? description, bool isBillable
});




}
/// @nodoc
class __$CreateTaskTimeEntryPayloadCopyWithImpl<$Res>
    implements _$CreateTaskTimeEntryPayloadCopyWith<$Res> {
  __$CreateTaskTimeEntryPayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskTimeEntryPayload _self;
  final $Res Function(_CreateTaskTimeEntryPayload) _then;

/// Create a copy of CreateTaskTimeEntryPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startedAtUtc = freezed,Object? durationMinutes = null,Object? description = freezed,Object? isBillable = null,}) {
  return _then(_CreateTaskTimeEntryPayload(
startedAtUtc: freezed == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isBillable: null == isBillable ? _self.isBillable : isBillable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StopTaskTimerPayload {

 DateTime? get stoppedAtUtc;
/// Create a copy of StopTaskTimerPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopTaskTimerPayloadCopyWith<StopTaskTimerPayload> get copyWith => _$StopTaskTimerPayloadCopyWithImpl<StopTaskTimerPayload>(this as StopTaskTimerPayload, _$identity);

  /// Serializes this StopTaskTimerPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopTaskTimerPayload&&(identical(other.stoppedAtUtc, stoppedAtUtc) || other.stoppedAtUtc == stoppedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stoppedAtUtc);

@override
String toString() {
  return 'StopTaskTimerPayload(stoppedAtUtc: $stoppedAtUtc)';
}


}

/// @nodoc
abstract mixin class $StopTaskTimerPayloadCopyWith<$Res>  {
  factory $StopTaskTimerPayloadCopyWith(StopTaskTimerPayload value, $Res Function(StopTaskTimerPayload) _then) = _$StopTaskTimerPayloadCopyWithImpl;
@useResult
$Res call({
 DateTime? stoppedAtUtc
});




}
/// @nodoc
class _$StopTaskTimerPayloadCopyWithImpl<$Res>
    implements $StopTaskTimerPayloadCopyWith<$Res> {
  _$StopTaskTimerPayloadCopyWithImpl(this._self, this._then);

  final StopTaskTimerPayload _self;
  final $Res Function(StopTaskTimerPayload) _then;

/// Create a copy of StopTaskTimerPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stoppedAtUtc = freezed,}) {
  return _then(_self.copyWith(
stoppedAtUtc: freezed == stoppedAtUtc ? _self.stoppedAtUtc : stoppedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StopTaskTimerPayload].
extension StopTaskTimerPayloadPatterns on StopTaskTimerPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StopTaskTimerPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StopTaskTimerPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StopTaskTimerPayload value)  $default,){
final _that = this;
switch (_that) {
case _StopTaskTimerPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StopTaskTimerPayload value)?  $default,){
final _that = this;
switch (_that) {
case _StopTaskTimerPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? stoppedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StopTaskTimerPayload() when $default != null:
return $default(_that.stoppedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? stoppedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _StopTaskTimerPayload():
return $default(_that.stoppedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? stoppedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _StopTaskTimerPayload() when $default != null:
return $default(_that.stoppedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StopTaskTimerPayload implements StopTaskTimerPayload {
  const _StopTaskTimerPayload({this.stoppedAtUtc});
  factory _StopTaskTimerPayload.fromJson(Map<String, dynamic> json) => _$StopTaskTimerPayloadFromJson(json);

@override final  DateTime? stoppedAtUtc;

/// Create a copy of StopTaskTimerPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StopTaskTimerPayloadCopyWith<_StopTaskTimerPayload> get copyWith => __$StopTaskTimerPayloadCopyWithImpl<_StopTaskTimerPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StopTaskTimerPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopTaskTimerPayload&&(identical(other.stoppedAtUtc, stoppedAtUtc) || other.stoppedAtUtc == stoppedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stoppedAtUtc);

@override
String toString() {
  return 'StopTaskTimerPayload(stoppedAtUtc: $stoppedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$StopTaskTimerPayloadCopyWith<$Res> implements $StopTaskTimerPayloadCopyWith<$Res> {
  factory _$StopTaskTimerPayloadCopyWith(_StopTaskTimerPayload value, $Res Function(_StopTaskTimerPayload) _then) = __$StopTaskTimerPayloadCopyWithImpl;
@override @useResult
$Res call({
 DateTime? stoppedAtUtc
});




}
/// @nodoc
class __$StopTaskTimerPayloadCopyWithImpl<$Res>
    implements _$StopTaskTimerPayloadCopyWith<$Res> {
  __$StopTaskTimerPayloadCopyWithImpl(this._self, this._then);

  final _StopTaskTimerPayload _self;
  final $Res Function(_StopTaskTimerPayload) _then;

/// Create a copy of StopTaskTimerPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stoppedAtUtc = freezed,}) {
  return _then(_StopTaskTimerPayload(
stoppedAtUtc: freezed == stoppedAtUtc ? _self.stoppedAtUtc : stoppedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TimeEntryWorkflowPayload {

 int get expectedVersion; String? get comment;
/// Create a copy of TimeEntryWorkflowPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeEntryWorkflowPayloadCopyWith<TimeEntryWorkflowPayload> get copyWith => _$TimeEntryWorkflowPayloadCopyWithImpl<TimeEntryWorkflowPayload>(this as TimeEntryWorkflowPayload, _$identity);

  /// Serializes this TimeEntryWorkflowPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeEntryWorkflowPayload&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expectedVersion,comment);

@override
String toString() {
  return 'TimeEntryWorkflowPayload(expectedVersion: $expectedVersion, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $TimeEntryWorkflowPayloadCopyWith<$Res>  {
  factory $TimeEntryWorkflowPayloadCopyWith(TimeEntryWorkflowPayload value, $Res Function(TimeEntryWorkflowPayload) _then) = _$TimeEntryWorkflowPayloadCopyWithImpl;
@useResult
$Res call({
 int expectedVersion, String? comment
});




}
/// @nodoc
class _$TimeEntryWorkflowPayloadCopyWithImpl<$Res>
    implements $TimeEntryWorkflowPayloadCopyWith<$Res> {
  _$TimeEntryWorkflowPayloadCopyWithImpl(this._self, this._then);

  final TimeEntryWorkflowPayload _self;
  final $Res Function(TimeEntryWorkflowPayload) _then;

/// Create a copy of TimeEntryWorkflowPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expectedVersion = null,Object? comment = freezed,}) {
  return _then(_self.copyWith(
expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeEntryWorkflowPayload].
extension TimeEntryWorkflowPayloadPatterns on TimeEntryWorkflowPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeEntryWorkflowPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeEntryWorkflowPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeEntryWorkflowPayload value)  $default,){
final _that = this;
switch (_that) {
case _TimeEntryWorkflowPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeEntryWorkflowPayload value)?  $default,){
final _that = this;
switch (_that) {
case _TimeEntryWorkflowPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int expectedVersion,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeEntryWorkflowPayload() when $default != null:
return $default(_that.expectedVersion,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int expectedVersion,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _TimeEntryWorkflowPayload():
return $default(_that.expectedVersion,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int expectedVersion,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _TimeEntryWorkflowPayload() when $default != null:
return $default(_that.expectedVersion,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeEntryWorkflowPayload implements TimeEntryWorkflowPayload {
  const _TimeEntryWorkflowPayload({required this.expectedVersion, this.comment});
  factory _TimeEntryWorkflowPayload.fromJson(Map<String, dynamic> json) => _$TimeEntryWorkflowPayloadFromJson(json);

@override final  int expectedVersion;
@override final  String? comment;

/// Create a copy of TimeEntryWorkflowPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeEntryWorkflowPayloadCopyWith<_TimeEntryWorkflowPayload> get copyWith => __$TimeEntryWorkflowPayloadCopyWithImpl<_TimeEntryWorkflowPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeEntryWorkflowPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeEntryWorkflowPayload&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expectedVersion,comment);

@override
String toString() {
  return 'TimeEntryWorkflowPayload(expectedVersion: $expectedVersion, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$TimeEntryWorkflowPayloadCopyWith<$Res> implements $TimeEntryWorkflowPayloadCopyWith<$Res> {
  factory _$TimeEntryWorkflowPayloadCopyWith(_TimeEntryWorkflowPayload value, $Res Function(_TimeEntryWorkflowPayload) _then) = __$TimeEntryWorkflowPayloadCopyWithImpl;
@override @useResult
$Res call({
 int expectedVersion, String? comment
});




}
/// @nodoc
class __$TimeEntryWorkflowPayloadCopyWithImpl<$Res>
    implements _$TimeEntryWorkflowPayloadCopyWith<$Res> {
  __$TimeEntryWorkflowPayloadCopyWithImpl(this._self, this._then);

  final _TimeEntryWorkflowPayload _self;
  final $Res Function(_TimeEntryWorkflowPayload) _then;

/// Create a copy of TimeEntryWorkflowPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expectedVersion = null,Object? comment = freezed,}) {
  return _then(_TimeEntryWorkflowPayload(
expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
