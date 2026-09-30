// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

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
mixin _$ChatMessageResponse {

 String get id; String get conversationId; String get authorUserId; String get clientMessageId; String get text; String? get deltaJson; String? get replyToMessageId; String get payloadHash; int get version; DateTime get createdAtUtc; bool get isDeleted; List<ChatLinkResponse>? get links; List<ChatReactionSummaryResponse>? get reactions; List<ChatAttachmentResponse>? get attachments; String? get threadRootMessageId; bool get isEdited; DateTime? get deletedAtUtc; int get deliveredToCount; int get readByCount; Map<String, String>? get mentionLabels; ChatMessageReplyPreviewResponse? get replyPreview;
/// Create a copy of ChatMessageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageResponseCopyWith<ChatMessageResponse> get copyWith => _$ChatMessageResponseCopyWithImpl<ChatMessageResponse>(this as ChatMessageResponse, _$identity);

  /// Serializes this ChatMessageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&(identical(other.payloadHash, payloadHash) || other.payloadHash == payloadHash)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&const DeepCollectionEquality().equals(other.links, links)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.threadRootMessageId, threadRootMessageId) || other.threadRootMessageId == threadRootMessageId)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.deletedAtUtc, deletedAtUtc) || other.deletedAtUtc == deletedAtUtc)&&(identical(other.deliveredToCount, deliveredToCount) || other.deliveredToCount == deliveredToCount)&&(identical(other.readByCount, readByCount) || other.readByCount == readByCount)&&const DeepCollectionEquality().equals(other.mentionLabels, mentionLabels)&&(identical(other.replyPreview, replyPreview) || other.replyPreview == replyPreview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,conversationId,authorUserId,clientMessageId,text,deltaJson,replyToMessageId,payloadHash,version,createdAtUtc,isDeleted,const DeepCollectionEquality().hash(links),const DeepCollectionEquality().hash(reactions),const DeepCollectionEquality().hash(attachments),threadRootMessageId,isEdited,deletedAtUtc,deliveredToCount,readByCount,const DeepCollectionEquality().hash(mentionLabels),replyPreview]);

@override
String toString() {
  return 'ChatMessageResponse(id: $id, conversationId: $conversationId, authorUserId: $authorUserId, clientMessageId: $clientMessageId, text: $text, deltaJson: $deltaJson, replyToMessageId: $replyToMessageId, payloadHash: $payloadHash, version: $version, createdAtUtc: $createdAtUtc, isDeleted: $isDeleted, links: $links, reactions: $reactions, attachments: $attachments, threadRootMessageId: $threadRootMessageId, isEdited: $isEdited, deletedAtUtc: $deletedAtUtc, deliveredToCount: $deliveredToCount, readByCount: $readByCount, mentionLabels: $mentionLabels, replyPreview: $replyPreview)';
}


}

/// @nodoc
abstract mixin class $ChatMessageResponseCopyWith<$Res>  {
  factory $ChatMessageResponseCopyWith(ChatMessageResponse value, $Res Function(ChatMessageResponse) _then) = _$ChatMessageResponseCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String authorUserId, String clientMessageId, String text, String? deltaJson, String? replyToMessageId, String payloadHash, int version, DateTime createdAtUtc, bool isDeleted, List<ChatLinkResponse>? links, List<ChatReactionSummaryResponse>? reactions, List<ChatAttachmentResponse>? attachments, String? threadRootMessageId, bool isEdited, DateTime? deletedAtUtc, int deliveredToCount, int readByCount, Map<String, String>? mentionLabels, ChatMessageReplyPreviewResponse? replyPreview
});


