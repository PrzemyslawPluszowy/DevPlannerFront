// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_conversation_models.dart';

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

// dart format on
