// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_search_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

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

// dart format on