$ChatMessageReplyPreviewResponseCopyWith<$Res>? get replyPreview;

}
/// @nodoc
class _$ChatMessageResponseCopyWithImpl<$Res>
    implements $ChatMessageResponseCopyWith<$Res> {
  _$ChatMessageResponseCopyWithImpl(this._self, this._then);

  final ChatMessageResponse _self;
  final $Res Function(ChatMessageResponse) _then;

/// Create a copy of ChatMessageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? authorUserId = null,Object? clientMessageId = null,Object? text = null,Object? deltaJson = freezed,Object? replyToMessageId = freezed,Object? payloadHash = null,Object? version = null,Object? createdAtUtc = null,Object? isDeleted = null,Object? links = freezed,Object? reactions = freezed,Object? attachments = freezed,Object? threadRootMessageId = freezed,Object? isEdited = null,Object? deletedAtUtc = freezed,Object? deliveredToCount = null,Object? readByCount = null,Object? mentionLabels = freezed,Object? replyPreview = freezed,}) {
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
as int,mentionLabels: freezed == mentionLabels ? _self.mentionLabels : mentionLabels // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,replyPreview: freezed == replyPreview ? _self.replyPreview : replyPreview // ignore: cast_nullable_to_non_nullable
as ChatMessageReplyPreviewResponse?,
  ));
}
/// Create a copy of ChatMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageReplyPreviewResponseCopyWith<$Res>? get replyPreview {
    if (_self.replyPreview == null) {
    return null;
  }

  return $ChatMessageReplyPreviewResponseCopyWith<$Res>(_self.replyPreview!, (value) {
    return _then(_self.copyWith(replyPreview: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String authorUserId,  String clientMessageId,  String text,  String? deltaJson,  String? replyToMessageId,  String payloadHash,  int version,  DateTime createdAtUtc,  bool isDeleted,  List<ChatLinkResponse>? links,  List<ChatReactionSummaryResponse>? reactions,  List<ChatAttachmentResponse>? attachments,  String? threadRootMessageId,  bool isEdited,  DateTime? deletedAtUtc,  int deliveredToCount,  int readByCount,  Map<String, String>? mentionLabels,  ChatMessageReplyPreviewResponse? replyPreview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.authorUserId,_that.clientMessageId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.payloadHash,_that.version,_that.createdAtUtc,_that.isDeleted,_that.links,_that.reactions,_that.attachments,_that.threadRootMessageId,_that.isEdited,_that.deletedAtUtc,_that.deliveredToCount,_that.readByCount,_that.mentionLabels,_that.replyPreview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String authorUserId,  String clientMessageId,  String text,  String? deltaJson,  String? replyToMessageId,  String payloadHash,  int version,  DateTime createdAtUtc,  bool isDeleted,  List<ChatLinkResponse>? links,  List<ChatReactionSummaryResponse>? reactions,  List<ChatAttachmentResponse>? attachments,  String? threadRootMessageId,  bool isEdited,  DateTime? deletedAtUtc,  int deliveredToCount,  int readByCount,  Map<String, String>? mentionLabels,  ChatMessageReplyPreviewResponse? replyPreview)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageResponse():
return $default(_that.id,_that.conversationId,_that.authorUserId,_that.clientMessageId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.payloadHash,_that.version,_that.createdAtUtc,_that.isDeleted,_that.links,_that.reactions,_that.attachments,_that.threadRootMessageId,_that.isEdited,_that.deletedAtUtc,_that.deliveredToCount,_that.readByCount,_that.mentionLabels,_that.replyPreview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String authorUserId,  String clientMessageId,  String text,  String? deltaJson,  String? replyToMessageId,  String payloadHash,  int version,  DateTime createdAtUtc,  bool isDeleted,  List<ChatLinkResponse>? links,  List<ChatReactionSummaryResponse>? reactions,  List<ChatAttachmentResponse>? attachments,  String? threadRootMessageId,  bool isEdited,  DateTime? deletedAtUtc,  int deliveredToCount,  int readByCount,  Map<String, String>? mentionLabels,  ChatMessageReplyPreviewResponse? replyPreview)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.authorUserId,_that.clientMessageId,_that.text,_that.deltaJson,_that.replyToMessageId,_that.payloadHash,_that.version,_that.createdAtUtc,_that.isDeleted,_that.links,_that.reactions,_that.attachments,_that.threadRootMessageId,_that.isEdited,_that.deletedAtUtc,_that.deliveredToCount,_that.readByCount,_that.mentionLabels,_that.replyPreview);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageResponse implements ChatMessageResponse {
  const _ChatMessageResponse({required this.id, required this.conversationId, required this.authorUserId, required this.clientMessageId, required this.text, this.deltaJson, this.replyToMessageId, required this.payloadHash, required this.version, required this.createdAtUtc, required this.isDeleted, this.links, this.reactions, this.attachments, this.threadRootMessageId, this.isEdited = false, this.deletedAtUtc, this.deliveredToCount = 0, this.readByCount = 0, this.mentionLabels, this.replyPreview});
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
@override final  Map<String, String>? mentionLabels;
@override final  ChatMessageReplyPreviewResponse? replyPreview;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.clientMessageId, clientMessageId) || other.clientMessageId == clientMessageId)&&(identical(other.text, text) || other.text == text)&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.replyToMessageId, replyToMessageId) || other.replyToMessageId == replyToMessageId)&&(identical(other.payloadHash, payloadHash) || other.payloadHash == payloadHash)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&const DeepCollectionEquality().equals(other.links, links)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.threadRootMessageId, threadRootMessageId) || other.threadRootMessageId == threadRootMessageId)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.deletedAtUtc, deletedAtUtc) || other.deletedAtUtc == deletedAtUtc)&&(identical(other.deliveredToCount, deliveredToCount) || other.deliveredToCount == deliveredToCount)&&(identical(other.readByCount, readByCount) || other.readByCount == readByCount)&&const DeepCollectionEquality().equals(other.mentionLabels, mentionLabels)&&(identical(other.replyPreview, replyPreview) || other.replyPreview == replyPreview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,conversationId,authorUserId,clientMessageId,text,deltaJson,replyToMessageId,payloadHash,version,createdAtUtc,isDeleted,const DeepCollectionEquality().hash(links),const DeepCollectionEquality().hash(reactions),const DeepCollectionEquality().hash(attachments),threadRootMessageId,isEdited,deletedAtUtc,deliveredToCount,readByCount,const DeepCollectionEquality().hash(mentionLabels),replyPreview]);

