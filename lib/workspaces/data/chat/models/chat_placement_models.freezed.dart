// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_placement_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

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

// dart format on
