// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_detail_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectTaskResponse {

 String get id; int get number; String get key; String get workspaceId; String get projectId; String? get parentTaskId; String get title; String? get description; String? get descriptionDeltaJson; ProjectTaskStatus get status; TaskPriority get priority; String get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; int? get actualMinutes; int get position; DateTime? get startAtUtc; DateTime? get dueAtUtc; String get createdByUserId; List<TaskAssigneeResponse> get assignees; List<TaskChecklistItemResponse> get checklistItems; TaskRecurrenceSummaryResponse? get recurrence; DateTime get createdAtUtc; DateTime get updatedAtUtc; DateTime? get archivedAtUtc; int get version; String? get customStatusId; String? get milestoneId;
/// Create a copy of ProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskResponseCopyWith<ProjectTaskResponse> get copyWith => _$ProjectTaskResponseCopyWithImpl<ProjectTaskResponse>(this as ProjectTaskResponse, _$identity);

  /// Serializes this ProjectTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&(identical(other.position, position) || other.position == position)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,workspaceId,projectId,parentTaskId,title,description,descriptionDeltaJson,status,priority,taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,position,startAtUtc,dueAtUtc,createdByUserId,const DeepCollectionEquality().hash(assignees),const DeepCollectionEquality().hash(checklistItems),recurrence,createdAtUtc,updatedAtUtc,archivedAtUtc,version,customStatusId,milestoneId]);

@override
String toString() {
  return 'ProjectTaskResponse(id: $id, number: $number, key: $key, workspaceId: $workspaceId, projectId: $projectId, parentTaskId: $parentTaskId, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson, status: $status, priority: $priority, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, position: $position, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, createdByUserId: $createdByUserId, assignees: $assignees, checklistItems: $checklistItems, recurrence: $recurrence, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, archivedAtUtc: $archivedAtUtc, version: $version, customStatusId: $customStatusId, milestoneId: $milestoneId)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskResponseCopyWith<$Res>  {
  factory $ProjectTaskResponseCopyWith(ProjectTaskResponse value, $Res Function(ProjectTaskResponse) _then) = _$ProjectTaskResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String workspaceId, String projectId, String? parentTaskId, String title, String? description, String? descriptionDeltaJson, ProjectTaskStatus status, TaskPriority priority, String taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, int position, DateTime? startAtUtc, DateTime? dueAtUtc, String createdByUserId, List<TaskAssigneeResponse> assignees, List<TaskChecklistItemResponse> checklistItems, TaskRecurrenceSummaryResponse? recurrence, DateTime createdAtUtc, DateTime updatedAtUtc, DateTime? archivedAtUtc, int version, String? customStatusId, String? milestoneId
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? workspaceId = null,Object? projectId = null,Object? parentTaskId = freezed,Object? title = null,Object? description = freezed,Object? descriptionDeltaJson = freezed,Object? status = null,Object? priority = null,Object? taskType = null,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? position = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? createdByUserId = null,Object? assignees = null,Object? checklistItems = null,Object? recurrence = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? archivedAtUtc = freezed,Object? version = null,Object? customStatusId = freezed,Object? milestoneId = freezed,}) {
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
as DateTime?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<TaskAssigneeResponse>,checklistItems: null == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<TaskChecklistItemResponse>,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceSummaryResponse?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String workspaceId,  String projectId,  String? parentTaskId,  String title,  String? description,  String? descriptionDeltaJson,  ProjectTaskStatus status,  TaskPriority priority,  String taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  int position,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String createdByUserId,  List<TaskAssigneeResponse> assignees,  List<TaskChecklistItemResponse> checklistItems,  TaskRecurrenceSummaryResponse? recurrence,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc,  int version,  String? customStatusId,  String? milestoneId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.projectId,_that.parentTaskId,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.position,_that.startAtUtc,_that.dueAtUtc,_that.createdByUserId,_that.assignees,_that.checklistItems,_that.recurrence,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc,_that.version,_that.customStatusId,_that.milestoneId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String workspaceId,  String projectId,  String? parentTaskId,  String title,  String? description,  String? descriptionDeltaJson,  ProjectTaskStatus status,  TaskPriority priority,  String taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  int position,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String createdByUserId,  List<TaskAssigneeResponse> assignees,  List<TaskChecklistItemResponse> checklistItems,  TaskRecurrenceSummaryResponse? recurrence,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc,  int version,  String? customStatusId,  String? milestoneId)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskResponse():
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.projectId,_that.parentTaskId,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.position,_that.startAtUtc,_that.dueAtUtc,_that.createdByUserId,_that.assignees,_that.checklistItems,_that.recurrence,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc,_that.version,_that.customStatusId,_that.milestoneId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String workspaceId,  String projectId,  String? parentTaskId,  String title,  String? description,  String? descriptionDeltaJson,  ProjectTaskStatus status,  TaskPriority priority,  String taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  int position,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String createdByUserId,  List<TaskAssigneeResponse> assignees,  List<TaskChecklistItemResponse> checklistItems,  TaskRecurrenceSummaryResponse? recurrence,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc,  int version,  String? customStatusId,  String? milestoneId)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.projectId,_that.parentTaskId,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.position,_that.startAtUtc,_that.dueAtUtc,_that.createdByUserId,_that.assignees,_that.checklistItems,_that.recurrence,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc,_that.version,_that.customStatusId,_that.milestoneId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskResponse implements ProjectTaskResponse {
  const _ProjectTaskResponse({required this.id, required this.number, required this.key, required this.workspaceId, required this.projectId, this.parentTaskId, required this.title, this.description, this.descriptionDeltaJson, required this.status, required this.priority, required this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.actualMinutes, required this.position, this.startAtUtc, this.dueAtUtc, required this.createdByUserId, required this.assignees, required this.checklistItems, this.recurrence, required this.createdAtUtc, required this.updatedAtUtc, this.archivedAtUtc, required this.version, this.customStatusId, this.milestoneId});
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
@override final  String createdByUserId;
@override final  List<TaskAssigneeResponse> assignees;
@override final  List<TaskChecklistItemResponse> checklistItems;
@override final  TaskRecurrenceSummaryResponse? recurrence;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  DateTime? archivedAtUtc;
@override final  int version;
@override final  String? customStatusId;
@override final  String? milestoneId;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&(identical(other.position, position) || other.position == position)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,workspaceId,projectId,parentTaskId,title,description,descriptionDeltaJson,status,priority,taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,position,startAtUtc,dueAtUtc,createdByUserId,const DeepCollectionEquality().hash(assignees),const DeepCollectionEquality().hash(checklistItems),recurrence,createdAtUtc,updatedAtUtc,archivedAtUtc,version,customStatusId,milestoneId]);

