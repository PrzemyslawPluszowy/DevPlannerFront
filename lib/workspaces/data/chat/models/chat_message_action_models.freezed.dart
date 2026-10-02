// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_action_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

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

 String get id; String get messageId; String get conversationId; String get userId; String? get note; DateTime get createdAtUtc; String? get messageText;
/// Create a copy of ChatBookmarkResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatBookmarkResponseCopyWith<ChatBookmarkResponse> get copyWith => _$ChatBookmarkResponseCopyWithImpl<ChatBookmarkResponse>(this as ChatBookmarkResponse, _$identity);

  /// Serializes this ChatBookmarkResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatBookmarkResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.messageText, messageText) || other.messageText == messageText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,conversationId,userId,note,createdAtUtc,messageText);

@override
String toString() {
  return 'ChatBookmarkResponse(id: $id, messageId: $messageId, conversationId: $conversationId, userId: $userId, note: $note, createdAtUtc: $createdAtUtc, messageText: $messageText)';
}


}

/// @nodoc
abstract mixin class $ChatBookmarkResponseCopyWith<$Res>  {
  factory $ChatBookmarkResponseCopyWith(ChatBookmarkResponse value, $Res Function(ChatBookmarkResponse) _then) = _$ChatBookmarkResponseCopyWithImpl;
@useResult
$Res call({
 String id, String messageId, String conversationId, String userId, String? note, DateTime createdAtUtc, String? messageText
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messageId = null,Object? conversationId = null,Object? userId = null,Object? note = freezed,Object? createdAtUtc = null,Object? messageText = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,messageText: freezed == messageText ? _self.messageText : messageText // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messageId,  String conversationId,  String userId,  String? note,  DateTime createdAtUtc,  String? messageText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatBookmarkResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.conversationId,_that.userId,_that.note,_that.createdAtUtc,_that.messageText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messageId,  String conversationId,  String userId,  String? note,  DateTime createdAtUtc,  String? messageText)  $default,) {final _that = this;
switch (_that) {
case _ChatBookmarkResponse():
return $default(_that.id,_that.messageId,_that.conversationId,_that.userId,_that.note,_that.createdAtUtc,_that.messageText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messageId,  String conversationId,  String userId,  String? note,  DateTime createdAtUtc,  String? messageText)?  $default,) {final _that = this;
switch (_that) {
case _ChatBookmarkResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.conversationId,_that.userId,_that.note,_that.createdAtUtc,_that.messageText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatBookmarkResponse implements ChatBookmarkResponse {
  const _ChatBookmarkResponse({required this.id, required this.messageId, required this.conversationId, required this.userId, this.note, required this.createdAtUtc, this.messageText});
  factory _ChatBookmarkResponse.fromJson(Map<String, dynamic> json) => _$ChatBookmarkResponseFromJson(json);

@override final  String id;
@override final  String messageId;
@override final  String conversationId;
@override final  String userId;
@override final  String? note;
@override final  DateTime createdAtUtc;
@override final  String? messageText;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatBookmarkResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.messageText, messageText) || other.messageText == messageText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,conversationId,userId,note,createdAtUtc,messageText);

@override
String toString() {
  return 'ChatBookmarkResponse(id: $id, messageId: $messageId, conversationId: $conversationId, userId: $userId, note: $note, createdAtUtc: $createdAtUtc, messageText: $messageText)';
}


}

/// @nodoc
abstract mixin class _$ChatBookmarkResponseCopyWith<$Res> implements $ChatBookmarkResponseCopyWith<$Res> {
  factory _$ChatBookmarkResponseCopyWith(_ChatBookmarkResponse value, $Res Function(_ChatBookmarkResponse) _then) = __$ChatBookmarkResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String messageId, String conversationId, String userId, String? note, DateTime createdAtUtc, String? messageText
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messageId = null,Object? conversationId = null,Object? userId = null,Object? note = freezed,Object? createdAtUtc = null,Object? messageText = freezed,}) {
  return _then(_ChatBookmarkResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,messageText: freezed == messageText ? _self.messageText : messageText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChatPinnedMessageResponse {

 String get id; String get conversationId; String get messageId; String get pinnedByUserId; DateTime get pinnedAtUtc; String? get messageText;
/// Create a copy of ChatPinnedMessageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatPinnedMessageResponseCopyWith<ChatPinnedMessageResponse> get copyWith => _$ChatPinnedMessageResponseCopyWithImpl<ChatPinnedMessageResponse>(this as ChatPinnedMessageResponse, _$identity);

  /// Serializes this ChatPinnedMessageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatPinnedMessageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.pinnedByUserId, pinnedByUserId) || other.pinnedByUserId == pinnedByUserId)&&(identical(other.pinnedAtUtc, pinnedAtUtc) || other.pinnedAtUtc == pinnedAtUtc)&&(identical(other.messageText, messageText) || other.messageText == messageText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,messageId,pinnedByUserId,pinnedAtUtc,messageText);

@override
String toString() {
  return 'ChatPinnedMessageResponse(id: $id, conversationId: $conversationId, messageId: $messageId, pinnedByUserId: $pinnedByUserId, pinnedAtUtc: $pinnedAtUtc, messageText: $messageText)';
}


}

/// @nodoc
abstract mixin class $ChatPinnedMessageResponseCopyWith<$Res>  {
  factory $ChatPinnedMessageResponseCopyWith(ChatPinnedMessageResponse value, $Res Function(ChatPinnedMessageResponse) _then) = _$ChatPinnedMessageResponseCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String messageId, String pinnedByUserId, DateTime pinnedAtUtc, String? messageText
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? messageId = null,Object? pinnedByUserId = null,Object? pinnedAtUtc = null,Object? messageText = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,pinnedByUserId: null == pinnedByUserId ? _self.pinnedByUserId : pinnedByUserId // ignore: cast_nullable_to_non_nullable
as String,pinnedAtUtc: null == pinnedAtUtc ? _self.pinnedAtUtc : pinnedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,messageText: freezed == messageText ? _self.messageText : messageText // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String messageId,  String pinnedByUserId,  DateTime pinnedAtUtc,  String? messageText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatPinnedMessageResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.messageId,_that.pinnedByUserId,_that.pinnedAtUtc,_that.messageText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String messageId,  String pinnedByUserId,  DateTime pinnedAtUtc,  String? messageText)  $default,) {final _that = this;
switch (_that) {
case _ChatPinnedMessageResponse():
return $default(_that.id,_that.conversationId,_that.messageId,_that.pinnedByUserId,_that.pinnedAtUtc,_that.messageText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String messageId,  String pinnedByUserId,  DateTime pinnedAtUtc,  String? messageText)?  $default,) {final _that = this;
switch (_that) {
case _ChatPinnedMessageResponse() when $default != null:
return $default(_that.id,_that.conversationId,_that.messageId,_that.pinnedByUserId,_that.pinnedAtUtc,_that.messageText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatPinnedMessageResponse implements ChatPinnedMessageResponse {
  const _ChatPinnedMessageResponse({required this.id, required this.conversationId, required this.messageId, required this.pinnedByUserId, required this.pinnedAtUtc, this.messageText});
  factory _ChatPinnedMessageResponse.fromJson(Map<String, dynamic> json) => _$ChatPinnedMessageResponseFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String messageId;
@override final  String pinnedByUserId;
@override final  DateTime pinnedAtUtc;
@override final  String? messageText;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatPinnedMessageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.pinnedByUserId, pinnedByUserId) || other.pinnedByUserId == pinnedByUserId)&&(identical(other.pinnedAtUtc, pinnedAtUtc) || other.pinnedAtUtc == pinnedAtUtc)&&(identical(other.messageText, messageText) || other.messageText == messageText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,messageId,pinnedByUserId,pinnedAtUtc,messageText);

@override
String toString() {
  return 'ChatPinnedMessageResponse(id: $id, conversationId: $conversationId, messageId: $messageId, pinnedByUserId: $pinnedByUserId, pinnedAtUtc: $pinnedAtUtc, messageText: $messageText)';
}


}

/// @nodoc
abstract mixin class _$ChatPinnedMessageResponseCopyWith<$Res> implements $ChatPinnedMessageResponseCopyWith<$Res> {
  factory _$ChatPinnedMessageResponseCopyWith(_ChatPinnedMessageResponse value, $Res Function(_ChatPinnedMessageResponse) _then) = __$ChatPinnedMessageResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String messageId, String pinnedByUserId, DateTime pinnedAtUtc, String? messageText
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? messageId = null,Object? pinnedByUserId = null,Object? pinnedAtUtc = null,Object? messageText = freezed,}) {
  return _then(_ChatPinnedMessageResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,pinnedByUserId: null == pinnedByUserId ? _self.pinnedByUserId : pinnedByUserId // ignore: cast_nullable_to_non_nullable
as String,pinnedAtUtc: null == pinnedAtUtc ? _self.pinnedAtUtc : pinnedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,messageText: freezed == messageText ? _self.messageText : messageText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
