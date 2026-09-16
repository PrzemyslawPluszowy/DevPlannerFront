// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkspaceNotificationResponse {

 String get id; String get sourceModule; String get eventType; String get entityType; String get entityId; String? get workspaceId; String get title; String get body; String? get deepLink; String get eventId; int get contractVersion; DateTime get createdAtUtc; DateTime? get readAtUtc; bool get isPinned; DateTime? get pinnedAtUtc; NotificationCategory get category; String? get groupKey; String? get metadataJson; NotificationPriority get priority; bool get digestOnly;
/// Create a copy of WorkspaceNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceNotificationResponseCopyWith<WorkspaceNotificationResponse> get copyWith => _$WorkspaceNotificationResponseCopyWithImpl<WorkspaceNotificationResponse>(this as WorkspaceNotificationResponse, _$identity);

  /// Serializes this WorkspaceNotificationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceNotificationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.readAtUtc, readAtUtc) || other.readAtUtc == readAtUtc)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.pinnedAtUtc, pinnedAtUtc) || other.pinnedAtUtc == pinnedAtUtc)&&(identical(other.category, category) || other.category == category)&&(identical(other.groupKey, groupKey) || other.groupKey == groupKey)&&(identical(other.metadataJson, metadataJson) || other.metadataJson == metadataJson)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.digestOnly, digestOnly) || other.digestOnly == digestOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,sourceModule,eventType,entityType,entityId,workspaceId,title,body,deepLink,eventId,contractVersion,createdAtUtc,readAtUtc,isPinned,pinnedAtUtc,category,groupKey,metadataJson,priority,digestOnly]);

@override
String toString() {
  return 'WorkspaceNotificationResponse(id: $id, sourceModule: $sourceModule, eventType: $eventType, entityType: $entityType, entityId: $entityId, workspaceId: $workspaceId, title: $title, body: $body, deepLink: $deepLink, eventId: $eventId, contractVersion: $contractVersion, createdAtUtc: $createdAtUtc, readAtUtc: $readAtUtc, isPinned: $isPinned, pinnedAtUtc: $pinnedAtUtc, category: $category, groupKey: $groupKey, metadataJson: $metadataJson, priority: $priority, digestOnly: $digestOnly)';
}


}

