// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_attachment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

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
mixin _$CopyPrivateFileToChatAttachmentResponse {

 String get storageFileId; String get sessionId; String get fileName; String get mimeType; int get fileSizeBytes;
/// Create a copy of CopyPrivateFileToChatAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CopyPrivateFileToChatAttachmentResponseCopyWith<CopyPrivateFileToChatAttachmentResponse> get copyWith => _$CopyPrivateFileToChatAttachmentResponseCopyWithImpl<CopyPrivateFileToChatAttachmentResponse>(this as CopyPrivateFileToChatAttachmentResponse, _$identity);

  /// Serializes this CopyPrivateFileToChatAttachmentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CopyPrivateFileToChatAttachmentResponse&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageFileId,sessionId,fileName,mimeType,fileSizeBytes);

@override
String toString() {
  return 'CopyPrivateFileToChatAttachmentResponse(storageFileId: $storageFileId, sessionId: $sessionId, fileName: $fileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes)';
}


}

/// @nodoc
abstract mixin class $CopyPrivateFileToChatAttachmentResponseCopyWith<$Res>  {
  factory $CopyPrivateFileToChatAttachmentResponseCopyWith(CopyPrivateFileToChatAttachmentResponse value, $Res Function(CopyPrivateFileToChatAttachmentResponse) _then) = _$CopyPrivateFileToChatAttachmentResponseCopyWithImpl;
@useResult
$Res call({
 String storageFileId, String sessionId, String fileName, String mimeType, int fileSizeBytes
});




}
/// @nodoc
class _$CopyPrivateFileToChatAttachmentResponseCopyWithImpl<$Res>
    implements $CopyPrivateFileToChatAttachmentResponseCopyWith<$Res> {
  _$CopyPrivateFileToChatAttachmentResponseCopyWithImpl(this._self, this._then);

  final CopyPrivateFileToChatAttachmentResponse _self;
  final $Res Function(CopyPrivateFileToChatAttachmentResponse) _then;

/// Create a copy of CopyPrivateFileToChatAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storageFileId = null,Object? sessionId = null,Object? fileName = null,Object? mimeType = null,Object? fileSizeBytes = null,}) {
  return _then(_self.copyWith(
storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CopyPrivateFileToChatAttachmentResponse].
extension CopyPrivateFileToChatAttachmentResponsePatterns on CopyPrivateFileToChatAttachmentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CopyPrivateFileToChatAttachmentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CopyPrivateFileToChatAttachmentResponse value)  $default,){
final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CopyPrivateFileToChatAttachmentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storageFileId,  String sessionId,  String fileName,  String mimeType,  int fileSizeBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentResponse() when $default != null:
return $default(_that.storageFileId,_that.sessionId,_that.fileName,_that.mimeType,_that.fileSizeBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storageFileId,  String sessionId,  String fileName,  String mimeType,  int fileSizeBytes)  $default,) {final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentResponse():
return $default(_that.storageFileId,_that.sessionId,_that.fileName,_that.mimeType,_that.fileSizeBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storageFileId,  String sessionId,  String fileName,  String mimeType,  int fileSizeBytes)?  $default,) {final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentResponse() when $default != null:
return $default(_that.storageFileId,_that.sessionId,_that.fileName,_that.mimeType,_that.fileSizeBytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CopyPrivateFileToChatAttachmentResponse implements CopyPrivateFileToChatAttachmentResponse {
  const _CopyPrivateFileToChatAttachmentResponse({required this.storageFileId, required this.sessionId, required this.fileName, required this.mimeType, required this.fileSizeBytes});
  factory _CopyPrivateFileToChatAttachmentResponse.fromJson(Map<String, dynamic> json) => _$CopyPrivateFileToChatAttachmentResponseFromJson(json);

@override final  String storageFileId;
@override final  String sessionId;
@override final  String fileName;
@override final  String mimeType;
@override final  int fileSizeBytes;

/// Create a copy of CopyPrivateFileToChatAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CopyPrivateFileToChatAttachmentResponseCopyWith<_CopyPrivateFileToChatAttachmentResponse> get copyWith => __$CopyPrivateFileToChatAttachmentResponseCopyWithImpl<_CopyPrivateFileToChatAttachmentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CopyPrivateFileToChatAttachmentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CopyPrivateFileToChatAttachmentResponse&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageFileId,sessionId,fileName,mimeType,fileSizeBytes);

@override
String toString() {
  return 'CopyPrivateFileToChatAttachmentResponse(storageFileId: $storageFileId, sessionId: $sessionId, fileName: $fileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes)';
}


}

/// @nodoc
abstract mixin class _$CopyPrivateFileToChatAttachmentResponseCopyWith<$Res> implements $CopyPrivateFileToChatAttachmentResponseCopyWith<$Res> {
  factory _$CopyPrivateFileToChatAttachmentResponseCopyWith(_CopyPrivateFileToChatAttachmentResponse value, $Res Function(_CopyPrivateFileToChatAttachmentResponse) _then) = __$CopyPrivateFileToChatAttachmentResponseCopyWithImpl;
@override @useResult
$Res call({
 String storageFileId, String sessionId, String fileName, String mimeType, int fileSizeBytes
});




}
/// @nodoc
class __$CopyPrivateFileToChatAttachmentResponseCopyWithImpl<$Res>
    implements _$CopyPrivateFileToChatAttachmentResponseCopyWith<$Res> {
  __$CopyPrivateFileToChatAttachmentResponseCopyWithImpl(this._self, this._then);

  final _CopyPrivateFileToChatAttachmentResponse _self;
  final $Res Function(_CopyPrivateFileToChatAttachmentResponse) _then;

/// Create a copy of CopyPrivateFileToChatAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storageFileId = null,Object? sessionId = null,Object? fileName = null,Object? mimeType = null,Object? fileSizeBytes = null,}) {
  return _then(_CopyPrivateFileToChatAttachmentResponse(
storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CopyPrivateFileToChatAttachmentPayload {

 String get storageFileId;
/// Create a copy of CopyPrivateFileToChatAttachmentPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CopyPrivateFileToChatAttachmentPayloadCopyWith<CopyPrivateFileToChatAttachmentPayload> get copyWith => _$CopyPrivateFileToChatAttachmentPayloadCopyWithImpl<CopyPrivateFileToChatAttachmentPayload>(this as CopyPrivateFileToChatAttachmentPayload, _$identity);

  /// Serializes this CopyPrivateFileToChatAttachmentPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CopyPrivateFileToChatAttachmentPayload&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageFileId);

@override
String toString() {
  return 'CopyPrivateFileToChatAttachmentPayload(storageFileId: $storageFileId)';
}


}

/// @nodoc
abstract mixin class $CopyPrivateFileToChatAttachmentPayloadCopyWith<$Res>  {
  factory $CopyPrivateFileToChatAttachmentPayloadCopyWith(CopyPrivateFileToChatAttachmentPayload value, $Res Function(CopyPrivateFileToChatAttachmentPayload) _then) = _$CopyPrivateFileToChatAttachmentPayloadCopyWithImpl;
@useResult
$Res call({
 String storageFileId
});




}
/// @nodoc
class _$CopyPrivateFileToChatAttachmentPayloadCopyWithImpl<$Res>
    implements $CopyPrivateFileToChatAttachmentPayloadCopyWith<$Res> {
  _$CopyPrivateFileToChatAttachmentPayloadCopyWithImpl(this._self, this._then);

  final CopyPrivateFileToChatAttachmentPayload _self;
  final $Res Function(CopyPrivateFileToChatAttachmentPayload) _then;

/// Create a copy of CopyPrivateFileToChatAttachmentPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storageFileId = null,}) {
  return _then(_self.copyWith(
storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CopyPrivateFileToChatAttachmentPayload].
extension CopyPrivateFileToChatAttachmentPayloadPatterns on CopyPrivateFileToChatAttachmentPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CopyPrivateFileToChatAttachmentPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CopyPrivateFileToChatAttachmentPayload value)  $default,){
final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CopyPrivateFileToChatAttachmentPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storageFileId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentPayload() when $default != null:
return $default(_that.storageFileId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storageFileId)  $default,) {final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentPayload():
return $default(_that.storageFileId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storageFileId)?  $default,) {final _that = this;
switch (_that) {
case _CopyPrivateFileToChatAttachmentPayload() when $default != null:
return $default(_that.storageFileId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CopyPrivateFileToChatAttachmentPayload implements CopyPrivateFileToChatAttachmentPayload {
  const _CopyPrivateFileToChatAttachmentPayload({required this.storageFileId});
  factory _CopyPrivateFileToChatAttachmentPayload.fromJson(Map<String, dynamic> json) => _$CopyPrivateFileToChatAttachmentPayloadFromJson(json);

@override final  String storageFileId;

/// Create a copy of CopyPrivateFileToChatAttachmentPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CopyPrivateFileToChatAttachmentPayloadCopyWith<_CopyPrivateFileToChatAttachmentPayload> get copyWith => __$CopyPrivateFileToChatAttachmentPayloadCopyWithImpl<_CopyPrivateFileToChatAttachmentPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CopyPrivateFileToChatAttachmentPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CopyPrivateFileToChatAttachmentPayload&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageFileId);

@override
String toString() {
  return 'CopyPrivateFileToChatAttachmentPayload(storageFileId: $storageFileId)';
}


}

/// @nodoc
abstract mixin class _$CopyPrivateFileToChatAttachmentPayloadCopyWith<$Res> implements $CopyPrivateFileToChatAttachmentPayloadCopyWith<$Res> {
  factory _$CopyPrivateFileToChatAttachmentPayloadCopyWith(_CopyPrivateFileToChatAttachmentPayload value, $Res Function(_CopyPrivateFileToChatAttachmentPayload) _then) = __$CopyPrivateFileToChatAttachmentPayloadCopyWithImpl;
@override @useResult
$Res call({
 String storageFileId
});




}
/// @nodoc
class __$CopyPrivateFileToChatAttachmentPayloadCopyWithImpl<$Res>
    implements _$CopyPrivateFileToChatAttachmentPayloadCopyWith<$Res> {
  __$CopyPrivateFileToChatAttachmentPayloadCopyWithImpl(this._self, this._then);

  final _CopyPrivateFileToChatAttachmentPayload _self;
  final $Res Function(_CopyPrivateFileToChatAttachmentPayload) _then;

/// Create a copy of CopyPrivateFileToChatAttachmentPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storageFileId = null,}) {
  return _then(_CopyPrivateFileToChatAttachmentPayload(
storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,
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

 String get id; String get messageId; String get storageFileId; String get attachedByUserId; int get position; DateTime get createdAtUtc; String? get fileName; int? get fileSizeBytes; String? get contentType; bool get isAvailable; bool get isOfficeDocument;
/// Create a copy of ChatAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatAttachmentResponseCopyWith<ChatAttachmentResponse> get copyWith => _$ChatAttachmentResponseCopyWithImpl<ChatAttachmentResponse>(this as ChatAttachmentResponse, _$identity);

  /// Serializes this ChatAttachmentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatAttachmentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.attachedByUserId, attachedByUserId) || other.attachedByUserId == attachedByUserId)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isOfficeDocument, isOfficeDocument) || other.isOfficeDocument == isOfficeDocument));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,storageFileId,attachedByUserId,position,createdAtUtc,fileName,fileSizeBytes,contentType,isAvailable,isOfficeDocument);

@override
String toString() {
  return 'ChatAttachmentResponse(id: $id, messageId: $messageId, storageFileId: $storageFileId, attachedByUserId: $attachedByUserId, position: $position, createdAtUtc: $createdAtUtc, fileName: $fileName, fileSizeBytes: $fileSizeBytes, contentType: $contentType, isAvailable: $isAvailable, isOfficeDocument: $isOfficeDocument)';
}


}

/// @nodoc
abstract mixin class $ChatAttachmentResponseCopyWith<$Res>  {
  factory $ChatAttachmentResponseCopyWith(ChatAttachmentResponse value, $Res Function(ChatAttachmentResponse) _then) = _$ChatAttachmentResponseCopyWithImpl;
@useResult
$Res call({
 String id, String messageId, String storageFileId, String attachedByUserId, int position, DateTime createdAtUtc, String? fileName, int? fileSizeBytes, String? contentType, bool isAvailable, bool isOfficeDocument
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messageId = null,Object? storageFileId = null,Object? attachedByUserId = null,Object? position = null,Object? createdAtUtc = null,Object? fileName = freezed,Object? fileSizeBytes = freezed,Object? contentType = freezed,Object? isAvailable = null,Object? isOfficeDocument = null,}) {
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
as bool,isOfficeDocument: null == isOfficeDocument ? _self.isOfficeDocument : isOfficeDocument // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String messageId,  String storageFileId,  String attachedByUserId,  int position,  DateTime createdAtUtc,  String? fileName,  int? fileSizeBytes,  String? contentType,  bool isAvailable,  bool isOfficeDocument)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatAttachmentResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.storageFileId,_that.attachedByUserId,_that.position,_that.createdAtUtc,_that.fileName,_that.fileSizeBytes,_that.contentType,_that.isAvailable,_that.isOfficeDocument);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String messageId,  String storageFileId,  String attachedByUserId,  int position,  DateTime createdAtUtc,  String? fileName,  int? fileSizeBytes,  String? contentType,  bool isAvailable,  bool isOfficeDocument)  $default,) {final _that = this;
switch (_that) {
case _ChatAttachmentResponse():
return $default(_that.id,_that.messageId,_that.storageFileId,_that.attachedByUserId,_that.position,_that.createdAtUtc,_that.fileName,_that.fileSizeBytes,_that.contentType,_that.isAvailable,_that.isOfficeDocument);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String messageId,  String storageFileId,  String attachedByUserId,  int position,  DateTime createdAtUtc,  String? fileName,  int? fileSizeBytes,  String? contentType,  bool isAvailable,  bool isOfficeDocument)?  $default,) {final _that = this;
switch (_that) {
case _ChatAttachmentResponse() when $default != null:
return $default(_that.id,_that.messageId,_that.storageFileId,_that.attachedByUserId,_that.position,_that.createdAtUtc,_that.fileName,_that.fileSizeBytes,_that.contentType,_that.isAvailable,_that.isOfficeDocument);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatAttachmentResponse implements ChatAttachmentResponse {
  const _ChatAttachmentResponse({required this.id, required this.messageId, required this.storageFileId, required this.attachedByUserId, required this.position, required this.createdAtUtc, this.fileName, this.fileSizeBytes, this.contentType, this.isAvailable = false, this.isOfficeDocument = false});
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
@override@JsonKey() final  bool isOfficeDocument;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatAttachmentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.attachedByUserId, attachedByUserId) || other.attachedByUserId == attachedByUserId)&&(identical(other.position, position) || other.position == position)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isOfficeDocument, isOfficeDocument) || other.isOfficeDocument == isOfficeDocument));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageId,storageFileId,attachedByUserId,position,createdAtUtc,fileName,fileSizeBytes,contentType,isAvailable,isOfficeDocument);

@override
String toString() {
  return 'ChatAttachmentResponse(id: $id, messageId: $messageId, storageFileId: $storageFileId, attachedByUserId: $attachedByUserId, position: $position, createdAtUtc: $createdAtUtc, fileName: $fileName, fileSizeBytes: $fileSizeBytes, contentType: $contentType, isAvailable: $isAvailable, isOfficeDocument: $isOfficeDocument)';
}


}

/// @nodoc
abstract mixin class _$ChatAttachmentResponseCopyWith<$Res> implements $ChatAttachmentResponseCopyWith<$Res> {
  factory _$ChatAttachmentResponseCopyWith(_ChatAttachmentResponse value, $Res Function(_ChatAttachmentResponse) _then) = __$ChatAttachmentResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String messageId, String storageFileId, String attachedByUserId, int position, DateTime createdAtUtc, String? fileName, int? fileSizeBytes, String? contentType, bool isAvailable, bool isOfficeDocument
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messageId = null,Object? storageFileId = null,Object? attachedByUserId = null,Object? position = null,Object? createdAtUtc = null,Object? fileName = freezed,Object? fileSizeBytes = freezed,Object? contentType = freezed,Object? isAvailable = null,Object? isOfficeDocument = null,}) {
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
as bool,isOfficeDocument: null == isOfficeDocument ? _self.isOfficeDocument : isOfficeDocument // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SaveChatAttachmentToStorageResponse {

 String get storageFileId; String get fileName; String get mimeType; int get fileSizeBytes; bool get canEditOnline;
/// Create a copy of SaveChatAttachmentToStorageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveChatAttachmentToStorageResponseCopyWith<SaveChatAttachmentToStorageResponse> get copyWith => _$SaveChatAttachmentToStorageResponseCopyWithImpl<SaveChatAttachmentToStorageResponse>(this as SaveChatAttachmentToStorageResponse, _$identity);

  /// Serializes this SaveChatAttachmentToStorageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveChatAttachmentToStorageResponse&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.canEditOnline, canEditOnline) || other.canEditOnline == canEditOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageFileId,fileName,mimeType,fileSizeBytes,canEditOnline);

@override
String toString() {
  return 'SaveChatAttachmentToStorageResponse(storageFileId: $storageFileId, fileName: $fileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, canEditOnline: $canEditOnline)';
}


}

/// @nodoc
abstract mixin class $SaveChatAttachmentToStorageResponseCopyWith<$Res>  {
  factory $SaveChatAttachmentToStorageResponseCopyWith(SaveChatAttachmentToStorageResponse value, $Res Function(SaveChatAttachmentToStorageResponse) _then) = _$SaveChatAttachmentToStorageResponseCopyWithImpl;
@useResult
$Res call({
 String storageFileId, String fileName, String mimeType, int fileSizeBytes, bool canEditOnline
});




}
/// @nodoc
class _$SaveChatAttachmentToStorageResponseCopyWithImpl<$Res>
    implements $SaveChatAttachmentToStorageResponseCopyWith<$Res> {
  _$SaveChatAttachmentToStorageResponseCopyWithImpl(this._self, this._then);

  final SaveChatAttachmentToStorageResponse _self;
  final $Res Function(SaveChatAttachmentToStorageResponse) _then;

/// Create a copy of SaveChatAttachmentToStorageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storageFileId = null,Object? fileName = null,Object? mimeType = null,Object? fileSizeBytes = null,Object? canEditOnline = null,}) {
  return _then(_self.copyWith(
storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,canEditOnline: null == canEditOnline ? _self.canEditOnline : canEditOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveChatAttachmentToStorageResponse].
extension SaveChatAttachmentToStorageResponsePatterns on SaveChatAttachmentToStorageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveChatAttachmentToStorageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveChatAttachmentToStorageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveChatAttachmentToStorageResponse value)  $default,){
final _that = this;
switch (_that) {
case _SaveChatAttachmentToStorageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveChatAttachmentToStorageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SaveChatAttachmentToStorageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storageFileId,  String fileName,  String mimeType,  int fileSizeBytes,  bool canEditOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveChatAttachmentToStorageResponse() when $default != null:
return $default(_that.storageFileId,_that.fileName,_that.mimeType,_that.fileSizeBytes,_that.canEditOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storageFileId,  String fileName,  String mimeType,  int fileSizeBytes,  bool canEditOnline)  $default,) {final _that = this;
switch (_that) {
case _SaveChatAttachmentToStorageResponse():
return $default(_that.storageFileId,_that.fileName,_that.mimeType,_that.fileSizeBytes,_that.canEditOnline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storageFileId,  String fileName,  String mimeType,  int fileSizeBytes,  bool canEditOnline)?  $default,) {final _that = this;
switch (_that) {
case _SaveChatAttachmentToStorageResponse() when $default != null:
return $default(_that.storageFileId,_that.fileName,_that.mimeType,_that.fileSizeBytes,_that.canEditOnline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaveChatAttachmentToStorageResponse implements SaveChatAttachmentToStorageResponse {
  const _SaveChatAttachmentToStorageResponse({required this.storageFileId, required this.fileName, required this.mimeType, required this.fileSizeBytes, required this.canEditOnline});
  factory _SaveChatAttachmentToStorageResponse.fromJson(Map<String, dynamic> json) => _$SaveChatAttachmentToStorageResponseFromJson(json);

@override final  String storageFileId;
@override final  String fileName;
@override final  String mimeType;
@override final  int fileSizeBytes;
@override final  bool canEditOnline;

/// Create a copy of SaveChatAttachmentToStorageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveChatAttachmentToStorageResponseCopyWith<_SaveChatAttachmentToStorageResponse> get copyWith => __$SaveChatAttachmentToStorageResponseCopyWithImpl<_SaveChatAttachmentToStorageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaveChatAttachmentToStorageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveChatAttachmentToStorageResponse&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.canEditOnline, canEditOnline) || other.canEditOnline == canEditOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageFileId,fileName,mimeType,fileSizeBytes,canEditOnline);

@override
String toString() {
  return 'SaveChatAttachmentToStorageResponse(storageFileId: $storageFileId, fileName: $fileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, canEditOnline: $canEditOnline)';
}


}

/// @nodoc
abstract mixin class _$SaveChatAttachmentToStorageResponseCopyWith<$Res> implements $SaveChatAttachmentToStorageResponseCopyWith<$Res> {
  factory _$SaveChatAttachmentToStorageResponseCopyWith(_SaveChatAttachmentToStorageResponse value, $Res Function(_SaveChatAttachmentToStorageResponse) _then) = __$SaveChatAttachmentToStorageResponseCopyWithImpl;
@override @useResult
$Res call({
 String storageFileId, String fileName, String mimeType, int fileSizeBytes, bool canEditOnline
});




}
/// @nodoc
class __$SaveChatAttachmentToStorageResponseCopyWithImpl<$Res>
    implements _$SaveChatAttachmentToStorageResponseCopyWith<$Res> {
  __$SaveChatAttachmentToStorageResponseCopyWithImpl(this._self, this._then);

  final _SaveChatAttachmentToStorageResponse _self;
  final $Res Function(_SaveChatAttachmentToStorageResponse) _then;

/// Create a copy of SaveChatAttachmentToStorageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storageFileId = null,Object? fileName = null,Object? mimeType = null,Object? fileSizeBytes = null,Object? canEditOnline = null,}) {
  return _then(_SaveChatAttachmentToStorageResponse(
storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,canEditOnline: null == canEditOnline ? _self.canEditOnline : canEditOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
