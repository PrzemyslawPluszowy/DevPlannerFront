// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskRecurrenceSummaryResponse {

 String get id; String get sourceTaskId; TaskRecurrenceMode get mode; TaskRecurrenceFrequency get frequency; int get interval; String get timeZoneId; DateTime? get nextOccurrenceAtUtc; ProjectTaskStatus get occurrenceStatus; bool get skipIfPreviousOpen; bool get isActive; bool get isSourceTask; int get version;
/// Create a copy of TaskRecurrenceSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskRecurrenceSummaryResponseCopyWith<TaskRecurrenceSummaryResponse> get copyWith => _$TaskRecurrenceSummaryResponseCopyWithImpl<TaskRecurrenceSummaryResponse>(this as TaskRecurrenceSummaryResponse, _$identity);

  /// Serializes this TaskRecurrenceSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskRecurrenceSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.nextOccurrenceAtUtc, nextOccurrenceAtUtc) || other.nextOccurrenceAtUtc == nextOccurrenceAtUtc)&&(identical(other.occurrenceStatus, occurrenceStatus) || other.occurrenceStatus == occurrenceStatus)&&(identical(other.skipIfPreviousOpen, skipIfPreviousOpen) || other.skipIfPreviousOpen == skipIfPreviousOpen)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isSourceTask, isSourceTask) || other.isSourceTask == isSourceTask)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceTaskId,mode,frequency,interval,timeZoneId,nextOccurrenceAtUtc,occurrenceStatus,skipIfPreviousOpen,isActive,isSourceTask,version);

@override
String toString() {
  return 'TaskRecurrenceSummaryResponse(id: $id, sourceTaskId: $sourceTaskId, mode: $mode, frequency: $frequency, interval: $interval, timeZoneId: $timeZoneId, nextOccurrenceAtUtc: $nextOccurrenceAtUtc, occurrenceStatus: $occurrenceStatus, skipIfPreviousOpen: $skipIfPreviousOpen, isActive: $isActive, isSourceTask: $isSourceTask, version: $version)';
}


}

