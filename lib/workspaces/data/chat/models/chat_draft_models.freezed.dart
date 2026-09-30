// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_draft_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

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

// dart format on
