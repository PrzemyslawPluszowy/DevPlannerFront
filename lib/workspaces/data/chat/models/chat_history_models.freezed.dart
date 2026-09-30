// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_history_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

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

// dart format on
