// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_workflow_models.dart';

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

 String get title; String? get description; String? get parentTaskId; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; List<String>? get assigneeUserIds; List<String>? get checklistItems; String? get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; int? get actualMinutes; String? get descriptionDeltaJson; String? get milestoneId; ProjectTaskStatus? get targetStatus; String? get customStatusId; String? get previousTaskId; String? get nextTaskId;
/// Create a copy of CreateProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProjectTaskPayloadCopyWith<CreateProjectTaskPayload> get copyWith => _$CreateProjectTaskPayloadCopyWithImpl<CreateProjectTaskPayload>(this as CreateProjectTaskPayload, _$identity);

  /// Serializes this CreateProjectTaskPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProjectTaskPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeUserIds, assigneeUserIds)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,description,parentTaskId,status,priority,startAtUtc,dueAtUtc,const DeepCollectionEquality().hash(assigneeUserIds),const DeepCollectionEquality().hash(checklistItems),taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,descriptionDeltaJson,milestoneId,targetStatus,customStatusId,previousTaskId,nextTaskId]);

@override
String toString() {
  return 'CreateProjectTaskPayload(title: $title, description: $description, parentTaskId: $parentTaskId, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, assigneeUserIds: $assigneeUserIds, checklistItems: $checklistItems, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, descriptionDeltaJson: $descriptionDeltaJson, milestoneId: $milestoneId, targetStatus: $targetStatus, customStatusId: $customStatusId, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId)';
}


}

/// @nodoc
abstract mixin class $CreateProjectTaskPayloadCopyWith<$Res>  {
  factory $CreateProjectTaskPayloadCopyWith(CreateProjectTaskPayload value, $Res Function(CreateProjectTaskPayload) _then) = _$CreateProjectTaskPayloadCopyWithImpl;
@useResult
$Res call({
 String title, String? description, String? parentTaskId, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, List<String>? assigneeUserIds, List<String>? checklistItems, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, String? descriptionDeltaJson, String? milestoneId, ProjectTaskStatus? targetStatus, String? customStatusId, String? previousTaskId, String? nextTaskId
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
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? parentTaskId = freezed,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? assigneeUserIds = freezed,Object? checklistItems = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? descriptionDeltaJson = freezed,Object? milestoneId = freezed,Object? targetStatus = freezed,Object? customStatusId = freezed,Object? previousTaskId = freezed,Object? nextTaskId = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assigneeUserIds: freezed == assigneeUserIds ? _self.assigneeUserIds : assigneeUserIds // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description,  String? parentTaskId,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<String>? assigneeUserIds,  List<String>? checklistItems,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  String? descriptionDeltaJson,  String? milestoneId,  ProjectTaskStatus? targetStatus,  String? customStatusId,  String? previousTaskId,  String? nextTaskId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProjectTaskPayload() when $default != null:
return $default(_that.title,_that.description,_that.parentTaskId,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assigneeUserIds,_that.checklistItems,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.descriptionDeltaJson,_that.milestoneId,_that.targetStatus,_that.customStatusId,_that.previousTaskId,_that.nextTaskId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description,  String? parentTaskId,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<String>? assigneeUserIds,  List<String>? checklistItems,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  String? descriptionDeltaJson,  String? milestoneId,  ProjectTaskStatus? targetStatus,  String? customStatusId,  String? previousTaskId,  String? nextTaskId)  $default,) {final _that = this;
switch (_that) {
case _CreateProjectTaskPayload():
return $default(_that.title,_that.description,_that.parentTaskId,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assigneeUserIds,_that.checklistItems,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.descriptionDeltaJson,_that.milestoneId,_that.targetStatus,_that.customStatusId,_that.previousTaskId,_that.nextTaskId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description,  String? parentTaskId,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<String>? assigneeUserIds,  List<String>? checklistItems,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  String? descriptionDeltaJson,  String? milestoneId,  ProjectTaskStatus? targetStatus,  String? customStatusId,  String? previousTaskId,  String? nextTaskId)?  $default,) {final _that = this;
switch (_that) {
case _CreateProjectTaskPayload() when $default != null:
return $default(_that.title,_that.description,_that.parentTaskId,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assigneeUserIds,_that.checklistItems,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.descriptionDeltaJson,_that.milestoneId,_that.targetStatus,_that.customStatusId,_that.previousTaskId,_that.nextTaskId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProjectTaskPayload implements CreateProjectTaskPayload {
  const _CreateProjectTaskPayload({required this.title, this.description, this.parentTaskId, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, this.assigneeUserIds, this.checklistItems, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.actualMinutes, this.descriptionDeltaJson, this.milestoneId, this.targetStatus, this.customStatusId, this.previousTaskId, this.nextTaskId});
  factory _CreateProjectTaskPayload.fromJson(Map<String, dynamic> json) => _$CreateProjectTaskPayloadFromJson(json);

@override final  String title;
@override final  String? description;
@override final  String? parentTaskId;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  List<String>? assigneeUserIds;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProjectTaskPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeUserIds, assigneeUserIds)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,description,parentTaskId,status,priority,startAtUtc,dueAtUtc,const DeepCollectionEquality().hash(assigneeUserIds),const DeepCollectionEquality().hash(checklistItems),taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,descriptionDeltaJson,milestoneId,targetStatus,customStatusId,previousTaskId,nextTaskId]);

@override
String toString() {
  return 'CreateProjectTaskPayload(title: $title, description: $description, parentTaskId: $parentTaskId, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, assigneeUserIds: $assigneeUserIds, checklistItems: $checklistItems, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, descriptionDeltaJson: $descriptionDeltaJson, milestoneId: $milestoneId, targetStatus: $targetStatus, customStatusId: $customStatusId, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId)';
}


}

/// @nodoc
abstract mixin class _$CreateProjectTaskPayloadCopyWith<$Res> implements $CreateProjectTaskPayloadCopyWith<$Res> {
  factory _$CreateProjectTaskPayloadCopyWith(_CreateProjectTaskPayload value, $Res Function(_CreateProjectTaskPayload) _then) = __$CreateProjectTaskPayloadCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, String? parentTaskId, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, List<String>? assigneeUserIds, List<String>? checklistItems, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, String? descriptionDeltaJson, String? milestoneId, ProjectTaskStatus? targetStatus, String? customStatusId, String? previousTaskId, String? nextTaskId
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
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? parentTaskId = freezed,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? assigneeUserIds = freezed,Object? checklistItems = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? descriptionDeltaJson = freezed,Object? milestoneId = freezed,Object? targetStatus = freezed,Object? customStatusId = freezed,Object? previousTaskId = freezed,Object? nextTaskId = freezed,}) {
  return _then(_CreateProjectTaskPayload(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assigneeUserIds: freezed == assigneeUserIds ? _self.assigneeUserIds : assigneeUserIds // ignore: cast_nullable_to_non_nullable
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

// dart format on
