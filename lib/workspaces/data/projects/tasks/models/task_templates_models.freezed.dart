// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_templates_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTaskTemplatePayload {

 String get name;
/// Create a copy of CreateTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskTemplatePayloadCopyWith<CreateTaskTemplatePayload> get copyWith => _$CreateTaskTemplatePayloadCopyWithImpl<CreateTaskTemplatePayload>(this as CreateTaskTemplatePayload, _$identity);

  /// Serializes this CreateTaskTemplatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskTemplatePayload&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CreateTaskTemplatePayload(name: $name)';
}


}

/// @nodoc
abstract mixin class $CreateTaskTemplatePayloadCopyWith<$Res>  {
  factory $CreateTaskTemplatePayloadCopyWith(CreateTaskTemplatePayload value, $Res Function(CreateTaskTemplatePayload) _then) = _$CreateTaskTemplatePayloadCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$CreateTaskTemplatePayloadCopyWithImpl<$Res>
    implements $CreateTaskTemplatePayloadCopyWith<$Res> {
  _$CreateTaskTemplatePayloadCopyWithImpl(this._self, this._then);

  final CreateTaskTemplatePayload _self;
  final $Res Function(CreateTaskTemplatePayload) _then;

/// Create a copy of CreateTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskTemplatePayload].
extension CreateTaskTemplatePayloadPatterns on CreateTaskTemplatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskTemplatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskTemplatePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskTemplatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskTemplatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskTemplatePayload() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskTemplatePayload():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskTemplatePayload() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskTemplatePayload implements CreateTaskTemplatePayload {
  const _CreateTaskTemplatePayload({required this.name});
  factory _CreateTaskTemplatePayload.fromJson(Map<String, dynamic> json) => _$CreateTaskTemplatePayloadFromJson(json);

@override final  String name;

/// Create a copy of CreateTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskTemplatePayloadCopyWith<_CreateTaskTemplatePayload> get copyWith => __$CreateTaskTemplatePayloadCopyWithImpl<_CreateTaskTemplatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskTemplatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskTemplatePayload&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CreateTaskTemplatePayload(name: $name)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskTemplatePayloadCopyWith<$Res> implements $CreateTaskTemplatePayloadCopyWith<$Res> {
  factory _$CreateTaskTemplatePayloadCopyWith(_CreateTaskTemplatePayload value, $Res Function(_CreateTaskTemplatePayload) _then) = __$CreateTaskTemplatePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$CreateTaskTemplatePayloadCopyWithImpl<$Res>
    implements _$CreateTaskTemplatePayloadCopyWith<$Res> {
  __$CreateTaskTemplatePayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskTemplatePayload _self;
  final $Res Function(_CreateTaskTemplatePayload) _then;

/// Create a copy of CreateTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_CreateTaskTemplatePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ApplyTaskTemplatePayload {

 String get projectId; String? get parentTaskId; String? get customStatusId; String? get titleOverride; ProjectTaskStatus? get targetStatus;
/// Create a copy of ApplyTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyTaskTemplatePayloadCopyWith<ApplyTaskTemplatePayload> get copyWith => _$ApplyTaskTemplatePayloadCopyWithImpl<ApplyTaskTemplatePayload>(this as ApplyTaskTemplatePayload, _$identity);

  /// Serializes this ApplyTaskTemplatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyTaskTemplatePayload&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.titleOverride, titleOverride) || other.titleOverride == titleOverride)&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,parentTaskId,customStatusId,titleOverride,targetStatus);

@override
String toString() {
  return 'ApplyTaskTemplatePayload(projectId: $projectId, parentTaskId: $parentTaskId, customStatusId: $customStatusId, titleOverride: $titleOverride, targetStatus: $targetStatus)';
}


}

/// @nodoc
abstract mixin class $ApplyTaskTemplatePayloadCopyWith<$Res>  {
  factory $ApplyTaskTemplatePayloadCopyWith(ApplyTaskTemplatePayload value, $Res Function(ApplyTaskTemplatePayload) _then) = _$ApplyTaskTemplatePayloadCopyWithImpl;
@useResult
$Res call({
 String projectId, String? parentTaskId, String? customStatusId, String? titleOverride, ProjectTaskStatus? targetStatus
});




}
/// @nodoc
class _$ApplyTaskTemplatePayloadCopyWithImpl<$Res>
    implements $ApplyTaskTemplatePayloadCopyWith<$Res> {
  _$ApplyTaskTemplatePayloadCopyWithImpl(this._self, this._then);

  final ApplyTaskTemplatePayload _self;
  final $Res Function(ApplyTaskTemplatePayload) _then;

/// Create a copy of ApplyTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? parentTaskId = freezed,Object? customStatusId = freezed,Object? titleOverride = freezed,Object? targetStatus = freezed,}) {
  return _then(_self.copyWith(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,titleOverride: freezed == titleOverride ? _self.titleOverride : titleOverride // ignore: cast_nullable_to_non_nullable
as String?,targetStatus: freezed == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplyTaskTemplatePayload].
extension ApplyTaskTemplatePayloadPatterns on ApplyTaskTemplatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplyTaskTemplatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplyTaskTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplyTaskTemplatePayload value)  $default,){
final _that = this;
switch (_that) {
case _ApplyTaskTemplatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplyTaskTemplatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ApplyTaskTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  String? parentTaskId,  String? customStatusId,  String? titleOverride,  ProjectTaskStatus? targetStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplyTaskTemplatePayload() when $default != null:
return $default(_that.projectId,_that.parentTaskId,_that.customStatusId,_that.titleOverride,_that.targetStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  String? parentTaskId,  String? customStatusId,  String? titleOverride,  ProjectTaskStatus? targetStatus)  $default,) {final _that = this;
switch (_that) {
case _ApplyTaskTemplatePayload():
return $default(_that.projectId,_that.parentTaskId,_that.customStatusId,_that.titleOverride,_that.targetStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  String? parentTaskId,  String? customStatusId,  String? titleOverride,  ProjectTaskStatus? targetStatus)?  $default,) {final _that = this;
switch (_that) {
case _ApplyTaskTemplatePayload() when $default != null:
return $default(_that.projectId,_that.parentTaskId,_that.customStatusId,_that.titleOverride,_that.targetStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplyTaskTemplatePayload implements ApplyTaskTemplatePayload {
  const _ApplyTaskTemplatePayload({required this.projectId, this.parentTaskId, this.customStatusId, this.titleOverride, this.targetStatus});
  factory _ApplyTaskTemplatePayload.fromJson(Map<String, dynamic> json) => _$ApplyTaskTemplatePayloadFromJson(json);

@override final  String projectId;
@override final  String? parentTaskId;
@override final  String? customStatusId;
@override final  String? titleOverride;
@override final  ProjectTaskStatus? targetStatus;

/// Create a copy of ApplyTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplyTaskTemplatePayloadCopyWith<_ApplyTaskTemplatePayload> get copyWith => __$ApplyTaskTemplatePayloadCopyWithImpl<_ApplyTaskTemplatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplyTaskTemplatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplyTaskTemplatePayload&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.titleOverride, titleOverride) || other.titleOverride == titleOverride)&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,parentTaskId,customStatusId,titleOverride,targetStatus);

@override
String toString() {
  return 'ApplyTaskTemplatePayload(projectId: $projectId, parentTaskId: $parentTaskId, customStatusId: $customStatusId, titleOverride: $titleOverride, targetStatus: $targetStatus)';
}


}

/// @nodoc
abstract mixin class _$ApplyTaskTemplatePayloadCopyWith<$Res> implements $ApplyTaskTemplatePayloadCopyWith<$Res> {
  factory _$ApplyTaskTemplatePayloadCopyWith(_ApplyTaskTemplatePayload value, $Res Function(_ApplyTaskTemplatePayload) _then) = __$ApplyTaskTemplatePayloadCopyWithImpl;
@override @useResult
$Res call({
 String projectId, String? parentTaskId, String? customStatusId, String? titleOverride, ProjectTaskStatus? targetStatus
});




}
/// @nodoc
class __$ApplyTaskTemplatePayloadCopyWithImpl<$Res>
    implements _$ApplyTaskTemplatePayloadCopyWith<$Res> {
  __$ApplyTaskTemplatePayloadCopyWithImpl(this._self, this._then);

  final _ApplyTaskTemplatePayload _self;
  final $Res Function(_ApplyTaskTemplatePayload) _then;

/// Create a copy of ApplyTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? parentTaskId = freezed,Object? customStatusId = freezed,Object? titleOverride = freezed,Object? targetStatus = freezed,}) {
  return _then(_ApplyTaskTemplatePayload(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,titleOverride: freezed == titleOverride ? _self.titleOverride : titleOverride // ignore: cast_nullable_to_non_nullable
as String?,targetStatus: freezed == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,
  ));
}


}


/// @nodoc
mixin _$TaskTemplateResponse {

 String get id; String get workspaceId; String get name; DateTime get updatedAtUtc; int get version; bool get isDefaultForCurrentUser;
/// Create a copy of TaskTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskTemplateResponseCopyWith<TaskTemplateResponse> get copyWith => _$TaskTemplateResponseCopyWithImpl<TaskTemplateResponse>(this as TaskTemplateResponse, _$identity);

  /// Serializes this TaskTemplateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskTemplateResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.isDefaultForCurrentUser, isDefaultForCurrentUser) || other.isDefaultForCurrentUser == isDefaultForCurrentUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,name,updatedAtUtc,version,isDefaultForCurrentUser);

@override
String toString() {
  return 'TaskTemplateResponse(id: $id, workspaceId: $workspaceId, name: $name, updatedAtUtc: $updatedAtUtc, version: $version, isDefaultForCurrentUser: $isDefaultForCurrentUser)';
}


}

/// @nodoc
abstract mixin class $TaskTemplateResponseCopyWith<$Res>  {
  factory $TaskTemplateResponseCopyWith(TaskTemplateResponse value, $Res Function(TaskTemplateResponse) _then) = _$TaskTemplateResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String name, DateTime updatedAtUtc, int version, bool isDefaultForCurrentUser
});




}
/// @nodoc
class _$TaskTemplateResponseCopyWithImpl<$Res>
    implements $TaskTemplateResponseCopyWith<$Res> {
  _$TaskTemplateResponseCopyWithImpl(this._self, this._then);

  final TaskTemplateResponse _self;
  final $Res Function(TaskTemplateResponse) _then;

/// Create a copy of TaskTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? name = null,Object? updatedAtUtc = null,Object? version = null,Object? isDefaultForCurrentUser = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,isDefaultForCurrentUser: null == isDefaultForCurrentUser ? _self.isDefaultForCurrentUser : isDefaultForCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskTemplateResponse].
extension TaskTemplateResponsePatterns on TaskTemplateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskTemplateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskTemplateResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskTemplateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskTemplateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String name,  DateTime updatedAtUtc,  int version,  bool isDefaultForCurrentUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskTemplateResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.name,_that.updatedAtUtc,_that.version,_that.isDefaultForCurrentUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String name,  DateTime updatedAtUtc,  int version,  bool isDefaultForCurrentUser)  $default,) {final _that = this;
switch (_that) {
case _TaskTemplateResponse():
return $default(_that.id,_that.workspaceId,_that.name,_that.updatedAtUtc,_that.version,_that.isDefaultForCurrentUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String name,  DateTime updatedAtUtc,  int version,  bool isDefaultForCurrentUser)?  $default,) {final _that = this;
switch (_that) {
case _TaskTemplateResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.name,_that.updatedAtUtc,_that.version,_that.isDefaultForCurrentUser);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskTemplateResponse implements TaskTemplateResponse {
  const _TaskTemplateResponse({required this.id, required this.workspaceId, required this.name, required this.updatedAtUtc, required this.version, this.isDefaultForCurrentUser = false});
  factory _TaskTemplateResponse.fromJson(Map<String, dynamic> json) => _$TaskTemplateResponseFromJson(json);

@override final  String id;
@override final  String workspaceId;
@override final  String name;
@override final  DateTime updatedAtUtc;
@override final  int version;
@override@JsonKey() final  bool isDefaultForCurrentUser;

/// Create a copy of TaskTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskTemplateResponseCopyWith<_TaskTemplateResponse> get copyWith => __$TaskTemplateResponseCopyWithImpl<_TaskTemplateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskTemplateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskTemplateResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.isDefaultForCurrentUser, isDefaultForCurrentUser) || other.isDefaultForCurrentUser == isDefaultForCurrentUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,name,updatedAtUtc,version,isDefaultForCurrentUser);

@override
String toString() {
  return 'TaskTemplateResponse(id: $id, workspaceId: $workspaceId, name: $name, updatedAtUtc: $updatedAtUtc, version: $version, isDefaultForCurrentUser: $isDefaultForCurrentUser)';
}


}

/// @nodoc
abstract mixin class _$TaskTemplateResponseCopyWith<$Res> implements $TaskTemplateResponseCopyWith<$Res> {
  factory _$TaskTemplateResponseCopyWith(_TaskTemplateResponse value, $Res Function(_TaskTemplateResponse) _then) = __$TaskTemplateResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String name, DateTime updatedAtUtc, int version, bool isDefaultForCurrentUser
});




}
/// @nodoc
class __$TaskTemplateResponseCopyWithImpl<$Res>
    implements _$TaskTemplateResponseCopyWith<$Res> {
  __$TaskTemplateResponseCopyWithImpl(this._self, this._then);

  final _TaskTemplateResponse _self;
  final $Res Function(_TaskTemplateResponse) _then;

/// Create a copy of TaskTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? name = null,Object? updatedAtUtc = null,Object? version = null,Object? isDefaultForCurrentUser = null,}) {
  return _then(_TaskTemplateResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,isDefaultForCurrentUser: null == isDefaultForCurrentUser ? _self.isDefaultForCurrentUser : isDefaultForCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CreateTaskTemplateDefinitionPayload {

 String get name; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; String? get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; List<String>? get assigneeCoreUserIds; List<String>? get checklistItems; List<String>? get acceptanceCriteria; List<TaskTemplateLabelResponse>? get labels; List<TaskTemplateCustomFieldValueResponse>? get customFieldValues; TaskTemplateCustomStatusResponse? get customStatus;@JsonKey(includeIfNull: false) String? get title;@JsonKey(includeIfNull: false) String? get description;@JsonKey(includeIfNull: false) String? get descriptionDeltaJson;
/// Create a copy of CreateTaskTemplateDefinitionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskTemplateDefinitionPayloadCopyWith<CreateTaskTemplateDefinitionPayload> get copyWith => _$CreateTaskTemplateDefinitionPayloadCopyWithImpl<CreateTaskTemplateDefinitionPayload>(this as CreateTaskTemplateDefinitionPayload, _$identity);

  /// Serializes this CreateTaskTemplateDefinitionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskTemplateDefinitionPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFieldValues, customFieldValues)&&(identical(other.customStatus, customStatus) || other.customStatus == customStatus)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,name,status,priority,startAtUtc,dueAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,const DeepCollectionEquality().hash(assigneeCoreUserIds),const DeepCollectionEquality().hash(checklistItems),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFieldValues),customStatus,title,description,descriptionDeltaJson]);

@override
String toString() {
  return 'CreateTaskTemplateDefinitionPayload(name: $name, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, assigneeCoreUserIds: $assigneeCoreUserIds, checklistItems: $checklistItems, acceptanceCriteria: $acceptanceCriteria, labels: $labels, customFieldValues: $customFieldValues, customStatus: $customStatus, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson)';
}


}

/// @nodoc
abstract mixin class $CreateTaskTemplateDefinitionPayloadCopyWith<$Res>  {
  factory $CreateTaskTemplateDefinitionPayloadCopyWith(CreateTaskTemplateDefinitionPayload value, $Res Function(CreateTaskTemplateDefinitionPayload) _then) = _$CreateTaskTemplateDefinitionPayloadCopyWithImpl;
@useResult
$Res call({
 String name, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, List<String>? assigneeCoreUserIds, List<String>? checklistItems, List<String>? acceptanceCriteria, List<TaskTemplateLabelResponse>? labels, List<TaskTemplateCustomFieldValueResponse>? customFieldValues, TaskTemplateCustomStatusResponse? customStatus,@JsonKey(includeIfNull: false) String? title,@JsonKey(includeIfNull: false) String? description,@JsonKey(includeIfNull: false) String? descriptionDeltaJson
});


$TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus;

}
/// @nodoc
class _$CreateTaskTemplateDefinitionPayloadCopyWithImpl<$Res>
    implements $CreateTaskTemplateDefinitionPayloadCopyWith<$Res> {
  _$CreateTaskTemplateDefinitionPayloadCopyWithImpl(this._self, this._then);

  final CreateTaskTemplateDefinitionPayload _self;
  final $Res Function(CreateTaskTemplateDefinitionPayload) _then;

/// Create a copy of CreateTaskTemplateDefinitionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? assigneeCoreUserIds = freezed,Object? checklistItems = freezed,Object? acceptanceCriteria = freezed,Object? labels = freezed,Object? customFieldValues = freezed,Object? customStatus = freezed,Object? title = freezed,Object? description = freezed,Object? descriptionDeltaJson = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,assigneeCoreUserIds: freezed == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,checklistItems: freezed == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>?,acceptanceCriteria: freezed == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<String>?,labels: freezed == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateLabelResponse>?,customFieldValues: freezed == customFieldValues ? _self.customFieldValues : customFieldValues // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateCustomFieldValueResponse>?,customStatus: freezed == customStatus ? _self.customStatus : customStatus // ignore: cast_nullable_to_non_nullable
as TaskTemplateCustomStatusResponse?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CreateTaskTemplateDefinitionPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus {
    if (_self.customStatus == null) {
    return null;
  }

  return $TaskTemplateCustomStatusResponseCopyWith<$Res>(_self.customStatus!, (value) {
    return _then(_self.copyWith(customStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateTaskTemplateDefinitionPayload].
extension CreateTaskTemplateDefinitionPayloadPatterns on CreateTaskTemplateDefinitionPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskTemplateDefinitionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskTemplateDefinitionPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskTemplateDefinitionPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskTemplateDefinitionPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskTemplateDefinitionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskTemplateDefinitionPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  List<String>? assigneeCoreUserIds,  List<String>? checklistItems,  List<String>? acceptanceCriteria,  List<TaskTemplateLabelResponse>? labels,  List<TaskTemplateCustomFieldValueResponse>? customFieldValues,  TaskTemplateCustomStatusResponse? customStatus, @JsonKey(includeIfNull: false)  String? title, @JsonKey(includeIfNull: false)  String? description, @JsonKey(includeIfNull: false)  String? descriptionDeltaJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskTemplateDefinitionPayload() when $default != null:
return $default(_that.name,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.assigneeCoreUserIds,_that.checklistItems,_that.acceptanceCriteria,_that.labels,_that.customFieldValues,_that.customStatus,_that.title,_that.description,_that.descriptionDeltaJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  List<String>? assigneeCoreUserIds,  List<String>? checklistItems,  List<String>? acceptanceCriteria,  List<TaskTemplateLabelResponse>? labels,  List<TaskTemplateCustomFieldValueResponse>? customFieldValues,  TaskTemplateCustomStatusResponse? customStatus, @JsonKey(includeIfNull: false)  String? title, @JsonKey(includeIfNull: false)  String? description, @JsonKey(includeIfNull: false)  String? descriptionDeltaJson)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskTemplateDefinitionPayload():
return $default(_that.name,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.assigneeCoreUserIds,_that.checklistItems,_that.acceptanceCriteria,_that.labels,_that.customFieldValues,_that.customStatus,_that.title,_that.description,_that.descriptionDeltaJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  List<String>? assigneeCoreUserIds,  List<String>? checklistItems,  List<String>? acceptanceCriteria,  List<TaskTemplateLabelResponse>? labels,  List<TaskTemplateCustomFieldValueResponse>? customFieldValues,  TaskTemplateCustomStatusResponse? customStatus, @JsonKey(includeIfNull: false)  String? title, @JsonKey(includeIfNull: false)  String? description, @JsonKey(includeIfNull: false)  String? descriptionDeltaJson)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskTemplateDefinitionPayload() when $default != null:
return $default(_that.name,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.assigneeCoreUserIds,_that.checklistItems,_that.acceptanceCriteria,_that.labels,_that.customFieldValues,_that.customStatus,_that.title,_that.description,_that.descriptionDeltaJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskTemplateDefinitionPayload implements CreateTaskTemplateDefinitionPayload {
  const _CreateTaskTemplateDefinitionPayload({required this.name, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.assigneeCoreUserIds, this.checklistItems, this.acceptanceCriteria, this.labels, this.customFieldValues, this.customStatus, @JsonKey(includeIfNull: false) this.title, @JsonKey(includeIfNull: false) this.description, @JsonKey(includeIfNull: false) this.descriptionDeltaJson});
  factory _CreateTaskTemplateDefinitionPayload.fromJson(Map<String, dynamic> json) => _$CreateTaskTemplateDefinitionPayloadFromJson(json);

@override final  String name;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  String? taskType;
@override final  int? size;
@override final  int? complexity;
@override final  int? risk;
@override final  int? businessValue;
@override final  int? estimatedMinutes;
@override final  List<String>? assigneeCoreUserIds;
@override final  List<String>? checklistItems;
@override final  List<String>? acceptanceCriteria;
@override final  List<TaskTemplateLabelResponse>? labels;
@override final  List<TaskTemplateCustomFieldValueResponse>? customFieldValues;
@override final  TaskTemplateCustomStatusResponse? customStatus;
@override@JsonKey(includeIfNull: false) final  String? title;
@override@JsonKey(includeIfNull: false) final  String? description;
@override@JsonKey(includeIfNull: false) final  String? descriptionDeltaJson;

/// Create a copy of CreateTaskTemplateDefinitionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskTemplateDefinitionPayloadCopyWith<_CreateTaskTemplateDefinitionPayload> get copyWith => __$CreateTaskTemplateDefinitionPayloadCopyWithImpl<_CreateTaskTemplateDefinitionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskTemplateDefinitionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskTemplateDefinitionPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFieldValues, customFieldValues)&&(identical(other.customStatus, customStatus) || other.customStatus == customStatus)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,name,status,priority,startAtUtc,dueAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,const DeepCollectionEquality().hash(assigneeCoreUserIds),const DeepCollectionEquality().hash(checklistItems),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFieldValues),customStatus,title,description,descriptionDeltaJson]);

@override
String toString() {
  return 'CreateTaskTemplateDefinitionPayload(name: $name, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, assigneeCoreUserIds: $assigneeCoreUserIds, checklistItems: $checklistItems, acceptanceCriteria: $acceptanceCriteria, labels: $labels, customFieldValues: $customFieldValues, customStatus: $customStatus, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskTemplateDefinitionPayloadCopyWith<$Res> implements $CreateTaskTemplateDefinitionPayloadCopyWith<$Res> {
  factory _$CreateTaskTemplateDefinitionPayloadCopyWith(_CreateTaskTemplateDefinitionPayload value, $Res Function(_CreateTaskTemplateDefinitionPayload) _then) = __$CreateTaskTemplateDefinitionPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, List<String>? assigneeCoreUserIds, List<String>? checklistItems, List<String>? acceptanceCriteria, List<TaskTemplateLabelResponse>? labels, List<TaskTemplateCustomFieldValueResponse>? customFieldValues, TaskTemplateCustomStatusResponse? customStatus,@JsonKey(includeIfNull: false) String? title,@JsonKey(includeIfNull: false) String? description,@JsonKey(includeIfNull: false) String? descriptionDeltaJson
});


@override $TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus;

}
/// @nodoc
class __$CreateTaskTemplateDefinitionPayloadCopyWithImpl<$Res>
    implements _$CreateTaskTemplateDefinitionPayloadCopyWith<$Res> {
  __$CreateTaskTemplateDefinitionPayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskTemplateDefinitionPayload _self;
  final $Res Function(_CreateTaskTemplateDefinitionPayload) _then;

/// Create a copy of CreateTaskTemplateDefinitionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? assigneeCoreUserIds = freezed,Object? checklistItems = freezed,Object? acceptanceCriteria = freezed,Object? labels = freezed,Object? customFieldValues = freezed,Object? customStatus = freezed,Object? title = freezed,Object? description = freezed,Object? descriptionDeltaJson = freezed,}) {
  return _then(_CreateTaskTemplateDefinitionPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,assigneeCoreUserIds: freezed == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,checklistItems: freezed == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>?,acceptanceCriteria: freezed == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<String>?,labels: freezed == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateLabelResponse>?,customFieldValues: freezed == customFieldValues ? _self.customFieldValues : customFieldValues // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateCustomFieldValueResponse>?,customStatus: freezed == customStatus ? _self.customStatus : customStatus // ignore: cast_nullable_to_non_nullable
as TaskTemplateCustomStatusResponse?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CreateTaskTemplateDefinitionPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus {
    if (_self.customStatus == null) {
    return null;
  }

  return $TaskTemplateCustomStatusResponseCopyWith<$Res>(_self.customStatus!, (value) {
    return _then(_self.copyWith(customStatus: value));
  });
}
}


/// @nodoc
mixin _$SetDefaultTaskTemplatePayload {

 String? get taskTemplateId;
/// Create a copy of SetDefaultTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetDefaultTaskTemplatePayloadCopyWith<SetDefaultTaskTemplatePayload> get copyWith => _$SetDefaultTaskTemplatePayloadCopyWithImpl<SetDefaultTaskTemplatePayload>(this as SetDefaultTaskTemplatePayload, _$identity);

  /// Serializes this SetDefaultTaskTemplatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetDefaultTaskTemplatePayload&&(identical(other.taskTemplateId, taskTemplateId) || other.taskTemplateId == taskTemplateId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskTemplateId);

@override
String toString() {
  return 'SetDefaultTaskTemplatePayload(taskTemplateId: $taskTemplateId)';
}


}

/// @nodoc
abstract mixin class $SetDefaultTaskTemplatePayloadCopyWith<$Res>  {
  factory $SetDefaultTaskTemplatePayloadCopyWith(SetDefaultTaskTemplatePayload value, $Res Function(SetDefaultTaskTemplatePayload) _then) = _$SetDefaultTaskTemplatePayloadCopyWithImpl;
@useResult
$Res call({
 String? taskTemplateId
});




}
/// @nodoc
class _$SetDefaultTaskTemplatePayloadCopyWithImpl<$Res>
    implements $SetDefaultTaskTemplatePayloadCopyWith<$Res> {
  _$SetDefaultTaskTemplatePayloadCopyWithImpl(this._self, this._then);

  final SetDefaultTaskTemplatePayload _self;
  final $Res Function(SetDefaultTaskTemplatePayload) _then;

/// Create a copy of SetDefaultTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskTemplateId = freezed,}) {
  return _then(_self.copyWith(
taskTemplateId: freezed == taskTemplateId ? _self.taskTemplateId : taskTemplateId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetDefaultTaskTemplatePayload].
extension SetDefaultTaskTemplatePayloadPatterns on SetDefaultTaskTemplatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetDefaultTaskTemplatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetDefaultTaskTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetDefaultTaskTemplatePayload value)  $default,){
final _that = this;
switch (_that) {
case _SetDefaultTaskTemplatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetDefaultTaskTemplatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _SetDefaultTaskTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? taskTemplateId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetDefaultTaskTemplatePayload() when $default != null:
return $default(_that.taskTemplateId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? taskTemplateId)  $default,) {final _that = this;
switch (_that) {
case _SetDefaultTaskTemplatePayload():
return $default(_that.taskTemplateId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? taskTemplateId)?  $default,) {final _that = this;
switch (_that) {
case _SetDefaultTaskTemplatePayload() when $default != null:
return $default(_that.taskTemplateId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetDefaultTaskTemplatePayload implements SetDefaultTaskTemplatePayload {
  const _SetDefaultTaskTemplatePayload({this.taskTemplateId});
  factory _SetDefaultTaskTemplatePayload.fromJson(Map<String, dynamic> json) => _$SetDefaultTaskTemplatePayloadFromJson(json);

@override final  String? taskTemplateId;

/// Create a copy of SetDefaultTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetDefaultTaskTemplatePayloadCopyWith<_SetDefaultTaskTemplatePayload> get copyWith => __$SetDefaultTaskTemplatePayloadCopyWithImpl<_SetDefaultTaskTemplatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetDefaultTaskTemplatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetDefaultTaskTemplatePayload&&(identical(other.taskTemplateId, taskTemplateId) || other.taskTemplateId == taskTemplateId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskTemplateId);

@override
String toString() {
  return 'SetDefaultTaskTemplatePayload(taskTemplateId: $taskTemplateId)';
}


}

/// @nodoc
abstract mixin class _$SetDefaultTaskTemplatePayloadCopyWith<$Res> implements $SetDefaultTaskTemplatePayloadCopyWith<$Res> {
  factory _$SetDefaultTaskTemplatePayloadCopyWith(_SetDefaultTaskTemplatePayload value, $Res Function(_SetDefaultTaskTemplatePayload) _then) = __$SetDefaultTaskTemplatePayloadCopyWithImpl;
@override @useResult
$Res call({
 String? taskTemplateId
});




}
/// @nodoc
class __$SetDefaultTaskTemplatePayloadCopyWithImpl<$Res>
    implements _$SetDefaultTaskTemplatePayloadCopyWith<$Res> {
  __$SetDefaultTaskTemplatePayloadCopyWithImpl(this._self, this._then);

  final _SetDefaultTaskTemplatePayload _self;
  final $Res Function(_SetDefaultTaskTemplatePayload) _then;

/// Create a copy of SetDefaultTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskTemplateId = freezed,}) {
  return _then(_SetDefaultTaskTemplatePayload(
taskTemplateId: freezed == taskTemplateId ? _self.taskTemplateId : taskTemplateId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DefaultTaskTemplateResponse {

 String? get taskTemplateId; DateTime? get updatedAtUtc;
/// Create a copy of DefaultTaskTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DefaultTaskTemplateResponseCopyWith<DefaultTaskTemplateResponse> get copyWith => _$DefaultTaskTemplateResponseCopyWithImpl<DefaultTaskTemplateResponse>(this as DefaultTaskTemplateResponse, _$identity);

  /// Serializes this DefaultTaskTemplateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DefaultTaskTemplateResponse&&(identical(other.taskTemplateId, taskTemplateId) || other.taskTemplateId == taskTemplateId)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskTemplateId,updatedAtUtc);

@override
String toString() {
  return 'DefaultTaskTemplateResponse(taskTemplateId: $taskTemplateId, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $DefaultTaskTemplateResponseCopyWith<$Res>  {
  factory $DefaultTaskTemplateResponseCopyWith(DefaultTaskTemplateResponse value, $Res Function(DefaultTaskTemplateResponse) _then) = _$DefaultTaskTemplateResponseCopyWithImpl;
@useResult
$Res call({
 String? taskTemplateId, DateTime? updatedAtUtc
});




}
/// @nodoc
class _$DefaultTaskTemplateResponseCopyWithImpl<$Res>
    implements $DefaultTaskTemplateResponseCopyWith<$Res> {
  _$DefaultTaskTemplateResponseCopyWithImpl(this._self, this._then);

  final DefaultTaskTemplateResponse _self;
  final $Res Function(DefaultTaskTemplateResponse) _then;

/// Create a copy of DefaultTaskTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskTemplateId = freezed,Object? updatedAtUtc = freezed,}) {
  return _then(_self.copyWith(
taskTemplateId: freezed == taskTemplateId ? _self.taskTemplateId : taskTemplateId // ignore: cast_nullable_to_non_nullable
as String?,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DefaultTaskTemplateResponse].
extension DefaultTaskTemplateResponsePatterns on DefaultTaskTemplateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DefaultTaskTemplateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DefaultTaskTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DefaultTaskTemplateResponse value)  $default,){
final _that = this;
switch (_that) {
case _DefaultTaskTemplateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DefaultTaskTemplateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DefaultTaskTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? taskTemplateId,  DateTime? updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DefaultTaskTemplateResponse() when $default != null:
return $default(_that.taskTemplateId,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? taskTemplateId,  DateTime? updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _DefaultTaskTemplateResponse():
return $default(_that.taskTemplateId,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? taskTemplateId,  DateTime? updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _DefaultTaskTemplateResponse() when $default != null:
return $default(_that.taskTemplateId,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DefaultTaskTemplateResponse implements DefaultTaskTemplateResponse {
  const _DefaultTaskTemplateResponse({this.taskTemplateId, this.updatedAtUtc});
  factory _DefaultTaskTemplateResponse.fromJson(Map<String, dynamic> json) => _$DefaultTaskTemplateResponseFromJson(json);

@override final  String? taskTemplateId;
@override final  DateTime? updatedAtUtc;

/// Create a copy of DefaultTaskTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DefaultTaskTemplateResponseCopyWith<_DefaultTaskTemplateResponse> get copyWith => __$DefaultTaskTemplateResponseCopyWithImpl<_DefaultTaskTemplateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DefaultTaskTemplateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DefaultTaskTemplateResponse&&(identical(other.taskTemplateId, taskTemplateId) || other.taskTemplateId == taskTemplateId)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskTemplateId,updatedAtUtc);

@override
String toString() {
  return 'DefaultTaskTemplateResponse(taskTemplateId: $taskTemplateId, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$DefaultTaskTemplateResponseCopyWith<$Res> implements $DefaultTaskTemplateResponseCopyWith<$Res> {
  factory _$DefaultTaskTemplateResponseCopyWith(_DefaultTaskTemplateResponse value, $Res Function(_DefaultTaskTemplateResponse) _then) = __$DefaultTaskTemplateResponseCopyWithImpl;
@override @useResult
$Res call({
 String? taskTemplateId, DateTime? updatedAtUtc
});




}
/// @nodoc
class __$DefaultTaskTemplateResponseCopyWithImpl<$Res>
    implements _$DefaultTaskTemplateResponseCopyWith<$Res> {
  __$DefaultTaskTemplateResponseCopyWithImpl(this._self, this._then);

  final _DefaultTaskTemplateResponse _self;
  final $Res Function(_DefaultTaskTemplateResponse) _then;

/// Create a copy of DefaultTaskTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskTemplateId = freezed,Object? updatedAtUtc = freezed,}) {
  return _then(_DefaultTaskTemplateResponse(
taskTemplateId: freezed == taskTemplateId ? _self.taskTemplateId : taskTemplateId // ignore: cast_nullable_to_non_nullable
as String?,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TaskTemplateLabelResponse {

 String get name; String get color;
/// Create a copy of TaskTemplateLabelResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskTemplateLabelResponseCopyWith<TaskTemplateLabelResponse> get copyWith => _$TaskTemplateLabelResponseCopyWithImpl<TaskTemplateLabelResponse>(this as TaskTemplateLabelResponse, _$identity);

  /// Serializes this TaskTemplateLabelResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskTemplateLabelResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,color);

@override
String toString() {
  return 'TaskTemplateLabelResponse(name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class $TaskTemplateLabelResponseCopyWith<$Res>  {
  factory $TaskTemplateLabelResponseCopyWith(TaskTemplateLabelResponse value, $Res Function(TaskTemplateLabelResponse) _then) = _$TaskTemplateLabelResponseCopyWithImpl;
@useResult
$Res call({
 String name, String color
});




}
/// @nodoc
class _$TaskTemplateLabelResponseCopyWithImpl<$Res>
    implements $TaskTemplateLabelResponseCopyWith<$Res> {
  _$TaskTemplateLabelResponseCopyWithImpl(this._self, this._then);

  final TaskTemplateLabelResponse _self;
  final $Res Function(TaskTemplateLabelResponse) _then;

/// Create a copy of TaskTemplateLabelResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? color = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskTemplateLabelResponse].
extension TaskTemplateLabelResponsePatterns on TaskTemplateLabelResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskTemplateLabelResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskTemplateLabelResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskTemplateLabelResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskTemplateLabelResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskTemplateLabelResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskTemplateLabelResponse() when $default != null:
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
case _TaskTemplateLabelResponse() when $default != null:
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
case _TaskTemplateLabelResponse():
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
case _TaskTemplateLabelResponse() when $default != null:
return $default(_that.name,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskTemplateLabelResponse implements TaskTemplateLabelResponse {
  const _TaskTemplateLabelResponse({required this.name, required this.color});
  factory _TaskTemplateLabelResponse.fromJson(Map<String, dynamic> json) => _$TaskTemplateLabelResponseFromJson(json);

@override final  String name;
@override final  String color;

/// Create a copy of TaskTemplateLabelResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskTemplateLabelResponseCopyWith<_TaskTemplateLabelResponse> get copyWith => __$TaskTemplateLabelResponseCopyWithImpl<_TaskTemplateLabelResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskTemplateLabelResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskTemplateLabelResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,color);

@override
String toString() {
  return 'TaskTemplateLabelResponse(name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class _$TaskTemplateLabelResponseCopyWith<$Res> implements $TaskTemplateLabelResponseCopyWith<$Res> {
  factory _$TaskTemplateLabelResponseCopyWith(_TaskTemplateLabelResponse value, $Res Function(_TaskTemplateLabelResponse) _then) = __$TaskTemplateLabelResponseCopyWithImpl;
@override @useResult
$Res call({
 String name, String color
});




}
/// @nodoc
class __$TaskTemplateLabelResponseCopyWithImpl<$Res>
    implements _$TaskTemplateLabelResponseCopyWith<$Res> {
  __$TaskTemplateLabelResponseCopyWithImpl(this._self, this._then);

  final _TaskTemplateLabelResponse _self;
  final $Res Function(_TaskTemplateLabelResponse) _then;

/// Create a copy of TaskTemplateLabelResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? color = null,}) {
  return _then(_TaskTemplateLabelResponse(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TaskTemplateCustomFieldValueResponse {

 String get fieldName; TaskCustomFieldType get fieldType; Object get value;
/// Create a copy of TaskTemplateCustomFieldValueResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskTemplateCustomFieldValueResponseCopyWith<TaskTemplateCustomFieldValueResponse> get copyWith => _$TaskTemplateCustomFieldValueResponseCopyWithImpl<TaskTemplateCustomFieldValueResponse>(this as TaskTemplateCustomFieldValueResponse, _$identity);

  /// Serializes this TaskTemplateCustomFieldValueResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskTemplateCustomFieldValueResponse&&(identical(other.fieldName, fieldName) || other.fieldName == fieldName)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldName,fieldType,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'TaskTemplateCustomFieldValueResponse(fieldName: $fieldName, fieldType: $fieldType, value: $value)';
}


}

/// @nodoc
abstract mixin class $TaskTemplateCustomFieldValueResponseCopyWith<$Res>  {
  factory $TaskTemplateCustomFieldValueResponseCopyWith(TaskTemplateCustomFieldValueResponse value, $Res Function(TaskTemplateCustomFieldValueResponse) _then) = _$TaskTemplateCustomFieldValueResponseCopyWithImpl;
@useResult
$Res call({
 String fieldName, TaskCustomFieldType fieldType, Object value
});




}
/// @nodoc
class _$TaskTemplateCustomFieldValueResponseCopyWithImpl<$Res>
    implements $TaskTemplateCustomFieldValueResponseCopyWith<$Res> {
  _$TaskTemplateCustomFieldValueResponseCopyWithImpl(this._self, this._then);

  final TaskTemplateCustomFieldValueResponse _self;
  final $Res Function(TaskTemplateCustomFieldValueResponse) _then;

/// Create a copy of TaskTemplateCustomFieldValueResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fieldName = null,Object? fieldType = null,Object? value = null,}) {
  return _then(_self.copyWith(
fieldName: null == fieldName ? _self.fieldName : fieldName // ignore: cast_nullable_to_non_nullable
as String,fieldType: null == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as TaskCustomFieldType,value: null == value ? _self.value : value ,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskTemplateCustomFieldValueResponse].
extension TaskTemplateCustomFieldValueResponsePatterns on TaskTemplateCustomFieldValueResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskTemplateCustomFieldValueResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskTemplateCustomFieldValueResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskTemplateCustomFieldValueResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskTemplateCustomFieldValueResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskTemplateCustomFieldValueResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskTemplateCustomFieldValueResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fieldName,  TaskCustomFieldType fieldType,  Object value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskTemplateCustomFieldValueResponse() when $default != null:
return $default(_that.fieldName,_that.fieldType,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fieldName,  TaskCustomFieldType fieldType,  Object value)  $default,) {final _that = this;
switch (_that) {
case _TaskTemplateCustomFieldValueResponse():
return $default(_that.fieldName,_that.fieldType,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fieldName,  TaskCustomFieldType fieldType,  Object value)?  $default,) {final _that = this;
switch (_that) {
case _TaskTemplateCustomFieldValueResponse() when $default != null:
return $default(_that.fieldName,_that.fieldType,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskTemplateCustomFieldValueResponse implements TaskTemplateCustomFieldValueResponse {
  const _TaskTemplateCustomFieldValueResponse({required this.fieldName, required this.fieldType, required this.value});
  factory _TaskTemplateCustomFieldValueResponse.fromJson(Map<String, dynamic> json) => _$TaskTemplateCustomFieldValueResponseFromJson(json);

@override final  String fieldName;
@override final  TaskCustomFieldType fieldType;
@override final  Object value;

/// Create a copy of TaskTemplateCustomFieldValueResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskTemplateCustomFieldValueResponseCopyWith<_TaskTemplateCustomFieldValueResponse> get copyWith => __$TaskTemplateCustomFieldValueResponseCopyWithImpl<_TaskTemplateCustomFieldValueResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskTemplateCustomFieldValueResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskTemplateCustomFieldValueResponse&&(identical(other.fieldName, fieldName) || other.fieldName == fieldName)&&(identical(other.fieldType, fieldType) || other.fieldType == fieldType)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldName,fieldType,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'TaskTemplateCustomFieldValueResponse(fieldName: $fieldName, fieldType: $fieldType, value: $value)';
}


}

/// @nodoc
abstract mixin class _$TaskTemplateCustomFieldValueResponseCopyWith<$Res> implements $TaskTemplateCustomFieldValueResponseCopyWith<$Res> {
  factory _$TaskTemplateCustomFieldValueResponseCopyWith(_TaskTemplateCustomFieldValueResponse value, $Res Function(_TaskTemplateCustomFieldValueResponse) _then) = __$TaskTemplateCustomFieldValueResponseCopyWithImpl;
@override @useResult
$Res call({
 String fieldName, TaskCustomFieldType fieldType, Object value
});




}
/// @nodoc
class __$TaskTemplateCustomFieldValueResponseCopyWithImpl<$Res>
    implements _$TaskTemplateCustomFieldValueResponseCopyWith<$Res> {
  __$TaskTemplateCustomFieldValueResponseCopyWithImpl(this._self, this._then);

  final _TaskTemplateCustomFieldValueResponse _self;
  final $Res Function(_TaskTemplateCustomFieldValueResponse) _then;

/// Create a copy of TaskTemplateCustomFieldValueResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fieldName = null,Object? fieldType = null,Object? value = null,}) {
  return _then(_TaskTemplateCustomFieldValueResponse(
fieldName: null == fieldName ? _self.fieldName : fieldName // ignore: cast_nullable_to_non_nullable
as String,fieldType: null == fieldType ? _self.fieldType : fieldType // ignore: cast_nullable_to_non_nullable
as TaskCustomFieldType,value: null == value ? _self.value : value ,
  ));
}


}


/// @nodoc
mixin _$TaskTemplateCustomStatusResponse {

 String get name; TaskStatusCategory get category;
/// Create a copy of TaskTemplateCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskTemplateCustomStatusResponseCopyWith<TaskTemplateCustomStatusResponse> get copyWith => _$TaskTemplateCustomStatusResponseCopyWithImpl<TaskTemplateCustomStatusResponse>(this as TaskTemplateCustomStatusResponse, _$identity);

  /// Serializes this TaskTemplateCustomStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskTemplateCustomStatusResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category);

@override
String toString() {
  return 'TaskTemplateCustomStatusResponse(name: $name, category: $category)';
}


}

/// @nodoc
abstract mixin class $TaskTemplateCustomStatusResponseCopyWith<$Res>  {
  factory $TaskTemplateCustomStatusResponseCopyWith(TaskTemplateCustomStatusResponse value, $Res Function(TaskTemplateCustomStatusResponse) _then) = _$TaskTemplateCustomStatusResponseCopyWithImpl;
@useResult
$Res call({
 String name, TaskStatusCategory category
});




}
/// @nodoc
class _$TaskTemplateCustomStatusResponseCopyWithImpl<$Res>
    implements $TaskTemplateCustomStatusResponseCopyWith<$Res> {
  _$TaskTemplateCustomStatusResponseCopyWithImpl(this._self, this._then);

  final TaskTemplateCustomStatusResponse _self;
  final $Res Function(TaskTemplateCustomStatusResponse) _then;

/// Create a copy of TaskTemplateCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? category = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskTemplateCustomStatusResponse].
extension TaskTemplateCustomStatusResponsePatterns on TaskTemplateCustomStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskTemplateCustomStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskTemplateCustomStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskTemplateCustomStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskTemplateCustomStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskTemplateCustomStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskTemplateCustomStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  TaskStatusCategory category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskTemplateCustomStatusResponse() when $default != null:
return $default(_that.name,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  TaskStatusCategory category)  $default,) {final _that = this;
switch (_that) {
case _TaskTemplateCustomStatusResponse():
return $default(_that.name,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  TaskStatusCategory category)?  $default,) {final _that = this;
switch (_that) {
case _TaskTemplateCustomStatusResponse() when $default != null:
return $default(_that.name,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskTemplateCustomStatusResponse implements TaskTemplateCustomStatusResponse {
  const _TaskTemplateCustomStatusResponse({required this.name, required this.category});
  factory _TaskTemplateCustomStatusResponse.fromJson(Map<String, dynamic> json) => _$TaskTemplateCustomStatusResponseFromJson(json);

@override final  String name;
@override final  TaskStatusCategory category;

/// Create a copy of TaskTemplateCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskTemplateCustomStatusResponseCopyWith<_TaskTemplateCustomStatusResponse> get copyWith => __$TaskTemplateCustomStatusResponseCopyWithImpl<_TaskTemplateCustomStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskTemplateCustomStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskTemplateCustomStatusResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category);

@override
String toString() {
  return 'TaskTemplateCustomStatusResponse(name: $name, category: $category)';
}


}

/// @nodoc
abstract mixin class _$TaskTemplateCustomStatusResponseCopyWith<$Res> implements $TaskTemplateCustomStatusResponseCopyWith<$Res> {
  factory _$TaskTemplateCustomStatusResponseCopyWith(_TaskTemplateCustomStatusResponse value, $Res Function(_TaskTemplateCustomStatusResponse) _then) = __$TaskTemplateCustomStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 String name, TaskStatusCategory category
});




}
/// @nodoc
class __$TaskTemplateCustomStatusResponseCopyWithImpl<$Res>
    implements _$TaskTemplateCustomStatusResponseCopyWith<$Res> {
  __$TaskTemplateCustomStatusResponseCopyWithImpl(this._self, this._then);

  final _TaskTemplateCustomStatusResponse _self;
  final $Res Function(_TaskTemplateCustomStatusResponse) _then;

/// Create a copy of TaskTemplateCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? category = null,}) {
  return _then(_TaskTemplateCustomStatusResponse(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,
  ));
}


}


/// @nodoc
mixin _$TaskTemplateDetailsResponse {

 String get id; String get name; String? get title; String? get description; String? get descriptionDeltaJson; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; String? get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; List<String> get assigneeCoreUserIds; List<String> get checklistItems; List<String> get acceptanceCriteria; List<TaskTemplateLabelResponse> get labels; List<TaskTemplateCustomFieldValueResponse> get customFieldValues; TaskTemplateCustomStatusResponse? get customStatus; DateTime get updatedAtUtc; int get version;
/// Create a copy of TaskTemplateDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskTemplateDetailsResponseCopyWith<TaskTemplateDetailsResponse> get copyWith => _$TaskTemplateDetailsResponseCopyWithImpl<TaskTemplateDetailsResponse>(this as TaskTemplateDetailsResponse, _$identity);

  /// Serializes this TaskTemplateDetailsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskTemplateDetailsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFieldValues, customFieldValues)&&(identical(other.customStatus, customStatus) || other.customStatus == customStatus)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,title,description,descriptionDeltaJson,status,priority,startAtUtc,dueAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,const DeepCollectionEquality().hash(assigneeCoreUserIds),const DeepCollectionEquality().hash(checklistItems),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFieldValues),customStatus,updatedAtUtc,version]);

@override
String toString() {
  return 'TaskTemplateDetailsResponse(id: $id, name: $name, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, assigneeCoreUserIds: $assigneeCoreUserIds, checklistItems: $checklistItems, acceptanceCriteria: $acceptanceCriteria, labels: $labels, customFieldValues: $customFieldValues, customStatus: $customStatus, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $TaskTemplateDetailsResponseCopyWith<$Res>  {
  factory $TaskTemplateDetailsResponseCopyWith(TaskTemplateDetailsResponse value, $Res Function(TaskTemplateDetailsResponse) _then) = _$TaskTemplateDetailsResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? title, String? description, String? descriptionDeltaJson, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, List<String> assigneeCoreUserIds, List<String> checklistItems, List<String> acceptanceCriteria, List<TaskTemplateLabelResponse> labels, List<TaskTemplateCustomFieldValueResponse> customFieldValues, TaskTemplateCustomStatusResponse? customStatus, DateTime updatedAtUtc, int version
});


$TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus;

}
/// @nodoc
class _$TaskTemplateDetailsResponseCopyWithImpl<$Res>
    implements $TaskTemplateDetailsResponseCopyWith<$Res> {
  _$TaskTemplateDetailsResponseCopyWithImpl(this._self, this._then);

  final TaskTemplateDetailsResponse _self;
  final $Res Function(TaskTemplateDetailsResponse) _then;

/// Create a copy of TaskTemplateDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? title = freezed,Object? description = freezed,Object? descriptionDeltaJson = freezed,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? assigneeCoreUserIds = null,Object? checklistItems = null,Object? acceptanceCriteria = null,Object? labels = null,Object? customFieldValues = null,Object? customStatus = freezed,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,assigneeCoreUserIds: null == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,checklistItems: null == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>,acceptanceCriteria: null == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<String>,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateLabelResponse>,customFieldValues: null == customFieldValues ? _self.customFieldValues : customFieldValues // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateCustomFieldValueResponse>,customStatus: freezed == customStatus ? _self.customStatus : customStatus // ignore: cast_nullable_to_non_nullable
as TaskTemplateCustomStatusResponse?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TaskTemplateDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus {
    if (_self.customStatus == null) {
    return null;
  }

  return $TaskTemplateCustomStatusResponseCopyWith<$Res>(_self.customStatus!, (value) {
    return _then(_self.copyWith(customStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskTemplateDetailsResponse].
extension TaskTemplateDetailsResponsePatterns on TaskTemplateDetailsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskTemplateDetailsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskTemplateDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskTemplateDetailsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskTemplateDetailsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskTemplateDetailsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskTemplateDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? title,  String? description,  String? descriptionDeltaJson,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  List<String> assigneeCoreUserIds,  List<String> checklistItems,  List<String> acceptanceCriteria,  List<TaskTemplateLabelResponse> labels,  List<TaskTemplateCustomFieldValueResponse> customFieldValues,  TaskTemplateCustomStatusResponse? customStatus,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskTemplateDetailsResponse() when $default != null:
return $default(_that.id,_that.name,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.assigneeCoreUserIds,_that.checklistItems,_that.acceptanceCriteria,_that.labels,_that.customFieldValues,_that.customStatus,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? title,  String? description,  String? descriptionDeltaJson,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  List<String> assigneeCoreUserIds,  List<String> checklistItems,  List<String> acceptanceCriteria,  List<TaskTemplateLabelResponse> labels,  List<TaskTemplateCustomFieldValueResponse> customFieldValues,  TaskTemplateCustomStatusResponse? customStatus,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _TaskTemplateDetailsResponse():
return $default(_that.id,_that.name,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.assigneeCoreUserIds,_that.checklistItems,_that.acceptanceCriteria,_that.labels,_that.customFieldValues,_that.customStatus,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? title,  String? description,  String? descriptionDeltaJson,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  List<String> assigneeCoreUserIds,  List<String> checklistItems,  List<String> acceptanceCriteria,  List<TaskTemplateLabelResponse> labels,  List<TaskTemplateCustomFieldValueResponse> customFieldValues,  TaskTemplateCustomStatusResponse? customStatus,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _TaskTemplateDetailsResponse() when $default != null:
return $default(_that.id,_that.name,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.assigneeCoreUserIds,_that.checklistItems,_that.acceptanceCriteria,_that.labels,_that.customFieldValues,_that.customStatus,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskTemplateDetailsResponse implements TaskTemplateDetailsResponse {
  const _TaskTemplateDetailsResponse({required this.id, required this.name, this.title, this.description, this.descriptionDeltaJson, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, required this.assigneeCoreUserIds, required this.checklistItems, required this.acceptanceCriteria, required this.labels, required this.customFieldValues, this.customStatus, required this.updatedAtUtc, required this.version});
  factory _TaskTemplateDetailsResponse.fromJson(Map<String, dynamic> json) => _$TaskTemplateDetailsResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? title;
@override final  String? description;
@override final  String? descriptionDeltaJson;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  String? taskType;
@override final  int? size;
@override final  int? complexity;
@override final  int? risk;
@override final  int? businessValue;
@override final  int? estimatedMinutes;
@override final  List<String> assigneeCoreUserIds;
@override final  List<String> checklistItems;
@override final  List<String> acceptanceCriteria;
@override final  List<TaskTemplateLabelResponse> labels;
@override final  List<TaskTemplateCustomFieldValueResponse> customFieldValues;
@override final  TaskTemplateCustomStatusResponse? customStatus;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of TaskTemplateDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskTemplateDetailsResponseCopyWith<_TaskTemplateDetailsResponse> get copyWith => __$TaskTemplateDetailsResponseCopyWithImpl<_TaskTemplateDetailsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskTemplateDetailsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskTemplateDetailsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFieldValues, customFieldValues)&&(identical(other.customStatus, customStatus) || other.customStatus == customStatus)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,title,description,descriptionDeltaJson,status,priority,startAtUtc,dueAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,const DeepCollectionEquality().hash(assigneeCoreUserIds),const DeepCollectionEquality().hash(checklistItems),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFieldValues),customStatus,updatedAtUtc,version]);

@override
String toString() {
  return 'TaskTemplateDetailsResponse(id: $id, name: $name, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, assigneeCoreUserIds: $assigneeCoreUserIds, checklistItems: $checklistItems, acceptanceCriteria: $acceptanceCriteria, labels: $labels, customFieldValues: $customFieldValues, customStatus: $customStatus, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$TaskTemplateDetailsResponseCopyWith<$Res> implements $TaskTemplateDetailsResponseCopyWith<$Res> {
  factory _$TaskTemplateDetailsResponseCopyWith(_TaskTemplateDetailsResponse value, $Res Function(_TaskTemplateDetailsResponse) _then) = __$TaskTemplateDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? title, String? description, String? descriptionDeltaJson, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, List<String> assigneeCoreUserIds, List<String> checklistItems, List<String> acceptanceCriteria, List<TaskTemplateLabelResponse> labels, List<TaskTemplateCustomFieldValueResponse> customFieldValues, TaskTemplateCustomStatusResponse? customStatus, DateTime updatedAtUtc, int version
});


@override $TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus;

}
/// @nodoc
class __$TaskTemplateDetailsResponseCopyWithImpl<$Res>
    implements _$TaskTemplateDetailsResponseCopyWith<$Res> {
  __$TaskTemplateDetailsResponseCopyWithImpl(this._self, this._then);

  final _TaskTemplateDetailsResponse _self;
  final $Res Function(_TaskTemplateDetailsResponse) _then;

/// Create a copy of TaskTemplateDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? title = freezed,Object? description = freezed,Object? descriptionDeltaJson = freezed,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? assigneeCoreUserIds = null,Object? checklistItems = null,Object? acceptanceCriteria = null,Object? labels = null,Object? customFieldValues = null,Object? customStatus = freezed,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_TaskTemplateDetailsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,assigneeCoreUserIds: null == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,checklistItems: null == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>,acceptanceCriteria: null == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<String>,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateLabelResponse>,customFieldValues: null == customFieldValues ? _self.customFieldValues : customFieldValues // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateCustomFieldValueResponse>,customStatus: freezed == customStatus ? _self.customStatus : customStatus // ignore: cast_nullable_to_non_nullable
as TaskTemplateCustomStatusResponse?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TaskTemplateDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus {
    if (_self.customStatus == null) {
    return null;
  }

  return $TaskTemplateCustomStatusResponseCopyWith<$Res>(_self.customStatus!, (value) {
    return _then(_self.copyWith(customStatus: value));
  });
}
}


/// @nodoc
mixin _$UpdateTaskTemplatePayload {

 String get name; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; String? get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; List<String>? get assigneeCoreUserIds; List<String>? get checklistItems; List<String>? get acceptanceCriteria; List<TaskTemplateLabelResponse>? get labels; List<TaskTemplateCustomFieldValueResponse>? get customFieldValues; TaskTemplateCustomStatusResponse? get customStatus; bool get clearCustomStatus; int get expectedVersion;@JsonKey(includeIfNull: false) String? get title;@JsonKey(includeIfNull: false) String? get description;@JsonKey(includeIfNull: false) String? get descriptionDeltaJson;
/// Create a copy of UpdateTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskTemplatePayloadCopyWith<UpdateTaskTemplatePayload> get copyWith => _$UpdateTaskTemplatePayloadCopyWithImpl<UpdateTaskTemplatePayload>(this as UpdateTaskTemplatePayload, _$identity);

  /// Serializes this UpdateTaskTemplatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskTemplatePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFieldValues, customFieldValues)&&(identical(other.customStatus, customStatus) || other.customStatus == customStatus)&&(identical(other.clearCustomStatus, clearCustomStatus) || other.clearCustomStatus == clearCustomStatus)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,name,status,priority,startAtUtc,dueAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,const DeepCollectionEquality().hash(assigneeCoreUserIds),const DeepCollectionEquality().hash(checklistItems),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFieldValues),customStatus,clearCustomStatus,expectedVersion,title,description,descriptionDeltaJson]);

@override
String toString() {
  return 'UpdateTaskTemplatePayload(name: $name, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, assigneeCoreUserIds: $assigneeCoreUserIds, checklistItems: $checklistItems, acceptanceCriteria: $acceptanceCriteria, labels: $labels, customFieldValues: $customFieldValues, customStatus: $customStatus, clearCustomStatus: $clearCustomStatus, expectedVersion: $expectedVersion, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskTemplatePayloadCopyWith<$Res>  {
  factory $UpdateTaskTemplatePayloadCopyWith(UpdateTaskTemplatePayload value, $Res Function(UpdateTaskTemplatePayload) _then) = _$UpdateTaskTemplatePayloadCopyWithImpl;
@useResult
$Res call({
 String name, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, List<String>? assigneeCoreUserIds, List<String>? checklistItems, List<String>? acceptanceCriteria, List<TaskTemplateLabelResponse>? labels, List<TaskTemplateCustomFieldValueResponse>? customFieldValues, TaskTemplateCustomStatusResponse? customStatus, bool clearCustomStatus, int expectedVersion,@JsonKey(includeIfNull: false) String? title,@JsonKey(includeIfNull: false) String? description,@JsonKey(includeIfNull: false) String? descriptionDeltaJson
});


$TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus;

}
/// @nodoc
class _$UpdateTaskTemplatePayloadCopyWithImpl<$Res>
    implements $UpdateTaskTemplatePayloadCopyWith<$Res> {
  _$UpdateTaskTemplatePayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskTemplatePayload _self;
  final $Res Function(UpdateTaskTemplatePayload) _then;

/// Create a copy of UpdateTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? assigneeCoreUserIds = freezed,Object? checklistItems = freezed,Object? acceptanceCriteria = freezed,Object? labels = freezed,Object? customFieldValues = freezed,Object? customStatus = freezed,Object? clearCustomStatus = null,Object? expectedVersion = null,Object? title = freezed,Object? description = freezed,Object? descriptionDeltaJson = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,assigneeCoreUserIds: freezed == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,checklistItems: freezed == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>?,acceptanceCriteria: freezed == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<String>?,labels: freezed == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateLabelResponse>?,customFieldValues: freezed == customFieldValues ? _self.customFieldValues : customFieldValues // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateCustomFieldValueResponse>?,customStatus: freezed == customStatus ? _self.customStatus : customStatus // ignore: cast_nullable_to_non_nullable
as TaskTemplateCustomStatusResponse?,clearCustomStatus: null == clearCustomStatus ? _self.clearCustomStatus : clearCustomStatus // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of UpdateTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus {
    if (_self.customStatus == null) {
    return null;
  }

  return $TaskTemplateCustomStatusResponseCopyWith<$Res>(_self.customStatus!, (value) {
    return _then(_self.copyWith(customStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateTaskTemplatePayload].
extension UpdateTaskTemplatePayloadPatterns on UpdateTaskTemplatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskTemplatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskTemplatePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskTemplatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskTemplatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  List<String>? assigneeCoreUserIds,  List<String>? checklistItems,  List<String>? acceptanceCriteria,  List<TaskTemplateLabelResponse>? labels,  List<TaskTemplateCustomFieldValueResponse>? customFieldValues,  TaskTemplateCustomStatusResponse? customStatus,  bool clearCustomStatus,  int expectedVersion, @JsonKey(includeIfNull: false)  String? title, @JsonKey(includeIfNull: false)  String? description, @JsonKey(includeIfNull: false)  String? descriptionDeltaJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskTemplatePayload() when $default != null:
return $default(_that.name,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.assigneeCoreUserIds,_that.checklistItems,_that.acceptanceCriteria,_that.labels,_that.customFieldValues,_that.customStatus,_that.clearCustomStatus,_that.expectedVersion,_that.title,_that.description,_that.descriptionDeltaJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  List<String>? assigneeCoreUserIds,  List<String>? checklistItems,  List<String>? acceptanceCriteria,  List<TaskTemplateLabelResponse>? labels,  List<TaskTemplateCustomFieldValueResponse>? customFieldValues,  TaskTemplateCustomStatusResponse? customStatus,  bool clearCustomStatus,  int expectedVersion, @JsonKey(includeIfNull: false)  String? title, @JsonKey(includeIfNull: false)  String? description, @JsonKey(includeIfNull: false)  String? descriptionDeltaJson)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskTemplatePayload():
return $default(_that.name,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.assigneeCoreUserIds,_that.checklistItems,_that.acceptanceCriteria,_that.labels,_that.customFieldValues,_that.customStatus,_that.clearCustomStatus,_that.expectedVersion,_that.title,_that.description,_that.descriptionDeltaJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  List<String>? assigneeCoreUserIds,  List<String>? checklistItems,  List<String>? acceptanceCriteria,  List<TaskTemplateLabelResponse>? labels,  List<TaskTemplateCustomFieldValueResponse>? customFieldValues,  TaskTemplateCustomStatusResponse? customStatus,  bool clearCustomStatus,  int expectedVersion, @JsonKey(includeIfNull: false)  String? title, @JsonKey(includeIfNull: false)  String? description, @JsonKey(includeIfNull: false)  String? descriptionDeltaJson)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskTemplatePayload() when $default != null:
return $default(_that.name,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.assigneeCoreUserIds,_that.checklistItems,_that.acceptanceCriteria,_that.labels,_that.customFieldValues,_that.customStatus,_that.clearCustomStatus,_that.expectedVersion,_that.title,_that.description,_that.descriptionDeltaJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskTemplatePayload implements UpdateTaskTemplatePayload {
  const _UpdateTaskTemplatePayload({required this.name, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.assigneeCoreUserIds, this.checklistItems, this.acceptanceCriteria, this.labels, this.customFieldValues, this.customStatus, this.clearCustomStatus = false, required this.expectedVersion, @JsonKey(includeIfNull: false) this.title, @JsonKey(includeIfNull: false) this.description, @JsonKey(includeIfNull: false) this.descriptionDeltaJson});
  factory _UpdateTaskTemplatePayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskTemplatePayloadFromJson(json);

@override final  String name;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  String? taskType;
@override final  int? size;
@override final  int? complexity;
@override final  int? risk;
@override final  int? businessValue;
@override final  int? estimatedMinutes;
@override final  List<String>? assigneeCoreUserIds;
@override final  List<String>? checklistItems;
@override final  List<String>? acceptanceCriteria;
@override final  List<TaskTemplateLabelResponse>? labels;
@override final  List<TaskTemplateCustomFieldValueResponse>? customFieldValues;
@override final  TaskTemplateCustomStatusResponse? customStatus;
@override@JsonKey() final  bool clearCustomStatus;
@override final  int expectedVersion;
@override@JsonKey(includeIfNull: false) final  String? title;
@override@JsonKey(includeIfNull: false) final  String? description;
@override@JsonKey(includeIfNull: false) final  String? descriptionDeltaJson;

/// Create a copy of UpdateTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskTemplatePayloadCopyWith<_UpdateTaskTemplatePayload> get copyWith => __$UpdateTaskTemplatePayloadCopyWithImpl<_UpdateTaskTemplatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskTemplatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskTemplatePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFieldValues, customFieldValues)&&(identical(other.customStatus, customStatus) || other.customStatus == customStatus)&&(identical(other.clearCustomStatus, clearCustomStatus) || other.clearCustomStatus == clearCustomStatus)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,name,status,priority,startAtUtc,dueAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,const DeepCollectionEquality().hash(assigneeCoreUserIds),const DeepCollectionEquality().hash(checklistItems),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFieldValues),customStatus,clearCustomStatus,expectedVersion,title,description,descriptionDeltaJson]);

@override
String toString() {
  return 'UpdateTaskTemplatePayload(name: $name, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, assigneeCoreUserIds: $assigneeCoreUserIds, checklistItems: $checklistItems, acceptanceCriteria: $acceptanceCriteria, labels: $labels, customFieldValues: $customFieldValues, customStatus: $customStatus, clearCustomStatus: $clearCustomStatus, expectedVersion: $expectedVersion, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskTemplatePayloadCopyWith<$Res> implements $UpdateTaskTemplatePayloadCopyWith<$Res> {
  factory _$UpdateTaskTemplatePayloadCopyWith(_UpdateTaskTemplatePayload value, $Res Function(_UpdateTaskTemplatePayload) _then) = __$UpdateTaskTemplatePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, List<String>? assigneeCoreUserIds, List<String>? checklistItems, List<String>? acceptanceCriteria, List<TaskTemplateLabelResponse>? labels, List<TaskTemplateCustomFieldValueResponse>? customFieldValues, TaskTemplateCustomStatusResponse? customStatus, bool clearCustomStatus, int expectedVersion,@JsonKey(includeIfNull: false) String? title,@JsonKey(includeIfNull: false) String? description,@JsonKey(includeIfNull: false) String? descriptionDeltaJson
});


@override $TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus;

}
/// @nodoc
class __$UpdateTaskTemplatePayloadCopyWithImpl<$Res>
    implements _$UpdateTaskTemplatePayloadCopyWith<$Res> {
  __$UpdateTaskTemplatePayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskTemplatePayload _self;
  final $Res Function(_UpdateTaskTemplatePayload) _then;

/// Create a copy of UpdateTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? assigneeCoreUserIds = freezed,Object? checklistItems = freezed,Object? acceptanceCriteria = freezed,Object? labels = freezed,Object? customFieldValues = freezed,Object? customStatus = freezed,Object? clearCustomStatus = null,Object? expectedVersion = null,Object? title = freezed,Object? description = freezed,Object? descriptionDeltaJson = freezed,}) {
  return _then(_UpdateTaskTemplatePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,assigneeCoreUserIds: freezed == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,checklistItems: freezed == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>?,acceptanceCriteria: freezed == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<String>?,labels: freezed == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateLabelResponse>?,customFieldValues: freezed == customFieldValues ? _self.customFieldValues : customFieldValues // ignore: cast_nullable_to_non_nullable
as List<TaskTemplateCustomFieldValueResponse>?,customStatus: freezed == customStatus ? _self.customStatus : customStatus // ignore: cast_nullable_to_non_nullable
as TaskTemplateCustomStatusResponse?,clearCustomStatus: null == clearCustomStatus ? _self.clearCustomStatus : clearCustomStatus // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of UpdateTaskTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskTemplateCustomStatusResponseCopyWith<$Res>? get customStatus {
    if (_self.customStatus == null) {
    return null;
  }

  return $TaskTemplateCustomStatusResponseCopyWith<$Res>(_self.customStatus!, (value) {
    return _then(_self.copyWith(customStatus: value));
  });
}
}

// dart format on
