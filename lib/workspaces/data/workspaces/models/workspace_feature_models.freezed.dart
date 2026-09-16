// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_feature_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateDashboardPreferencePayload {

 Map<String, dynamic> get layout; int get expectedVersion;
/// Create a copy of UpdateDashboardPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateDashboardPreferencePayloadCopyWith<UpdateDashboardPreferencePayload> get copyWith => _$UpdateDashboardPreferencePayloadCopyWithImpl<UpdateDashboardPreferencePayload>(this as UpdateDashboardPreferencePayload, _$identity);

  /// Serializes this UpdateDashboardPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateDashboardPreferencePayload&&const DeepCollectionEquality().equals(other.layout, layout)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(layout),expectedVersion);

@override
String toString() {
  return 'UpdateDashboardPreferencePayload(layout: $layout, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateDashboardPreferencePayloadCopyWith<$Res>  {
  factory $UpdateDashboardPreferencePayloadCopyWith(UpdateDashboardPreferencePayload value, $Res Function(UpdateDashboardPreferencePayload) _then) = _$UpdateDashboardPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> layout, int expectedVersion
});




}
/// @nodoc
class _$UpdateDashboardPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateDashboardPreferencePayloadCopyWith<$Res> {
  _$UpdateDashboardPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateDashboardPreferencePayload _self;
  final $Res Function(UpdateDashboardPreferencePayload) _then;

/// Create a copy of UpdateDashboardPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? layout = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateDashboardPreferencePayload].
extension UpdateDashboardPreferencePayloadPatterns on UpdateDashboardPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateDashboardPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateDashboardPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateDashboardPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateDashboardPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateDashboardPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateDashboardPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> layout,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateDashboardPreferencePayload() when $default != null:
return $default(_that.layout,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> layout,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateDashboardPreferencePayload():
return $default(_that.layout,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> layout,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateDashboardPreferencePayload() when $default != null:
return $default(_that.layout,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateDashboardPreferencePayload implements UpdateDashboardPreferencePayload {
  const _UpdateDashboardPreferencePayload({required this.layout, required this.expectedVersion});
  factory _UpdateDashboardPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateDashboardPreferencePayloadFromJson(json);

@override final  Map<String, dynamic> layout;
@override final  int expectedVersion;

/// Create a copy of UpdateDashboardPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateDashboardPreferencePayloadCopyWith<_UpdateDashboardPreferencePayload> get copyWith => __$UpdateDashboardPreferencePayloadCopyWithImpl<_UpdateDashboardPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateDashboardPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateDashboardPreferencePayload&&const DeepCollectionEquality().equals(other.layout, layout)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(layout),expectedVersion);

@override
String toString() {
  return 'UpdateDashboardPreferencePayload(layout: $layout, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateDashboardPreferencePayloadCopyWith<$Res> implements $UpdateDashboardPreferencePayloadCopyWith<$Res> {
  factory _$UpdateDashboardPreferencePayloadCopyWith(_UpdateDashboardPreferencePayload value, $Res Function(_UpdateDashboardPreferencePayload) _then) = __$UpdateDashboardPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> layout, int expectedVersion
});




}
/// @nodoc
class __$UpdateDashboardPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateDashboardPreferencePayloadCopyWith<$Res> {
  __$UpdateDashboardPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateDashboardPreferencePayload _self;
  final $Res Function(_UpdateDashboardPreferencePayload) _then;

/// Create a copy of UpdateDashboardPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? layout = null,Object? expectedVersion = null,}) {
  return _then(_UpdateDashboardPreferencePayload(
layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardPreferenceResponse {

 String get workspaceId; String get userId; DashboardContextKind get context; String? get projectId; Map<String, dynamic> get layout; DateTime get updatedAtUtc; int get version;
/// Create a copy of DashboardPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPreferenceResponseCopyWith<DashboardPreferenceResponse> get copyWith => _$DashboardPreferenceResponseCopyWithImpl<DashboardPreferenceResponse>(this as DashboardPreferenceResponse, _$identity);

  /// Serializes this DashboardPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPreferenceResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.context, context) || other.context == context)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&const DeepCollectionEquality().equals(other.layout, layout)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,userId,context,projectId,const DeepCollectionEquality().hash(layout),updatedAtUtc,version);

@override
String toString() {
  return 'DashboardPreferenceResponse(workspaceId: $workspaceId, userId: $userId, context: $context, projectId: $projectId, layout: $layout, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $DashboardPreferenceResponseCopyWith<$Res>  {
  factory $DashboardPreferenceResponseCopyWith(DashboardPreferenceResponse value, $Res Function(DashboardPreferenceResponse) _then) = _$DashboardPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String workspaceId, String userId, DashboardContextKind context, String? projectId, Map<String, dynamic> layout, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$DashboardPreferenceResponseCopyWithImpl<$Res>
    implements $DashboardPreferenceResponseCopyWith<$Res> {
  _$DashboardPreferenceResponseCopyWithImpl(this._self, this._then);

  final DashboardPreferenceResponse _self;
  final $Res Function(DashboardPreferenceResponse) _then;

/// Create a copy of DashboardPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workspaceId = null,Object? userId = null,Object? context = null,Object? projectId = freezed,Object? layout = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as DashboardContextKind,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPreferenceResponse].
extension DashboardPreferenceResponsePatterns on DashboardPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workspaceId,  String userId,  DashboardContextKind context,  String? projectId,  Map<String, dynamic> layout,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPreferenceResponse() when $default != null:
return $default(_that.workspaceId,_that.userId,_that.context,_that.projectId,_that.layout,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workspaceId,  String userId,  DashboardContextKind context,  String? projectId,  Map<String, dynamic> layout,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _DashboardPreferenceResponse():
return $default(_that.workspaceId,_that.userId,_that.context,_that.projectId,_that.layout,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workspaceId,  String userId,  DashboardContextKind context,  String? projectId,  Map<String, dynamic> layout,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPreferenceResponse() when $default != null:
return $default(_that.workspaceId,_that.userId,_that.context,_that.projectId,_that.layout,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardPreferenceResponse implements DashboardPreferenceResponse {
  const _DashboardPreferenceResponse({required this.workspaceId, required this.userId, required this.context, this.projectId, required this.layout, required this.updatedAtUtc, required this.version});
  factory _DashboardPreferenceResponse.fromJson(Map<String, dynamic> json) => _$DashboardPreferenceResponseFromJson(json);

@override final  String workspaceId;
@override final  String userId;
@override final  DashboardContextKind context;
@override final  String? projectId;
@override final  Map<String, dynamic> layout;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of DashboardPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPreferenceResponseCopyWith<_DashboardPreferenceResponse> get copyWith => __$DashboardPreferenceResponseCopyWithImpl<_DashboardPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPreferenceResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.context, context) || other.context == context)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&const DeepCollectionEquality().equals(other.layout, layout)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,userId,context,projectId,const DeepCollectionEquality().hash(layout),updatedAtUtc,version);

@override
String toString() {
  return 'DashboardPreferenceResponse(workspaceId: $workspaceId, userId: $userId, context: $context, projectId: $projectId, layout: $layout, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$DashboardPreferenceResponseCopyWith<$Res> implements $DashboardPreferenceResponseCopyWith<$Res> {
  factory _$DashboardPreferenceResponseCopyWith(_DashboardPreferenceResponse value, $Res Function(_DashboardPreferenceResponse) _then) = __$DashboardPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String workspaceId, String userId, DashboardContextKind context, String? projectId, Map<String, dynamic> layout, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$DashboardPreferenceResponseCopyWithImpl<$Res>
    implements _$DashboardPreferenceResponseCopyWith<$Res> {
  __$DashboardPreferenceResponseCopyWithImpl(this._self, this._then);

  final _DashboardPreferenceResponse _self;
  final $Res Function(_DashboardPreferenceResponse) _then;

/// Create a copy of DashboardPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workspaceId = null,Object? userId = null,Object? context = null,Object? projectId = freezed,Object? layout = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_DashboardPreferenceResponse(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as DashboardContextKind,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WorkspaceActivityItemResponse {

 String get id; String get sourceModule; String get eventType; String get workspaceId; String? get projectId; String get entityId; String? get actorCoreUserId; DateTime get occurredAtUtc; String? get metadataJson;
/// Create a copy of WorkspaceActivityItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceActivityItemResponseCopyWith<WorkspaceActivityItemResponse> get copyWith => _$WorkspaceActivityItemResponseCopyWithImpl<WorkspaceActivityItemResponse>(this as WorkspaceActivityItemResponse, _$identity);

  /// Serializes this WorkspaceActivityItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceActivityItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.actorCoreUserId, actorCoreUserId) || other.actorCoreUserId == actorCoreUserId)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc)&&(identical(other.metadataJson, metadataJson) || other.metadataJson == metadataJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceModule,eventType,workspaceId,projectId,entityId,actorCoreUserId,occurredAtUtc,metadataJson);

@override
String toString() {
  return 'WorkspaceActivityItemResponse(id: $id, sourceModule: $sourceModule, eventType: $eventType, workspaceId: $workspaceId, projectId: $projectId, entityId: $entityId, actorCoreUserId: $actorCoreUserId, occurredAtUtc: $occurredAtUtc, metadataJson: $metadataJson)';
}


}

/// @nodoc
abstract mixin class $WorkspaceActivityItemResponseCopyWith<$Res>  {
  factory $WorkspaceActivityItemResponseCopyWith(WorkspaceActivityItemResponse value, $Res Function(WorkspaceActivityItemResponse) _then) = _$WorkspaceActivityItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, String sourceModule, String eventType, String workspaceId, String? projectId, String entityId, String? actorCoreUserId, DateTime occurredAtUtc, String? metadataJson
});




}
/// @nodoc
class _$WorkspaceActivityItemResponseCopyWithImpl<$Res>
    implements $WorkspaceActivityItemResponseCopyWith<$Res> {
  _$WorkspaceActivityItemResponseCopyWithImpl(this._self, this._then);

  final WorkspaceActivityItemResponse _self;
  final $Res Function(WorkspaceActivityItemResponse) _then;

/// Create a copy of WorkspaceActivityItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceModule = null,Object? eventType = null,Object? workspaceId = null,Object? projectId = freezed,Object? entityId = null,Object? actorCoreUserId = freezed,Object? occurredAtUtc = null,Object? metadataJson = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,actorCoreUserId: freezed == actorCoreUserId ? _self.actorCoreUserId : actorCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,metadataJson: freezed == metadataJson ? _self.metadataJson : metadataJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceActivityItemResponse].
extension WorkspaceActivityItemResponsePatterns on WorkspaceActivityItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceActivityItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceActivityItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceActivityItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceActivityItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceActivityItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceActivityItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceModule,  String eventType,  String workspaceId,  String? projectId,  String entityId,  String? actorCoreUserId,  DateTime occurredAtUtc,  String? metadataJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceActivityItemResponse() when $default != null:
return $default(_that.id,_that.sourceModule,_that.eventType,_that.workspaceId,_that.projectId,_that.entityId,_that.actorCoreUserId,_that.occurredAtUtc,_that.metadataJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceModule,  String eventType,  String workspaceId,  String? projectId,  String entityId,  String? actorCoreUserId,  DateTime occurredAtUtc,  String? metadataJson)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceActivityItemResponse():
return $default(_that.id,_that.sourceModule,_that.eventType,_that.workspaceId,_that.projectId,_that.entityId,_that.actorCoreUserId,_that.occurredAtUtc,_that.metadataJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceModule,  String eventType,  String workspaceId,  String? projectId,  String entityId,  String? actorCoreUserId,  DateTime occurredAtUtc,  String? metadataJson)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceActivityItemResponse() when $default != null:
return $default(_that.id,_that.sourceModule,_that.eventType,_that.workspaceId,_that.projectId,_that.entityId,_that.actorCoreUserId,_that.occurredAtUtc,_that.metadataJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceActivityItemResponse implements WorkspaceActivityItemResponse {
  const _WorkspaceActivityItemResponse({required this.id, required this.sourceModule, required this.eventType, required this.workspaceId, this.projectId, required this.entityId, this.actorCoreUserId, required this.occurredAtUtc, this.metadataJson});
  factory _WorkspaceActivityItemResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceActivityItemResponseFromJson(json);

@override final  String id;
@override final  String sourceModule;
@override final  String eventType;
@override final  String workspaceId;
@override final  String? projectId;
@override final  String entityId;
@override final  String? actorCoreUserId;
@override final  DateTime occurredAtUtc;
@override final  String? metadataJson;

/// Create a copy of WorkspaceActivityItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceActivityItemResponseCopyWith<_WorkspaceActivityItemResponse> get copyWith => __$WorkspaceActivityItemResponseCopyWithImpl<_WorkspaceActivityItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceActivityItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceActivityItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.actorCoreUserId, actorCoreUserId) || other.actorCoreUserId == actorCoreUserId)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc)&&(identical(other.metadataJson, metadataJson) || other.metadataJson == metadataJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceModule,eventType,workspaceId,projectId,entityId,actorCoreUserId,occurredAtUtc,metadataJson);

@override
String toString() {
  return 'WorkspaceActivityItemResponse(id: $id, sourceModule: $sourceModule, eventType: $eventType, workspaceId: $workspaceId, projectId: $projectId, entityId: $entityId, actorCoreUserId: $actorCoreUserId, occurredAtUtc: $occurredAtUtc, metadataJson: $metadataJson)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceActivityItemResponseCopyWith<$Res> implements $WorkspaceActivityItemResponseCopyWith<$Res> {
  factory _$WorkspaceActivityItemResponseCopyWith(_WorkspaceActivityItemResponse value, $Res Function(_WorkspaceActivityItemResponse) _then) = __$WorkspaceActivityItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceModule, String eventType, String workspaceId, String? projectId, String entityId, String? actorCoreUserId, DateTime occurredAtUtc, String? metadataJson
});




}
/// @nodoc
class __$WorkspaceActivityItemResponseCopyWithImpl<$Res>
    implements _$WorkspaceActivityItemResponseCopyWith<$Res> {
  __$WorkspaceActivityItemResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceActivityItemResponse _self;
  final $Res Function(_WorkspaceActivityItemResponse) _then;

/// Create a copy of WorkspaceActivityItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceModule = null,Object? eventType = null,Object? workspaceId = null,Object? projectId = freezed,Object? entityId = null,Object? actorCoreUserId = freezed,Object? occurredAtUtc = null,Object? metadataJson = freezed,}) {
  return _then(_WorkspaceActivityItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,actorCoreUserId: freezed == actorCoreUserId ? _self.actorCoreUserId : actorCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,metadataJson: freezed == metadataJson ? _self.metadataJson : metadataJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WorkspaceActivityPageResponse {

 List<WorkspaceActivityItemResponse> get items; String? get nextCursor;
/// Create a copy of WorkspaceActivityPageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceActivityPageResponseCopyWith<WorkspaceActivityPageResponse> get copyWith => _$WorkspaceActivityPageResponseCopyWithImpl<WorkspaceActivityPageResponse>(this as WorkspaceActivityPageResponse, _$identity);

  /// Serializes this WorkspaceActivityPageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceActivityPageResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'WorkspaceActivityPageResponse(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $WorkspaceActivityPageResponseCopyWith<$Res>  {
  factory $WorkspaceActivityPageResponseCopyWith(WorkspaceActivityPageResponse value, $Res Function(WorkspaceActivityPageResponse) _then) = _$WorkspaceActivityPageResponseCopyWithImpl;
@useResult
$Res call({
 List<WorkspaceActivityItemResponse> items, String? nextCursor
});




}
/// @nodoc
class _$WorkspaceActivityPageResponseCopyWithImpl<$Res>
    implements $WorkspaceActivityPageResponseCopyWith<$Res> {
  _$WorkspaceActivityPageResponseCopyWithImpl(this._self, this._then);

  final WorkspaceActivityPageResponse _self;
  final $Res Function(WorkspaceActivityPageResponse) _then;

/// Create a copy of WorkspaceActivityPageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WorkspaceActivityItemResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceActivityPageResponse].
extension WorkspaceActivityPageResponsePatterns on WorkspaceActivityPageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceActivityPageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceActivityPageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceActivityPageResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceActivityPageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceActivityPageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceActivityPageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WorkspaceActivityItemResponse> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceActivityPageResponse() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WorkspaceActivityItemResponse> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceActivityPageResponse():
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WorkspaceActivityItemResponse> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceActivityPageResponse() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceActivityPageResponse implements WorkspaceActivityPageResponse {
  const _WorkspaceActivityPageResponse({required this.items, this.nextCursor});
  factory _WorkspaceActivityPageResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceActivityPageResponseFromJson(json);

@override final  List<WorkspaceActivityItemResponse> items;
@override final  String? nextCursor;

/// Create a copy of WorkspaceActivityPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceActivityPageResponseCopyWith<_WorkspaceActivityPageResponse> get copyWith => __$WorkspaceActivityPageResponseCopyWithImpl<_WorkspaceActivityPageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceActivityPageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceActivityPageResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'WorkspaceActivityPageResponse(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceActivityPageResponseCopyWith<$Res> implements $WorkspaceActivityPageResponseCopyWith<$Res> {
  factory _$WorkspaceActivityPageResponseCopyWith(_WorkspaceActivityPageResponse value, $Res Function(_WorkspaceActivityPageResponse) _then) = __$WorkspaceActivityPageResponseCopyWithImpl;
@override @useResult
$Res call({
 List<WorkspaceActivityItemResponse> items, String? nextCursor
});




}
/// @nodoc
class __$WorkspaceActivityPageResponseCopyWithImpl<$Res>
    implements _$WorkspaceActivityPageResponseCopyWith<$Res> {
  __$WorkspaceActivityPageResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceActivityPageResponse _self;
  final $Res Function(_WorkspaceActivityPageResponse) _then;

/// Create a copy of WorkspaceActivityPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_WorkspaceActivityPageResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WorkspaceActivityItemResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateCrossModuleSyncLinkPayload {

 String get taskId; CrossModuleSyncSourceKind get sourceKind; String get sourceId;
/// Create a copy of CreateCrossModuleSyncLinkPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateCrossModuleSyncLinkPayloadCopyWith<CreateCrossModuleSyncLinkPayload> get copyWith => _$CreateCrossModuleSyncLinkPayloadCopyWithImpl<CreateCrossModuleSyncLinkPayload>(this as CreateCrossModuleSyncLinkPayload, _$identity);

  /// Serializes this CreateCrossModuleSyncLinkPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateCrossModuleSyncLinkPayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.sourceKind, sourceKind) || other.sourceKind == sourceKind)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,sourceKind,sourceId);

@override
String toString() {
  return 'CreateCrossModuleSyncLinkPayload(taskId: $taskId, sourceKind: $sourceKind, sourceId: $sourceId)';
}


}

/// @nodoc
abstract mixin class $CreateCrossModuleSyncLinkPayloadCopyWith<$Res>  {
  factory $CreateCrossModuleSyncLinkPayloadCopyWith(CreateCrossModuleSyncLinkPayload value, $Res Function(CreateCrossModuleSyncLinkPayload) _then) = _$CreateCrossModuleSyncLinkPayloadCopyWithImpl;
@useResult
$Res call({
 String taskId, CrossModuleSyncSourceKind sourceKind, String sourceId
});




}
/// @nodoc
class _$CreateCrossModuleSyncLinkPayloadCopyWithImpl<$Res>
    implements $CreateCrossModuleSyncLinkPayloadCopyWith<$Res> {
  _$CreateCrossModuleSyncLinkPayloadCopyWithImpl(this._self, this._then);

  final CreateCrossModuleSyncLinkPayload _self;
  final $Res Function(CreateCrossModuleSyncLinkPayload) _then;

/// Create a copy of CreateCrossModuleSyncLinkPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? sourceKind = null,Object? sourceId = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,sourceKind: null == sourceKind ? _self.sourceKind : sourceKind // ignore: cast_nullable_to_non_nullable
as CrossModuleSyncSourceKind,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateCrossModuleSyncLinkPayload].
extension CreateCrossModuleSyncLinkPayloadPatterns on CreateCrossModuleSyncLinkPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateCrossModuleSyncLinkPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateCrossModuleSyncLinkPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateCrossModuleSyncLinkPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateCrossModuleSyncLinkPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateCrossModuleSyncLinkPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateCrossModuleSyncLinkPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  CrossModuleSyncSourceKind sourceKind,  String sourceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateCrossModuleSyncLinkPayload() when $default != null:
return $default(_that.taskId,_that.sourceKind,_that.sourceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  CrossModuleSyncSourceKind sourceKind,  String sourceId)  $default,) {final _that = this;
switch (_that) {
case _CreateCrossModuleSyncLinkPayload():
return $default(_that.taskId,_that.sourceKind,_that.sourceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  CrossModuleSyncSourceKind sourceKind,  String sourceId)?  $default,) {final _that = this;
switch (_that) {
case _CreateCrossModuleSyncLinkPayload() when $default != null:
return $default(_that.taskId,_that.sourceKind,_that.sourceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateCrossModuleSyncLinkPayload implements CreateCrossModuleSyncLinkPayload {
  const _CreateCrossModuleSyncLinkPayload({required this.taskId, required this.sourceKind, required this.sourceId});
  factory _CreateCrossModuleSyncLinkPayload.fromJson(Map<String, dynamic> json) => _$CreateCrossModuleSyncLinkPayloadFromJson(json);

@override final  String taskId;
@override final  CrossModuleSyncSourceKind sourceKind;
@override final  String sourceId;

/// Create a copy of CreateCrossModuleSyncLinkPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCrossModuleSyncLinkPayloadCopyWith<_CreateCrossModuleSyncLinkPayload> get copyWith => __$CreateCrossModuleSyncLinkPayloadCopyWithImpl<_CreateCrossModuleSyncLinkPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateCrossModuleSyncLinkPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateCrossModuleSyncLinkPayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.sourceKind, sourceKind) || other.sourceKind == sourceKind)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,sourceKind,sourceId);

@override
String toString() {
  return 'CreateCrossModuleSyncLinkPayload(taskId: $taskId, sourceKind: $sourceKind, sourceId: $sourceId)';
}


}

/// @nodoc
abstract mixin class _$CreateCrossModuleSyncLinkPayloadCopyWith<$Res> implements $CreateCrossModuleSyncLinkPayloadCopyWith<$Res> {
  factory _$CreateCrossModuleSyncLinkPayloadCopyWith(_CreateCrossModuleSyncLinkPayload value, $Res Function(_CreateCrossModuleSyncLinkPayload) _then) = __$CreateCrossModuleSyncLinkPayloadCopyWithImpl;
@override @useResult
$Res call({
 String taskId, CrossModuleSyncSourceKind sourceKind, String sourceId
});




}
/// @nodoc
class __$CreateCrossModuleSyncLinkPayloadCopyWithImpl<$Res>
    implements _$CreateCrossModuleSyncLinkPayloadCopyWith<$Res> {
  __$CreateCrossModuleSyncLinkPayloadCopyWithImpl(this._self, this._then);

  final _CreateCrossModuleSyncLinkPayload _self;
  final $Res Function(_CreateCrossModuleSyncLinkPayload) _then;

/// Create a copy of CreateCrossModuleSyncLinkPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? sourceKind = null,Object? sourceId = null,}) {
  return _then(_CreateCrossModuleSyncLinkPayload(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,sourceKind: null == sourceKind ? _self.sourceKind : sourceKind // ignore: cast_nullable_to_non_nullable
as CrossModuleSyncSourceKind,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CrossModuleSyncLinkResponse {

 String get id; String get workspaceId; String get projectId; String get taskId; CrossModuleSyncSourceKind get sourceKind; String get sourceId; CrossModuleSyncLinkStatus get status; int get lastTaskVersion; int get lastSourceVersion; String? get lastCorrelationId; String? get lastError; DateTime get createdAtUtc; DateTime get updatedAtUtc; int get version;
/// Create a copy of CrossModuleSyncLinkResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrossModuleSyncLinkResponseCopyWith<CrossModuleSyncLinkResponse> get copyWith => _$CrossModuleSyncLinkResponseCopyWithImpl<CrossModuleSyncLinkResponse>(this as CrossModuleSyncLinkResponse, _$identity);

  /// Serializes this CrossModuleSyncLinkResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrossModuleSyncLinkResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.sourceKind, sourceKind) || other.sourceKind == sourceKind)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastTaskVersion, lastTaskVersion) || other.lastTaskVersion == lastTaskVersion)&&(identical(other.lastSourceVersion, lastSourceVersion) || other.lastSourceVersion == lastSourceVersion)&&(identical(other.lastCorrelationId, lastCorrelationId) || other.lastCorrelationId == lastCorrelationId)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,projectId,taskId,sourceKind,sourceId,status,lastTaskVersion,lastSourceVersion,lastCorrelationId,lastError,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'CrossModuleSyncLinkResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, taskId: $taskId, sourceKind: $sourceKind, sourceId: $sourceId, status: $status, lastTaskVersion: $lastTaskVersion, lastSourceVersion: $lastSourceVersion, lastCorrelationId: $lastCorrelationId, lastError: $lastError, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $CrossModuleSyncLinkResponseCopyWith<$Res>  {
  factory $CrossModuleSyncLinkResponseCopyWith(CrossModuleSyncLinkResponse value, $Res Function(CrossModuleSyncLinkResponse) _then) = _$CrossModuleSyncLinkResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String projectId, String taskId, CrossModuleSyncSourceKind sourceKind, String sourceId, CrossModuleSyncLinkStatus status, int lastTaskVersion, int lastSourceVersion, String? lastCorrelationId, String? lastError, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$CrossModuleSyncLinkResponseCopyWithImpl<$Res>
    implements $CrossModuleSyncLinkResponseCopyWith<$Res> {
  _$CrossModuleSyncLinkResponseCopyWithImpl(this._self, this._then);

  final CrossModuleSyncLinkResponse _self;
  final $Res Function(CrossModuleSyncLinkResponse) _then;

/// Create a copy of CrossModuleSyncLinkResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = null,Object? taskId = null,Object? sourceKind = null,Object? sourceId = null,Object? status = null,Object? lastTaskVersion = null,Object? lastSourceVersion = null,Object? lastCorrelationId = freezed,Object? lastError = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,sourceKind: null == sourceKind ? _self.sourceKind : sourceKind // ignore: cast_nullable_to_non_nullable
as CrossModuleSyncSourceKind,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CrossModuleSyncLinkStatus,lastTaskVersion: null == lastTaskVersion ? _self.lastTaskVersion : lastTaskVersion // ignore: cast_nullable_to_non_nullable
as int,lastSourceVersion: null == lastSourceVersion ? _self.lastSourceVersion : lastSourceVersion // ignore: cast_nullable_to_non_nullable
as int,lastCorrelationId: freezed == lastCorrelationId ? _self.lastCorrelationId : lastCorrelationId // ignore: cast_nullable_to_non_nullable
as String?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CrossModuleSyncLinkResponse].
extension CrossModuleSyncLinkResponsePatterns on CrossModuleSyncLinkResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrossModuleSyncLinkResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrossModuleSyncLinkResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrossModuleSyncLinkResponse value)  $default,){
final _that = this;
switch (_that) {
case _CrossModuleSyncLinkResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrossModuleSyncLinkResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CrossModuleSyncLinkResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String projectId,  String taskId,  CrossModuleSyncSourceKind sourceKind,  String sourceId,  CrossModuleSyncLinkStatus status,  int lastTaskVersion,  int lastSourceVersion,  String? lastCorrelationId,  String? lastError,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrossModuleSyncLinkResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.taskId,_that.sourceKind,_that.sourceId,_that.status,_that.lastTaskVersion,_that.lastSourceVersion,_that.lastCorrelationId,_that.lastError,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String projectId,  String taskId,  CrossModuleSyncSourceKind sourceKind,  String sourceId,  CrossModuleSyncLinkStatus status,  int lastTaskVersion,  int lastSourceVersion,  String? lastCorrelationId,  String? lastError,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _CrossModuleSyncLinkResponse():
return $default(_that.id,_that.workspaceId,_that.projectId,_that.taskId,_that.sourceKind,_that.sourceId,_that.status,_that.lastTaskVersion,_that.lastSourceVersion,_that.lastCorrelationId,_that.lastError,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String projectId,  String taskId,  CrossModuleSyncSourceKind sourceKind,  String sourceId,  CrossModuleSyncLinkStatus status,  int lastTaskVersion,  int lastSourceVersion,  String? lastCorrelationId,  String? lastError,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _CrossModuleSyncLinkResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.taskId,_that.sourceKind,_that.sourceId,_that.status,_that.lastTaskVersion,_that.lastSourceVersion,_that.lastCorrelationId,_that.lastError,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrossModuleSyncLinkResponse implements CrossModuleSyncLinkResponse {
  const _CrossModuleSyncLinkResponse({required this.id, required this.workspaceId, required this.projectId, required this.taskId, required this.sourceKind, required this.sourceId, required this.status, required this.lastTaskVersion, required this.lastSourceVersion, this.lastCorrelationId, this.lastError, required this.createdAtUtc, required this.updatedAtUtc, required this.version});
  factory _CrossModuleSyncLinkResponse.fromJson(Map<String, dynamic> json) => _$CrossModuleSyncLinkResponseFromJson(json);

@override final  String id;
@override final  String workspaceId;
@override final  String projectId;
@override final  String taskId;
@override final  CrossModuleSyncSourceKind sourceKind;
@override final  String sourceId;
@override final  CrossModuleSyncLinkStatus status;
@override final  int lastTaskVersion;
@override final  int lastSourceVersion;
@override final  String? lastCorrelationId;
@override final  String? lastError;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of CrossModuleSyncLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrossModuleSyncLinkResponseCopyWith<_CrossModuleSyncLinkResponse> get copyWith => __$CrossModuleSyncLinkResponseCopyWithImpl<_CrossModuleSyncLinkResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrossModuleSyncLinkResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrossModuleSyncLinkResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.sourceKind, sourceKind) || other.sourceKind == sourceKind)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastTaskVersion, lastTaskVersion) || other.lastTaskVersion == lastTaskVersion)&&(identical(other.lastSourceVersion, lastSourceVersion) || other.lastSourceVersion == lastSourceVersion)&&(identical(other.lastCorrelationId, lastCorrelationId) || other.lastCorrelationId == lastCorrelationId)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,projectId,taskId,sourceKind,sourceId,status,lastTaskVersion,lastSourceVersion,lastCorrelationId,lastError,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'CrossModuleSyncLinkResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, taskId: $taskId, sourceKind: $sourceKind, sourceId: $sourceId, status: $status, lastTaskVersion: $lastTaskVersion, lastSourceVersion: $lastSourceVersion, lastCorrelationId: $lastCorrelationId, lastError: $lastError, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$CrossModuleSyncLinkResponseCopyWith<$Res> implements $CrossModuleSyncLinkResponseCopyWith<$Res> {
  factory _$CrossModuleSyncLinkResponseCopyWith(_CrossModuleSyncLinkResponse value, $Res Function(_CrossModuleSyncLinkResponse) _then) = __$CrossModuleSyncLinkResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String projectId, String taskId, CrossModuleSyncSourceKind sourceKind, String sourceId, CrossModuleSyncLinkStatus status, int lastTaskVersion, int lastSourceVersion, String? lastCorrelationId, String? lastError, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$CrossModuleSyncLinkResponseCopyWithImpl<$Res>
    implements _$CrossModuleSyncLinkResponseCopyWith<$Res> {
  __$CrossModuleSyncLinkResponseCopyWithImpl(this._self, this._then);

  final _CrossModuleSyncLinkResponse _self;
  final $Res Function(_CrossModuleSyncLinkResponse) _then;

/// Create a copy of CrossModuleSyncLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = null,Object? taskId = null,Object? sourceKind = null,Object? sourceId = null,Object? status = null,Object? lastTaskVersion = null,Object? lastSourceVersion = null,Object? lastCorrelationId = freezed,Object? lastError = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_CrossModuleSyncLinkResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,sourceKind: null == sourceKind ? _self.sourceKind : sourceKind // ignore: cast_nullable_to_non_nullable
as CrossModuleSyncSourceKind,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CrossModuleSyncLinkStatus,lastTaskVersion: null == lastTaskVersion ? _self.lastTaskVersion : lastTaskVersion // ignore: cast_nullable_to_non_nullable
as int,lastSourceVersion: null == lastSourceVersion ? _self.lastSourceVersion : lastSourceVersion // ignore: cast_nullable_to_non_nullable
as int,lastCorrelationId: freezed == lastCorrelationId ? _self.lastCorrelationId : lastCorrelationId // ignore: cast_nullable_to_non_nullable
as String?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SetCrossModuleSyncLinkStatePayload {

 bool get paused; int get expectedVersion;
/// Create a copy of SetCrossModuleSyncLinkStatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetCrossModuleSyncLinkStatePayloadCopyWith<SetCrossModuleSyncLinkStatePayload> get copyWith => _$SetCrossModuleSyncLinkStatePayloadCopyWithImpl<SetCrossModuleSyncLinkStatePayload>(this as SetCrossModuleSyncLinkStatePayload, _$identity);

  /// Serializes this SetCrossModuleSyncLinkStatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetCrossModuleSyncLinkStatePayload&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paused,expectedVersion);

@override
String toString() {
  return 'SetCrossModuleSyncLinkStatePayload(paused: $paused, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $SetCrossModuleSyncLinkStatePayloadCopyWith<$Res>  {
  factory $SetCrossModuleSyncLinkStatePayloadCopyWith(SetCrossModuleSyncLinkStatePayload value, $Res Function(SetCrossModuleSyncLinkStatePayload) _then) = _$SetCrossModuleSyncLinkStatePayloadCopyWithImpl;
@useResult
$Res call({
 bool paused, int expectedVersion
});




}
/// @nodoc
class _$SetCrossModuleSyncLinkStatePayloadCopyWithImpl<$Res>
    implements $SetCrossModuleSyncLinkStatePayloadCopyWith<$Res> {
  _$SetCrossModuleSyncLinkStatePayloadCopyWithImpl(this._self, this._then);

  final SetCrossModuleSyncLinkStatePayload _self;
  final $Res Function(SetCrossModuleSyncLinkStatePayload) _then;

/// Create a copy of SetCrossModuleSyncLinkStatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paused = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SetCrossModuleSyncLinkStatePayload].
extension SetCrossModuleSyncLinkStatePayloadPatterns on SetCrossModuleSyncLinkStatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetCrossModuleSyncLinkStatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetCrossModuleSyncLinkStatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetCrossModuleSyncLinkStatePayload value)  $default,){
final _that = this;
switch (_that) {
case _SetCrossModuleSyncLinkStatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetCrossModuleSyncLinkStatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _SetCrossModuleSyncLinkStatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool paused,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetCrossModuleSyncLinkStatePayload() when $default != null:
return $default(_that.paused,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool paused,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _SetCrossModuleSyncLinkStatePayload():
return $default(_that.paused,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool paused,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _SetCrossModuleSyncLinkStatePayload() when $default != null:
return $default(_that.paused,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetCrossModuleSyncLinkStatePayload implements SetCrossModuleSyncLinkStatePayload {
  const _SetCrossModuleSyncLinkStatePayload({required this.paused, required this.expectedVersion});
  factory _SetCrossModuleSyncLinkStatePayload.fromJson(Map<String, dynamic> json) => _$SetCrossModuleSyncLinkStatePayloadFromJson(json);

@override final  bool paused;
@override final  int expectedVersion;

/// Create a copy of SetCrossModuleSyncLinkStatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetCrossModuleSyncLinkStatePayloadCopyWith<_SetCrossModuleSyncLinkStatePayload> get copyWith => __$SetCrossModuleSyncLinkStatePayloadCopyWithImpl<_SetCrossModuleSyncLinkStatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetCrossModuleSyncLinkStatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetCrossModuleSyncLinkStatePayload&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,paused,expectedVersion);

@override
String toString() {
  return 'SetCrossModuleSyncLinkStatePayload(paused: $paused, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$SetCrossModuleSyncLinkStatePayloadCopyWith<$Res> implements $SetCrossModuleSyncLinkStatePayloadCopyWith<$Res> {
  factory _$SetCrossModuleSyncLinkStatePayloadCopyWith(_SetCrossModuleSyncLinkStatePayload value, $Res Function(_SetCrossModuleSyncLinkStatePayload) _then) = __$SetCrossModuleSyncLinkStatePayloadCopyWithImpl;
@override @useResult
$Res call({
 bool paused, int expectedVersion
});




}
/// @nodoc
class __$SetCrossModuleSyncLinkStatePayloadCopyWithImpl<$Res>
    implements _$SetCrossModuleSyncLinkStatePayloadCopyWith<$Res> {
  __$SetCrossModuleSyncLinkStatePayloadCopyWithImpl(this._self, this._then);

  final _SetCrossModuleSyncLinkStatePayload _self;
  final $Res Function(_SetCrossModuleSyncLinkStatePayload) _then;

/// Create a copy of SetCrossModuleSyncLinkStatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paused = null,Object? expectedVersion = null,}) {
  return _then(_SetCrossModuleSyncLinkStatePayload(
paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HomeDashboardTaskResponse {

 String get id; int get number; String get title; String get projectId; String get projectName; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get dueAtUtc; String get deepLink;
/// Create a copy of HomeDashboardTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardTaskResponseCopyWith<HomeDashboardTaskResponse> get copyWith => _$HomeDashboardTaskResponseCopyWithImpl<HomeDashboardTaskResponse>(this as HomeDashboardTaskResponse, _$identity);

  /// Serializes this HomeDashboardTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboardTaskResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,title,projectId,projectName,status,priority,dueAtUtc,deepLink);

@override
String toString() {
  return 'HomeDashboardTaskResponse(id: $id, number: $number, title: $title, projectId: $projectId, projectName: $projectName, status: $status, priority: $priority, dueAtUtc: $dueAtUtc, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class $HomeDashboardTaskResponseCopyWith<$Res>  {
  factory $HomeDashboardTaskResponseCopyWith(HomeDashboardTaskResponse value, $Res Function(HomeDashboardTaskResponse) _then) = _$HomeDashboardTaskResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String title, String projectId, String projectName, ProjectTaskStatus status, TaskPriority priority, DateTime? dueAtUtc, String deepLink
});




}
/// @nodoc
class _$HomeDashboardTaskResponseCopyWithImpl<$Res>
    implements $HomeDashboardTaskResponseCopyWith<$Res> {
  _$HomeDashboardTaskResponseCopyWithImpl(this._self, this._then);

  final HomeDashboardTaskResponse _self;
  final $Res Function(HomeDashboardTaskResponse) _then;

/// Create a copy of HomeDashboardTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? title = null,Object? projectId = null,Object? projectName = null,Object? status = null,Object? priority = null,Object? dueAtUtc = freezed,Object? deepLink = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeDashboardTaskResponse].
extension HomeDashboardTaskResponsePatterns on HomeDashboardTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboardTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboardTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboardTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboardTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String title,  String projectId,  String projectName,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  String deepLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboardTaskResponse() when $default != null:
return $default(_that.id,_that.number,_that.title,_that.projectId,_that.projectName,_that.status,_that.priority,_that.dueAtUtc,_that.deepLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String title,  String projectId,  String projectName,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  String deepLink)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardTaskResponse():
return $default(_that.id,_that.number,_that.title,_that.projectId,_that.projectName,_that.status,_that.priority,_that.dueAtUtc,_that.deepLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String title,  String projectId,  String projectName,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  String deepLink)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardTaskResponse() when $default != null:
return $default(_that.id,_that.number,_that.title,_that.projectId,_that.projectName,_that.status,_that.priority,_that.dueAtUtc,_that.deepLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeDashboardTaskResponse implements HomeDashboardTaskResponse {
  const _HomeDashboardTaskResponse({required this.id, required this.number, required this.title, required this.projectId, required this.projectName, required this.status, required this.priority, this.dueAtUtc, required this.deepLink});
  factory _HomeDashboardTaskResponse.fromJson(Map<String, dynamic> json) => _$HomeDashboardTaskResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String title;
@override final  String projectId;
@override final  String projectName;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? dueAtUtc;
@override final  String deepLink;

/// Create a copy of HomeDashboardTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardTaskResponseCopyWith<_HomeDashboardTaskResponse> get copyWith => __$HomeDashboardTaskResponseCopyWithImpl<_HomeDashboardTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeDashboardTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboardTaskResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,title,projectId,projectName,status,priority,dueAtUtc,deepLink);

@override
String toString() {
  return 'HomeDashboardTaskResponse(id: $id, number: $number, title: $title, projectId: $projectId, projectName: $projectName, status: $status, priority: $priority, dueAtUtc: $dueAtUtc, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardTaskResponseCopyWith<$Res> implements $HomeDashboardTaskResponseCopyWith<$Res> {
  factory _$HomeDashboardTaskResponseCopyWith(_HomeDashboardTaskResponse value, $Res Function(_HomeDashboardTaskResponse) _then) = __$HomeDashboardTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String title, String projectId, String projectName, ProjectTaskStatus status, TaskPriority priority, DateTime? dueAtUtc, String deepLink
});




}
/// @nodoc
class __$HomeDashboardTaskResponseCopyWithImpl<$Res>
    implements _$HomeDashboardTaskResponseCopyWith<$Res> {
  __$HomeDashboardTaskResponseCopyWithImpl(this._self, this._then);

  final _HomeDashboardTaskResponse _self;
  final $Res Function(_HomeDashboardTaskResponse) _then;

/// Create a copy of HomeDashboardTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? title = null,Object? projectId = null,Object? projectName = null,Object? status = null,Object? priority = null,Object? dueAtUtc = freezed,Object? deepLink = null,}) {
  return _then(_HomeDashboardTaskResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HomeDashboardActivityResponse {

 String get id; String get sourceModule; String get eventType; String? get projectId; String? get entityId; DateTime get occurredAtUtc;
/// Create a copy of HomeDashboardActivityResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardActivityResponseCopyWith<HomeDashboardActivityResponse> get copyWith => _$HomeDashboardActivityResponseCopyWithImpl<HomeDashboardActivityResponse>(this as HomeDashboardActivityResponse, _$identity);

  /// Serializes this HomeDashboardActivityResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboardActivityResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceModule,eventType,projectId,entityId,occurredAtUtc);

@override
String toString() {
  return 'HomeDashboardActivityResponse(id: $id, sourceModule: $sourceModule, eventType: $eventType, projectId: $projectId, entityId: $entityId, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class $HomeDashboardActivityResponseCopyWith<$Res>  {
  factory $HomeDashboardActivityResponseCopyWith(HomeDashboardActivityResponse value, $Res Function(HomeDashboardActivityResponse) _then) = _$HomeDashboardActivityResponseCopyWithImpl;
@useResult
$Res call({
 String id, String sourceModule, String eventType, String? projectId, String? entityId, DateTime occurredAtUtc
});




}
/// @nodoc
class _$HomeDashboardActivityResponseCopyWithImpl<$Res>
    implements $HomeDashboardActivityResponseCopyWith<$Res> {
  _$HomeDashboardActivityResponseCopyWithImpl(this._self, this._then);

  final HomeDashboardActivityResponse _self;
  final $Res Function(HomeDashboardActivityResponse) _then;

/// Create a copy of HomeDashboardActivityResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceModule = null,Object? eventType = null,Object? projectId = freezed,Object? entityId = freezed,Object? occurredAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeDashboardActivityResponse].
extension HomeDashboardActivityResponsePatterns on HomeDashboardActivityResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboardActivityResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboardActivityResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboardActivityResponse value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardActivityResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboardActivityResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardActivityResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceModule,  String eventType,  String? projectId,  String? entityId,  DateTime occurredAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboardActivityResponse() when $default != null:
return $default(_that.id,_that.sourceModule,_that.eventType,_that.projectId,_that.entityId,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceModule,  String eventType,  String? projectId,  String? entityId,  DateTime occurredAtUtc)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardActivityResponse():
return $default(_that.id,_that.sourceModule,_that.eventType,_that.projectId,_that.entityId,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceModule,  String eventType,  String? projectId,  String? entityId,  DateTime occurredAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardActivityResponse() when $default != null:
return $default(_that.id,_that.sourceModule,_that.eventType,_that.projectId,_that.entityId,_that.occurredAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeDashboardActivityResponse implements HomeDashboardActivityResponse {
  const _HomeDashboardActivityResponse({required this.id, required this.sourceModule, required this.eventType, this.projectId, this.entityId, required this.occurredAtUtc});
  factory _HomeDashboardActivityResponse.fromJson(Map<String, dynamic> json) => _$HomeDashboardActivityResponseFromJson(json);

@override final  String id;
@override final  String sourceModule;
@override final  String eventType;
@override final  String? projectId;
@override final  String? entityId;
@override final  DateTime occurredAtUtc;

/// Create a copy of HomeDashboardActivityResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardActivityResponseCopyWith<_HomeDashboardActivityResponse> get copyWith => __$HomeDashboardActivityResponseCopyWithImpl<_HomeDashboardActivityResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeDashboardActivityResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboardActivityResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceModule,eventType,projectId,entityId,occurredAtUtc);

@override
String toString() {
  return 'HomeDashboardActivityResponse(id: $id, sourceModule: $sourceModule, eventType: $eventType, projectId: $projectId, entityId: $entityId, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardActivityResponseCopyWith<$Res> implements $HomeDashboardActivityResponseCopyWith<$Res> {
  factory _$HomeDashboardActivityResponseCopyWith(_HomeDashboardActivityResponse value, $Res Function(_HomeDashboardActivityResponse) _then) = __$HomeDashboardActivityResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceModule, String eventType, String? projectId, String? entityId, DateTime occurredAtUtc
});




}
/// @nodoc
class __$HomeDashboardActivityResponseCopyWithImpl<$Res>
    implements _$HomeDashboardActivityResponseCopyWith<$Res> {
  __$HomeDashboardActivityResponseCopyWithImpl(this._self, this._then);

  final _HomeDashboardActivityResponse _self;
  final $Res Function(_HomeDashboardActivityResponse) _then;

/// Create a copy of HomeDashboardActivityResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceModule = null,Object? eventType = null,Object? projectId = freezed,Object? entityId = freezed,Object? occurredAtUtc = null,}) {
  return _then(_HomeDashboardActivityResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$HomeDashboardResourceResponse {

 String get id; String get resourceType; String get name; String? get projectId; DateTime get updatedAtUtc; String get deepLink;
/// Create a copy of HomeDashboardResourceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardResourceResponseCopyWith<HomeDashboardResourceResponse> get copyWith => _$HomeDashboardResourceResponseCopyWithImpl<HomeDashboardResourceResponse>(this as HomeDashboardResourceResponse, _$identity);

  /// Serializes this HomeDashboardResourceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboardResourceResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.name, name) || other.name == name)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,resourceType,name,projectId,updatedAtUtc,deepLink);

@override
String toString() {
  return 'HomeDashboardResourceResponse(id: $id, resourceType: $resourceType, name: $name, projectId: $projectId, updatedAtUtc: $updatedAtUtc, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class $HomeDashboardResourceResponseCopyWith<$Res>  {
  factory $HomeDashboardResourceResponseCopyWith(HomeDashboardResourceResponse value, $Res Function(HomeDashboardResourceResponse) _then) = _$HomeDashboardResourceResponseCopyWithImpl;
@useResult
$Res call({
 String id, String resourceType, String name, String? projectId, DateTime updatedAtUtc, String deepLink
});




}
/// @nodoc
class _$HomeDashboardResourceResponseCopyWithImpl<$Res>
    implements $HomeDashboardResourceResponseCopyWith<$Res> {
  _$HomeDashboardResourceResponseCopyWithImpl(this._self, this._then);

  final HomeDashboardResourceResponse _self;
  final $Res Function(HomeDashboardResourceResponse) _then;

/// Create a copy of HomeDashboardResourceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? resourceType = null,Object? name = null,Object? projectId = freezed,Object? updatedAtUtc = null,Object? deepLink = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeDashboardResourceResponse].
extension HomeDashboardResourceResponsePatterns on HomeDashboardResourceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboardResourceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboardResourceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboardResourceResponse value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardResourceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboardResourceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardResourceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String resourceType,  String name,  String? projectId,  DateTime updatedAtUtc,  String deepLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboardResourceResponse() when $default != null:
return $default(_that.id,_that.resourceType,_that.name,_that.projectId,_that.updatedAtUtc,_that.deepLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String resourceType,  String name,  String? projectId,  DateTime updatedAtUtc,  String deepLink)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardResourceResponse():
return $default(_that.id,_that.resourceType,_that.name,_that.projectId,_that.updatedAtUtc,_that.deepLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String resourceType,  String name,  String? projectId,  DateTime updatedAtUtc,  String deepLink)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardResourceResponse() when $default != null:
return $default(_that.id,_that.resourceType,_that.name,_that.projectId,_that.updatedAtUtc,_that.deepLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeDashboardResourceResponse implements HomeDashboardResourceResponse {
  const _HomeDashboardResourceResponse({required this.id, required this.resourceType, required this.name, this.projectId, required this.updatedAtUtc, required this.deepLink});
  factory _HomeDashboardResourceResponse.fromJson(Map<String, dynamic> json) => _$HomeDashboardResourceResponseFromJson(json);

@override final  String id;
@override final  String resourceType;
@override final  String name;
@override final  String? projectId;
@override final  DateTime updatedAtUtc;
@override final  String deepLink;

/// Create a copy of HomeDashboardResourceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardResourceResponseCopyWith<_HomeDashboardResourceResponse> get copyWith => __$HomeDashboardResourceResponseCopyWithImpl<_HomeDashboardResourceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeDashboardResourceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboardResourceResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.name, name) || other.name == name)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,resourceType,name,projectId,updatedAtUtc,deepLink);

@override
String toString() {
  return 'HomeDashboardResourceResponse(id: $id, resourceType: $resourceType, name: $name, projectId: $projectId, updatedAtUtc: $updatedAtUtc, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardResourceResponseCopyWith<$Res> implements $HomeDashboardResourceResponseCopyWith<$Res> {
  factory _$HomeDashboardResourceResponseCopyWith(_HomeDashboardResourceResponse value, $Res Function(_HomeDashboardResourceResponse) _then) = __$HomeDashboardResourceResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String resourceType, String name, String? projectId, DateTime updatedAtUtc, String deepLink
});




}
/// @nodoc
class __$HomeDashboardResourceResponseCopyWithImpl<$Res>
    implements _$HomeDashboardResourceResponseCopyWith<$Res> {
  __$HomeDashboardResourceResponseCopyWithImpl(this._self, this._then);

  final _HomeDashboardResourceResponse _self;
  final $Res Function(_HomeDashboardResourceResponse) _then;

/// Create a copy of HomeDashboardResourceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? resourceType = null,Object? name = null,Object? projectId = freezed,Object? updatedAtUtc = null,Object? deepLink = null,}) {
  return _then(_HomeDashboardResourceResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HomeDashboardDiscussionResponse {

 String get conversationId; String? get name; int get unreadMessageCount; DateTime get latestMessageAtUtc; String get deepLink;
/// Create a copy of HomeDashboardDiscussionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardDiscussionResponseCopyWith<HomeDashboardDiscussionResponse> get copyWith => _$HomeDashboardDiscussionResponseCopyWithImpl<HomeDashboardDiscussionResponse>(this as HomeDashboardDiscussionResponse, _$identity);

  /// Serializes this HomeDashboardDiscussionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboardDiscussionResponse&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.unreadMessageCount, unreadMessageCount) || other.unreadMessageCount == unreadMessageCount)&&(identical(other.latestMessageAtUtc, latestMessageAtUtc) || other.latestMessageAtUtc == latestMessageAtUtc)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,name,unreadMessageCount,latestMessageAtUtc,deepLink);

@override
String toString() {
  return 'HomeDashboardDiscussionResponse(conversationId: $conversationId, name: $name, unreadMessageCount: $unreadMessageCount, latestMessageAtUtc: $latestMessageAtUtc, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class $HomeDashboardDiscussionResponseCopyWith<$Res>  {
  factory $HomeDashboardDiscussionResponseCopyWith(HomeDashboardDiscussionResponse value, $Res Function(HomeDashboardDiscussionResponse) _then) = _$HomeDashboardDiscussionResponseCopyWithImpl;
@useResult
$Res call({
 String conversationId, String? name, int unreadMessageCount, DateTime latestMessageAtUtc, String deepLink
});




}
/// @nodoc
class _$HomeDashboardDiscussionResponseCopyWithImpl<$Res>
    implements $HomeDashboardDiscussionResponseCopyWith<$Res> {
  _$HomeDashboardDiscussionResponseCopyWithImpl(this._self, this._then);

  final HomeDashboardDiscussionResponse _self;
  final $Res Function(HomeDashboardDiscussionResponse) _then;

/// Create a copy of HomeDashboardDiscussionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? name = freezed,Object? unreadMessageCount = null,Object? latestMessageAtUtc = null,Object? deepLink = null,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,unreadMessageCount: null == unreadMessageCount ? _self.unreadMessageCount : unreadMessageCount // ignore: cast_nullable_to_non_nullable
as int,latestMessageAtUtc: null == latestMessageAtUtc ? _self.latestMessageAtUtc : latestMessageAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeDashboardDiscussionResponse].
extension HomeDashboardDiscussionResponsePatterns on HomeDashboardDiscussionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboardDiscussionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboardDiscussionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboardDiscussionResponse value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardDiscussionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboardDiscussionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardDiscussionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String conversationId,  String? name,  int unreadMessageCount,  DateTime latestMessageAtUtc,  String deepLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboardDiscussionResponse() when $default != null:
return $default(_that.conversationId,_that.name,_that.unreadMessageCount,_that.latestMessageAtUtc,_that.deepLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String conversationId,  String? name,  int unreadMessageCount,  DateTime latestMessageAtUtc,  String deepLink)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardDiscussionResponse():
return $default(_that.conversationId,_that.name,_that.unreadMessageCount,_that.latestMessageAtUtc,_that.deepLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String conversationId,  String? name,  int unreadMessageCount,  DateTime latestMessageAtUtc,  String deepLink)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardDiscussionResponse() when $default != null:
return $default(_that.conversationId,_that.name,_that.unreadMessageCount,_that.latestMessageAtUtc,_that.deepLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeDashboardDiscussionResponse implements HomeDashboardDiscussionResponse {
  const _HomeDashboardDiscussionResponse({required this.conversationId, this.name, required this.unreadMessageCount, required this.latestMessageAtUtc, required this.deepLink});
  factory _HomeDashboardDiscussionResponse.fromJson(Map<String, dynamic> json) => _$HomeDashboardDiscussionResponseFromJson(json);

@override final  String conversationId;
@override final  String? name;
@override final  int unreadMessageCount;
@override final  DateTime latestMessageAtUtc;
@override final  String deepLink;

/// Create a copy of HomeDashboardDiscussionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardDiscussionResponseCopyWith<_HomeDashboardDiscussionResponse> get copyWith => __$HomeDashboardDiscussionResponseCopyWithImpl<_HomeDashboardDiscussionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeDashboardDiscussionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboardDiscussionResponse&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.unreadMessageCount, unreadMessageCount) || other.unreadMessageCount == unreadMessageCount)&&(identical(other.latestMessageAtUtc, latestMessageAtUtc) || other.latestMessageAtUtc == latestMessageAtUtc)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,name,unreadMessageCount,latestMessageAtUtc,deepLink);

@override
String toString() {
  return 'HomeDashboardDiscussionResponse(conversationId: $conversationId, name: $name, unreadMessageCount: $unreadMessageCount, latestMessageAtUtc: $latestMessageAtUtc, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardDiscussionResponseCopyWith<$Res> implements $HomeDashboardDiscussionResponseCopyWith<$Res> {
  factory _$HomeDashboardDiscussionResponseCopyWith(_HomeDashboardDiscussionResponse value, $Res Function(_HomeDashboardDiscussionResponse) _then) = __$HomeDashboardDiscussionResponseCopyWithImpl;
@override @useResult
$Res call({
 String conversationId, String? name, int unreadMessageCount, DateTime latestMessageAtUtc, String deepLink
});




}
/// @nodoc
class __$HomeDashboardDiscussionResponseCopyWithImpl<$Res>
    implements _$HomeDashboardDiscussionResponseCopyWith<$Res> {
  __$HomeDashboardDiscussionResponseCopyWithImpl(this._self, this._then);

  final _HomeDashboardDiscussionResponse _self;
  final $Res Function(_HomeDashboardDiscussionResponse) _then;

/// Create a copy of HomeDashboardDiscussionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? name = freezed,Object? unreadMessageCount = null,Object? latestMessageAtUtc = null,Object? deepLink = null,}) {
  return _then(_HomeDashboardDiscussionResponse(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,unreadMessageCount: null == unreadMessageCount ? _self.unreadMessageCount : unreadMessageCount // ignore: cast_nullable_to_non_nullable
as int,latestMessageAtUtc: null == latestMessageAtUtc ? _self.latestMessageAtUtc : latestMessageAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HomeDashboardKeyResultResponse {

 String get id; String get name; double get currentValue; double get targetValue; String? get projectId; DateTime get updatedAtUtc; String get deepLink;
/// Create a copy of HomeDashboardKeyResultResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardKeyResultResponseCopyWith<HomeDashboardKeyResultResponse> get copyWith => _$HomeDashboardKeyResultResponseCopyWithImpl<HomeDashboardKeyResultResponse>(this as HomeDashboardKeyResultResponse, _$identity);

  /// Serializes this HomeDashboardKeyResultResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboardKeyResultResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,currentValue,targetValue,projectId,updatedAtUtc,deepLink);

@override
String toString() {
  return 'HomeDashboardKeyResultResponse(id: $id, name: $name, currentValue: $currentValue, targetValue: $targetValue, projectId: $projectId, updatedAtUtc: $updatedAtUtc, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class $HomeDashboardKeyResultResponseCopyWith<$Res>  {
  factory $HomeDashboardKeyResultResponseCopyWith(HomeDashboardKeyResultResponse value, $Res Function(HomeDashboardKeyResultResponse) _then) = _$HomeDashboardKeyResultResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, double currentValue, double targetValue, String? projectId, DateTime updatedAtUtc, String deepLink
});




}
/// @nodoc
class _$HomeDashboardKeyResultResponseCopyWithImpl<$Res>
    implements $HomeDashboardKeyResultResponseCopyWith<$Res> {
  _$HomeDashboardKeyResultResponseCopyWithImpl(this._self, this._then);

  final HomeDashboardKeyResultResponse _self;
  final $Res Function(HomeDashboardKeyResultResponse) _then;

/// Create a copy of HomeDashboardKeyResultResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? currentValue = null,Object? targetValue = null,Object? projectId = freezed,Object? updatedAtUtc = null,Object? deepLink = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeDashboardKeyResultResponse].
extension HomeDashboardKeyResultResponsePatterns on HomeDashboardKeyResultResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboardKeyResultResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboardKeyResultResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboardKeyResultResponse value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardKeyResultResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboardKeyResultResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardKeyResultResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double currentValue,  double targetValue,  String? projectId,  DateTime updatedAtUtc,  String deepLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboardKeyResultResponse() when $default != null:
return $default(_that.id,_that.name,_that.currentValue,_that.targetValue,_that.projectId,_that.updatedAtUtc,_that.deepLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double currentValue,  double targetValue,  String? projectId,  DateTime updatedAtUtc,  String deepLink)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardKeyResultResponse():
return $default(_that.id,_that.name,_that.currentValue,_that.targetValue,_that.projectId,_that.updatedAtUtc,_that.deepLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double currentValue,  double targetValue,  String? projectId,  DateTime updatedAtUtc,  String deepLink)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardKeyResultResponse() when $default != null:
return $default(_that.id,_that.name,_that.currentValue,_that.targetValue,_that.projectId,_that.updatedAtUtc,_that.deepLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeDashboardKeyResultResponse implements HomeDashboardKeyResultResponse {
  const _HomeDashboardKeyResultResponse({required this.id, required this.name, required this.currentValue, required this.targetValue, this.projectId, required this.updatedAtUtc, required this.deepLink});
  factory _HomeDashboardKeyResultResponse.fromJson(Map<String, dynamic> json) => _$HomeDashboardKeyResultResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  double currentValue;
@override final  double targetValue;
@override final  String? projectId;
@override final  DateTime updatedAtUtc;
@override final  String deepLink;

/// Create a copy of HomeDashboardKeyResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardKeyResultResponseCopyWith<_HomeDashboardKeyResultResponse> get copyWith => __$HomeDashboardKeyResultResponseCopyWithImpl<_HomeDashboardKeyResultResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeDashboardKeyResultResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboardKeyResultResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,currentValue,targetValue,projectId,updatedAtUtc,deepLink);

@override
String toString() {
  return 'HomeDashboardKeyResultResponse(id: $id, name: $name, currentValue: $currentValue, targetValue: $targetValue, projectId: $projectId, updatedAtUtc: $updatedAtUtc, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardKeyResultResponseCopyWith<$Res> implements $HomeDashboardKeyResultResponseCopyWith<$Res> {
  factory _$HomeDashboardKeyResultResponseCopyWith(_HomeDashboardKeyResultResponse value, $Res Function(_HomeDashboardKeyResultResponse) _then) = __$HomeDashboardKeyResultResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double currentValue, double targetValue, String? projectId, DateTime updatedAtUtc, String deepLink
});




}
/// @nodoc
class __$HomeDashboardKeyResultResponseCopyWithImpl<$Res>
    implements _$HomeDashboardKeyResultResponseCopyWith<$Res> {
  __$HomeDashboardKeyResultResponseCopyWithImpl(this._self, this._then);

  final _HomeDashboardKeyResultResponse _self;
  final $Res Function(_HomeDashboardKeyResultResponse) _then;

/// Create a copy of HomeDashboardKeyResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? currentValue = null,Object? targetValue = null,Object? projectId = freezed,Object? updatedAtUtc = null,Object? deepLink = null,}) {
  return _then(_HomeDashboardKeyResultResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HomeDashboardResponse {

 String get workspaceId; int get unreadNotifications; int get openTasks; int get dueToday; int get overdue; List<HomeDashboardTaskResponse> get nextTasks; List<HomeDashboardActivityResponse> get recentActivity; DateTime get generatedAtUtc; List<HomeDashboardResourceResponse>? get recentResources; List<HomeDashboardDiscussionResponse>? get unreadDiscussions; List<HomeDashboardKeyResultResponse>? get assignedKeyResults; List<HomeDashboardActivityResponse>? get teamActivity;
/// Create a copy of HomeDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardResponseCopyWith<HomeDashboardResponse> get copyWith => _$HomeDashboardResponseCopyWithImpl<HomeDashboardResponse>(this as HomeDashboardResponse, _$identity);

  /// Serializes this HomeDashboardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboardResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.unreadNotifications, unreadNotifications) || other.unreadNotifications == unreadNotifications)&&(identical(other.openTasks, openTasks) || other.openTasks == openTasks)&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&const DeepCollectionEquality().equals(other.nextTasks, nextTasks)&&const DeepCollectionEquality().equals(other.recentActivity, recentActivity)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&const DeepCollectionEquality().equals(other.recentResources, recentResources)&&const DeepCollectionEquality().equals(other.unreadDiscussions, unreadDiscussions)&&const DeepCollectionEquality().equals(other.assignedKeyResults, assignedKeyResults)&&const DeepCollectionEquality().equals(other.teamActivity, teamActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,unreadNotifications,openTasks,dueToday,overdue,const DeepCollectionEquality().hash(nextTasks),const DeepCollectionEquality().hash(recentActivity),generatedAtUtc,const DeepCollectionEquality().hash(recentResources),const DeepCollectionEquality().hash(unreadDiscussions),const DeepCollectionEquality().hash(assignedKeyResults),const DeepCollectionEquality().hash(teamActivity));

@override
String toString() {
  return 'HomeDashboardResponse(workspaceId: $workspaceId, unreadNotifications: $unreadNotifications, openTasks: $openTasks, dueToday: $dueToday, overdue: $overdue, nextTasks: $nextTasks, recentActivity: $recentActivity, generatedAtUtc: $generatedAtUtc, recentResources: $recentResources, unreadDiscussions: $unreadDiscussions, assignedKeyResults: $assignedKeyResults, teamActivity: $teamActivity)';
}


}

/// @nodoc
abstract mixin class $HomeDashboardResponseCopyWith<$Res>  {
  factory $HomeDashboardResponseCopyWith(HomeDashboardResponse value, $Res Function(HomeDashboardResponse) _then) = _$HomeDashboardResponseCopyWithImpl;
@useResult
$Res call({
 String workspaceId, int unreadNotifications, int openTasks, int dueToday, int overdue, List<HomeDashboardTaskResponse> nextTasks, List<HomeDashboardActivityResponse> recentActivity, DateTime generatedAtUtc, List<HomeDashboardResourceResponse>? recentResources, List<HomeDashboardDiscussionResponse>? unreadDiscussions, List<HomeDashboardKeyResultResponse>? assignedKeyResults, List<HomeDashboardActivityResponse>? teamActivity
});




}
/// @nodoc
class _$HomeDashboardResponseCopyWithImpl<$Res>
    implements $HomeDashboardResponseCopyWith<$Res> {
  _$HomeDashboardResponseCopyWithImpl(this._self, this._then);

  final HomeDashboardResponse _self;
  final $Res Function(HomeDashboardResponse) _then;

/// Create a copy of HomeDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workspaceId = null,Object? unreadNotifications = null,Object? openTasks = null,Object? dueToday = null,Object? overdue = null,Object? nextTasks = null,Object? recentActivity = null,Object? generatedAtUtc = null,Object? recentResources = freezed,Object? unreadDiscussions = freezed,Object? assignedKeyResults = freezed,Object? teamActivity = freezed,}) {
  return _then(_self.copyWith(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,unreadNotifications: null == unreadNotifications ? _self.unreadNotifications : unreadNotifications // ignore: cast_nullable_to_non_nullable
as int,openTasks: null == openTasks ? _self.openTasks : openTasks // ignore: cast_nullable_to_non_nullable
as int,dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,nextTasks: null == nextTasks ? _self.nextTasks : nextTasks // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardTaskResponse>,recentActivity: null == recentActivity ? _self.recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardActivityResponse>,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,recentResources: freezed == recentResources ? _self.recentResources : recentResources // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardResourceResponse>?,unreadDiscussions: freezed == unreadDiscussions ? _self.unreadDiscussions : unreadDiscussions // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardDiscussionResponse>?,assignedKeyResults: freezed == assignedKeyResults ? _self.assignedKeyResults : assignedKeyResults // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardKeyResultResponse>?,teamActivity: freezed == teamActivity ? _self.teamActivity : teamActivity // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardActivityResponse>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeDashboardResponse].
extension HomeDashboardResponsePatterns on HomeDashboardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboardResponse value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workspaceId,  int unreadNotifications,  int openTasks,  int dueToday,  int overdue,  List<HomeDashboardTaskResponse> nextTasks,  List<HomeDashboardActivityResponse> recentActivity,  DateTime generatedAtUtc,  List<HomeDashboardResourceResponse>? recentResources,  List<HomeDashboardDiscussionResponse>? unreadDiscussions,  List<HomeDashboardKeyResultResponse>? assignedKeyResults,  List<HomeDashboardActivityResponse>? teamActivity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboardResponse() when $default != null:
return $default(_that.workspaceId,_that.unreadNotifications,_that.openTasks,_that.dueToday,_that.overdue,_that.nextTasks,_that.recentActivity,_that.generatedAtUtc,_that.recentResources,_that.unreadDiscussions,_that.assignedKeyResults,_that.teamActivity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workspaceId,  int unreadNotifications,  int openTasks,  int dueToday,  int overdue,  List<HomeDashboardTaskResponse> nextTasks,  List<HomeDashboardActivityResponse> recentActivity,  DateTime generatedAtUtc,  List<HomeDashboardResourceResponse>? recentResources,  List<HomeDashboardDiscussionResponse>? unreadDiscussions,  List<HomeDashboardKeyResultResponse>? assignedKeyResults,  List<HomeDashboardActivityResponse>? teamActivity)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardResponse():
return $default(_that.workspaceId,_that.unreadNotifications,_that.openTasks,_that.dueToday,_that.overdue,_that.nextTasks,_that.recentActivity,_that.generatedAtUtc,_that.recentResources,_that.unreadDiscussions,_that.assignedKeyResults,_that.teamActivity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workspaceId,  int unreadNotifications,  int openTasks,  int dueToday,  int overdue,  List<HomeDashboardTaskResponse> nextTasks,  List<HomeDashboardActivityResponse> recentActivity,  DateTime generatedAtUtc,  List<HomeDashboardResourceResponse>? recentResources,  List<HomeDashboardDiscussionResponse>? unreadDiscussions,  List<HomeDashboardKeyResultResponse>? assignedKeyResults,  List<HomeDashboardActivityResponse>? teamActivity)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardResponse() when $default != null:
return $default(_that.workspaceId,_that.unreadNotifications,_that.openTasks,_that.dueToday,_that.overdue,_that.nextTasks,_that.recentActivity,_that.generatedAtUtc,_that.recentResources,_that.unreadDiscussions,_that.assignedKeyResults,_that.teamActivity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeDashboardResponse implements HomeDashboardResponse {
  const _HomeDashboardResponse({required this.workspaceId, required this.unreadNotifications, required this.openTasks, required this.dueToday, required this.overdue, required this.nextTasks, required this.recentActivity, required this.generatedAtUtc, this.recentResources, this.unreadDiscussions, this.assignedKeyResults, this.teamActivity});
  factory _HomeDashboardResponse.fromJson(Map<String, dynamic> json) => _$HomeDashboardResponseFromJson(json);

@override final  String workspaceId;
@override final  int unreadNotifications;
@override final  int openTasks;
@override final  int dueToday;
@override final  int overdue;
@override final  List<HomeDashboardTaskResponse> nextTasks;
@override final  List<HomeDashboardActivityResponse> recentActivity;
@override final  DateTime generatedAtUtc;
@override final  List<HomeDashboardResourceResponse>? recentResources;
@override final  List<HomeDashboardDiscussionResponse>? unreadDiscussions;
@override final  List<HomeDashboardKeyResultResponse>? assignedKeyResults;
@override final  List<HomeDashboardActivityResponse>? teamActivity;

/// Create a copy of HomeDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardResponseCopyWith<_HomeDashboardResponse> get copyWith => __$HomeDashboardResponseCopyWithImpl<_HomeDashboardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeDashboardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboardResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.unreadNotifications, unreadNotifications) || other.unreadNotifications == unreadNotifications)&&(identical(other.openTasks, openTasks) || other.openTasks == openTasks)&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&const DeepCollectionEquality().equals(other.nextTasks, nextTasks)&&const DeepCollectionEquality().equals(other.recentActivity, recentActivity)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&const DeepCollectionEquality().equals(other.recentResources, recentResources)&&const DeepCollectionEquality().equals(other.unreadDiscussions, unreadDiscussions)&&const DeepCollectionEquality().equals(other.assignedKeyResults, assignedKeyResults)&&const DeepCollectionEquality().equals(other.teamActivity, teamActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,unreadNotifications,openTasks,dueToday,overdue,const DeepCollectionEquality().hash(nextTasks),const DeepCollectionEquality().hash(recentActivity),generatedAtUtc,const DeepCollectionEquality().hash(recentResources),const DeepCollectionEquality().hash(unreadDiscussions),const DeepCollectionEquality().hash(assignedKeyResults),const DeepCollectionEquality().hash(teamActivity));

@override
String toString() {
  return 'HomeDashboardResponse(workspaceId: $workspaceId, unreadNotifications: $unreadNotifications, openTasks: $openTasks, dueToday: $dueToday, overdue: $overdue, nextTasks: $nextTasks, recentActivity: $recentActivity, generatedAtUtc: $generatedAtUtc, recentResources: $recentResources, unreadDiscussions: $unreadDiscussions, assignedKeyResults: $assignedKeyResults, teamActivity: $teamActivity)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardResponseCopyWith<$Res> implements $HomeDashboardResponseCopyWith<$Res> {
  factory _$HomeDashboardResponseCopyWith(_HomeDashboardResponse value, $Res Function(_HomeDashboardResponse) _then) = __$HomeDashboardResponseCopyWithImpl;
@override @useResult
$Res call({
 String workspaceId, int unreadNotifications, int openTasks, int dueToday, int overdue, List<HomeDashboardTaskResponse> nextTasks, List<HomeDashboardActivityResponse> recentActivity, DateTime generatedAtUtc, List<HomeDashboardResourceResponse>? recentResources, List<HomeDashboardDiscussionResponse>? unreadDiscussions, List<HomeDashboardKeyResultResponse>? assignedKeyResults, List<HomeDashboardActivityResponse>? teamActivity
});




}
/// @nodoc
class __$HomeDashboardResponseCopyWithImpl<$Res>
    implements _$HomeDashboardResponseCopyWith<$Res> {
  __$HomeDashboardResponseCopyWithImpl(this._self, this._then);

  final _HomeDashboardResponse _self;
  final $Res Function(_HomeDashboardResponse) _then;

/// Create a copy of HomeDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workspaceId = null,Object? unreadNotifications = null,Object? openTasks = null,Object? dueToday = null,Object? overdue = null,Object? nextTasks = null,Object? recentActivity = null,Object? generatedAtUtc = null,Object? recentResources = freezed,Object? unreadDiscussions = freezed,Object? assignedKeyResults = freezed,Object? teamActivity = freezed,}) {
  return _then(_HomeDashboardResponse(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,unreadNotifications: null == unreadNotifications ? _self.unreadNotifications : unreadNotifications // ignore: cast_nullable_to_non_nullable
as int,openTasks: null == openTasks ? _self.openTasks : openTasks // ignore: cast_nullable_to_non_nullable
as int,dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,nextTasks: null == nextTasks ? _self.nextTasks : nextTasks // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardTaskResponse>,recentActivity: null == recentActivity ? _self.recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardActivityResponse>,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,recentResources: freezed == recentResources ? _self.recentResources : recentResources // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardResourceResponse>?,unreadDiscussions: freezed == unreadDiscussions ? _self.unreadDiscussions : unreadDiscussions // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardDiscussionResponse>?,assignedKeyResults: freezed == assignedKeyResults ? _self.assignedKeyResults : assignedKeyResults // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardKeyResultResponse>?,teamActivity: freezed == teamActivity ? _self.teamActivity : teamActivity // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardActivityResponse>?,
  ));
}


}


/// @nodoc
mixin _$ProjectDashboardMilestoneResponse {

 String get id; String get name; MilestoneStatus get status; double get progress; DateTime? get dueAtUtc;
/// Create a copy of ProjectDashboardMilestoneResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDashboardMilestoneResponseCopyWith<ProjectDashboardMilestoneResponse> get copyWith => _$ProjectDashboardMilestoneResponseCopyWithImpl<ProjectDashboardMilestoneResponse>(this as ProjectDashboardMilestoneResponse, _$identity);

  /// Serializes this ProjectDashboardMilestoneResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDashboardMilestoneResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,progress,dueAtUtc);

@override
String toString() {
  return 'ProjectDashboardMilestoneResponse(id: $id, name: $name, status: $status, progress: $progress, dueAtUtc: $dueAtUtc)';
}


}

/// @nodoc
abstract mixin class $ProjectDashboardMilestoneResponseCopyWith<$Res>  {
  factory $ProjectDashboardMilestoneResponseCopyWith(ProjectDashboardMilestoneResponse value, $Res Function(ProjectDashboardMilestoneResponse) _then) = _$ProjectDashboardMilestoneResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, MilestoneStatus status, double progress, DateTime? dueAtUtc
});




}
/// @nodoc
class _$ProjectDashboardMilestoneResponseCopyWithImpl<$Res>
    implements $ProjectDashboardMilestoneResponseCopyWith<$Res> {
  _$ProjectDashboardMilestoneResponseCopyWithImpl(this._self, this._then);

  final ProjectDashboardMilestoneResponse _self;
  final $Res Function(ProjectDashboardMilestoneResponse) _then;

/// Create a copy of ProjectDashboardMilestoneResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? progress = null,Object? dueAtUtc = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MilestoneStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectDashboardMilestoneResponse].
extension ProjectDashboardMilestoneResponsePatterns on ProjectDashboardMilestoneResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectDashboardMilestoneResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectDashboardMilestoneResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectDashboardMilestoneResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectDashboardMilestoneResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectDashboardMilestoneResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectDashboardMilestoneResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  MilestoneStatus status,  double progress,  DateTime? dueAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectDashboardMilestoneResponse() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.progress,_that.dueAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  MilestoneStatus status,  double progress,  DateTime? dueAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ProjectDashboardMilestoneResponse():
return $default(_that.id,_that.name,_that.status,_that.progress,_that.dueAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  MilestoneStatus status,  double progress,  DateTime? dueAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ProjectDashboardMilestoneResponse() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.progress,_that.dueAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectDashboardMilestoneResponse implements ProjectDashboardMilestoneResponse {
  const _ProjectDashboardMilestoneResponse({required this.id, required this.name, required this.status, required this.progress, this.dueAtUtc});
  factory _ProjectDashboardMilestoneResponse.fromJson(Map<String, dynamic> json) => _$ProjectDashboardMilestoneResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  MilestoneStatus status;
@override final  double progress;
@override final  DateTime? dueAtUtc;

/// Create a copy of ProjectDashboardMilestoneResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDashboardMilestoneResponseCopyWith<_ProjectDashboardMilestoneResponse> get copyWith => __$ProjectDashboardMilestoneResponseCopyWithImpl<_ProjectDashboardMilestoneResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectDashboardMilestoneResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectDashboardMilestoneResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,progress,dueAtUtc);

@override
String toString() {
  return 'ProjectDashboardMilestoneResponse(id: $id, name: $name, status: $status, progress: $progress, dueAtUtc: $dueAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ProjectDashboardMilestoneResponseCopyWith<$Res> implements $ProjectDashboardMilestoneResponseCopyWith<$Res> {
  factory _$ProjectDashboardMilestoneResponseCopyWith(_ProjectDashboardMilestoneResponse value, $Res Function(_ProjectDashboardMilestoneResponse) _then) = __$ProjectDashboardMilestoneResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, MilestoneStatus status, double progress, DateTime? dueAtUtc
});




}
/// @nodoc
class __$ProjectDashboardMilestoneResponseCopyWithImpl<$Res>
    implements _$ProjectDashboardMilestoneResponseCopyWith<$Res> {
  __$ProjectDashboardMilestoneResponseCopyWithImpl(this._self, this._then);

  final _ProjectDashboardMilestoneResponse _self;
  final $Res Function(_ProjectDashboardMilestoneResponse) _then;

/// Create a copy of ProjectDashboardMilestoneResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? progress = null,Object? dueAtUtc = freezed,}) {
  return _then(_ProjectDashboardMilestoneResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MilestoneStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ProjectDashboardResponse {

 String get projectId; String get projectName; Map<String, int> get kanbanColumnCounts; List<ProjectDashboardMilestoneResponse> get milestones; TaskWorkloadResponse get teamWorkload; List<HomeDashboardActivityResponse> get recentActivity; DateTime get generatedAtUtc; bool get isWipLimitExceeded; int get velocityCompletedLast14Days;
/// Create a copy of ProjectDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDashboardResponseCopyWith<ProjectDashboardResponse> get copyWith => _$ProjectDashboardResponseCopyWithImpl<ProjectDashboardResponse>(this as ProjectDashboardResponse, _$identity);

  /// Serializes this ProjectDashboardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDashboardResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&const DeepCollectionEquality().equals(other.kanbanColumnCounts, kanbanColumnCounts)&&const DeepCollectionEquality().equals(other.milestones, milestones)&&(identical(other.teamWorkload, teamWorkload) || other.teamWorkload == teamWorkload)&&const DeepCollectionEquality().equals(other.recentActivity, recentActivity)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&(identical(other.isWipLimitExceeded, isWipLimitExceeded) || other.isWipLimitExceeded == isWipLimitExceeded)&&(identical(other.velocityCompletedLast14Days, velocityCompletedLast14Days) || other.velocityCompletedLast14Days == velocityCompletedLast14Days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,projectName,const DeepCollectionEquality().hash(kanbanColumnCounts),const DeepCollectionEquality().hash(milestones),teamWorkload,const DeepCollectionEquality().hash(recentActivity),generatedAtUtc,isWipLimitExceeded,velocityCompletedLast14Days);

@override
String toString() {
  return 'ProjectDashboardResponse(projectId: $projectId, projectName: $projectName, kanbanColumnCounts: $kanbanColumnCounts, milestones: $milestones, teamWorkload: $teamWorkload, recentActivity: $recentActivity, generatedAtUtc: $generatedAtUtc, isWipLimitExceeded: $isWipLimitExceeded, velocityCompletedLast14Days: $velocityCompletedLast14Days)';
}


}

/// @nodoc
abstract mixin class $ProjectDashboardResponseCopyWith<$Res>  {
  factory $ProjectDashboardResponseCopyWith(ProjectDashboardResponse value, $Res Function(ProjectDashboardResponse) _then) = _$ProjectDashboardResponseCopyWithImpl;
@useResult
$Res call({
 String projectId, String projectName, Map<String, int> kanbanColumnCounts, List<ProjectDashboardMilestoneResponse> milestones, TaskWorkloadResponse teamWorkload, List<HomeDashboardActivityResponse> recentActivity, DateTime generatedAtUtc, bool isWipLimitExceeded, int velocityCompletedLast14Days
});


$TaskWorkloadResponseCopyWith<$Res> get teamWorkload;

}
/// @nodoc
class _$ProjectDashboardResponseCopyWithImpl<$Res>
    implements $ProjectDashboardResponseCopyWith<$Res> {
  _$ProjectDashboardResponseCopyWithImpl(this._self, this._then);

  final ProjectDashboardResponse _self;
  final $Res Function(ProjectDashboardResponse) _then;

/// Create a copy of ProjectDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? projectName = null,Object? kanbanColumnCounts = null,Object? milestones = null,Object? teamWorkload = null,Object? recentActivity = null,Object? generatedAtUtc = null,Object? isWipLimitExceeded = null,Object? velocityCompletedLast14Days = null,}) {
  return _then(_self.copyWith(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,kanbanColumnCounts: null == kanbanColumnCounts ? _self.kanbanColumnCounts : kanbanColumnCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,milestones: null == milestones ? _self.milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<ProjectDashboardMilestoneResponse>,teamWorkload: null == teamWorkload ? _self.teamWorkload : teamWorkload // ignore: cast_nullable_to_non_nullable
as TaskWorkloadResponse,recentActivity: null == recentActivity ? _self.recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardActivityResponse>,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,isWipLimitExceeded: null == isWipLimitExceeded ? _self.isWipLimitExceeded : isWipLimitExceeded // ignore: cast_nullable_to_non_nullable
as bool,velocityCompletedLast14Days: null == velocityCompletedLast14Days ? _self.velocityCompletedLast14Days : velocityCompletedLast14Days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ProjectDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskWorkloadResponseCopyWith<$Res> get teamWorkload {
  
  return $TaskWorkloadResponseCopyWith<$Res>(_self.teamWorkload, (value) {
    return _then(_self.copyWith(teamWorkload: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectDashboardResponse].
extension ProjectDashboardResponsePatterns on ProjectDashboardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectDashboardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectDashboardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectDashboardResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectDashboardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectDashboardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectDashboardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  String projectName,  Map<String, int> kanbanColumnCounts,  List<ProjectDashboardMilestoneResponse> milestones,  TaskWorkloadResponse teamWorkload,  List<HomeDashboardActivityResponse> recentActivity,  DateTime generatedAtUtc,  bool isWipLimitExceeded,  int velocityCompletedLast14Days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectDashboardResponse() when $default != null:
return $default(_that.projectId,_that.projectName,_that.kanbanColumnCounts,_that.milestones,_that.teamWorkload,_that.recentActivity,_that.generatedAtUtc,_that.isWipLimitExceeded,_that.velocityCompletedLast14Days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  String projectName,  Map<String, int> kanbanColumnCounts,  List<ProjectDashboardMilestoneResponse> milestones,  TaskWorkloadResponse teamWorkload,  List<HomeDashboardActivityResponse> recentActivity,  DateTime generatedAtUtc,  bool isWipLimitExceeded,  int velocityCompletedLast14Days)  $default,) {final _that = this;
switch (_that) {
case _ProjectDashboardResponse():
return $default(_that.projectId,_that.projectName,_that.kanbanColumnCounts,_that.milestones,_that.teamWorkload,_that.recentActivity,_that.generatedAtUtc,_that.isWipLimitExceeded,_that.velocityCompletedLast14Days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  String projectName,  Map<String, int> kanbanColumnCounts,  List<ProjectDashboardMilestoneResponse> milestones,  TaskWorkloadResponse teamWorkload,  List<HomeDashboardActivityResponse> recentActivity,  DateTime generatedAtUtc,  bool isWipLimitExceeded,  int velocityCompletedLast14Days)?  $default,) {final _that = this;
switch (_that) {
case _ProjectDashboardResponse() when $default != null:
return $default(_that.projectId,_that.projectName,_that.kanbanColumnCounts,_that.milestones,_that.teamWorkload,_that.recentActivity,_that.generatedAtUtc,_that.isWipLimitExceeded,_that.velocityCompletedLast14Days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectDashboardResponse implements ProjectDashboardResponse {
  const _ProjectDashboardResponse({required this.projectId, required this.projectName, required this.kanbanColumnCounts, required this.milestones, required this.teamWorkload, required this.recentActivity, required this.generatedAtUtc, this.isWipLimitExceeded = false, this.velocityCompletedLast14Days = 0});
  factory _ProjectDashboardResponse.fromJson(Map<String, dynamic> json) => _$ProjectDashboardResponseFromJson(json);

@override final  String projectId;
@override final  String projectName;
@override final  Map<String, int> kanbanColumnCounts;
@override final  List<ProjectDashboardMilestoneResponse> milestones;
@override final  TaskWorkloadResponse teamWorkload;
@override final  List<HomeDashboardActivityResponse> recentActivity;
@override final  DateTime generatedAtUtc;
@override@JsonKey() final  bool isWipLimitExceeded;
@override@JsonKey() final  int velocityCompletedLast14Days;

/// Create a copy of ProjectDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDashboardResponseCopyWith<_ProjectDashboardResponse> get copyWith => __$ProjectDashboardResponseCopyWithImpl<_ProjectDashboardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectDashboardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectDashboardResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&const DeepCollectionEquality().equals(other.kanbanColumnCounts, kanbanColumnCounts)&&const DeepCollectionEquality().equals(other.milestones, milestones)&&(identical(other.teamWorkload, teamWorkload) || other.teamWorkload == teamWorkload)&&const DeepCollectionEquality().equals(other.recentActivity, recentActivity)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&(identical(other.isWipLimitExceeded, isWipLimitExceeded) || other.isWipLimitExceeded == isWipLimitExceeded)&&(identical(other.velocityCompletedLast14Days, velocityCompletedLast14Days) || other.velocityCompletedLast14Days == velocityCompletedLast14Days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,projectName,const DeepCollectionEquality().hash(kanbanColumnCounts),const DeepCollectionEquality().hash(milestones),teamWorkload,const DeepCollectionEquality().hash(recentActivity),generatedAtUtc,isWipLimitExceeded,velocityCompletedLast14Days);

@override
String toString() {
  return 'ProjectDashboardResponse(projectId: $projectId, projectName: $projectName, kanbanColumnCounts: $kanbanColumnCounts, milestones: $milestones, teamWorkload: $teamWorkload, recentActivity: $recentActivity, generatedAtUtc: $generatedAtUtc, isWipLimitExceeded: $isWipLimitExceeded, velocityCompletedLast14Days: $velocityCompletedLast14Days)';
}


}

/// @nodoc
abstract mixin class _$ProjectDashboardResponseCopyWith<$Res> implements $ProjectDashboardResponseCopyWith<$Res> {
  factory _$ProjectDashboardResponseCopyWith(_ProjectDashboardResponse value, $Res Function(_ProjectDashboardResponse) _then) = __$ProjectDashboardResponseCopyWithImpl;
@override @useResult
$Res call({
 String projectId, String projectName, Map<String, int> kanbanColumnCounts, List<ProjectDashboardMilestoneResponse> milestones, TaskWorkloadResponse teamWorkload, List<HomeDashboardActivityResponse> recentActivity, DateTime generatedAtUtc, bool isWipLimitExceeded, int velocityCompletedLast14Days
});


@override $TaskWorkloadResponseCopyWith<$Res> get teamWorkload;

}
/// @nodoc
class __$ProjectDashboardResponseCopyWithImpl<$Res>
    implements _$ProjectDashboardResponseCopyWith<$Res> {
  __$ProjectDashboardResponseCopyWithImpl(this._self, this._then);

  final _ProjectDashboardResponse _self;
  final $Res Function(_ProjectDashboardResponse) _then;

/// Create a copy of ProjectDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? projectName = null,Object? kanbanColumnCounts = null,Object? milestones = null,Object? teamWorkload = null,Object? recentActivity = null,Object? generatedAtUtc = null,Object? isWipLimitExceeded = null,Object? velocityCompletedLast14Days = null,}) {
  return _then(_ProjectDashboardResponse(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,kanbanColumnCounts: null == kanbanColumnCounts ? _self.kanbanColumnCounts : kanbanColumnCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,milestones: null == milestones ? _self.milestones : milestones // ignore: cast_nullable_to_non_nullable
as List<ProjectDashboardMilestoneResponse>,teamWorkload: null == teamWorkload ? _self.teamWorkload : teamWorkload // ignore: cast_nullable_to_non_nullable
as TaskWorkloadResponse,recentActivity: null == recentActivity ? _self.recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<HomeDashboardActivityResponse>,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,isWipLimitExceeded: null == isWipLimitExceeded ? _self.isWipLimitExceeded : isWipLimitExceeded // ignore: cast_nullable_to_non_nullable
as bool,velocityCompletedLast14Days: null == velocityCompletedLast14Days ? _self.velocityCompletedLast14Days : velocityCompletedLast14Days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ProjectDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskWorkloadResponseCopyWith<$Res> get teamWorkload {
  
  return $TaskWorkloadResponseCopyWith<$Res>(_self.teamWorkload, (value) {
    return _then(_self.copyWith(teamWorkload: value));
  });
}
}


/// @nodoc
mixin _$GlobalSearchTaskResult {

 String get id; String get taskCode; String get title; String get status; String get projectId;
/// Create a copy of GlobalSearchTaskResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalSearchTaskResultCopyWith<GlobalSearchTaskResult> get copyWith => _$GlobalSearchTaskResultCopyWithImpl<GlobalSearchTaskResult>(this as GlobalSearchTaskResult, _$identity);

  /// Serializes this GlobalSearchTaskResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalSearchTaskResult&&(identical(other.id, id) || other.id == id)&&(identical(other.taskCode, taskCode) || other.taskCode == taskCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskCode,title,status,projectId);

@override
String toString() {
  return 'GlobalSearchTaskResult(id: $id, taskCode: $taskCode, title: $title, status: $status, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class $GlobalSearchTaskResultCopyWith<$Res>  {
  factory $GlobalSearchTaskResultCopyWith(GlobalSearchTaskResult value, $Res Function(GlobalSearchTaskResult) _then) = _$GlobalSearchTaskResultCopyWithImpl;
@useResult
$Res call({
 String id, String taskCode, String title, String status, String projectId
});




}
/// @nodoc
class _$GlobalSearchTaskResultCopyWithImpl<$Res>
    implements $GlobalSearchTaskResultCopyWith<$Res> {
  _$GlobalSearchTaskResultCopyWithImpl(this._self, this._then);

  final GlobalSearchTaskResult _self;
  final $Res Function(GlobalSearchTaskResult) _then;

/// Create a copy of GlobalSearchTaskResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskCode = null,Object? title = null,Object? status = null,Object? projectId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskCode: null == taskCode ? _self.taskCode : taskCode // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalSearchTaskResult].
extension GlobalSearchTaskResultPatterns on GlobalSearchTaskResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalSearchTaskResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalSearchTaskResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalSearchTaskResult value)  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchTaskResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalSearchTaskResult value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchTaskResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskCode,  String title,  String status,  String projectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalSearchTaskResult() when $default != null:
return $default(_that.id,_that.taskCode,_that.title,_that.status,_that.projectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskCode,  String title,  String status,  String projectId)  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchTaskResult():
return $default(_that.id,_that.taskCode,_that.title,_that.status,_that.projectId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskCode,  String title,  String status,  String projectId)?  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchTaskResult() when $default != null:
return $default(_that.id,_that.taskCode,_that.title,_that.status,_that.projectId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalSearchTaskResult implements GlobalSearchTaskResult {
  const _GlobalSearchTaskResult({required this.id, required this.taskCode, required this.title, required this.status, required this.projectId});
  factory _GlobalSearchTaskResult.fromJson(Map<String, dynamic> json) => _$GlobalSearchTaskResultFromJson(json);

@override final  String id;
@override final  String taskCode;
@override final  String title;
@override final  String status;
@override final  String projectId;

/// Create a copy of GlobalSearchTaskResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalSearchTaskResultCopyWith<_GlobalSearchTaskResult> get copyWith => __$GlobalSearchTaskResultCopyWithImpl<_GlobalSearchTaskResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalSearchTaskResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalSearchTaskResult&&(identical(other.id, id) || other.id == id)&&(identical(other.taskCode, taskCode) || other.taskCode == taskCode)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskCode,title,status,projectId);

@override
String toString() {
  return 'GlobalSearchTaskResult(id: $id, taskCode: $taskCode, title: $title, status: $status, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class _$GlobalSearchTaskResultCopyWith<$Res> implements $GlobalSearchTaskResultCopyWith<$Res> {
  factory _$GlobalSearchTaskResultCopyWith(_GlobalSearchTaskResult value, $Res Function(_GlobalSearchTaskResult) _then) = __$GlobalSearchTaskResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskCode, String title, String status, String projectId
});




}
/// @nodoc
class __$GlobalSearchTaskResultCopyWithImpl<$Res>
    implements _$GlobalSearchTaskResultCopyWith<$Res> {
  __$GlobalSearchTaskResultCopyWithImpl(this._self, this._then);

  final _GlobalSearchTaskResult _self;
  final $Res Function(_GlobalSearchTaskResult) _then;

/// Create a copy of GlobalSearchTaskResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskCode = null,Object? title = null,Object? status = null,Object? projectId = null,}) {
  return _then(_GlobalSearchTaskResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskCode: null == taskCode ? _self.taskCode : taskCode // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GlobalSearchProjectResult {

 String get id; String get name; String? get description; String get status;
/// Create a copy of GlobalSearchProjectResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalSearchProjectResultCopyWith<GlobalSearchProjectResult> get copyWith => _$GlobalSearchProjectResultCopyWithImpl<GlobalSearchProjectResult>(this as GlobalSearchProjectResult, _$identity);

  /// Serializes this GlobalSearchProjectResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalSearchProjectResult&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,status);

@override
String toString() {
  return 'GlobalSearchProjectResult(id: $id, name: $name, description: $description, status: $status)';
}


}

/// @nodoc
abstract mixin class $GlobalSearchProjectResultCopyWith<$Res>  {
  factory $GlobalSearchProjectResultCopyWith(GlobalSearchProjectResult value, $Res Function(GlobalSearchProjectResult) _then) = _$GlobalSearchProjectResultCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String status
});




}
/// @nodoc
class _$GlobalSearchProjectResultCopyWithImpl<$Res>
    implements $GlobalSearchProjectResultCopyWith<$Res> {
  _$GlobalSearchProjectResultCopyWithImpl(this._self, this._then);

  final GlobalSearchProjectResult _self;
  final $Res Function(GlobalSearchProjectResult) _then;

/// Create a copy of GlobalSearchProjectResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalSearchProjectResult].
extension GlobalSearchProjectResultPatterns on GlobalSearchProjectResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalSearchProjectResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalSearchProjectResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalSearchProjectResult value)  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchProjectResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalSearchProjectResult value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchProjectResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalSearchProjectResult() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String status)  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchProjectResult():
return $default(_that.id,_that.name,_that.description,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String status)?  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchProjectResult() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalSearchProjectResult implements GlobalSearchProjectResult {
  const _GlobalSearchProjectResult({required this.id, required this.name, this.description, required this.status});
  factory _GlobalSearchProjectResult.fromJson(Map<String, dynamic> json) => _$GlobalSearchProjectResultFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String status;

/// Create a copy of GlobalSearchProjectResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalSearchProjectResultCopyWith<_GlobalSearchProjectResult> get copyWith => __$GlobalSearchProjectResultCopyWithImpl<_GlobalSearchProjectResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalSearchProjectResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalSearchProjectResult&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,status);

@override
String toString() {
  return 'GlobalSearchProjectResult(id: $id, name: $name, description: $description, status: $status)';
}


}

/// @nodoc
abstract mixin class _$GlobalSearchProjectResultCopyWith<$Res> implements $GlobalSearchProjectResultCopyWith<$Res> {
  factory _$GlobalSearchProjectResultCopyWith(_GlobalSearchProjectResult value, $Res Function(_GlobalSearchProjectResult) _then) = __$GlobalSearchProjectResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String status
});




}
/// @nodoc
class __$GlobalSearchProjectResultCopyWithImpl<$Res>
    implements _$GlobalSearchProjectResultCopyWith<$Res> {
  __$GlobalSearchProjectResultCopyWithImpl(this._self, this._then);

  final _GlobalSearchProjectResult _self;
  final $Res Function(_GlobalSearchProjectResult) _then;

/// Create a copy of GlobalSearchProjectResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? status = null,}) {
  return _then(_GlobalSearchProjectResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GlobalSearchWikiResult {

 String get id; String? get projectId; String get title; bool get isVerified;
/// Create a copy of GlobalSearchWikiResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalSearchWikiResultCopyWith<GlobalSearchWikiResult> get copyWith => _$GlobalSearchWikiResultCopyWithImpl<GlobalSearchWikiResult>(this as GlobalSearchWikiResult, _$identity);

  /// Serializes this GlobalSearchWikiResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalSearchWikiResult&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,title,isVerified);

@override
String toString() {
  return 'GlobalSearchWikiResult(id: $id, projectId: $projectId, title: $title, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $GlobalSearchWikiResultCopyWith<$Res>  {
  factory $GlobalSearchWikiResultCopyWith(GlobalSearchWikiResult value, $Res Function(GlobalSearchWikiResult) _then) = _$GlobalSearchWikiResultCopyWithImpl;
@useResult
$Res call({
 String id, String? projectId, String title, bool isVerified
});




}
/// @nodoc
class _$GlobalSearchWikiResultCopyWithImpl<$Res>
    implements $GlobalSearchWikiResultCopyWith<$Res> {
  _$GlobalSearchWikiResultCopyWithImpl(this._self, this._then);

  final GlobalSearchWikiResult _self;
  final $Res Function(GlobalSearchWikiResult) _then;

/// Create a copy of GlobalSearchWikiResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = freezed,Object? title = null,Object? isVerified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalSearchWikiResult].
extension GlobalSearchWikiResultPatterns on GlobalSearchWikiResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalSearchWikiResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalSearchWikiResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalSearchWikiResult value)  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchWikiResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalSearchWikiResult value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchWikiResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? projectId,  String title,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalSearchWikiResult() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.isVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? projectId,  String title,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchWikiResult():
return $default(_that.id,_that.projectId,_that.title,_that.isVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? projectId,  String title,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchWikiResult() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalSearchWikiResult implements GlobalSearchWikiResult {
  const _GlobalSearchWikiResult({required this.id, this.projectId, required this.title, required this.isVerified});
  factory _GlobalSearchWikiResult.fromJson(Map<String, dynamic> json) => _$GlobalSearchWikiResultFromJson(json);

@override final  String id;
@override final  String? projectId;
@override final  String title;
@override final  bool isVerified;

/// Create a copy of GlobalSearchWikiResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalSearchWikiResultCopyWith<_GlobalSearchWikiResult> get copyWith => __$GlobalSearchWikiResultCopyWithImpl<_GlobalSearchWikiResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalSearchWikiResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalSearchWikiResult&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,title,isVerified);

@override
String toString() {
  return 'GlobalSearchWikiResult(id: $id, projectId: $projectId, title: $title, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$GlobalSearchWikiResultCopyWith<$Res> implements $GlobalSearchWikiResultCopyWith<$Res> {
  factory _$GlobalSearchWikiResultCopyWith(_GlobalSearchWikiResult value, $Res Function(_GlobalSearchWikiResult) _then) = __$GlobalSearchWikiResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String? projectId, String title, bool isVerified
});




}
/// @nodoc
class __$GlobalSearchWikiResultCopyWithImpl<$Res>
    implements _$GlobalSearchWikiResultCopyWith<$Res> {
  __$GlobalSearchWikiResultCopyWithImpl(this._self, this._then);

  final _GlobalSearchWikiResult _self;
  final $Res Function(_GlobalSearchWikiResult) _then;

/// Create a copy of GlobalSearchWikiResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = freezed,Object? title = null,Object? isVerified = null,}) {
  return _then(_GlobalSearchWikiResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$GlobalSearchFileResult {

 String get id; String? get projectId; String get name; String get mimeType;
/// Create a copy of GlobalSearchFileResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalSearchFileResultCopyWith<GlobalSearchFileResult> get copyWith => _$GlobalSearchFileResultCopyWithImpl<GlobalSearchFileResult>(this as GlobalSearchFileResult, _$identity);

  /// Serializes this GlobalSearchFileResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalSearchFileResult&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name,mimeType);

@override
String toString() {
  return 'GlobalSearchFileResult(id: $id, projectId: $projectId, name: $name, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class $GlobalSearchFileResultCopyWith<$Res>  {
  factory $GlobalSearchFileResultCopyWith(GlobalSearchFileResult value, $Res Function(GlobalSearchFileResult) _then) = _$GlobalSearchFileResultCopyWithImpl;
@useResult
$Res call({
 String id, String? projectId, String name, String mimeType
});




}
/// @nodoc
class _$GlobalSearchFileResultCopyWithImpl<$Res>
    implements $GlobalSearchFileResultCopyWith<$Res> {
  _$GlobalSearchFileResultCopyWithImpl(this._self, this._then);

  final GlobalSearchFileResult _self;
  final $Res Function(GlobalSearchFileResult) _then;

/// Create a copy of GlobalSearchFileResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = freezed,Object? name = null,Object? mimeType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalSearchFileResult].
extension GlobalSearchFileResultPatterns on GlobalSearchFileResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalSearchFileResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalSearchFileResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalSearchFileResult value)  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchFileResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalSearchFileResult value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchFileResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? projectId,  String name,  String mimeType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalSearchFileResult() when $default != null:
return $default(_that.id,_that.projectId,_that.name,_that.mimeType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? projectId,  String name,  String mimeType)  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchFileResult():
return $default(_that.id,_that.projectId,_that.name,_that.mimeType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? projectId,  String name,  String mimeType)?  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchFileResult() when $default != null:
return $default(_that.id,_that.projectId,_that.name,_that.mimeType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalSearchFileResult implements GlobalSearchFileResult {
  const _GlobalSearchFileResult({required this.id, this.projectId, required this.name, required this.mimeType});
  factory _GlobalSearchFileResult.fromJson(Map<String, dynamic> json) => _$GlobalSearchFileResultFromJson(json);

@override final  String id;
@override final  String? projectId;
@override final  String name;
@override final  String mimeType;

/// Create a copy of GlobalSearchFileResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalSearchFileResultCopyWith<_GlobalSearchFileResult> get copyWith => __$GlobalSearchFileResultCopyWithImpl<_GlobalSearchFileResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalSearchFileResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalSearchFileResult&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name,mimeType);

@override
String toString() {
  return 'GlobalSearchFileResult(id: $id, projectId: $projectId, name: $name, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class _$GlobalSearchFileResultCopyWith<$Res> implements $GlobalSearchFileResultCopyWith<$Res> {
  factory _$GlobalSearchFileResultCopyWith(_GlobalSearchFileResult value, $Res Function(_GlobalSearchFileResult) _then) = __$GlobalSearchFileResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String? projectId, String name, String mimeType
});




}
/// @nodoc
class __$GlobalSearchFileResultCopyWithImpl<$Res>
    implements _$GlobalSearchFileResultCopyWith<$Res> {
  __$GlobalSearchFileResultCopyWithImpl(this._self, this._then);

  final _GlobalSearchFileResult _self;
  final $Res Function(_GlobalSearchFileResult) _then;

/// Create a copy of GlobalSearchFileResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = freezed,Object? name = null,Object? mimeType = null,}) {
  return _then(_GlobalSearchFileResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GlobalSearchWhiteboardResult {

 String get id; String get projectId; String get name;
/// Create a copy of GlobalSearchWhiteboardResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalSearchWhiteboardResultCopyWith<GlobalSearchWhiteboardResult> get copyWith => _$GlobalSearchWhiteboardResultCopyWithImpl<GlobalSearchWhiteboardResult>(this as GlobalSearchWhiteboardResult, _$identity);

  /// Serializes this GlobalSearchWhiteboardResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalSearchWhiteboardResult&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name);

@override
String toString() {
  return 'GlobalSearchWhiteboardResult(id: $id, projectId: $projectId, name: $name)';
}


}

/// @nodoc
abstract mixin class $GlobalSearchWhiteboardResultCopyWith<$Res>  {
  factory $GlobalSearchWhiteboardResultCopyWith(GlobalSearchWhiteboardResult value, $Res Function(GlobalSearchWhiteboardResult) _then) = _$GlobalSearchWhiteboardResultCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String name
});




}
/// @nodoc
class _$GlobalSearchWhiteboardResultCopyWithImpl<$Res>
    implements $GlobalSearchWhiteboardResultCopyWith<$Res> {
  _$GlobalSearchWhiteboardResultCopyWithImpl(this._self, this._then);

  final GlobalSearchWhiteboardResult _self;
  final $Res Function(GlobalSearchWhiteboardResult) _then;

/// Create a copy of GlobalSearchWhiteboardResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalSearchWhiteboardResult].
extension GlobalSearchWhiteboardResultPatterns on GlobalSearchWhiteboardResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalSearchWhiteboardResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalSearchWhiteboardResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalSearchWhiteboardResult value)  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchWhiteboardResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalSearchWhiteboardResult value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchWhiteboardResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalSearchWhiteboardResult() when $default != null:
return $default(_that.id,_that.projectId,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String name)  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchWhiteboardResult():
return $default(_that.id,_that.projectId,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String name)?  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchWhiteboardResult() when $default != null:
return $default(_that.id,_that.projectId,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalSearchWhiteboardResult implements GlobalSearchWhiteboardResult {
  const _GlobalSearchWhiteboardResult({required this.id, required this.projectId, required this.name});
  factory _GlobalSearchWhiteboardResult.fromJson(Map<String, dynamic> json) => _$GlobalSearchWhiteboardResultFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  String name;

/// Create a copy of GlobalSearchWhiteboardResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalSearchWhiteboardResultCopyWith<_GlobalSearchWhiteboardResult> get copyWith => __$GlobalSearchWhiteboardResultCopyWithImpl<_GlobalSearchWhiteboardResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalSearchWhiteboardResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalSearchWhiteboardResult&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name);

@override
String toString() {
  return 'GlobalSearchWhiteboardResult(id: $id, projectId: $projectId, name: $name)';
}


}

/// @nodoc
abstract mixin class _$GlobalSearchWhiteboardResultCopyWith<$Res> implements $GlobalSearchWhiteboardResultCopyWith<$Res> {
  factory _$GlobalSearchWhiteboardResultCopyWith(_GlobalSearchWhiteboardResult value, $Res Function(_GlobalSearchWhiteboardResult) _then) = __$GlobalSearchWhiteboardResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String name
});




}
/// @nodoc
class __$GlobalSearchWhiteboardResultCopyWithImpl<$Res>
    implements _$GlobalSearchWhiteboardResultCopyWith<$Res> {
  __$GlobalSearchWhiteboardResultCopyWithImpl(this._self, this._then);

  final _GlobalSearchWhiteboardResult _self;
  final $Res Function(_GlobalSearchWhiteboardResult) _then;

/// Create a copy of GlobalSearchWhiteboardResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? name = null,}) {
  return _then(_GlobalSearchWhiteboardResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GlobalSearchChatResult {

 String get messageId; String get conversationId; String get authorCoreUserId; String? get conversationName; String get snippet; DateTime get createdAtUtc;
/// Create a copy of GlobalSearchChatResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalSearchChatResultCopyWith<GlobalSearchChatResult> get copyWith => _$GlobalSearchChatResultCopyWithImpl<GlobalSearchChatResult>(this as GlobalSearchChatResult, _$identity);

  /// Serializes this GlobalSearchChatResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalSearchChatResult&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.authorCoreUserId, authorCoreUserId) || other.authorCoreUserId == authorCoreUserId)&&(identical(other.conversationName, conversationName) || other.conversationName == conversationName)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,conversationId,authorCoreUserId,conversationName,snippet,createdAtUtc);

@override
String toString() {
  return 'GlobalSearchChatResult(messageId: $messageId, conversationId: $conversationId, authorCoreUserId: $authorCoreUserId, conversationName: $conversationName, snippet: $snippet, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $GlobalSearchChatResultCopyWith<$Res>  {
  factory $GlobalSearchChatResultCopyWith(GlobalSearchChatResult value, $Res Function(GlobalSearchChatResult) _then) = _$GlobalSearchChatResultCopyWithImpl;
@useResult
$Res call({
 String messageId, String conversationId, String authorCoreUserId, String? conversationName, String snippet, DateTime createdAtUtc
});




}
/// @nodoc
class _$GlobalSearchChatResultCopyWithImpl<$Res>
    implements $GlobalSearchChatResultCopyWith<$Res> {
  _$GlobalSearchChatResultCopyWithImpl(this._self, this._then);

  final GlobalSearchChatResult _self;
  final $Res Function(GlobalSearchChatResult) _then;

/// Create a copy of GlobalSearchChatResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? conversationId = null,Object? authorCoreUserId = null,Object? conversationName = freezed,Object? snippet = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,authorCoreUserId: null == authorCoreUserId ? _self.authorCoreUserId : authorCoreUserId // ignore: cast_nullable_to_non_nullable
as String,conversationName: freezed == conversationName ? _self.conversationName : conversationName // ignore: cast_nullable_to_non_nullable
as String?,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalSearchChatResult].
extension GlobalSearchChatResultPatterns on GlobalSearchChatResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalSearchChatResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalSearchChatResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalSearchChatResult value)  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchChatResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalSearchChatResult value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchChatResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String messageId,  String conversationId,  String authorCoreUserId,  String? conversationName,  String snippet,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalSearchChatResult() when $default != null:
return $default(_that.messageId,_that.conversationId,_that.authorCoreUserId,_that.conversationName,_that.snippet,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String messageId,  String conversationId,  String authorCoreUserId,  String? conversationName,  String snippet,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchChatResult():
return $default(_that.messageId,_that.conversationId,_that.authorCoreUserId,_that.conversationName,_that.snippet,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String messageId,  String conversationId,  String authorCoreUserId,  String? conversationName,  String snippet,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchChatResult() when $default != null:
return $default(_that.messageId,_that.conversationId,_that.authorCoreUserId,_that.conversationName,_that.snippet,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalSearchChatResult implements GlobalSearchChatResult {
  const _GlobalSearchChatResult({required this.messageId, required this.conversationId, required this.authorCoreUserId, this.conversationName, required this.snippet, required this.createdAtUtc});
  factory _GlobalSearchChatResult.fromJson(Map<String, dynamic> json) => _$GlobalSearchChatResultFromJson(json);

@override final  String messageId;
@override final  String conversationId;
@override final  String authorCoreUserId;
@override final  String? conversationName;
@override final  String snippet;
@override final  DateTime createdAtUtc;

/// Create a copy of GlobalSearchChatResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalSearchChatResultCopyWith<_GlobalSearchChatResult> get copyWith => __$GlobalSearchChatResultCopyWithImpl<_GlobalSearchChatResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalSearchChatResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalSearchChatResult&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.authorCoreUserId, authorCoreUserId) || other.authorCoreUserId == authorCoreUserId)&&(identical(other.conversationName, conversationName) || other.conversationName == conversationName)&&(identical(other.snippet, snippet) || other.snippet == snippet)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,conversationId,authorCoreUserId,conversationName,snippet,createdAtUtc);

@override
String toString() {
  return 'GlobalSearchChatResult(messageId: $messageId, conversationId: $conversationId, authorCoreUserId: $authorCoreUserId, conversationName: $conversationName, snippet: $snippet, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$GlobalSearchChatResultCopyWith<$Res> implements $GlobalSearchChatResultCopyWith<$Res> {
  factory _$GlobalSearchChatResultCopyWith(_GlobalSearchChatResult value, $Res Function(_GlobalSearchChatResult) _then) = __$GlobalSearchChatResultCopyWithImpl;
@override @useResult
$Res call({
 String messageId, String conversationId, String authorCoreUserId, String? conversationName, String snippet, DateTime createdAtUtc
});




}
/// @nodoc
class __$GlobalSearchChatResultCopyWithImpl<$Res>
    implements _$GlobalSearchChatResultCopyWith<$Res> {
  __$GlobalSearchChatResultCopyWithImpl(this._self, this._then);

  final _GlobalSearchChatResult _self;
  final $Res Function(_GlobalSearchChatResult) _then;

/// Create a copy of GlobalSearchChatResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? conversationId = null,Object? authorCoreUserId = null,Object? conversationName = freezed,Object? snippet = null,Object? createdAtUtc = null,}) {
  return _then(_GlobalSearchChatResult(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,authorCoreUserId: null == authorCoreUserId ? _self.authorCoreUserId : authorCoreUserId // ignore: cast_nullable_to_non_nullable
as String,conversationName: freezed == conversationName ? _self.conversationName : conversationName // ignore: cast_nullable_to_non_nullable
as String?,snippet: null == snippet ? _self.snippet : snippet // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$GlobalSearchResponse {

 String get query; List<GlobalSearchTaskResult> get tasks; List<GlobalSearchProjectResult> get projects; List<GlobalSearchWikiResult> get wikiPages; List<GlobalSearchFileResult> get files; List<GlobalSearchWhiteboardResult> get whiteboards; List<GlobalSearchChatResult> get chatMessages;
/// Create a copy of GlobalSearchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalSearchResponseCopyWith<GlobalSearchResponse> get copyWith => _$GlobalSearchResponseCopyWithImpl<GlobalSearchResponse>(this as GlobalSearchResponse, _$identity);

  /// Serializes this GlobalSearchResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalSearchResponse&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&const DeepCollectionEquality().equals(other.projects, projects)&&const DeepCollectionEquality().equals(other.wikiPages, wikiPages)&&const DeepCollectionEquality().equals(other.files, files)&&const DeepCollectionEquality().equals(other.whiteboards, whiteboards)&&const DeepCollectionEquality().equals(other.chatMessages, chatMessages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(tasks),const DeepCollectionEquality().hash(projects),const DeepCollectionEquality().hash(wikiPages),const DeepCollectionEquality().hash(files),const DeepCollectionEquality().hash(whiteboards),const DeepCollectionEquality().hash(chatMessages));

@override
String toString() {
  return 'GlobalSearchResponse(query: $query, tasks: $tasks, projects: $projects, wikiPages: $wikiPages, files: $files, whiteboards: $whiteboards, chatMessages: $chatMessages)';
}


}

/// @nodoc
abstract mixin class $GlobalSearchResponseCopyWith<$Res>  {
  factory $GlobalSearchResponseCopyWith(GlobalSearchResponse value, $Res Function(GlobalSearchResponse) _then) = _$GlobalSearchResponseCopyWithImpl;
@useResult
$Res call({
 String query, List<GlobalSearchTaskResult> tasks, List<GlobalSearchProjectResult> projects, List<GlobalSearchWikiResult> wikiPages, List<GlobalSearchFileResult> files, List<GlobalSearchWhiteboardResult> whiteboards, List<GlobalSearchChatResult> chatMessages
});




}
/// @nodoc
class _$GlobalSearchResponseCopyWithImpl<$Res>
    implements $GlobalSearchResponseCopyWith<$Res> {
  _$GlobalSearchResponseCopyWithImpl(this._self, this._then);

  final GlobalSearchResponse _self;
  final $Res Function(GlobalSearchResponse) _then;

/// Create a copy of GlobalSearchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? tasks = null,Object? projects = null,Object? wikiPages = null,Object? files = null,Object? whiteboards = null,Object? chatMessages = null,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchTaskResult>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchProjectResult>,wikiPages: null == wikiPages ? _self.wikiPages : wikiPages // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchWikiResult>,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchFileResult>,whiteboards: null == whiteboards ? _self.whiteboards : whiteboards // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchWhiteboardResult>,chatMessages: null == chatMessages ? _self.chatMessages : chatMessages // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchChatResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalSearchResponse].
extension GlobalSearchResponsePatterns on GlobalSearchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalSearchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalSearchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalSearchResponse value)  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalSearchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalSearchResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  List<GlobalSearchTaskResult> tasks,  List<GlobalSearchProjectResult> projects,  List<GlobalSearchWikiResult> wikiPages,  List<GlobalSearchFileResult> files,  List<GlobalSearchWhiteboardResult> whiteboards,  List<GlobalSearchChatResult> chatMessages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalSearchResponse() when $default != null:
return $default(_that.query,_that.tasks,_that.projects,_that.wikiPages,_that.files,_that.whiteboards,_that.chatMessages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  List<GlobalSearchTaskResult> tasks,  List<GlobalSearchProjectResult> projects,  List<GlobalSearchWikiResult> wikiPages,  List<GlobalSearchFileResult> files,  List<GlobalSearchWhiteboardResult> whiteboards,  List<GlobalSearchChatResult> chatMessages)  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchResponse():
return $default(_that.query,_that.tasks,_that.projects,_that.wikiPages,_that.files,_that.whiteboards,_that.chatMessages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  List<GlobalSearchTaskResult> tasks,  List<GlobalSearchProjectResult> projects,  List<GlobalSearchWikiResult> wikiPages,  List<GlobalSearchFileResult> files,  List<GlobalSearchWhiteboardResult> whiteboards,  List<GlobalSearchChatResult> chatMessages)?  $default,) {final _that = this;
switch (_that) {
case _GlobalSearchResponse() when $default != null:
return $default(_that.query,_that.tasks,_that.projects,_that.wikiPages,_that.files,_that.whiteboards,_that.chatMessages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalSearchResponse implements GlobalSearchResponse {
  const _GlobalSearchResponse({required this.query, required this.tasks, required this.projects, required this.wikiPages, required this.files, required this.whiteboards, required this.chatMessages});
  factory _GlobalSearchResponse.fromJson(Map<String, dynamic> json) => _$GlobalSearchResponseFromJson(json);

@override final  String query;
@override final  List<GlobalSearchTaskResult> tasks;
@override final  List<GlobalSearchProjectResult> projects;
@override final  List<GlobalSearchWikiResult> wikiPages;
@override final  List<GlobalSearchFileResult> files;
@override final  List<GlobalSearchWhiteboardResult> whiteboards;
@override final  List<GlobalSearchChatResult> chatMessages;

/// Create a copy of GlobalSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalSearchResponseCopyWith<_GlobalSearchResponse> get copyWith => __$GlobalSearchResponseCopyWithImpl<_GlobalSearchResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalSearchResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalSearchResponse&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&const DeepCollectionEquality().equals(other.projects, projects)&&const DeepCollectionEquality().equals(other.wikiPages, wikiPages)&&const DeepCollectionEquality().equals(other.files, files)&&const DeepCollectionEquality().equals(other.whiteboards, whiteboards)&&const DeepCollectionEquality().equals(other.chatMessages, chatMessages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(tasks),const DeepCollectionEquality().hash(projects),const DeepCollectionEquality().hash(wikiPages),const DeepCollectionEquality().hash(files),const DeepCollectionEquality().hash(whiteboards),const DeepCollectionEquality().hash(chatMessages));

@override
String toString() {
  return 'GlobalSearchResponse(query: $query, tasks: $tasks, projects: $projects, wikiPages: $wikiPages, files: $files, whiteboards: $whiteboards, chatMessages: $chatMessages)';
}


}

/// @nodoc
abstract mixin class _$GlobalSearchResponseCopyWith<$Res> implements $GlobalSearchResponseCopyWith<$Res> {
  factory _$GlobalSearchResponseCopyWith(_GlobalSearchResponse value, $Res Function(_GlobalSearchResponse) _then) = __$GlobalSearchResponseCopyWithImpl;
@override @useResult
$Res call({
 String query, List<GlobalSearchTaskResult> tasks, List<GlobalSearchProjectResult> projects, List<GlobalSearchWikiResult> wikiPages, List<GlobalSearchFileResult> files, List<GlobalSearchWhiteboardResult> whiteboards, List<GlobalSearchChatResult> chatMessages
});




}
/// @nodoc
class __$GlobalSearchResponseCopyWithImpl<$Res>
    implements _$GlobalSearchResponseCopyWith<$Res> {
  __$GlobalSearchResponseCopyWithImpl(this._self, this._then);

  final _GlobalSearchResponse _self;
  final $Res Function(_GlobalSearchResponse) _then;

/// Create a copy of GlobalSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? tasks = null,Object? projects = null,Object? wikiPages = null,Object? files = null,Object? whiteboards = null,Object? chatMessages = null,}) {
  return _then(_GlobalSearchResponse(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchTaskResult>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchProjectResult>,wikiPages: null == wikiPages ? _self.wikiPages : wikiPages // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchWikiResult>,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchFileResult>,whiteboards: null == whiteboards ? _self.whiteboards : whiteboards // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchWhiteboardResult>,chatMessages: null == chatMessages ? _self.chatMessages : chatMessages // ignore: cast_nullable_to_non_nullable
as List<GlobalSearchChatResult>,
  ));
}


}

// dart format on