@override
String toString() {
  return 'ChatMessageResponse(id: $id, conversationId: $conversationId, authorUserId: $authorUserId, clientMessageId: $clientMessageId, text: $text, deltaJson: $deltaJson, replyToMessageId: $replyToMessageId, payloadHash: $payloadHash, version: $version, createdAtUtc: $createdAtUtc, isDeleted: $isDeleted, links: $links, reactions: $reactions, attachments: $attachments, threadRootMessageId: $threadRootMessageId, isEdited: $isEdited, deletedAtUtc: $deletedAtUtc, deliveredToCount: $deliveredToCount, readByCount: $readByCount, mentionLabels: $mentionLabels, replyPreview: $replyPreview)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageResponseCopyWith<$Res> implements $ChatMessageResponseCopyWith<$Res> {
  factory _$ChatMessageResponseCopyWith(_ChatMessageResponse value, $Res Function(_ChatMessageResponse) _then) = __$ChatMessageResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String authorUserId, String clientMessageId, String text, String? deltaJson, String? replyToMessageId, String payloadHash, int version, DateTime createdAtUtc, bool isDeleted, List<ChatLinkResponse>? links, List<ChatReactionSummaryResponse>? reactions, List<ChatAttachmentResponse>? attachments, String? threadRootMessageId, bool isEdited, DateTime? deletedAtUtc, int deliveredToCount, int readByCount, Map<String, String>? mentionLabels, ChatMessageReplyPreviewResponse? replyPreview
});


@override $ChatMessageReplyPreviewResponseCopyWith<$Res>? get replyPreview;

}
/// @nodoc
class __$ChatMessageResponseCopyWithImpl<$Res>
    implements _$ChatMessageResponseCopyWith<$Res> {
  __$ChatMessageResponseCopyWithImpl(this._self, this._then);

  final _ChatMessageResponse _self;
  final $Res Function(_ChatMessageResponse) _then;

/// Create a copy of ChatMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? authorUserId = null,Object? clientMessageId = null,Object? text = null,Object? deltaJson = freezed,Object? replyToMessageId = freezed,Object? payloadHash = null,Object? version = null,Object? createdAtUtc = null,Object? isDeleted = null,Object? links = freezed,Object? reactions = freezed,Object? attachments = freezed,Object? threadRootMessageId = freezed,Object? isEdited = null,Object? deletedAtUtc = freezed,Object? deliveredToCount = null,Object? readByCount = null,Object? mentionLabels = freezed,Object? replyPreview = freezed,}) {
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
as int,mentionLabels: freezed == mentionLabels ? _self.mentionLabels : mentionLabels // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,replyPreview: freezed == replyPreview ? _self.replyPreview : replyPreview // ignore: cast_nullable_to_non_nullable
as ChatMessageReplyPreviewResponse?,
  ));
}

