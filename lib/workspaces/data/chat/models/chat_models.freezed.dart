// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResolveChatConversationPayload {

 ChatConversationType get type; ChatScopeKind get scopeKind; String get scopeKey; String? get workspaceId; String? get projectId; String? get name; String? get directConversationKey; List<String>? get userIds; String? get discussionRootMessageId; String get postingPermission; String? get scopeProvider; String? get scopeResourceType; String? get scopeResourceId;
/// Create a copy of ResolveChatConversationPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolveChatConversationPayloadCopyWith<ResolveChatConversationPayload> get copyWith => _$ResolveChatConversationPayloadCopyWithImpl<ResolveChatConversationPayload>(this as ResolveChatConversationPayload, _$identity);

  /// Serializes this ResolveChatConversationPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolveChatConversationPayload&&(identical(other.type, type) || other.type == type)&&(identical(other.scopeKind, scopeKind) || other.scopeKind == scopeKind)&&(identical(other.scopeKey, scopeKey) || other.scopeKey == scopeKey)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.directConversationKey, directConversationKey) || other.directConversationKey == directConversationKey)&&const DeepCollectionEquality().equals(other.userIds, userIds)&&(identical(other.discussionRootMessageId, discussionRootMessageId) || other.discussionRootMessageId == discussionRootMessageId)&&(identical(other.postingPermission, postingPermission) || other.postingPermission == postingPermission)&&(identical(other.scopeProvider, scopeProvider) || other.scopeProvider == scopeProvider)&&(identical(other.scopeResourceType, scopeResourceType) || other.scopeResourceType == scopeResourceType)&&(identical(other.scopeResourceId, scopeResourceId) || other.scopeResourceId == scopeResourceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,scopeKind,scopeKey,workspaceId,projectId,name,directConversationKey,const DeepCollectionEquality().hash(userIds),discussionRootMessageId,postingPermission,scopeProvider,scopeResourceType,scopeResourceId);

@override
String toString() {
  return 'ResolveChatConversationPayload(type: $type, scopeKind: $scopeKind, scopeKey: $scopeKey, workspaceId: $workspaceId, projectId: $projectId, name: $name, directConversationKey: $directConversationKey, userIds: $userIds, discussionRootMessageId: $discussionRootMessageId, postingPermission: $postingPermission, scopeProvider: $scopeProvider, scopeResourceType: $scopeResourceType, scopeResourceId: $scopeResourceId)';
}


}

