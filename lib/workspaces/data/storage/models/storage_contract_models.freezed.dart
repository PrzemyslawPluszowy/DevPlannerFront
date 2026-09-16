// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage_contract_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StorageUploadTicketItemPayload {

 String get fileName; int get fileSizeBytes; String? get mimeType; String? get contentSha256;
/// Create a copy of StorageUploadTicketItemPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageUploadTicketItemPayloadCopyWith<StorageUploadTicketItemPayload> get copyWith => _$StorageUploadTicketItemPayloadCopyWithImpl<StorageUploadTicketItemPayload>(this as StorageUploadTicketItemPayload, _$identity);

  /// Serializes this StorageUploadTicketItemPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageUploadTicketItemPayload&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,fileSizeBytes,mimeType,contentSha256);

@override
String toString() {
  return 'StorageUploadTicketItemPayload(fileName: $fileName, fileSizeBytes: $fileSizeBytes, mimeType: $mimeType, contentSha256: $contentSha256)';
}


}

/// @nodoc
abstract mixin class $StorageUploadTicketItemPayloadCopyWith<$Res>  {
  factory $StorageUploadTicketItemPayloadCopyWith(StorageUploadTicketItemPayload value, $Res Function(StorageUploadTicketItemPayload) _then) = _$StorageUploadTicketItemPayloadCopyWithImpl;
@useResult
$Res call({
 String fileName, int fileSizeBytes, String? mimeType, String? contentSha256
});




}
/// @nodoc
class _$StorageUploadTicketItemPayloadCopyWithImpl<$Res>
    implements $StorageUploadTicketItemPayloadCopyWith<$Res> {
  _$StorageUploadTicketItemPayloadCopyWithImpl(this._self, this._then);

  final StorageUploadTicketItemPayload _self;
  final $Res Function(StorageUploadTicketItemPayload) _then;

/// Create a copy of StorageUploadTicketItemPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? fileSizeBytes = null,Object? mimeType = freezed,Object? contentSha256 = freezed,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageUploadTicketItemPayload].
extension StorageUploadTicketItemPayloadPatterns on StorageUploadTicketItemPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageUploadTicketItemPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageUploadTicketItemPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageUploadTicketItemPayload value)  $default,){
final _that = this;
switch (_that) {
case _StorageUploadTicketItemPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageUploadTicketItemPayload value)?  $default,){
final _that = this;
switch (_that) {
case _StorageUploadTicketItemPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  int fileSizeBytes,  String? mimeType,  String? contentSha256)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageUploadTicketItemPayload() when $default != null:
return $default(_that.fileName,_that.fileSizeBytes,_that.mimeType,_that.contentSha256);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  int fileSizeBytes,  String? mimeType,  String? contentSha256)  $default,) {final _that = this;
switch (_that) {
case _StorageUploadTicketItemPayload():
return $default(_that.fileName,_that.fileSizeBytes,_that.mimeType,_that.contentSha256);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  int fileSizeBytes,  String? mimeType,  String? contentSha256)?  $default,) {final _that = this;
switch (_that) {
case _StorageUploadTicketItemPayload() when $default != null:
return $default(_that.fileName,_that.fileSizeBytes,_that.mimeType,_that.contentSha256);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageUploadTicketItemPayload implements StorageUploadTicketItemPayload {
  const _StorageUploadTicketItemPayload({required this.fileName, required this.fileSizeBytes, this.mimeType, this.contentSha256});
  factory _StorageUploadTicketItemPayload.fromJson(Map<String, dynamic> json) => _$StorageUploadTicketItemPayloadFromJson(json);

@override final  String fileName;
@override final  int fileSizeBytes;
@override final  String? mimeType;
@override final  String? contentSha256;

/// Create a copy of StorageUploadTicketItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageUploadTicketItemPayloadCopyWith<_StorageUploadTicketItemPayload> get copyWith => __$StorageUploadTicketItemPayloadCopyWithImpl<_StorageUploadTicketItemPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageUploadTicketItemPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageUploadTicketItemPayload&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,fileSizeBytes,mimeType,contentSha256);

@override
String toString() {
  return 'StorageUploadTicketItemPayload(fileName: $fileName, fileSizeBytes: $fileSizeBytes, mimeType: $mimeType, contentSha256: $contentSha256)';
}


}

/// @nodoc
abstract mixin class _$StorageUploadTicketItemPayloadCopyWith<$Res> implements $StorageUploadTicketItemPayloadCopyWith<$Res> {
  factory _$StorageUploadTicketItemPayloadCopyWith(_StorageUploadTicketItemPayload value, $Res Function(_StorageUploadTicketItemPayload) _then) = __$StorageUploadTicketItemPayloadCopyWithImpl;
@override @useResult
$Res call({
 String fileName, int fileSizeBytes, String? mimeType, String? contentSha256
});




}
/// @nodoc
class __$StorageUploadTicketItemPayloadCopyWithImpl<$Res>
    implements _$StorageUploadTicketItemPayloadCopyWith<$Res> {
  __$StorageUploadTicketItemPayloadCopyWithImpl(this._self, this._then);

  final _StorageUploadTicketItemPayload _self;
  final $Res Function(_StorageUploadTicketItemPayload) _then;

/// Create a copy of StorageUploadTicketItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? fileSizeBytes = null,Object? mimeType = freezed,Object? contentSha256 = freezed,}) {
  return _then(_StorageUploadTicketItemPayload(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BulkTaskUploadTicketPayload {

 List<StorageUploadTicketItemPayload> get files;
/// Create a copy of BulkTaskUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkTaskUploadTicketPayloadCopyWith<BulkTaskUploadTicketPayload> get copyWith => _$BulkTaskUploadTicketPayloadCopyWithImpl<BulkTaskUploadTicketPayload>(this as BulkTaskUploadTicketPayload, _$identity);

  /// Serializes this BulkTaskUploadTicketPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkTaskUploadTicketPayload&&const DeepCollectionEquality().equals(other.files, files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'BulkTaskUploadTicketPayload(files: $files)';
}


}

/// @nodoc
abstract mixin class $BulkTaskUploadTicketPayloadCopyWith<$Res>  {
  factory $BulkTaskUploadTicketPayloadCopyWith(BulkTaskUploadTicketPayload value, $Res Function(BulkTaskUploadTicketPayload) _then) = _$BulkTaskUploadTicketPayloadCopyWithImpl;
@useResult
$Res call({
 List<StorageUploadTicketItemPayload> files
});




}
/// @nodoc
class _$BulkTaskUploadTicketPayloadCopyWithImpl<$Res>
    implements $BulkTaskUploadTicketPayloadCopyWith<$Res> {
  _$BulkTaskUploadTicketPayloadCopyWithImpl(this._self, this._then);

  final BulkTaskUploadTicketPayload _self;
  final $Res Function(BulkTaskUploadTicketPayload) _then;

/// Create a copy of BulkTaskUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,}) {
  return _then(_self.copyWith(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<StorageUploadTicketItemPayload>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkTaskUploadTicketPayload].
extension BulkTaskUploadTicketPayloadPatterns on BulkTaskUploadTicketPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkTaskUploadTicketPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkTaskUploadTicketPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkTaskUploadTicketPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkTaskUploadTicketPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkTaskUploadTicketPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkTaskUploadTicketPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StorageUploadTicketItemPayload> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkTaskUploadTicketPayload() when $default != null:
return $default(_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StorageUploadTicketItemPayload> files)  $default,) {final _that = this;
switch (_that) {
case _BulkTaskUploadTicketPayload():
return $default(_that.files);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StorageUploadTicketItemPayload> files)?  $default,) {final _that = this;
switch (_that) {
case _BulkTaskUploadTicketPayload() when $default != null:
return $default(_that.files);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkTaskUploadTicketPayload implements BulkTaskUploadTicketPayload {
  const _BulkTaskUploadTicketPayload({required this.files});
  factory _BulkTaskUploadTicketPayload.fromJson(Map<String, dynamic> json) => _$BulkTaskUploadTicketPayloadFromJson(json);

@override final  List<StorageUploadTicketItemPayload> files;

/// Create a copy of BulkTaskUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkTaskUploadTicketPayloadCopyWith<_BulkTaskUploadTicketPayload> get copyWith => __$BulkTaskUploadTicketPayloadCopyWithImpl<_BulkTaskUploadTicketPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkTaskUploadTicketPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkTaskUploadTicketPayload&&const DeepCollectionEquality().equals(other.files, files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'BulkTaskUploadTicketPayload(files: $files)';
}


}

/// @nodoc
abstract mixin class _$BulkTaskUploadTicketPayloadCopyWith<$Res> implements $BulkTaskUploadTicketPayloadCopyWith<$Res> {
  factory _$BulkTaskUploadTicketPayloadCopyWith(_BulkTaskUploadTicketPayload value, $Res Function(_BulkTaskUploadTicketPayload) _then) = __$BulkTaskUploadTicketPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<StorageUploadTicketItemPayload> files
});




}
/// @nodoc
class __$BulkTaskUploadTicketPayloadCopyWithImpl<$Res>
    implements _$BulkTaskUploadTicketPayloadCopyWith<$Res> {
  __$BulkTaskUploadTicketPayloadCopyWithImpl(this._self, this._then);

  final _BulkTaskUploadTicketPayload _self;
  final $Res Function(_BulkTaskUploadTicketPayload) _then;

/// Create a copy of BulkTaskUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,}) {
  return _then(_BulkTaskUploadTicketPayload(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<StorageUploadTicketItemPayload>,
  ));
}


}


/// @nodoc
mixin _$StorageUploadTicketResponse {

 String get fileId; String get storageObjectKey; String get uploadUrl; DateTime get expiresAtUtc; bool get isAlreadyUploaded;
/// Create a copy of StorageUploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageUploadTicketResponseCopyWith<StorageUploadTicketResponse> get copyWith => _$StorageUploadTicketResponseCopyWithImpl<StorageUploadTicketResponse>(this as StorageUploadTicketResponse, _$identity);

  /// Serializes this StorageUploadTicketResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageUploadTicketResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.storageObjectKey, storageObjectKey) || other.storageObjectKey == storageObjectKey)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.isAlreadyUploaded, isAlreadyUploaded) || other.isAlreadyUploaded == isAlreadyUploaded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,storageObjectKey,uploadUrl,expiresAtUtc,isAlreadyUploaded);

@override
String toString() {
  return 'StorageUploadTicketResponse(fileId: $fileId, storageObjectKey: $storageObjectKey, uploadUrl: $uploadUrl, expiresAtUtc: $expiresAtUtc, isAlreadyUploaded: $isAlreadyUploaded)';
}


}

/// @nodoc
abstract mixin class $StorageUploadTicketResponseCopyWith<$Res>  {
  factory $StorageUploadTicketResponseCopyWith(StorageUploadTicketResponse value, $Res Function(StorageUploadTicketResponse) _then) = _$StorageUploadTicketResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, String storageObjectKey, String uploadUrl, DateTime expiresAtUtc, bool isAlreadyUploaded
});




}
/// @nodoc
class _$StorageUploadTicketResponseCopyWithImpl<$Res>
    implements $StorageUploadTicketResponseCopyWith<$Res> {
  _$StorageUploadTicketResponseCopyWithImpl(this._self, this._then);

  final StorageUploadTicketResponse _self;
  final $Res Function(StorageUploadTicketResponse) _then;

/// Create a copy of StorageUploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? storageObjectKey = null,Object? uploadUrl = null,Object? expiresAtUtc = null,Object? isAlreadyUploaded = null,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,storageObjectKey: null == storageObjectKey ? _self.storageObjectKey : storageObjectKey // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,isAlreadyUploaded: null == isAlreadyUploaded ? _self.isAlreadyUploaded : isAlreadyUploaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageUploadTicketResponse].
extension StorageUploadTicketResponsePatterns on StorageUploadTicketResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageUploadTicketResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageUploadTicketResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageUploadTicketResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageUploadTicketResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageUploadTicketResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageUploadTicketResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  String storageObjectKey,  String uploadUrl,  DateTime expiresAtUtc,  bool isAlreadyUploaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageUploadTicketResponse() when $default != null:
return $default(_that.fileId,_that.storageObjectKey,_that.uploadUrl,_that.expiresAtUtc,_that.isAlreadyUploaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  String storageObjectKey,  String uploadUrl,  DateTime expiresAtUtc,  bool isAlreadyUploaded)  $default,) {final _that = this;
switch (_that) {
case _StorageUploadTicketResponse():
return $default(_that.fileId,_that.storageObjectKey,_that.uploadUrl,_that.expiresAtUtc,_that.isAlreadyUploaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  String storageObjectKey,  String uploadUrl,  DateTime expiresAtUtc,  bool isAlreadyUploaded)?  $default,) {final _that = this;
switch (_that) {
case _StorageUploadTicketResponse() when $default != null:
return $default(_that.fileId,_that.storageObjectKey,_that.uploadUrl,_that.expiresAtUtc,_that.isAlreadyUploaded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageUploadTicketResponse implements StorageUploadTicketResponse {
  const _StorageUploadTicketResponse({required this.fileId, required this.storageObjectKey, required this.uploadUrl, required this.expiresAtUtc, required this.isAlreadyUploaded});
  factory _StorageUploadTicketResponse.fromJson(Map<String, dynamic> json) => _$StorageUploadTicketResponseFromJson(json);

@override final  String fileId;
@override final  String storageObjectKey;
@override final  String uploadUrl;
@override final  DateTime expiresAtUtc;
@override final  bool isAlreadyUploaded;

/// Create a copy of StorageUploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageUploadTicketResponseCopyWith<_StorageUploadTicketResponse> get copyWith => __$StorageUploadTicketResponseCopyWithImpl<_StorageUploadTicketResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageUploadTicketResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageUploadTicketResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.storageObjectKey, storageObjectKey) || other.storageObjectKey == storageObjectKey)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.isAlreadyUploaded, isAlreadyUploaded) || other.isAlreadyUploaded == isAlreadyUploaded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,storageObjectKey,uploadUrl,expiresAtUtc,isAlreadyUploaded);

@override
String toString() {
  return 'StorageUploadTicketResponse(fileId: $fileId, storageObjectKey: $storageObjectKey, uploadUrl: $uploadUrl, expiresAtUtc: $expiresAtUtc, isAlreadyUploaded: $isAlreadyUploaded)';
}


}

/// @nodoc
abstract mixin class _$StorageUploadTicketResponseCopyWith<$Res> implements $StorageUploadTicketResponseCopyWith<$Res> {
  factory _$StorageUploadTicketResponseCopyWith(_StorageUploadTicketResponse value, $Res Function(_StorageUploadTicketResponse) _then) = __$StorageUploadTicketResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, String storageObjectKey, String uploadUrl, DateTime expiresAtUtc, bool isAlreadyUploaded
});




}
/// @nodoc
class __$StorageUploadTicketResponseCopyWithImpl<$Res>
    implements _$StorageUploadTicketResponseCopyWith<$Res> {
  __$StorageUploadTicketResponseCopyWithImpl(this._self, this._then);

  final _StorageUploadTicketResponse _self;
  final $Res Function(_StorageUploadTicketResponse) _then;

/// Create a copy of StorageUploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? storageObjectKey = null,Object? uploadUrl = null,Object? expiresAtUtc = null,Object? isAlreadyUploaded = null,}) {
  return _then(_StorageUploadTicketResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,storageObjectKey: null == storageObjectKey ? _self.storageObjectKey : storageObjectKey // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,isAlreadyUploaded: null == isAlreadyUploaded ? _self.isAlreadyUploaded : isAlreadyUploaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BulkStorageUploadTicketResponse {

 List<StorageUploadTicketResponse> get tickets;
/// Create a copy of BulkStorageUploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkStorageUploadTicketResponseCopyWith<BulkStorageUploadTicketResponse> get copyWith => _$BulkStorageUploadTicketResponseCopyWithImpl<BulkStorageUploadTicketResponse>(this as BulkStorageUploadTicketResponse, _$identity);

  /// Serializes this BulkStorageUploadTicketResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkStorageUploadTicketResponse&&const DeepCollectionEquality().equals(other.tickets, tickets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tickets));

@override
String toString() {
  return 'BulkStorageUploadTicketResponse(tickets: $tickets)';
}


}

/// @nodoc
abstract mixin class $BulkStorageUploadTicketResponseCopyWith<$Res>  {
  factory $BulkStorageUploadTicketResponseCopyWith(BulkStorageUploadTicketResponse value, $Res Function(BulkStorageUploadTicketResponse) _then) = _$BulkStorageUploadTicketResponseCopyWithImpl;
@useResult
$Res call({
 List<StorageUploadTicketResponse> tickets
});




}
/// @nodoc
class _$BulkStorageUploadTicketResponseCopyWithImpl<$Res>
    implements $BulkStorageUploadTicketResponseCopyWith<$Res> {
  _$BulkStorageUploadTicketResponseCopyWithImpl(this._self, this._then);

  final BulkStorageUploadTicketResponse _self;
  final $Res Function(BulkStorageUploadTicketResponse) _then;

/// Create a copy of BulkStorageUploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tickets = null,}) {
  return _then(_self.copyWith(
tickets: null == tickets ? _self.tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<StorageUploadTicketResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkStorageUploadTicketResponse].
extension BulkStorageUploadTicketResponsePatterns on BulkStorageUploadTicketResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkStorageUploadTicketResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkStorageUploadTicketResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkStorageUploadTicketResponse value)  $default,){
final _that = this;
switch (_that) {
case _BulkStorageUploadTicketResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkStorageUploadTicketResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BulkStorageUploadTicketResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StorageUploadTicketResponse> tickets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkStorageUploadTicketResponse() when $default != null:
return $default(_that.tickets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StorageUploadTicketResponse> tickets)  $default,) {final _that = this;
switch (_that) {
case _BulkStorageUploadTicketResponse():
return $default(_that.tickets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StorageUploadTicketResponse> tickets)?  $default,) {final _that = this;
switch (_that) {
case _BulkStorageUploadTicketResponse() when $default != null:
return $default(_that.tickets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkStorageUploadTicketResponse implements BulkStorageUploadTicketResponse {
  const _BulkStorageUploadTicketResponse({required this.tickets});
  factory _BulkStorageUploadTicketResponse.fromJson(Map<String, dynamic> json) => _$BulkStorageUploadTicketResponseFromJson(json);

@override final  List<StorageUploadTicketResponse> tickets;

/// Create a copy of BulkStorageUploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkStorageUploadTicketResponseCopyWith<_BulkStorageUploadTicketResponse> get copyWith => __$BulkStorageUploadTicketResponseCopyWithImpl<_BulkStorageUploadTicketResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkStorageUploadTicketResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkStorageUploadTicketResponse&&const DeepCollectionEquality().equals(other.tickets, tickets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tickets));

@override
String toString() {
  return 'BulkStorageUploadTicketResponse(tickets: $tickets)';
}


}

/// @nodoc
abstract mixin class _$BulkStorageUploadTicketResponseCopyWith<$Res> implements $BulkStorageUploadTicketResponseCopyWith<$Res> {
  factory _$BulkStorageUploadTicketResponseCopyWith(_BulkStorageUploadTicketResponse value, $Res Function(_BulkStorageUploadTicketResponse) _then) = __$BulkStorageUploadTicketResponseCopyWithImpl;
@override @useResult
$Res call({
 List<StorageUploadTicketResponse> tickets
});




}
/// @nodoc
class __$BulkStorageUploadTicketResponseCopyWithImpl<$Res>
    implements _$BulkStorageUploadTicketResponseCopyWith<$Res> {
  __$BulkStorageUploadTicketResponseCopyWithImpl(this._self, this._then);

  final _BulkStorageUploadTicketResponse _self;
  final $Res Function(_BulkStorageUploadTicketResponse) _then;

/// Create a copy of BulkStorageUploadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tickets = null,}) {
  return _then(_BulkStorageUploadTicketResponse(
tickets: null == tickets ? _self.tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<StorageUploadTicketResponse>,
  ));
}


}


/// @nodoc
mixin _$BulkCompleteFileItemPayload {

 String get fileId; int get fileSizeBytes; String? get contentSha256; String? get changeSummary;
/// Create a copy of BulkCompleteFileItemPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkCompleteFileItemPayloadCopyWith<BulkCompleteFileItemPayload> get copyWith => _$BulkCompleteFileItemPayloadCopyWithImpl<BulkCompleteFileItemPayload>(this as BulkCompleteFileItemPayload, _$identity);

  /// Serializes this BulkCompleteFileItemPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkCompleteFileItemPayload&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,fileSizeBytes,contentSha256,changeSummary);

@override
String toString() {
  return 'BulkCompleteFileItemPayload(fileId: $fileId, fileSizeBytes: $fileSizeBytes, contentSha256: $contentSha256, changeSummary: $changeSummary)';
}


}

/// @nodoc
abstract mixin class $BulkCompleteFileItemPayloadCopyWith<$Res>  {
  factory $BulkCompleteFileItemPayloadCopyWith(BulkCompleteFileItemPayload value, $Res Function(BulkCompleteFileItemPayload) _then) = _$BulkCompleteFileItemPayloadCopyWithImpl;
@useResult
$Res call({
 String fileId, int fileSizeBytes, String? contentSha256, String? changeSummary
});




}
/// @nodoc
class _$BulkCompleteFileItemPayloadCopyWithImpl<$Res>
    implements $BulkCompleteFileItemPayloadCopyWith<$Res> {
  _$BulkCompleteFileItemPayloadCopyWithImpl(this._self, this._then);

  final BulkCompleteFileItemPayload _self;
  final $Res Function(BulkCompleteFileItemPayload) _then;

/// Create a copy of BulkCompleteFileItemPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? fileSizeBytes = null,Object? contentSha256 = freezed,Object? changeSummary = freezed,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkCompleteFileItemPayload].
extension BulkCompleteFileItemPayloadPatterns on BulkCompleteFileItemPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkCompleteFileItemPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkCompleteFileItemPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkCompleteFileItemPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkCompleteFileItemPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkCompleteFileItemPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkCompleteFileItemPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  int fileSizeBytes,  String? contentSha256,  String? changeSummary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkCompleteFileItemPayload() when $default != null:
return $default(_that.fileId,_that.fileSizeBytes,_that.contentSha256,_that.changeSummary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  int fileSizeBytes,  String? contentSha256,  String? changeSummary)  $default,) {final _that = this;
switch (_that) {
case _BulkCompleteFileItemPayload():
return $default(_that.fileId,_that.fileSizeBytes,_that.contentSha256,_that.changeSummary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  int fileSizeBytes,  String? contentSha256,  String? changeSummary)?  $default,) {final _that = this;
switch (_that) {
case _BulkCompleteFileItemPayload() when $default != null:
return $default(_that.fileId,_that.fileSizeBytes,_that.contentSha256,_that.changeSummary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkCompleteFileItemPayload implements BulkCompleteFileItemPayload {
  const _BulkCompleteFileItemPayload({required this.fileId, required this.fileSizeBytes, this.contentSha256, this.changeSummary});
  factory _BulkCompleteFileItemPayload.fromJson(Map<String, dynamic> json) => _$BulkCompleteFileItemPayloadFromJson(json);

@override final  String fileId;
@override final  int fileSizeBytes;
@override final  String? contentSha256;
@override final  String? changeSummary;

/// Create a copy of BulkCompleteFileItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkCompleteFileItemPayloadCopyWith<_BulkCompleteFileItemPayload> get copyWith => __$BulkCompleteFileItemPayloadCopyWithImpl<_BulkCompleteFileItemPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkCompleteFileItemPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkCompleteFileItemPayload&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,fileSizeBytes,contentSha256,changeSummary);

@override
String toString() {
  return 'BulkCompleteFileItemPayload(fileId: $fileId, fileSizeBytes: $fileSizeBytes, contentSha256: $contentSha256, changeSummary: $changeSummary)';
}


}

/// @nodoc
abstract mixin class _$BulkCompleteFileItemPayloadCopyWith<$Res> implements $BulkCompleteFileItemPayloadCopyWith<$Res> {
  factory _$BulkCompleteFileItemPayloadCopyWith(_BulkCompleteFileItemPayload value, $Res Function(_BulkCompleteFileItemPayload) _then) = __$BulkCompleteFileItemPayloadCopyWithImpl;
@override @useResult
$Res call({
 String fileId, int fileSizeBytes, String? contentSha256, String? changeSummary
});




}
/// @nodoc
class __$BulkCompleteFileItemPayloadCopyWithImpl<$Res>
    implements _$BulkCompleteFileItemPayloadCopyWith<$Res> {
  __$BulkCompleteFileItemPayloadCopyWithImpl(this._self, this._then);

  final _BulkCompleteFileItemPayload _self;
  final $Res Function(_BulkCompleteFileItemPayload) _then;

/// Create a copy of BulkCompleteFileItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? fileSizeBytes = null,Object? contentSha256 = freezed,Object? changeSummary = freezed,}) {
  return _then(_BulkCompleteFileItemPayload(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BulkCompleteUploadPayload {

 List<BulkCompleteFileItemPayload> get files;
/// Create a copy of BulkCompleteUploadPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkCompleteUploadPayloadCopyWith<BulkCompleteUploadPayload> get copyWith => _$BulkCompleteUploadPayloadCopyWithImpl<BulkCompleteUploadPayload>(this as BulkCompleteUploadPayload, _$identity);

  /// Serializes this BulkCompleteUploadPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkCompleteUploadPayload&&const DeepCollectionEquality().equals(other.files, files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'BulkCompleteUploadPayload(files: $files)';
}


}

/// @nodoc
abstract mixin class $BulkCompleteUploadPayloadCopyWith<$Res>  {
  factory $BulkCompleteUploadPayloadCopyWith(BulkCompleteUploadPayload value, $Res Function(BulkCompleteUploadPayload) _then) = _$BulkCompleteUploadPayloadCopyWithImpl;
@useResult
$Res call({
 List<BulkCompleteFileItemPayload> files
});




}
/// @nodoc
class _$BulkCompleteUploadPayloadCopyWithImpl<$Res>
    implements $BulkCompleteUploadPayloadCopyWith<$Res> {
  _$BulkCompleteUploadPayloadCopyWithImpl(this._self, this._then);

  final BulkCompleteUploadPayload _self;
  final $Res Function(BulkCompleteUploadPayload) _then;

/// Create a copy of BulkCompleteUploadPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,}) {
  return _then(_self.copyWith(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<BulkCompleteFileItemPayload>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkCompleteUploadPayload].
extension BulkCompleteUploadPayloadPatterns on BulkCompleteUploadPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkCompleteUploadPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkCompleteUploadPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkCompleteUploadPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkCompleteUploadPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkCompleteUploadPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkCompleteUploadPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BulkCompleteFileItemPayload> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkCompleteUploadPayload() when $default != null:
return $default(_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BulkCompleteFileItemPayload> files)  $default,) {final _that = this;
switch (_that) {
case _BulkCompleteUploadPayload():
return $default(_that.files);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BulkCompleteFileItemPayload> files)?  $default,) {final _that = this;
switch (_that) {
case _BulkCompleteUploadPayload() when $default != null:
return $default(_that.files);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkCompleteUploadPayload implements BulkCompleteUploadPayload {
  const _BulkCompleteUploadPayload({required this.files});
  factory _BulkCompleteUploadPayload.fromJson(Map<String, dynamic> json) => _$BulkCompleteUploadPayloadFromJson(json);

@override final  List<BulkCompleteFileItemPayload> files;

/// Create a copy of BulkCompleteUploadPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkCompleteUploadPayloadCopyWith<_BulkCompleteUploadPayload> get copyWith => __$BulkCompleteUploadPayloadCopyWithImpl<_BulkCompleteUploadPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkCompleteUploadPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkCompleteUploadPayload&&const DeepCollectionEquality().equals(other.files, files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'BulkCompleteUploadPayload(files: $files)';
}


}

/// @nodoc
abstract mixin class _$BulkCompleteUploadPayloadCopyWith<$Res> implements $BulkCompleteUploadPayloadCopyWith<$Res> {
  factory _$BulkCompleteUploadPayloadCopyWith(_BulkCompleteUploadPayload value, $Res Function(_BulkCompleteUploadPayload) _then) = __$BulkCompleteUploadPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<BulkCompleteFileItemPayload> files
});




}
/// @nodoc
class __$BulkCompleteUploadPayloadCopyWithImpl<$Res>
    implements _$BulkCompleteUploadPayloadCopyWith<$Res> {
  __$BulkCompleteUploadPayloadCopyWithImpl(this._self, this._then);

  final _BulkCompleteUploadPayload _self;
  final $Res Function(_BulkCompleteUploadPayload) _then;

/// Create a copy of BulkCompleteUploadPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,}) {
  return _then(_BulkCompleteUploadPayload(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<BulkCompleteFileItemPayload>,
  ));
}


}


/// @nodoc
mixin _$StorageFileResponse {

 String get id; StorageModule get module; StorageResourceType get resourceType; String? get resourceId; String get originalFileName; String get extension; String get mimeType; int get fileSizeBytes; String? get contentSha256; int get version; String? get workspaceId; String? get projectId; String get ownerUserId; String get createdByUserId; DateTime get createdAtUtc; DateTime get updatedAtUtc; bool get isDeleted; StorageProcessingStatus get processingStatus; StorageScanStatus get scanStatus; StorageAiStatus get aiStatus; String? get aiDescription; List<String>? get aiTags; String? get aiSummary; String? get aiOcrText; int? get mediaDurationSeconds; int? get mediaWidth; int? get mediaHeight; StorageEffectiveAccessLevel get accessLevel; bool get canRead; bool get canComment; bool get canEdit; bool get canShare; bool get canDelete; bool get isFavorite; DateTime? get favoritedAtUtc; DateTime? get lastAccessedAtUtc; String? get manualDescription; String? get manualDescriptionUpdatedByUserId; DateTime? get manualDescriptionUpdatedAtUtc; String? get concurrencyToken; String? get aiLanguage; List<AiDetectedEntity>? get aiEntities; bool get canPreview; bool get canEditOnline; bool get canDownload; bool get canManageVersions; bool get canRestore; bool get canConvertToPdf;
/// Create a copy of StorageFileResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFileResponseCopyWith<StorageFileResponse> get copyWith => _$StorageFileResponseCopyWithImpl<StorageFileResponse>(this as StorageFileResponse, _$identity);

  /// Serializes this StorageFileResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFileResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.module, module) || other.module == module)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.originalFileName, originalFileName) || other.originalFileName == originalFileName)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.version, version) || other.version == version)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus)&&(identical(other.aiStatus, aiStatus) || other.aiStatus == aiStatus)&&(identical(other.aiDescription, aiDescription) || other.aiDescription == aiDescription)&&const DeepCollectionEquality().equals(other.aiTags, aiTags)&&(identical(other.aiSummary, aiSummary) || other.aiSummary == aiSummary)&&(identical(other.aiOcrText, aiOcrText) || other.aiOcrText == aiOcrText)&&(identical(other.mediaDurationSeconds, mediaDurationSeconds) || other.mediaDurationSeconds == mediaDurationSeconds)&&(identical(other.mediaWidth, mediaWidth) || other.mediaWidth == mediaWidth)&&(identical(other.mediaHeight, mediaHeight) || other.mediaHeight == mediaHeight)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.canRead, canRead) || other.canRead == canRead)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.favoritedAtUtc, favoritedAtUtc) || other.favoritedAtUtc == favoritedAtUtc)&&(identical(other.lastAccessedAtUtc, lastAccessedAtUtc) || other.lastAccessedAtUtc == lastAccessedAtUtc)&&(identical(other.manualDescription, manualDescription) || other.manualDescription == manualDescription)&&(identical(other.manualDescriptionUpdatedByUserId, manualDescriptionUpdatedByUserId) || other.manualDescriptionUpdatedByUserId == manualDescriptionUpdatedByUserId)&&(identical(other.manualDescriptionUpdatedAtUtc, manualDescriptionUpdatedAtUtc) || other.manualDescriptionUpdatedAtUtc == manualDescriptionUpdatedAtUtc)&&(identical(other.concurrencyToken, concurrencyToken) || other.concurrencyToken == concurrencyToken)&&(identical(other.aiLanguage, aiLanguage) || other.aiLanguage == aiLanguage)&&const DeepCollectionEquality().equals(other.aiEntities, aiEntities)&&(identical(other.canPreview, canPreview) || other.canPreview == canPreview)&&(identical(other.canEditOnline, canEditOnline) || other.canEditOnline == canEditOnline)&&(identical(other.canDownload, canDownload) || other.canDownload == canDownload)&&(identical(other.canManageVersions, canManageVersions) || other.canManageVersions == canManageVersions)&&(identical(other.canRestore, canRestore) || other.canRestore == canRestore)&&(identical(other.canConvertToPdf, canConvertToPdf) || other.canConvertToPdf == canConvertToPdf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,module,resourceType,resourceId,originalFileName,extension,mimeType,fileSizeBytes,contentSha256,version,workspaceId,projectId,ownerUserId,createdByUserId,createdAtUtc,updatedAtUtc,isDeleted,processingStatus,scanStatus,aiStatus,aiDescription,const DeepCollectionEquality().hash(aiTags),aiSummary,aiOcrText,mediaDurationSeconds,mediaWidth,mediaHeight,accessLevel,canRead,canComment,canEdit,canShare,canDelete,isFavorite,favoritedAtUtc,lastAccessedAtUtc,manualDescription,manualDescriptionUpdatedByUserId,manualDescriptionUpdatedAtUtc,concurrencyToken,aiLanguage,const DeepCollectionEquality().hash(aiEntities),canPreview,canEditOnline,canDownload,canManageVersions,canRestore,canConvertToPdf]);

@override
String toString() {
  return 'StorageFileResponse(id: $id, module: $module, resourceType: $resourceType, resourceId: $resourceId, originalFileName: $originalFileName, extension: $extension, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, contentSha256: $contentSha256, version: $version, workspaceId: $workspaceId, projectId: $projectId, ownerUserId: $ownerUserId, createdByUserId: $createdByUserId, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, isDeleted: $isDeleted, processingStatus: $processingStatus, scanStatus: $scanStatus, aiStatus: $aiStatus, aiDescription: $aiDescription, aiTags: $aiTags, aiSummary: $aiSummary, aiOcrText: $aiOcrText, mediaDurationSeconds: $mediaDurationSeconds, mediaWidth: $mediaWidth, mediaHeight: $mediaHeight, accessLevel: $accessLevel, canRead: $canRead, canComment: $canComment, canEdit: $canEdit, canShare: $canShare, canDelete: $canDelete, isFavorite: $isFavorite, favoritedAtUtc: $favoritedAtUtc, lastAccessedAtUtc: $lastAccessedAtUtc, manualDescription: $manualDescription, manualDescriptionUpdatedByUserId: $manualDescriptionUpdatedByUserId, manualDescriptionUpdatedAtUtc: $manualDescriptionUpdatedAtUtc, concurrencyToken: $concurrencyToken, aiLanguage: $aiLanguage, aiEntities: $aiEntities, canPreview: $canPreview, canEditOnline: $canEditOnline, canDownload: $canDownload, canManageVersions: $canManageVersions, canRestore: $canRestore, canConvertToPdf: $canConvertToPdf)';
}


}

/// @nodoc
abstract mixin class $StorageFileResponseCopyWith<$Res>  {
  factory $StorageFileResponseCopyWith(StorageFileResponse value, $Res Function(StorageFileResponse) _then) = _$StorageFileResponseCopyWithImpl;
@useResult
$Res call({
 String id, StorageModule module, StorageResourceType resourceType, String? resourceId, String originalFileName, String extension, String mimeType, int fileSizeBytes, String? contentSha256, int version, String? workspaceId, String? projectId, String ownerUserId, String createdByUserId, DateTime createdAtUtc, DateTime updatedAtUtc, bool isDeleted, StorageProcessingStatus processingStatus, StorageScanStatus scanStatus, StorageAiStatus aiStatus, String? aiDescription, List<String>? aiTags, String? aiSummary, String? aiOcrText, int? mediaDurationSeconds, int? mediaWidth, int? mediaHeight, StorageEffectiveAccessLevel accessLevel, bool canRead, bool canComment, bool canEdit, bool canShare, bool canDelete, bool isFavorite, DateTime? favoritedAtUtc, DateTime? lastAccessedAtUtc, String? manualDescription, String? manualDescriptionUpdatedByUserId, DateTime? manualDescriptionUpdatedAtUtc, String? concurrencyToken, String? aiLanguage, List<AiDetectedEntity>? aiEntities, bool canPreview, bool canEditOnline, bool canDownload, bool canManageVersions, bool canRestore, bool canConvertToPdf
});




}
/// @nodoc
class _$StorageFileResponseCopyWithImpl<$Res>
    implements $StorageFileResponseCopyWith<$Res> {
  _$StorageFileResponseCopyWithImpl(this._self, this._then);

  final StorageFileResponse _self;
  final $Res Function(StorageFileResponse) _then;

/// Create a copy of StorageFileResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? module = null,Object? resourceType = null,Object? resourceId = freezed,Object? originalFileName = null,Object? extension = null,Object? mimeType = null,Object? fileSizeBytes = null,Object? contentSha256 = freezed,Object? version = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? ownerUserId = null,Object? createdByUserId = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? isDeleted = null,Object? processingStatus = null,Object? scanStatus = null,Object? aiStatus = null,Object? aiDescription = freezed,Object? aiTags = freezed,Object? aiSummary = freezed,Object? aiOcrText = freezed,Object? mediaDurationSeconds = freezed,Object? mediaWidth = freezed,Object? mediaHeight = freezed,Object? accessLevel = null,Object? canRead = null,Object? canComment = null,Object? canEdit = null,Object? canShare = null,Object? canDelete = null,Object? isFavorite = null,Object? favoritedAtUtc = freezed,Object? lastAccessedAtUtc = freezed,Object? manualDescription = freezed,Object? manualDescriptionUpdatedByUserId = freezed,Object? manualDescriptionUpdatedAtUtc = freezed,Object? concurrencyToken = freezed,Object? aiLanguage = freezed,Object? aiEntities = freezed,Object? canPreview = null,Object? canEditOnline = null,Object? canDownload = null,Object? canManageVersions = null,Object? canRestore = null,Object? canConvertToPdf = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as StorageModule,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as StorageResourceType,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,originalFileName: null == originalFileName ? _self.originalFileName : originalFileName // ignore: cast_nullable_to_non_nullable
as String,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as StorageProcessingStatus,scanStatus: null == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as StorageScanStatus,aiStatus: null == aiStatus ? _self.aiStatus : aiStatus // ignore: cast_nullable_to_non_nullable
as StorageAiStatus,aiDescription: freezed == aiDescription ? _self.aiDescription : aiDescription // ignore: cast_nullable_to_non_nullable
as String?,aiTags: freezed == aiTags ? _self.aiTags : aiTags // ignore: cast_nullable_to_non_nullable
as List<String>?,aiSummary: freezed == aiSummary ? _self.aiSummary : aiSummary // ignore: cast_nullable_to_non_nullable
as String?,aiOcrText: freezed == aiOcrText ? _self.aiOcrText : aiOcrText // ignore: cast_nullable_to_non_nullable
as String?,mediaDurationSeconds: freezed == mediaDurationSeconds ? _self.mediaDurationSeconds : mediaDurationSeconds // ignore: cast_nullable_to_non_nullable
as int?,mediaWidth: freezed == mediaWidth ? _self.mediaWidth : mediaWidth // ignore: cast_nullable_to_non_nullable
as int?,mediaHeight: freezed == mediaHeight ? _self.mediaHeight : mediaHeight // ignore: cast_nullable_to_non_nullable
as int?,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageEffectiveAccessLevel,canRead: null == canRead ? _self.canRead : canRead // ignore: cast_nullable_to_non_nullable
as bool,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,favoritedAtUtc: freezed == favoritedAtUtc ? _self.favoritedAtUtc : favoritedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAccessedAtUtc: freezed == lastAccessedAtUtc ? _self.lastAccessedAtUtc : lastAccessedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,manualDescription: freezed == manualDescription ? _self.manualDescription : manualDescription // ignore: cast_nullable_to_non_nullable
as String?,manualDescriptionUpdatedByUserId: freezed == manualDescriptionUpdatedByUserId ? _self.manualDescriptionUpdatedByUserId : manualDescriptionUpdatedByUserId // ignore: cast_nullable_to_non_nullable
as String?,manualDescriptionUpdatedAtUtc: freezed == manualDescriptionUpdatedAtUtc ? _self.manualDescriptionUpdatedAtUtc : manualDescriptionUpdatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,concurrencyToken: freezed == concurrencyToken ? _self.concurrencyToken : concurrencyToken // ignore: cast_nullable_to_non_nullable
as String?,aiLanguage: freezed == aiLanguage ? _self.aiLanguage : aiLanguage // ignore: cast_nullable_to_non_nullable
as String?,aiEntities: freezed == aiEntities ? _self.aiEntities : aiEntities // ignore: cast_nullable_to_non_nullable
as List<AiDetectedEntity>?,canPreview: null == canPreview ? _self.canPreview : canPreview // ignore: cast_nullable_to_non_nullable
as bool,canEditOnline: null == canEditOnline ? _self.canEditOnline : canEditOnline // ignore: cast_nullable_to_non_nullable
as bool,canDownload: null == canDownload ? _self.canDownload : canDownload // ignore: cast_nullable_to_non_nullable
as bool,canManageVersions: null == canManageVersions ? _self.canManageVersions : canManageVersions // ignore: cast_nullable_to_non_nullable
as bool,canRestore: null == canRestore ? _self.canRestore : canRestore // ignore: cast_nullable_to_non_nullable
as bool,canConvertToPdf: null == canConvertToPdf ? _self.canConvertToPdf : canConvertToPdf // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageFileResponse].
extension StorageFileResponsePatterns on StorageFileResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFileResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFileResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFileResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFileResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFileResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFileResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  StorageModule module,  StorageResourceType resourceType,  String? resourceId,  String originalFileName,  String extension,  String mimeType,  int fileSizeBytes,  String? contentSha256,  int version,  String? workspaceId,  String? projectId,  String ownerUserId,  String createdByUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  bool isDeleted,  StorageProcessingStatus processingStatus,  StorageScanStatus scanStatus,  StorageAiStatus aiStatus,  String? aiDescription,  List<String>? aiTags,  String? aiSummary,  String? aiOcrText,  int? mediaDurationSeconds,  int? mediaWidth,  int? mediaHeight,  StorageEffectiveAccessLevel accessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete,  bool isFavorite,  DateTime? favoritedAtUtc,  DateTime? lastAccessedAtUtc,  String? manualDescription,  String? manualDescriptionUpdatedByUserId,  DateTime? manualDescriptionUpdatedAtUtc,  String? concurrencyToken,  String? aiLanguage,  List<AiDetectedEntity>? aiEntities,  bool canPreview,  bool canEditOnline,  bool canDownload,  bool canManageVersions,  bool canRestore,  bool canConvertToPdf)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFileResponse() when $default != null:
return $default(_that.id,_that.module,_that.resourceType,_that.resourceId,_that.originalFileName,_that.extension,_that.mimeType,_that.fileSizeBytes,_that.contentSha256,_that.version,_that.workspaceId,_that.projectId,_that.ownerUserId,_that.createdByUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.isDeleted,_that.processingStatus,_that.scanStatus,_that.aiStatus,_that.aiDescription,_that.aiTags,_that.aiSummary,_that.aiOcrText,_that.mediaDurationSeconds,_that.mediaWidth,_that.mediaHeight,_that.accessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete,_that.isFavorite,_that.favoritedAtUtc,_that.lastAccessedAtUtc,_that.manualDescription,_that.manualDescriptionUpdatedByUserId,_that.manualDescriptionUpdatedAtUtc,_that.concurrencyToken,_that.aiLanguage,_that.aiEntities,_that.canPreview,_that.canEditOnline,_that.canDownload,_that.canManageVersions,_that.canRestore,_that.canConvertToPdf);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  StorageModule module,  StorageResourceType resourceType,  String? resourceId,  String originalFileName,  String extension,  String mimeType,  int fileSizeBytes,  String? contentSha256,  int version,  String? workspaceId,  String? projectId,  String ownerUserId,  String createdByUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  bool isDeleted,  StorageProcessingStatus processingStatus,  StorageScanStatus scanStatus,  StorageAiStatus aiStatus,  String? aiDescription,  List<String>? aiTags,  String? aiSummary,  String? aiOcrText,  int? mediaDurationSeconds,  int? mediaWidth,  int? mediaHeight,  StorageEffectiveAccessLevel accessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete,  bool isFavorite,  DateTime? favoritedAtUtc,  DateTime? lastAccessedAtUtc,  String? manualDescription,  String? manualDescriptionUpdatedByUserId,  DateTime? manualDescriptionUpdatedAtUtc,  String? concurrencyToken,  String? aiLanguage,  List<AiDetectedEntity>? aiEntities,  bool canPreview,  bool canEditOnline,  bool canDownload,  bool canManageVersions,  bool canRestore,  bool canConvertToPdf)  $default,) {final _that = this;
switch (_that) {
case _StorageFileResponse():
return $default(_that.id,_that.module,_that.resourceType,_that.resourceId,_that.originalFileName,_that.extension,_that.mimeType,_that.fileSizeBytes,_that.contentSha256,_that.version,_that.workspaceId,_that.projectId,_that.ownerUserId,_that.createdByUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.isDeleted,_that.processingStatus,_that.scanStatus,_that.aiStatus,_that.aiDescription,_that.aiTags,_that.aiSummary,_that.aiOcrText,_that.mediaDurationSeconds,_that.mediaWidth,_that.mediaHeight,_that.accessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete,_that.isFavorite,_that.favoritedAtUtc,_that.lastAccessedAtUtc,_that.manualDescription,_that.manualDescriptionUpdatedByUserId,_that.manualDescriptionUpdatedAtUtc,_that.concurrencyToken,_that.aiLanguage,_that.aiEntities,_that.canPreview,_that.canEditOnline,_that.canDownload,_that.canManageVersions,_that.canRestore,_that.canConvertToPdf);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  StorageModule module,  StorageResourceType resourceType,  String? resourceId,  String originalFileName,  String extension,  String mimeType,  int fileSizeBytes,  String? contentSha256,  int version,  String? workspaceId,  String? projectId,  String ownerUserId,  String createdByUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  bool isDeleted,  StorageProcessingStatus processingStatus,  StorageScanStatus scanStatus,  StorageAiStatus aiStatus,  String? aiDescription,  List<String>? aiTags,  String? aiSummary,  String? aiOcrText,  int? mediaDurationSeconds,  int? mediaWidth,  int? mediaHeight,  StorageEffectiveAccessLevel accessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete,  bool isFavorite,  DateTime? favoritedAtUtc,  DateTime? lastAccessedAtUtc,  String? manualDescription,  String? manualDescriptionUpdatedByUserId,  DateTime? manualDescriptionUpdatedAtUtc,  String? concurrencyToken,  String? aiLanguage,  List<AiDetectedEntity>? aiEntities,  bool canPreview,  bool canEditOnline,  bool canDownload,  bool canManageVersions,  bool canRestore,  bool canConvertToPdf)?  $default,) {final _that = this;
switch (_that) {
case _StorageFileResponse() when $default != null:
return $default(_that.id,_that.module,_that.resourceType,_that.resourceId,_that.originalFileName,_that.extension,_that.mimeType,_that.fileSizeBytes,_that.contentSha256,_that.version,_that.workspaceId,_that.projectId,_that.ownerUserId,_that.createdByUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.isDeleted,_that.processingStatus,_that.scanStatus,_that.aiStatus,_that.aiDescription,_that.aiTags,_that.aiSummary,_that.aiOcrText,_that.mediaDurationSeconds,_that.mediaWidth,_that.mediaHeight,_that.accessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete,_that.isFavorite,_that.favoritedAtUtc,_that.lastAccessedAtUtc,_that.manualDescription,_that.manualDescriptionUpdatedByUserId,_that.manualDescriptionUpdatedAtUtc,_that.concurrencyToken,_that.aiLanguage,_that.aiEntities,_that.canPreview,_that.canEditOnline,_that.canDownload,_that.canManageVersions,_that.canRestore,_that.canConvertToPdf);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFileResponse implements StorageFileResponse {
  const _StorageFileResponse({required this.id, required this.module, required this.resourceType, this.resourceId, required this.originalFileName, required this.extension, required this.mimeType, required this.fileSizeBytes, this.contentSha256, required this.version, this.workspaceId, this.projectId, required this.ownerUserId, required this.createdByUserId, required this.createdAtUtc, required this.updatedAtUtc, required this.isDeleted, required this.processingStatus, required this.scanStatus, required this.aiStatus, this.aiDescription, this.aiTags, this.aiSummary, this.aiOcrText, this.mediaDurationSeconds, this.mediaWidth, this.mediaHeight, this.accessLevel = StorageEffectiveAccessLevel.none, this.canRead = false, this.canComment = false, this.canEdit = false, this.canShare = false, this.canDelete = false, this.isFavorite = false, this.favoritedAtUtc, this.lastAccessedAtUtc, this.manualDescription, this.manualDescriptionUpdatedByUserId, this.manualDescriptionUpdatedAtUtc, this.concurrencyToken, this.aiLanguage, this.aiEntities, this.canPreview = false, this.canEditOnline = false, this.canDownload = false, this.canManageVersions = false, this.canRestore = false, this.canConvertToPdf = false});
  factory _StorageFileResponse.fromJson(Map<String, dynamic> json) => _$StorageFileResponseFromJson(json);

@override final  String id;
@override final  StorageModule module;
@override final  StorageResourceType resourceType;
@override final  String? resourceId;
@override final  String originalFileName;
@override final  String extension;
@override final  String mimeType;
@override final  int fileSizeBytes;
@override final  String? contentSha256;
@override final  int version;
@override final  String? workspaceId;
@override final  String? projectId;
@override final  String ownerUserId;
@override final  String createdByUserId;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  bool isDeleted;
@override final  StorageProcessingStatus processingStatus;
@override final  StorageScanStatus scanStatus;
@override final  StorageAiStatus aiStatus;
@override final  String? aiDescription;
@override final  List<String>? aiTags;
@override final  String? aiSummary;
@override final  String? aiOcrText;
@override final  int? mediaDurationSeconds;
@override final  int? mediaWidth;
@override final  int? mediaHeight;
@override@JsonKey() final  StorageEffectiveAccessLevel accessLevel;
@override@JsonKey() final  bool canRead;
@override@JsonKey() final  bool canComment;
@override@JsonKey() final  bool canEdit;
@override@JsonKey() final  bool canShare;
@override@JsonKey() final  bool canDelete;
@override@JsonKey() final  bool isFavorite;
@override final  DateTime? favoritedAtUtc;
@override final  DateTime? lastAccessedAtUtc;
@override final  String? manualDescription;
@override final  String? manualDescriptionUpdatedByUserId;
@override final  DateTime? manualDescriptionUpdatedAtUtc;
@override final  String? concurrencyToken;
@override final  String? aiLanguage;
@override final  List<AiDetectedEntity>? aiEntities;
@override@JsonKey() final  bool canPreview;
@override@JsonKey() final  bool canEditOnline;
@override@JsonKey() final  bool canDownload;
@override@JsonKey() final  bool canManageVersions;
@override@JsonKey() final  bool canRestore;
@override@JsonKey() final  bool canConvertToPdf;

/// Create a copy of StorageFileResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFileResponseCopyWith<_StorageFileResponse> get copyWith => __$StorageFileResponseCopyWithImpl<_StorageFileResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFileResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFileResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.module, module) || other.module == module)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.originalFileName, originalFileName) || other.originalFileName == originalFileName)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.version, version) || other.version == version)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus)&&(identical(other.aiStatus, aiStatus) || other.aiStatus == aiStatus)&&(identical(other.aiDescription, aiDescription) || other.aiDescription == aiDescription)&&const DeepCollectionEquality().equals(other.aiTags, aiTags)&&(identical(other.aiSummary, aiSummary) || other.aiSummary == aiSummary)&&(identical(other.aiOcrText, aiOcrText) || other.aiOcrText == aiOcrText)&&(identical(other.mediaDurationSeconds, mediaDurationSeconds) || other.mediaDurationSeconds == mediaDurationSeconds)&&(identical(other.mediaWidth, mediaWidth) || other.mediaWidth == mediaWidth)&&(identical(other.mediaHeight, mediaHeight) || other.mediaHeight == mediaHeight)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.canRead, canRead) || other.canRead == canRead)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.favoritedAtUtc, favoritedAtUtc) || other.favoritedAtUtc == favoritedAtUtc)&&(identical(other.lastAccessedAtUtc, lastAccessedAtUtc) || other.lastAccessedAtUtc == lastAccessedAtUtc)&&(identical(other.manualDescription, manualDescription) || other.manualDescription == manualDescription)&&(identical(other.manualDescriptionUpdatedByUserId, manualDescriptionUpdatedByUserId) || other.manualDescriptionUpdatedByUserId == manualDescriptionUpdatedByUserId)&&(identical(other.manualDescriptionUpdatedAtUtc, manualDescriptionUpdatedAtUtc) || other.manualDescriptionUpdatedAtUtc == manualDescriptionUpdatedAtUtc)&&(identical(other.concurrencyToken, concurrencyToken) || other.concurrencyToken == concurrencyToken)&&(identical(other.aiLanguage, aiLanguage) || other.aiLanguage == aiLanguage)&&const DeepCollectionEquality().equals(other.aiEntities, aiEntities)&&(identical(other.canPreview, canPreview) || other.canPreview == canPreview)&&(identical(other.canEditOnline, canEditOnline) || other.canEditOnline == canEditOnline)&&(identical(other.canDownload, canDownload) || other.canDownload == canDownload)&&(identical(other.canManageVersions, canManageVersions) || other.canManageVersions == canManageVersions)&&(identical(other.canRestore, canRestore) || other.canRestore == canRestore)&&(identical(other.canConvertToPdf, canConvertToPdf) || other.canConvertToPdf == canConvertToPdf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,module,resourceType,resourceId,originalFileName,extension,mimeType,fileSizeBytes,contentSha256,version,workspaceId,projectId,ownerUserId,createdByUserId,createdAtUtc,updatedAtUtc,isDeleted,processingStatus,scanStatus,aiStatus,aiDescription,const DeepCollectionEquality().hash(aiTags),aiSummary,aiOcrText,mediaDurationSeconds,mediaWidth,mediaHeight,accessLevel,canRead,canComment,canEdit,canShare,canDelete,isFavorite,favoritedAtUtc,lastAccessedAtUtc,manualDescription,manualDescriptionUpdatedByUserId,manualDescriptionUpdatedAtUtc,concurrencyToken,aiLanguage,const DeepCollectionEquality().hash(aiEntities),canPreview,canEditOnline,canDownload,canManageVersions,canRestore,canConvertToPdf]);

@override
String toString() {
  return 'StorageFileResponse(id: $id, module: $module, resourceType: $resourceType, resourceId: $resourceId, originalFileName: $originalFileName, extension: $extension, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, contentSha256: $contentSha256, version: $version, workspaceId: $workspaceId, projectId: $projectId, ownerUserId: $ownerUserId, createdByUserId: $createdByUserId, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, isDeleted: $isDeleted, processingStatus: $processingStatus, scanStatus: $scanStatus, aiStatus: $aiStatus, aiDescription: $aiDescription, aiTags: $aiTags, aiSummary: $aiSummary, aiOcrText: $aiOcrText, mediaDurationSeconds: $mediaDurationSeconds, mediaWidth: $mediaWidth, mediaHeight: $mediaHeight, accessLevel: $accessLevel, canRead: $canRead, canComment: $canComment, canEdit: $canEdit, canShare: $canShare, canDelete: $canDelete, isFavorite: $isFavorite, favoritedAtUtc: $favoritedAtUtc, lastAccessedAtUtc: $lastAccessedAtUtc, manualDescription: $manualDescription, manualDescriptionUpdatedByUserId: $manualDescriptionUpdatedByUserId, manualDescriptionUpdatedAtUtc: $manualDescriptionUpdatedAtUtc, concurrencyToken: $concurrencyToken, aiLanguage: $aiLanguage, aiEntities: $aiEntities, canPreview: $canPreview, canEditOnline: $canEditOnline, canDownload: $canDownload, canManageVersions: $canManageVersions, canRestore: $canRestore, canConvertToPdf: $canConvertToPdf)';
}


}

/// @nodoc
abstract mixin class _$StorageFileResponseCopyWith<$Res> implements $StorageFileResponseCopyWith<$Res> {
  factory _$StorageFileResponseCopyWith(_StorageFileResponse value, $Res Function(_StorageFileResponse) _then) = __$StorageFileResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, StorageModule module, StorageResourceType resourceType, String? resourceId, String originalFileName, String extension, String mimeType, int fileSizeBytes, String? contentSha256, int version, String? workspaceId, String? projectId, String ownerUserId, String createdByUserId, DateTime createdAtUtc, DateTime updatedAtUtc, bool isDeleted, StorageProcessingStatus processingStatus, StorageScanStatus scanStatus, StorageAiStatus aiStatus, String? aiDescription, List<String>? aiTags, String? aiSummary, String? aiOcrText, int? mediaDurationSeconds, int? mediaWidth, int? mediaHeight, StorageEffectiveAccessLevel accessLevel, bool canRead, bool canComment, bool canEdit, bool canShare, bool canDelete, bool isFavorite, DateTime? favoritedAtUtc, DateTime? lastAccessedAtUtc, String? manualDescription, String? manualDescriptionUpdatedByUserId, DateTime? manualDescriptionUpdatedAtUtc, String? concurrencyToken, String? aiLanguage, List<AiDetectedEntity>? aiEntities, bool canPreview, bool canEditOnline, bool canDownload, bool canManageVersions, bool canRestore, bool canConvertToPdf
});




}
/// @nodoc
class __$StorageFileResponseCopyWithImpl<$Res>
    implements _$StorageFileResponseCopyWith<$Res> {
  __$StorageFileResponseCopyWithImpl(this._self, this._then);

  final _StorageFileResponse _self;
  final $Res Function(_StorageFileResponse) _then;

/// Create a copy of StorageFileResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? module = null,Object? resourceType = null,Object? resourceId = freezed,Object? originalFileName = null,Object? extension = null,Object? mimeType = null,Object? fileSizeBytes = null,Object? contentSha256 = freezed,Object? version = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? ownerUserId = null,Object? createdByUserId = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? isDeleted = null,Object? processingStatus = null,Object? scanStatus = null,Object? aiStatus = null,Object? aiDescription = freezed,Object? aiTags = freezed,Object? aiSummary = freezed,Object? aiOcrText = freezed,Object? mediaDurationSeconds = freezed,Object? mediaWidth = freezed,Object? mediaHeight = freezed,Object? accessLevel = null,Object? canRead = null,Object? canComment = null,Object? canEdit = null,Object? canShare = null,Object? canDelete = null,Object? isFavorite = null,Object? favoritedAtUtc = freezed,Object? lastAccessedAtUtc = freezed,Object? manualDescription = freezed,Object? manualDescriptionUpdatedByUserId = freezed,Object? manualDescriptionUpdatedAtUtc = freezed,Object? concurrencyToken = freezed,Object? aiLanguage = freezed,Object? aiEntities = freezed,Object? canPreview = null,Object? canEditOnline = null,Object? canDownload = null,Object? canManageVersions = null,Object? canRestore = null,Object? canConvertToPdf = null,}) {
  return _then(_StorageFileResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as StorageModule,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as StorageResourceType,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,originalFileName: null == originalFileName ? _self.originalFileName : originalFileName // ignore: cast_nullable_to_non_nullable
as String,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as StorageProcessingStatus,scanStatus: null == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as StorageScanStatus,aiStatus: null == aiStatus ? _self.aiStatus : aiStatus // ignore: cast_nullable_to_non_nullable
as StorageAiStatus,aiDescription: freezed == aiDescription ? _self.aiDescription : aiDescription // ignore: cast_nullable_to_non_nullable
as String?,aiTags: freezed == aiTags ? _self.aiTags : aiTags // ignore: cast_nullable_to_non_nullable
as List<String>?,aiSummary: freezed == aiSummary ? _self.aiSummary : aiSummary // ignore: cast_nullable_to_non_nullable
as String?,aiOcrText: freezed == aiOcrText ? _self.aiOcrText : aiOcrText // ignore: cast_nullable_to_non_nullable
as String?,mediaDurationSeconds: freezed == mediaDurationSeconds ? _self.mediaDurationSeconds : mediaDurationSeconds // ignore: cast_nullable_to_non_nullable
as int?,mediaWidth: freezed == mediaWidth ? _self.mediaWidth : mediaWidth // ignore: cast_nullable_to_non_nullable
as int?,mediaHeight: freezed == mediaHeight ? _self.mediaHeight : mediaHeight // ignore: cast_nullable_to_non_nullable
as int?,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageEffectiveAccessLevel,canRead: null == canRead ? _self.canRead : canRead // ignore: cast_nullable_to_non_nullable
as bool,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,favoritedAtUtc: freezed == favoritedAtUtc ? _self.favoritedAtUtc : favoritedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAccessedAtUtc: freezed == lastAccessedAtUtc ? _self.lastAccessedAtUtc : lastAccessedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,manualDescription: freezed == manualDescription ? _self.manualDescription : manualDescription // ignore: cast_nullable_to_non_nullable
as String?,manualDescriptionUpdatedByUserId: freezed == manualDescriptionUpdatedByUserId ? _self.manualDescriptionUpdatedByUserId : manualDescriptionUpdatedByUserId // ignore: cast_nullable_to_non_nullable
as String?,manualDescriptionUpdatedAtUtc: freezed == manualDescriptionUpdatedAtUtc ? _self.manualDescriptionUpdatedAtUtc : manualDescriptionUpdatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,concurrencyToken: freezed == concurrencyToken ? _self.concurrencyToken : concurrencyToken // ignore: cast_nullable_to_non_nullable
as String?,aiLanguage: freezed == aiLanguage ? _self.aiLanguage : aiLanguage // ignore: cast_nullable_to_non_nullable
as String?,aiEntities: freezed == aiEntities ? _self.aiEntities : aiEntities // ignore: cast_nullable_to_non_nullable
as List<AiDetectedEntity>?,canPreview: null == canPreview ? _self.canPreview : canPreview // ignore: cast_nullable_to_non_nullable
as bool,canEditOnline: null == canEditOnline ? _self.canEditOnline : canEditOnline // ignore: cast_nullable_to_non_nullable
as bool,canDownload: null == canDownload ? _self.canDownload : canDownload // ignore: cast_nullable_to_non_nullable
as bool,canManageVersions: null == canManageVersions ? _self.canManageVersions : canManageVersions // ignore: cast_nullable_to_non_nullable
as bool,canRestore: null == canRestore ? _self.canRestore : canRestore // ignore: cast_nullable_to_non_nullable
as bool,canConvertToPdf: null == canConvertToPdf ? _self.canConvertToPdf : canConvertToPdf // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BulkCompleteFileItemResult {

 String get fileId; bool get success; StorageFileResponse? get file; String? get errorCode; String? get errorMessage;
/// Create a copy of BulkCompleteFileItemResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkCompleteFileItemResultCopyWith<BulkCompleteFileItemResult> get copyWith => _$BulkCompleteFileItemResultCopyWithImpl<BulkCompleteFileItemResult>(this as BulkCompleteFileItemResult, _$identity);

  /// Serializes this BulkCompleteFileItemResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkCompleteFileItemResult&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.success, success) || other.success == success)&&(identical(other.file, file) || other.file == file)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,success,file,errorCode,errorMessage);

@override
String toString() {
  return 'BulkCompleteFileItemResult(fileId: $fileId, success: $success, file: $file, errorCode: $errorCode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $BulkCompleteFileItemResultCopyWith<$Res>  {
  factory $BulkCompleteFileItemResultCopyWith(BulkCompleteFileItemResult value, $Res Function(BulkCompleteFileItemResult) _then) = _$BulkCompleteFileItemResultCopyWithImpl;
@useResult
$Res call({
 String fileId, bool success, StorageFileResponse? file, String? errorCode, String? errorMessage
});


$StorageFileResponseCopyWith<$Res>? get file;

}
/// @nodoc
class _$BulkCompleteFileItemResultCopyWithImpl<$Res>
    implements $BulkCompleteFileItemResultCopyWith<$Res> {
  _$BulkCompleteFileItemResultCopyWithImpl(this._self, this._then);

  final BulkCompleteFileItemResult _self;
  final $Res Function(BulkCompleteFileItemResult) _then;

/// Create a copy of BulkCompleteFileItemResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? success = null,Object? file = freezed,Object? errorCode = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as StorageFileResponse?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BulkCompleteFileItemResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFileResponseCopyWith<$Res>? get file {
    if (_self.file == null) {
    return null;
  }

  return $StorageFileResponseCopyWith<$Res>(_self.file!, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}


/// Adds pattern-matching-related methods to [BulkCompleteFileItemResult].
extension BulkCompleteFileItemResultPatterns on BulkCompleteFileItemResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkCompleteFileItemResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkCompleteFileItemResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkCompleteFileItemResult value)  $default,){
final _that = this;
switch (_that) {
case _BulkCompleteFileItemResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkCompleteFileItemResult value)?  $default,){
final _that = this;
switch (_that) {
case _BulkCompleteFileItemResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  bool success,  StorageFileResponse? file,  String? errorCode,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkCompleteFileItemResult() when $default != null:
return $default(_that.fileId,_that.success,_that.file,_that.errorCode,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  bool success,  StorageFileResponse? file,  String? errorCode,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _BulkCompleteFileItemResult():
return $default(_that.fileId,_that.success,_that.file,_that.errorCode,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  bool success,  StorageFileResponse? file,  String? errorCode,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _BulkCompleteFileItemResult() when $default != null:
return $default(_that.fileId,_that.success,_that.file,_that.errorCode,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkCompleteFileItemResult implements BulkCompleteFileItemResult {
  const _BulkCompleteFileItemResult({required this.fileId, required this.success, this.file, this.errorCode, this.errorMessage});
  factory _BulkCompleteFileItemResult.fromJson(Map<String, dynamic> json) => _$BulkCompleteFileItemResultFromJson(json);

@override final  String fileId;
@override final  bool success;
@override final  StorageFileResponse? file;
@override final  String? errorCode;
@override final  String? errorMessage;

/// Create a copy of BulkCompleteFileItemResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkCompleteFileItemResultCopyWith<_BulkCompleteFileItemResult> get copyWith => __$BulkCompleteFileItemResultCopyWithImpl<_BulkCompleteFileItemResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkCompleteFileItemResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkCompleteFileItemResult&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.success, success) || other.success == success)&&(identical(other.file, file) || other.file == file)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,success,file,errorCode,errorMessage);

@override
String toString() {
  return 'BulkCompleteFileItemResult(fileId: $fileId, success: $success, file: $file, errorCode: $errorCode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$BulkCompleteFileItemResultCopyWith<$Res> implements $BulkCompleteFileItemResultCopyWith<$Res> {
  factory _$BulkCompleteFileItemResultCopyWith(_BulkCompleteFileItemResult value, $Res Function(_BulkCompleteFileItemResult) _then) = __$BulkCompleteFileItemResultCopyWithImpl;
@override @useResult
$Res call({
 String fileId, bool success, StorageFileResponse? file, String? errorCode, String? errorMessage
});


@override $StorageFileResponseCopyWith<$Res>? get file;

}
/// @nodoc
class __$BulkCompleteFileItemResultCopyWithImpl<$Res>
    implements _$BulkCompleteFileItemResultCopyWith<$Res> {
  __$BulkCompleteFileItemResultCopyWithImpl(this._self, this._then);

  final _BulkCompleteFileItemResult _self;
  final $Res Function(_BulkCompleteFileItemResult) _then;

/// Create a copy of BulkCompleteFileItemResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? success = null,Object? file = freezed,Object? errorCode = freezed,Object? errorMessage = freezed,}) {
  return _then(_BulkCompleteFileItemResult(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as StorageFileResponse?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BulkCompleteFileItemResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFileResponseCopyWith<$Res>? get file {
    if (_self.file == null) {
    return null;
  }

  return $StorageFileResponseCopyWith<$Res>(_self.file!, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}


/// @nodoc
mixin _$BulkCompleteUploadResponse {

 List<BulkCompleteFileItemResult> get results; int get totalCount; int get successCount; int get failedCount;
/// Create a copy of BulkCompleteUploadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkCompleteUploadResponseCopyWith<BulkCompleteUploadResponse> get copyWith => _$BulkCompleteUploadResponseCopyWithImpl<BulkCompleteUploadResponse>(this as BulkCompleteUploadResponse, _$identity);

  /// Serializes this BulkCompleteUploadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkCompleteUploadResponse&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results),totalCount,successCount,failedCount);

@override
String toString() {
  return 'BulkCompleteUploadResponse(results: $results, totalCount: $totalCount, successCount: $successCount, failedCount: $failedCount)';
}


}

/// @nodoc
abstract mixin class $BulkCompleteUploadResponseCopyWith<$Res>  {
  factory $BulkCompleteUploadResponseCopyWith(BulkCompleteUploadResponse value, $Res Function(BulkCompleteUploadResponse) _then) = _$BulkCompleteUploadResponseCopyWithImpl;
@useResult
$Res call({
 List<BulkCompleteFileItemResult> results, int totalCount, int successCount, int failedCount
});




}
/// @nodoc
class _$BulkCompleteUploadResponseCopyWithImpl<$Res>
    implements $BulkCompleteUploadResponseCopyWith<$Res> {
  _$BulkCompleteUploadResponseCopyWithImpl(this._self, this._then);

  final BulkCompleteUploadResponse _self;
  final $Res Function(BulkCompleteUploadResponse) _then;

/// Create a copy of BulkCompleteUploadResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,Object? totalCount = null,Object? successCount = null,Object? failedCount = null,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<BulkCompleteFileItemResult>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkCompleteUploadResponse].
extension BulkCompleteUploadResponsePatterns on BulkCompleteUploadResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkCompleteUploadResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkCompleteUploadResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkCompleteUploadResponse value)  $default,){
final _that = this;
switch (_that) {
case _BulkCompleteUploadResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkCompleteUploadResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BulkCompleteUploadResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BulkCompleteFileItemResult> results,  int totalCount,  int successCount,  int failedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkCompleteUploadResponse() when $default != null:
return $default(_that.results,_that.totalCount,_that.successCount,_that.failedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BulkCompleteFileItemResult> results,  int totalCount,  int successCount,  int failedCount)  $default,) {final _that = this;
switch (_that) {
case _BulkCompleteUploadResponse():
return $default(_that.results,_that.totalCount,_that.successCount,_that.failedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BulkCompleteFileItemResult> results,  int totalCount,  int successCount,  int failedCount)?  $default,) {final _that = this;
switch (_that) {
case _BulkCompleteUploadResponse() when $default != null:
return $default(_that.results,_that.totalCount,_that.successCount,_that.failedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkCompleteUploadResponse implements BulkCompleteUploadResponse {
  const _BulkCompleteUploadResponse({required this.results, required this.totalCount, required this.successCount, required this.failedCount});
  factory _BulkCompleteUploadResponse.fromJson(Map<String, dynamic> json) => _$BulkCompleteUploadResponseFromJson(json);

@override final  List<BulkCompleteFileItemResult> results;
@override final  int totalCount;
@override final  int successCount;
@override final  int failedCount;

/// Create a copy of BulkCompleteUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkCompleteUploadResponseCopyWith<_BulkCompleteUploadResponse> get copyWith => __$BulkCompleteUploadResponseCopyWithImpl<_BulkCompleteUploadResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkCompleteUploadResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkCompleteUploadResponse&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.successCount, successCount) || other.successCount == successCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results),totalCount,successCount,failedCount);

@override
String toString() {
  return 'BulkCompleteUploadResponse(results: $results, totalCount: $totalCount, successCount: $successCount, failedCount: $failedCount)';
}


}

/// @nodoc
abstract mixin class _$BulkCompleteUploadResponseCopyWith<$Res> implements $BulkCompleteUploadResponseCopyWith<$Res> {
  factory _$BulkCompleteUploadResponseCopyWith(_BulkCompleteUploadResponse value, $Res Function(_BulkCompleteUploadResponse) _then) = __$BulkCompleteUploadResponseCopyWithImpl;
@override @useResult
$Res call({
 List<BulkCompleteFileItemResult> results, int totalCount, int successCount, int failedCount
});




}
/// @nodoc
class __$BulkCompleteUploadResponseCopyWithImpl<$Res>
    implements _$BulkCompleteUploadResponseCopyWith<$Res> {
  __$BulkCompleteUploadResponseCopyWithImpl(this._self, this._then);

  final _BulkCompleteUploadResponse _self;
  final $Res Function(_BulkCompleteUploadResponse) _then;

/// Create a copy of BulkCompleteUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,Object? totalCount = null,Object? successCount = null,Object? failedCount = null,}) {
  return _then(_BulkCompleteUploadResponse(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<BulkCompleteFileItemResult>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,successCount: null == successCount ? _self.successCount : successCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