/// @nodoc
abstract mixin class $WorkspaceNotificationResponseCopyWith<$Res>  {
  factory $WorkspaceNotificationResponseCopyWith(WorkspaceNotificationResponse value, $Res Function(WorkspaceNotificationResponse) _then) = _$WorkspaceNotificationResponseCopyWithImpl;
@useResult
$Res call({
 String id, String sourceModule, String eventType, String entityType, String entityId, String? workspaceId, String title, String body, String? deepLink, String eventId, int contractVersion, DateTime createdAtUtc, DateTime? readAtUtc, bool isPinned, DateTime? pinnedAtUtc, NotificationCategory category, String? groupKey, String? metadataJson, NotificationPriority priority, bool digestOnly
});




}
/// @nodoc
class _$WorkspaceNotificationResponseCopyWithImpl<$Res>
    implements $WorkspaceNotificationResponseCopyWith<$Res> {
  _$WorkspaceNotificationResponseCopyWithImpl(this._self, this._then);

  final WorkspaceNotificationResponse _self;
  final $Res Function(WorkspaceNotificationResponse) _then;

/// Create a copy of WorkspaceNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceModule = null,Object? eventType = null,Object? entityType = null,Object? entityId = null,Object? workspaceId = freezed,Object? title = null,Object? body = null,Object? deepLink = freezed,Object? eventId = null,Object? contractVersion = null,Object? createdAtUtc = null,Object? readAtUtc = freezed,Object? isPinned = null,Object? pinnedAtUtc = freezed,Object? category = null,Object? groupKey = freezed,Object? metadataJson = freezed,Object? priority = null,Object? digestOnly = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,readAtUtc: freezed == readAtUtc ? _self.readAtUtc : readAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,pinnedAtUtc: freezed == pinnedAtUtc ? _self.pinnedAtUtc : pinnedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as NotificationCategory,groupKey: freezed == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String?,metadataJson: freezed == metadataJson ? _self.metadataJson : metadataJson // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as NotificationPriority,digestOnly: null == digestOnly ? _self.digestOnly : digestOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceNotificationResponse].
extension WorkspaceNotificationResponsePatterns on WorkspaceNotificationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceNotificationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceNotificationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceNotificationResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceNotificationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceNotificationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceNotificationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceModule,  String eventType,  String entityType,  String entityId,  String? workspaceId,  String title,  String body,  String? deepLink,  String eventId,  int contractVersion,  DateTime createdAtUtc,  DateTime? readAtUtc,  bool isPinned,  DateTime? pinnedAtUtc,  NotificationCategory category,  String? groupKey,  String? metadataJson,  NotificationPriority priority,  bool digestOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceNotificationResponse() when $default != null:
return $default(_that.id,_that.sourceModule,_that.eventType,_that.entityType,_that.entityId,_that.workspaceId,_that.title,_that.body,_that.deepLink,_that.eventId,_that.contractVersion,_that.createdAtUtc,_that.readAtUtc,_that.isPinned,_that.pinnedAtUtc,_that.category,_that.groupKey,_that.metadataJson,_that.priority,_that.digestOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceModule,  String eventType,  String entityType,  String entityId,  String? workspaceId,  String title,  String body,  String? deepLink,  String eventId,  int contractVersion,  DateTime createdAtUtc,  DateTime? readAtUtc,  bool isPinned,  DateTime? pinnedAtUtc,  NotificationCategory category,  String? groupKey,  String? metadataJson,  NotificationPriority priority,  bool digestOnly)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceNotificationResponse():
return $default(_that.id,_that.sourceModule,_that.eventType,_that.entityType,_that.entityId,_that.workspaceId,_that.title,_that.body,_that.deepLink,_that.eventId,_that.contractVersion,_that.createdAtUtc,_that.readAtUtc,_that.isPinned,_that.pinnedAtUtc,_that.category,_that.groupKey,_that.metadataJson,_that.priority,_that.digestOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceModule,  String eventType,  String entityType,  String entityId,  String? workspaceId,  String title,  String body,  String? deepLink,  String eventId,  int contractVersion,  DateTime createdAtUtc,  DateTime? readAtUtc,  bool isPinned,  DateTime? pinnedAtUtc,  NotificationCategory category,  String? groupKey,  String? metadataJson,  NotificationPriority priority,  bool digestOnly)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceNotificationResponse() when $default != null:
return $default(_that.id,_that.sourceModule,_that.eventType,_that.entityType,_that.entityId,_that.workspaceId,_that.title,_that.body,_that.deepLink,_that.eventId,_that.contractVersion,_that.createdAtUtc,_that.readAtUtc,_that.isPinned,_that.pinnedAtUtc,_that.category,_that.groupKey,_that.metadataJson,_that.priority,_that.digestOnly);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceNotificationResponse implements WorkspaceNotificationResponse {
  const _WorkspaceNotificationResponse({required this.id, required this.sourceModule, required this.eventType, required this.entityType, required this.entityId, this.workspaceId, required this.title, required this.body, this.deepLink, required this.eventId, required this.contractVersion, required this.createdAtUtc, this.readAtUtc, required this.isPinned, this.pinnedAtUtc, required this.category, this.groupKey, this.metadataJson, required this.priority, this.digestOnly = false});
  factory _WorkspaceNotificationResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceNotificationResponseFromJson(json);

@override final  String id;
@override final  String sourceModule;
@override final  String eventType;
@override final  String entityType;
@override final  String entityId;
@override final  String? workspaceId;
@override final  String title;
@override final  String body;
@override final  String? deepLink;
@override final  String eventId;
@override final  int contractVersion;
@override final  DateTime createdAtUtc;
@override final  DateTime? readAtUtc;
@override final  bool isPinned;
@override final  DateTime? pinnedAtUtc;
@override final  NotificationCategory category;
@override final  String? groupKey;
@override final  String? metadataJson;
@override final  NotificationPriority priority;
@override@JsonKey() final  bool digestOnly;

/// Create a copy of WorkspaceNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceNotificationResponseCopyWith<_WorkspaceNotificationResponse> get copyWith => __$WorkspaceNotificationResponseCopyWithImpl<_WorkspaceNotificationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceNotificationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceNotificationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.readAtUtc, readAtUtc) || other.readAtUtc == readAtUtc)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.pinnedAtUtc, pinnedAtUtc) || other.pinnedAtUtc == pinnedAtUtc)&&(identical(other.category, category) || other.category == category)&&(identical(other.groupKey, groupKey) || other.groupKey == groupKey)&&(identical(other.metadataJson, metadataJson) || other.metadataJson == metadataJson)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.digestOnly, digestOnly) || other.digestOnly == digestOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,sourceModule,eventType,entityType,entityId,workspaceId,title,body,deepLink,eventId,contractVersion,createdAtUtc,readAtUtc,isPinned,pinnedAtUtc,category,groupKey,metadataJson,priority,digestOnly]);

@override
String toString() {
  return 'WorkspaceNotificationResponse(id: $id, sourceModule: $sourceModule, eventType: $eventType, entityType: $entityType, entityId: $entityId, workspaceId: $workspaceId, title: $title, body: $body, deepLink: $deepLink, eventId: $eventId, contractVersion: $contractVersion, createdAtUtc: $createdAtUtc, readAtUtc: $readAtUtc, isPinned: $isPinned, pinnedAtUtc: $pinnedAtUtc, category: $category, groupKey: $groupKey, metadataJson: $metadataJson, priority: $priority, digestOnly: $digestOnly)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceNotificationResponseCopyWith<$Res> implements $WorkspaceNotificationResponseCopyWith<$Res> {
  factory _$WorkspaceNotificationResponseCopyWith(_WorkspaceNotificationResponse value, $Res Function(_WorkspaceNotificationResponse) _then) = __$WorkspaceNotificationResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceModule, String eventType, String entityType, String entityId, String? workspaceId, String title, String body, String? deepLink, String eventId, int contractVersion, DateTime createdAtUtc, DateTime? readAtUtc, bool isPinned, DateTime? pinnedAtUtc, NotificationCategory category, String? groupKey, String? metadataJson, NotificationPriority priority, bool digestOnly
});




}
/// @nodoc
class __$WorkspaceNotificationResponseCopyWithImpl<$Res>
    implements _$WorkspaceNotificationResponseCopyWith<$Res> {
  __$WorkspaceNotificationResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceNotificationResponse _self;
  final $Res Function(_WorkspaceNotificationResponse) _then;

/// Create a copy of WorkspaceNotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceModule = null,Object? eventType = null,Object? entityType = null,Object? entityId = null,Object? workspaceId = freezed,Object? title = null,Object? body = null,Object? deepLink = freezed,Object? eventId = null,Object? contractVersion = null,Object? createdAtUtc = null,Object? readAtUtc = freezed,Object? isPinned = null,Object? pinnedAtUtc = freezed,Object? category = null,Object? groupKey = freezed,Object? metadataJson = freezed,Object? priority = null,Object? digestOnly = null,}) {
  return _then(_WorkspaceNotificationResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,readAtUtc: freezed == readAtUtc ? _self.readAtUtc : readAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,pinnedAtUtc: freezed == pinnedAtUtc ? _self.pinnedAtUtc : pinnedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as NotificationCategory,groupKey: freezed == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String?,metadataJson: freezed == metadataJson ? _self.metadataJson : metadataJson // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as NotificationPriority,digestOnly: null == digestOnly ? _self.digestOnly : digestOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$NotificationActorAvatarResponse {

 String get coreUserId; String? get avatarUrl;
/// Create a copy of NotificationActorAvatarResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationActorAvatarResponseCopyWith<NotificationActorAvatarResponse> get copyWith => _$NotificationActorAvatarResponseCopyWithImpl<NotificationActorAvatarResponse>(this as NotificationActorAvatarResponse, _$identity);

  /// Serializes this NotificationActorAvatarResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationActorAvatarResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,avatarUrl);

@override
String toString() {
  return 'NotificationActorAvatarResponse(coreUserId: $coreUserId, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $NotificationActorAvatarResponseCopyWith<$Res>  {
  factory $NotificationActorAvatarResponseCopyWith(NotificationActorAvatarResponse value, $Res Function(NotificationActorAvatarResponse) _then) = _$NotificationActorAvatarResponseCopyWithImpl;
@useResult
$Res call({
 String coreUserId, String? avatarUrl
});




}
/// @nodoc
class _$NotificationActorAvatarResponseCopyWithImpl<$Res>
    implements $NotificationActorAvatarResponseCopyWith<$Res> {
  _$NotificationActorAvatarResponseCopyWithImpl(this._self, this._then);

  final NotificationActorAvatarResponse _self;
  final $Res Function(NotificationActorAvatarResponse) _then;

/// Create a copy of NotificationActorAvatarResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coreUserId = null,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationActorAvatarResponse].
extension NotificationActorAvatarResponsePatterns on NotificationActorAvatarResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationActorAvatarResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationActorAvatarResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationActorAvatarResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationActorAvatarResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationActorAvatarResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationActorAvatarResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coreUserId,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationActorAvatarResponse() when $default != null:
return $default(_that.coreUserId,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coreUserId,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _NotificationActorAvatarResponse():
return $default(_that.coreUserId,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coreUserId,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _NotificationActorAvatarResponse() when $default != null:
return $default(_that.coreUserId,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationActorAvatarResponse implements NotificationActorAvatarResponse {
  const _NotificationActorAvatarResponse({required this.coreUserId, this.avatarUrl});
  factory _NotificationActorAvatarResponse.fromJson(Map<String, dynamic> json) => _$NotificationActorAvatarResponseFromJson(json);

@override final  String coreUserId;
@override final  String? avatarUrl;

/// Create a copy of NotificationActorAvatarResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationActorAvatarResponseCopyWith<_NotificationActorAvatarResponse> get copyWith => __$NotificationActorAvatarResponseCopyWithImpl<_NotificationActorAvatarResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationActorAvatarResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationActorAvatarResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,avatarUrl);

@override
String toString() {
  return 'NotificationActorAvatarResponse(coreUserId: $coreUserId, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$NotificationActorAvatarResponseCopyWith<$Res> implements $NotificationActorAvatarResponseCopyWith<$Res> {
  factory _$NotificationActorAvatarResponseCopyWith(_NotificationActorAvatarResponse value, $Res Function(_NotificationActorAvatarResponse) _then) = __$NotificationActorAvatarResponseCopyWithImpl;
@override @useResult
$Res call({
 String coreUserId, String? avatarUrl
});




}
/// @nodoc
class __$NotificationActorAvatarResponseCopyWithImpl<$Res>
    implements _$NotificationActorAvatarResponseCopyWith<$Res> {
  __$NotificationActorAvatarResponseCopyWithImpl(this._self, this._then);

  final _NotificationActorAvatarResponse _self;
  final $Res Function(_NotificationActorAvatarResponse) _then;

/// Create a copy of NotificationActorAvatarResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coreUserId = null,Object? avatarUrl = freezed,}) {
  return _then(_NotificationActorAvatarResponse(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NotificationGroupResponse {

 String get groupKey; int get count; int get unreadCount; WorkspaceNotificationResponse get latest; List<String> get notificationIds; String? get notificationKind; String? get scopeReference; List<NotificationActorAvatarResponse>? get actorAvatars; String? get preview; bool get isArchived; int? get realtimeSequence;
/// Create a copy of NotificationGroupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationGroupResponseCopyWith<NotificationGroupResponse> get copyWith => _$NotificationGroupResponseCopyWithImpl<NotificationGroupResponse>(this as NotificationGroupResponse, _$identity);

  /// Serializes this NotificationGroupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationGroupResponse&&(identical(other.groupKey, groupKey) || other.groupKey == groupKey)&&(identical(other.count, count) || other.count == count)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.latest, latest) || other.latest == latest)&&const DeepCollectionEquality().equals(other.notificationIds, notificationIds)&&(identical(other.notificationKind, notificationKind) || other.notificationKind == notificationKind)&&(identical(other.scopeReference, scopeReference) || other.scopeReference == scopeReference)&&const DeepCollectionEquality().equals(other.actorAvatars, actorAvatars)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.realtimeSequence, realtimeSequence) || other.realtimeSequence == realtimeSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupKey,count,unreadCount,latest,const DeepCollectionEquality().hash(notificationIds),notificationKind,scopeReference,const DeepCollectionEquality().hash(actorAvatars),preview,isArchived,realtimeSequence);

@override
String toString() {
  return 'NotificationGroupResponse(groupKey: $groupKey, count: $count, unreadCount: $unreadCount, latest: $latest, notificationIds: $notificationIds, notificationKind: $notificationKind, scopeReference: $scopeReference, actorAvatars: $actorAvatars, preview: $preview, isArchived: $isArchived, realtimeSequence: $realtimeSequence)';
}


}

/// @nodoc
abstract mixin class $NotificationGroupResponseCopyWith<$Res>  {
  factory $NotificationGroupResponseCopyWith(NotificationGroupResponse value, $Res Function(NotificationGroupResponse) _then) = _$NotificationGroupResponseCopyWithImpl;
@useResult
$Res call({
 String groupKey, int count, int unreadCount, WorkspaceNotificationResponse latest, List<String> notificationIds, String? notificationKind, String? scopeReference, List<NotificationActorAvatarResponse>? actorAvatars, String? preview, bool isArchived, int? realtimeSequence
});


$WorkspaceNotificationResponseCopyWith<$Res> get latest;

}
/// @nodoc
class _$NotificationGroupResponseCopyWithImpl<$Res>
    implements $NotificationGroupResponseCopyWith<$Res> {
  _$NotificationGroupResponseCopyWithImpl(this._self, this._then);

  final NotificationGroupResponse _self;
  final $Res Function(NotificationGroupResponse) _then;

/// Create a copy of NotificationGroupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupKey = null,Object? count = null,Object? unreadCount = null,Object? latest = null,Object? notificationIds = null,Object? notificationKind = freezed,Object? scopeReference = freezed,Object? actorAvatars = freezed,Object? preview = freezed,Object? isArchived = null,Object? realtimeSequence = freezed,}) {
  return _then(_self.copyWith(
groupKey: null == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,latest: null == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as WorkspaceNotificationResponse,notificationIds: null == notificationIds ? _self.notificationIds : notificationIds // ignore: cast_nullable_to_non_nullable
as List<String>,notificationKind: freezed == notificationKind ? _self.notificationKind : notificationKind // ignore: cast_nullable_to_non_nullable
as String?,scopeReference: freezed == scopeReference ? _self.scopeReference : scopeReference // ignore: cast_nullable_to_non_nullable
as String?,actorAvatars: freezed == actorAvatars ? _self.actorAvatars : actorAvatars // ignore: cast_nullable_to_non_nullable
as List<NotificationActorAvatarResponse>?,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,realtimeSequence: freezed == realtimeSequence ? _self.realtimeSequence : realtimeSequence // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of NotificationGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkspaceNotificationResponseCopyWith<$Res> get latest {
  
  return $WorkspaceNotificationResponseCopyWith<$Res>(_self.latest, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationGroupResponse].
extension NotificationGroupResponsePatterns on NotificationGroupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationGroupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationGroupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationGroupResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationGroupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationGroupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationGroupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String groupKey,  int count,  int unreadCount,  WorkspaceNotificationResponse latest,  List<String> notificationIds,  String? notificationKind,  String? scopeReference,  List<NotificationActorAvatarResponse>? actorAvatars,  String? preview,  bool isArchived,  int? realtimeSequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationGroupResponse() when $default != null:
return $default(_that.groupKey,_that.count,_that.unreadCount,_that.latest,_that.notificationIds,_that.notificationKind,_that.scopeReference,_that.actorAvatars,_that.preview,_that.isArchived,_that.realtimeSequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String groupKey,  int count,  int unreadCount,  WorkspaceNotificationResponse latest,  List<String> notificationIds,  String? notificationKind,  String? scopeReference,  List<NotificationActorAvatarResponse>? actorAvatars,  String? preview,  bool isArchived,  int? realtimeSequence)  $default,) {final _that = this;
switch (_that) {
case _NotificationGroupResponse():
return $default(_that.groupKey,_that.count,_that.unreadCount,_that.latest,_that.notificationIds,_that.notificationKind,_that.scopeReference,_that.actorAvatars,_that.preview,_that.isArchived,_that.realtimeSequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String groupKey,  int count,  int unreadCount,  WorkspaceNotificationResponse latest,  List<String> notificationIds,  String? notificationKind,  String? scopeReference,  List<NotificationActorAvatarResponse>? actorAvatars,  String? preview,  bool isArchived,  int? realtimeSequence)?  $default,) {final _that = this;
switch (_that) {
case _NotificationGroupResponse() when $default != null:
return $default(_that.groupKey,_that.count,_that.unreadCount,_that.latest,_that.notificationIds,_that.notificationKind,_that.scopeReference,_that.actorAvatars,_that.preview,_that.isArchived,_that.realtimeSequence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationGroupResponse implements NotificationGroupResponse {
  const _NotificationGroupResponse({required this.groupKey, required this.count, required this.unreadCount, required this.latest, required this.notificationIds, this.notificationKind, this.scopeReference, this.actorAvatars, this.preview, this.isArchived = false, this.realtimeSequence});
  factory _NotificationGroupResponse.fromJson(Map<String, dynamic> json) => _$NotificationGroupResponseFromJson(json);

@override final  String groupKey;
@override final  int count;
@override final  int unreadCount;
@override final  WorkspaceNotificationResponse latest;
@override final  List<String> notificationIds;
@override final  String? notificationKind;
@override final  String? scopeReference;
@override final  List<NotificationActorAvatarResponse>? actorAvatars;
@override final  String? preview;
@override@JsonKey() final  bool isArchived;
@override final  int? realtimeSequence;

/// Create a copy of NotificationGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationGroupResponseCopyWith<_NotificationGroupResponse> get copyWith => __$NotificationGroupResponseCopyWithImpl<_NotificationGroupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationGroupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationGroupResponse&&(identical(other.groupKey, groupKey) || other.groupKey == groupKey)&&(identical(other.count, count) || other.count == count)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.latest, latest) || other.latest == latest)&&const DeepCollectionEquality().equals(other.notificationIds, notificationIds)&&(identical(other.notificationKind, notificationKind) || other.notificationKind == notificationKind)&&(identical(other.scopeReference, scopeReference) || other.scopeReference == scopeReference)&&const DeepCollectionEquality().equals(other.actorAvatars, actorAvatars)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.realtimeSequence, realtimeSequence) || other.realtimeSequence == realtimeSequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupKey,count,unreadCount,latest,const DeepCollectionEquality().hash(notificationIds),notificationKind,scopeReference,const DeepCollectionEquality().hash(actorAvatars),preview,isArchived,realtimeSequence);

@override
String toString() {
  return 'NotificationGroupResponse(groupKey: $groupKey, count: $count, unreadCount: $unreadCount, latest: $latest, notificationIds: $notificationIds, notificationKind: $notificationKind, scopeReference: $scopeReference, actorAvatars: $actorAvatars, preview: $preview, isArchived: $isArchived, realtimeSequence: $realtimeSequence)';
}


}

/// @nodoc
abstract mixin class _$NotificationGroupResponseCopyWith<$Res> implements $NotificationGroupResponseCopyWith<$Res> {
  factory _$NotificationGroupResponseCopyWith(_NotificationGroupResponse value, $Res Function(_NotificationGroupResponse) _then) = __$NotificationGroupResponseCopyWithImpl;
@override @useResult
$Res call({
 String groupKey, int count, int unreadCount, WorkspaceNotificationResponse latest, List<String> notificationIds, String? notificationKind, String? scopeReference, List<NotificationActorAvatarResponse>? actorAvatars, String? preview, bool isArchived, int? realtimeSequence
});


@override $WorkspaceNotificationResponseCopyWith<$Res> get latest;

}
/// @nodoc
class __$NotificationGroupResponseCopyWithImpl<$Res>
    implements _$NotificationGroupResponseCopyWith<$Res> {
  __$NotificationGroupResponseCopyWithImpl(this._self, this._then);

  final _NotificationGroupResponse _self;
  final $Res Function(_NotificationGroupResponse) _then;

/// Create a copy of NotificationGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupKey = null,Object? count = null,Object? unreadCount = null,Object? latest = null,Object? notificationIds = null,Object? notificationKind = freezed,Object? scopeReference = freezed,Object? actorAvatars = freezed,Object? preview = freezed,Object? isArchived = null,Object? realtimeSequence = freezed,}) {
  return _then(_NotificationGroupResponse(
groupKey: null == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,latest: null == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as WorkspaceNotificationResponse,notificationIds: null == notificationIds ? _self.notificationIds : notificationIds // ignore: cast_nullable_to_non_nullable
as List<String>,notificationKind: freezed == notificationKind ? _self.notificationKind : notificationKind // ignore: cast_nullable_to_non_nullable
as String?,scopeReference: freezed == scopeReference ? _self.scopeReference : scopeReference // ignore: cast_nullable_to_non_nullable
as String?,actorAvatars: freezed == actorAvatars ? _self.actorAvatars : actorAvatars // ignore: cast_nullable_to_non_nullable
as List<NotificationActorAvatarResponse>?,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,realtimeSequence: freezed == realtimeSequence ? _self.realtimeSequence : realtimeSequence // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of NotificationGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkspaceNotificationResponseCopyWith<$Res> get latest {
  
  return $WorkspaceNotificationResponseCopyWith<$Res>(_self.latest, (value) {
    return _then(_self.copyWith(latest: value));
  });
}
}


/// @nodoc
mixin _$NotificationDigestResponse {

 DateTime get generatedAtUtc; List<NotificationGroupResponse> get groups;
/// Create a copy of NotificationDigestResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationDigestResponseCopyWith<NotificationDigestResponse> get copyWith => _$NotificationDigestResponseCopyWithImpl<NotificationDigestResponse>(this as NotificationDigestResponse, _$identity);

  /// Serializes this NotificationDigestResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationDigestResponse&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAtUtc,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'NotificationDigestResponse(generatedAtUtc: $generatedAtUtc, groups: $groups)';
}


}

/// @nodoc
abstract mixin class $NotificationDigestResponseCopyWith<$Res>  {
  factory $NotificationDigestResponseCopyWith(NotificationDigestResponse value, $Res Function(NotificationDigestResponse) _then) = _$NotificationDigestResponseCopyWithImpl;
@useResult
$Res call({
 DateTime generatedAtUtc, List<NotificationGroupResponse> groups
});




}
/// @nodoc
class _$NotificationDigestResponseCopyWithImpl<$Res>
    implements $NotificationDigestResponseCopyWith<$Res> {
  _$NotificationDigestResponseCopyWithImpl(this._self, this._then);

  final NotificationDigestResponse _self;
  final $Res Function(NotificationDigestResponse) _then;

/// Create a copy of NotificationDigestResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generatedAtUtc = null,Object? groups = null,}) {
  return _then(_self.copyWith(
generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<NotificationGroupResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationDigestResponse].
extension NotificationDigestResponsePatterns on NotificationDigestResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationDigestResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationDigestResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationDigestResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationDigestResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationDigestResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationDigestResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime generatedAtUtc,  List<NotificationGroupResponse> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationDigestResponse() when $default != null:
return $default(_that.generatedAtUtc,_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime generatedAtUtc,  List<NotificationGroupResponse> groups)  $default,) {final _that = this;
switch (_that) {
case _NotificationDigestResponse():
return $default(_that.generatedAtUtc,_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime generatedAtUtc,  List<NotificationGroupResponse> groups)?  $default,) {final _that = this;
switch (_that) {
case _NotificationDigestResponse() when $default != null:
return $default(_that.generatedAtUtc,_that.groups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationDigestResponse implements NotificationDigestResponse {
  const _NotificationDigestResponse({required this.generatedAtUtc, required this.groups});
  factory _NotificationDigestResponse.fromJson(Map<String, dynamic> json) => _$NotificationDigestResponseFromJson(json);

@override final  DateTime generatedAtUtc;
@override final  List<NotificationGroupResponse> groups;

/// Create a copy of NotificationDigestResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationDigestResponseCopyWith<_NotificationDigestResponse> get copyWith => __$NotificationDigestResponseCopyWithImpl<_NotificationDigestResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationDigestResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationDigestResponse&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAtUtc,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'NotificationDigestResponse(generatedAtUtc: $generatedAtUtc, groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$NotificationDigestResponseCopyWith<$Res> implements $NotificationDigestResponseCopyWith<$Res> {
  factory _$NotificationDigestResponseCopyWith(_NotificationDigestResponse value, $Res Function(_NotificationDigestResponse) _then) = __$NotificationDigestResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime generatedAtUtc, List<NotificationGroupResponse> groups
});




}
/// @nodoc
class __$NotificationDigestResponseCopyWithImpl<$Res>
    implements _$NotificationDigestResponseCopyWith<$Res> {
  __$NotificationDigestResponseCopyWithImpl(this._self, this._then);

  final _NotificationDigestResponse _self;
  final $Res Function(_NotificationDigestResponse) _then;

/// Create a copy of NotificationDigestResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatedAtUtc = null,Object? groups = null,}) {
  return _then(_NotificationDigestResponse(
generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<NotificationGroupResponse>,
  ));
}


}


/// @nodoc
mixin _$UnreadNotificationCountResponse {

 int get count;
/// Create a copy of UnreadNotificationCountResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnreadNotificationCountResponseCopyWith<UnreadNotificationCountResponse> get copyWith => _$UnreadNotificationCountResponseCopyWithImpl<UnreadNotificationCountResponse>(this as UnreadNotificationCountResponse, _$identity);

  /// Serializes this UnreadNotificationCountResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnreadNotificationCountResponse&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'UnreadNotificationCountResponse(count: $count)';
}


}

/// @nodoc
abstract mixin class $UnreadNotificationCountResponseCopyWith<$Res>  {
  factory $UnreadNotificationCountResponseCopyWith(UnreadNotificationCountResponse value, $Res Function(UnreadNotificationCountResponse) _then) = _$UnreadNotificationCountResponseCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$UnreadNotificationCountResponseCopyWithImpl<$Res>
    implements $UnreadNotificationCountResponseCopyWith<$Res> {
  _$UnreadNotificationCountResponseCopyWithImpl(this._self, this._then);

  final UnreadNotificationCountResponse _self;
  final $Res Function(UnreadNotificationCountResponse) _then;

/// Create a copy of UnreadNotificationCountResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UnreadNotificationCountResponse].
extension UnreadNotificationCountResponsePatterns on UnreadNotificationCountResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnreadNotificationCountResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnreadNotificationCountResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnreadNotificationCountResponse value)  $default,){
final _that = this;
switch (_that) {
case _UnreadNotificationCountResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnreadNotificationCountResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UnreadNotificationCountResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnreadNotificationCountResponse() when $default != null:
return $default(_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count)  $default,) {final _that = this;
switch (_that) {
case _UnreadNotificationCountResponse():
return $default(_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count)?  $default,) {final _that = this;
switch (_that) {
case _UnreadNotificationCountResponse() when $default != null:
return $default(_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnreadNotificationCountResponse implements UnreadNotificationCountResponse {
  const _UnreadNotificationCountResponse({required this.count});
  factory _UnreadNotificationCountResponse.fromJson(Map<String, dynamic> json) => _$UnreadNotificationCountResponseFromJson(json);

@override final  int count;

/// Create a copy of UnreadNotificationCountResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnreadNotificationCountResponseCopyWith<_UnreadNotificationCountResponse> get copyWith => __$UnreadNotificationCountResponseCopyWithImpl<_UnreadNotificationCountResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnreadNotificationCountResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnreadNotificationCountResponse&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'UnreadNotificationCountResponse(count: $count)';
}


}

/// @nodoc
abstract mixin class _$UnreadNotificationCountResponseCopyWith<$Res> implements $UnreadNotificationCountResponseCopyWith<$Res> {
  factory _$UnreadNotificationCountResponseCopyWith(_UnreadNotificationCountResponse value, $Res Function(_UnreadNotificationCountResponse) _then) = __$UnreadNotificationCountResponseCopyWithImpl;
@override @useResult
$Res call({
 int count
});




}
/// @nodoc
class __$UnreadNotificationCountResponseCopyWithImpl<$Res>
    implements _$UnreadNotificationCountResponseCopyWith<$Res> {
  __$UnreadNotificationCountResponseCopyWithImpl(this._self, this._then);

  final _UnreadNotificationCountResponse _self;
  final $Res Function(_UnreadNotificationCountResponse) _then;

/// Create a copy of UnreadNotificationCountResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(_UnreadNotificationCountResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NotificationEmailCategoryPreference {

 NotificationEmailDeliveryMode get emailMode;
/// Create a copy of NotificationEmailCategoryPreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<NotificationEmailCategoryPreference> get copyWith => _$NotificationEmailCategoryPreferenceCopyWithImpl<NotificationEmailCategoryPreference>(this as NotificationEmailCategoryPreference, _$identity);

  /// Serializes this NotificationEmailCategoryPreference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationEmailCategoryPreference&&(identical(other.emailMode, emailMode) || other.emailMode == emailMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emailMode);

@override
String toString() {
  return 'NotificationEmailCategoryPreference(emailMode: $emailMode)';
}


}

/// @nodoc
abstract mixin class $NotificationEmailCategoryPreferenceCopyWith<$Res>  {
  factory $NotificationEmailCategoryPreferenceCopyWith(NotificationEmailCategoryPreference value, $Res Function(NotificationEmailCategoryPreference) _then) = _$NotificationEmailCategoryPreferenceCopyWithImpl;
@useResult
$Res call({
 NotificationEmailDeliveryMode emailMode
});




}
/// @nodoc
class _$NotificationEmailCategoryPreferenceCopyWithImpl<$Res>
    implements $NotificationEmailCategoryPreferenceCopyWith<$Res> {
  _$NotificationEmailCategoryPreferenceCopyWithImpl(this._self, this._then);

  final NotificationEmailCategoryPreference _self;
  final $Res Function(NotificationEmailCategoryPreference) _then;

/// Create a copy of NotificationEmailCategoryPreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emailMode = null,}) {
  return _then(_self.copyWith(
emailMode: null == emailMode ? _self.emailMode : emailMode // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationEmailCategoryPreference].
extension NotificationEmailCategoryPreferencePatterns on NotificationEmailCategoryPreference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationEmailCategoryPreference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationEmailCategoryPreference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationEmailCategoryPreference value)  $default,){
final _that = this;
switch (_that) {
case _NotificationEmailCategoryPreference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationEmailCategoryPreference value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationEmailCategoryPreference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationEmailDeliveryMode emailMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationEmailCategoryPreference() when $default != null:
return $default(_that.emailMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationEmailDeliveryMode emailMode)  $default,) {final _that = this;
switch (_that) {
case _NotificationEmailCategoryPreference():
return $default(_that.emailMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationEmailDeliveryMode emailMode)?  $default,) {final _that = this;
switch (_that) {
case _NotificationEmailCategoryPreference() when $default != null:
return $default(_that.emailMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationEmailCategoryPreference implements NotificationEmailCategoryPreference {
  const _NotificationEmailCategoryPreference({required this.emailMode});
  factory _NotificationEmailCategoryPreference.fromJson(Map<String, dynamic> json) => _$NotificationEmailCategoryPreferenceFromJson(json);

@override final  NotificationEmailDeliveryMode emailMode;

/// Create a copy of NotificationEmailCategoryPreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationEmailCategoryPreferenceCopyWith<_NotificationEmailCategoryPreference> get copyWith => __$NotificationEmailCategoryPreferenceCopyWithImpl<_NotificationEmailCategoryPreference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationEmailCategoryPreferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationEmailCategoryPreference&&(identical(other.emailMode, emailMode) || other.emailMode == emailMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emailMode);

@override
String toString() {
  return 'NotificationEmailCategoryPreference(emailMode: $emailMode)';
}


}

/// @nodoc
abstract mixin class _$NotificationEmailCategoryPreferenceCopyWith<$Res> implements $NotificationEmailCategoryPreferenceCopyWith<$Res> {
  factory _$NotificationEmailCategoryPreferenceCopyWith(_NotificationEmailCategoryPreference value, $Res Function(_NotificationEmailCategoryPreference) _then) = __$NotificationEmailCategoryPreferenceCopyWithImpl;
@override @useResult
$Res call({
 NotificationEmailDeliveryMode emailMode
});




}
/// @nodoc
class __$NotificationEmailCategoryPreferenceCopyWithImpl<$Res>
    implements _$NotificationEmailCategoryPreferenceCopyWith<$Res> {
  __$NotificationEmailCategoryPreferenceCopyWithImpl(this._self, this._then);

  final _NotificationEmailCategoryPreference _self;
  final $Res Function(_NotificationEmailCategoryPreference) _then;

/// Create a copy of NotificationEmailCategoryPreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emailMode = null,}) {
  return _then(_NotificationEmailCategoryPreference(
emailMode: null == emailMode ? _self.emailMode : emailMode // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode,
  ));
}


}


/// @nodoc
mixin _$NotificationDeliveryPreferenceResponse {

 String get coreUserId; NotificationEmailCategoryPreference get invitation; NotificationEmailCategoryPreference get membership; NotificationEmailCategoryPreference get workspace; NotificationEmailCategoryPreference get project; NotificationEmailCategoryPreference get task; NotificationEmailCategoryPreference get comment; NotificationEmailCategoryPreference get chat; NotificationEmailCategoryPreference get storage; NotificationEmailCategoryPreference get system; DateTime get updatedAtUtc;
/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationDeliveryPreferenceResponseCopyWith<NotificationDeliveryPreferenceResponse> get copyWith => _$NotificationDeliveryPreferenceResponseCopyWithImpl<NotificationDeliveryPreferenceResponse>(this as NotificationDeliveryPreferenceResponse, _$identity);

  /// Serializes this NotificationDeliveryPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationDeliveryPreferenceResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.invitation, invitation) || other.invitation == invitation)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.project, project) || other.project == project)&&(identical(other.task, task) || other.task == task)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.chat, chat) || other.chat == chat)&&(identical(other.storage, storage) || other.storage == storage)&&(identical(other.system, system) || other.system == system)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,invitation,membership,workspace,project,task,comment,chat,storage,system,updatedAtUtc);

@override
String toString() {
  return 'NotificationDeliveryPreferenceResponse(coreUserId: $coreUserId, invitation: $invitation, membership: $membership, workspace: $workspace, project: $project, task: $task, comment: $comment, chat: $chat, storage: $storage, system: $system, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $NotificationDeliveryPreferenceResponseCopyWith<$Res>  {
  factory $NotificationDeliveryPreferenceResponseCopyWith(NotificationDeliveryPreferenceResponse value, $Res Function(NotificationDeliveryPreferenceResponse) _then) = _$NotificationDeliveryPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String coreUserId, NotificationEmailCategoryPreference invitation, NotificationEmailCategoryPreference membership, NotificationEmailCategoryPreference workspace, NotificationEmailCategoryPreference project, NotificationEmailCategoryPreference task, NotificationEmailCategoryPreference comment, NotificationEmailCategoryPreference chat, NotificationEmailCategoryPreference storage, NotificationEmailCategoryPreference system, DateTime updatedAtUtc
});


$NotificationEmailCategoryPreferenceCopyWith<$Res> get invitation;$NotificationEmailCategoryPreferenceCopyWith<$Res> get membership;$NotificationEmailCategoryPreferenceCopyWith<$Res> get workspace;$NotificationEmailCategoryPreferenceCopyWith<$Res> get project;$NotificationEmailCategoryPreferenceCopyWith<$Res> get task;$NotificationEmailCategoryPreferenceCopyWith<$Res> get comment;$NotificationEmailCategoryPreferenceCopyWith<$Res> get chat;$NotificationEmailCategoryPreferenceCopyWith<$Res> get storage;$NotificationEmailCategoryPreferenceCopyWith<$Res> get system;

}
/// @nodoc
class _$NotificationDeliveryPreferenceResponseCopyWithImpl<$Res>
    implements $NotificationDeliveryPreferenceResponseCopyWith<$Res> {
  _$NotificationDeliveryPreferenceResponseCopyWithImpl(this._self, this._then);

  final NotificationDeliveryPreferenceResponse _self;
  final $Res Function(NotificationDeliveryPreferenceResponse) _then;

/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coreUserId = null,Object? invitation = null,Object? membership = null,Object? workspace = null,Object? project = null,Object? task = null,Object? comment = null,Object? chat = null,Object? storage = null,Object? system = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,invitation: null == invitation ? _self.invitation : invitation // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,workspace: null == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,chat: null == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,storage: null == storage ? _self.storage : storage // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,system: null == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get invitation {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.invitation, (value) {
    return _then(_self.copyWith(invitation: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get membership {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get workspace {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.workspace, (value) {
    return _then(_self.copyWith(workspace: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get project {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.project, (value) {
    return _then(_self.copyWith(project: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get task {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get comment {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.comment, (value) {
    return _then(_self.copyWith(comment: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get chat {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.chat, (value) {
    return _then(_self.copyWith(chat: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get storage {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.storage, (value) {
    return _then(_self.copyWith(storage: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get system {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.system, (value) {
    return _then(_self.copyWith(system: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationDeliveryPreferenceResponse].
extension NotificationDeliveryPreferenceResponsePatterns on NotificationDeliveryPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationDeliveryPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationDeliveryPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationDeliveryPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationDeliveryPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationDeliveryPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationDeliveryPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coreUserId,  NotificationEmailCategoryPreference invitation,  NotificationEmailCategoryPreference membership,  NotificationEmailCategoryPreference workspace,  NotificationEmailCategoryPreference project,  NotificationEmailCategoryPreference task,  NotificationEmailCategoryPreference comment,  NotificationEmailCategoryPreference chat,  NotificationEmailCategoryPreference storage,  NotificationEmailCategoryPreference system,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationDeliveryPreferenceResponse() when $default != null:
return $default(_that.coreUserId,_that.invitation,_that.membership,_that.workspace,_that.project,_that.task,_that.comment,_that.chat,_that.storage,_that.system,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coreUserId,  NotificationEmailCategoryPreference invitation,  NotificationEmailCategoryPreference membership,  NotificationEmailCategoryPreference workspace,  NotificationEmailCategoryPreference project,  NotificationEmailCategoryPreference task,  NotificationEmailCategoryPreference comment,  NotificationEmailCategoryPreference chat,  NotificationEmailCategoryPreference storage,  NotificationEmailCategoryPreference system,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _NotificationDeliveryPreferenceResponse():
return $default(_that.coreUserId,_that.invitation,_that.membership,_that.workspace,_that.project,_that.task,_that.comment,_that.chat,_that.storage,_that.system,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coreUserId,  NotificationEmailCategoryPreference invitation,  NotificationEmailCategoryPreference membership,  NotificationEmailCategoryPreference workspace,  NotificationEmailCategoryPreference project,  NotificationEmailCategoryPreference task,  NotificationEmailCategoryPreference comment,  NotificationEmailCategoryPreference chat,  NotificationEmailCategoryPreference storage,  NotificationEmailCategoryPreference system,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _NotificationDeliveryPreferenceResponse() when $default != null:
return $default(_that.coreUserId,_that.invitation,_that.membership,_that.workspace,_that.project,_that.task,_that.comment,_that.chat,_that.storage,_that.system,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationDeliveryPreferenceResponse implements NotificationDeliveryPreferenceResponse {
  const _NotificationDeliveryPreferenceResponse({required this.coreUserId, required this.invitation, required this.membership, required this.workspace, required this.project, required this.task, required this.comment, required this.chat, required this.storage, required this.system, required this.updatedAtUtc});
  factory _NotificationDeliveryPreferenceResponse.fromJson(Map<String, dynamic> json) => _$NotificationDeliveryPreferenceResponseFromJson(json);

@override final  String coreUserId;
@override final  NotificationEmailCategoryPreference invitation;
@override final  NotificationEmailCategoryPreference membership;
@override final  NotificationEmailCategoryPreference workspace;
@override final  NotificationEmailCategoryPreference project;
@override final  NotificationEmailCategoryPreference task;
@override final  NotificationEmailCategoryPreference comment;
@override final  NotificationEmailCategoryPreference chat;
@override final  NotificationEmailCategoryPreference storage;
@override final  NotificationEmailCategoryPreference system;
@override final  DateTime updatedAtUtc;

/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationDeliveryPreferenceResponseCopyWith<_NotificationDeliveryPreferenceResponse> get copyWith => __$NotificationDeliveryPreferenceResponseCopyWithImpl<_NotificationDeliveryPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationDeliveryPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationDeliveryPreferenceResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.invitation, invitation) || other.invitation == invitation)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.project, project) || other.project == project)&&(identical(other.task, task) || other.task == task)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.chat, chat) || other.chat == chat)&&(identical(other.storage, storage) || other.storage == storage)&&(identical(other.system, system) || other.system == system)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,invitation,membership,workspace,project,task,comment,chat,storage,system,updatedAtUtc);

@override
String toString() {
  return 'NotificationDeliveryPreferenceResponse(coreUserId: $coreUserId, invitation: $invitation, membership: $membership, workspace: $workspace, project: $project, task: $task, comment: $comment, chat: $chat, storage: $storage, system: $system, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$NotificationDeliveryPreferenceResponseCopyWith<$Res> implements $NotificationDeliveryPreferenceResponseCopyWith<$Res> {
  factory _$NotificationDeliveryPreferenceResponseCopyWith(_NotificationDeliveryPreferenceResponse value, $Res Function(_NotificationDeliveryPreferenceResponse) _then) = __$NotificationDeliveryPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String coreUserId, NotificationEmailCategoryPreference invitation, NotificationEmailCategoryPreference membership, NotificationEmailCategoryPreference workspace, NotificationEmailCategoryPreference project, NotificationEmailCategoryPreference task, NotificationEmailCategoryPreference comment, NotificationEmailCategoryPreference chat, NotificationEmailCategoryPreference storage, NotificationEmailCategoryPreference system, DateTime updatedAtUtc
});


@override $NotificationEmailCategoryPreferenceCopyWith<$Res> get invitation;@override $NotificationEmailCategoryPreferenceCopyWith<$Res> get membership;@override $NotificationEmailCategoryPreferenceCopyWith<$Res> get workspace;@override $NotificationEmailCategoryPreferenceCopyWith<$Res> get project;@override $NotificationEmailCategoryPreferenceCopyWith<$Res> get task;@override $NotificationEmailCategoryPreferenceCopyWith<$Res> get comment;@override $NotificationEmailCategoryPreferenceCopyWith<$Res> get chat;@override $NotificationEmailCategoryPreferenceCopyWith<$Res> get storage;@override $NotificationEmailCategoryPreferenceCopyWith<$Res> get system;

}
/// @nodoc
class __$NotificationDeliveryPreferenceResponseCopyWithImpl<$Res>
    implements _$NotificationDeliveryPreferenceResponseCopyWith<$Res> {
  __$NotificationDeliveryPreferenceResponseCopyWithImpl(this._self, this._then);

  final _NotificationDeliveryPreferenceResponse _self;
  final $Res Function(_NotificationDeliveryPreferenceResponse) _then;

/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coreUserId = null,Object? invitation = null,Object? membership = null,Object? workspace = null,Object? project = null,Object? task = null,Object? comment = null,Object? chat = null,Object? storage = null,Object? system = null,Object? updatedAtUtc = null,}) {
  return _then(_NotificationDeliveryPreferenceResponse(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,invitation: null == invitation ? _self.invitation : invitation // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,workspace: null == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,chat: null == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,storage: null == storage ? _self.storage : storage // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,system: null == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as NotificationEmailCategoryPreference,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get invitation {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.invitation, (value) {
    return _then(_self.copyWith(invitation: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get membership {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get workspace {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.workspace, (value) {
    return _then(_self.copyWith(workspace: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get project {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.project, (value) {
    return _then(_self.copyWith(project: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get task {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get comment {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.comment, (value) {
    return _then(_self.copyWith(comment: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get chat {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.chat, (value) {
    return _then(_self.copyWith(chat: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get storage {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.storage, (value) {
    return _then(_self.copyWith(storage: value));
  });
}/// Create a copy of NotificationDeliveryPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationEmailCategoryPreferenceCopyWith<$Res> get system {
  
  return $NotificationEmailCategoryPreferenceCopyWith<$Res>(_self.system, (value) {
    return _then(_self.copyWith(system: value));
  });
}
}


/// @nodoc
mixin _$UpdateNotificationDeliveryPreferencePayload {

 NotificationEmailDeliveryMode? get invitation; NotificationEmailDeliveryMode? get membership; NotificationEmailDeliveryMode? get workspace; NotificationEmailDeliveryMode? get project; NotificationEmailDeliveryMode? get task; NotificationEmailDeliveryMode? get comment; NotificationEmailDeliveryMode? get chat; NotificationEmailDeliveryMode? get storage; NotificationEmailDeliveryMode? get system;
/// Create a copy of UpdateNotificationDeliveryPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateNotificationDeliveryPreferencePayloadCopyWith<UpdateNotificationDeliveryPreferencePayload> get copyWith => _$UpdateNotificationDeliveryPreferencePayloadCopyWithImpl<UpdateNotificationDeliveryPreferencePayload>(this as UpdateNotificationDeliveryPreferencePayload, _$identity);

  /// Serializes this UpdateNotificationDeliveryPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateNotificationDeliveryPreferencePayload&&(identical(other.invitation, invitation) || other.invitation == invitation)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.project, project) || other.project == project)&&(identical(other.task, task) || other.task == task)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.chat, chat) || other.chat == chat)&&(identical(other.storage, storage) || other.storage == storage)&&(identical(other.system, system) || other.system == system));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,invitation,membership,workspace,project,task,comment,chat,storage,system);

@override
String toString() {
  return 'UpdateNotificationDeliveryPreferencePayload(invitation: $invitation, membership: $membership, workspace: $workspace, project: $project, task: $task, comment: $comment, chat: $chat, storage: $storage, system: $system)';
}


}

/// @nodoc
abstract mixin class $UpdateNotificationDeliveryPreferencePayloadCopyWith<$Res>  {
  factory $UpdateNotificationDeliveryPreferencePayloadCopyWith(UpdateNotificationDeliveryPreferencePayload value, $Res Function(UpdateNotificationDeliveryPreferencePayload) _then) = _$UpdateNotificationDeliveryPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 NotificationEmailDeliveryMode? invitation, NotificationEmailDeliveryMode? membership, NotificationEmailDeliveryMode? workspace, NotificationEmailDeliveryMode? project, NotificationEmailDeliveryMode? task, NotificationEmailDeliveryMode? comment, NotificationEmailDeliveryMode? chat, NotificationEmailDeliveryMode? storage, NotificationEmailDeliveryMode? system
});




}
/// @nodoc
class _$UpdateNotificationDeliveryPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateNotificationDeliveryPreferencePayloadCopyWith<$Res> {
  _$UpdateNotificationDeliveryPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateNotificationDeliveryPreferencePayload _self;
  final $Res Function(UpdateNotificationDeliveryPreferencePayload) _then;

/// Create a copy of UpdateNotificationDeliveryPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invitation = freezed,Object? membership = freezed,Object? workspace = freezed,Object? project = freezed,Object? task = freezed,Object? comment = freezed,Object? chat = freezed,Object? storage = freezed,Object? system = freezed,}) {
  return _then(_self.copyWith(
invitation: freezed == invitation ? _self.invitation : invitation // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,workspace: freezed == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,project: freezed == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,chat: freezed == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,storage: freezed == storage ? _self.storage : storage // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,system: freezed == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateNotificationDeliveryPreferencePayload].
extension UpdateNotificationDeliveryPreferencePayloadPatterns on UpdateNotificationDeliveryPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateNotificationDeliveryPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateNotificationDeliveryPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateNotificationDeliveryPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateNotificationDeliveryPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateNotificationDeliveryPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateNotificationDeliveryPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationEmailDeliveryMode? invitation,  NotificationEmailDeliveryMode? membership,  NotificationEmailDeliveryMode? workspace,  NotificationEmailDeliveryMode? project,  NotificationEmailDeliveryMode? task,  NotificationEmailDeliveryMode? comment,  NotificationEmailDeliveryMode? chat,  NotificationEmailDeliveryMode? storage,  NotificationEmailDeliveryMode? system)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateNotificationDeliveryPreferencePayload() when $default != null:
return $default(_that.invitation,_that.membership,_that.workspace,_that.project,_that.task,_that.comment,_that.chat,_that.storage,_that.system);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationEmailDeliveryMode? invitation,  NotificationEmailDeliveryMode? membership,  NotificationEmailDeliveryMode? workspace,  NotificationEmailDeliveryMode? project,  NotificationEmailDeliveryMode? task,  NotificationEmailDeliveryMode? comment,  NotificationEmailDeliveryMode? chat,  NotificationEmailDeliveryMode? storage,  NotificationEmailDeliveryMode? system)  $default,) {final _that = this;
switch (_that) {
case _UpdateNotificationDeliveryPreferencePayload():
return $default(_that.invitation,_that.membership,_that.workspace,_that.project,_that.task,_that.comment,_that.chat,_that.storage,_that.system);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationEmailDeliveryMode? invitation,  NotificationEmailDeliveryMode? membership,  NotificationEmailDeliveryMode? workspace,  NotificationEmailDeliveryMode? project,  NotificationEmailDeliveryMode? task,  NotificationEmailDeliveryMode? comment,  NotificationEmailDeliveryMode? chat,  NotificationEmailDeliveryMode? storage,  NotificationEmailDeliveryMode? system)?  $default,) {final _that = this;
switch (_that) {
case _UpdateNotificationDeliveryPreferencePayload() when $default != null:
return $default(_that.invitation,_that.membership,_that.workspace,_that.project,_that.task,_that.comment,_that.chat,_that.storage,_that.system);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateNotificationDeliveryPreferencePayload implements UpdateNotificationDeliveryPreferencePayload {
  const _UpdateNotificationDeliveryPreferencePayload({this.invitation, this.membership, this.workspace, this.project, this.task, this.comment, this.chat, this.storage, this.system});
  factory _UpdateNotificationDeliveryPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateNotificationDeliveryPreferencePayloadFromJson(json);

@override final  NotificationEmailDeliveryMode? invitation;
@override final  NotificationEmailDeliveryMode? membership;
@override final  NotificationEmailDeliveryMode? workspace;
@override final  NotificationEmailDeliveryMode? project;
@override final  NotificationEmailDeliveryMode? task;
@override final  NotificationEmailDeliveryMode? comment;
@override final  NotificationEmailDeliveryMode? chat;
@override final  NotificationEmailDeliveryMode? storage;
@override final  NotificationEmailDeliveryMode? system;

/// Create a copy of UpdateNotificationDeliveryPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateNotificationDeliveryPreferencePayloadCopyWith<_UpdateNotificationDeliveryPreferencePayload> get copyWith => __$UpdateNotificationDeliveryPreferencePayloadCopyWithImpl<_UpdateNotificationDeliveryPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateNotificationDeliveryPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateNotificationDeliveryPreferencePayload&&(identical(other.invitation, invitation) || other.invitation == invitation)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.project, project) || other.project == project)&&(identical(other.task, task) || other.task == task)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.chat, chat) || other.chat == chat)&&(identical(other.storage, storage) || other.storage == storage)&&(identical(other.system, system) || other.system == system));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,invitation,membership,workspace,project,task,comment,chat,storage,system);

@override
String toString() {
  return 'UpdateNotificationDeliveryPreferencePayload(invitation: $invitation, membership: $membership, workspace: $workspace, project: $project, task: $task, comment: $comment, chat: $chat, storage: $storage, system: $system)';
}


}

/// @nodoc
abstract mixin class _$UpdateNotificationDeliveryPreferencePayloadCopyWith<$Res> implements $UpdateNotificationDeliveryPreferencePayloadCopyWith<$Res> {
  factory _$UpdateNotificationDeliveryPreferencePayloadCopyWith(_UpdateNotificationDeliveryPreferencePayload value, $Res Function(_UpdateNotificationDeliveryPreferencePayload) _then) = __$UpdateNotificationDeliveryPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 NotificationEmailDeliveryMode? invitation, NotificationEmailDeliveryMode? membership, NotificationEmailDeliveryMode? workspace, NotificationEmailDeliveryMode? project, NotificationEmailDeliveryMode? task, NotificationEmailDeliveryMode? comment, NotificationEmailDeliveryMode? chat, NotificationEmailDeliveryMode? storage, NotificationEmailDeliveryMode? system
});




}
/// @nodoc
class __$UpdateNotificationDeliveryPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateNotificationDeliveryPreferencePayloadCopyWith<$Res> {
  __$UpdateNotificationDeliveryPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateNotificationDeliveryPreferencePayload _self;
  final $Res Function(_UpdateNotificationDeliveryPreferencePayload) _then;

/// Create a copy of UpdateNotificationDeliveryPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invitation = freezed,Object? membership = freezed,Object? workspace = freezed,Object? project = freezed,Object? task = freezed,Object? comment = freezed,Object? chat = freezed,Object? storage = freezed,Object? system = freezed,}) {
  return _then(_UpdateNotificationDeliveryPreferencePayload(
invitation: freezed == invitation ? _self.invitation : invitation // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,workspace: freezed == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,project: freezed == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,chat: freezed == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,storage: freezed == storage ? _self.storage : storage // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,system: freezed == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as NotificationEmailDeliveryMode?,
  ));
}


}


/// @nodoc
mixin _$StorageNotificationPreferenceResponse {

 String get coreUserId; StorageNotificationPreferenceMode get mode; bool get isDefault; DateTime? get updatedAtUtc;
/// Create a copy of StorageNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageNotificationPreferenceResponseCopyWith<StorageNotificationPreferenceResponse> get copyWith => _$StorageNotificationPreferenceResponseCopyWithImpl<StorageNotificationPreferenceResponse>(this as StorageNotificationPreferenceResponse, _$identity);

  /// Serializes this StorageNotificationPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageNotificationPreferenceResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,mode,isDefault,updatedAtUtc);

@override
String toString() {
  return 'StorageNotificationPreferenceResponse(coreUserId: $coreUserId, mode: $mode, isDefault: $isDefault, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $StorageNotificationPreferenceResponseCopyWith<$Res>  {
  factory $StorageNotificationPreferenceResponseCopyWith(StorageNotificationPreferenceResponse value, $Res Function(StorageNotificationPreferenceResponse) _then) = _$StorageNotificationPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String coreUserId, StorageNotificationPreferenceMode mode, bool isDefault, DateTime? updatedAtUtc
});




}
/// @nodoc
class _$StorageNotificationPreferenceResponseCopyWithImpl<$Res>
    implements $StorageNotificationPreferenceResponseCopyWith<$Res> {
  _$StorageNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final StorageNotificationPreferenceResponse _self;
  final $Res Function(StorageNotificationPreferenceResponse) _then;

/// Create a copy of StorageNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coreUserId = null,Object? mode = null,Object? isDefault = null,Object? updatedAtUtc = freezed,}) {
  return _then(_self.copyWith(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as StorageNotificationPreferenceMode,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageNotificationPreferenceResponse].
extension StorageNotificationPreferenceResponsePatterns on StorageNotificationPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageNotificationPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageNotificationPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageNotificationPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageNotificationPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coreUserId,  StorageNotificationPreferenceMode mode,  bool isDefault,  DateTime? updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageNotificationPreferenceResponse() when $default != null:
return $default(_that.coreUserId,_that.mode,_that.isDefault,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coreUserId,  StorageNotificationPreferenceMode mode,  bool isDefault,  DateTime? updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _StorageNotificationPreferenceResponse():
return $default(_that.coreUserId,_that.mode,_that.isDefault,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coreUserId,  StorageNotificationPreferenceMode mode,  bool isDefault,  DateTime? updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _StorageNotificationPreferenceResponse() when $default != null:
return $default(_that.coreUserId,_that.mode,_that.isDefault,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageNotificationPreferenceResponse implements StorageNotificationPreferenceResponse {
  const _StorageNotificationPreferenceResponse({required this.coreUserId, required this.mode, required this.isDefault, this.updatedAtUtc});
  factory _StorageNotificationPreferenceResponse.fromJson(Map<String, dynamic> json) => _$StorageNotificationPreferenceResponseFromJson(json);

@override final  String coreUserId;
@override final  StorageNotificationPreferenceMode mode;
@override final  bool isDefault;
@override final  DateTime? updatedAtUtc;

/// Create a copy of StorageNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageNotificationPreferenceResponseCopyWith<_StorageNotificationPreferenceResponse> get copyWith => __$StorageNotificationPreferenceResponseCopyWithImpl<_StorageNotificationPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageNotificationPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageNotificationPreferenceResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,mode,isDefault,updatedAtUtc);

@override
String toString() {
  return 'StorageNotificationPreferenceResponse(coreUserId: $coreUserId, mode: $mode, isDefault: $isDefault, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$StorageNotificationPreferenceResponseCopyWith<$Res> implements $StorageNotificationPreferenceResponseCopyWith<$Res> {
  factory _$StorageNotificationPreferenceResponseCopyWith(_StorageNotificationPreferenceResponse value, $Res Function(_StorageNotificationPreferenceResponse) _then) = __$StorageNotificationPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String coreUserId, StorageNotificationPreferenceMode mode, bool isDefault, DateTime? updatedAtUtc
});




}
/// @nodoc
class __$StorageNotificationPreferenceResponseCopyWithImpl<$Res>
    implements _$StorageNotificationPreferenceResponseCopyWith<$Res> {
  __$StorageNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final _StorageNotificationPreferenceResponse _self;
  final $Res Function(_StorageNotificationPreferenceResponse) _then;

/// Create a copy of StorageNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coreUserId = null,Object? mode = null,Object? isDefault = null,Object? updatedAtUtc = freezed,}) {
  return _then(_StorageNotificationPreferenceResponse(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as StorageNotificationPreferenceMode,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$UpdateStorageNotificationPreferencePayload {

 StorageNotificationPreferenceMode get mode;
/// Create a copy of UpdateStorageNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStorageNotificationPreferencePayloadCopyWith<UpdateStorageNotificationPreferencePayload> get copyWith => _$UpdateStorageNotificationPreferencePayloadCopyWithImpl<UpdateStorageNotificationPreferencePayload>(this as UpdateStorageNotificationPreferencePayload, _$identity);

  /// Serializes this UpdateStorageNotificationPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStorageNotificationPreferencePayload&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'UpdateStorageNotificationPreferencePayload(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $UpdateStorageNotificationPreferencePayloadCopyWith<$Res>  {
  factory $UpdateStorageNotificationPreferencePayloadCopyWith(UpdateStorageNotificationPreferencePayload value, $Res Function(UpdateStorageNotificationPreferencePayload) _then) = _$UpdateStorageNotificationPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 StorageNotificationPreferenceMode mode
});




}
/// @nodoc
class _$UpdateStorageNotificationPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateStorageNotificationPreferencePayloadCopyWith<$Res> {
  _$UpdateStorageNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateStorageNotificationPreferencePayload _self;
  final $Res Function(UpdateStorageNotificationPreferencePayload) _then;

/// Create a copy of UpdateStorageNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as StorageNotificationPreferenceMode,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateStorageNotificationPreferencePayload].
extension UpdateStorageNotificationPreferencePayloadPatterns on UpdateStorageNotificationPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateStorageNotificationPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateStorageNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateStorageNotificationPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateStorageNotificationPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateStorageNotificationPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateStorageNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StorageNotificationPreferenceMode mode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateStorageNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StorageNotificationPreferenceMode mode)  $default,) {final _that = this;
switch (_that) {
case _UpdateStorageNotificationPreferencePayload():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StorageNotificationPreferenceMode mode)?  $default,) {final _that = this;
switch (_that) {
case _UpdateStorageNotificationPreferencePayload() when $default != null:
return $default(_that.mode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateStorageNotificationPreferencePayload implements UpdateStorageNotificationPreferencePayload {
  const _UpdateStorageNotificationPreferencePayload({required this.mode});
  factory _UpdateStorageNotificationPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateStorageNotificationPreferencePayloadFromJson(json);

@override final  StorageNotificationPreferenceMode mode;

/// Create a copy of UpdateStorageNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateStorageNotificationPreferencePayloadCopyWith<_UpdateStorageNotificationPreferencePayload> get copyWith => __$UpdateStorageNotificationPreferencePayloadCopyWithImpl<_UpdateStorageNotificationPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateStorageNotificationPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateStorageNotificationPreferencePayload&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'UpdateStorageNotificationPreferencePayload(mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$UpdateStorageNotificationPreferencePayloadCopyWith<$Res> implements $UpdateStorageNotificationPreferencePayloadCopyWith<$Res> {
  factory _$UpdateStorageNotificationPreferencePayloadCopyWith(_UpdateStorageNotificationPreferencePayload value, $Res Function(_UpdateStorageNotificationPreferencePayload) _then) = __$UpdateStorageNotificationPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 StorageNotificationPreferenceMode mode
});




}
/// @nodoc
class __$UpdateStorageNotificationPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateStorageNotificationPreferencePayloadCopyWith<$Res> {
  __$UpdateStorageNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateStorageNotificationPreferencePayload _self;
  final $Res Function(_UpdateStorageNotificationPreferencePayload) _then;

/// Create a copy of UpdateStorageNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(_UpdateStorageNotificationPreferencePayload(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as StorageNotificationPreferenceMode,
  ));
}


}


/// @nodoc
mixin _$NotificationQuickActionPayload {

 NotificationQuickActionKind get action;
/// Create a copy of NotificationQuickActionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationQuickActionPayloadCopyWith<NotificationQuickActionPayload> get copyWith => _$NotificationQuickActionPayloadCopyWithImpl<NotificationQuickActionPayload>(this as NotificationQuickActionPayload, _$identity);

  /// Serializes this NotificationQuickActionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationQuickActionPayload&&(identical(other.action, action) || other.action == action));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action);

@override
String toString() {
  return 'NotificationQuickActionPayload(action: $action)';
}


}

/// @nodoc
abstract mixin class $NotificationQuickActionPayloadCopyWith<$Res>  {
  factory $NotificationQuickActionPayloadCopyWith(NotificationQuickActionPayload value, $Res Function(NotificationQuickActionPayload) _then) = _$NotificationQuickActionPayloadCopyWithImpl;
@useResult
$Res call({
 NotificationQuickActionKind action
});




}
/// @nodoc
class _$NotificationQuickActionPayloadCopyWithImpl<$Res>
    implements $NotificationQuickActionPayloadCopyWith<$Res> {
  _$NotificationQuickActionPayloadCopyWithImpl(this._self, this._then);

  final NotificationQuickActionPayload _self;
  final $Res Function(NotificationQuickActionPayload) _then;

/// Create a copy of NotificationQuickActionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,}) {
  return _then(_self.copyWith(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as NotificationQuickActionKind,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationQuickActionPayload].
extension NotificationQuickActionPayloadPatterns on NotificationQuickActionPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationQuickActionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationQuickActionPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationQuickActionPayload value)  $default,){
final _that = this;
switch (_that) {
case _NotificationQuickActionPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationQuickActionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationQuickActionPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationQuickActionKind action)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationQuickActionPayload() when $default != null:
return $default(_that.action);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationQuickActionKind action)  $default,) {final _that = this;
switch (_that) {
case _NotificationQuickActionPayload():
return $default(_that.action);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationQuickActionKind action)?  $default,) {final _that = this;
switch (_that) {
case _NotificationQuickActionPayload() when $default != null:
return $default(_that.action);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationQuickActionPayload implements NotificationQuickActionPayload {
  const _NotificationQuickActionPayload({required this.action});
  factory _NotificationQuickActionPayload.fromJson(Map<String, dynamic> json) => _$NotificationQuickActionPayloadFromJson(json);

@override final  NotificationQuickActionKind action;

/// Create a copy of NotificationQuickActionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationQuickActionPayloadCopyWith<_NotificationQuickActionPayload> get copyWith => __$NotificationQuickActionPayloadCopyWithImpl<_NotificationQuickActionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationQuickActionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationQuickActionPayload&&(identical(other.action, action) || other.action == action));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action);

@override
String toString() {
  return 'NotificationQuickActionPayload(action: $action)';
}


}

/// @nodoc
abstract mixin class _$NotificationQuickActionPayloadCopyWith<$Res> implements $NotificationQuickActionPayloadCopyWith<$Res> {
  factory _$NotificationQuickActionPayloadCopyWith(_NotificationQuickActionPayload value, $Res Function(_NotificationQuickActionPayload) _then) = __$NotificationQuickActionPayloadCopyWithImpl;
@override @useResult
$Res call({
 NotificationQuickActionKind action
});




}
/// @nodoc
class __$NotificationQuickActionPayloadCopyWithImpl<$Res>
    implements _$NotificationQuickActionPayloadCopyWith<$Res> {
  __$NotificationQuickActionPayloadCopyWithImpl(this._self, this._then);

  final _NotificationQuickActionPayload _self;
  final $Res Function(_NotificationQuickActionPayload) _then;

/// Create a copy of NotificationQuickActionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,}) {
  return _then(_NotificationQuickActionPayload(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as NotificationQuickActionKind,
  ));
}


}


/// @nodoc
mixin _$NotificationQuickActionResponse {

 String get notificationId; NotificationQuickActionKind get action; bool get changed;
/// Create a copy of NotificationQuickActionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationQuickActionResponseCopyWith<NotificationQuickActionResponse> get copyWith => _$NotificationQuickActionResponseCopyWithImpl<NotificationQuickActionResponse>(this as NotificationQuickActionResponse, _$identity);

  /// Serializes this NotificationQuickActionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationQuickActionResponse&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.action, action) || other.action == action)&&(identical(other.changed, changed) || other.changed == changed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationId,action,changed);

@override
String toString() {
  return 'NotificationQuickActionResponse(notificationId: $notificationId, action: $action, changed: $changed)';
}


}

/// @nodoc
abstract mixin class $NotificationQuickActionResponseCopyWith<$Res>  {
  factory $NotificationQuickActionResponseCopyWith(NotificationQuickActionResponse value, $Res Function(NotificationQuickActionResponse) _then) = _$NotificationQuickActionResponseCopyWithImpl;
@useResult
$Res call({
 String notificationId, NotificationQuickActionKind action, bool changed
});




}
/// @nodoc
class _$NotificationQuickActionResponseCopyWithImpl<$Res>
    implements $NotificationQuickActionResponseCopyWith<$Res> {
  _$NotificationQuickActionResponseCopyWithImpl(this._self, this._then);

  final NotificationQuickActionResponse _self;
  final $Res Function(NotificationQuickActionResponse) _then;

/// Create a copy of NotificationQuickActionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationId = null,Object? action = null,Object? changed = null,}) {
  return _then(_self.copyWith(
notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as NotificationQuickActionKind,changed: null == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationQuickActionResponse].
extension NotificationQuickActionResponsePatterns on NotificationQuickActionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationQuickActionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationQuickActionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationQuickActionResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationQuickActionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationQuickActionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationQuickActionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String notificationId,  NotificationQuickActionKind action,  bool changed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationQuickActionResponse() when $default != null:
return $default(_that.notificationId,_that.action,_that.changed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String notificationId,  NotificationQuickActionKind action,  bool changed)  $default,) {final _that = this;
switch (_that) {
case _NotificationQuickActionResponse():
return $default(_that.notificationId,_that.action,_that.changed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String notificationId,  NotificationQuickActionKind action,  bool changed)?  $default,) {final _that = this;
switch (_that) {
case _NotificationQuickActionResponse() when $default != null:
return $default(_that.notificationId,_that.action,_that.changed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationQuickActionResponse implements NotificationQuickActionResponse {
  const _NotificationQuickActionResponse({required this.notificationId, required this.action, required this.changed});
  factory _NotificationQuickActionResponse.fromJson(Map<String, dynamic> json) => _$NotificationQuickActionResponseFromJson(json);

@override final  String notificationId;
@override final  NotificationQuickActionKind action;
@override final  bool changed;

/// Create a copy of NotificationQuickActionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationQuickActionResponseCopyWith<_NotificationQuickActionResponse> get copyWith => __$NotificationQuickActionResponseCopyWithImpl<_NotificationQuickActionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationQuickActionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationQuickActionResponse&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.action, action) || other.action == action)&&(identical(other.changed, changed) || other.changed == changed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationId,action,changed);

@override
String toString() {
  return 'NotificationQuickActionResponse(notificationId: $notificationId, action: $action, changed: $changed)';
}


}

/// @nodoc
abstract mixin class _$NotificationQuickActionResponseCopyWith<$Res> implements $NotificationQuickActionResponseCopyWith<$Res> {
  factory _$NotificationQuickActionResponseCopyWith(_NotificationQuickActionResponse value, $Res Function(_NotificationQuickActionResponse) _then) = __$NotificationQuickActionResponseCopyWithImpl;
@override @useResult
$Res call({
 String notificationId, NotificationQuickActionKind action, bool changed
});




}
/// @nodoc
class __$NotificationQuickActionResponseCopyWithImpl<$Res>
    implements _$NotificationQuickActionResponseCopyWith<$Res> {
  __$NotificationQuickActionResponseCopyWithImpl(this._self, this._then);

  final _NotificationQuickActionResponse _self;
  final $Res Function(_NotificationQuickActionResponse) _then;

/// Create a copy of NotificationQuickActionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationId = null,Object? action = null,Object? changed = null,}) {
  return _then(_NotificationQuickActionResponse(
notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as NotificationQuickActionKind,changed: null == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$NotificationReplyPayload {

 String get clientMessageId; String get text; String? get deltaJson;
/// Create a copy of NotificationReplyPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationReplyPayloadCopyWith<NotificationReplyPayload> get copyWith => _$NotificationReplyPayloadCopyWithImpl<NotificationReplyPayload>(this as NotificationReplyPayload, _$identity);

  /// Serializes this NotificationReplyPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationReplyPayload&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientMessageId,text,deltaJson);

@override
String toString() {
  return 'NotificationReplyPayload(clientMessageId: $clientMessageId, text: $text, deltaJson: $deltaJson)';
}


}

/// @nodoc
abstract mixin class $NotificationReplyPayloadCopyWith<$Res>  {
  factory $NotificationReplyPayloadCopyWith(NotificationReplyPayload value, $Res Function(NotificationReplyPayload) _then) = _$NotificationReplyPayloadCopyWithImpl;
@useResult
$Res call({
 String clientMessageId, String text, String? deltaJson
});




}
/// @nodoc
class _$NotificationReplyPayloadCopyWithImpl<$Res>
    implements $NotificationReplyPayloadCopyWith<$Res> {
  _$NotificationReplyPayloadCopyWithImpl(this._self, this._then);

  final NotificationReplyPayload _self;
  final $Res Function(NotificationReplyPayload) _then;

/// Create a copy of NotificationReplyPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientMessageId = null,Object? text = null,Object? deltaJson = freezed,}) {
  return _then(_self.copyWith(
clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationReplyPayload].
extension NotificationReplyPayloadPatterns on NotificationReplyPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationReplyPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationReplyPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationReplyPayload value)  $default,){
final _that = this;
switch (_that) {
case _NotificationReplyPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationReplyPayload value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationReplyPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientMessageId,  String text,  String? deltaJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationReplyPayload() when $default != null:
return $default(_that.clientMessageId,_that.text,_that.deltaJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientMessageId,  String text,  String? deltaJson)  $default,) {final _that = this;
switch (_that) {
case _NotificationReplyPayload():
return $default(_that.clientMessageId,_that.text,_that.deltaJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientMessageId,  String text,  String? deltaJson)?  $default,) {final _that = this;
switch (_that) {
case _NotificationReplyPayload() when $default != null:
return $default(_that.clientMessageId,_that.text,_that.deltaJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationReplyPayload implements NotificationReplyPayload {
  const _NotificationReplyPayload({required this.clientMessageId, required this.text, this.deltaJson});
  factory _NotificationReplyPayload.fromJson(Map<String, dynamic> json) => _$NotificationReplyPayloadFromJson(json);

@override final  String clientMessageId;
@override final  String text;
@override final  String? deltaJson;

/// Create a copy of NotificationReplyPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationReplyPayloadCopyWith<_NotificationReplyPayload> get copyWith => __$NotificationReplyPayloadCopyWithImpl<_NotificationReplyPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationReplyPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationReplyPayload&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientMessageId,text,deltaJson);

@override
String toString() {
  return 'NotificationReplyPayload(clientMessageId: $clientMessageId, text: $text, deltaJson: $deltaJson)';
}


}

/// @nodoc
abstract mixin class _$NotificationReplyPayloadCopyWith<$Res> implements $NotificationReplyPayloadCopyWith<$Res> {
  factory _$NotificationReplyPayloadCopyWith(_NotificationReplyPayload value, $Res Function(_NotificationReplyPayload) _then) = __$NotificationReplyPayloadCopyWithImpl;
@override @useResult
$Res call({
 String clientMessageId, String text, String? deltaJson
});




}
/// @nodoc
class __$NotificationReplyPayloadCopyWithImpl<$Res>
    implements _$NotificationReplyPayloadCopyWith<$Res> {
  __$NotificationReplyPayloadCopyWithImpl(this._self, this._then);

  final _NotificationReplyPayload _self;
  final $Res Function(_NotificationReplyPayload) _then;

/// Create a copy of NotificationReplyPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientMessageId = null,Object? text = null,Object? deltaJson = freezed,}) {
  return _then(_NotificationReplyPayload(
clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateAdminNotificationPayload {

 String get recipientCoreUserId; String get title; String get body; String? get deepLink; String? get workspaceId;
/// Create a copy of CreateAdminNotificationPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAdminNotificationPayloadCopyWith<CreateAdminNotificationPayload> get copyWith => _$CreateAdminNotificationPayloadCopyWithImpl<CreateAdminNotificationPayload>(this as CreateAdminNotificationPayload, _$identity);

  /// Serializes this CreateAdminNotificationPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAdminNotificationPayload&&(identical(other.recipientCoreUserId, recipientCoreUserId) || other.recipientCoreUserId == recipientCoreUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recipientCoreUserId,title,body,deepLink,workspaceId);

@override
String toString() {
  return 'CreateAdminNotificationPayload(recipientCoreUserId: $recipientCoreUserId, title: $title, body: $body, deepLink: $deepLink, workspaceId: $workspaceId)';
}


}

/// @nodoc
abstract mixin class $CreateAdminNotificationPayloadCopyWith<$Res>  {
  factory $CreateAdminNotificationPayloadCopyWith(CreateAdminNotificationPayload value, $Res Function(CreateAdminNotificationPayload) _then) = _$CreateAdminNotificationPayloadCopyWithImpl;
@useResult
$Res call({
 String recipientCoreUserId, String title, String body, String? deepLink, String? workspaceId
});




}
/// @nodoc
class _$CreateAdminNotificationPayloadCopyWithImpl<$Res>
    implements $CreateAdminNotificationPayloadCopyWith<$Res> {
  _$CreateAdminNotificationPayloadCopyWithImpl(this._self, this._then);

  final CreateAdminNotificationPayload _self;
  final $Res Function(CreateAdminNotificationPayload) _then;

/// Create a copy of CreateAdminNotificationPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipientCoreUserId = null,Object? title = null,Object? body = null,Object? deepLink = freezed,Object? workspaceId = freezed,}) {
  return _then(_self.copyWith(
recipientCoreUserId: null == recipientCoreUserId ? _self.recipientCoreUserId : recipientCoreUserId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateAdminNotificationPayload].
extension CreateAdminNotificationPayloadPatterns on CreateAdminNotificationPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateAdminNotificationPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateAdminNotificationPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateAdminNotificationPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateAdminNotificationPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateAdminNotificationPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateAdminNotificationPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String recipientCoreUserId,  String title,  String body,  String? deepLink,  String? workspaceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateAdminNotificationPayload() when $default != null:
return $default(_that.recipientCoreUserId,_that.title,_that.body,_that.deepLink,_that.workspaceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String recipientCoreUserId,  String title,  String body,  String? deepLink,  String? workspaceId)  $default,) {final _that = this;
switch (_that) {
case _CreateAdminNotificationPayload():
return $default(_that.recipientCoreUserId,_that.title,_that.body,_that.deepLink,_that.workspaceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String recipientCoreUserId,  String title,  String body,  String? deepLink,  String? workspaceId)?  $default,) {final _that = this;
switch (_that) {
case _CreateAdminNotificationPayload() when $default != null:
return $default(_that.recipientCoreUserId,_that.title,_that.body,_that.deepLink,_that.workspaceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateAdminNotificationPayload implements CreateAdminNotificationPayload {
  const _CreateAdminNotificationPayload({required this.recipientCoreUserId, required this.title, required this.body, this.deepLink, this.workspaceId});
  factory _CreateAdminNotificationPayload.fromJson(Map<String, dynamic> json) => _$CreateAdminNotificationPayloadFromJson(json);

@override final  String recipientCoreUserId;
@override final  String title;
@override final  String body;
@override final  String? deepLink;
@override final  String? workspaceId;

/// Create a copy of CreateAdminNotificationPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAdminNotificationPayloadCopyWith<_CreateAdminNotificationPayload> get copyWith => __$CreateAdminNotificationPayloadCopyWithImpl<_CreateAdminNotificationPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateAdminNotificationPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAdminNotificationPayload&&(identical(other.recipientCoreUserId, recipientCoreUserId) || other.recipientCoreUserId == recipientCoreUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recipientCoreUserId,title,body,deepLink,workspaceId);

@override
String toString() {
  return 'CreateAdminNotificationPayload(recipientCoreUserId: $recipientCoreUserId, title: $title, body: $body, deepLink: $deepLink, workspaceId: $workspaceId)';
}


}

/// @nodoc
abstract mixin class _$CreateAdminNotificationPayloadCopyWith<$Res> implements $CreateAdminNotificationPayloadCopyWith<$Res> {
  factory _$CreateAdminNotificationPayloadCopyWith(_CreateAdminNotificationPayload value, $Res Function(_CreateAdminNotificationPayload) _then) = __$CreateAdminNotificationPayloadCopyWithImpl;
@override @useResult
$Res call({
 String recipientCoreUserId, String title, String body, String? deepLink, String? workspaceId
});




}
/// @nodoc
class __$CreateAdminNotificationPayloadCopyWithImpl<$Res>
    implements _$CreateAdminNotificationPayloadCopyWith<$Res> {
  __$CreateAdminNotificationPayloadCopyWithImpl(this._self, this._then);

  final _CreateAdminNotificationPayload _self;
  final $Res Function(_CreateAdminNotificationPayload) _then;

/// Create a copy of CreateAdminNotificationPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipientCoreUserId = null,Object? title = null,Object? body = null,Object? deepLink = freezed,Object? workspaceId = freezed,}) {
  return _then(_CreateAdminNotificationPayload(
recipientCoreUserId: null == recipientCoreUserId ? _self.recipientCoreUserId : recipientCoreUserId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