/// @nodoc
abstract mixin class $TaskRecurrenceSummaryResponseCopyWith<$Res>  {
  factory $TaskRecurrenceSummaryResponseCopyWith(TaskRecurrenceSummaryResponse value, $Res Function(TaskRecurrenceSummaryResponse) _then) = _$TaskRecurrenceSummaryResponseCopyWithImpl;
@useResult
$Res call({
 String id, String sourceTaskId, TaskRecurrenceMode mode, TaskRecurrenceFrequency frequency, int interval, String timeZoneId, DateTime? nextOccurrenceAtUtc, ProjectTaskStatus occurrenceStatus, bool skipIfPreviousOpen, bool isActive, bool isSourceTask, int version
});




}
/// @nodoc
class _$TaskRecurrenceSummaryResponseCopyWithImpl<$Res>
    implements $TaskRecurrenceSummaryResponseCopyWith<$Res> {
  _$TaskRecurrenceSummaryResponseCopyWithImpl(this._self, this._then);

  final TaskRecurrenceSummaryResponse _self;
  final $Res Function(TaskRecurrenceSummaryResponse) _then;

/// Create a copy of TaskRecurrenceSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceTaskId = null,Object? mode = null,Object? frequency = null,Object? interval = null,Object? timeZoneId = null,Object? nextOccurrenceAtUtc = freezed,Object? occurrenceStatus = null,Object? skipIfPreviousOpen = null,Object? isActive = null,Object? isSourceTask = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceMode,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceFrequency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,nextOccurrenceAtUtc: freezed == nextOccurrenceAtUtc ? _self.nextOccurrenceAtUtc : nextOccurrenceAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,occurrenceStatus: null == occurrenceStatus ? _self.occurrenceStatus : occurrenceStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,skipIfPreviousOpen: null == skipIfPreviousOpen ? _self.skipIfPreviousOpen : skipIfPreviousOpen // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isSourceTask: null == isSourceTask ? _self.isSourceTask : isSourceTask // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskRecurrenceSummaryResponse].
extension TaskRecurrenceSummaryResponsePatterns on TaskRecurrenceSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskRecurrenceSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskRecurrenceSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskRecurrenceSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskRecurrenceSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskRecurrenceSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskRecurrenceSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceTaskId,  TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  bool isActive,  bool isSourceTask,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskRecurrenceSummaryResponse() when $default != null:
return $default(_that.id,_that.sourceTaskId,_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.isActive,_that.isSourceTask,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceTaskId,  TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  bool isActive,  bool isSourceTask,  int version)  $default,) {final _that = this;
switch (_that) {
case _TaskRecurrenceSummaryResponse():
return $default(_that.id,_that.sourceTaskId,_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.isActive,_that.isSourceTask,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceTaskId,  TaskRecurrenceMode mode,  TaskRecurrenceFrequency frequency,  int interval,  String timeZoneId,  DateTime? nextOccurrenceAtUtc,  ProjectTaskStatus occurrenceStatus,  bool skipIfPreviousOpen,  bool isActive,  bool isSourceTask,  int version)?  $default,) {final _that = this;
switch (_that) {
case _TaskRecurrenceSummaryResponse() when $default != null:
return $default(_that.id,_that.sourceTaskId,_that.mode,_that.frequency,_that.interval,_that.timeZoneId,_that.nextOccurrenceAtUtc,_that.occurrenceStatus,_that.skipIfPreviousOpen,_that.isActive,_that.isSourceTask,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskRecurrenceSummaryResponse implements TaskRecurrenceSummaryResponse {
  const _TaskRecurrenceSummaryResponse({required this.id, required this.sourceTaskId, required this.mode, required this.frequency, required this.interval, required this.timeZoneId, this.nextOccurrenceAtUtc, required this.occurrenceStatus, required this.skipIfPreviousOpen, required this.isActive, required this.isSourceTask, required this.version});
  factory _TaskRecurrenceSummaryResponse.fromJson(Map<String, dynamic> json) => _$TaskRecurrenceSummaryResponseFromJson(json);

@override final  String id;
@override final  String sourceTaskId;
@override final  TaskRecurrenceMode mode;
@override final  TaskRecurrenceFrequency frequency;
@override final  int interval;
@override final  String timeZoneId;
@override final  DateTime? nextOccurrenceAtUtc;
@override final  ProjectTaskStatus occurrenceStatus;
@override final  bool skipIfPreviousOpen;
@override final  bool isActive;
@override final  bool isSourceTask;
@override final  int version;

/// Create a copy of TaskRecurrenceSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskRecurrenceSummaryResponseCopyWith<_TaskRecurrenceSummaryResponse> get copyWith => __$TaskRecurrenceSummaryResponseCopyWithImpl<_TaskRecurrenceSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskRecurrenceSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskRecurrenceSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.nextOccurrenceAtUtc, nextOccurrenceAtUtc) || other.nextOccurrenceAtUtc == nextOccurrenceAtUtc)&&(identical(other.occurrenceStatus, occurrenceStatus) || other.occurrenceStatus == occurrenceStatus)&&(identical(other.skipIfPreviousOpen, skipIfPreviousOpen) || other.skipIfPreviousOpen == skipIfPreviousOpen)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isSourceTask, isSourceTask) || other.isSourceTask == isSourceTask)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceTaskId,mode,frequency,interval,timeZoneId,nextOccurrenceAtUtc,occurrenceStatus,skipIfPreviousOpen,isActive,isSourceTask,version);

@override
String toString() {
  return 'TaskRecurrenceSummaryResponse(id: $id, sourceTaskId: $sourceTaskId, mode: $mode, frequency: $frequency, interval: $interval, timeZoneId: $timeZoneId, nextOccurrenceAtUtc: $nextOccurrenceAtUtc, occurrenceStatus: $occurrenceStatus, skipIfPreviousOpen: $skipIfPreviousOpen, isActive: $isActive, isSourceTask: $isSourceTask, version: $version)';
}


}

/// @nodoc
abstract mixin class _$TaskRecurrenceSummaryResponseCopyWith<$Res> implements $TaskRecurrenceSummaryResponseCopyWith<$Res> {
  factory _$TaskRecurrenceSummaryResponseCopyWith(_TaskRecurrenceSummaryResponse value, $Res Function(_TaskRecurrenceSummaryResponse) _then) = __$TaskRecurrenceSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceTaskId, TaskRecurrenceMode mode, TaskRecurrenceFrequency frequency, int interval, String timeZoneId, DateTime? nextOccurrenceAtUtc, ProjectTaskStatus occurrenceStatus, bool skipIfPreviousOpen, bool isActive, bool isSourceTask, int version
});




}
/// @nodoc
class __$TaskRecurrenceSummaryResponseCopyWithImpl<$Res>
    implements _$TaskRecurrenceSummaryResponseCopyWith<$Res> {
  __$TaskRecurrenceSummaryResponseCopyWithImpl(this._self, this._then);

  final _TaskRecurrenceSummaryResponse _self;
  final $Res Function(_TaskRecurrenceSummaryResponse) _then;

/// Create a copy of TaskRecurrenceSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceTaskId = null,Object? mode = null,Object? frequency = null,Object? interval = null,Object? timeZoneId = null,Object? nextOccurrenceAtUtc = freezed,Object? occurrenceStatus = null,Object? skipIfPreviousOpen = null,Object? isActive = null,Object? isSourceTask = null,Object? version = null,}) {
  return _then(_TaskRecurrenceSummaryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceMode,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceFrequency,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,nextOccurrenceAtUtc: freezed == nextOccurrenceAtUtc ? _self.nextOccurrenceAtUtc : nextOccurrenceAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,occurrenceStatus: null == occurrenceStatus ? _self.occurrenceStatus : occurrenceStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,skipIfPreviousOpen: null == skipIfPreviousOpen ? _self.skipIfPreviousOpen : skipIfPreviousOpen // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isSourceTask: null == isSourceTask ? _self.isSourceTask : isSourceTask // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskWorkflowStatusResponse {

 ProjectTaskStatus get status; String get displayName; String get color; int get position; bool get isInitial; bool get isTerminal; TaskStatusCategory get category;
/// Create a copy of ProjectTaskWorkflowStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskWorkflowStatusResponseCopyWith<ProjectTaskWorkflowStatusResponse> get copyWith => _$ProjectTaskWorkflowStatusResponseCopyWithImpl<ProjectTaskWorkflowStatusResponse>(this as ProjectTaskWorkflowStatusResponse, _$identity);

  /// Serializes this ProjectTaskWorkflowStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskWorkflowStatusResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.isInitial, isInitial) || other.isInitial == isInitial)&&(identical(other.isTerminal, isTerminal) || other.isTerminal == isTerminal)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,displayName,color,position,isInitial,isTerminal,category);

@override
String toString() {
  return 'ProjectTaskWorkflowStatusResponse(status: $status, displayName: $displayName, color: $color, position: $position, isInitial: $isInitial, isTerminal: $isTerminal, category: $category)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskWorkflowStatusResponseCopyWith<$Res>  {
  factory $ProjectTaskWorkflowStatusResponseCopyWith(ProjectTaskWorkflowStatusResponse value, $Res Function(ProjectTaskWorkflowStatusResponse) _then) = _$ProjectTaskWorkflowStatusResponseCopyWithImpl;
@useResult
$Res call({
 ProjectTaskStatus status, String displayName, String color, int position, bool isInitial, bool isTerminal, TaskStatusCategory category
});




}
/// @nodoc
class _$ProjectTaskWorkflowStatusResponseCopyWithImpl<$Res>
    implements $ProjectTaskWorkflowStatusResponseCopyWith<$Res> {
  _$ProjectTaskWorkflowStatusResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskWorkflowStatusResponse _self;
  final $Res Function(ProjectTaskWorkflowStatusResponse) _then;

/// Create a copy of ProjectTaskWorkflowStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? displayName = null,Object? color = null,Object? position = null,Object? isInitial = null,Object? isTerminal = null,Object? category = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isInitial: null == isInitial ? _self.isInitial : isInitial // ignore: cast_nullable_to_non_nullable
as bool,isTerminal: null == isTerminal ? _self.isTerminal : isTerminal // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskWorkflowStatusResponse].
extension ProjectTaskWorkflowStatusResponsePatterns on ProjectTaskWorkflowStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskWorkflowStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskWorkflowStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskWorkflowStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskWorkflowStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskWorkflowStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskWorkflowStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectTaskStatus status,  String displayName,  String color,  int position,  bool isInitial,  bool isTerminal,  TaskStatusCategory category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskWorkflowStatusResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectTaskStatus status,  String displayName,  String color,  int position,  bool isInitial,  bool isTerminal,  TaskStatusCategory category)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskWorkflowStatusResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectTaskStatus status,  String displayName,  String color,  int position,  bool isInitial,  bool isTerminal,  TaskStatusCategory category)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskWorkflowStatusResponse() when $default != null:
return $default(_that.status,_that.displayName,_that.color,_that.position,_that.isInitial,_that.isTerminal,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskWorkflowStatusResponse implements ProjectTaskWorkflowStatusResponse {
  const _ProjectTaskWorkflowStatusResponse({required this.status, required this.displayName, required this.color, required this.position, required this.isInitial, required this.isTerminal, required this.category});
  factory _ProjectTaskWorkflowStatusResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskWorkflowStatusResponseFromJson(json);

@override final  ProjectTaskStatus status;
@override final  String displayName;
@override final  String color;
@override final  int position;
@override final  bool isInitial;
@override final  bool isTerminal;
@override final  TaskStatusCategory category;

/// Create a copy of ProjectTaskWorkflowStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskWorkflowStatusResponseCopyWith<_ProjectTaskWorkflowStatusResponse> get copyWith => __$ProjectTaskWorkflowStatusResponseCopyWithImpl<_ProjectTaskWorkflowStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskWorkflowStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskWorkflowStatusResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.isInitial, isInitial) || other.isInitial == isInitial)&&(identical(other.isTerminal, isTerminal) || other.isTerminal == isTerminal)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,displayName,color,position,isInitial,isTerminal,category);

@override
String toString() {
  return 'ProjectTaskWorkflowStatusResponse(status: $status, displayName: $displayName, color: $color, position: $position, isInitial: $isInitial, isTerminal: $isTerminal, category: $category)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskWorkflowStatusResponseCopyWith<$Res> implements $ProjectTaskWorkflowStatusResponseCopyWith<$Res> {
  factory _$ProjectTaskWorkflowStatusResponseCopyWith(_ProjectTaskWorkflowStatusResponse value, $Res Function(_ProjectTaskWorkflowStatusResponse) _then) = __$ProjectTaskWorkflowStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectTaskStatus status, String displayName, String color, int position, bool isInitial, bool isTerminal, TaskStatusCategory category
});




}
/// @nodoc
class __$ProjectTaskWorkflowStatusResponseCopyWithImpl<$Res>
    implements _$ProjectTaskWorkflowStatusResponseCopyWith<$Res> {
  __$ProjectTaskWorkflowStatusResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskWorkflowStatusResponse _self;
  final $Res Function(_ProjectTaskWorkflowStatusResponse) _then;

/// Create a copy of ProjectTaskWorkflowStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? displayName = null,Object? color = null,Object? position = null,Object? isInitial = null,Object? isTerminal = null,Object? category = null,}) {
  return _then(_ProjectTaskWorkflowStatusResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isInitial: null == isInitial ? _self.isInitial : isInitial // ignore: cast_nullable_to_non_nullable
as bool,isTerminal: null == isTerminal ? _self.isTerminal : isTerminal // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskWorkflowTransitionResponse {

 ProjectTaskStatus get fromStatus; ProjectTaskStatus get toStatus;
/// Create a copy of ProjectTaskWorkflowTransitionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskWorkflowTransitionResponseCopyWith<ProjectTaskWorkflowTransitionResponse> get copyWith => _$ProjectTaskWorkflowTransitionResponseCopyWithImpl<ProjectTaskWorkflowTransitionResponse>(this as ProjectTaskWorkflowTransitionResponse, _$identity);

  /// Serializes this ProjectTaskWorkflowTransitionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskWorkflowTransitionResponse&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromStatus,toStatus);

@override
String toString() {
  return 'ProjectTaskWorkflowTransitionResponse(fromStatus: $fromStatus, toStatus: $toStatus)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskWorkflowTransitionResponseCopyWith<$Res>  {
  factory $ProjectTaskWorkflowTransitionResponseCopyWith(ProjectTaskWorkflowTransitionResponse value, $Res Function(ProjectTaskWorkflowTransitionResponse) _then) = _$ProjectTaskWorkflowTransitionResponseCopyWithImpl;
@useResult
$Res call({
 ProjectTaskStatus fromStatus, ProjectTaskStatus toStatus
});




}
/// @nodoc
class _$ProjectTaskWorkflowTransitionResponseCopyWithImpl<$Res>
    implements $ProjectTaskWorkflowTransitionResponseCopyWith<$Res> {
  _$ProjectTaskWorkflowTransitionResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskWorkflowTransitionResponse _self;
  final $Res Function(ProjectTaskWorkflowTransitionResponse) _then;

/// Create a copy of ProjectTaskWorkflowTransitionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromStatus = null,Object? toStatus = null,}) {
  return _then(_self.copyWith(
fromStatus: null == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskWorkflowTransitionResponse].
extension ProjectTaskWorkflowTransitionResponsePatterns on ProjectTaskWorkflowTransitionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskWorkflowTransitionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskWorkflowTransitionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskWorkflowTransitionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskWorkflowTransitionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskWorkflowTransitionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskWorkflowTransitionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectTaskStatus fromStatus,  ProjectTaskStatus toStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskWorkflowTransitionResponse() when $default != null:
return $default(_that.fromStatus,_that.toStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectTaskStatus fromStatus,  ProjectTaskStatus toStatus)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskWorkflowTransitionResponse():
return $default(_that.fromStatus,_that.toStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectTaskStatus fromStatus,  ProjectTaskStatus toStatus)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskWorkflowTransitionResponse() when $default != null:
return $default(_that.fromStatus,_that.toStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskWorkflowTransitionResponse implements ProjectTaskWorkflowTransitionResponse {
  const _ProjectTaskWorkflowTransitionResponse({required this.fromStatus, required this.toStatus});
  factory _ProjectTaskWorkflowTransitionResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskWorkflowTransitionResponseFromJson(json);

@override final  ProjectTaskStatus fromStatus;
@override final  ProjectTaskStatus toStatus;

/// Create a copy of ProjectTaskWorkflowTransitionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskWorkflowTransitionResponseCopyWith<_ProjectTaskWorkflowTransitionResponse> get copyWith => __$ProjectTaskWorkflowTransitionResponseCopyWithImpl<_ProjectTaskWorkflowTransitionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskWorkflowTransitionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskWorkflowTransitionResponse&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromStatus,toStatus);

@override
String toString() {
  return 'ProjectTaskWorkflowTransitionResponse(fromStatus: $fromStatus, toStatus: $toStatus)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskWorkflowTransitionResponseCopyWith<$Res> implements $ProjectTaskWorkflowTransitionResponseCopyWith<$Res> {
  factory _$ProjectTaskWorkflowTransitionResponseCopyWith(_ProjectTaskWorkflowTransitionResponse value, $Res Function(_ProjectTaskWorkflowTransitionResponse) _then) = __$ProjectTaskWorkflowTransitionResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectTaskStatus fromStatus, ProjectTaskStatus toStatus
});




}
/// @nodoc
class __$ProjectTaskWorkflowTransitionResponseCopyWithImpl<$Res>
    implements _$ProjectTaskWorkflowTransitionResponseCopyWith<$Res> {
  __$ProjectTaskWorkflowTransitionResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskWorkflowTransitionResponse _self;
  final $Res Function(_ProjectTaskWorkflowTransitionResponse) _then;

/// Create a copy of ProjectTaskWorkflowTransitionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromStatus = null,Object? toStatus = null,}) {
  return _then(_ProjectTaskWorkflowTransitionResponse(
fromStatus: null == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskWorkflowResponse {

 List<ProjectTaskWorkflowStatusResponse> get statuses; List<ProjectTaskWorkflowTransitionResponse> get transitions; int get version;
/// Create a copy of ProjectTaskWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskWorkflowResponseCopyWith<ProjectTaskWorkflowResponse> get copyWith => _$ProjectTaskWorkflowResponseCopyWithImpl<ProjectTaskWorkflowResponse>(this as ProjectTaskWorkflowResponse, _$identity);

  /// Serializes this ProjectTaskWorkflowResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskWorkflowResponse&&const DeepCollectionEquality().equals(other.statuses, statuses)&&const DeepCollectionEquality().equals(other.transitions, transitions)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(statuses),const DeepCollectionEquality().hash(transitions),version);

@override
String toString() {
  return 'ProjectTaskWorkflowResponse(statuses: $statuses, transitions: $transitions, version: $version)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskWorkflowResponseCopyWith<$Res>  {
  factory $ProjectTaskWorkflowResponseCopyWith(ProjectTaskWorkflowResponse value, $Res Function(ProjectTaskWorkflowResponse) _then) = _$ProjectTaskWorkflowResponseCopyWithImpl;
@useResult
$Res call({
 List<ProjectTaskWorkflowStatusResponse> statuses, List<ProjectTaskWorkflowTransitionResponse> transitions, int version
});




}
/// @nodoc
class _$ProjectTaskWorkflowResponseCopyWithImpl<$Res>
    implements $ProjectTaskWorkflowResponseCopyWith<$Res> {
  _$ProjectTaskWorkflowResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskWorkflowResponse _self;
  final $Res Function(ProjectTaskWorkflowResponse) _then;

/// Create a copy of ProjectTaskWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statuses = null,Object? transitions = null,Object? version = null,}) {
  return _then(_self.copyWith(
statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskWorkflowStatusResponse>,transitions: null == transitions ? _self.transitions : transitions // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskWorkflowTransitionResponse>,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskWorkflowResponse].
extension ProjectTaskWorkflowResponsePatterns on ProjectTaskWorkflowResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskWorkflowResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskWorkflowResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskWorkflowResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskWorkflowResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskWorkflowResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskWorkflowResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProjectTaskWorkflowStatusResponse> statuses,  List<ProjectTaskWorkflowTransitionResponse> transitions,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskWorkflowResponse() when $default != null:
return $default(_that.statuses,_that.transitions,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProjectTaskWorkflowStatusResponse> statuses,  List<ProjectTaskWorkflowTransitionResponse> transitions,  int version)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskWorkflowResponse():
return $default(_that.statuses,_that.transitions,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProjectTaskWorkflowStatusResponse> statuses,  List<ProjectTaskWorkflowTransitionResponse> transitions,  int version)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskWorkflowResponse() when $default != null:
return $default(_that.statuses,_that.transitions,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskWorkflowResponse implements ProjectTaskWorkflowResponse {
  const _ProjectTaskWorkflowResponse({required this.statuses, required this.transitions, required this.version});
  factory _ProjectTaskWorkflowResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskWorkflowResponseFromJson(json);

@override final  List<ProjectTaskWorkflowStatusResponse> statuses;
@override final  List<ProjectTaskWorkflowTransitionResponse> transitions;
@override final  int version;

/// Create a copy of ProjectTaskWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskWorkflowResponseCopyWith<_ProjectTaskWorkflowResponse> get copyWith => __$ProjectTaskWorkflowResponseCopyWithImpl<_ProjectTaskWorkflowResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskWorkflowResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskWorkflowResponse&&const DeepCollectionEquality().equals(other.statuses, statuses)&&const DeepCollectionEquality().equals(other.transitions, transitions)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(statuses),const DeepCollectionEquality().hash(transitions),version);

@override
String toString() {
  return 'ProjectTaskWorkflowResponse(statuses: $statuses, transitions: $transitions, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskWorkflowResponseCopyWith<$Res> implements $ProjectTaskWorkflowResponseCopyWith<$Res> {
  factory _$ProjectTaskWorkflowResponseCopyWith(_ProjectTaskWorkflowResponse value, $Res Function(_ProjectTaskWorkflowResponse) _then) = __$ProjectTaskWorkflowResponseCopyWithImpl;
@override @useResult
$Res call({
 List<ProjectTaskWorkflowStatusResponse> statuses, List<ProjectTaskWorkflowTransitionResponse> transitions, int version
});




}
/// @nodoc
class __$ProjectTaskWorkflowResponseCopyWithImpl<$Res>
    implements _$ProjectTaskWorkflowResponseCopyWith<$Res> {
  __$ProjectTaskWorkflowResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskWorkflowResponse _self;
  final $Res Function(_ProjectTaskWorkflowResponse) _then;

/// Create a copy of ProjectTaskWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statuses = null,Object? transitions = null,Object? version = null,}) {
  return _then(_ProjectTaskWorkflowResponse(
statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskWorkflowStatusResponse>,transitions: null == transitions ? _self.transitions : transitions // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskWorkflowTransitionResponse>,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateProjectTaskPayload {

 String get title; String? get description; String? get parentTaskId; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; List<String>? get assigneeCoreUserIds; List<String>? get checklistItems; String? get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; int? get actualMinutes; String? get descriptionDeltaJson; String? get milestoneId; ProjectTaskStatus? get targetStatus; String? get customStatusId; String? get previousTaskId; String? get nextTaskId;
/// Create a copy of CreateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProjectTaskPayloadCopyWith<CreateProjectTaskPayload> get copyWith => _$CreateProjectTaskPayloadCopyWithImpl<CreateProjectTaskPayload>(this as CreateProjectTaskPayload, _$identity);

  /// Serializes this CreateProjectTaskPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProjectTaskPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,description,parentTaskId,status,priority,startAtUtc,dueAtUtc,const DeepCollectionEquality().hash(assigneeCoreUserIds),const DeepCollectionEquality().hash(checklistItems),taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,descriptionDeltaJson,milestoneId,targetStatus,customStatusId,previousTaskId,nextTaskId]);

@override
String toString() {
  return 'CreateProjectTaskPayload(title: $title, description: $description, parentTaskId: $parentTaskId, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, assigneeCoreUserIds: $assigneeCoreUserIds, checklistItems: $checklistItems, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, descriptionDeltaJson: $descriptionDeltaJson, milestoneId: $milestoneId, targetStatus: $targetStatus, customStatusId: $customStatusId, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId)';
}


}

/// @nodoc
abstract mixin class $CreateProjectTaskPayloadCopyWith<$Res>  {
  factory $CreateProjectTaskPayloadCopyWith(CreateProjectTaskPayload value, $Res Function(CreateProjectTaskPayload) _then) = _$CreateProjectTaskPayloadCopyWithImpl;
@useResult
$Res call({
 String title, String? description, String? parentTaskId, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, List<String>? assigneeCoreUserIds, List<String>? checklistItems, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, String? descriptionDeltaJson, String? milestoneId, ProjectTaskStatus? targetStatus, String? customStatusId, String? previousTaskId, String? nextTaskId
});




}
/// @nodoc
class _$CreateProjectTaskPayloadCopyWithImpl<$Res>
    implements $CreateProjectTaskPayloadCopyWith<$Res> {
  _$CreateProjectTaskPayloadCopyWithImpl(this._self, this._then);

  final CreateProjectTaskPayload _self;
  final $Res Function(CreateProjectTaskPayload) _then;

/// Create a copy of CreateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? parentTaskId = freezed,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? assigneeCoreUserIds = freezed,Object? checklistItems = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? descriptionDeltaJson = freezed,Object? milestoneId = freezed,Object? targetStatus = freezed,Object? customStatusId = freezed,Object? previousTaskId = freezed,Object? nextTaskId = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assigneeCoreUserIds: freezed == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,checklistItems: freezed == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualMinutes: freezed == actualMinutes ? _self.actualMinutes : actualMinutes // ignore: cast_nullable_to_non_nullable
as int?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,targetStatus: freezed == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,previousTaskId: freezed == previousTaskId ? _self.previousTaskId : previousTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextTaskId: freezed == nextTaskId ? _self.nextTaskId : nextTaskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProjectTaskPayload].
extension CreateProjectTaskPayloadPatterns on CreateProjectTaskPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProjectTaskPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProjectTaskPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProjectTaskPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateProjectTaskPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProjectTaskPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProjectTaskPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description,  String? parentTaskId,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<String>? assigneeCoreUserIds,  List<String>? checklistItems,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  String? descriptionDeltaJson,  String? milestoneId,  ProjectTaskStatus? targetStatus,  String? customStatusId,  String? previousTaskId,  String? nextTaskId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProjectTaskPayload() when $default != null:
return $default(_that.title,_that.description,_that.parentTaskId,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assigneeCoreUserIds,_that.checklistItems,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.descriptionDeltaJson,_that.milestoneId,_that.targetStatus,_that.customStatusId,_that.previousTaskId,_that.nextTaskId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description,  String? parentTaskId,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<String>? assigneeCoreUserIds,  List<String>? checklistItems,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  String? descriptionDeltaJson,  String? milestoneId,  ProjectTaskStatus? targetStatus,  String? customStatusId,  String? previousTaskId,  String? nextTaskId)  $default,) {final _that = this;
switch (_that) {
case _CreateProjectTaskPayload():
return $default(_that.title,_that.description,_that.parentTaskId,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assigneeCoreUserIds,_that.checklistItems,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.descriptionDeltaJson,_that.milestoneId,_that.targetStatus,_that.customStatusId,_that.previousTaskId,_that.nextTaskId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description,  String? parentTaskId,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<String>? assigneeCoreUserIds,  List<String>? checklistItems,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  String? descriptionDeltaJson,  String? milestoneId,  ProjectTaskStatus? targetStatus,  String? customStatusId,  String? previousTaskId,  String? nextTaskId)?  $default,) {final _that = this;
switch (_that) {
case _CreateProjectTaskPayload() when $default != null:
return $default(_that.title,_that.description,_that.parentTaskId,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assigneeCoreUserIds,_that.checklistItems,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.descriptionDeltaJson,_that.milestoneId,_that.targetStatus,_that.customStatusId,_that.previousTaskId,_that.nextTaskId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProjectTaskPayload implements CreateProjectTaskPayload {
  const _CreateProjectTaskPayload({required this.title, this.description, this.parentTaskId, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, this.assigneeCoreUserIds, this.checklistItems, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.actualMinutes, this.descriptionDeltaJson, this.milestoneId, this.targetStatus, this.customStatusId, this.previousTaskId, this.nextTaskId});
  factory _CreateProjectTaskPayload.fromJson(Map<String, dynamic> json) => _$CreateProjectTaskPayloadFromJson(json);

@override final  String title;
@override final  String? description;
@override final  String? parentTaskId;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  List<String>? assigneeCoreUserIds;
@override final  List<String>? checklistItems;
@override final  String? taskType;
@override final  int? size;
@override final  int? complexity;
@override final  int? risk;
@override final  int? businessValue;
@override final  int? estimatedMinutes;
@override final  int? actualMinutes;
@override final  String? descriptionDeltaJson;
@override final  String? milestoneId;
@override final  ProjectTaskStatus? targetStatus;
@override final  String? customStatusId;
@override final  String? previousTaskId;
@override final  String? nextTaskId;

/// Create a copy of CreateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProjectTaskPayloadCopyWith<_CreateProjectTaskPayload> get copyWith => __$CreateProjectTaskPayloadCopyWithImpl<_CreateProjectTaskPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProjectTaskPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProjectTaskPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,description,parentTaskId,status,priority,startAtUtc,dueAtUtc,const DeepCollectionEquality().hash(assigneeCoreUserIds),const DeepCollectionEquality().hash(checklistItems),taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,descriptionDeltaJson,milestoneId,targetStatus,customStatusId,previousTaskId,nextTaskId]);

@override
String toString() {
  return 'CreateProjectTaskPayload(title: $title, description: $description, parentTaskId: $parentTaskId, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, assigneeCoreUserIds: $assigneeCoreUserIds, checklistItems: $checklistItems, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, descriptionDeltaJson: $descriptionDeltaJson, milestoneId: $milestoneId, targetStatus: $targetStatus, customStatusId: $customStatusId, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId)';
}


}

/// @nodoc
abstract mixin class _$CreateProjectTaskPayloadCopyWith<$Res> implements $CreateProjectTaskPayloadCopyWith<$Res> {
  factory _$CreateProjectTaskPayloadCopyWith(_CreateProjectTaskPayload value, $Res Function(_CreateProjectTaskPayload) _then) = __$CreateProjectTaskPayloadCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, String? parentTaskId, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, List<String>? assigneeCoreUserIds, List<String>? checklistItems, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, String? descriptionDeltaJson, String? milestoneId, ProjectTaskStatus? targetStatus, String? customStatusId, String? previousTaskId, String? nextTaskId
});




}
/// @nodoc
class __$CreateProjectTaskPayloadCopyWithImpl<$Res>
    implements _$CreateProjectTaskPayloadCopyWith<$Res> {
  __$CreateProjectTaskPayloadCopyWithImpl(this._self, this._then);

  final _CreateProjectTaskPayload _self;
  final $Res Function(_CreateProjectTaskPayload) _then;

/// Create a copy of CreateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? parentTaskId = freezed,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? assigneeCoreUserIds = freezed,Object? checklistItems = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? descriptionDeltaJson = freezed,Object? milestoneId = freezed,Object? targetStatus = freezed,Object? customStatusId = freezed,Object? previousTaskId = freezed,Object? nextTaskId = freezed,}) {
  return _then(_CreateProjectTaskPayload(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assigneeCoreUserIds: freezed == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,checklistItems: freezed == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualMinutes: freezed == actualMinutes ? _self.actualMinutes : actualMinutes // ignore: cast_nullable_to_non_nullable
as int?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,targetStatus: freezed == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,previousTaskId: freezed == previousTaskId ? _self.previousTaskId : previousTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextTaskId: freezed == nextTaskId ? _self.nextTaskId : nextTaskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$QuickCreateProjectTaskPayload {

 String get title;@JsonKey(includeIfNull: false) String? get parentTaskId;@JsonKey(includeIfNull: false) String? get taskTemplateId; bool get useDefaultTemplate;@JsonKey(includeIfNull: false) ProjectTaskStatus? get targetStatus;@JsonKey(includeIfNull: false) String? get customStatusId;@JsonKey(includeIfNull: false) String? get previousTaskId;@JsonKey(includeIfNull: false) String? get nextTaskId;
/// Create a copy of QuickCreateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickCreateProjectTaskPayloadCopyWith<QuickCreateProjectTaskPayload> get copyWith => _$QuickCreateProjectTaskPayloadCopyWithImpl<QuickCreateProjectTaskPayload>(this as QuickCreateProjectTaskPayload, _$identity);

  /// Serializes this QuickCreateProjectTaskPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickCreateProjectTaskPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.taskTemplateId, taskTemplateId) || other.taskTemplateId == taskTemplateId)&&(identical(other.useDefaultTemplate, useDefaultTemplate) || other.useDefaultTemplate == useDefaultTemplate)&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,parentTaskId,taskTemplateId,useDefaultTemplate,targetStatus,customStatusId,previousTaskId,nextTaskId);

@override
String toString() {
  return 'QuickCreateProjectTaskPayload(title: $title, parentTaskId: $parentTaskId, taskTemplateId: $taskTemplateId, useDefaultTemplate: $useDefaultTemplate, targetStatus: $targetStatus, customStatusId: $customStatusId, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId)';
}


}

/// @nodoc
abstract mixin class $QuickCreateProjectTaskPayloadCopyWith<$Res>  {
  factory $QuickCreateProjectTaskPayloadCopyWith(QuickCreateProjectTaskPayload value, $Res Function(QuickCreateProjectTaskPayload) _then) = _$QuickCreateProjectTaskPayloadCopyWithImpl;
@useResult
$Res call({
 String title,@JsonKey(includeIfNull: false) String? parentTaskId,@JsonKey(includeIfNull: false) String? taskTemplateId, bool useDefaultTemplate,@JsonKey(includeIfNull: false) ProjectTaskStatus? targetStatus,@JsonKey(includeIfNull: false) String? customStatusId,@JsonKey(includeIfNull: false) String? previousTaskId,@JsonKey(includeIfNull: false) String? nextTaskId
});




}
/// @nodoc
class _$QuickCreateProjectTaskPayloadCopyWithImpl<$Res>
    implements $QuickCreateProjectTaskPayloadCopyWith<$Res> {
  _$QuickCreateProjectTaskPayloadCopyWithImpl(this._self, this._then);

  final QuickCreateProjectTaskPayload _self;
  final $Res Function(QuickCreateProjectTaskPayload) _then;

/// Create a copy of QuickCreateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? parentTaskId = freezed,Object? taskTemplateId = freezed,Object? useDefaultTemplate = null,Object? targetStatus = freezed,Object? customStatusId = freezed,Object? previousTaskId = freezed,Object? nextTaskId = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,taskTemplateId: freezed == taskTemplateId ? _self.taskTemplateId : taskTemplateId // ignore: cast_nullable_to_non_nullable
as String?,useDefaultTemplate: null == useDefaultTemplate ? _self.useDefaultTemplate : useDefaultTemplate // ignore: cast_nullable_to_non_nullable
as bool,targetStatus: freezed == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,previousTaskId: freezed == previousTaskId ? _self.previousTaskId : previousTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextTaskId: freezed == nextTaskId ? _self.nextTaskId : nextTaskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickCreateProjectTaskPayload].
extension QuickCreateProjectTaskPayloadPatterns on QuickCreateProjectTaskPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickCreateProjectTaskPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickCreateProjectTaskPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickCreateProjectTaskPayload value)  $default,){
final _that = this;
switch (_that) {
case _QuickCreateProjectTaskPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickCreateProjectTaskPayload value)?  $default,){
final _that = this;
switch (_that) {
case _QuickCreateProjectTaskPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @JsonKey(includeIfNull: false)  String? parentTaskId, @JsonKey(includeIfNull: false)  String? taskTemplateId,  bool useDefaultTemplate, @JsonKey(includeIfNull: false)  ProjectTaskStatus? targetStatus, @JsonKey(includeIfNull: false)  String? customStatusId, @JsonKey(includeIfNull: false)  String? previousTaskId, @JsonKey(includeIfNull: false)  String? nextTaskId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickCreateProjectTaskPayload() when $default != null:
return $default(_that.title,_that.parentTaskId,_that.taskTemplateId,_that.useDefaultTemplate,_that.targetStatus,_that.customStatusId,_that.previousTaskId,_that.nextTaskId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @JsonKey(includeIfNull: false)  String? parentTaskId, @JsonKey(includeIfNull: false)  String? taskTemplateId,  bool useDefaultTemplate, @JsonKey(includeIfNull: false)  ProjectTaskStatus? targetStatus, @JsonKey(includeIfNull: false)  String? customStatusId, @JsonKey(includeIfNull: false)  String? previousTaskId, @JsonKey(includeIfNull: false)  String? nextTaskId)  $default,) {final _that = this;
switch (_that) {
case _QuickCreateProjectTaskPayload():
return $default(_that.title,_that.parentTaskId,_that.taskTemplateId,_that.useDefaultTemplate,_that.targetStatus,_that.customStatusId,_that.previousTaskId,_that.nextTaskId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @JsonKey(includeIfNull: false)  String? parentTaskId, @JsonKey(includeIfNull: false)  String? taskTemplateId,  bool useDefaultTemplate, @JsonKey(includeIfNull: false)  ProjectTaskStatus? targetStatus, @JsonKey(includeIfNull: false)  String? customStatusId, @JsonKey(includeIfNull: false)  String? previousTaskId, @JsonKey(includeIfNull: false)  String? nextTaskId)?  $default,) {final _that = this;
switch (_that) {
case _QuickCreateProjectTaskPayload() when $default != null:
return $default(_that.title,_that.parentTaskId,_that.taskTemplateId,_that.useDefaultTemplate,_that.targetStatus,_that.customStatusId,_that.previousTaskId,_that.nextTaskId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuickCreateProjectTaskPayload implements QuickCreateProjectTaskPayload {
  const _QuickCreateProjectTaskPayload({required this.title, @JsonKey(includeIfNull: false) this.parentTaskId, @JsonKey(includeIfNull: false) this.taskTemplateId, this.useDefaultTemplate = true, @JsonKey(includeIfNull: false) this.targetStatus, @JsonKey(includeIfNull: false) this.customStatusId, @JsonKey(includeIfNull: false) this.previousTaskId, @JsonKey(includeIfNull: false) this.nextTaskId});
  factory _QuickCreateProjectTaskPayload.fromJson(Map<String, dynamic> json) => _$QuickCreateProjectTaskPayloadFromJson(json);

@override final  String title;
@override@JsonKey(includeIfNull: false) final  String? parentTaskId;
@override@JsonKey(includeIfNull: false) final  String? taskTemplateId;
@override@JsonKey() final  bool useDefaultTemplate;
@override@JsonKey(includeIfNull: false) final  ProjectTaskStatus? targetStatus;
@override@JsonKey(includeIfNull: false) final  String? customStatusId;
@override@JsonKey(includeIfNull: false) final  String? previousTaskId;
@override@JsonKey(includeIfNull: false) final  String? nextTaskId;

/// Create a copy of QuickCreateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickCreateProjectTaskPayloadCopyWith<_QuickCreateProjectTaskPayload> get copyWith => __$QuickCreateProjectTaskPayloadCopyWithImpl<_QuickCreateProjectTaskPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuickCreateProjectTaskPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickCreateProjectTaskPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.taskTemplateId, taskTemplateId) || other.taskTemplateId == taskTemplateId)&&(identical(other.useDefaultTemplate, useDefaultTemplate) || other.useDefaultTemplate == useDefaultTemplate)&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,parentTaskId,taskTemplateId,useDefaultTemplate,targetStatus,customStatusId,previousTaskId,nextTaskId);

@override
String toString() {
  return 'QuickCreateProjectTaskPayload(title: $title, parentTaskId: $parentTaskId, taskTemplateId: $taskTemplateId, useDefaultTemplate: $useDefaultTemplate, targetStatus: $targetStatus, customStatusId: $customStatusId, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId)';
}


}

/// @nodoc
abstract mixin class _$QuickCreateProjectTaskPayloadCopyWith<$Res> implements $QuickCreateProjectTaskPayloadCopyWith<$Res> {
  factory _$QuickCreateProjectTaskPayloadCopyWith(_QuickCreateProjectTaskPayload value, $Res Function(_QuickCreateProjectTaskPayload) _then) = __$QuickCreateProjectTaskPayloadCopyWithImpl;
@override @useResult
$Res call({
 String title,@JsonKey(includeIfNull: false) String? parentTaskId,@JsonKey(includeIfNull: false) String? taskTemplateId, bool useDefaultTemplate,@JsonKey(includeIfNull: false) ProjectTaskStatus? targetStatus,@JsonKey(includeIfNull: false) String? customStatusId,@JsonKey(includeIfNull: false) String? previousTaskId,@JsonKey(includeIfNull: false) String? nextTaskId
});




}
/// @nodoc
class __$QuickCreateProjectTaskPayloadCopyWithImpl<$Res>
    implements _$QuickCreateProjectTaskPayloadCopyWith<$Res> {
  __$QuickCreateProjectTaskPayloadCopyWithImpl(this._self, this._then);

  final _QuickCreateProjectTaskPayload _self;
  final $Res Function(_QuickCreateProjectTaskPayload) _then;

/// Create a copy of QuickCreateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? parentTaskId = freezed,Object? taskTemplateId = freezed,Object? useDefaultTemplate = null,Object? targetStatus = freezed,Object? customStatusId = freezed,Object? previousTaskId = freezed,Object? nextTaskId = freezed,}) {
  return _then(_QuickCreateProjectTaskPayload(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,taskTemplateId: freezed == taskTemplateId ? _self.taskTemplateId : taskTemplateId // ignore: cast_nullable_to_non_nullable
as String?,useDefaultTemplate: null == useDefaultTemplate ? _self.useDefaultTemplate : useDefaultTemplate // ignore: cast_nullable_to_non_nullable
as bool,targetStatus: freezed == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,previousTaskId: freezed == previousTaskId ? _self.previousTaskId : previousTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextTaskId: freezed == nextTaskId ? _self.nextTaskId : nextTaskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateProjectTaskPayload {

 String get title; String? get description; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; int get position; int get expectedVersion; String? get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; int? get actualMinutes; String? get descriptionDeltaJson; String? get milestoneId; String? get customStatusId; bool get clearMilestone;
/// Create a copy of UpdateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProjectTaskPayloadCopyWith<UpdateProjectTaskPayload> get copyWith => _$UpdateProjectTaskPayloadCopyWithImpl<UpdateProjectTaskPayload>(this as UpdateProjectTaskPayload, _$identity);

  /// Serializes this UpdateProjectTaskPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProjectTaskPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.position, position) || other.position == position)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.clearMilestone, clearMilestone) || other.clearMilestone == clearMilestone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,description,status,priority,startAtUtc,dueAtUtc,position,expectedVersion,taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,descriptionDeltaJson,milestoneId,customStatusId,clearMilestone]);

@override
String toString() {
  return 'UpdateProjectTaskPayload(title: $title, description: $description, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, position: $position, expectedVersion: $expectedVersion, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, descriptionDeltaJson: $descriptionDeltaJson, milestoneId: $milestoneId, customStatusId: $customStatusId, clearMilestone: $clearMilestone)';
}


}

/// @nodoc
abstract mixin class $UpdateProjectTaskPayloadCopyWith<$Res>  {
  factory $UpdateProjectTaskPayloadCopyWith(UpdateProjectTaskPayload value, $Res Function(UpdateProjectTaskPayload) _then) = _$UpdateProjectTaskPayloadCopyWithImpl;
@useResult
$Res call({
 String title, String? description, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, int position, int expectedVersion, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, String? descriptionDeltaJson, String? milestoneId, String? customStatusId, bool clearMilestone
});




}
/// @nodoc
class _$UpdateProjectTaskPayloadCopyWithImpl<$Res>
    implements $UpdateProjectTaskPayloadCopyWith<$Res> {
  _$UpdateProjectTaskPayloadCopyWithImpl(this._self, this._then);

  final UpdateProjectTaskPayload _self;
  final $Res Function(UpdateProjectTaskPayload) _then;

/// Create a copy of UpdateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? position = null,Object? expectedVersion = null,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? descriptionDeltaJson = freezed,Object? milestoneId = freezed,Object? customStatusId = freezed,Object? clearMilestone = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualMinutes: freezed == actualMinutes ? _self.actualMinutes : actualMinutes // ignore: cast_nullable_to_non_nullable
as int?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,clearMilestone: null == clearMilestone ? _self.clearMilestone : clearMilestone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProjectTaskPayload].
extension UpdateProjectTaskPayloadPatterns on UpdateProjectTaskPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProjectTaskPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProjectTaskPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProjectTaskPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectTaskPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProjectTaskPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectTaskPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  int position,  int expectedVersion,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  String? descriptionDeltaJson,  String? milestoneId,  String? customStatusId,  bool clearMilestone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProjectTaskPayload() when $default != null:
return $default(_that.title,_that.description,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.position,_that.expectedVersion,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.descriptionDeltaJson,_that.milestoneId,_that.customStatusId,_that.clearMilestone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  int position,  int expectedVersion,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  String? descriptionDeltaJson,  String? milestoneId,  String? customStatusId,  bool clearMilestone)  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectTaskPayload():
return $default(_that.title,_that.description,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.position,_that.expectedVersion,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.descriptionDeltaJson,_that.milestoneId,_that.customStatusId,_that.clearMilestone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  int position,  int expectedVersion,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  String? descriptionDeltaJson,  String? milestoneId,  String? customStatusId,  bool clearMilestone)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectTaskPayload() when $default != null:
return $default(_that.title,_that.description,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.position,_that.expectedVersion,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.descriptionDeltaJson,_that.milestoneId,_that.customStatusId,_that.clearMilestone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProjectTaskPayload implements UpdateProjectTaskPayload {
  const _UpdateProjectTaskPayload({required this.title, this.description, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, required this.position, required this.expectedVersion, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.actualMinutes, this.descriptionDeltaJson, this.milestoneId, this.customStatusId, this.clearMilestone = false});
  factory _UpdateProjectTaskPayload.fromJson(Map<String, dynamic> json) => _$UpdateProjectTaskPayloadFromJson(json);

@override final  String title;
@override final  String? description;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  int position;
@override final  int expectedVersion;
@override final  String? taskType;
@override final  int? size;
@override final  int? complexity;
@override final  int? risk;
@override final  int? businessValue;
@override final  int? estimatedMinutes;
@override final  int? actualMinutes;
@override final  String? descriptionDeltaJson;
@override final  String? milestoneId;
@override final  String? customStatusId;
@override@JsonKey() final  bool clearMilestone;

/// Create a copy of UpdateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProjectTaskPayloadCopyWith<_UpdateProjectTaskPayload> get copyWith => __$UpdateProjectTaskPayloadCopyWithImpl<_UpdateProjectTaskPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProjectTaskPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProjectTaskPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.position, position) || other.position == position)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.clearMilestone, clearMilestone) || other.clearMilestone == clearMilestone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,description,status,priority,startAtUtc,dueAtUtc,position,expectedVersion,taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,descriptionDeltaJson,milestoneId,customStatusId,clearMilestone]);

@override
String toString() {
  return 'UpdateProjectTaskPayload(title: $title, description: $description, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, position: $position, expectedVersion: $expectedVersion, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, descriptionDeltaJson: $descriptionDeltaJson, milestoneId: $milestoneId, customStatusId: $customStatusId, clearMilestone: $clearMilestone)';
}


}

/// @nodoc
abstract mixin class _$UpdateProjectTaskPayloadCopyWith<$Res> implements $UpdateProjectTaskPayloadCopyWith<$Res> {
  factory _$UpdateProjectTaskPayloadCopyWith(_UpdateProjectTaskPayload value, $Res Function(_UpdateProjectTaskPayload) _then) = __$UpdateProjectTaskPayloadCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, int position, int expectedVersion, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, String? descriptionDeltaJson, String? milestoneId, String? customStatusId, bool clearMilestone
});




}
/// @nodoc
class __$UpdateProjectTaskPayloadCopyWithImpl<$Res>
    implements _$UpdateProjectTaskPayloadCopyWith<$Res> {
  __$UpdateProjectTaskPayloadCopyWithImpl(this._self, this._then);

  final _UpdateProjectTaskPayload _self;
  final $Res Function(_UpdateProjectTaskPayload) _then;

/// Create a copy of UpdateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? position = null,Object? expectedVersion = null,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? descriptionDeltaJson = freezed,Object? milestoneId = freezed,Object? customStatusId = freezed,Object? clearMilestone = null,}) {
  return _then(_UpdateProjectTaskPayload(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualMinutes: freezed == actualMinutes ? _self.actualMinutes : actualMinutes // ignore: cast_nullable_to_non_nullable
as int?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,clearMilestone: null == clearMilestone ? _self.clearMilestone : clearMilestone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TaskAssigneeResponse {

 String get coreUserId; bool get isPrimary; DateTime get createdAtUtc;
/// Create a copy of TaskAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskAssigneeResponseCopyWith<TaskAssigneeResponse> get copyWith => _$TaskAssigneeResponseCopyWithImpl<TaskAssigneeResponse>(this as TaskAssigneeResponse, _$identity);

  /// Serializes this TaskAssigneeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskAssigneeResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,isPrimary,createdAtUtc);

@override
String toString() {
  return 'TaskAssigneeResponse(coreUserId: $coreUserId, isPrimary: $isPrimary, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskAssigneeResponseCopyWith<$Res>  {
  factory $TaskAssigneeResponseCopyWith(TaskAssigneeResponse value, $Res Function(TaskAssigneeResponse) _then) = _$TaskAssigneeResponseCopyWithImpl;
@useResult
$Res call({
 String coreUserId, bool isPrimary, DateTime createdAtUtc
});




}
/// @nodoc
class _$TaskAssigneeResponseCopyWithImpl<$Res>
    implements $TaskAssigneeResponseCopyWith<$Res> {
  _$TaskAssigneeResponseCopyWithImpl(this._self, this._then);

  final TaskAssigneeResponse _self;
  final $Res Function(TaskAssigneeResponse) _then;

/// Create a copy of TaskAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coreUserId = null,Object? isPrimary = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskAssigneeResponse].
extension TaskAssigneeResponsePatterns on TaskAssigneeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskAssigneeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskAssigneeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskAssigneeResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskAssigneeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskAssigneeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskAssigneeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coreUserId,  bool isPrimary,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskAssigneeResponse() when $default != null:
return $default(_that.coreUserId,_that.isPrimary,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coreUserId,  bool isPrimary,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskAssigneeResponse():
return $default(_that.coreUserId,_that.isPrimary,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coreUserId,  bool isPrimary,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskAssigneeResponse() when $default != null:
return $default(_that.coreUserId,_that.isPrimary,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskAssigneeResponse implements TaskAssigneeResponse {
  const _TaskAssigneeResponse({required this.coreUserId, required this.isPrimary, required this.createdAtUtc});
  factory _TaskAssigneeResponse.fromJson(Map<String, dynamic> json) => _$TaskAssigneeResponseFromJson(json);

@override final  String coreUserId;
@override final  bool isPrimary;
@override final  DateTime createdAtUtc;

/// Create a copy of TaskAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskAssigneeResponseCopyWith<_TaskAssigneeResponse> get copyWith => __$TaskAssigneeResponseCopyWithImpl<_TaskAssigneeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskAssigneeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskAssigneeResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,isPrimary,createdAtUtc);

@override
String toString() {
  return 'TaskAssigneeResponse(coreUserId: $coreUserId, isPrimary: $isPrimary, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskAssigneeResponseCopyWith<$Res> implements $TaskAssigneeResponseCopyWith<$Res> {
  factory _$TaskAssigneeResponseCopyWith(_TaskAssigneeResponse value, $Res Function(_TaskAssigneeResponse) _then) = __$TaskAssigneeResponseCopyWithImpl;
@override @useResult
$Res call({
 String coreUserId, bool isPrimary, DateTime createdAtUtc
});




}
/// @nodoc
class __$TaskAssigneeResponseCopyWithImpl<$Res>
    implements _$TaskAssigneeResponseCopyWith<$Res> {
  __$TaskAssigneeResponseCopyWithImpl(this._self, this._then);

  final _TaskAssigneeResponse _self;
  final $Res Function(_TaskAssigneeResponse) _then;

/// Create a copy of TaskAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coreUserId = null,Object? isPrimary = null,Object? createdAtUtc = null,}) {
  return _then(_TaskAssigneeResponse(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskChecklistItemResponse {

 String get id; String get title; int get position; bool get isCompleted; String? get completedByCoreUserId; DateTime? get completedAtUtc; DateTime get updatedAtUtc;
/// Create a copy of TaskChecklistItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskChecklistItemResponseCopyWith<TaskChecklistItemResponse> get copyWith => _$TaskChecklistItemResponseCopyWithImpl<TaskChecklistItemResponse>(this as TaskChecklistItemResponse, _$identity);

  /// Serializes this TaskChecklistItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskChecklistItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.position, position) || other.position == position)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedByCoreUserId, completedByCoreUserId) || other.completedByCoreUserId == completedByCoreUserId)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,position,isCompleted,completedByCoreUserId,completedAtUtc,updatedAtUtc);

@override
String toString() {
  return 'TaskChecklistItemResponse(id: $id, title: $title, position: $position, isCompleted: $isCompleted, completedByCoreUserId: $completedByCoreUserId, completedAtUtc: $completedAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskChecklistItemResponseCopyWith<$Res>  {
  factory $TaskChecklistItemResponseCopyWith(TaskChecklistItemResponse value, $Res Function(TaskChecklistItemResponse) _then) = _$TaskChecklistItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, String title, int position, bool isCompleted, String? completedByCoreUserId, DateTime? completedAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class _$TaskChecklistItemResponseCopyWithImpl<$Res>
    implements $TaskChecklistItemResponseCopyWith<$Res> {
  _$TaskChecklistItemResponseCopyWithImpl(this._self, this._then);

  final TaskChecklistItemResponse _self;
  final $Res Function(TaskChecklistItemResponse) _then;

/// Create a copy of TaskChecklistItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? position = null,Object? isCompleted = null,Object? completedByCoreUserId = freezed,Object? completedAtUtc = freezed,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedByCoreUserId: freezed == completedByCoreUserId ? _self.completedByCoreUserId : completedByCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskChecklistItemResponse].
extension TaskChecklistItemResponsePatterns on TaskChecklistItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskChecklistItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskChecklistItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskChecklistItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskChecklistItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskChecklistItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskChecklistItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  int position,  bool isCompleted,  String? completedByCoreUserId,  DateTime? completedAtUtc,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskChecklistItemResponse() when $default != null:
return $default(_that.id,_that.title,_that.position,_that.isCompleted,_that.completedByCoreUserId,_that.completedAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  int position,  bool isCompleted,  String? completedByCoreUserId,  DateTime? completedAtUtc,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskChecklistItemResponse():
return $default(_that.id,_that.title,_that.position,_that.isCompleted,_that.completedByCoreUserId,_that.completedAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  int position,  bool isCompleted,  String? completedByCoreUserId,  DateTime? completedAtUtc,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskChecklistItemResponse() when $default != null:
return $default(_that.id,_that.title,_that.position,_that.isCompleted,_that.completedByCoreUserId,_that.completedAtUtc,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskChecklistItemResponse implements TaskChecklistItemResponse {
  const _TaskChecklistItemResponse({required this.id, required this.title, required this.position, required this.isCompleted, this.completedByCoreUserId, this.completedAtUtc, required this.updatedAtUtc});
  factory _TaskChecklistItemResponse.fromJson(Map<String, dynamic> json) => _$TaskChecklistItemResponseFromJson(json);

@override final  String id;
@override final  String title;
@override final  int position;
@override final  bool isCompleted;
@override final  String? completedByCoreUserId;
@override final  DateTime? completedAtUtc;
@override final  DateTime updatedAtUtc;

/// Create a copy of TaskChecklistItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskChecklistItemResponseCopyWith<_TaskChecklistItemResponse> get copyWith => __$TaskChecklistItemResponseCopyWithImpl<_TaskChecklistItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskChecklistItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskChecklistItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.position, position) || other.position == position)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedByCoreUserId, completedByCoreUserId) || other.completedByCoreUserId == completedByCoreUserId)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,position,isCompleted,completedByCoreUserId,completedAtUtc,updatedAtUtc);

@override
String toString() {
  return 'TaskChecklistItemResponse(id: $id, title: $title, position: $position, isCompleted: $isCompleted, completedByCoreUserId: $completedByCoreUserId, completedAtUtc: $completedAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskChecklistItemResponseCopyWith<$Res> implements $TaskChecklistItemResponseCopyWith<$Res> {
  factory _$TaskChecklistItemResponseCopyWith(_TaskChecklistItemResponse value, $Res Function(_TaskChecklistItemResponse) _then) = __$TaskChecklistItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int position, bool isCompleted, String? completedByCoreUserId, DateTime? completedAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class __$TaskChecklistItemResponseCopyWithImpl<$Res>
    implements _$TaskChecklistItemResponseCopyWith<$Res> {
  __$TaskChecklistItemResponseCopyWithImpl(this._self, this._then);

  final _TaskChecklistItemResponse _self;
  final $Res Function(_TaskChecklistItemResponse) _then;

/// Create a copy of TaskChecklistItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? position = null,Object? isCompleted = null,Object? completedByCoreUserId = freezed,Object? completedAtUtc = freezed,Object? updatedAtUtc = null,}) {
  return _then(_TaskChecklistItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedByCoreUserId: freezed == completedByCoreUserId ? _self.completedByCoreUserId : completedByCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskListItemResponse {

 String get id; int get number; String get key; String? get parentTaskId; String get title; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; List<TaskAssigneeResponse> get assignees; int get checklistCompletedCount; int get checklistTotalCount; int get subtaskCount; DateTime get updatedAtUtc; int get version; bool get isPinned; String? get customStatusId; List<TaskCustomFieldValueResponse> get customFields; DateTime? get createdAtUtc; String? get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; int? get actualMinutes; List<TaskLabelResponse> get labels; String? get customStatusName; String? get customStatusColor; int get watcherCount; bool get isWatchedByMe; TaskRecurrenceSummaryResponse? get recurrence; String? get milestoneId;
/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskListItemResponseCopyWith<ProjectTaskListItemResponse> get copyWith => _$ProjectTaskListItemResponseCopyWithImpl<ProjectTaskListItemResponse>(this as ProjectTaskListItemResponse, _$identity);

  /// Serializes this ProjectTaskListItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskListItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&(identical(other.checklistCompletedCount, checklistCompletedCount) || other.checklistCompletedCount == checklistCompletedCount)&&(identical(other.checklistTotalCount, checklistTotalCount) || other.checklistTotalCount == checklistTotalCount)&&(identical(other.subtaskCount, subtaskCount) || other.subtaskCount == subtaskCount)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.customStatusName, customStatusName) || other.customStatusName == customStatusName)&&(identical(other.customStatusColor, customStatusColor) || other.customStatusColor == customStatusColor)&&(identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount)&&(identical(other.isWatchedByMe, isWatchedByMe) || other.isWatchedByMe == isWatchedByMe)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,parentTaskId,title,status,priority,startAtUtc,dueAtUtc,const DeepCollectionEquality().hash(assignees),checklistCompletedCount,checklistTotalCount,subtaskCount,updatedAtUtc,version,isPinned,customStatusId,const DeepCollectionEquality().hash(customFields),createdAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,const DeepCollectionEquality().hash(labels),customStatusName,customStatusColor,watcherCount,isWatchedByMe,recurrence,milestoneId]);

@override
String toString() {
  return 'ProjectTaskListItemResponse(id: $id, number: $number, key: $key, parentTaskId: $parentTaskId, title: $title, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, assignees: $assignees, checklistCompletedCount: $checklistCompletedCount, checklistTotalCount: $checklistTotalCount, subtaskCount: $subtaskCount, updatedAtUtc: $updatedAtUtc, version: $version, isPinned: $isPinned, customStatusId: $customStatusId, customFields: $customFields, createdAtUtc: $createdAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, labels: $labels, customStatusName: $customStatusName, customStatusColor: $customStatusColor, watcherCount: $watcherCount, isWatchedByMe: $isWatchedByMe, recurrence: $recurrence, milestoneId: $milestoneId)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskListItemResponseCopyWith<$Res>  {
  factory $ProjectTaskListItemResponseCopyWith(ProjectTaskListItemResponse value, $Res Function(ProjectTaskListItemResponse) _then) = _$ProjectTaskListItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String? parentTaskId, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, List<TaskAssigneeResponse> assignees, int checklistCompletedCount, int checklistTotalCount, int subtaskCount, DateTime updatedAtUtc, int version, bool isPinned, String? customStatusId, List<TaskCustomFieldValueResponse> customFields, DateTime? createdAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, List<TaskLabelResponse> labels, String? customStatusName, String? customStatusColor, int watcherCount, bool isWatchedByMe, TaskRecurrenceSummaryResponse? recurrence, String? milestoneId
});


$TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence;

}
/// @nodoc
class _$ProjectTaskListItemResponseCopyWithImpl<$Res>
    implements $ProjectTaskListItemResponseCopyWith<$Res> {
  _$ProjectTaskListItemResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskListItemResponse _self;
  final $Res Function(ProjectTaskListItemResponse) _then;

/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? parentTaskId = freezed,Object? title = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? assignees = null,Object? checklistCompletedCount = null,Object? checklistTotalCount = null,Object? subtaskCount = null,Object? updatedAtUtc = null,Object? version = null,Object? isPinned = null,Object? customStatusId = freezed,Object? customFields = null,Object? createdAtUtc = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? labels = null,Object? customStatusName = freezed,Object? customStatusColor = freezed,Object? watcherCount = null,Object? isWatchedByMe = null,Object? recurrence = freezed,Object? milestoneId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<TaskAssigneeResponse>,checklistCompletedCount: null == checklistCompletedCount ? _self.checklistCompletedCount : checklistCompletedCount // ignore: cast_nullable_to_non_nullable
as int,checklistTotalCount: null == checklistTotalCount ? _self.checklistTotalCount : checklistTotalCount // ignore: cast_nullable_to_non_nullable
as int,subtaskCount: null == subtaskCount ? _self.subtaskCount : subtaskCount // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<TaskCustomFieldValueResponse>,createdAtUtc: freezed == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualMinutes: freezed == actualMinutes ? _self.actualMinutes : actualMinutes // ignore: cast_nullable_to_non_nullable
as int?,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskLabelResponse>,customStatusName: freezed == customStatusName ? _self.customStatusName : customStatusName // ignore: cast_nullable_to_non_nullable
as String?,customStatusColor: freezed == customStatusColor ? _self.customStatusColor : customStatusColor // ignore: cast_nullable_to_non_nullable
as String?,watcherCount: null == watcherCount ? _self.watcherCount : watcherCount // ignore: cast_nullable_to_non_nullable
as int,isWatchedByMe: null == isWatchedByMe ? _self.isWatchedByMe : isWatchedByMe // ignore: cast_nullable_to_non_nullable
as bool,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceSummaryResponse?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $TaskRecurrenceSummaryResponseCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectTaskListItemResponse].
extension ProjectTaskListItemResponsePatterns on ProjectTaskListItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskListItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskListItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskListItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String? parentTaskId,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<TaskAssigneeResponse> assignees,  int checklistCompletedCount,  int checklistTotalCount,  int subtaskCount,  DateTime updatedAtUtc,  int version,  bool isPinned,  String? customStatusId,  List<TaskCustomFieldValueResponse> customFields,  DateTime? createdAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  List<TaskLabelResponse> labels,  String? customStatusName,  String? customStatusColor,  int watcherCount,  bool isWatchedByMe,  TaskRecurrenceSummaryResponse? recurrence,  String? milestoneId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.parentTaskId,_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assignees,_that.checklistCompletedCount,_that.checklistTotalCount,_that.subtaskCount,_that.updatedAtUtc,_that.version,_that.isPinned,_that.customStatusId,_that.customFields,_that.createdAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.labels,_that.customStatusName,_that.customStatusColor,_that.watcherCount,_that.isWatchedByMe,_that.recurrence,_that.milestoneId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String? parentTaskId,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<TaskAssigneeResponse> assignees,  int checklistCompletedCount,  int checklistTotalCount,  int subtaskCount,  DateTime updatedAtUtc,  int version,  bool isPinned,  String? customStatusId,  List<TaskCustomFieldValueResponse> customFields,  DateTime? createdAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  List<TaskLabelResponse> labels,  String? customStatusName,  String? customStatusColor,  int watcherCount,  bool isWatchedByMe,  TaskRecurrenceSummaryResponse? recurrence,  String? milestoneId)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse():
return $default(_that.id,_that.number,_that.key,_that.parentTaskId,_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assignees,_that.checklistCompletedCount,_that.checklistTotalCount,_that.subtaskCount,_that.updatedAtUtc,_that.version,_that.isPinned,_that.customStatusId,_that.customFields,_that.createdAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.labels,_that.customStatusName,_that.customStatusColor,_that.watcherCount,_that.isWatchedByMe,_that.recurrence,_that.milestoneId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String? parentTaskId,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<TaskAssigneeResponse> assignees,  int checklistCompletedCount,  int checklistTotalCount,  int subtaskCount,  DateTime updatedAtUtc,  int version,  bool isPinned,  String? customStatusId,  List<TaskCustomFieldValueResponse> customFields,  DateTime? createdAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  List<TaskLabelResponse> labels,  String? customStatusName,  String? customStatusColor,  int watcherCount,  bool isWatchedByMe,  TaskRecurrenceSummaryResponse? recurrence,  String? milestoneId)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.parentTaskId,_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assignees,_that.checklistCompletedCount,_that.checklistTotalCount,_that.subtaskCount,_that.updatedAtUtc,_that.version,_that.isPinned,_that.customStatusId,_that.customFields,_that.createdAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.labels,_that.customStatusName,_that.customStatusColor,_that.watcherCount,_that.isWatchedByMe,_that.recurrence,_that.milestoneId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskListItemResponse implements ProjectTaskListItemResponse {
  const _ProjectTaskListItemResponse({required this.id, required this.number, required this.key, this.parentTaskId, required this.title, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, required this.assignees, required this.checklistCompletedCount, required this.checklistTotalCount, this.subtaskCount = 0, required this.updatedAtUtc, required this.version, this.isPinned = false, this.customStatusId, this.customFields = const [], this.createdAtUtc, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.actualMinutes, this.labels = const [], this.customStatusName, this.customStatusColor, this.watcherCount = 0, this.isWatchedByMe = false, this.recurrence, this.milestoneId});
  factory _ProjectTaskListItemResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskListItemResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String key;
@override final  String? parentTaskId;
@override final  String title;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  List<TaskAssigneeResponse> assignees;
@override final  int checklistCompletedCount;
@override final  int checklistTotalCount;
@override@JsonKey() final  int subtaskCount;
@override final  DateTime updatedAtUtc;
@override final  int version;
@override@JsonKey() final  bool isPinned;
@override final  String? customStatusId;
@override@JsonKey() final  List<TaskCustomFieldValueResponse> customFields;
@override final  DateTime? createdAtUtc;
@override final  String? taskType;
@override final  int? size;
@override final  int? complexity;
@override final  int? risk;
@override final  int? businessValue;
@override final  int? estimatedMinutes;
@override final  int? actualMinutes;
@override@JsonKey() final  List<TaskLabelResponse> labels;
@override final  String? customStatusName;
@override final  String? customStatusColor;
@override@JsonKey() final  int watcherCount;
@override@JsonKey() final  bool isWatchedByMe;
@override final  TaskRecurrenceSummaryResponse? recurrence;
@override final  String? milestoneId;

/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskListItemResponseCopyWith<_ProjectTaskListItemResponse> get copyWith => __$ProjectTaskListItemResponseCopyWithImpl<_ProjectTaskListItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskListItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskListItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&(identical(other.checklistCompletedCount, checklistCompletedCount) || other.checklistCompletedCount == checklistCompletedCount)&&(identical(other.checklistTotalCount, checklistTotalCount) || other.checklistTotalCount == checklistTotalCount)&&(identical(other.subtaskCount, subtaskCount) || other.subtaskCount == subtaskCount)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.customStatusName, customStatusName) || other.customStatusName == customStatusName)&&(identical(other.customStatusColor, customStatusColor) || other.customStatusColor == customStatusColor)&&(identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount)&&(identical(other.isWatchedByMe, isWatchedByMe) || other.isWatchedByMe == isWatchedByMe)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,parentTaskId,title,status,priority,startAtUtc,dueAtUtc,const DeepCollectionEquality().hash(assignees),checklistCompletedCount,checklistTotalCount,subtaskCount,updatedAtUtc,version,isPinned,customStatusId,const DeepCollectionEquality().hash(customFields),createdAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,const DeepCollectionEquality().hash(labels),customStatusName,customStatusColor,watcherCount,isWatchedByMe,recurrence,milestoneId]);

@override
String toString() {
  return 'ProjectTaskListItemResponse(id: $id, number: $number, key: $key, parentTaskId: $parentTaskId, title: $title, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, assignees: $assignees, checklistCompletedCount: $checklistCompletedCount, checklistTotalCount: $checklistTotalCount, subtaskCount: $subtaskCount, updatedAtUtc: $updatedAtUtc, version: $version, isPinned: $isPinned, customStatusId: $customStatusId, customFields: $customFields, createdAtUtc: $createdAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, labels: $labels, customStatusName: $customStatusName, customStatusColor: $customStatusColor, watcherCount: $watcherCount, isWatchedByMe: $isWatchedByMe, recurrence: $recurrence, milestoneId: $milestoneId)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskListItemResponseCopyWith<$Res> implements $ProjectTaskListItemResponseCopyWith<$Res> {
  factory _$ProjectTaskListItemResponseCopyWith(_ProjectTaskListItemResponse value, $Res Function(_ProjectTaskListItemResponse) _then) = __$ProjectTaskListItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String? parentTaskId, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, List<TaskAssigneeResponse> assignees, int checklistCompletedCount, int checklistTotalCount, int subtaskCount, DateTime updatedAtUtc, int version, bool isPinned, String? customStatusId, List<TaskCustomFieldValueResponse> customFields, DateTime? createdAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, List<TaskLabelResponse> labels, String? customStatusName, String? customStatusColor, int watcherCount, bool isWatchedByMe, TaskRecurrenceSummaryResponse? recurrence, String? milestoneId
});


@override $TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence;

}
/// @nodoc
class __$ProjectTaskListItemResponseCopyWithImpl<$Res>
    implements _$ProjectTaskListItemResponseCopyWith<$Res> {
  __$ProjectTaskListItemResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskListItemResponse _self;
  final $Res Function(_ProjectTaskListItemResponse) _then;

/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? parentTaskId = freezed,Object? title = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? assignees = null,Object? checklistCompletedCount = null,Object? checklistTotalCount = null,Object? subtaskCount = null,Object? updatedAtUtc = null,Object? version = null,Object? isPinned = null,Object? customStatusId = freezed,Object? customFields = null,Object? createdAtUtc = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? labels = null,Object? customStatusName = freezed,Object? customStatusColor = freezed,Object? watcherCount = null,Object? isWatchedByMe = null,Object? recurrence = freezed,Object? milestoneId = freezed,}) {
  return _then(_ProjectTaskListItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<TaskAssigneeResponse>,checklistCompletedCount: null == checklistCompletedCount ? _self.checklistCompletedCount : checklistCompletedCount // ignore: cast_nullable_to_non_nullable
as int,checklistTotalCount: null == checklistTotalCount ? _self.checklistTotalCount : checklistTotalCount // ignore: cast_nullable_to_non_nullable
as int,subtaskCount: null == subtaskCount ? _self.subtaskCount : subtaskCount // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<TaskCustomFieldValueResponse>,createdAtUtc: freezed == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualMinutes: freezed == actualMinutes ? _self.actualMinutes : actualMinutes // ignore: cast_nullable_to_non_nullable
as int?,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskLabelResponse>,customStatusName: freezed == customStatusName ? _self.customStatusName : customStatusName // ignore: cast_nullable_to_non_nullable
as String?,customStatusColor: freezed == customStatusColor ? _self.customStatusColor : customStatusColor // ignore: cast_nullable_to_non_nullable
as String?,watcherCount: null == watcherCount ? _self.watcherCount : watcherCount // ignore: cast_nullable_to_non_nullable
as int,isWatchedByMe: null == isWatchedByMe ? _self.isWatchedByMe : isWatchedByMe // ignore: cast_nullable_to_non_nullable
as bool,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceSummaryResponse?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $TaskRecurrenceSummaryResponseCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// @nodoc
mixin _$ProjectTaskListGroupResponse {

 String get key; String get displayName; String? get color; int get position; int get totalCount; List<ProjectTaskListItemResponse> get items; String? get nextCursor;
/// Create a copy of ProjectTaskListGroupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskListGroupResponseCopyWith<ProjectTaskListGroupResponse> get copyWith => _$ProjectTaskListGroupResponseCopyWithImpl<ProjectTaskListGroupResponse>(this as ProjectTaskListGroupResponse, _$identity);

  /// Serializes this ProjectTaskListGroupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskListGroupResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,displayName,color,position,totalCount,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'ProjectTaskListGroupResponse(key: $key, displayName: $displayName, color: $color, position: $position, totalCount: $totalCount, items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskListGroupResponseCopyWith<$Res>  {
  factory $ProjectTaskListGroupResponseCopyWith(ProjectTaskListGroupResponse value, $Res Function(ProjectTaskListGroupResponse) _then) = _$ProjectTaskListGroupResponseCopyWithImpl;
@useResult
$Res call({
 String key, String displayName, String? color, int position, int totalCount, List<ProjectTaskListItemResponse> items, String? nextCursor
});




}
/// @nodoc
class _$ProjectTaskListGroupResponseCopyWithImpl<$Res>
    implements $ProjectTaskListGroupResponseCopyWith<$Res> {
  _$ProjectTaskListGroupResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskListGroupResponse _self;
  final $Res Function(ProjectTaskListGroupResponse) _then;

/// Create a copy of ProjectTaskListGroupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? displayName = null,Object? color = freezed,Object? position = null,Object? totalCount = null,Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskListItemResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskListGroupResponse].
extension ProjectTaskListGroupResponsePatterns on ProjectTaskListGroupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskListGroupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskListGroupResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskListGroupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String displayName,  String? color,  int position,  int totalCount,  List<ProjectTaskListItemResponse> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse() when $default != null:
return $default(_that.key,_that.displayName,_that.color,_that.position,_that.totalCount,_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String displayName,  String? color,  int position,  int totalCount,  List<ProjectTaskListItemResponse> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse():
return $default(_that.key,_that.displayName,_that.color,_that.position,_that.totalCount,_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String displayName,  String? color,  int position,  int totalCount,  List<ProjectTaskListItemResponse> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse() when $default != null:
return $default(_that.key,_that.displayName,_that.color,_that.position,_that.totalCount,_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskListGroupResponse implements ProjectTaskListGroupResponse {
  const _ProjectTaskListGroupResponse({required this.key, required this.displayName, this.color, required this.position, required this.totalCount, required this.items, this.nextCursor});
  factory _ProjectTaskListGroupResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskListGroupResponseFromJson(json);

@override final  String key;
@override final  String displayName;
@override final  String? color;
@override final  int position;
@override final  int totalCount;
@override final  List<ProjectTaskListItemResponse> items;
@override final  String? nextCursor;

/// Create a copy of ProjectTaskListGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskListGroupResponseCopyWith<_ProjectTaskListGroupResponse> get copyWith => __$ProjectTaskListGroupResponseCopyWithImpl<_ProjectTaskListGroupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskListGroupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskListGroupResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,displayName,color,position,totalCount,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'ProjectTaskListGroupResponse(key: $key, displayName: $displayName, color: $color, position: $position, totalCount: $totalCount, items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskListGroupResponseCopyWith<$Res> implements $ProjectTaskListGroupResponseCopyWith<$Res> {
  factory _$ProjectTaskListGroupResponseCopyWith(_ProjectTaskListGroupResponse value, $Res Function(_ProjectTaskListGroupResponse) _then) = __$ProjectTaskListGroupResponseCopyWithImpl;
@override @useResult
$Res call({
 String key, String displayName, String? color, int position, int totalCount, List<ProjectTaskListItemResponse> items, String? nextCursor
});




}
/// @nodoc
class __$ProjectTaskListGroupResponseCopyWithImpl<$Res>
    implements _$ProjectTaskListGroupResponseCopyWith<$Res> {
  __$ProjectTaskListGroupResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskListGroupResponse _self;
  final $Res Function(_ProjectTaskListGroupResponse) _then;

/// Create a copy of ProjectTaskListGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? displayName = null,Object? color = freezed,Object? position = null,Object? totalCount = null,Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_ProjectTaskListGroupResponse(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskListItemResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskGroupedListResponse {

 int get totalCount; TaskSavedViewGroupBy get groupBy; List<ProjectTaskListGroupResponse> get groups;
/// Create a copy of ProjectTaskGroupedListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskGroupedListResponseCopyWith<ProjectTaskGroupedListResponse> get copyWith => _$ProjectTaskGroupedListResponseCopyWithImpl<ProjectTaskGroupedListResponse>(this as ProjectTaskGroupedListResponse, _$identity);

  /// Serializes this ProjectTaskGroupedListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskGroupedListResponse&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.groupBy, groupBy) || other.groupBy == groupBy)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCount,groupBy,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'ProjectTaskGroupedListResponse(totalCount: $totalCount, groupBy: $groupBy, groups: $groups)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskGroupedListResponseCopyWith<$Res>  {
  factory $ProjectTaskGroupedListResponseCopyWith(ProjectTaskGroupedListResponse value, $Res Function(ProjectTaskGroupedListResponse) _then) = _$ProjectTaskGroupedListResponseCopyWithImpl;
@useResult
$Res call({
 int totalCount, TaskSavedViewGroupBy groupBy, List<ProjectTaskListGroupResponse> groups
});




}
/// @nodoc
class _$ProjectTaskGroupedListResponseCopyWithImpl<$Res>
    implements $ProjectTaskGroupedListResponseCopyWith<$Res> {
  _$ProjectTaskGroupedListResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskGroupedListResponse _self;
  final $Res Function(ProjectTaskGroupedListResponse) _then;

/// Create a copy of ProjectTaskGroupedListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCount = null,Object? groupBy = null,Object? groups = null,}) {
  return _then(_self.copyWith(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,groupBy: null == groupBy ? _self.groupBy : groupBy // ignore: cast_nullable_to_non_nullable
as TaskSavedViewGroupBy,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskListGroupResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskGroupedListResponse].
extension ProjectTaskGroupedListResponsePatterns on ProjectTaskGroupedListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskGroupedListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskGroupedListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskGroupedListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCount,  TaskSavedViewGroupBy groupBy,  List<ProjectTaskListGroupResponse> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse() when $default != null:
return $default(_that.totalCount,_that.groupBy,_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCount,  TaskSavedViewGroupBy groupBy,  List<ProjectTaskListGroupResponse> groups)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse():
return $default(_that.totalCount,_that.groupBy,_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCount,  TaskSavedViewGroupBy groupBy,  List<ProjectTaskListGroupResponse> groups)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse() when $default != null:
return $default(_that.totalCount,_that.groupBy,_that.groups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskGroupedListResponse implements ProjectTaskGroupedListResponse {
  const _ProjectTaskGroupedListResponse({required this.totalCount, required this.groupBy, required this.groups});
  factory _ProjectTaskGroupedListResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskGroupedListResponseFromJson(json);

@override final  int totalCount;
@override final  TaskSavedViewGroupBy groupBy;
@override final  List<ProjectTaskListGroupResponse> groups;

/// Create a copy of ProjectTaskGroupedListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskGroupedListResponseCopyWith<_ProjectTaskGroupedListResponse> get copyWith => __$ProjectTaskGroupedListResponseCopyWithImpl<_ProjectTaskGroupedListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskGroupedListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskGroupedListResponse&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.groupBy, groupBy) || other.groupBy == groupBy)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCount,groupBy,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'ProjectTaskGroupedListResponse(totalCount: $totalCount, groupBy: $groupBy, groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskGroupedListResponseCopyWith<$Res> implements $ProjectTaskGroupedListResponseCopyWith<$Res> {
  factory _$ProjectTaskGroupedListResponseCopyWith(_ProjectTaskGroupedListResponse value, $Res Function(_ProjectTaskGroupedListResponse) _then) = __$ProjectTaskGroupedListResponseCopyWithImpl;
@override @useResult
$Res call({
 int totalCount, TaskSavedViewGroupBy groupBy, List<ProjectTaskListGroupResponse> groups
});




}
/// @nodoc
class __$ProjectTaskGroupedListResponseCopyWithImpl<$Res>
    implements _$ProjectTaskGroupedListResponseCopyWith<$Res> {
  __$ProjectTaskGroupedListResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskGroupedListResponse _self;
  final $Res Function(_ProjectTaskGroupedListResponse) _then;

/// Create a copy of ProjectTaskGroupedListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCount = null,Object? groupBy = null,Object? groups = null,}) {
  return _then(_ProjectTaskGroupedListResponse(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,groupBy: null == groupBy ? _self.groupBy : groupBy // ignore: cast_nullable_to_non_nullable
as TaskSavedViewGroupBy,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskListGroupResponse>,
  ));
}


}


/// @nodoc
mixin _$CreateTaskSelectionTokenPayload {

 TaskSelectionQueryPayload get query;
/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskSelectionTokenPayloadCopyWith<CreateTaskSelectionTokenPayload> get copyWith => _$CreateTaskSelectionTokenPayloadCopyWithImpl<CreateTaskSelectionTokenPayload>(this as CreateTaskSelectionTokenPayload, _$identity);

  /// Serializes this CreateTaskSelectionTokenPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskSelectionTokenPayload&&(identical(other.query, query) || other.query == query));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'CreateTaskSelectionTokenPayload(query: $query)';
}


}

/// @nodoc
abstract mixin class $CreateTaskSelectionTokenPayloadCopyWith<$Res>  {
  factory $CreateTaskSelectionTokenPayloadCopyWith(CreateTaskSelectionTokenPayload value, $Res Function(CreateTaskSelectionTokenPayload) _then) = _$CreateTaskSelectionTokenPayloadCopyWithImpl;
@useResult
$Res call({
 TaskSelectionQueryPayload query
});


$TaskSelectionQueryPayloadCopyWith<$Res> get query;

}
/// @nodoc
class _$CreateTaskSelectionTokenPayloadCopyWithImpl<$Res>
    implements $CreateTaskSelectionTokenPayloadCopyWith<$Res> {
  _$CreateTaskSelectionTokenPayloadCopyWithImpl(this._self, this._then);

  final CreateTaskSelectionTokenPayload _self;
  final $Res Function(CreateTaskSelectionTokenPayload) _then;

/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as TaskSelectionQueryPayload,
  ));
}
/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSelectionQueryPayloadCopyWith<$Res> get query {
  
  return $TaskSelectionQueryPayloadCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateTaskSelectionTokenPayload].
extension CreateTaskSelectionTokenPayloadPatterns on CreateTaskSelectionTokenPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskSelectionTokenPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskSelectionTokenPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskSelectionTokenPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskSelectionQueryPayload query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload() when $default != null:
return $default(_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskSelectionQueryPayload query)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload():
return $default(_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskSelectionQueryPayload query)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload() when $default != null:
return $default(_that.query);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskSelectionTokenPayload implements CreateTaskSelectionTokenPayload {
  const _CreateTaskSelectionTokenPayload({required this.query});
  factory _CreateTaskSelectionTokenPayload.fromJson(Map<String, dynamic> json) => _$CreateTaskSelectionTokenPayloadFromJson(json);

@override final  TaskSelectionQueryPayload query;

/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskSelectionTokenPayloadCopyWith<_CreateTaskSelectionTokenPayload> get copyWith => __$CreateTaskSelectionTokenPayloadCopyWithImpl<_CreateTaskSelectionTokenPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskSelectionTokenPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskSelectionTokenPayload&&(identical(other.query, query) || other.query == query));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'CreateTaskSelectionTokenPayload(query: $query)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskSelectionTokenPayloadCopyWith<$Res> implements $CreateTaskSelectionTokenPayloadCopyWith<$Res> {
  factory _$CreateTaskSelectionTokenPayloadCopyWith(_CreateTaskSelectionTokenPayload value, $Res Function(_CreateTaskSelectionTokenPayload) _then) = __$CreateTaskSelectionTokenPayloadCopyWithImpl;
@override @useResult
$Res call({
 TaskSelectionQueryPayload query
});


@override $TaskSelectionQueryPayloadCopyWith<$Res> get query;

}
/// @nodoc
class __$CreateTaskSelectionTokenPayloadCopyWithImpl<$Res>
    implements _$CreateTaskSelectionTokenPayloadCopyWith<$Res> {
  __$CreateTaskSelectionTokenPayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskSelectionTokenPayload _self;
  final $Res Function(_CreateTaskSelectionTokenPayload) _then;

/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_CreateTaskSelectionTokenPayload(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as TaskSelectionQueryPayload,
  ));
}

/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSelectionQueryPayloadCopyWith<$Res> get query {
  
  return $TaskSelectionQueryPayloadCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}


/// @nodoc
mixin _$TaskSelectionQueryPayload {

 String? get savedViewId; String? get status; String? get priority; String? get assigneeCoreUserId; String? get myInvolvement; String? get search; DateTime? get dueFromUtc; DateTime? get dueToUtc; bool get includeArchived; bool get pinnedOnly; bool get unassignedOnly;
/// Create a copy of TaskSelectionQueryPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSelectionQueryPayloadCopyWith<TaskSelectionQueryPayload> get copyWith => _$TaskSelectionQueryPayloadCopyWithImpl<TaskSelectionQueryPayload>(this as TaskSelectionQueryPayload, _$identity);

  /// Serializes this TaskSelectionQueryPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSelectionQueryPayload&&(identical(other.savedViewId, savedViewId) || other.savedViewId == savedViewId)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assigneeCoreUserId, assigneeCoreUserId) || other.assigneeCoreUserId == assigneeCoreUserId)&&(identical(other.myInvolvement, myInvolvement) || other.myInvolvement == myInvolvement)&&(identical(other.search, search) || other.search == search)&&(identical(other.dueFromUtc, dueFromUtc) || other.dueFromUtc == dueFromUtc)&&(identical(other.dueToUtc, dueToUtc) || other.dueToUtc == dueToUtc)&&(identical(other.includeArchived, includeArchived) || other.includeArchived == includeArchived)&&(identical(other.pinnedOnly, pinnedOnly) || other.pinnedOnly == pinnedOnly)&&(identical(other.unassignedOnly, unassignedOnly) || other.unassignedOnly == unassignedOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,savedViewId,status,priority,assigneeCoreUserId,myInvolvement,search,dueFromUtc,dueToUtc,includeArchived,pinnedOnly,unassignedOnly);

@override
String toString() {
  return 'TaskSelectionQueryPayload(savedViewId: $savedViewId, status: $status, priority: $priority, assigneeCoreUserId: $assigneeCoreUserId, myInvolvement: $myInvolvement, search: $search, dueFromUtc: $dueFromUtc, dueToUtc: $dueToUtc, includeArchived: $includeArchived, pinnedOnly: $pinnedOnly, unassignedOnly: $unassignedOnly)';
}


}

/// @nodoc
abstract mixin class $TaskSelectionQueryPayloadCopyWith<$Res>  {
  factory $TaskSelectionQueryPayloadCopyWith(TaskSelectionQueryPayload value, $Res Function(TaskSelectionQueryPayload) _then) = _$TaskSelectionQueryPayloadCopyWithImpl;
@useResult
$Res call({
 String? savedViewId, String? status, String? priority, String? assigneeCoreUserId, String? myInvolvement, String? search, DateTime? dueFromUtc, DateTime? dueToUtc, bool includeArchived, bool pinnedOnly, bool unassignedOnly
});




}
/// @nodoc
class _$TaskSelectionQueryPayloadCopyWithImpl<$Res>
    implements $TaskSelectionQueryPayloadCopyWith<$Res> {
  _$TaskSelectionQueryPayloadCopyWithImpl(this._self, this._then);

  final TaskSelectionQueryPayload _self;
  final $Res Function(TaskSelectionQueryPayload) _then;

/// Create a copy of TaskSelectionQueryPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? savedViewId = freezed,Object? status = freezed,Object? priority = freezed,Object? assigneeCoreUserId = freezed,Object? myInvolvement = freezed,Object? search = freezed,Object? dueFromUtc = freezed,Object? dueToUtc = freezed,Object? includeArchived = null,Object? pinnedOnly = null,Object? unassignedOnly = null,}) {
  return _then(_self.copyWith(
savedViewId: freezed == savedViewId ? _self.savedViewId : savedViewId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,assigneeCoreUserId: freezed == assigneeCoreUserId ? _self.assigneeCoreUserId : assigneeCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,myInvolvement: freezed == myInvolvement ? _self.myInvolvement : myInvolvement // ignore: cast_nullable_to_non_nullable
as String?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,dueFromUtc: freezed == dueFromUtc ? _self.dueFromUtc : dueFromUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueToUtc: freezed == dueToUtc ? _self.dueToUtc : dueToUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,includeArchived: null == includeArchived ? _self.includeArchived : includeArchived // ignore: cast_nullable_to_non_nullable
as bool,pinnedOnly: null == pinnedOnly ? _self.pinnedOnly : pinnedOnly // ignore: cast_nullable_to_non_nullable
as bool,unassignedOnly: null == unassignedOnly ? _self.unassignedOnly : unassignedOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskSelectionQueryPayload].
extension TaskSelectionQueryPayloadPatterns on TaskSelectionQueryPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSelectionQueryPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSelectionQueryPayload value)  $default,){
final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSelectionQueryPayload value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? savedViewId,  String? status,  String? priority,  String? assigneeCoreUserId,  String? myInvolvement,  String? search,  DateTime? dueFromUtc,  DateTime? dueToUtc,  bool includeArchived,  bool pinnedOnly,  bool unassignedOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload() when $default != null:
return $default(_that.savedViewId,_that.status,_that.priority,_that.assigneeCoreUserId,_that.myInvolvement,_that.search,_that.dueFromUtc,_that.dueToUtc,_that.includeArchived,_that.pinnedOnly,_that.unassignedOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? savedViewId,  String? status,  String? priority,  String? assigneeCoreUserId,  String? myInvolvement,  String? search,  DateTime? dueFromUtc,  DateTime? dueToUtc,  bool includeArchived,  bool pinnedOnly,  bool unassignedOnly)  $default,) {final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload():
return $default(_that.savedViewId,_that.status,_that.priority,_that.assigneeCoreUserId,_that.myInvolvement,_that.search,_that.dueFromUtc,_that.dueToUtc,_that.includeArchived,_that.pinnedOnly,_that.unassignedOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? savedViewId,  String? status,  String? priority,  String? assigneeCoreUserId,  String? myInvolvement,  String? search,  DateTime? dueFromUtc,  DateTime? dueToUtc,  bool includeArchived,  bool pinnedOnly,  bool unassignedOnly)?  $default,) {final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload() when $default != null:
return $default(_that.savedViewId,_that.status,_that.priority,_that.assigneeCoreUserId,_that.myInvolvement,_that.search,_that.dueFromUtc,_that.dueToUtc,_that.includeArchived,_that.pinnedOnly,_that.unassignedOnly);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSelectionQueryPayload implements TaskSelectionQueryPayload {
  const _TaskSelectionQueryPayload({this.savedViewId, this.status, this.priority, this.assigneeCoreUserId, this.myInvolvement, this.search, this.dueFromUtc, this.dueToUtc, this.includeArchived = false, this.pinnedOnly = false, this.unassignedOnly = false});
  factory _TaskSelectionQueryPayload.fromJson(Map<String, dynamic> json) => _$TaskSelectionQueryPayloadFromJson(json);

@override final  String? savedViewId;
@override final  String? status;
@override final  String? priority;
@override final  String? assigneeCoreUserId;
@override final  String? myInvolvement;
@override final  String? search;
@override final  DateTime? dueFromUtc;
@override final  DateTime? dueToUtc;
@override@JsonKey() final  bool includeArchived;
@override@JsonKey() final  bool pinnedOnly;
@override@JsonKey() final  bool unassignedOnly;

/// Create a copy of TaskSelectionQueryPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSelectionQueryPayloadCopyWith<_TaskSelectionQueryPayload> get copyWith => __$TaskSelectionQueryPayloadCopyWithImpl<_TaskSelectionQueryPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSelectionQueryPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSelectionQueryPayload&&(identical(other.savedViewId, savedViewId) || other.savedViewId == savedViewId)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assigneeCoreUserId, assigneeCoreUserId) || other.assigneeCoreUserId == assigneeCoreUserId)&&(identical(other.myInvolvement, myInvolvement) || other.myInvolvement == myInvolvement)&&(identical(other.search, search) || other.search == search)&&(identical(other.dueFromUtc, dueFromUtc) || other.dueFromUtc == dueFromUtc)&&(identical(other.dueToUtc, dueToUtc) || other.dueToUtc == dueToUtc)&&(identical(other.includeArchived, includeArchived) || other.includeArchived == includeArchived)&&(identical(other.pinnedOnly, pinnedOnly) || other.pinnedOnly == pinnedOnly)&&(identical(other.unassignedOnly, unassignedOnly) || other.unassignedOnly == unassignedOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,savedViewId,status,priority,assigneeCoreUserId,myInvolvement,search,dueFromUtc,dueToUtc,includeArchived,pinnedOnly,unassignedOnly);

@override
String toString() {
  return 'TaskSelectionQueryPayload(savedViewId: $savedViewId, status: $status, priority: $priority, assigneeCoreUserId: $assigneeCoreUserId, myInvolvement: $myInvolvement, search: $search, dueFromUtc: $dueFromUtc, dueToUtc: $dueToUtc, includeArchived: $includeArchived, pinnedOnly: $pinnedOnly, unassignedOnly: $unassignedOnly)';
}


}

/// @nodoc
abstract mixin class _$TaskSelectionQueryPayloadCopyWith<$Res> implements $TaskSelectionQueryPayloadCopyWith<$Res> {
  factory _$TaskSelectionQueryPayloadCopyWith(_TaskSelectionQueryPayload value, $Res Function(_TaskSelectionQueryPayload) _then) = __$TaskSelectionQueryPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? savedViewId, String? status, String? priority, String? assigneeCoreUserId, String? myInvolvement, String? search, DateTime? dueFromUtc, DateTime? dueToUtc, bool includeArchived, bool pinnedOnly, bool unassignedOnly
});




}
/// @nodoc
class __$TaskSelectionQueryPayloadCopyWithImpl<$Res>
    implements _$TaskSelectionQueryPayloadCopyWith<$Res> {
  __$TaskSelectionQueryPayloadCopyWithImpl(this._self, this._then);

  final _TaskSelectionQueryPayload _self;
  final $Res Function(_TaskSelectionQueryPayload) _then;

/// Create a copy of TaskSelectionQueryPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? savedViewId = freezed,Object? status = freezed,Object? priority = freezed,Object? assigneeCoreUserId = freezed,Object? myInvolvement = freezed,Object? search = freezed,Object? dueFromUtc = freezed,Object? dueToUtc = freezed,Object? includeArchived = null,Object? pinnedOnly = null,Object? unassignedOnly = null,}) {
  return _then(_TaskSelectionQueryPayload(
savedViewId: freezed == savedViewId ? _self.savedViewId : savedViewId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,assigneeCoreUserId: freezed == assigneeCoreUserId ? _self.assigneeCoreUserId : assigneeCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,myInvolvement: freezed == myInvolvement ? _self.myInvolvement : myInvolvement // ignore: cast_nullable_to_non_nullable
as String?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,dueFromUtc: freezed == dueFromUtc ? _self.dueFromUtc : dueFromUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueToUtc: freezed == dueToUtc ? _self.dueToUtc : dueToUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,includeArchived: null == includeArchived ? _self.includeArchived : includeArchived // ignore: cast_nullable_to_non_nullable
as bool,pinnedOnly: null == pinnedOnly ? _self.pinnedOnly : pinnedOnly // ignore: cast_nullable_to_non_nullable
as bool,unassignedOnly: null == unassignedOnly ? _self.unassignedOnly : unassignedOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TaskSelectionTokenResponse {

 String get token; int get totalCount; DateTime get expiresAtUtc;
/// Create a copy of TaskSelectionTokenResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSelectionTokenResponseCopyWith<TaskSelectionTokenResponse> get copyWith => _$TaskSelectionTokenResponseCopyWithImpl<TaskSelectionTokenResponse>(this as TaskSelectionTokenResponse, _$identity);

  /// Serializes this TaskSelectionTokenResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSelectionTokenResponse&&(identical(other.token, token) || other.token == token)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,totalCount,expiresAtUtc);

@override
String toString() {
  return 'TaskSelectionTokenResponse(token: $token, totalCount: $totalCount, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskSelectionTokenResponseCopyWith<$Res>  {
  factory $TaskSelectionTokenResponseCopyWith(TaskSelectionTokenResponse value, $Res Function(TaskSelectionTokenResponse) _then) = _$TaskSelectionTokenResponseCopyWithImpl;
@useResult
$Res call({
 String token, int totalCount, DateTime expiresAtUtc
});




}
/// @nodoc
class _$TaskSelectionTokenResponseCopyWithImpl<$Res>
    implements $TaskSelectionTokenResponseCopyWith<$Res> {
  _$TaskSelectionTokenResponseCopyWithImpl(this._self, this._then);

  final TaskSelectionTokenResponse _self;
  final $Res Function(TaskSelectionTokenResponse) _then;

/// Create a copy of TaskSelectionTokenResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? totalCount = null,Object? expiresAtUtc = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskSelectionTokenResponse].
extension TaskSelectionTokenResponsePatterns on TaskSelectionTokenResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSelectionTokenResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSelectionTokenResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSelectionTokenResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  int totalCount,  DateTime expiresAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse() when $default != null:
return $default(_that.token,_that.totalCount,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  int totalCount,  DateTime expiresAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse():
return $default(_that.token,_that.totalCount,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  int totalCount,  DateTime expiresAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse() when $default != null:
return $default(_that.token,_that.totalCount,_that.expiresAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSelectionTokenResponse implements TaskSelectionTokenResponse {
  const _TaskSelectionTokenResponse({required this.token, required this.totalCount, required this.expiresAtUtc});
  factory _TaskSelectionTokenResponse.fromJson(Map<String, dynamic> json) => _$TaskSelectionTokenResponseFromJson(json);

@override final  String token;
@override final  int totalCount;
@override final  DateTime expiresAtUtc;

/// Create a copy of TaskSelectionTokenResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSelectionTokenResponseCopyWith<_TaskSelectionTokenResponse> get copyWith => __$TaskSelectionTokenResponseCopyWithImpl<_TaskSelectionTokenResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSelectionTokenResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSelectionTokenResponse&&(identical(other.token, token) || other.token == token)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,totalCount,expiresAtUtc);

@override
String toString() {
  return 'TaskSelectionTokenResponse(token: $token, totalCount: $totalCount, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskSelectionTokenResponseCopyWith<$Res> implements $TaskSelectionTokenResponseCopyWith<$Res> {
  factory _$TaskSelectionTokenResponseCopyWith(_TaskSelectionTokenResponse value, $Res Function(_TaskSelectionTokenResponse) _then) = __$TaskSelectionTokenResponseCopyWithImpl;
@override @useResult
$Res call({
 String token, int totalCount, DateTime expiresAtUtc
});




}
/// @nodoc
class __$TaskSelectionTokenResponseCopyWithImpl<$Res>
    implements _$TaskSelectionTokenResponseCopyWith<$Res> {
  __$TaskSelectionTokenResponseCopyWithImpl(this._self, this._then);

  final _TaskSelectionTokenResponse _self;
  final $Res Function(_TaskSelectionTokenResponse) _then;

/// Create a copy of TaskSelectionTokenResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? totalCount = null,Object? expiresAtUtc = null,}) {
  return _then(_TaskSelectionTokenResponse(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$BulkUpdateTaskSelectionPayload {

 String get selectionToken; ProjectTaskStatus? get status; String? get customStatusId; bool get clearCustomStatus; TaskPriority? get priority; DateTime? get dueAtUtc; bool get clearDueAtUtc; List<String>? get assigneeIds; bool get archive; List<String> get returnTaskIds;
/// Create a copy of BulkUpdateTaskSelectionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkUpdateTaskSelectionPayloadCopyWith<BulkUpdateTaskSelectionPayload> get copyWith => _$BulkUpdateTaskSelectionPayloadCopyWithImpl<BulkUpdateTaskSelectionPayload>(this as BulkUpdateTaskSelectionPayload, _$identity);

  /// Serializes this BulkUpdateTaskSelectionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkUpdateTaskSelectionPayload&&(identical(other.selectionToken, selectionToken) || other.selectionToken == selectionToken)&&(identical(other.status, status) || other.status == status)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.clearCustomStatus, clearCustomStatus) || other.clearCustomStatus == clearCustomStatus)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.clearDueAtUtc, clearDueAtUtc) || other.clearDueAtUtc == clearDueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeIds, assigneeIds)&&(identical(other.archive, archive) || other.archive == archive)&&const DeepCollectionEquality().equals(other.returnTaskIds, returnTaskIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectionToken,status,customStatusId,clearCustomStatus,priority,dueAtUtc,clearDueAtUtc,const DeepCollectionEquality().hash(assigneeIds),archive,const DeepCollectionEquality().hash(returnTaskIds));

@override
String toString() {
  return 'BulkUpdateTaskSelectionPayload(selectionToken: $selectionToken, status: $status, customStatusId: $customStatusId, clearCustomStatus: $clearCustomStatus, priority: $priority, dueAtUtc: $dueAtUtc, clearDueAtUtc: $clearDueAtUtc, assigneeIds: $assigneeIds, archive: $archive, returnTaskIds: $returnTaskIds)';
}


}

/// @nodoc
abstract mixin class $BulkUpdateTaskSelectionPayloadCopyWith<$Res>  {
  factory $BulkUpdateTaskSelectionPayloadCopyWith(BulkUpdateTaskSelectionPayload value, $Res Function(BulkUpdateTaskSelectionPayload) _then) = _$BulkUpdateTaskSelectionPayloadCopyWithImpl;
@useResult
$Res call({
 String selectionToken, ProjectTaskStatus? status, String? customStatusId, bool clearCustomStatus, TaskPriority? priority, DateTime? dueAtUtc, bool clearDueAtUtc, List<String>? assigneeIds, bool archive, List<String> returnTaskIds
});




}
/// @nodoc
class _$BulkUpdateTaskSelectionPayloadCopyWithImpl<$Res>
    implements $BulkUpdateTaskSelectionPayloadCopyWith<$Res> {
  _$BulkUpdateTaskSelectionPayloadCopyWithImpl(this._self, this._then);

  final BulkUpdateTaskSelectionPayload _self;
  final $Res Function(BulkUpdateTaskSelectionPayload) _then;

/// Create a copy of BulkUpdateTaskSelectionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectionToken = null,Object? status = freezed,Object? customStatusId = freezed,Object? clearCustomStatus = null,Object? priority = freezed,Object? dueAtUtc = freezed,Object? clearDueAtUtc = null,Object? assigneeIds = freezed,Object? archive = null,Object? returnTaskIds = null,}) {
  return _then(_self.copyWith(
selectionToken: null == selectionToken ? _self.selectionToken : selectionToken // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,clearCustomStatus: null == clearCustomStatus ? _self.clearCustomStatus : clearCustomStatus // ignore: cast_nullable_to_non_nullable
as bool,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,clearDueAtUtc: null == clearDueAtUtc ? _self.clearDueAtUtc : clearDueAtUtc // ignore: cast_nullable_to_non_nullable
as bool,assigneeIds: freezed == assigneeIds ? _self.assigneeIds : assigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>?,archive: null == archive ? _self.archive : archive // ignore: cast_nullable_to_non_nullable
as bool,returnTaskIds: null == returnTaskIds ? _self.returnTaskIds : returnTaskIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkUpdateTaskSelectionPayload].
extension BulkUpdateTaskSelectionPayloadPatterns on BulkUpdateTaskSelectionPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkUpdateTaskSelectionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkUpdateTaskSelectionPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkUpdateTaskSelectionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String selectionToken,  ProjectTaskStatus? status,  String? customStatusId,  bool clearCustomStatus,  TaskPriority? priority,  DateTime? dueAtUtc,  bool clearDueAtUtc,  List<String>? assigneeIds,  bool archive,  List<String> returnTaskIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload() when $default != null:
return $default(_that.selectionToken,_that.status,_that.customStatusId,_that.clearCustomStatus,_that.priority,_that.dueAtUtc,_that.clearDueAtUtc,_that.assigneeIds,_that.archive,_that.returnTaskIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String selectionToken,  ProjectTaskStatus? status,  String? customStatusId,  bool clearCustomStatus,  TaskPriority? priority,  DateTime? dueAtUtc,  bool clearDueAtUtc,  List<String>? assigneeIds,  bool archive,  List<String> returnTaskIds)  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload():
return $default(_that.selectionToken,_that.status,_that.customStatusId,_that.clearCustomStatus,_that.priority,_that.dueAtUtc,_that.clearDueAtUtc,_that.assigneeIds,_that.archive,_that.returnTaskIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String selectionToken,  ProjectTaskStatus? status,  String? customStatusId,  bool clearCustomStatus,  TaskPriority? priority,  DateTime? dueAtUtc,  bool clearDueAtUtc,  List<String>? assigneeIds,  bool archive,  List<String> returnTaskIds)?  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload() when $default != null:
return $default(_that.selectionToken,_that.status,_that.customStatusId,_that.clearCustomStatus,_that.priority,_that.dueAtUtc,_that.clearDueAtUtc,_that.assigneeIds,_that.archive,_that.returnTaskIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkUpdateTaskSelectionPayload implements BulkUpdateTaskSelectionPayload {
  const _BulkUpdateTaskSelectionPayload({required this.selectionToken, this.status, this.customStatusId, this.clearCustomStatus = false, this.priority, this.dueAtUtc, this.clearDueAtUtc = false, this.assigneeIds, this.archive = false, this.returnTaskIds = const <String>[]});
  factory _BulkUpdateTaskSelectionPayload.fromJson(Map<String, dynamic> json) => _$BulkUpdateTaskSelectionPayloadFromJson(json);

@override final  String selectionToken;
@override final  ProjectTaskStatus? status;
@override final  String? customStatusId;
@override@JsonKey() final  bool clearCustomStatus;
@override final  TaskPriority? priority;
@override final  DateTime? dueAtUtc;
@override@JsonKey() final  bool clearDueAtUtc;
@override final  List<String>? assigneeIds;
@override@JsonKey() final  bool archive;
@override@JsonKey() final  List<String> returnTaskIds;

/// Create a copy of BulkUpdateTaskSelectionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkUpdateTaskSelectionPayloadCopyWith<_BulkUpdateTaskSelectionPayload> get copyWith => __$BulkUpdateTaskSelectionPayloadCopyWithImpl<_BulkUpdateTaskSelectionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkUpdateTaskSelectionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkUpdateTaskSelectionPayload&&(identical(other.selectionToken, selectionToken) || other.selectionToken == selectionToken)&&(identical(other.status, status) || other.status == status)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.clearCustomStatus, clearCustomStatus) || other.clearCustomStatus == clearCustomStatus)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.clearDueAtUtc, clearDueAtUtc) || other.clearDueAtUtc == clearDueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeIds, assigneeIds)&&(identical(other.archive, archive) || other.archive == archive)&&const DeepCollectionEquality().equals(other.returnTaskIds, returnTaskIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectionToken,status,customStatusId,clearCustomStatus,priority,dueAtUtc,clearDueAtUtc,const DeepCollectionEquality().hash(assigneeIds),archive,const DeepCollectionEquality().hash(returnTaskIds));

@override
String toString() {
  return 'BulkUpdateTaskSelectionPayload(selectionToken: $selectionToken, status: $status, customStatusId: $customStatusId, clearCustomStatus: $clearCustomStatus, priority: $priority, dueAtUtc: $dueAtUtc, clearDueAtUtc: $clearDueAtUtc, assigneeIds: $assigneeIds, archive: $archive, returnTaskIds: $returnTaskIds)';
}


}

/// @nodoc
abstract mixin class _$BulkUpdateTaskSelectionPayloadCopyWith<$Res> implements $BulkUpdateTaskSelectionPayloadCopyWith<$Res> {
  factory _$BulkUpdateTaskSelectionPayloadCopyWith(_BulkUpdateTaskSelectionPayload value, $Res Function(_BulkUpdateTaskSelectionPayload) _then) = __$BulkUpdateTaskSelectionPayloadCopyWithImpl;
@override @useResult
$Res call({
 String selectionToken, ProjectTaskStatus? status, String? customStatusId, bool clearCustomStatus, TaskPriority? priority, DateTime? dueAtUtc, bool clearDueAtUtc, List<String>? assigneeIds, bool archive, List<String> returnTaskIds
});




}
/// @nodoc
class __$BulkUpdateTaskSelectionPayloadCopyWithImpl<$Res>
    implements _$BulkUpdateTaskSelectionPayloadCopyWith<$Res> {
  __$BulkUpdateTaskSelectionPayloadCopyWithImpl(this._self, this._then);

  final _BulkUpdateTaskSelectionPayload _self;
  final $Res Function(_BulkUpdateTaskSelectionPayload) _then;

/// Create a copy of BulkUpdateTaskSelectionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectionToken = null,Object? status = freezed,Object? customStatusId = freezed,Object? clearCustomStatus = null,Object? priority = freezed,Object? dueAtUtc = freezed,Object? clearDueAtUtc = null,Object? assigneeIds = freezed,Object? archive = null,Object? returnTaskIds = null,}) {
  return _then(_BulkUpdateTaskSelectionPayload(
selectionToken: null == selectionToken ? _self.selectionToken : selectionToken // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,clearCustomStatus: null == clearCustomStatus ? _self.clearCustomStatus : clearCustomStatus // ignore: cast_nullable_to_non_nullable
as bool,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,clearDueAtUtc: null == clearDueAtUtc ? _self.clearDueAtUtc : clearDueAtUtc // ignore: cast_nullable_to_non_nullable
as bool,assigneeIds: freezed == assigneeIds ? _self.assigneeIds : assigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>?,archive: null == archive ? _self.archive : archive // ignore: cast_nullable_to_non_nullable
as bool,returnTaskIds: null == returnTaskIds ? _self.returnTaskIds : returnTaskIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$BulkUpdateTaskSelectionResponse {

 int get updatedCount; List<BulkUpdatedTaskVersionResponse> get updatedTasks;
/// Create a copy of BulkUpdateTaskSelectionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkUpdateTaskSelectionResponseCopyWith<BulkUpdateTaskSelectionResponse> get copyWith => _$BulkUpdateTaskSelectionResponseCopyWithImpl<BulkUpdateTaskSelectionResponse>(this as BulkUpdateTaskSelectionResponse, _$identity);

  /// Serializes this BulkUpdateTaskSelectionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkUpdateTaskSelectionResponse&&(identical(other.updatedCount, updatedCount) || other.updatedCount == updatedCount)&&const DeepCollectionEquality().equals(other.updatedTasks, updatedTasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updatedCount,const DeepCollectionEquality().hash(updatedTasks));

@override
String toString() {
  return 'BulkUpdateTaskSelectionResponse(updatedCount: $updatedCount, updatedTasks: $updatedTasks)';
}


}

/// @nodoc
abstract mixin class $BulkUpdateTaskSelectionResponseCopyWith<$Res>  {
  factory $BulkUpdateTaskSelectionResponseCopyWith(BulkUpdateTaskSelectionResponse value, $Res Function(BulkUpdateTaskSelectionResponse) _then) = _$BulkUpdateTaskSelectionResponseCopyWithImpl;
@useResult
$Res call({
 int updatedCount, List<BulkUpdatedTaskVersionResponse> updatedTasks
});




}
/// @nodoc
class _$BulkUpdateTaskSelectionResponseCopyWithImpl<$Res>
    implements $BulkUpdateTaskSelectionResponseCopyWith<$Res> {
  _$BulkUpdateTaskSelectionResponseCopyWithImpl(this._self, this._then);

  final BulkUpdateTaskSelectionResponse _self;
  final $Res Function(BulkUpdateTaskSelectionResponse) _then;

/// Create a copy of BulkUpdateTaskSelectionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? updatedCount = null,Object? updatedTasks = null,}) {
  return _then(_self.copyWith(
updatedCount: null == updatedCount ? _self.updatedCount : updatedCount // ignore: cast_nullable_to_non_nullable
as int,updatedTasks: null == updatedTasks ? _self.updatedTasks : updatedTasks // ignore: cast_nullable_to_non_nullable
as List<BulkUpdatedTaskVersionResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkUpdateTaskSelectionResponse].
extension BulkUpdateTaskSelectionResponsePatterns on BulkUpdateTaskSelectionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkUpdateTaskSelectionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkUpdateTaskSelectionResponse value)  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkUpdateTaskSelectionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int updatedCount,  List<BulkUpdatedTaskVersionResponse> updatedTasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse() when $default != null:
return $default(_that.updatedCount,_that.updatedTasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int updatedCount,  List<BulkUpdatedTaskVersionResponse> updatedTasks)  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse():
return $default(_that.updatedCount,_that.updatedTasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int updatedCount,  List<BulkUpdatedTaskVersionResponse> updatedTasks)?  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse() when $default != null:
return $default(_that.updatedCount,_that.updatedTasks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkUpdateTaskSelectionResponse implements BulkUpdateTaskSelectionResponse {
  const _BulkUpdateTaskSelectionResponse({required this.updatedCount, this.updatedTasks = const <BulkUpdatedTaskVersionResponse>[]});
  factory _BulkUpdateTaskSelectionResponse.fromJson(Map<String, dynamic> json) => _$BulkUpdateTaskSelectionResponseFromJson(json);

@override final  int updatedCount;
@override@JsonKey() final  List<BulkUpdatedTaskVersionResponse> updatedTasks;

/// Create a copy of BulkUpdateTaskSelectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkUpdateTaskSelectionResponseCopyWith<_BulkUpdateTaskSelectionResponse> get copyWith => __$BulkUpdateTaskSelectionResponseCopyWithImpl<_BulkUpdateTaskSelectionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkUpdateTaskSelectionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkUpdateTaskSelectionResponse&&(identical(other.updatedCount, updatedCount) || other.updatedCount == updatedCount)&&const DeepCollectionEquality().equals(other.updatedTasks, updatedTasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updatedCount,const DeepCollectionEquality().hash(updatedTasks));

@override
String toString() {
  return 'BulkUpdateTaskSelectionResponse(updatedCount: $updatedCount, updatedTasks: $updatedTasks)';
}


}

/// @nodoc
abstract mixin class _$BulkUpdateTaskSelectionResponseCopyWith<$Res> implements $BulkUpdateTaskSelectionResponseCopyWith<$Res> {
  factory _$BulkUpdateTaskSelectionResponseCopyWith(_BulkUpdateTaskSelectionResponse value, $Res Function(_BulkUpdateTaskSelectionResponse) _then) = __$BulkUpdateTaskSelectionResponseCopyWithImpl;
@override @useResult
$Res call({
 int updatedCount, List<BulkUpdatedTaskVersionResponse> updatedTasks
});




}
/// @nodoc
class __$BulkUpdateTaskSelectionResponseCopyWithImpl<$Res>
    implements _$BulkUpdateTaskSelectionResponseCopyWith<$Res> {
  __$BulkUpdateTaskSelectionResponseCopyWithImpl(this._self, this._then);

  final _BulkUpdateTaskSelectionResponse _self;
  final $Res Function(_BulkUpdateTaskSelectionResponse) _then;

/// Create a copy of BulkUpdateTaskSelectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? updatedCount = null,Object? updatedTasks = null,}) {
  return _then(_BulkUpdateTaskSelectionResponse(
updatedCount: null == updatedCount ? _self.updatedCount : updatedCount // ignore: cast_nullable_to_non_nullable
as int,updatedTasks: null == updatedTasks ? _self.updatedTasks : updatedTasks // ignore: cast_nullable_to_non_nullable
as List<BulkUpdatedTaskVersionResponse>,
  ));
}


}


/// @nodoc
mixin _$BulkUpdatedTaskVersionResponse {

 String get taskId; int get version; DateTime get updatedAtUtc;
/// Create a copy of BulkUpdatedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkUpdatedTaskVersionResponseCopyWith<BulkUpdatedTaskVersionResponse> get copyWith => _$BulkUpdatedTaskVersionResponseCopyWithImpl<BulkUpdatedTaskVersionResponse>(this as BulkUpdatedTaskVersionResponse, _$identity);

  /// Serializes this BulkUpdatedTaskVersionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkUpdatedTaskVersionResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,version,updatedAtUtc);

@override
String toString() {
  return 'BulkUpdatedTaskVersionResponse(taskId: $taskId, version: $version, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $BulkUpdatedTaskVersionResponseCopyWith<$Res>  {
  factory $BulkUpdatedTaskVersionResponseCopyWith(BulkUpdatedTaskVersionResponse value, $Res Function(BulkUpdatedTaskVersionResponse) _then) = _$BulkUpdatedTaskVersionResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, int version, DateTime updatedAtUtc
});




}
/// @nodoc
class _$BulkUpdatedTaskVersionResponseCopyWithImpl<$Res>
    implements $BulkUpdatedTaskVersionResponseCopyWith<$Res> {
  _$BulkUpdatedTaskVersionResponseCopyWithImpl(this._self, this._then);

  final BulkUpdatedTaskVersionResponse _self;
  final $Res Function(BulkUpdatedTaskVersionResponse) _then;

/// Create a copy of BulkUpdatedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? version = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkUpdatedTaskVersionResponse].
extension BulkUpdatedTaskVersionResponsePatterns on BulkUpdatedTaskVersionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkUpdatedTaskVersionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkUpdatedTaskVersionResponse value)  $default,){
final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkUpdatedTaskVersionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  int version,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse() when $default != null:
return $default(_that.taskId,_that.version,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  int version,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse():
return $default(_that.taskId,_that.version,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  int version,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse() when $default != null:
return $default(_that.taskId,_that.version,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkUpdatedTaskVersionResponse implements BulkUpdatedTaskVersionResponse {
  const _BulkUpdatedTaskVersionResponse({required this.taskId, required this.version, required this.updatedAtUtc});
  factory _BulkUpdatedTaskVersionResponse.fromJson(Map<String, dynamic> json) => _$BulkUpdatedTaskVersionResponseFromJson(json);

@override final  String taskId;
@override final  int version;
@override final  DateTime updatedAtUtc;

/// Create a copy of BulkUpdatedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkUpdatedTaskVersionResponseCopyWith<_BulkUpdatedTaskVersionResponse> get copyWith => __$BulkUpdatedTaskVersionResponseCopyWithImpl<_BulkUpdatedTaskVersionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkUpdatedTaskVersionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkUpdatedTaskVersionResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,version,updatedAtUtc);

@override
String toString() {
  return 'BulkUpdatedTaskVersionResponse(taskId: $taskId, version: $version, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$BulkUpdatedTaskVersionResponseCopyWith<$Res> implements $BulkUpdatedTaskVersionResponseCopyWith<$Res> {
  factory _$BulkUpdatedTaskVersionResponseCopyWith(_BulkUpdatedTaskVersionResponse value, $Res Function(_BulkUpdatedTaskVersionResponse) _then) = __$BulkUpdatedTaskVersionResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, int version, DateTime updatedAtUtc
});




}
/// @nodoc
class __$BulkUpdatedTaskVersionResponseCopyWithImpl<$Res>
    implements _$BulkUpdatedTaskVersionResponseCopyWith<$Res> {
  __$BulkUpdatedTaskVersionResponseCopyWithImpl(this._self, this._then);

  final _BulkUpdatedTaskVersionResponse _self;
  final $Res Function(_BulkUpdatedTaskVersionResponse) _then;

/// Create a copy of BulkUpdatedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? version = null,Object? updatedAtUtc = null,}) {
  return _then(_BulkUpdatedTaskVersionResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskListItemPayload {

 String? get title;@JsonKey(includeIfNull: false) ProjectTaskStatus? get status; TaskPriority? get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; bool get clearStartAtUtc; bool get clearDueAtUtc; String? get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; bool get clearSize; bool get clearComplexity; bool get clearRisk; bool get clearBusinessValue; bool get clearEstimatedMinutes; String? get milestoneId; bool get clearMilestone;@JsonKey(includeIfNull: false) String? get customStatusId; int get expectedVersion;
/// Create a copy of UpdateTaskListItemPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskListItemPayloadCopyWith<UpdateTaskListItemPayload> get copyWith => _$UpdateTaskListItemPayloadCopyWithImpl<UpdateTaskListItemPayload>(this as UpdateTaskListItemPayload, _$identity);

  /// Serializes this UpdateTaskListItemPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskListItemPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.clearStartAtUtc, clearStartAtUtc) || other.clearStartAtUtc == clearStartAtUtc)&&(identical(other.clearDueAtUtc, clearDueAtUtc) || other.clearDueAtUtc == clearDueAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.clearSize, clearSize) || other.clearSize == clearSize)&&(identical(other.clearComplexity, clearComplexity) || other.clearComplexity == clearComplexity)&&(identical(other.clearRisk, clearRisk) || other.clearRisk == clearRisk)&&(identical(other.clearBusinessValue, clearBusinessValue) || other.clearBusinessValue == clearBusinessValue)&&(identical(other.clearEstimatedMinutes, clearEstimatedMinutes) || other.clearEstimatedMinutes == clearEstimatedMinutes)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.clearMilestone, clearMilestone) || other.clearMilestone == clearMilestone)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,status,priority,startAtUtc,dueAtUtc,clearStartAtUtc,clearDueAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,clearSize,clearComplexity,clearRisk,clearBusinessValue,clearEstimatedMinutes,milestoneId,clearMilestone,customStatusId,expectedVersion]);

@override
String toString() {
  return 'UpdateTaskListItemPayload(title: $title, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, clearStartAtUtc: $clearStartAtUtc, clearDueAtUtc: $clearDueAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, clearSize: $clearSize, clearComplexity: $clearComplexity, clearRisk: $clearRisk, clearBusinessValue: $clearBusinessValue, clearEstimatedMinutes: $clearEstimatedMinutes, milestoneId: $milestoneId, clearMilestone: $clearMilestone, customStatusId: $customStatusId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskListItemPayloadCopyWith<$Res>  {
  factory $UpdateTaskListItemPayloadCopyWith(UpdateTaskListItemPayload value, $Res Function(UpdateTaskListItemPayload) _then) = _$UpdateTaskListItemPayloadCopyWithImpl;
@useResult
$Res call({
 String? title,@JsonKey(includeIfNull: false) ProjectTaskStatus? status, TaskPriority? priority, DateTime? startAtUtc, DateTime? dueAtUtc, bool clearStartAtUtc, bool clearDueAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, bool clearSize, bool clearComplexity, bool clearRisk, bool clearBusinessValue, bool clearEstimatedMinutes, String? milestoneId, bool clearMilestone,@JsonKey(includeIfNull: false) String? customStatusId, int expectedVersion
});




}
/// @nodoc
class _$UpdateTaskListItemPayloadCopyWithImpl<$Res>
    implements $UpdateTaskListItemPayloadCopyWith<$Res> {
  _$UpdateTaskListItemPayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskListItemPayload _self;
  final $Res Function(UpdateTaskListItemPayload) _then;

/// Create a copy of UpdateTaskListItemPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? status = freezed,Object? priority = freezed,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? clearStartAtUtc = null,Object? clearDueAtUtc = null,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? clearSize = null,Object? clearComplexity = null,Object? clearRisk = null,Object? clearBusinessValue = null,Object? clearEstimatedMinutes = null,Object? milestoneId = freezed,Object? clearMilestone = null,Object? customStatusId = freezed,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,clearStartAtUtc: null == clearStartAtUtc ? _self.clearStartAtUtc : clearStartAtUtc // ignore: cast_nullable_to_non_nullable
as bool,clearDueAtUtc: null == clearDueAtUtc ? _self.clearDueAtUtc : clearDueAtUtc // ignore: cast_nullable_to_non_nullable
as bool,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,clearSize: null == clearSize ? _self.clearSize : clearSize // ignore: cast_nullable_to_non_nullable
as bool,clearComplexity: null == clearComplexity ? _self.clearComplexity : clearComplexity // ignore: cast_nullable_to_non_nullable
as bool,clearRisk: null == clearRisk ? _self.clearRisk : clearRisk // ignore: cast_nullable_to_non_nullable
as bool,clearBusinessValue: null == clearBusinessValue ? _self.clearBusinessValue : clearBusinessValue // ignore: cast_nullable_to_non_nullable
as bool,clearEstimatedMinutes: null == clearEstimatedMinutes ? _self.clearEstimatedMinutes : clearEstimatedMinutes // ignore: cast_nullable_to_non_nullable
as bool,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,clearMilestone: null == clearMilestone ? _self.clearMilestone : clearMilestone // ignore: cast_nullable_to_non_nullable
as bool,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskListItemPayload].
extension UpdateTaskListItemPayloadPatterns on UpdateTaskListItemPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskListItemPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskListItemPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskListItemPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title, @JsonKey(includeIfNull: false)  ProjectTaskStatus? status,  TaskPriority? priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  bool clearStartAtUtc,  bool clearDueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  bool clearSize,  bool clearComplexity,  bool clearRisk,  bool clearBusinessValue,  bool clearEstimatedMinutes,  String? milestoneId,  bool clearMilestone, @JsonKey(includeIfNull: false)  String? customStatusId,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload() when $default != null:
return $default(_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.clearStartAtUtc,_that.clearDueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.clearSize,_that.clearComplexity,_that.clearRisk,_that.clearBusinessValue,_that.clearEstimatedMinutes,_that.milestoneId,_that.clearMilestone,_that.customStatusId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title, @JsonKey(includeIfNull: false)  ProjectTaskStatus? status,  TaskPriority? priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  bool clearStartAtUtc,  bool clearDueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  bool clearSize,  bool clearComplexity,  bool clearRisk,  bool clearBusinessValue,  bool clearEstimatedMinutes,  String? milestoneId,  bool clearMilestone, @JsonKey(includeIfNull: false)  String? customStatusId,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload():
return $default(_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.clearStartAtUtc,_that.clearDueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.clearSize,_that.clearComplexity,_that.clearRisk,_that.clearBusinessValue,_that.clearEstimatedMinutes,_that.milestoneId,_that.clearMilestone,_that.customStatusId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title, @JsonKey(includeIfNull: false)  ProjectTaskStatus? status,  TaskPriority? priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  bool clearStartAtUtc,  bool clearDueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  bool clearSize,  bool clearComplexity,  bool clearRisk,  bool clearBusinessValue,  bool clearEstimatedMinutes,  String? milestoneId,  bool clearMilestone, @JsonKey(includeIfNull: false)  String? customStatusId,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload() when $default != null:
return $default(_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.clearStartAtUtc,_that.clearDueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.clearSize,_that.clearComplexity,_that.clearRisk,_that.clearBusinessValue,_that.clearEstimatedMinutes,_that.milestoneId,_that.clearMilestone,_that.customStatusId,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskListItemPayload implements UpdateTaskListItemPayload {
  const _UpdateTaskListItemPayload({this.title, @JsonKey(includeIfNull: false) this.status, this.priority, this.startAtUtc, this.dueAtUtc, this.clearStartAtUtc = false, this.clearDueAtUtc = false, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.clearSize = false, this.clearComplexity = false, this.clearRisk = false, this.clearBusinessValue = false, this.clearEstimatedMinutes = false, this.milestoneId, this.clearMilestone = false, @JsonKey(includeIfNull: false) this.customStatusId, required this.expectedVersion});
  factory _UpdateTaskListItemPayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskListItemPayloadFromJson(json);

@override final  String? title;
@override@JsonKey(includeIfNull: false) final  ProjectTaskStatus? status;
@override final  TaskPriority? priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override@JsonKey() final  bool clearStartAtUtc;
@override@JsonKey() final  bool clearDueAtUtc;
@override final  String? taskType;
@override final  int? size;
@override final  int? complexity;
@override final  int? risk;
@override final  int? businessValue;
@override final  int? estimatedMinutes;
@override@JsonKey() final  bool clearSize;
@override@JsonKey() final  bool clearComplexity;
@override@JsonKey() final  bool clearRisk;
@override@JsonKey() final  bool clearBusinessValue;
@override@JsonKey() final  bool clearEstimatedMinutes;
@override final  String? milestoneId;
@override@JsonKey() final  bool clearMilestone;
@override@JsonKey(includeIfNull: false) final  String? customStatusId;
@override final  int expectedVersion;

/// Create a copy of UpdateTaskListItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskListItemPayloadCopyWith<_UpdateTaskListItemPayload> get copyWith => __$UpdateTaskListItemPayloadCopyWithImpl<_UpdateTaskListItemPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskListItemPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskListItemPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.clearStartAtUtc, clearStartAtUtc) || other.clearStartAtUtc == clearStartAtUtc)&&(identical(other.clearDueAtUtc, clearDueAtUtc) || other.clearDueAtUtc == clearDueAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.clearSize, clearSize) || other.clearSize == clearSize)&&(identical(other.clearComplexity, clearComplexity) || other.clearComplexity == clearComplexity)&&(identical(other.clearRisk, clearRisk) || other.clearRisk == clearRisk)&&(identical(other.clearBusinessValue, clearBusinessValue) || other.clearBusinessValue == clearBusinessValue)&&(identical(other.clearEstimatedMinutes, clearEstimatedMinutes) || other.clearEstimatedMinutes == clearEstimatedMinutes)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.clearMilestone, clearMilestone) || other.clearMilestone == clearMilestone)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,status,priority,startAtUtc,dueAtUtc,clearStartAtUtc,clearDueAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,clearSize,clearComplexity,clearRisk,clearBusinessValue,clearEstimatedMinutes,milestoneId,clearMilestone,customStatusId,expectedVersion]);

@override
String toString() {
  return 'UpdateTaskListItemPayload(title: $title, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, clearStartAtUtc: $clearStartAtUtc, clearDueAtUtc: $clearDueAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, clearSize: $clearSize, clearComplexity: $clearComplexity, clearRisk: $clearRisk, clearBusinessValue: $clearBusinessValue, clearEstimatedMinutes: $clearEstimatedMinutes, milestoneId: $milestoneId, clearMilestone: $clearMilestone, customStatusId: $customStatusId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskListItemPayloadCopyWith<$Res> implements $UpdateTaskListItemPayloadCopyWith<$Res> {
  factory _$UpdateTaskListItemPayloadCopyWith(_UpdateTaskListItemPayload value, $Res Function(_UpdateTaskListItemPayload) _then) = __$UpdateTaskListItemPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? title,@JsonKey(includeIfNull: false) ProjectTaskStatus? status, TaskPriority? priority, DateTime? startAtUtc, DateTime? dueAtUtc, bool clearStartAtUtc, bool clearDueAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, bool clearSize, bool clearComplexity, bool clearRisk, bool clearBusinessValue, bool clearEstimatedMinutes, String? milestoneId, bool clearMilestone,@JsonKey(includeIfNull: false) String? customStatusId, int expectedVersion
});




}
/// @nodoc
class __$UpdateTaskListItemPayloadCopyWithImpl<$Res>
    implements _$UpdateTaskListItemPayloadCopyWith<$Res> {
  __$UpdateTaskListItemPayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskListItemPayload _self;
  final $Res Function(_UpdateTaskListItemPayload) _then;

/// Create a copy of UpdateTaskListItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? status = freezed,Object? priority = freezed,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? clearStartAtUtc = null,Object? clearDueAtUtc = null,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? clearSize = null,Object? clearComplexity = null,Object? clearRisk = null,Object? clearBusinessValue = null,Object? clearEstimatedMinutes = null,Object? milestoneId = freezed,Object? clearMilestone = null,Object? customStatusId = freezed,Object? expectedVersion = null,}) {
  return _then(_UpdateTaskListItemPayload(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,clearStartAtUtc: null == clearStartAtUtc ? _self.clearStartAtUtc : clearStartAtUtc // ignore: cast_nullable_to_non_nullable
as bool,clearDueAtUtc: null == clearDueAtUtc ? _self.clearDueAtUtc : clearDueAtUtc // ignore: cast_nullable_to_non_nullable
as bool,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,clearSize: null == clearSize ? _self.clearSize : clearSize // ignore: cast_nullable_to_non_nullable
as bool,clearComplexity: null == clearComplexity ? _self.clearComplexity : clearComplexity // ignore: cast_nullable_to_non_nullable
as bool,clearRisk: null == clearRisk ? _self.clearRisk : clearRisk // ignore: cast_nullable_to_non_nullable
as bool,clearBusinessValue: null == clearBusinessValue ? _self.clearBusinessValue : clearBusinessValue // ignore: cast_nullable_to_non_nullable
as bool,clearEstimatedMinutes: null == clearEstimatedMinutes ? _self.clearEstimatedMinutes : clearEstimatedMinutes // ignore: cast_nullable_to_non_nullable
as bool,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,clearMilestone: null == clearMilestone ? _self.clearMilestone : clearMilestone // ignore: cast_nullable_to_non_nullable
as bool,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MoveProjectTaskPayload {

 int get expectedVersion; String? get parentTaskId; String? get previousTaskId; String? get nextTaskId; ProjectTaskStatus? get status; String? get customStatusId;
/// Create a copy of MoveProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveProjectTaskPayloadCopyWith<MoveProjectTaskPayload> get copyWith => _$MoveProjectTaskPayloadCopyWithImpl<MoveProjectTaskPayload>(this as MoveProjectTaskPayload, _$identity);

  /// Serializes this MoveProjectTaskPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveProjectTaskPayload&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expectedVersion,parentTaskId,previousTaskId,nextTaskId,status,customStatusId);

@override
String toString() {
  return 'MoveProjectTaskPayload(expectedVersion: $expectedVersion, parentTaskId: $parentTaskId, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId, status: $status, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class $MoveProjectTaskPayloadCopyWith<$Res>  {
  factory $MoveProjectTaskPayloadCopyWith(MoveProjectTaskPayload value, $Res Function(MoveProjectTaskPayload) _then) = _$MoveProjectTaskPayloadCopyWithImpl;
@useResult
$Res call({
 int expectedVersion, String? parentTaskId, String? previousTaskId, String? nextTaskId, ProjectTaskStatus? status, String? customStatusId
});




}
/// @nodoc
class _$MoveProjectTaskPayloadCopyWithImpl<$Res>
    implements $MoveProjectTaskPayloadCopyWith<$Res> {
  _$MoveProjectTaskPayloadCopyWithImpl(this._self, this._then);

  final MoveProjectTaskPayload _self;
  final $Res Function(MoveProjectTaskPayload) _then;

/// Create a copy of MoveProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expectedVersion = null,Object? parentTaskId = freezed,Object? previousTaskId = freezed,Object? nextTaskId = freezed,Object? status = freezed,Object? customStatusId = freezed,}) {
  return _then(_self.copyWith(
expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,previousTaskId: freezed == previousTaskId ? _self.previousTaskId : previousTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextTaskId: freezed == nextTaskId ? _self.nextTaskId : nextTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MoveProjectTaskPayload].
extension MoveProjectTaskPayloadPatterns on MoveProjectTaskPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoveProjectTaskPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoveProjectTaskPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoveProjectTaskPayload value)  $default,){
final _that = this;
switch (_that) {
case _MoveProjectTaskPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoveProjectTaskPayload value)?  $default,){
final _that = this;
switch (_that) {
case _MoveProjectTaskPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int expectedVersion,  String? parentTaskId,  String? previousTaskId,  String? nextTaskId,  ProjectTaskStatus? status,  String? customStatusId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoveProjectTaskPayload() when $default != null:
return $default(_that.expectedVersion,_that.parentTaskId,_that.previousTaskId,_that.nextTaskId,_that.status,_that.customStatusId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int expectedVersion,  String? parentTaskId,  String? previousTaskId,  String? nextTaskId,  ProjectTaskStatus? status,  String? customStatusId)  $default,) {final _that = this;
switch (_that) {
case _MoveProjectTaskPayload():
return $default(_that.expectedVersion,_that.parentTaskId,_that.previousTaskId,_that.nextTaskId,_that.status,_that.customStatusId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int expectedVersion,  String? parentTaskId,  String? previousTaskId,  String? nextTaskId,  ProjectTaskStatus? status,  String? customStatusId)?  $default,) {final _that = this;
switch (_that) {
case _MoveProjectTaskPayload() when $default != null:
return $default(_that.expectedVersion,_that.parentTaskId,_that.previousTaskId,_that.nextTaskId,_that.status,_that.customStatusId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoveProjectTaskPayload implements MoveProjectTaskPayload {
  const _MoveProjectTaskPayload({required this.expectedVersion, this.parentTaskId, this.previousTaskId, this.nextTaskId, this.status, this.customStatusId});
  factory _MoveProjectTaskPayload.fromJson(Map<String, dynamic> json) => _$MoveProjectTaskPayloadFromJson(json);

@override final  int expectedVersion;
@override final  String? parentTaskId;
@override final  String? previousTaskId;
@override final  String? nextTaskId;
@override final  ProjectTaskStatus? status;
@override final  String? customStatusId;

/// Create a copy of MoveProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoveProjectTaskPayloadCopyWith<_MoveProjectTaskPayload> get copyWith => __$MoveProjectTaskPayloadCopyWithImpl<_MoveProjectTaskPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoveProjectTaskPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoveProjectTaskPayload&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expectedVersion,parentTaskId,previousTaskId,nextTaskId,status,customStatusId);

@override
String toString() {
  return 'MoveProjectTaskPayload(expectedVersion: $expectedVersion, parentTaskId: $parentTaskId, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId, status: $status, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class _$MoveProjectTaskPayloadCopyWith<$Res> implements $MoveProjectTaskPayloadCopyWith<$Res> {
  factory _$MoveProjectTaskPayloadCopyWith(_MoveProjectTaskPayload value, $Res Function(_MoveProjectTaskPayload) _then) = __$MoveProjectTaskPayloadCopyWithImpl;
@override @useResult
$Res call({
 int expectedVersion, String? parentTaskId, String? previousTaskId, String? nextTaskId, ProjectTaskStatus? status, String? customStatusId
});




}
/// @nodoc
class __$MoveProjectTaskPayloadCopyWithImpl<$Res>
    implements _$MoveProjectTaskPayloadCopyWith<$Res> {
  __$MoveProjectTaskPayloadCopyWithImpl(this._self, this._then);

  final _MoveProjectTaskPayload _self;
  final $Res Function(_MoveProjectTaskPayload) _then;

/// Create a copy of MoveProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expectedVersion = null,Object? parentTaskId = freezed,Object? previousTaskId = freezed,Object? nextTaskId = freezed,Object? status = freezed,Object? customStatusId = freezed,}) {
  return _then(_MoveProjectTaskPayload(
expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,previousTaskId: freezed == previousTaskId ? _self.previousTaskId : previousTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextTaskId: freezed == nextTaskId ? _self.nextTaskId : nextTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MovedProjectTaskResponse {

 String get taskId; String? get parentTaskId; ProjectTaskStatus get status; int get position; int get version; DateTime get updatedAtUtc; String? get customStatusId;
/// Create a copy of MovedProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovedProjectTaskResponseCopyWith<MovedProjectTaskResponse> get copyWith => _$MovedProjectTaskResponseCopyWithImpl<MovedProjectTaskResponse>(this as MovedProjectTaskResponse, _$identity);

  /// Serializes this MovedProjectTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovedProjectTaskResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,parentTaskId,status,position,version,updatedAtUtc,customStatusId);

@override
String toString() {
  return 'MovedProjectTaskResponse(taskId: $taskId, parentTaskId: $parentTaskId, status: $status, position: $position, version: $version, updatedAtUtc: $updatedAtUtc, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class $MovedProjectTaskResponseCopyWith<$Res>  {
  factory $MovedProjectTaskResponseCopyWith(MovedProjectTaskResponse value, $Res Function(MovedProjectTaskResponse) _then) = _$MovedProjectTaskResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, String? parentTaskId, ProjectTaskStatus status, int position, int version, DateTime updatedAtUtc, String? customStatusId
});




}
/// @nodoc
class _$MovedProjectTaskResponseCopyWithImpl<$Res>
    implements $MovedProjectTaskResponseCopyWith<$Res> {
  _$MovedProjectTaskResponseCopyWithImpl(this._self, this._then);

  final MovedProjectTaskResponse _self;
  final $Res Function(MovedProjectTaskResponse) _then;

/// Create a copy of MovedProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? parentTaskId = freezed,Object? status = null,Object? position = null,Object? version = null,Object? updatedAtUtc = null,Object? customStatusId = freezed,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovedProjectTaskResponse].
extension MovedProjectTaskResponsePatterns on MovedProjectTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovedProjectTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovedProjectTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovedProjectTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _MovedProjectTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovedProjectTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MovedProjectTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String? parentTaskId,  ProjectTaskStatus status,  int position,  int version,  DateTime updatedAtUtc,  String? customStatusId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovedProjectTaskResponse() when $default != null:
return $default(_that.taskId,_that.parentTaskId,_that.status,_that.position,_that.version,_that.updatedAtUtc,_that.customStatusId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String? parentTaskId,  ProjectTaskStatus status,  int position,  int version,  DateTime updatedAtUtc,  String? customStatusId)  $default,) {final _that = this;
switch (_that) {
case _MovedProjectTaskResponse():
return $default(_that.taskId,_that.parentTaskId,_that.status,_that.position,_that.version,_that.updatedAtUtc,_that.customStatusId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String? parentTaskId,  ProjectTaskStatus status,  int position,  int version,  DateTime updatedAtUtc,  String? customStatusId)?  $default,) {final _that = this;
switch (_that) {
case _MovedProjectTaskResponse() when $default != null:
return $default(_that.taskId,_that.parentTaskId,_that.status,_that.position,_that.version,_that.updatedAtUtc,_that.customStatusId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MovedProjectTaskResponse implements MovedProjectTaskResponse {
  const _MovedProjectTaskResponse({required this.taskId, this.parentTaskId, required this.status, required this.position, required this.version, required this.updatedAtUtc, this.customStatusId});
  factory _MovedProjectTaskResponse.fromJson(Map<String, dynamic> json) => _$MovedProjectTaskResponseFromJson(json);

@override final  String taskId;
@override final  String? parentTaskId;
@override final  ProjectTaskStatus status;
@override final  int position;
@override final  int version;
@override final  DateTime updatedAtUtc;
@override final  String? customStatusId;

/// Create a copy of MovedProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovedProjectTaskResponseCopyWith<_MovedProjectTaskResponse> get copyWith => __$MovedProjectTaskResponseCopyWithImpl<_MovedProjectTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovedProjectTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovedProjectTaskResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,parentTaskId,status,position,version,updatedAtUtc,customStatusId);

@override
String toString() {
  return 'MovedProjectTaskResponse(taskId: $taskId, parentTaskId: $parentTaskId, status: $status, position: $position, version: $version, updatedAtUtc: $updatedAtUtc, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class _$MovedProjectTaskResponseCopyWith<$Res> implements $MovedProjectTaskResponseCopyWith<$Res> {
  factory _$MovedProjectTaskResponseCopyWith(_MovedProjectTaskResponse value, $Res Function(_MovedProjectTaskResponse) _then) = __$MovedProjectTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String? parentTaskId, ProjectTaskStatus status, int position, int version, DateTime updatedAtUtc, String? customStatusId
});




}
/// @nodoc
class __$MovedProjectTaskResponseCopyWithImpl<$Res>
    implements _$MovedProjectTaskResponseCopyWith<$Res> {
  __$MovedProjectTaskResponseCopyWithImpl(this._self, this._then);

  final _MovedProjectTaskResponse _self;
  final $Res Function(_MovedProjectTaskResponse) _then;

/// Create a copy of MovedProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? parentTaskId = freezed,Object? status = null,Object? position = null,Object? version = null,Object? updatedAtUtc = null,Object? customStatusId = freezed,}) {
  return _then(_MovedProjectTaskResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskResponse {

 String get id; int get number; String get key; String get workspaceId; String get projectId; String? get parentTaskId; String get title; String? get description; String? get descriptionDeltaJson; ProjectTaskStatus get status; TaskPriority get priority; String get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; int? get actualMinutes; int get position; DateTime? get startAtUtc; DateTime? get dueAtUtc; String get createdByCoreUserId; List<TaskAssigneeResponse> get assignees; List<TaskChecklistItemResponse> get checklistItems; TaskRecurrenceSummaryResponse? get recurrence; DateTime get createdAtUtc; DateTime get updatedAtUtc; DateTime? get archivedAtUtc; int get version; String? get customStatusId;
/// Create a copy of ProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskResponseCopyWith<ProjectTaskResponse> get copyWith => _$ProjectTaskResponseCopyWithImpl<ProjectTaskResponse>(this as ProjectTaskResponse, _$identity);

  /// Serializes this ProjectTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&(identical(other.position, position) || other.position == position)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,workspaceId,projectId,parentTaskId,title,description,descriptionDeltaJson,status,priority,taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,position,startAtUtc,dueAtUtc,createdByCoreUserId,const DeepCollectionEquality().hash(assignees),const DeepCollectionEquality().hash(checklistItems),recurrence,createdAtUtc,updatedAtUtc,archivedAtUtc,version,customStatusId]);

@override
String toString() {
  return 'ProjectTaskResponse(id: $id, number: $number, key: $key, workspaceId: $workspaceId, projectId: $projectId, parentTaskId: $parentTaskId, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson, status: $status, priority: $priority, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, position: $position, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, createdByCoreUserId: $createdByCoreUserId, assignees: $assignees, checklistItems: $checklistItems, recurrence: $recurrence, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, archivedAtUtc: $archivedAtUtc, version: $version, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskResponseCopyWith<$Res>  {
  factory $ProjectTaskResponseCopyWith(ProjectTaskResponse value, $Res Function(ProjectTaskResponse) _then) = _$ProjectTaskResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String workspaceId, String projectId, String? parentTaskId, String title, String? description, String? descriptionDeltaJson, ProjectTaskStatus status, TaskPriority priority, String taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, int position, DateTime? startAtUtc, DateTime? dueAtUtc, String createdByCoreUserId, List<TaskAssigneeResponse> assignees, List<TaskChecklistItemResponse> checklistItems, TaskRecurrenceSummaryResponse? recurrence, DateTime createdAtUtc, DateTime updatedAtUtc, DateTime? archivedAtUtc, int version, String? customStatusId
});


$TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence;

}
/// @nodoc
class _$ProjectTaskResponseCopyWithImpl<$Res>
    implements $ProjectTaskResponseCopyWith<$Res> {
  _$ProjectTaskResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskResponse _self;
  final $Res Function(ProjectTaskResponse) _then;

/// Create a copy of ProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? workspaceId = null,Object? projectId = null,Object? parentTaskId = freezed,Object? title = null,Object? description = freezed,Object? descriptionDeltaJson = freezed,Object? status = null,Object? priority = null,Object? taskType = null,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? position = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? createdByCoreUserId = null,Object? assignees = null,Object? checklistItems = null,Object? recurrence = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? archivedAtUtc = freezed,Object? version = null,Object? customStatusId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualMinutes: freezed == actualMinutes ? _self.actualMinutes : actualMinutes // ignore: cast_nullable_to_non_nullable
as int?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,createdByCoreUserId: null == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<TaskAssigneeResponse>,checklistItems: null == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<TaskChecklistItemResponse>,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceSummaryResponse?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $TaskRecurrenceSummaryResponseCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectTaskResponse].
extension ProjectTaskResponsePatterns on ProjectTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String workspaceId,  String projectId,  String? parentTaskId,  String title,  String? description,  String? descriptionDeltaJson,  ProjectTaskStatus status,  TaskPriority priority,  String taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  int position,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String createdByCoreUserId,  List<TaskAssigneeResponse> assignees,  List<TaskChecklistItemResponse> checklistItems,  TaskRecurrenceSummaryResponse? recurrence,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc,  int version,  String? customStatusId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.projectId,_that.parentTaskId,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.position,_that.startAtUtc,_that.dueAtUtc,_that.createdByCoreUserId,_that.assignees,_that.checklistItems,_that.recurrence,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc,_that.version,_that.customStatusId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String workspaceId,  String projectId,  String? parentTaskId,  String title,  String? description,  String? descriptionDeltaJson,  ProjectTaskStatus status,  TaskPriority priority,  String taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  int position,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String createdByCoreUserId,  List<TaskAssigneeResponse> assignees,  List<TaskChecklistItemResponse> checklistItems,  TaskRecurrenceSummaryResponse? recurrence,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc,  int version,  String? customStatusId)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskResponse():
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.projectId,_that.parentTaskId,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.position,_that.startAtUtc,_that.dueAtUtc,_that.createdByCoreUserId,_that.assignees,_that.checklistItems,_that.recurrence,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc,_that.version,_that.customStatusId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String workspaceId,  String projectId,  String? parentTaskId,  String title,  String? description,  String? descriptionDeltaJson,  ProjectTaskStatus status,  TaskPriority priority,  String taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  int position,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String createdByCoreUserId,  List<TaskAssigneeResponse> assignees,  List<TaskChecklistItemResponse> checklistItems,  TaskRecurrenceSummaryResponse? recurrence,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc,  int version,  String? customStatusId)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.projectId,_that.parentTaskId,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.position,_that.startAtUtc,_that.dueAtUtc,_that.createdByCoreUserId,_that.assignees,_that.checklistItems,_that.recurrence,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc,_that.version,_that.customStatusId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskResponse implements ProjectTaskResponse {
  const _ProjectTaskResponse({required this.id, required this.number, required this.key, required this.workspaceId, required this.projectId, this.parentTaskId, required this.title, this.description, this.descriptionDeltaJson, required this.status, required this.priority, required this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.actualMinutes, required this.position, this.startAtUtc, this.dueAtUtc, required this.createdByCoreUserId, required this.assignees, required this.checklistItems, this.recurrence, required this.createdAtUtc, required this.updatedAtUtc, this.archivedAtUtc, required this.version, this.customStatusId});
  factory _ProjectTaskResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String key;
@override final  String workspaceId;
@override final  String projectId;
@override final  String? parentTaskId;
@override final  String title;
@override final  String? description;
@override final  String? descriptionDeltaJson;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  String taskType;
@override final  int? size;
@override final  int? complexity;
@override final  int? risk;
@override final  int? businessValue;
@override final  int? estimatedMinutes;
@override final  int? actualMinutes;
@override final  int position;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  String createdByCoreUserId;
@override final  List<TaskAssigneeResponse> assignees;
@override final  List<TaskChecklistItemResponse> checklistItems;
@override final  TaskRecurrenceSummaryResponse? recurrence;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  DateTime? archivedAtUtc;
@override final  int version;
@override final  String? customStatusId;

/// Create a copy of ProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskResponseCopyWith<_ProjectTaskResponse> get copyWith => __$ProjectTaskResponseCopyWithImpl<_ProjectTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&(identical(other.position, position) || other.position == position)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,workspaceId,projectId,parentTaskId,title,description,descriptionDeltaJson,status,priority,taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,position,startAtUtc,dueAtUtc,createdByCoreUserId,const DeepCollectionEquality().hash(assignees),const DeepCollectionEquality().hash(checklistItems),recurrence,createdAtUtc,updatedAtUtc,archivedAtUtc,version,customStatusId]);

@override
String toString() {
  return 'ProjectTaskResponse(id: $id, number: $number, key: $key, workspaceId: $workspaceId, projectId: $projectId, parentTaskId: $parentTaskId, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson, status: $status, priority: $priority, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, position: $position, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, createdByCoreUserId: $createdByCoreUserId, assignees: $assignees, checklistItems: $checklistItems, recurrence: $recurrence, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, archivedAtUtc: $archivedAtUtc, version: $version, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskResponseCopyWith<$Res> implements $ProjectTaskResponseCopyWith<$Res> {
  factory _$ProjectTaskResponseCopyWith(_ProjectTaskResponse value, $Res Function(_ProjectTaskResponse) _then) = __$ProjectTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String workspaceId, String projectId, String? parentTaskId, String title, String? description, String? descriptionDeltaJson, ProjectTaskStatus status, TaskPriority priority, String taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, int position, DateTime? startAtUtc, DateTime? dueAtUtc, String createdByCoreUserId, List<TaskAssigneeResponse> assignees, List<TaskChecklistItemResponse> checklistItems, TaskRecurrenceSummaryResponse? recurrence, DateTime createdAtUtc, DateTime updatedAtUtc, DateTime? archivedAtUtc, int version, String? customStatusId
});


@override $TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence;

}
/// @nodoc
class __$ProjectTaskResponseCopyWithImpl<$Res>
    implements _$ProjectTaskResponseCopyWith<$Res> {
  __$ProjectTaskResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskResponse _self;
  final $Res Function(_ProjectTaskResponse) _then;

/// Create a copy of ProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? workspaceId = null,Object? projectId = null,Object? parentTaskId = freezed,Object? title = null,Object? description = freezed,Object? descriptionDeltaJson = freezed,Object? status = null,Object? priority = null,Object? taskType = null,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? position = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? createdByCoreUserId = null,Object? assignees = null,Object? checklistItems = null,Object? recurrence = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? archivedAtUtc = freezed,Object? version = null,Object? customStatusId = freezed,}) {
  return _then(_ProjectTaskResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualMinutes: freezed == actualMinutes ? _self.actualMinutes : actualMinutes // ignore: cast_nullable_to_non_nullable
as int?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,createdByCoreUserId: null == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<TaskAssigneeResponse>,checklistItems: null == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<TaskChecklistItemResponse>,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceSummaryResponse?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $TaskRecurrenceSummaryResponseCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// @nodoc
mixin _$TaskMutationResponse<T> {

 String get taskId; int get taskVersion; DateTime get taskUpdatedAtUtc; T get data;
/// Create a copy of TaskMutationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskMutationResponseCopyWith<T, TaskMutationResponse<T>> get copyWith => _$TaskMutationResponseCopyWithImpl<T, TaskMutationResponse<T>>(this as TaskMutationResponse<T>, _$identity);

  /// Serializes this TaskMutationResponse to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskMutationResponse<T>&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskVersion, taskVersion) || other.taskVersion == taskVersion)&&(identical(other.taskUpdatedAtUtc, taskUpdatedAtUtc) || other.taskUpdatedAtUtc == taskUpdatedAtUtc)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,taskVersion,taskUpdatedAtUtc,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'TaskMutationResponse<$T>(taskId: $taskId, taskVersion: $taskVersion, taskUpdatedAtUtc: $taskUpdatedAtUtc, data: $data)';
}


}

/// @nodoc
abstract mixin class $TaskMutationResponseCopyWith<T,$Res>  {
  factory $TaskMutationResponseCopyWith(TaskMutationResponse<T> value, $Res Function(TaskMutationResponse<T>) _then) = _$TaskMutationResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, int taskVersion, DateTime taskUpdatedAtUtc, T data
});




}
/// @nodoc
class _$TaskMutationResponseCopyWithImpl<T,$Res>
    implements $TaskMutationResponseCopyWith<T, $Res> {
  _$TaskMutationResponseCopyWithImpl(this._self, this._then);

  final TaskMutationResponse<T> _self;
  final $Res Function(TaskMutationResponse<T>) _then;

/// Create a copy of TaskMutationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? taskVersion = null,Object? taskUpdatedAtUtc = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,taskVersion: null == taskVersion ? _self.taskVersion : taskVersion // ignore: cast_nullable_to_non_nullable
as int,taskUpdatedAtUtc: null == taskUpdatedAtUtc ? _self.taskUpdatedAtUtc : taskUpdatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskMutationResponse].
extension TaskMutationResponsePatterns<T> on TaskMutationResponse<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskMutationResponse<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskMutationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskMutationResponse<T> value)  $default,){
final _that = this;
switch (_that) {
case _TaskMutationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskMutationResponse<T> value)?  $default,){
final _that = this;
switch (_that) {
case _TaskMutationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  int taskVersion,  DateTime taskUpdatedAtUtc,  T data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskMutationResponse() when $default != null:
return $default(_that.taskId,_that.taskVersion,_that.taskUpdatedAtUtc,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  int taskVersion,  DateTime taskUpdatedAtUtc,  T data)  $default,) {final _that = this;
switch (_that) {
case _TaskMutationResponse():
return $default(_that.taskId,_that.taskVersion,_that.taskUpdatedAtUtc,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  int taskVersion,  DateTime taskUpdatedAtUtc,  T data)?  $default,) {final _that = this;
switch (_that) {
case _TaskMutationResponse() when $default != null:
return $default(_that.taskId,_that.taskVersion,_that.taskUpdatedAtUtc,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _TaskMutationResponse<T> implements TaskMutationResponse<T> {
  const _TaskMutationResponse({required this.taskId, required this.taskVersion, required this.taskUpdatedAtUtc, required this.data});
  factory _TaskMutationResponse.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$TaskMutationResponseFromJson(json,fromJsonT);

@override final  String taskId;
@override final  int taskVersion;
@override final  DateTime taskUpdatedAtUtc;
@override final  T data;

/// Create a copy of TaskMutationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskMutationResponseCopyWith<T, _TaskMutationResponse<T>> get copyWith => __$TaskMutationResponseCopyWithImpl<T, _TaskMutationResponse<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$TaskMutationResponseToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskMutationResponse<T>&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskVersion, taskVersion) || other.taskVersion == taskVersion)&&(identical(other.taskUpdatedAtUtc, taskUpdatedAtUtc) || other.taskUpdatedAtUtc == taskUpdatedAtUtc)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,taskVersion,taskUpdatedAtUtc,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'TaskMutationResponse<$T>(taskId: $taskId, taskVersion: $taskVersion, taskUpdatedAtUtc: $taskUpdatedAtUtc, data: $data)';
}


}

/// @nodoc
abstract mixin class _$TaskMutationResponseCopyWith<T,$Res> implements $TaskMutationResponseCopyWith<T, $Res> {
  factory _$TaskMutationResponseCopyWith(_TaskMutationResponse<T> value, $Res Function(_TaskMutationResponse<T>) _then) = __$TaskMutationResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, int taskVersion, DateTime taskUpdatedAtUtc, T data
});




}
/// @nodoc
class __$TaskMutationResponseCopyWithImpl<T,$Res>
    implements _$TaskMutationResponseCopyWith<T, $Res> {
  __$TaskMutationResponseCopyWithImpl(this._self, this._then);

  final _TaskMutationResponse<T> _self;
  final $Res Function(_TaskMutationResponse<T>) _then;

/// Create a copy of TaskMutationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? taskVersion = null,Object? taskUpdatedAtUtc = null,Object? data = freezed,}) {
  return _then(_TaskMutationResponse<T>(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,taskVersion: null == taskVersion ? _self.taskVersion : taskVersion // ignore: cast_nullable_to_non_nullable
as int,taskUpdatedAtUtc: null == taskUpdatedAtUtc ? _self.taskUpdatedAtUtc : taskUpdatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}


/// @nodoc
mixin _$ReorderedTaskVersionResponse {

 String get taskId; int get taskVersion; DateTime get taskUpdatedAtUtc;
/// Create a copy of ReorderedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReorderedTaskVersionResponseCopyWith<ReorderedTaskVersionResponse> get copyWith => _$ReorderedTaskVersionResponseCopyWithImpl<ReorderedTaskVersionResponse>(this as ReorderedTaskVersionResponse, _$identity);

  /// Serializes this ReorderedTaskVersionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReorderedTaskVersionResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskVersion, taskVersion) || other.taskVersion == taskVersion)&&(identical(other.taskUpdatedAtUtc, taskUpdatedAtUtc) || other.taskUpdatedAtUtc == taskUpdatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,taskVersion,taskUpdatedAtUtc);

@override
String toString() {
  return 'ReorderedTaskVersionResponse(taskId: $taskId, taskVersion: $taskVersion, taskUpdatedAtUtc: $taskUpdatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ReorderedTaskVersionResponseCopyWith<$Res>  {
  factory $ReorderedTaskVersionResponseCopyWith(ReorderedTaskVersionResponse value, $Res Function(ReorderedTaskVersionResponse) _then) = _$ReorderedTaskVersionResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, int taskVersion, DateTime taskUpdatedAtUtc
});




}
/// @nodoc
class _$ReorderedTaskVersionResponseCopyWithImpl<$Res>
    implements $ReorderedTaskVersionResponseCopyWith<$Res> {
  _$ReorderedTaskVersionResponseCopyWithImpl(this._self, this._then);

  final ReorderedTaskVersionResponse _self;
  final $Res Function(ReorderedTaskVersionResponse) _then;

/// Create a copy of ReorderedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? taskVersion = null,Object? taskUpdatedAtUtc = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,taskVersion: null == taskVersion ? _self.taskVersion : taskVersion // ignore: cast_nullable_to_non_nullable
as int,taskUpdatedAtUtc: null == taskUpdatedAtUtc ? _self.taskUpdatedAtUtc : taskUpdatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReorderedTaskVersionResponse].
extension ReorderedTaskVersionResponsePatterns on ReorderedTaskVersionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReorderedTaskVersionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReorderedTaskVersionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReorderedTaskVersionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ReorderedTaskVersionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReorderedTaskVersionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ReorderedTaskVersionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  int taskVersion,  DateTime taskUpdatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReorderedTaskVersionResponse() when $default != null:
return $default(_that.taskId,_that.taskVersion,_that.taskUpdatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  int taskVersion,  DateTime taskUpdatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ReorderedTaskVersionResponse():
return $default(_that.taskId,_that.taskVersion,_that.taskUpdatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  int taskVersion,  DateTime taskUpdatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ReorderedTaskVersionResponse() when $default != null:
return $default(_that.taskId,_that.taskVersion,_that.taskUpdatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReorderedTaskVersionResponse implements ReorderedTaskVersionResponse {
  const _ReorderedTaskVersionResponse({required this.taskId, required this.taskVersion, required this.taskUpdatedAtUtc});
  factory _ReorderedTaskVersionResponse.fromJson(Map<String, dynamic> json) => _$ReorderedTaskVersionResponseFromJson(json);

@override final  String taskId;
@override final  int taskVersion;
@override final  DateTime taskUpdatedAtUtc;

/// Create a copy of ReorderedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReorderedTaskVersionResponseCopyWith<_ReorderedTaskVersionResponse> get copyWith => __$ReorderedTaskVersionResponseCopyWithImpl<_ReorderedTaskVersionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReorderedTaskVersionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReorderedTaskVersionResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskVersion, taskVersion) || other.taskVersion == taskVersion)&&(identical(other.taskUpdatedAtUtc, taskUpdatedAtUtc) || other.taskUpdatedAtUtc == taskUpdatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,taskVersion,taskUpdatedAtUtc);

@override
String toString() {
  return 'ReorderedTaskVersionResponse(taskId: $taskId, taskVersion: $taskVersion, taskUpdatedAtUtc: $taskUpdatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ReorderedTaskVersionResponseCopyWith<$Res> implements $ReorderedTaskVersionResponseCopyWith<$Res> {
  factory _$ReorderedTaskVersionResponseCopyWith(_ReorderedTaskVersionResponse value, $Res Function(_ReorderedTaskVersionResponse) _then) = __$ReorderedTaskVersionResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, int taskVersion, DateTime taskUpdatedAtUtc
});




}
/// @nodoc
class __$ReorderedTaskVersionResponseCopyWithImpl<$Res>
    implements _$ReorderedTaskVersionResponseCopyWith<$Res> {
  __$ReorderedTaskVersionResponseCopyWithImpl(this._self, this._then);

  final _ReorderedTaskVersionResponse _self;
  final $Res Function(_ReorderedTaskVersionResponse) _then;

/// Create a copy of ReorderedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? taskVersion = null,Object? taskUpdatedAtUtc = null,}) {
  return _then(_ReorderedTaskVersionResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,taskVersion: null == taskVersion ? _self.taskVersion : taskVersion // ignore: cast_nullable_to_non_nullable
as int,taskUpdatedAtUtc: null == taskUpdatedAtUtc ? _self.taskUpdatedAtUtc : taskUpdatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskDependencyResponse {

 String get id; String get sourceTaskId; String get targetTaskId; TaskDependencyType get type; DateTime get createdAtUtc; TaskDependencyKind get dependencyKind; int get lagDays;
/// Create a copy of TaskDependencyResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDependencyResponseCopyWith<TaskDependencyResponse> get copyWith => _$TaskDependencyResponseCopyWithImpl<TaskDependencyResponse>(this as TaskDependencyResponse, _$identity);

  /// Serializes this TaskDependencyResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDependencyResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.targetTaskId, targetTaskId) || other.targetTaskId == targetTaskId)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.dependencyKind, dependencyKind) || other.dependencyKind == dependencyKind)&&(identical(other.lagDays, lagDays) || other.lagDays == lagDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceTaskId,targetTaskId,type,createdAtUtc,dependencyKind,lagDays);

@override
String toString() {
  return 'TaskDependencyResponse(id: $id, sourceTaskId: $sourceTaskId, targetTaskId: $targetTaskId, type: $type, createdAtUtc: $createdAtUtc, dependencyKind: $dependencyKind, lagDays: $lagDays)';
}


}

/// @nodoc
abstract mixin class $TaskDependencyResponseCopyWith<$Res>  {
  factory $TaskDependencyResponseCopyWith(TaskDependencyResponse value, $Res Function(TaskDependencyResponse) _then) = _$TaskDependencyResponseCopyWithImpl;
@useResult
$Res call({
 String id, String sourceTaskId, String targetTaskId, TaskDependencyType type, DateTime createdAtUtc, TaskDependencyKind dependencyKind, int lagDays
});




}
/// @nodoc
class _$TaskDependencyResponseCopyWithImpl<$Res>
    implements $TaskDependencyResponseCopyWith<$Res> {
  _$TaskDependencyResponseCopyWithImpl(this._self, this._then);

  final TaskDependencyResponse _self;
  final $Res Function(TaskDependencyResponse) _then;

/// Create a copy of TaskDependencyResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceTaskId = null,Object? targetTaskId = null,Object? type = null,Object? createdAtUtc = null,Object? dependencyKind = null,Object? lagDays = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,targetTaskId: null == targetTaskId ? _self.targetTaskId : targetTaskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskDependencyType,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,dependencyKind: null == dependencyKind ? _self.dependencyKind : dependencyKind // ignore: cast_nullable_to_non_nullable
as TaskDependencyKind,lagDays: null == lagDays ? _self.lagDays : lagDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskDependencyResponse].
extension TaskDependencyResponsePatterns on TaskDependencyResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskDependencyResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskDependencyResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskDependencyResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskDependencyResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskDependencyResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskDependencyResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceTaskId,  String targetTaskId,  TaskDependencyType type,  DateTime createdAtUtc,  TaskDependencyKind dependencyKind,  int lagDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskDependencyResponse() when $default != null:
return $default(_that.id,_that.sourceTaskId,_that.targetTaskId,_that.type,_that.createdAtUtc,_that.dependencyKind,_that.lagDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceTaskId,  String targetTaskId,  TaskDependencyType type,  DateTime createdAtUtc,  TaskDependencyKind dependencyKind,  int lagDays)  $default,) {final _that = this;
switch (_that) {
case _TaskDependencyResponse():
return $default(_that.id,_that.sourceTaskId,_that.targetTaskId,_that.type,_that.createdAtUtc,_that.dependencyKind,_that.lagDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceTaskId,  String targetTaskId,  TaskDependencyType type,  DateTime createdAtUtc,  TaskDependencyKind dependencyKind,  int lagDays)?  $default,) {final _that = this;
switch (_that) {
case _TaskDependencyResponse() when $default != null:
return $default(_that.id,_that.sourceTaskId,_that.targetTaskId,_that.type,_that.createdAtUtc,_that.dependencyKind,_that.lagDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskDependencyResponse implements TaskDependencyResponse {
  const _TaskDependencyResponse({required this.id, required this.sourceTaskId, required this.targetTaskId, required this.type, required this.createdAtUtc, this.dependencyKind = TaskDependencyKind.finishToStart, this.lagDays = 0});
  factory _TaskDependencyResponse.fromJson(Map<String, dynamic> json) => _$TaskDependencyResponseFromJson(json);

@override final  String id;
@override final  String sourceTaskId;
@override final  String targetTaskId;
@override final  TaskDependencyType type;
@override final  DateTime createdAtUtc;
@override@JsonKey() final  TaskDependencyKind dependencyKind;
@override@JsonKey() final  int lagDays;

/// Create a copy of TaskDependencyResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDependencyResponseCopyWith<_TaskDependencyResponse> get copyWith => __$TaskDependencyResponseCopyWithImpl<_TaskDependencyResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskDependencyResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskDependencyResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.targetTaskId, targetTaskId) || other.targetTaskId == targetTaskId)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.dependencyKind, dependencyKind) || other.dependencyKind == dependencyKind)&&(identical(other.lagDays, lagDays) || other.lagDays == lagDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceTaskId,targetTaskId,type,createdAtUtc,dependencyKind,lagDays);

@override
String toString() {
  return 'TaskDependencyResponse(id: $id, sourceTaskId: $sourceTaskId, targetTaskId: $targetTaskId, type: $type, createdAtUtc: $createdAtUtc, dependencyKind: $dependencyKind, lagDays: $lagDays)';
}


}

/// @nodoc
abstract mixin class _$TaskDependencyResponseCopyWith<$Res> implements $TaskDependencyResponseCopyWith<$Res> {
  factory _$TaskDependencyResponseCopyWith(_TaskDependencyResponse value, $Res Function(_TaskDependencyResponse) _then) = __$TaskDependencyResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceTaskId, String targetTaskId, TaskDependencyType type, DateTime createdAtUtc, TaskDependencyKind dependencyKind, int lagDays
});




}
/// @nodoc
class __$TaskDependencyResponseCopyWithImpl<$Res>
    implements _$TaskDependencyResponseCopyWith<$Res> {
  __$TaskDependencyResponseCopyWithImpl(this._self, this._then);

  final _TaskDependencyResponse _self;
  final $Res Function(_TaskDependencyResponse) _then;

/// Create a copy of TaskDependencyResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceTaskId = null,Object? targetTaskId = null,Object? type = null,Object? createdAtUtc = null,Object? dependencyKind = null,Object? lagDays = null,}) {
  return _then(_TaskDependencyResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,targetTaskId: null == targetTaskId ? _self.targetTaskId : targetTaskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskDependencyType,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,dependencyKind: null == dependencyKind ? _self.dependencyKind : dependencyKind // ignore: cast_nullable_to_non_nullable
as TaskDependencyKind,lagDays: null == lagDays ? _self.lagDays : lagDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TaskLabelResponse {

 String get id; String get name; String get color; DateTime get createdAtUtc;
/// Create a copy of TaskLabelResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskLabelResponseCopyWith<TaskLabelResponse> get copyWith => _$TaskLabelResponseCopyWithImpl<TaskLabelResponse>(this as TaskLabelResponse, _$identity);

  /// Serializes this TaskLabelResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskLabelResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,createdAtUtc);

@override
String toString() {
  return 'TaskLabelResponse(id: $id, name: $name, color: $color, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskLabelResponseCopyWith<$Res>  {
  factory $TaskLabelResponseCopyWith(TaskLabelResponse value, $Res Function(TaskLabelResponse) _then) = _$TaskLabelResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String color, DateTime createdAtUtc
});




}
/// @nodoc
class _$TaskLabelResponseCopyWithImpl<$Res>
    implements $TaskLabelResponseCopyWith<$Res> {
  _$TaskLabelResponseCopyWithImpl(this._self, this._then);

  final TaskLabelResponse _self;
  final $Res Function(TaskLabelResponse) _then;

/// Create a copy of TaskLabelResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskLabelResponse].
extension TaskLabelResponsePatterns on TaskLabelResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskLabelResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskLabelResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskLabelResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskLabelResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskLabelResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskLabelResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String color,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskLabelResponse() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String color,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskLabelResponse():
return $default(_that.id,_that.name,_that.color,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String color,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskLabelResponse() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskLabelResponse implements TaskLabelResponse {
  const _TaskLabelResponse({required this.id, required this.name, required this.color, required this.createdAtUtc});
  factory _TaskLabelResponse.fromJson(Map<String, dynamic> json) => _$TaskLabelResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String color;
@override final  DateTime createdAtUtc;

/// Create a copy of TaskLabelResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskLabelResponseCopyWith<_TaskLabelResponse> get copyWith => __$TaskLabelResponseCopyWithImpl<_TaskLabelResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskLabelResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskLabelResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,createdAtUtc);

@override
String toString() {
  return 'TaskLabelResponse(id: $id, name: $name, color: $color, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskLabelResponseCopyWith<$Res> implements $TaskLabelResponseCopyWith<$Res> {
  factory _$TaskLabelResponseCopyWith(_TaskLabelResponse value, $Res Function(_TaskLabelResponse) _then) = __$TaskLabelResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String color, DateTime createdAtUtc
});




}
/// @nodoc
class __$TaskLabelResponseCopyWithImpl<$Res>
    implements _$TaskLabelResponseCopyWith<$Res> {
  __$TaskLabelResponseCopyWithImpl(this._self, this._then);

  final _TaskLabelResponse _self;
  final $Res Function(_TaskLabelResponse) _then;

/// Create a copy of TaskLabelResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? color = null,Object? createdAtUtc = null,}) {
  return _then(_TaskLabelResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskAcceptanceCriterionResponse {

 String get id; String get text; int get position; bool get isAccepted; String? get acceptedByCoreUserId; DateTime? get acceptedAtUtc; DateTime get updatedAtUtc;
/// Create a copy of TaskAcceptanceCriterionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskAcceptanceCriterionResponseCopyWith<TaskAcceptanceCriterionResponse> get copyWith => _$TaskAcceptanceCriterionResponseCopyWithImpl<TaskAcceptanceCriterionResponse>(this as TaskAcceptanceCriterionResponse, _$identity);

  /// Serializes this TaskAcceptanceCriterionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskAcceptanceCriterionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.position, position) || other.position == position)&&(identical(other.isAccepted, isAccepted) || other.isAccepted == isAccepted)&&(identical(other.acceptedByCoreUserId, acceptedByCoreUserId) || other.acceptedByCoreUserId == acceptedByCoreUserId)&&(identical(other.acceptedAtUtc, acceptedAtUtc) || other.acceptedAtUtc == acceptedAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,position,isAccepted,acceptedByCoreUserId,acceptedAtUtc,updatedAtUtc);

@override
String toString() {
  return 'TaskAcceptanceCriterionResponse(id: $id, text: $text, position: $position, isAccepted: $isAccepted, acceptedByCoreUserId: $acceptedByCoreUserId, acceptedAtUtc: $acceptedAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskAcceptanceCriterionResponseCopyWith<$Res>  {
  factory $TaskAcceptanceCriterionResponseCopyWith(TaskAcceptanceCriterionResponse value, $Res Function(TaskAcceptanceCriterionResponse) _then) = _$TaskAcceptanceCriterionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String text, int position, bool isAccepted, String? acceptedByCoreUserId, DateTime? acceptedAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class _$TaskAcceptanceCriterionResponseCopyWithImpl<$Res>
    implements $TaskAcceptanceCriterionResponseCopyWith<$Res> {
  _$TaskAcceptanceCriterionResponseCopyWithImpl(this._self, this._then);

  final TaskAcceptanceCriterionResponse _self;
  final $Res Function(TaskAcceptanceCriterionResponse) _then;

/// Create a copy of TaskAcceptanceCriterionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? position = null,Object? isAccepted = null,Object? acceptedByCoreUserId = freezed,Object? acceptedAtUtc = freezed,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isAccepted: null == isAccepted ? _self.isAccepted : isAccepted // ignore: cast_nullable_to_non_nullable
as bool,acceptedByCoreUserId: freezed == acceptedByCoreUserId ? _self.acceptedByCoreUserId : acceptedByCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,acceptedAtUtc: freezed == acceptedAtUtc ? _self.acceptedAtUtc : acceptedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskAcceptanceCriterionResponse].
extension TaskAcceptanceCriterionResponsePatterns on TaskAcceptanceCriterionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskAcceptanceCriterionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskAcceptanceCriterionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskAcceptanceCriterionResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskAcceptanceCriterionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskAcceptanceCriterionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskAcceptanceCriterionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  int position,  bool isAccepted,  String? acceptedByCoreUserId,  DateTime? acceptedAtUtc,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskAcceptanceCriterionResponse() when $default != null:
return $default(_that.id,_that.text,_that.position,_that.isAccepted,_that.acceptedByCoreUserId,_that.acceptedAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  int position,  bool isAccepted,  String? acceptedByCoreUserId,  DateTime? acceptedAtUtc,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskAcceptanceCriterionResponse():
return $default(_that.id,_that.text,_that.position,_that.isAccepted,_that.acceptedByCoreUserId,_that.acceptedAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  int position,  bool isAccepted,  String? acceptedByCoreUserId,  DateTime? acceptedAtUtc,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskAcceptanceCriterionResponse() when $default != null:
return $default(_that.id,_that.text,_that.position,_that.isAccepted,_that.acceptedByCoreUserId,_that.acceptedAtUtc,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskAcceptanceCriterionResponse implements TaskAcceptanceCriterionResponse {
  const _TaskAcceptanceCriterionResponse({required this.id, required this.text, required this.position, required this.isAccepted, this.acceptedByCoreUserId, this.acceptedAtUtc, required this.updatedAtUtc});
  factory _TaskAcceptanceCriterionResponse.fromJson(Map<String, dynamic> json) => _$TaskAcceptanceCriterionResponseFromJson(json);

@override final  String id;
@override final  String text;
@override final  int position;
@override final  bool isAccepted;
@override final  String? acceptedByCoreUserId;
@override final  DateTime? acceptedAtUtc;
@override final  DateTime updatedAtUtc;

/// Create a copy of TaskAcceptanceCriterionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskAcceptanceCriterionResponseCopyWith<_TaskAcceptanceCriterionResponse> get copyWith => __$TaskAcceptanceCriterionResponseCopyWithImpl<_TaskAcceptanceCriterionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskAcceptanceCriterionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskAcceptanceCriterionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.position, position) || other.position == position)&&(identical(other.isAccepted, isAccepted) || other.isAccepted == isAccepted)&&(identical(other.acceptedByCoreUserId, acceptedByCoreUserId) || other.acceptedByCoreUserId == acceptedByCoreUserId)&&(identical(other.acceptedAtUtc, acceptedAtUtc) || other.acceptedAtUtc == acceptedAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,position,isAccepted,acceptedByCoreUserId,acceptedAtUtc,updatedAtUtc);

@override
String toString() {
  return 'TaskAcceptanceCriterionResponse(id: $id, text: $text, position: $position, isAccepted: $isAccepted, acceptedByCoreUserId: $acceptedByCoreUserId, acceptedAtUtc: $acceptedAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskAcceptanceCriterionResponseCopyWith<$Res> implements $TaskAcceptanceCriterionResponseCopyWith<$Res> {
  factory _$TaskAcceptanceCriterionResponseCopyWith(_TaskAcceptanceCriterionResponse value, $Res Function(_TaskAcceptanceCriterionResponse) _then) = __$TaskAcceptanceCriterionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, int position, bool isAccepted, String? acceptedByCoreUserId, DateTime? acceptedAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class __$TaskAcceptanceCriterionResponseCopyWithImpl<$Res>
    implements _$TaskAcceptanceCriterionResponseCopyWith<$Res> {
  __$TaskAcceptanceCriterionResponseCopyWithImpl(this._self, this._then);

  final _TaskAcceptanceCriterionResponse _self;
  final $Res Function(_TaskAcceptanceCriterionResponse) _then;

/// Create a copy of TaskAcceptanceCriterionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? position = null,Object? isAccepted = null,Object? acceptedByCoreUserId = freezed,Object? acceptedAtUtc = freezed,Object? updatedAtUtc = null,}) {
  return _then(_TaskAcceptanceCriterionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isAccepted: null == isAccepted ? _self.isAccepted : isAccepted // ignore: cast_nullable_to_non_nullable
as bool,acceptedByCoreUserId: freezed == acceptedByCoreUserId ? _self.acceptedByCoreUserId : acceptedByCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,acceptedAtUtc: freezed == acceptedAtUtc ? _self.acceptedAtUtc : acceptedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskWatcherResponse {

 String get coreUserId; DateTime get createdAtUtc;
/// Create a copy of TaskWatcherResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskWatcherResponseCopyWith<TaskWatcherResponse> get copyWith => _$TaskWatcherResponseCopyWithImpl<TaskWatcherResponse>(this as TaskWatcherResponse, _$identity);

  /// Serializes this TaskWatcherResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskWatcherResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,createdAtUtc);

@override
String toString() {
  return 'TaskWatcherResponse(coreUserId: $coreUserId, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskWatcherResponseCopyWith<$Res>  {
  factory $TaskWatcherResponseCopyWith(TaskWatcherResponse value, $Res Function(TaskWatcherResponse) _then) = _$TaskWatcherResponseCopyWithImpl;
@useResult
$Res call({
 String coreUserId, DateTime createdAtUtc
});




}
/// @nodoc
class _$TaskWatcherResponseCopyWithImpl<$Res>
    implements $TaskWatcherResponseCopyWith<$Res> {
  _$TaskWatcherResponseCopyWithImpl(this._self, this._then);

  final TaskWatcherResponse _self;
  final $Res Function(TaskWatcherResponse) _then;

/// Create a copy of TaskWatcherResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coreUserId = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskWatcherResponse].
extension TaskWatcherResponsePatterns on TaskWatcherResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskWatcherResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskWatcherResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskWatcherResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskWatcherResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskWatcherResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskWatcherResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coreUserId,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskWatcherResponse() when $default != null:
return $default(_that.coreUserId,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coreUserId,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskWatcherResponse():
return $default(_that.coreUserId,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coreUserId,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskWatcherResponse() when $default != null:
return $default(_that.coreUserId,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskWatcherResponse implements TaskWatcherResponse {
  const _TaskWatcherResponse({required this.coreUserId, required this.createdAtUtc});
  factory _TaskWatcherResponse.fromJson(Map<String, dynamic> json) => _$TaskWatcherResponseFromJson(json);

@override final  String coreUserId;
@override final  DateTime createdAtUtc;

/// Create a copy of TaskWatcherResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskWatcherResponseCopyWith<_TaskWatcherResponse> get copyWith => __$TaskWatcherResponseCopyWithImpl<_TaskWatcherResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskWatcherResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskWatcherResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,createdAtUtc);

@override
String toString() {
  return 'TaskWatcherResponse(coreUserId: $coreUserId, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskWatcherResponseCopyWith<$Res> implements $TaskWatcherResponseCopyWith<$Res> {
  factory _$TaskWatcherResponseCopyWith(_TaskWatcherResponse value, $Res Function(_TaskWatcherResponse) _then) = __$TaskWatcherResponseCopyWithImpl;
@override @useResult
$Res call({
 String coreUserId, DateTime createdAtUtc
});




}
/// @nodoc
class __$TaskWatcherResponseCopyWithImpl<$Res>
    implements _$TaskWatcherResponseCopyWith<$Res> {
  __$TaskWatcherResponseCopyWithImpl(this._self, this._then);

  final _TaskWatcherResponse _self;
  final $Res Function(_TaskWatcherResponse) _then;

/// Create a copy of TaskWatcherResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coreUserId = null,Object? createdAtUtc = null,}) {
  return _then(_TaskWatcherResponse(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskMutationAcknowledgementResponse {

 bool get changed;
/// Create a copy of TaskMutationAcknowledgementResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskMutationAcknowledgementResponseCopyWith<TaskMutationAcknowledgementResponse> get copyWith => _$TaskMutationAcknowledgementResponseCopyWithImpl<TaskMutationAcknowledgementResponse>(this as TaskMutationAcknowledgementResponse, _$identity);

  /// Serializes this TaskMutationAcknowledgementResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskMutationAcknowledgementResponse&&(identical(other.changed, changed) || other.changed == changed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,changed);

@override
String toString() {
  return 'TaskMutationAcknowledgementResponse(changed: $changed)';
}


}

/// @nodoc
abstract mixin class $TaskMutationAcknowledgementResponseCopyWith<$Res>  {
  factory $TaskMutationAcknowledgementResponseCopyWith(TaskMutationAcknowledgementResponse value, $Res Function(TaskMutationAcknowledgementResponse) _then) = _$TaskMutationAcknowledgementResponseCopyWithImpl;
@useResult
$Res call({
 bool changed
});




}
/// @nodoc
class _$TaskMutationAcknowledgementResponseCopyWithImpl<$Res>
    implements $TaskMutationAcknowledgementResponseCopyWith<$Res> {
  _$TaskMutationAcknowledgementResponseCopyWithImpl(this._self, this._then);

  final TaskMutationAcknowledgementResponse _self;
  final $Res Function(TaskMutationAcknowledgementResponse) _then;

/// Create a copy of TaskMutationAcknowledgementResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? changed = null,}) {
  return _then(_self.copyWith(
changed: null == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskMutationAcknowledgementResponse].
extension TaskMutationAcknowledgementResponsePatterns on TaskMutationAcknowledgementResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskMutationAcknowledgementResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskMutationAcknowledgementResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskMutationAcknowledgementResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskMutationAcknowledgementResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskMutationAcknowledgementResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskMutationAcknowledgementResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool changed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskMutationAcknowledgementResponse() when $default != null:
return $default(_that.changed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool changed)  $default,) {final _that = this;
switch (_that) {
case _TaskMutationAcknowledgementResponse():
return $default(_that.changed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool changed)?  $default,) {final _that = this;
switch (_that) {
case _TaskMutationAcknowledgementResponse() when $default != null:
return $default(_that.changed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskMutationAcknowledgementResponse implements TaskMutationAcknowledgementResponse {
  const _TaskMutationAcknowledgementResponse({required this.changed});
  factory _TaskMutationAcknowledgementResponse.fromJson(Map<String, dynamic> json) => _$TaskMutationAcknowledgementResponseFromJson(json);

@override final  bool changed;

/// Create a copy of TaskMutationAcknowledgementResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskMutationAcknowledgementResponseCopyWith<_TaskMutationAcknowledgementResponse> get copyWith => __$TaskMutationAcknowledgementResponseCopyWithImpl<_TaskMutationAcknowledgementResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskMutationAcknowledgementResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskMutationAcknowledgementResponse&&(identical(other.changed, changed) || other.changed == changed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,changed);

@override
String toString() {
  return 'TaskMutationAcknowledgementResponse(changed: $changed)';
}


}

/// @nodoc
abstract mixin class _$TaskMutationAcknowledgementResponseCopyWith<$Res> implements $TaskMutationAcknowledgementResponseCopyWith<$Res> {
  factory _$TaskMutationAcknowledgementResponseCopyWith(_TaskMutationAcknowledgementResponse value, $Res Function(_TaskMutationAcknowledgementResponse) _then) = __$TaskMutationAcknowledgementResponseCopyWithImpl;
@override @useResult
$Res call({
 bool changed
});




}
/// @nodoc
class __$TaskMutationAcknowledgementResponseCopyWithImpl<$Res>
    implements _$TaskMutationAcknowledgementResponseCopyWith<$Res> {
  __$TaskMutationAcknowledgementResponseCopyWithImpl(this._self, this._then);

  final _TaskMutationAcknowledgementResponse _self;
  final $Res Function(_TaskMutationAcknowledgementResponse) _then;

/// Create a copy of TaskMutationAcknowledgementResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? changed = null,}) {
  return _then(_TaskMutationAcknowledgementResponse(
changed: null == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CreateTaskAcceptanceCriterionPayload {

 String get text; int get expectedVersion;
/// Create a copy of CreateTaskAcceptanceCriterionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskAcceptanceCriterionPayloadCopyWith<CreateTaskAcceptanceCriterionPayload> get copyWith => _$CreateTaskAcceptanceCriterionPayloadCopyWithImpl<CreateTaskAcceptanceCriterionPayload>(this as CreateTaskAcceptanceCriterionPayload, _$identity);

  /// Serializes this CreateTaskAcceptanceCriterionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskAcceptanceCriterionPayload&&(identical(other.text, text) || other.text == text)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,expectedVersion);

@override
String toString() {
  return 'CreateTaskAcceptanceCriterionPayload(text: $text, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $CreateTaskAcceptanceCriterionPayloadCopyWith<$Res>  {
  factory $CreateTaskAcceptanceCriterionPayloadCopyWith(CreateTaskAcceptanceCriterionPayload value, $Res Function(CreateTaskAcceptanceCriterionPayload) _then) = _$CreateTaskAcceptanceCriterionPayloadCopyWithImpl;
@useResult
$Res call({
 String text, int expectedVersion
});




}
/// @nodoc
class _$CreateTaskAcceptanceCriterionPayloadCopyWithImpl<$Res>
    implements $CreateTaskAcceptanceCriterionPayloadCopyWith<$Res> {
  _$CreateTaskAcceptanceCriterionPayloadCopyWithImpl(this._self, this._then);

  final CreateTaskAcceptanceCriterionPayload _self;
  final $Res Function(CreateTaskAcceptanceCriterionPayload) _then;

/// Create a copy of CreateTaskAcceptanceCriterionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskAcceptanceCriterionPayload].
extension CreateTaskAcceptanceCriterionPayloadPatterns on CreateTaskAcceptanceCriterionPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskAcceptanceCriterionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskAcceptanceCriterionPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskAcceptanceCriterionPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskAcceptanceCriterionPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskAcceptanceCriterionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskAcceptanceCriterionPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskAcceptanceCriterionPayload() when $default != null:
return $default(_that.text,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskAcceptanceCriterionPayload():
return $default(_that.text,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskAcceptanceCriterionPayload() when $default != null:
return $default(_that.text,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskAcceptanceCriterionPayload implements CreateTaskAcceptanceCriterionPayload {
  const _CreateTaskAcceptanceCriterionPayload({required this.text, required this.expectedVersion});
  factory _CreateTaskAcceptanceCriterionPayload.fromJson(Map<String, dynamic> json) => _$CreateTaskAcceptanceCriterionPayloadFromJson(json);

@override final  String text;
@override final  int expectedVersion;

/// Create a copy of CreateTaskAcceptanceCriterionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskAcceptanceCriterionPayloadCopyWith<_CreateTaskAcceptanceCriterionPayload> get copyWith => __$CreateTaskAcceptanceCriterionPayloadCopyWithImpl<_CreateTaskAcceptanceCriterionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskAcceptanceCriterionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskAcceptanceCriterionPayload&&(identical(other.text, text) || other.text == text)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,expectedVersion);

@override
String toString() {
  return 'CreateTaskAcceptanceCriterionPayload(text: $text, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskAcceptanceCriterionPayloadCopyWith<$Res> implements $CreateTaskAcceptanceCriterionPayloadCopyWith<$Res> {
  factory _$CreateTaskAcceptanceCriterionPayloadCopyWith(_CreateTaskAcceptanceCriterionPayload value, $Res Function(_CreateTaskAcceptanceCriterionPayload) _then) = __$CreateTaskAcceptanceCriterionPayloadCopyWithImpl;
@override @useResult
$Res call({
 String text, int expectedVersion
});




}
/// @nodoc
class __$CreateTaskAcceptanceCriterionPayloadCopyWithImpl<$Res>
    implements _$CreateTaskAcceptanceCriterionPayloadCopyWith<$Res> {
  __$CreateTaskAcceptanceCriterionPayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskAcceptanceCriterionPayload _self;
  final $Res Function(_CreateTaskAcceptanceCriterionPayload) _then;

/// Create a copy of CreateTaskAcceptanceCriterionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? expectedVersion = null,}) {
  return _then(_CreateTaskAcceptanceCriterionPayload(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskAcceptanceCriterionPayload {

 String get text; int get position; bool get isAccepted; int get expectedVersion;
/// Create a copy of UpdateTaskAcceptanceCriterionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskAcceptanceCriterionPayloadCopyWith<UpdateTaskAcceptanceCriterionPayload> get copyWith => _$UpdateTaskAcceptanceCriterionPayloadCopyWithImpl<UpdateTaskAcceptanceCriterionPayload>(this as UpdateTaskAcceptanceCriterionPayload, _$identity);

  /// Serializes this UpdateTaskAcceptanceCriterionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskAcceptanceCriterionPayload&&(identical(other.text, text) || other.text == text)&&(identical(other.position, position) || other.position == position)&&(identical(other.isAccepted, isAccepted) || other.isAccepted == isAccepted)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,position,isAccepted,expectedVersion);

@override
String toString() {
  return 'UpdateTaskAcceptanceCriterionPayload(text: $text, position: $position, isAccepted: $isAccepted, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskAcceptanceCriterionPayloadCopyWith<$Res>  {
  factory $UpdateTaskAcceptanceCriterionPayloadCopyWith(UpdateTaskAcceptanceCriterionPayload value, $Res Function(UpdateTaskAcceptanceCriterionPayload) _then) = _$UpdateTaskAcceptanceCriterionPayloadCopyWithImpl;
@useResult
$Res call({
 String text, int position, bool isAccepted, int expectedVersion
});




}
/// @nodoc
class _$UpdateTaskAcceptanceCriterionPayloadCopyWithImpl<$Res>
    implements $UpdateTaskAcceptanceCriterionPayloadCopyWith<$Res> {
  _$UpdateTaskAcceptanceCriterionPayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskAcceptanceCriterionPayload _self;
  final $Res Function(UpdateTaskAcceptanceCriterionPayload) _then;

/// Create a copy of UpdateTaskAcceptanceCriterionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? position = null,Object? isAccepted = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isAccepted: null == isAccepted ? _self.isAccepted : isAccepted // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskAcceptanceCriterionPayload].
extension UpdateTaskAcceptanceCriterionPayloadPatterns on UpdateTaskAcceptanceCriterionPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskAcceptanceCriterionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskAcceptanceCriterionPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskAcceptanceCriterionPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskAcceptanceCriterionPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskAcceptanceCriterionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskAcceptanceCriterionPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  int position,  bool isAccepted,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskAcceptanceCriterionPayload() when $default != null:
return $default(_that.text,_that.position,_that.isAccepted,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  int position,  bool isAccepted,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskAcceptanceCriterionPayload():
return $default(_that.text,_that.position,_that.isAccepted,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  int position,  bool isAccepted,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskAcceptanceCriterionPayload() when $default != null:
return $default(_that.text,_that.position,_that.isAccepted,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskAcceptanceCriterionPayload implements UpdateTaskAcceptanceCriterionPayload {
  const _UpdateTaskAcceptanceCriterionPayload({required this.text, required this.position, required this.isAccepted, required this.expectedVersion});
  factory _UpdateTaskAcceptanceCriterionPayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskAcceptanceCriterionPayloadFromJson(json);

@override final  String text;
@override final  int position;
@override final  bool isAccepted;
@override final  int expectedVersion;

/// Create a copy of UpdateTaskAcceptanceCriterionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskAcceptanceCriterionPayloadCopyWith<_UpdateTaskAcceptanceCriterionPayload> get copyWith => __$UpdateTaskAcceptanceCriterionPayloadCopyWithImpl<_UpdateTaskAcceptanceCriterionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskAcceptanceCriterionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskAcceptanceCriterionPayload&&(identical(other.text, text) || other.text == text)&&(identical(other.position, position) || other.position == position)&&(identical(other.isAccepted, isAccepted) || other.isAccepted == isAccepted)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,position,isAccepted,expectedVersion);

@override
String toString() {
  return 'UpdateTaskAcceptanceCriterionPayload(text: $text, position: $position, isAccepted: $isAccepted, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskAcceptanceCriterionPayloadCopyWith<$Res> implements $UpdateTaskAcceptanceCriterionPayloadCopyWith<$Res> {
  factory _$UpdateTaskAcceptanceCriterionPayloadCopyWith(_UpdateTaskAcceptanceCriterionPayload value, $Res Function(_UpdateTaskAcceptanceCriterionPayload) _then) = __$UpdateTaskAcceptanceCriterionPayloadCopyWithImpl;
@override @useResult
$Res call({
 String text, int position, bool isAccepted, int expectedVersion
});




}
/// @nodoc
class __$UpdateTaskAcceptanceCriterionPayloadCopyWithImpl<$Res>
    implements _$UpdateTaskAcceptanceCriterionPayloadCopyWith<$Res> {
  __$UpdateTaskAcceptanceCriterionPayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskAcceptanceCriterionPayload _self;
  final $Res Function(_UpdateTaskAcceptanceCriterionPayload) _then;

/// Create a copy of UpdateTaskAcceptanceCriterionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? position = null,Object? isAccepted = null,Object? expectedVersion = null,}) {
  return _then(_UpdateTaskAcceptanceCriterionPayload(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isAccepted: null == isAccepted ? _self.isAccepted : isAccepted // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskUserPreferencePayload {

 bool get isPinned;
/// Create a copy of UpdateTaskUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskUserPreferencePayloadCopyWith<UpdateTaskUserPreferencePayload> get copyWith => _$UpdateTaskUserPreferencePayloadCopyWithImpl<UpdateTaskUserPreferencePayload>(this as UpdateTaskUserPreferencePayload, _$identity);

  /// Serializes this UpdateTaskUserPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskUserPreferencePayload&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPinned);

@override
String toString() {
  return 'UpdateTaskUserPreferencePayload(isPinned: $isPinned)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskUserPreferencePayloadCopyWith<$Res>  {
  factory $UpdateTaskUserPreferencePayloadCopyWith(UpdateTaskUserPreferencePayload value, $Res Function(UpdateTaskUserPreferencePayload) _then) = _$UpdateTaskUserPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 bool isPinned
});




}
/// @nodoc
class _$UpdateTaskUserPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateTaskUserPreferencePayloadCopyWith<$Res> {
  _$UpdateTaskUserPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskUserPreferencePayload _self;
  final $Res Function(UpdateTaskUserPreferencePayload) _then;

/// Create a copy of UpdateTaskUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPinned = null,}) {
  return _then(_self.copyWith(
isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskUserPreferencePayload].
extension UpdateTaskUserPreferencePayloadPatterns on UpdateTaskUserPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskUserPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskUserPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskUserPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskUserPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskUserPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskUserPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPinned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskUserPreferencePayload() when $default != null:
return $default(_that.isPinned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPinned)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskUserPreferencePayload():
return $default(_that.isPinned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPinned)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskUserPreferencePayload() when $default != null:
return $default(_that.isPinned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskUserPreferencePayload implements UpdateTaskUserPreferencePayload {
  const _UpdateTaskUserPreferencePayload({required this.isPinned});
  factory _UpdateTaskUserPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskUserPreferencePayloadFromJson(json);

@override final  bool isPinned;

/// Create a copy of UpdateTaskUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskUserPreferencePayloadCopyWith<_UpdateTaskUserPreferencePayload> get copyWith => __$UpdateTaskUserPreferencePayloadCopyWithImpl<_UpdateTaskUserPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskUserPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskUserPreferencePayload&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPinned);

@override
String toString() {
  return 'UpdateTaskUserPreferencePayload(isPinned: $isPinned)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskUserPreferencePayloadCopyWith<$Res> implements $UpdateTaskUserPreferencePayloadCopyWith<$Res> {
  factory _$UpdateTaskUserPreferencePayloadCopyWith(_UpdateTaskUserPreferencePayload value, $Res Function(_UpdateTaskUserPreferencePayload) _then) = __$UpdateTaskUserPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 bool isPinned
});




}
/// @nodoc
class __$UpdateTaskUserPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateTaskUserPreferencePayloadCopyWith<$Res> {
  __$UpdateTaskUserPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskUserPreferencePayload _self;
  final $Res Function(_UpdateTaskUserPreferencePayload) _then;

/// Create a copy of UpdateTaskUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPinned = null,}) {
  return _then(_UpdateTaskUserPreferencePayload(
isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskDetailsResponse {

 ProjectTaskResponse get task; List<TaskLabelResponse> get labels; List<TaskCustomFieldDefinitionValueResponse> get customFields; List<TaskAcceptanceCriterionResponse> get acceptanceCriteria; List<TaskDependencyDetailsResponse> get dependencies; List<TaskWatcherResponse> get watchers; bool get isWatchedByMe; bool get isPinnedByMe; List<ProjectTaskSubtaskSummaryResponse> get subtasks; ProjectTaskWorkflowResponse get workflow; List<UserReferenceResponse> get includedUsers;
/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskDetailsResponseCopyWith<ProjectTaskDetailsResponse> get copyWith => _$ProjectTaskDetailsResponseCopyWithImpl<ProjectTaskDetailsResponse>(this as ProjectTaskDetailsResponse, _$identity);

  /// Serializes this ProjectTaskDetailsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskDetailsResponse&&(identical(other.task, task) || other.task == task)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&const DeepCollectionEquality().equals(other.watchers, watchers)&&(identical(other.isWatchedByMe, isWatchedByMe) || other.isWatchedByMe == isWatchedByMe)&&(identical(other.isPinnedByMe, isPinnedByMe) || other.isPinnedByMe == isPinnedByMe)&&const DeepCollectionEquality().equals(other.subtasks, subtasks)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&const DeepCollectionEquality().equals(other.includedUsers, includedUsers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFields),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(dependencies),const DeepCollectionEquality().hash(watchers),isWatchedByMe,isPinnedByMe,const DeepCollectionEquality().hash(subtasks),workflow,const DeepCollectionEquality().hash(includedUsers));

@override
String toString() {
  return 'ProjectTaskDetailsResponse(task: $task, labels: $labels, customFields: $customFields, acceptanceCriteria: $acceptanceCriteria, dependencies: $dependencies, watchers: $watchers, isWatchedByMe: $isWatchedByMe, isPinnedByMe: $isPinnedByMe, subtasks: $subtasks, workflow: $workflow, includedUsers: $includedUsers)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskDetailsResponseCopyWith<$Res>  {
  factory $ProjectTaskDetailsResponseCopyWith(ProjectTaskDetailsResponse value, $Res Function(ProjectTaskDetailsResponse) _then) = _$ProjectTaskDetailsResponseCopyWithImpl;
@useResult
$Res call({
 ProjectTaskResponse task, List<TaskLabelResponse> labels, List<TaskCustomFieldDefinitionValueResponse> customFields, List<TaskAcceptanceCriterionResponse> acceptanceCriteria, List<TaskDependencyDetailsResponse> dependencies, List<TaskWatcherResponse> watchers, bool isWatchedByMe, bool isPinnedByMe, List<ProjectTaskSubtaskSummaryResponse> subtasks, ProjectTaskWorkflowResponse workflow, List<UserReferenceResponse> includedUsers
});


$ProjectTaskResponseCopyWith<$Res> get task;$ProjectTaskWorkflowResponseCopyWith<$Res> get workflow;

}
/// @nodoc
class _$ProjectTaskDetailsResponseCopyWithImpl<$Res>
    implements $ProjectTaskDetailsResponseCopyWith<$Res> {
  _$ProjectTaskDetailsResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskDetailsResponse _self;
  final $Res Function(ProjectTaskDetailsResponse) _then;

/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? labels = null,Object? customFields = null,Object? acceptanceCriteria = null,Object? dependencies = null,Object? watchers = null,Object? isWatchedByMe = null,Object? isPinnedByMe = null,Object? subtasks = null,Object? workflow = null,Object? includedUsers = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as ProjectTaskResponse,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskLabelResponse>,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<TaskCustomFieldDefinitionValueResponse>,acceptanceCriteria: null == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<TaskAcceptanceCriterionResponse>,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<TaskDependencyDetailsResponse>,watchers: null == watchers ? _self.watchers : watchers // ignore: cast_nullable_to_non_nullable
as List<TaskWatcherResponse>,isWatchedByMe: null == isWatchedByMe ? _self.isWatchedByMe : isWatchedByMe // ignore: cast_nullable_to_non_nullable
as bool,isPinnedByMe: null == isPinnedByMe ? _self.isPinnedByMe : isPinnedByMe // ignore: cast_nullable_to_non_nullable
as bool,subtasks: null == subtasks ? _self.subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskSubtaskSummaryResponse>,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as ProjectTaskWorkflowResponse,includedUsers: null == includedUsers ? _self.includedUsers : includedUsers // ignore: cast_nullable_to_non_nullable
as List<UserReferenceResponse>,
  ));
}
/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskResponseCopyWith<$Res> get task {
  
  return $ProjectTaskResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskWorkflowResponseCopyWith<$Res> get workflow {
  
  return $ProjectTaskWorkflowResponseCopyWith<$Res>(_self.workflow, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectTaskDetailsResponse].
extension ProjectTaskDetailsResponsePatterns on ProjectTaskDetailsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskDetailsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskDetailsResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskDetailsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskDetailsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectTaskResponse task,  List<TaskLabelResponse> labels,  List<TaskCustomFieldDefinitionValueResponse> customFields,  List<TaskAcceptanceCriterionResponse> acceptanceCriteria,  List<TaskDependencyDetailsResponse> dependencies,  List<TaskWatcherResponse> watchers,  bool isWatchedByMe,  bool isPinnedByMe,  List<ProjectTaskSubtaskSummaryResponse> subtasks,  ProjectTaskWorkflowResponse workflow,  List<UserReferenceResponse> includedUsers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskDetailsResponse() when $default != null:
return $default(_that.task,_that.labels,_that.customFields,_that.acceptanceCriteria,_that.dependencies,_that.watchers,_that.isWatchedByMe,_that.isPinnedByMe,_that.subtasks,_that.workflow,_that.includedUsers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectTaskResponse task,  List<TaskLabelResponse> labels,  List<TaskCustomFieldDefinitionValueResponse> customFields,  List<TaskAcceptanceCriterionResponse> acceptanceCriteria,  List<TaskDependencyDetailsResponse> dependencies,  List<TaskWatcherResponse> watchers,  bool isWatchedByMe,  bool isPinnedByMe,  List<ProjectTaskSubtaskSummaryResponse> subtasks,  ProjectTaskWorkflowResponse workflow,  List<UserReferenceResponse> includedUsers)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskDetailsResponse():
return $default(_that.task,_that.labels,_that.customFields,_that.acceptanceCriteria,_that.dependencies,_that.watchers,_that.isWatchedByMe,_that.isPinnedByMe,_that.subtasks,_that.workflow,_that.includedUsers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectTaskResponse task,  List<TaskLabelResponse> labels,  List<TaskCustomFieldDefinitionValueResponse> customFields,  List<TaskAcceptanceCriterionResponse> acceptanceCriteria,  List<TaskDependencyDetailsResponse> dependencies,  List<TaskWatcherResponse> watchers,  bool isWatchedByMe,  bool isPinnedByMe,  List<ProjectTaskSubtaskSummaryResponse> subtasks,  ProjectTaskWorkflowResponse workflow,  List<UserReferenceResponse> includedUsers)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskDetailsResponse() when $default != null:
return $default(_that.task,_that.labels,_that.customFields,_that.acceptanceCriteria,_that.dependencies,_that.watchers,_that.isWatchedByMe,_that.isPinnedByMe,_that.subtasks,_that.workflow,_that.includedUsers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskDetailsResponse implements ProjectTaskDetailsResponse {
  const _ProjectTaskDetailsResponse({required this.task, required this.labels, required this.customFields, required this.acceptanceCriteria, required this.dependencies, required this.watchers, required this.isWatchedByMe, required this.isPinnedByMe, required this.subtasks, required this.workflow, required this.includedUsers});
  factory _ProjectTaskDetailsResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskDetailsResponseFromJson(json);

@override final  ProjectTaskResponse task;
@override final  List<TaskLabelResponse> labels;
@override final  List<TaskCustomFieldDefinitionValueResponse> customFields;
@override final  List<TaskAcceptanceCriterionResponse> acceptanceCriteria;
@override final  List<TaskDependencyDetailsResponse> dependencies;
@override final  List<TaskWatcherResponse> watchers;
@override final  bool isWatchedByMe;
@override final  bool isPinnedByMe;
@override final  List<ProjectTaskSubtaskSummaryResponse> subtasks;
@override final  ProjectTaskWorkflowResponse workflow;
@override final  List<UserReferenceResponse> includedUsers;

/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskDetailsResponseCopyWith<_ProjectTaskDetailsResponse> get copyWith => __$ProjectTaskDetailsResponseCopyWithImpl<_ProjectTaskDetailsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskDetailsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskDetailsResponse&&(identical(other.task, task) || other.task == task)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&const DeepCollectionEquality().equals(other.watchers, watchers)&&(identical(other.isWatchedByMe, isWatchedByMe) || other.isWatchedByMe == isWatchedByMe)&&(identical(other.isPinnedByMe, isPinnedByMe) || other.isPinnedByMe == isPinnedByMe)&&const DeepCollectionEquality().equals(other.subtasks, subtasks)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&const DeepCollectionEquality().equals(other.includedUsers, includedUsers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFields),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(dependencies),const DeepCollectionEquality().hash(watchers),isWatchedByMe,isPinnedByMe,const DeepCollectionEquality().hash(subtasks),workflow,const DeepCollectionEquality().hash(includedUsers));

@override
String toString() {
  return 'ProjectTaskDetailsResponse(task: $task, labels: $labels, customFields: $customFields, acceptanceCriteria: $acceptanceCriteria, dependencies: $dependencies, watchers: $watchers, isWatchedByMe: $isWatchedByMe, isPinnedByMe: $isPinnedByMe, subtasks: $subtasks, workflow: $workflow, includedUsers: $includedUsers)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskDetailsResponseCopyWith<$Res> implements $ProjectTaskDetailsResponseCopyWith<$Res> {
  factory _$ProjectTaskDetailsResponseCopyWith(_ProjectTaskDetailsResponse value, $Res Function(_ProjectTaskDetailsResponse) _then) = __$ProjectTaskDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectTaskResponse task, List<TaskLabelResponse> labels, List<TaskCustomFieldDefinitionValueResponse> customFields, List<TaskAcceptanceCriterionResponse> acceptanceCriteria, List<TaskDependencyDetailsResponse> dependencies, List<TaskWatcherResponse> watchers, bool isWatchedByMe, bool isPinnedByMe, List<ProjectTaskSubtaskSummaryResponse> subtasks, ProjectTaskWorkflowResponse workflow, List<UserReferenceResponse> includedUsers
});


@override $ProjectTaskResponseCopyWith<$Res> get task;@override $ProjectTaskWorkflowResponseCopyWith<$Res> get workflow;

}
/// @nodoc
class __$ProjectTaskDetailsResponseCopyWithImpl<$Res>
    implements _$ProjectTaskDetailsResponseCopyWith<$Res> {
  __$ProjectTaskDetailsResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskDetailsResponse _self;
  final $Res Function(_ProjectTaskDetailsResponse) _then;

/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? labels = null,Object? customFields = null,Object? acceptanceCriteria = null,Object? dependencies = null,Object? watchers = null,Object? isWatchedByMe = null,Object? isPinnedByMe = null,Object? subtasks = null,Object? workflow = null,Object? includedUsers = null,}) {
  return _then(_ProjectTaskDetailsResponse(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as ProjectTaskResponse,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskLabelResponse>,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<TaskCustomFieldDefinitionValueResponse>,acceptanceCriteria: null == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<TaskAcceptanceCriterionResponse>,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<TaskDependencyDetailsResponse>,watchers: null == watchers ? _self.watchers : watchers // ignore: cast_nullable_to_non_nullable
as List<TaskWatcherResponse>,isWatchedByMe: null == isWatchedByMe ? _self.isWatchedByMe : isWatchedByMe // ignore: cast_nullable_to_non_nullable
as bool,isPinnedByMe: null == isPinnedByMe ? _self.isPinnedByMe : isPinnedByMe // ignore: cast_nullable_to_non_nullable
as bool,subtasks: null == subtasks ? _self.subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskSubtaskSummaryResponse>,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as ProjectTaskWorkflowResponse,includedUsers: null == includedUsers ? _self.includedUsers : includedUsers // ignore: cast_nullable_to_non_nullable
as List<UserReferenceResponse>,
  ));
}

/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskResponseCopyWith<$Res> get task {
  
  return $ProjectTaskResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskWorkflowResponseCopyWith<$Res> get workflow {
  
  return $ProjectTaskWorkflowResponseCopyWith<$Res>(_self.workflow, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}
}


/// @nodoc
mixin _$UserReferenceResponse {

 String get coreUserId; String? get displayName; String? get avatarUrl; bool get isActive;
/// Create a copy of UserReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserReferenceResponseCopyWith<UserReferenceResponse> get copyWith => _$UserReferenceResponseCopyWithImpl<UserReferenceResponse>(this as UserReferenceResponse, _$identity);

  /// Serializes this UserReferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserReferenceResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,displayName,avatarUrl,isActive);

@override
String toString() {
  return 'UserReferenceResponse(coreUserId: $coreUserId, displayName: $displayName, avatarUrl: $avatarUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $UserReferenceResponseCopyWith<$Res>  {
  factory $UserReferenceResponseCopyWith(UserReferenceResponse value, $Res Function(UserReferenceResponse) _then) = _$UserReferenceResponseCopyWithImpl;
@useResult
$Res call({
 String coreUserId, String? displayName, String? avatarUrl, bool isActive
});




}
/// @nodoc
class _$UserReferenceResponseCopyWithImpl<$Res>
    implements $UserReferenceResponseCopyWith<$Res> {
  _$UserReferenceResponseCopyWithImpl(this._self, this._then);

  final UserReferenceResponse _self;
  final $Res Function(UserReferenceResponse) _then;

/// Create a copy of UserReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coreUserId = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserReferenceResponse].
extension UserReferenceResponsePatterns on UserReferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserReferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserReferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserReferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _UserReferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserReferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UserReferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coreUserId,  String? displayName,  String? avatarUrl,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserReferenceResponse() when $default != null:
return $default(_that.coreUserId,_that.displayName,_that.avatarUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coreUserId,  String? displayName,  String? avatarUrl,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _UserReferenceResponse():
return $default(_that.coreUserId,_that.displayName,_that.avatarUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coreUserId,  String? displayName,  String? avatarUrl,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _UserReferenceResponse() when $default != null:
return $default(_that.coreUserId,_that.displayName,_that.avatarUrl,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserReferenceResponse implements UserReferenceResponse {
  const _UserReferenceResponse({required this.coreUserId, this.displayName, this.avatarUrl, required this.isActive});
  factory _UserReferenceResponse.fromJson(Map<String, dynamic> json) => _$UserReferenceResponseFromJson(json);

@override final  String coreUserId;
@override final  String? displayName;
@override final  String? avatarUrl;
@override final  bool isActive;

/// Create a copy of UserReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserReferenceResponseCopyWith<_UserReferenceResponse> get copyWith => __$UserReferenceResponseCopyWithImpl<_UserReferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserReferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserReferenceResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,displayName,avatarUrl,isActive);

@override
String toString() {
  return 'UserReferenceResponse(coreUserId: $coreUserId, displayName: $displayName, avatarUrl: $avatarUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UserReferenceResponseCopyWith<$Res> implements $UserReferenceResponseCopyWith<$Res> {
  factory _$UserReferenceResponseCopyWith(_UserReferenceResponse value, $Res Function(_UserReferenceResponse) _then) = __$UserReferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String coreUserId, String? displayName, String? avatarUrl, bool isActive
});




}
/// @nodoc
class __$UserReferenceResponseCopyWithImpl<$Res>
    implements _$UserReferenceResponseCopyWith<$Res> {
  __$UserReferenceResponseCopyWithImpl(this._self, this._then);

  final _UserReferenceResponse _self;
  final $Res Function(_UserReferenceResponse) _then;

/// Create a copy of UserReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coreUserId = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? isActive = null,}) {
  return _then(_UserReferenceResponse(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TaskCustomFieldDefinitionValueResponse {

 String get id; String get name; TaskCustomFieldType get type;@JsonKey(name: 'required') bool get isRequired; int get position; List<String>? get options; Object? get value; DateTime? get valueUpdatedAtUtc;
/// Create a copy of TaskCustomFieldDefinitionValueResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCustomFieldDefinitionValueResponseCopyWith<TaskCustomFieldDefinitionValueResponse> get copyWith => _$TaskCustomFieldDefinitionValueResponseCopyWithImpl<TaskCustomFieldDefinitionValueResponse>(this as TaskCustomFieldDefinitionValueResponse, _$identity);

  /// Serializes this TaskCustomFieldDefinitionValueResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskCustomFieldDefinitionValueResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.valueUpdatedAtUtc, valueUpdatedAtUtc) || other.valueUpdatedAtUtc == valueUpdatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,isRequired,position,const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(value),valueUpdatedAtUtc);

@override
String toString() {
  return 'TaskCustomFieldDefinitionValueResponse(id: $id, name: $name, type: $type, isRequired: $isRequired, position: $position, options: $options, value: $value, valueUpdatedAtUtc: $valueUpdatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskCustomFieldDefinitionValueResponseCopyWith<$Res>  {
  factory $TaskCustomFieldDefinitionValueResponseCopyWith(TaskCustomFieldDefinitionValueResponse value, $Res Function(TaskCustomFieldDefinitionValueResponse) _then) = _$TaskCustomFieldDefinitionValueResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, TaskCustomFieldType type,@JsonKey(name: 'required') bool isRequired, int position, List<String>? options, Object? value, DateTime? valueUpdatedAtUtc
});




}
/// @nodoc
class _$TaskCustomFieldDefinitionValueResponseCopyWithImpl<$Res>
    implements $TaskCustomFieldDefinitionValueResponseCopyWith<$Res> {
  _$TaskCustomFieldDefinitionValueResponseCopyWithImpl(this._self, this._then);

  final TaskCustomFieldDefinitionValueResponse _self;
  final $Res Function(TaskCustomFieldDefinitionValueResponse) _then;

/// Create a copy of TaskCustomFieldDefinitionValueResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? isRequired = null,Object? position = null,Object? options = freezed,Object? value = freezed,Object? valueUpdatedAtUtc = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskCustomFieldType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,value: freezed == value ? _self.value : value ,valueUpdatedAtUtc: freezed == valueUpdatedAtUtc ? _self.valueUpdatedAtUtc : valueUpdatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskCustomFieldDefinitionValueResponse].
extension TaskCustomFieldDefinitionValueResponsePatterns on TaskCustomFieldDefinitionValueResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskCustomFieldDefinitionValueResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskCustomFieldDefinitionValueResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskCustomFieldDefinitionValueResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskCustomFieldDefinitionValueResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskCustomFieldDefinitionValueResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskCustomFieldDefinitionValueResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  TaskCustomFieldType type, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options,  Object? value,  DateTime? valueUpdatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskCustomFieldDefinitionValueResponse() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isRequired,_that.position,_that.options,_that.value,_that.valueUpdatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  TaskCustomFieldType type, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options,  Object? value,  DateTime? valueUpdatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskCustomFieldDefinitionValueResponse():
return $default(_that.id,_that.name,_that.type,_that.isRequired,_that.position,_that.options,_that.value,_that.valueUpdatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  TaskCustomFieldType type, @JsonKey(name: 'required')  bool isRequired,  int position,  List<String>? options,  Object? value,  DateTime? valueUpdatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskCustomFieldDefinitionValueResponse() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isRequired,_that.position,_that.options,_that.value,_that.valueUpdatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskCustomFieldDefinitionValueResponse implements TaskCustomFieldDefinitionValueResponse {
  const _TaskCustomFieldDefinitionValueResponse({required this.id, required this.name, required this.type, @JsonKey(name: 'required') required this.isRequired, required this.position, this.options, this.value, this.valueUpdatedAtUtc});
  factory _TaskCustomFieldDefinitionValueResponse.fromJson(Map<String, dynamic> json) => _$TaskCustomFieldDefinitionValueResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  TaskCustomFieldType type;
@override@JsonKey(name: 'required') final  bool isRequired;
@override final  int position;
@override final  List<String>? options;
@override final  Object? value;
@override final  DateTime? valueUpdatedAtUtc;

/// Create a copy of TaskCustomFieldDefinitionValueResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCustomFieldDefinitionValueResponseCopyWith<_TaskCustomFieldDefinitionValueResponse> get copyWith => __$TaskCustomFieldDefinitionValueResponseCopyWithImpl<_TaskCustomFieldDefinitionValueResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskCustomFieldDefinitionValueResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskCustomFieldDefinitionValueResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.valueUpdatedAtUtc, valueUpdatedAtUtc) || other.valueUpdatedAtUtc == valueUpdatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,isRequired,position,const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(value),valueUpdatedAtUtc);

@override
String toString() {
  return 'TaskCustomFieldDefinitionValueResponse(id: $id, name: $name, type: $type, isRequired: $isRequired, position: $position, options: $options, value: $value, valueUpdatedAtUtc: $valueUpdatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskCustomFieldDefinitionValueResponseCopyWith<$Res> implements $TaskCustomFieldDefinitionValueResponseCopyWith<$Res> {
  factory _$TaskCustomFieldDefinitionValueResponseCopyWith(_TaskCustomFieldDefinitionValueResponse value, $Res Function(_TaskCustomFieldDefinitionValueResponse) _then) = __$TaskCustomFieldDefinitionValueResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, TaskCustomFieldType type,@JsonKey(name: 'required') bool isRequired, int position, List<String>? options, Object? value, DateTime? valueUpdatedAtUtc
});




}
/// @nodoc
class __$TaskCustomFieldDefinitionValueResponseCopyWithImpl<$Res>
    implements _$TaskCustomFieldDefinitionValueResponseCopyWith<$Res> {
  __$TaskCustomFieldDefinitionValueResponseCopyWithImpl(this._self, this._then);

  final _TaskCustomFieldDefinitionValueResponse _self;
  final $Res Function(_TaskCustomFieldDefinitionValueResponse) _then;

/// Create a copy of TaskCustomFieldDefinitionValueResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? isRequired = null,Object? position = null,Object? options = freezed,Object? value = freezed,Object? valueUpdatedAtUtc = freezed,}) {
  return _then(_TaskCustomFieldDefinitionValueResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskCustomFieldType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,value: freezed == value ? _self.value : value ,valueUpdatedAtUtc: freezed == valueUpdatedAtUtc ? _self.valueUpdatedAtUtc : valueUpdatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TaskDependencyDetailsResponse {

 String get id; String get sourceTaskId; String get targetTaskId; TaskDependencyType get type; DateTime get createdAtUtc; ProjectTaskReferenceResponse get relatedTask; TaskDependencyKind get dependencyKind; int get lagDays;
/// Create a copy of TaskDependencyDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDependencyDetailsResponseCopyWith<TaskDependencyDetailsResponse> get copyWith => _$TaskDependencyDetailsResponseCopyWithImpl<TaskDependencyDetailsResponse>(this as TaskDependencyDetailsResponse, _$identity);

  /// Serializes this TaskDependencyDetailsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDependencyDetailsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.targetTaskId, targetTaskId) || other.targetTaskId == targetTaskId)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.relatedTask, relatedTask) || other.relatedTask == relatedTask)&&(identical(other.dependencyKind, dependencyKind) || other.dependencyKind == dependencyKind)&&(identical(other.lagDays, lagDays) || other.lagDays == lagDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceTaskId,targetTaskId,type,createdAtUtc,relatedTask,dependencyKind,lagDays);

@override
String toString() {
  return 'TaskDependencyDetailsResponse(id: $id, sourceTaskId: $sourceTaskId, targetTaskId: $targetTaskId, type: $type, createdAtUtc: $createdAtUtc, relatedTask: $relatedTask, dependencyKind: $dependencyKind, lagDays: $lagDays)';
}


}

/// @nodoc
abstract mixin class $TaskDependencyDetailsResponseCopyWith<$Res>  {
  factory $TaskDependencyDetailsResponseCopyWith(TaskDependencyDetailsResponse value, $Res Function(TaskDependencyDetailsResponse) _then) = _$TaskDependencyDetailsResponseCopyWithImpl;
@useResult
$Res call({
 String id, String sourceTaskId, String targetTaskId, TaskDependencyType type, DateTime createdAtUtc, ProjectTaskReferenceResponse relatedTask, TaskDependencyKind dependencyKind, int lagDays
});


$ProjectTaskReferenceResponseCopyWith<$Res> get relatedTask;

}
/// @nodoc
class _$TaskDependencyDetailsResponseCopyWithImpl<$Res>
    implements $TaskDependencyDetailsResponseCopyWith<$Res> {
  _$TaskDependencyDetailsResponseCopyWithImpl(this._self, this._then);

  final TaskDependencyDetailsResponse _self;
  final $Res Function(TaskDependencyDetailsResponse) _then;

/// Create a copy of TaskDependencyDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceTaskId = null,Object? targetTaskId = null,Object? type = null,Object? createdAtUtc = null,Object? relatedTask = null,Object? dependencyKind = null,Object? lagDays = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,targetTaskId: null == targetTaskId ? _self.targetTaskId : targetTaskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskDependencyType,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,relatedTask: null == relatedTask ? _self.relatedTask : relatedTask // ignore: cast_nullable_to_non_nullable
as ProjectTaskReferenceResponse,dependencyKind: null == dependencyKind ? _self.dependencyKind : dependencyKind // ignore: cast_nullable_to_non_nullable
as TaskDependencyKind,lagDays: null == lagDays ? _self.lagDays : lagDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TaskDependencyDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskReferenceResponseCopyWith<$Res> get relatedTask {
  
  return $ProjectTaskReferenceResponseCopyWith<$Res>(_self.relatedTask, (value) {
    return _then(_self.copyWith(relatedTask: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskDependencyDetailsResponse].
extension TaskDependencyDetailsResponsePatterns on TaskDependencyDetailsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskDependencyDetailsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskDependencyDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskDependencyDetailsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskDependencyDetailsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskDependencyDetailsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskDependencyDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceTaskId,  String targetTaskId,  TaskDependencyType type,  DateTime createdAtUtc,  ProjectTaskReferenceResponse relatedTask,  TaskDependencyKind dependencyKind,  int lagDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskDependencyDetailsResponse() when $default != null:
return $default(_that.id,_that.sourceTaskId,_that.targetTaskId,_that.type,_that.createdAtUtc,_that.relatedTask,_that.dependencyKind,_that.lagDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceTaskId,  String targetTaskId,  TaskDependencyType type,  DateTime createdAtUtc,  ProjectTaskReferenceResponse relatedTask,  TaskDependencyKind dependencyKind,  int lagDays)  $default,) {final _that = this;
switch (_that) {
case _TaskDependencyDetailsResponse():
return $default(_that.id,_that.sourceTaskId,_that.targetTaskId,_that.type,_that.createdAtUtc,_that.relatedTask,_that.dependencyKind,_that.lagDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceTaskId,  String targetTaskId,  TaskDependencyType type,  DateTime createdAtUtc,  ProjectTaskReferenceResponse relatedTask,  TaskDependencyKind dependencyKind,  int lagDays)?  $default,) {final _that = this;
switch (_that) {
case _TaskDependencyDetailsResponse() when $default != null:
return $default(_that.id,_that.sourceTaskId,_that.targetTaskId,_that.type,_that.createdAtUtc,_that.relatedTask,_that.dependencyKind,_that.lagDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskDependencyDetailsResponse implements TaskDependencyDetailsResponse {
  const _TaskDependencyDetailsResponse({required this.id, required this.sourceTaskId, required this.targetTaskId, required this.type, required this.createdAtUtc, required this.relatedTask, this.dependencyKind = TaskDependencyKind.finishToStart, this.lagDays = 0});
  factory _TaskDependencyDetailsResponse.fromJson(Map<String, dynamic> json) => _$TaskDependencyDetailsResponseFromJson(json);

@override final  String id;
@override final  String sourceTaskId;
@override final  String targetTaskId;
@override final  TaskDependencyType type;
@override final  DateTime createdAtUtc;
@override final  ProjectTaskReferenceResponse relatedTask;
@override@JsonKey() final  TaskDependencyKind dependencyKind;
@override@JsonKey() final  int lagDays;

/// Create a copy of TaskDependencyDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDependencyDetailsResponseCopyWith<_TaskDependencyDetailsResponse> get copyWith => __$TaskDependencyDetailsResponseCopyWithImpl<_TaskDependencyDetailsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskDependencyDetailsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskDependencyDetailsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceTaskId, sourceTaskId) || other.sourceTaskId == sourceTaskId)&&(identical(other.targetTaskId, targetTaskId) || other.targetTaskId == targetTaskId)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.relatedTask, relatedTask) || other.relatedTask == relatedTask)&&(identical(other.dependencyKind, dependencyKind) || other.dependencyKind == dependencyKind)&&(identical(other.lagDays, lagDays) || other.lagDays == lagDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceTaskId,targetTaskId,type,createdAtUtc,relatedTask,dependencyKind,lagDays);

@override
String toString() {
  return 'TaskDependencyDetailsResponse(id: $id, sourceTaskId: $sourceTaskId, targetTaskId: $targetTaskId, type: $type, createdAtUtc: $createdAtUtc, relatedTask: $relatedTask, dependencyKind: $dependencyKind, lagDays: $lagDays)';
}


}

/// @nodoc
abstract mixin class _$TaskDependencyDetailsResponseCopyWith<$Res> implements $TaskDependencyDetailsResponseCopyWith<$Res> {
  factory _$TaskDependencyDetailsResponseCopyWith(_TaskDependencyDetailsResponse value, $Res Function(_TaskDependencyDetailsResponse) _then) = __$TaskDependencyDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceTaskId, String targetTaskId, TaskDependencyType type, DateTime createdAtUtc, ProjectTaskReferenceResponse relatedTask, TaskDependencyKind dependencyKind, int lagDays
});


@override $ProjectTaskReferenceResponseCopyWith<$Res> get relatedTask;

}
/// @nodoc
class __$TaskDependencyDetailsResponseCopyWithImpl<$Res>
    implements _$TaskDependencyDetailsResponseCopyWith<$Res> {
  __$TaskDependencyDetailsResponseCopyWithImpl(this._self, this._then);

  final _TaskDependencyDetailsResponse _self;
  final $Res Function(_TaskDependencyDetailsResponse) _then;

/// Create a copy of TaskDependencyDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceTaskId = null,Object? targetTaskId = null,Object? type = null,Object? createdAtUtc = null,Object? relatedTask = null,Object? dependencyKind = null,Object? lagDays = null,}) {
  return _then(_TaskDependencyDetailsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceTaskId: null == sourceTaskId ? _self.sourceTaskId : sourceTaskId // ignore: cast_nullable_to_non_nullable
as String,targetTaskId: null == targetTaskId ? _self.targetTaskId : targetTaskId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskDependencyType,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,relatedTask: null == relatedTask ? _self.relatedTask : relatedTask // ignore: cast_nullable_to_non_nullable
as ProjectTaskReferenceResponse,dependencyKind: null == dependencyKind ? _self.dependencyKind : dependencyKind // ignore: cast_nullable_to_non_nullable
as TaskDependencyKind,lagDays: null == lagDays ? _self.lagDays : lagDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TaskDependencyDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskReferenceResponseCopyWith<$Res> get relatedTask {
  
  return $ProjectTaskReferenceResponseCopyWith<$Res>(_self.relatedTask, (value) {
    return _then(_self.copyWith(relatedTask: value));
  });
}
}


/// @nodoc
mixin _$ProjectTaskReferenceResponse {

 String get id; int get number; String get key; String get title; ProjectTaskStatus get status; DateTime? get archivedAtUtc; int get version;
/// Create a copy of ProjectTaskReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskReferenceResponseCopyWith<ProjectTaskReferenceResponse> get copyWith => _$ProjectTaskReferenceResponseCopyWithImpl<ProjectTaskReferenceResponse>(this as ProjectTaskReferenceResponse, _$identity);

  /// Serializes this ProjectTaskReferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskReferenceResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,title,status,archivedAtUtc,version);

@override
String toString() {
  return 'ProjectTaskReferenceResponse(id: $id, number: $number, key: $key, title: $title, status: $status, archivedAtUtc: $archivedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskReferenceResponseCopyWith<$Res>  {
  factory $ProjectTaskReferenceResponseCopyWith(ProjectTaskReferenceResponse value, $Res Function(ProjectTaskReferenceResponse) _then) = _$ProjectTaskReferenceResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String title, ProjectTaskStatus status, DateTime? archivedAtUtc, int version
});




}
/// @nodoc
class _$ProjectTaskReferenceResponseCopyWithImpl<$Res>
    implements $ProjectTaskReferenceResponseCopyWith<$Res> {
  _$ProjectTaskReferenceResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskReferenceResponse _self;
  final $Res Function(ProjectTaskReferenceResponse) _then;

/// Create a copy of ProjectTaskReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? title = null,Object? status = null,Object? archivedAtUtc = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskReferenceResponse].
extension ProjectTaskReferenceResponsePatterns on ProjectTaskReferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskReferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskReferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskReferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskReferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskReferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskReferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  DateTime? archivedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskReferenceResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.archivedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  DateTime? archivedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskReferenceResponse():
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.archivedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  DateTime? archivedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskReferenceResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.archivedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskReferenceResponse implements ProjectTaskReferenceResponse {
  const _ProjectTaskReferenceResponse({required this.id, required this.number, required this.key, required this.title, required this.status, this.archivedAtUtc, required this.version});
  factory _ProjectTaskReferenceResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskReferenceResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String key;
@override final  String title;
@override final  ProjectTaskStatus status;
@override final  DateTime? archivedAtUtc;
@override final  int version;

/// Create a copy of ProjectTaskReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskReferenceResponseCopyWith<_ProjectTaskReferenceResponse> get copyWith => __$ProjectTaskReferenceResponseCopyWithImpl<_ProjectTaskReferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskReferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskReferenceResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,title,status,archivedAtUtc,version);

@override
String toString() {
  return 'ProjectTaskReferenceResponse(id: $id, number: $number, key: $key, title: $title, status: $status, archivedAtUtc: $archivedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskReferenceResponseCopyWith<$Res> implements $ProjectTaskReferenceResponseCopyWith<$Res> {
  factory _$ProjectTaskReferenceResponseCopyWith(_ProjectTaskReferenceResponse value, $Res Function(_ProjectTaskReferenceResponse) _then) = __$ProjectTaskReferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String title, ProjectTaskStatus status, DateTime? archivedAtUtc, int version
});




}
/// @nodoc
class __$ProjectTaskReferenceResponseCopyWithImpl<$Res>
    implements _$ProjectTaskReferenceResponseCopyWith<$Res> {
  __$ProjectTaskReferenceResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskReferenceResponse _self;
  final $Res Function(_ProjectTaskReferenceResponse) _then;

/// Create a copy of ProjectTaskReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? title = null,Object? status = null,Object? archivedAtUtc = freezed,Object? version = null,}) {
  return _then(_ProjectTaskReferenceResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskSubtaskSummaryResponse {

 String get id; int get number; String get key; String get title; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get dueAtUtc; int get version;
/// Create a copy of ProjectTaskSubtaskSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskSubtaskSummaryResponseCopyWith<ProjectTaskSubtaskSummaryResponse> get copyWith => _$ProjectTaskSubtaskSummaryResponseCopyWithImpl<ProjectTaskSubtaskSummaryResponse>(this as ProjectTaskSubtaskSummaryResponse, _$identity);

  /// Serializes this ProjectTaskSubtaskSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskSubtaskSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,title,status,priority,dueAtUtc,version);

@override
String toString() {
  return 'ProjectTaskSubtaskSummaryResponse(id: $id, number: $number, key: $key, title: $title, status: $status, priority: $priority, dueAtUtc: $dueAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskSubtaskSummaryResponseCopyWith<$Res>  {
  factory $ProjectTaskSubtaskSummaryResponseCopyWith(ProjectTaskSubtaskSummaryResponse value, $Res Function(ProjectTaskSubtaskSummaryResponse) _then) = _$ProjectTaskSubtaskSummaryResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? dueAtUtc, int version
});




}
/// @nodoc
class _$ProjectTaskSubtaskSummaryResponseCopyWithImpl<$Res>
    implements $ProjectTaskSubtaskSummaryResponseCopyWith<$Res> {
  _$ProjectTaskSubtaskSummaryResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskSubtaskSummaryResponse _self;
  final $Res Function(ProjectTaskSubtaskSummaryResponse) _then;

/// Create a copy of ProjectTaskSubtaskSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? title = null,Object? status = null,Object? priority = null,Object? dueAtUtc = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskSubtaskSummaryResponse].
extension ProjectTaskSubtaskSummaryResponsePatterns on ProjectTaskSubtaskSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskSubtaskSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskSubtaskSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskSubtaskSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskSubtaskSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskSubtaskSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskSubtaskSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskSubtaskSummaryResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.priority,_that.dueAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskSubtaskSummaryResponse():
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.priority,_that.dueAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskSubtaskSummaryResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.priority,_that.dueAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskSubtaskSummaryResponse implements ProjectTaskSubtaskSummaryResponse {
  const _ProjectTaskSubtaskSummaryResponse({required this.id, required this.number, required this.key, required this.title, required this.status, required this.priority, this.dueAtUtc, required this.version});
  factory _ProjectTaskSubtaskSummaryResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskSubtaskSummaryResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String key;
@override final  String title;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? dueAtUtc;
@override final  int version;

/// Create a copy of ProjectTaskSubtaskSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskSubtaskSummaryResponseCopyWith<_ProjectTaskSubtaskSummaryResponse> get copyWith => __$ProjectTaskSubtaskSummaryResponseCopyWithImpl<_ProjectTaskSubtaskSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskSubtaskSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskSubtaskSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,title,status,priority,dueAtUtc,version);

@override
String toString() {
  return 'ProjectTaskSubtaskSummaryResponse(id: $id, number: $number, key: $key, title: $title, status: $status, priority: $priority, dueAtUtc: $dueAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskSubtaskSummaryResponseCopyWith<$Res> implements $ProjectTaskSubtaskSummaryResponseCopyWith<$Res> {
  factory _$ProjectTaskSubtaskSummaryResponseCopyWith(_ProjectTaskSubtaskSummaryResponse value, $Res Function(_ProjectTaskSubtaskSummaryResponse) _then) = __$ProjectTaskSubtaskSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? dueAtUtc, int version
});




}
/// @nodoc
class __$ProjectTaskSubtaskSummaryResponseCopyWithImpl<$Res>
    implements _$ProjectTaskSubtaskSummaryResponseCopyWith<$Res> {
  __$ProjectTaskSubtaskSummaryResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskSubtaskSummaryResponse _self;
  final $Res Function(_ProjectTaskSubtaskSummaryResponse) _then;

/// Create a copy of ProjectTaskSubtaskSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? title = null,Object? status = null,Object? priority = null,Object? dueAtUtc = freezed,Object? version = null,}) {
  return _then(_ProjectTaskSubtaskSummaryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


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

 List<String> get coreUserIds; int get expectedVersion;
/// Create a copy of UpdateTaskAssigneesPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskAssigneesPayloadCopyWith<UpdateTaskAssigneesPayload> get copyWith => _$UpdateTaskAssigneesPayloadCopyWithImpl<UpdateTaskAssigneesPayload>(this as UpdateTaskAssigneesPayload, _$identity);

  /// Serializes this UpdateTaskAssigneesPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskAssigneesPayload&&const DeepCollectionEquality().equals(other.coreUserIds, coreUserIds)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(coreUserIds),expectedVersion);

@override
String toString() {
  return 'UpdateTaskAssigneesPayload(coreUserIds: $coreUserIds, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskAssigneesPayloadCopyWith<$Res>  {
  factory $UpdateTaskAssigneesPayloadCopyWith(UpdateTaskAssigneesPayload value, $Res Function(UpdateTaskAssigneesPayload) _then) = _$UpdateTaskAssigneesPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> coreUserIds, int expectedVersion
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
@pragma('vm:prefer-inline') @override $Res call({Object? coreUserIds = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
coreUserIds: null == coreUserIds ? _self.coreUserIds : coreUserIds // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> coreUserIds,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskAssigneesPayload() when $default != null:
return $default(_that.coreUserIds,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> coreUserIds,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskAssigneesPayload():
return $default(_that.coreUserIds,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> coreUserIds,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskAssigneesPayload() when $default != null:
return $default(_that.coreUserIds,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskAssigneesPayload implements UpdateTaskAssigneesPayload {
  const _UpdateTaskAssigneesPayload({required this.coreUserIds, required this.expectedVersion});
  factory _UpdateTaskAssigneesPayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskAssigneesPayloadFromJson(json);

@override final  List<String> coreUserIds;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskAssigneesPayload&&const DeepCollectionEquality().equals(other.coreUserIds, coreUserIds)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(coreUserIds),expectedVersion);

@override
String toString() {
  return 'UpdateTaskAssigneesPayload(coreUserIds: $coreUserIds, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskAssigneesPayloadCopyWith<$Res> implements $UpdateTaskAssigneesPayloadCopyWith<$Res> {
  factory _$UpdateTaskAssigneesPayloadCopyWith(_UpdateTaskAssigneesPayload value, $Res Function(_UpdateTaskAssigneesPayload) _then) = __$UpdateTaskAssigneesPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> coreUserIds, int expectedVersion
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
@override @pragma('vm:prefer-inline') $Res call({Object? coreUserIds = null,Object? expectedVersion = null,}) {
  return _then(_UpdateTaskAssigneesPayload(
coreUserIds: null == coreUserIds ? _self.coreUserIds : coreUserIds // ignore: cast_nullable_to_non_nullable
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