@override
String toString() {
  return 'ProjectTaskResponse(id: $id, number: $number, key: $key, workspaceId: $workspaceId, projectId: $projectId, parentTaskId: $parentTaskId, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson, status: $status, priority: $priority, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, position: $position, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, createdByUserId: $createdByUserId, assignees: $assignees, checklistItems: $checklistItems, recurrence: $recurrence, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, archivedAtUtc: $archivedAtUtc, version: $version, customStatusId: $customStatusId, milestoneId: $milestoneId)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskResponseCopyWith<$Res> implements $ProjectTaskResponseCopyWith<$Res> {
  factory _$ProjectTaskResponseCopyWith(_ProjectTaskResponse value, $Res Function(_ProjectTaskResponse) _then) = __$ProjectTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String workspaceId, String projectId, String? parentTaskId, String title, String? description, String? descriptionDeltaJson, ProjectTaskStatus status, TaskPriority priority, String taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, int position, DateTime? startAtUtc, DateTime? dueAtUtc, String createdByUserId, List<TaskAssigneeResponse> assignees, List<TaskChecklistItemResponse> checklistItems, TaskRecurrenceSummaryResponse? recurrence, DateTime createdAtUtc, DateTime updatedAtUtc, DateTime? archivedAtUtc, int version, String? customStatusId, String? milestoneId
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? workspaceId = null,Object? projectId = null,Object? parentTaskId = freezed,Object? title = null,Object? description = freezed,Object? descriptionDeltaJson = freezed,Object? status = null,Object? priority = null,Object? taskType = null,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? position = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? createdByUserId = null,Object? assignees = null,Object? checklistItems = null,Object? recurrence = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? archivedAtUtc = freezed,Object? version = null,Object? customStatusId = freezed,Object? milestoneId = freezed,}) {
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
as DateTime?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<TaskAssigneeResponse>,checklistItems: null == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<TaskChecklistItemResponse>,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceSummaryResponse?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
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
mixin _$TaskAcceptanceCriterionResponse {

 String get id; String get text; int get position; bool get isAccepted; String? get acceptedByUserId; DateTime? get acceptedAtUtc; DateTime get updatedAtUtc;
/// Create a copy of TaskAcceptanceCriterionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskAcceptanceCriterionResponseCopyWith<TaskAcceptanceCriterionResponse> get copyWith => _$TaskAcceptanceCriterionResponseCopyWithImpl<TaskAcceptanceCriterionResponse>(this as TaskAcceptanceCriterionResponse, _$identity);

  /// Serializes this TaskAcceptanceCriterionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskAcceptanceCriterionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.position, position) || other.position == position)&&(identical(other.isAccepted, isAccepted) || other.isAccepted == isAccepted)&&(identical(other.acceptedByUserId, acceptedByUserId) || other.acceptedByUserId == acceptedByUserId)&&(identical(other.acceptedAtUtc, acceptedAtUtc) || other.acceptedAtUtc == acceptedAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,position,isAccepted,acceptedByUserId,acceptedAtUtc,updatedAtUtc);

@override
String toString() {
  return 'TaskAcceptanceCriterionResponse(id: $id, text: $text, position: $position, isAccepted: $isAccepted, acceptedByUserId: $acceptedByUserId, acceptedAtUtc: $acceptedAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskAcceptanceCriterionResponseCopyWith<$Res>  {
  factory $TaskAcceptanceCriterionResponseCopyWith(TaskAcceptanceCriterionResponse value, $Res Function(TaskAcceptanceCriterionResponse) _then) = _$TaskAcceptanceCriterionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String text, int position, bool isAccepted, String? acceptedByUserId, DateTime? acceptedAtUtc, DateTime updatedAtUtc
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? position = null,Object? isAccepted = null,Object? acceptedByUserId = freezed,Object? acceptedAtUtc = freezed,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isAccepted: null == isAccepted ? _self.isAccepted : isAccepted // ignore: cast_nullable_to_non_nullable
as bool,acceptedByUserId: freezed == acceptedByUserId ? _self.acceptedByUserId : acceptedByUserId // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  int position,  bool isAccepted,  String? acceptedByUserId,  DateTime? acceptedAtUtc,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskAcceptanceCriterionResponse() when $default != null:
return $default(_that.id,_that.text,_that.position,_that.isAccepted,_that.acceptedByUserId,_that.acceptedAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  int position,  bool isAccepted,  String? acceptedByUserId,  DateTime? acceptedAtUtc,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskAcceptanceCriterionResponse():
return $default(_that.id,_that.text,_that.position,_that.isAccepted,_that.acceptedByUserId,_that.acceptedAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  int position,  bool isAccepted,  String? acceptedByUserId,  DateTime? acceptedAtUtc,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskAcceptanceCriterionResponse() when $default != null:
return $default(_that.id,_that.text,_that.position,_that.isAccepted,_that.acceptedByUserId,_that.acceptedAtUtc,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskAcceptanceCriterionResponse implements TaskAcceptanceCriterionResponse {
  const _TaskAcceptanceCriterionResponse({required this.id, required this.text, required this.position, required this.isAccepted, this.acceptedByUserId, this.acceptedAtUtc, required this.updatedAtUtc});
  factory _TaskAcceptanceCriterionResponse.fromJson(Map<String, dynamic> json) => _$TaskAcceptanceCriterionResponseFromJson(json);

@override final  String id;
@override final  String text;
@override final  int position;
@override final  bool isAccepted;
@override final  String? acceptedByUserId;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskAcceptanceCriterionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.position, position) || other.position == position)&&(identical(other.isAccepted, isAccepted) || other.isAccepted == isAccepted)&&(identical(other.acceptedByUserId, acceptedByUserId) || other.acceptedByUserId == acceptedByUserId)&&(identical(other.acceptedAtUtc, acceptedAtUtc) || other.acceptedAtUtc == acceptedAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,position,isAccepted,acceptedByUserId,acceptedAtUtc,updatedAtUtc);

@override
String toString() {
  return 'TaskAcceptanceCriterionResponse(id: $id, text: $text, position: $position, isAccepted: $isAccepted, acceptedByUserId: $acceptedByUserId, acceptedAtUtc: $acceptedAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskAcceptanceCriterionResponseCopyWith<$Res> implements $TaskAcceptanceCriterionResponseCopyWith<$Res> {
  factory _$TaskAcceptanceCriterionResponseCopyWith(_TaskAcceptanceCriterionResponse value, $Res Function(_TaskAcceptanceCriterionResponse) _then) = __$TaskAcceptanceCriterionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, int position, bool isAccepted, String? acceptedByUserId, DateTime? acceptedAtUtc, DateTime updatedAtUtc
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? position = null,Object? isAccepted = null,Object? acceptedByUserId = freezed,Object? acceptedAtUtc = freezed,Object? updatedAtUtc = null,}) {
  return _then(_TaskAcceptanceCriterionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isAccepted: null == isAccepted ? _self.isAccepted : isAccepted // ignore: cast_nullable_to_non_nullable
as bool,acceptedByUserId: freezed == acceptedByUserId ? _self.acceptedByUserId : acceptedByUserId // ignore: cast_nullable_to_non_nullable
as String?,acceptedAtUtc: freezed == acceptedAtUtc ? _self.acceptedAtUtc : acceptedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskWatcherResponse {

 String get userId; DateTime get createdAtUtc;
/// Create a copy of TaskWatcherResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskWatcherResponseCopyWith<TaskWatcherResponse> get copyWith => _$TaskWatcherResponseCopyWithImpl<TaskWatcherResponse>(this as TaskWatcherResponse, _$identity);

  /// Serializes this TaskWatcherResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskWatcherResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,createdAtUtc);

@override
String toString() {
  return 'TaskWatcherResponse(userId: $userId, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskWatcherResponseCopyWith<$Res>  {
  factory $TaskWatcherResponseCopyWith(TaskWatcherResponse value, $Res Function(TaskWatcherResponse) _then) = _$TaskWatcherResponseCopyWithImpl;
@useResult
$Res call({
 String userId, DateTime createdAtUtc
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
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskWatcherResponse() when $default != null:
return $default(_that.userId,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskWatcherResponse():
return $default(_that.userId,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskWatcherResponse() when $default != null:
return $default(_that.userId,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskWatcherResponse implements TaskWatcherResponse {
  const _TaskWatcherResponse({required this.userId, required this.createdAtUtc});
  factory _TaskWatcherResponse.fromJson(Map<String, dynamic> json) => _$TaskWatcherResponseFromJson(json);

@override final  String userId;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskWatcherResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,createdAtUtc);

@override
String toString() {
  return 'TaskWatcherResponse(userId: $userId, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskWatcherResponseCopyWith<$Res> implements $TaskWatcherResponseCopyWith<$Res> {
  factory _$TaskWatcherResponseCopyWith(_TaskWatcherResponse value, $Res Function(_TaskWatcherResponse) _then) = __$TaskWatcherResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, DateTime createdAtUtc
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
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? createdAtUtc = null,}) {
  return _then(_TaskWatcherResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
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

 ProjectTaskResponse get task; List<TaskLabelResponse> get labels; List<TaskCustomFieldDefinitionValueResponse> get customFields; List<TaskAcceptanceCriterionResponse> get acceptanceCriteria; List<TaskDependencyDetailsResponse> get dependencies; List<TaskWatcherResponse> get watchers; bool get isWatchedByMe; bool get isPinnedByMe; List<ProjectTaskSubtaskSummaryResponse> get subtasks; ProjectTaskWorkflowResponse get workflow; List<UserReferenceResponse> get includedUsers; TaskCapabilitiesResponse? get capabilities; ProjectTaskCustomStatusResponse? get customStatus;
/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskDetailsResponseCopyWith<ProjectTaskDetailsResponse> get copyWith => _$ProjectTaskDetailsResponseCopyWithImpl<ProjectTaskDetailsResponse>(this as ProjectTaskDetailsResponse, _$identity);

  /// Serializes this ProjectTaskDetailsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskDetailsResponse&&(identical(other.task, task) || other.task == task)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&const DeepCollectionEquality().equals(other.watchers, watchers)&&(identical(other.isWatchedByMe, isWatchedByMe) || other.isWatchedByMe == isWatchedByMe)&&(identical(other.isPinnedByMe, isPinnedByMe) || other.isPinnedByMe == isPinnedByMe)&&const DeepCollectionEquality().equals(other.subtasks, subtasks)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&const DeepCollectionEquality().equals(other.includedUsers, includedUsers)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities)&&(identical(other.customStatus, customStatus) || other.customStatus == customStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFields),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(dependencies),const DeepCollectionEquality().hash(watchers),isWatchedByMe,isPinnedByMe,const DeepCollectionEquality().hash(subtasks),workflow,const DeepCollectionEquality().hash(includedUsers),capabilities,customStatus);

@override
String toString() {
  return 'ProjectTaskDetailsResponse(task: $task, labels: $labels, customFields: $customFields, acceptanceCriteria: $acceptanceCriteria, dependencies: $dependencies, watchers: $watchers, isWatchedByMe: $isWatchedByMe, isPinnedByMe: $isPinnedByMe, subtasks: $subtasks, workflow: $workflow, includedUsers: $includedUsers, capabilities: $capabilities, customStatus: $customStatus)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskDetailsResponseCopyWith<$Res>  {
  factory $ProjectTaskDetailsResponseCopyWith(ProjectTaskDetailsResponse value, $Res Function(ProjectTaskDetailsResponse) _then) = _$ProjectTaskDetailsResponseCopyWithImpl;
@useResult
$Res call({
 ProjectTaskResponse task, List<TaskLabelResponse> labels, List<TaskCustomFieldDefinitionValueResponse> customFields, List<TaskAcceptanceCriterionResponse> acceptanceCriteria, List<TaskDependencyDetailsResponse> dependencies, List<TaskWatcherResponse> watchers, bool isWatchedByMe, bool isPinnedByMe, List<ProjectTaskSubtaskSummaryResponse> subtasks, ProjectTaskWorkflowResponse workflow, List<UserReferenceResponse> includedUsers, TaskCapabilitiesResponse? capabilities, ProjectTaskCustomStatusResponse? customStatus
});


$ProjectTaskResponseCopyWith<$Res> get task;$ProjectTaskWorkflowResponseCopyWith<$Res> get workflow;$TaskCapabilitiesResponseCopyWith<$Res>? get capabilities;$ProjectTaskCustomStatusResponseCopyWith<$Res>? get customStatus;

}
/// @nodoc
class _$ProjectTaskDetailsResponseCopyWithImpl<$Res>
    implements $ProjectTaskDetailsResponseCopyWith<$Res> {
  _$ProjectTaskDetailsResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskDetailsResponse _self;
  final $Res Function(ProjectTaskDetailsResponse) _then;

/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? labels = null,Object? customFields = null,Object? acceptanceCriteria = null,Object? dependencies = null,Object? watchers = null,Object? isWatchedByMe = null,Object? isPinnedByMe = null,Object? subtasks = null,Object? workflow = null,Object? includedUsers = null,Object? capabilities = freezed,Object? customStatus = freezed,}) {
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
as List<UserReferenceResponse>,capabilities: freezed == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as TaskCapabilitiesResponse?,customStatus: freezed == customStatus ? _self.customStatus : customStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskCustomStatusResponse?,
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
}/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCapabilitiesResponseCopyWith<$Res>? get capabilities {
    if (_self.capabilities == null) {
    return null;
  }

  return $TaskCapabilitiesResponseCopyWith<$Res>(_self.capabilities!, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskCustomStatusResponseCopyWith<$Res>? get customStatus {
    if (_self.customStatus == null) {
    return null;
  }

  return $ProjectTaskCustomStatusResponseCopyWith<$Res>(_self.customStatus!, (value) {
    return _then(_self.copyWith(customStatus: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectTaskResponse task,  List<TaskLabelResponse> labels,  List<TaskCustomFieldDefinitionValueResponse> customFields,  List<TaskAcceptanceCriterionResponse> acceptanceCriteria,  List<TaskDependencyDetailsResponse> dependencies,  List<TaskWatcherResponse> watchers,  bool isWatchedByMe,  bool isPinnedByMe,  List<ProjectTaskSubtaskSummaryResponse> subtasks,  ProjectTaskWorkflowResponse workflow,  List<UserReferenceResponse> includedUsers,  TaskCapabilitiesResponse? capabilities,  ProjectTaskCustomStatusResponse? customStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskDetailsResponse() when $default != null:
return $default(_that.task,_that.labels,_that.customFields,_that.acceptanceCriteria,_that.dependencies,_that.watchers,_that.isWatchedByMe,_that.isPinnedByMe,_that.subtasks,_that.workflow,_that.includedUsers,_that.capabilities,_that.customStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectTaskResponse task,  List<TaskLabelResponse> labels,  List<TaskCustomFieldDefinitionValueResponse> customFields,  List<TaskAcceptanceCriterionResponse> acceptanceCriteria,  List<TaskDependencyDetailsResponse> dependencies,  List<TaskWatcherResponse> watchers,  bool isWatchedByMe,  bool isPinnedByMe,  List<ProjectTaskSubtaskSummaryResponse> subtasks,  ProjectTaskWorkflowResponse workflow,  List<UserReferenceResponse> includedUsers,  TaskCapabilitiesResponse? capabilities,  ProjectTaskCustomStatusResponse? customStatus)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskDetailsResponse():
return $default(_that.task,_that.labels,_that.customFields,_that.acceptanceCriteria,_that.dependencies,_that.watchers,_that.isWatchedByMe,_that.isPinnedByMe,_that.subtasks,_that.workflow,_that.includedUsers,_that.capabilities,_that.customStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectTaskResponse task,  List<TaskLabelResponse> labels,  List<TaskCustomFieldDefinitionValueResponse> customFields,  List<TaskAcceptanceCriterionResponse> acceptanceCriteria,  List<TaskDependencyDetailsResponse> dependencies,  List<TaskWatcherResponse> watchers,  bool isWatchedByMe,  bool isPinnedByMe,  List<ProjectTaskSubtaskSummaryResponse> subtasks,  ProjectTaskWorkflowResponse workflow,  List<UserReferenceResponse> includedUsers,  TaskCapabilitiesResponse? capabilities,  ProjectTaskCustomStatusResponse? customStatus)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskDetailsResponse() when $default != null:
return $default(_that.task,_that.labels,_that.customFields,_that.acceptanceCriteria,_that.dependencies,_that.watchers,_that.isWatchedByMe,_that.isPinnedByMe,_that.subtasks,_that.workflow,_that.includedUsers,_that.capabilities,_that.customStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskDetailsResponse implements ProjectTaskDetailsResponse {
  const _ProjectTaskDetailsResponse({required this.task, required this.labels, required this.customFields, required this.acceptanceCriteria, required this.dependencies, required this.watchers, required this.isWatchedByMe, required this.isPinnedByMe, required this.subtasks, required this.workflow, required this.includedUsers, this.capabilities, this.customStatus});
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
@override final  TaskCapabilitiesResponse? capabilities;
@override final  ProjectTaskCustomStatusResponse? customStatus;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskDetailsResponse&&(identical(other.task, task) || other.task == task)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&const DeepCollectionEquality().equals(other.watchers, watchers)&&(identical(other.isWatchedByMe, isWatchedByMe) || other.isWatchedByMe == isWatchedByMe)&&(identical(other.isPinnedByMe, isPinnedByMe) || other.isPinnedByMe == isPinnedByMe)&&const DeepCollectionEquality().equals(other.subtasks, subtasks)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&const DeepCollectionEquality().equals(other.includedUsers, includedUsers)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities)&&(identical(other.customStatus, customStatus) || other.customStatus == customStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFields),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(dependencies),const DeepCollectionEquality().hash(watchers),isWatchedByMe,isPinnedByMe,const DeepCollectionEquality().hash(subtasks),workflow,const DeepCollectionEquality().hash(includedUsers),capabilities,customStatus);

@override
String toString() {
  return 'ProjectTaskDetailsResponse(task: $task, labels: $labels, customFields: $customFields, acceptanceCriteria: $acceptanceCriteria, dependencies: $dependencies, watchers: $watchers, isWatchedByMe: $isWatchedByMe, isPinnedByMe: $isPinnedByMe, subtasks: $subtasks, workflow: $workflow, includedUsers: $includedUsers, capabilities: $capabilities, customStatus: $customStatus)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskDetailsResponseCopyWith<$Res> implements $ProjectTaskDetailsResponseCopyWith<$Res> {
  factory _$ProjectTaskDetailsResponseCopyWith(_ProjectTaskDetailsResponse value, $Res Function(_ProjectTaskDetailsResponse) _then) = __$ProjectTaskDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectTaskResponse task, List<TaskLabelResponse> labels, List<TaskCustomFieldDefinitionValueResponse> customFields, List<TaskAcceptanceCriterionResponse> acceptanceCriteria, List<TaskDependencyDetailsResponse> dependencies, List<TaskWatcherResponse> watchers, bool isWatchedByMe, bool isPinnedByMe, List<ProjectTaskSubtaskSummaryResponse> subtasks, ProjectTaskWorkflowResponse workflow, List<UserReferenceResponse> includedUsers, TaskCapabilitiesResponse? capabilities, ProjectTaskCustomStatusResponse? customStatus
});


@override $ProjectTaskResponseCopyWith<$Res> get task;@override $ProjectTaskWorkflowResponseCopyWith<$Res> get workflow;@override $TaskCapabilitiesResponseCopyWith<$Res>? get capabilities;@override $ProjectTaskCustomStatusResponseCopyWith<$Res>? get customStatus;

}
/// @nodoc
class __$ProjectTaskDetailsResponseCopyWithImpl<$Res>
    implements _$ProjectTaskDetailsResponseCopyWith<$Res> {
  __$ProjectTaskDetailsResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskDetailsResponse _self;
  final $Res Function(_ProjectTaskDetailsResponse) _then;

/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? labels = null,Object? customFields = null,Object? acceptanceCriteria = null,Object? dependencies = null,Object? watchers = null,Object? isWatchedByMe = null,Object? isPinnedByMe = null,Object? subtasks = null,Object? workflow = null,Object? includedUsers = null,Object? capabilities = freezed,Object? customStatus = freezed,}) {
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
as List<UserReferenceResponse>,capabilities: freezed == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as TaskCapabilitiesResponse?,customStatus: freezed == customStatus ? _self.customStatus : customStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskCustomStatusResponse?,
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
}/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCapabilitiesResponseCopyWith<$Res>? get capabilities {
    if (_self.capabilities == null) {
    return null;
  }

  return $TaskCapabilitiesResponseCopyWith<$Res>(_self.capabilities!, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}/// Create a copy of ProjectTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskCustomStatusResponseCopyWith<$Res>? get customStatus {
    if (_self.customStatus == null) {
    return null;
  }

  return $ProjectTaskCustomStatusResponseCopyWith<$Res>(_self.customStatus!, (value) {
    return _then(_self.copyWith(customStatus: value));
  });
}
}


/// @nodoc
mixin _$TaskCapabilitiesResponse {

 bool get canEdit; bool get canArchive; bool get canRestore;
/// Create a copy of TaskCapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCapabilitiesResponseCopyWith<TaskCapabilitiesResponse> get copyWith => _$TaskCapabilitiesResponseCopyWithImpl<TaskCapabilitiesResponse>(this as TaskCapabilitiesResponse, _$identity);

  /// Serializes this TaskCapabilitiesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskCapabilitiesResponse&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canArchive, canArchive) || other.canArchive == canArchive)&&(identical(other.canRestore, canRestore) || other.canRestore == canRestore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canEdit,canArchive,canRestore);

@override
String toString() {
  return 'TaskCapabilitiesResponse(canEdit: $canEdit, canArchive: $canArchive, canRestore: $canRestore)';
}


}

/// @nodoc
abstract mixin class $TaskCapabilitiesResponseCopyWith<$Res>  {
  factory $TaskCapabilitiesResponseCopyWith(TaskCapabilitiesResponse value, $Res Function(TaskCapabilitiesResponse) _then) = _$TaskCapabilitiesResponseCopyWithImpl;
@useResult
$Res call({
 bool canEdit, bool canArchive, bool canRestore
});




}
/// @nodoc
class _$TaskCapabilitiesResponseCopyWithImpl<$Res>
    implements $TaskCapabilitiesResponseCopyWith<$Res> {
  _$TaskCapabilitiesResponseCopyWithImpl(this._self, this._then);

  final TaskCapabilitiesResponse _self;
  final $Res Function(TaskCapabilitiesResponse) _then;

/// Create a copy of TaskCapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? canEdit = null,Object? canArchive = null,Object? canRestore = null,}) {
  return _then(_self.copyWith(
canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canArchive: null == canArchive ? _self.canArchive : canArchive // ignore: cast_nullable_to_non_nullable
as bool,canRestore: null == canRestore ? _self.canRestore : canRestore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskCapabilitiesResponse].
extension TaskCapabilitiesResponsePatterns on TaskCapabilitiesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskCapabilitiesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskCapabilitiesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskCapabilitiesResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskCapabilitiesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskCapabilitiesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskCapabilitiesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool canEdit,  bool canArchive,  bool canRestore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskCapabilitiesResponse() when $default != null:
return $default(_that.canEdit,_that.canArchive,_that.canRestore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool canEdit,  bool canArchive,  bool canRestore)  $default,) {final _that = this;
switch (_that) {
case _TaskCapabilitiesResponse():
return $default(_that.canEdit,_that.canArchive,_that.canRestore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool canEdit,  bool canArchive,  bool canRestore)?  $default,) {final _that = this;
switch (_that) {
case _TaskCapabilitiesResponse() when $default != null:
return $default(_that.canEdit,_that.canArchive,_that.canRestore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskCapabilitiesResponse implements TaskCapabilitiesResponse {
  const _TaskCapabilitiesResponse({required this.canEdit, required this.canArchive, required this.canRestore});
  factory _TaskCapabilitiesResponse.fromJson(Map<String, dynamic> json) => _$TaskCapabilitiesResponseFromJson(json);

@override final  bool canEdit;
@override final  bool canArchive;
@override final  bool canRestore;

/// Create a copy of TaskCapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCapabilitiesResponseCopyWith<_TaskCapabilitiesResponse> get copyWith => __$TaskCapabilitiesResponseCopyWithImpl<_TaskCapabilitiesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskCapabilitiesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskCapabilitiesResponse&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canArchive, canArchive) || other.canArchive == canArchive)&&(identical(other.canRestore, canRestore) || other.canRestore == canRestore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canEdit,canArchive,canRestore);

@override
String toString() {
  return 'TaskCapabilitiesResponse(canEdit: $canEdit, canArchive: $canArchive, canRestore: $canRestore)';
}


}

/// @nodoc
abstract mixin class _$TaskCapabilitiesResponseCopyWith<$Res> implements $TaskCapabilitiesResponseCopyWith<$Res> {
  factory _$TaskCapabilitiesResponseCopyWith(_TaskCapabilitiesResponse value, $Res Function(_TaskCapabilitiesResponse) _then) = __$TaskCapabilitiesResponseCopyWithImpl;
@override @useResult
$Res call({
 bool canEdit, bool canArchive, bool canRestore
});




}
/// @nodoc
class __$TaskCapabilitiesResponseCopyWithImpl<$Res>
    implements _$TaskCapabilitiesResponseCopyWith<$Res> {
  __$TaskCapabilitiesResponseCopyWithImpl(this._self, this._then);

  final _TaskCapabilitiesResponse _self;
  final $Res Function(_TaskCapabilitiesResponse) _then;

/// Create a copy of TaskCapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? canEdit = null,Object? canArchive = null,Object? canRestore = null,}) {
  return _then(_TaskCapabilitiesResponse(
canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canArchive: null == canArchive ? _self.canArchive : canArchive // ignore: cast_nullable_to_non_nullable
as bool,canRestore: null == canRestore ? _self.canRestore : canRestore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskCustomStatusResponse {

 String get id; String get name; String get color; TaskStatusCategory get category;
/// Create a copy of ProjectTaskCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskCustomStatusResponseCopyWith<ProjectTaskCustomStatusResponse> get copyWith => _$ProjectTaskCustomStatusResponseCopyWithImpl<ProjectTaskCustomStatusResponse>(this as ProjectTaskCustomStatusResponse, _$identity);

  /// Serializes this ProjectTaskCustomStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskCustomStatusResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,category);

@override
String toString() {
  return 'ProjectTaskCustomStatusResponse(id: $id, name: $name, color: $color, category: $category)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskCustomStatusResponseCopyWith<$Res>  {
  factory $ProjectTaskCustomStatusResponseCopyWith(ProjectTaskCustomStatusResponse value, $Res Function(ProjectTaskCustomStatusResponse) _then) = _$ProjectTaskCustomStatusResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String color, TaskStatusCategory category
});




}
/// @nodoc
class _$ProjectTaskCustomStatusResponseCopyWithImpl<$Res>
    implements $ProjectTaskCustomStatusResponseCopyWith<$Res> {
  _$ProjectTaskCustomStatusResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskCustomStatusResponse _self;
  final $Res Function(ProjectTaskCustomStatusResponse) _then;

/// Create a copy of ProjectTaskCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = null,Object? category = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskCustomStatusResponse].
extension ProjectTaskCustomStatusResponsePatterns on ProjectTaskCustomStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskCustomStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskCustomStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskCustomStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskCustomStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskCustomStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskCustomStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String color,  TaskStatusCategory category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskCustomStatusResponse() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String color,  TaskStatusCategory category)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskCustomStatusResponse():
return $default(_that.id,_that.name,_that.color,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String color,  TaskStatusCategory category)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskCustomStatusResponse() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskCustomStatusResponse implements ProjectTaskCustomStatusResponse {
  const _ProjectTaskCustomStatusResponse({required this.id, required this.name, required this.color, required this.category});
  factory _ProjectTaskCustomStatusResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskCustomStatusResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String color;
@override final  TaskStatusCategory category;

/// Create a copy of ProjectTaskCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskCustomStatusResponseCopyWith<_ProjectTaskCustomStatusResponse> get copyWith => __$ProjectTaskCustomStatusResponseCopyWithImpl<_ProjectTaskCustomStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskCustomStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskCustomStatusResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,category);

@override
String toString() {
  return 'ProjectTaskCustomStatusResponse(id: $id, name: $name, color: $color, category: $category)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskCustomStatusResponseCopyWith<$Res> implements $ProjectTaskCustomStatusResponseCopyWith<$Res> {
  factory _$ProjectTaskCustomStatusResponseCopyWith(_ProjectTaskCustomStatusResponse value, $Res Function(_ProjectTaskCustomStatusResponse) _then) = __$ProjectTaskCustomStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String color, TaskStatusCategory category
});




}
/// @nodoc
class __$ProjectTaskCustomStatusResponseCopyWithImpl<$Res>
    implements _$ProjectTaskCustomStatusResponseCopyWith<$Res> {
  __$ProjectTaskCustomStatusResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskCustomStatusResponse _self;
  final $Res Function(_ProjectTaskCustomStatusResponse) _then;

/// Create a copy of ProjectTaskCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? color = null,Object? category = null,}) {
  return _then(_ProjectTaskCustomStatusResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,
  ));
}


}


/// @nodoc
mixin _$UserReferenceResponse {

 String get userId; String? get displayName; String? get avatarUrl; bool get isActive;
/// Create a copy of UserReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserReferenceResponseCopyWith<UserReferenceResponse> get copyWith => _$UserReferenceResponseCopyWithImpl<UserReferenceResponse>(this as UserReferenceResponse, _$identity);

  /// Serializes this UserReferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserReferenceResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,avatarUrl,isActive);

@override
String toString() {
  return 'UserReferenceResponse(userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $UserReferenceResponseCopyWith<$Res>  {
  factory $UserReferenceResponseCopyWith(UserReferenceResponse value, $Res Function(UserReferenceResponse) _then) = _$UserReferenceResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String? displayName, String? avatarUrl, bool isActive
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
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? displayName,  String? avatarUrl,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserReferenceResponse() when $default != null:
return $default(_that.userId,_that.displayName,_that.avatarUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? displayName,  String? avatarUrl,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _UserReferenceResponse():
return $default(_that.userId,_that.displayName,_that.avatarUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? displayName,  String? avatarUrl,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _UserReferenceResponse() when $default != null:
return $default(_that.userId,_that.displayName,_that.avatarUrl,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserReferenceResponse implements UserReferenceResponse {
  const _UserReferenceResponse({required this.userId, this.displayName, this.avatarUrl, required this.isActive});
  factory _UserReferenceResponse.fromJson(Map<String, dynamic> json) => _$UserReferenceResponseFromJson(json);

@override final  String userId;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserReferenceResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,avatarUrl,isActive);

@override
String toString() {
  return 'UserReferenceResponse(userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UserReferenceResponseCopyWith<$Res> implements $UserReferenceResponseCopyWith<$Res> {
  factory _$UserReferenceResponseCopyWith(_UserReferenceResponse value, $Res Function(_UserReferenceResponse) _then) = __$UserReferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? displayName, String? avatarUrl, bool isActive
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
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = freezed,Object? avatarUrl = freezed,Object? isActive = null,}) {
  return _then(_UserReferenceResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
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

 String get id; int get number; String get key; String get title; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get dueAtUtc; int get version; String? get customStatusId; String? get customStatusName; String? get customStatusColor;
/// Create a copy of ProjectTaskSubtaskSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskSubtaskSummaryResponseCopyWith<ProjectTaskSubtaskSummaryResponse> get copyWith => _$ProjectTaskSubtaskSummaryResponseCopyWithImpl<ProjectTaskSubtaskSummaryResponse>(this as ProjectTaskSubtaskSummaryResponse, _$identity);

  /// Serializes this ProjectTaskSubtaskSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskSubtaskSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.customStatusName, customStatusName) || other.customStatusName == customStatusName)&&(identical(other.customStatusColor, customStatusColor) || other.customStatusColor == customStatusColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,title,status,priority,dueAtUtc,version,customStatusId,customStatusName,customStatusColor);

@override
String toString() {
  return 'ProjectTaskSubtaskSummaryResponse(id: $id, number: $number, key: $key, title: $title, status: $status, priority: $priority, dueAtUtc: $dueAtUtc, version: $version, customStatusId: $customStatusId, customStatusName: $customStatusName, customStatusColor: $customStatusColor)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskSubtaskSummaryResponseCopyWith<$Res>  {
  factory $ProjectTaskSubtaskSummaryResponseCopyWith(ProjectTaskSubtaskSummaryResponse value, $Res Function(ProjectTaskSubtaskSummaryResponse) _then) = _$ProjectTaskSubtaskSummaryResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? dueAtUtc, int version, String? customStatusId, String? customStatusName, String? customStatusColor
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? title = null,Object? status = null,Object? priority = null,Object? dueAtUtc = freezed,Object? version = null,Object? customStatusId = freezed,Object? customStatusName = freezed,Object? customStatusColor = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,customStatusName: freezed == customStatusName ? _self.customStatusName : customStatusName // ignore: cast_nullable_to_non_nullable
as String?,customStatusColor: freezed == customStatusColor ? _self.customStatusColor : customStatusColor // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  int version,  String? customStatusId,  String? customStatusName,  String? customStatusColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskSubtaskSummaryResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.priority,_that.dueAtUtc,_that.version,_that.customStatusId,_that.customStatusName,_that.customStatusColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  int version,  String? customStatusId,  String? customStatusName,  String? customStatusColor)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskSubtaskSummaryResponse():
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.priority,_that.dueAtUtc,_that.version,_that.customStatusId,_that.customStatusName,_that.customStatusColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  int version,  String? customStatusId,  String? customStatusName,  String? customStatusColor)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskSubtaskSummaryResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.priority,_that.dueAtUtc,_that.version,_that.customStatusId,_that.customStatusName,_that.customStatusColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskSubtaskSummaryResponse implements ProjectTaskSubtaskSummaryResponse {
  const _ProjectTaskSubtaskSummaryResponse({required this.id, required this.number, required this.key, required this.title, required this.status, required this.priority, this.dueAtUtc, required this.version, this.customStatusId, this.customStatusName, this.customStatusColor});
  factory _ProjectTaskSubtaskSummaryResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskSubtaskSummaryResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String key;
@override final  String title;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? dueAtUtc;
@override final  int version;
@override final  String? customStatusId;
@override final  String? customStatusName;
@override final  String? customStatusColor;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskSubtaskSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.customStatusName, customStatusName) || other.customStatusName == customStatusName)&&(identical(other.customStatusColor, customStatusColor) || other.customStatusColor == customStatusColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,title,status,priority,dueAtUtc,version,customStatusId,customStatusName,customStatusColor);

@override
String toString() {
  return 'ProjectTaskSubtaskSummaryResponse(id: $id, number: $number, key: $key, title: $title, status: $status, priority: $priority, dueAtUtc: $dueAtUtc, version: $version, customStatusId: $customStatusId, customStatusName: $customStatusName, customStatusColor: $customStatusColor)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskSubtaskSummaryResponseCopyWith<$Res> implements $ProjectTaskSubtaskSummaryResponseCopyWith<$Res> {
  factory _$ProjectTaskSubtaskSummaryResponseCopyWith(_ProjectTaskSubtaskSummaryResponse value, $Res Function(_ProjectTaskSubtaskSummaryResponse) _then) = __$ProjectTaskSubtaskSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? dueAtUtc, int version, String? customStatusId, String? customStatusName, String? customStatusColor
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? title = null,Object? status = null,Object? priority = null,Object? dueAtUtc = freezed,Object? version = null,Object? customStatusId = freezed,Object? customStatusName = freezed,Object? customStatusColor = freezed,}) {
  return _then(_ProjectTaskSubtaskSummaryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,customStatusName: freezed == customStatusName ? _self.customStatusName : customStatusName // ignore: cast_nullable_to_non_nullable
as String?,customStatusColor: freezed == customStatusColor ? _self.customStatusColor : customStatusColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
