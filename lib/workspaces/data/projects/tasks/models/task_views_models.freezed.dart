// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_views_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskSavedViewFilter {

 List<ProjectTaskStatus>? get statuses; List<TaskPriority>? get priorities; List<String>? get assigneeUserIds; List<String>? get labelIds; String? get parentTaskId; TaskInvolvementFilter? get myInvolvement; DateTime? get dueFromUtc; DateTime? get dueToUtc; String? get search; bool get includeArchived; bool get pinnedOnly;
/// Create a copy of TaskSavedViewFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSavedViewFilterCopyWith<TaskSavedViewFilter> get copyWith => _$TaskSavedViewFilterCopyWithImpl<TaskSavedViewFilter>(this as TaskSavedViewFilter, _$identity);

  /// Serializes this TaskSavedViewFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSavedViewFilter&&const DeepCollectionEquality().equals(other.statuses, statuses)&&const DeepCollectionEquality().equals(other.priorities, priorities)&&const DeepCollectionEquality().equals(other.assigneeUserIds, assigneeUserIds)&&const DeepCollectionEquality().equals(other.labelIds, labelIds)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.myInvolvement, myInvolvement) || other.myInvolvement == myInvolvement)&&(identical(other.dueFromUtc, dueFromUtc) || other.dueFromUtc == dueFromUtc)&&(identical(other.dueToUtc, dueToUtc) || other.dueToUtc == dueToUtc)&&(identical(other.search, search) || other.search == search)&&(identical(other.includeArchived, includeArchived) || other.includeArchived == includeArchived)&&(identical(other.pinnedOnly, pinnedOnly) || other.pinnedOnly == pinnedOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(statuses),const DeepCollectionEquality().hash(priorities),const DeepCollectionEquality().hash(assigneeUserIds),const DeepCollectionEquality().hash(labelIds),parentTaskId,myInvolvement,dueFromUtc,dueToUtc,search,includeArchived,pinnedOnly);

@override
String toString() {
  return 'TaskSavedViewFilter(statuses: $statuses, priorities: $priorities, assigneeUserIds: $assigneeUserIds, labelIds: $labelIds, parentTaskId: $parentTaskId, myInvolvement: $myInvolvement, dueFromUtc: $dueFromUtc, dueToUtc: $dueToUtc, search: $search, includeArchived: $includeArchived, pinnedOnly: $pinnedOnly)';
}


}