/// @nodoc
abstract mixin class $ResolveChatConversationPayloadCopyWith<$Res>  {
  factory $ResolveChatConversationPayloadCopyWith(ResolveChatConversationPayload value, $Res Function(ResolveChatConversationPayload) _then) = _$ResolveChatConversationPayloadCopyWithImpl;
@useResult
$Res call({
 ChatConversationType type, ChatScopeKind scopeKind, String scopeKey, String? workspaceId, String? projectId, String? name, String? directConversationKey, List<String>? userIds, String? discussionRootMessageId, String postingPermission, String? scopeProvider, String? scopeResourceType, String? scopeResourceId
});




}
/// @nodoc
class _$ResolveChatConversationPayloadCopyWithImpl<$Res>
    implements $ResolveChatConversationPayloadCopyWith<$Res> {
  _$ResolveChatConversationPayloadCopyWithImpl(this._self, this._then);

  final ResolveChatConversationPayload _self;
  final $Res Function(ResolveChatConversationPayload) _then;

/// Create a copy of ResolveChatConversationPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? scopeKind = null,Object? scopeKey = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? name = freezed,Object? directConversationKey = freezed,Object? userIds = freezed,Object? discussionRootMessageId = freezed,Object? postingPermission = null,Object? scopeProvider = freezed,Object? scopeResourceType = freezed,Object? scopeResourceId = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatConversationType,scopeKind: null == scopeKind ? _self.scopeKind : scopeKind // ignore: cast_nullable_to_non_nullable
as ChatScopeKind,scopeKey: null == scopeKey ? _self.scopeKey : scopeKey // ignore: cast_nullable_to_non_nullable
as String,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,directConversationKey: freezed == directConversationKey ? _self.directConversationKey : directConversationKey // ignore: cast_nullable_to_non_nullable
as String?,userIds: freezed == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>?,discussionRootMessageId: freezed == discussionRootMessageId ? _self.discussionRootMessageId : discussionRootMessageId // ignore: cast_nullable_to_non_nullable
as String?,postingPermission: null == postingPermission ? _self.postingPermission : postingPermission // ignore: cast_nullable_to_non_nullable
as String,scopeProvider: freezed == scopeProvider ? _self.scopeProvider : scopeProvider // ignore: cast_nullable_to_non_nullable
as String?,scopeResourceType: freezed == scopeResourceType ? _self.scopeResourceType : scopeResourceType // ignore: cast_nullable_to_non_nullable
as String?,scopeResourceId: freezed == scopeResourceId ? _self.scopeResourceId : scopeResourceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResolveChatConversationPayload].
extension ResolveChatConversationPayloadPatterns on ResolveChatConversationPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResolveChatConversationPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResolveChatConversationPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResolveChatConversationPayload value)  $default,){
final _that = this;
switch (_that) {
case _ResolveChatConversationPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResolveChatConversationPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ResolveChatConversationPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatConversationType type,  ChatScopeKind scopeKind,  String scopeKey,  String? workspaceId,  String? projectId,  String? name,  String? directConversationKey,  List<String>? userIds,  String? discussionRootMessageId,  String postingPermission,  String? scopeProvider,  String? scopeResourceType,  String? scopeResourceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResolveChatConversationPayload() when $default != null:
return $default(_that.type,_that.scopeKind,_that.scopeKey,_that.workspaceId,_that.projectId,_that.name,_that.directConversationKey,_that.userIds,_that.discussionRootMessageId,_that.postingPermission,_that.scopeProvider,_that.scopeResourceType,_that.scopeResourceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatConversationType type,  ChatScopeKind scopeKind,  String scopeKey,  String? workspaceId,  String? projectId,  String? name,  String? directConversationKey,  List<String>? userIds,  String? discussionRootMessageId,  String postingPermission,  String? scopeProvider,  String? scopeResourceType,  String? scopeResourceId)  $default,) {final _that = this;
switch (_that) {
case _ResolveChatConversationPayload():
return $default(_that.type,_that.scopeKind,_that.scopeKey,_that.workspaceId,_that.projectId,_that.name,_that.directConversationKey,_that.userIds,_that.discussionRootMessageId,_that.postingPermission,_that.scopeProvider,_that.scopeResourceType,_that.scopeResourceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatConversationType type,  ChatScopeKind scopeKind,  String scopeKey,  String? workspaceId,  String? projectId,  String? name,  String? directConversationKey,  List<String>? userIds,  String? discussionRootMessageId,  String postingPermission,  String? scopeProvider,  String? scopeResourceType,  String? scopeResourceId)?  $default,) {final _that = this;
switch (_that) {
case _ResolveChatConversationPayload() when $default != null:
return $default(_that.type,_that.scopeKind,_that.scopeKey,_that.workspaceId,_that.projectId,_that.name,_that.directConversationKey,_that.userIds,_that.discussionRootMessageId,_that.postingPermission,_that.scopeProvider,_that.scopeResourceType,_that.scopeResourceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResolveChatConversationPayload implements ResolveChatConversationPayload {
  const _ResolveChatConversationPayload({required this.type, required this.scopeKind, required this.scopeKey, this.workspaceId, this.projectId, this.name, this.directConversationKey, this.userIds, this.discussionRootMessageId, this.postingPermission = 'Everyone', this.scopeProvider, this.scopeResourceType, this.scopeResourceId});
  factory _ResolveChatConversationPayload.fromJson(Map<String, dynamic> json) => _$ResolveChatConversationPayloadFromJson(json);

@override final  ChatConversationType type;
@override final  ChatScopeKind scopeKind;
@override final  String scopeKey;
@override final  String? workspaceId;
@override final  String? projectId;
@override final  String? name;
@override final  String? directConversationKey;
@override final  List<String>? userIds;
@override final  String? discussionRootMessageId;
@override@JsonKey() final  String postingPermission;
@override final  String? scopeProvider;
@override final  String? scopeResourceType;
@override final  String? scopeResourceId;

/// Create a copy of ResolveChatConversationPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResolveChatConversationPayloadCopyWith<_ResolveChatConversationPayload> get copyWith => __$ResolveChatConversationPayloadCopyWithImpl<_ResolveChatConversationPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResolveChatConversationPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResolveChatConversationPayload&&(identical(other.type, type) || other.type == type)&&(identical(other.scopeKind, scopeKind) || other.scopeKind == scopeKind)&&(identical(other.scopeKey, scopeKey) || other.scopeKey == scopeKey)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.directConversationKey, directConversationKey) || other.directConversationKey == directConversationKey)&&const DeepCollectionEquality().equals(other.userIds, userIds)&&(identical(other.discussionRootMessageId, discussionRootMessageId) || other.discussionRootMessageId == discussionRootMessageId)&&(identical(other.postingPermission, postingPermission) || other.postingPermission == postingPermission)&&(identical(other.scopeProvider, scopeProvider) || other.scopeProvider == scopeProvider)&&(identical(other.scopeResourceType, scopeResourceType) || other.scopeResourceType == scopeResourceType)&&(identical(other.scopeResourceId, scopeResourceId) || other.scopeResourceId == scopeResourceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,scopeKind,scopeKey,workspaceId,projectId,name,directConversationKey,const DeepCollectionEquality().hash(userIds),discussionRootMessageId,postingPermission,scopeProvider,scopeResourceType,scopeResourceId);

@override
String toString() {
  return 'ResolveChatConversationPayload(type: $type, scopeKind: $scopeKind, scopeKey: $scopeKey, workspaceId: $workspaceId, projectId: $projectId, name: $name, directConversationKey: $directConversationKey, userIds: $userIds, discussionRootMessageId: $discussionRootMessageId, postingPermission: $postingPermission, scopeProvider: $scopeProvider, scopeResourceType: $scopeResourceType, scopeResourceId: $scopeResourceId)';
}


}

/// @nodoc
abstract mixin class _$ResolveChatConversationPayloadCopyWith<$Res> implements $ResolveChatConversationPayloadCopyWith<$Res> {
  factory _$ResolveChatConversationPayloadCopyWith(_ResolveChatConversationPayload value, $Res Function(_ResolveChatConversationPayload) _then) = __$ResolveChatConversationPayloadCopyWithImpl;
@override @useResult
$Res call({
 ChatConversationType type, ChatScopeKind scopeKind, String scopeKey, String? workspaceId, String? projectId, String? name, String? directConversationKey, List<String>? userIds, String? discussionRootMessageId, String postingPermission, String? scopeProvider, String? scopeResourceType, String? scopeResourceId
});




}
/// @nodoc
class __$ResolveChatConversationPayloadCopyWithImpl<$Res>
    implements _$ResolveChatConversationPayloadCopyWith<$Res> {
  __$ResolveChatConversationPayloadCopyWithImpl(this._self, this._then);

  final _ResolveChatConversationPayload _self;
  final $Res Function(_ResolveChatConversationPayload) _then;

/// Create a copy of ResolveChatConversationPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? scopeKind = null,Object? scopeKey = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? name = freezed,Object? directConversationKey = freezed,Object? userIds = freezed,Object? discussionRootMessageId = freezed,Object? postingPermission = null,Object? scopeProvider = freezed,Object? scopeResourceType = freezed,Object? scopeResourceId = freezed,}) {
  return _then(_ResolveChatConversationPayload(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatConversationType,scopeKind: null == scopeKind ? _self.scopeKind : scopeKind // ignore: cast_nullable_to_non_nullable
as ChatScopeKind,scopeKey: null == scopeKey ? _self.scopeKey : scopeKey // ignore: cast_nullable_to_non_nullable
as String,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,directConversationKey: freezed == directConversationKey ? _self.directConversationKey : directConversationKey // ignore: cast_nullable_to_non_nullable
as String?,userIds: freezed == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>?,discussionRootMessageId: freezed == discussionRootMessageId ? _self.discussionRootMessageId : discussionRootMessageId // ignore: cast_nullable_to_non_nullable
as String?,postingPermission: null == postingPermission ? _self.postingPermission : postingPermission // ignore: cast_nullable_to_non_nullable
as String,scopeProvider: freezed == scopeProvider ? _self.scopeProvider : scopeProvider // ignore: cast_nullable_to_non_nullable
as String?,scopeResourceType: freezed == scopeResourceType ? _self.scopeResourceType : scopeResourceType // ignore: cast_nullable_to_non_nullable
as String?,scopeResourceId: freezed == scopeResourceId ? _self.scopeResourceId : scopeResourceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateChatConversationPayload {

 String? get name; String get postingPermission;
/// Create a copy of UpdateChatConversationPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateChatConversationPayloadCopyWith<UpdateChatConversationPayload> get copyWith => _$UpdateChatConversationPayloadCopyWithImpl<UpdateChatConversationPayload>(this as UpdateChatConversationPayload, _$identity);

  /// Serializes this UpdateChatConversationPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChatConversationPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.postingPermission, postingPermission) || other.postingPermission == postingPermission));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,postingPermission);

@override
String toString() {
  return 'UpdateChatConversationPayload(name: $name, postingPermission: $postingPermission)';
}


}

/// @nodoc
abstract mixin class $UpdateChatConversationPayloadCopyWith<$Res>  {
  factory $UpdateChatConversationPayloadCopyWith(UpdateChatConversationPayload value, $Res Function(UpdateChatConversationPayload) _then) = _$UpdateChatConversationPayloadCopyWithImpl;
@useResult
$Res call({
 String? name, String postingPermission
});




}
/// @nodoc
class _$UpdateChatConversationPayloadCopyWithImpl<$Res>
    implements $UpdateChatConversationPayloadCopyWith<$Res> {
  _$UpdateChatConversationPayloadCopyWithImpl(this._self, this._then);

  final UpdateChatConversationPayload _self;
  final $Res Function(UpdateChatConversationPayload) _then;

/// Create a copy of UpdateChatConversationPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? postingPermission = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,postingPermission: null == postingPermission ? _self.postingPermission : postingPermission // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateChatConversationPayload].
extension UpdateChatConversationPayloadPatterns on UpdateChatConversationPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateChatConversationPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateChatConversationPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateChatConversationPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateChatConversationPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateChatConversationPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateChatConversationPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String postingPermission)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateChatConversationPayload() when $default != null:
return $default(_that.name,_that.postingPermission);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String postingPermission)  $default,) {final _that = this;
switch (_that) {
case _UpdateChatConversationPayload():
return $default(_that.name,_that.postingPermission);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String postingPermission)?  $default,) {final _that = this;
switch (_that) {
case _UpdateChatConversationPayload() when $default != null:
return $default(_that.name,_that.postingPermission);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateChatConversationPayload implements UpdateChatConversationPayload {
  const _UpdateChatConversationPayload({this.name, this.postingPermission = 'Everyone'});
  factory _UpdateChatConversationPayload.fromJson(Map<String, dynamic> json) => _$UpdateChatConversationPayloadFromJson(json);

@override final  String? name;
@override@JsonKey() final  String postingPermission;

/// Create a copy of UpdateChatConversationPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateChatConversationPayloadCopyWith<_UpdateChatConversationPayload> get copyWith => __$UpdateChatConversationPayloadCopyWithImpl<_UpdateChatConversationPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateChatConversationPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateChatConversationPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.postingPermission, postingPermission) || other.postingPermission == postingPermission));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,postingPermission);

@override
String toString() {
  return 'UpdateChatConversationPayload(name: $name, postingPermission: $postingPermission)';
}


}

/// @nodoc
abstract mixin class _$UpdateChatConversationPayloadCopyWith<$Res> implements $UpdateChatConversationPayloadCopyWith<$Res> {
  factory _$UpdateChatConversationPayloadCopyWith(_UpdateChatConversationPayload value, $Res Function(_UpdateChatConversationPayload) _then) = __$UpdateChatConversationPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? name, String postingPermission
});




}
/// @nodoc
class __$UpdateChatConversationPayloadCopyWithImpl<$Res>
    implements _$UpdateChatConversationPayloadCopyWith<$Res> {
  __$UpdateChatConversationPayloadCopyWithImpl(this._self, this._then);

  final _UpdateChatConversationPayload _self;
  final $Res Function(_UpdateChatConversationPayload) _then;

/// Create a copy of UpdateChatConversationPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? postingPermission = null,}) {
  return _then(_UpdateChatConversationPayload(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,postingPermission: null == postingPermission ? _self.postingPermission : postingPermission // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ChatConversationResponse {

 String get id; ChatConversationType get type; ChatScopeKind get scopeKind; String get scopeKey; String? get workspaceId; String? get projectId; String? get name; String? get discussionRootMessageId; int get version; DateTime get createdAtUtc; String get postingPermission; bool get isArchived;
/// Create a copy of ChatConversationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatConversationResponseCopyWith<ChatConversationResponse> get copyWith => _$ChatConversationResponseCopyWithImpl<ChatConversationResponse>(this as ChatConversationResponse, _$identity);

  /// Serializes this ChatConversationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatConversationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.scopeKind, scopeKind) || other.scopeKind == scopeKind)&&(identical(other.scopeKey, scopeKey) || other.scopeKey == scopeKey)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.discussionRootMessageId, discussionRootMessageId) || other.discussionRootMessageId == discussionRootMessageId)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.postingPermission, postingPermission) || other.postingPermission == postingPermission)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,scopeKind,scopeKey,workspaceId,projectId,name,discussionRootMessageId,version,createdAtUtc,postingPermission,isArchived);

@override
String toString() {
  return 'ChatConversationResponse(id: $id, type: $type, scopeKind: $scopeKind, scopeKey: $scopeKey, workspaceId: $workspaceId, projectId: $projectId, name: $name, discussionRootMessageId: $discussionRootMessageId, version: $version, createdAtUtc: $createdAtUtc, postingPermission: $postingPermission, isArchived: $isArchived)';
}


}

/// @nodoc
abstract mixin class $ChatConversationResponseCopyWith<$Res>  {
  factory $ChatConversationResponseCopyWith(ChatConversationResponse value, $Res Function(ChatConversationResponse) _then) = _$ChatConversationResponseCopyWithImpl;
@useResult
$Res call({
 String id, ChatConversationType type, ChatScopeKind scopeKind, String scopeKey, String? workspaceId, String? projectId, String? name, String? discussionRootMessageId, int version, DateTime createdAtUtc, String postingPermission, bool isArchived
});




}
/// @nodoc
class _$ChatConversationResponseCopyWithImpl<$Res>
    implements $ChatConversationResponseCopyWith<$Res> {
  _$ChatConversationResponseCopyWithImpl(this._self, this._then);

  final ChatConversationResponse _self;
  final $Res Function(ChatConversationResponse) _then;

/// Create a copy of ChatConversationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? scopeKind = null,Object? scopeKey = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? name = freezed,Object? discussionRootMessageId = freezed,Object? version = null,Object? createdAtUtc = null,Object? postingPermission = null,Object? isArchived = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatConversationType,scopeKind: null == scopeKind ? _self.scopeKind : scopeKind // ignore: cast_nullable_to_non_nullable
as ChatScopeKind,scopeKey: null == scopeKey ? _self.scopeKey : scopeKey // ignore: cast_nullable_to_non_nullable
as String,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,discussionRootMessageId: freezed == discussionRootMessageId ? _self.discussionRootMessageId : discussionRootMessageId // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,postingPermission: null == postingPermission ? _self.postingPermission : postingPermission // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatConversationResponse].
extension ChatConversationResponsePatterns on ChatConversationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatConversationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatConversationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatConversationResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatConversationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatConversationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatConversationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ChatConversationType type,  ChatScopeKind scopeKind,  String scopeKey,  String? workspaceId,  String? projectId,  String? name,  String? discussionRootMessageId,  int version,  DateTime createdAtUtc,  String postingPermission,  bool isArchived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatConversationResponse() when $default != null:
return $default(_that.id,_that.type,_that.scopeKind,_that.scopeKey,_that.workspaceId,_that.projectId,_that.name,_that.discussionRootMessageId,_that.version,_that.createdAtUtc,_that.postingPermission,_that.isArchived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ChatConversationType type,  ChatScopeKind scopeKind,  String scopeKey,  String? workspaceId,  String? projectId,  String? name,  String? discussionRootMessageId,  int version,  DateTime createdAtUtc,  String postingPermission,  bool isArchived)  $default,) {final _that = this;
switch (_that) {
case _ChatConversationResponse():
return $default(_that.id,_that.type,_that.scopeKind,_that.scopeKey,_that.workspaceId,_that.projectId,_that.name,_that.discussionRootMessageId,_that.version,_that.createdAtUtc,_that.postingPermission,_that.isArchived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ChatConversationType type,  ChatScopeKind scopeKind,  String scopeKey,  String? workspaceId,  String? projectId,  String? name,  String? discussionRootMessageId,  int version,  DateTime createdAtUtc,  String postingPermission,  bool isArchived)?  $default,) {final _that = this;
switch (_that) {
case _ChatConversationResponse() when $default != null:
return $default(_that.id,_that.type,_that.scopeKind,_that.scopeKey,_that.workspaceId,_that.projectId,_that.name,_that.discussionRootMessageId,_that.version,_that.createdAtUtc,_that.postingPermission,_that.isArchived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatConversationResponse implements ChatConversationResponse {
  const _ChatConversationResponse({required this.id, required this.type, required this.scopeKind, required this.scopeKey, this.workspaceId, this.projectId, this.name, this.discussionRootMessageId, required this.version, required this.createdAtUtc, this.postingPermission = 'Everyone', this.isArchived = false});
  factory _ChatConversationResponse.fromJson(Map<String, dynamic> json) => _$ChatConversationResponseFromJson(json);

@override final  String id;
@override final  ChatConversationType type;
@override final  ChatScopeKind scopeKind;
@override final  String scopeKey;
@override final  String? workspaceId;
@override final  String? projectId;
@override final  String? name;
@override final  String? discussionRootMessageId;
@override final  int version;
@override final  DateTime createdAtUtc;
@override@JsonKey() final  String postingPermission;
@override@JsonKey() final  bool isArchived;

/// Create a copy of ChatConversationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatConversationResponseCopyWith<_ChatConversationResponse> get copyWith => __$ChatConversationResponseCopyWithImpl<_ChatConversationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatConversationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatConversationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.scopeKind, scopeKind) || other.scopeKind == scopeKind)&&(identical(other.scopeKey, scopeKey) || other.scopeKey == scopeKey)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.discussionRootMessageId, discussionRootMessageId) || other.discussionRootMessageId == discussionRootMessageId)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.postingPermission, postingPermission) || other.postingPermission == postingPermission)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,scopeKind,scopeKey,workspaceId,projectId,name,discussionRootMessageId,version,createdAtUtc,postingPermission,isArchived);

@override
String toString() {
  return 'ChatConversationResponse(id: $id, type: $type, scopeKind: $scopeKind, scopeKey: $scopeKey, workspaceId: $workspaceId, projectId: $projectId, name: $name, discussionRootMessageId: $discussionRootMessageId, version: $version, createdAtUtc: $createdAtUtc, postingPermission: $postingPermission, isArchived: $isArchived)';
}


}

/// @nodoc
abstract mixin class _$ChatConversationResponseCopyWith<$Res> implements $ChatConversationResponseCopyWith<$Res> {
  factory _$ChatConversationResponseCopyWith(_ChatConversationResponse value, $Res Function(_ChatConversationResponse) _then) = __$ChatConversationResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, ChatConversationType type, ChatScopeKind scopeKind, String scopeKey, String? workspaceId, String? projectId, String? name, String? discussionRootMessageId, int version, DateTime createdAtUtc, String postingPermission, bool isArchived
});




}
/// @nodoc
class __$ChatConversationResponseCopyWithImpl<$Res>
    implements _$ChatConversationResponseCopyWith<$Res> {
  __$ChatConversationResponseCopyWithImpl(this._self, this._then);

  final _ChatConversationResponse _self;
  final $Res Function(_ChatConversationResponse) _then;

/// Create a copy of ChatConversationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? scopeKind = null,Object? scopeKey = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? name = freezed,Object? discussionRootMessageId = freezed,Object? version = null,Object? createdAtUtc = null,Object? postingPermission = null,Object? isArchived = null,}) {
  return _then(_ChatConversationResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatConversationType,scopeKind: null == scopeKind ? _self.scopeKind : scopeKind // ignore: cast_nullable_to_non_nullable
as ChatScopeKind,scopeKey: null == scopeKey ? _self.scopeKey : scopeKey // ignore: cast_nullable_to_non_nullable
as String,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,discussionRootMessageId: freezed == discussionRootMessageId ? _self.discussionRootMessageId : discussionRootMessageId // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,postingPermission: null == postingPermission ? _self.postingPermission : postingPermission // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AddChatMembersPayload {

 List<String>? get userIds;
/// Create a copy of AddChatMembersPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddChatMembersPayloadCopyWith<AddChatMembersPayload> get copyWith => _$AddChatMembersPayloadCopyWithImpl<AddChatMembersPayload>(this as AddChatMembersPayload, _$identity);

  /// Serializes this AddChatMembersPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddChatMembersPayload&&const DeepCollectionEquality().equals(other.userIds, userIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(userIds));

@override
String toString() {
  return 'AddChatMembersPayload(userIds: $userIds)';
}


}

/// @nodoc
abstract mixin class $AddChatMembersPayloadCopyWith<$Res>  {
  factory $AddChatMembersPayloadCopyWith(AddChatMembersPayload value, $Res Function(AddChatMembersPayload) _then) = _$AddChatMembersPayloadCopyWithImpl;
@useResult
$Res call({
 List<String>? userIds
});




}
/// @nodoc
class _$AddChatMembersPayloadCopyWithImpl<$Res>
    implements $AddChatMembersPayloadCopyWith<$Res> {
  _$AddChatMembersPayloadCopyWithImpl(this._self, this._then);

  final AddChatMembersPayload _self;
  final $Res Function(AddChatMembersPayload) _then;

/// Create a copy of AddChatMembersPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userIds = freezed,}) {
  return _then(_self.copyWith(
userIds: freezed == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddChatMembersPayload].
extension AddChatMembersPayloadPatterns on AddChatMembersPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddChatMembersPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddChatMembersPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddChatMembersPayload value)  $default,){
final _that = this;
switch (_that) {
case _AddChatMembersPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddChatMembersPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AddChatMembersPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String>? userIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddChatMembersPayload() when $default != null:
return $default(_that.userIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String>? userIds)  $default,) {final _that = this;
switch (_that) {
case _AddChatMembersPayload():
return $default(_that.userIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String>? userIds)?  $default,) {final _that = this;
switch (_that) {
case _AddChatMembersPayload() when $default != null:
return $default(_that.userIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddChatMembersPayload implements AddChatMembersPayload {
  const _AddChatMembersPayload({this.userIds});
  factory _AddChatMembersPayload.fromJson(Map<String, dynamic> json) => _$AddChatMembersPayloadFromJson(json);

@override final  List<String>? userIds;

/// Create a copy of AddChatMembersPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddChatMembersPayloadCopyWith<_AddChatMembersPayload> get copyWith => __$AddChatMembersPayloadCopyWithImpl<_AddChatMembersPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddChatMembersPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddChatMembersPayload&&const DeepCollectionEquality().equals(other.userIds, userIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(userIds));

@override
String toString() {
  return 'AddChatMembersPayload(userIds: $userIds)';
}


}

/// @nodoc
abstract mixin class _$AddChatMembersPayloadCopyWith<$Res> implements $AddChatMembersPayloadCopyWith<$Res> {
  factory _$AddChatMembersPayloadCopyWith(_AddChatMembersPayload value, $Res Function(_AddChatMembersPayload) _then) = __$AddChatMembersPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String>? userIds
});




}
/// @nodoc
class __$AddChatMembersPayloadCopyWithImpl<$Res>
    implements _$AddChatMembersPayloadCopyWith<$Res> {
  __$AddChatMembersPayloadCopyWithImpl(this._self, this._then);

  final _AddChatMembersPayload _self;
  final $Res Function(_AddChatMembersPayload) _then;

/// Create a copy of AddChatMembersPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userIds = freezed,}) {
  return _then(_AddChatMembersPayload(
userIds: freezed == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$UpdateChatMemberRolePayload {

 String get role;
/// Create a copy of UpdateChatMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateChatMemberRolePayloadCopyWith<UpdateChatMemberRolePayload> get copyWith => _$UpdateChatMemberRolePayloadCopyWithImpl<UpdateChatMemberRolePayload>(this as UpdateChatMemberRolePayload, _$identity);

  /// Serializes this UpdateChatMemberRolePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChatMemberRolePayload&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'UpdateChatMemberRolePayload(role: $role)';
}


}

/// @nodoc
abstract mixin class $UpdateChatMemberRolePayloadCopyWith<$Res>  {
  factory $UpdateChatMemberRolePayloadCopyWith(UpdateChatMemberRolePayload value, $Res Function(UpdateChatMemberRolePayload) _then) = _$UpdateChatMemberRolePayloadCopyWithImpl;
@useResult
$Res call({
 String role
});




}
/// @nodoc
class _$UpdateChatMemberRolePayloadCopyWithImpl<$Res>
    implements $UpdateChatMemberRolePayloadCopyWith<$Res> {
  _$UpdateChatMemberRolePayloadCopyWithImpl(this._self, this._then);

  final UpdateChatMemberRolePayload _self;
  final $Res Function(UpdateChatMemberRolePayload) _then;

/// Create a copy of UpdateChatMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateChatMemberRolePayload].
extension UpdateChatMemberRolePayloadPatterns on UpdateChatMemberRolePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateChatMemberRolePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateChatMemberRolePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateChatMemberRolePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload() when $default != null:
return $default(_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role)  $default,) {final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload():
return $default(_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role)?  $default,) {final _that = this;
switch (_that) {
case _UpdateChatMemberRolePayload() when $default != null:
return $default(_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateChatMemberRolePayload implements UpdateChatMemberRolePayload {
  const _UpdateChatMemberRolePayload({required this.role});
  factory _UpdateChatMemberRolePayload.fromJson(Map<String, dynamic> json) => _$UpdateChatMemberRolePayloadFromJson(json);

@override final  String role;

/// Create a copy of UpdateChatMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateChatMemberRolePayloadCopyWith<_UpdateChatMemberRolePayload> get copyWith => __$UpdateChatMemberRolePayloadCopyWithImpl<_UpdateChatMemberRolePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateChatMemberRolePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateChatMemberRolePayload&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'UpdateChatMemberRolePayload(role: $role)';
}


}

/// @nodoc
abstract mixin class _$UpdateChatMemberRolePayloadCopyWith<$Res> implements $UpdateChatMemberRolePayloadCopyWith<$Res> {
  factory _$UpdateChatMemberRolePayloadCopyWith(_UpdateChatMemberRolePayload value, $Res Function(_UpdateChatMemberRolePayload) _then) = __$UpdateChatMemberRolePayloadCopyWithImpl;
@override @useResult
$Res call({
 String role
});




}
/// @nodoc
class __$UpdateChatMemberRolePayloadCopyWithImpl<$Res>
    implements _$UpdateChatMemberRolePayloadCopyWith<$Res> {
  __$UpdateChatMemberRolePayloadCopyWithImpl(this._self, this._then);

  final _UpdateChatMemberRolePayload _self;
  final $Res Function(_UpdateChatMemberRolePayload) _then;

/// Create a copy of UpdateChatMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,}) {
  return _then(_UpdateChatMemberRolePayload(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ChatMemberResponse {

 String get userId; String get role; DateTime get joinedAtUtc; String? get login; String? get displayName; String? get avatarUrl;
/// Create a copy of ChatMemberResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMemberResponseCopyWith<ChatMemberResponse> get copyWith => _$ChatMemberResponseCopyWithImpl<ChatMemberResponse>(this as ChatMemberResponse, _$identity);

  /// Serializes this ChatMemberResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMemberResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAtUtc, joinedAtUtc) || other.joinedAtUtc == joinedAtUtc)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,role,joinedAtUtc,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatMemberResponse(userId: $userId, role: $role, joinedAtUtc: $joinedAtUtc, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ChatMemberResponseCopyWith<$Res>  {
  factory $ChatMemberResponseCopyWith(ChatMemberResponse value, $Res Function(ChatMemberResponse) _then) = _$ChatMemberResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String role, DateTime joinedAtUtc, String? login, String? displayName, String? avatarUrl
});




}
/// @nodoc
class _$ChatMemberResponseCopyWithImpl<$Res>
    implements $ChatMemberResponseCopyWith<$Res> {
  _$ChatMemberResponseCopyWithImpl(this._self, this._then);

  final ChatMemberResponse _self;
  final $Res Function(ChatMemberResponse) _then;

/// Create a copy of ChatMemberResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? role = null,Object? joinedAtUtc = null,Object? login = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,joinedAtUtc: null == joinedAtUtc ? _self.joinedAtUtc : joinedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,login: freezed == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMemberResponse].
extension ChatMemberResponsePatterns on ChatMemberResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMemberResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMemberResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMemberResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatMemberResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMemberResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMemberResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String role,  DateTime joinedAtUtc,  String? login,  String? displayName,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMemberResponse() when $default != null:
return $default(_that.userId,_that.role,_that.joinedAtUtc,_that.login,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String role,  DateTime joinedAtUtc,  String? login,  String? displayName,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ChatMemberResponse():
return $default(_that.userId,_that.role,_that.joinedAtUtc,_that.login,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String role,  DateTime joinedAtUtc,  String? login,  String? displayName,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ChatMemberResponse() when $default != null:
return $default(_that.userId,_that.role,_that.joinedAtUtc,_that.login,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMemberResponse implements ChatMemberResponse {
  const _ChatMemberResponse({required this.userId, required this.role, required this.joinedAtUtc, this.login, this.displayName, this.avatarUrl});
  factory _ChatMemberResponse.fromJson(Map<String, dynamic> json) => _$ChatMemberResponseFromJson(json);

@override final  String userId;
@override final  String role;
@override final  DateTime joinedAtUtc;
@override final  String? login;
@override final  String? displayName;
@override final  String? avatarUrl;

/// Create a copy of ChatMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMemberResponseCopyWith<_ChatMemberResponse> get copyWith => __$ChatMemberResponseCopyWithImpl<_ChatMemberResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMemberResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMemberResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAtUtc, joinedAtUtc) || other.joinedAtUtc == joinedAtUtc)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,role,joinedAtUtc,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatMemberResponse(userId: $userId, role: $role, joinedAtUtc: $joinedAtUtc, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ChatMemberResponseCopyWith<$Res> implements $ChatMemberResponseCopyWith<$Res> {
  factory _$ChatMemberResponseCopyWith(_ChatMemberResponse value, $Res Function(_ChatMemberResponse) _then) = __$ChatMemberResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String role, DateTime joinedAtUtc, String? login, String? displayName, String? avatarUrl
});




}
/// @nodoc
class __$ChatMemberResponseCopyWithImpl<$Res>
    implements _$ChatMemberResponseCopyWith<$Res> {
  __$ChatMemberResponseCopyWithImpl(this._self, this._then);

  final _ChatMemberResponse _self;
  final $Res Function(_ChatMemberResponse) _then;

/// Create a copy of ChatMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? role = null,Object? joinedAtUtc = null,Object? login = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_ChatMemberResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,joinedAtUtc: null == joinedAtUtc ? _self.joinedAtUtc : joinedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,login: freezed == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChatMentionSuggestionResponse {

 String get userId; String get login; String get displayName; String? get avatarUrl;
/// Create a copy of ChatMentionSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMentionSuggestionResponseCopyWith<ChatMentionSuggestionResponse> get copyWith => _$ChatMentionSuggestionResponseCopyWithImpl<ChatMentionSuggestionResponse>(this as ChatMentionSuggestionResponse, _$identity);

  /// Serializes this ChatMentionSuggestionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMentionSuggestionResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatMentionSuggestionResponse(userId: $userId, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ChatMentionSuggestionResponseCopyWith<$Res>  {
  factory $ChatMentionSuggestionResponseCopyWith(ChatMentionSuggestionResponse value, $Res Function(ChatMentionSuggestionResponse) _then) = _$ChatMentionSuggestionResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String login, String displayName, String? avatarUrl
});




}
/// @nodoc
class _$ChatMentionSuggestionResponseCopyWithImpl<$Res>
    implements $ChatMentionSuggestionResponseCopyWith<$Res> {
  _$ChatMentionSuggestionResponseCopyWithImpl(this._self, this._then);

  final ChatMentionSuggestionResponse _self;
  final $Res Function(ChatMentionSuggestionResponse) _then;

/// Create a copy of ChatMentionSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? login = null,Object? displayName = null,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMentionSuggestionResponse].
extension ChatMentionSuggestionResponsePatterns on ChatMentionSuggestionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMentionSuggestionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMentionSuggestionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMentionSuggestionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatMentionSuggestionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMentionSuggestionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMentionSuggestionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String login,  String displayName,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMentionSuggestionResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String login,  String displayName,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ChatMentionSuggestionResponse():
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String login,  String displayName,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ChatMentionSuggestionResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMentionSuggestionResponse implements ChatMentionSuggestionResponse {
  const _ChatMentionSuggestionResponse({required this.userId, required this.login, required this.displayName, this.avatarUrl});
  factory _ChatMentionSuggestionResponse.fromJson(Map<String, dynamic> json) => _$ChatMentionSuggestionResponseFromJson(json);

@override final  String userId;
@override final  String login;
@override final  String displayName;
@override final  String? avatarUrl;

/// Create a copy of ChatMentionSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMentionSuggestionResponseCopyWith<_ChatMentionSuggestionResponse> get copyWith => __$ChatMentionSuggestionResponseCopyWithImpl<_ChatMentionSuggestionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMentionSuggestionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMentionSuggestionResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatMentionSuggestionResponse(userId: $userId, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ChatMentionSuggestionResponseCopyWith<$Res> implements $ChatMentionSuggestionResponseCopyWith<$Res> {
  factory _$ChatMentionSuggestionResponseCopyWith(_ChatMentionSuggestionResponse value, $Res Function(_ChatMentionSuggestionResponse) _then) = __$ChatMentionSuggestionResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String login, String displayName, String? avatarUrl
});




}
/// @nodoc
class __$ChatMentionSuggestionResponseCopyWithImpl<$Res>
    implements _$ChatMentionSuggestionResponseCopyWith<$Res> {
  __$ChatMentionSuggestionResponseCopyWithImpl(this._self, this._then);

  final _ChatMentionSuggestionResponse _self;
  final $Res Function(_ChatMentionSuggestionResponse) _then;

/// Create a copy of ChatMentionSuggestionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? login = null,Object? displayName = null,Object? avatarUrl = freezed,}) {
  return _then(_ChatMentionSuggestionResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SendChatMessagePayload {

 String get clientMessageId; String get text; String? get deltaJson; String? get replyToMessageId; List<String>? get attachmentFileIds;
/// Create a copy of SendChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendChatMessagePayloadCopyWith<SendChatMessagePayload> get copyWith => _$SendChatMessagePayloadCopyWithImpl<SendChatMessagePayload>(this as SendChatMessagePayload, _$identity);

  /// Serializes this SendChatMessagePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendChatMessagePayload&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&const DeepCollectionEquality().equals(other.attachmentFileIds, attachmentFileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientMessageId,text,deltaJson,replyToMessageId,const DeepCollectionEquality().hash(attachmentFileIds));

@override
String toString() {
  return 'SendChatMessagePayload(clientMessageId: $clientMessageId, text: $text, deltaJson: $deltaJson, replyToMessageId: $replyToMessageId, attachmentFileIds: $attachmentFileIds)';
}


}

/// @nodoc
abstract mixin class $SendChatMessagePayloadCopyWith<$Res>  {
  factory $SendChatMessagePayloadCopyWith(SendChatMessagePayload value, $Res Function(SendChatMessagePayload) _then) = _$SendChatMessagePayloadCopyWithImpl;
@useResult
$Res call({
 String clientMessageId, String text, String? deltaJson, String? replyToMessageId, List<String>? attachmentFileIds
});




}
/// @nodoc
class _$SendChatMessagePayloadCopyWithImpl<$Res>
    implements $SendChatMessagePayloadCopyWith<$Res> {
  _$SendChatMessagePayloadCopyWithImpl(this._self, this._then);

  final SendChatMessagePayload _self;
  final $Res Function(SendChatMessagePayload) _then;

/// Create a copy of SendChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientMessageId = null,Object? text = null,Object? deltaJson = freezed,Object? replyToMessageId = freezed,Object? attachmentFileIds = freezed,}) {
  return _then(_self.copyWith(
clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,attachmentFileIds: freezed == attachmentFileIds ? _self.attachmentFileIds : attachmentFileIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SendChatMessagePayload].
extension SendChatMessagePayloadPatterns on SendChatMessagePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendChatMessagePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendChatMessagePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendChatMessagePayload value)  $default,){
final _that = this;
switch (_that) {
case _SendChatMessagePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendChatMessagePayload value)?  $default,){
final _that = this;
switch (_that) {
case _SendChatMessagePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientMessageId,  String text,  String? deltaJson,  String? replyToMessageId,  List<String>? attachmentFileIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendChatMessagePayload() when $default != null:
return $default(_that.clientMessageId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.attachmentFileIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientMessageId,  String text,  String? deltaJson,  String? replyToMessageId,  List<String>? attachmentFileIds)  $default,) {final _that = this;
switch (_that) {
case _SendChatMessagePayload():
return $default(_that.clientMessageId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.attachmentFileIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientMessageId,  String text,  String? deltaJson,  String? replyToMessageId,  List<String>? attachmentFileIds)?  $default,) {final _that = this;
switch (_that) {
case _SendChatMessagePayload() when $default != null:
return $default(_that.clientMessageId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.attachmentFileIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendChatMessagePayload implements SendChatMessagePayload {
  const _SendChatMessagePayload({required this.clientMessageId, required this.text, this.deltaJson, this.replyToMessageId, this.attachmentFileIds});
  factory _SendChatMessagePayload.fromJson(Map<String, dynamic> json) => _$SendChatMessagePayloadFromJson(json);

@override final  String clientMessageId;
@override final  String text;
@override final  String? deltaJson;
@override final  String? replyToMessageId;
@override final  List<String>? attachmentFileIds;

/// Create a copy of SendChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendChatMessagePayloadCopyWith<_SendChatMessagePayload> get copyWith => __$SendChatMessagePayloadCopyWithImpl<_SendChatMessagePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendChatMessagePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendChatMessagePayload&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&const DeepCollectionEquality().equals(other.attachmentFileIds, attachmentFileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientMessageId,text,deltaJson,replyToMessageId,const DeepCollectionEquality().hash(attachmentFileIds));

@override
String toString() {
  return 'SendChatMessagePayload(clientMessageId: $clientMessageId, text: $text, deltaJson: $deltaJson, replyToMessageId: $replyToMessageId, attachmentFileIds: $attachmentFileIds)';
}


}

/// @nodoc
abstract mixin class _$SendChatMessagePayloadCopyWith<$Res> implements $SendChatMessagePayloadCopyWith<$Res> {
  factory _$SendChatMessagePayloadCopyWith(_SendChatMessagePayload value, $Res Function(_SendChatMessagePayload) _then) = __$SendChatMessagePayloadCopyWithImpl;
@override @useResult
$Res call({
 String clientMessageId, String text, String? deltaJson, String? replyToMessageId, List<String>? attachmentFileIds
});




}
/// @nodoc
class __$SendChatMessagePayloadCopyWithImpl<$Res>
    implements _$SendChatMessagePayloadCopyWith<$Res> {
  __$SendChatMessagePayloadCopyWithImpl(this._self, this._then);

  final _SendChatMessagePayload _self;
  final $Res Function(_SendChatMessagePayload) _then;

/// Create a copy of SendChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientMessageId = null,Object? text = null,Object? deltaJson = freezed,Object? replyToMessageId = freezed,Object? attachmentFileIds = freezed,}) {
  return _then(_SendChatMessagePayload(
clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,attachmentFileIds: freezed == attachmentFileIds ? _self.attachmentFileIds : attachmentFileIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$UpdateChatMessagePayload {

 String get text; String? get deltaJson; int get version;
/// Create a copy of UpdateChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateChatMessagePayloadCopyWith<UpdateChatMessagePayload> get copyWith => _$UpdateChatMessagePayloadCopyWithImpl<UpdateChatMessagePayload>(this as UpdateChatMessagePayload, _$identity);

  /// Serializes this UpdateChatMessagePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChatMessagePayload&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,deltaJson,version);

@override
String toString() {
  return 'UpdateChatMessagePayload(text: $text, deltaJson: $deltaJson, version: $version)';
}


}

/// @nodoc
abstract mixin class $UpdateChatMessagePayloadCopyWith<$Res>  {
  factory $UpdateChatMessagePayloadCopyWith(UpdateChatMessagePayload value, $Res Function(UpdateChatMessagePayload) _then) = _$UpdateChatMessagePayloadCopyWithImpl;
@useResult
$Res call({
 String text, String? deltaJson, int version
});




}
/// @nodoc
class _$UpdateChatMessagePayloadCopyWithImpl<$Res>
    implements $UpdateChatMessagePayloadCopyWith<$Res> {
  _$UpdateChatMessagePayloadCopyWithImpl(this._self, this._then);

  final UpdateChatMessagePayload _self;
  final $Res Function(UpdateChatMessagePayload) _then;

/// Create a copy of UpdateChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? deltaJson = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateChatMessagePayload].
extension UpdateChatMessagePayloadPatterns on UpdateChatMessagePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateChatMessagePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateChatMessagePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateChatMessagePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateChatMessagePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateChatMessagePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateChatMessagePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String? deltaJson,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateChatMessagePayload() when $default != null:
return $default(_that.text,_that.deltaJson,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String? deltaJson,  int version)  $default,) {final _that = this;
switch (_that) {
case _UpdateChatMessagePayload():
return $default(_that.text,_that.deltaJson,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String? deltaJson,  int version)?  $default,) {final _that = this;
switch (_that) {
case _UpdateChatMessagePayload() when $default != null:
return $default(_that.text,_that.deltaJson,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateChatMessagePayload implements UpdateChatMessagePayload {
  const _UpdateChatMessagePayload({required this.text, this.deltaJson, required this.version});
  factory _UpdateChatMessagePayload.fromJson(Map<String, dynamic> json) => _$UpdateChatMessagePayloadFromJson(json);

@override final  String text;
@override final  String? deltaJson;
@override final  int version;

/// Create a copy of UpdateChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateChatMessagePayloadCopyWith<_UpdateChatMessagePayload> get copyWith => __$UpdateChatMessagePayloadCopyWithImpl<_UpdateChatMessagePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateChatMessagePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateChatMessagePayload&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,deltaJson,version);

@override
String toString() {
  return 'UpdateChatMessagePayload(text: $text, deltaJson: $deltaJson, version: $version)';
}


}

/// @nodoc
abstract mixin class _$UpdateChatMessagePayloadCopyWith<$Res> implements $UpdateChatMessagePayloadCopyWith<$Res> {
  factory _$UpdateChatMessagePayloadCopyWith(_UpdateChatMessagePayload value, $Res Function(_UpdateChatMessagePayload) _then) = __$UpdateChatMessagePayloadCopyWithImpl;
@override @useResult
$Res call({
 String text, String? deltaJson, int version
});




}
/// @nodoc
class __$UpdateChatMessagePayloadCopyWithImpl<$Res>
    implements _$UpdateChatMessagePayloadCopyWith<$Res> {
  __$UpdateChatMessagePayloadCopyWithImpl(this._self, this._then);

  final _UpdateChatMessagePayload _self;
  final $Res Function(_UpdateChatMessagePayload) _then;

/// Create a copy of UpdateChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? deltaJson = freezed,Object? version = null,}) {
  return _then(_UpdateChatMessagePayload(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ForwardChatMessagePayload {

 String get targetConversationId; String get clientMessageId;
/// Create a copy of ForwardChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForwardChatMessagePayloadCopyWith<ForwardChatMessagePayload> get copyWith => _$ForwardChatMessagePayloadCopyWithImpl<ForwardChatMessagePayload>(this as ForwardChatMessagePayload, _$identity);

  /// Serializes this ForwardChatMessagePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForwardChatMessagePayload&&(identical(other.targetConversationId, targetConversationId) || other.targetConversationId == targetConversationId)&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetConversationId,clientMessageId);

@override
String toString() {
  return 'ForwardChatMessagePayload(targetConversationId: $targetConversationId, clientMessageId: $clientMessageId)';
}


}

/// @nodoc
abstract mixin class $ForwardChatMessagePayloadCopyWith<$Res>  {
  factory $ForwardChatMessagePayloadCopyWith(ForwardChatMessagePayload value, $Res Function(ForwardChatMessagePayload) _then) = _$ForwardChatMessagePayloadCopyWithImpl;
@useResult
$Res call({
 String targetConversationId, String clientMessageId
});




}
/// @nodoc
class _$ForwardChatMessagePayloadCopyWithImpl<$Res>
    implements $ForwardChatMessagePayloadCopyWith<$Res> {
  _$ForwardChatMessagePayloadCopyWithImpl(this._self, this._then);

  final ForwardChatMessagePayload _self;
  final $Res Function(ForwardChatMessagePayload) _then;

/// Create a copy of ForwardChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetConversationId = null,Object? clientMessageId = null,}) {
  return _then(_self.copyWith(
targetConversationId: null == targetConversationId ? _self.targetConversationId : targetConversationId // ignore: cast_nullable_to_non_nullable
as String,clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ForwardChatMessagePayload].
extension ForwardChatMessagePayloadPatterns on ForwardChatMessagePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForwardChatMessagePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForwardChatMessagePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForwardChatMessagePayload value)  $default,){
final _that = this;
switch (_that) {
case _ForwardChatMessagePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForwardChatMessagePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ForwardChatMessagePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String targetConversationId,  String clientMessageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForwardChatMessagePayload() when $default != null:
return $default(_that.targetConversationId,_that.clientMessageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String targetConversationId,  String clientMessageId)  $default,) {final _that = this;
switch (_that) {
case _ForwardChatMessagePayload():
return $default(_that.targetConversationId,_that.clientMessageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String targetConversationId,  String clientMessageId)?  $default,) {final _that = this;
switch (_that) {
case _ForwardChatMessagePayload() when $default != null:
return $default(_that.targetConversationId,_that.clientMessageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForwardChatMessagePayload implements ForwardChatMessagePayload {
  const _ForwardChatMessagePayload({required this.targetConversationId, required this.clientMessageId});
  factory _ForwardChatMessagePayload.fromJson(Map<String, dynamic> json) => _$ForwardChatMessagePayloadFromJson(json);

@override final  String targetConversationId;
@override final  String clientMessageId;

/// Create a copy of ForwardChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForwardChatMessagePayloadCopyWith<_ForwardChatMessagePayload> get copyWith => __$ForwardChatMessagePayloadCopyWithImpl<_ForwardChatMessagePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForwardChatMessagePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForwardChatMessagePayload&&(identical(other.targetConversationId, targetConversationId) || other.targetConversationId == targetConversationId)&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetConversationId,clientMessageId);

@override
String toString() {
  return 'ForwardChatMessagePayload(targetConversationId: $targetConversationId, clientMessageId: $clientMessageId)';
}


}

/// @nodoc
abstract mixin class _$ForwardChatMessagePayloadCopyWith<$Res> implements $ForwardChatMessagePayloadCopyWith<$Res> {
  factory _$ForwardChatMessagePayloadCopyWith(_ForwardChatMessagePayload value, $Res Function(_ForwardChatMessagePayload) _then) = __$ForwardChatMessagePayloadCopyWithImpl;
@override @useResult
$Res call({
 String targetConversationId, String clientMessageId
});




}
/// @nodoc
class __$ForwardChatMessagePayloadCopyWithImpl<$Res>
    implements _$ForwardChatMessagePayloadCopyWith<$Res> {
  __$ForwardChatMessagePayloadCopyWithImpl(this._self, this._then);

  final _ForwardChatMessagePayload _self;
  final $Res Function(_ForwardChatMessagePayload) _then;

/// Create a copy of ForwardChatMessagePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetConversationId = null,Object? clientMessageId = null,}) {
  return _then(_ForwardChatMessagePayload(
targetConversationId: null == targetConversationId ? _self.targetConversationId : targetConversationId // ignore: cast_nullable_to_non_nullable
as String,clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ChatMessageRevisionResponse {

 String get id; String get messageId; String get authorUserId; String get editedByUserId; String get text; String? get deltaJson; DateTime get createdAtUtc; int get version; int get newVersion;
/// Create a copy of ChatMessageRevisionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageRevisionResponseCopyWith<ChatMessageRevisionResponse> get copyWith => _$ChatMessageRevisionResponseCopyWithImpl<ChatMessageRevisionResponse>(this as ChatMessageRevisionResponse, _$identity);

  /// Serializes this ChatMessageRevisionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageRevisionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.editedByUserId, editedByUserId) || other.editedByUserId == editedByUserId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.newVersion, newVersion) || other.newVersion == newVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,authorUserId,editedByUserId,text,deltaJson,createdAtUtc,version,newVersion);

@override
String toString() {
  return 'ChatMessageRevisionResponse(id: $id, messageId: $messageId, authorUserId: $authorUserId, editedByUserId: $editedByUserId, text: $text, deltaJson: $deltaJson, createdAtUtc: $createdAtUtc, version: $version, newVersion: $newVersion)';
}


}

/// @nodoc
abstract mixin class $ChatMessageRevisionResponseCopyWith<$Res>  {
  factory $ChatMessageRevisionResponseCopyWith(ChatMessageRevisionResponse value, $Res Function(ChatMessageRevisionResponse) _then) = _$ChatMessageRevisionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String messageId, String authorUserId, String editedByUserId, String text, String? deltaJson, DateTime createdAtUtc, int version, int newVersion
});




}
/// @nodoc
class _$ChatMessageRevisionResponseCopyWithImpl<$Res>
    implements $ChatMessageRevisionResponseCopyWith<$Res> {
  _$ChatMessageRevisionResponseCopyWithImpl(this._self, this._then);

  final ChatMessageRevisionResponse _self;
  final $Res Function(ChatMessageRevisionResponse) _then;

/// Create a copy of ChatMessageRevisionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messageId = null,Object? authorUserId = null,Object? editedByUserId = null,Object? text = null,Object? deltaJson = freezed,Object? createdAtUtc = null,Object? version = null,Object? newVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,editedByUserId: null == editedByUserId ? _self.editedByUserId : editedByUserId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,newVersion: null == newVersion ? _self.newVersion : newVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageRevisionResponse].
extension ChatMessageRevisionResponsePatterns on ChatMessageRevisionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageRevisionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageRevisionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageRevisionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageRevisionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageRevisionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageRevisionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messageId,  String authorUserId,  String editedByUserId,  String text,  String? deltaJson,  DateTime createdAtUtc,  int version,  int newVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageRevisionResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.authorUserId,_that.editedByUserId,_that.text,_that.deltaJson,_that.createdAtUtc,_that.version,_that.newVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messageId,  String authorUserId,  String editedByUserId,  String text,  String? deltaJson,  DateTime createdAtUtc,  int version,  int newVersion)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageRevisionResponse():
return $default(_that.id,_that.messageId,_that.authorUserId,_that.editedByUserId,_that.text,_that.deltaJson,_that.createdAtUtc,_that.version,_that.newVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messageId,  String authorUserId,  String editedByUserId,  String text,  String? deltaJson,  DateTime createdAtUtc,  int version,  int newVersion)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageRevisionResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.authorUserId,_that.editedByUserId,_that.text,_that.deltaJson,_that.createdAtUtc,_that.version,_that.newVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageRevisionResponse implements ChatMessageRevisionResponse {
  const _ChatMessageRevisionResponse({required this.id, required this.messageId, required this.authorUserId, required this.editedByUserId, required this.text, this.deltaJson, required this.createdAtUtc, required this.version, required this.newVersion});
  factory _ChatMessageRevisionResponse.fromJson(Map<String, dynamic> json) => _$ChatMessageRevisionResponseFromJson(json);

@override final  String id;
@override final  String messageId;
@override final  String authorUserId;
@override final  String editedByUserId;
@override final  String text;
@override final  String? deltaJson;
@override final  DateTime createdAtUtc;
@override final  int version;
@override final  int newVersion;

/// Create a copy of ChatMessageRevisionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageRevisionResponseCopyWith<_ChatMessageRevisionResponse> get copyWith => __$ChatMessageRevisionResponseCopyWithImpl<_ChatMessageRevisionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageRevisionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageRevisionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.editedByUserId, editedByUserId) || other.editedByUserId == editedByUserId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.newVersion, newVersion) || other.newVersion == newVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,authorUserId,editedByUserId,text,deltaJson,createdAtUtc,version,newVersion);

@override
String toString() {
  return 'ChatMessageRevisionResponse(id: $id, messageId: $messageId, authorUserId: $authorUserId, editedByUserId: $editedByUserId, text: $text, deltaJson: $deltaJson, createdAtUtc: $createdAtUtc, version: $version, newVersion: $newVersion)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageRevisionResponseCopyWith<$Res> implements $ChatMessageRevisionResponseCopyWith<$Res> {
  factory _$ChatMessageRevisionResponseCopyWith(_ChatMessageRevisionResponse value, $Res Function(_ChatMessageRevisionResponse) _then) = __$ChatMessageRevisionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String messageId, String authorUserId, String editedByUserId, String text, String? deltaJson, DateTime createdAtUtc, int version, int newVersion
});




}
/// @nodoc
class __$ChatMessageRevisionResponseCopyWithImpl<$Res>
    implements _$ChatMessageRevisionResponseCopyWith<$Res> {
  __$ChatMessageRevisionResponseCopyWithImpl(this._self, this._then);

  final _ChatMessageRevisionResponse _self;
  final $Res Function(_ChatMessageRevisionResponse) _then;

/// Create a copy of ChatMessageRevisionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messageId = null,Object? authorUserId = null,Object? editedByUserId = null,Object? text = null,Object? deltaJson = freezed,Object? createdAtUtc = null,Object? version = null,Object? newVersion = null,}) {
  return _then(_ChatMessageRevisionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,editedByUserId: null == editedByUserId ? _self.editedByUserId : editedByUserId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,newVersion: null == newVersion ? _self.newVersion : newVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChatLinkResponse {

 String get url; String? get host; bool get isHttps; bool get isInternal; bool get previewAllowed;
/// Create a copy of ChatLinkResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatLinkResponseCopyWith<ChatLinkResponse> get copyWith => _$ChatLinkResponseCopyWithImpl<ChatLinkResponse>(this as ChatLinkResponse, _$identity);

  /// Serializes this ChatLinkResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatLinkResponse&&(identical(other.url, url) || other.url == url)&&(identical(other.host, host) || other.host == host)&&(identical(other.isHttps, isHttps) || other.isHttps == isHttps)&&(identical(other.isInternal, isInternal) || other.isInternal == isInternal)&&(identical(other.previewAllowed, previewAllowed) || other.previewAllowed == previewAllowed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,host,isHttps,isInternal,previewAllowed);

@override
String toString() {
  return 'ChatLinkResponse(url: $url, host: $host, isHttps: $isHttps, isInternal: $isInternal, previewAllowed: $previewAllowed)';
}


}

/// @nodoc
abstract mixin class $ChatLinkResponseCopyWith<$Res>  {
  factory $ChatLinkResponseCopyWith(ChatLinkResponse value, $Res Function(ChatLinkResponse) _then) = _$ChatLinkResponseCopyWithImpl;
@useResult
$Res call({
 String url, String? host, bool isHttps, bool isInternal, bool previewAllowed
});




}
/// @nodoc
class _$ChatLinkResponseCopyWithImpl<$Res>
    implements $ChatLinkResponseCopyWith<$Res> {
  _$ChatLinkResponseCopyWithImpl(this._self, this._then);

  final ChatLinkResponse _self;
  final $Res Function(ChatLinkResponse) _then;

/// Create a copy of ChatLinkResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? host = freezed,Object? isHttps = null,Object? isInternal = null,Object? previewAllowed = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,isHttps: null == isHttps ? _self.isHttps : isHttps // ignore: cast_nullable_to_non_nullable
as bool,isInternal: null == isInternal ? _self.isInternal : isInternal // ignore: cast_nullable_to_non_nullable
as bool,previewAllowed: null == previewAllowed ? _self.previewAllowed : previewAllowed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatLinkResponse].
extension ChatLinkResponsePatterns on ChatLinkResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatLinkResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatLinkResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatLinkResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatLinkResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatLinkResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatLinkResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String? host,  bool isHttps,  bool isInternal,  bool previewAllowed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatLinkResponse() when $default != null:
return $default(_that.url,_that.host,_that.isHttps,_that.isInternal,_that.previewAllowed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String? host,  bool isHttps,  bool isInternal,  bool previewAllowed)  $default,) {final _that = this;
switch (_that) {
case _ChatLinkResponse():
return $default(_that.url,_that.host,_that.isHttps,_that.isInternal,_that.previewAllowed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String? host,  bool isHttps,  bool isInternal,  bool previewAllowed)?  $default,) {final _that = this;
switch (_that) {
case _ChatLinkResponse() when $default != null:
return $default(_that.url,_that.host,_that.isHttps,_that.isInternal,_that.previewAllowed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatLinkResponse implements ChatLinkResponse {
  const _ChatLinkResponse({required this.url, this.host, required this.isHttps, required this.isInternal, required this.previewAllowed});
  factory _ChatLinkResponse.fromJson(Map<String, dynamic> json) => _$ChatLinkResponseFromJson(json);

@override final  String url;
@override final  String? host;
@override final  bool isHttps;
@override final  bool isInternal;
@override final  bool previewAllowed;

/// Create a copy of ChatLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatLinkResponseCopyWith<_ChatLinkResponse> get copyWith => __$ChatLinkResponseCopyWithImpl<_ChatLinkResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatLinkResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatLinkResponse&&(identical(other.url, url) || other.url == url)&&(identical(other.host, host) || other.host == host)&&(identical(other.isHttps, isHttps) || other.isHttps == isHttps)&&(identical(other.isInternal, isInternal) || other.isInternal == isInternal)&&(identical(other.previewAllowed, previewAllowed) || other.previewAllowed == previewAllowed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,host,isHttps,isInternal,previewAllowed);

@override
String toString() {
  return 'ChatLinkResponse(url: $url, host: $host, isHttps: $isHttps, isInternal: $isInternal, previewAllowed: $previewAllowed)';
}


}

/// @nodoc
abstract mixin class _$ChatLinkResponseCopyWith<$Res> implements $ChatLinkResponseCopyWith<$Res> {
  factory _$ChatLinkResponseCopyWith(_ChatLinkResponse value, $Res Function(_ChatLinkResponse) _then) = __$ChatLinkResponseCopyWithImpl;
@override @useResult
$Res call({
 String url, String? host, bool isHttps, bool isInternal, bool previewAllowed
});




}
/// @nodoc
class __$ChatLinkResponseCopyWithImpl<$Res>
    implements _$ChatLinkResponseCopyWith<$Res> {
  __$ChatLinkResponseCopyWithImpl(this._self, this._then);

  final _ChatLinkResponse _self;
  final $Res Function(_ChatLinkResponse) _then;

/// Create a copy of ChatLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? host = freezed,Object? isHttps = null,Object? isInternal = null,Object? previewAllowed = null,}) {
  return _then(_ChatLinkResponse(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,isHttps: null == isHttps ? _self.isHttps : isHttps // ignore: cast_nullable_to_non_nullable
as bool,isInternal: null == isInternal ? _self.isInternal : isInternal // ignore: cast_nullable_to_non_nullable
as bool,previewAllowed: null == previewAllowed ? _self.previewAllowed : previewAllowed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatLinkPreviewResponse {

 String get finalUrl; String? get title; String? get description; String? get contentType; DateTime get fetchedAtUtc;
/// Create a copy of ChatLinkPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatLinkPreviewResponseCopyWith<ChatLinkPreviewResponse> get copyWith => _$ChatLinkPreviewResponseCopyWithImpl<ChatLinkPreviewResponse>(this as ChatLinkPreviewResponse, _$identity);

  /// Serializes this ChatLinkPreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatLinkPreviewResponse&&(identical(other.finalUrl, finalUrl) || other.finalUrl == finalUrl)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.fetchedAtUtc, fetchedAtUtc) || other.fetchedAtUtc == fetchedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,finalUrl,title,description,contentType,fetchedAtUtc);

@override
String toString() {
  return 'ChatLinkPreviewResponse(finalUrl: $finalUrl, title: $title, description: $description, contentType: $contentType, fetchedAtUtc: $fetchedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatLinkPreviewResponseCopyWith<$Res>  {
  factory $ChatLinkPreviewResponseCopyWith(ChatLinkPreviewResponse value, $Res Function(ChatLinkPreviewResponse) _then) = _$ChatLinkPreviewResponseCopyWithImpl;
@useResult
$Res call({
 String finalUrl, String? title, String? description, String? contentType, DateTime fetchedAtUtc
});




}
/// @nodoc
class _$ChatLinkPreviewResponseCopyWithImpl<$Res>
    implements $ChatLinkPreviewResponseCopyWith<$Res> {
  _$ChatLinkPreviewResponseCopyWithImpl(this._self, this._then);

  final ChatLinkPreviewResponse _self;
  final $Res Function(ChatLinkPreviewResponse) _then;

/// Create a copy of ChatLinkPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? finalUrl = null,Object? title = freezed,Object? description = freezed,Object? contentType = freezed,Object? fetchedAtUtc = null,}) {
  return _then(_self.copyWith(
finalUrl: null == finalUrl ? _self.finalUrl : finalUrl // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,fetchedAtUtc: null == fetchedAtUtc ? _self.fetchedAtUtc : fetchedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatLinkPreviewResponse].
extension ChatLinkPreviewResponsePatterns on ChatLinkPreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatLinkPreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatLinkPreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatLinkPreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String finalUrl,  String? title,  String? description,  String? contentType,  DateTime fetchedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse() when $default != null:
return $default(_that.finalUrl,_that.title,_that.description,_that.contentType,_that.fetchedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String finalUrl,  String? title,  String? description,  String? contentType,  DateTime fetchedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse():
return $default(_that.finalUrl,_that.title,_that.description,_that.contentType,_that.fetchedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String finalUrl,  String? title,  String? description,  String? contentType,  DateTime fetchedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse() when $default != null:
return $default(_that.finalUrl,_that.title,_that.description,_that.contentType,_that.fetchedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatLinkPreviewResponse implements ChatLinkPreviewResponse {
  const _ChatLinkPreviewResponse({required this.finalUrl, this.title, this.description, this.contentType, required this.fetchedAtUtc});
  factory _ChatLinkPreviewResponse.fromJson(Map<String, dynamic> json) => _$ChatLinkPreviewResponseFromJson(json);

@override final  String finalUrl;
@override final  String? title;
@override final  String? description;
@override final  String? contentType;
@override final  DateTime fetchedAtUtc;

/// Create a copy of ChatLinkPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatLinkPreviewResponseCopyWith<_ChatLinkPreviewResponse> get copyWith => __$ChatLinkPreviewResponseCopyWithImpl<_ChatLinkPreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatLinkPreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatLinkPreviewResponse&&(identical(other.finalUrl, finalUrl) || other.finalUrl == finalUrl)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.fetchedAtUtc, fetchedAtUtc) || other.fetchedAtUtc == fetchedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,finalUrl,title,description,contentType,fetchedAtUtc);

@override
String toString() {
  return 'ChatLinkPreviewResponse(finalUrl: $finalUrl, title: $title, description: $description, contentType: $contentType, fetchedAtUtc: $fetchedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatLinkPreviewResponseCopyWith<$Res> implements $ChatLinkPreviewResponseCopyWith<$Res> {
  factory _$ChatLinkPreviewResponseCopyWith(_ChatLinkPreviewResponse value, $Res Function(_ChatLinkPreviewResponse) _then) = __$ChatLinkPreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 String finalUrl, String? title, String? description, String? contentType, DateTime fetchedAtUtc
});




}
/// @nodoc
class __$ChatLinkPreviewResponseCopyWithImpl<$Res>
    implements _$ChatLinkPreviewResponseCopyWith<$Res> {
  __$ChatLinkPreviewResponseCopyWithImpl(this._self, this._then);

  final _ChatLinkPreviewResponse _self;
  final $Res Function(_ChatLinkPreviewResponse) _then;

/// Create a copy of ChatLinkPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? finalUrl = null,Object? title = freezed,Object? description = freezed,Object? contentType = freezed,Object? fetchedAtUtc = null,}) {
  return _then(_ChatLinkPreviewResponse(
finalUrl: null == finalUrl ? _self.finalUrl : finalUrl // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,fetchedAtUtc: null == fetchedAtUtc ? _self.fetchedAtUtc : fetchedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatSnippetPayload {

 String get text; String get format; bool get force;
/// Create a copy of ChatSnippetPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSnippetPayloadCopyWith<ChatSnippetPayload> get copyWith => _$ChatSnippetPayloadCopyWithImpl<ChatSnippetPayload>(this as ChatSnippetPayload, _$identity);

  /// Serializes this ChatSnippetPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSnippetPayload&&(identical(other.text, text) || other.text == text)&&(identical(other.format, format) || other.format == format)&&(identical(other.force, force) || other.force == force));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,format,force);

@override
String toString() {
  return 'ChatSnippetPayload(text: $text, format: $format, force: $force)';
}


}

/// @nodoc
abstract mixin class $ChatSnippetPayloadCopyWith<$Res>  {
  factory $ChatSnippetPayloadCopyWith(ChatSnippetPayload value, $Res Function(ChatSnippetPayload) _then) = _$ChatSnippetPayloadCopyWithImpl;
@useResult
$Res call({
 String text, String format, bool force
});




}
/// @nodoc
class _$ChatSnippetPayloadCopyWithImpl<$Res>
    implements $ChatSnippetPayloadCopyWith<$Res> {
  _$ChatSnippetPayloadCopyWithImpl(this._self, this._then);

  final ChatSnippetPayload _self;
  final $Res Function(ChatSnippetPayload) _then;

/// Create a copy of ChatSnippetPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? format = null,Object? force = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,force: null == force ? _self.force : force // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSnippetPayload].
extension ChatSnippetPayloadPatterns on ChatSnippetPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSnippetPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSnippetPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSnippetPayload value)  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSnippetPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String format,  bool force)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSnippetPayload() when $default != null:
return $default(_that.text,_that.format,_that.force);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String format,  bool force)  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetPayload():
return $default(_that.text,_that.format,_that.force);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String format,  bool force)?  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetPayload() when $default != null:
return $default(_that.text,_that.format,_that.force);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSnippetPayload implements ChatSnippetPayload {
  const _ChatSnippetPayload({required this.text, this.format = 'PlainText', this.force = false});
  factory _ChatSnippetPayload.fromJson(Map<String, dynamic> json) => _$ChatSnippetPayloadFromJson(json);

@override final  String text;
@override@JsonKey() final  String format;
@override@JsonKey() final  bool force;

/// Create a copy of ChatSnippetPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSnippetPayloadCopyWith<_ChatSnippetPayload> get copyWith => __$ChatSnippetPayloadCopyWithImpl<_ChatSnippetPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSnippetPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSnippetPayload&&(identical(other.text, text) || other.text == text)&&(identical(other.format, format) || other.format == format)&&(identical(other.force, force) || other.force == force));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,format,force);

@override
String toString() {
  return 'ChatSnippetPayload(text: $text, format: $format, force: $force)';
}


}

/// @nodoc
abstract mixin class _$ChatSnippetPayloadCopyWith<$Res> implements $ChatSnippetPayloadCopyWith<$Res> {
  factory _$ChatSnippetPayloadCopyWith(_ChatSnippetPayload value, $Res Function(_ChatSnippetPayload) _then) = __$ChatSnippetPayloadCopyWithImpl;
@override @useResult
$Res call({
 String text, String format, bool force
});




}
/// @nodoc
class __$ChatSnippetPayloadCopyWithImpl<$Res>
    implements _$ChatSnippetPayloadCopyWith<$Res> {
  __$ChatSnippetPayloadCopyWithImpl(this._self, this._then);

  final _ChatSnippetPayload _self;
  final $Res Function(_ChatSnippetPayload) _then;

/// Create a copy of ChatSnippetPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? format = null,Object? force = null,}) {
  return _then(_ChatSnippetPayload(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,force: null == force ? _self.force : force // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatSnippetResponse {

 bool get isSnippet; int get originalLength; String? get suggestedFileName; String? get mimeType; String? get content; bool get isTruncated;
/// Create a copy of ChatSnippetResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSnippetResponseCopyWith<ChatSnippetResponse> get copyWith => _$ChatSnippetResponseCopyWithImpl<ChatSnippetResponse>(this as ChatSnippetResponse, _$identity);

  /// Serializes this ChatSnippetResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSnippetResponse&&(identical(other.isSnippet, isSnippet) || other.isSnippet == isSnippet)&&(identical(other.originalLength, originalLength) || other.originalLength == originalLength)&&(identical(other.suggestedFileName, suggestedFileName) || other.suggestedFileName == suggestedFileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.content, content) || other.content == content)&&(identical(other.isTruncated, isTruncated) || other.isTruncated == isTruncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isSnippet,originalLength,suggestedFileName,mimeType,content,isTruncated);

@override
String toString() {
  return 'ChatSnippetResponse(isSnippet: $isSnippet, originalLength: $originalLength, suggestedFileName: $suggestedFileName, mimeType: $mimeType, content: $content, isTruncated: $isTruncated)';
}


}

/// @nodoc
abstract mixin class $ChatSnippetResponseCopyWith<$Res>  {
  factory $ChatSnippetResponseCopyWith(ChatSnippetResponse value, $Res Function(ChatSnippetResponse) _then) = _$ChatSnippetResponseCopyWithImpl;
@useResult
$Res call({
 bool isSnippet, int originalLength, String? suggestedFileName, String? mimeType, String? content, bool isTruncated
});




}
/// @nodoc
class _$ChatSnippetResponseCopyWithImpl<$Res>
    implements $ChatSnippetResponseCopyWith<$Res> {
  _$ChatSnippetResponseCopyWithImpl(this._self, this._then);

  final ChatSnippetResponse _self;
  final $Res Function(ChatSnippetResponse) _then;

/// Create a copy of ChatSnippetResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSnippet = null,Object? originalLength = null,Object? suggestedFileName = freezed,Object? mimeType = freezed,Object? content = freezed,Object? isTruncated = null,}) {
  return _then(_self.copyWith(
isSnippet: null == isSnippet ? _self.isSnippet : isSnippet // ignore: cast_nullable_to_non_nullable
as bool,originalLength: null == originalLength ? _self.originalLength : originalLength // ignore: cast_nullable_to_non_nullable
as int,suggestedFileName: freezed == suggestedFileName ? _self.suggestedFileName : suggestedFileName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,isTruncated: null == isTruncated ? _self.isTruncated : isTruncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSnippetResponse].
extension ChatSnippetResponsePatterns on ChatSnippetResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSnippetResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSnippetResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSnippetResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSnippetResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSnippet,  int originalLength,  String? suggestedFileName,  String? mimeType,  String? content,  bool isTruncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSnippetResponse() when $default != null:
return $default(_that.isSnippet,_that.originalLength,_that.suggestedFileName,_that.mimeType,_that.content,_that.isTruncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSnippet,  int originalLength,  String? suggestedFileName,  String? mimeType,  String? content,  bool isTruncated)  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetResponse():
return $default(_that.isSnippet,_that.originalLength,_that.suggestedFileName,_that.mimeType,_that.content,_that.isTruncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSnippet,  int originalLength,  String? suggestedFileName,  String? mimeType,  String? content,  bool isTruncated)?  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetResponse() when $default != null:
return $default(_that.isSnippet,_that.originalLength,_that.suggestedFileName,_that.mimeType,_that.content,_that.isTruncated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSnippetResponse implements ChatSnippetResponse {
  const _ChatSnippetResponse({required this.isSnippet, required this.originalLength, this.suggestedFileName, this.mimeType, this.content, required this.isTruncated});
  factory _ChatSnippetResponse.fromJson(Map<String, dynamic> json) => _$ChatSnippetResponseFromJson(json);

@override final  bool isSnippet;
@override final  int originalLength;
@override final  String? suggestedFileName;
@override final  String? mimeType;
@override final  String? content;
@override final  bool isTruncated;

/// Create a copy of ChatSnippetResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSnippetResponseCopyWith<_ChatSnippetResponse> get copyWith => __$ChatSnippetResponseCopyWithImpl<_ChatSnippetResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSnippetResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSnippetResponse&&(identical(other.isSnippet, isSnippet) || other.isSnippet == isSnippet)&&(identical(other.originalLength, originalLength) || other.originalLength == originalLength)&&(identical(other.suggestedFileName, suggestedFileName) || other.suggestedFileName == suggestedFileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.content, content) || other.content == content)&&(identical(other.isTruncated, isTruncated) || other.isTruncated == isTruncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isSnippet,originalLength,suggestedFileName,mimeType,content,isTruncated);

@override
String toString() {
  return 'ChatSnippetResponse(isSnippet: $isSnippet, originalLength: $originalLength, suggestedFileName: $suggestedFileName, mimeType: $mimeType, content: $content, isTruncated: $isTruncated)';
}


}

/// @nodoc
abstract mixin class _$ChatSnippetResponseCopyWith<$Res> implements $ChatSnippetResponseCopyWith<$Res> {
  factory _$ChatSnippetResponseCopyWith(_ChatSnippetResponse value, $Res Function(_ChatSnippetResponse) _then) = __$ChatSnippetResponseCopyWithImpl;
@override @useResult
$Res call({
 bool isSnippet, int originalLength, String? suggestedFileName, String? mimeType, String? content, bool isTruncated
});




}
/// @nodoc
class __$ChatSnippetResponseCopyWithImpl<$Res>
    implements _$ChatSnippetResponseCopyWith<$Res> {
  __$ChatSnippetResponseCopyWithImpl(this._self, this._then);

  final _ChatSnippetResponse _self;
  final $Res Function(_ChatSnippetResponse) _then;

/// Create a copy of ChatSnippetResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSnippet = null,Object? originalLength = null,Object? suggestedFileName = freezed,Object? mimeType = freezed,Object? content = freezed,Object? isTruncated = null,}) {
  return _then(_ChatSnippetResponse(
isSnippet: null == isSnippet ? _self.isSnippet : isSnippet // ignore: cast_nullable_to_non_nullable
as bool,originalLength: null == originalLength ? _self.originalLength : originalLength // ignore: cast_nullable_to_non_nullable
as int,suggestedFileName: freezed == suggestedFileName ? _self.suggestedFileName : suggestedFileName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,isTruncated: null == isTruncated ? _self.isTruncated : isTruncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatSnippetAttachmentResponse {

 ChatAttachmentResponse get attachment; String get fileName; int get fileSizeBytes; StorageScanStatus get scanStatus;
/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSnippetAttachmentResponseCopyWith<ChatSnippetAttachmentResponse> get copyWith => _$ChatSnippetAttachmentResponseCopyWithImpl<ChatSnippetAttachmentResponse>(this as ChatSnippetAttachmentResponse, _$identity);

  /// Serializes this ChatSnippetAttachmentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSnippetAttachmentResponse&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attachment,fileName,fileSizeBytes,scanStatus);

@override
String toString() {
  return 'ChatSnippetAttachmentResponse(attachment: $attachment, fileName: $fileName, fileSizeBytes: $fileSizeBytes, scanStatus: $scanStatus)';
}


}

/// @nodoc
abstract mixin class $ChatSnippetAttachmentResponseCopyWith<$Res>  {
  factory $ChatSnippetAttachmentResponseCopyWith(ChatSnippetAttachmentResponse value, $Res Function(ChatSnippetAttachmentResponse) _then) = _$ChatSnippetAttachmentResponseCopyWithImpl;
@useResult
$Res call({
 ChatAttachmentResponse attachment, String fileName, int fileSizeBytes, StorageScanStatus scanStatus
});


$ChatAttachmentResponseCopyWith<$Res> get attachment;

}
/// @nodoc
class _$ChatSnippetAttachmentResponseCopyWithImpl<$Res>
    implements $ChatSnippetAttachmentResponseCopyWith<$Res> {
  _$ChatSnippetAttachmentResponseCopyWithImpl(this._self, this._then);

  final ChatSnippetAttachmentResponse _self;
  final $Res Function(ChatSnippetAttachmentResponse) _then;

/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attachment = null,Object? fileName = null,Object? fileSizeBytes = null,Object? scanStatus = null,}) {
  return _then(_self.copyWith(
attachment: null == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as ChatAttachmentResponse,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,scanStatus: null == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as StorageScanStatus,
  ));
}
/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatAttachmentResponseCopyWith<$Res> get attachment {

  return $ChatAttachmentResponseCopyWith<$Res>(_self.attachment, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatSnippetAttachmentResponse].
extension ChatSnippetAttachmentResponsePatterns on ChatSnippetAttachmentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSnippetAttachmentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSnippetAttachmentResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSnippetAttachmentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatAttachmentResponse attachment,  String fileName,  int fileSizeBytes,  StorageScanStatus scanStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse() when $default != null:
return $default(_that.attachment,_that.fileName,_that.fileSizeBytes,_that.scanStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatAttachmentResponse attachment,  String fileName,  int fileSizeBytes,  StorageScanStatus scanStatus)  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse():
return $default(_that.attachment,_that.fileName,_that.fileSizeBytes,_that.scanStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatAttachmentResponse attachment,  String fileName,  int fileSizeBytes,  StorageScanStatus scanStatus)?  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse() when $default != null:
return $default(_that.attachment,_that.fileName,_that.fileSizeBytes,_that.scanStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSnippetAttachmentResponse implements ChatSnippetAttachmentResponse {
  const _ChatSnippetAttachmentResponse({required this.attachment, required this.fileName, required this.fileSizeBytes, required this.scanStatus});
  factory _ChatSnippetAttachmentResponse.fromJson(Map<String, dynamic> json) => _$ChatSnippetAttachmentResponseFromJson(json);

@override final  ChatAttachmentResponse attachment;
@override final  String fileName;
@override final  int fileSizeBytes;
@override final  StorageScanStatus scanStatus;

/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSnippetAttachmentResponseCopyWith<_ChatSnippetAttachmentResponse> get copyWith => __$ChatSnippetAttachmentResponseCopyWithImpl<_ChatSnippetAttachmentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSnippetAttachmentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSnippetAttachmentResponse&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attachment,fileName,fileSizeBytes,scanStatus);

@override
String toString() {
  return 'ChatSnippetAttachmentResponse(attachment: $attachment, fileName: $fileName, fileSizeBytes: $fileSizeBytes, scanStatus: $scanStatus)';
}


}

/// @nodoc
abstract mixin class _$ChatSnippetAttachmentResponseCopyWith<$Res> implements $ChatSnippetAttachmentResponseCopyWith<$Res> {
  factory _$ChatSnippetAttachmentResponseCopyWith(_ChatSnippetAttachmentResponse value, $Res Function(_ChatSnippetAttachmentResponse) _then) = __$ChatSnippetAttachmentResponseCopyWithImpl;
@override @useResult
$Res call({
 ChatAttachmentResponse attachment, String fileName, int fileSizeBytes, StorageScanStatus scanStatus
});


@override $ChatAttachmentResponseCopyWith<$Res> get attachment;

}
/// @nodoc
class __$ChatSnippetAttachmentResponseCopyWithImpl<$Res>
    implements _$ChatSnippetAttachmentResponseCopyWith<$Res> {
  __$ChatSnippetAttachmentResponseCopyWithImpl(this._self, this._then);

  final _ChatSnippetAttachmentResponse _self;
  final $Res Function(_ChatSnippetAttachmentResponse) _then;

/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attachment = null,Object? fileName = null,Object? fileSizeBytes = null,Object? scanStatus = null,}) {
  return _then(_ChatSnippetAttachmentResponse(
attachment: null == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as ChatAttachmentResponse,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,scanStatus: null == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as StorageScanStatus,
  ));
}

/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatAttachmentResponseCopyWith<$Res> get attachment {

  return $ChatAttachmentResponseCopyWith<$Res>(_self.attachment, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}


/// @nodoc
mixin _$ChatReactionSummaryResponse {

 String get emoji; int get count; bool get reactedByCurrentUser;
/// Create a copy of ChatReactionSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatReactionSummaryResponseCopyWith<ChatReactionSummaryResponse> get copyWith => _$ChatReactionSummaryResponseCopyWithImpl<ChatReactionSummaryResponse>(this as ChatReactionSummaryResponse, _$identity);

  /// Serializes this ChatReactionSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatReactionSummaryResponse&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.count, count) || other.count == count)&&(identical(other.reactedByCurrentUser, reactedByCurrentUser) || other.reactedByCurrentUser == reactedByCurrentUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,count,reactedByCurrentUser);

@override
String toString() {
  return 'ChatReactionSummaryResponse(emoji: $emoji, count: $count, reactedByCurrentUser: $reactedByCurrentUser)';
}


}

/// @nodoc
abstract mixin class $ChatReactionSummaryResponseCopyWith<$Res>  {
  factory $ChatReactionSummaryResponseCopyWith(ChatReactionSummaryResponse value, $Res Function(ChatReactionSummaryResponse) _then) = _$ChatReactionSummaryResponseCopyWithImpl;
@useResult
$Res call({
 String emoji, int count, bool reactedByCurrentUser
});




}
/// @nodoc
class _$ChatReactionSummaryResponseCopyWithImpl<$Res>
    implements $ChatReactionSummaryResponseCopyWith<$Res> {
  _$ChatReactionSummaryResponseCopyWithImpl(this._self, this._then);

  final ChatReactionSummaryResponse _self;
  final $Res Function(ChatReactionSummaryResponse) _then;

/// Create a copy of ChatReactionSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = null,Object? count = null,Object? reactedByCurrentUser = null,}) {
  return _then(_self.copyWith(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,reactedByCurrentUser: null == reactedByCurrentUser ? _self.reactedByCurrentUser : reactedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatReactionSummaryResponse].
extension ChatReactionSummaryResponsePatterns on ChatReactionSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatReactionSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatReactionSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatReactionSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatReactionSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatReactionSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatReactionSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String emoji,  int count,  bool reactedByCurrentUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatReactionSummaryResponse() when $default != null:
return $default(_that.emoji,_that.count,_that.reactedByCurrentUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String emoji,  int count,  bool reactedByCurrentUser)  $default,) {final _that = this;
switch (_that) {
case _ChatReactionSummaryResponse():
return $default(_that.emoji,_that.count,_that.reactedByCurrentUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String emoji,  int count,  bool reactedByCurrentUser)?  $default,) {final _that = this;
switch (_that) {
case _ChatReactionSummaryResponse() when $default != null:
return $default(_that.emoji,_that.count,_that.reactedByCurrentUser);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatReactionSummaryResponse implements ChatReactionSummaryResponse {
  const _ChatReactionSummaryResponse({required this.emoji, required this.count, required this.reactedByCurrentUser});
  factory _ChatReactionSummaryResponse.fromJson(Map<String, dynamic> json) => _$ChatReactionSummaryResponseFromJson(json);

@override final  String emoji;
@override final  int count;
@override final  bool reactedByCurrentUser;

/// Create a copy of ChatReactionSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatReactionSummaryResponseCopyWith<_ChatReactionSummaryResponse> get copyWith => __$ChatReactionSummaryResponseCopyWithImpl<_ChatReactionSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatReactionSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatReactionSummaryResponse&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.count, count) || other.count == count)&&(identical(other.reactedByCurrentUser, reactedByCurrentUser) || other.reactedByCurrentUser == reactedByCurrentUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,count,reactedByCurrentUser);

@override
String toString() {
  return 'ChatReactionSummaryResponse(emoji: $emoji, count: $count, reactedByCurrentUser: $reactedByCurrentUser)';
}


}

/// @nodoc
abstract mixin class _$ChatReactionSummaryResponseCopyWith<$Res> implements $ChatReactionSummaryResponseCopyWith<$Res> {
  factory _$ChatReactionSummaryResponseCopyWith(_ChatReactionSummaryResponse value, $Res Function(_ChatReactionSummaryResponse) _then) = __$ChatReactionSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String emoji, int count, bool reactedByCurrentUser
});




}
/// @nodoc
class __$ChatReactionSummaryResponseCopyWithImpl<$Res>
    implements _$ChatReactionSummaryResponseCopyWith<$Res> {
  __$ChatReactionSummaryResponseCopyWithImpl(this._self, this._then);

  final _ChatReactionSummaryResponse _self;
  final $Res Function(_ChatReactionSummaryResponse) _then;

/// Create a copy of ChatReactionSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = null,Object? count = null,Object? reactedByCurrentUser = null,}) {
  return _then(_ChatReactionSummaryResponse(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,reactedByCurrentUser: null == reactedByCurrentUser ? _self.reactedByCurrentUser : reactedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatMessageResponse {

 String get id; String get conversationId; String get authorUserId; String get clientMessageId; String get text; String? get deltaJson; String? get replyToMessageId; String get payloadHash; int get version; DateTime get createdAtUtc; bool get isDeleted; List<ChatLinkResponse>? get links; List<ChatReactionSummaryResponse>? get reactions; List<ChatAttachmentResponse>? get attachments; String? get threadRootMessageId; bool get isEdited; DateTime? get deletedAtUtc; int get deliveredToCount; int get readByCount;
/// Create a copy of ChatMessageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageResponseCopyWith<ChatMessageResponse> get copyWith => _$ChatMessageResponseCopyWithImpl<ChatMessageResponse>(this as ChatMessageResponse, _$identity);

  /// Serializes this ChatMessageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&(identical(other.payloadHash, payloadHash) || other.payloadHash == payloadHash)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&const DeepCollectionEquality().equals(other.links, links)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.threadRootMessageId, threadRootMessageId) || other.threadRootMessageId == threadRootMessageId)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.deletedAtUtc, deletedAtUtc) || other.deletedAtUtc == deletedAtUtc)&&(identical(other.deliveredToCount, deliveredToCount) || other.deliveredToCount == deliveredToCount)&&(identical(other.readByCount, readByCount) || other.readByCount == readByCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,conversationId,authorUserId,clientMessageId,text,deltaJson,replyToMessageId,payloadHash,version,createdAtUtc,isDeleted,const DeepCollectionEquality().hash(links),const DeepCollectionEquality().hash(reactions),const DeepCollectionEquality().hash(attachments),threadRootMessageId,isEdited,deletedAtUtc,deliveredToCount,readByCount]);

@override
String toString() {
  return 'ChatMessageResponse(id: $id, conversationId: $conversationId, authorUserId: $authorUserId, clientMessageId: $clientMessageId, text: $text, deltaJson: $deltaJson, replyToMessageId: $replyToMessageId, payloadHash: $payloadHash, version: $version, createdAtUtc: $createdAtUtc, isDeleted: $isDeleted, links: $links, reactions: $reactions, attachments: $attachments, threadRootMessageId: $threadRootMessageId, isEdited: $isEdited, deletedAtUtc: $deletedAtUtc, deliveredToCount: $deliveredToCount, readByCount: $readByCount)';
}


}

/// @nodoc
abstract mixin class $ChatMessageResponseCopyWith<$Res>  {
  factory $ChatMessageResponseCopyWith(ChatMessageResponse value, $Res Function(ChatMessageResponse) _then) = _$ChatMessageResponseCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String authorUserId, String clientMessageId, String text, String? deltaJson, String? replyToMessageId, String payloadHash, int version, DateTime createdAtUtc, bool isDeleted, List<ChatLinkResponse>? links, List<ChatReactionSummaryResponse>? reactions, List<ChatAttachmentResponse>? attachments, String? threadRootMessageId, bool isEdited, DateTime? deletedAtUtc, int deliveredToCount, int readByCount
});




}
/// @nodoc
class _$ChatMessageResponseCopyWithImpl<$Res>
    implements $ChatMessageResponseCopyWith<$Res> {
  _$ChatMessageResponseCopyWithImpl(this._self, this._then);

  final ChatMessageResponse _self;
  final $Res Function(ChatMessageResponse) _then;

/// Create a copy of ChatMessageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? authorUserId = null,Object? clientMessageId = null,Object? text = null,Object? deltaJson = freezed,Object? replyToMessageId = freezed,Object? payloadHash = null,Object? version = null,Object? createdAtUtc = null,Object? isDeleted = null,Object? links = freezed,Object? reactions = freezed,Object? attachments = freezed,Object? threadRootMessageId = freezed,Object? isEdited = null,Object? deletedAtUtc = freezed,Object? deliveredToCount = null,Object? readByCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,payloadHash: null == payloadHash ? _self.payloadHash : payloadHash // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,links: freezed == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<ChatLinkResponse>?,reactions: freezed == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<ChatReactionSummaryResponse>?,attachments: freezed == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ChatAttachmentResponse>?,threadRootMessageId: freezed == threadRootMessageId ? _self.threadRootMessageId : threadRootMessageId // ignore: cast_nullable_to_non_nullable
as String?,isEdited: null == isEdited ? _self.isEdited : isEdited // ignore: cast_nullable_to_non_nullable
as bool,deletedAtUtc: freezed == deletedAtUtc ? _self.deletedAtUtc : deletedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredToCount: null == deliveredToCount ? _self.deliveredToCount : deliveredToCount // ignore: cast_nullable_to_non_nullable
as int,readByCount: null == readByCount ? _self.readByCount : readByCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageResponse].
extension ChatMessageResponsePatterns on ChatMessageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String authorUserId,  String clientMessageId,  String text,  String? deltaJson,  String? replyToMessageId,  String payloadHash,  int version,  DateTime createdAtUtc,  bool isDeleted,  List<ChatLinkResponse>? links,  List<ChatReactionSummaryResponse>? reactions,  List<ChatAttachmentResponse>? attachments,  String? threadRootMessageId,  bool isEdited,  DateTime? deletedAtUtc,  int deliveredToCount,  int readByCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.authorUserId,_that.clientMessageId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.payloadHash,_that.version,_that.createdAtUtc,_that.isDeleted,_that.links,_that.reactions,_that.attachments,_that.threadRootMessageId,_that.isEdited,_that.deletedAtUtc,_that.deliveredToCount,_that.readByCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String authorUserId,  String clientMessageId,  String text,  String? deltaJson,  String? replyToMessageId,  String payloadHash,  int version,  DateTime createdAtUtc,  bool isDeleted,  List<ChatLinkResponse>? links,  List<ChatReactionSummaryResponse>? reactions,  List<ChatAttachmentResponse>? attachments,  String? threadRootMessageId,  bool isEdited,  DateTime? deletedAtUtc,  int deliveredToCount,  int readByCount)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageResponse():
return $default(_that.id,_that.conversationId,_that.authorUserId,_that.clientMessageId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.payloadHash,_that.version,_that.createdAtUtc,_that.isDeleted,_that.links,_that.reactions,_that.attachments,_that.threadRootMessageId,_that.isEdited,_that.deletedAtUtc,_that.deliveredToCount,_that.readByCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String authorUserId,  String clientMessageId,  String text,  String? deltaJson,  String? replyToMessageId,  String payloadHash,  int version,  DateTime createdAtUtc,  bool isDeleted,  List<ChatLinkResponse>? links,  List<ChatReactionSummaryResponse>? reactions,  List<ChatAttachmentResponse>? attachments,  String? threadRootMessageId,  bool isEdited,  DateTime? deletedAtUtc,  int deliveredToCount,  int readByCount)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.authorUserId,_that.clientMessageId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.payloadHash,_that.version,_that.createdAtUtc,_that.isDeleted,_that.links,_that.reactions,_that.attachments,_that.threadRootMessageId,_that.isEdited,_that.deletedAtUtc,_that.deliveredToCount,_that.readByCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageResponse implements ChatMessageResponse {
  const _ChatMessageResponse({required this.id, required this.conversationId, required this.authorUserId, required this.clientMessageId, required this.text, this.deltaJson, this.replyToMessageId, required this.payloadHash, required this.version, required this.createdAtUtc, required this.isDeleted, this.links, this.reactions, this.attachments, this.threadRootMessageId, this.isEdited = false, this.deletedAtUtc, this.deliveredToCount = 0, this.readByCount = 0});
  factory _ChatMessageResponse.fromJson(Map<String, dynamic> json) => _$ChatMessageResponseFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String authorUserId;
@override final  String clientMessageId;
@override final  String text;
@override final  String? deltaJson;
@override final  String? replyToMessageId;
@override final  String payloadHash;
@override final  int version;
@override final  DateTime createdAtUtc;
@override final  bool isDeleted;
@override final  List<ChatLinkResponse>? links;
@override final  List<ChatReactionSummaryResponse>? reactions;
@override final  List<ChatAttachmentResponse>? attachments;
@override final  String? threadRootMessageId;
@override@JsonKey() final  bool isEdited;
@override final  DateTime? deletedAtUtc;
@override@JsonKey() final  int deliveredToCount;
@override@JsonKey() final  int readByCount;

/// Create a copy of ChatMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageResponseCopyWith<_ChatMessageResponse> get copyWith => __$ChatMessageResponseCopyWithImpl<_ChatMessageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&(identical(other.payloadHash, payloadHash) || other.payloadHash == payloadHash)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&const DeepCollectionEquality().equals(other.links, links)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.threadRootMessageId, threadRootMessageId) || other.threadRootMessageId == threadRootMessageId)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.deletedAtUtc, deletedAtUtc) || other.deletedAtUtc == deletedAtUtc)&&(identical(other.deliveredToCount, deliveredToCount) || other.deliveredToCount == deliveredToCount)&&(identical(other.readByCount, readByCount) || other.readByCount == readByCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,conversationId,authorUserId,clientMessageId,text,deltaJson,replyToMessageId,payloadHash,version,createdAtUtc,isDeleted,const DeepCollectionEquality().hash(links),const DeepCollectionEquality().hash(reactions),const DeepCollectionEquality().hash(attachments),threadRootMessageId,isEdited,deletedAtUtc,deliveredToCount,readByCount]);

@override
String toString() {
  return 'ChatMessageResponse(id: $id, conversationId: $conversationId, authorUserId: $authorUserId, clientMessageId: $clientMessageId, text: $text, deltaJson: $deltaJson, replyToMessageId: $replyToMessageId, payloadHash: $payloadHash, version: $version, createdAtUtc: $createdAtUtc, isDeleted: $isDeleted, links: $links, reactions: $reactions, attachments: $attachments, threadRootMessageId: $threadRootMessageId, isEdited: $isEdited, deletedAtUtc: $deletedAtUtc, deliveredToCount: $deliveredToCount, readByCount: $readByCount)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageResponseCopyWith<$Res> implements $ChatMessageResponseCopyWith<$Res> {
  factory _$ChatMessageResponseCopyWith(_ChatMessageResponse value, $Res Function(_ChatMessageResponse) _then) = __$ChatMessageResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String authorUserId, String clientMessageId, String text, String? deltaJson, String? replyToMessageId, String payloadHash, int version, DateTime createdAtUtc, bool isDeleted, List<ChatLinkResponse>? links, List<ChatReactionSummaryResponse>? reactions, List<ChatAttachmentResponse>? attachments, String? threadRootMessageId, bool isEdited, DateTime? deletedAtUtc, int deliveredToCount, int readByCount
});




}
/// @nodoc
class __$ChatMessageResponseCopyWithImpl<$Res>
    implements _$ChatMessageResponseCopyWith<$Res> {
  __$ChatMessageResponseCopyWithImpl(this._self, this._then);

  final _ChatMessageResponse _self;
  final $Res Function(_ChatMessageResponse) _then;

/// Create a copy of ChatMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? authorUserId = null,Object? clientMessageId = null,Object? text = null,Object? deltaJson = freezed,Object? replyToMessageId = freezed,Object? payloadHash = null,Object? version = null,Object? createdAtUtc = null,Object? isDeleted = null,Object? links = freezed,Object? reactions = freezed,Object? attachments = freezed,Object? threadRootMessageId = freezed,Object? isEdited = null,Object? deletedAtUtc = freezed,Object? deliveredToCount = null,Object? readByCount = null,}) {
  return _then(_ChatMessageResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,clientMessageId: null == clientMessageId ? _self.clientMessageId : clientMessageId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,payloadHash: null == payloadHash ? _self.payloadHash : payloadHash // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,links: freezed == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<ChatLinkResponse>?,reactions: freezed == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<ChatReactionSummaryResponse>?,attachments: freezed == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ChatAttachmentResponse>?,threadRootMessageId: freezed == threadRootMessageId ? _self.threadRootMessageId : threadRootMessageId // ignore: cast_nullable_to_non_nullable
as String?,isEdited: null == isEdited ? _self.isEdited : isEdited // ignore: cast_nullable_to_non_nullable
as bool,deletedAtUtc: freezed == deletedAtUtc ? _self.deletedAtUtc : deletedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredToCount: null == deliveredToCount ? _self.deliveredToCount : deliveredToCount // ignore: cast_nullable_to_non_nullable
as int,readByCount: null == readByCount ? _self.readByCount : readByCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChatTemporaryAttachmentSessionResponse {

 String get id; String get conversationId; DateTime get expiresAtUtc;
/// Create a copy of ChatTemporaryAttachmentSessionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatTemporaryAttachmentSessionResponseCopyWith<ChatTemporaryAttachmentSessionResponse> get copyWith => _$ChatTemporaryAttachmentSessionResponseCopyWithImpl<ChatTemporaryAttachmentSessionResponse>(this as ChatTemporaryAttachmentSessionResponse, _$identity);

  /// Serializes this ChatTemporaryAttachmentSessionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatTemporaryAttachmentSessionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,expiresAtUtc);

@override
String toString() {
  return 'ChatTemporaryAttachmentSessionResponse(id: $id, conversationId: $conversationId, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatTemporaryAttachmentSessionResponseCopyWith<$Res>  {
  factory $ChatTemporaryAttachmentSessionResponseCopyWith(ChatTemporaryAttachmentSessionResponse value, $Res Function(ChatTemporaryAttachmentSessionResponse) _then) = _$ChatTemporaryAttachmentSessionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, DateTime expiresAtUtc
});




}
/// @nodoc
class _$ChatTemporaryAttachmentSessionResponseCopyWithImpl<$Res>
    implements $ChatTemporaryAttachmentSessionResponseCopyWith<$Res> {
  _$ChatTemporaryAttachmentSessionResponseCopyWithImpl(this._self, this._then);

  final ChatTemporaryAttachmentSessionResponse _self;
  final $Res Function(ChatTemporaryAttachmentSessionResponse) _then;

/// Create a copy of ChatTemporaryAttachmentSessionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? expiresAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatTemporaryAttachmentSessionResponse].
extension ChatTemporaryAttachmentSessionResponsePatterns on ChatTemporaryAttachmentSessionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatTemporaryAttachmentSessionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatTemporaryAttachmentSessionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatTemporaryAttachmentSessionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatTemporaryAttachmentSessionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatTemporaryAttachmentSessionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatTemporaryAttachmentSessionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  DateTime expiresAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatTemporaryAttachmentSessionResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  DateTime expiresAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatTemporaryAttachmentSessionResponse():
return $default(_that.id,_that.conversationId,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  DateTime expiresAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatTemporaryAttachmentSessionResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.expiresAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatTemporaryAttachmentSessionResponse implements ChatTemporaryAttachmentSessionResponse {
  const _ChatTemporaryAttachmentSessionResponse({required this.id, required this.conversationId, required this.expiresAtUtc});
  factory _ChatTemporaryAttachmentSessionResponse.fromJson(Map<String, dynamic> json) => _$ChatTemporaryAttachmentSessionResponseFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  DateTime expiresAtUtc;

/// Create a copy of ChatTemporaryAttachmentSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatTemporaryAttachmentSessionResponseCopyWith<_ChatTemporaryAttachmentSessionResponse> get copyWith => __$ChatTemporaryAttachmentSessionResponseCopyWithImpl<_ChatTemporaryAttachmentSessionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatTemporaryAttachmentSessionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatTemporaryAttachmentSessionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,expiresAtUtc);

@override
String toString() {
  return 'ChatTemporaryAttachmentSessionResponse(id: $id, conversationId: $conversationId, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatTemporaryAttachmentSessionResponseCopyWith<$Res> implements $ChatTemporaryAttachmentSessionResponseCopyWith<$Res> {
  factory _$ChatTemporaryAttachmentSessionResponseCopyWith(_ChatTemporaryAttachmentSessionResponse value, $Res Function(_ChatTemporaryAttachmentSessionResponse) _then) = __$ChatTemporaryAttachmentSessionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, DateTime expiresAtUtc
});




}
/// @nodoc
class __$ChatTemporaryAttachmentSessionResponseCopyWithImpl<$Res>
    implements _$ChatTemporaryAttachmentSessionResponseCopyWith<$Res> {
  __$ChatTemporaryAttachmentSessionResponseCopyWithImpl(this._self, this._then);

  final _ChatTemporaryAttachmentSessionResponse _self;
  final $Res Function(_ChatTemporaryAttachmentSessionResponse) _then;

/// Create a copy of ChatTemporaryAttachmentSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? expiresAtUtc = null,}) {
  return _then(_ChatTemporaryAttachmentSessionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatMessageDeliveryResponse {

 String get messageId; String get recipientUserId; String? get deviceId; ChatMessageDeliveryStatus get status; DateTime get updatedAtUtc; String? get lastError;
/// Create a copy of ChatMessageDeliveryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageDeliveryResponseCopyWith<ChatMessageDeliveryResponse> get copyWith => _$ChatMessageDeliveryResponseCopyWithImpl<ChatMessageDeliveryResponse>(this as ChatMessageDeliveryResponse, _$identity);

  /// Serializes this ChatMessageDeliveryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageDeliveryResponse&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,recipientUserId,deviceId,status,updatedAtUtc,lastError);

@override
String toString() {
  return 'ChatMessageDeliveryResponse(messageId: $messageId, recipientUserId: $recipientUserId, deviceId: $deviceId, status: $status, updatedAtUtc: $updatedAtUtc, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class $ChatMessageDeliveryResponseCopyWith<$Res>  {
  factory $ChatMessageDeliveryResponseCopyWith(ChatMessageDeliveryResponse value, $Res Function(ChatMessageDeliveryResponse) _then) = _$ChatMessageDeliveryResponseCopyWithImpl;
@useResult
$Res call({
 String messageId, String recipientUserId, String? deviceId, ChatMessageDeliveryStatus status, DateTime updatedAtUtc, String? lastError
});




}
/// @nodoc
class _$ChatMessageDeliveryResponseCopyWithImpl<$Res>
    implements $ChatMessageDeliveryResponseCopyWith<$Res> {
  _$ChatMessageDeliveryResponseCopyWithImpl(this._self, this._then);

  final ChatMessageDeliveryResponse _self;
  final $Res Function(ChatMessageDeliveryResponse) _then;

/// Create a copy of ChatMessageDeliveryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? recipientUserId = null,Object? deviceId = freezed,Object? status = null,Object? updatedAtUtc = null,Object? lastError = freezed,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChatMessageDeliveryStatus,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageDeliveryResponse].
extension ChatMessageDeliveryResponsePatterns on ChatMessageDeliveryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageDeliveryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageDeliveryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageDeliveryResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageDeliveryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageDeliveryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageDeliveryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String messageId,  String recipientUserId,  String? deviceId,  ChatMessageDeliveryStatus status,  DateTime updatedAtUtc,  String? lastError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageDeliveryResponse() when $default != null:
return $default(_that.messageId,_that.recipientUserId,_that.deviceId,_that.status,_that.updatedAtUtc,_that.lastError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String messageId,  String recipientUserId,  String? deviceId,  ChatMessageDeliveryStatus status,  DateTime updatedAtUtc,  String? lastError)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageDeliveryResponse():
return $default(_that.messageId,_that.recipientUserId,_that.deviceId,_that.status,_that.updatedAtUtc,_that.lastError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String messageId,  String recipientUserId,  String? deviceId,  ChatMessageDeliveryStatus status,  DateTime updatedAtUtc,  String? lastError)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageDeliveryResponse() when $default != null:
return $default(_that.messageId,_that.recipientUserId,_that.deviceId,_that.status,_that.updatedAtUtc,_that.lastError);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageDeliveryResponse implements ChatMessageDeliveryResponse {
  const _ChatMessageDeliveryResponse({required this.messageId, required this.recipientUserId, this.deviceId, required this.status, required this.updatedAtUtc, this.lastError});
  factory _ChatMessageDeliveryResponse.fromJson(Map<String, dynamic> json) => _$ChatMessageDeliveryResponseFromJson(json);

@override final  String messageId;
@override final  String recipientUserId;
@override final  String? deviceId;
@override final  ChatMessageDeliveryStatus status;
@override final  DateTime updatedAtUtc;
@override final  String? lastError;

/// Create a copy of ChatMessageDeliveryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageDeliveryResponseCopyWith<_ChatMessageDeliveryResponse> get copyWith => __$ChatMessageDeliveryResponseCopyWithImpl<_ChatMessageDeliveryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageDeliveryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageDeliveryResponse&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,recipientUserId,deviceId,status,updatedAtUtc,lastError);

@override
String toString() {
  return 'ChatMessageDeliveryResponse(messageId: $messageId, recipientUserId: $recipientUserId, deviceId: $deviceId, status: $status, updatedAtUtc: $updatedAtUtc, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageDeliveryResponseCopyWith<$Res> implements $ChatMessageDeliveryResponseCopyWith<$Res> {
  factory _$ChatMessageDeliveryResponseCopyWith(_ChatMessageDeliveryResponse value, $Res Function(_ChatMessageDeliveryResponse) _then) = __$ChatMessageDeliveryResponseCopyWithImpl;
@override @useResult
$Res call({
 String messageId, String recipientUserId, String? deviceId, ChatMessageDeliveryStatus status, DateTime updatedAtUtc, String? lastError
});




}
/// @nodoc
class __$ChatMessageDeliveryResponseCopyWithImpl<$Res>
    implements _$ChatMessageDeliveryResponseCopyWith<$Res> {
  __$ChatMessageDeliveryResponseCopyWithImpl(this._self, this._then);

  final _ChatMessageDeliveryResponse _self;
  final $Res Function(_ChatMessageDeliveryResponse) _then;

/// Create a copy of ChatMessageDeliveryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? recipientUserId = null,Object? deviceId = freezed,Object? status = null,Object? updatedAtUtc = null,Object? lastError = freezed,}) {
  return _then(_ChatMessageDeliveryResponse(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChatMessageDeliveryStatus,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AddChatReactionPayload {

 String get emoji;
/// Create a copy of AddChatReactionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddChatReactionPayloadCopyWith<AddChatReactionPayload> get copyWith => _$AddChatReactionPayloadCopyWithImpl<AddChatReactionPayload>(this as AddChatReactionPayload, _$identity);

  /// Serializes this AddChatReactionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddChatReactionPayload&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji);

@override
String toString() {
  return 'AddChatReactionPayload(emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $AddChatReactionPayloadCopyWith<$Res>  {
  factory $AddChatReactionPayloadCopyWith(AddChatReactionPayload value, $Res Function(AddChatReactionPayload) _then) = _$AddChatReactionPayloadCopyWithImpl;
@useResult
$Res call({
 String emoji
});




}
/// @nodoc
class _$AddChatReactionPayloadCopyWithImpl<$Res>
    implements $AddChatReactionPayloadCopyWith<$Res> {
  _$AddChatReactionPayloadCopyWithImpl(this._self, this._then);

  final AddChatReactionPayload _self;
  final $Res Function(AddChatReactionPayload) _then;

/// Create a copy of AddChatReactionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = null,}) {
  return _then(_self.copyWith(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AddChatReactionPayload].
extension AddChatReactionPayloadPatterns on AddChatReactionPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddChatReactionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddChatReactionPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddChatReactionPayload value)  $default,){
final _that = this;
switch (_that) {
case _AddChatReactionPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddChatReactionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AddChatReactionPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String emoji)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddChatReactionPayload() when $default != null:
return $default(_that.emoji);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String emoji)  $default,) {final _that = this;
switch (_that) {
case _AddChatReactionPayload():
return $default(_that.emoji);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String emoji)?  $default,) {final _that = this;
switch (_that) {
case _AddChatReactionPayload() when $default != null:
return $default(_that.emoji);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddChatReactionPayload implements AddChatReactionPayload {
  const _AddChatReactionPayload({required this.emoji});
  factory _AddChatReactionPayload.fromJson(Map<String, dynamic> json) => _$AddChatReactionPayloadFromJson(json);

@override final  String emoji;

/// Create a copy of AddChatReactionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddChatReactionPayloadCopyWith<_AddChatReactionPayload> get copyWith => __$AddChatReactionPayloadCopyWithImpl<_AddChatReactionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddChatReactionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddChatReactionPayload&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji);

@override
String toString() {
  return 'AddChatReactionPayload(emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$AddChatReactionPayloadCopyWith<$Res> implements $AddChatReactionPayloadCopyWith<$Res> {
  factory _$AddChatReactionPayloadCopyWith(_AddChatReactionPayload value, $Res Function(_AddChatReactionPayload) _then) = __$AddChatReactionPayloadCopyWithImpl;
@override @useResult
$Res call({
 String emoji
});




}
/// @nodoc
class __$AddChatReactionPayloadCopyWithImpl<$Res>
    implements _$AddChatReactionPayloadCopyWith<$Res> {
  __$AddChatReactionPayloadCopyWithImpl(this._self, this._then);

  final _AddChatReactionPayload _self;
  final $Res Function(_AddChatReactionPayload) _then;

/// Create a copy of AddChatReactionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = null,}) {
  return _then(_AddChatReactionPayload(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ChatReactionResponse {

 String get id; String get messageId; String get userId; String get emoji; DateTime get createdAtUtc;
/// Create a copy of ChatReactionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatReactionResponseCopyWith<ChatReactionResponse> get copyWith => _$ChatReactionResponseCopyWithImpl<ChatReactionResponse>(this as ChatReactionResponse, _$identity);

  /// Serializes this ChatReactionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatReactionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,userId,emoji,createdAtUtc);

@override
String toString() {
  return 'ChatReactionResponse(id: $id, messageId: $messageId, userId: $userId, emoji: $emoji, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatReactionResponseCopyWith<$Res>  {
  factory $ChatReactionResponseCopyWith(ChatReactionResponse value, $Res Function(ChatReactionResponse) _then) = _$ChatReactionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String messageId, String userId, String emoji, DateTime createdAtUtc
});




}
/// @nodoc
class _$ChatReactionResponseCopyWithImpl<$Res>
    implements $ChatReactionResponseCopyWith<$Res> {
  _$ChatReactionResponseCopyWithImpl(this._self, this._then);

  final ChatReactionResponse _self;
  final $Res Function(ChatReactionResponse) _then;

/// Create a copy of ChatReactionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messageId = null,Object? userId = null,Object? emoji = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatReactionResponse].
extension ChatReactionResponsePatterns on ChatReactionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatReactionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatReactionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatReactionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatReactionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatReactionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatReactionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messageId,  String userId,  String emoji,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatReactionResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.userId,_that.emoji,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messageId,  String userId,  String emoji,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatReactionResponse():
return $default(_that.id,_that.messageId,_that.userId,_that.emoji,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messageId,  String userId,  String emoji,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatReactionResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.userId,_that.emoji,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatReactionResponse implements ChatReactionResponse {
  const _ChatReactionResponse({required this.id, required this.messageId, required this.userId, required this.emoji, required this.createdAtUtc});
  factory _ChatReactionResponse.fromJson(Map<String, dynamic> json) => _$ChatReactionResponseFromJson(json);

@override final  String id;
@override final  String messageId;
@override final  String userId;
@override final  String emoji;
@override final  DateTime createdAtUtc;

/// Create a copy of ChatReactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatReactionResponseCopyWith<_ChatReactionResponse> get copyWith => __$ChatReactionResponseCopyWithImpl<_ChatReactionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatReactionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatReactionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,userId,emoji,createdAtUtc);

@override
String toString() {
  return 'ChatReactionResponse(id: $id, messageId: $messageId, userId: $userId, emoji: $emoji, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatReactionResponseCopyWith<$Res> implements $ChatReactionResponseCopyWith<$Res> {
  factory _$ChatReactionResponseCopyWith(_ChatReactionResponse value, $Res Function(_ChatReactionResponse) _then) = __$ChatReactionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String messageId, String userId, String emoji, DateTime createdAtUtc
});




}
/// @nodoc
class __$ChatReactionResponseCopyWithImpl<$Res>
    implements _$ChatReactionResponseCopyWith<$Res> {
  __$ChatReactionResponseCopyWithImpl(this._self, this._then);

  final _ChatReactionResponse _self;
  final $Res Function(_ChatReactionResponse) _then;

/// Create a copy of ChatReactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messageId = null,Object? userId = null,Object? emoji = null,Object? createdAtUtc = null,}) {
  return _then(_ChatReactionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatMutePayload {

 DateTime? get untilUtc;
/// Create a copy of ChatMutePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMutePayloadCopyWith<ChatMutePayload> get copyWith => _$ChatMutePayloadCopyWithImpl<ChatMutePayload>(this as ChatMutePayload, _$identity);

  /// Serializes this ChatMutePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMutePayload&&(identical(other.untilUtc, untilUtc) || other.untilUtc == untilUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,untilUtc);

@override
String toString() {
  return 'ChatMutePayload(untilUtc: $untilUtc)';
}


}

/// @nodoc
abstract mixin class $ChatMutePayloadCopyWith<$Res>  {
  factory $ChatMutePayloadCopyWith(ChatMutePayload value, $Res Function(ChatMutePayload) _then) = _$ChatMutePayloadCopyWithImpl;
@useResult
$Res call({
 DateTime? untilUtc
});




}
/// @nodoc
class _$ChatMutePayloadCopyWithImpl<$Res>
    implements $ChatMutePayloadCopyWith<$Res> {
  _$ChatMutePayloadCopyWithImpl(this._self, this._then);

  final ChatMutePayload _self;
  final $Res Function(ChatMutePayload) _then;

/// Create a copy of ChatMutePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? untilUtc = freezed,}) {
  return _then(_self.copyWith(
untilUtc: freezed == untilUtc ? _self.untilUtc : untilUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMutePayload].
extension ChatMutePayloadPatterns on ChatMutePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMutePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMutePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMutePayload value)  $default,){
final _that = this;
switch (_that) {
case _ChatMutePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMutePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMutePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? untilUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMutePayload() when $default != null:
return $default(_that.untilUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? untilUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatMutePayload():
return $default(_that.untilUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? untilUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatMutePayload() when $default != null:
return $default(_that.untilUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMutePayload implements ChatMutePayload {
  const _ChatMutePayload({this.untilUtc});
  factory _ChatMutePayload.fromJson(Map<String, dynamic> json) => _$ChatMutePayloadFromJson(json);

@override final  DateTime? untilUtc;

/// Create a copy of ChatMutePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMutePayloadCopyWith<_ChatMutePayload> get copyWith => __$ChatMutePayloadCopyWithImpl<_ChatMutePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMutePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMutePayload&&(identical(other.untilUtc, untilUtc) || other.untilUtc == untilUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,untilUtc);

@override
String toString() {
  return 'ChatMutePayload(untilUtc: $untilUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatMutePayloadCopyWith<$Res> implements $ChatMutePayloadCopyWith<$Res> {
  factory _$ChatMutePayloadCopyWith(_ChatMutePayload value, $Res Function(_ChatMutePayload) _then) = __$ChatMutePayloadCopyWithImpl;
@override @useResult
$Res call({
 DateTime? untilUtc
});




}
/// @nodoc
class __$ChatMutePayloadCopyWithImpl<$Res>
    implements _$ChatMutePayloadCopyWith<$Res> {
  __$ChatMutePayloadCopyWithImpl(this._self, this._then);

  final _ChatMutePayload _self;
  final $Res Function(_ChatMutePayload) _then;

/// Create a copy of ChatMutePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? untilUtc = freezed,}) {
  return _then(_ChatMutePayload(
untilUtc: freezed == untilUtc ? _self.untilUtc : untilUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ChatThreadMutePayload {

 DateTime? get untilUtc;
/// Create a copy of ChatThreadMutePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatThreadMutePayloadCopyWith<ChatThreadMutePayload> get copyWith => _$ChatThreadMutePayloadCopyWithImpl<ChatThreadMutePayload>(this as ChatThreadMutePayload, _$identity);

  /// Serializes this ChatThreadMutePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatThreadMutePayload&&(identical(other.untilUtc, untilUtc) || other.untilUtc == untilUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,untilUtc);

@override
String toString() {
  return 'ChatThreadMutePayload(untilUtc: $untilUtc)';
}


}

/// @nodoc
abstract mixin class $ChatThreadMutePayloadCopyWith<$Res>  {
  factory $ChatThreadMutePayloadCopyWith(ChatThreadMutePayload value, $Res Function(ChatThreadMutePayload) _then) = _$ChatThreadMutePayloadCopyWithImpl;
@useResult
$Res call({
 DateTime? untilUtc
});




}
/// @nodoc
class _$ChatThreadMutePayloadCopyWithImpl<$Res>
    implements $ChatThreadMutePayloadCopyWith<$Res> {
  _$ChatThreadMutePayloadCopyWithImpl(this._self, this._then);

  final ChatThreadMutePayload _self;
  final $Res Function(ChatThreadMutePayload) _then;

/// Create a copy of ChatThreadMutePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? untilUtc = freezed,}) {
  return _then(_self.copyWith(
untilUtc: freezed == untilUtc ? _self.untilUtc : untilUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatThreadMutePayload].
extension ChatThreadMutePayloadPatterns on ChatThreadMutePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatThreadMutePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatThreadMutePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatThreadMutePayload value)  $default,){
final _that = this;
switch (_that) {
case _ChatThreadMutePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatThreadMutePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ChatThreadMutePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? untilUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatThreadMutePayload() when $default != null:
return $default(_that.untilUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? untilUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatThreadMutePayload():
return $default(_that.untilUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? untilUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatThreadMutePayload() when $default != null:
return $default(_that.untilUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatThreadMutePayload implements ChatThreadMutePayload {
  const _ChatThreadMutePayload({this.untilUtc});
  factory _ChatThreadMutePayload.fromJson(Map<String, dynamic> json) => _$ChatThreadMutePayloadFromJson(json);

@override final  DateTime? untilUtc;

/// Create a copy of ChatThreadMutePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatThreadMutePayloadCopyWith<_ChatThreadMutePayload> get copyWith => __$ChatThreadMutePayloadCopyWithImpl<_ChatThreadMutePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatThreadMutePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatThreadMutePayload&&(identical(other.untilUtc, untilUtc) || other.untilUtc == untilUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,untilUtc);

@override
String toString() {
  return 'ChatThreadMutePayload(untilUtc: $untilUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatThreadMutePayloadCopyWith<$Res> implements $ChatThreadMutePayloadCopyWith<$Res> {
  factory _$ChatThreadMutePayloadCopyWith(_ChatThreadMutePayload value, $Res Function(_ChatThreadMutePayload) _then) = __$ChatThreadMutePayloadCopyWithImpl;
@override @useResult
$Res call({
 DateTime? untilUtc
});




}
/// @nodoc
class __$ChatThreadMutePayloadCopyWithImpl<$Res>
    implements _$ChatThreadMutePayloadCopyWith<$Res> {
  __$ChatThreadMutePayloadCopyWithImpl(this._self, this._then);

  final _ChatThreadMutePayload _self;
  final $Res Function(_ChatThreadMutePayload) _then;

/// Create a copy of ChatThreadMutePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? untilUtc = freezed,}) {
  return _then(_ChatThreadMutePayload(
untilUtc: freezed == untilUtc ? _self.untilUtc : untilUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AddChatPlacementPayload {

 String get provider; String get resourceType; String get resourceId; String? get label; String? get deepLink;
/// Create a copy of AddChatPlacementPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddChatPlacementPayloadCopyWith<AddChatPlacementPayload> get copyWith => _$AddChatPlacementPayloadCopyWithImpl<AddChatPlacementPayload>(this as AddChatPlacementPayload, _$identity);

  /// Serializes this AddChatPlacementPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddChatPlacementPayload&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.label, label) || other.label == label)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,resourceType,resourceId,label,deepLink);

@override
String toString() {
  return 'AddChatPlacementPayload(provider: $provider, resourceType: $resourceType, resourceId: $resourceId, label: $label, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class $AddChatPlacementPayloadCopyWith<$Res>  {
  factory $AddChatPlacementPayloadCopyWith(AddChatPlacementPayload value, $Res Function(AddChatPlacementPayload) _then) = _$AddChatPlacementPayloadCopyWithImpl;
@useResult
$Res call({
 String provider, String resourceType, String resourceId, String? label, String? deepLink
});




}
/// @nodoc
class _$AddChatPlacementPayloadCopyWithImpl<$Res>
    implements $AddChatPlacementPayloadCopyWith<$Res> {
  _$AddChatPlacementPayloadCopyWithImpl(this._self, this._then);

  final AddChatPlacementPayload _self;
  final $Res Function(AddChatPlacementPayload) _then;

/// Create a copy of AddChatPlacementPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? resourceType = null,Object? resourceId = null,Object? label = freezed,Object? deepLink = freezed,}) {
  return _then(_self.copyWith(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,resourceId: null == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddChatPlacementPayload].
extension AddChatPlacementPayloadPatterns on AddChatPlacementPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddChatPlacementPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddChatPlacementPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddChatPlacementPayload value)  $default,){
final _that = this;
switch (_that) {
case _AddChatPlacementPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddChatPlacementPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AddChatPlacementPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String resourceType,  String resourceId,  String? label,  String? deepLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddChatPlacementPayload() when $default != null:
return $default(_that.provider,_that.resourceType,_that.resourceId,_that.label,_that.deepLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String resourceType,  String resourceId,  String? label,  String? deepLink)  $default,) {final _that = this;
switch (_that) {
case _AddChatPlacementPayload():
return $default(_that.provider,_that.resourceType,_that.resourceId,_that.label,_that.deepLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String resourceType,  String resourceId,  String? label,  String? deepLink)?  $default,) {final _that = this;
switch (_that) {
case _AddChatPlacementPayload() when $default != null:
return $default(_that.provider,_that.resourceType,_that.resourceId,_that.label,_that.deepLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddChatPlacementPayload implements AddChatPlacementPayload {
  const _AddChatPlacementPayload({required this.provider, required this.resourceType, required this.resourceId, this.label, this.deepLink});
  factory _AddChatPlacementPayload.fromJson(Map<String, dynamic> json) => _$AddChatPlacementPayloadFromJson(json);

@override final  String provider;
@override final  String resourceType;
@override final  String resourceId;
@override final  String? label;
@override final  String? deepLink;

/// Create a copy of AddChatPlacementPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddChatPlacementPayloadCopyWith<_AddChatPlacementPayload> get copyWith => __$AddChatPlacementPayloadCopyWithImpl<_AddChatPlacementPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddChatPlacementPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddChatPlacementPayload&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.label, label) || other.label == label)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,resourceType,resourceId,label,deepLink);

@override
String toString() {
  return 'AddChatPlacementPayload(provider: $provider, resourceType: $resourceType, resourceId: $resourceId, label: $label, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$AddChatPlacementPayloadCopyWith<$Res> implements $AddChatPlacementPayloadCopyWith<$Res> {
  factory _$AddChatPlacementPayloadCopyWith(_AddChatPlacementPayload value, $Res Function(_AddChatPlacementPayload) _then) = __$AddChatPlacementPayloadCopyWithImpl;
@override @useResult
$Res call({
 String provider, String resourceType, String resourceId, String? label, String? deepLink
});




}
/// @nodoc
class __$AddChatPlacementPayloadCopyWithImpl<$Res>
    implements _$AddChatPlacementPayloadCopyWith<$Res> {
  __$AddChatPlacementPayloadCopyWithImpl(this._self, this._then);

  final _AddChatPlacementPayload _self;
  final $Res Function(_AddChatPlacementPayload) _then;

/// Create a copy of AddChatPlacementPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? resourceType = null,Object? resourceId = null,Object? label = freezed,Object? deepLink = freezed,}) {
  return _then(_AddChatPlacementPayload(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,resourceId: null == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChatPlacementResponse {

 String get id; String get conversationId; String get provider; String get resourceType; String get resourceId; String? get label; String? get deepLink; String get createdByUserId; DateTime get createdAtUtc;
/// Create a copy of ChatPlacementResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatPlacementResponseCopyWith<ChatPlacementResponse> get copyWith => _$ChatPlacementResponseCopyWithImpl<ChatPlacementResponse>(this as ChatPlacementResponse, _$identity);

  /// Serializes this ChatPlacementResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatPlacementResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.label, label) || other.label == label)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,provider,resourceType,resourceId,label,deepLink,createdByUserId,createdAtUtc);

@override
String toString() {
  return 'ChatPlacementResponse(id: $id, conversationId: $conversationId, provider: $provider, resourceType: $resourceType, resourceId: $resourceId, label: $label, deepLink: $deepLink, createdByUserId: $createdByUserId, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatPlacementResponseCopyWith<$Res>  {
  factory $ChatPlacementResponseCopyWith(ChatPlacementResponse value, $Res Function(ChatPlacementResponse) _then) = _$ChatPlacementResponseCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String provider, String resourceType, String resourceId, String? label, String? deepLink, String createdByUserId, DateTime createdAtUtc
});




}
/// @nodoc
class _$ChatPlacementResponseCopyWithImpl<$Res>
    implements $ChatPlacementResponseCopyWith<$Res> {
  _$ChatPlacementResponseCopyWithImpl(this._self, this._then);

  final ChatPlacementResponse _self;
  final $Res Function(ChatPlacementResponse) _then;

/// Create a copy of ChatPlacementResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? provider = null,Object? resourceType = null,Object? resourceId = null,Object? label = freezed,Object? deepLink = freezed,Object? createdByUserId = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,resourceId: null == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatPlacementResponse].
extension ChatPlacementResponsePatterns on ChatPlacementResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatPlacementResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatPlacementResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatPlacementResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatPlacementResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatPlacementResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatPlacementResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String provider,  String resourceType,  String resourceId,  String? label,  String? deepLink,  String createdByUserId,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatPlacementResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.provider,_that.resourceType,_that.resourceId,_that.label,_that.deepLink,_that.createdByUserId,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String provider,  String resourceType,  String resourceId,  String? label,  String? deepLink,  String createdByUserId,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatPlacementResponse():
return $default(_that.id,_that.conversationId,_that.provider,_that.resourceType,_that.resourceId,_that.label,_that.deepLink,_that.createdByUserId,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String provider,  String resourceType,  String resourceId,  String? label,  String? deepLink,  String createdByUserId,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatPlacementResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.provider,_that.resourceType,_that.resourceId,_that.label,_that.deepLink,_that.createdByUserId,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatPlacementResponse implements ChatPlacementResponse {
  const _ChatPlacementResponse({required this.id, required this.conversationId, required this.provider, required this.resourceType, required this.resourceId, this.label, this.deepLink, required this.createdByUserId, required this.createdAtUtc});
  factory _ChatPlacementResponse.fromJson(Map<String, dynamic> json) => _$ChatPlacementResponseFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String provider;
@override final  String resourceType;
@override final  String resourceId;
@override final  String? label;
@override final  String? deepLink;
@override final  String createdByUserId;
@override final  DateTime createdAtUtc;

/// Create a copy of ChatPlacementResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatPlacementResponseCopyWith<_ChatPlacementResponse> get copyWith => __$ChatPlacementResponseCopyWithImpl<_ChatPlacementResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatPlacementResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatPlacementResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.label, label) || other.label == label)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,provider,resourceType,resourceId,label,deepLink,createdByUserId,createdAtUtc);

@override
String toString() {
  return 'ChatPlacementResponse(id: $id, conversationId: $conversationId, provider: $provider, resourceType: $resourceType, resourceId: $resourceId, label: $label, deepLink: $deepLink, createdByUserId: $createdByUserId, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatPlacementResponseCopyWith<$Res> implements $ChatPlacementResponseCopyWith<$Res> {
  factory _$ChatPlacementResponseCopyWith(_ChatPlacementResponse value, $Res Function(_ChatPlacementResponse) _then) = __$ChatPlacementResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String provider, String resourceType, String resourceId, String? label, String? deepLink, String createdByUserId, DateTime createdAtUtc
});




}
/// @nodoc
class __$ChatPlacementResponseCopyWithImpl<$Res>
    implements _$ChatPlacementResponseCopyWith<$Res> {
  __$ChatPlacementResponseCopyWithImpl(this._self, this._then);

  final _ChatPlacementResponse _self;
  final $Res Function(_ChatPlacementResponse) _then;

/// Create a copy of ChatPlacementResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? provider = null,Object? resourceType = null,Object? resourceId = null,Object? label = freezed,Object? deepLink = freezed,Object? createdByUserId = null,Object? createdAtUtc = null,}) {
  return _then(_ChatPlacementResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String,resourceId: null == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$UpsertChatUserStatusPayload {

 String? get emoji; String? get text; DateTime? get expiresAtUtc; bool get isDnd;
/// Create a copy of UpsertChatUserStatusPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpsertChatUserStatusPayloadCopyWith<UpsertChatUserStatusPayload> get copyWith => _$UpsertChatUserStatusPayloadCopyWithImpl<UpsertChatUserStatusPayload>(this as UpsertChatUserStatusPayload, _$identity);

  /// Serializes this UpsertChatUserStatusPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpsertChatUserStatusPayload&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.text, text) || other.text == text)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.isDnd, isDnd) || other.isDnd == isDnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,text,expiresAtUtc,isDnd);

@override
String toString() {
  return 'UpsertChatUserStatusPayload(emoji: $emoji, text: $text, expiresAtUtc: $expiresAtUtc, isDnd: $isDnd)';
}


}

/// @nodoc
abstract mixin class $UpsertChatUserStatusPayloadCopyWith<$Res>  {
  factory $UpsertChatUserStatusPayloadCopyWith(UpsertChatUserStatusPayload value, $Res Function(UpsertChatUserStatusPayload) _then) = _$UpsertChatUserStatusPayloadCopyWithImpl;
@useResult
$Res call({
 String? emoji, String? text, DateTime? expiresAtUtc, bool isDnd
});




}
/// @nodoc
class _$UpsertChatUserStatusPayloadCopyWithImpl<$Res>
    implements $UpsertChatUserStatusPayloadCopyWith<$Res> {
  _$UpsertChatUserStatusPayloadCopyWithImpl(this._self, this._then);

  final UpsertChatUserStatusPayload _self;
  final $Res Function(UpsertChatUserStatusPayload) _then;

/// Create a copy of UpsertChatUserStatusPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = freezed,Object? text = freezed,Object? expiresAtUtc = freezed,Object? isDnd = null,}) {
  return _then(_self.copyWith(
emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,isDnd: null == isDnd ? _self.isDnd : isDnd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UpsertChatUserStatusPayload].
extension UpsertChatUserStatusPayloadPatterns on UpsertChatUserStatusPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpsertChatUserStatusPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpsertChatUserStatusPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpsertChatUserStatusPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload() when $default != null:
return $default(_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd)  $default,) {final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload():
return $default(_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd)?  $default,) {final _that = this;
switch (_that) {
case _UpsertChatUserStatusPayload() when $default != null:
return $default(_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpsertChatUserStatusPayload implements UpsertChatUserStatusPayload {
  const _UpsertChatUserStatusPayload({this.emoji, this.text, this.expiresAtUtc, this.isDnd = false});
  factory _UpsertChatUserStatusPayload.fromJson(Map<String, dynamic> json) => _$UpsertChatUserStatusPayloadFromJson(json);

@override final  String? emoji;
@override final  String? text;
@override final  DateTime? expiresAtUtc;
@override@JsonKey() final  bool isDnd;

/// Create a copy of UpsertChatUserStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpsertChatUserStatusPayloadCopyWith<_UpsertChatUserStatusPayload> get copyWith => __$UpsertChatUserStatusPayloadCopyWithImpl<_UpsertChatUserStatusPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpsertChatUserStatusPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpsertChatUserStatusPayload&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.text, text) || other.text == text)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.isDnd, isDnd) || other.isDnd == isDnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,text,expiresAtUtc,isDnd);

@override
String toString() {
  return 'UpsertChatUserStatusPayload(emoji: $emoji, text: $text, expiresAtUtc: $expiresAtUtc, isDnd: $isDnd)';
}


}

/// @nodoc
abstract mixin class _$UpsertChatUserStatusPayloadCopyWith<$Res> implements $UpsertChatUserStatusPayloadCopyWith<$Res> {
  factory _$UpsertChatUserStatusPayloadCopyWith(_UpsertChatUserStatusPayload value, $Res Function(_UpsertChatUserStatusPayload) _then) = __$UpsertChatUserStatusPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? emoji, String? text, DateTime? expiresAtUtc, bool isDnd
});




}
/// @nodoc
class __$UpsertChatUserStatusPayloadCopyWithImpl<$Res>
    implements _$UpsertChatUserStatusPayloadCopyWith<$Res> {
  __$UpsertChatUserStatusPayloadCopyWithImpl(this._self, this._then);

  final _UpsertChatUserStatusPayload _self;
  final $Res Function(_UpsertChatUserStatusPayload) _then;

/// Create a copy of UpsertChatUserStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = freezed,Object? text = freezed,Object? expiresAtUtc = freezed,Object? isDnd = null,}) {
  return _then(_UpsertChatUserStatusPayload(
emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,isDnd: null == isDnd ? _self.isDnd : isDnd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatUserStatusResponse {

 String get userId; String? get emoji; String? get text; DateTime? get expiresAtUtc; bool get isDnd; DateTime get updatedAtUtc;
/// Create a copy of ChatUserStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatUserStatusResponseCopyWith<ChatUserStatusResponse> get copyWith => _$ChatUserStatusResponseCopyWithImpl<ChatUserStatusResponse>(this as ChatUserStatusResponse, _$identity);

  /// Serializes this ChatUserStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatUserStatusResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.text, text) || other.text == text)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.isDnd, isDnd) || other.isDnd == isDnd)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,emoji,text,expiresAtUtc,isDnd,updatedAtUtc);

@override
String toString() {
  return 'ChatUserStatusResponse(userId: $userId, emoji: $emoji, text: $text, expiresAtUtc: $expiresAtUtc, isDnd: $isDnd, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatUserStatusResponseCopyWith<$Res>  {
  factory $ChatUserStatusResponseCopyWith(ChatUserStatusResponse value, $Res Function(ChatUserStatusResponse) _then) = _$ChatUserStatusResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String? emoji, String? text, DateTime? expiresAtUtc, bool isDnd, DateTime updatedAtUtc
});




}
/// @nodoc
class _$ChatUserStatusResponseCopyWithImpl<$Res>
    implements $ChatUserStatusResponseCopyWith<$Res> {
  _$ChatUserStatusResponseCopyWithImpl(this._self, this._then);

  final ChatUserStatusResponse _self;
  final $Res Function(ChatUserStatusResponse) _then;

/// Create a copy of ChatUserStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? emoji = freezed,Object? text = freezed,Object? expiresAtUtc = freezed,Object? isDnd = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,isDnd: null == isDnd ? _self.isDnd : isDnd // ignore: cast_nullable_to_non_nullable
as bool,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatUserStatusResponse].
extension ChatUserStatusResponsePatterns on ChatUserStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatUserStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatUserStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatUserStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatUserStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatUserStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatUserStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatUserStatusResponse() when $default != null:
return $default(_that.userId,_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatUserStatusResponse():
return $default(_that.userId,_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? emoji,  String? text,  DateTime? expiresAtUtc,  bool isDnd,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatUserStatusResponse() when $default != null:
return $default(_that.userId,_that.emoji,_that.text,_that.expiresAtUtc,_that.isDnd,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatUserStatusResponse implements ChatUserStatusResponse {
  const _ChatUserStatusResponse({required this.userId, this.emoji, this.text, this.expiresAtUtc, required this.isDnd, required this.updatedAtUtc});
  factory _ChatUserStatusResponse.fromJson(Map<String, dynamic> json) => _$ChatUserStatusResponseFromJson(json);

@override final  String userId;
@override final  String? emoji;
@override final  String? text;
@override final  DateTime? expiresAtUtc;
@override final  bool isDnd;
@override final  DateTime updatedAtUtc;

/// Create a copy of ChatUserStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatUserStatusResponseCopyWith<_ChatUserStatusResponse> get copyWith => __$ChatUserStatusResponseCopyWithImpl<_ChatUserStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatUserStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatUserStatusResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.text, text) || other.text == text)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.isDnd, isDnd) || other.isDnd == isDnd)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,emoji,text,expiresAtUtc,isDnd,updatedAtUtc);

@override
String toString() {
  return 'ChatUserStatusResponse(userId: $userId, emoji: $emoji, text: $text, expiresAtUtc: $expiresAtUtc, isDnd: $isDnd, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatUserStatusResponseCopyWith<$Res> implements $ChatUserStatusResponseCopyWith<$Res> {
  factory _$ChatUserStatusResponseCopyWith(_ChatUserStatusResponse value, $Res Function(_ChatUserStatusResponse) _then) = __$ChatUserStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? emoji, String? text, DateTime? expiresAtUtc, bool isDnd, DateTime updatedAtUtc
});




}
/// @nodoc
class __$ChatUserStatusResponseCopyWithImpl<$Res>
    implements _$ChatUserStatusResponseCopyWith<$Res> {
  __$ChatUserStatusResponseCopyWithImpl(this._self, this._then);

  final _ChatUserStatusResponse _self;
  final $Res Function(_ChatUserStatusResponse) _then;

/// Create a copy of ChatUserStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? emoji = freezed,Object? text = freezed,Object? expiresAtUtc = freezed,Object? isDnd = null,Object? updatedAtUtc = null,}) {
  return _then(_ChatUserStatusResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,isDnd: null == isDnd ? _self.isDnd : isDnd // ignore: cast_nullable_to_non_nullable
as bool,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatUserNotificationPreferenceResponse {

 String get userId; bool get inAppEnabled; bool get emailEnabled; bool get pushEnabled; bool get digestEnabled;
/// Create a copy of ChatUserNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatUserNotificationPreferenceResponseCopyWith<ChatUserNotificationPreferenceResponse> get copyWith => _$ChatUserNotificationPreferenceResponseCopyWithImpl<ChatUserNotificationPreferenceResponse>(this as ChatUserNotificationPreferenceResponse, _$identity);

  /// Serializes this ChatUserNotificationPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatUserNotificationPreferenceResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.digestEnabled, digestEnabled) || other.digestEnabled == digestEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,inAppEnabled,emailEnabled,pushEnabled,digestEnabled);

@override
String toString() {
  return 'ChatUserNotificationPreferenceResponse(userId: $userId, inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, pushEnabled: $pushEnabled, digestEnabled: $digestEnabled)';
}


}

/// @nodoc
abstract mixin class $ChatUserNotificationPreferenceResponseCopyWith<$Res>  {
  factory $ChatUserNotificationPreferenceResponseCopyWith(ChatUserNotificationPreferenceResponse value, $Res Function(ChatUserNotificationPreferenceResponse) _then) = _$ChatUserNotificationPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String userId, bool inAppEnabled, bool emailEnabled, bool pushEnabled, bool digestEnabled
});




}
/// @nodoc
class _$ChatUserNotificationPreferenceResponseCopyWithImpl<$Res>
    implements $ChatUserNotificationPreferenceResponseCopyWith<$Res> {
  _$ChatUserNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final ChatUserNotificationPreferenceResponse _self;
  final $Res Function(ChatUserNotificationPreferenceResponse) _then;

/// Create a copy of ChatUserNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? inAppEnabled = null,Object? emailEnabled = null,Object? pushEnabled = null,Object? digestEnabled = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,inAppEnabled: null == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool,emailEnabled: null == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,digestEnabled: null == digestEnabled ? _self.digestEnabled : digestEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatUserNotificationPreferenceResponse].
extension ChatUserNotificationPreferenceResponsePatterns on ChatUserNotificationPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatUserNotificationPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatUserNotificationPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatUserNotificationPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool inAppEnabled,  bool emailEnabled,  bool pushEnabled,  bool digestEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse() when $default != null:
return $default(_that.userId,_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool inAppEnabled,  bool emailEnabled,  bool pushEnabled,  bool digestEnabled)  $default,) {final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse():
return $default(_that.userId,_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool inAppEnabled,  bool emailEnabled,  bool pushEnabled,  bool digestEnabled)?  $default,) {final _that = this;
switch (_that) {
case _ChatUserNotificationPreferenceResponse() when $default != null:
return $default(_that.userId,_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatUserNotificationPreferenceResponse implements ChatUserNotificationPreferenceResponse {
  const _ChatUserNotificationPreferenceResponse({required this.userId, required this.inAppEnabled, required this.emailEnabled, required this.pushEnabled, required this.digestEnabled});
  factory _ChatUserNotificationPreferenceResponse.fromJson(Map<String, dynamic> json) => _$ChatUserNotificationPreferenceResponseFromJson(json);

@override final  String userId;
@override final  bool inAppEnabled;
@override final  bool emailEnabled;
@override final  bool pushEnabled;
@override final  bool digestEnabled;

/// Create a copy of ChatUserNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatUserNotificationPreferenceResponseCopyWith<_ChatUserNotificationPreferenceResponse> get copyWith => __$ChatUserNotificationPreferenceResponseCopyWithImpl<_ChatUserNotificationPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatUserNotificationPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatUserNotificationPreferenceResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.digestEnabled, digestEnabled) || other.digestEnabled == digestEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,inAppEnabled,emailEnabled,pushEnabled,digestEnabled);

@override
String toString() {
  return 'ChatUserNotificationPreferenceResponse(userId: $userId, inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, pushEnabled: $pushEnabled, digestEnabled: $digestEnabled)';
}


}

/// @nodoc
abstract mixin class _$ChatUserNotificationPreferenceResponseCopyWith<$Res> implements $ChatUserNotificationPreferenceResponseCopyWith<$Res> {
  factory _$ChatUserNotificationPreferenceResponseCopyWith(_ChatUserNotificationPreferenceResponse value, $Res Function(_ChatUserNotificationPreferenceResponse) _then) = __$ChatUserNotificationPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool inAppEnabled, bool emailEnabled, bool pushEnabled, bool digestEnabled
});




}
/// @nodoc
class __$ChatUserNotificationPreferenceResponseCopyWithImpl<$Res>
    implements _$ChatUserNotificationPreferenceResponseCopyWith<$Res> {
  __$ChatUserNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final _ChatUserNotificationPreferenceResponse _self;
  final $Res Function(_ChatUserNotificationPreferenceResponse) _then;

/// Create a copy of ChatUserNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? inAppEnabled = null,Object? emailEnabled = null,Object? pushEnabled = null,Object? digestEnabled = null,}) {
  return _then(_ChatUserNotificationPreferenceResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,inAppEnabled: null == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool,emailEnabled: null == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,digestEnabled: null == digestEnabled ? _self.digestEnabled : digestEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UpdateChatUserNotificationPreferencePayload {

 bool? get inAppEnabled; bool? get emailEnabled; bool? get pushEnabled; bool? get digestEnabled;
/// Create a copy of UpdateChatUserNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateChatUserNotificationPreferencePayloadCopyWith<UpdateChatUserNotificationPreferencePayload> get copyWith => _$UpdateChatUserNotificationPreferencePayloadCopyWithImpl<UpdateChatUserNotificationPreferencePayload>(this as UpdateChatUserNotificationPreferencePayload, _$identity);

  /// Serializes this UpdateChatUserNotificationPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChatUserNotificationPreferencePayload&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.digestEnabled, digestEnabled) || other.digestEnabled == digestEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inAppEnabled,emailEnabled,pushEnabled,digestEnabled);

@override
String toString() {
  return 'UpdateChatUserNotificationPreferencePayload(inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, pushEnabled: $pushEnabled, digestEnabled: $digestEnabled)';
}


}

/// @nodoc
abstract mixin class $UpdateChatUserNotificationPreferencePayloadCopyWith<$Res>  {
  factory $UpdateChatUserNotificationPreferencePayloadCopyWith(UpdateChatUserNotificationPreferencePayload value, $Res Function(UpdateChatUserNotificationPreferencePayload) _then) = _$UpdateChatUserNotificationPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 bool? inAppEnabled, bool? emailEnabled, bool? pushEnabled, bool? digestEnabled
});




}
/// @nodoc
class _$UpdateChatUserNotificationPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateChatUserNotificationPreferencePayloadCopyWith<$Res> {
  _$UpdateChatUserNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateChatUserNotificationPreferencePayload _self;
  final $Res Function(UpdateChatUserNotificationPreferencePayload) _then;

/// Create a copy of UpdateChatUserNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inAppEnabled = freezed,Object? emailEnabled = freezed,Object? pushEnabled = freezed,Object? digestEnabled = freezed,}) {
  return _then(_self.copyWith(
inAppEnabled: freezed == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool?,emailEnabled: freezed == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool?,pushEnabled: freezed == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool?,digestEnabled: freezed == digestEnabled ? _self.digestEnabled : digestEnabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateChatUserNotificationPreferencePayload].
extension UpdateChatUserNotificationPreferencePayloadPatterns on UpdateChatUserNotificationPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateChatUserNotificationPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateChatUserNotificationPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateChatUserNotificationPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? inAppEnabled,  bool? emailEnabled,  bool? pushEnabled,  bool? digestEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload() when $default != null:
return $default(_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? inAppEnabled,  bool? emailEnabled,  bool? pushEnabled,  bool? digestEnabled)  $default,) {final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload():
return $default(_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? inAppEnabled,  bool? emailEnabled,  bool? pushEnabled,  bool? digestEnabled)?  $default,) {final _that = this;
switch (_that) {
case _UpdateChatUserNotificationPreferencePayload() when $default != null:
return $default(_that.inAppEnabled,_that.emailEnabled,_that.pushEnabled,_that.digestEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateChatUserNotificationPreferencePayload implements UpdateChatUserNotificationPreferencePayload {
  const _UpdateChatUserNotificationPreferencePayload({this.inAppEnabled, this.emailEnabled, this.pushEnabled, this.digestEnabled});
  factory _UpdateChatUserNotificationPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateChatUserNotificationPreferencePayloadFromJson(json);

@override final  bool? inAppEnabled;
@override final  bool? emailEnabled;
@override final  bool? pushEnabled;
@override final  bool? digestEnabled;

/// Create a copy of UpdateChatUserNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateChatUserNotificationPreferencePayloadCopyWith<_UpdateChatUserNotificationPreferencePayload> get copyWith => __$UpdateChatUserNotificationPreferencePayloadCopyWithImpl<_UpdateChatUserNotificationPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateChatUserNotificationPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateChatUserNotificationPreferencePayload&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.digestEnabled, digestEnabled) || other.digestEnabled == digestEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inAppEnabled,emailEnabled,pushEnabled,digestEnabled);

@override
String toString() {
  return 'UpdateChatUserNotificationPreferencePayload(inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, pushEnabled: $pushEnabled, digestEnabled: $digestEnabled)';
}


}

/// @nodoc
abstract mixin class _$UpdateChatUserNotificationPreferencePayloadCopyWith<$Res> implements $UpdateChatUserNotificationPreferencePayloadCopyWith<$Res> {
  factory _$UpdateChatUserNotificationPreferencePayloadCopyWith(_UpdateChatUserNotificationPreferencePayload value, $Res Function(_UpdateChatUserNotificationPreferencePayload) _then) = __$UpdateChatUserNotificationPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 bool? inAppEnabled, bool? emailEnabled, bool? pushEnabled, bool? digestEnabled
});




}
/// @nodoc
class __$UpdateChatUserNotificationPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateChatUserNotificationPreferencePayloadCopyWith<$Res> {
  __$UpdateChatUserNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateChatUserNotificationPreferencePayload _self;
  final $Res Function(_UpdateChatUserNotificationPreferencePayload) _then;

/// Create a copy of UpdateChatUserNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inAppEnabled = freezed,Object? emailEnabled = freezed,Object? pushEnabled = freezed,Object? digestEnabled = freezed,}) {
  return _then(_UpdateChatUserNotificationPreferencePayload(
inAppEnabled: freezed == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool?,emailEnabled: freezed == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool?,pushEnabled: freezed == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool?,digestEnabled: freezed == digestEnabled ? _self.digestEnabled : digestEnabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$ChatNotificationPreferenceResponse {

 String get conversationId; String get userId; ChatNotificationPreference get preference;
/// Create a copy of ChatNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatNotificationPreferenceResponseCopyWith<ChatNotificationPreferenceResponse> get copyWith => _$ChatNotificationPreferenceResponseCopyWithImpl<ChatNotificationPreferenceResponse>(this as ChatNotificationPreferenceResponse, _$identity);

  /// Serializes this ChatNotificationPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatNotificationPreferenceResponse&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.preference, preference) || other.preference == preference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,userId,preference);

@override
String toString() {
  return 'ChatNotificationPreferenceResponse(conversationId: $conversationId, userId: $userId, preference: $preference)';
}


}

/// @nodoc
abstract mixin class $ChatNotificationPreferenceResponseCopyWith<$Res>  {
  factory $ChatNotificationPreferenceResponseCopyWith(ChatNotificationPreferenceResponse value, $Res Function(ChatNotificationPreferenceResponse) _then) = _$ChatNotificationPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String conversationId, String userId, ChatNotificationPreference preference
});




}
/// @nodoc
class _$ChatNotificationPreferenceResponseCopyWithImpl<$Res>
    implements $ChatNotificationPreferenceResponseCopyWith<$Res> {
  _$ChatNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final ChatNotificationPreferenceResponse _self;
  final $Res Function(ChatNotificationPreferenceResponse) _then;

/// Create a copy of ChatNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? userId = null,Object? preference = null,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as ChatNotificationPreference,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatNotificationPreferenceResponse].
extension ChatNotificationPreferenceResponsePatterns on ChatNotificationPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatNotificationPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatNotificationPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatNotificationPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String conversationId,  String userId,  ChatNotificationPreference preference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse() when $default != null:
return $default(_that.conversationId,_that.userId,_that.preference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String conversationId,  String userId,  ChatNotificationPreference preference)  $default,) {final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse():
return $default(_that.conversationId,_that.userId,_that.preference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String conversationId,  String userId,  ChatNotificationPreference preference)?  $default,) {final _that = this;
switch (_that) {
case _ChatNotificationPreferenceResponse() when $default != null:
return $default(_that.conversationId,_that.userId,_that.preference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatNotificationPreferenceResponse implements ChatNotificationPreferenceResponse {
  const _ChatNotificationPreferenceResponse({required this.conversationId, required this.userId, required this.preference});
  factory _ChatNotificationPreferenceResponse.fromJson(Map<String, dynamic> json) => _$ChatNotificationPreferenceResponseFromJson(json);

@override final  String conversationId;
@override final  String userId;
@override final  ChatNotificationPreference preference;

/// Create a copy of ChatNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatNotificationPreferenceResponseCopyWith<_ChatNotificationPreferenceResponse> get copyWith => __$ChatNotificationPreferenceResponseCopyWithImpl<_ChatNotificationPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatNotificationPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatNotificationPreferenceResponse&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.preference, preference) || other.preference == preference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,userId,preference);

@override
String toString() {
  return 'ChatNotificationPreferenceResponse(conversationId: $conversationId, userId: $userId, preference: $preference)';
}


}

/// @nodoc
abstract mixin class _$ChatNotificationPreferenceResponseCopyWith<$Res> implements $ChatNotificationPreferenceResponseCopyWith<$Res> {
  factory _$ChatNotificationPreferenceResponseCopyWith(_ChatNotificationPreferenceResponse value, $Res Function(_ChatNotificationPreferenceResponse) _then) = __$ChatNotificationPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String conversationId, String userId, ChatNotificationPreference preference
});




}
/// @nodoc
class __$ChatNotificationPreferenceResponseCopyWithImpl<$Res>
    implements _$ChatNotificationPreferenceResponseCopyWith<$Res> {
  __$ChatNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final _ChatNotificationPreferenceResponse _self;
  final $Res Function(_ChatNotificationPreferenceResponse) _then;

/// Create a copy of ChatNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? userId = null,Object? preference = null,}) {
  return _then(_ChatNotificationPreferenceResponse(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as ChatNotificationPreference,
  ));
}


}


/// @nodoc
mixin _$UpdateChatNotificationPreferencePayload {

 ChatNotificationPreference get preference;
/// Create a copy of UpdateChatNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateChatNotificationPreferencePayloadCopyWith<UpdateChatNotificationPreferencePayload> get copyWith => _$UpdateChatNotificationPreferencePayloadCopyWithImpl<UpdateChatNotificationPreferencePayload>(this as UpdateChatNotificationPreferencePayload, _$identity);

  /// Serializes this UpdateChatNotificationPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateChatNotificationPreferencePayload&&(identical(other.preference, preference) || other.preference == preference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preference);

@override
String toString() {
  return 'UpdateChatNotificationPreferencePayload(preference: $preference)';
}


}

/// @nodoc
abstract mixin class $UpdateChatNotificationPreferencePayloadCopyWith<$Res>  {
  factory $UpdateChatNotificationPreferencePayloadCopyWith(UpdateChatNotificationPreferencePayload value, $Res Function(UpdateChatNotificationPreferencePayload) _then) = _$UpdateChatNotificationPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 ChatNotificationPreference preference
});




}
/// @nodoc
class _$UpdateChatNotificationPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateChatNotificationPreferencePayloadCopyWith<$Res> {
  _$UpdateChatNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateChatNotificationPreferencePayload _self;
  final $Res Function(UpdateChatNotificationPreferencePayload) _then;

/// Create a copy of UpdateChatNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preference = null,}) {
  return _then(_self.copyWith(
preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as ChatNotificationPreference,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateChatNotificationPreferencePayload].
extension UpdateChatNotificationPreferencePayloadPatterns on UpdateChatNotificationPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateChatNotificationPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateChatNotificationPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateChatNotificationPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatNotificationPreference preference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload() when $default != null:
return $default(_that.preference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatNotificationPreference preference)  $default,) {final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload():
return $default(_that.preference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatNotificationPreference preference)?  $default,) {final _that = this;
switch (_that) {
case _UpdateChatNotificationPreferencePayload() when $default != null:
return $default(_that.preference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateChatNotificationPreferencePayload implements UpdateChatNotificationPreferencePayload {
  const _UpdateChatNotificationPreferencePayload({required this.preference});
  factory _UpdateChatNotificationPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateChatNotificationPreferencePayloadFromJson(json);

@override final  ChatNotificationPreference preference;

/// Create a copy of UpdateChatNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateChatNotificationPreferencePayloadCopyWith<_UpdateChatNotificationPreferencePayload> get copyWith => __$UpdateChatNotificationPreferencePayloadCopyWithImpl<_UpdateChatNotificationPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateChatNotificationPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateChatNotificationPreferencePayload&&(identical(other.preference, preference) || other.preference == preference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preference);

@override
String toString() {
  return 'UpdateChatNotificationPreferencePayload(preference: $preference)';
}


}

/// @nodoc
abstract mixin class _$UpdateChatNotificationPreferencePayloadCopyWith<$Res> implements $UpdateChatNotificationPreferencePayloadCopyWith<$Res> {
  factory _$UpdateChatNotificationPreferencePayloadCopyWith(_UpdateChatNotificationPreferencePayload value, $Res Function(_UpdateChatNotificationPreferencePayload) _then) = __$UpdateChatNotificationPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 ChatNotificationPreference preference
});




}
/// @nodoc
class __$UpdateChatNotificationPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateChatNotificationPreferencePayloadCopyWith<$Res> {
  __$UpdateChatNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateChatNotificationPreferencePayload _self;
  final $Res Function(_UpdateChatNotificationPreferencePayload) _then;

/// Create a copy of UpdateChatNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preference = null,}) {
  return _then(_UpdateChatNotificationPreferencePayload(
preference: null == preference ? _self.preference : preference // ignore: cast_nullable_to_non_nullable
as ChatNotificationPreference,
  ));
}


}


/// @nodoc
mixin _$AttachChatFilePayload {

 String get storageFileId; int get position;
/// Create a copy of AttachChatFilePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachChatFilePayloadCopyWith<AttachChatFilePayload> get copyWith => _$AttachChatFilePayloadCopyWithImpl<AttachChatFilePayload>(this as AttachChatFilePayload, _$identity);

  /// Serializes this AttachChatFilePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachChatFilePayload&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageFileId,position);

@override
String toString() {
  return 'AttachChatFilePayload(storageFileId: $storageFileId, position: $position)';
}


}

/// @nodoc
abstract mixin class $AttachChatFilePayloadCopyWith<$Res>  {
  factory $AttachChatFilePayloadCopyWith(AttachChatFilePayload value, $Res Function(AttachChatFilePayload) _then) = _$AttachChatFilePayloadCopyWithImpl;
@useResult
$Res call({
 String storageFileId, int position
});




}
/// @nodoc
class _$AttachChatFilePayloadCopyWithImpl<$Res>
    implements $AttachChatFilePayloadCopyWith<$Res> {
  _$AttachChatFilePayloadCopyWithImpl(this._self, this._then);

  final AttachChatFilePayload _self;
  final $Res Function(AttachChatFilePayload) _then;

/// Create a copy of AttachChatFilePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storageFileId = null,Object? position = null,}) {
  return _then(_self.copyWith(
storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachChatFilePayload].
extension AttachChatFilePayloadPatterns on AttachChatFilePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachChatFilePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachChatFilePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachChatFilePayload value)  $default,){
final _that = this;
switch (_that) {
case _AttachChatFilePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachChatFilePayload value)?  $default,){
final _that = this;
switch (_that) {
case _AttachChatFilePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storageFileId,  int position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachChatFilePayload() when $default != null:
return $default(_that.storageFileId,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storageFileId,  int position)  $default,) {final _that = this;
switch (_that) {
case _AttachChatFilePayload():
return $default(_that.storageFileId,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storageFileId,  int position)?  $default,) {final _that = this;
switch (_that) {
case _AttachChatFilePayload() when $default != null:
return $default(_that.storageFileId,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachChatFilePayload implements AttachChatFilePayload {
  const _AttachChatFilePayload({required this.storageFileId, this.position = 0});
  factory _AttachChatFilePayload.fromJson(Map<String, dynamic> json) => _$AttachChatFilePayloadFromJson(json);

@override final  String storageFileId;
@override@JsonKey() final  int position;

/// Create a copy of AttachChatFilePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachChatFilePayloadCopyWith<_AttachChatFilePayload> get copyWith => __$AttachChatFilePayloadCopyWithImpl<_AttachChatFilePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachChatFilePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachChatFilePayload&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageFileId,position);

@override
String toString() {
  return 'AttachChatFilePayload(storageFileId: $storageFileId, position: $position)';
}


}

/// @nodoc
abstract mixin class _$AttachChatFilePayloadCopyWith<$Res> implements $AttachChatFilePayloadCopyWith<$Res> {
  factory _$AttachChatFilePayloadCopyWith(_AttachChatFilePayload value, $Res Function(_AttachChatFilePayload) _then) = __$AttachChatFilePayloadCopyWithImpl;
@override @useResult
$Res call({
 String storageFileId, int position
});




}
/// @nodoc
class __$AttachChatFilePayloadCopyWithImpl<$Res>
    implements _$AttachChatFilePayloadCopyWith<$Res> {
  __$AttachChatFilePayloadCopyWithImpl(this._self, this._then);

  final _AttachChatFilePayload _self;
  final $Res Function(_AttachChatFilePayload) _then;

/// Create a copy of AttachChatFilePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storageFileId = null,Object? position = null,}) {
  return _then(_AttachChatFilePayload(
storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChatAttachmentResponse {

 String get id; String get messageId; String get storageFileId; String get attachedByUserId; int get position; DateTime get createdAtUtc; String? get fileName; int? get fileSizeBytes; String? get contentType; bool get isAvailable;
/// Create a copy of ChatAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatAttachmentResponseCopyWith<ChatAttachmentResponse> get copyWith => _$ChatAttachmentResponseCopyWithImpl<ChatAttachmentResponse>(this as ChatAttachmentResponse, _$identity);

  /// Serializes this ChatAttachmentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatAttachmentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.attachedByUserId, attachedByUserId) || other.attachedByUserId == attachedByUserId)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,storageFileId,attachedByUserId,position,createdAtUtc,fileName,fileSizeBytes,contentType,isAvailable);

@override
String toString() {
  return 'ChatAttachmentResponse(id: $id, messageId: $messageId, storageFileId: $storageFileId, attachedByUserId: $attachedByUserId, position: $position, createdAtUtc: $createdAtUtc, fileName: $fileName, fileSizeBytes: $fileSizeBytes, contentType: $contentType, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class $ChatAttachmentResponseCopyWith<$Res>  {
  factory $ChatAttachmentResponseCopyWith(ChatAttachmentResponse value, $Res Function(ChatAttachmentResponse) _then) = _$ChatAttachmentResponseCopyWithImpl;
@useResult
$Res call({
 String id, String messageId, String storageFileId, String attachedByUserId, int position, DateTime createdAtUtc, String? fileName, int? fileSizeBytes, String? contentType, bool isAvailable
});




}
/// @nodoc
class _$ChatAttachmentResponseCopyWithImpl<$Res>
    implements $ChatAttachmentResponseCopyWith<$Res> {
  _$ChatAttachmentResponseCopyWithImpl(this._self, this._then);

  final ChatAttachmentResponse _self;
  final $Res Function(ChatAttachmentResponse) _then;

/// Create a copy of ChatAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messageId = null,Object? storageFileId = null,Object? attachedByUserId = null,Object? position = null,Object? createdAtUtc = null,Object? fileName = freezed,Object? fileSizeBytes = freezed,Object? contentType = freezed,Object? isAvailable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,attachedByUserId: null == attachedByUserId ? _self.attachedByUserId : attachedByUserId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatAttachmentResponse].
extension ChatAttachmentResponsePatterns on ChatAttachmentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatAttachmentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatAttachmentResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatAttachmentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatAttachmentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messageId,  String storageFileId,  String attachedByUserId,  int position,  DateTime createdAtUtc,  String? fileName,  int? fileSizeBytes,  String? contentType,  bool isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatAttachmentResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.storageFileId,_that.attachedByUserId,_that.position,_that.createdAtUtc,_that.fileName,_that.fileSizeBytes,_that.contentType,_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messageId,  String storageFileId,  String attachedByUserId,  int position,  DateTime createdAtUtc,  String? fileName,  int? fileSizeBytes,  String? contentType,  bool isAvailable)  $default,) {final _that = this;
switch (_that) {
case _ChatAttachmentResponse():
return $default(_that.id,_that.messageId,_that.storageFileId,_that.attachedByUserId,_that.position,_that.createdAtUtc,_that.fileName,_that.fileSizeBytes,_that.contentType,_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messageId,  String storageFileId,  String attachedByUserId,  int position,  DateTime createdAtUtc,  String? fileName,  int? fileSizeBytes,  String? contentType,  bool isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _ChatAttachmentResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.storageFileId,_that.attachedByUserId,_that.position,_that.createdAtUtc,_that.fileName,_that.fileSizeBytes,_that.contentType,_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatAttachmentResponse implements ChatAttachmentResponse {
  const _ChatAttachmentResponse({required this.id, required this.messageId, required this.storageFileId, required this.attachedByUserId, required this.position, required this.createdAtUtc, this.fileName, this.fileSizeBytes, this.contentType, this.isAvailable = false});
  factory _ChatAttachmentResponse.fromJson(Map<String, dynamic> json) => _$ChatAttachmentResponseFromJson(json);

@override final  String id;
@override final  String messageId;
@override final  String storageFileId;
@override final  String attachedByUserId;
@override final  int position;
@override final  DateTime createdAtUtc;
@override final  String? fileName;
@override final  int? fileSizeBytes;
@override final  String? contentType;
@override@JsonKey() final  bool isAvailable;

/// Create a copy of ChatAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatAttachmentResponseCopyWith<_ChatAttachmentResponse> get copyWith => __$ChatAttachmentResponseCopyWithImpl<_ChatAttachmentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatAttachmentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatAttachmentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.attachedByUserId, attachedByUserId) || other.attachedByUserId == attachedByUserId)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,storageFileId,attachedByUserId,position,createdAtUtc,fileName,fileSizeBytes,contentType,isAvailable);

@override
String toString() {
  return 'ChatAttachmentResponse(id: $id, messageId: $messageId, storageFileId: $storageFileId, attachedByUserId: $attachedByUserId, position: $position, createdAtUtc: $createdAtUtc, fileName: $fileName, fileSizeBytes: $fileSizeBytes, contentType: $contentType, isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$ChatAttachmentResponseCopyWith<$Res> implements $ChatAttachmentResponseCopyWith<$Res> {
  factory _$ChatAttachmentResponseCopyWith(_ChatAttachmentResponse value, $Res Function(_ChatAttachmentResponse) _then) = __$ChatAttachmentResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String messageId, String storageFileId, String attachedByUserId, int position, DateTime createdAtUtc, String? fileName, int? fileSizeBytes, String? contentType, bool isAvailable
});




}
/// @nodoc
class __$ChatAttachmentResponseCopyWithImpl<$Res>
    implements _$ChatAttachmentResponseCopyWith<$Res> {
  __$ChatAttachmentResponseCopyWithImpl(this._self, this._then);

  final _ChatAttachmentResponse _self;
  final $Res Function(_ChatAttachmentResponse) _then;

/// Create a copy of ChatAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messageId = null,Object? storageFileId = null,Object? attachedByUserId = null,Object? position = null,Object? createdAtUtc = null,Object? fileName = freezed,Object? fileSizeBytes = freezed,Object? contentType = freezed,Object? isAvailable = null,}) {
  return _then(_ChatAttachmentResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,attachedByUserId: null == attachedByUserId ? _self.attachedByUserId : attachedByUserId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatInviteResponse {

 String get id; String get conversationId; String get email; ChatInvitationStatus get status; DateTime get createdAtUtc; DateTime get expiresAtUtc; DateTime? get respondedAtUtc;
/// Create a copy of ChatInviteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInviteResponseCopyWith<ChatInviteResponse> get copyWith => _$ChatInviteResponseCopyWithImpl<ChatInviteResponse>(this as ChatInviteResponse, _$identity);

  /// Serializes this ChatInviteResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInviteResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.respondedAtUtc, respondedAtUtc) || other.respondedAtUtc == respondedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,email,status,createdAtUtc,expiresAtUtc,respondedAtUtc);

@override
String toString() {
  return 'ChatInviteResponse(id: $id, conversationId: $conversationId, email: $email, status: $status, createdAtUtc: $createdAtUtc, expiresAtUtc: $expiresAtUtc, respondedAtUtc: $respondedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatInviteResponseCopyWith<$Res>  {
  factory $ChatInviteResponseCopyWith(ChatInviteResponse value, $Res Function(ChatInviteResponse) _then) = _$ChatInviteResponseCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String email, ChatInvitationStatus status, DateTime createdAtUtc, DateTime expiresAtUtc, DateTime? respondedAtUtc
});




}
/// @nodoc
class _$ChatInviteResponseCopyWithImpl<$Res>
    implements $ChatInviteResponseCopyWith<$Res> {
  _$ChatInviteResponseCopyWithImpl(this._self, this._then);

  final ChatInviteResponse _self;
  final $Res Function(ChatInviteResponse) _then;

/// Create a copy of ChatInviteResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? email = null,Object? status = null,Object? createdAtUtc = null,Object? expiresAtUtc = null,Object? respondedAtUtc = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChatInvitationStatus,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAtUtc: freezed == respondedAtUtc ? _self.respondedAtUtc : respondedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatInviteResponse].
extension ChatInviteResponsePatterns on ChatInviteResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInviteResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInviteResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInviteResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatInviteResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInviteResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInviteResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String email,  ChatInvitationStatus status,  DateTime createdAtUtc,  DateTime expiresAtUtc,  DateTime? respondedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInviteResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.email,_that.status,_that.createdAtUtc,_that.expiresAtUtc,_that.respondedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String email,  ChatInvitationStatus status,  DateTime createdAtUtc,  DateTime expiresAtUtc,  DateTime? respondedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatInviteResponse():
return $default(_that.id,_that.conversationId,_that.email,_that.status,_that.createdAtUtc,_that.expiresAtUtc,_that.respondedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String email,  ChatInvitationStatus status,  DateTime createdAtUtc,  DateTime expiresAtUtc,  DateTime? respondedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatInviteResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.email,_that.status,_that.createdAtUtc,_that.expiresAtUtc,_that.respondedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatInviteResponse implements ChatInviteResponse {
  const _ChatInviteResponse({required this.id, required this.conversationId, required this.email, required this.status, required this.createdAtUtc, required this.expiresAtUtc, this.respondedAtUtc});
  factory _ChatInviteResponse.fromJson(Map<String, dynamic> json) => _$ChatInviteResponseFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String email;
@override final  ChatInvitationStatus status;
@override final  DateTime createdAtUtc;
@override final  DateTime expiresAtUtc;
@override final  DateTime? respondedAtUtc;

/// Create a copy of ChatInviteResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInviteResponseCopyWith<_ChatInviteResponse> get copyWith => __$ChatInviteResponseCopyWithImpl<_ChatInviteResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatInviteResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInviteResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.respondedAtUtc, respondedAtUtc) || other.respondedAtUtc == respondedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,email,status,createdAtUtc,expiresAtUtc,respondedAtUtc);

@override
String toString() {
  return 'ChatInviteResponse(id: $id, conversationId: $conversationId, email: $email, status: $status, createdAtUtc: $createdAtUtc, expiresAtUtc: $expiresAtUtc, respondedAtUtc: $respondedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatInviteResponseCopyWith<$Res> implements $ChatInviteResponseCopyWith<$Res> {
  factory _$ChatInviteResponseCopyWith(_ChatInviteResponse value, $Res Function(_ChatInviteResponse) _then) = __$ChatInviteResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String email, ChatInvitationStatus status, DateTime createdAtUtc, DateTime expiresAtUtc, DateTime? respondedAtUtc
});




}
/// @nodoc
class __$ChatInviteResponseCopyWithImpl<$Res>
    implements _$ChatInviteResponseCopyWith<$Res> {
  __$ChatInviteResponseCopyWithImpl(this._self, this._then);

  final _ChatInviteResponse _self;
  final $Res Function(_ChatInviteResponse) _then;

/// Create a copy of ChatInviteResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? email = null,Object? status = null,Object? createdAtUtc = null,Object? expiresAtUtc = null,Object? respondedAtUtc = freezed,}) {
  return _then(_ChatInviteResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChatInvitationStatus,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAtUtc: freezed == respondedAtUtc ? _self.respondedAtUtc : respondedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ChatBookmarkPayload {

 String? get note;
/// Create a copy of ChatBookmarkPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatBookmarkPayloadCopyWith<ChatBookmarkPayload> get copyWith => _$ChatBookmarkPayloadCopyWithImpl<ChatBookmarkPayload>(this as ChatBookmarkPayload, _$identity);

  /// Serializes this ChatBookmarkPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatBookmarkPayload&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,note);

@override
String toString() {
  return 'ChatBookmarkPayload(note: $note)';
}


}

/// @nodoc
abstract mixin class $ChatBookmarkPayloadCopyWith<$Res>  {
  factory $ChatBookmarkPayloadCopyWith(ChatBookmarkPayload value, $Res Function(ChatBookmarkPayload) _then) = _$ChatBookmarkPayloadCopyWithImpl;
@useResult
$Res call({
 String? note
});




}
/// @nodoc
class _$ChatBookmarkPayloadCopyWithImpl<$Res>
    implements $ChatBookmarkPayloadCopyWith<$Res> {
  _$ChatBookmarkPayloadCopyWithImpl(this._self, this._then);

  final ChatBookmarkPayload _self;
  final $Res Function(ChatBookmarkPayload) _then;

/// Create a copy of ChatBookmarkPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? note = freezed,}) {
  return _then(_self.copyWith(
note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatBookmarkPayload].
extension ChatBookmarkPayloadPatterns on ChatBookmarkPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatBookmarkPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatBookmarkPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatBookmarkPayload value)  $default,){
final _that = this;
switch (_that) {
case _ChatBookmarkPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatBookmarkPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ChatBookmarkPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatBookmarkPayload() when $default != null:
return $default(_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? note)  $default,) {final _that = this;
switch (_that) {
case _ChatBookmarkPayload():
return $default(_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? note)?  $default,) {final _that = this;
switch (_that) {
case _ChatBookmarkPayload() when $default != null:
return $default(_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatBookmarkPayload implements ChatBookmarkPayload {
  const _ChatBookmarkPayload({this.note});
  factory _ChatBookmarkPayload.fromJson(Map<String, dynamic> json) => _$ChatBookmarkPayloadFromJson(json);

@override final  String? note;

/// Create a copy of ChatBookmarkPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatBookmarkPayloadCopyWith<_ChatBookmarkPayload> get copyWith => __$ChatBookmarkPayloadCopyWithImpl<_ChatBookmarkPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatBookmarkPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatBookmarkPayload&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,note);

@override
String toString() {
  return 'ChatBookmarkPayload(note: $note)';
}


}

/// @nodoc
abstract mixin class _$ChatBookmarkPayloadCopyWith<$Res> implements $ChatBookmarkPayloadCopyWith<$Res> {
  factory _$ChatBookmarkPayloadCopyWith(_ChatBookmarkPayload value, $Res Function(_ChatBookmarkPayload) _then) = __$ChatBookmarkPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? note
});




}
/// @nodoc
class __$ChatBookmarkPayloadCopyWithImpl<$Res>
    implements _$ChatBookmarkPayloadCopyWith<$Res> {
  __$ChatBookmarkPayloadCopyWithImpl(this._self, this._then);

  final _ChatBookmarkPayload _self;
  final $Res Function(_ChatBookmarkPayload) _then;

/// Create a copy of ChatBookmarkPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? note = freezed,}) {
  return _then(_ChatBookmarkPayload(
note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChatBookmarkResponse {

 String get id; String get messageId; String get conversationId; String get userId; String? get note; DateTime get createdAtUtc;
/// Create a copy of ChatBookmarkResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatBookmarkResponseCopyWith<ChatBookmarkResponse> get copyWith => _$ChatBookmarkResponseCopyWithImpl<ChatBookmarkResponse>(this as ChatBookmarkResponse, _$identity);

  /// Serializes this ChatBookmarkResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatBookmarkResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,conversationId,userId,note,createdAtUtc);

@override
String toString() {
  return 'ChatBookmarkResponse(id: $id, messageId: $messageId, conversationId: $conversationId, userId: $userId, note: $note, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatBookmarkResponseCopyWith<$Res>  {
  factory $ChatBookmarkResponseCopyWith(ChatBookmarkResponse value, $Res Function(ChatBookmarkResponse) _then) = _$ChatBookmarkResponseCopyWithImpl;
@useResult
$Res call({
 String id, String messageId, String conversationId, String userId, String? note, DateTime createdAtUtc
});




}
/// @nodoc
class _$ChatBookmarkResponseCopyWithImpl<$Res>
    implements $ChatBookmarkResponseCopyWith<$Res> {
  _$ChatBookmarkResponseCopyWithImpl(this._self, this._then);

  final ChatBookmarkResponse _self;
  final $Res Function(ChatBookmarkResponse) _then;

/// Create a copy of ChatBookmarkResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messageId = null,Object? conversationId = null,Object? userId = null,Object? note = freezed,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatBookmarkResponse].
extension ChatBookmarkResponsePatterns on ChatBookmarkResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatBookmarkResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatBookmarkResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatBookmarkResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatBookmarkResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatBookmarkResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatBookmarkResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messageId,  String conversationId,  String userId,  String? note,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatBookmarkResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.conversationId,_that.userId,_that.note,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messageId,  String conversationId,  String userId,  String? note,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatBookmarkResponse():
return $default(_that.id,_that.messageId,_that.conversationId,_that.userId,_that.note,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messageId,  String conversationId,  String userId,  String? note,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatBookmarkResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.conversationId,_that.userId,_that.note,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatBookmarkResponse implements ChatBookmarkResponse {
  const _ChatBookmarkResponse({required this.id, required this.messageId, required this.conversationId, required this.userId, this.note, required this.createdAtUtc});
  factory _ChatBookmarkResponse.fromJson(Map<String, dynamic> json) => _$ChatBookmarkResponseFromJson(json);

@override final  String id;
@override final  String messageId;
@override final  String conversationId;
@override final  String userId;
@override final  String? note;
@override final  DateTime createdAtUtc;

/// Create a copy of ChatBookmarkResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatBookmarkResponseCopyWith<_ChatBookmarkResponse> get copyWith => __$ChatBookmarkResponseCopyWithImpl<_ChatBookmarkResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatBookmarkResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatBookmarkResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,conversationId,userId,note,createdAtUtc);

@override
String toString() {
  return 'ChatBookmarkResponse(id: $id, messageId: $messageId, conversationId: $conversationId, userId: $userId, note: $note, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatBookmarkResponseCopyWith<$Res> implements $ChatBookmarkResponseCopyWith<$Res> {
  factory _$ChatBookmarkResponseCopyWith(_ChatBookmarkResponse value, $Res Function(_ChatBookmarkResponse) _then) = __$ChatBookmarkResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String messageId, String conversationId, String userId, String? note, DateTime createdAtUtc
});




}
/// @nodoc
class __$ChatBookmarkResponseCopyWithImpl<$Res>
    implements _$ChatBookmarkResponseCopyWith<$Res> {
  __$ChatBookmarkResponseCopyWithImpl(this._self, this._then);

  final _ChatBookmarkResponse _self;
  final $Res Function(_ChatBookmarkResponse) _then;

/// Create a copy of ChatBookmarkResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messageId = null,Object? conversationId = null,Object? userId = null,Object? note = freezed,Object? createdAtUtc = null,}) {
  return _then(_ChatBookmarkResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatPinnedMessageResponse {

 String get id; String get conversationId; String get messageId; String get pinnedByUserId; DateTime get pinnedAtUtc;
/// Create a copy of ChatPinnedMessageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatPinnedMessageResponseCopyWith<ChatPinnedMessageResponse> get copyWith => _$ChatPinnedMessageResponseCopyWithImpl<ChatPinnedMessageResponse>(this as ChatPinnedMessageResponse, _$identity);

  /// Serializes this ChatPinnedMessageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatPinnedMessageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.pinnedByUserId, pinnedByUserId) || other.pinnedByUserId == pinnedByUserId)&&(identical(other.pinnedAtUtc, pinnedAtUtc) || other.pinnedAtUtc == pinnedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,messageId,pinnedByUserId,pinnedAtUtc);

@override
String toString() {
  return 'ChatPinnedMessageResponse(id: $id, conversationId: $conversationId, messageId: $messageId, pinnedByUserId: $pinnedByUserId, pinnedAtUtc: $pinnedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatPinnedMessageResponseCopyWith<$Res>  {
  factory $ChatPinnedMessageResponseCopyWith(ChatPinnedMessageResponse value, $Res Function(ChatPinnedMessageResponse) _then) = _$ChatPinnedMessageResponseCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String messageId, String pinnedByUserId, DateTime pinnedAtUtc
});




}
/// @nodoc
class _$ChatPinnedMessageResponseCopyWithImpl<$Res>
    implements $ChatPinnedMessageResponseCopyWith<$Res> {
  _$ChatPinnedMessageResponseCopyWithImpl(this._self, this._then);

  final ChatPinnedMessageResponse _self;
  final $Res Function(ChatPinnedMessageResponse) _then;

/// Create a copy of ChatPinnedMessageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? messageId = null,Object? pinnedByUserId = null,Object? pinnedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,pinnedByUserId: null == pinnedByUserId ? _self.pinnedByUserId : pinnedByUserId // ignore: cast_nullable_to_non_nullable
as String,pinnedAtUtc: null == pinnedAtUtc ? _self.pinnedAtUtc : pinnedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatPinnedMessageResponse].
extension ChatPinnedMessageResponsePatterns on ChatPinnedMessageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatPinnedMessageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatPinnedMessageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatPinnedMessageResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatPinnedMessageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatPinnedMessageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatPinnedMessageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String messageId,  String pinnedByUserId,  DateTime pinnedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatPinnedMessageResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.messageId,_that.pinnedByUserId,_that.pinnedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String messageId,  String pinnedByUserId,  DateTime pinnedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatPinnedMessageResponse():
return $default(_that.id,_that.conversationId,_that.messageId,_that.pinnedByUserId,_that.pinnedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String messageId,  String pinnedByUserId,  DateTime pinnedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatPinnedMessageResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.messageId,_that.pinnedByUserId,_that.pinnedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatPinnedMessageResponse implements ChatPinnedMessageResponse {
  const _ChatPinnedMessageResponse({required this.id, required this.conversationId, required this.messageId, required this.pinnedByUserId, required this.pinnedAtUtc});
  factory _ChatPinnedMessageResponse.fromJson(Map<String, dynamic> json) => _$ChatPinnedMessageResponseFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String messageId;
@override final  String pinnedByUserId;
@override final  DateTime pinnedAtUtc;

/// Create a copy of ChatPinnedMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatPinnedMessageResponseCopyWith<_ChatPinnedMessageResponse> get copyWith => __$ChatPinnedMessageResponseCopyWithImpl<_ChatPinnedMessageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatPinnedMessageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatPinnedMessageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.pinnedByUserId, pinnedByUserId) || other.pinnedByUserId == pinnedByUserId)&&(identical(other.pinnedAtUtc, pinnedAtUtc) || other.pinnedAtUtc == pinnedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,messageId,pinnedByUserId,pinnedAtUtc);

@override
String toString() {
  return 'ChatPinnedMessageResponse(id: $id, conversationId: $conversationId, messageId: $messageId, pinnedByUserId: $pinnedByUserId, pinnedAtUtc: $pinnedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatPinnedMessageResponseCopyWith<$Res> implements $ChatPinnedMessageResponseCopyWith<$Res> {
  factory _$ChatPinnedMessageResponseCopyWith(_ChatPinnedMessageResponse value, $Res Function(_ChatPinnedMessageResponse) _then) = __$ChatPinnedMessageResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String messageId, String pinnedByUserId, DateTime pinnedAtUtc
});




}
/// @nodoc
class __$ChatPinnedMessageResponseCopyWithImpl<$Res>
    implements _$ChatPinnedMessageResponseCopyWith<$Res> {
  __$ChatPinnedMessageResponseCopyWithImpl(this._self, this._then);

  final _ChatPinnedMessageResponse _self;
  final $Res Function(_ChatPinnedMessageResponse) _then;

/// Create a copy of ChatPinnedMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? messageId = null,Object? pinnedByUserId = null,Object? pinnedAtUtc = null,}) {
  return _then(_ChatPinnedMessageResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,pinnedByUserId: null == pinnedByUserId ? _self.pinnedByUserId : pinnedByUserId // ignore: cast_nullable_to_non_nullable
as String,pinnedAtUtc: null == pinnedAtUtc ? _self.pinnedAtUtc : pinnedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CreateChatInvitePayload {

 String get email; int get ttlHours;
/// Create a copy of CreateChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateChatInvitePayloadCopyWith<CreateChatInvitePayload> get copyWith => _$CreateChatInvitePayloadCopyWithImpl<CreateChatInvitePayload>(this as CreateChatInvitePayload, _$identity);

  /// Serializes this CreateChatInvitePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateChatInvitePayload&&(identical(other.email, email) || other.email == email)&&(identical(other.ttlHours, ttlHours) || other.ttlHours == ttlHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,ttlHours);

@override
String toString() {
  return 'CreateChatInvitePayload(email: $email, ttlHours: $ttlHours)';
}


}

/// @nodoc
abstract mixin class $CreateChatInvitePayloadCopyWith<$Res>  {
  factory $CreateChatInvitePayloadCopyWith(CreateChatInvitePayload value, $Res Function(CreateChatInvitePayload) _then) = _$CreateChatInvitePayloadCopyWithImpl;
@useResult
$Res call({
 String email, int ttlHours
});




}
/// @nodoc
class _$CreateChatInvitePayloadCopyWithImpl<$Res>
    implements $CreateChatInvitePayloadCopyWith<$Res> {
  _$CreateChatInvitePayloadCopyWithImpl(this._self, this._then);

  final CreateChatInvitePayload _self;
  final $Res Function(CreateChatInvitePayload) _then;

/// Create a copy of CreateChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? ttlHours = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,ttlHours: null == ttlHours ? _self.ttlHours : ttlHours // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateChatInvitePayload].
extension CreateChatInvitePayloadPatterns on CreateChatInvitePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateChatInvitePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateChatInvitePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateChatInvitePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateChatInvitePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateChatInvitePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateChatInvitePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  int ttlHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateChatInvitePayload() when $default != null:
return $default(_that.email,_that.ttlHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  int ttlHours)  $default,) {final _that = this;
switch (_that) {
case _CreateChatInvitePayload():
return $default(_that.email,_that.ttlHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  int ttlHours)?  $default,) {final _that = this;
switch (_that) {
case _CreateChatInvitePayload() when $default != null:
return $default(_that.email,_that.ttlHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateChatInvitePayload implements CreateChatInvitePayload {
  const _CreateChatInvitePayload({required this.email, this.ttlHours = 72});
  factory _CreateChatInvitePayload.fromJson(Map<String, dynamic> json) => _$CreateChatInvitePayloadFromJson(json);

@override final  String email;
@override@JsonKey() final  int ttlHours;

/// Create a copy of CreateChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateChatInvitePayloadCopyWith<_CreateChatInvitePayload> get copyWith => __$CreateChatInvitePayloadCopyWithImpl<_CreateChatInvitePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateChatInvitePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateChatInvitePayload&&(identical(other.email, email) || other.email == email)&&(identical(other.ttlHours, ttlHours) || other.ttlHours == ttlHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,ttlHours);

@override
String toString() {
  return 'CreateChatInvitePayload(email: $email, ttlHours: $ttlHours)';
}


}

/// @nodoc
abstract mixin class _$CreateChatInvitePayloadCopyWith<$Res> implements $CreateChatInvitePayloadCopyWith<$Res> {
  factory _$CreateChatInvitePayloadCopyWith(_CreateChatInvitePayload value, $Res Function(_CreateChatInvitePayload) _then) = __$CreateChatInvitePayloadCopyWithImpl;
@override @useResult
$Res call({
 String email, int ttlHours
});




}
/// @nodoc
class __$CreateChatInvitePayloadCopyWithImpl<$Res>
    implements _$CreateChatInvitePayloadCopyWith<$Res> {
  __$CreateChatInvitePayloadCopyWithImpl(this._self, this._then);

  final _CreateChatInvitePayload _self;
  final $Res Function(_CreateChatInvitePayload) _then;

/// Create a copy of CreateChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? ttlHours = null,}) {
  return _then(_CreateChatInvitePayload(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,ttlHours: null == ttlHours ? _self.ttlHours : ttlHours // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AcceptChatInvitePayload {

 String get token;
/// Create a copy of AcceptChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcceptChatInvitePayloadCopyWith<AcceptChatInvitePayload> get copyWith => _$AcceptChatInvitePayloadCopyWithImpl<AcceptChatInvitePayload>(this as AcceptChatInvitePayload, _$identity);

  /// Serializes this AcceptChatInvitePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcceptChatInvitePayload&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'AcceptChatInvitePayload(token: $token)';
}


}

/// @nodoc
abstract mixin class $AcceptChatInvitePayloadCopyWith<$Res>  {
  factory $AcceptChatInvitePayloadCopyWith(AcceptChatInvitePayload value, $Res Function(AcceptChatInvitePayload) _then) = _$AcceptChatInvitePayloadCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class _$AcceptChatInvitePayloadCopyWithImpl<$Res>
    implements $AcceptChatInvitePayloadCopyWith<$Res> {
  _$AcceptChatInvitePayloadCopyWithImpl(this._self, this._then);

  final AcceptChatInvitePayload _self;
  final $Res Function(AcceptChatInvitePayload) _then;

/// Create a copy of AcceptChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AcceptChatInvitePayload].
extension AcceptChatInvitePayloadPatterns on AcceptChatInvitePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcceptChatInvitePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcceptChatInvitePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcceptChatInvitePayload value)  $default,){
final _that = this;
switch (_that) {
case _AcceptChatInvitePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcceptChatInvitePayload value)?  $default,){
final _that = this;
switch (_that) {
case _AcceptChatInvitePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcceptChatInvitePayload() when $default != null:
return $default(_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token)  $default,) {final _that = this;
switch (_that) {
case _AcceptChatInvitePayload():
return $default(_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token)?  $default,) {final _that = this;
switch (_that) {
case _AcceptChatInvitePayload() when $default != null:
return $default(_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AcceptChatInvitePayload implements AcceptChatInvitePayload {
  const _AcceptChatInvitePayload({required this.token});
  factory _AcceptChatInvitePayload.fromJson(Map<String, dynamic> json) => _$AcceptChatInvitePayloadFromJson(json);

@override final  String token;

/// Create a copy of AcceptChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcceptChatInvitePayloadCopyWith<_AcceptChatInvitePayload> get copyWith => __$AcceptChatInvitePayloadCopyWithImpl<_AcceptChatInvitePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AcceptChatInvitePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcceptChatInvitePayload&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'AcceptChatInvitePayload(token: $token)';
}


}

/// @nodoc
abstract mixin class _$AcceptChatInvitePayloadCopyWith<$Res> implements $AcceptChatInvitePayloadCopyWith<$Res> {
  factory _$AcceptChatInvitePayloadCopyWith(_AcceptChatInvitePayload value, $Res Function(_AcceptChatInvitePayload) _then) = __$AcceptChatInvitePayloadCopyWithImpl;
@override @useResult
$Res call({
 String token
});




}
/// @nodoc
class __$AcceptChatInvitePayloadCopyWithImpl<$Res>
    implements _$AcceptChatInvitePayloadCopyWith<$Res> {
  __$AcceptChatInvitePayloadCopyWithImpl(this._self, this._then);

  final _AcceptChatInvitePayload _self;
  final $Res Function(_AcceptChatInvitePayload) _then;

/// Create a copy of AcceptChatInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(_AcceptChatInvitePayload(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpsertChatDraftPayload {

 String? get text; String? get deltaJson; String? get replyToMessageId; int get version; List<String>? get attachmentStorageFileIds;
/// Create a copy of UpsertChatDraftPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpsertChatDraftPayloadCopyWith<UpsertChatDraftPayload> get copyWith => _$UpsertChatDraftPayloadCopyWithImpl<UpsertChatDraftPayload>(this as UpsertChatDraftPayload, _$identity);

  /// Serializes this UpsertChatDraftPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpsertChatDraftPayload&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.attachmentStorageFileIds, attachmentStorageFileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,deltaJson,replyToMessageId,version,const DeepCollectionEquality().hash(attachmentStorageFileIds));

@override
String toString() {
  return 'UpsertChatDraftPayload(text: $text, deltaJson: $deltaJson, replyToMessageId: $replyToMessageId, version: $version, attachmentStorageFileIds: $attachmentStorageFileIds)';
}


}

/// @nodoc
abstract mixin class $UpsertChatDraftPayloadCopyWith<$Res>  {
  factory $UpsertChatDraftPayloadCopyWith(UpsertChatDraftPayload value, $Res Function(UpsertChatDraftPayload) _then) = _$UpsertChatDraftPayloadCopyWithImpl;
@useResult
$Res call({
 String? text, String? deltaJson, String? replyToMessageId, int version, List<String>? attachmentStorageFileIds
});




}
/// @nodoc
class _$UpsertChatDraftPayloadCopyWithImpl<$Res>
    implements $UpsertChatDraftPayloadCopyWith<$Res> {
  _$UpsertChatDraftPayloadCopyWithImpl(this._self, this._then);

  final UpsertChatDraftPayload _self;
  final $Res Function(UpsertChatDraftPayload) _then;

/// Create a copy of UpsertChatDraftPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = freezed,Object? deltaJson = freezed,Object? replyToMessageId = freezed,Object? version = null,Object? attachmentStorageFileIds = freezed,}) {
  return _then(_self.copyWith(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,attachmentStorageFileIds: freezed == attachmentStorageFileIds ? _self.attachmentStorageFileIds : attachmentStorageFileIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpsertChatDraftPayload].
extension UpsertChatDraftPayloadPatterns on UpsertChatDraftPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpsertChatDraftPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpsertChatDraftPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpsertChatDraftPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpsertChatDraftPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpsertChatDraftPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpsertChatDraftPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? text,  String? deltaJson,  String? replyToMessageId,  int version,  List<String>? attachmentStorageFileIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpsertChatDraftPayload() when $default != null:
return $default(_that.text,_that.deltaJson,_that.replyToMessageId,_that.version,_that.attachmentStorageFileIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? text,  String? deltaJson,  String? replyToMessageId,  int version,  List<String>? attachmentStorageFileIds)  $default,) {final _that = this;
switch (_that) {
case _UpsertChatDraftPayload():
return $default(_that.text,_that.deltaJson,_that.replyToMessageId,_that.version,_that.attachmentStorageFileIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? text,  String? deltaJson,  String? replyToMessageId,  int version,  List<String>? attachmentStorageFileIds)?  $default,) {final _that = this;
switch (_that) {
case _UpsertChatDraftPayload() when $default != null:
return $default(_that.text,_that.deltaJson,_that.replyToMessageId,_that.version,_that.attachmentStorageFileIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpsertChatDraftPayload implements UpsertChatDraftPayload {
  const _UpsertChatDraftPayload({this.text, this.deltaJson, this.replyToMessageId, this.version = 0, this.attachmentStorageFileIds});
  factory _UpsertChatDraftPayload.fromJson(Map<String, dynamic> json) => _$UpsertChatDraftPayloadFromJson(json);

@override final  String? text;
@override final  String? deltaJson;
@override final  String? replyToMessageId;
@override@JsonKey() final  int version;
@override final  List<String>? attachmentStorageFileIds;

/// Create a copy of UpsertChatDraftPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpsertChatDraftPayloadCopyWith<_UpsertChatDraftPayload> get copyWith => __$UpsertChatDraftPayloadCopyWithImpl<_UpsertChatDraftPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpsertChatDraftPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpsertChatDraftPayload&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.attachmentStorageFileIds, attachmentStorageFileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,deltaJson,replyToMessageId,version,const DeepCollectionEquality().hash(attachmentStorageFileIds));

@override
String toString() {
  return 'UpsertChatDraftPayload(text: $text, deltaJson: $deltaJson, replyToMessageId: $replyToMessageId, version: $version, attachmentStorageFileIds: $attachmentStorageFileIds)';
}


}

/// @nodoc
abstract mixin class _$UpsertChatDraftPayloadCopyWith<$Res> implements $UpsertChatDraftPayloadCopyWith<$Res> {
  factory _$UpsertChatDraftPayloadCopyWith(_UpsertChatDraftPayload value, $Res Function(_UpsertChatDraftPayload) _then) = __$UpsertChatDraftPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? text, String? deltaJson, String? replyToMessageId, int version, List<String>? attachmentStorageFileIds
});




}
/// @nodoc
class __$UpsertChatDraftPayloadCopyWithImpl<$Res>
    implements _$UpsertChatDraftPayloadCopyWith<$Res> {
  __$UpsertChatDraftPayloadCopyWithImpl(this._self, this._then);

  final _UpsertChatDraftPayload _self;
  final $Res Function(_UpsertChatDraftPayload) _then;

/// Create a copy of UpsertChatDraftPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = freezed,Object? deltaJson = freezed,Object? replyToMessageId = freezed,Object? version = null,Object? attachmentStorageFileIds = freezed,}) {
  return _then(_UpsertChatDraftPayload(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,attachmentStorageFileIds: freezed == attachmentStorageFileIds ? _self.attachmentStorageFileIds : attachmentStorageFileIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$ChatDraftResponse {

 String get id; String get conversationId; String? get text; String? get deltaJson; String? get replyToMessageId; int get version; DateTime get updatedAtUtc; List<ChatDraftAttachmentResponse>? get attachments;
/// Create a copy of ChatDraftResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDraftResponseCopyWith<ChatDraftResponse> get copyWith => _$ChatDraftResponseCopyWithImpl<ChatDraftResponse>(this as ChatDraftResponse, _$identity);

  /// Serializes this ChatDraftResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDraftResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&const DeepCollectionEquality().equals(other.attachments, attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,text,deltaJson,replyToMessageId,version,updatedAtUtc,const DeepCollectionEquality().hash(attachments));

@override
String toString() {
  return 'ChatDraftResponse(id: $id, conversationId: $conversationId, text: $text, deltaJson: $deltaJson, replyToMessageId: $replyToMessageId, version: $version, updatedAtUtc: $updatedAtUtc, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class $ChatDraftResponseCopyWith<$Res>  {
  factory $ChatDraftResponseCopyWith(ChatDraftResponse value, $Res Function(ChatDraftResponse) _then) = _$ChatDraftResponseCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String? text, String? deltaJson, String? replyToMessageId, int version, DateTime updatedAtUtc, List<ChatDraftAttachmentResponse>? attachments
});




}
/// @nodoc
class _$ChatDraftResponseCopyWithImpl<$Res>
    implements $ChatDraftResponseCopyWith<$Res> {
  _$ChatDraftResponseCopyWithImpl(this._self, this._then);

  final ChatDraftResponse _self;
  final $Res Function(ChatDraftResponse) _then;

/// Create a copy of ChatDraftResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? text = freezed,Object? deltaJson = freezed,Object? replyToMessageId = freezed,Object? version = null,Object? updatedAtUtc = null,Object? attachments = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,attachments: freezed == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ChatDraftAttachmentResponse>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatDraftResponse].
extension ChatDraftResponsePatterns on ChatDraftResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatDraftResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatDraftResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatDraftResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatDraftResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatDraftResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatDraftResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String? text,  String? deltaJson,  String? replyToMessageId,  int version,  DateTime updatedAtUtc,  List<ChatDraftAttachmentResponse>? attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatDraftResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.version,_that.updatedAtUtc,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String? text,  String? deltaJson,  String? replyToMessageId,  int version,  DateTime updatedAtUtc,  List<ChatDraftAttachmentResponse>? attachments)  $default,) {final _that = this;
switch (_that) {
case _ChatDraftResponse():
return $default(_that.id,_that.conversationId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.version,_that.updatedAtUtc,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String? text,  String? deltaJson,  String? replyToMessageId,  int version,  DateTime updatedAtUtc,  List<ChatDraftAttachmentResponse>? attachments)?  $default,) {final _that = this;
switch (_that) {
case _ChatDraftResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.version,_that.updatedAtUtc,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatDraftResponse implements ChatDraftResponse {
  const _ChatDraftResponse({required this.id, required this.conversationId, this.text, this.deltaJson, this.replyToMessageId, required this.version, required this.updatedAtUtc, this.attachments});
  factory _ChatDraftResponse.fromJson(Map<String, dynamic> json) => _$ChatDraftResponseFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String? text;
@override final  String? deltaJson;
@override final  String? replyToMessageId;
@override final  int version;
@override final  DateTime updatedAtUtc;
@override final  List<ChatDraftAttachmentResponse>? attachments;

/// Create a copy of ChatDraftResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatDraftResponseCopyWith<_ChatDraftResponse> get copyWith => __$ChatDraftResponseCopyWithImpl<_ChatDraftResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatDraftResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatDraftResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&const DeepCollectionEquality().equals(other.attachments, attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,text,deltaJson,replyToMessageId,version,updatedAtUtc,const DeepCollectionEquality().hash(attachments));

@override
String toString() {
  return 'ChatDraftResponse(id: $id, conversationId: $conversationId, text: $text, deltaJson: $deltaJson, replyToMessageId: $replyToMessageId, version: $version, updatedAtUtc: $updatedAtUtc, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$ChatDraftResponseCopyWith<$Res> implements $ChatDraftResponseCopyWith<$Res> {
  factory _$ChatDraftResponseCopyWith(_ChatDraftResponse value, $Res Function(_ChatDraftResponse) _then) = __$ChatDraftResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String? text, String? deltaJson, String? replyToMessageId, int version, DateTime updatedAtUtc, List<ChatDraftAttachmentResponse>? attachments
});




}
/// @nodoc
class __$ChatDraftResponseCopyWithImpl<$Res>
    implements _$ChatDraftResponseCopyWith<$Res> {
  __$ChatDraftResponseCopyWithImpl(this._self, this._then);

  final _ChatDraftResponse _self;
  final $Res Function(_ChatDraftResponse) _then;

/// Create a copy of ChatDraftResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? text = freezed,Object? deltaJson = freezed,Object? replyToMessageId = freezed,Object? version = null,Object? updatedAtUtc = null,Object? attachments = freezed,}) {
  return _then(_ChatDraftResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,deltaJson: freezed == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String?,replyToMessageId: freezed == replyToMessageId ? _self.replyToMessageId : replyToMessageId // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,attachments: freezed == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ChatDraftAttachmentResponse>?,
  ));
}


}


/// @nodoc
mixin _$ChatDraftAttachmentResponse {

 String get id; String get storageFileId; int get position; DateTime get createdAtUtc;
/// Create a copy of ChatDraftAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDraftAttachmentResponseCopyWith<ChatDraftAttachmentResponse> get copyWith => _$ChatDraftAttachmentResponseCopyWithImpl<ChatDraftAttachmentResponse>(this as ChatDraftAttachmentResponse, _$identity);

  /// Serializes this ChatDraftAttachmentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDraftAttachmentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storageFileId,position,createdAtUtc);

@override
String toString() {
  return 'ChatDraftAttachmentResponse(id: $id, storageFileId: $storageFileId, position: $position, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatDraftAttachmentResponseCopyWith<$Res>  {
  factory $ChatDraftAttachmentResponseCopyWith(ChatDraftAttachmentResponse value, $Res Function(ChatDraftAttachmentResponse) _then) = _$ChatDraftAttachmentResponseCopyWithImpl;
@useResult
$Res call({
 String id, String storageFileId, int position, DateTime createdAtUtc
});




}
/// @nodoc
class _$ChatDraftAttachmentResponseCopyWithImpl<$Res>
    implements $ChatDraftAttachmentResponseCopyWith<$Res> {
  _$ChatDraftAttachmentResponseCopyWithImpl(this._self, this._then);

  final ChatDraftAttachmentResponse _self;
  final $Res Function(ChatDraftAttachmentResponse) _then;

/// Create a copy of ChatDraftAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storageFileId = null,Object? position = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatDraftAttachmentResponse].
extension ChatDraftAttachmentResponsePatterns on ChatDraftAttachmentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatDraftAttachmentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatDraftAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatDraftAttachmentResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatDraftAttachmentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatDraftAttachmentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatDraftAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storageFileId,  int position,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatDraftAttachmentResponse() when $default != null:
return $default(_that.id,_that.storageFileId,_that.position,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storageFileId,  int position,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatDraftAttachmentResponse():
return $default(_that.id,_that.storageFileId,_that.position,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storageFileId,  int position,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatDraftAttachmentResponse() when $default != null:
return $default(_that.id,_that.storageFileId,_that.position,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatDraftAttachmentResponse implements ChatDraftAttachmentResponse {
  const _ChatDraftAttachmentResponse({required this.id, required this.storageFileId, required this.position, required this.createdAtUtc});
  factory _ChatDraftAttachmentResponse.fromJson(Map<String, dynamic> json) => _$ChatDraftAttachmentResponseFromJson(json);

@override final  String id;
@override final  String storageFileId;
@override final  int position;
@override final  DateTime createdAtUtc;

/// Create a copy of ChatDraftAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatDraftAttachmentResponseCopyWith<_ChatDraftAttachmentResponse> get copyWith => __$ChatDraftAttachmentResponseCopyWithImpl<_ChatDraftAttachmentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatDraftAttachmentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatDraftAttachmentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storageFileId,position,createdAtUtc);

@override
String toString() {
  return 'ChatDraftAttachmentResponse(id: $id, storageFileId: $storageFileId, position: $position, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatDraftAttachmentResponseCopyWith<$Res> implements $ChatDraftAttachmentResponseCopyWith<$Res> {
  factory _$ChatDraftAttachmentResponseCopyWith(_ChatDraftAttachmentResponse value, $Res Function(_ChatDraftAttachmentResponse) _then) = __$ChatDraftAttachmentResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String storageFileId, int position, DateTime createdAtUtc
});




}
/// @nodoc
class __$ChatDraftAttachmentResponseCopyWithImpl<$Res>
    implements _$ChatDraftAttachmentResponseCopyWith<$Res> {
  __$ChatDraftAttachmentResponseCopyWithImpl(this._self, this._then);

  final _ChatDraftAttachmentResponse _self;
  final $Res Function(_ChatDraftAttachmentResponse) _then;

/// Create a copy of ChatDraftAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storageFileId = null,Object? position = null,Object? createdAtUtc = null,}) {
  return _then(_ChatDraftAttachmentResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatContextResponse {

 String get conversationId; String get summary; int get compactedMessageCount; int get participantCount; DateTime? get earliestMessageAtUtc; DateTime? get latestMessageAtUtc; List<ChatMessageResponse> get recentMessages; DateTime get generatedAtUtc;
/// Create a copy of ChatContextResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatContextResponseCopyWith<ChatContextResponse> get copyWith => _$ChatContextResponseCopyWithImpl<ChatContextResponse>(this as ChatContextResponse, _$identity);

  /// Serializes this ChatContextResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatContextResponse&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.compactedMessageCount, compactedMessageCount) || other.compactedMessageCount == compactedMessageCount)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.earliestMessageAtUtc, earliestMessageAtUtc) || other.earliestMessageAtUtc == earliestMessageAtUtc)&&(identical(other.latestMessageAtUtc, latestMessageAtUtc) || other.latestMessageAtUtc == latestMessageAtUtc)&&const DeepCollectionEquality().equals(other.recentMessages, recentMessages)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,summary,compactedMessageCount,participantCount,earliestMessageAtUtc,latestMessageAtUtc,const DeepCollectionEquality().hash(recentMessages),generatedAtUtc);

@override
String toString() {
  return 'ChatContextResponse(conversationId: $conversationId, summary: $summary, compactedMessageCount: $compactedMessageCount, participantCount: $participantCount, earliestMessageAtUtc: $earliestMessageAtUtc, latestMessageAtUtc: $latestMessageAtUtc, recentMessages: $recentMessages, generatedAtUtc: $generatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatContextResponseCopyWith<$Res>  {
  factory $ChatContextResponseCopyWith(ChatContextResponse value, $Res Function(ChatContextResponse) _then) = _$ChatContextResponseCopyWithImpl;
@useResult
$Res call({
 String conversationId, String summary, int compactedMessageCount, int participantCount, DateTime? earliestMessageAtUtc, DateTime? latestMessageAtUtc, List<ChatMessageResponse> recentMessages, DateTime generatedAtUtc
});




}
/// @nodoc
class _$ChatContextResponseCopyWithImpl<$Res>
    implements $ChatContextResponseCopyWith<$Res> {
  _$ChatContextResponseCopyWithImpl(this._self, this._then);

  final ChatContextResponse _self;
  final $Res Function(ChatContextResponse) _then;

/// Create a copy of ChatContextResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? summary = null,Object? compactedMessageCount = null,Object? participantCount = null,Object? earliestMessageAtUtc = freezed,Object? latestMessageAtUtc = freezed,Object? recentMessages = null,Object? generatedAtUtc = null,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,compactedMessageCount: null == compactedMessageCount ? _self.compactedMessageCount : compactedMessageCount // ignore: cast_nullable_to_non_nullable
as int,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,earliestMessageAtUtc: freezed == earliestMessageAtUtc ? _self.earliestMessageAtUtc : earliestMessageAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,latestMessageAtUtc: freezed == latestMessageAtUtc ? _self.latestMessageAtUtc : latestMessageAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,recentMessages: null == recentMessages ? _self.recentMessages : recentMessages // ignore: cast_nullable_to_non_nullable
as List<ChatMessageResponse>,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatContextResponse].
extension ChatContextResponsePatterns on ChatContextResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatContextResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatContextResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatContextResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatContextResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatContextResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatContextResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String conversationId,  String summary,  int compactedMessageCount,  int participantCount,  DateTime? earliestMessageAtUtc,  DateTime? latestMessageAtUtc,  List<ChatMessageResponse> recentMessages,  DateTime generatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatContextResponse() when $default != null:
return $default(_that.conversationId,_that.summary,_that.compactedMessageCount,_that.participantCount,_that.earliestMessageAtUtc,_that.latestMessageAtUtc,_that.recentMessages,_that.generatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String conversationId,  String summary,  int compactedMessageCount,  int participantCount,  DateTime? earliestMessageAtUtc,  DateTime? latestMessageAtUtc,  List<ChatMessageResponse> recentMessages,  DateTime generatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatContextResponse():
return $default(_that.conversationId,_that.summary,_that.compactedMessageCount,_that.participantCount,_that.earliestMessageAtUtc,_that.latestMessageAtUtc,_that.recentMessages,_that.generatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String conversationId,  String summary,  int compactedMessageCount,  int participantCount,  DateTime? earliestMessageAtUtc,  DateTime? latestMessageAtUtc,  List<ChatMessageResponse> recentMessages,  DateTime generatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatContextResponse() when $default != null:
return $default(_that.conversationId,_that.summary,_that.compactedMessageCount,_that.participantCount,_that.earliestMessageAtUtc,_that.latestMessageAtUtc,_that.recentMessages,_that.generatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatContextResponse implements ChatContextResponse {
  const _ChatContextResponse({required this.conversationId, required this.summary, required this.compactedMessageCount, required this.participantCount, this.earliestMessageAtUtc, this.latestMessageAtUtc, required this.recentMessages, required this.generatedAtUtc});
  factory _ChatContextResponse.fromJson(Map<String, dynamic> json) => _$ChatContextResponseFromJson(json);

@override final  String conversationId;
@override final  String summary;
@override final  int compactedMessageCount;
@override final  int participantCount;
@override final  DateTime? earliestMessageAtUtc;
@override final  DateTime? latestMessageAtUtc;
@override final  List<ChatMessageResponse> recentMessages;
@override final  DateTime generatedAtUtc;

/// Create a copy of ChatContextResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatContextResponseCopyWith<_ChatContextResponse> get copyWith => __$ChatContextResponseCopyWithImpl<_ChatContextResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatContextResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatContextResponse&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.compactedMessageCount, compactedMessageCount) || other.compactedMessageCount == compactedMessageCount)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.earliestMessageAtUtc, earliestMessageAtUtc) || other.earliestMessageAtUtc == earliestMessageAtUtc)&&(identical(other.latestMessageAtUtc, latestMessageAtUtc) || other.latestMessageAtUtc == latestMessageAtUtc)&&const DeepCollectionEquality().equals(other.recentMessages, recentMessages)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,summary,compactedMessageCount,participantCount,earliestMessageAtUtc,latestMessageAtUtc,const DeepCollectionEquality().hash(recentMessages),generatedAtUtc);

@override
String toString() {
  return 'ChatContextResponse(conversationId: $conversationId, summary: $summary, compactedMessageCount: $compactedMessageCount, participantCount: $participantCount, earliestMessageAtUtc: $earliestMessageAtUtc, latestMessageAtUtc: $latestMessageAtUtc, recentMessages: $recentMessages, generatedAtUtc: $generatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatContextResponseCopyWith<$Res> implements $ChatContextResponseCopyWith<$Res> {
  factory _$ChatContextResponseCopyWith(_ChatContextResponse value, $Res Function(_ChatContextResponse) _then) = __$ChatContextResponseCopyWithImpl;
@override @useResult
$Res call({
 String conversationId, String summary, int compactedMessageCount, int participantCount, DateTime? earliestMessageAtUtc, DateTime? latestMessageAtUtc, List<ChatMessageResponse> recentMessages, DateTime generatedAtUtc
});




}
/// @nodoc
class __$ChatContextResponseCopyWithImpl<$Res>
    implements _$ChatContextResponseCopyWith<$Res> {
  __$ChatContextResponseCopyWithImpl(this._self, this._then);

  final _ChatContextResponse _self;
  final $Res Function(_ChatContextResponse) _then;

/// Create a copy of ChatContextResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? summary = null,Object? compactedMessageCount = null,Object? participantCount = null,Object? earliestMessageAtUtc = freezed,Object? latestMessageAtUtc = freezed,Object? recentMessages = null,Object? generatedAtUtc = null,}) {
  return _then(_ChatContextResponse(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,compactedMessageCount: null == compactedMessageCount ? _self.compactedMessageCount : compactedMessageCount // ignore: cast_nullable_to_non_nullable
as int,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,earliestMessageAtUtc: freezed == earliestMessageAtUtc ? _self.earliestMessageAtUtc : earliestMessageAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,latestMessageAtUtc: freezed == latestMessageAtUtc ? _self.latestMessageAtUtc : latestMessageAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,recentMessages: null == recentMessages ? _self.recentMessages : recentMessages // ignore: cast_nullable_to_non_nullable
as List<ChatMessageResponse>,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatMessageWindowResponse {

 String get conversationId; String get anchorMessageId; List<ChatMessageResponse> get messages; bool get hasMoreBefore; bool get hasMoreAfter; String? get beforeCursor;
/// Create a copy of ChatMessageWindowResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageWindowResponseCopyWith<ChatMessageWindowResponse> get copyWith => _$ChatMessageWindowResponseCopyWithImpl<ChatMessageWindowResponse>(this as ChatMessageWindowResponse, _$identity);

  /// Serializes this ChatMessageWindowResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageWindowResponse&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.anchorMessageId, anchorMessageId) || other.anchorMessageId == anchorMessageId)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.hasMoreBefore, hasMoreBefore) || other.hasMoreBefore == hasMoreBefore)&&(identical(other.hasMoreAfter, hasMoreAfter) || other.hasMoreAfter == hasMoreAfter)&&(identical(other.beforeCursor, beforeCursor) || other.beforeCursor == beforeCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,anchorMessageId,const DeepCollectionEquality().hash(messages),hasMoreBefore,hasMoreAfter,beforeCursor);

@override
String toString() {
  return 'ChatMessageWindowResponse(conversationId: $conversationId, anchorMessageId: $anchorMessageId, messages: $messages, hasMoreBefore: $hasMoreBefore, hasMoreAfter: $hasMoreAfter, beforeCursor: $beforeCursor)';
}


}

/// @nodoc
abstract mixin class $ChatMessageWindowResponseCopyWith<$Res>  {
  factory $ChatMessageWindowResponseCopyWith(ChatMessageWindowResponse value, $Res Function(ChatMessageWindowResponse) _then) = _$ChatMessageWindowResponseCopyWithImpl;
@useResult
$Res call({
 String conversationId, String anchorMessageId, List<ChatMessageResponse> messages, bool hasMoreBefore, bool hasMoreAfter, String? beforeCursor
});




}
/// @nodoc
class _$ChatMessageWindowResponseCopyWithImpl<$Res>
    implements $ChatMessageWindowResponseCopyWith<$Res> {
  _$ChatMessageWindowResponseCopyWithImpl(this._self, this._then);

  final ChatMessageWindowResponse _self;
  final $Res Function(ChatMessageWindowResponse) _then;

/// Create a copy of ChatMessageWindowResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? anchorMessageId = null,Object? messages = null,Object? hasMoreBefore = null,Object? hasMoreAfter = null,Object? beforeCursor = freezed,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,anchorMessageId: null == anchorMessageId ? _self.anchorMessageId : anchorMessageId // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessageResponse>,hasMoreBefore: null == hasMoreBefore ? _self.hasMoreBefore : hasMoreBefore // ignore: cast_nullable_to_non_nullable
as bool,hasMoreAfter: null == hasMoreAfter ? _self.hasMoreAfter : hasMoreAfter // ignore: cast_nullable_to_non_nullable
as bool,beforeCursor: freezed == beforeCursor ? _self.beforeCursor : beforeCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageWindowResponse].
extension ChatMessageWindowResponsePatterns on ChatMessageWindowResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageWindowResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageWindowResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageWindowResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageWindowResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageWindowResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageWindowResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String conversationId,  String anchorMessageId,  List<ChatMessageResponse> messages,  bool hasMoreBefore,  bool hasMoreAfter,  String? beforeCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageWindowResponse() when $default != null:
return $default(_that.conversationId,_that.anchorMessageId,_that.messages,_that.hasMoreBefore,_that.hasMoreAfter,_that.beforeCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String conversationId,  String anchorMessageId,  List<ChatMessageResponse> messages,  bool hasMoreBefore,  bool hasMoreAfter,  String? beforeCursor)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageWindowResponse():
return $default(_that.conversationId,_that.anchorMessageId,_that.messages,_that.hasMoreBefore,_that.hasMoreAfter,_that.beforeCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String conversationId,  String anchorMessageId,  List<ChatMessageResponse> messages,  bool hasMoreBefore,  bool hasMoreAfter,  String? beforeCursor)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageWindowResponse() when $default != null:
return $default(_that.conversationId,_that.anchorMessageId,_that.messages,_that.hasMoreBefore,_that.hasMoreAfter,_that.beforeCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageWindowResponse implements ChatMessageWindowResponse {
  const _ChatMessageWindowResponse({required this.conversationId, required this.anchorMessageId, required this.messages, required this.hasMoreBefore, required this.hasMoreAfter, this.beforeCursor});
  factory _ChatMessageWindowResponse.fromJson(Map<String, dynamic> json) => _$ChatMessageWindowResponseFromJson(json);

@override final  String conversationId;
@override final  String anchorMessageId;
@override final  List<ChatMessageResponse> messages;
@override final  bool hasMoreBefore;
@override final  bool hasMoreAfter;
@override final  String? beforeCursor;

/// Create a copy of ChatMessageWindowResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageWindowResponseCopyWith<_ChatMessageWindowResponse> get copyWith => __$ChatMessageWindowResponseCopyWithImpl<_ChatMessageWindowResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageWindowResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageWindowResponse&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.anchorMessageId, anchorMessageId) || other.anchorMessageId == anchorMessageId)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.hasMoreBefore, hasMoreBefore) || other.hasMoreBefore == hasMoreBefore)&&(identical(other.hasMoreAfter, hasMoreAfter) || other.hasMoreAfter == hasMoreAfter)&&(identical(other.beforeCursor, beforeCursor) || other.beforeCursor == beforeCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,anchorMessageId,const DeepCollectionEquality().hash(messages),hasMoreBefore,hasMoreAfter,beforeCursor);

@override
String toString() {
  return 'ChatMessageWindowResponse(conversationId: $conversationId, anchorMessageId: $anchorMessageId, messages: $messages, hasMoreBefore: $hasMoreBefore, hasMoreAfter: $hasMoreAfter, beforeCursor: $beforeCursor)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageWindowResponseCopyWith<$Res> implements $ChatMessageWindowResponseCopyWith<$Res> {
  factory _$ChatMessageWindowResponseCopyWith(_ChatMessageWindowResponse value, $Res Function(_ChatMessageWindowResponse) _then) = __$ChatMessageWindowResponseCopyWithImpl;
@override @useResult
$Res call({
 String conversationId, String anchorMessageId, List<ChatMessageResponse> messages, bool hasMoreBefore, bool hasMoreAfter, String? beforeCursor
});




}
/// @nodoc
class __$ChatMessageWindowResponseCopyWithImpl<$Res>
    implements _$ChatMessageWindowResponseCopyWith<$Res> {
  __$ChatMessageWindowResponseCopyWithImpl(this._self, this._then);

  final _ChatMessageWindowResponse _self;
  final $Res Function(_ChatMessageWindowResponse) _then;

/// Create a copy of ChatMessageWindowResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? anchorMessageId = null,Object? messages = null,Object? hasMoreBefore = null,Object? hasMoreAfter = null,Object? beforeCursor = freezed,}) {
  return _then(_ChatMessageWindowResponse(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,anchorMessageId: null == anchorMessageId ? _self.anchorMessageId : anchorMessageId // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessageResponse>,hasMoreBefore: null == hasMoreBefore ? _self.hasMoreBefore : hasMoreBefore // ignore: cast_nullable_to_non_nullable
as bool,hasMoreAfter: null == hasMoreAfter ? _self.hasMoreAfter : hasMoreAfter // ignore: cast_nullable_to_non_nullable
as bool,beforeCursor: freezed == beforeCursor ? _self.beforeCursor : beforeCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChatSearchItemResponse {

 String get messageId; String get conversationId; String get authorUserId; ChatConversationType get conversationType; String? get workspaceId; String? get projectId; String? get conversationName; String get text; String? get highlight; double get score; DateTime get createdAtUtc; bool get hasMention;
/// Create a copy of ChatSearchItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSearchItemResponseCopyWith<ChatSearchItemResponse> get copyWith => _$ChatSearchItemResponseCopyWithImpl<ChatSearchItemResponse>(this as ChatSearchItemResponse, _$identity);

  /// Serializes this ChatSearchItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSearchItemResponse&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.conversationType, conversationType) || other.conversationType == conversationType)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.conversationName, conversationName) || other.conversationName == conversationName)&&(identical(other.text, text) || other.text == text)&&(identical(other.highlight, highlight) || other.highlight == highlight)&&(identical(other.score, score) || other.score == score)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.hasMention, hasMention) || other.hasMention == hasMention));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,conversationId,authorUserId,conversationType,workspaceId,projectId,conversationName,text,highlight,score,createdAtUtc,hasMention);

@override
String toString() {
  return 'ChatSearchItemResponse(messageId: $messageId, conversationId: $conversationId, authorUserId: $authorUserId, conversationType: $conversationType, workspaceId: $workspaceId, projectId: $projectId, conversationName: $conversationName, text: $text, highlight: $highlight, score: $score, createdAtUtc: $createdAtUtc, hasMention: $hasMention)';
}


}

/// @nodoc
abstract mixin class $ChatSearchItemResponseCopyWith<$Res>  {
  factory $ChatSearchItemResponseCopyWith(ChatSearchItemResponse value, $Res Function(ChatSearchItemResponse) _then) = _$ChatSearchItemResponseCopyWithImpl;
@useResult
$Res call({
 String messageId, String conversationId, String authorUserId, ChatConversationType conversationType, String? workspaceId, String? projectId, String? conversationName, String text, String? highlight, double score, DateTime createdAtUtc, bool hasMention
});




}
/// @nodoc
class _$ChatSearchItemResponseCopyWithImpl<$Res>
    implements $ChatSearchItemResponseCopyWith<$Res> {
  _$ChatSearchItemResponseCopyWithImpl(this._self, this._then);

  final ChatSearchItemResponse _self;
  final $Res Function(ChatSearchItemResponse) _then;

/// Create a copy of ChatSearchItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? conversationId = null,Object? authorUserId = null,Object? conversationType = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? conversationName = freezed,Object? text = null,Object? highlight = freezed,Object? score = null,Object? createdAtUtc = null,Object? hasMention = null,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,conversationType: null == conversationType ? _self.conversationType : conversationType // ignore: cast_nullable_to_non_nullable
as ChatConversationType,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,conversationName: freezed == conversationName ? _self.conversationName : conversationName // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,highlight: freezed == highlight ? _self.highlight : highlight // ignore: cast_nullable_to_non_nullable
as String?,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,hasMention: null == hasMention ? _self.hasMention : hasMention // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSearchItemResponse].
extension ChatSearchItemResponsePatterns on ChatSearchItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSearchItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSearchItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSearchItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatSearchItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSearchItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSearchItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String messageId,  String conversationId,  String authorUserId,  ChatConversationType conversationType,  String? workspaceId,  String? projectId,  String? conversationName,  String text,  String? highlight,  double score,  DateTime createdAtUtc,  bool hasMention)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSearchItemResponse() when $default != null:
return $default(_that.messageId,_that.conversationId,_that.authorUserId,_that.conversationType,_that.workspaceId,_that.projectId,_that.conversationName,_that.text,_that.highlight,_that.score,_that.createdAtUtc,_that.hasMention);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String messageId,  String conversationId,  String authorUserId,  ChatConversationType conversationType,  String? workspaceId,  String? projectId,  String? conversationName,  String text,  String? highlight,  double score,  DateTime createdAtUtc,  bool hasMention)  $default,) {final _that = this;
switch (_that) {
case _ChatSearchItemResponse():
return $default(_that.messageId,_that.conversationId,_that.authorUserId,_that.conversationType,_that.workspaceId,_that.projectId,_that.conversationName,_that.text,_that.highlight,_that.score,_that.createdAtUtc,_that.hasMention);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String messageId,  String conversationId,  String authorUserId,  ChatConversationType conversationType,  String? workspaceId,  String? projectId,  String? conversationName,  String text,  String? highlight,  double score,  DateTime createdAtUtc,  bool hasMention)?  $default,) {final _that = this;
switch (_that) {
case _ChatSearchItemResponse() when $default != null:
return $default(_that.messageId,_that.conversationId,_that.authorUserId,_that.conversationType,_that.workspaceId,_that.projectId,_that.conversationName,_that.text,_that.highlight,_that.score,_that.createdAtUtc,_that.hasMention);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSearchItemResponse implements ChatSearchItemResponse {
  const _ChatSearchItemResponse({required this.messageId, required this.conversationId, required this.authorUserId, required this.conversationType, this.workspaceId, this.projectId, this.conversationName, required this.text, this.highlight, required this.score, required this.createdAtUtc, required this.hasMention});
  factory _ChatSearchItemResponse.fromJson(Map<String, dynamic> json) => _$ChatSearchItemResponseFromJson(json);

@override final  String messageId;
@override final  String conversationId;
@override final  String authorUserId;
@override final  ChatConversationType conversationType;
@override final  String? workspaceId;
@override final  String? projectId;
@override final  String? conversationName;
@override final  String text;
@override final  String? highlight;
@override final  double score;
@override final  DateTime createdAtUtc;
@override final  bool hasMention;

/// Create a copy of ChatSearchItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSearchItemResponseCopyWith<_ChatSearchItemResponse> get copyWith => __$ChatSearchItemResponseCopyWithImpl<_ChatSearchItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSearchItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSearchItemResponse&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.conversationType, conversationType) || other.conversationType == conversationType)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.conversationName, conversationName) || other.conversationName == conversationName)&&(identical(other.text, text) || other.text == text)&&(identical(other.highlight, highlight) || other.highlight == highlight)&&(identical(other.score, score) || other.score == score)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.hasMention, hasMention) || other.hasMention == hasMention));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,conversationId,authorUserId,conversationType,workspaceId,projectId,conversationName,text,highlight,score,createdAtUtc,hasMention);

@override
String toString() {
  return 'ChatSearchItemResponse(messageId: $messageId, conversationId: $conversationId, authorUserId: $authorUserId, conversationType: $conversationType, workspaceId: $workspaceId, projectId: $projectId, conversationName: $conversationName, text: $text, highlight: $highlight, score: $score, createdAtUtc: $createdAtUtc, hasMention: $hasMention)';
}


}

/// @nodoc
abstract mixin class _$ChatSearchItemResponseCopyWith<$Res> implements $ChatSearchItemResponseCopyWith<$Res> {
  factory _$ChatSearchItemResponseCopyWith(_ChatSearchItemResponse value, $Res Function(_ChatSearchItemResponse) _then) = __$ChatSearchItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String messageId, String conversationId, String authorUserId, ChatConversationType conversationType, String? workspaceId, String? projectId, String? conversationName, String text, String? highlight, double score, DateTime createdAtUtc, bool hasMention
});




}
/// @nodoc
class __$ChatSearchItemResponseCopyWithImpl<$Res>
    implements _$ChatSearchItemResponseCopyWith<$Res> {
  __$ChatSearchItemResponseCopyWithImpl(this._self, this._then);

  final _ChatSearchItemResponse _self;
  final $Res Function(_ChatSearchItemResponse) _then;

/// Create a copy of ChatSearchItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? conversationId = null,Object? authorUserId = null,Object? conversationType = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? conversationName = freezed,Object? text = null,Object? highlight = freezed,Object? score = null,Object? createdAtUtc = null,Object? hasMention = null,}) {
  return _then(_ChatSearchItemResponse(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,conversationType: null == conversationType ? _self.conversationType : conversationType // ignore: cast_nullable_to_non_nullable
as ChatConversationType,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,conversationName: freezed == conversationName ? _self.conversationName : conversationName // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,highlight: freezed == highlight ? _self.highlight : highlight // ignore: cast_nullable_to_non_nullable
as String?,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,hasMention: null == hasMention ? _self.hasMention : hasMention // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatSearchFacetBucketResponse {

 String get id; String? get label; int get count;
/// Create a copy of ChatSearchFacetBucketResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSearchFacetBucketResponseCopyWith<ChatSearchFacetBucketResponse> get copyWith => _$ChatSearchFacetBucketResponseCopyWithImpl<ChatSearchFacetBucketResponse>(this as ChatSearchFacetBucketResponse, _$identity);

  /// Serializes this ChatSearchFacetBucketResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSearchFacetBucketResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,count);

@override
String toString() {
  return 'ChatSearchFacetBucketResponse(id: $id, label: $label, count: $count)';
}


}

/// @nodoc
abstract mixin class $ChatSearchFacetBucketResponseCopyWith<$Res>  {
  factory $ChatSearchFacetBucketResponseCopyWith(ChatSearchFacetBucketResponse value, $Res Function(ChatSearchFacetBucketResponse) _then) = _$ChatSearchFacetBucketResponseCopyWithImpl;
@useResult
$Res call({
 String id, String? label, int count
});




}
/// @nodoc
class _$ChatSearchFacetBucketResponseCopyWithImpl<$Res>
    implements $ChatSearchFacetBucketResponseCopyWith<$Res> {
  _$ChatSearchFacetBucketResponseCopyWithImpl(this._self, this._then);

  final ChatSearchFacetBucketResponse _self;
  final $Res Function(ChatSearchFacetBucketResponse) _then;

/// Create a copy of ChatSearchFacetBucketResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = freezed,Object? count = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSearchFacetBucketResponse].
extension ChatSearchFacetBucketResponsePatterns on ChatSearchFacetBucketResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSearchFacetBucketResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSearchFacetBucketResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSearchFacetBucketResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatSearchFacetBucketResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSearchFacetBucketResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSearchFacetBucketResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? label,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSearchFacetBucketResponse() when $default != null:
return $default(_that.id,_that.label,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? label,  int count)  $default,) {final _that = this;
switch (_that) {
case _ChatSearchFacetBucketResponse():
return $default(_that.id,_that.label,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? label,  int count)?  $default,) {final _that = this;
switch (_that) {
case _ChatSearchFacetBucketResponse() when $default != null:
return $default(_that.id,_that.label,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSearchFacetBucketResponse implements ChatSearchFacetBucketResponse {
  const _ChatSearchFacetBucketResponse({required this.id, this.label, required this.count});
  factory _ChatSearchFacetBucketResponse.fromJson(Map<String, dynamic> json) => _$ChatSearchFacetBucketResponseFromJson(json);

@override final  String id;
@override final  String? label;
@override final  int count;

/// Create a copy of ChatSearchFacetBucketResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSearchFacetBucketResponseCopyWith<_ChatSearchFacetBucketResponse> get copyWith => __$ChatSearchFacetBucketResponseCopyWithImpl<_ChatSearchFacetBucketResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSearchFacetBucketResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSearchFacetBucketResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,count);

@override
String toString() {
  return 'ChatSearchFacetBucketResponse(id: $id, label: $label, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ChatSearchFacetBucketResponseCopyWith<$Res> implements $ChatSearchFacetBucketResponseCopyWith<$Res> {
  factory _$ChatSearchFacetBucketResponseCopyWith(_ChatSearchFacetBucketResponse value, $Res Function(_ChatSearchFacetBucketResponse) _then) = __$ChatSearchFacetBucketResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String? label, int count
});




}
/// @nodoc
class __$ChatSearchFacetBucketResponseCopyWithImpl<$Res>
    implements _$ChatSearchFacetBucketResponseCopyWith<$Res> {
  __$ChatSearchFacetBucketResponseCopyWithImpl(this._self, this._then);

  final _ChatSearchFacetBucketResponse _self;
  final $Res Function(_ChatSearchFacetBucketResponse) _then;

/// Create a copy of ChatSearchFacetBucketResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = freezed,Object? count = null,}) {
  return _then(_ChatSearchFacetBucketResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChatSearchResponse {

 List<ChatSearchItemResponse> get items; String? get nextCursor; int get totalApproximate; String get indexVersion;
/// Create a copy of ChatSearchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSearchResponseCopyWith<ChatSearchResponse> get copyWith => _$ChatSearchResponseCopyWithImpl<ChatSearchResponse>(this as ChatSearchResponse, _$identity);

  /// Serializes this ChatSearchResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSearchResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.totalApproximate, totalApproximate) || other.totalApproximate == totalApproximate)&&(identical(other.indexVersion, indexVersion) || other.indexVersion == indexVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,totalApproximate,indexVersion);

@override
String toString() {
  return 'ChatSearchResponse(items: $items, nextCursor: $nextCursor, totalApproximate: $totalApproximate, indexVersion: $indexVersion)';
}


}

/// @nodoc
abstract mixin class $ChatSearchResponseCopyWith<$Res>  {
  factory $ChatSearchResponseCopyWith(ChatSearchResponse value, $Res Function(ChatSearchResponse) _then) = _$ChatSearchResponseCopyWithImpl;
@useResult
$Res call({
 List<ChatSearchItemResponse> items, String? nextCursor, int totalApproximate, String indexVersion
});




}
/// @nodoc
class _$ChatSearchResponseCopyWithImpl<$Res>
    implements $ChatSearchResponseCopyWith<$Res> {
  _$ChatSearchResponseCopyWithImpl(this._self, this._then);

  final ChatSearchResponse _self;
  final $Res Function(ChatSearchResponse) _then;

/// Create a copy of ChatSearchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,Object? totalApproximate = null,Object? indexVersion = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChatSearchItemResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,totalApproximate: null == totalApproximate ? _self.totalApproximate : totalApproximate // ignore: cast_nullable_to_non_nullable
as int,indexVersion: null == indexVersion ? _self.indexVersion : indexVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSearchResponse].
extension ChatSearchResponsePatterns on ChatSearchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSearchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSearchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSearchResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatSearchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSearchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSearchResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatSearchItemResponse> items,  String? nextCursor,  int totalApproximate,  String indexVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSearchResponse() when $default != null:
return $default(_that.items,_that.nextCursor,_that.totalApproximate,_that.indexVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatSearchItemResponse> items,  String? nextCursor,  int totalApproximate,  String indexVersion)  $default,) {final _that = this;
switch (_that) {
case _ChatSearchResponse():
return $default(_that.items,_that.nextCursor,_that.totalApproximate,_that.indexVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatSearchItemResponse> items,  String? nextCursor,  int totalApproximate,  String indexVersion)?  $default,) {final _that = this;
switch (_that) {
case _ChatSearchResponse() when $default != null:
return $default(_that.items,_that.nextCursor,_that.totalApproximate,_that.indexVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSearchResponse implements ChatSearchResponse {
  const _ChatSearchResponse({required this.items, this.nextCursor, required this.totalApproximate, required this.indexVersion});
  factory _ChatSearchResponse.fromJson(Map<String, dynamic> json) => _$ChatSearchResponseFromJson(json);

@override final  List<ChatSearchItemResponse> items;
@override final  String? nextCursor;
@override final  int totalApproximate;
@override final  String indexVersion;

/// Create a copy of ChatSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSearchResponseCopyWith<_ChatSearchResponse> get copyWith => __$ChatSearchResponseCopyWithImpl<_ChatSearchResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSearchResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSearchResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.totalApproximate, totalApproximate) || other.totalApproximate == totalApproximate)&&(identical(other.indexVersion, indexVersion) || other.indexVersion == indexVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,totalApproximate,indexVersion);

@override
String toString() {
  return 'ChatSearchResponse(items: $items, nextCursor: $nextCursor, totalApproximate: $totalApproximate, indexVersion: $indexVersion)';
}


}

/// @nodoc
abstract mixin class _$ChatSearchResponseCopyWith<$Res> implements $ChatSearchResponseCopyWith<$Res> {
  factory _$ChatSearchResponseCopyWith(_ChatSearchResponse value, $Res Function(_ChatSearchResponse) _then) = __$ChatSearchResponseCopyWithImpl;
@override @useResult
$Res call({
 List<ChatSearchItemResponse> items, String? nextCursor, int totalApproximate, String indexVersion
});




}
/// @nodoc
class __$ChatSearchResponseCopyWithImpl<$Res>
    implements _$ChatSearchResponseCopyWith<$Res> {
  __$ChatSearchResponseCopyWithImpl(this._self, this._then);

  final _ChatSearchResponse _self;
  final $Res Function(_ChatSearchResponse) _then;

/// Create a copy of ChatSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? totalApproximate = null,Object? indexVersion = null,}) {
  return _then(_ChatSearchResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChatSearchItemResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,totalApproximate: null == totalApproximate ? _self.totalApproximate : totalApproximate // ignore: cast_nullable_to_non_nullable
as int,indexVersion: null == indexVersion ? _self.indexVersion : indexVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ChatSearchFacetsResponse {

 int get total; List<ChatSearchFacetBucketResponse> get conversations; List<ChatSearchFacetBucketResponse> get senders; List<ChatSearchFacetBucketResponse> get workspaces; List<ChatSearchFacetBucketResponse> get projects;
/// Create a copy of ChatSearchFacetsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSearchFacetsResponseCopyWith<ChatSearchFacetsResponse> get copyWith => _$ChatSearchFacetsResponseCopyWithImpl<ChatSearchFacetsResponse>(this as ChatSearchFacetsResponse, _$identity);

  /// Serializes this ChatSearchFacetsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSearchFacetsResponse&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.conversations, conversations)&&const DeepCollectionEquality().equals(other.senders, senders)&&const DeepCollectionEquality().equals(other.workspaces, workspaces)&&const DeepCollectionEquality().equals(other.projects, projects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(conversations),const DeepCollectionEquality().hash(senders),const DeepCollectionEquality().hash(workspaces),const DeepCollectionEquality().hash(projects));

@override
String toString() {
  return 'ChatSearchFacetsResponse(total: $total, conversations: $conversations, senders: $senders, workspaces: $workspaces, projects: $projects)';
}


}

/// @nodoc
abstract mixin class $ChatSearchFacetsResponseCopyWith<$Res>  {
  factory $ChatSearchFacetsResponseCopyWith(ChatSearchFacetsResponse value, $Res Function(ChatSearchFacetsResponse) _then) = _$ChatSearchFacetsResponseCopyWithImpl;
@useResult
$Res call({
 int total, List<ChatSearchFacetBucketResponse> conversations, List<ChatSearchFacetBucketResponse> senders, List<ChatSearchFacetBucketResponse> workspaces, List<ChatSearchFacetBucketResponse> projects
});




}
/// @nodoc
class _$ChatSearchFacetsResponseCopyWithImpl<$Res>
    implements $ChatSearchFacetsResponseCopyWith<$Res> {
  _$ChatSearchFacetsResponseCopyWithImpl(this._self, this._then);

  final ChatSearchFacetsResponse _self;
  final $Res Function(ChatSearchFacetsResponse) _then;

/// Create a copy of ChatSearchFacetsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? conversations = null,Object? senders = null,Object? workspaces = null,Object? projects = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,conversations: null == conversations ? _self.conversations : conversations // ignore: cast_nullable_to_non_nullable
as List<ChatSearchFacetBucketResponse>,senders: null == senders ? _self.senders : senders // ignore: cast_nullable_to_non_nullable
as List<ChatSearchFacetBucketResponse>,workspaces: null == workspaces ? _self.workspaces : workspaces // ignore: cast_nullable_to_non_nullable
as List<ChatSearchFacetBucketResponse>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<ChatSearchFacetBucketResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSearchFacetsResponse].
extension ChatSearchFacetsResponsePatterns on ChatSearchFacetsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSearchFacetsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSearchFacetsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSearchFacetsResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatSearchFacetsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSearchFacetsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSearchFacetsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  List<ChatSearchFacetBucketResponse> conversations,  List<ChatSearchFacetBucketResponse> senders,  List<ChatSearchFacetBucketResponse> workspaces,  List<ChatSearchFacetBucketResponse> projects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSearchFacetsResponse() when $default != null:
return $default(_that.total,_that.conversations,_that.senders,_that.workspaces,_that.projects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  List<ChatSearchFacetBucketResponse> conversations,  List<ChatSearchFacetBucketResponse> senders,  List<ChatSearchFacetBucketResponse> workspaces,  List<ChatSearchFacetBucketResponse> projects)  $default,) {final _that = this;
switch (_that) {
case _ChatSearchFacetsResponse():
return $default(_that.total,_that.conversations,_that.senders,_that.workspaces,_that.projects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  List<ChatSearchFacetBucketResponse> conversations,  List<ChatSearchFacetBucketResponse> senders,  List<ChatSearchFacetBucketResponse> workspaces,  List<ChatSearchFacetBucketResponse> projects)?  $default,) {final _that = this;
switch (_that) {
case _ChatSearchFacetsResponse() when $default != null:
return $default(_that.total,_that.conversations,_that.senders,_that.workspaces,_that.projects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSearchFacetsResponse implements ChatSearchFacetsResponse {
  const _ChatSearchFacetsResponse({required this.total, required this.conversations, required this.senders, required this.workspaces, required this.projects});
  factory _ChatSearchFacetsResponse.fromJson(Map<String, dynamic> json) => _$ChatSearchFacetsResponseFromJson(json);

@override final  int total;
@override final  List<ChatSearchFacetBucketResponse> conversations;
@override final  List<ChatSearchFacetBucketResponse> senders;
@override final  List<ChatSearchFacetBucketResponse> workspaces;
@override final  List<ChatSearchFacetBucketResponse> projects;

/// Create a copy of ChatSearchFacetsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSearchFacetsResponseCopyWith<_ChatSearchFacetsResponse> get copyWith => __$ChatSearchFacetsResponseCopyWithImpl<_ChatSearchFacetsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSearchFacetsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSearchFacetsResponse&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.conversations, conversations)&&const DeepCollectionEquality().equals(other.senders, senders)&&const DeepCollectionEquality().equals(other.workspaces, workspaces)&&const DeepCollectionEquality().equals(other.projects, projects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(conversations),const DeepCollectionEquality().hash(senders),const DeepCollectionEquality().hash(workspaces),const DeepCollectionEquality().hash(projects));

@override
String toString() {
  return 'ChatSearchFacetsResponse(total: $total, conversations: $conversations, senders: $senders, workspaces: $workspaces, projects: $projects)';
}


}

/// @nodoc
abstract mixin class _$ChatSearchFacetsResponseCopyWith<$Res> implements $ChatSearchFacetsResponseCopyWith<$Res> {
  factory _$ChatSearchFacetsResponseCopyWith(_ChatSearchFacetsResponse value, $Res Function(_ChatSearchFacetsResponse) _then) = __$ChatSearchFacetsResponseCopyWithImpl;
@override @useResult
$Res call({
 int total, List<ChatSearchFacetBucketResponse> conversations, List<ChatSearchFacetBucketResponse> senders, List<ChatSearchFacetBucketResponse> workspaces, List<ChatSearchFacetBucketResponse> projects
});




}
/// @nodoc
class __$ChatSearchFacetsResponseCopyWithImpl<$Res>
    implements _$ChatSearchFacetsResponseCopyWith<$Res> {
  __$ChatSearchFacetsResponseCopyWithImpl(this._self, this._then);

  final _ChatSearchFacetsResponse _self;
  final $Res Function(_ChatSearchFacetsResponse) _then;

/// Create a copy of ChatSearchFacetsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? conversations = null,Object? senders = null,Object? workspaces = null,Object? projects = null,}) {
  return _then(_ChatSearchFacetsResponse(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,conversations: null == conversations ? _self.conversations : conversations // ignore: cast_nullable_to_non_nullable
as List<ChatSearchFacetBucketResponse>,senders: null == senders ? _self.senders : senders // ignore: cast_nullable_to_non_nullable
as List<ChatSearchFacetBucketResponse>,workspaces: null == workspaces ? _self.workspaces : workspaces // ignore: cast_nullable_to_non_nullable
as List<ChatSearchFacetBucketResponse>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<ChatSearchFacetBucketResponse>,
  ));
}


}


/// @nodoc
mixin _$ChatInboxPageResponse {

 List<ChatInboxItemResponse> get items; String? get nextCursor; bool get hasMore;
/// Create a copy of ChatInboxPageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInboxPageResponseCopyWith<ChatInboxPageResponse> get copyWith => _$ChatInboxPageResponseCopyWithImpl<ChatInboxPageResponse>(this as ChatInboxPageResponse, _$identity);

  /// Serializes this ChatInboxPageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInboxPageResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,hasMore);

@override
String toString() {
  return 'ChatInboxPageResponse(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $ChatInboxPageResponseCopyWith<$Res>  {
  factory $ChatInboxPageResponseCopyWith(ChatInboxPageResponse value, $Res Function(ChatInboxPageResponse) _then) = _$ChatInboxPageResponseCopyWithImpl;
@useResult
$Res call({
 List<ChatInboxItemResponse> items, String? nextCursor, bool hasMore
});




}
/// @nodoc
class _$ChatInboxPageResponseCopyWithImpl<$Res>
    implements $ChatInboxPageResponseCopyWith<$Res> {
  _$ChatInboxPageResponseCopyWithImpl(this._self, this._then);

  final ChatInboxPageResponse _self;
  final $Res Function(ChatInboxPageResponse) _then;

/// Create a copy of ChatInboxPageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChatInboxItemResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatInboxPageResponse].
extension ChatInboxPageResponsePatterns on ChatInboxPageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInboxPageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInboxPageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInboxPageResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatInboxPageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInboxPageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInboxPageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatInboxItemResponse> items,  String? nextCursor,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInboxPageResponse() when $default != null:
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatInboxItemResponse> items,  String? nextCursor,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _ChatInboxPageResponse():
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatInboxItemResponse> items,  String? nextCursor,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _ChatInboxPageResponse() when $default != null:
return $default(_that.items,_that.nextCursor,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatInboxPageResponse implements ChatInboxPageResponse {
  const _ChatInboxPageResponse({this.items = const <ChatInboxItemResponse>[], this.nextCursor, this.hasMore = false});
  factory _ChatInboxPageResponse.fromJson(Map<String, dynamic> json) => _$ChatInboxPageResponseFromJson(json);

@override@JsonKey() final  List<ChatInboxItemResponse> items;
@override final  String? nextCursor;
@override@JsonKey() final  bool hasMore;

/// Create a copy of ChatInboxPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInboxPageResponseCopyWith<_ChatInboxPageResponse> get copyWith => __$ChatInboxPageResponseCopyWithImpl<_ChatInboxPageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatInboxPageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInboxPageResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor,hasMore);

@override
String toString() {
  return 'ChatInboxPageResponse(items: $items, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$ChatInboxPageResponseCopyWith<$Res> implements $ChatInboxPageResponseCopyWith<$Res> {
  factory _$ChatInboxPageResponseCopyWith(_ChatInboxPageResponse value, $Res Function(_ChatInboxPageResponse) _then) = __$ChatInboxPageResponseCopyWithImpl;
@override @useResult
$Res call({
 List<ChatInboxItemResponse> items, String? nextCursor, bool hasMore
});




}
/// @nodoc
class __$ChatInboxPageResponseCopyWithImpl<$Res>
    implements _$ChatInboxPageResponseCopyWith<$Res> {
  __$ChatInboxPageResponseCopyWithImpl(this._self, this._then);

  final _ChatInboxPageResponse _self;
  final $Res Function(_ChatInboxPageResponse) _then;

/// Create a copy of ChatInboxPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_ChatInboxPageResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChatInboxItemResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatInboxItemResponse {

 ChatConversationResponse get conversation; ChatInboxMessagePreviewResponse? get lastMessage; DateTime get lastActivityAtUtc; int get unreadCount; String? get lastReadMessageId; bool get isMuted; bool get isDraft; String? get draftText; String? get role; List<ChatInboxParticipantResponse> get participants; int get participantCount;
/// Create a copy of ChatInboxItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInboxItemResponseCopyWith<ChatInboxItemResponse> get copyWith => _$ChatInboxItemResponseCopyWithImpl<ChatInboxItemResponse>(this as ChatInboxItemResponse, _$identity);

  /// Serializes this ChatInboxItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInboxItemResponse&&(identical(other.conversation, conversation) || other.conversation == conversation)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastActivityAtUtc, lastActivityAtUtc) || other.lastActivityAtUtc == lastActivityAtUtc)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastReadMessageId, lastReadMessageId) || other.lastReadMessageId == lastReadMessageId)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isDraft, isDraft) || other.isDraft == isDraft)&&(identical(other.draftText, draftText) || other.draftText == draftText)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversation,lastMessage,lastActivityAtUtc,unreadCount,lastReadMessageId,isMuted,isDraft,draftText,role,const DeepCollectionEquality().hash(participants),participantCount);

@override
String toString() {
  return 'ChatInboxItemResponse(conversation: $conversation, lastMessage: $lastMessage, lastActivityAtUtc: $lastActivityAtUtc, unreadCount: $unreadCount, lastReadMessageId: $lastReadMessageId, isMuted: $isMuted, isDraft: $isDraft, draftText: $draftText, role: $role, participants: $participants, participantCount: $participantCount)';
}


}

/// @nodoc
abstract mixin class $ChatInboxItemResponseCopyWith<$Res>  {
  factory $ChatInboxItemResponseCopyWith(ChatInboxItemResponse value, $Res Function(ChatInboxItemResponse) _then) = _$ChatInboxItemResponseCopyWithImpl;
@useResult
$Res call({
 ChatConversationResponse conversation, ChatInboxMessagePreviewResponse? lastMessage, DateTime lastActivityAtUtc, int unreadCount, String? lastReadMessageId, bool isMuted, bool isDraft, String? draftText, String? role, List<ChatInboxParticipantResponse> participants, int participantCount
});


$ChatConversationResponseCopyWith<$Res> get conversation;$ChatInboxMessagePreviewResponseCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class _$ChatInboxItemResponseCopyWithImpl<$Res>
    implements $ChatInboxItemResponseCopyWith<$Res> {
  _$ChatInboxItemResponseCopyWithImpl(this._self, this._then);

  final ChatInboxItemResponse _self;
  final $Res Function(ChatInboxItemResponse) _then;

/// Create a copy of ChatInboxItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversation = null,Object? lastMessage = freezed,Object? lastActivityAtUtc = null,Object? unreadCount = null,Object? lastReadMessageId = freezed,Object? isMuted = null,Object? isDraft = null,Object? draftText = freezed,Object? role = freezed,Object? participants = null,Object? participantCount = null,}) {
  return _then(_self.copyWith(
conversation: null == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as ChatConversationResponse,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as ChatInboxMessagePreviewResponse?,lastActivityAtUtc: null == lastActivityAtUtc ? _self.lastActivityAtUtc : lastActivityAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastReadMessageId: freezed == lastReadMessageId ? _self.lastReadMessageId : lastReadMessageId // ignore: cast_nullable_to_non_nullable
as String?,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isDraft: null == isDraft ? _self.isDraft : isDraft // ignore: cast_nullable_to_non_nullable
as bool,draftText: freezed == draftText ? _self.draftText : draftText // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ChatInboxParticipantResponse>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ChatInboxItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatConversationResponseCopyWith<$Res> get conversation {

  return $ChatConversationResponseCopyWith<$Res>(_self.conversation, (value) {
    return _then(_self.copyWith(conversation: value));
  });
}/// Create a copy of ChatInboxItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatInboxMessagePreviewResponseCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $ChatInboxMessagePreviewResponseCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatInboxItemResponse].
extension ChatInboxItemResponsePatterns on ChatInboxItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInboxItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInboxItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInboxItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatInboxItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInboxItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInboxItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatConversationResponse conversation,  ChatInboxMessagePreviewResponse? lastMessage,  DateTime lastActivityAtUtc,  int unreadCount,  String? lastReadMessageId,  bool isMuted,  bool isDraft,  String? draftText,  String? role,  List<ChatInboxParticipantResponse> participants,  int participantCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInboxItemResponse() when $default != null:
return $default(_that.conversation,_that.lastMessage,_that.lastActivityAtUtc,_that.unreadCount,_that.lastReadMessageId,_that.isMuted,_that.isDraft,_that.draftText,_that.role,_that.participants,_that.participantCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatConversationResponse conversation,  ChatInboxMessagePreviewResponse? lastMessage,  DateTime lastActivityAtUtc,  int unreadCount,  String? lastReadMessageId,  bool isMuted,  bool isDraft,  String? draftText,  String? role,  List<ChatInboxParticipantResponse> participants,  int participantCount)  $default,) {final _that = this;
switch (_that) {
case _ChatInboxItemResponse():
return $default(_that.conversation,_that.lastMessage,_that.lastActivityAtUtc,_that.unreadCount,_that.lastReadMessageId,_that.isMuted,_that.isDraft,_that.draftText,_that.role,_that.participants,_that.participantCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatConversationResponse conversation,  ChatInboxMessagePreviewResponse? lastMessage,  DateTime lastActivityAtUtc,  int unreadCount,  String? lastReadMessageId,  bool isMuted,  bool isDraft,  String? draftText,  String? role,  List<ChatInboxParticipantResponse> participants,  int participantCount)?  $default,) {final _that = this;
switch (_that) {
case _ChatInboxItemResponse() when $default != null:
return $default(_that.conversation,_that.lastMessage,_that.lastActivityAtUtc,_that.unreadCount,_that.lastReadMessageId,_that.isMuted,_that.isDraft,_that.draftText,_that.role,_that.participants,_that.participantCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatInboxItemResponse implements ChatInboxItemResponse {
  const _ChatInboxItemResponse({required this.conversation, this.lastMessage, required this.lastActivityAtUtc, this.unreadCount = 0, this.lastReadMessageId, this.isMuted = false, this.isDraft = false, this.draftText, this.role, this.participants = const <ChatInboxParticipantResponse>[], this.participantCount = 0});
  factory _ChatInboxItemResponse.fromJson(Map<String, dynamic> json) => _$ChatInboxItemResponseFromJson(json);

@override final  ChatConversationResponse conversation;
@override final  ChatInboxMessagePreviewResponse? lastMessage;
@override final  DateTime lastActivityAtUtc;
@override@JsonKey() final  int unreadCount;
@override final  String? lastReadMessageId;
@override@JsonKey() final  bool isMuted;
@override@JsonKey() final  bool isDraft;
@override final  String? draftText;
@override final  String? role;
@override@JsonKey() final  List<ChatInboxParticipantResponse> participants;
@override@JsonKey() final  int participantCount;

/// Create a copy of ChatInboxItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInboxItemResponseCopyWith<_ChatInboxItemResponse> get copyWith => __$ChatInboxItemResponseCopyWithImpl<_ChatInboxItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatInboxItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInboxItemResponse&&(identical(other.conversation, conversation) || other.conversation == conversation)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastActivityAtUtc, lastActivityAtUtc) || other.lastActivityAtUtc == lastActivityAtUtc)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastReadMessageId, lastReadMessageId) || other.lastReadMessageId == lastReadMessageId)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isDraft, isDraft) || other.isDraft == isDraft)&&(identical(other.draftText, draftText) || other.draftText == draftText)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversation,lastMessage,lastActivityAtUtc,unreadCount,lastReadMessageId,isMuted,isDraft,draftText,role,const DeepCollectionEquality().hash(participants),participantCount);

@override
String toString() {
  return 'ChatInboxItemResponse(conversation: $conversation, lastMessage: $lastMessage, lastActivityAtUtc: $lastActivityAtUtc, unreadCount: $unreadCount, lastReadMessageId: $lastReadMessageId, isMuted: $isMuted, isDraft: $isDraft, draftText: $draftText, role: $role, participants: $participants, participantCount: $participantCount)';
}


}

/// @nodoc
abstract mixin class _$ChatInboxItemResponseCopyWith<$Res> implements $ChatInboxItemResponseCopyWith<$Res> {
  factory _$ChatInboxItemResponseCopyWith(_ChatInboxItemResponse value, $Res Function(_ChatInboxItemResponse) _then) = __$ChatInboxItemResponseCopyWithImpl;
@override @useResult
$Res call({
 ChatConversationResponse conversation, ChatInboxMessagePreviewResponse? lastMessage, DateTime lastActivityAtUtc, int unreadCount, String? lastReadMessageId, bool isMuted, bool isDraft, String? draftText, String? role, List<ChatInboxParticipantResponse> participants, int participantCount
});


@override $ChatConversationResponseCopyWith<$Res> get conversation;@override $ChatInboxMessagePreviewResponseCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class __$ChatInboxItemResponseCopyWithImpl<$Res>
    implements _$ChatInboxItemResponseCopyWith<$Res> {
  __$ChatInboxItemResponseCopyWithImpl(this._self, this._then);

  final _ChatInboxItemResponse _self;
  final $Res Function(_ChatInboxItemResponse) _then;

/// Create a copy of ChatInboxItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversation = null,Object? lastMessage = freezed,Object? lastActivityAtUtc = null,Object? unreadCount = null,Object? lastReadMessageId = freezed,Object? isMuted = null,Object? isDraft = null,Object? draftText = freezed,Object? role = freezed,Object? participants = null,Object? participantCount = null,}) {
  return _then(_ChatInboxItemResponse(
conversation: null == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as ChatConversationResponse,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as ChatInboxMessagePreviewResponse?,lastActivityAtUtc: null == lastActivityAtUtc ? _self.lastActivityAtUtc : lastActivityAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastReadMessageId: freezed == lastReadMessageId ? _self.lastReadMessageId : lastReadMessageId // ignore: cast_nullable_to_non_nullable
as String?,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isDraft: null == isDraft ? _self.isDraft : isDraft // ignore: cast_nullable_to_non_nullable
as bool,draftText: freezed == draftText ? _self.draftText : draftText // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ChatInboxParticipantResponse>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ChatInboxItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatConversationResponseCopyWith<$Res> get conversation {

  return $ChatConversationResponseCopyWith<$Res>(_self.conversation, (value) {
    return _then(_self.copyWith(conversation: value));
  });
}/// Create a copy of ChatInboxItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatInboxMessagePreviewResponseCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $ChatInboxMessagePreviewResponseCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}


/// @nodoc
mixin _$ChatInboxMessagePreviewResponse {

 String get messageId; String get authorUserId; String? get text; bool get isDeleted; bool get hasAttachments; String? get threadRootMessageId; DateTime get createdAtUtc;
/// Create a copy of ChatInboxMessagePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInboxMessagePreviewResponseCopyWith<ChatInboxMessagePreviewResponse> get copyWith => _$ChatInboxMessagePreviewResponseCopyWithImpl<ChatInboxMessagePreviewResponse>(this as ChatInboxMessagePreviewResponse, _$identity);

  /// Serializes this ChatInboxMessagePreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInboxMessagePreviewResponse&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.text, text) || other.text == text)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.hasAttachments, hasAttachments) || other.hasAttachments == hasAttachments)&&(identical(other.threadRootMessageId, threadRootMessageId) || other.threadRootMessageId == threadRootMessageId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,authorUserId,text,isDeleted,hasAttachments,threadRootMessageId,createdAtUtc);

@override
String toString() {
  return 'ChatInboxMessagePreviewResponse(messageId: $messageId, authorUserId: $authorUserId, text: $text, isDeleted: $isDeleted, hasAttachments: $hasAttachments, threadRootMessageId: $threadRootMessageId, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatInboxMessagePreviewResponseCopyWith<$Res>  {
  factory $ChatInboxMessagePreviewResponseCopyWith(ChatInboxMessagePreviewResponse value, $Res Function(ChatInboxMessagePreviewResponse) _then) = _$ChatInboxMessagePreviewResponseCopyWithImpl;
@useResult
$Res call({
 String messageId, String authorUserId, String? text, bool isDeleted, bool hasAttachments, String? threadRootMessageId, DateTime createdAtUtc
});




}
/// @nodoc
class _$ChatInboxMessagePreviewResponseCopyWithImpl<$Res>
    implements $ChatInboxMessagePreviewResponseCopyWith<$Res> {
  _$ChatInboxMessagePreviewResponseCopyWithImpl(this._self, this._then);

  final ChatInboxMessagePreviewResponse _self;
  final $Res Function(ChatInboxMessagePreviewResponse) _then;

/// Create a copy of ChatInboxMessagePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? authorUserId = null,Object? text = freezed,Object? isDeleted = null,Object? hasAttachments = null,Object? threadRootMessageId = freezed,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,hasAttachments: null == hasAttachments ? _self.hasAttachments : hasAttachments // ignore: cast_nullable_to_non_nullable
as bool,threadRootMessageId: freezed == threadRootMessageId ? _self.threadRootMessageId : threadRootMessageId // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatInboxMessagePreviewResponse].
extension ChatInboxMessagePreviewResponsePatterns on ChatInboxMessagePreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInboxMessagePreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInboxMessagePreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInboxMessagePreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatInboxMessagePreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInboxMessagePreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInboxMessagePreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String messageId,  String authorUserId,  String? text,  bool isDeleted,  bool hasAttachments,  String? threadRootMessageId,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInboxMessagePreviewResponse() when $default != null:
return $default(_that.messageId,_that.authorUserId,_that.text,_that.isDeleted,_that.hasAttachments,_that.threadRootMessageId,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String messageId,  String authorUserId,  String? text,  bool isDeleted,  bool hasAttachments,  String? threadRootMessageId,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatInboxMessagePreviewResponse():
return $default(_that.messageId,_that.authorUserId,_that.text,_that.isDeleted,_that.hasAttachments,_that.threadRootMessageId,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String messageId,  String authorUserId,  String? text,  bool isDeleted,  bool hasAttachments,  String? threadRootMessageId,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatInboxMessagePreviewResponse() when $default != null:
return $default(_that.messageId,_that.authorUserId,_that.text,_that.isDeleted,_that.hasAttachments,_that.threadRootMessageId,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatInboxMessagePreviewResponse implements ChatInboxMessagePreviewResponse {
  const _ChatInboxMessagePreviewResponse({required this.messageId, required this.authorUserId, this.text, this.isDeleted = false, this.hasAttachments = false, this.threadRootMessageId, required this.createdAtUtc});
  factory _ChatInboxMessagePreviewResponse.fromJson(Map<String, dynamic> json) => _$ChatInboxMessagePreviewResponseFromJson(json);

@override final  String messageId;
@override final  String authorUserId;
@override final  String? text;
@override@JsonKey() final  bool isDeleted;
@override@JsonKey() final  bool hasAttachments;
@override final  String? threadRootMessageId;
@override final  DateTime createdAtUtc;

/// Create a copy of ChatInboxMessagePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInboxMessagePreviewResponseCopyWith<_ChatInboxMessagePreviewResponse> get copyWith => __$ChatInboxMessagePreviewResponseCopyWithImpl<_ChatInboxMessagePreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatInboxMessagePreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInboxMessagePreviewResponse&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.text, text) || other.text == text)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.hasAttachments, hasAttachments) || other.hasAttachments == hasAttachments)&&(identical(other.threadRootMessageId, threadRootMessageId) || other.threadRootMessageId == threadRootMessageId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,authorUserId,text,isDeleted,hasAttachments,threadRootMessageId,createdAtUtc);

@override
String toString() {
  return 'ChatInboxMessagePreviewResponse(messageId: $messageId, authorUserId: $authorUserId, text: $text, isDeleted: $isDeleted, hasAttachments: $hasAttachments, threadRootMessageId: $threadRootMessageId, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatInboxMessagePreviewResponseCopyWith<$Res> implements $ChatInboxMessagePreviewResponseCopyWith<$Res> {
  factory _$ChatInboxMessagePreviewResponseCopyWith(_ChatInboxMessagePreviewResponse value, $Res Function(_ChatInboxMessagePreviewResponse) _then) = __$ChatInboxMessagePreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 String messageId, String authorUserId, String? text, bool isDeleted, bool hasAttachments, String? threadRootMessageId, DateTime createdAtUtc
});




}
/// @nodoc
class __$ChatInboxMessagePreviewResponseCopyWithImpl<$Res>
    implements _$ChatInboxMessagePreviewResponseCopyWith<$Res> {
  __$ChatInboxMessagePreviewResponseCopyWithImpl(this._self, this._then);

  final _ChatInboxMessagePreviewResponse _self;
  final $Res Function(_ChatInboxMessagePreviewResponse) _then;

/// Create a copy of ChatInboxMessagePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? authorUserId = null,Object? text = freezed,Object? isDeleted = null,Object? hasAttachments = null,Object? threadRootMessageId = freezed,Object? createdAtUtc = null,}) {
  return _then(_ChatInboxMessagePreviewResponse(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,hasAttachments: null == hasAttachments ? _self.hasAttachments : hasAttachments // ignore: cast_nullable_to_non_nullable
as bool,threadRootMessageId: freezed == threadRootMessageId ? _self.threadRootMessageId : threadRootMessageId // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatInboxParticipantResponse {

 String get userId; String? get login; String? get displayName; String? get avatarUrl; bool get isCurrentUser;
/// Create a copy of ChatInboxParticipantResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInboxParticipantResponseCopyWith<ChatInboxParticipantResponse> get copyWith => _$ChatInboxParticipantResponseCopyWithImpl<ChatInboxParticipantResponse>(this as ChatInboxParticipantResponse, _$identity);

  /// Serializes this ChatInboxParticipantResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInboxParticipantResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isCurrentUser, isCurrentUser) || other.isCurrentUser == isCurrentUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,avatarUrl,isCurrentUser);

@override
String toString() {
  return 'ChatInboxParticipantResponse(userId: $userId, login: $login, displayName: $displayName, avatarUrl: $avatarUrl, isCurrentUser: $isCurrentUser)';
}


}

/// @nodoc
abstract mixin class $ChatInboxParticipantResponseCopyWith<$Res>  {
  factory $ChatInboxParticipantResponseCopyWith(ChatInboxParticipantResponse value, $Res Function(ChatInboxParticipantResponse) _then) = _$ChatInboxParticipantResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String? login, String? displayName, String? avatarUrl, bool isCurrentUser
});




}
/// @nodoc
class _$ChatInboxParticipantResponseCopyWithImpl<$Res>
    implements $ChatInboxParticipantResponseCopyWith<$Res> {
  _$ChatInboxParticipantResponseCopyWithImpl(this._self, this._then);

  final ChatInboxParticipantResponse _self;
  final $Res Function(ChatInboxParticipantResponse) _then;

/// Create a copy of ChatInboxParticipantResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? login = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,Object? isCurrentUser = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: freezed == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isCurrentUser: null == isCurrentUser ? _self.isCurrentUser : isCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatInboxParticipantResponse].
extension ChatInboxParticipantResponsePatterns on ChatInboxParticipantResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInboxParticipantResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInboxParticipantResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInboxParticipantResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatInboxParticipantResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInboxParticipantResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInboxParticipantResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? login,  String? displayName,  String? avatarUrl,  bool isCurrentUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInboxParticipantResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl,_that.isCurrentUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? login,  String? displayName,  String? avatarUrl,  bool isCurrentUser)  $default,) {final _that = this;
switch (_that) {
case _ChatInboxParticipantResponse():
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl,_that.isCurrentUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? login,  String? displayName,  String? avatarUrl,  bool isCurrentUser)?  $default,) {final _that = this;
switch (_that) {
case _ChatInboxParticipantResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl,_that.isCurrentUser);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatInboxParticipantResponse implements ChatInboxParticipantResponse {
  const _ChatInboxParticipantResponse({required this.userId, this.login, this.displayName, this.avatarUrl, this.isCurrentUser = false});
  factory _ChatInboxParticipantResponse.fromJson(Map<String, dynamic> json) => _$ChatInboxParticipantResponseFromJson(json);

@override final  String userId;
@override final  String? login;
@override final  String? displayName;
@override final  String? avatarUrl;
@override@JsonKey() final  bool isCurrentUser;

/// Create a copy of ChatInboxParticipantResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInboxParticipantResponseCopyWith<_ChatInboxParticipantResponse> get copyWith => __$ChatInboxParticipantResponseCopyWithImpl<_ChatInboxParticipantResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatInboxParticipantResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInboxParticipantResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isCurrentUser, isCurrentUser) || other.isCurrentUser == isCurrentUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,avatarUrl,isCurrentUser);

@override
String toString() {
  return 'ChatInboxParticipantResponse(userId: $userId, login: $login, displayName: $displayName, avatarUrl: $avatarUrl, isCurrentUser: $isCurrentUser)';
}


}

/// @nodoc
abstract mixin class _$ChatInboxParticipantResponseCopyWith<$Res> implements $ChatInboxParticipantResponseCopyWith<$Res> {
  factory _$ChatInboxParticipantResponseCopyWith(_ChatInboxParticipantResponse value, $Res Function(_ChatInboxParticipantResponse) _then) = __$ChatInboxParticipantResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? login, String? displayName, String? avatarUrl, bool isCurrentUser
});




}
/// @nodoc
class __$ChatInboxParticipantResponseCopyWithImpl<$Res>
    implements _$ChatInboxParticipantResponseCopyWith<$Res> {
  __$ChatInboxParticipantResponseCopyWithImpl(this._self, this._then);

  final _ChatInboxParticipantResponse _self;
  final $Res Function(_ChatInboxParticipantResponse) _then;

/// Create a copy of ChatInboxParticipantResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? login = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,Object? isCurrentUser = null,}) {
  return _then(_ChatInboxParticipantResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: freezed == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isCurrentUser: null == isCurrentUser ? _self.isCurrentUser : isCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatInboxUnreadCountResponse {

 int get totalUnreadCount; int get unreadConversationCount; DateTime get generatedAtUtc;
/// Create a copy of ChatInboxUnreadCountResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInboxUnreadCountResponseCopyWith<ChatInboxUnreadCountResponse> get copyWith => _$ChatInboxUnreadCountResponseCopyWithImpl<ChatInboxUnreadCountResponse>(this as ChatInboxUnreadCountResponse, _$identity);

  /// Serializes this ChatInboxUnreadCountResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInboxUnreadCountResponse&&(identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount)&&(identical(other.unreadConversationCount, unreadConversationCount) || other.unreadConversationCount == unreadConversationCount)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalUnreadCount,unreadConversationCount,generatedAtUtc);

@override
String toString() {
  return 'ChatInboxUnreadCountResponse(totalUnreadCount: $totalUnreadCount, unreadConversationCount: $unreadConversationCount, generatedAtUtc: $generatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatInboxUnreadCountResponseCopyWith<$Res>  {
  factory $ChatInboxUnreadCountResponseCopyWith(ChatInboxUnreadCountResponse value, $Res Function(ChatInboxUnreadCountResponse) _then) = _$ChatInboxUnreadCountResponseCopyWithImpl;
@useResult
$Res call({
 int totalUnreadCount, int unreadConversationCount, DateTime generatedAtUtc
});




}
/// @nodoc
class _$ChatInboxUnreadCountResponseCopyWithImpl<$Res>
    implements $ChatInboxUnreadCountResponseCopyWith<$Res> {
  _$ChatInboxUnreadCountResponseCopyWithImpl(this._self, this._then);

  final ChatInboxUnreadCountResponse _self;
  final $Res Function(ChatInboxUnreadCountResponse) _then;

/// Create a copy of ChatInboxUnreadCountResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalUnreadCount = null,Object? unreadConversationCount = null,Object? generatedAtUtc = null,}) {
  return _then(_self.copyWith(
totalUnreadCount: null == totalUnreadCount ? _self.totalUnreadCount : totalUnreadCount // ignore: cast_nullable_to_non_nullable
as int,unreadConversationCount: null == unreadConversationCount ? _self.unreadConversationCount : unreadConversationCount // ignore: cast_nullable_to_non_nullable
as int,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatInboxUnreadCountResponse].
extension ChatInboxUnreadCountResponsePatterns on ChatInboxUnreadCountResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInboxUnreadCountResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInboxUnreadCountResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInboxUnreadCountResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatInboxUnreadCountResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInboxUnreadCountResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInboxUnreadCountResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalUnreadCount,  int unreadConversationCount,  DateTime generatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInboxUnreadCountResponse() when $default != null:
return $default(_that.totalUnreadCount,_that.unreadConversationCount,_that.generatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalUnreadCount,  int unreadConversationCount,  DateTime generatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatInboxUnreadCountResponse():
return $default(_that.totalUnreadCount,_that.unreadConversationCount,_that.generatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalUnreadCount,  int unreadConversationCount,  DateTime generatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatInboxUnreadCountResponse() when $default != null:
return $default(_that.totalUnreadCount,_that.unreadConversationCount,_that.generatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatInboxUnreadCountResponse implements ChatInboxUnreadCountResponse {
  const _ChatInboxUnreadCountResponse({this.totalUnreadCount = 0, this.unreadConversationCount = 0, required this.generatedAtUtc});
  factory _ChatInboxUnreadCountResponse.fromJson(Map<String, dynamic> json) => _$ChatInboxUnreadCountResponseFromJson(json);

@override@JsonKey() final  int totalUnreadCount;
@override@JsonKey() final  int unreadConversationCount;
@override final  DateTime generatedAtUtc;

/// Create a copy of ChatInboxUnreadCountResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInboxUnreadCountResponseCopyWith<_ChatInboxUnreadCountResponse> get copyWith => __$ChatInboxUnreadCountResponseCopyWithImpl<_ChatInboxUnreadCountResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatInboxUnreadCountResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInboxUnreadCountResponse&&(identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount)&&(identical(other.unreadConversationCount, unreadConversationCount) || other.unreadConversationCount == unreadConversationCount)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalUnreadCount,unreadConversationCount,generatedAtUtc);

@override
String toString() {
  return 'ChatInboxUnreadCountResponse(totalUnreadCount: $totalUnreadCount, unreadConversationCount: $unreadConversationCount, generatedAtUtc: $generatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatInboxUnreadCountResponseCopyWith<$Res> implements $ChatInboxUnreadCountResponseCopyWith<$Res> {
  factory _$ChatInboxUnreadCountResponseCopyWith(_ChatInboxUnreadCountResponse value, $Res Function(_ChatInboxUnreadCountResponse) _then) = __$ChatInboxUnreadCountResponseCopyWithImpl;
@override @useResult
$Res call({
 int totalUnreadCount, int unreadConversationCount, DateTime generatedAtUtc
});




}
/// @nodoc
class __$ChatInboxUnreadCountResponseCopyWithImpl<$Res>
    implements _$ChatInboxUnreadCountResponseCopyWith<$Res> {
  __$ChatInboxUnreadCountResponseCopyWithImpl(this._self, this._then);

  final _ChatInboxUnreadCountResponse _self;
  final $Res Function(_ChatInboxUnreadCountResponse) _then;

/// Create a copy of ChatInboxUnreadCountResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalUnreadCount = null,Object? unreadConversationCount = null,Object? generatedAtUtc = null,}) {
  return _then(_ChatInboxUnreadCountResponse(
totalUnreadCount: null == totalUnreadCount ? _self.totalUnreadCount : totalUnreadCount // ignore: cast_nullable_to_non_nullable
as int,unreadConversationCount: null == unreadConversationCount ? _self.unreadConversationCount : unreadConversationCount // ignore: cast_nullable_to_non_nullable
as int,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatDirectoryUserResponse {

 String get userId; String get login; String get displayName; String? get avatarUrl;
/// Create a copy of ChatDirectoryUserResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDirectoryUserResponseCopyWith<ChatDirectoryUserResponse> get copyWith => _$ChatDirectoryUserResponseCopyWithImpl<ChatDirectoryUserResponse>(this as ChatDirectoryUserResponse, _$identity);

  /// Serializes this ChatDirectoryUserResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDirectoryUserResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatDirectoryUserResponse(userId: $userId, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ChatDirectoryUserResponseCopyWith<$Res>  {
  factory $ChatDirectoryUserResponseCopyWith(ChatDirectoryUserResponse value, $Res Function(ChatDirectoryUserResponse) _then) = _$ChatDirectoryUserResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String login, String displayName, String? avatarUrl
});




}
/// @nodoc
class _$ChatDirectoryUserResponseCopyWithImpl<$Res>
    implements $ChatDirectoryUserResponseCopyWith<$Res> {
  _$ChatDirectoryUserResponseCopyWithImpl(this._self, this._then);

  final ChatDirectoryUserResponse _self;
  final $Res Function(ChatDirectoryUserResponse) _then;

/// Create a copy of ChatDirectoryUserResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? login = null,Object? displayName = null,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatDirectoryUserResponse].
extension ChatDirectoryUserResponsePatterns on ChatDirectoryUserResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatDirectoryUserResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatDirectoryUserResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatDirectoryUserResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String login,  String displayName,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String login,  String displayName,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse():
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String login,  String displayName,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ChatDirectoryUserResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatDirectoryUserResponse implements ChatDirectoryUserResponse {
  const _ChatDirectoryUserResponse({required this.userId, required this.login, required this.displayName, this.avatarUrl});
  factory _ChatDirectoryUserResponse.fromJson(Map<String, dynamic> json) => _$ChatDirectoryUserResponseFromJson(json);

@override final  String userId;
@override final  String login;
@override final  String displayName;
@override final  String? avatarUrl;

/// Create a copy of ChatDirectoryUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatDirectoryUserResponseCopyWith<_ChatDirectoryUserResponse> get copyWith => __$ChatDirectoryUserResponseCopyWithImpl<_ChatDirectoryUserResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatDirectoryUserResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatDirectoryUserResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,avatarUrl);

@override
String toString() {
  return 'ChatDirectoryUserResponse(userId: $userId, login: $login, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ChatDirectoryUserResponseCopyWith<$Res> implements $ChatDirectoryUserResponseCopyWith<$Res> {
  factory _$ChatDirectoryUserResponseCopyWith(_ChatDirectoryUserResponse value, $Res Function(_ChatDirectoryUserResponse) _then) = __$ChatDirectoryUserResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String login, String displayName, String? avatarUrl
});




}
/// @nodoc
class __$ChatDirectoryUserResponseCopyWithImpl<$Res>
    implements _$ChatDirectoryUserResponseCopyWith<$Res> {
  __$ChatDirectoryUserResponseCopyWithImpl(this._self, this._then);

  final _ChatDirectoryUserResponse _self;
  final $Res Function(_ChatDirectoryUserResponse) _then;

/// Create a copy of ChatDirectoryUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? login = null,Object? displayName = null,Object? avatarUrl = freezed,}) {
  return _then(_ChatDirectoryUserResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