/// Create a copy of ChatMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageReplyPreviewResponseCopyWith<$Res>? get replyPreview {
    if (_self.replyPreview == null) {
    return null;
  }

  return $ChatMessageReplyPreviewResponseCopyWith<$Res>(_self.replyPreview!, (value) {
    return _then(_self.copyWith(replyPreview: value));
  });
}
}


/// @nodoc
mixin _$ChatMessageReplyPreviewResponse {

 String get messageId; String get authorUserId; String? get authorLabel; String get text; bool get isDeleted; bool get hasAttachments; Map<String, String>? get mentionLabels;
/// Create a copy of ChatMessageReplyPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageReplyPreviewResponseCopyWith<ChatMessageReplyPreviewResponse> get copyWith => _$ChatMessageReplyPreviewResponseCopyWithImpl<ChatMessageReplyPreviewResponse>(this as ChatMessageReplyPreviewResponse, _$identity);

  /// Serializes this ChatMessageReplyPreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageReplyPreviewResponse&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.authorLabel, authorLabel) || other.authorLabel == authorLabel)&&(identical(other.text, text) || other.text == text)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.hasAttachments, hasAttachments) || other.hasAttachments == hasAttachments)&&const DeepCollectionEquality().equals(other.mentionLabels, mentionLabels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,authorUserId,authorLabel,text,isDeleted,hasAttachments,const DeepCollectionEquality().hash(mentionLabels));

@override
String toString() {
  return 'ChatMessageReplyPreviewResponse(messageId: $messageId, authorUserId: $authorUserId, authorLabel: $authorLabel, text: $text, isDeleted: $isDeleted, hasAttachments: $hasAttachments, mentionLabels: $mentionLabels)';
}


}

