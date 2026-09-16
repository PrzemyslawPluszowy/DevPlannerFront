// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateStorageDocumentPayload {

 String get name; StorageDocumentFormat get format; StorageModule get module; StorageResourceType get resourceType; String? get projectId; String? get workspaceId; String? get folderId;
/// Create a copy of CreateStorageDocumentPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateStorageDocumentPayloadCopyWith<CreateStorageDocumentPayload> get copyWith => _$CreateStorageDocumentPayloadCopyWithImpl<CreateStorageDocumentPayload>(this as CreateStorageDocumentPayload, _$identity);

  /// Serializes this CreateStorageDocumentPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateStorageDocumentPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.format, format) || other.format == format)&&(identical(other.module, module) || other.module == module)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.folderId, folderId) || other.folderId == folderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,format,module,resourceType,projectId,workspaceId,folderId);

@override
String toString() {
  return 'CreateStorageDocumentPayload(name: $name, format: $format, module: $module, resourceType: $resourceType, projectId: $projectId, workspaceId: $workspaceId, folderId: $folderId)';
}


}

/// @nodoc
abstract mixin class $CreateStorageDocumentPayloadCopyWith<$Res>  {
  factory $CreateStorageDocumentPayloadCopyWith(CreateStorageDocumentPayload value, $Res Function(CreateStorageDocumentPayload) _then) = _$CreateStorageDocumentPayloadCopyWithImpl;
@useResult
$Res call({
 String name, StorageDocumentFormat format, StorageModule module, StorageResourceType resourceType, String? projectId, String? workspaceId, String? folderId
});




}
/// @nodoc
class _$CreateStorageDocumentPayloadCopyWithImpl<$Res>
    implements $CreateStorageDocumentPayloadCopyWith<$Res> {
  _$CreateStorageDocumentPayloadCopyWithImpl(this._self, this._then);

  final CreateStorageDocumentPayload _self;
  final $Res Function(CreateStorageDocumentPayload) _then;

/// Create a copy of CreateStorageDocumentPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? format = null,Object? module = null,Object? resourceType = null,Object? projectId = freezed,Object? workspaceId = freezed,Object? folderId = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as StorageDocumentFormat,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as StorageModule,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as StorageResourceType,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateStorageDocumentPayload].
extension CreateStorageDocumentPayloadPatterns on CreateStorageDocumentPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateStorageDocumentPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateStorageDocumentPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateStorageDocumentPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateStorageDocumentPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateStorageDocumentPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateStorageDocumentPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  StorageDocumentFormat format,  StorageModule module,  StorageResourceType resourceType,  String? projectId,  String? workspaceId,  String? folderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateStorageDocumentPayload() when $default != null:
return $default(_that.name,_that.format,_that.module,_that.resourceType,_that.projectId,_that.workspaceId,_that.folderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  StorageDocumentFormat format,  StorageModule module,  StorageResourceType resourceType,  String? projectId,  String? workspaceId,  String? folderId)  $default,) {final _that = this;
switch (_that) {
case _CreateStorageDocumentPayload():
return $default(_that.name,_that.format,_that.module,_that.resourceType,_that.projectId,_that.workspaceId,_that.folderId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  StorageDocumentFormat format,  StorageModule module,  StorageResourceType resourceType,  String? projectId,  String? workspaceId,  String? folderId)?  $default,) {final _that = this;
switch (_that) {
case _CreateStorageDocumentPayload() when $default != null:
return $default(_that.name,_that.format,_that.module,_that.resourceType,_that.projectId,_that.workspaceId,_that.folderId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateStorageDocumentPayload implements CreateStorageDocumentPayload {
  const _CreateStorageDocumentPayload({required this.name, required this.format, required this.module, required this.resourceType, this.projectId, this.workspaceId, this.folderId});
  factory _CreateStorageDocumentPayload.fromJson(Map<String, dynamic> json) => _$CreateStorageDocumentPayloadFromJson(json);

@override final  String name;
@override final  StorageDocumentFormat format;
@override final  StorageModule module;
@override final  StorageResourceType resourceType;
@override final  String? projectId;
@override final  String? workspaceId;
@override final  String? folderId;

/// Create a copy of CreateStorageDocumentPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateStorageDocumentPayloadCopyWith<_CreateStorageDocumentPayload> get copyWith => __$CreateStorageDocumentPayloadCopyWithImpl<_CreateStorageDocumentPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateStorageDocumentPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateStorageDocumentPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.format, format) || other.format == format)&&(identical(other.module, module) || other.module == module)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.folderId, folderId) || other.folderId == folderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,format,module,resourceType,projectId,workspaceId,folderId);

@override
String toString() {
  return 'CreateStorageDocumentPayload(name: $name, format: $format, module: $module, resourceType: $resourceType, projectId: $projectId, workspaceId: $workspaceId, folderId: $folderId)';
}


}

/// @nodoc
abstract mixin class _$CreateStorageDocumentPayloadCopyWith<$Res> implements $CreateStorageDocumentPayloadCopyWith<$Res> {
  factory _$CreateStorageDocumentPayloadCopyWith(_CreateStorageDocumentPayload value, $Res Function(_CreateStorageDocumentPayload) _then) = __$CreateStorageDocumentPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, StorageDocumentFormat format, StorageModule module, StorageResourceType resourceType, String? projectId, String? workspaceId, String? folderId
});




}
/// @nodoc
class __$CreateStorageDocumentPayloadCopyWithImpl<$Res>
    implements _$CreateStorageDocumentPayloadCopyWith<$Res> {
  __$CreateStorageDocumentPayloadCopyWithImpl(this._self, this._then);

  final _CreateStorageDocumentPayload _self;
  final $Res Function(_CreateStorageDocumentPayload) _then;

/// Create a copy of CreateStorageDocumentPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? format = null,Object? module = null,Object? resourceType = null,Object? projectId = freezed,Object? workspaceId = freezed,Object? folderId = freezed,}) {
  return _then(_CreateStorageDocumentPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as StorageDocumentFormat,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as StorageModule,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as StorageResourceType,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StorageUploadTicketPayload {

 StorageModule get module; StorageResourceType get resourceType; String? get resourceId; String get fileName; int get fileSizeBytes; String? get mimeType; String? get contentSha256; String? get workspaceId; String? get projectId;
/// Create a copy of StorageUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageUploadTicketPayloadCopyWith<StorageUploadTicketPayload> get copyWith => _$StorageUploadTicketPayloadCopyWithImpl<StorageUploadTicketPayload>(this as StorageUploadTicketPayload, _$identity);

  /// Serializes this StorageUploadTicketPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageUploadTicketPayload&&(identical(other.module, module) || other.module == module)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,module,resourceType,resourceId,fileName,fileSizeBytes,mimeType,contentSha256,workspaceId,projectId);

@override
String toString() {
  return 'StorageUploadTicketPayload(module: $module, resourceType: $resourceType, resourceId: $resourceId, fileName: $fileName, fileSizeBytes: $fileSizeBytes, mimeType: $mimeType, contentSha256: $contentSha256, workspaceId: $workspaceId, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class $StorageUploadTicketPayloadCopyWith<$Res>  {
  factory $StorageUploadTicketPayloadCopyWith(StorageUploadTicketPayload value, $Res Function(StorageUploadTicketPayload) _then) = _$StorageUploadTicketPayloadCopyWithImpl;
@useResult
$Res call({
 StorageModule module, StorageResourceType resourceType, String? resourceId, String fileName, int fileSizeBytes, String? mimeType, String? contentSha256, String? workspaceId, String? projectId
});




}
/// @nodoc
class _$StorageUploadTicketPayloadCopyWithImpl<$Res>
    implements $StorageUploadTicketPayloadCopyWith<$Res> {
  _$StorageUploadTicketPayloadCopyWithImpl(this._self, this._then);

  final StorageUploadTicketPayload _self;
  final $Res Function(StorageUploadTicketPayload) _then;

/// Create a copy of StorageUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? module = null,Object? resourceType = null,Object? resourceId = freezed,Object? fileName = null,Object? fileSizeBytes = null,Object? mimeType = freezed,Object? contentSha256 = freezed,Object? workspaceId = freezed,Object? projectId = freezed,}) {
  return _then(_self.copyWith(
module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as StorageModule,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as StorageResourceType,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageUploadTicketPayload].
extension StorageUploadTicketPayloadPatterns on StorageUploadTicketPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageUploadTicketPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageUploadTicketPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageUploadTicketPayload value)  $default,){
final _that = this;
switch (_that) {
case _StorageUploadTicketPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageUploadTicketPayload value)?  $default,){
final _that = this;
switch (_that) {
case _StorageUploadTicketPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StorageModule module,  StorageResourceType resourceType,  String? resourceId,  String fileName,  int fileSizeBytes,  String? mimeType,  String? contentSha256,  String? workspaceId,  String? projectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageUploadTicketPayload() when $default != null:
return $default(_that.module,_that.resourceType,_that.resourceId,_that.fileName,_that.fileSizeBytes,_that.mimeType,_that.contentSha256,_that.workspaceId,_that.projectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StorageModule module,  StorageResourceType resourceType,  String? resourceId,  String fileName,  int fileSizeBytes,  String? mimeType,  String? contentSha256,  String? workspaceId,  String? projectId)  $default,) {final _that = this;
switch (_that) {
case _StorageUploadTicketPayload():
return $default(_that.module,_that.resourceType,_that.resourceId,_that.fileName,_that.fileSizeBytes,_that.mimeType,_that.contentSha256,_that.workspaceId,_that.projectId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StorageModule module,  StorageResourceType resourceType,  String? resourceId,  String fileName,  int fileSizeBytes,  String? mimeType,  String? contentSha256,  String? workspaceId,  String? projectId)?  $default,) {final _that = this;
switch (_that) {
case _StorageUploadTicketPayload() when $default != null:
return $default(_that.module,_that.resourceType,_that.resourceId,_that.fileName,_that.fileSizeBytes,_that.mimeType,_that.contentSha256,_that.workspaceId,_that.projectId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageUploadTicketPayload implements StorageUploadTicketPayload {
  const _StorageUploadTicketPayload({required this.module, required this.resourceType, this.resourceId, required this.fileName, required this.fileSizeBytes, this.mimeType, this.contentSha256, this.workspaceId, this.projectId});
  factory _StorageUploadTicketPayload.fromJson(Map<String, dynamic> json) => _$StorageUploadTicketPayloadFromJson(json);

@override final  StorageModule module;
@override final  StorageResourceType resourceType;
@override final  String? resourceId;
@override final  String fileName;
@override final  int fileSizeBytes;
@override final  String? mimeType;
@override final  String? contentSha256;
@override final  String? workspaceId;
@override final  String? projectId;

/// Create a copy of StorageUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageUploadTicketPayloadCopyWith<_StorageUploadTicketPayload> get copyWith => __$StorageUploadTicketPayloadCopyWithImpl<_StorageUploadTicketPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageUploadTicketPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageUploadTicketPayload&&(identical(other.module, module) || other.module == module)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,module,resourceType,resourceId,fileName,fileSizeBytes,mimeType,contentSha256,workspaceId,projectId);

@override
String toString() {
  return 'StorageUploadTicketPayload(module: $module, resourceType: $resourceType, resourceId: $resourceId, fileName: $fileName, fileSizeBytes: $fileSizeBytes, mimeType: $mimeType, contentSha256: $contentSha256, workspaceId: $workspaceId, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class _$StorageUploadTicketPayloadCopyWith<$Res> implements $StorageUploadTicketPayloadCopyWith<$Res> {
  factory _$StorageUploadTicketPayloadCopyWith(_StorageUploadTicketPayload value, $Res Function(_StorageUploadTicketPayload) _then) = __$StorageUploadTicketPayloadCopyWithImpl;
@override @useResult
$Res call({
 StorageModule module, StorageResourceType resourceType, String? resourceId, String fileName, int fileSizeBytes, String? mimeType, String? contentSha256, String? workspaceId, String? projectId
});




}
/// @nodoc
class __$StorageUploadTicketPayloadCopyWithImpl<$Res>
    implements _$StorageUploadTicketPayloadCopyWith<$Res> {
  __$StorageUploadTicketPayloadCopyWithImpl(this._self, this._then);

  final _StorageUploadTicketPayload _self;
  final $Res Function(_StorageUploadTicketPayload) _then;

/// Create a copy of StorageUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? module = null,Object? resourceType = null,Object? resourceId = freezed,Object? fileName = null,Object? fileSizeBytes = null,Object? mimeType = freezed,Object? contentSha256 = freezed,Object? workspaceId = freezed,Object? projectId = freezed,}) {
  return _then(_StorageUploadTicketPayload(
module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as StorageModule,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as StorageResourceType,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CompleteStorageUploadPayload {

 int get fileSizeBytes; String? get contentSha256; String? get changeSummary;
/// Create a copy of CompleteStorageUploadPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompleteStorageUploadPayloadCopyWith<CompleteStorageUploadPayload> get copyWith => _$CompleteStorageUploadPayloadCopyWithImpl<CompleteStorageUploadPayload>(this as CompleteStorageUploadPayload, _$identity);

  /// Serializes this CompleteStorageUploadPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompleteStorageUploadPayload&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileSizeBytes,contentSha256,changeSummary);

@override
String toString() {
  return 'CompleteStorageUploadPayload(fileSizeBytes: $fileSizeBytes, contentSha256: $contentSha256, changeSummary: $changeSummary)';
}


}

/// @nodoc
abstract mixin class $CompleteStorageUploadPayloadCopyWith<$Res>  {
  factory $CompleteStorageUploadPayloadCopyWith(CompleteStorageUploadPayload value, $Res Function(CompleteStorageUploadPayload) _then) = _$CompleteStorageUploadPayloadCopyWithImpl;
@useResult
$Res call({
 int fileSizeBytes, String? contentSha256, String? changeSummary
});




}
/// @nodoc
class _$CompleteStorageUploadPayloadCopyWithImpl<$Res>
    implements $CompleteStorageUploadPayloadCopyWith<$Res> {
  _$CompleteStorageUploadPayloadCopyWithImpl(this._self, this._then);

  final CompleteStorageUploadPayload _self;
  final $Res Function(CompleteStorageUploadPayload) _then;

/// Create a copy of CompleteStorageUploadPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileSizeBytes = null,Object? contentSha256 = freezed,Object? changeSummary = freezed,}) {
  return _then(_self.copyWith(
fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CompleteStorageUploadPayload].
extension CompleteStorageUploadPayloadPatterns on CompleteStorageUploadPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompleteStorageUploadPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompleteStorageUploadPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompleteStorageUploadPayload value)  $default,){
final _that = this;
switch (_that) {
case _CompleteStorageUploadPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompleteStorageUploadPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CompleteStorageUploadPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fileSizeBytes,  String? contentSha256,  String? changeSummary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompleteStorageUploadPayload() when $default != null:
return $default(_that.fileSizeBytes,_that.contentSha256,_that.changeSummary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fileSizeBytes,  String? contentSha256,  String? changeSummary)  $default,) {final _that = this;
switch (_that) {
case _CompleteStorageUploadPayload():
return $default(_that.fileSizeBytes,_that.contentSha256,_that.changeSummary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fileSizeBytes,  String? contentSha256,  String? changeSummary)?  $default,) {final _that = this;
switch (_that) {
case _CompleteStorageUploadPayload() when $default != null:
return $default(_that.fileSizeBytes,_that.contentSha256,_that.changeSummary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompleteStorageUploadPayload implements CompleteStorageUploadPayload {
  const _CompleteStorageUploadPayload({required this.fileSizeBytes, this.contentSha256, this.changeSummary});
  factory _CompleteStorageUploadPayload.fromJson(Map<String, dynamic> json) => _$CompleteStorageUploadPayloadFromJson(json);

@override final  int fileSizeBytes;
@override final  String? contentSha256;
@override final  String? changeSummary;

/// Create a copy of CompleteStorageUploadPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompleteStorageUploadPayloadCopyWith<_CompleteStorageUploadPayload> get copyWith => __$CompleteStorageUploadPayloadCopyWithImpl<_CompleteStorageUploadPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompleteStorageUploadPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompleteStorageUploadPayload&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileSizeBytes,contentSha256,changeSummary);

@override
String toString() {
  return 'CompleteStorageUploadPayload(fileSizeBytes: $fileSizeBytes, contentSha256: $contentSha256, changeSummary: $changeSummary)';
}


}

/// @nodoc
abstract mixin class _$CompleteStorageUploadPayloadCopyWith<$Res> implements $CompleteStorageUploadPayloadCopyWith<$Res> {
  factory _$CompleteStorageUploadPayloadCopyWith(_CompleteStorageUploadPayload value, $Res Function(_CompleteStorageUploadPayload) _then) = __$CompleteStorageUploadPayloadCopyWithImpl;
@override @useResult
$Res call({
 int fileSizeBytes, String? contentSha256, String? changeSummary
});




}
/// @nodoc
class __$CompleteStorageUploadPayloadCopyWithImpl<$Res>
    implements _$CompleteStorageUploadPayloadCopyWith<$Res> {
  __$CompleteStorageUploadPayloadCopyWithImpl(this._self, this._then);

  final _CompleteStorageUploadPayload _self;
  final $Res Function(_CompleteStorageUploadPayload) _then;

/// Create a copy of CompleteStorageUploadPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileSizeBytes = null,Object? contentSha256 = freezed,Object? changeSummary = freezed,}) {
  return _then(_CompleteStorageUploadPayload(
fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StorageDownloadTicketResponse {

 String get fileId; String get originalFileName; String get mimeType; int get fileSizeBytes; String get downloadUrl; DateTime get expiresAtUtc; String? get previewUrl;
/// Create a copy of StorageDownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageDownloadTicketResponseCopyWith<StorageDownloadTicketResponse> get copyWith => _$StorageDownloadTicketResponseCopyWithImpl<StorageDownloadTicketResponse>(this as StorageDownloadTicketResponse, _$identity);

  /// Serializes this StorageDownloadTicketResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageDownloadTicketResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.originalFileName, originalFileName) || other.originalFileName == originalFileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,originalFileName,mimeType,fileSizeBytes,downloadUrl,expiresAtUtc,previewUrl);

@override
String toString() {
  return 'StorageDownloadTicketResponse(fileId: $fileId, originalFileName: $originalFileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, downloadUrl: $downloadUrl, expiresAtUtc: $expiresAtUtc, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class $StorageDownloadTicketResponseCopyWith<$Res>  {
  factory $StorageDownloadTicketResponseCopyWith(StorageDownloadTicketResponse value, $Res Function(StorageDownloadTicketResponse) _then) = _$StorageDownloadTicketResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, String originalFileName, String mimeType, int fileSizeBytes, String downloadUrl, DateTime expiresAtUtc, String? previewUrl
});




}
/// @nodoc
class _$StorageDownloadTicketResponseCopyWithImpl<$Res>
    implements $StorageDownloadTicketResponseCopyWith<$Res> {
  _$StorageDownloadTicketResponseCopyWithImpl(this._self, this._then);

  final StorageDownloadTicketResponse _self;
  final $Res Function(StorageDownloadTicketResponse) _then;

/// Create a copy of StorageDownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? originalFileName = null,Object? mimeType = null,Object? fileSizeBytes = null,Object? downloadUrl = null,Object? expiresAtUtc = null,Object? previewUrl = freezed,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,originalFileName: null == originalFileName ? _self.originalFileName : originalFileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageDownloadTicketResponse].
extension StorageDownloadTicketResponsePatterns on StorageDownloadTicketResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageDownloadTicketResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageDownloadTicketResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageDownloadTicketResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageDownloadTicketResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageDownloadTicketResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageDownloadTicketResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  String originalFileName,  String mimeType,  int fileSizeBytes,  String downloadUrl,  DateTime expiresAtUtc,  String? previewUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageDownloadTicketResponse() when $default != null:
return $default(_that.fileId,_that.originalFileName,_that.mimeType,_that.fileSizeBytes,_that.downloadUrl,_that.expiresAtUtc,_that.previewUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  String originalFileName,  String mimeType,  int fileSizeBytes,  String downloadUrl,  DateTime expiresAtUtc,  String? previewUrl)  $default,) {final _that = this;
switch (_that) {
case _StorageDownloadTicketResponse():
return $default(_that.fileId,_that.originalFileName,_that.mimeType,_that.fileSizeBytes,_that.downloadUrl,_that.expiresAtUtc,_that.previewUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  String originalFileName,  String mimeType,  int fileSizeBytes,  String downloadUrl,  DateTime expiresAtUtc,  String? previewUrl)?  $default,) {final _that = this;
switch (_that) {
case _StorageDownloadTicketResponse() when $default != null:
return $default(_that.fileId,_that.originalFileName,_that.mimeType,_that.fileSizeBytes,_that.downloadUrl,_that.expiresAtUtc,_that.previewUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageDownloadTicketResponse implements StorageDownloadTicketResponse {
  const _StorageDownloadTicketResponse({required this.fileId, required this.originalFileName, required this.mimeType, required this.fileSizeBytes, required this.downloadUrl, required this.expiresAtUtc, this.previewUrl});
  factory _StorageDownloadTicketResponse.fromJson(Map<String, dynamic> json) => _$StorageDownloadTicketResponseFromJson(json);

@override final  String fileId;
@override final  String originalFileName;
@override final  String mimeType;
@override final  int fileSizeBytes;
@override final  String downloadUrl;
@override final  DateTime expiresAtUtc;
@override final  String? previewUrl;

/// Create a copy of StorageDownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageDownloadTicketResponseCopyWith<_StorageDownloadTicketResponse> get copyWith => __$StorageDownloadTicketResponseCopyWithImpl<_StorageDownloadTicketResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageDownloadTicketResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageDownloadTicketResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.originalFileName, originalFileName) || other.originalFileName == originalFileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,originalFileName,mimeType,fileSizeBytes,downloadUrl,expiresAtUtc,previewUrl);

@override
String toString() {
  return 'StorageDownloadTicketResponse(fileId: $fileId, originalFileName: $originalFileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, downloadUrl: $downloadUrl, expiresAtUtc: $expiresAtUtc, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class _$StorageDownloadTicketResponseCopyWith<$Res> implements $StorageDownloadTicketResponseCopyWith<$Res> {
  factory _$StorageDownloadTicketResponseCopyWith(_StorageDownloadTicketResponse value, $Res Function(_StorageDownloadTicketResponse) _then) = __$StorageDownloadTicketResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, String originalFileName, String mimeType, int fileSizeBytes, String downloadUrl, DateTime expiresAtUtc, String? previewUrl
});




}
/// @nodoc
class __$StorageDownloadTicketResponseCopyWithImpl<$Res>
    implements _$StorageDownloadTicketResponseCopyWith<$Res> {
  __$StorageDownloadTicketResponseCopyWithImpl(this._self, this._then);

  final _StorageDownloadTicketResponse _self;
  final $Res Function(_StorageDownloadTicketResponse) _then;

/// Create a copy of StorageDownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? originalFileName = null,Object? mimeType = null,Object? fileSizeBytes = null,Object? downloadUrl = null,Object? expiresAtUtc = null,Object? previewUrl = freezed,}) {
  return _then(_StorageDownloadTicketResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,originalFileName: null == originalFileName ? _self.originalFileName : originalFileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateStorageFileSharePayload {

 StorageShareType get shareType; StorageShareAccessLevel get accessLevel; String? get sharedWithUserId; String? get sharedWithWorkspaceId; String? get sharedWithProjectId; String? get password; DateTime? get expiresAtUtc;
/// Create a copy of CreateStorageFileSharePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateStorageFileSharePayloadCopyWith<CreateStorageFileSharePayload> get copyWith => _$CreateStorageFileSharePayloadCopyWithImpl<CreateStorageFileSharePayload>(this as CreateStorageFileSharePayload, _$identity);

  /// Serializes this CreateStorageFileSharePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateStorageFileSharePayload&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.sharedWithUserId, sharedWithUserId) || other.sharedWithUserId == sharedWithUserId)&&(identical(other.sharedWithWorkspaceId, sharedWithWorkspaceId) || other.sharedWithWorkspaceId == sharedWithWorkspaceId)&&(identical(other.sharedWithProjectId, sharedWithProjectId) || other.sharedWithProjectId == sharedWithProjectId)&&(identical(other.password, password) || other.password == password)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shareType,accessLevel,sharedWithUserId,sharedWithWorkspaceId,sharedWithProjectId,password,expiresAtUtc);

@override
String toString() {
  return 'CreateStorageFileSharePayload(shareType: $shareType, accessLevel: $accessLevel, sharedWithUserId: $sharedWithUserId, sharedWithWorkspaceId: $sharedWithWorkspaceId, sharedWithProjectId: $sharedWithProjectId, password: $password, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class $CreateStorageFileSharePayloadCopyWith<$Res>  {
  factory $CreateStorageFileSharePayloadCopyWith(CreateStorageFileSharePayload value, $Res Function(CreateStorageFileSharePayload) _then) = _$CreateStorageFileSharePayloadCopyWithImpl;
@useResult
$Res call({
 StorageShareType shareType, StorageShareAccessLevel accessLevel, String? sharedWithUserId, String? sharedWithWorkspaceId, String? sharedWithProjectId, String? password, DateTime? expiresAtUtc
});




}
/// @nodoc
class _$CreateStorageFileSharePayloadCopyWithImpl<$Res>
    implements $CreateStorageFileSharePayloadCopyWith<$Res> {
  _$CreateStorageFileSharePayloadCopyWithImpl(this._self, this._then);

  final CreateStorageFileSharePayload _self;
  final $Res Function(CreateStorageFileSharePayload) _then;

/// Create a copy of CreateStorageFileSharePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shareType = null,Object? accessLevel = null,Object? sharedWithUserId = freezed,Object? sharedWithWorkspaceId = freezed,Object? sharedWithProjectId = freezed,Object? password = freezed,Object? expiresAtUtc = freezed,}) {
  return _then(_self.copyWith(
shareType: null == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as StorageShareType,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageShareAccessLevel,sharedWithUserId: freezed == sharedWithUserId ? _self.sharedWithUserId : sharedWithUserId // ignore: cast_nullable_to_non_nullable
as String?,sharedWithWorkspaceId: freezed == sharedWithWorkspaceId ? _self.sharedWithWorkspaceId : sharedWithWorkspaceId // ignore: cast_nullable_to_non_nullable
as String?,sharedWithProjectId: freezed == sharedWithProjectId ? _self.sharedWithProjectId : sharedWithProjectId // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateStorageFileSharePayload].
extension CreateStorageFileSharePayloadPatterns on CreateStorageFileSharePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateStorageFileSharePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateStorageFileSharePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateStorageFileSharePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateStorageFileSharePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateStorageFileSharePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateStorageFileSharePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StorageShareType shareType,  StorageShareAccessLevel accessLevel,  String? sharedWithUserId,  String? sharedWithWorkspaceId,  String? sharedWithProjectId,  String? password,  DateTime? expiresAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateStorageFileSharePayload() when $default != null:
return $default(_that.shareType,_that.accessLevel,_that.sharedWithUserId,_that.sharedWithWorkspaceId,_that.sharedWithProjectId,_that.password,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StorageShareType shareType,  StorageShareAccessLevel accessLevel,  String? sharedWithUserId,  String? sharedWithWorkspaceId,  String? sharedWithProjectId,  String? password,  DateTime? expiresAtUtc)  $default,) {final _that = this;
switch (_that) {
case _CreateStorageFileSharePayload():
return $default(_that.shareType,_that.accessLevel,_that.sharedWithUserId,_that.sharedWithWorkspaceId,_that.sharedWithProjectId,_that.password,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StorageShareType shareType,  StorageShareAccessLevel accessLevel,  String? sharedWithUserId,  String? sharedWithWorkspaceId,  String? sharedWithProjectId,  String? password,  DateTime? expiresAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _CreateStorageFileSharePayload() when $default != null:
return $default(_that.shareType,_that.accessLevel,_that.sharedWithUserId,_that.sharedWithWorkspaceId,_that.sharedWithProjectId,_that.password,_that.expiresAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateStorageFileSharePayload implements CreateStorageFileSharePayload {
  const _CreateStorageFileSharePayload({required this.shareType, required this.accessLevel, this.sharedWithUserId, this.sharedWithWorkspaceId, this.sharedWithProjectId, this.password, this.expiresAtUtc});
  factory _CreateStorageFileSharePayload.fromJson(Map<String, dynamic> json) => _$CreateStorageFileSharePayloadFromJson(json);

@override final  StorageShareType shareType;
@override final  StorageShareAccessLevel accessLevel;
@override final  String? sharedWithUserId;
@override final  String? sharedWithWorkspaceId;
@override final  String? sharedWithProjectId;
@override final  String? password;
@override final  DateTime? expiresAtUtc;

/// Create a copy of CreateStorageFileSharePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateStorageFileSharePayloadCopyWith<_CreateStorageFileSharePayload> get copyWith => __$CreateStorageFileSharePayloadCopyWithImpl<_CreateStorageFileSharePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateStorageFileSharePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateStorageFileSharePayload&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.sharedWithUserId, sharedWithUserId) || other.sharedWithUserId == sharedWithUserId)&&(identical(other.sharedWithWorkspaceId, sharedWithWorkspaceId) || other.sharedWithWorkspaceId == sharedWithWorkspaceId)&&(identical(other.sharedWithProjectId, sharedWithProjectId) || other.sharedWithProjectId == sharedWithProjectId)&&(identical(other.password, password) || other.password == password)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shareType,accessLevel,sharedWithUserId,sharedWithWorkspaceId,sharedWithProjectId,password,expiresAtUtc);

@override
String toString() {
  return 'CreateStorageFileSharePayload(shareType: $shareType, accessLevel: $accessLevel, sharedWithUserId: $sharedWithUserId, sharedWithWorkspaceId: $sharedWithWorkspaceId, sharedWithProjectId: $sharedWithProjectId, password: $password, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class _$CreateStorageFileSharePayloadCopyWith<$Res> implements $CreateStorageFileSharePayloadCopyWith<$Res> {
  factory _$CreateStorageFileSharePayloadCopyWith(_CreateStorageFileSharePayload value, $Res Function(_CreateStorageFileSharePayload) _then) = __$CreateStorageFileSharePayloadCopyWithImpl;
@override @useResult
$Res call({
 StorageShareType shareType, StorageShareAccessLevel accessLevel, String? sharedWithUserId, String? sharedWithWorkspaceId, String? sharedWithProjectId, String? password, DateTime? expiresAtUtc
});




}
/// @nodoc
class __$CreateStorageFileSharePayloadCopyWithImpl<$Res>
    implements _$CreateStorageFileSharePayloadCopyWith<$Res> {
  __$CreateStorageFileSharePayloadCopyWithImpl(this._self, this._then);

  final _CreateStorageFileSharePayload _self;
  final $Res Function(_CreateStorageFileSharePayload) _then;

/// Create a copy of CreateStorageFileSharePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shareType = null,Object? accessLevel = null,Object? sharedWithUserId = freezed,Object? sharedWithWorkspaceId = freezed,Object? sharedWithProjectId = freezed,Object? password = freezed,Object? expiresAtUtc = freezed,}) {
  return _then(_CreateStorageFileSharePayload(
shareType: null == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as StorageShareType,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageShareAccessLevel,sharedWithUserId: freezed == sharedWithUserId ? _self.sharedWithUserId : sharedWithUserId // ignore: cast_nullable_to_non_nullable
as String?,sharedWithWorkspaceId: freezed == sharedWithWorkspaceId ? _self.sharedWithWorkspaceId : sharedWithWorkspaceId // ignore: cast_nullable_to_non_nullable
as String?,sharedWithProjectId: freezed == sharedWithProjectId ? _self.sharedWithProjectId : sharedWithProjectId // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StorageFileShareResponse {

 String get id; String get fileId; StorageShareType get shareType; StorageShareAccessLevel get accessLevel; String? get sharedWithUserId; String? get sharedWithWorkspaceId; String? get sharedWithProjectId; String? get shareToken; DateTime? get expiresAtUtc; String get createdByUserId; DateTime get createdAtUtc; StorageEffectiveAccessLevel get effectiveAccessLevel; bool get canRead; bool get canComment; bool get canEdit; bool get canShare; bool get canDelete;
/// Create a copy of StorageFileShareResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFileShareResponseCopyWith<StorageFileShareResponse> get copyWith => _$StorageFileShareResponseCopyWithImpl<StorageFileShareResponse>(this as StorageFileShareResponse, _$identity);

  /// Serializes this StorageFileShareResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFileShareResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.sharedWithUserId, sharedWithUserId) || other.sharedWithUserId == sharedWithUserId)&&(identical(other.sharedWithWorkspaceId, sharedWithWorkspaceId) || other.sharedWithWorkspaceId == sharedWithWorkspaceId)&&(identical(other.sharedWithProjectId, sharedWithProjectId) || other.sharedWithProjectId == sharedWithProjectId)&&(identical(other.shareToken, shareToken) || other.shareToken == shareToken)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.effectiveAccessLevel, effectiveAccessLevel) || other.effectiveAccessLevel == effectiveAccessLevel)&&(identical(other.canRead, canRead) || other.canRead == canRead)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fileId,shareType,accessLevel,sharedWithUserId,sharedWithWorkspaceId,sharedWithProjectId,shareToken,expiresAtUtc,createdByUserId,createdAtUtc,effectiveAccessLevel,canRead,canComment,canEdit,canShare,canDelete);

@override
String toString() {
  return 'StorageFileShareResponse(id: $id, fileId: $fileId, shareType: $shareType, accessLevel: $accessLevel, sharedWithUserId: $sharedWithUserId, sharedWithWorkspaceId: $sharedWithWorkspaceId, sharedWithProjectId: $sharedWithProjectId, shareToken: $shareToken, expiresAtUtc: $expiresAtUtc, createdByUserId: $createdByUserId, createdAtUtc: $createdAtUtc, effectiveAccessLevel: $effectiveAccessLevel, canRead: $canRead, canComment: $canComment, canEdit: $canEdit, canShare: $canShare, canDelete: $canDelete)';
}


}

/// @nodoc
abstract mixin class $StorageFileShareResponseCopyWith<$Res>  {
  factory $StorageFileShareResponseCopyWith(StorageFileShareResponse value, $Res Function(StorageFileShareResponse) _then) = _$StorageFileShareResponseCopyWithImpl;
@useResult
$Res call({
 String id, String fileId, StorageShareType shareType, StorageShareAccessLevel accessLevel, String? sharedWithUserId, String? sharedWithWorkspaceId, String? sharedWithProjectId, String? shareToken, DateTime? expiresAtUtc, String createdByUserId, DateTime createdAtUtc, StorageEffectiveAccessLevel effectiveAccessLevel, bool canRead, bool canComment, bool canEdit, bool canShare, bool canDelete
});




}
/// @nodoc
class _$StorageFileShareResponseCopyWithImpl<$Res>
    implements $StorageFileShareResponseCopyWith<$Res> {
  _$StorageFileShareResponseCopyWithImpl(this._self, this._then);

  final StorageFileShareResponse _self;
  final $Res Function(StorageFileShareResponse) _then;

/// Create a copy of StorageFileShareResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fileId = null,Object? shareType = null,Object? accessLevel = null,Object? sharedWithUserId = freezed,Object? sharedWithWorkspaceId = freezed,Object? sharedWithProjectId = freezed,Object? shareToken = freezed,Object? expiresAtUtc = freezed,Object? createdByUserId = null,Object? createdAtUtc = null,Object? effectiveAccessLevel = null,Object? canRead = null,Object? canComment = null,Object? canEdit = null,Object? canShare = null,Object? canDelete = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,shareType: null == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as StorageShareType,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageShareAccessLevel,sharedWithUserId: freezed == sharedWithUserId ? _self.sharedWithUserId : sharedWithUserId // ignore: cast_nullable_to_non_nullable
as String?,sharedWithWorkspaceId: freezed == sharedWithWorkspaceId ? _self.sharedWithWorkspaceId : sharedWithWorkspaceId // ignore: cast_nullable_to_non_nullable
as String?,sharedWithProjectId: freezed == sharedWithProjectId ? _self.sharedWithProjectId : sharedWithProjectId // ignore: cast_nullable_to_non_nullable
as String?,shareToken: freezed == shareToken ? _self.shareToken : shareToken // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveAccessLevel: null == effectiveAccessLevel ? _self.effectiveAccessLevel : effectiveAccessLevel // ignore: cast_nullable_to_non_nullable
as StorageEffectiveAccessLevel,canRead: null == canRead ? _self.canRead : canRead // ignore: cast_nullable_to_non_nullable
as bool,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageFileShareResponse].
extension StorageFileShareResponsePatterns on StorageFileShareResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFileShareResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFileShareResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFileShareResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFileShareResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFileShareResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFileShareResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fileId,  StorageShareType shareType,  StorageShareAccessLevel accessLevel,  String? sharedWithUserId,  String? sharedWithWorkspaceId,  String? sharedWithProjectId,  String? shareToken,  DateTime? expiresAtUtc,  String createdByUserId,  DateTime createdAtUtc,  StorageEffectiveAccessLevel effectiveAccessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFileShareResponse() when $default != null:
return $default(_that.id,_that.fileId,_that.shareType,_that.accessLevel,_that.sharedWithUserId,_that.sharedWithWorkspaceId,_that.sharedWithProjectId,_that.shareToken,_that.expiresAtUtc,_that.createdByUserId,_that.createdAtUtc,_that.effectiveAccessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fileId,  StorageShareType shareType,  StorageShareAccessLevel accessLevel,  String? sharedWithUserId,  String? sharedWithWorkspaceId,  String? sharedWithProjectId,  String? shareToken,  DateTime? expiresAtUtc,  String createdByUserId,  DateTime createdAtUtc,  StorageEffectiveAccessLevel effectiveAccessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete)  $default,) {final _that = this;
switch (_that) {
case _StorageFileShareResponse():
return $default(_that.id,_that.fileId,_that.shareType,_that.accessLevel,_that.sharedWithUserId,_that.sharedWithWorkspaceId,_that.sharedWithProjectId,_that.shareToken,_that.expiresAtUtc,_that.createdByUserId,_that.createdAtUtc,_that.effectiveAccessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fileId,  StorageShareType shareType,  StorageShareAccessLevel accessLevel,  String? sharedWithUserId,  String? sharedWithWorkspaceId,  String? sharedWithProjectId,  String? shareToken,  DateTime? expiresAtUtc,  String createdByUserId,  DateTime createdAtUtc,  StorageEffectiveAccessLevel effectiveAccessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete)?  $default,) {final _that = this;
switch (_that) {
case _StorageFileShareResponse() when $default != null:
return $default(_that.id,_that.fileId,_that.shareType,_that.accessLevel,_that.sharedWithUserId,_that.sharedWithWorkspaceId,_that.sharedWithProjectId,_that.shareToken,_that.expiresAtUtc,_that.createdByUserId,_that.createdAtUtc,_that.effectiveAccessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFileShareResponse implements StorageFileShareResponse {
  const _StorageFileShareResponse({required this.id, required this.fileId, required this.shareType, required this.accessLevel, this.sharedWithUserId, this.sharedWithWorkspaceId, this.sharedWithProjectId, this.shareToken, this.expiresAtUtc, required this.createdByUserId, required this.createdAtUtc, required this.effectiveAccessLevel, required this.canRead, required this.canComment, required this.canEdit, required this.canShare, required this.canDelete});
  factory _StorageFileShareResponse.fromJson(Map<String, dynamic> json) => _$StorageFileShareResponseFromJson(json);

@override final  String id;
@override final  String fileId;
@override final  StorageShareType shareType;
@override final  StorageShareAccessLevel accessLevel;
@override final  String? sharedWithUserId;
@override final  String? sharedWithWorkspaceId;
@override final  String? sharedWithProjectId;
@override final  String? shareToken;
@override final  DateTime? expiresAtUtc;
@override final  String createdByUserId;
@override final  DateTime createdAtUtc;
@override final  StorageEffectiveAccessLevel effectiveAccessLevel;
@override final  bool canRead;
@override final  bool canComment;
@override final  bool canEdit;
@override final  bool canShare;
@override final  bool canDelete;

/// Create a copy of StorageFileShareResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFileShareResponseCopyWith<_StorageFileShareResponse> get copyWith => __$StorageFileShareResponseCopyWithImpl<_StorageFileShareResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFileShareResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFileShareResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.sharedWithUserId, sharedWithUserId) || other.sharedWithUserId == sharedWithUserId)&&(identical(other.sharedWithWorkspaceId, sharedWithWorkspaceId) || other.sharedWithWorkspaceId == sharedWithWorkspaceId)&&(identical(other.sharedWithProjectId, sharedWithProjectId) || other.sharedWithProjectId == sharedWithProjectId)&&(identical(other.shareToken, shareToken) || other.shareToken == shareToken)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.effectiveAccessLevel, effectiveAccessLevel) || other.effectiveAccessLevel == effectiveAccessLevel)&&(identical(other.canRead, canRead) || other.canRead == canRead)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fileId,shareType,accessLevel,sharedWithUserId,sharedWithWorkspaceId,sharedWithProjectId,shareToken,expiresAtUtc,createdByUserId,createdAtUtc,effectiveAccessLevel,canRead,canComment,canEdit,canShare,canDelete);

@override
String toString() {
  return 'StorageFileShareResponse(id: $id, fileId: $fileId, shareType: $shareType, accessLevel: $accessLevel, sharedWithUserId: $sharedWithUserId, sharedWithWorkspaceId: $sharedWithWorkspaceId, sharedWithProjectId: $sharedWithProjectId, shareToken: $shareToken, expiresAtUtc: $expiresAtUtc, createdByUserId: $createdByUserId, createdAtUtc: $createdAtUtc, effectiveAccessLevel: $effectiveAccessLevel, canRead: $canRead, canComment: $canComment, canEdit: $canEdit, canShare: $canShare, canDelete: $canDelete)';
}


}

/// @nodoc
abstract mixin class _$StorageFileShareResponseCopyWith<$Res> implements $StorageFileShareResponseCopyWith<$Res> {
  factory _$StorageFileShareResponseCopyWith(_StorageFileShareResponse value, $Res Function(_StorageFileShareResponse) _then) = __$StorageFileShareResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String fileId, StorageShareType shareType, StorageShareAccessLevel accessLevel, String? sharedWithUserId, String? sharedWithWorkspaceId, String? sharedWithProjectId, String? shareToken, DateTime? expiresAtUtc, String createdByUserId, DateTime createdAtUtc, StorageEffectiveAccessLevel effectiveAccessLevel, bool canRead, bool canComment, bool canEdit, bool canShare, bool canDelete
});




}
/// @nodoc
class __$StorageFileShareResponseCopyWithImpl<$Res>
    implements _$StorageFileShareResponseCopyWith<$Res> {
  __$StorageFileShareResponseCopyWithImpl(this._self, this._then);

  final _StorageFileShareResponse _self;
  final $Res Function(_StorageFileShareResponse) _then;

/// Create a copy of StorageFileShareResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fileId = null,Object? shareType = null,Object? accessLevel = null,Object? sharedWithUserId = freezed,Object? sharedWithWorkspaceId = freezed,Object? sharedWithProjectId = freezed,Object? shareToken = freezed,Object? expiresAtUtc = freezed,Object? createdByUserId = null,Object? createdAtUtc = null,Object? effectiveAccessLevel = null,Object? canRead = null,Object? canComment = null,Object? canEdit = null,Object? canShare = null,Object? canDelete = null,}) {
  return _then(_StorageFileShareResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,shareType: null == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as StorageShareType,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageShareAccessLevel,sharedWithUserId: freezed == sharedWithUserId ? _self.sharedWithUserId : sharedWithUserId // ignore: cast_nullable_to_non_nullable
as String?,sharedWithWorkspaceId: freezed == sharedWithWorkspaceId ? _self.sharedWithWorkspaceId : sharedWithWorkspaceId // ignore: cast_nullable_to_non_nullable
as String?,sharedWithProjectId: freezed == sharedWithProjectId ? _self.sharedWithProjectId : sharedWithProjectId // ignore: cast_nullable_to_non_nullable
as String?,shareToken: freezed == shareToken ? _self.shareToken : shareToken // ignore: cast_nullable_to_non_nullable
as String?,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveAccessLevel: null == effectiveAccessLevel ? _self.effectiveAccessLevel : effectiveAccessLevel // ignore: cast_nullable_to_non_nullable
as StorageEffectiveAccessLevel,canRead: null == canRead ? _self.canRead : canRead // ignore: cast_nullable_to_non_nullable
as bool,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CreateStorageFolderPayload {

 StorageFolderType get folderType; String get name; String? get parentFolderId; String? get ownerUserId; String? get workspaceId; String? get projectId;
/// Create a copy of CreateStorageFolderPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateStorageFolderPayloadCopyWith<CreateStorageFolderPayload> get copyWith => _$CreateStorageFolderPayloadCopyWithImpl<CreateStorageFolderPayload>(this as CreateStorageFolderPayload, _$identity);

  /// Serializes this CreateStorageFolderPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateStorageFolderPayload&&(identical(other.folderType, folderType) || other.folderType == folderType)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentFolderId, parentFolderId) || other.parentFolderId == parentFolderId)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,folderType,name,parentFolderId,ownerUserId,workspaceId,projectId);

@override
String toString() {
  return 'CreateStorageFolderPayload(folderType: $folderType, name: $name, parentFolderId: $parentFolderId, ownerUserId: $ownerUserId, workspaceId: $workspaceId, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class $CreateStorageFolderPayloadCopyWith<$Res>  {
  factory $CreateStorageFolderPayloadCopyWith(CreateStorageFolderPayload value, $Res Function(CreateStorageFolderPayload) _then) = _$CreateStorageFolderPayloadCopyWithImpl;
@useResult
$Res call({
 StorageFolderType folderType, String name, String? parentFolderId, String? ownerUserId, String? workspaceId, String? projectId
});




}
/// @nodoc
class _$CreateStorageFolderPayloadCopyWithImpl<$Res>
    implements $CreateStorageFolderPayloadCopyWith<$Res> {
  _$CreateStorageFolderPayloadCopyWithImpl(this._self, this._then);

  final CreateStorageFolderPayload _self;
  final $Res Function(CreateStorageFolderPayload) _then;

/// Create a copy of CreateStorageFolderPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderType = null,Object? name = null,Object? parentFolderId = freezed,Object? ownerUserId = freezed,Object? workspaceId = freezed,Object? projectId = freezed,}) {
  return _then(_self.copyWith(
folderType: null == folderType ? _self.folderType : folderType // ignore: cast_nullable_to_non_nullable
as StorageFolderType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentFolderId: freezed == parentFolderId ? _self.parentFolderId : parentFolderId // ignore: cast_nullable_to_non_nullable
as String?,ownerUserId: freezed == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateStorageFolderPayload].
extension CreateStorageFolderPayloadPatterns on CreateStorageFolderPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateStorageFolderPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateStorageFolderPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateStorageFolderPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateStorageFolderPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateStorageFolderPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateStorageFolderPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StorageFolderType folderType,  String name,  String? parentFolderId,  String? ownerUserId,  String? workspaceId,  String? projectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateStorageFolderPayload() when $default != null:
return $default(_that.folderType,_that.name,_that.parentFolderId,_that.ownerUserId,_that.workspaceId,_that.projectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StorageFolderType folderType,  String name,  String? parentFolderId,  String? ownerUserId,  String? workspaceId,  String? projectId)  $default,) {final _that = this;
switch (_that) {
case _CreateStorageFolderPayload():
return $default(_that.folderType,_that.name,_that.parentFolderId,_that.ownerUserId,_that.workspaceId,_that.projectId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StorageFolderType folderType,  String name,  String? parentFolderId,  String? ownerUserId,  String? workspaceId,  String? projectId)?  $default,) {final _that = this;
switch (_that) {
case _CreateStorageFolderPayload() when $default != null:
return $default(_that.folderType,_that.name,_that.parentFolderId,_that.ownerUserId,_that.workspaceId,_that.projectId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateStorageFolderPayload implements CreateStorageFolderPayload {
  const _CreateStorageFolderPayload({required this.folderType, required this.name, this.parentFolderId, this.ownerUserId, this.workspaceId, this.projectId});
  factory _CreateStorageFolderPayload.fromJson(Map<String, dynamic> json) => _$CreateStorageFolderPayloadFromJson(json);

@override final  StorageFolderType folderType;
@override final  String name;
@override final  String? parentFolderId;
@override final  String? ownerUserId;
@override final  String? workspaceId;
@override final  String? projectId;

/// Create a copy of CreateStorageFolderPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateStorageFolderPayloadCopyWith<_CreateStorageFolderPayload> get copyWith => __$CreateStorageFolderPayloadCopyWithImpl<_CreateStorageFolderPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateStorageFolderPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateStorageFolderPayload&&(identical(other.folderType, folderType) || other.folderType == folderType)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentFolderId, parentFolderId) || other.parentFolderId == parentFolderId)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,folderType,name,parentFolderId,ownerUserId,workspaceId,projectId);

@override
String toString() {
  return 'CreateStorageFolderPayload(folderType: $folderType, name: $name, parentFolderId: $parentFolderId, ownerUserId: $ownerUserId, workspaceId: $workspaceId, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class _$CreateStorageFolderPayloadCopyWith<$Res> implements $CreateStorageFolderPayloadCopyWith<$Res> {
  factory _$CreateStorageFolderPayloadCopyWith(_CreateStorageFolderPayload value, $Res Function(_CreateStorageFolderPayload) _then) = __$CreateStorageFolderPayloadCopyWithImpl;
@override @useResult
$Res call({
 StorageFolderType folderType, String name, String? parentFolderId, String? ownerUserId, String? workspaceId, String? projectId
});




}
/// @nodoc
class __$CreateStorageFolderPayloadCopyWithImpl<$Res>
    implements _$CreateStorageFolderPayloadCopyWith<$Res> {
  __$CreateStorageFolderPayloadCopyWithImpl(this._self, this._then);

  final _CreateStorageFolderPayload _self;
  final $Res Function(_CreateStorageFolderPayload) _then;

/// Create a copy of CreateStorageFolderPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderType = null,Object? name = null,Object? parentFolderId = freezed,Object? ownerUserId = freezed,Object? workspaceId = freezed,Object? projectId = freezed,}) {
  return _then(_CreateStorageFolderPayload(
folderType: null == folderType ? _self.folderType : folderType // ignore: cast_nullable_to_non_nullable
as StorageFolderType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentFolderId: freezed == parentFolderId ? _self.parentFolderId : parentFolderId // ignore: cast_nullable_to_non_nullable
as String?,ownerUserId: freezed == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StorageFolderResponse {

 String get id; String get name; StorageFolderType get folderType; String? get parentFolderId; String? get workspaceId; String? get projectId; bool get canRead; bool get canComment; bool get canEdit; bool get canShare; bool get canDelete; int get itemCount; DateTime get updatedAtUtc; StorageEffectiveAccessLevel get accessLevel;
/// Create a copy of StorageFolderResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFolderResponseCopyWith<StorageFolderResponse> get copyWith => _$StorageFolderResponseCopyWithImpl<StorageFolderResponse>(this as StorageFolderResponse, _$identity);

  /// Serializes this StorageFolderResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFolderResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.folderType, folderType) || other.folderType == folderType)&&(identical(other.parentFolderId, parentFolderId) || other.parentFolderId == parentFolderId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.canRead, canRead) || other.canRead == canRead)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,folderType,parentFolderId,workspaceId,projectId,canRead,canComment,canEdit,canShare,canDelete,itemCount,updatedAtUtc,accessLevel);

@override
String toString() {
  return 'StorageFolderResponse(id: $id, name: $name, folderType: $folderType, parentFolderId: $parentFolderId, workspaceId: $workspaceId, projectId: $projectId, canRead: $canRead, canComment: $canComment, canEdit: $canEdit, canShare: $canShare, canDelete: $canDelete, itemCount: $itemCount, updatedAtUtc: $updatedAtUtc, accessLevel: $accessLevel)';
}


}

/// @nodoc
abstract mixin class $StorageFolderResponseCopyWith<$Res>  {
  factory $StorageFolderResponseCopyWith(StorageFolderResponse value, $Res Function(StorageFolderResponse) _then) = _$StorageFolderResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, StorageFolderType folderType, String? parentFolderId, String? workspaceId, String? projectId, bool canRead, bool canComment, bool canEdit, bool canShare, bool canDelete, int itemCount, DateTime updatedAtUtc, StorageEffectiveAccessLevel accessLevel
});




}
/// @nodoc
class _$StorageFolderResponseCopyWithImpl<$Res>
    implements $StorageFolderResponseCopyWith<$Res> {
  _$StorageFolderResponseCopyWithImpl(this._self, this._then);

  final StorageFolderResponse _self;
  final $Res Function(StorageFolderResponse) _then;

/// Create a copy of StorageFolderResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? folderType = null,Object? parentFolderId = freezed,Object? workspaceId = freezed,Object? projectId = freezed,Object? canRead = null,Object? canComment = null,Object? canEdit = null,Object? canShare = null,Object? canDelete = null,Object? itemCount = null,Object? updatedAtUtc = null,Object? accessLevel = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,folderType: null == folderType ? _self.folderType : folderType // ignore: cast_nullable_to_non_nullable
as StorageFolderType,parentFolderId: freezed == parentFolderId ? _self.parentFolderId : parentFolderId // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,canRead: null == canRead ? _self.canRead : canRead // ignore: cast_nullable_to_non_nullable
as bool,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageEffectiveAccessLevel,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageFolderResponse].
extension StorageFolderResponsePatterns on StorageFolderResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFolderResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFolderResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFolderResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFolderResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFolderResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFolderResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  StorageFolderType folderType,  String? parentFolderId,  String? workspaceId,  String? projectId,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete,  int itemCount,  DateTime updatedAtUtc,  StorageEffectiveAccessLevel accessLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFolderResponse() when $default != null:
return $default(_that.id,_that.name,_that.folderType,_that.parentFolderId,_that.workspaceId,_that.projectId,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete,_that.itemCount,_that.updatedAtUtc,_that.accessLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  StorageFolderType folderType,  String? parentFolderId,  String? workspaceId,  String? projectId,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete,  int itemCount,  DateTime updatedAtUtc,  StorageEffectiveAccessLevel accessLevel)  $default,) {final _that = this;
switch (_that) {
case _StorageFolderResponse():
return $default(_that.id,_that.name,_that.folderType,_that.parentFolderId,_that.workspaceId,_that.projectId,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete,_that.itemCount,_that.updatedAtUtc,_that.accessLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  StorageFolderType folderType,  String? parentFolderId,  String? workspaceId,  String? projectId,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete,  int itemCount,  DateTime updatedAtUtc,  StorageEffectiveAccessLevel accessLevel)?  $default,) {final _that = this;
switch (_that) {
case _StorageFolderResponse() when $default != null:
return $default(_that.id,_that.name,_that.folderType,_that.parentFolderId,_that.workspaceId,_that.projectId,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete,_that.itemCount,_that.updatedAtUtc,_that.accessLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFolderResponse implements StorageFolderResponse {
  const _StorageFolderResponse({required this.id, required this.name, required this.folderType, this.parentFolderId, this.workspaceId, this.projectId, required this.canRead, required this.canComment, required this.canEdit, required this.canShare, required this.canDelete, required this.itemCount, required this.updatedAtUtc, required this.accessLevel});
  factory _StorageFolderResponse.fromJson(Map<String, dynamic> json) => _$StorageFolderResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  StorageFolderType folderType;
@override final  String? parentFolderId;
@override final  String? workspaceId;
@override final  String? projectId;
@override final  bool canRead;
@override final  bool canComment;
@override final  bool canEdit;
@override final  bool canShare;
@override final  bool canDelete;
@override final  int itemCount;
@override final  DateTime updatedAtUtc;
@override final  StorageEffectiveAccessLevel accessLevel;

/// Create a copy of StorageFolderResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFolderResponseCopyWith<_StorageFolderResponse> get copyWith => __$StorageFolderResponseCopyWithImpl<_StorageFolderResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFolderResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFolderResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.folderType, folderType) || other.folderType == folderType)&&(identical(other.parentFolderId, parentFolderId) || other.parentFolderId == parentFolderId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.canRead, canRead) || other.canRead == canRead)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,folderType,parentFolderId,workspaceId,projectId,canRead,canComment,canEdit,canShare,canDelete,itemCount,updatedAtUtc,accessLevel);

@override
String toString() {
  return 'StorageFolderResponse(id: $id, name: $name, folderType: $folderType, parentFolderId: $parentFolderId, workspaceId: $workspaceId, projectId: $projectId, canRead: $canRead, canComment: $canComment, canEdit: $canEdit, canShare: $canShare, canDelete: $canDelete, itemCount: $itemCount, updatedAtUtc: $updatedAtUtc, accessLevel: $accessLevel)';
}


}

/// @nodoc
abstract mixin class _$StorageFolderResponseCopyWith<$Res> implements $StorageFolderResponseCopyWith<$Res> {
  factory _$StorageFolderResponseCopyWith(_StorageFolderResponse value, $Res Function(_StorageFolderResponse) _then) = __$StorageFolderResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, StorageFolderType folderType, String? parentFolderId, String? workspaceId, String? projectId, bool canRead, bool canComment, bool canEdit, bool canShare, bool canDelete, int itemCount, DateTime updatedAtUtc, StorageEffectiveAccessLevel accessLevel
});




}
/// @nodoc
class __$StorageFolderResponseCopyWithImpl<$Res>
    implements _$StorageFolderResponseCopyWith<$Res> {
  __$StorageFolderResponseCopyWithImpl(this._self, this._then);

  final _StorageFolderResponse _self;
  final $Res Function(_StorageFolderResponse) _then;

/// Create a copy of StorageFolderResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? folderType = null,Object? parentFolderId = freezed,Object? workspaceId = freezed,Object? projectId = freezed,Object? canRead = null,Object? canComment = null,Object? canEdit = null,Object? canShare = null,Object? canDelete = null,Object? itemCount = null,Object? updatedAtUtc = null,Object? accessLevel = null,}) {
  return _then(_StorageFolderResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,folderType: null == folderType ? _self.folderType : folderType // ignore: cast_nullable_to_non_nullable
as StorageFolderType,parentFolderId: freezed == parentFolderId ? _self.parentFolderId : parentFolderId // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,canRead: null == canRead ? _self.canRead : canRead // ignore: cast_nullable_to_non_nullable
as bool,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageEffectiveAccessLevel,
  ));
}


}

// dart format on
