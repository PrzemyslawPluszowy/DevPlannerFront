// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_inbox_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

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

// dart format on