/// @nodoc
abstract mixin class $TaskSavedViewFilterCopyWith<$Res>  {
  factory $TaskSavedViewFilterCopyWith(TaskSavedViewFilter value, $Res Function(TaskSavedViewFilter) _then) = _$TaskSavedViewFilterCopyWithImpl;
@useResult
$Res call({
 List<ProjectTaskStatus>? statuses, List<TaskPriority>? priorities, List<String>? assigneeUserIds, List<String>? labelIds, String? parentTaskId, TaskInvolvementFilter? myInvolvement, DateTime? dueFromUtc, DateTime? dueToUtc, String? search, bool includeArchived, bool pinnedOnly
});




}
/// @nodoc
class _$TaskSavedViewFilterCopyWithImpl<$Res>
    implements $TaskSavedViewFilterCopyWith<$Res> {
  _$TaskSavedViewFilterCopyWithImpl(this._self, this._then);

  final TaskSavedViewFilter _self;
  final $Res Function(TaskSavedViewFilter) _then;

/// Create a copy of TaskSavedViewFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statuses = freezed,Object? priorities = freezed,Object? assigneeUserIds = freezed,Object? labelIds = freezed,Object? parentTaskId = freezed,Object? myInvolvement = freezed,Object? dueFromUtc = freezed,Object? dueToUtc = freezed,Object? search = freezed,Object? includeArchived = null,Object? pinnedOnly = null,}) {
  return _then(_self.copyWith(
statuses: freezed == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>?,priorities: freezed == priorities ? _self.priorities : priorities // ignore: cast_nullable_to_non_nullable
as List<TaskPriority>?,assigneeUserIds: freezed == assigneeUserIds ? _self.assigneeUserIds : assigneeUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,labelIds: freezed == labelIds ? _self.labelIds : labelIds // ignore: cast_nullable_to_non_nullable
as List<String>?,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,myInvolvement: freezed == myInvolvement ? _self.myInvolvement : myInvolvement // ignore: cast_nullable_to_non_nullable
as TaskInvolvementFilter?,dueFromUtc: freezed == dueFromUtc ? _self.dueFromUtc : dueFromUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueToUtc: freezed == dueToUtc ? _self.dueToUtc : dueToUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,includeArchived: null == includeArchived ? _self.includeArchived : includeArchived // ignore: cast_nullable_to_non_nullable
as bool,pinnedOnly: null == pinnedOnly ? _self.pinnedOnly : pinnedOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskSavedViewFilter].
extension TaskSavedViewFilterPatterns on TaskSavedViewFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSavedViewFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSavedViewFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSavedViewFilter value)  $default,){
final _that = this;
switch (_that) {
case _TaskSavedViewFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSavedViewFilter value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSavedViewFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProjectTaskStatus>? statuses,  List<TaskPriority>? priorities,  List<String>? assigneeUserIds,  List<String>? labelIds,  String? parentTaskId,  TaskInvolvementFilter? myInvolvement,  DateTime? dueFromUtc,  DateTime? dueToUtc,  String? search,  bool includeArchived,  bool pinnedOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSavedViewFilter() when $default != null:
return $default(_that.statuses,_that.priorities,_that.assigneeUserIds,_that.labelIds,_that.parentTaskId,_that.myInvolvement,_that.dueFromUtc,_that.dueToUtc,_that.search,_that.includeArchived,_that.pinnedOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProjectTaskStatus>? statuses,  List<TaskPriority>? priorities,  List<String>? assigneeUserIds,  List<String>? labelIds,  String? parentTaskId,  TaskInvolvementFilter? myInvolvement,  DateTime? dueFromUtc,  DateTime? dueToUtc,  String? search,  bool includeArchived,  bool pinnedOnly)  $default,) {final _that = this;
switch (_that) {
case _TaskSavedViewFilter():
return $default(_that.statuses,_that.priorities,_that.assigneeUserIds,_that.labelIds,_that.parentTaskId,_that.myInvolvement,_that.dueFromUtc,_that.dueToUtc,_that.search,_that.includeArchived,_that.pinnedOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProjectTaskStatus>? statuses,  List<TaskPriority>? priorities,  List<String>? assigneeUserIds,  List<String>? labelIds,  String? parentTaskId,  TaskInvolvementFilter? myInvolvement,  DateTime? dueFromUtc,  DateTime? dueToUtc,  String? search,  bool includeArchived,  bool pinnedOnly)?  $default,) {final _that = this;
switch (_that) {
case _TaskSavedViewFilter() when $default != null:
return $default(_that.statuses,_that.priorities,_that.assigneeUserIds,_that.labelIds,_that.parentTaskId,_that.myInvolvement,_that.dueFromUtc,_that.dueToUtc,_that.search,_that.includeArchived,_that.pinnedOnly);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSavedViewFilter implements TaskSavedViewFilter {
  const _TaskSavedViewFilter({this.statuses, this.priorities, this.assigneeUserIds, this.labelIds, this.parentTaskId, this.myInvolvement, this.dueFromUtc, this.dueToUtc, this.search, this.includeArchived = false, this.pinnedOnly = false});
  factory _TaskSavedViewFilter.fromJson(Map<String, dynamic> json) => _$TaskSavedViewFilterFromJson(json);

@override final  List<ProjectTaskStatus>? statuses;
@override final  List<TaskPriority>? priorities;
@override final  List<String>? assigneeUserIds;
@override final  List<String>? labelIds;
@override final  String? parentTaskId;
@override final  TaskInvolvementFilter? myInvolvement;
@override final  DateTime? dueFromUtc;
@override final  DateTime? dueToUtc;
@override final  String? search;
@override@JsonKey() final  bool includeArchived;
@override@JsonKey() final  bool pinnedOnly;

/// Create a copy of TaskSavedViewFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSavedViewFilterCopyWith<_TaskSavedViewFilter> get copyWith => __$TaskSavedViewFilterCopyWithImpl<_TaskSavedViewFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSavedViewFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSavedViewFilter&&const DeepCollectionEquality().equals(other.statuses, statuses)&&const DeepCollectionEquality().equals(other.priorities, priorities)&&const DeepCollectionEquality().equals(other.assigneeUserIds, assigneeUserIds)&&const DeepCollectionEquality().equals(other.labelIds, labelIds)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.myInvolvement, myInvolvement) || other.myInvolvement == myInvolvement)&&(identical(other.dueFromUtc, dueFromUtc) || other.dueFromUtc == dueFromUtc)&&(identical(other.dueToUtc, dueToUtc) || other.dueToUtc == dueToUtc)&&(identical(other.search, search) || other.search == search)&&(identical(other.includeArchived, includeArchived) || other.includeArchived == includeArchived)&&(identical(other.pinnedOnly, pinnedOnly) || other.pinnedOnly == pinnedOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(statuses),const DeepCollectionEquality().hash(priorities),const DeepCollectionEquality().hash(assigneeUserIds),const DeepCollectionEquality().hash(labelIds),parentTaskId,myInvolvement,dueFromUtc,dueToUtc,search,includeArchived,pinnedOnly);

@override
String toString() {
  return 'TaskSavedViewFilter(statuses: $statuses, priorities: $priorities, assigneeUserIds: $assigneeUserIds, labelIds: $labelIds, parentTaskId: $parentTaskId, myInvolvement: $myInvolvement, dueFromUtc: $dueFromUtc, dueToUtc: $dueToUtc, search: $search, includeArchived: $includeArchived, pinnedOnly: $pinnedOnly)';
}


}

/// @nodoc
abstract mixin class _$TaskSavedViewFilterCopyWith<$Res> implements $TaskSavedViewFilterCopyWith<$Res> {
  factory _$TaskSavedViewFilterCopyWith(_TaskSavedViewFilter value, $Res Function(_TaskSavedViewFilter) _then) = __$TaskSavedViewFilterCopyWithImpl;
@override @useResult
$Res call({
 List<ProjectTaskStatus>? statuses, List<TaskPriority>? priorities, List<String>? assigneeUserIds, List<String>? labelIds, String? parentTaskId, TaskInvolvementFilter? myInvolvement, DateTime? dueFromUtc, DateTime? dueToUtc, String? search, bool includeArchived, bool pinnedOnly
});




}
/// @nodoc
class __$TaskSavedViewFilterCopyWithImpl<$Res>
    implements _$TaskSavedViewFilterCopyWith<$Res> {
  __$TaskSavedViewFilterCopyWithImpl(this._self, this._then);

  final _TaskSavedViewFilter _self;
  final $Res Function(_TaskSavedViewFilter) _then;

/// Create a copy of TaskSavedViewFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statuses = freezed,Object? priorities = freezed,Object? assigneeUserIds = freezed,Object? labelIds = freezed,Object? parentTaskId = freezed,Object? myInvolvement = freezed,Object? dueFromUtc = freezed,Object? dueToUtc = freezed,Object? search = freezed,Object? includeArchived = null,Object? pinnedOnly = null,}) {
  return _then(_TaskSavedViewFilter(
statuses: freezed == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskStatus>?,priorities: freezed == priorities ? _self.priorities : priorities // ignore: cast_nullable_to_non_nullable
as List<TaskPriority>?,assigneeUserIds: freezed == assigneeUserIds ? _self.assigneeUserIds : assigneeUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,labelIds: freezed == labelIds ? _self.labelIds : labelIds // ignore: cast_nullable_to_non_nullable
as List<String>?,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,myInvolvement: freezed == myInvolvement ? _self.myInvolvement : myInvolvement // ignore: cast_nullable_to_non_nullable
as TaskInvolvementFilter?,dueFromUtc: freezed == dueFromUtc ? _self.dueFromUtc : dueFromUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueToUtc: freezed == dueToUtc ? _self.dueToUtc : dueToUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,includeArchived: null == includeArchived ? _self.includeArchived : includeArchived // ignore: cast_nullable_to_non_nullable
as bool,pinnedOnly: null == pinnedOnly ? _self.pinnedOnly : pinnedOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TaskSavedViewDefinition {

 TaskSavedViewFilter get filter; TaskSavedViewSortField get sortField; TaskSavedViewSortDirection get sortDirection; TaskSavedViewGroupBy get groupBy; List<TaskSavedViewColumn> get columns; List<String> get customFieldIds; List<String>? get columnOrder;
/// Create a copy of TaskSavedViewDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSavedViewDefinitionCopyWith<TaskSavedViewDefinition> get copyWith => _$TaskSavedViewDefinitionCopyWithImpl<TaskSavedViewDefinition>(this as TaskSavedViewDefinition, _$identity);

  /// Serializes this TaskSavedViewDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSavedViewDefinition&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.sortField, sortField) || other.sortField == sortField)&&(identical(other.sortDirection, sortDirection) || other.sortDirection == sortDirection)&&(identical(other.groupBy, groupBy) || other.groupBy == groupBy)&&const DeepCollectionEquality().equals(other.columns, columns)&&const DeepCollectionEquality().equals(other.customFieldIds, customFieldIds)&&const DeepCollectionEquality().equals(other.columnOrder, columnOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filter,sortField,sortDirection,groupBy,const DeepCollectionEquality().hash(columns),const DeepCollectionEquality().hash(customFieldIds),const DeepCollectionEquality().hash(columnOrder));

@override
String toString() {
  return 'TaskSavedViewDefinition(filter: $filter, sortField: $sortField, sortDirection: $sortDirection, groupBy: $groupBy, columns: $columns, customFieldIds: $customFieldIds, columnOrder: $columnOrder)';
}


}

/// @nodoc
abstract mixin class $TaskSavedViewDefinitionCopyWith<$Res>  {
  factory $TaskSavedViewDefinitionCopyWith(TaskSavedViewDefinition value, $Res Function(TaskSavedViewDefinition) _then) = _$TaskSavedViewDefinitionCopyWithImpl;
@useResult
$Res call({
 TaskSavedViewFilter filter, TaskSavedViewSortField sortField, TaskSavedViewSortDirection sortDirection, TaskSavedViewGroupBy groupBy, List<TaskSavedViewColumn> columns, List<String> customFieldIds, List<String>? columnOrder
});


$TaskSavedViewFilterCopyWith<$Res> get filter;

}
/// @nodoc
class _$TaskSavedViewDefinitionCopyWithImpl<$Res>
    implements $TaskSavedViewDefinitionCopyWith<$Res> {
  _$TaskSavedViewDefinitionCopyWithImpl(this._self, this._then);

  final TaskSavedViewDefinition _self;
  final $Res Function(TaskSavedViewDefinition) _then;

/// Create a copy of TaskSavedViewDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filter = null,Object? sortField = null,Object? sortDirection = null,Object? groupBy = null,Object? columns = null,Object? customFieldIds = null,Object? columnOrder = freezed,}) {
  return _then(_self.copyWith(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TaskSavedViewFilter,sortField: null == sortField ? _self.sortField : sortField // ignore: cast_nullable_to_non_nullable
as TaskSavedViewSortField,sortDirection: null == sortDirection ? _self.sortDirection : sortDirection // ignore: cast_nullable_to_non_nullable
as TaskSavedViewSortDirection,groupBy: null == groupBy ? _self.groupBy : groupBy // ignore: cast_nullable_to_non_nullable
as TaskSavedViewGroupBy,columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<TaskSavedViewColumn>,customFieldIds: null == customFieldIds ? _self.customFieldIds : customFieldIds // ignore: cast_nullable_to_non_nullable
as List<String>,columnOrder: freezed == columnOrder ? _self.columnOrder : columnOrder // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}
/// Create a copy of TaskSavedViewDefinition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSavedViewFilterCopyWith<$Res> get filter {
  
  return $TaskSavedViewFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskSavedViewDefinition].
extension TaskSavedViewDefinitionPatterns on TaskSavedViewDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSavedViewDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSavedViewDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSavedViewDefinition value)  $default,){
final _that = this;
switch (_that) {
case _TaskSavedViewDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSavedViewDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSavedViewDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskSavedViewFilter filter,  TaskSavedViewSortField sortField,  TaskSavedViewSortDirection sortDirection,  TaskSavedViewGroupBy groupBy,  List<TaskSavedViewColumn> columns,  List<String> customFieldIds,  List<String>? columnOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSavedViewDefinition() when $default != null:
return $default(_that.filter,_that.sortField,_that.sortDirection,_that.groupBy,_that.columns,_that.customFieldIds,_that.columnOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskSavedViewFilter filter,  TaskSavedViewSortField sortField,  TaskSavedViewSortDirection sortDirection,  TaskSavedViewGroupBy groupBy,  List<TaskSavedViewColumn> columns,  List<String> customFieldIds,  List<String>? columnOrder)  $default,) {final _that = this;
switch (_that) {
case _TaskSavedViewDefinition():
return $default(_that.filter,_that.sortField,_that.sortDirection,_that.groupBy,_that.columns,_that.customFieldIds,_that.columnOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskSavedViewFilter filter,  TaskSavedViewSortField sortField,  TaskSavedViewSortDirection sortDirection,  TaskSavedViewGroupBy groupBy,  List<TaskSavedViewColumn> columns,  List<String> customFieldIds,  List<String>? columnOrder)?  $default,) {final _that = this;
switch (_that) {
case _TaskSavedViewDefinition() when $default != null:
return $default(_that.filter,_that.sortField,_that.sortDirection,_that.groupBy,_that.columns,_that.customFieldIds,_that.columnOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSavedViewDefinition implements TaskSavedViewDefinition {
  const _TaskSavedViewDefinition({required this.filter, required this.sortField, required this.sortDirection, required this.groupBy, required this.columns, this.customFieldIds = const [], this.columnOrder});
  factory _TaskSavedViewDefinition.fromJson(Map<String, dynamic> json) => _$TaskSavedViewDefinitionFromJson(json);

@override final  TaskSavedViewFilter filter;
@override final  TaskSavedViewSortField sortField;
@override final  TaskSavedViewSortDirection sortDirection;
@override final  TaskSavedViewGroupBy groupBy;
@override final  List<TaskSavedViewColumn> columns;
@override@JsonKey() final  List<String> customFieldIds;
@override final  List<String>? columnOrder;

/// Create a copy of TaskSavedViewDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSavedViewDefinitionCopyWith<_TaskSavedViewDefinition> get copyWith => __$TaskSavedViewDefinitionCopyWithImpl<_TaskSavedViewDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSavedViewDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSavedViewDefinition&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.sortField, sortField) || other.sortField == sortField)&&(identical(other.sortDirection, sortDirection) || other.sortDirection == sortDirection)&&(identical(other.groupBy, groupBy) || other.groupBy == groupBy)&&const DeepCollectionEquality().equals(other.columns, columns)&&const DeepCollectionEquality().equals(other.customFieldIds, customFieldIds)&&const DeepCollectionEquality().equals(other.columnOrder, columnOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filter,sortField,sortDirection,groupBy,const DeepCollectionEquality().hash(columns),const DeepCollectionEquality().hash(customFieldIds),const DeepCollectionEquality().hash(columnOrder));

@override
String toString() {
  return 'TaskSavedViewDefinition(filter: $filter, sortField: $sortField, sortDirection: $sortDirection, groupBy: $groupBy, columns: $columns, customFieldIds: $customFieldIds, columnOrder: $columnOrder)';
}


}

/// @nodoc
abstract mixin class _$TaskSavedViewDefinitionCopyWith<$Res> implements $TaskSavedViewDefinitionCopyWith<$Res> {
  factory _$TaskSavedViewDefinitionCopyWith(_TaskSavedViewDefinition value, $Res Function(_TaskSavedViewDefinition) _then) = __$TaskSavedViewDefinitionCopyWithImpl;
@override @useResult
$Res call({
 TaskSavedViewFilter filter, TaskSavedViewSortField sortField, TaskSavedViewSortDirection sortDirection, TaskSavedViewGroupBy groupBy, List<TaskSavedViewColumn> columns, List<String> customFieldIds, List<String>? columnOrder
});


@override $TaskSavedViewFilterCopyWith<$Res> get filter;

}
/// @nodoc
class __$TaskSavedViewDefinitionCopyWithImpl<$Res>
    implements _$TaskSavedViewDefinitionCopyWith<$Res> {
  __$TaskSavedViewDefinitionCopyWithImpl(this._self, this._then);

  final _TaskSavedViewDefinition _self;
  final $Res Function(_TaskSavedViewDefinition) _then;

/// Create a copy of TaskSavedViewDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filter = null,Object? sortField = null,Object? sortDirection = null,Object? groupBy = null,Object? columns = null,Object? customFieldIds = null,Object? columnOrder = freezed,}) {
  return _then(_TaskSavedViewDefinition(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TaskSavedViewFilter,sortField: null == sortField ? _self.sortField : sortField // ignore: cast_nullable_to_non_nullable
as TaskSavedViewSortField,sortDirection: null == sortDirection ? _self.sortDirection : sortDirection // ignore: cast_nullable_to_non_nullable
as TaskSavedViewSortDirection,groupBy: null == groupBy ? _self.groupBy : groupBy // ignore: cast_nullable_to_non_nullable
as TaskSavedViewGroupBy,columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<TaskSavedViewColumn>,customFieldIds: null == customFieldIds ? _self.customFieldIds : customFieldIds // ignore: cast_nullable_to_non_nullable
as List<String>,columnOrder: freezed == columnOrder ? _self.columnOrder : columnOrder // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

/// Create a copy of TaskSavedViewDefinition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSavedViewFilterCopyWith<$Res> get filter {
  
  return $TaskSavedViewFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}


/// @nodoc
mixin _$CreateTaskSavedViewPayload {

 String get name; TaskSavedViewDefinition get view;
/// Create a copy of CreateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskSavedViewPayloadCopyWith<CreateTaskSavedViewPayload> get copyWith => _$CreateTaskSavedViewPayloadCopyWithImpl<CreateTaskSavedViewPayload>(this as CreateTaskSavedViewPayload, _$identity);

  /// Serializes this CreateTaskSavedViewPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskSavedViewPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.view, view) || other.view == view));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,view);

@override
String toString() {
  return 'CreateTaskSavedViewPayload(name: $name, view: $view)';
}


}

/// @nodoc
abstract mixin class $CreateTaskSavedViewPayloadCopyWith<$Res>  {
  factory $CreateTaskSavedViewPayloadCopyWith(CreateTaskSavedViewPayload value, $Res Function(CreateTaskSavedViewPayload) _then) = _$CreateTaskSavedViewPayloadCopyWithImpl;
@useResult
$Res call({
 String name, TaskSavedViewDefinition view
});


$TaskSavedViewDefinitionCopyWith<$Res> get view;

}
/// @nodoc
class _$CreateTaskSavedViewPayloadCopyWithImpl<$Res>
    implements $CreateTaskSavedViewPayloadCopyWith<$Res> {
  _$CreateTaskSavedViewPayloadCopyWithImpl(this._self, this._then);

  final CreateTaskSavedViewPayload _self;
  final $Res Function(CreateTaskSavedViewPayload) _then;

/// Create a copy of CreateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? view = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as TaskSavedViewDefinition,
  ));
}
/// Create a copy of CreateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSavedViewDefinitionCopyWith<$Res> get view {
  
  return $TaskSavedViewDefinitionCopyWith<$Res>(_self.view, (value) {
    return _then(_self.copyWith(view: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateTaskSavedViewPayload].
extension CreateTaskSavedViewPayloadPatterns on CreateTaskSavedViewPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskSavedViewPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskSavedViewPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskSavedViewPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskSavedViewPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskSavedViewPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskSavedViewPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  TaskSavedViewDefinition view)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskSavedViewPayload() when $default != null:
return $default(_that.name,_that.view);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  TaskSavedViewDefinition view)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskSavedViewPayload():
return $default(_that.name,_that.view);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  TaskSavedViewDefinition view)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskSavedViewPayload() when $default != null:
return $default(_that.name,_that.view);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskSavedViewPayload implements CreateTaskSavedViewPayload {
  const _CreateTaskSavedViewPayload({required this.name, required this.view});
  factory _CreateTaskSavedViewPayload.fromJson(Map<String, dynamic> json) => _$CreateTaskSavedViewPayloadFromJson(json);

@override final  String name;
@override final  TaskSavedViewDefinition view;

/// Create a copy of CreateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskSavedViewPayloadCopyWith<_CreateTaskSavedViewPayload> get copyWith => __$CreateTaskSavedViewPayloadCopyWithImpl<_CreateTaskSavedViewPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskSavedViewPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskSavedViewPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.view, view) || other.view == view));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,view);

@override
String toString() {
  return 'CreateTaskSavedViewPayload(name: $name, view: $view)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskSavedViewPayloadCopyWith<$Res> implements $CreateTaskSavedViewPayloadCopyWith<$Res> {
  factory _$CreateTaskSavedViewPayloadCopyWith(_CreateTaskSavedViewPayload value, $Res Function(_CreateTaskSavedViewPayload) _then) = __$CreateTaskSavedViewPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, TaskSavedViewDefinition view
});


@override $TaskSavedViewDefinitionCopyWith<$Res> get view;

}
/// @nodoc
class __$CreateTaskSavedViewPayloadCopyWithImpl<$Res>
    implements _$CreateTaskSavedViewPayloadCopyWith<$Res> {
  __$CreateTaskSavedViewPayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskSavedViewPayload _self;
  final $Res Function(_CreateTaskSavedViewPayload) _then;

/// Create a copy of CreateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? view = null,}) {
  return _then(_CreateTaskSavedViewPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as TaskSavedViewDefinition,
  ));
}

/// Create a copy of CreateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSavedViewDefinitionCopyWith<$Res> get view {
  
  return $TaskSavedViewDefinitionCopyWith<$Res>(_self.view, (value) {
    return _then(_self.copyWith(view: value));
  });
}
}


/// @nodoc
mixin _$UpdateTaskSavedViewPayload {

 String get name; TaskSavedViewDefinition get view; int? get expectedVersion;
/// Create a copy of UpdateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskSavedViewPayloadCopyWith<UpdateTaskSavedViewPayload> get copyWith => _$UpdateTaskSavedViewPayloadCopyWithImpl<UpdateTaskSavedViewPayload>(this as UpdateTaskSavedViewPayload, _$identity);

  /// Serializes this UpdateTaskSavedViewPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskSavedViewPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.view, view) || other.view == view)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,view,expectedVersion);

@override
String toString() {
  return 'UpdateTaskSavedViewPayload(name: $name, view: $view, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskSavedViewPayloadCopyWith<$Res>  {
  factory $UpdateTaskSavedViewPayloadCopyWith(UpdateTaskSavedViewPayload value, $Res Function(UpdateTaskSavedViewPayload) _then) = _$UpdateTaskSavedViewPayloadCopyWithImpl;
@useResult
$Res call({
 String name, TaskSavedViewDefinition view, int? expectedVersion
});


$TaskSavedViewDefinitionCopyWith<$Res> get view;

}
/// @nodoc
class _$UpdateTaskSavedViewPayloadCopyWithImpl<$Res>
    implements $UpdateTaskSavedViewPayloadCopyWith<$Res> {
  _$UpdateTaskSavedViewPayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskSavedViewPayload _self;
  final $Res Function(UpdateTaskSavedViewPayload) _then;

/// Create a copy of UpdateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? view = null,Object? expectedVersion = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as TaskSavedViewDefinition,expectedVersion: freezed == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of UpdateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSavedViewDefinitionCopyWith<$Res> get view {
  
  return $TaskSavedViewDefinitionCopyWith<$Res>(_self.view, (value) {
    return _then(_self.copyWith(view: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateTaskSavedViewPayload].
extension UpdateTaskSavedViewPayloadPatterns on UpdateTaskSavedViewPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskSavedViewPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskSavedViewPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskSavedViewPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskSavedViewPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskSavedViewPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskSavedViewPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  TaskSavedViewDefinition view,  int? expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskSavedViewPayload() when $default != null:
return $default(_that.name,_that.view,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  TaskSavedViewDefinition view,  int? expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskSavedViewPayload():
return $default(_that.name,_that.view,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  TaskSavedViewDefinition view,  int? expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskSavedViewPayload() when $default != null:
return $default(_that.name,_that.view,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskSavedViewPayload implements UpdateTaskSavedViewPayload {
  const _UpdateTaskSavedViewPayload({required this.name, required this.view, this.expectedVersion});
  factory _UpdateTaskSavedViewPayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskSavedViewPayloadFromJson(json);

@override final  String name;
@override final  TaskSavedViewDefinition view;
@override final  int? expectedVersion;

/// Create a copy of UpdateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskSavedViewPayloadCopyWith<_UpdateTaskSavedViewPayload> get copyWith => __$UpdateTaskSavedViewPayloadCopyWithImpl<_UpdateTaskSavedViewPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskSavedViewPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskSavedViewPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.view, view) || other.view == view)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,view,expectedVersion);

@override
String toString() {
  return 'UpdateTaskSavedViewPayload(name: $name, view: $view, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskSavedViewPayloadCopyWith<$Res> implements $UpdateTaskSavedViewPayloadCopyWith<$Res> {
  factory _$UpdateTaskSavedViewPayloadCopyWith(_UpdateTaskSavedViewPayload value, $Res Function(_UpdateTaskSavedViewPayload) _then) = __$UpdateTaskSavedViewPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, TaskSavedViewDefinition view, int? expectedVersion
});


@override $TaskSavedViewDefinitionCopyWith<$Res> get view;

}
/// @nodoc
class __$UpdateTaskSavedViewPayloadCopyWithImpl<$Res>
    implements _$UpdateTaskSavedViewPayloadCopyWith<$Res> {
  __$UpdateTaskSavedViewPayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskSavedViewPayload _self;
  final $Res Function(_UpdateTaskSavedViewPayload) _then;

/// Create a copy of UpdateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? view = null,Object? expectedVersion = freezed,}) {
  return _then(_UpdateTaskSavedViewPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as TaskSavedViewDefinition,expectedVersion: freezed == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of UpdateTaskSavedViewPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSavedViewDefinitionCopyWith<$Res> get view {
  
  return $TaskSavedViewDefinitionCopyWith<$Res>(_self.view, (value) {
    return _then(_self.copyWith(view: value));
  });
}
}


/// @nodoc
mixin _$TaskSavedViewResponse {

 String get id; String get name; TaskSavedViewDefinition get view; DateTime get createdAtUtc; DateTime get updatedAtUtc; int get version;
/// Create a copy of TaskSavedViewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSavedViewResponseCopyWith<TaskSavedViewResponse> get copyWith => _$TaskSavedViewResponseCopyWithImpl<TaskSavedViewResponse>(this as TaskSavedViewResponse, _$identity);

  /// Serializes this TaskSavedViewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSavedViewResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.view, view) || other.view == view)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,view,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'TaskSavedViewResponse(id: $id, name: $name, view: $view, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $TaskSavedViewResponseCopyWith<$Res>  {
  factory $TaskSavedViewResponseCopyWith(TaskSavedViewResponse value, $Res Function(TaskSavedViewResponse) _then) = _$TaskSavedViewResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, TaskSavedViewDefinition view, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});


$TaskSavedViewDefinitionCopyWith<$Res> get view;

}
/// @nodoc
class _$TaskSavedViewResponseCopyWithImpl<$Res>
    implements $TaskSavedViewResponseCopyWith<$Res> {
  _$TaskSavedViewResponseCopyWithImpl(this._self, this._then);

  final TaskSavedViewResponse _self;
  final $Res Function(TaskSavedViewResponse) _then;

/// Create a copy of TaskSavedViewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? view = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as TaskSavedViewDefinition,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TaskSavedViewResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSavedViewDefinitionCopyWith<$Res> get view {
  
  return $TaskSavedViewDefinitionCopyWith<$Res>(_self.view, (value) {
    return _then(_self.copyWith(view: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskSavedViewResponse].
extension TaskSavedViewResponsePatterns on TaskSavedViewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSavedViewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSavedViewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSavedViewResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskSavedViewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSavedViewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSavedViewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  TaskSavedViewDefinition view,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSavedViewResponse() when $default != null:
return $default(_that.id,_that.name,_that.view,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  TaskSavedViewDefinition view,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _TaskSavedViewResponse():
return $default(_that.id,_that.name,_that.view,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  TaskSavedViewDefinition view,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _TaskSavedViewResponse() when $default != null:
return $default(_that.id,_that.name,_that.view,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSavedViewResponse implements TaskSavedViewResponse {
  const _TaskSavedViewResponse({required this.id, required this.name, required this.view, required this.createdAtUtc, required this.updatedAtUtc, this.version = 1});
  factory _TaskSavedViewResponse.fromJson(Map<String, dynamic> json) => _$TaskSavedViewResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  TaskSavedViewDefinition view;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override@JsonKey() final  int version;

/// Create a copy of TaskSavedViewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSavedViewResponseCopyWith<_TaskSavedViewResponse> get copyWith => __$TaskSavedViewResponseCopyWithImpl<_TaskSavedViewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSavedViewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSavedViewResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.view, view) || other.view == view)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,view,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'TaskSavedViewResponse(id: $id, name: $name, view: $view, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$TaskSavedViewResponseCopyWith<$Res> implements $TaskSavedViewResponseCopyWith<$Res> {
  factory _$TaskSavedViewResponseCopyWith(_TaskSavedViewResponse value, $Res Function(_TaskSavedViewResponse) _then) = __$TaskSavedViewResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, TaskSavedViewDefinition view, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});


@override $TaskSavedViewDefinitionCopyWith<$Res> get view;

}
/// @nodoc
class __$TaskSavedViewResponseCopyWithImpl<$Res>
    implements _$TaskSavedViewResponseCopyWith<$Res> {
  __$TaskSavedViewResponseCopyWithImpl(this._self, this._then);

  final _TaskSavedViewResponse _self;
  final $Res Function(_TaskSavedViewResponse) _then;

/// Create a copy of TaskSavedViewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? view = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_TaskSavedViewResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as TaskSavedViewDefinition,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TaskSavedViewResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSavedViewDefinitionCopyWith<$Res> get view {
  
  return $TaskSavedViewDefinitionCopyWith<$Res>(_self.view, (value) {
    return _then(_self.copyWith(view: value));
  });
}
}


/// @nodoc
mixin _$MyTaskListItemResponse {

 String get id; int get number; String get key; String get workspaceId; String get workspaceName; String get projectId; String get projectName; String? get parentTaskId; String get title; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; TaskInvolvementFilter get involvement; int get checklistCompletedCount; int get checklistTotalCount; bool get isPinned; DateTime get updatedAtUtc; int get version;
/// Create a copy of MyTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyTaskListItemResponseCopyWith<MyTaskListItemResponse> get copyWith => _$MyTaskListItemResponseCopyWithImpl<MyTaskListItemResponse>(this as MyTaskListItemResponse, _$identity);

  /// Serializes this MyTaskListItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTaskListItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.workspaceName, workspaceName) || other.workspaceName == workspaceName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.involvement, involvement) || other.involvement == involvement)&&(identical(other.checklistCompletedCount, checklistCompletedCount) || other.checklistCompletedCount == checklistCompletedCount)&&(identical(other.checklistTotalCount, checklistTotalCount) || other.checklistTotalCount == checklistTotalCount)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,workspaceId,workspaceName,projectId,projectName,parentTaskId,title,status,priority,startAtUtc,dueAtUtc,involvement,checklistCompletedCount,checklistTotalCount,isPinned,updatedAtUtc,version]);

@override
String toString() {
  return 'MyTaskListItemResponse(id: $id, number: $number, key: $key, workspaceId: $workspaceId, workspaceName: $workspaceName, projectId: $projectId, projectName: $projectName, parentTaskId: $parentTaskId, title: $title, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, involvement: $involvement, checklistCompletedCount: $checklistCompletedCount, checklistTotalCount: $checklistTotalCount, isPinned: $isPinned, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $MyTaskListItemResponseCopyWith<$Res>  {
  factory $MyTaskListItemResponseCopyWith(MyTaskListItemResponse value, $Res Function(MyTaskListItemResponse) _then) = _$MyTaskListItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String workspaceId, String workspaceName, String projectId, String projectName, String? parentTaskId, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, TaskInvolvementFilter involvement, int checklistCompletedCount, int checklistTotalCount, bool isPinned, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$MyTaskListItemResponseCopyWithImpl<$Res>
    implements $MyTaskListItemResponseCopyWith<$Res> {
  _$MyTaskListItemResponseCopyWithImpl(this._self, this._then);

  final MyTaskListItemResponse _self;
  final $Res Function(MyTaskListItemResponse) _then;

/// Create a copy of MyTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? workspaceId = null,Object? workspaceName = null,Object? projectId = null,Object? projectName = null,Object? parentTaskId = freezed,Object? title = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? involvement = null,Object? checklistCompletedCount = null,Object? checklistTotalCount = null,Object? isPinned = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,workspaceName: null == workspaceName ? _self.workspaceName : workspaceName // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,involvement: null == involvement ? _self.involvement : involvement // ignore: cast_nullable_to_non_nullable
as TaskInvolvementFilter,checklistCompletedCount: null == checklistCompletedCount ? _self.checklistCompletedCount : checklistCompletedCount // ignore: cast_nullable_to_non_nullable
as int,checklistTotalCount: null == checklistTotalCount ? _self.checklistTotalCount : checklistTotalCount // ignore: cast_nullable_to_non_nullable
as int,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MyTaskListItemResponse].
extension MyTaskListItemResponsePatterns on MyTaskListItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyTaskListItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyTaskListItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyTaskListItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _MyTaskListItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyTaskListItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MyTaskListItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String workspaceId,  String workspaceName,  String projectId,  String projectName,  String? parentTaskId,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  TaskInvolvementFilter involvement,  int checklistCompletedCount,  int checklistTotalCount,  bool isPinned,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyTaskListItemResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.workspaceName,_that.projectId,_that.projectName,_that.parentTaskId,_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.involvement,_that.checklistCompletedCount,_that.checklistTotalCount,_that.isPinned,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String workspaceId,  String workspaceName,  String projectId,  String projectName,  String? parentTaskId,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  TaskInvolvementFilter involvement,  int checklistCompletedCount,  int checklistTotalCount,  bool isPinned,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _MyTaskListItemResponse():
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.workspaceName,_that.projectId,_that.projectName,_that.parentTaskId,_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.involvement,_that.checklistCompletedCount,_that.checklistTotalCount,_that.isPinned,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String workspaceId,  String workspaceName,  String projectId,  String projectName,  String? parentTaskId,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  TaskInvolvementFilter involvement,  int checklistCompletedCount,  int checklistTotalCount,  bool isPinned,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _MyTaskListItemResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.workspaceName,_that.projectId,_that.projectName,_that.parentTaskId,_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.involvement,_that.checklistCompletedCount,_that.checklistTotalCount,_that.isPinned,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyTaskListItemResponse implements MyTaskListItemResponse {
  const _MyTaskListItemResponse({required this.id, required this.number, required this.key, required this.workspaceId, required this.workspaceName, required this.projectId, required this.projectName, this.parentTaskId, required this.title, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, required this.involvement, required this.checklistCompletedCount, required this.checklistTotalCount, required this.isPinned, required this.updatedAtUtc, required this.version});
  factory _MyTaskListItemResponse.fromJson(Map<String, dynamic> json) => _$MyTaskListItemResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String key;
@override final  String workspaceId;
@override final  String workspaceName;
@override final  String projectId;
@override final  String projectName;
@override final  String? parentTaskId;
@override final  String title;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  TaskInvolvementFilter involvement;
@override final  int checklistCompletedCount;
@override final  int checklistTotalCount;
@override final  bool isPinned;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of MyTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyTaskListItemResponseCopyWith<_MyTaskListItemResponse> get copyWith => __$MyTaskListItemResponseCopyWithImpl<_MyTaskListItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyTaskListItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyTaskListItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.workspaceName, workspaceName) || other.workspaceName == workspaceName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.involvement, involvement) || other.involvement == involvement)&&(identical(other.checklistCompletedCount, checklistCompletedCount) || other.checklistCompletedCount == checklistCompletedCount)&&(identical(other.checklistTotalCount, checklistTotalCount) || other.checklistTotalCount == checklistTotalCount)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,workspaceId,workspaceName,projectId,projectName,parentTaskId,title,status,priority,startAtUtc,dueAtUtc,involvement,checklistCompletedCount,checklistTotalCount,isPinned,updatedAtUtc,version]);

@override
String toString() {
  return 'MyTaskListItemResponse(id: $id, number: $number, key: $key, workspaceId: $workspaceId, workspaceName: $workspaceName, projectId: $projectId, projectName: $projectName, parentTaskId: $parentTaskId, title: $title, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, involvement: $involvement, checklistCompletedCount: $checklistCompletedCount, checklistTotalCount: $checklistTotalCount, isPinned: $isPinned, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$MyTaskListItemResponseCopyWith<$Res> implements $MyTaskListItemResponseCopyWith<$Res> {
  factory _$MyTaskListItemResponseCopyWith(_MyTaskListItemResponse value, $Res Function(_MyTaskListItemResponse) _then) = __$MyTaskListItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String workspaceId, String workspaceName, String projectId, String projectName, String? parentTaskId, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, TaskInvolvementFilter involvement, int checklistCompletedCount, int checklistTotalCount, bool isPinned, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$MyTaskListItemResponseCopyWithImpl<$Res>
    implements _$MyTaskListItemResponseCopyWith<$Res> {
  __$MyTaskListItemResponseCopyWithImpl(this._self, this._then);

  final _MyTaskListItemResponse _self;
  final $Res Function(_MyTaskListItemResponse) _then;

/// Create a copy of MyTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? workspaceId = null,Object? workspaceName = null,Object? projectId = null,Object? projectName = null,Object? parentTaskId = freezed,Object? title = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? involvement = null,Object? checklistCompletedCount = null,Object? checklistTotalCount = null,Object? isPinned = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_MyTaskListItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,workspaceName: null == workspaceName ? _self.workspaceName : workspaceName // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,involvement: null == involvement ? _self.involvement : involvement // ignore: cast_nullable_to_non_nullable
as TaskInvolvementFilter,checklistCompletedCount: null == checklistCompletedCount ? _self.checklistCompletedCount : checklistCompletedCount // ignore: cast_nullable_to_non_nullable
as int,checklistTotalCount: null == checklistTotalCount ? _self.checklistTotalCount : checklistTotalCount // ignore: cast_nullable_to_non_nullable
as int,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GlobalTaskSearchItemResponse {

 String get id; int get number; String get key; String get workspaceId; String get workspaceName; String get projectId; String get projectName; String? get parentTaskId; String get title; String? get descriptionPreview; String? get titleHighlight; String? get descriptionHighlight; List<String> get matchedLabels; double get score; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; DateTime get updatedAtUtc; int get version;
/// Create a copy of GlobalTaskSearchItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalTaskSearchItemResponseCopyWith<GlobalTaskSearchItemResponse> get copyWith => _$GlobalTaskSearchItemResponseCopyWithImpl<GlobalTaskSearchItemResponse>(this as GlobalTaskSearchItemResponse, _$identity);

  /// Serializes this GlobalTaskSearchItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalTaskSearchItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.workspaceName, workspaceName) || other.workspaceName == workspaceName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.descriptionPreview, descriptionPreview) || other.descriptionPreview == descriptionPreview)&&(identical(other.titleHighlight, titleHighlight) || other.titleHighlight == titleHighlight)&&(identical(other.descriptionHighlight, descriptionHighlight) || other.descriptionHighlight == descriptionHighlight)&&const DeepCollectionEquality().equals(other.matchedLabels, matchedLabels)&&(identical(other.score, score) || other.score == score)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,workspaceId,workspaceName,projectId,projectName,parentTaskId,title,descriptionPreview,titleHighlight,descriptionHighlight,const DeepCollectionEquality().hash(matchedLabels),score,status,priority,startAtUtc,dueAtUtc,updatedAtUtc,version]);

@override
String toString() {
  return 'GlobalTaskSearchItemResponse(id: $id, number: $number, key: $key, workspaceId: $workspaceId, workspaceName: $workspaceName, projectId: $projectId, projectName: $projectName, parentTaskId: $parentTaskId, title: $title, descriptionPreview: $descriptionPreview, titleHighlight: $titleHighlight, descriptionHighlight: $descriptionHighlight, matchedLabels: $matchedLabels, score: $score, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $GlobalTaskSearchItemResponseCopyWith<$Res>  {
  factory $GlobalTaskSearchItemResponseCopyWith(GlobalTaskSearchItemResponse value, $Res Function(GlobalTaskSearchItemResponse) _then) = _$GlobalTaskSearchItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String workspaceId, String workspaceName, String projectId, String projectName, String? parentTaskId, String title, String? descriptionPreview, String? titleHighlight, String? descriptionHighlight, List<String> matchedLabels, double score, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$GlobalTaskSearchItemResponseCopyWithImpl<$Res>
    implements $GlobalTaskSearchItemResponseCopyWith<$Res> {
  _$GlobalTaskSearchItemResponseCopyWithImpl(this._self, this._then);

  final GlobalTaskSearchItemResponse _self;
  final $Res Function(GlobalTaskSearchItemResponse) _then;

/// Create a copy of GlobalTaskSearchItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? workspaceId = null,Object? workspaceName = null,Object? projectId = null,Object? projectName = null,Object? parentTaskId = freezed,Object? title = null,Object? descriptionPreview = freezed,Object? titleHighlight = freezed,Object? descriptionHighlight = freezed,Object? matchedLabels = null,Object? score = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,workspaceName: null == workspaceName ? _self.workspaceName : workspaceName // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,descriptionPreview: freezed == descriptionPreview ? _self.descriptionPreview : descriptionPreview // ignore: cast_nullable_to_non_nullable
as String?,titleHighlight: freezed == titleHighlight ? _self.titleHighlight : titleHighlight // ignore: cast_nullable_to_non_nullable
as String?,descriptionHighlight: freezed == descriptionHighlight ? _self.descriptionHighlight : descriptionHighlight // ignore: cast_nullable_to_non_nullable
as String?,matchedLabels: null == matchedLabels ? _self.matchedLabels : matchedLabels // ignore: cast_nullable_to_non_nullable
as List<String>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalTaskSearchItemResponse].
extension GlobalTaskSearchItemResponsePatterns on GlobalTaskSearchItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalTaskSearchItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalTaskSearchItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalTaskSearchItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _GlobalTaskSearchItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalTaskSearchItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalTaskSearchItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String workspaceId,  String workspaceName,  String projectId,  String projectName,  String? parentTaskId,  String title,  String? descriptionPreview,  String? titleHighlight,  String? descriptionHighlight,  List<String> matchedLabels,  double score,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalTaskSearchItemResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.workspaceName,_that.projectId,_that.projectName,_that.parentTaskId,_that.title,_that.descriptionPreview,_that.titleHighlight,_that.descriptionHighlight,_that.matchedLabels,_that.score,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String workspaceId,  String workspaceName,  String projectId,  String projectName,  String? parentTaskId,  String title,  String? descriptionPreview,  String? titleHighlight,  String? descriptionHighlight,  List<String> matchedLabels,  double score,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _GlobalTaskSearchItemResponse():
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.workspaceName,_that.projectId,_that.projectName,_that.parentTaskId,_that.title,_that.descriptionPreview,_that.titleHighlight,_that.descriptionHighlight,_that.matchedLabels,_that.score,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String workspaceId,  String workspaceName,  String projectId,  String projectName,  String? parentTaskId,  String title,  String? descriptionPreview,  String? titleHighlight,  String? descriptionHighlight,  List<String> matchedLabels,  double score,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _GlobalTaskSearchItemResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.workspaceId,_that.workspaceName,_that.projectId,_that.projectName,_that.parentTaskId,_that.title,_that.descriptionPreview,_that.titleHighlight,_that.descriptionHighlight,_that.matchedLabels,_that.score,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalTaskSearchItemResponse implements GlobalTaskSearchItemResponse {
  const _GlobalTaskSearchItemResponse({required this.id, required this.number, required this.key, required this.workspaceId, required this.workspaceName, required this.projectId, required this.projectName, this.parentTaskId, required this.title, this.descriptionPreview, this.titleHighlight, this.descriptionHighlight, required this.matchedLabels, required this.score, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, required this.updatedAtUtc, required this.version});
  factory _GlobalTaskSearchItemResponse.fromJson(Map<String, dynamic> json) => _$GlobalTaskSearchItemResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String key;
@override final  String workspaceId;
@override final  String workspaceName;
@override final  String projectId;
@override final  String projectName;
@override final  String? parentTaskId;
@override final  String title;
@override final  String? descriptionPreview;
@override final  String? titleHighlight;
@override final  String? descriptionHighlight;
@override final  List<String> matchedLabels;
@override final  double score;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of GlobalTaskSearchItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalTaskSearchItemResponseCopyWith<_GlobalTaskSearchItemResponse> get copyWith => __$GlobalTaskSearchItemResponseCopyWithImpl<_GlobalTaskSearchItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalTaskSearchItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalTaskSearchItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.workspaceName, workspaceName) || other.workspaceName == workspaceName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.descriptionPreview, descriptionPreview) || other.descriptionPreview == descriptionPreview)&&(identical(other.titleHighlight, titleHighlight) || other.titleHighlight == titleHighlight)&&(identical(other.descriptionHighlight, descriptionHighlight) || other.descriptionHighlight == descriptionHighlight)&&const DeepCollectionEquality().equals(other.matchedLabels, matchedLabels)&&(identical(other.score, score) || other.score == score)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,workspaceId,workspaceName,projectId,projectName,parentTaskId,title,descriptionPreview,titleHighlight,descriptionHighlight,const DeepCollectionEquality().hash(matchedLabels),score,status,priority,startAtUtc,dueAtUtc,updatedAtUtc,version]);

@override
String toString() {
  return 'GlobalTaskSearchItemResponse(id: $id, number: $number, key: $key, workspaceId: $workspaceId, workspaceName: $workspaceName, projectId: $projectId, projectName: $projectName, parentTaskId: $parentTaskId, title: $title, descriptionPreview: $descriptionPreview, titleHighlight: $titleHighlight, descriptionHighlight: $descriptionHighlight, matchedLabels: $matchedLabels, score: $score, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$GlobalTaskSearchItemResponseCopyWith<$Res> implements $GlobalTaskSearchItemResponseCopyWith<$Res> {
  factory _$GlobalTaskSearchItemResponseCopyWith(_GlobalTaskSearchItemResponse value, $Res Function(_GlobalTaskSearchItemResponse) _then) = __$GlobalTaskSearchItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String workspaceId, String workspaceName, String projectId, String projectName, String? parentTaskId, String title, String? descriptionPreview, String? titleHighlight, String? descriptionHighlight, List<String> matchedLabels, double score, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$GlobalTaskSearchItemResponseCopyWithImpl<$Res>
    implements _$GlobalTaskSearchItemResponseCopyWith<$Res> {
  __$GlobalTaskSearchItemResponseCopyWithImpl(this._self, this._then);

  final _GlobalTaskSearchItemResponse _self;
  final $Res Function(_GlobalTaskSearchItemResponse) _then;

/// Create a copy of GlobalTaskSearchItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? workspaceId = null,Object? workspaceName = null,Object? projectId = null,Object? projectName = null,Object? parentTaskId = freezed,Object? title = null,Object? descriptionPreview = freezed,Object? titleHighlight = freezed,Object? descriptionHighlight = freezed,Object? matchedLabels = null,Object? score = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_GlobalTaskSearchItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,workspaceName: null == workspaceName ? _self.workspaceName : workspaceName // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,descriptionPreview: freezed == descriptionPreview ? _self.descriptionPreview : descriptionPreview // ignore: cast_nullable_to_non_nullable
as String?,titleHighlight: freezed == titleHighlight ? _self.titleHighlight : titleHighlight // ignore: cast_nullable_to_non_nullable
as String?,descriptionHighlight: freezed == descriptionHighlight ? _self.descriptionHighlight : descriptionHighlight // ignore: cast_nullable_to_non_nullable
as String?,matchedLabels: null == matchedLabels ? _self.matchedLabels : matchedLabels // ignore: cast_nullable_to_non_nullable
as List<String>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
