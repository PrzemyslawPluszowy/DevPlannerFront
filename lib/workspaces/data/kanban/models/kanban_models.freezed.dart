// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kanban_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KanbanCardLabelResponse {

 String get id; String get name; String get color;
/// Create a copy of KanbanCardLabelResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanbanCardLabelResponseCopyWith<KanbanCardLabelResponse> get copyWith => _$KanbanCardLabelResponseCopyWithImpl<KanbanCardLabelResponse>(this as KanbanCardLabelResponse, _$identity);

  /// Serializes this KanbanCardLabelResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanbanCardLabelResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color);

@override
String toString() {
  return 'KanbanCardLabelResponse(id: $id, name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class $KanbanCardLabelResponseCopyWith<$Res>  {
  factory $KanbanCardLabelResponseCopyWith(KanbanCardLabelResponse value, $Res Function(KanbanCardLabelResponse) _then) = _$KanbanCardLabelResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String color
});




}
/// @nodoc
class _$KanbanCardLabelResponseCopyWithImpl<$Res>
    implements $KanbanCardLabelResponseCopyWith<$Res> {
  _$KanbanCardLabelResponseCopyWithImpl(this._self, this._then);

  final KanbanCardLabelResponse _self;
  final $Res Function(KanbanCardLabelResponse) _then;

/// Create a copy of KanbanCardLabelResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KanbanCardLabelResponse].
extension KanbanCardLabelResponsePatterns on KanbanCardLabelResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanbanCardLabelResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanbanCardLabelResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanbanCardLabelResponse value)  $default,){
final _that = this;
switch (_that) {
case _KanbanCardLabelResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanbanCardLabelResponse value)?  $default,){
final _that = this;
switch (_that) {
case _KanbanCardLabelResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanbanCardLabelResponse() when $default != null:
return $default(_that.id,_that.name,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String color)  $default,) {final _that = this;
switch (_that) {
case _KanbanCardLabelResponse():
return $default(_that.id,_that.name,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String color)?  $default,) {final _that = this;
switch (_that) {
case _KanbanCardLabelResponse() when $default != null:
return $default(_that.id,_that.name,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanbanCardLabelResponse implements KanbanCardLabelResponse {
  const _KanbanCardLabelResponse({required this.id, required this.name, required this.color});
  factory _KanbanCardLabelResponse.fromJson(Map<String, dynamic> json) => _$KanbanCardLabelResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String color;

/// Create a copy of KanbanCardLabelResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanbanCardLabelResponseCopyWith<_KanbanCardLabelResponse> get copyWith => __$KanbanCardLabelResponseCopyWithImpl<_KanbanCardLabelResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanbanCardLabelResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanbanCardLabelResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color);

@override
String toString() {
  return 'KanbanCardLabelResponse(id: $id, name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class _$KanbanCardLabelResponseCopyWith<$Res> implements $KanbanCardLabelResponseCopyWith<$Res> {
  factory _$KanbanCardLabelResponseCopyWith(_KanbanCardLabelResponse value, $Res Function(_KanbanCardLabelResponse) _then) = __$KanbanCardLabelResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String color
});




}
/// @nodoc
class __$KanbanCardLabelResponseCopyWithImpl<$Res>
    implements _$KanbanCardLabelResponseCopyWith<$Res> {
  __$KanbanCardLabelResponseCopyWithImpl(this._self, this._then);

  final _KanbanCardLabelResponse _self;
  final $Res Function(_KanbanCardLabelResponse) _then;

/// Create a copy of KanbanCardLabelResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? color = null,}) {
  return _then(_KanbanCardLabelResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$KanbanCardCustomFieldResponse {

 String get fieldId; String get name; String get valueJson;
/// Create a copy of KanbanCardCustomFieldResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanbanCardCustomFieldResponseCopyWith<KanbanCardCustomFieldResponse> get copyWith => _$KanbanCardCustomFieldResponseCopyWithImpl<KanbanCardCustomFieldResponse>(this as KanbanCardCustomFieldResponse, _$identity);

  /// Serializes this KanbanCardCustomFieldResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanbanCardCustomFieldResponse&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&(identical(other.name, name) || other.name == name)&&(identical(other.valueJson, valueJson) || other.valueJson == valueJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldId,name,valueJson);

@override
String toString() {
  return 'KanbanCardCustomFieldResponse(fieldId: $fieldId, name: $name, valueJson: $valueJson)';
}


}

/// @nodoc
abstract mixin class $KanbanCardCustomFieldResponseCopyWith<$Res>  {
  factory $KanbanCardCustomFieldResponseCopyWith(KanbanCardCustomFieldResponse value, $Res Function(KanbanCardCustomFieldResponse) _then) = _$KanbanCardCustomFieldResponseCopyWithImpl;
@useResult
$Res call({
 String fieldId, String name, String valueJson
});




}
/// @nodoc
class _$KanbanCardCustomFieldResponseCopyWithImpl<$Res>
    implements $KanbanCardCustomFieldResponseCopyWith<$Res> {
  _$KanbanCardCustomFieldResponseCopyWithImpl(this._self, this._then);

  final KanbanCardCustomFieldResponse _self;
  final $Res Function(KanbanCardCustomFieldResponse) _then;

/// Create a copy of KanbanCardCustomFieldResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fieldId = null,Object? name = null,Object? valueJson = null,}) {
  return _then(_self.copyWith(
fieldId: null == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,valueJson: null == valueJson ? _self.valueJson : valueJson // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KanbanCardCustomFieldResponse].
extension KanbanCardCustomFieldResponsePatterns on KanbanCardCustomFieldResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanbanCardCustomFieldResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanbanCardCustomFieldResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanbanCardCustomFieldResponse value)  $default,){
final _that = this;
switch (_that) {
case _KanbanCardCustomFieldResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanbanCardCustomFieldResponse value)?  $default,){
final _that = this;
switch (_that) {
case _KanbanCardCustomFieldResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fieldId,  String name,  String valueJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanbanCardCustomFieldResponse() when $default != null:
return $default(_that.fieldId,_that.name,_that.valueJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fieldId,  String name,  String valueJson)  $default,) {final _that = this;
switch (_that) {
case _KanbanCardCustomFieldResponse():
return $default(_that.fieldId,_that.name,_that.valueJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fieldId,  String name,  String valueJson)?  $default,) {final _that = this;
switch (_that) {
case _KanbanCardCustomFieldResponse() when $default != null:
return $default(_that.fieldId,_that.name,_that.valueJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanbanCardCustomFieldResponse implements KanbanCardCustomFieldResponse {
  const _KanbanCardCustomFieldResponse({required this.fieldId, required this.name, required this.valueJson});
  factory _KanbanCardCustomFieldResponse.fromJson(Map<String, dynamic> json) => _$KanbanCardCustomFieldResponseFromJson(json);

@override final  String fieldId;
@override final  String name;
@override final  String valueJson;

/// Create a copy of KanbanCardCustomFieldResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanbanCardCustomFieldResponseCopyWith<_KanbanCardCustomFieldResponse> get copyWith => __$KanbanCardCustomFieldResponseCopyWithImpl<_KanbanCardCustomFieldResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanbanCardCustomFieldResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanbanCardCustomFieldResponse&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&(identical(other.name, name) || other.name == name)&&(identical(other.valueJson, valueJson) || other.valueJson == valueJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldId,name,valueJson);

@override
String toString() {
  return 'KanbanCardCustomFieldResponse(fieldId: $fieldId, name: $name, valueJson: $valueJson)';
}


}

/// @nodoc
abstract mixin class _$KanbanCardCustomFieldResponseCopyWith<$Res> implements $KanbanCardCustomFieldResponseCopyWith<$Res> {
  factory _$KanbanCardCustomFieldResponseCopyWith(_KanbanCardCustomFieldResponse value, $Res Function(_KanbanCardCustomFieldResponse) _then) = __$KanbanCardCustomFieldResponseCopyWithImpl;
@override @useResult
$Res call({
 String fieldId, String name, String valueJson
});




}
/// @nodoc
class __$KanbanCardCustomFieldResponseCopyWithImpl<$Res>
    implements _$KanbanCardCustomFieldResponseCopyWith<$Res> {
  __$KanbanCardCustomFieldResponseCopyWithImpl(this._self, this._then);

  final _KanbanCardCustomFieldResponse _self;
  final $Res Function(_KanbanCardCustomFieldResponse) _then;

/// Create a copy of KanbanCardCustomFieldResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fieldId = null,Object? name = null,Object? valueJson = null,}) {
  return _then(_KanbanCardCustomFieldResponse(
fieldId: null == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,valueJson: null == valueJson ? _self.valueJson : valueJson // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$KanbanTaskCardResponse {

 String get id; int get number; String get taskCode; String get title; ProjectTaskStatus get status; TaskPriority get priority; int get position; String? get primaryAssigneeUserId; String? get milestoneId; DateTime? get dueAtUtc; int get checklistTotal; int get checklistCompleted; int get attachmentCount; int get version; int? get estimatedMinutes; int? get loggedMinutes; int get subtaskTotal; int get subtaskCompleted; bool get isBlocked; List<String>? get blockedByTaskIds; List<KanbanCardLabelResponse>? get labels; List<KanbanCardCustomFieldResponse>? get customFieldsSummary; String? get coverAttachmentId; String? get customStatusId; TaskRecurrenceSummaryResponse? get recurrence; bool get isPinned; int get watcherCount; bool get isWatchedByMe; List<String>? get assigneeUserIds;
/// Create a copy of KanbanTaskCardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanbanTaskCardResponseCopyWith<KanbanTaskCardResponse> get copyWith => _$KanbanTaskCardResponseCopyWithImpl<KanbanTaskCardResponse>(this as KanbanTaskCardResponse, _$identity);

  /// Serializes this KanbanTaskCardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanbanTaskCardResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.taskCode, taskCode) || other.taskCode == taskCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.position, position) || other.position == position)&&(identical(other.primaryAssigneeUserId, primaryAssigneeUserId) || other.primaryAssigneeUserId == primaryAssigneeUserId)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.checklistTotal, checklistTotal) || other.checklistTotal == checklistTotal)&&(identical(other.checklistCompleted, checklistCompleted) || other.checklistCompleted == checklistCompleted)&&(identical(other.attachmentCount, attachmentCount) || other.attachmentCount == attachmentCount)&&(identical(other.version, version) || other.version == version)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.loggedMinutes, loggedMinutes) || other.loggedMinutes == loggedMinutes)&&(identical(other.subtaskTotal, subtaskTotal) || other.subtaskTotal == subtaskTotal)&&(identical(other.subtaskCompleted, subtaskCompleted) || other.subtaskCompleted == subtaskCompleted)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&const DeepCollectionEquality().equals(other.blockedByTaskIds, blockedByTaskIds)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFieldsSummary, customFieldsSummary)&&(identical(other.coverAttachmentId, coverAttachmentId) || other.coverAttachmentId == coverAttachmentId)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount)&&(identical(other.isWatchedByMe, isWatchedByMe) || other.isWatchedByMe == isWatchedByMe)&&const DeepCollectionEquality().equals(other.assigneeUserIds, assigneeUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,taskCode,title,status,priority,position,primaryAssigneeUserId,milestoneId,dueAtUtc,checklistTotal,checklistCompleted,attachmentCount,version,estimatedMinutes,loggedMinutes,subtaskTotal,subtaskCompleted,isBlocked,const DeepCollectionEquality().hash(blockedByTaskIds),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFieldsSummary),coverAttachmentId,customStatusId,recurrence,isPinned,watcherCount,isWatchedByMe,const DeepCollectionEquality().hash(assigneeUserIds)]);

@override
String toString() {
  return 'KanbanTaskCardResponse(id: $id, number: $number, taskCode: $taskCode, title: $title, status: $status, priority: $priority, position: $position, primaryAssigneeUserId: $primaryAssigneeUserId, milestoneId: $milestoneId, dueAtUtc: $dueAtUtc, checklistTotal: $checklistTotal, checklistCompleted: $checklistCompleted, attachmentCount: $attachmentCount, version: $version, estimatedMinutes: $estimatedMinutes, loggedMinutes: $loggedMinutes, subtaskTotal: $subtaskTotal, subtaskCompleted: $subtaskCompleted, isBlocked: $isBlocked, blockedByTaskIds: $blockedByTaskIds, labels: $labels, customFieldsSummary: $customFieldsSummary, coverAttachmentId: $coverAttachmentId, customStatusId: $customStatusId, recurrence: $recurrence, isPinned: $isPinned, watcherCount: $watcherCount, isWatchedByMe: $isWatchedByMe, assigneeUserIds: $assigneeUserIds)';
}


}

/// @nodoc
abstract mixin class $KanbanTaskCardResponseCopyWith<$Res>  {
  factory $KanbanTaskCardResponseCopyWith(KanbanTaskCardResponse value, $Res Function(KanbanTaskCardResponse) _then) = _$KanbanTaskCardResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String taskCode, String title, ProjectTaskStatus status, TaskPriority priority, int position, String? primaryAssigneeUserId, String? milestoneId, DateTime? dueAtUtc, int checklistTotal, int checklistCompleted, int attachmentCount, int version, int? estimatedMinutes, int? loggedMinutes, int subtaskTotal, int subtaskCompleted, bool isBlocked, List<String>? blockedByTaskIds, List<KanbanCardLabelResponse>? labels, List<KanbanCardCustomFieldResponse>? customFieldsSummary, String? coverAttachmentId, String? customStatusId, TaskRecurrenceSummaryResponse? recurrence, bool isPinned, int watcherCount, bool isWatchedByMe, List<String>? assigneeUserIds
});


$TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence;

}
/// @nodoc
class _$KanbanTaskCardResponseCopyWithImpl<$Res>
    implements $KanbanTaskCardResponseCopyWith<$Res> {
  _$KanbanTaskCardResponseCopyWithImpl(this._self, this._then);

  final KanbanTaskCardResponse _self;
  final $Res Function(KanbanTaskCardResponse) _then;

/// Create a copy of KanbanTaskCardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? taskCode = null,Object? title = null,Object? status = null,Object? priority = null,Object? position = null,Object? primaryAssigneeUserId = freezed,Object? milestoneId = freezed,Object? dueAtUtc = freezed,Object? checklistTotal = null,Object? checklistCompleted = null,Object? attachmentCount = null,Object? version = null,Object? estimatedMinutes = freezed,Object? loggedMinutes = freezed,Object? subtaskTotal = null,Object? subtaskCompleted = null,Object? isBlocked = null,Object? blockedByTaskIds = freezed,Object? labels = freezed,Object? customFieldsSummary = freezed,Object? coverAttachmentId = freezed,Object? customStatusId = freezed,Object? recurrence = freezed,Object? isPinned = null,Object? watcherCount = null,Object? isWatchedByMe = null,Object? assigneeUserIds = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,taskCode: null == taskCode ? _self.taskCode : taskCode // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,primaryAssigneeUserId: freezed == primaryAssigneeUserId ? _self.primaryAssigneeUserId : primaryAssigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,checklistTotal: null == checklistTotal ? _self.checklistTotal : checklistTotal // ignore: cast_nullable_to_non_nullable
as int,checklistCompleted: null == checklistCompleted ? _self.checklistCompleted : checklistCompleted // ignore: cast_nullable_to_non_nullable
as int,attachmentCount: null == attachmentCount ? _self.attachmentCount : attachmentCount // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,loggedMinutes: freezed == loggedMinutes ? _self.loggedMinutes : loggedMinutes // ignore: cast_nullable_to_non_nullable
as int?,subtaskTotal: null == subtaskTotal ? _self.subtaskTotal : subtaskTotal // ignore: cast_nullable_to_non_nullable
as int,subtaskCompleted: null == subtaskCompleted ? _self.subtaskCompleted : subtaskCompleted // ignore: cast_nullable_to_non_nullable
as int,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,blockedByTaskIds: freezed == blockedByTaskIds ? _self.blockedByTaskIds : blockedByTaskIds // ignore: cast_nullable_to_non_nullable
as List<String>?,labels: freezed == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<KanbanCardLabelResponse>?,customFieldsSummary: freezed == customFieldsSummary ? _self.customFieldsSummary : customFieldsSummary // ignore: cast_nullable_to_non_nullable
as List<KanbanCardCustomFieldResponse>?,coverAttachmentId: freezed == coverAttachmentId ? _self.coverAttachmentId : coverAttachmentId // ignore: cast_nullable_to_non_nullable
as String?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceSummaryResponse?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,watcherCount: null == watcherCount ? _self.watcherCount : watcherCount // ignore: cast_nullable_to_non_nullable
as int,isWatchedByMe: null == isWatchedByMe ? _self.isWatchedByMe : isWatchedByMe // ignore: cast_nullable_to_non_nullable
as bool,assigneeUserIds: freezed == assigneeUserIds ? _self.assigneeUserIds : assigneeUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}
/// Create a copy of KanbanTaskCardResponse
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


/// Adds pattern-matching-related methods to [KanbanTaskCardResponse].
extension KanbanTaskCardResponsePatterns on KanbanTaskCardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanbanTaskCardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanbanTaskCardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanbanTaskCardResponse value)  $default,){
final _that = this;
switch (_that) {
case _KanbanTaskCardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanbanTaskCardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _KanbanTaskCardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String taskCode,  String title,  ProjectTaskStatus status,  TaskPriority priority,  int position,  String? primaryAssigneeUserId,  String? milestoneId,  DateTime? dueAtUtc,  int checklistTotal,  int checklistCompleted,  int attachmentCount,  int version,  int? estimatedMinutes,  int? loggedMinutes,  int subtaskTotal,  int subtaskCompleted,  bool isBlocked,  List<String>? blockedByTaskIds,  List<KanbanCardLabelResponse>? labels,  List<KanbanCardCustomFieldResponse>? customFieldsSummary,  String? coverAttachmentId,  String? customStatusId,  TaskRecurrenceSummaryResponse? recurrence,  bool isPinned,  int watcherCount,  bool isWatchedByMe,  List<String>? assigneeUserIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanbanTaskCardResponse() when $default != null:
return $default(_that.id,_that.number,_that.taskCode,_that.title,_that.status,_that.priority,_that.position,_that.primaryAssigneeUserId,_that.milestoneId,_that.dueAtUtc,_that.checklistTotal,_that.checklistCompleted,_that.attachmentCount,_that.version,_that.estimatedMinutes,_that.loggedMinutes,_that.subtaskTotal,_that.subtaskCompleted,_that.isBlocked,_that.blockedByTaskIds,_that.labels,_that.customFieldsSummary,_that.coverAttachmentId,_that.customStatusId,_that.recurrence,_that.isPinned,_that.watcherCount,_that.isWatchedByMe,_that.assigneeUserIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String taskCode,  String title,  ProjectTaskStatus status,  TaskPriority priority,  int position,  String? primaryAssigneeUserId,  String? milestoneId,  DateTime? dueAtUtc,  int checklistTotal,  int checklistCompleted,  int attachmentCount,  int version,  int? estimatedMinutes,  int? loggedMinutes,  int subtaskTotal,  int subtaskCompleted,  bool isBlocked,  List<String>? blockedByTaskIds,  List<KanbanCardLabelResponse>? labels,  List<KanbanCardCustomFieldResponse>? customFieldsSummary,  String? coverAttachmentId,  String? customStatusId,  TaskRecurrenceSummaryResponse? recurrence,  bool isPinned,  int watcherCount,  bool isWatchedByMe,  List<String>? assigneeUserIds)  $default,) {final _that = this;
switch (_that) {
case _KanbanTaskCardResponse():
return $default(_that.id,_that.number,_that.taskCode,_that.title,_that.status,_that.priority,_that.position,_that.primaryAssigneeUserId,_that.milestoneId,_that.dueAtUtc,_that.checklistTotal,_that.checklistCompleted,_that.attachmentCount,_that.version,_that.estimatedMinutes,_that.loggedMinutes,_that.subtaskTotal,_that.subtaskCompleted,_that.isBlocked,_that.blockedByTaskIds,_that.labels,_that.customFieldsSummary,_that.coverAttachmentId,_that.customStatusId,_that.recurrence,_that.isPinned,_that.watcherCount,_that.isWatchedByMe,_that.assigneeUserIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String taskCode,  String title,  ProjectTaskStatus status,  TaskPriority priority,  int position,  String? primaryAssigneeUserId,  String? milestoneId,  DateTime? dueAtUtc,  int checklistTotal,  int checklistCompleted,  int attachmentCount,  int version,  int? estimatedMinutes,  int? loggedMinutes,  int subtaskTotal,  int subtaskCompleted,  bool isBlocked,  List<String>? blockedByTaskIds,  List<KanbanCardLabelResponse>? labels,  List<KanbanCardCustomFieldResponse>? customFieldsSummary,  String? coverAttachmentId,  String? customStatusId,  TaskRecurrenceSummaryResponse? recurrence,  bool isPinned,  int watcherCount,  bool isWatchedByMe,  List<String>? assigneeUserIds)?  $default,) {final _that = this;
switch (_that) {
case _KanbanTaskCardResponse() when $default != null:
return $default(_that.id,_that.number,_that.taskCode,_that.title,_that.status,_that.priority,_that.position,_that.primaryAssigneeUserId,_that.milestoneId,_that.dueAtUtc,_that.checklistTotal,_that.checklistCompleted,_that.attachmentCount,_that.version,_that.estimatedMinutes,_that.loggedMinutes,_that.subtaskTotal,_that.subtaskCompleted,_that.isBlocked,_that.blockedByTaskIds,_that.labels,_that.customFieldsSummary,_that.coverAttachmentId,_that.customStatusId,_that.recurrence,_that.isPinned,_that.watcherCount,_that.isWatchedByMe,_that.assigneeUserIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanbanTaskCardResponse implements KanbanTaskCardResponse {
  const _KanbanTaskCardResponse({required this.id, required this.number, required this.taskCode, required this.title, required this.status, required this.priority, required this.position, this.primaryAssigneeUserId, this.milestoneId, this.dueAtUtc, required this.checklistTotal, required this.checklistCompleted, required this.attachmentCount, required this.version, this.estimatedMinutes, this.loggedMinutes, this.subtaskTotal = 0, this.subtaskCompleted = 0, this.isBlocked = false, this.blockedByTaskIds, this.labels, this.customFieldsSummary, this.coverAttachmentId, this.customStatusId, this.recurrence, this.isPinned = false, this.watcherCount = 0, this.isWatchedByMe = false, this.assigneeUserIds});
  factory _KanbanTaskCardResponse.fromJson(Map<String, dynamic> json) => _$KanbanTaskCardResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String taskCode;
@override final  String title;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  int position;
@override final  String? primaryAssigneeUserId;
@override final  String? milestoneId;
@override final  DateTime? dueAtUtc;
@override final  int checklistTotal;
@override final  int checklistCompleted;
@override final  int attachmentCount;
@override final  int version;
@override final  int? estimatedMinutes;
@override final  int? loggedMinutes;
@override@JsonKey() final  int subtaskTotal;
@override@JsonKey() final  int subtaskCompleted;
@override@JsonKey() final  bool isBlocked;
@override final  List<String>? blockedByTaskIds;
@override final  List<KanbanCardLabelResponse>? labels;
@override final  List<KanbanCardCustomFieldResponse>? customFieldsSummary;
@override final  String? coverAttachmentId;
@override final  String? customStatusId;
@override final  TaskRecurrenceSummaryResponse? recurrence;
@override@JsonKey() final  bool isPinned;
@override@JsonKey() final  int watcherCount;
@override@JsonKey() final  bool isWatchedByMe;
@override final  List<String>? assigneeUserIds;

/// Create a copy of KanbanTaskCardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanbanTaskCardResponseCopyWith<_KanbanTaskCardResponse> get copyWith => __$KanbanTaskCardResponseCopyWithImpl<_KanbanTaskCardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanbanTaskCardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanbanTaskCardResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.taskCode, taskCode) || other.taskCode == taskCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.position, position) || other.position == position)&&(identical(other.primaryAssigneeUserId, primaryAssigneeUserId) || other.primaryAssigneeUserId == primaryAssigneeUserId)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.checklistTotal, checklistTotal) || other.checklistTotal == checklistTotal)&&(identical(other.checklistCompleted, checklistCompleted) || other.checklistCompleted == checklistCompleted)&&(identical(other.attachmentCount, attachmentCount) || other.attachmentCount == attachmentCount)&&(identical(other.version, version) || other.version == version)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.loggedMinutes, loggedMinutes) || other.loggedMinutes == loggedMinutes)&&(identical(other.subtaskTotal, subtaskTotal) || other.subtaskTotal == subtaskTotal)&&(identical(other.subtaskCompleted, subtaskCompleted) || other.subtaskCompleted == subtaskCompleted)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&const DeepCollectionEquality().equals(other.blockedByTaskIds, blockedByTaskIds)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFieldsSummary, customFieldsSummary)&&(identical(other.coverAttachmentId, coverAttachmentId) || other.coverAttachmentId == coverAttachmentId)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount)&&(identical(other.isWatchedByMe, isWatchedByMe) || other.isWatchedByMe == isWatchedByMe)&&const DeepCollectionEquality().equals(other.assigneeUserIds, assigneeUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,taskCode,title,status,priority,position,primaryAssigneeUserId,milestoneId,dueAtUtc,checklistTotal,checklistCompleted,attachmentCount,version,estimatedMinutes,loggedMinutes,subtaskTotal,subtaskCompleted,isBlocked,const DeepCollectionEquality().hash(blockedByTaskIds),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFieldsSummary),coverAttachmentId,customStatusId,recurrence,isPinned,watcherCount,isWatchedByMe,const DeepCollectionEquality().hash(assigneeUserIds)]);

@override
String toString() {
  return 'KanbanTaskCardResponse(id: $id, number: $number, taskCode: $taskCode, title: $title, status: $status, priority: $priority, position: $position, primaryAssigneeUserId: $primaryAssigneeUserId, milestoneId: $milestoneId, dueAtUtc: $dueAtUtc, checklistTotal: $checklistTotal, checklistCompleted: $checklistCompleted, attachmentCount: $attachmentCount, version: $version, estimatedMinutes: $estimatedMinutes, loggedMinutes: $loggedMinutes, subtaskTotal: $subtaskTotal, subtaskCompleted: $subtaskCompleted, isBlocked: $isBlocked, blockedByTaskIds: $blockedByTaskIds, labels: $labels, customFieldsSummary: $customFieldsSummary, coverAttachmentId: $coverAttachmentId, customStatusId: $customStatusId, recurrence: $recurrence, isPinned: $isPinned, watcherCount: $watcherCount, isWatchedByMe: $isWatchedByMe, assigneeUserIds: $assigneeUserIds)';
}


}

/// @nodoc
abstract mixin class _$KanbanTaskCardResponseCopyWith<$Res> implements $KanbanTaskCardResponseCopyWith<$Res> {
  factory _$KanbanTaskCardResponseCopyWith(_KanbanTaskCardResponse value, $Res Function(_KanbanTaskCardResponse) _then) = __$KanbanTaskCardResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String taskCode, String title, ProjectTaskStatus status, TaskPriority priority, int position, String? primaryAssigneeUserId, String? milestoneId, DateTime? dueAtUtc, int checklistTotal, int checklistCompleted, int attachmentCount, int version, int? estimatedMinutes, int? loggedMinutes, int subtaskTotal, int subtaskCompleted, bool isBlocked, List<String>? blockedByTaskIds, List<KanbanCardLabelResponse>? labels, List<KanbanCardCustomFieldResponse>? customFieldsSummary, String? coverAttachmentId, String? customStatusId, TaskRecurrenceSummaryResponse? recurrence, bool isPinned, int watcherCount, bool isWatchedByMe, List<String>? assigneeUserIds
});


@override $TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence;

}
/// @nodoc
class __$KanbanTaskCardResponseCopyWithImpl<$Res>
    implements _$KanbanTaskCardResponseCopyWith<$Res> {
  __$KanbanTaskCardResponseCopyWithImpl(this._self, this._then);

  final _KanbanTaskCardResponse _self;
  final $Res Function(_KanbanTaskCardResponse) _then;

/// Create a copy of KanbanTaskCardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? taskCode = null,Object? title = null,Object? status = null,Object? priority = null,Object? position = null,Object? primaryAssigneeUserId = freezed,Object? milestoneId = freezed,Object? dueAtUtc = freezed,Object? checklistTotal = null,Object? checklistCompleted = null,Object? attachmentCount = null,Object? version = null,Object? estimatedMinutes = freezed,Object? loggedMinutes = freezed,Object? subtaskTotal = null,Object? subtaskCompleted = null,Object? isBlocked = null,Object? blockedByTaskIds = freezed,Object? labels = freezed,Object? customFieldsSummary = freezed,Object? coverAttachmentId = freezed,Object? customStatusId = freezed,Object? recurrence = freezed,Object? isPinned = null,Object? watcherCount = null,Object? isWatchedByMe = null,Object? assigneeUserIds = freezed,}) {
  return _then(_KanbanTaskCardResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,taskCode: null == taskCode ? _self.taskCode : taskCode // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,primaryAssigneeUserId: freezed == primaryAssigneeUserId ? _self.primaryAssigneeUserId : primaryAssigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,checklistTotal: null == checklistTotal ? _self.checklistTotal : checklistTotal // ignore: cast_nullable_to_non_nullable
as int,checklistCompleted: null == checklistCompleted ? _self.checklistCompleted : checklistCompleted // ignore: cast_nullable_to_non_nullable
as int,attachmentCount: null == attachmentCount ? _self.attachmentCount : attachmentCount // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,loggedMinutes: freezed == loggedMinutes ? _self.loggedMinutes : loggedMinutes // ignore: cast_nullable_to_non_nullable
as int?,subtaskTotal: null == subtaskTotal ? _self.subtaskTotal : subtaskTotal // ignore: cast_nullable_to_non_nullable
as int,subtaskCompleted: null == subtaskCompleted ? _self.subtaskCompleted : subtaskCompleted // ignore: cast_nullable_to_non_nullable
as int,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,blockedByTaskIds: freezed == blockedByTaskIds ? _self.blockedByTaskIds : blockedByTaskIds // ignore: cast_nullable_to_non_nullable
as List<String>?,labels: freezed == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<KanbanCardLabelResponse>?,customFieldsSummary: freezed == customFieldsSummary ? _self.customFieldsSummary : customFieldsSummary // ignore: cast_nullable_to_non_nullable
as List<KanbanCardCustomFieldResponse>?,coverAttachmentId: freezed == coverAttachmentId ? _self.coverAttachmentId : coverAttachmentId // ignore: cast_nullable_to_non_nullable
as String?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceSummaryResponse?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,watcherCount: null == watcherCount ? _self.watcherCount : watcherCount // ignore: cast_nullable_to_non_nullable
as int,isWatchedByMe: null == isWatchedByMe ? _self.isWatchedByMe : isWatchedByMe // ignore: cast_nullable_to_non_nullable
as bool,assigneeUserIds: freezed == assigneeUserIds ? _self.assigneeUserIds : assigneeUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

/// Create a copy of KanbanTaskCardResponse
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
mixin _$AssigneeKanbanGroupResponse {

 String? get assigneeUserId; String get displayName; String? get avatarUrl; bool get isCurrentUser; int get totalTaskCount; List<KanbanTaskCardResponse> get tasks; String? get nextCursor;
/// Create a copy of AssigneeKanbanGroupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssigneeKanbanGroupResponseCopyWith<AssigneeKanbanGroupResponse> get copyWith => _$AssigneeKanbanGroupResponseCopyWithImpl<AssigneeKanbanGroupResponse>(this as AssigneeKanbanGroupResponse, _$identity);

  /// Serializes this AssigneeKanbanGroupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssigneeKanbanGroupResponse&&(identical(other.assigneeUserId, assigneeUserId) || other.assigneeUserId == assigneeUserId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isCurrentUser, isCurrentUser) || other.isCurrentUser == isCurrentUser)&&(identical(other.totalTaskCount, totalTaskCount) || other.totalTaskCount == totalTaskCount)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assigneeUserId,displayName,avatarUrl,isCurrentUser,totalTaskCount,const DeepCollectionEquality().hash(tasks),nextCursor);

@override
String toString() {
  return 'AssigneeKanbanGroupResponse(assigneeUserId: $assigneeUserId, displayName: $displayName, avatarUrl: $avatarUrl, isCurrentUser: $isCurrentUser, totalTaskCount: $totalTaskCount, tasks: $tasks, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $AssigneeKanbanGroupResponseCopyWith<$Res>  {
  factory $AssigneeKanbanGroupResponseCopyWith(AssigneeKanbanGroupResponse value, $Res Function(AssigneeKanbanGroupResponse) _then) = _$AssigneeKanbanGroupResponseCopyWithImpl;
@useResult
$Res call({
 String? assigneeUserId, String displayName, String? avatarUrl, bool isCurrentUser, int totalTaskCount, List<KanbanTaskCardResponse> tasks, String? nextCursor
});




}
/// @nodoc
class _$AssigneeKanbanGroupResponseCopyWithImpl<$Res>
    implements $AssigneeKanbanGroupResponseCopyWith<$Res> {
  _$AssigneeKanbanGroupResponseCopyWithImpl(this._self, this._then);

  final AssigneeKanbanGroupResponse _self;
  final $Res Function(AssigneeKanbanGroupResponse) _then;

/// Create a copy of AssigneeKanbanGroupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assigneeUserId = freezed,Object? displayName = null,Object? avatarUrl = freezed,Object? isCurrentUser = null,Object? totalTaskCount = null,Object? tasks = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
assigneeUserId: freezed == assigneeUserId ? _self.assigneeUserId : assigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isCurrentUser: null == isCurrentUser ? _self.isCurrentUser : isCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,totalTaskCount: null == totalTaskCount ? _self.totalTaskCount : totalTaskCount // ignore: cast_nullable_to_non_nullable
as int,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<KanbanTaskCardResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssigneeKanbanGroupResponse].
extension AssigneeKanbanGroupResponsePatterns on AssigneeKanbanGroupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssigneeKanbanGroupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssigneeKanbanGroupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssigneeKanbanGroupResponse value)  $default,){
final _that = this;
switch (_that) {
case _AssigneeKanbanGroupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssigneeKanbanGroupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AssigneeKanbanGroupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? assigneeUserId,  String displayName,  String? avatarUrl,  bool isCurrentUser,  int totalTaskCount,  List<KanbanTaskCardResponse> tasks,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssigneeKanbanGroupResponse() when $default != null:
return $default(_that.assigneeUserId,_that.displayName,_that.avatarUrl,_that.isCurrentUser,_that.totalTaskCount,_that.tasks,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? assigneeUserId,  String displayName,  String? avatarUrl,  bool isCurrentUser,  int totalTaskCount,  List<KanbanTaskCardResponse> tasks,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _AssigneeKanbanGroupResponse():
return $default(_that.assigneeUserId,_that.displayName,_that.avatarUrl,_that.isCurrentUser,_that.totalTaskCount,_that.tasks,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? assigneeUserId,  String displayName,  String? avatarUrl,  bool isCurrentUser,  int totalTaskCount,  List<KanbanTaskCardResponse> tasks,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _AssigneeKanbanGroupResponse() when $default != null:
return $default(_that.assigneeUserId,_that.displayName,_that.avatarUrl,_that.isCurrentUser,_that.totalTaskCount,_that.tasks,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssigneeKanbanGroupResponse implements AssigneeKanbanGroupResponse {
  const _AssigneeKanbanGroupResponse({this.assigneeUserId, required this.displayName, this.avatarUrl, this.isCurrentUser = false, required this.totalTaskCount, required this.tasks, this.nextCursor});
  factory _AssigneeKanbanGroupResponse.fromJson(Map<String, dynamic> json) => _$AssigneeKanbanGroupResponseFromJson(json);

@override final  String? assigneeUserId;
@override final  String displayName;
@override final  String? avatarUrl;
@override@JsonKey() final  bool isCurrentUser;
@override final  int totalTaskCount;
@override final  List<KanbanTaskCardResponse> tasks;
@override final  String? nextCursor;

/// Create a copy of AssigneeKanbanGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssigneeKanbanGroupResponseCopyWith<_AssigneeKanbanGroupResponse> get copyWith => __$AssigneeKanbanGroupResponseCopyWithImpl<_AssigneeKanbanGroupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssigneeKanbanGroupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssigneeKanbanGroupResponse&&(identical(other.assigneeUserId, assigneeUserId) || other.assigneeUserId == assigneeUserId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isCurrentUser, isCurrentUser) || other.isCurrentUser == isCurrentUser)&&(identical(other.totalTaskCount, totalTaskCount) || other.totalTaskCount == totalTaskCount)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assigneeUserId,displayName,avatarUrl,isCurrentUser,totalTaskCount,const DeepCollectionEquality().hash(tasks),nextCursor);

@override
String toString() {
  return 'AssigneeKanbanGroupResponse(assigneeUserId: $assigneeUserId, displayName: $displayName, avatarUrl: $avatarUrl, isCurrentUser: $isCurrentUser, totalTaskCount: $totalTaskCount, tasks: $tasks, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$AssigneeKanbanGroupResponseCopyWith<$Res> implements $AssigneeKanbanGroupResponseCopyWith<$Res> {
  factory _$AssigneeKanbanGroupResponseCopyWith(_AssigneeKanbanGroupResponse value, $Res Function(_AssigneeKanbanGroupResponse) _then) = __$AssigneeKanbanGroupResponseCopyWithImpl;
@override @useResult
$Res call({
 String? assigneeUserId, String displayName, String? avatarUrl, bool isCurrentUser, int totalTaskCount, List<KanbanTaskCardResponse> tasks, String? nextCursor
});




}
/// @nodoc
class __$AssigneeKanbanGroupResponseCopyWithImpl<$Res>
    implements _$AssigneeKanbanGroupResponseCopyWith<$Res> {
  __$AssigneeKanbanGroupResponseCopyWithImpl(this._self, this._then);

  final _AssigneeKanbanGroupResponse _self;
  final $Res Function(_AssigneeKanbanGroupResponse) _then;

/// Create a copy of AssigneeKanbanGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assigneeUserId = freezed,Object? displayName = null,Object? avatarUrl = freezed,Object? isCurrentUser = null,Object? totalTaskCount = null,Object? tasks = null,Object? nextCursor = freezed,}) {
  return _then(_AssigneeKanbanGroupResponse(
assigneeUserId: freezed == assigneeUserId ? _self.assigneeUserId : assigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isCurrentUser: null == isCurrentUser ? _self.isCurrentUser : isCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,totalTaskCount: null == totalTaskCount ? _self.totalTaskCount : totalTaskCount // ignore: cast_nullable_to_non_nullable
as int,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<KanbanTaskCardResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AssigneeKanbanBoardResponse {

 String get projectId; KanbanSwimlaneMode get grouping; int get settingsVersion; List<KanbanCardField> get visibleCardFields; KanbanCardDensity get defaultCardDensity; List<AssigneeKanbanGroupResponse> get groups;
/// Create a copy of AssigneeKanbanBoardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssigneeKanbanBoardResponseCopyWith<AssigneeKanbanBoardResponse> get copyWith => _$AssigneeKanbanBoardResponseCopyWithImpl<AssigneeKanbanBoardResponse>(this as AssigneeKanbanBoardResponse, _$identity);

  /// Serializes this AssigneeKanbanBoardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssigneeKanbanBoardResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.grouping, grouping) || other.grouping == grouping)&&(identical(other.settingsVersion, settingsVersion) || other.settingsVersion == settingsVersion)&&const DeepCollectionEquality().equals(other.visibleCardFields, visibleCardFields)&&(identical(other.defaultCardDensity, defaultCardDensity) || other.defaultCardDensity == defaultCardDensity)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,grouping,settingsVersion,const DeepCollectionEquality().hash(visibleCardFields),defaultCardDensity,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'AssigneeKanbanBoardResponse(projectId: $projectId, grouping: $grouping, settingsVersion: $settingsVersion, visibleCardFields: $visibleCardFields, defaultCardDensity: $defaultCardDensity, groups: $groups)';
}


}

/// @nodoc
abstract mixin class $AssigneeKanbanBoardResponseCopyWith<$Res>  {
  factory $AssigneeKanbanBoardResponseCopyWith(AssigneeKanbanBoardResponse value, $Res Function(AssigneeKanbanBoardResponse) _then) = _$AssigneeKanbanBoardResponseCopyWithImpl;
@useResult
$Res call({
 String projectId, KanbanSwimlaneMode grouping, int settingsVersion, List<KanbanCardField> visibleCardFields, KanbanCardDensity defaultCardDensity, List<AssigneeKanbanGroupResponse> groups
});




}
/// @nodoc
class _$AssigneeKanbanBoardResponseCopyWithImpl<$Res>
    implements $AssigneeKanbanBoardResponseCopyWith<$Res> {
  _$AssigneeKanbanBoardResponseCopyWithImpl(this._self, this._then);

  final AssigneeKanbanBoardResponse _self;
  final $Res Function(AssigneeKanbanBoardResponse) _then;

/// Create a copy of AssigneeKanbanBoardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? grouping = null,Object? settingsVersion = null,Object? visibleCardFields = null,Object? defaultCardDensity = null,Object? groups = null,}) {
  return _then(_self.copyWith(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,grouping: null == grouping ? _self.grouping : grouping // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode,settingsVersion: null == settingsVersion ? _self.settingsVersion : settingsVersion // ignore: cast_nullable_to_non_nullable
as int,visibleCardFields: null == visibleCardFields ? _self.visibleCardFields : visibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>,defaultCardDensity: null == defaultCardDensity ? _self.defaultCardDensity : defaultCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<AssigneeKanbanGroupResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [AssigneeKanbanBoardResponse].
extension AssigneeKanbanBoardResponsePatterns on AssigneeKanbanBoardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssigneeKanbanBoardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssigneeKanbanBoardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssigneeKanbanBoardResponse value)  $default,){
final _that = this;
switch (_that) {
case _AssigneeKanbanBoardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssigneeKanbanBoardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AssigneeKanbanBoardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  KanbanSwimlaneMode grouping,  int settingsVersion,  List<KanbanCardField> visibleCardFields,  KanbanCardDensity defaultCardDensity,  List<AssigneeKanbanGroupResponse> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssigneeKanbanBoardResponse() when $default != null:
return $default(_that.projectId,_that.grouping,_that.settingsVersion,_that.visibleCardFields,_that.defaultCardDensity,_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  KanbanSwimlaneMode grouping,  int settingsVersion,  List<KanbanCardField> visibleCardFields,  KanbanCardDensity defaultCardDensity,  List<AssigneeKanbanGroupResponse> groups)  $default,) {final _that = this;
switch (_that) {
case _AssigneeKanbanBoardResponse():
return $default(_that.projectId,_that.grouping,_that.settingsVersion,_that.visibleCardFields,_that.defaultCardDensity,_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  KanbanSwimlaneMode grouping,  int settingsVersion,  List<KanbanCardField> visibleCardFields,  KanbanCardDensity defaultCardDensity,  List<AssigneeKanbanGroupResponse> groups)?  $default,) {final _that = this;
switch (_that) {
case _AssigneeKanbanBoardResponse() when $default != null:
return $default(_that.projectId,_that.grouping,_that.settingsVersion,_that.visibleCardFields,_that.defaultCardDensity,_that.groups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssigneeKanbanBoardResponse implements AssigneeKanbanBoardResponse {
  const _AssigneeKanbanBoardResponse({required this.projectId, required this.grouping, required this.settingsVersion, required this.visibleCardFields, required this.defaultCardDensity, required this.groups});
  factory _AssigneeKanbanBoardResponse.fromJson(Map<String, dynamic> json) => _$AssigneeKanbanBoardResponseFromJson(json);

@override final  String projectId;
@override final  KanbanSwimlaneMode grouping;
@override final  int settingsVersion;
@override final  List<KanbanCardField> visibleCardFields;
@override final  KanbanCardDensity defaultCardDensity;
@override final  List<AssigneeKanbanGroupResponse> groups;

/// Create a copy of AssigneeKanbanBoardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssigneeKanbanBoardResponseCopyWith<_AssigneeKanbanBoardResponse> get copyWith => __$AssigneeKanbanBoardResponseCopyWithImpl<_AssigneeKanbanBoardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssigneeKanbanBoardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssigneeKanbanBoardResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.grouping, grouping) || other.grouping == grouping)&&(identical(other.settingsVersion, settingsVersion) || other.settingsVersion == settingsVersion)&&const DeepCollectionEquality().equals(other.visibleCardFields, visibleCardFields)&&(identical(other.defaultCardDensity, defaultCardDensity) || other.defaultCardDensity == defaultCardDensity)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,grouping,settingsVersion,const DeepCollectionEquality().hash(visibleCardFields),defaultCardDensity,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'AssigneeKanbanBoardResponse(projectId: $projectId, grouping: $grouping, settingsVersion: $settingsVersion, visibleCardFields: $visibleCardFields, defaultCardDensity: $defaultCardDensity, groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$AssigneeKanbanBoardResponseCopyWith<$Res> implements $AssigneeKanbanBoardResponseCopyWith<$Res> {
  factory _$AssigneeKanbanBoardResponseCopyWith(_AssigneeKanbanBoardResponse value, $Res Function(_AssigneeKanbanBoardResponse) _then) = __$AssigneeKanbanBoardResponseCopyWithImpl;
@override @useResult
$Res call({
 String projectId, KanbanSwimlaneMode grouping, int settingsVersion, List<KanbanCardField> visibleCardFields, KanbanCardDensity defaultCardDensity, List<AssigneeKanbanGroupResponse> groups
});




}
/// @nodoc
class __$AssigneeKanbanBoardResponseCopyWithImpl<$Res>
    implements _$AssigneeKanbanBoardResponseCopyWith<$Res> {
  __$AssigneeKanbanBoardResponseCopyWithImpl(this._self, this._then);

  final _AssigneeKanbanBoardResponse _self;
  final $Res Function(_AssigneeKanbanBoardResponse) _then;

/// Create a copy of AssigneeKanbanBoardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? grouping = null,Object? settingsVersion = null,Object? visibleCardFields = null,Object? defaultCardDensity = null,Object? groups = null,}) {
  return _then(_AssigneeKanbanBoardResponse(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,grouping: null == grouping ? _self.grouping : grouping // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode,settingsVersion: null == settingsVersion ? _self.settingsVersion : settingsVersion // ignore: cast_nullable_to_non_nullable
as int,visibleCardFields: null == visibleCardFields ? _self.visibleCardFields : visibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>,defaultCardDensity: null == defaultCardDensity ? _self.defaultCardDensity : defaultCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<AssigneeKanbanGroupResponse>,
  ));
}


}


/// @nodoc
mixin _$ChangeKanbanPrimaryAssigneePayload {

 String? get targetUserId; int get expectedVersion;
/// Create a copy of ChangeKanbanPrimaryAssigneePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeKanbanPrimaryAssigneePayloadCopyWith<ChangeKanbanPrimaryAssigneePayload> get copyWith => _$ChangeKanbanPrimaryAssigneePayloadCopyWithImpl<ChangeKanbanPrimaryAssigneePayload>(this as ChangeKanbanPrimaryAssigneePayload, _$identity);

  /// Serializes this ChangeKanbanPrimaryAssigneePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeKanbanPrimaryAssigneePayload&&(identical(other.targetUserId, targetUserId) || other.targetUserId == targetUserId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetUserId,expectedVersion);

@override
String toString() {
  return 'ChangeKanbanPrimaryAssigneePayload(targetUserId: $targetUserId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $ChangeKanbanPrimaryAssigneePayloadCopyWith<$Res>  {
  factory $ChangeKanbanPrimaryAssigneePayloadCopyWith(ChangeKanbanPrimaryAssigneePayload value, $Res Function(ChangeKanbanPrimaryAssigneePayload) _then) = _$ChangeKanbanPrimaryAssigneePayloadCopyWithImpl;
@useResult
$Res call({
 String? targetUserId, int expectedVersion
});




}
/// @nodoc
class _$ChangeKanbanPrimaryAssigneePayloadCopyWithImpl<$Res>
    implements $ChangeKanbanPrimaryAssigneePayloadCopyWith<$Res> {
  _$ChangeKanbanPrimaryAssigneePayloadCopyWithImpl(this._self, this._then);

  final ChangeKanbanPrimaryAssigneePayload _self;
  final $Res Function(ChangeKanbanPrimaryAssigneePayload) _then;

/// Create a copy of ChangeKanbanPrimaryAssigneePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetUserId = freezed,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
targetUserId: freezed == targetUserId ? _self.targetUserId : targetUserId // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangeKanbanPrimaryAssigneePayload].
extension ChangeKanbanPrimaryAssigneePayloadPatterns on ChangeKanbanPrimaryAssigneePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeKanbanPrimaryAssigneePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeKanbanPrimaryAssigneePayload value)  $default,){
final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeKanbanPrimaryAssigneePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? targetUserId,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneePayload() when $default != null:
return $default(_that.targetUserId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? targetUserId,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneePayload():
return $default(_that.targetUserId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? targetUserId,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneePayload() when $default != null:
return $default(_that.targetUserId,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChangeKanbanPrimaryAssigneePayload implements ChangeKanbanPrimaryAssigneePayload {
  const _ChangeKanbanPrimaryAssigneePayload({this.targetUserId, required this.expectedVersion});
  factory _ChangeKanbanPrimaryAssigneePayload.fromJson(Map<String, dynamic> json) => _$ChangeKanbanPrimaryAssigneePayloadFromJson(json);

@override final  String? targetUserId;
@override final  int expectedVersion;

/// Create a copy of ChangeKanbanPrimaryAssigneePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeKanbanPrimaryAssigneePayloadCopyWith<_ChangeKanbanPrimaryAssigneePayload> get copyWith => __$ChangeKanbanPrimaryAssigneePayloadCopyWithImpl<_ChangeKanbanPrimaryAssigneePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangeKanbanPrimaryAssigneePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeKanbanPrimaryAssigneePayload&&(identical(other.targetUserId, targetUserId) || other.targetUserId == targetUserId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetUserId,expectedVersion);

@override
String toString() {
  return 'ChangeKanbanPrimaryAssigneePayload(targetUserId: $targetUserId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$ChangeKanbanPrimaryAssigneePayloadCopyWith<$Res> implements $ChangeKanbanPrimaryAssigneePayloadCopyWith<$Res> {
  factory _$ChangeKanbanPrimaryAssigneePayloadCopyWith(_ChangeKanbanPrimaryAssigneePayload value, $Res Function(_ChangeKanbanPrimaryAssigneePayload) _then) = __$ChangeKanbanPrimaryAssigneePayloadCopyWithImpl;
@override @useResult
$Res call({
 String? targetUserId, int expectedVersion
});




}
/// @nodoc
class __$ChangeKanbanPrimaryAssigneePayloadCopyWithImpl<$Res>
    implements _$ChangeKanbanPrimaryAssigneePayloadCopyWith<$Res> {
  __$ChangeKanbanPrimaryAssigneePayloadCopyWithImpl(this._self, this._then);

  final _ChangeKanbanPrimaryAssigneePayload _self;
  final $Res Function(_ChangeKanbanPrimaryAssigneePayload) _then;

/// Create a copy of ChangeKanbanPrimaryAssigneePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetUserId = freezed,Object? expectedVersion = null,}) {
  return _then(_ChangeKanbanPrimaryAssigneePayload(
targetUserId: freezed == targetUserId ? _self.targetUserId : targetUserId // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChangeKanbanPrimaryAssigneeResponse {

 KanbanTaskCardResponse get task; String? get previousAssigneeUserId; int get previousGroupTaskCount; String? get targetAssigneeUserId; int get targetGroupTaskCount;
/// Create a copy of ChangeKanbanPrimaryAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeKanbanPrimaryAssigneeResponseCopyWith<ChangeKanbanPrimaryAssigneeResponse> get copyWith => _$ChangeKanbanPrimaryAssigneeResponseCopyWithImpl<ChangeKanbanPrimaryAssigneeResponse>(this as ChangeKanbanPrimaryAssigneeResponse, _$identity);

  /// Serializes this ChangeKanbanPrimaryAssigneeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeKanbanPrimaryAssigneeResponse&&(identical(other.task, task) || other.task == task)&&(identical(other.previousAssigneeUserId, previousAssigneeUserId) || other.previousAssigneeUserId == previousAssigneeUserId)&&(identical(other.previousGroupTaskCount, previousGroupTaskCount) || other.previousGroupTaskCount == previousGroupTaskCount)&&(identical(other.targetAssigneeUserId, targetAssigneeUserId) || other.targetAssigneeUserId == targetAssigneeUserId)&&(identical(other.targetGroupTaskCount, targetGroupTaskCount) || other.targetGroupTaskCount == targetGroupTaskCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,previousAssigneeUserId,previousGroupTaskCount,targetAssigneeUserId,targetGroupTaskCount);

@override
String toString() {
  return 'ChangeKanbanPrimaryAssigneeResponse(task: $task, previousAssigneeUserId: $previousAssigneeUserId, previousGroupTaskCount: $previousGroupTaskCount, targetAssigneeUserId: $targetAssigneeUserId, targetGroupTaskCount: $targetGroupTaskCount)';
}


}

/// @nodoc
abstract mixin class $ChangeKanbanPrimaryAssigneeResponseCopyWith<$Res>  {
  factory $ChangeKanbanPrimaryAssigneeResponseCopyWith(ChangeKanbanPrimaryAssigneeResponse value, $Res Function(ChangeKanbanPrimaryAssigneeResponse) _then) = _$ChangeKanbanPrimaryAssigneeResponseCopyWithImpl;
@useResult
$Res call({
 KanbanTaskCardResponse task, String? previousAssigneeUserId, int previousGroupTaskCount, String? targetAssigneeUserId, int targetGroupTaskCount
});


$KanbanTaskCardResponseCopyWith<$Res> get task;

}
/// @nodoc
class _$ChangeKanbanPrimaryAssigneeResponseCopyWithImpl<$Res>
    implements $ChangeKanbanPrimaryAssigneeResponseCopyWith<$Res> {
  _$ChangeKanbanPrimaryAssigneeResponseCopyWithImpl(this._self, this._then);

  final ChangeKanbanPrimaryAssigneeResponse _self;
  final $Res Function(ChangeKanbanPrimaryAssigneeResponse) _then;

/// Create a copy of ChangeKanbanPrimaryAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? previousAssigneeUserId = freezed,Object? previousGroupTaskCount = null,Object? targetAssigneeUserId = freezed,Object? targetGroupTaskCount = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as KanbanTaskCardResponse,previousAssigneeUserId: freezed == previousAssigneeUserId ? _self.previousAssigneeUserId : previousAssigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,previousGroupTaskCount: null == previousGroupTaskCount ? _self.previousGroupTaskCount : previousGroupTaskCount // ignore: cast_nullable_to_non_nullable
as int,targetAssigneeUserId: freezed == targetAssigneeUserId ? _self.targetAssigneeUserId : targetAssigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,targetGroupTaskCount: null == targetGroupTaskCount ? _self.targetGroupTaskCount : targetGroupTaskCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ChangeKanbanPrimaryAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanbanTaskCardResponseCopyWith<$Res> get task {

  return $KanbanTaskCardResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChangeKanbanPrimaryAssigneeResponse].
extension ChangeKanbanPrimaryAssigneeResponsePatterns on ChangeKanbanPrimaryAssigneeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeKanbanPrimaryAssigneeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeKanbanPrimaryAssigneeResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeKanbanPrimaryAssigneeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KanbanTaskCardResponse task,  String? previousAssigneeUserId,  int previousGroupTaskCount,  String? targetAssigneeUserId,  int targetGroupTaskCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneeResponse() when $default != null:
return $default(_that.task,_that.previousAssigneeUserId,_that.previousGroupTaskCount,_that.targetAssigneeUserId,_that.targetGroupTaskCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KanbanTaskCardResponse task,  String? previousAssigneeUserId,  int previousGroupTaskCount,  String? targetAssigneeUserId,  int targetGroupTaskCount)  $default,) {final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneeResponse():
return $default(_that.task,_that.previousAssigneeUserId,_that.previousGroupTaskCount,_that.targetAssigneeUserId,_that.targetGroupTaskCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KanbanTaskCardResponse task,  String? previousAssigneeUserId,  int previousGroupTaskCount,  String? targetAssigneeUserId,  int targetGroupTaskCount)?  $default,) {final _that = this;
switch (_that) {
case _ChangeKanbanPrimaryAssigneeResponse() when $default != null:
return $default(_that.task,_that.previousAssigneeUserId,_that.previousGroupTaskCount,_that.targetAssigneeUserId,_that.targetGroupTaskCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChangeKanbanPrimaryAssigneeResponse implements ChangeKanbanPrimaryAssigneeResponse {
  const _ChangeKanbanPrimaryAssigneeResponse({required this.task, this.previousAssigneeUserId, required this.previousGroupTaskCount, this.targetAssigneeUserId, required this.targetGroupTaskCount});
  factory _ChangeKanbanPrimaryAssigneeResponse.fromJson(Map<String, dynamic> json) => _$ChangeKanbanPrimaryAssigneeResponseFromJson(json);

@override final  KanbanTaskCardResponse task;
@override final  String? previousAssigneeUserId;
@override final  int previousGroupTaskCount;
@override final  String? targetAssigneeUserId;
@override final  int targetGroupTaskCount;

/// Create a copy of ChangeKanbanPrimaryAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeKanbanPrimaryAssigneeResponseCopyWith<_ChangeKanbanPrimaryAssigneeResponse> get copyWith => __$ChangeKanbanPrimaryAssigneeResponseCopyWithImpl<_ChangeKanbanPrimaryAssigneeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangeKanbanPrimaryAssigneeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeKanbanPrimaryAssigneeResponse&&(identical(other.task, task) || other.task == task)&&(identical(other.previousAssigneeUserId, previousAssigneeUserId) || other.previousAssigneeUserId == previousAssigneeUserId)&&(identical(other.previousGroupTaskCount, previousGroupTaskCount) || other.previousGroupTaskCount == previousGroupTaskCount)&&(identical(other.targetAssigneeUserId, targetAssigneeUserId) || other.targetAssigneeUserId == targetAssigneeUserId)&&(identical(other.targetGroupTaskCount, targetGroupTaskCount) || other.targetGroupTaskCount == targetGroupTaskCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,previousAssigneeUserId,previousGroupTaskCount,targetAssigneeUserId,targetGroupTaskCount);

@override
String toString() {
  return 'ChangeKanbanPrimaryAssigneeResponse(task: $task, previousAssigneeUserId: $previousAssigneeUserId, previousGroupTaskCount: $previousGroupTaskCount, targetAssigneeUserId: $targetAssigneeUserId, targetGroupTaskCount: $targetGroupTaskCount)';
}


}

/// @nodoc
abstract mixin class _$ChangeKanbanPrimaryAssigneeResponseCopyWith<$Res> implements $ChangeKanbanPrimaryAssigneeResponseCopyWith<$Res> {
  factory _$ChangeKanbanPrimaryAssigneeResponseCopyWith(_ChangeKanbanPrimaryAssigneeResponse value, $Res Function(_ChangeKanbanPrimaryAssigneeResponse) _then) = __$ChangeKanbanPrimaryAssigneeResponseCopyWithImpl;
@override @useResult
$Res call({
 KanbanTaskCardResponse task, String? previousAssigneeUserId, int previousGroupTaskCount, String? targetAssigneeUserId, int targetGroupTaskCount
});


@override $KanbanTaskCardResponseCopyWith<$Res> get task;

}
/// @nodoc
class __$ChangeKanbanPrimaryAssigneeResponseCopyWithImpl<$Res>
    implements _$ChangeKanbanPrimaryAssigneeResponseCopyWith<$Res> {
  __$ChangeKanbanPrimaryAssigneeResponseCopyWithImpl(this._self, this._then);

  final _ChangeKanbanPrimaryAssigneeResponse _self;
  final $Res Function(_ChangeKanbanPrimaryAssigneeResponse) _then;

/// Create a copy of ChangeKanbanPrimaryAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? previousAssigneeUserId = freezed,Object? previousGroupTaskCount = null,Object? targetAssigneeUserId = freezed,Object? targetGroupTaskCount = null,}) {
  return _then(_ChangeKanbanPrimaryAssigneeResponse(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as KanbanTaskCardResponse,previousAssigneeUserId: freezed == previousAssigneeUserId ? _self.previousAssigneeUserId : previousAssigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,previousGroupTaskCount: null == previousGroupTaskCount ? _self.previousGroupTaskCount : previousGroupTaskCount // ignore: cast_nullable_to_non_nullable
as int,targetAssigneeUserId: freezed == targetAssigneeUserId ? _self.targetAssigneeUserId : targetAssigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,targetGroupTaskCount: null == targetGroupTaskCount ? _self.targetGroupTaskCount : targetGroupTaskCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ChangeKanbanPrimaryAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanbanTaskCardResponseCopyWith<$Res> get task {

  return $KanbanTaskCardResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// @nodoc
mixin _$KanbanColumnResponse {

 ProjectTaskStatus get status; String get displayName; String get color; int? get wipLimit; int get totalTaskCount; bool get isWipLimitExceeded; List<KanbanTaskCardResponse> get tasks; String? get nextCursor; String? get customStatusId;
/// Create a copy of KanbanColumnResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanbanColumnResponseCopyWith<KanbanColumnResponse> get copyWith => _$KanbanColumnResponseCopyWithImpl<KanbanColumnResponse>(this as KanbanColumnResponse, _$identity);

  /// Serializes this KanbanColumnResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanbanColumnResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.color, color) || other.color == color)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.totalTaskCount, totalTaskCount) || other.totalTaskCount == totalTaskCount)&&(identical(other.isWipLimitExceeded, isWipLimitExceeded) || other.isWipLimitExceeded == isWipLimitExceeded)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,displayName,color,wipLimit,totalTaskCount,isWipLimitExceeded,const DeepCollectionEquality().hash(tasks),nextCursor,customStatusId);

@override
String toString() {
  return 'KanbanColumnResponse(status: $status, displayName: $displayName, color: $color, wipLimit: $wipLimit, totalTaskCount: $totalTaskCount, isWipLimitExceeded: $isWipLimitExceeded, tasks: $tasks, nextCursor: $nextCursor, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class $KanbanColumnResponseCopyWith<$Res>  {
  factory $KanbanColumnResponseCopyWith(KanbanColumnResponse value, $Res Function(KanbanColumnResponse) _then) = _$KanbanColumnResponseCopyWithImpl;
@useResult
$Res call({
 ProjectTaskStatus status, String displayName, String color, int? wipLimit, int totalTaskCount, bool isWipLimitExceeded, List<KanbanTaskCardResponse> tasks, String? nextCursor, String? customStatusId
});




}
/// @nodoc
class _$KanbanColumnResponseCopyWithImpl<$Res>
    implements $KanbanColumnResponseCopyWith<$Res> {
  _$KanbanColumnResponseCopyWithImpl(this._self, this._then);

  final KanbanColumnResponse _self;
  final $Res Function(KanbanColumnResponse) _then;

/// Create a copy of KanbanColumnResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? displayName = null,Object? color = null,Object? wipLimit = freezed,Object? totalTaskCount = null,Object? isWipLimitExceeded = null,Object? tasks = null,Object? nextCursor = freezed,Object? customStatusId = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,totalTaskCount: null == totalTaskCount ? _self.totalTaskCount : totalTaskCount // ignore: cast_nullable_to_non_nullable
as int,isWipLimitExceeded: null == isWipLimitExceeded ? _self.isWipLimitExceeded : isWipLimitExceeded // ignore: cast_nullable_to_non_nullable
as bool,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<KanbanTaskCardResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KanbanColumnResponse].
extension KanbanColumnResponsePatterns on KanbanColumnResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanbanColumnResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanbanColumnResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanbanColumnResponse value)  $default,){
final _that = this;
switch (_that) {
case _KanbanColumnResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanbanColumnResponse value)?  $default,){
final _that = this;
switch (_that) {
case _KanbanColumnResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectTaskStatus status,  String displayName,  String color,  int? wipLimit,  int totalTaskCount,  bool isWipLimitExceeded,  List<KanbanTaskCardResponse> tasks,  String? nextCursor,  String? customStatusId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanbanColumnResponse() when $default != null:
return $default(_that.status,_that.displayName,_that.color,_that.wipLimit,_that.totalTaskCount,_that.isWipLimitExceeded,_that.tasks,_that.nextCursor,_that.customStatusId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectTaskStatus status,  String displayName,  String color,  int? wipLimit,  int totalTaskCount,  bool isWipLimitExceeded,  List<KanbanTaskCardResponse> tasks,  String? nextCursor,  String? customStatusId)  $default,) {final _that = this;
switch (_that) {
case _KanbanColumnResponse():
return $default(_that.status,_that.displayName,_that.color,_that.wipLimit,_that.totalTaskCount,_that.isWipLimitExceeded,_that.tasks,_that.nextCursor,_that.customStatusId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectTaskStatus status,  String displayName,  String color,  int? wipLimit,  int totalTaskCount,  bool isWipLimitExceeded,  List<KanbanTaskCardResponse> tasks,  String? nextCursor,  String? customStatusId)?  $default,) {final _that = this;
switch (_that) {
case _KanbanColumnResponse() when $default != null:
return $default(_that.status,_that.displayName,_that.color,_that.wipLimit,_that.totalTaskCount,_that.isWipLimitExceeded,_that.tasks,_that.nextCursor,_that.customStatusId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanbanColumnResponse implements KanbanColumnResponse {
  const _KanbanColumnResponse({required this.status, required this.displayName, required this.color, this.wipLimit, required this.totalTaskCount, required this.isWipLimitExceeded, required this.tasks, this.nextCursor, this.customStatusId});
  factory _KanbanColumnResponse.fromJson(Map<String, dynamic> json) => _$KanbanColumnResponseFromJson(json);

@override final  ProjectTaskStatus status;
@override final  String displayName;
@override final  String color;
@override final  int? wipLimit;
@override final  int totalTaskCount;
@override final  bool isWipLimitExceeded;
@override final  List<KanbanTaskCardResponse> tasks;
@override final  String? nextCursor;
@override final  String? customStatusId;

/// Create a copy of KanbanColumnResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanbanColumnResponseCopyWith<_KanbanColumnResponse> get copyWith => __$KanbanColumnResponseCopyWithImpl<_KanbanColumnResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanbanColumnResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanbanColumnResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.color, color) || other.color == color)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.totalTaskCount, totalTaskCount) || other.totalTaskCount == totalTaskCount)&&(identical(other.isWipLimitExceeded, isWipLimitExceeded) || other.isWipLimitExceeded == isWipLimitExceeded)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,displayName,color,wipLimit,totalTaskCount,isWipLimitExceeded,const DeepCollectionEquality().hash(tasks),nextCursor,customStatusId);

@override
String toString() {
  return 'KanbanColumnResponse(status: $status, displayName: $displayName, color: $color, wipLimit: $wipLimit, totalTaskCount: $totalTaskCount, isWipLimitExceeded: $isWipLimitExceeded, tasks: $tasks, nextCursor: $nextCursor, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class _$KanbanColumnResponseCopyWith<$Res> implements $KanbanColumnResponseCopyWith<$Res> {
  factory _$KanbanColumnResponseCopyWith(_KanbanColumnResponse value, $Res Function(_KanbanColumnResponse) _then) = __$KanbanColumnResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectTaskStatus status, String displayName, String color, int? wipLimit, int totalTaskCount, bool isWipLimitExceeded, List<KanbanTaskCardResponse> tasks, String? nextCursor, String? customStatusId
});




}
/// @nodoc
class __$KanbanColumnResponseCopyWithImpl<$Res>
    implements _$KanbanColumnResponseCopyWith<$Res> {
  __$KanbanColumnResponseCopyWithImpl(this._self, this._then);

  final _KanbanColumnResponse _self;
  final $Res Function(_KanbanColumnResponse) _then;

/// Create a copy of KanbanColumnResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? displayName = null,Object? color = null,Object? wipLimit = freezed,Object? totalTaskCount = null,Object? isWipLimitExceeded = null,Object? tasks = null,Object? nextCursor = freezed,Object? customStatusId = freezed,}) {
  return _then(_KanbanColumnResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,totalTaskCount: null == totalTaskCount ? _self.totalTaskCount : totalTaskCount // ignore: cast_nullable_to_non_nullable
as int,isWipLimitExceeded: null == isWipLimitExceeded ? _self.isWipLimitExceeded : isWipLimitExceeded // ignore: cast_nullable_to_non_nullable
as bool,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<KanbanTaskCardResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$KanbanBoardResponse {

 String get projectId; KanbanSwimlaneMode get swimlaneMode; int get settingsVersion; List<ProjectTaskStatus> get hiddenColumns; List<KanbanCardField> get visibleCardFields; KanbanCardDensity get defaultCardDensity; List<KanbanColumnResponse> get columns;
/// Create a copy of KanbanBoardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanbanBoardResponseCopyWith<KanbanBoardResponse> get copyWith => _$KanbanBoardResponseCopyWithImpl<KanbanBoardResponse>(this as KanbanBoardResponse, _$identity);

  /// Serializes this KanbanBoardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanbanBoardResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.swimlaneMode, swimlaneMode) || other.swimlaneMode == swimlaneMode)&&(identical(other.settingsVersion, settingsVersion) || other.settingsVersion == settingsVersion)&&const DeepCollectionEquality().equals(other.hiddenColumns, hiddenColumns)&&const DeepCollectionEquality().equals(other.visibleCardFields, visibleCardFields)&&(identical(other.defaultCardDensity, defaultCardDensity) || other.defaultCardDensity == defaultCardDensity)&&const DeepCollectionEquality().equals(other.columns, columns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,swimlaneMode,settingsVersion,const DeepCollectionEquality().hash(hiddenColumns),const DeepCollectionEquality().hash(visibleCardFields),defaultCardDensity,const DeepCollectionEquality().hash(columns));

@override
String toString() {
  return 'KanbanBoardResponse(projectId: $projectId, swimlaneMode: $swimlaneMode, settingsVersion: $settingsVersion, hiddenColumns: $hiddenColumns, visibleCardFields: $visibleCardFields, defaultCardDensity: $defaultCardDensity, columns: $columns)';
}


}

/// @nodoc
abstract mixin class $KanbanBoardResponseCopyWith<$Res>  {
  factory $KanbanBoardResponseCopyWith(KanbanBoardResponse value, $Res Function(KanbanBoardResponse) _then) = _$KanbanBoardResponseCopyWithImpl;
@useResult
$Res call({
 String projectId, KanbanSwimlaneMode swimlaneMode, int settingsVersion, List<ProjectTaskStatus> hiddenColumns, List<KanbanCardField> visibleCardFields, KanbanCardDensity defaultCardDensity, List<KanbanColumnResponse> columns
});




}
/// @nodoc
class _$KanbanBoardResponseCopyWithImpl<$Res>
    implements $KanbanBoardResponseCopyWith<$Res> {
  _$KanbanBoardResponseCopyWithImpl(this._self, this._then);

  final KanbanBoardResponse _self;
  final $Res Function(KanbanBoardResponse) _then;

/// Create a copy of KanbanBoardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? swimlaneMode = null,Object? settingsVersion = null,Object? hiddenColumns = null,Object? visibleCardFields = null,Object? defaultCardDensity = null,Object? columns = null,}) {
  return _then(_self.copyWith(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,swimlaneMode: null == swimlaneMode ? _self.swimlaneMode : swimlaneMode // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode,settingsVersion: null == settingsVersion ? _self.settingsVersion : settingsVersion // ignore: cast_nullable_to_non_nullable
as int,hiddenColumns: null == hiddenColumns ? _self.hiddenColumns : hiddenColumns // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>,visibleCardFields: null == visibleCardFields ? _self.visibleCardFields : visibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>,defaultCardDensity: null == defaultCardDensity ? _self.defaultCardDensity : defaultCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity,columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<KanbanColumnResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [KanbanBoardResponse].
extension KanbanBoardResponsePatterns on KanbanBoardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanbanBoardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanbanBoardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanbanBoardResponse value)  $default,){
final _that = this;
switch (_that) {
case _KanbanBoardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanbanBoardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _KanbanBoardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  KanbanSwimlaneMode swimlaneMode,  int settingsVersion,  List<ProjectTaskStatus> hiddenColumns,  List<KanbanCardField> visibleCardFields,  KanbanCardDensity defaultCardDensity,  List<KanbanColumnResponse> columns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanbanBoardResponse() when $default != null:
return $default(_that.projectId,_that.swimlaneMode,_that.settingsVersion,_that.hiddenColumns,_that.visibleCardFields,_that.defaultCardDensity,_that.columns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  KanbanSwimlaneMode swimlaneMode,  int settingsVersion,  List<ProjectTaskStatus> hiddenColumns,  List<KanbanCardField> visibleCardFields,  KanbanCardDensity defaultCardDensity,  List<KanbanColumnResponse> columns)  $default,) {final _that = this;
switch (_that) {
case _KanbanBoardResponse():
return $default(_that.projectId,_that.swimlaneMode,_that.settingsVersion,_that.hiddenColumns,_that.visibleCardFields,_that.defaultCardDensity,_that.columns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  KanbanSwimlaneMode swimlaneMode,  int settingsVersion,  List<ProjectTaskStatus> hiddenColumns,  List<KanbanCardField> visibleCardFields,  KanbanCardDensity defaultCardDensity,  List<KanbanColumnResponse> columns)?  $default,) {final _that = this;
switch (_that) {
case _KanbanBoardResponse() when $default != null:
return $default(_that.projectId,_that.swimlaneMode,_that.settingsVersion,_that.hiddenColumns,_that.visibleCardFields,_that.defaultCardDensity,_that.columns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanbanBoardResponse implements KanbanBoardResponse {
  const _KanbanBoardResponse({required this.projectId, required this.swimlaneMode, required this.settingsVersion, required this.hiddenColumns, required this.visibleCardFields, required this.defaultCardDensity, required this.columns});
  factory _KanbanBoardResponse.fromJson(Map<String, dynamic> json) => _$KanbanBoardResponseFromJson(json);

@override final  String projectId;
@override final  KanbanSwimlaneMode swimlaneMode;
@override final  int settingsVersion;
@override final  List<ProjectTaskStatus> hiddenColumns;
@override final  List<KanbanCardField> visibleCardFields;
@override final  KanbanCardDensity defaultCardDensity;
@override final  List<KanbanColumnResponse> columns;

/// Create a copy of KanbanBoardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanbanBoardResponseCopyWith<_KanbanBoardResponse> get copyWith => __$KanbanBoardResponseCopyWithImpl<_KanbanBoardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanbanBoardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanbanBoardResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.swimlaneMode, swimlaneMode) || other.swimlaneMode == swimlaneMode)&&(identical(other.settingsVersion, settingsVersion) || other.settingsVersion == settingsVersion)&&const DeepCollectionEquality().equals(other.hiddenColumns, hiddenColumns)&&const DeepCollectionEquality().equals(other.visibleCardFields, visibleCardFields)&&(identical(other.defaultCardDensity, defaultCardDensity) || other.defaultCardDensity == defaultCardDensity)&&const DeepCollectionEquality().equals(other.columns, columns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,swimlaneMode,settingsVersion,const DeepCollectionEquality().hash(hiddenColumns),const DeepCollectionEquality().hash(visibleCardFields),defaultCardDensity,const DeepCollectionEquality().hash(columns));

@override
String toString() {
  return 'KanbanBoardResponse(projectId: $projectId, swimlaneMode: $swimlaneMode, settingsVersion: $settingsVersion, hiddenColumns: $hiddenColumns, visibleCardFields: $visibleCardFields, defaultCardDensity: $defaultCardDensity, columns: $columns)';
}


}

/// @nodoc
abstract mixin class _$KanbanBoardResponseCopyWith<$Res> implements $KanbanBoardResponseCopyWith<$Res> {
  factory _$KanbanBoardResponseCopyWith(_KanbanBoardResponse value, $Res Function(_KanbanBoardResponse) _then) = __$KanbanBoardResponseCopyWithImpl;
@override @useResult
$Res call({
 String projectId, KanbanSwimlaneMode swimlaneMode, int settingsVersion, List<ProjectTaskStatus> hiddenColumns, List<KanbanCardField> visibleCardFields, KanbanCardDensity defaultCardDensity, List<KanbanColumnResponse> columns
});




}
/// @nodoc
class __$KanbanBoardResponseCopyWithImpl<$Res>
    implements _$KanbanBoardResponseCopyWith<$Res> {
  __$KanbanBoardResponseCopyWithImpl(this._self, this._then);

  final _KanbanBoardResponse _self;
  final $Res Function(_KanbanBoardResponse) _then;

/// Create a copy of KanbanBoardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? swimlaneMode = null,Object? settingsVersion = null,Object? hiddenColumns = null,Object? visibleCardFields = null,Object? defaultCardDensity = null,Object? columns = null,}) {
  return _then(_KanbanBoardResponse(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,swimlaneMode: null == swimlaneMode ? _self.swimlaneMode : swimlaneMode // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode,settingsVersion: null == settingsVersion ? _self.settingsVersion : settingsVersion // ignore: cast_nullable_to_non_nullable
as int,hiddenColumns: null == hiddenColumns ? _self.hiddenColumns : hiddenColumns // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>,visibleCardFields: null == visibleCardFields ? _self.visibleCardFields : visibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>,defaultCardDensity: null == defaultCardDensity ? _self.defaultCardDensity : defaultCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity,columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<KanbanColumnResponse>,
  ));
}


}


/// @nodoc
mixin _$MoveKanbanTaskPayload {

 ProjectTaskStatus get targetStatus; String? get previousTaskId; String? get nextTaskId; int get expectedVersion; String? get customStatusId;
/// Create a copy of MoveKanbanTaskPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveKanbanTaskPayloadCopyWith<MoveKanbanTaskPayload> get copyWith => _$MoveKanbanTaskPayloadCopyWithImpl<MoveKanbanTaskPayload>(this as MoveKanbanTaskPayload, _$identity);

  /// Serializes this MoveKanbanTaskPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveKanbanTaskPayload&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetStatus,previousTaskId,nextTaskId,expectedVersion,customStatusId);

@override
String toString() {
  return 'MoveKanbanTaskPayload(targetStatus: $targetStatus, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId, expectedVersion: $expectedVersion, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class $MoveKanbanTaskPayloadCopyWith<$Res>  {
  factory $MoveKanbanTaskPayloadCopyWith(MoveKanbanTaskPayload value, $Res Function(MoveKanbanTaskPayload) _then) = _$MoveKanbanTaskPayloadCopyWithImpl;
@useResult
$Res call({
 ProjectTaskStatus targetStatus, String? previousTaskId, String? nextTaskId, int expectedVersion, String? customStatusId
});




}
/// @nodoc
class _$MoveKanbanTaskPayloadCopyWithImpl<$Res>
    implements $MoveKanbanTaskPayloadCopyWith<$Res> {
  _$MoveKanbanTaskPayloadCopyWithImpl(this._self, this._then);

  final MoveKanbanTaskPayload _self;
  final $Res Function(MoveKanbanTaskPayload) _then;

/// Create a copy of MoveKanbanTaskPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetStatus = null,Object? previousTaskId = freezed,Object? nextTaskId = freezed,Object? expectedVersion = null,Object? customStatusId = freezed,}) {
  return _then(_self.copyWith(
targetStatus: null == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,previousTaskId: freezed == previousTaskId ? _self.previousTaskId : previousTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextTaskId: freezed == nextTaskId ? _self.nextTaskId : nextTaskId // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MoveKanbanTaskPayload].
extension MoveKanbanTaskPayloadPatterns on MoveKanbanTaskPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoveKanbanTaskPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoveKanbanTaskPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoveKanbanTaskPayload value)  $default,){
final _that = this;
switch (_that) {
case _MoveKanbanTaskPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoveKanbanTaskPayload value)?  $default,){
final _that = this;
switch (_that) {
case _MoveKanbanTaskPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectTaskStatus targetStatus,  String? previousTaskId,  String? nextTaskId,  int expectedVersion,  String? customStatusId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoveKanbanTaskPayload() when $default != null:
return $default(_that.targetStatus,_that.previousTaskId,_that.nextTaskId,_that.expectedVersion,_that.customStatusId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectTaskStatus targetStatus,  String? previousTaskId,  String? nextTaskId,  int expectedVersion,  String? customStatusId)  $default,) {final _that = this;
switch (_that) {
case _MoveKanbanTaskPayload():
return $default(_that.targetStatus,_that.previousTaskId,_that.nextTaskId,_that.expectedVersion,_that.customStatusId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectTaskStatus targetStatus,  String? previousTaskId,  String? nextTaskId,  int expectedVersion,  String? customStatusId)?  $default,) {final _that = this;
switch (_that) {
case _MoveKanbanTaskPayload() when $default != null:
return $default(_that.targetStatus,_that.previousTaskId,_that.nextTaskId,_that.expectedVersion,_that.customStatusId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoveKanbanTaskPayload implements MoveKanbanTaskPayload {
  const _MoveKanbanTaskPayload({required this.targetStatus, this.previousTaskId, this.nextTaskId, required this.expectedVersion, this.customStatusId});
  factory _MoveKanbanTaskPayload.fromJson(Map<String, dynamic> json) => _$MoveKanbanTaskPayloadFromJson(json);

@override final  ProjectTaskStatus targetStatus;
@override final  String? previousTaskId;
@override final  String? nextTaskId;
@override final  int expectedVersion;
@override final  String? customStatusId;

/// Create a copy of MoveKanbanTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoveKanbanTaskPayloadCopyWith<_MoveKanbanTaskPayload> get copyWith => __$MoveKanbanTaskPayloadCopyWithImpl<_MoveKanbanTaskPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoveKanbanTaskPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoveKanbanTaskPayload&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetStatus,previousTaskId,nextTaskId,expectedVersion,customStatusId);

@override
String toString() {
  return 'MoveKanbanTaskPayload(targetStatus: $targetStatus, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId, expectedVersion: $expectedVersion, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class _$MoveKanbanTaskPayloadCopyWith<$Res> implements $MoveKanbanTaskPayloadCopyWith<$Res> {
  factory _$MoveKanbanTaskPayloadCopyWith(_MoveKanbanTaskPayload value, $Res Function(_MoveKanbanTaskPayload) _then) = __$MoveKanbanTaskPayloadCopyWithImpl;
@override @useResult
$Res call({
 ProjectTaskStatus targetStatus, String? previousTaskId, String? nextTaskId, int expectedVersion, String? customStatusId
});




}
/// @nodoc
class __$MoveKanbanTaskPayloadCopyWithImpl<$Res>
    implements _$MoveKanbanTaskPayloadCopyWith<$Res> {
  __$MoveKanbanTaskPayloadCopyWithImpl(this._self, this._then);

  final _MoveKanbanTaskPayload _self;
  final $Res Function(_MoveKanbanTaskPayload) _then;

/// Create a copy of MoveKanbanTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetStatus = null,Object? previousTaskId = freezed,Object? nextTaskId = freezed,Object? expectedVersion = null,Object? customStatusId = freezed,}) {
  return _then(_MoveKanbanTaskPayload(
targetStatus: null == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,previousTaskId: freezed == previousTaskId ? _self.previousTaskId : previousTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextTaskId: freezed == nextTaskId ? _self.nextTaskId : nextTaskId // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MoveKanbanTaskResponse {

 KanbanTaskCardResponse get task; int get targetColumnTaskCount; int? get targetColumnWipLimit; bool get isWipLimitExceeded;
/// Create a copy of MoveKanbanTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveKanbanTaskResponseCopyWith<MoveKanbanTaskResponse> get copyWith => _$MoveKanbanTaskResponseCopyWithImpl<MoveKanbanTaskResponse>(this as MoveKanbanTaskResponse, _$identity);

  /// Serializes this MoveKanbanTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveKanbanTaskResponse&&(identical(other.task, task) || other.task == task)&&(identical(other.targetColumnTaskCount, targetColumnTaskCount) || other.targetColumnTaskCount == targetColumnTaskCount)&&(identical(other.targetColumnWipLimit, targetColumnWipLimit) || other.targetColumnWipLimit == targetColumnWipLimit)&&(identical(other.isWipLimitExceeded, isWipLimitExceeded) || other.isWipLimitExceeded == isWipLimitExceeded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,targetColumnTaskCount,targetColumnWipLimit,isWipLimitExceeded);

@override
String toString() {
  return 'MoveKanbanTaskResponse(task: $task, targetColumnTaskCount: $targetColumnTaskCount, targetColumnWipLimit: $targetColumnWipLimit, isWipLimitExceeded: $isWipLimitExceeded)';
}


}

/// @nodoc
abstract mixin class $MoveKanbanTaskResponseCopyWith<$Res>  {
  factory $MoveKanbanTaskResponseCopyWith(MoveKanbanTaskResponse value, $Res Function(MoveKanbanTaskResponse) _then) = _$MoveKanbanTaskResponseCopyWithImpl;
@useResult
$Res call({
 KanbanTaskCardResponse task, int targetColumnTaskCount, int? targetColumnWipLimit, bool isWipLimitExceeded
});


$KanbanTaskCardResponseCopyWith<$Res> get task;

}
/// @nodoc
class _$MoveKanbanTaskResponseCopyWithImpl<$Res>
    implements $MoveKanbanTaskResponseCopyWith<$Res> {
  _$MoveKanbanTaskResponseCopyWithImpl(this._self, this._then);

  final MoveKanbanTaskResponse _self;
  final $Res Function(MoveKanbanTaskResponse) _then;

/// Create a copy of MoveKanbanTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? targetColumnTaskCount = null,Object? targetColumnWipLimit = freezed,Object? isWipLimitExceeded = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as KanbanTaskCardResponse,targetColumnTaskCount: null == targetColumnTaskCount ? _self.targetColumnTaskCount : targetColumnTaskCount // ignore: cast_nullable_to_non_nullable
as int,targetColumnWipLimit: freezed == targetColumnWipLimit ? _self.targetColumnWipLimit : targetColumnWipLimit // ignore: cast_nullable_to_non_nullable
as int?,isWipLimitExceeded: null == isWipLimitExceeded ? _self.isWipLimitExceeded : isWipLimitExceeded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MoveKanbanTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanbanTaskCardResponseCopyWith<$Res> get task {

  return $KanbanTaskCardResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [MoveKanbanTaskResponse].
extension MoveKanbanTaskResponsePatterns on MoveKanbanTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoveKanbanTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoveKanbanTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoveKanbanTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _MoveKanbanTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoveKanbanTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MoveKanbanTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KanbanTaskCardResponse task,  int targetColumnTaskCount,  int? targetColumnWipLimit,  bool isWipLimitExceeded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoveKanbanTaskResponse() when $default != null:
return $default(_that.task,_that.targetColumnTaskCount,_that.targetColumnWipLimit,_that.isWipLimitExceeded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KanbanTaskCardResponse task,  int targetColumnTaskCount,  int? targetColumnWipLimit,  bool isWipLimitExceeded)  $default,) {final _that = this;
switch (_that) {
case _MoveKanbanTaskResponse():
return $default(_that.task,_that.targetColumnTaskCount,_that.targetColumnWipLimit,_that.isWipLimitExceeded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KanbanTaskCardResponse task,  int targetColumnTaskCount,  int? targetColumnWipLimit,  bool isWipLimitExceeded)?  $default,) {final _that = this;
switch (_that) {
case _MoveKanbanTaskResponse() when $default != null:
return $default(_that.task,_that.targetColumnTaskCount,_that.targetColumnWipLimit,_that.isWipLimitExceeded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoveKanbanTaskResponse implements MoveKanbanTaskResponse {
  const _MoveKanbanTaskResponse({required this.task, required this.targetColumnTaskCount, this.targetColumnWipLimit, required this.isWipLimitExceeded});
  factory _MoveKanbanTaskResponse.fromJson(Map<String, dynamic> json) => _$MoveKanbanTaskResponseFromJson(json);

@override final  KanbanTaskCardResponse task;
@override final  int targetColumnTaskCount;
@override final  int? targetColumnWipLimit;
@override final  bool isWipLimitExceeded;

/// Create a copy of MoveKanbanTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoveKanbanTaskResponseCopyWith<_MoveKanbanTaskResponse> get copyWith => __$MoveKanbanTaskResponseCopyWithImpl<_MoveKanbanTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoveKanbanTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoveKanbanTaskResponse&&(identical(other.task, task) || other.task == task)&&(identical(other.targetColumnTaskCount, targetColumnTaskCount) || other.targetColumnTaskCount == targetColumnTaskCount)&&(identical(other.targetColumnWipLimit, targetColumnWipLimit) || other.targetColumnWipLimit == targetColumnWipLimit)&&(identical(other.isWipLimitExceeded, isWipLimitExceeded) || other.isWipLimitExceeded == isWipLimitExceeded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,targetColumnTaskCount,targetColumnWipLimit,isWipLimitExceeded);

@override
String toString() {
  return 'MoveKanbanTaskResponse(task: $task, targetColumnTaskCount: $targetColumnTaskCount, targetColumnWipLimit: $targetColumnWipLimit, isWipLimitExceeded: $isWipLimitExceeded)';
}


}

/// @nodoc
abstract mixin class _$MoveKanbanTaskResponseCopyWith<$Res> implements $MoveKanbanTaskResponseCopyWith<$Res> {
  factory _$MoveKanbanTaskResponseCopyWith(_MoveKanbanTaskResponse value, $Res Function(_MoveKanbanTaskResponse) _then) = __$MoveKanbanTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 KanbanTaskCardResponse task, int targetColumnTaskCount, int? targetColumnWipLimit, bool isWipLimitExceeded
});


@override $KanbanTaskCardResponseCopyWith<$Res> get task;

}
/// @nodoc
class __$MoveKanbanTaskResponseCopyWithImpl<$Res>
    implements _$MoveKanbanTaskResponseCopyWith<$Res> {
  __$MoveKanbanTaskResponseCopyWithImpl(this._self, this._then);

  final _MoveKanbanTaskResponse _self;
  final $Res Function(_MoveKanbanTaskResponse) _then;

/// Create a copy of MoveKanbanTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? targetColumnTaskCount = null,Object? targetColumnWipLimit = freezed,Object? isWipLimitExceeded = null,}) {
  return _then(_MoveKanbanTaskResponse(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as KanbanTaskCardResponse,targetColumnTaskCount: null == targetColumnTaskCount ? _self.targetColumnTaskCount : targetColumnTaskCount // ignore: cast_nullable_to_non_nullable
as int,targetColumnWipLimit: freezed == targetColumnWipLimit ? _self.targetColumnWipLimit : targetColumnWipLimit // ignore: cast_nullable_to_non_nullable
as int?,isWipLimitExceeded: null == isWipLimitExceeded ? _self.isWipLimitExceeded : isWipLimitExceeded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MoveKanbanTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KanbanTaskCardResponseCopyWith<$Res> get task {

  return $KanbanTaskCardResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// @nodoc
mixin _$BulkMoveKanbanTaskItemPayload {

 String get taskId; int get expectedVersion;
/// Create a copy of BulkMoveKanbanTaskItemPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkMoveKanbanTaskItemPayloadCopyWith<BulkMoveKanbanTaskItemPayload> get copyWith => _$BulkMoveKanbanTaskItemPayloadCopyWithImpl<BulkMoveKanbanTaskItemPayload>(this as BulkMoveKanbanTaskItemPayload, _$identity);

  /// Serializes this BulkMoveKanbanTaskItemPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkMoveKanbanTaskItemPayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,expectedVersion);

@override
String toString() {
  return 'BulkMoveKanbanTaskItemPayload(taskId: $taskId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $BulkMoveKanbanTaskItemPayloadCopyWith<$Res>  {
  factory $BulkMoveKanbanTaskItemPayloadCopyWith(BulkMoveKanbanTaskItemPayload value, $Res Function(BulkMoveKanbanTaskItemPayload) _then) = _$BulkMoveKanbanTaskItemPayloadCopyWithImpl;
@useResult
$Res call({
 String taskId, int expectedVersion
});




}
/// @nodoc
class _$BulkMoveKanbanTaskItemPayloadCopyWithImpl<$Res>
    implements $BulkMoveKanbanTaskItemPayloadCopyWith<$Res> {
  _$BulkMoveKanbanTaskItemPayloadCopyWithImpl(this._self, this._then);

  final BulkMoveKanbanTaskItemPayload _self;
  final $Res Function(BulkMoveKanbanTaskItemPayload) _then;

/// Create a copy of BulkMoveKanbanTaskItemPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkMoveKanbanTaskItemPayload].
extension BulkMoveKanbanTaskItemPayloadPatterns on BulkMoveKanbanTaskItemPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkMoveKanbanTaskItemPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkMoveKanbanTaskItemPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkMoveKanbanTaskItemPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkMoveKanbanTaskItemPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkMoveKanbanTaskItemPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkMoveKanbanTaskItemPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkMoveKanbanTaskItemPayload() when $default != null:
return $default(_that.taskId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _BulkMoveKanbanTaskItemPayload():
return $default(_that.taskId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _BulkMoveKanbanTaskItemPayload() when $default != null:
return $default(_that.taskId,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkMoveKanbanTaskItemPayload implements BulkMoveKanbanTaskItemPayload {
  const _BulkMoveKanbanTaskItemPayload({required this.taskId, required this.expectedVersion});
  factory _BulkMoveKanbanTaskItemPayload.fromJson(Map<String, dynamic> json) => _$BulkMoveKanbanTaskItemPayloadFromJson(json);

@override final  String taskId;
@override final  int expectedVersion;

/// Create a copy of BulkMoveKanbanTaskItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkMoveKanbanTaskItemPayloadCopyWith<_BulkMoveKanbanTaskItemPayload> get copyWith => __$BulkMoveKanbanTaskItemPayloadCopyWithImpl<_BulkMoveKanbanTaskItemPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkMoveKanbanTaskItemPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkMoveKanbanTaskItemPayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,expectedVersion);

@override
String toString() {
  return 'BulkMoveKanbanTaskItemPayload(taskId: $taskId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$BulkMoveKanbanTaskItemPayloadCopyWith<$Res> implements $BulkMoveKanbanTaskItemPayloadCopyWith<$Res> {
  factory _$BulkMoveKanbanTaskItemPayloadCopyWith(_BulkMoveKanbanTaskItemPayload value, $Res Function(_BulkMoveKanbanTaskItemPayload) _then) = __$BulkMoveKanbanTaskItemPayloadCopyWithImpl;
@override @useResult
$Res call({
 String taskId, int expectedVersion
});




}
/// @nodoc
class __$BulkMoveKanbanTaskItemPayloadCopyWithImpl<$Res>
    implements _$BulkMoveKanbanTaskItemPayloadCopyWith<$Res> {
  __$BulkMoveKanbanTaskItemPayloadCopyWithImpl(this._self, this._then);

  final _BulkMoveKanbanTaskItemPayload _self;
  final $Res Function(_BulkMoveKanbanTaskItemPayload) _then;

/// Create a copy of BulkMoveKanbanTaskItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? expectedVersion = null,}) {
  return _then(_BulkMoveKanbanTaskItemPayload(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BulkMoveKanbanTasksPayload {

 ProjectTaskStatus get targetStatus; List<BulkMoveKanbanTaskItemPayload> get tasks; String? get customStatusId;
/// Create a copy of BulkMoveKanbanTasksPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkMoveKanbanTasksPayloadCopyWith<BulkMoveKanbanTasksPayload> get copyWith => _$BulkMoveKanbanTasksPayloadCopyWithImpl<BulkMoveKanbanTasksPayload>(this as BulkMoveKanbanTasksPayload, _$identity);

  /// Serializes this BulkMoveKanbanTasksPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkMoveKanbanTasksPayload&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetStatus,const DeepCollectionEquality().hash(tasks),customStatusId);

@override
String toString() {
  return 'BulkMoveKanbanTasksPayload(targetStatus: $targetStatus, tasks: $tasks, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class $BulkMoveKanbanTasksPayloadCopyWith<$Res>  {
  factory $BulkMoveKanbanTasksPayloadCopyWith(BulkMoveKanbanTasksPayload value, $Res Function(BulkMoveKanbanTasksPayload) _then) = _$BulkMoveKanbanTasksPayloadCopyWithImpl;
@useResult
$Res call({
 ProjectTaskStatus targetStatus, List<BulkMoveKanbanTaskItemPayload> tasks, String? customStatusId
});




}
/// @nodoc
class _$BulkMoveKanbanTasksPayloadCopyWithImpl<$Res>
    implements $BulkMoveKanbanTasksPayloadCopyWith<$Res> {
  _$BulkMoveKanbanTasksPayloadCopyWithImpl(this._self, this._then);

  final BulkMoveKanbanTasksPayload _self;
  final $Res Function(BulkMoveKanbanTasksPayload) _then;

/// Create a copy of BulkMoveKanbanTasksPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetStatus = null,Object? tasks = null,Object? customStatusId = freezed,}) {
  return _then(_self.copyWith(
targetStatus: null == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<BulkMoveKanbanTaskItemPayload>,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkMoveKanbanTasksPayload].
extension BulkMoveKanbanTasksPayloadPatterns on BulkMoveKanbanTasksPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkMoveKanbanTasksPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkMoveKanbanTasksPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkMoveKanbanTasksPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectTaskStatus targetStatus,  List<BulkMoveKanbanTaskItemPayload> tasks,  String? customStatusId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksPayload() when $default != null:
return $default(_that.targetStatus,_that.tasks,_that.customStatusId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectTaskStatus targetStatus,  List<BulkMoveKanbanTaskItemPayload> tasks,  String? customStatusId)  $default,) {final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksPayload():
return $default(_that.targetStatus,_that.tasks,_that.customStatusId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectTaskStatus targetStatus,  List<BulkMoveKanbanTaskItemPayload> tasks,  String? customStatusId)?  $default,) {final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksPayload() when $default != null:
return $default(_that.targetStatus,_that.tasks,_that.customStatusId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkMoveKanbanTasksPayload implements BulkMoveKanbanTasksPayload {
  const _BulkMoveKanbanTasksPayload({required this.targetStatus, required this.tasks, this.customStatusId});
  factory _BulkMoveKanbanTasksPayload.fromJson(Map<String, dynamic> json) => _$BulkMoveKanbanTasksPayloadFromJson(json);

@override final  ProjectTaskStatus targetStatus;
@override final  List<BulkMoveKanbanTaskItemPayload> tasks;
@override final  String? customStatusId;

/// Create a copy of BulkMoveKanbanTasksPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkMoveKanbanTasksPayloadCopyWith<_BulkMoveKanbanTasksPayload> get copyWith => __$BulkMoveKanbanTasksPayloadCopyWithImpl<_BulkMoveKanbanTasksPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkMoveKanbanTasksPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkMoveKanbanTasksPayload&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetStatus,const DeepCollectionEquality().hash(tasks),customStatusId);

@override
String toString() {
  return 'BulkMoveKanbanTasksPayload(targetStatus: $targetStatus, tasks: $tasks, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class _$BulkMoveKanbanTasksPayloadCopyWith<$Res> implements $BulkMoveKanbanTasksPayloadCopyWith<$Res> {
  factory _$BulkMoveKanbanTasksPayloadCopyWith(_BulkMoveKanbanTasksPayload value, $Res Function(_BulkMoveKanbanTasksPayload) _then) = __$BulkMoveKanbanTasksPayloadCopyWithImpl;
@override @useResult
$Res call({
 ProjectTaskStatus targetStatus, List<BulkMoveKanbanTaskItemPayload> tasks, String? customStatusId
});




}
/// @nodoc
class __$BulkMoveKanbanTasksPayloadCopyWithImpl<$Res>
    implements _$BulkMoveKanbanTasksPayloadCopyWith<$Res> {
  __$BulkMoveKanbanTasksPayloadCopyWithImpl(this._self, this._then);

  final _BulkMoveKanbanTasksPayload _self;
  final $Res Function(_BulkMoveKanbanTasksPayload) _then;

/// Create a copy of BulkMoveKanbanTasksPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetStatus = null,Object? tasks = null,Object? customStatusId = freezed,}) {
  return _then(_BulkMoveKanbanTasksPayload(
targetStatus: null == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<BulkMoveKanbanTaskItemPayload>,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BulkMoveKanbanTasksResponse {

 List<KanbanTaskCardResponse> get tasks; int get targetColumnTaskCount; int? get targetColumnWipLimit; bool get isWipLimitExceeded;
/// Create a copy of BulkMoveKanbanTasksResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkMoveKanbanTasksResponseCopyWith<BulkMoveKanbanTasksResponse> get copyWith => _$BulkMoveKanbanTasksResponseCopyWithImpl<BulkMoveKanbanTasksResponse>(this as BulkMoveKanbanTasksResponse, _$identity);

  /// Serializes this BulkMoveKanbanTasksResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkMoveKanbanTasksResponse&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.targetColumnTaskCount, targetColumnTaskCount) || other.targetColumnTaskCount == targetColumnTaskCount)&&(identical(other.targetColumnWipLimit, targetColumnWipLimit) || other.targetColumnWipLimit == targetColumnWipLimit)&&(identical(other.isWipLimitExceeded, isWipLimitExceeded) || other.isWipLimitExceeded == isWipLimitExceeded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tasks),targetColumnTaskCount,targetColumnWipLimit,isWipLimitExceeded);

@override
String toString() {
  return 'BulkMoveKanbanTasksResponse(tasks: $tasks, targetColumnTaskCount: $targetColumnTaskCount, targetColumnWipLimit: $targetColumnWipLimit, isWipLimitExceeded: $isWipLimitExceeded)';
}


}

/// @nodoc
abstract mixin class $BulkMoveKanbanTasksResponseCopyWith<$Res>  {
  factory $BulkMoveKanbanTasksResponseCopyWith(BulkMoveKanbanTasksResponse value, $Res Function(BulkMoveKanbanTasksResponse) _then) = _$BulkMoveKanbanTasksResponseCopyWithImpl;
@useResult
$Res call({
 List<KanbanTaskCardResponse> tasks, int targetColumnTaskCount, int? targetColumnWipLimit, bool isWipLimitExceeded
});




}
/// @nodoc
class _$BulkMoveKanbanTasksResponseCopyWithImpl<$Res>
    implements $BulkMoveKanbanTasksResponseCopyWith<$Res> {
  _$BulkMoveKanbanTasksResponseCopyWithImpl(this._self, this._then);

  final BulkMoveKanbanTasksResponse _self;
  final $Res Function(BulkMoveKanbanTasksResponse) _then;

/// Create a copy of BulkMoveKanbanTasksResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasks = null,Object? targetColumnTaskCount = null,Object? targetColumnWipLimit = freezed,Object? isWipLimitExceeded = null,}) {
  return _then(_self.copyWith(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<KanbanTaskCardResponse>,targetColumnTaskCount: null == targetColumnTaskCount ? _self.targetColumnTaskCount : targetColumnTaskCount // ignore: cast_nullable_to_non_nullable
as int,targetColumnWipLimit: freezed == targetColumnWipLimit ? _self.targetColumnWipLimit : targetColumnWipLimit // ignore: cast_nullable_to_non_nullable
as int?,isWipLimitExceeded: null == isWipLimitExceeded ? _self.isWipLimitExceeded : isWipLimitExceeded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkMoveKanbanTasksResponse].
extension BulkMoveKanbanTasksResponsePatterns on BulkMoveKanbanTasksResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkMoveKanbanTasksResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkMoveKanbanTasksResponse value)  $default,){
final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkMoveKanbanTasksResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<KanbanTaskCardResponse> tasks,  int targetColumnTaskCount,  int? targetColumnWipLimit,  bool isWipLimitExceeded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksResponse() when $default != null:
return $default(_that.tasks,_that.targetColumnTaskCount,_that.targetColumnWipLimit,_that.isWipLimitExceeded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<KanbanTaskCardResponse> tasks,  int targetColumnTaskCount,  int? targetColumnWipLimit,  bool isWipLimitExceeded)  $default,) {final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksResponse():
return $default(_that.tasks,_that.targetColumnTaskCount,_that.targetColumnWipLimit,_that.isWipLimitExceeded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<KanbanTaskCardResponse> tasks,  int targetColumnTaskCount,  int? targetColumnWipLimit,  bool isWipLimitExceeded)?  $default,) {final _that = this;
switch (_that) {
case _BulkMoveKanbanTasksResponse() when $default != null:
return $default(_that.tasks,_that.targetColumnTaskCount,_that.targetColumnWipLimit,_that.isWipLimitExceeded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkMoveKanbanTasksResponse implements BulkMoveKanbanTasksResponse {
  const _BulkMoveKanbanTasksResponse({required this.tasks, required this.targetColumnTaskCount, this.targetColumnWipLimit, required this.isWipLimitExceeded});
  factory _BulkMoveKanbanTasksResponse.fromJson(Map<String, dynamic> json) => _$BulkMoveKanbanTasksResponseFromJson(json);

@override final  List<KanbanTaskCardResponse> tasks;
@override final  int targetColumnTaskCount;
@override final  int? targetColumnWipLimit;
@override final  bool isWipLimitExceeded;

/// Create a copy of BulkMoveKanbanTasksResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkMoveKanbanTasksResponseCopyWith<_BulkMoveKanbanTasksResponse> get copyWith => __$BulkMoveKanbanTasksResponseCopyWithImpl<_BulkMoveKanbanTasksResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkMoveKanbanTasksResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkMoveKanbanTasksResponse&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.targetColumnTaskCount, targetColumnTaskCount) || other.targetColumnTaskCount == targetColumnTaskCount)&&(identical(other.targetColumnWipLimit, targetColumnWipLimit) || other.targetColumnWipLimit == targetColumnWipLimit)&&(identical(other.isWipLimitExceeded, isWipLimitExceeded) || other.isWipLimitExceeded == isWipLimitExceeded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tasks),targetColumnTaskCount,targetColumnWipLimit,isWipLimitExceeded);

@override
String toString() {
  return 'BulkMoveKanbanTasksResponse(tasks: $tasks, targetColumnTaskCount: $targetColumnTaskCount, targetColumnWipLimit: $targetColumnWipLimit, isWipLimitExceeded: $isWipLimitExceeded)';
}


}

/// @nodoc
abstract mixin class _$BulkMoveKanbanTasksResponseCopyWith<$Res> implements $BulkMoveKanbanTasksResponseCopyWith<$Res> {
  factory _$BulkMoveKanbanTasksResponseCopyWith(_BulkMoveKanbanTasksResponse value, $Res Function(_BulkMoveKanbanTasksResponse) _then) = __$BulkMoveKanbanTasksResponseCopyWithImpl;
@override @useResult
$Res call({
 List<KanbanTaskCardResponse> tasks, int targetColumnTaskCount, int? targetColumnWipLimit, bool isWipLimitExceeded
});




}
/// @nodoc
class __$BulkMoveKanbanTasksResponseCopyWithImpl<$Res>
    implements _$BulkMoveKanbanTasksResponseCopyWith<$Res> {
  __$BulkMoveKanbanTasksResponseCopyWithImpl(this._self, this._then);

  final _BulkMoveKanbanTasksResponse _self;
  final $Res Function(_BulkMoveKanbanTasksResponse) _then;

/// Create a copy of BulkMoveKanbanTasksResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasks = null,Object? targetColumnTaskCount = null,Object? targetColumnWipLimit = freezed,Object? isWipLimitExceeded = null,}) {
  return _then(_BulkMoveKanbanTasksResponse(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<KanbanTaskCardResponse>,targetColumnTaskCount: null == targetColumnTaskCount ? _self.targetColumnTaskCount : targetColumnTaskCount // ignore: cast_nullable_to_non_nullable
as int,targetColumnWipLimit: freezed == targetColumnWipLimit ? _self.targetColumnWipLimit : targetColumnWipLimit // ignore: cast_nullable_to_non_nullable
as int?,isWipLimitExceeded: null == isWipLimitExceeded ? _self.isWipLimitExceeded : isWipLimitExceeded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BulkUpdateKanbanTaskItemPayload {

 String get taskId; int get expectedVersion;
/// Create a copy of BulkUpdateKanbanTaskItemPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkUpdateKanbanTaskItemPayloadCopyWith<BulkUpdateKanbanTaskItemPayload> get copyWith => _$BulkUpdateKanbanTaskItemPayloadCopyWithImpl<BulkUpdateKanbanTaskItemPayload>(this as BulkUpdateKanbanTaskItemPayload, _$identity);

  /// Serializes this BulkUpdateKanbanTaskItemPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkUpdateKanbanTaskItemPayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,expectedVersion);

@override
String toString() {
  return 'BulkUpdateKanbanTaskItemPayload(taskId: $taskId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $BulkUpdateKanbanTaskItemPayloadCopyWith<$Res>  {
  factory $BulkUpdateKanbanTaskItemPayloadCopyWith(BulkUpdateKanbanTaskItemPayload value, $Res Function(BulkUpdateKanbanTaskItemPayload) _then) = _$BulkUpdateKanbanTaskItemPayloadCopyWithImpl;
@useResult
$Res call({
 String taskId, int expectedVersion
});




}
/// @nodoc
class _$BulkUpdateKanbanTaskItemPayloadCopyWithImpl<$Res>
    implements $BulkUpdateKanbanTaskItemPayloadCopyWith<$Res> {
  _$BulkUpdateKanbanTaskItemPayloadCopyWithImpl(this._self, this._then);

  final BulkUpdateKanbanTaskItemPayload _self;
  final $Res Function(BulkUpdateKanbanTaskItemPayload) _then;

/// Create a copy of BulkUpdateKanbanTaskItemPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkUpdateKanbanTaskItemPayload].
extension BulkUpdateKanbanTaskItemPayloadPatterns on BulkUpdateKanbanTaskItemPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkUpdateKanbanTaskItemPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkUpdateKanbanTaskItemPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkUpdateKanbanTaskItemPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateKanbanTaskItemPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkUpdateKanbanTaskItemPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateKanbanTaskItemPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkUpdateKanbanTaskItemPayload() when $default != null:
return $default(_that.taskId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateKanbanTaskItemPayload():
return $default(_that.taskId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateKanbanTaskItemPayload() when $default != null:
return $default(_that.taskId,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkUpdateKanbanTaskItemPayload implements BulkUpdateKanbanTaskItemPayload {
  const _BulkUpdateKanbanTaskItemPayload({required this.taskId, required this.expectedVersion});
  factory _BulkUpdateKanbanTaskItemPayload.fromJson(Map<String, dynamic> json) => _$BulkUpdateKanbanTaskItemPayloadFromJson(json);

@override final  String taskId;
@override final  int expectedVersion;

/// Create a copy of BulkUpdateKanbanTaskItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkUpdateKanbanTaskItemPayloadCopyWith<_BulkUpdateKanbanTaskItemPayload> get copyWith => __$BulkUpdateKanbanTaskItemPayloadCopyWithImpl<_BulkUpdateKanbanTaskItemPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkUpdateKanbanTaskItemPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkUpdateKanbanTaskItemPayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,expectedVersion);

@override
String toString() {
  return 'BulkUpdateKanbanTaskItemPayload(taskId: $taskId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$BulkUpdateKanbanTaskItemPayloadCopyWith<$Res> implements $BulkUpdateKanbanTaskItemPayloadCopyWith<$Res> {
  factory _$BulkUpdateKanbanTaskItemPayloadCopyWith(_BulkUpdateKanbanTaskItemPayload value, $Res Function(_BulkUpdateKanbanTaskItemPayload) _then) = __$BulkUpdateKanbanTaskItemPayloadCopyWithImpl;
@override @useResult
$Res call({
 String taskId, int expectedVersion
});




}
/// @nodoc
class __$BulkUpdateKanbanTaskItemPayloadCopyWithImpl<$Res>
    implements _$BulkUpdateKanbanTaskItemPayloadCopyWith<$Res> {
  __$BulkUpdateKanbanTaskItemPayloadCopyWithImpl(this._self, this._then);

  final _BulkUpdateKanbanTaskItemPayload _self;
  final $Res Function(_BulkUpdateKanbanTaskItemPayload) _then;

/// Create a copy of BulkUpdateKanbanTaskItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? expectedVersion = null,}) {
  return _then(_BulkUpdateKanbanTaskItemPayload(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BulkUpdateKanbanTasksPayload {

 List<BulkUpdateKanbanTaskItemPayload> get tasks; TaskPriority? get priority; DateTime? get dueAtUtc; List<String>? get assigneeIds; List<String>? get labelIds;
/// Create a copy of BulkUpdateKanbanTasksPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkUpdateKanbanTasksPayloadCopyWith<BulkUpdateKanbanTasksPayload> get copyWith => _$BulkUpdateKanbanTasksPayloadCopyWithImpl<BulkUpdateKanbanTasksPayload>(this as BulkUpdateKanbanTasksPayload, _$identity);

  /// Serializes this BulkUpdateKanbanTasksPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkUpdateKanbanTasksPayload&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeIds, assigneeIds)&&const DeepCollectionEquality().equals(other.labelIds, labelIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tasks),priority,dueAtUtc,const DeepCollectionEquality().hash(assigneeIds),const DeepCollectionEquality().hash(labelIds));

@override
String toString() {
  return 'BulkUpdateKanbanTasksPayload(tasks: $tasks, priority: $priority, dueAtUtc: $dueAtUtc, assigneeIds: $assigneeIds, labelIds: $labelIds)';
}


}

/// @nodoc
abstract mixin class $BulkUpdateKanbanTasksPayloadCopyWith<$Res>  {
  factory $BulkUpdateKanbanTasksPayloadCopyWith(BulkUpdateKanbanTasksPayload value, $Res Function(BulkUpdateKanbanTasksPayload) _then) = _$BulkUpdateKanbanTasksPayloadCopyWithImpl;
@useResult
$Res call({
 List<BulkUpdateKanbanTaskItemPayload> tasks, TaskPriority? priority, DateTime? dueAtUtc, List<String>? assigneeIds, List<String>? labelIds
});




}
/// @nodoc
class _$BulkUpdateKanbanTasksPayloadCopyWithImpl<$Res>
    implements $BulkUpdateKanbanTasksPayloadCopyWith<$Res> {
  _$BulkUpdateKanbanTasksPayloadCopyWithImpl(this._self, this._then);

  final BulkUpdateKanbanTasksPayload _self;
  final $Res Function(BulkUpdateKanbanTasksPayload) _then;

/// Create a copy of BulkUpdateKanbanTasksPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasks = null,Object? priority = freezed,Object? dueAtUtc = freezed,Object? assigneeIds = freezed,Object? labelIds = freezed,}) {
  return _then(_self.copyWith(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<BulkUpdateKanbanTaskItemPayload>,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assigneeIds: freezed == assigneeIds ? _self.assigneeIds : assigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>?,labelIds: freezed == labelIds ? _self.labelIds : labelIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkUpdateKanbanTasksPayload].
extension BulkUpdateKanbanTasksPayloadPatterns on BulkUpdateKanbanTasksPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkUpdateKanbanTasksPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkUpdateKanbanTasksPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkUpdateKanbanTasksPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BulkUpdateKanbanTaskItemPayload> tasks,  TaskPriority? priority,  DateTime? dueAtUtc,  List<String>? assigneeIds,  List<String>? labelIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksPayload() when $default != null:
return $default(_that.tasks,_that.priority,_that.dueAtUtc,_that.assigneeIds,_that.labelIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BulkUpdateKanbanTaskItemPayload> tasks,  TaskPriority? priority,  DateTime? dueAtUtc,  List<String>? assigneeIds,  List<String>? labelIds)  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksPayload():
return $default(_that.tasks,_that.priority,_that.dueAtUtc,_that.assigneeIds,_that.labelIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BulkUpdateKanbanTaskItemPayload> tasks,  TaskPriority? priority,  DateTime? dueAtUtc,  List<String>? assigneeIds,  List<String>? labelIds)?  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksPayload() when $default != null:
return $default(_that.tasks,_that.priority,_that.dueAtUtc,_that.assigneeIds,_that.labelIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkUpdateKanbanTasksPayload implements BulkUpdateKanbanTasksPayload {
  const _BulkUpdateKanbanTasksPayload({required this.tasks, this.priority, this.dueAtUtc, this.assigneeIds, this.labelIds});
  factory _BulkUpdateKanbanTasksPayload.fromJson(Map<String, dynamic> json) => _$BulkUpdateKanbanTasksPayloadFromJson(json);

@override final  List<BulkUpdateKanbanTaskItemPayload> tasks;
@override final  TaskPriority? priority;
@override final  DateTime? dueAtUtc;
@override final  List<String>? assigneeIds;
@override final  List<String>? labelIds;

/// Create a copy of BulkUpdateKanbanTasksPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkUpdateKanbanTasksPayloadCopyWith<_BulkUpdateKanbanTasksPayload> get copyWith => __$BulkUpdateKanbanTasksPayloadCopyWithImpl<_BulkUpdateKanbanTasksPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkUpdateKanbanTasksPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkUpdateKanbanTasksPayload&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeIds, assigneeIds)&&const DeepCollectionEquality().equals(other.labelIds, labelIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tasks),priority,dueAtUtc,const DeepCollectionEquality().hash(assigneeIds),const DeepCollectionEquality().hash(labelIds));

@override
String toString() {
  return 'BulkUpdateKanbanTasksPayload(tasks: $tasks, priority: $priority, dueAtUtc: $dueAtUtc, assigneeIds: $assigneeIds, labelIds: $labelIds)';
}


}

/// @nodoc
abstract mixin class _$BulkUpdateKanbanTasksPayloadCopyWith<$Res> implements $BulkUpdateKanbanTasksPayloadCopyWith<$Res> {
  factory _$BulkUpdateKanbanTasksPayloadCopyWith(_BulkUpdateKanbanTasksPayload value, $Res Function(_BulkUpdateKanbanTasksPayload) _then) = __$BulkUpdateKanbanTasksPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<BulkUpdateKanbanTaskItemPayload> tasks, TaskPriority? priority, DateTime? dueAtUtc, List<String>? assigneeIds, List<String>? labelIds
});




}
/// @nodoc
class __$BulkUpdateKanbanTasksPayloadCopyWithImpl<$Res>
    implements _$BulkUpdateKanbanTasksPayloadCopyWith<$Res> {
  __$BulkUpdateKanbanTasksPayloadCopyWithImpl(this._self, this._then);

  final _BulkUpdateKanbanTasksPayload _self;
  final $Res Function(_BulkUpdateKanbanTasksPayload) _then;

/// Create a copy of BulkUpdateKanbanTasksPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasks = null,Object? priority = freezed,Object? dueAtUtc = freezed,Object? assigneeIds = freezed,Object? labelIds = freezed,}) {
  return _then(_BulkUpdateKanbanTasksPayload(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<BulkUpdateKanbanTaskItemPayload>,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assigneeIds: freezed == assigneeIds ? _self.assigneeIds : assigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>?,labelIds: freezed == labelIds ? _self.labelIds : labelIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$BulkUpdateKanbanTasksResponse {

 List<KanbanTaskCardResponse> get tasks; int get updatedCount;
/// Create a copy of BulkUpdateKanbanTasksResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkUpdateKanbanTasksResponseCopyWith<BulkUpdateKanbanTasksResponse> get copyWith => _$BulkUpdateKanbanTasksResponseCopyWithImpl<BulkUpdateKanbanTasksResponse>(this as BulkUpdateKanbanTasksResponse, _$identity);

  /// Serializes this BulkUpdateKanbanTasksResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkUpdateKanbanTasksResponse&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.updatedCount, updatedCount) || other.updatedCount == updatedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tasks),updatedCount);

@override
String toString() {
  return 'BulkUpdateKanbanTasksResponse(tasks: $tasks, updatedCount: $updatedCount)';
}


}

/// @nodoc
abstract mixin class $BulkUpdateKanbanTasksResponseCopyWith<$Res>  {
  factory $BulkUpdateKanbanTasksResponseCopyWith(BulkUpdateKanbanTasksResponse value, $Res Function(BulkUpdateKanbanTasksResponse) _then) = _$BulkUpdateKanbanTasksResponseCopyWithImpl;
@useResult
$Res call({
 List<KanbanTaskCardResponse> tasks, int updatedCount
});




}
/// @nodoc
class _$BulkUpdateKanbanTasksResponseCopyWithImpl<$Res>
    implements $BulkUpdateKanbanTasksResponseCopyWith<$Res> {
  _$BulkUpdateKanbanTasksResponseCopyWithImpl(this._self, this._then);

  final BulkUpdateKanbanTasksResponse _self;
  final $Res Function(BulkUpdateKanbanTasksResponse) _then;

/// Create a copy of BulkUpdateKanbanTasksResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasks = null,Object? updatedCount = null,}) {
  return _then(_self.copyWith(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<KanbanTaskCardResponse>,updatedCount: null == updatedCount ? _self.updatedCount : updatedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkUpdateKanbanTasksResponse].
extension BulkUpdateKanbanTasksResponsePatterns on BulkUpdateKanbanTasksResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkUpdateKanbanTasksResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkUpdateKanbanTasksResponse value)  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkUpdateKanbanTasksResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<KanbanTaskCardResponse> tasks,  int updatedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksResponse() when $default != null:
return $default(_that.tasks,_that.updatedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<KanbanTaskCardResponse> tasks,  int updatedCount)  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksResponse():
return $default(_that.tasks,_that.updatedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<KanbanTaskCardResponse> tasks,  int updatedCount)?  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateKanbanTasksResponse() when $default != null:
return $default(_that.tasks,_that.updatedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkUpdateKanbanTasksResponse implements BulkUpdateKanbanTasksResponse {
  const _BulkUpdateKanbanTasksResponse({required this.tasks, required this.updatedCount});
  factory _BulkUpdateKanbanTasksResponse.fromJson(Map<String, dynamic> json) => _$BulkUpdateKanbanTasksResponseFromJson(json);

@override final  List<KanbanTaskCardResponse> tasks;
@override final  int updatedCount;

/// Create a copy of BulkUpdateKanbanTasksResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkUpdateKanbanTasksResponseCopyWith<_BulkUpdateKanbanTasksResponse> get copyWith => __$BulkUpdateKanbanTasksResponseCopyWithImpl<_BulkUpdateKanbanTasksResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkUpdateKanbanTasksResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkUpdateKanbanTasksResponse&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.updatedCount, updatedCount) || other.updatedCount == updatedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tasks),updatedCount);

@override
String toString() {
  return 'BulkUpdateKanbanTasksResponse(tasks: $tasks, updatedCount: $updatedCount)';
}


}

/// @nodoc
abstract mixin class _$BulkUpdateKanbanTasksResponseCopyWith<$Res> implements $BulkUpdateKanbanTasksResponseCopyWith<$Res> {
  factory _$BulkUpdateKanbanTasksResponseCopyWith(_BulkUpdateKanbanTasksResponse value, $Res Function(_BulkUpdateKanbanTasksResponse) _then) = __$BulkUpdateKanbanTasksResponseCopyWithImpl;
@override @useResult
$Res call({
 List<KanbanTaskCardResponse> tasks, int updatedCount
});




}
/// @nodoc
class __$BulkUpdateKanbanTasksResponseCopyWithImpl<$Res>
    implements _$BulkUpdateKanbanTasksResponseCopyWith<$Res> {
  __$BulkUpdateKanbanTasksResponseCopyWithImpl(this._self, this._then);

  final _BulkUpdateKanbanTasksResponse _self;
  final $Res Function(_BulkUpdateKanbanTasksResponse) _then;

/// Create a copy of BulkUpdateKanbanTasksResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasks = null,Object? updatedCount = null,}) {
  return _then(_BulkUpdateKanbanTasksResponse(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<KanbanTaskCardResponse>,updatedCount: null == updatedCount ? _self.updatedCount : updatedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UpdateProjectKanbanSettingsPayload {

 KanbanSwimlaneMode get swimlaneMode; Map<String, int> get columnWipLimits; List<ProjectTaskStatus> get hiddenColumns; int get expectedVersion; List<KanbanCardField>? get visibleCardFields; KanbanCardDensity get defaultCardDensity;
/// Create a copy of UpdateProjectKanbanSettingsPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProjectKanbanSettingsPayloadCopyWith<UpdateProjectKanbanSettingsPayload> get copyWith => _$UpdateProjectKanbanSettingsPayloadCopyWithImpl<UpdateProjectKanbanSettingsPayload>(this as UpdateProjectKanbanSettingsPayload, _$identity);

  /// Serializes this UpdateProjectKanbanSettingsPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProjectKanbanSettingsPayload&&(identical(other.swimlaneMode, swimlaneMode) || other.swimlaneMode == swimlaneMode)&&const DeepCollectionEquality().equals(other.columnWipLimits, columnWipLimits)&&const DeepCollectionEquality().equals(other.hiddenColumns, hiddenColumns)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&const DeepCollectionEquality().equals(other.visibleCardFields, visibleCardFields)&&(identical(other.defaultCardDensity, defaultCardDensity) || other.defaultCardDensity == defaultCardDensity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,swimlaneMode,const DeepCollectionEquality().hash(columnWipLimits),const DeepCollectionEquality().hash(hiddenColumns),expectedVersion,const DeepCollectionEquality().hash(visibleCardFields),defaultCardDensity);

@override
String toString() {
  return 'UpdateProjectKanbanSettingsPayload(swimlaneMode: $swimlaneMode, columnWipLimits: $columnWipLimits, hiddenColumns: $hiddenColumns, expectedVersion: $expectedVersion, visibleCardFields: $visibleCardFields, defaultCardDensity: $defaultCardDensity)';
}


}

/// @nodoc
abstract mixin class $UpdateProjectKanbanSettingsPayloadCopyWith<$Res>  {
  factory $UpdateProjectKanbanSettingsPayloadCopyWith(UpdateProjectKanbanSettingsPayload value, $Res Function(UpdateProjectKanbanSettingsPayload) _then) = _$UpdateProjectKanbanSettingsPayloadCopyWithImpl;
@useResult
$Res call({
 KanbanSwimlaneMode swimlaneMode, Map<String, int> columnWipLimits, List<ProjectTaskStatus> hiddenColumns, int expectedVersion, List<KanbanCardField>? visibleCardFields, KanbanCardDensity defaultCardDensity
});




}
/// @nodoc
class _$UpdateProjectKanbanSettingsPayloadCopyWithImpl<$Res>
    implements $UpdateProjectKanbanSettingsPayloadCopyWith<$Res> {
  _$UpdateProjectKanbanSettingsPayloadCopyWithImpl(this._self, this._then);

  final UpdateProjectKanbanSettingsPayload _self;
  final $Res Function(UpdateProjectKanbanSettingsPayload) _then;

/// Create a copy of UpdateProjectKanbanSettingsPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? swimlaneMode = null,Object? columnWipLimits = null,Object? hiddenColumns = null,Object? expectedVersion = null,Object? visibleCardFields = freezed,Object? defaultCardDensity = null,}) {
  return _then(_self.copyWith(
swimlaneMode: null == swimlaneMode ? _self.swimlaneMode : swimlaneMode // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode,columnWipLimits: null == columnWipLimits ? _self.columnWipLimits : columnWipLimits // ignore: cast_nullable_to_non_nullable
as Map<String, int>,hiddenColumns: null == hiddenColumns ? _self.hiddenColumns : hiddenColumns // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,visibleCardFields: freezed == visibleCardFields ? _self.visibleCardFields : visibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>?,defaultCardDensity: null == defaultCardDensity ? _self.defaultCardDensity : defaultCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProjectKanbanSettingsPayload].
extension UpdateProjectKanbanSettingsPayloadPatterns on UpdateProjectKanbanSettingsPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProjectKanbanSettingsPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProjectKanbanSettingsPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProjectKanbanSettingsPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectKanbanSettingsPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProjectKanbanSettingsPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectKanbanSettingsPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KanbanSwimlaneMode swimlaneMode,  Map<String, int> columnWipLimits,  List<ProjectTaskStatus> hiddenColumns,  int expectedVersion,  List<KanbanCardField>? visibleCardFields,  KanbanCardDensity defaultCardDensity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProjectKanbanSettingsPayload() when $default != null:
return $default(_that.swimlaneMode,_that.columnWipLimits,_that.hiddenColumns,_that.expectedVersion,_that.visibleCardFields,_that.defaultCardDensity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KanbanSwimlaneMode swimlaneMode,  Map<String, int> columnWipLimits,  List<ProjectTaskStatus> hiddenColumns,  int expectedVersion,  List<KanbanCardField>? visibleCardFields,  KanbanCardDensity defaultCardDensity)  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectKanbanSettingsPayload():
return $default(_that.swimlaneMode,_that.columnWipLimits,_that.hiddenColumns,_that.expectedVersion,_that.visibleCardFields,_that.defaultCardDensity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KanbanSwimlaneMode swimlaneMode,  Map<String, int> columnWipLimits,  List<ProjectTaskStatus> hiddenColumns,  int expectedVersion,  List<KanbanCardField>? visibleCardFields,  KanbanCardDensity defaultCardDensity)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectKanbanSettingsPayload() when $default != null:
return $default(_that.swimlaneMode,_that.columnWipLimits,_that.hiddenColumns,_that.expectedVersion,_that.visibleCardFields,_that.defaultCardDensity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProjectKanbanSettingsPayload implements UpdateProjectKanbanSettingsPayload {
  const _UpdateProjectKanbanSettingsPayload({required this.swimlaneMode, required this.columnWipLimits, required this.hiddenColumns, required this.expectedVersion, this.visibleCardFields, this.defaultCardDensity = KanbanCardDensity.comfortable});
  factory _UpdateProjectKanbanSettingsPayload.fromJson(Map<String, dynamic> json) => _$UpdateProjectKanbanSettingsPayloadFromJson(json);

@override final  KanbanSwimlaneMode swimlaneMode;
@override final  Map<String, int> columnWipLimits;
@override final  List<ProjectTaskStatus> hiddenColumns;
@override final  int expectedVersion;
@override final  List<KanbanCardField>? visibleCardFields;
@override@JsonKey() final  KanbanCardDensity defaultCardDensity;

/// Create a copy of UpdateProjectKanbanSettingsPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProjectKanbanSettingsPayloadCopyWith<_UpdateProjectKanbanSettingsPayload> get copyWith => __$UpdateProjectKanbanSettingsPayloadCopyWithImpl<_UpdateProjectKanbanSettingsPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProjectKanbanSettingsPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProjectKanbanSettingsPayload&&(identical(other.swimlaneMode, swimlaneMode) || other.swimlaneMode == swimlaneMode)&&const DeepCollectionEquality().equals(other.columnWipLimits, columnWipLimits)&&const DeepCollectionEquality().equals(other.hiddenColumns, hiddenColumns)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&const DeepCollectionEquality().equals(other.visibleCardFields, visibleCardFields)&&(identical(other.defaultCardDensity, defaultCardDensity) || other.defaultCardDensity == defaultCardDensity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,swimlaneMode,const DeepCollectionEquality().hash(columnWipLimits),const DeepCollectionEquality().hash(hiddenColumns),expectedVersion,const DeepCollectionEquality().hash(visibleCardFields),defaultCardDensity);

@override
String toString() {
  return 'UpdateProjectKanbanSettingsPayload(swimlaneMode: $swimlaneMode, columnWipLimits: $columnWipLimits, hiddenColumns: $hiddenColumns, expectedVersion: $expectedVersion, visibleCardFields: $visibleCardFields, defaultCardDensity: $defaultCardDensity)';
}


}

/// @nodoc
abstract mixin class _$UpdateProjectKanbanSettingsPayloadCopyWith<$Res> implements $UpdateProjectKanbanSettingsPayloadCopyWith<$Res> {
  factory _$UpdateProjectKanbanSettingsPayloadCopyWith(_UpdateProjectKanbanSettingsPayload value, $Res Function(_UpdateProjectKanbanSettingsPayload) _then) = __$UpdateProjectKanbanSettingsPayloadCopyWithImpl;
@override @useResult
$Res call({
 KanbanSwimlaneMode swimlaneMode, Map<String, int> columnWipLimits, List<ProjectTaskStatus> hiddenColumns, int expectedVersion, List<KanbanCardField>? visibleCardFields, KanbanCardDensity defaultCardDensity
});




}
/// @nodoc
class __$UpdateProjectKanbanSettingsPayloadCopyWithImpl<$Res>
    implements _$UpdateProjectKanbanSettingsPayloadCopyWith<$Res> {
  __$UpdateProjectKanbanSettingsPayloadCopyWithImpl(this._self, this._then);

  final _UpdateProjectKanbanSettingsPayload _self;
  final $Res Function(_UpdateProjectKanbanSettingsPayload) _then;

/// Create a copy of UpdateProjectKanbanSettingsPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? swimlaneMode = null,Object? columnWipLimits = null,Object? hiddenColumns = null,Object? expectedVersion = null,Object? visibleCardFields = freezed,Object? defaultCardDensity = null,}) {
  return _then(_UpdateProjectKanbanSettingsPayload(
swimlaneMode: null == swimlaneMode ? _self.swimlaneMode : swimlaneMode // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode,columnWipLimits: null == columnWipLimits ? _self.columnWipLimits : columnWipLimits // ignore: cast_nullable_to_non_nullable
as Map<String, int>,hiddenColumns: null == hiddenColumns ? _self.hiddenColumns : hiddenColumns // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,visibleCardFields: freezed == visibleCardFields ? _self.visibleCardFields : visibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>?,defaultCardDensity: null == defaultCardDensity ? _self.defaultCardDensity : defaultCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity,
  ));
}


}


/// @nodoc
mixin _$ProjectKanbanSettingsResponse {

 String get projectId; KanbanSwimlaneMode get swimlaneMode; Map<String, int> get columnWipLimits; List<ProjectTaskStatus> get hiddenColumns; List<KanbanCardField> get visibleCardFields; KanbanCardDensity get defaultCardDensity; DateTime get updatedAtUtc; int get version;
/// Create a copy of ProjectKanbanSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectKanbanSettingsResponseCopyWith<ProjectKanbanSettingsResponse> get copyWith => _$ProjectKanbanSettingsResponseCopyWithImpl<ProjectKanbanSettingsResponse>(this as ProjectKanbanSettingsResponse, _$identity);

  /// Serializes this ProjectKanbanSettingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectKanbanSettingsResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.swimlaneMode, swimlaneMode) || other.swimlaneMode == swimlaneMode)&&const DeepCollectionEquality().equals(other.columnWipLimits, columnWipLimits)&&const DeepCollectionEquality().equals(other.hiddenColumns, hiddenColumns)&&const DeepCollectionEquality().equals(other.visibleCardFields, visibleCardFields)&&(identical(other.defaultCardDensity, defaultCardDensity) || other.defaultCardDensity == defaultCardDensity)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,swimlaneMode,const DeepCollectionEquality().hash(columnWipLimits),const DeepCollectionEquality().hash(hiddenColumns),const DeepCollectionEquality().hash(visibleCardFields),defaultCardDensity,updatedAtUtc,version);

@override
String toString() {
  return 'ProjectKanbanSettingsResponse(projectId: $projectId, swimlaneMode: $swimlaneMode, columnWipLimits: $columnWipLimits, hiddenColumns: $hiddenColumns, visibleCardFields: $visibleCardFields, defaultCardDensity: $defaultCardDensity, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $ProjectKanbanSettingsResponseCopyWith<$Res>  {
  factory $ProjectKanbanSettingsResponseCopyWith(ProjectKanbanSettingsResponse value, $Res Function(ProjectKanbanSettingsResponse) _then) = _$ProjectKanbanSettingsResponseCopyWithImpl;
@useResult
$Res call({
 String projectId, KanbanSwimlaneMode swimlaneMode, Map<String, int> columnWipLimits, List<ProjectTaskStatus> hiddenColumns, List<KanbanCardField> visibleCardFields, KanbanCardDensity defaultCardDensity, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$ProjectKanbanSettingsResponseCopyWithImpl<$Res>
    implements $ProjectKanbanSettingsResponseCopyWith<$Res> {
  _$ProjectKanbanSettingsResponseCopyWithImpl(this._self, this._then);

  final ProjectKanbanSettingsResponse _self;
  final $Res Function(ProjectKanbanSettingsResponse) _then;

/// Create a copy of ProjectKanbanSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? swimlaneMode = null,Object? columnWipLimits = null,Object? hiddenColumns = null,Object? visibleCardFields = null,Object? defaultCardDensity = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,swimlaneMode: null == swimlaneMode ? _self.swimlaneMode : swimlaneMode // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode,columnWipLimits: null == columnWipLimits ? _self.columnWipLimits : columnWipLimits // ignore: cast_nullable_to_non_nullable
as Map<String, int>,hiddenColumns: null == hiddenColumns ? _self.hiddenColumns : hiddenColumns // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>,visibleCardFields: null == visibleCardFields ? _self.visibleCardFields : visibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>,defaultCardDensity: null == defaultCardDensity ? _self.defaultCardDensity : defaultCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectKanbanSettingsResponse].
extension ProjectKanbanSettingsResponsePatterns on ProjectKanbanSettingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectKanbanSettingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectKanbanSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectKanbanSettingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectKanbanSettingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectKanbanSettingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectKanbanSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  KanbanSwimlaneMode swimlaneMode,  Map<String, int> columnWipLimits,  List<ProjectTaskStatus> hiddenColumns,  List<KanbanCardField> visibleCardFields,  KanbanCardDensity defaultCardDensity,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectKanbanSettingsResponse() when $default != null:
return $default(_that.projectId,_that.swimlaneMode,_that.columnWipLimits,_that.hiddenColumns,_that.visibleCardFields,_that.defaultCardDensity,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  KanbanSwimlaneMode swimlaneMode,  Map<String, int> columnWipLimits,  List<ProjectTaskStatus> hiddenColumns,  List<KanbanCardField> visibleCardFields,  KanbanCardDensity defaultCardDensity,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _ProjectKanbanSettingsResponse():
return $default(_that.projectId,_that.swimlaneMode,_that.columnWipLimits,_that.hiddenColumns,_that.visibleCardFields,_that.defaultCardDensity,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  KanbanSwimlaneMode swimlaneMode,  Map<String, int> columnWipLimits,  List<ProjectTaskStatus> hiddenColumns,  List<KanbanCardField> visibleCardFields,  KanbanCardDensity defaultCardDensity,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _ProjectKanbanSettingsResponse() when $default != null:
return $default(_that.projectId,_that.swimlaneMode,_that.columnWipLimits,_that.hiddenColumns,_that.visibleCardFields,_that.defaultCardDensity,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectKanbanSettingsResponse implements ProjectKanbanSettingsResponse {
  const _ProjectKanbanSettingsResponse({required this.projectId, required this.swimlaneMode, required this.columnWipLimits, required this.hiddenColumns, required this.visibleCardFields, required this.defaultCardDensity, required this.updatedAtUtc, required this.version});
  factory _ProjectKanbanSettingsResponse.fromJson(Map<String, dynamic> json) => _$ProjectKanbanSettingsResponseFromJson(json);

@override final  String projectId;
@override final  KanbanSwimlaneMode swimlaneMode;
@override final  Map<String, int> columnWipLimits;
@override final  List<ProjectTaskStatus> hiddenColumns;
@override final  List<KanbanCardField> visibleCardFields;
@override final  KanbanCardDensity defaultCardDensity;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of ProjectKanbanSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectKanbanSettingsResponseCopyWith<_ProjectKanbanSettingsResponse> get copyWith => __$ProjectKanbanSettingsResponseCopyWithImpl<_ProjectKanbanSettingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectKanbanSettingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectKanbanSettingsResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.swimlaneMode, swimlaneMode) || other.swimlaneMode == swimlaneMode)&&const DeepCollectionEquality().equals(other.columnWipLimits, columnWipLimits)&&const DeepCollectionEquality().equals(other.hiddenColumns, hiddenColumns)&&const DeepCollectionEquality().equals(other.visibleCardFields, visibleCardFields)&&(identical(other.defaultCardDensity, defaultCardDensity) || other.defaultCardDensity == defaultCardDensity)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,swimlaneMode,const DeepCollectionEquality().hash(columnWipLimits),const DeepCollectionEquality().hash(hiddenColumns),const DeepCollectionEquality().hash(visibleCardFields),defaultCardDensity,updatedAtUtc,version);

@override
String toString() {
  return 'ProjectKanbanSettingsResponse(projectId: $projectId, swimlaneMode: $swimlaneMode, columnWipLimits: $columnWipLimits, hiddenColumns: $hiddenColumns, visibleCardFields: $visibleCardFields, defaultCardDensity: $defaultCardDensity, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ProjectKanbanSettingsResponseCopyWith<$Res> implements $ProjectKanbanSettingsResponseCopyWith<$Res> {
  factory _$ProjectKanbanSettingsResponseCopyWith(_ProjectKanbanSettingsResponse value, $Res Function(_ProjectKanbanSettingsResponse) _then) = __$ProjectKanbanSettingsResponseCopyWithImpl;
@override @useResult
$Res call({
 String projectId, KanbanSwimlaneMode swimlaneMode, Map<String, int> columnWipLimits, List<ProjectTaskStatus> hiddenColumns, List<KanbanCardField> visibleCardFields, KanbanCardDensity defaultCardDensity, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$ProjectKanbanSettingsResponseCopyWithImpl<$Res>
    implements _$ProjectKanbanSettingsResponseCopyWith<$Res> {
  __$ProjectKanbanSettingsResponseCopyWithImpl(this._self, this._then);

  final _ProjectKanbanSettingsResponse _self;
  final $Res Function(_ProjectKanbanSettingsResponse) _then;

/// Create a copy of ProjectKanbanSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? swimlaneMode = null,Object? columnWipLimits = null,Object? hiddenColumns = null,Object? visibleCardFields = null,Object? defaultCardDensity = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_ProjectKanbanSettingsResponse(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,swimlaneMode: null == swimlaneMode ? _self.swimlaneMode : swimlaneMode // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode,columnWipLimits: null == columnWipLimits ? _self.columnWipLimits : columnWipLimits // ignore: cast_nullable_to_non_nullable
as Map<String, int>,hiddenColumns: null == hiddenColumns ? _self.hiddenColumns : hiddenColumns // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>,visibleCardFields: null == visibleCardFields ? _self.visibleCardFields : visibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>,defaultCardDensity: null == defaultCardDensity ? _self.defaultCardDensity : defaultCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UpdateUserKanbanPreferencePayload {

 List<ProjectTaskStatus> get collapsedColumns; KanbanQuickFilter get quickFilter; int get expectedVersion; List<String>? get collapsedCustomStatusIds;
/// Create a copy of UpdateUserKanbanPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateUserKanbanPreferencePayloadCopyWith<UpdateUserKanbanPreferencePayload> get copyWith => _$UpdateUserKanbanPreferencePayloadCopyWithImpl<UpdateUserKanbanPreferencePayload>(this as UpdateUserKanbanPreferencePayload, _$identity);

  /// Serializes this UpdateUserKanbanPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUserKanbanPreferencePayload&&const DeepCollectionEquality().equals(other.collapsedColumns, collapsedColumns)&&(identical(other.quickFilter, quickFilter) || other.quickFilter == quickFilter)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&const DeepCollectionEquality().equals(other.collapsedCustomStatusIds, collapsedCustomStatusIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(collapsedColumns),quickFilter,expectedVersion,const DeepCollectionEquality().hash(collapsedCustomStatusIds));

@override
String toString() {
  return 'UpdateUserKanbanPreferencePayload(collapsedColumns: $collapsedColumns, quickFilter: $quickFilter, expectedVersion: $expectedVersion, collapsedCustomStatusIds: $collapsedCustomStatusIds)';
}


}

/// @nodoc
abstract mixin class $UpdateUserKanbanPreferencePayloadCopyWith<$Res>  {
  factory $UpdateUserKanbanPreferencePayloadCopyWith(UpdateUserKanbanPreferencePayload value, $Res Function(UpdateUserKanbanPreferencePayload) _then) = _$UpdateUserKanbanPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 List<ProjectTaskStatus> collapsedColumns, KanbanQuickFilter quickFilter, int expectedVersion, List<String>? collapsedCustomStatusIds
});




}
/// @nodoc
class _$UpdateUserKanbanPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateUserKanbanPreferencePayloadCopyWith<$Res> {
  _$UpdateUserKanbanPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateUserKanbanPreferencePayload _self;
  final $Res Function(UpdateUserKanbanPreferencePayload) _then;

/// Create a copy of UpdateUserKanbanPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? collapsedColumns = null,Object? quickFilter = null,Object? expectedVersion = null,Object? collapsedCustomStatusIds = freezed,}) {
  return _then(_self.copyWith(
collapsedColumns: null == collapsedColumns ? _self.collapsedColumns : collapsedColumns // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>,quickFilter: null == quickFilter ? _self.quickFilter : quickFilter // ignore: cast_nullable_to_non_nullable
as KanbanQuickFilter,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,collapsedCustomStatusIds: freezed == collapsedCustomStatusIds ? _self.collapsedCustomStatusIds : collapsedCustomStatusIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateUserKanbanPreferencePayload].
extension UpdateUserKanbanPreferencePayloadPatterns on UpdateUserKanbanPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateUserKanbanPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateUserKanbanPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateUserKanbanPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateUserKanbanPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateUserKanbanPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateUserKanbanPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProjectTaskStatus> collapsedColumns,  KanbanQuickFilter quickFilter,  int expectedVersion,  List<String>? collapsedCustomStatusIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateUserKanbanPreferencePayload() when $default != null:
return $default(_that.collapsedColumns,_that.quickFilter,_that.expectedVersion,_that.collapsedCustomStatusIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProjectTaskStatus> collapsedColumns,  KanbanQuickFilter quickFilter,  int expectedVersion,  List<String>? collapsedCustomStatusIds)  $default,) {final _that = this;
switch (_that) {
case _UpdateUserKanbanPreferencePayload():
return $default(_that.collapsedColumns,_that.quickFilter,_that.expectedVersion,_that.collapsedCustomStatusIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProjectTaskStatus> collapsedColumns,  KanbanQuickFilter quickFilter,  int expectedVersion,  List<String>? collapsedCustomStatusIds)?  $default,) {final _that = this;
switch (_that) {
case _UpdateUserKanbanPreferencePayload() when $default != null:
return $default(_that.collapsedColumns,_that.quickFilter,_that.expectedVersion,_that.collapsedCustomStatusIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateUserKanbanPreferencePayload implements UpdateUserKanbanPreferencePayload {
  const _UpdateUserKanbanPreferencePayload({required this.collapsedColumns, required this.quickFilter, required this.expectedVersion, this.collapsedCustomStatusIds});
  factory _UpdateUserKanbanPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateUserKanbanPreferencePayloadFromJson(json);

@override final  List<ProjectTaskStatus> collapsedColumns;
@override final  KanbanQuickFilter quickFilter;
@override final  int expectedVersion;
@override final  List<String>? collapsedCustomStatusIds;

/// Create a copy of UpdateUserKanbanPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateUserKanbanPreferencePayloadCopyWith<_UpdateUserKanbanPreferencePayload> get copyWith => __$UpdateUserKanbanPreferencePayloadCopyWithImpl<_UpdateUserKanbanPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateUserKanbanPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateUserKanbanPreferencePayload&&const DeepCollectionEquality().equals(other.collapsedColumns, collapsedColumns)&&(identical(other.quickFilter, quickFilter) || other.quickFilter == quickFilter)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&const DeepCollectionEquality().equals(other.collapsedCustomStatusIds, collapsedCustomStatusIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(collapsedColumns),quickFilter,expectedVersion,const DeepCollectionEquality().hash(collapsedCustomStatusIds));

@override
String toString() {
  return 'UpdateUserKanbanPreferencePayload(collapsedColumns: $collapsedColumns, quickFilter: $quickFilter, expectedVersion: $expectedVersion, collapsedCustomStatusIds: $collapsedCustomStatusIds)';
}


}

/// @nodoc
abstract mixin class _$UpdateUserKanbanPreferencePayloadCopyWith<$Res> implements $UpdateUserKanbanPreferencePayloadCopyWith<$Res> {
  factory _$UpdateUserKanbanPreferencePayloadCopyWith(_UpdateUserKanbanPreferencePayload value, $Res Function(_UpdateUserKanbanPreferencePayload) _then) = __$UpdateUserKanbanPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 List<ProjectTaskStatus> collapsedColumns, KanbanQuickFilter quickFilter, int expectedVersion, List<String>? collapsedCustomStatusIds
});




}
/// @nodoc
class __$UpdateUserKanbanPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateUserKanbanPreferencePayloadCopyWith<$Res> {
  __$UpdateUserKanbanPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateUserKanbanPreferencePayload _self;
  final $Res Function(_UpdateUserKanbanPreferencePayload) _then;

/// Create a copy of UpdateUserKanbanPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? collapsedColumns = null,Object? quickFilter = null,Object? expectedVersion = null,Object? collapsedCustomStatusIds = freezed,}) {
  return _then(_UpdateUserKanbanPreferencePayload(
collapsedColumns: null == collapsedColumns ? _self.collapsedColumns : collapsedColumns // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>,quickFilter: null == quickFilter ? _self.quickFilter : quickFilter // ignore: cast_nullable_to_non_nullable
as KanbanQuickFilter,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,collapsedCustomStatusIds: freezed == collapsedCustomStatusIds ? _self.collapsedCustomStatusIds : collapsedCustomStatusIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$UserKanbanPreferenceResponse {

 String get workspaceId; String get projectId; String get userId; List<ProjectTaskStatus> get collapsedColumns; KanbanQuickFilter get quickFilter; DateTime? get updatedAtUtc; int get version; List<String> get collapsedCustomStatusIds;
/// Create a copy of UserKanbanPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserKanbanPreferenceResponseCopyWith<UserKanbanPreferenceResponse> get copyWith => _$UserKanbanPreferenceResponseCopyWithImpl<UserKanbanPreferenceResponse>(this as UserKanbanPreferenceResponse, _$identity);

  /// Serializes this UserKanbanPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserKanbanPreferenceResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.collapsedColumns, collapsedColumns)&&(identical(other.quickFilter, quickFilter) || other.quickFilter == quickFilter)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.collapsedCustomStatusIds, collapsedCustomStatusIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,projectId,userId,const DeepCollectionEquality().hash(collapsedColumns),quickFilter,updatedAtUtc,version,const DeepCollectionEquality().hash(collapsedCustomStatusIds));

@override
String toString() {
  return 'UserKanbanPreferenceResponse(workspaceId: $workspaceId, projectId: $projectId, userId: $userId, collapsedColumns: $collapsedColumns, quickFilter: $quickFilter, updatedAtUtc: $updatedAtUtc, version: $version, collapsedCustomStatusIds: $collapsedCustomStatusIds)';
}


}

/// @nodoc
abstract mixin class $UserKanbanPreferenceResponseCopyWith<$Res>  {
  factory $UserKanbanPreferenceResponseCopyWith(UserKanbanPreferenceResponse value, $Res Function(UserKanbanPreferenceResponse) _then) = _$UserKanbanPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String workspaceId, String projectId, String userId, List<ProjectTaskStatus> collapsedColumns, KanbanQuickFilter quickFilter, DateTime? updatedAtUtc, int version, List<String> collapsedCustomStatusIds
});




}
/// @nodoc
class _$UserKanbanPreferenceResponseCopyWithImpl<$Res>
    implements $UserKanbanPreferenceResponseCopyWith<$Res> {
  _$UserKanbanPreferenceResponseCopyWithImpl(this._self, this._then);

  final UserKanbanPreferenceResponse _self;
  final $Res Function(UserKanbanPreferenceResponse) _then;

/// Create a copy of UserKanbanPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workspaceId = null,Object? projectId = null,Object? userId = null,Object? collapsedColumns = null,Object? quickFilter = null,Object? updatedAtUtc = freezed,Object? version = null,Object? collapsedCustomStatusIds = null,}) {
  return _then(_self.copyWith(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,collapsedColumns: null == collapsedColumns ? _self.collapsedColumns : collapsedColumns // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>,quickFilter: null == quickFilter ? _self.quickFilter : quickFilter // ignore: cast_nullable_to_non_nullable
as KanbanQuickFilter,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,collapsedCustomStatusIds: null == collapsedCustomStatusIds ? _self.collapsedCustomStatusIds : collapsedCustomStatusIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserKanbanPreferenceResponse].
extension UserKanbanPreferenceResponsePatterns on UserKanbanPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserKanbanPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserKanbanPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserKanbanPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _UserKanbanPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserKanbanPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UserKanbanPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workspaceId,  String projectId,  String userId,  List<ProjectTaskStatus> collapsedColumns,  KanbanQuickFilter quickFilter,  DateTime? updatedAtUtc,  int version,  List<String> collapsedCustomStatusIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserKanbanPreferenceResponse() when $default != null:
return $default(_that.workspaceId,_that.projectId,_that.userId,_that.collapsedColumns,_that.quickFilter,_that.updatedAtUtc,_that.version,_that.collapsedCustomStatusIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workspaceId,  String projectId,  String userId,  List<ProjectTaskStatus> collapsedColumns,  KanbanQuickFilter quickFilter,  DateTime? updatedAtUtc,  int version,  List<String> collapsedCustomStatusIds)  $default,) {final _that = this;
switch (_that) {
case _UserKanbanPreferenceResponse():
return $default(_that.workspaceId,_that.projectId,_that.userId,_that.collapsedColumns,_that.quickFilter,_that.updatedAtUtc,_that.version,_that.collapsedCustomStatusIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workspaceId,  String projectId,  String userId,  List<ProjectTaskStatus> collapsedColumns,  KanbanQuickFilter quickFilter,  DateTime? updatedAtUtc,  int version,  List<String> collapsedCustomStatusIds)?  $default,) {final _that = this;
switch (_that) {
case _UserKanbanPreferenceResponse() when $default != null:
return $default(_that.workspaceId,_that.projectId,_that.userId,_that.collapsedColumns,_that.quickFilter,_that.updatedAtUtc,_that.version,_that.collapsedCustomStatusIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserKanbanPreferenceResponse implements UserKanbanPreferenceResponse {
  const _UserKanbanPreferenceResponse({required this.workspaceId, required this.projectId, required this.userId, required this.collapsedColumns, required this.quickFilter, this.updatedAtUtc, required this.version, required this.collapsedCustomStatusIds});
  factory _UserKanbanPreferenceResponse.fromJson(Map<String, dynamic> json) => _$UserKanbanPreferenceResponseFromJson(json);

@override final  String workspaceId;
@override final  String projectId;
@override final  String userId;
@override final  List<ProjectTaskStatus> collapsedColumns;
@override final  KanbanQuickFilter quickFilter;
@override final  DateTime? updatedAtUtc;
@override final  int version;
@override final  List<String> collapsedCustomStatusIds;

/// Create a copy of UserKanbanPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserKanbanPreferenceResponseCopyWith<_UserKanbanPreferenceResponse> get copyWith => __$UserKanbanPreferenceResponseCopyWithImpl<_UserKanbanPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserKanbanPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserKanbanPreferenceResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.collapsedColumns, collapsedColumns)&&(identical(other.quickFilter, quickFilter) || other.quickFilter == quickFilter)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.collapsedCustomStatusIds, collapsedCustomStatusIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,projectId,userId,const DeepCollectionEquality().hash(collapsedColumns),quickFilter,updatedAtUtc,version,const DeepCollectionEquality().hash(collapsedCustomStatusIds));

@override
String toString() {
  return 'UserKanbanPreferenceResponse(workspaceId: $workspaceId, projectId: $projectId, userId: $userId, collapsedColumns: $collapsedColumns, quickFilter: $quickFilter, updatedAtUtc: $updatedAtUtc, version: $version, collapsedCustomStatusIds: $collapsedCustomStatusIds)';
}


}

/// @nodoc
abstract mixin class _$UserKanbanPreferenceResponseCopyWith<$Res> implements $UserKanbanPreferenceResponseCopyWith<$Res> {
  factory _$UserKanbanPreferenceResponseCopyWith(_UserKanbanPreferenceResponse value, $Res Function(_UserKanbanPreferenceResponse) _then) = __$UserKanbanPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String workspaceId, String projectId, String userId, List<ProjectTaskStatus> collapsedColumns, KanbanQuickFilter quickFilter, DateTime? updatedAtUtc, int version, List<String> collapsedCustomStatusIds
});




}
/// @nodoc
class __$UserKanbanPreferenceResponseCopyWithImpl<$Res>
    implements _$UserKanbanPreferenceResponseCopyWith<$Res> {
  __$UserKanbanPreferenceResponseCopyWithImpl(this._self, this._then);

  final _UserKanbanPreferenceResponse _self;
  final $Res Function(_UserKanbanPreferenceResponse) _then;

/// Create a copy of UserKanbanPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workspaceId = null,Object? projectId = null,Object? userId = null,Object? collapsedColumns = null,Object? quickFilter = null,Object? updatedAtUtc = freezed,Object? version = null,Object? collapsedCustomStatusIds = null,}) {
  return _then(_UserKanbanPreferenceResponse(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,collapsedColumns: null == collapsedColumns ? _self.collapsedColumns : collapsedColumns // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>,quickFilter: null == quickFilter ? _self.quickFilter : quickFilter // ignore: cast_nullable_to_non_nullable
as KanbanQuickFilter,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,collapsedCustomStatusIds: null == collapsedCustomStatusIds ? _self.collapsedCustomStatusIds : collapsedCustomStatusIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