/// @nodoc
abstract mixin class $ChatMessageReplyPreviewResponseCopyWith<$Res>  {
  factory $ChatMessageReplyPreviewResponseCopyWith(ChatMessageReplyPreviewResponse value, $Res Function(ChatMessageReplyPreviewResponse) _then) = _$ChatMessageReplyPreviewResponseCopyWithImpl;
@useResult
$Res call({
 String messageId, String authorUserId, String? authorLabel, String text, bool isDeleted, bool hasAttachments, Map<String, String>? mentionLabels
});




}
/// @nodoc
class _$ChatMessageReplyPreviewResponseCopyWithImpl<$Res>
    implements $ChatMessageReplyPreviewResponseCopyWith<$Res> {
  _$ChatMessageReplyPreviewResponseCopyWithImpl(this._self, this._then);

  final ChatMessageReplyPreviewResponse _self;
  final $Res Function(ChatMessageReplyPreviewResponse) _then;

/// Create a copy of ChatMessageReplyPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? authorUserId = null,Object? authorLabel = freezed,Object? text = null,Object? isDeleted = null,Object? hasAttachments = null,Object? mentionLabels = freezed,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,authorLabel: freezed == authorLabel ? _self.authorLabel : authorLabel // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,hasAttachments: null == hasAttachments ? _self.hasAttachments : hasAttachments // ignore: cast_nullable_to_non_nullable
as bool,mentionLabels: freezed == mentionLabels ? _self.mentionLabels : mentionLabels // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageReplyPreviewResponse].
extension ChatMessageReplyPreviewResponsePatterns on ChatMessageReplyPreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageReplyPreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageReplyPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageReplyPreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageReplyPreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageReplyPreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageReplyPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String messageId,  String authorUserId,  String? authorLabel,  String text,  bool isDeleted,  bool hasAttachments,  Map<String, String>? mentionLabels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageReplyPreviewResponse() when $default != null:
return $default(_that.messageId,_that.authorUserId,_that.authorLabel,_that.text,_that.isDeleted,_that.hasAttachments,_that.mentionLabels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String messageId,  String authorUserId,  String? authorLabel,  String text,  bool isDeleted,  bool hasAttachments,  Map<String, String>? mentionLabels)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageReplyPreviewResponse():
return $default(_that.messageId,_that.authorUserId,_that.authorLabel,_that.text,_that.isDeleted,_that.hasAttachments,_that.mentionLabels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String messageId,  String authorUserId,  String? authorLabel,  String text,  bool isDeleted,  bool hasAttachments,  Map<String, String>? mentionLabels)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageReplyPreviewResponse() when $default != null:
return $default(_that.messageId,_that.authorUserId,_that.authorLabel,_that.text,_that.isDeleted,_that.hasAttachments,_that.mentionLabels);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageReplyPreviewResponse implements ChatMessageReplyPreviewResponse {
  const _ChatMessageReplyPreviewResponse({required this.messageId, required this.authorUserId, this.authorLabel, required this.text, required this.isDeleted, required this.hasAttachments, this.mentionLabels});
  factory _ChatMessageReplyPreviewResponse.fromJson(Map<String, dynamic> json) => _$ChatMessageReplyPreviewResponseFromJson(json);

@override final  String messageId;
@override final  String authorUserId;
@override final  String? authorLabel;
@override final  String text;
@override final  bool isDeleted;
@override final  bool hasAttachments;
@override final  Map<String, String>? mentionLabels;

/// Create a copy of ChatMessageReplyPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageReplyPreviewResponseCopyWith<_ChatMessageReplyPreviewResponse> get copyWith => __$ChatMessageReplyPreviewResponseCopyWithImpl<_ChatMessageReplyPreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageReplyPreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageReplyPreviewResponse&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.authorUserId, authorUserId) || other.authorUserId == authorUserId)&&(identical(other.authorLabel, authorLabel) || other.authorLabel == authorLabel)&&(identical(other.text, text) || other.text == text)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.hasAttachments, hasAttachments) || other.hasAttachments == hasAttachments)&&const DeepCollectionEquality().equals(other.mentionLabels, mentionLabels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,authorUserId,authorLabel,text,isDeleted,hasAttachments,const DeepCollectionEquality().hash(mentionLabels));

@override
String toString() {
  return 'ChatMessageReplyPreviewResponse(messageId: $messageId, authorUserId: $authorUserId, authorLabel: $authorLabel, text: $text, isDeleted: $isDeleted, hasAttachments: $hasAttachments, mentionLabels: $mentionLabels)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageReplyPreviewResponseCopyWith<$Res> implements $ChatMessageReplyPreviewResponseCopyWith<$Res> {
  factory _$ChatMessageReplyPreviewResponseCopyWith(_ChatMessageReplyPreviewResponse value, $Res Function(_ChatMessageReplyPreviewResponse) _then) = __$ChatMessageReplyPreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 String messageId, String authorUserId, String? authorLabel, String text, bool isDeleted, bool hasAttachments, Map<String, String>? mentionLabels
});




}
/// @nodoc
class __$ChatMessageReplyPreviewResponseCopyWithImpl<$Res>
    implements _$ChatMessageReplyPreviewResponseCopyWith<$Res> {
  __$ChatMessageReplyPreviewResponseCopyWithImpl(this._self, this._then);

  final _ChatMessageReplyPreviewResponse _self;
  final $Res Function(_ChatMessageReplyPreviewResponse) _then;

/// Create a copy of ChatMessageReplyPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? authorUserId = null,Object? authorLabel = freezed,Object? text = null,Object? isDeleted = null,Object? hasAttachments = null,Object? mentionLabels = freezed,}) {
  return _then(_ChatMessageReplyPreviewResponse(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,authorUserId: null == authorUserId ? _self.authorUserId : authorUserId // ignore: cast_nullable_to_non_nullable
as String,authorLabel: freezed == authorLabel ? _self.authorLabel : authorLabel // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,hasAttachments: null == hasAttachments ? _self.hasAttachments : hasAttachments // ignore: cast_nullable_to_non_nullable
as bool,mentionLabels: freezed == mentionLabels ? _self.mentionLabels : mentionLabels // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
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

// dart format on
