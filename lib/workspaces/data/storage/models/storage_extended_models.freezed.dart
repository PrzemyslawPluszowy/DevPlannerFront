// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage_extended_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkStorageUploadTicketPayload {

 List<StorageUploadTicketItemPayload> get files; StorageModule get module; StorageResourceType get resourceType; String? get resourceId; String? get workspaceId; String? get projectId;
/// Create a copy of BulkStorageUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkStorageUploadTicketPayloadCopyWith<BulkStorageUploadTicketPayload> get copyWith => _$BulkStorageUploadTicketPayloadCopyWithImpl<BulkStorageUploadTicketPayload>(this as BulkStorageUploadTicketPayload, _$identity);

  /// Serializes this BulkStorageUploadTicketPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkStorageUploadTicketPayload&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.module, module) || other.module == module)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files),module,resourceType,resourceId,workspaceId,projectId);

@override
String toString() {
  return 'BulkStorageUploadTicketPayload(files: $files, module: $module, resourceType: $resourceType, resourceId: $resourceId, workspaceId: $workspaceId, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class $BulkStorageUploadTicketPayloadCopyWith<$Res>  {
  factory $BulkStorageUploadTicketPayloadCopyWith(BulkStorageUploadTicketPayload value, $Res Function(BulkStorageUploadTicketPayload) _then) = _$BulkStorageUploadTicketPayloadCopyWithImpl;
@useResult
$Res call({
 List<StorageUploadTicketItemPayload> files, StorageModule module, StorageResourceType resourceType, String? resourceId, String? workspaceId, String? projectId
});




}
/// @nodoc
class _$BulkStorageUploadTicketPayloadCopyWithImpl<$Res>
    implements $BulkStorageUploadTicketPayloadCopyWith<$Res> {
  _$BulkStorageUploadTicketPayloadCopyWithImpl(this._self, this._then);

  final BulkStorageUploadTicketPayload _self;
  final $Res Function(BulkStorageUploadTicketPayload) _then;

/// Create a copy of BulkStorageUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,Object? module = null,Object? resourceType = null,Object? resourceId = freezed,Object? workspaceId = freezed,Object? projectId = freezed,}) {
  return _then(_self.copyWith(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<StorageUploadTicketItemPayload>,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as StorageModule,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as StorageResourceType,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkStorageUploadTicketPayload].
extension BulkStorageUploadTicketPayloadPatterns on BulkStorageUploadTicketPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkStorageUploadTicketPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkStorageUploadTicketPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkStorageUploadTicketPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkStorageUploadTicketPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkStorageUploadTicketPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkStorageUploadTicketPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StorageUploadTicketItemPayload> files,  StorageModule module,  StorageResourceType resourceType,  String? resourceId,  String? workspaceId,  String? projectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkStorageUploadTicketPayload() when $default != null:
return $default(_that.files,_that.module,_that.resourceType,_that.resourceId,_that.workspaceId,_that.projectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StorageUploadTicketItemPayload> files,  StorageModule module,  StorageResourceType resourceType,  String? resourceId,  String? workspaceId,  String? projectId)  $default,) {final _that = this;
switch (_that) {
case _BulkStorageUploadTicketPayload():
return $default(_that.files,_that.module,_that.resourceType,_that.resourceId,_that.workspaceId,_that.projectId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StorageUploadTicketItemPayload> files,  StorageModule module,  StorageResourceType resourceType,  String? resourceId,  String? workspaceId,  String? projectId)?  $default,) {final _that = this;
switch (_that) {
case _BulkStorageUploadTicketPayload() when $default != null:
return $default(_that.files,_that.module,_that.resourceType,_that.resourceId,_that.workspaceId,_that.projectId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkStorageUploadTicketPayload implements BulkStorageUploadTicketPayload {
  const _BulkStorageUploadTicketPayload({required this.files, required this.module, required this.resourceType, this.resourceId, this.workspaceId, this.projectId});
  factory _BulkStorageUploadTicketPayload.fromJson(Map<String, dynamic> json) => _$BulkStorageUploadTicketPayloadFromJson(json);

@override final  List<StorageUploadTicketItemPayload> files;
@override final  StorageModule module;
@override final  StorageResourceType resourceType;
@override final  String? resourceId;
@override final  String? workspaceId;
@override final  String? projectId;

/// Create a copy of BulkStorageUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkStorageUploadTicketPayloadCopyWith<_BulkStorageUploadTicketPayload> get copyWith => __$BulkStorageUploadTicketPayloadCopyWithImpl<_BulkStorageUploadTicketPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkStorageUploadTicketPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkStorageUploadTicketPayload&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.module, module) || other.module == module)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files),module,resourceType,resourceId,workspaceId,projectId);

@override
String toString() {
  return 'BulkStorageUploadTicketPayload(files: $files, module: $module, resourceType: $resourceType, resourceId: $resourceId, workspaceId: $workspaceId, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class _$BulkStorageUploadTicketPayloadCopyWith<$Res> implements $BulkStorageUploadTicketPayloadCopyWith<$Res> {
  factory _$BulkStorageUploadTicketPayloadCopyWith(_BulkStorageUploadTicketPayload value, $Res Function(_BulkStorageUploadTicketPayload) _then) = __$BulkStorageUploadTicketPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<StorageUploadTicketItemPayload> files, StorageModule module, StorageResourceType resourceType, String? resourceId, String? workspaceId, String? projectId
});




}
/// @nodoc
class __$BulkStorageUploadTicketPayloadCopyWithImpl<$Res>
    implements _$BulkStorageUploadTicketPayloadCopyWith<$Res> {
  __$BulkStorageUploadTicketPayloadCopyWithImpl(this._self, this._then);

  final _BulkStorageUploadTicketPayload _self;
  final $Res Function(_BulkStorageUploadTicketPayload) _then;

/// Create a copy of BulkStorageUploadTicketPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,Object? module = null,Object? resourceType = null,Object? resourceId = freezed,Object? workspaceId = freezed,Object? projectId = freezed,}) {
  return _then(_BulkStorageUploadTicketPayload(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<StorageUploadTicketItemPayload>,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as StorageModule,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as StorageResourceType,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$QuillCleanUnusedImagesPayload {

 String get deltaJson; StorageResourceType get resourceType; String get resourceId;
/// Create a copy of QuillCleanUnusedImagesPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuillCleanUnusedImagesPayloadCopyWith<QuillCleanUnusedImagesPayload> get copyWith => _$QuillCleanUnusedImagesPayloadCopyWithImpl<QuillCleanUnusedImagesPayload>(this as QuillCleanUnusedImagesPayload, _$identity);

  /// Serializes this QuillCleanUnusedImagesPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuillCleanUnusedImagesPayload&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deltaJson,resourceType,resourceId);

@override
String toString() {
  return 'QuillCleanUnusedImagesPayload(deltaJson: $deltaJson, resourceType: $resourceType, resourceId: $resourceId)';
}


}

/// @nodoc
abstract mixin class $QuillCleanUnusedImagesPayloadCopyWith<$Res>  {
  factory $QuillCleanUnusedImagesPayloadCopyWith(QuillCleanUnusedImagesPayload value, $Res Function(QuillCleanUnusedImagesPayload) _then) = _$QuillCleanUnusedImagesPayloadCopyWithImpl;
@useResult
$Res call({
 String deltaJson, StorageResourceType resourceType, String resourceId
});




}
/// @nodoc
class _$QuillCleanUnusedImagesPayloadCopyWithImpl<$Res>
    implements $QuillCleanUnusedImagesPayloadCopyWith<$Res> {
  _$QuillCleanUnusedImagesPayloadCopyWithImpl(this._self, this._then);

  final QuillCleanUnusedImagesPayload _self;
  final $Res Function(QuillCleanUnusedImagesPayload) _then;

/// Create a copy of QuillCleanUnusedImagesPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deltaJson = null,Object? resourceType = null,Object? resourceId = null,}) {
  return _then(_self.copyWith(
deltaJson: null == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as StorageResourceType,resourceId: null == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuillCleanUnusedImagesPayload].
extension QuillCleanUnusedImagesPayloadPatterns on QuillCleanUnusedImagesPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuillCleanUnusedImagesPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuillCleanUnusedImagesPayload value)  $default,){
final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuillCleanUnusedImagesPayload value)?  $default,){
final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deltaJson,  StorageResourceType resourceType,  String resourceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesPayload() when $default != null:
return $default(_that.deltaJson,_that.resourceType,_that.resourceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deltaJson,  StorageResourceType resourceType,  String resourceId)  $default,) {final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesPayload():
return $default(_that.deltaJson,_that.resourceType,_that.resourceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deltaJson,  StorageResourceType resourceType,  String resourceId)?  $default,) {final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesPayload() when $default != null:
return $default(_that.deltaJson,_that.resourceType,_that.resourceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuillCleanUnusedImagesPayload implements QuillCleanUnusedImagesPayload {
  const _QuillCleanUnusedImagesPayload({required this.deltaJson, required this.resourceType, required this.resourceId});
  factory _QuillCleanUnusedImagesPayload.fromJson(Map<String, dynamic> json) => _$QuillCleanUnusedImagesPayloadFromJson(json);

@override final  String deltaJson;
@override final  StorageResourceType resourceType;
@override final  String resourceId;

/// Create a copy of QuillCleanUnusedImagesPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuillCleanUnusedImagesPayloadCopyWith<_QuillCleanUnusedImagesPayload> get copyWith => __$QuillCleanUnusedImagesPayloadCopyWithImpl<_QuillCleanUnusedImagesPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuillCleanUnusedImagesPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuillCleanUnusedImagesPayload&&(identical(other.deltaJson, deltaJson) || other.deltaJson == deltaJson)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deltaJson,resourceType,resourceId);

@override
String toString() {
  return 'QuillCleanUnusedImagesPayload(deltaJson: $deltaJson, resourceType: $resourceType, resourceId: $resourceId)';
}


}

/// @nodoc
abstract mixin class _$QuillCleanUnusedImagesPayloadCopyWith<$Res> implements $QuillCleanUnusedImagesPayloadCopyWith<$Res> {
  factory _$QuillCleanUnusedImagesPayloadCopyWith(_QuillCleanUnusedImagesPayload value, $Res Function(_QuillCleanUnusedImagesPayload) _then) = __$QuillCleanUnusedImagesPayloadCopyWithImpl;
@override @useResult
$Res call({
 String deltaJson, StorageResourceType resourceType, String resourceId
});




}
/// @nodoc
class __$QuillCleanUnusedImagesPayloadCopyWithImpl<$Res>
    implements _$QuillCleanUnusedImagesPayloadCopyWith<$Res> {
  __$QuillCleanUnusedImagesPayloadCopyWithImpl(this._self, this._then);

  final _QuillCleanUnusedImagesPayload _self;
  final $Res Function(_QuillCleanUnusedImagesPayload) _then;

/// Create a copy of QuillCleanUnusedImagesPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deltaJson = null,Object? resourceType = null,Object? resourceId = null,}) {
  return _then(_QuillCleanUnusedImagesPayload(
deltaJson: null == deltaJson ? _self.deltaJson : deltaJson // ignore: cast_nullable_to_non_nullable
as String,resourceType: null == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as StorageResourceType,resourceId: null == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpdateStorageFileDescriptionPayload {

 String? get manualDescription; String? get expectedConcurrencyToken;
/// Create a copy of UpdateStorageFileDescriptionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStorageFileDescriptionPayloadCopyWith<UpdateStorageFileDescriptionPayload> get copyWith => _$UpdateStorageFileDescriptionPayloadCopyWithImpl<UpdateStorageFileDescriptionPayload>(this as UpdateStorageFileDescriptionPayload, _$identity);

  /// Serializes this UpdateStorageFileDescriptionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStorageFileDescriptionPayload&&(identical(other.manualDescription, manualDescription) || other.manualDescription == manualDescription)&&(identical(other.expectedConcurrencyToken, expectedConcurrencyToken) || other.expectedConcurrencyToken == expectedConcurrencyToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,manualDescription,expectedConcurrencyToken);

@override
String toString() {
  return 'UpdateStorageFileDescriptionPayload(manualDescription: $manualDescription, expectedConcurrencyToken: $expectedConcurrencyToken)';
}


}

/// @nodoc
abstract mixin class $UpdateStorageFileDescriptionPayloadCopyWith<$Res>  {
  factory $UpdateStorageFileDescriptionPayloadCopyWith(UpdateStorageFileDescriptionPayload value, $Res Function(UpdateStorageFileDescriptionPayload) _then) = _$UpdateStorageFileDescriptionPayloadCopyWithImpl;
@useResult
$Res call({
 String? manualDescription, String? expectedConcurrencyToken
});




}
/// @nodoc
class _$UpdateStorageFileDescriptionPayloadCopyWithImpl<$Res>
    implements $UpdateStorageFileDescriptionPayloadCopyWith<$Res> {
  _$UpdateStorageFileDescriptionPayloadCopyWithImpl(this._self, this._then);

  final UpdateStorageFileDescriptionPayload _self;
  final $Res Function(UpdateStorageFileDescriptionPayload) _then;

/// Create a copy of UpdateStorageFileDescriptionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? manualDescription = freezed,Object? expectedConcurrencyToken = freezed,}) {
  return _then(_self.copyWith(
manualDescription: freezed == manualDescription ? _self.manualDescription : manualDescription // ignore: cast_nullable_to_non_nullable
as String?,expectedConcurrencyToken: freezed == expectedConcurrencyToken ? _self.expectedConcurrencyToken : expectedConcurrencyToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateStorageFileDescriptionPayload].
extension UpdateStorageFileDescriptionPayloadPatterns on UpdateStorageFileDescriptionPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateStorageFileDescriptionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateStorageFileDescriptionPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateStorageFileDescriptionPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateStorageFileDescriptionPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateStorageFileDescriptionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateStorageFileDescriptionPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? manualDescription,  String? expectedConcurrencyToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateStorageFileDescriptionPayload() when $default != null:
return $default(_that.manualDescription,_that.expectedConcurrencyToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? manualDescription,  String? expectedConcurrencyToken)  $default,) {final _that = this;
switch (_that) {
case _UpdateStorageFileDescriptionPayload():
return $default(_that.manualDescription,_that.expectedConcurrencyToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? manualDescription,  String? expectedConcurrencyToken)?  $default,) {final _that = this;
switch (_that) {
case _UpdateStorageFileDescriptionPayload() when $default != null:
return $default(_that.manualDescription,_that.expectedConcurrencyToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateStorageFileDescriptionPayload implements UpdateStorageFileDescriptionPayload {
  const _UpdateStorageFileDescriptionPayload({this.manualDescription, this.expectedConcurrencyToken});
  factory _UpdateStorageFileDescriptionPayload.fromJson(Map<String, dynamic> json) => _$UpdateStorageFileDescriptionPayloadFromJson(json);

@override final  String? manualDescription;
@override final  String? expectedConcurrencyToken;

/// Create a copy of UpdateStorageFileDescriptionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateStorageFileDescriptionPayloadCopyWith<_UpdateStorageFileDescriptionPayload> get copyWith => __$UpdateStorageFileDescriptionPayloadCopyWithImpl<_UpdateStorageFileDescriptionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateStorageFileDescriptionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateStorageFileDescriptionPayload&&(identical(other.manualDescription, manualDescription) || other.manualDescription == manualDescription)&&(identical(other.expectedConcurrencyToken, expectedConcurrencyToken) || other.expectedConcurrencyToken == expectedConcurrencyToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,manualDescription,expectedConcurrencyToken);

@override
String toString() {
  return 'UpdateStorageFileDescriptionPayload(manualDescription: $manualDescription, expectedConcurrencyToken: $expectedConcurrencyToken)';
}


}

/// @nodoc
abstract mixin class _$UpdateStorageFileDescriptionPayloadCopyWith<$Res> implements $UpdateStorageFileDescriptionPayloadCopyWith<$Res> {
  factory _$UpdateStorageFileDescriptionPayloadCopyWith(_UpdateStorageFileDescriptionPayload value, $Res Function(_UpdateStorageFileDescriptionPayload) _then) = __$UpdateStorageFileDescriptionPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? manualDescription, String? expectedConcurrencyToken
});




}
/// @nodoc
class __$UpdateStorageFileDescriptionPayloadCopyWithImpl<$Res>
    implements _$UpdateStorageFileDescriptionPayloadCopyWith<$Res> {
  __$UpdateStorageFileDescriptionPayloadCopyWithImpl(this._self, this._then);

  final _UpdateStorageFileDescriptionPayload _self;
  final $Res Function(_UpdateStorageFileDescriptionPayload) _then;

/// Create a copy of UpdateStorageFileDescriptionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? manualDescription = freezed,Object? expectedConcurrencyToken = freezed,}) {
  return _then(_UpdateStorageFileDescriptionPayload(
manualDescription: freezed == manualDescription ? _self.manualDescription : manualDescription // ignore: cast_nullable_to_non_nullable
as String?,expectedConcurrencyToken: freezed == expectedConcurrencyToken ? _self.expectedConcurrencyToken : expectedConcurrencyToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateStorageFolderPayload {

 String? get name; String? get parentFolderId;
/// Create a copy of UpdateStorageFolderPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStorageFolderPayloadCopyWith<UpdateStorageFolderPayload> get copyWith => _$UpdateStorageFolderPayloadCopyWithImpl<UpdateStorageFolderPayload>(this as UpdateStorageFolderPayload, _$identity);

  /// Serializes this UpdateStorageFolderPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStorageFolderPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.parentFolderId, parentFolderId) || other.parentFolderId == parentFolderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,parentFolderId);

@override
String toString() {
  return 'UpdateStorageFolderPayload(name: $name, parentFolderId: $parentFolderId)';
}


}

/// @nodoc
abstract mixin class $UpdateStorageFolderPayloadCopyWith<$Res>  {
  factory $UpdateStorageFolderPayloadCopyWith(UpdateStorageFolderPayload value, $Res Function(UpdateStorageFolderPayload) _then) = _$UpdateStorageFolderPayloadCopyWithImpl;
@useResult
$Res call({
 String? name, String? parentFolderId
});




}
/// @nodoc
class _$UpdateStorageFolderPayloadCopyWithImpl<$Res>
    implements $UpdateStorageFolderPayloadCopyWith<$Res> {
  _$UpdateStorageFolderPayloadCopyWithImpl(this._self, this._then);

  final UpdateStorageFolderPayload _self;
  final $Res Function(UpdateStorageFolderPayload) _then;

/// Create a copy of UpdateStorageFolderPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? parentFolderId = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,parentFolderId: freezed == parentFolderId ? _self.parentFolderId : parentFolderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateStorageFolderPayload].
extension UpdateStorageFolderPayloadPatterns on UpdateStorageFolderPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateStorageFolderPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateStorageFolderPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateStorageFolderPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateStorageFolderPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateStorageFolderPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateStorageFolderPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? parentFolderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateStorageFolderPayload() when $default != null:
return $default(_that.name,_that.parentFolderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? parentFolderId)  $default,) {final _that = this;
switch (_that) {
case _UpdateStorageFolderPayload():
return $default(_that.name,_that.parentFolderId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? parentFolderId)?  $default,) {final _that = this;
switch (_that) {
case _UpdateStorageFolderPayload() when $default != null:
return $default(_that.name,_that.parentFolderId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateStorageFolderPayload implements UpdateStorageFolderPayload {
  const _UpdateStorageFolderPayload({this.name, this.parentFolderId});
  factory _UpdateStorageFolderPayload.fromJson(Map<String, dynamic> json) => _$UpdateStorageFolderPayloadFromJson(json);

@override final  String? name;
@override final  String? parentFolderId;

/// Create a copy of UpdateStorageFolderPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateStorageFolderPayloadCopyWith<_UpdateStorageFolderPayload> get copyWith => __$UpdateStorageFolderPayloadCopyWithImpl<_UpdateStorageFolderPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateStorageFolderPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateStorageFolderPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.parentFolderId, parentFolderId) || other.parentFolderId == parentFolderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,parentFolderId);

@override
String toString() {
  return 'UpdateStorageFolderPayload(name: $name, parentFolderId: $parentFolderId)';
}


}

/// @nodoc
abstract mixin class _$UpdateStorageFolderPayloadCopyWith<$Res> implements $UpdateStorageFolderPayloadCopyWith<$Res> {
  factory _$UpdateStorageFolderPayloadCopyWith(_UpdateStorageFolderPayload value, $Res Function(_UpdateStorageFolderPayload) _then) = __$UpdateStorageFolderPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? parentFolderId
});




}
/// @nodoc
class __$UpdateStorageFolderPayloadCopyWithImpl<$Res>
    implements _$UpdateStorageFolderPayloadCopyWith<$Res> {
  __$UpdateStorageFolderPayloadCopyWithImpl(this._self, this._then);

  final _UpdateStorageFolderPayload _self;
  final $Res Function(_UpdateStorageFolderPayload) _then;

/// Create a copy of UpdateStorageFolderPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? parentFolderId = freezed,}) {
  return _then(_UpdateStorageFolderPayload(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,parentFolderId: freezed == parentFolderId ? _self.parentFolderId : parentFolderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateStorageFolderSharePayload {

 String get sharedWithUserId; StorageShareAccessLevel get accessLevel; DateTime? get expiresAtUtc;
/// Create a copy of CreateStorageFolderSharePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateStorageFolderSharePayloadCopyWith<CreateStorageFolderSharePayload> get copyWith => _$CreateStorageFolderSharePayloadCopyWithImpl<CreateStorageFolderSharePayload>(this as CreateStorageFolderSharePayload, _$identity);

  /// Serializes this CreateStorageFolderSharePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateStorageFolderSharePayload&&(identical(other.sharedWithUserId, sharedWithUserId) || other.sharedWithUserId == sharedWithUserId)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sharedWithUserId,accessLevel,expiresAtUtc);

@override
String toString() {
  return 'CreateStorageFolderSharePayload(sharedWithUserId: $sharedWithUserId, accessLevel: $accessLevel, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class $CreateStorageFolderSharePayloadCopyWith<$Res>  {
  factory $CreateStorageFolderSharePayloadCopyWith(CreateStorageFolderSharePayload value, $Res Function(CreateStorageFolderSharePayload) _then) = _$CreateStorageFolderSharePayloadCopyWithImpl;
@useResult
$Res call({
 String sharedWithUserId, StorageShareAccessLevel accessLevel, DateTime? expiresAtUtc
});




}
/// @nodoc
class _$CreateStorageFolderSharePayloadCopyWithImpl<$Res>
    implements $CreateStorageFolderSharePayloadCopyWith<$Res> {
  _$CreateStorageFolderSharePayloadCopyWithImpl(this._self, this._then);

  final CreateStorageFolderSharePayload _self;
  final $Res Function(CreateStorageFolderSharePayload) _then;

/// Create a copy of CreateStorageFolderSharePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sharedWithUserId = null,Object? accessLevel = null,Object? expiresAtUtc = freezed,}) {
  return _then(_self.copyWith(
sharedWithUserId: null == sharedWithUserId ? _self.sharedWithUserId : sharedWithUserId // ignore: cast_nullable_to_non_nullable
as String,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageShareAccessLevel,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateStorageFolderSharePayload].
extension CreateStorageFolderSharePayloadPatterns on CreateStorageFolderSharePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateStorageFolderSharePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateStorageFolderSharePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateStorageFolderSharePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateStorageFolderSharePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateStorageFolderSharePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateStorageFolderSharePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sharedWithUserId,  StorageShareAccessLevel accessLevel,  DateTime? expiresAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateStorageFolderSharePayload() when $default != null:
return $default(_that.sharedWithUserId,_that.accessLevel,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sharedWithUserId,  StorageShareAccessLevel accessLevel,  DateTime? expiresAtUtc)  $default,) {final _that = this;
switch (_that) {
case _CreateStorageFolderSharePayload():
return $default(_that.sharedWithUserId,_that.accessLevel,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sharedWithUserId,  StorageShareAccessLevel accessLevel,  DateTime? expiresAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _CreateStorageFolderSharePayload() when $default != null:
return $default(_that.sharedWithUserId,_that.accessLevel,_that.expiresAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateStorageFolderSharePayload implements CreateStorageFolderSharePayload {
  const _CreateStorageFolderSharePayload({required this.sharedWithUserId, required this.accessLevel, this.expiresAtUtc});
  factory _CreateStorageFolderSharePayload.fromJson(Map<String, dynamic> json) => _$CreateStorageFolderSharePayloadFromJson(json);

@override final  String sharedWithUserId;
@override final  StorageShareAccessLevel accessLevel;
@override final  DateTime? expiresAtUtc;

/// Create a copy of CreateStorageFolderSharePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateStorageFolderSharePayloadCopyWith<_CreateStorageFolderSharePayload> get copyWith => __$CreateStorageFolderSharePayloadCopyWithImpl<_CreateStorageFolderSharePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateStorageFolderSharePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateStorageFolderSharePayload&&(identical(other.sharedWithUserId, sharedWithUserId) || other.sharedWithUserId == sharedWithUserId)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sharedWithUserId,accessLevel,expiresAtUtc);

@override
String toString() {
  return 'CreateStorageFolderSharePayload(sharedWithUserId: $sharedWithUserId, accessLevel: $accessLevel, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class _$CreateStorageFolderSharePayloadCopyWith<$Res> implements $CreateStorageFolderSharePayloadCopyWith<$Res> {
  factory _$CreateStorageFolderSharePayloadCopyWith(_CreateStorageFolderSharePayload value, $Res Function(_CreateStorageFolderSharePayload) _then) = __$CreateStorageFolderSharePayloadCopyWithImpl;
@override @useResult
$Res call({
 String sharedWithUserId, StorageShareAccessLevel accessLevel, DateTime? expiresAtUtc
});




}
/// @nodoc
class __$CreateStorageFolderSharePayloadCopyWithImpl<$Res>
    implements _$CreateStorageFolderSharePayloadCopyWith<$Res> {
  __$CreateStorageFolderSharePayloadCopyWithImpl(this._self, this._then);

  final _CreateStorageFolderSharePayload _self;
  final $Res Function(_CreateStorageFolderSharePayload) _then;

/// Create a copy of CreateStorageFolderSharePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sharedWithUserId = null,Object? accessLevel = null,Object? expiresAtUtc = freezed,}) {
  return _then(_CreateStorageFolderSharePayload(
sharedWithUserId: null == sharedWithUserId ? _self.sharedWithUserId : sharedWithUserId // ignore: cast_nullable_to_non_nullable
as String,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageShareAccessLevel,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StorageFolderShareResponse {

 String get id; String get folderId; String get sharedWithUserId; StorageShareAccessLevel get accessLevel; DateTime? get expiresAtUtc; String get createdByUserId; DateTime get createdAtUtc; StorageEffectiveAccessLevel get effectiveAccessLevel; bool get canRead; bool get canComment; bool get canEdit; bool get canShare; bool get canDelete;
/// Create a copy of StorageFolderShareResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFolderShareResponseCopyWith<StorageFolderShareResponse> get copyWith => _$StorageFolderShareResponseCopyWithImpl<StorageFolderShareResponse>(this as StorageFolderShareResponse, _$identity);

  /// Serializes this StorageFolderShareResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFolderShareResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.sharedWithUserId, sharedWithUserId) || other.sharedWithUserId == sharedWithUserId)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.effectiveAccessLevel, effectiveAccessLevel) || other.effectiveAccessLevel == effectiveAccessLevel)&&(identical(other.canRead, canRead) || other.canRead == canRead)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,folderId,sharedWithUserId,accessLevel,expiresAtUtc,createdByUserId,createdAtUtc,effectiveAccessLevel,canRead,canComment,canEdit,canShare,canDelete);

@override
String toString() {
  return 'StorageFolderShareResponse(id: $id, folderId: $folderId, sharedWithUserId: $sharedWithUserId, accessLevel: $accessLevel, expiresAtUtc: $expiresAtUtc, createdByUserId: $createdByUserId, createdAtUtc: $createdAtUtc, effectiveAccessLevel: $effectiveAccessLevel, canRead: $canRead, canComment: $canComment, canEdit: $canEdit, canShare: $canShare, canDelete: $canDelete)';
}


}

/// @nodoc
abstract mixin class $StorageFolderShareResponseCopyWith<$Res>  {
  factory $StorageFolderShareResponseCopyWith(StorageFolderShareResponse value, $Res Function(StorageFolderShareResponse) _then) = _$StorageFolderShareResponseCopyWithImpl;
@useResult
$Res call({
 String id, String folderId, String sharedWithUserId, StorageShareAccessLevel accessLevel, DateTime? expiresAtUtc, String createdByUserId, DateTime createdAtUtc, StorageEffectiveAccessLevel effectiveAccessLevel, bool canRead, bool canComment, bool canEdit, bool canShare, bool canDelete
});




}
/// @nodoc
class _$StorageFolderShareResponseCopyWithImpl<$Res>
    implements $StorageFolderShareResponseCopyWith<$Res> {
  _$StorageFolderShareResponseCopyWithImpl(this._self, this._then);

  final StorageFolderShareResponse _self;
  final $Res Function(StorageFolderShareResponse) _then;

/// Create a copy of StorageFolderShareResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? folderId = null,Object? sharedWithUserId = null,Object? accessLevel = null,Object? expiresAtUtc = freezed,Object? createdByUserId = null,Object? createdAtUtc = null,Object? effectiveAccessLevel = null,Object? canRead = null,Object? canComment = null,Object? canEdit = null,Object? canShare = null,Object? canDelete = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,sharedWithUserId: null == sharedWithUserId ? _self.sharedWithUserId : sharedWithUserId // ignore: cast_nullable_to_non_nullable
as String,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageShareAccessLevel,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [StorageFolderShareResponse].
extension StorageFolderShareResponsePatterns on StorageFolderShareResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFolderShareResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFolderShareResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFolderShareResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFolderShareResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFolderShareResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFolderShareResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String folderId,  String sharedWithUserId,  StorageShareAccessLevel accessLevel,  DateTime? expiresAtUtc,  String createdByUserId,  DateTime createdAtUtc,  StorageEffectiveAccessLevel effectiveAccessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFolderShareResponse() when $default != null:
return $default(_that.id,_that.folderId,_that.sharedWithUserId,_that.accessLevel,_that.expiresAtUtc,_that.createdByUserId,_that.createdAtUtc,_that.effectiveAccessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String folderId,  String sharedWithUserId,  StorageShareAccessLevel accessLevel,  DateTime? expiresAtUtc,  String createdByUserId,  DateTime createdAtUtc,  StorageEffectiveAccessLevel effectiveAccessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete)  $default,) {final _that = this;
switch (_that) {
case _StorageFolderShareResponse():
return $default(_that.id,_that.folderId,_that.sharedWithUserId,_that.accessLevel,_that.expiresAtUtc,_that.createdByUserId,_that.createdAtUtc,_that.effectiveAccessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String folderId,  String sharedWithUserId,  StorageShareAccessLevel accessLevel,  DateTime? expiresAtUtc,  String createdByUserId,  DateTime createdAtUtc,  StorageEffectiveAccessLevel effectiveAccessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete)?  $default,) {final _that = this;
switch (_that) {
case _StorageFolderShareResponse() when $default != null:
return $default(_that.id,_that.folderId,_that.sharedWithUserId,_that.accessLevel,_that.expiresAtUtc,_that.createdByUserId,_that.createdAtUtc,_that.effectiveAccessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFolderShareResponse implements StorageFolderShareResponse {
  const _StorageFolderShareResponse({required this.id, required this.folderId, required this.sharedWithUserId, required this.accessLevel, this.expiresAtUtc, required this.createdByUserId, required this.createdAtUtc, required this.effectiveAccessLevel, required this.canRead, required this.canComment, required this.canEdit, required this.canShare, required this.canDelete});
  factory _StorageFolderShareResponse.fromJson(Map<String, dynamic> json) => _$StorageFolderShareResponseFromJson(json);

@override final  String id;
@override final  String folderId;
@override final  String sharedWithUserId;
@override final  StorageShareAccessLevel accessLevel;
@override final  DateTime? expiresAtUtc;
@override final  String createdByUserId;
@override final  DateTime createdAtUtc;
@override final  StorageEffectiveAccessLevel effectiveAccessLevel;
@override final  bool canRead;
@override final  bool canComment;
@override final  bool canEdit;
@override final  bool canShare;
@override final  bool canDelete;

/// Create a copy of StorageFolderShareResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFolderShareResponseCopyWith<_StorageFolderShareResponse> get copyWith => __$StorageFolderShareResponseCopyWithImpl<_StorageFolderShareResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFolderShareResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFolderShareResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.sharedWithUserId, sharedWithUserId) || other.sharedWithUserId == sharedWithUserId)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.effectiveAccessLevel, effectiveAccessLevel) || other.effectiveAccessLevel == effectiveAccessLevel)&&(identical(other.canRead, canRead) || other.canRead == canRead)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,folderId,sharedWithUserId,accessLevel,expiresAtUtc,createdByUserId,createdAtUtc,effectiveAccessLevel,canRead,canComment,canEdit,canShare,canDelete);

@override
String toString() {
  return 'StorageFolderShareResponse(id: $id, folderId: $folderId, sharedWithUserId: $sharedWithUserId, accessLevel: $accessLevel, expiresAtUtc: $expiresAtUtc, createdByUserId: $createdByUserId, createdAtUtc: $createdAtUtc, effectiveAccessLevel: $effectiveAccessLevel, canRead: $canRead, canComment: $canComment, canEdit: $canEdit, canShare: $canShare, canDelete: $canDelete)';
}


}

/// @nodoc
abstract mixin class _$StorageFolderShareResponseCopyWith<$Res> implements $StorageFolderShareResponseCopyWith<$Res> {
  factory _$StorageFolderShareResponseCopyWith(_StorageFolderShareResponse value, $Res Function(_StorageFolderShareResponse) _then) = __$StorageFolderShareResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String folderId, String sharedWithUserId, StorageShareAccessLevel accessLevel, DateTime? expiresAtUtc, String createdByUserId, DateTime createdAtUtc, StorageEffectiveAccessLevel effectiveAccessLevel, bool canRead, bool canComment, bool canEdit, bool canShare, bool canDelete
});




}
/// @nodoc
class __$StorageFolderShareResponseCopyWithImpl<$Res>
    implements _$StorageFolderShareResponseCopyWith<$Res> {
  __$StorageFolderShareResponseCopyWithImpl(this._self, this._then);

  final _StorageFolderShareResponse _self;
  final $Res Function(_StorageFolderShareResponse) _then;

/// Create a copy of StorageFolderShareResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? folderId = null,Object? sharedWithUserId = null,Object? accessLevel = null,Object? expiresAtUtc = freezed,Object? createdByUserId = null,Object? createdAtUtc = null,Object? effectiveAccessLevel = null,Object? canRead = null,Object? canComment = null,Object? canEdit = null,Object? canShare = null,Object? canDelete = null,}) {
  return _then(_StorageFolderShareResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,sharedWithUserId: null == sharedWithUserId ? _self.sharedWithUserId : sharedWithUserId // ignore: cast_nullable_to_non_nullable
as String,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageShareAccessLevel,expiresAtUtc: freezed == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
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
mixin _$AttachStorageFileToProjectPayload {

 String get folderId; String? get displayName;
/// Create a copy of AttachStorageFileToProjectPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachStorageFileToProjectPayloadCopyWith<AttachStorageFileToProjectPayload> get copyWith => _$AttachStorageFileToProjectPayloadCopyWithImpl<AttachStorageFileToProjectPayload>(this as AttachStorageFileToProjectPayload, _$identity);

  /// Serializes this AttachStorageFileToProjectPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachStorageFileToProjectPayload&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,folderId,displayName);

@override
String toString() {
  return 'AttachStorageFileToProjectPayload(folderId: $folderId, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $AttachStorageFileToProjectPayloadCopyWith<$Res>  {
  factory $AttachStorageFileToProjectPayloadCopyWith(AttachStorageFileToProjectPayload value, $Res Function(AttachStorageFileToProjectPayload) _then) = _$AttachStorageFileToProjectPayloadCopyWithImpl;
@useResult
$Res call({
 String folderId, String? displayName
});




}
/// @nodoc
class _$AttachStorageFileToProjectPayloadCopyWithImpl<$Res>
    implements $AttachStorageFileToProjectPayloadCopyWith<$Res> {
  _$AttachStorageFileToProjectPayloadCopyWithImpl(this._self, this._then);

  final AttachStorageFileToProjectPayload _self;
  final $Res Function(AttachStorageFileToProjectPayload) _then;

/// Create a copy of AttachStorageFileToProjectPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderId = null,Object? displayName = freezed,}) {
  return _then(_self.copyWith(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachStorageFileToProjectPayload].
extension AttachStorageFileToProjectPayloadPatterns on AttachStorageFileToProjectPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachStorageFileToProjectPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachStorageFileToProjectPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachStorageFileToProjectPayload value)  $default,){
final _that = this;
switch (_that) {
case _AttachStorageFileToProjectPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachStorageFileToProjectPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AttachStorageFileToProjectPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String folderId,  String? displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachStorageFileToProjectPayload() when $default != null:
return $default(_that.folderId,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String folderId,  String? displayName)  $default,) {final _that = this;
switch (_that) {
case _AttachStorageFileToProjectPayload():
return $default(_that.folderId,_that.displayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String folderId,  String? displayName)?  $default,) {final _that = this;
switch (_that) {
case _AttachStorageFileToProjectPayload() when $default != null:
return $default(_that.folderId,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachStorageFileToProjectPayload implements AttachStorageFileToProjectPayload {
  const _AttachStorageFileToProjectPayload({required this.folderId, this.displayName});
  factory _AttachStorageFileToProjectPayload.fromJson(Map<String, dynamic> json) => _$AttachStorageFileToProjectPayloadFromJson(json);

@override final  String folderId;
@override final  String? displayName;

/// Create a copy of AttachStorageFileToProjectPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachStorageFileToProjectPayloadCopyWith<_AttachStorageFileToProjectPayload> get copyWith => __$AttachStorageFileToProjectPayloadCopyWithImpl<_AttachStorageFileToProjectPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachStorageFileToProjectPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachStorageFileToProjectPayload&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,folderId,displayName);

@override
String toString() {
  return 'AttachStorageFileToProjectPayload(folderId: $folderId, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$AttachStorageFileToProjectPayloadCopyWith<$Res> implements $AttachStorageFileToProjectPayloadCopyWith<$Res> {
  factory _$AttachStorageFileToProjectPayloadCopyWith(_AttachStorageFileToProjectPayload value, $Res Function(_AttachStorageFileToProjectPayload) _then) = __$AttachStorageFileToProjectPayloadCopyWithImpl;
@override @useResult
$Res call({
 String folderId, String? displayName
});




}
/// @nodoc
class __$AttachStorageFileToProjectPayloadCopyWithImpl<$Res>
    implements _$AttachStorageFileToProjectPayloadCopyWith<$Res> {
  __$AttachStorageFileToProjectPayloadCopyWithImpl(this._self, this._then);

  final _AttachStorageFileToProjectPayload _self;
  final $Res Function(_AttachStorageFileToProjectPayload) _then;

/// Create a copy of AttachStorageFileToProjectPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderId = null,Object? displayName = freezed,}) {
  return _then(_AttachStorageFileToProjectPayload(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PublicShareAccessPayload {

 String? get password;
/// Create a copy of PublicShareAccessPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicShareAccessPayloadCopyWith<PublicShareAccessPayload> get copyWith => _$PublicShareAccessPayloadCopyWithImpl<PublicShareAccessPayload>(this as PublicShareAccessPayload, _$identity);

  /// Serializes this PublicShareAccessPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicShareAccessPayload&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'PublicShareAccessPayload(password: $password)';
}


}

/// @nodoc
abstract mixin class $PublicShareAccessPayloadCopyWith<$Res>  {
  factory $PublicShareAccessPayloadCopyWith(PublicShareAccessPayload value, $Res Function(PublicShareAccessPayload) _then) = _$PublicShareAccessPayloadCopyWithImpl;
@useResult
$Res call({
 String? password
});




}
/// @nodoc
class _$PublicShareAccessPayloadCopyWithImpl<$Res>
    implements $PublicShareAccessPayloadCopyWith<$Res> {
  _$PublicShareAccessPayloadCopyWithImpl(this._self, this._then);

  final PublicShareAccessPayload _self;
  final $Res Function(PublicShareAccessPayload) _then;

/// Create a copy of PublicShareAccessPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? password = freezed,}) {
  return _then(_self.copyWith(
password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicShareAccessPayload].
extension PublicShareAccessPayloadPatterns on PublicShareAccessPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicShareAccessPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicShareAccessPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicShareAccessPayload value)  $default,){
final _that = this;
switch (_that) {
case _PublicShareAccessPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicShareAccessPayload value)?  $default,){
final _that = this;
switch (_that) {
case _PublicShareAccessPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicShareAccessPayload() when $default != null:
return $default(_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? password)  $default,) {final _that = this;
switch (_that) {
case _PublicShareAccessPayload():
return $default(_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? password)?  $default,) {final _that = this;
switch (_that) {
case _PublicShareAccessPayload() when $default != null:
return $default(_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicShareAccessPayload implements PublicShareAccessPayload {
  const _PublicShareAccessPayload({this.password});
  factory _PublicShareAccessPayload.fromJson(Map<String, dynamic> json) => _$PublicShareAccessPayloadFromJson(json);

@override final  String? password;

/// Create a copy of PublicShareAccessPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicShareAccessPayloadCopyWith<_PublicShareAccessPayload> get copyWith => __$PublicShareAccessPayloadCopyWithImpl<_PublicShareAccessPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicShareAccessPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicShareAccessPayload&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'PublicShareAccessPayload(password: $password)';
}


}

/// @nodoc
abstract mixin class _$PublicShareAccessPayloadCopyWith<$Res> implements $PublicShareAccessPayloadCopyWith<$Res> {
  factory _$PublicShareAccessPayloadCopyWith(_PublicShareAccessPayload value, $Res Function(_PublicShareAccessPayload) _then) = __$PublicShareAccessPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? password
});




}
/// @nodoc
class __$PublicShareAccessPayloadCopyWithImpl<$Res>
    implements _$PublicShareAccessPayloadCopyWith<$Res> {
  __$PublicShareAccessPayloadCopyWithImpl(this._self, this._then);

  final _PublicShareAccessPayload _self;
  final $Res Function(_PublicShareAccessPayload) _then;

/// Create a copy of PublicShareAccessPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? password = freezed,}) {
  return _then(_PublicShareAccessPayload(
password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$QuillCleanUnusedImagesResponse {

 List<String> get deletedFileIds;
/// Create a copy of QuillCleanUnusedImagesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuillCleanUnusedImagesResponseCopyWith<QuillCleanUnusedImagesResponse> get copyWith => _$QuillCleanUnusedImagesResponseCopyWithImpl<QuillCleanUnusedImagesResponse>(this as QuillCleanUnusedImagesResponse, _$identity);

  /// Serializes this QuillCleanUnusedImagesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuillCleanUnusedImagesResponse&&const DeepCollectionEquality().equals(other.deletedFileIds, deletedFileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(deletedFileIds));

@override
String toString() {
  return 'QuillCleanUnusedImagesResponse(deletedFileIds: $deletedFileIds)';
}


}

/// @nodoc
abstract mixin class $QuillCleanUnusedImagesResponseCopyWith<$Res>  {
  factory $QuillCleanUnusedImagesResponseCopyWith(QuillCleanUnusedImagesResponse value, $Res Function(QuillCleanUnusedImagesResponse) _then) = _$QuillCleanUnusedImagesResponseCopyWithImpl;
@useResult
$Res call({
 List<String> deletedFileIds
});




}
/// @nodoc
class _$QuillCleanUnusedImagesResponseCopyWithImpl<$Res>
    implements $QuillCleanUnusedImagesResponseCopyWith<$Res> {
  _$QuillCleanUnusedImagesResponseCopyWithImpl(this._self, this._then);

  final QuillCleanUnusedImagesResponse _self;
  final $Res Function(QuillCleanUnusedImagesResponse) _then;

/// Create a copy of QuillCleanUnusedImagesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deletedFileIds = null,}) {
  return _then(_self.copyWith(
deletedFileIds: null == deletedFileIds ? _self.deletedFileIds : deletedFileIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuillCleanUnusedImagesResponse].
extension QuillCleanUnusedImagesResponsePatterns on QuillCleanUnusedImagesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuillCleanUnusedImagesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuillCleanUnusedImagesResponse value)  $default,){
final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuillCleanUnusedImagesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> deletedFileIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesResponse() when $default != null:
return $default(_that.deletedFileIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> deletedFileIds)  $default,) {final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesResponse():
return $default(_that.deletedFileIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> deletedFileIds)?  $default,) {final _that = this;
switch (_that) {
case _QuillCleanUnusedImagesResponse() when $default != null:
return $default(_that.deletedFileIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuillCleanUnusedImagesResponse implements QuillCleanUnusedImagesResponse {
  const _QuillCleanUnusedImagesResponse({required this.deletedFileIds});
  factory _QuillCleanUnusedImagesResponse.fromJson(Map<String, dynamic> json) => _$QuillCleanUnusedImagesResponseFromJson(json);

@override final  List<String> deletedFileIds;

/// Create a copy of QuillCleanUnusedImagesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuillCleanUnusedImagesResponseCopyWith<_QuillCleanUnusedImagesResponse> get copyWith => __$QuillCleanUnusedImagesResponseCopyWithImpl<_QuillCleanUnusedImagesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuillCleanUnusedImagesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuillCleanUnusedImagesResponse&&const DeepCollectionEquality().equals(other.deletedFileIds, deletedFileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(deletedFileIds));

@override
String toString() {
  return 'QuillCleanUnusedImagesResponse(deletedFileIds: $deletedFileIds)';
}


}

/// @nodoc
abstract mixin class _$QuillCleanUnusedImagesResponseCopyWith<$Res> implements $QuillCleanUnusedImagesResponseCopyWith<$Res> {
  factory _$QuillCleanUnusedImagesResponseCopyWith(_QuillCleanUnusedImagesResponse value, $Res Function(_QuillCleanUnusedImagesResponse) _then) = __$QuillCleanUnusedImagesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<String> deletedFileIds
});




}
/// @nodoc
class __$QuillCleanUnusedImagesResponseCopyWithImpl<$Res>
    implements _$QuillCleanUnusedImagesResponseCopyWith<$Res> {
  __$QuillCleanUnusedImagesResponseCopyWithImpl(this._self, this._then);

  final _QuillCleanUnusedImagesResponse _self;
  final $Res Function(_QuillCleanUnusedImagesResponse) _then;

/// Create a copy of QuillCleanUnusedImagesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deletedFileIds = null,}) {
  return _then(_QuillCleanUnusedImagesResponse(
deletedFileIds: null == deletedFileIds ? _self.deletedFileIds : deletedFileIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$SetUserAvatarPayload {

 String get fileId;
/// Create a copy of SetUserAvatarPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetUserAvatarPayloadCopyWith<SetUserAvatarPayload> get copyWith => _$SetUserAvatarPayloadCopyWithImpl<SetUserAvatarPayload>(this as SetUserAvatarPayload, _$identity);

  /// Serializes this SetUserAvatarPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetUserAvatarPayload&&(identical(other.fileId, fileId) || other.fileId == fileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId);

@override
String toString() {
  return 'SetUserAvatarPayload(fileId: $fileId)';
}


}

/// @nodoc
abstract mixin class $SetUserAvatarPayloadCopyWith<$Res>  {
  factory $SetUserAvatarPayloadCopyWith(SetUserAvatarPayload value, $Res Function(SetUserAvatarPayload) _then) = _$SetUserAvatarPayloadCopyWithImpl;
@useResult
$Res call({
 String fileId
});




}
/// @nodoc
class _$SetUserAvatarPayloadCopyWithImpl<$Res>
    implements $SetUserAvatarPayloadCopyWith<$Res> {
  _$SetUserAvatarPayloadCopyWithImpl(this._self, this._then);

  final SetUserAvatarPayload _self;
  final $Res Function(SetUserAvatarPayload) _then;

/// Create a copy of SetUserAvatarPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SetUserAvatarPayload].
extension SetUserAvatarPayloadPatterns on SetUserAvatarPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetUserAvatarPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetUserAvatarPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetUserAvatarPayload value)  $default,){
final _that = this;
switch (_that) {
case _SetUserAvatarPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetUserAvatarPayload value)?  $default,){
final _that = this;
switch (_that) {
case _SetUserAvatarPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetUserAvatarPayload() when $default != null:
return $default(_that.fileId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId)  $default,) {final _that = this;
switch (_that) {
case _SetUserAvatarPayload():
return $default(_that.fileId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId)?  $default,) {final _that = this;
switch (_that) {
case _SetUserAvatarPayload() when $default != null:
return $default(_that.fileId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetUserAvatarPayload implements SetUserAvatarPayload {
  const _SetUserAvatarPayload({required this.fileId});
  factory _SetUserAvatarPayload.fromJson(Map<String, dynamic> json) => _$SetUserAvatarPayloadFromJson(json);

@override final  String fileId;

/// Create a copy of SetUserAvatarPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetUserAvatarPayloadCopyWith<_SetUserAvatarPayload> get copyWith => __$SetUserAvatarPayloadCopyWithImpl<_SetUserAvatarPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetUserAvatarPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetUserAvatarPayload&&(identical(other.fileId, fileId) || other.fileId == fileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId);

@override
String toString() {
  return 'SetUserAvatarPayload(fileId: $fileId)';
}


}

/// @nodoc
abstract mixin class _$SetUserAvatarPayloadCopyWith<$Res> implements $SetUserAvatarPayloadCopyWith<$Res> {
  factory _$SetUserAvatarPayloadCopyWith(_SetUserAvatarPayload value, $Res Function(_SetUserAvatarPayload) _then) = __$SetUserAvatarPayloadCopyWithImpl;
@override @useResult
$Res call({
 String fileId
});




}
/// @nodoc
class __$SetUserAvatarPayloadCopyWithImpl<$Res>
    implements _$SetUserAvatarPayloadCopyWith<$Res> {
  __$SetUserAvatarPayloadCopyWithImpl(this._self, this._then);

  final _SetUserAvatarPayload _self;
  final $Res Function(_SetUserAvatarPayload) _then;

/// Create a copy of SetUserAvatarPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,}) {
  return _then(_SetUserAvatarPayload(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StorageScanResultPayload {

 StorageScanStatus get scanStatus;
/// Create a copy of StorageScanResultPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageScanResultPayloadCopyWith<StorageScanResultPayload> get copyWith => _$StorageScanResultPayloadCopyWithImpl<StorageScanResultPayload>(this as StorageScanResultPayload, _$identity);

  /// Serializes this StorageScanResultPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageScanResultPayload&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scanStatus);

@override
String toString() {
  return 'StorageScanResultPayload(scanStatus: $scanStatus)';
}


}

/// @nodoc
abstract mixin class $StorageScanResultPayloadCopyWith<$Res>  {
  factory $StorageScanResultPayloadCopyWith(StorageScanResultPayload value, $Res Function(StorageScanResultPayload) _then) = _$StorageScanResultPayloadCopyWithImpl;
@useResult
$Res call({
 StorageScanStatus scanStatus
});




}
/// @nodoc
class _$StorageScanResultPayloadCopyWithImpl<$Res>
    implements $StorageScanResultPayloadCopyWith<$Res> {
  _$StorageScanResultPayloadCopyWithImpl(this._self, this._then);

  final StorageScanResultPayload _self;
  final $Res Function(StorageScanResultPayload) _then;

/// Create a copy of StorageScanResultPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scanStatus = null,}) {
  return _then(_self.copyWith(
scanStatus: null == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as StorageScanStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageScanResultPayload].
extension StorageScanResultPayloadPatterns on StorageScanResultPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageScanResultPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageScanResultPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageScanResultPayload value)  $default,){
final _that = this;
switch (_that) {
case _StorageScanResultPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageScanResultPayload value)?  $default,){
final _that = this;
switch (_that) {
case _StorageScanResultPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StorageScanStatus scanStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageScanResultPayload() when $default != null:
return $default(_that.scanStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StorageScanStatus scanStatus)  $default,) {final _that = this;
switch (_that) {
case _StorageScanResultPayload():
return $default(_that.scanStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StorageScanStatus scanStatus)?  $default,) {final _that = this;
switch (_that) {
case _StorageScanResultPayload() when $default != null:
return $default(_that.scanStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageScanResultPayload implements StorageScanResultPayload {
  const _StorageScanResultPayload({required this.scanStatus});
  factory _StorageScanResultPayload.fromJson(Map<String, dynamic> json) => _$StorageScanResultPayloadFromJson(json);

@override final  StorageScanStatus scanStatus;

/// Create a copy of StorageScanResultPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageScanResultPayloadCopyWith<_StorageScanResultPayload> get copyWith => __$StorageScanResultPayloadCopyWithImpl<_StorageScanResultPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageScanResultPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageScanResultPayload&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scanStatus);

@override
String toString() {
  return 'StorageScanResultPayload(scanStatus: $scanStatus)';
}


}

/// @nodoc
abstract mixin class _$StorageScanResultPayloadCopyWith<$Res> implements $StorageScanResultPayloadCopyWith<$Res> {
  factory _$StorageScanResultPayloadCopyWith(_StorageScanResultPayload value, $Res Function(_StorageScanResultPayload) _then) = __$StorageScanResultPayloadCopyWithImpl;
@override @useResult
$Res call({
 StorageScanStatus scanStatus
});




}
/// @nodoc
class __$StorageScanResultPayloadCopyWithImpl<$Res>
    implements _$StorageScanResultPayloadCopyWith<$Res> {
  __$StorageScanResultPayloadCopyWithImpl(this._self, this._then);

  final _StorageScanResultPayload _self;
  final $Res Function(_StorageScanResultPayload) _then;

/// Create a copy of StorageScanResultPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scanStatus = null,}) {
  return _then(_StorageScanResultPayload(
scanStatus: null == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as StorageScanStatus,
  ));
}


}


/// @nodoc
mixin _$StorageFileVersionResponse {

 String get id; int get version; int get fileSizeBytes; String? get contentSha256; String get createdByUserId; DateTime get createdAtUtc; String? get changeSummary; bool get isCurrent; String? get changedByUserId;
/// Create a copy of StorageFileVersionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFileVersionResponseCopyWith<StorageFileVersionResponse> get copyWith => _$StorageFileVersionResponseCopyWithImpl<StorageFileVersionResponse>(this as StorageFileVersionResponse, _$identity);

  /// Serializes this StorageFileVersionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFileVersionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent)&&(identical(other.changedByUserId, changedByUserId) || other.changedByUserId == changedByUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,fileSizeBytes,contentSha256,createdByUserId,createdAtUtc,changeSummary,isCurrent,changedByUserId);

@override
String toString() {
  return 'StorageFileVersionResponse(id: $id, version: $version, fileSizeBytes: $fileSizeBytes, contentSha256: $contentSha256, createdByUserId: $createdByUserId, createdAtUtc: $createdAtUtc, changeSummary: $changeSummary, isCurrent: $isCurrent, changedByUserId: $changedByUserId)';
}


}

/// @nodoc
abstract mixin class $StorageFileVersionResponseCopyWith<$Res>  {
  factory $StorageFileVersionResponseCopyWith(StorageFileVersionResponse value, $Res Function(StorageFileVersionResponse) _then) = _$StorageFileVersionResponseCopyWithImpl;
@useResult
$Res call({
 String id, int version, int fileSizeBytes, String? contentSha256, String createdByUserId, DateTime createdAtUtc, String? changeSummary, bool isCurrent, String? changedByUserId
});




}
/// @nodoc
class _$StorageFileVersionResponseCopyWithImpl<$Res>
    implements $StorageFileVersionResponseCopyWith<$Res> {
  _$StorageFileVersionResponseCopyWithImpl(this._self, this._then);

  final StorageFileVersionResponse _self;
  final $Res Function(StorageFileVersionResponse) _then;

/// Create a copy of StorageFileVersionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? fileSizeBytes = null,Object? contentSha256 = freezed,Object? createdByUserId = null,Object? createdAtUtc = null,Object? changeSummary = freezed,Object? isCurrent = null,Object? changedByUserId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,changedByUserId: freezed == changedByUserId ? _self.changedByUserId : changedByUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageFileVersionResponse].
extension StorageFileVersionResponsePatterns on StorageFileVersionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFileVersionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFileVersionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFileVersionResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFileVersionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFileVersionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFileVersionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int version,  int fileSizeBytes,  String? contentSha256,  String createdByUserId,  DateTime createdAtUtc,  String? changeSummary,  bool isCurrent,  String? changedByUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFileVersionResponse() when $default != null:
return $default(_that.id,_that.version,_that.fileSizeBytes,_that.contentSha256,_that.createdByUserId,_that.createdAtUtc,_that.changeSummary,_that.isCurrent,_that.changedByUserId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int version,  int fileSizeBytes,  String? contentSha256,  String createdByUserId,  DateTime createdAtUtc,  String? changeSummary,  bool isCurrent,  String? changedByUserId)  $default,) {final _that = this;
switch (_that) {
case _StorageFileVersionResponse():
return $default(_that.id,_that.version,_that.fileSizeBytes,_that.contentSha256,_that.createdByUserId,_that.createdAtUtc,_that.changeSummary,_that.isCurrent,_that.changedByUserId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int version,  int fileSizeBytes,  String? contentSha256,  String createdByUserId,  DateTime createdAtUtc,  String? changeSummary,  bool isCurrent,  String? changedByUserId)?  $default,) {final _that = this;
switch (_that) {
case _StorageFileVersionResponse() when $default != null:
return $default(_that.id,_that.version,_that.fileSizeBytes,_that.contentSha256,_that.createdByUserId,_that.createdAtUtc,_that.changeSummary,_that.isCurrent,_that.changedByUserId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFileVersionResponse implements StorageFileVersionResponse {
  const _StorageFileVersionResponse({required this.id, required this.version, required this.fileSizeBytes, this.contentSha256, required this.createdByUserId, required this.createdAtUtc, this.changeSummary, this.isCurrent = false, this.changedByUserId});
  factory _StorageFileVersionResponse.fromJson(Map<String, dynamic> json) => _$StorageFileVersionResponseFromJson(json);

@override final  String id;
@override final  int version;
@override final  int fileSizeBytes;
@override final  String? contentSha256;
@override final  String createdByUserId;
@override final  DateTime createdAtUtc;
@override final  String? changeSummary;
@override@JsonKey() final  bool isCurrent;
@override final  String? changedByUserId;

/// Create a copy of StorageFileVersionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFileVersionResponseCopyWith<_StorageFileVersionResponse> get copyWith => __$StorageFileVersionResponseCopyWithImpl<_StorageFileVersionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFileVersionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFileVersionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent)&&(identical(other.changedByUserId, changedByUserId) || other.changedByUserId == changedByUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,fileSizeBytes,contentSha256,createdByUserId,createdAtUtc,changeSummary,isCurrent,changedByUserId);

@override
String toString() {
  return 'StorageFileVersionResponse(id: $id, version: $version, fileSizeBytes: $fileSizeBytes, contentSha256: $contentSha256, createdByUserId: $createdByUserId, createdAtUtc: $createdAtUtc, changeSummary: $changeSummary, isCurrent: $isCurrent, changedByUserId: $changedByUserId)';
}


}

/// @nodoc
abstract mixin class _$StorageFileVersionResponseCopyWith<$Res> implements $StorageFileVersionResponseCopyWith<$Res> {
  factory _$StorageFileVersionResponseCopyWith(_StorageFileVersionResponse value, $Res Function(_StorageFileVersionResponse) _then) = __$StorageFileVersionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, int fileSizeBytes, String? contentSha256, String createdByUserId, DateTime createdAtUtc, String? changeSummary, bool isCurrent, String? changedByUserId
});




}
/// @nodoc
class __$StorageFileVersionResponseCopyWithImpl<$Res>
    implements _$StorageFileVersionResponseCopyWith<$Res> {
  __$StorageFileVersionResponseCopyWithImpl(this._self, this._then);

  final _StorageFileVersionResponse _self;
  final $Res Function(_StorageFileVersionResponse) _then;

/// Create a copy of StorageFileVersionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? fileSizeBytes = null,Object? contentSha256 = freezed,Object? createdByUserId = null,Object? createdAtUtc = null,Object? changeSummary = freezed,Object? isCurrent = null,Object? changedByUserId = freezed,}) {
  return _then(_StorageFileVersionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,changedByUserId: freezed == changedByUserId ? _self.changedByUserId : changedByUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RestoreStorageFileVersionPayload {

 int get expectedVersion; String? get changeSummary;
/// Create a copy of RestoreStorageFileVersionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestoreStorageFileVersionPayloadCopyWith<RestoreStorageFileVersionPayload> get copyWith => _$RestoreStorageFileVersionPayloadCopyWithImpl<RestoreStorageFileVersionPayload>(this as RestoreStorageFileVersionPayload, _$identity);

  /// Serializes this RestoreStorageFileVersionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestoreStorageFileVersionPayload&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expectedVersion,changeSummary);

@override
String toString() {
  return 'RestoreStorageFileVersionPayload(expectedVersion: $expectedVersion, changeSummary: $changeSummary)';
}


}

/// @nodoc
abstract mixin class $RestoreStorageFileVersionPayloadCopyWith<$Res>  {
  factory $RestoreStorageFileVersionPayloadCopyWith(RestoreStorageFileVersionPayload value, $Res Function(RestoreStorageFileVersionPayload) _then) = _$RestoreStorageFileVersionPayloadCopyWithImpl;
@useResult
$Res call({
 int expectedVersion, String? changeSummary
});




}
/// @nodoc
class _$RestoreStorageFileVersionPayloadCopyWithImpl<$Res>
    implements $RestoreStorageFileVersionPayloadCopyWith<$Res> {
  _$RestoreStorageFileVersionPayloadCopyWithImpl(this._self, this._then);

  final RestoreStorageFileVersionPayload _self;
  final $Res Function(RestoreStorageFileVersionPayload) _then;

/// Create a copy of RestoreStorageFileVersionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expectedVersion = null,Object? changeSummary = freezed,}) {
  return _then(_self.copyWith(
expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RestoreStorageFileVersionPayload].
extension RestoreStorageFileVersionPayloadPatterns on RestoreStorageFileVersionPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestoreStorageFileVersionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestoreStorageFileVersionPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestoreStorageFileVersionPayload value)  $default,){
final _that = this;
switch (_that) {
case _RestoreStorageFileVersionPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestoreStorageFileVersionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _RestoreStorageFileVersionPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int expectedVersion,  String? changeSummary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestoreStorageFileVersionPayload() when $default != null:
return $default(_that.expectedVersion,_that.changeSummary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int expectedVersion,  String? changeSummary)  $default,) {final _that = this;
switch (_that) {
case _RestoreStorageFileVersionPayload():
return $default(_that.expectedVersion,_that.changeSummary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int expectedVersion,  String? changeSummary)?  $default,) {final _that = this;
switch (_that) {
case _RestoreStorageFileVersionPayload() when $default != null:
return $default(_that.expectedVersion,_that.changeSummary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestoreStorageFileVersionPayload implements RestoreStorageFileVersionPayload {
  const _RestoreStorageFileVersionPayload({required this.expectedVersion, this.changeSummary});
  factory _RestoreStorageFileVersionPayload.fromJson(Map<String, dynamic> json) => _$RestoreStorageFileVersionPayloadFromJson(json);

@override final  int expectedVersion;
@override final  String? changeSummary;

/// Create a copy of RestoreStorageFileVersionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestoreStorageFileVersionPayloadCopyWith<_RestoreStorageFileVersionPayload> get copyWith => __$RestoreStorageFileVersionPayloadCopyWithImpl<_RestoreStorageFileVersionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestoreStorageFileVersionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestoreStorageFileVersionPayload&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expectedVersion,changeSummary);

@override
String toString() {
  return 'RestoreStorageFileVersionPayload(expectedVersion: $expectedVersion, changeSummary: $changeSummary)';
}


}

/// @nodoc
abstract mixin class _$RestoreStorageFileVersionPayloadCopyWith<$Res> implements $RestoreStorageFileVersionPayloadCopyWith<$Res> {
  factory _$RestoreStorageFileVersionPayloadCopyWith(_RestoreStorageFileVersionPayload value, $Res Function(_RestoreStorageFileVersionPayload) _then) = __$RestoreStorageFileVersionPayloadCopyWithImpl;
@override @useResult
$Res call({
 int expectedVersion, String? changeSummary
});




}
/// @nodoc
class __$RestoreStorageFileVersionPayloadCopyWithImpl<$Res>
    implements _$RestoreStorageFileVersionPayloadCopyWith<$Res> {
  __$RestoreStorageFileVersionPayloadCopyWithImpl(this._self, this._then);

  final _RestoreStorageFileVersionPayload _self;
  final $Res Function(_RestoreStorageFileVersionPayload) _then;

/// Create a copy of RestoreStorageFileVersionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expectedVersion = null,Object? changeSummary = freezed,}) {
  return _then(_RestoreStorageFileVersionPayload(
expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StorageFileVersionDownloadTicketResponse {

 String get fileId; int get version; String get originalFileName; String get mimeType; int get fileSizeBytes; String? get contentSha256; String get downloadUrl; DateTime get expiresAtUtc;
/// Create a copy of StorageFileVersionDownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFileVersionDownloadTicketResponseCopyWith<StorageFileVersionDownloadTicketResponse> get copyWith => _$StorageFileVersionDownloadTicketResponseCopyWithImpl<StorageFileVersionDownloadTicketResponse>(this as StorageFileVersionDownloadTicketResponse, _$identity);

  /// Serializes this StorageFileVersionDownloadTicketResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFileVersionDownloadTicketResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.version, version) || other.version == version)&&(identical(other.originalFileName, originalFileName) || other.originalFileName == originalFileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,version,originalFileName,mimeType,fileSizeBytes,contentSha256,downloadUrl,expiresAtUtc);

@override
String toString() {
  return 'StorageFileVersionDownloadTicketResponse(fileId: $fileId, version: $version, originalFileName: $originalFileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, contentSha256: $contentSha256, downloadUrl: $downloadUrl, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class $StorageFileVersionDownloadTicketResponseCopyWith<$Res>  {
  factory $StorageFileVersionDownloadTicketResponseCopyWith(StorageFileVersionDownloadTicketResponse value, $Res Function(StorageFileVersionDownloadTicketResponse) _then) = _$StorageFileVersionDownloadTicketResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, int version, String originalFileName, String mimeType, int fileSizeBytes, String? contentSha256, String downloadUrl, DateTime expiresAtUtc
});




}
/// @nodoc
class _$StorageFileVersionDownloadTicketResponseCopyWithImpl<$Res>
    implements $StorageFileVersionDownloadTicketResponseCopyWith<$Res> {
  _$StorageFileVersionDownloadTicketResponseCopyWithImpl(this._self, this._then);

  final StorageFileVersionDownloadTicketResponse _self;
  final $Res Function(StorageFileVersionDownloadTicketResponse) _then;

/// Create a copy of StorageFileVersionDownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? version = null,Object? originalFileName = null,Object? mimeType = null,Object? fileSizeBytes = null,Object? contentSha256 = freezed,Object? downloadUrl = null,Object? expiresAtUtc = null,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,originalFileName: null == originalFileName ? _self.originalFileName : originalFileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageFileVersionDownloadTicketResponse].
extension StorageFileVersionDownloadTicketResponsePatterns on StorageFileVersionDownloadTicketResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFileVersionDownloadTicketResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFileVersionDownloadTicketResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFileVersionDownloadTicketResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFileVersionDownloadTicketResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFileVersionDownloadTicketResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFileVersionDownloadTicketResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  int version,  String originalFileName,  String mimeType,  int fileSizeBytes,  String? contentSha256,  String downloadUrl,  DateTime expiresAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFileVersionDownloadTicketResponse() when $default != null:
return $default(_that.fileId,_that.version,_that.originalFileName,_that.mimeType,_that.fileSizeBytes,_that.contentSha256,_that.downloadUrl,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  int version,  String originalFileName,  String mimeType,  int fileSizeBytes,  String? contentSha256,  String downloadUrl,  DateTime expiresAtUtc)  $default,) {final _that = this;
switch (_that) {
case _StorageFileVersionDownloadTicketResponse():
return $default(_that.fileId,_that.version,_that.originalFileName,_that.mimeType,_that.fileSizeBytes,_that.contentSha256,_that.downloadUrl,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  int version,  String originalFileName,  String mimeType,  int fileSizeBytes,  String? contentSha256,  String downloadUrl,  DateTime expiresAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _StorageFileVersionDownloadTicketResponse() when $default != null:
return $default(_that.fileId,_that.version,_that.originalFileName,_that.mimeType,_that.fileSizeBytes,_that.contentSha256,_that.downloadUrl,_that.expiresAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFileVersionDownloadTicketResponse implements StorageFileVersionDownloadTicketResponse {
  const _StorageFileVersionDownloadTicketResponse({required this.fileId, required this.version, required this.originalFileName, required this.mimeType, required this.fileSizeBytes, this.contentSha256, required this.downloadUrl, required this.expiresAtUtc});
  factory _StorageFileVersionDownloadTicketResponse.fromJson(Map<String, dynamic> json) => _$StorageFileVersionDownloadTicketResponseFromJson(json);

@override final  String fileId;
@override final  int version;
@override final  String originalFileName;
@override final  String mimeType;
@override final  int fileSizeBytes;
@override final  String? contentSha256;
@override final  String downloadUrl;
@override final  DateTime expiresAtUtc;

/// Create a copy of StorageFileVersionDownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFileVersionDownloadTicketResponseCopyWith<_StorageFileVersionDownloadTicketResponse> get copyWith => __$StorageFileVersionDownloadTicketResponseCopyWithImpl<_StorageFileVersionDownloadTicketResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFileVersionDownloadTicketResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFileVersionDownloadTicketResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.version, version) || other.version == version)&&(identical(other.originalFileName, originalFileName) || other.originalFileName == originalFileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,version,originalFileName,mimeType,fileSizeBytes,contentSha256,downloadUrl,expiresAtUtc);

@override
String toString() {
  return 'StorageFileVersionDownloadTicketResponse(fileId: $fileId, version: $version, originalFileName: $originalFileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, contentSha256: $contentSha256, downloadUrl: $downloadUrl, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class _$StorageFileVersionDownloadTicketResponseCopyWith<$Res> implements $StorageFileVersionDownloadTicketResponseCopyWith<$Res> {
  factory _$StorageFileVersionDownloadTicketResponseCopyWith(_StorageFileVersionDownloadTicketResponse value, $Res Function(_StorageFileVersionDownloadTicketResponse) _then) = __$StorageFileVersionDownloadTicketResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, int version, String originalFileName, String mimeType, int fileSizeBytes, String? contentSha256, String downloadUrl, DateTime expiresAtUtc
});




}
/// @nodoc
class __$StorageFileVersionDownloadTicketResponseCopyWithImpl<$Res>
    implements _$StorageFileVersionDownloadTicketResponseCopyWith<$Res> {
  __$StorageFileVersionDownloadTicketResponseCopyWithImpl(this._self, this._then);

  final _StorageFileVersionDownloadTicketResponse _self;
  final $Res Function(_StorageFileVersionDownloadTicketResponse) _then;

/// Create a copy of StorageFileVersionDownloadTicketResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? version = null,Object? originalFileName = null,Object? mimeType = null,Object? fileSizeBytes = null,Object? contentSha256 = freezed,Object? downloadUrl = null,Object? expiresAtUtc = null,}) {
  return _then(_StorageFileVersionDownloadTicketResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,originalFileName: null == originalFileName ? _self.originalFileName : originalFileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StorageFilePermissionsResponse {

 StorageEffectiveAccessLevel get accessLevel; bool get canRead; bool get canComment; bool get canEdit; bool get canShare; bool get canDelete;
/// Create a copy of StorageFilePermissionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFilePermissionsResponseCopyWith<StorageFilePermissionsResponse> get copyWith => _$StorageFilePermissionsResponseCopyWithImpl<StorageFilePermissionsResponse>(this as StorageFilePermissionsResponse, _$identity);

  /// Serializes this StorageFilePermissionsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFilePermissionsResponse&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.canRead, canRead) || other.canRead == canRead)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessLevel,canRead,canComment,canEdit,canShare,canDelete);

@override
String toString() {
  return 'StorageFilePermissionsResponse(accessLevel: $accessLevel, canRead: $canRead, canComment: $canComment, canEdit: $canEdit, canShare: $canShare, canDelete: $canDelete)';
}


}

/// @nodoc
abstract mixin class $StorageFilePermissionsResponseCopyWith<$Res>  {
  factory $StorageFilePermissionsResponseCopyWith(StorageFilePermissionsResponse value, $Res Function(StorageFilePermissionsResponse) _then) = _$StorageFilePermissionsResponseCopyWithImpl;
@useResult
$Res call({
 StorageEffectiveAccessLevel accessLevel, bool canRead, bool canComment, bool canEdit, bool canShare, bool canDelete
});




}
/// @nodoc
class _$StorageFilePermissionsResponseCopyWithImpl<$Res>
    implements $StorageFilePermissionsResponseCopyWith<$Res> {
  _$StorageFilePermissionsResponseCopyWithImpl(this._self, this._then);

  final StorageFilePermissionsResponse _self;
  final $Res Function(StorageFilePermissionsResponse) _then;

/// Create a copy of StorageFilePermissionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessLevel = null,Object? canRead = null,Object? canComment = null,Object? canEdit = null,Object? canShare = null,Object? canDelete = null,}) {
  return _then(_self.copyWith(
accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as StorageEffectiveAccessLevel,canRead: null == canRead ? _self.canRead : canRead // ignore: cast_nullable_to_non_nullable
as bool,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageFilePermissionsResponse].
extension StorageFilePermissionsResponsePatterns on StorageFilePermissionsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFilePermissionsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFilePermissionsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFilePermissionsResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFilePermissionsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFilePermissionsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFilePermissionsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StorageEffectiveAccessLevel accessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFilePermissionsResponse() when $default != null:
return $default(_that.accessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StorageEffectiveAccessLevel accessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete)  $default,) {final _that = this;
switch (_that) {
case _StorageFilePermissionsResponse():
return $default(_that.accessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StorageEffectiveAccessLevel accessLevel,  bool canRead,  bool canComment,  bool canEdit,  bool canShare,  bool canDelete)?  $default,) {final _that = this;
switch (_that) {
case _StorageFilePermissionsResponse() when $default != null:
return $default(_that.accessLevel,_that.canRead,_that.canComment,_that.canEdit,_that.canShare,_that.canDelete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFilePermissionsResponse implements StorageFilePermissionsResponse {
  const _StorageFilePermissionsResponse({required this.accessLevel, required this.canRead, required this.canComment, required this.canEdit, required this.canShare, required this.canDelete});
  factory _StorageFilePermissionsResponse.fromJson(Map<String, dynamic> json) => _$StorageFilePermissionsResponseFromJson(json);

@override final  StorageEffectiveAccessLevel accessLevel;
@override final  bool canRead;
@override final  bool canComment;
@override final  bool canEdit;
@override final  bool canShare;
@override final  bool canDelete;

/// Create a copy of StorageFilePermissionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFilePermissionsResponseCopyWith<_StorageFilePermissionsResponse> get copyWith => __$StorageFilePermissionsResponseCopyWithImpl<_StorageFilePermissionsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFilePermissionsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFilePermissionsResponse&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.canRead, canRead) || other.canRead == canRead)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessLevel,canRead,canComment,canEdit,canShare,canDelete);

@override
String toString() {
  return 'StorageFilePermissionsResponse(accessLevel: $accessLevel, canRead: $canRead, canComment: $canComment, canEdit: $canEdit, canShare: $canShare, canDelete: $canDelete)';
}


}

/// @nodoc
abstract mixin class _$StorageFilePermissionsResponseCopyWith<$Res> implements $StorageFilePermissionsResponseCopyWith<$Res> {
  factory _$StorageFilePermissionsResponseCopyWith(_StorageFilePermissionsResponse value, $Res Function(_StorageFilePermissionsResponse) _then) = __$StorageFilePermissionsResponseCopyWithImpl;
@override @useResult
$Res call({
 StorageEffectiveAccessLevel accessLevel, bool canRead, bool canComment, bool canEdit, bool canShare, bool canDelete
});




}
/// @nodoc
class __$StorageFilePermissionsResponseCopyWithImpl<$Res>
    implements _$StorageFilePermissionsResponseCopyWith<$Res> {
  __$StorageFilePermissionsResponseCopyWithImpl(this._self, this._then);

  final _StorageFilePermissionsResponse _self;
  final $Res Function(_StorageFilePermissionsResponse) _then;

/// Create a copy of StorageFilePermissionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessLevel = null,Object? canRead = null,Object? canComment = null,Object? canEdit = null,Object? canShare = null,Object? canDelete = null,}) {
  return _then(_StorageFilePermissionsResponse(
accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
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
mixin _$StorageFileDetailsResponse {

 StorageFileResponse get file; List<StorageFileVersionResponse> get versions; bool get canEdit; bool get canDelete; bool get isOfficeDocument; StorageFilePermissionsResponse get permissions; bool get canOpenResourceChat;
/// Create a copy of StorageFileDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFileDetailsResponseCopyWith<StorageFileDetailsResponse> get copyWith => _$StorageFileDetailsResponseCopyWithImpl<StorageFileDetailsResponse>(this as StorageFileDetailsResponse, _$identity);

  /// Serializes this StorageFileDetailsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFileDetailsResponse&&(identical(other.file, file) || other.file == file)&&const DeepCollectionEquality().equals(other.versions, versions)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.isOfficeDocument, isOfficeDocument) || other.isOfficeDocument == isOfficeDocument)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.canOpenResourceChat, canOpenResourceChat) || other.canOpenResourceChat == canOpenResourceChat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,file,const DeepCollectionEquality().hash(versions),canEdit,canDelete,isOfficeDocument,permissions,canOpenResourceChat);

@override
String toString() {
  return 'StorageFileDetailsResponse(file: $file, versions: $versions, canEdit: $canEdit, canDelete: $canDelete, isOfficeDocument: $isOfficeDocument, permissions: $permissions, canOpenResourceChat: $canOpenResourceChat)';
}


}

/// @nodoc
abstract mixin class $StorageFileDetailsResponseCopyWith<$Res>  {
  factory $StorageFileDetailsResponseCopyWith(StorageFileDetailsResponse value, $Res Function(StorageFileDetailsResponse) _then) = _$StorageFileDetailsResponseCopyWithImpl;
@useResult
$Res call({
 StorageFileResponse file, List<StorageFileVersionResponse> versions, bool canEdit, bool canDelete, bool isOfficeDocument, StorageFilePermissionsResponse permissions, bool canOpenResourceChat
});


$StorageFileResponseCopyWith<$Res> get file;$StorageFilePermissionsResponseCopyWith<$Res> get permissions;

}
/// @nodoc
class _$StorageFileDetailsResponseCopyWithImpl<$Res>
    implements $StorageFileDetailsResponseCopyWith<$Res> {
  _$StorageFileDetailsResponseCopyWithImpl(this._self, this._then);

  final StorageFileDetailsResponse _self;
  final $Res Function(StorageFileDetailsResponse) _then;

/// Create a copy of StorageFileDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? file = null,Object? versions = null,Object? canEdit = null,Object? canDelete = null,Object? isOfficeDocument = null,Object? permissions = null,Object? canOpenResourceChat = null,}) {
  return _then(_self.copyWith(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as StorageFileResponse,versions: null == versions ? _self.versions : versions // ignore: cast_nullable_to_non_nullable
as List<StorageFileVersionResponse>,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,isOfficeDocument: null == isOfficeDocument ? _self.isOfficeDocument : isOfficeDocument // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as StorageFilePermissionsResponse,canOpenResourceChat: null == canOpenResourceChat ? _self.canOpenResourceChat : canOpenResourceChat // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of StorageFileDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFileResponseCopyWith<$Res> get file {
  
  return $StorageFileResponseCopyWith<$Res>(_self.file, (value) {
    return _then(_self.copyWith(file: value));
  });
}/// Create a copy of StorageFileDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFilePermissionsResponseCopyWith<$Res> get permissions {
  
  return $StorageFilePermissionsResponseCopyWith<$Res>(_self.permissions, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}
}


/// Adds pattern-matching-related methods to [StorageFileDetailsResponse].
extension StorageFileDetailsResponsePatterns on StorageFileDetailsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFileDetailsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFileDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFileDetailsResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFileDetailsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFileDetailsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFileDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StorageFileResponse file,  List<StorageFileVersionResponse> versions,  bool canEdit,  bool canDelete,  bool isOfficeDocument,  StorageFilePermissionsResponse permissions,  bool canOpenResourceChat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFileDetailsResponse() when $default != null:
return $default(_that.file,_that.versions,_that.canEdit,_that.canDelete,_that.isOfficeDocument,_that.permissions,_that.canOpenResourceChat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StorageFileResponse file,  List<StorageFileVersionResponse> versions,  bool canEdit,  bool canDelete,  bool isOfficeDocument,  StorageFilePermissionsResponse permissions,  bool canOpenResourceChat)  $default,) {final _that = this;
switch (_that) {
case _StorageFileDetailsResponse():
return $default(_that.file,_that.versions,_that.canEdit,_that.canDelete,_that.isOfficeDocument,_that.permissions,_that.canOpenResourceChat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StorageFileResponse file,  List<StorageFileVersionResponse> versions,  bool canEdit,  bool canDelete,  bool isOfficeDocument,  StorageFilePermissionsResponse permissions,  bool canOpenResourceChat)?  $default,) {final _that = this;
switch (_that) {
case _StorageFileDetailsResponse() when $default != null:
return $default(_that.file,_that.versions,_that.canEdit,_that.canDelete,_that.isOfficeDocument,_that.permissions,_that.canOpenResourceChat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFileDetailsResponse implements StorageFileDetailsResponse {
  const _StorageFileDetailsResponse({required this.file, required this.versions, required this.canEdit, required this.canDelete, required this.isOfficeDocument, required this.permissions, this.canOpenResourceChat = false});
  factory _StorageFileDetailsResponse.fromJson(Map<String, dynamic> json) => _$StorageFileDetailsResponseFromJson(json);

@override final  StorageFileResponse file;
@override final  List<StorageFileVersionResponse> versions;
@override final  bool canEdit;
@override final  bool canDelete;
@override final  bool isOfficeDocument;
@override final  StorageFilePermissionsResponse permissions;
@override@JsonKey() final  bool canOpenResourceChat;

/// Create a copy of StorageFileDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFileDetailsResponseCopyWith<_StorageFileDetailsResponse> get copyWith => __$StorageFileDetailsResponseCopyWithImpl<_StorageFileDetailsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFileDetailsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFileDetailsResponse&&(identical(other.file, file) || other.file == file)&&const DeepCollectionEquality().equals(other.versions, versions)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.isOfficeDocument, isOfficeDocument) || other.isOfficeDocument == isOfficeDocument)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.canOpenResourceChat, canOpenResourceChat) || other.canOpenResourceChat == canOpenResourceChat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,file,const DeepCollectionEquality().hash(versions),canEdit,canDelete,isOfficeDocument,permissions,canOpenResourceChat);

@override
String toString() {
  return 'StorageFileDetailsResponse(file: $file, versions: $versions, canEdit: $canEdit, canDelete: $canDelete, isOfficeDocument: $isOfficeDocument, permissions: $permissions, canOpenResourceChat: $canOpenResourceChat)';
}


}

/// @nodoc
abstract mixin class _$StorageFileDetailsResponseCopyWith<$Res> implements $StorageFileDetailsResponseCopyWith<$Res> {
  factory _$StorageFileDetailsResponseCopyWith(_StorageFileDetailsResponse value, $Res Function(_StorageFileDetailsResponse) _then) = __$StorageFileDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
 StorageFileResponse file, List<StorageFileVersionResponse> versions, bool canEdit, bool canDelete, bool isOfficeDocument, StorageFilePermissionsResponse permissions, bool canOpenResourceChat
});


@override $StorageFileResponseCopyWith<$Res> get file;@override $StorageFilePermissionsResponseCopyWith<$Res> get permissions;

}
/// @nodoc
class __$StorageFileDetailsResponseCopyWithImpl<$Res>
    implements _$StorageFileDetailsResponseCopyWith<$Res> {
  __$StorageFileDetailsResponseCopyWithImpl(this._self, this._then);

  final _StorageFileDetailsResponse _self;
  final $Res Function(_StorageFileDetailsResponse) _then;

/// Create a copy of StorageFileDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? file = null,Object? versions = null,Object? canEdit = null,Object? canDelete = null,Object? isOfficeDocument = null,Object? permissions = null,Object? canOpenResourceChat = null,}) {
  return _then(_StorageFileDetailsResponse(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as StorageFileResponse,versions: null == versions ? _self.versions : versions // ignore: cast_nullable_to_non_nullable
as List<StorageFileVersionResponse>,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,isOfficeDocument: null == isOfficeDocument ? _self.isOfficeDocument : isOfficeDocument // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as StorageFilePermissionsResponse,canOpenResourceChat: null == canOpenResourceChat ? _self.canOpenResourceChat : canOpenResourceChat // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of StorageFileDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFileResponseCopyWith<$Res> get file {
  
  return $StorageFileResponseCopyWith<$Res>(_self.file, (value) {
    return _then(_self.copyWith(file: value));
  });
}/// Create a copy of StorageFileDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFilePermissionsResponseCopyWith<$Res> get permissions {
  
  return $StorageFilePermissionsResponseCopyWith<$Res>(_self.permissions, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}
}


/// @nodoc
mixin _$StorageFilePlacementResponse {

 String get id; String get fileId; String get folderId; String? get displayName; String? get resourceType; String? get resourceId; DateTime get createdAtUtc; String? get fileName; String? get mimeType; int? get fileSizeBytes; StorageFilePermissionsResponse? get permissions; int? get version;
/// Create a copy of StorageFilePlacementResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFilePlacementResponseCopyWith<StorageFilePlacementResponse> get copyWith => _$StorageFilePlacementResponseCopyWithImpl<StorageFilePlacementResponse>(this as StorageFilePlacementResponse, _$identity);

  /// Serializes this StorageFilePlacementResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFilePlacementResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fileId,folderId,displayName,resourceType,resourceId,createdAtUtc,fileName,mimeType,fileSizeBytes,permissions,version);

@override
String toString() {
  return 'StorageFilePlacementResponse(id: $id, fileId: $fileId, folderId: $folderId, displayName: $displayName, resourceType: $resourceType, resourceId: $resourceId, createdAtUtc: $createdAtUtc, fileName: $fileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, permissions: $permissions, version: $version)';
}


}

/// @nodoc
abstract mixin class $StorageFilePlacementResponseCopyWith<$Res>  {
  factory $StorageFilePlacementResponseCopyWith(StorageFilePlacementResponse value, $Res Function(StorageFilePlacementResponse) _then) = _$StorageFilePlacementResponseCopyWithImpl;
@useResult
$Res call({
 String id, String fileId, String folderId, String? displayName, String? resourceType, String? resourceId, DateTime createdAtUtc, String? fileName, String? mimeType, int? fileSizeBytes, StorageFilePermissionsResponse? permissions, int? version
});


$StorageFilePermissionsResponseCopyWith<$Res>? get permissions;

}
/// @nodoc
class _$StorageFilePlacementResponseCopyWithImpl<$Res>
    implements $StorageFilePlacementResponseCopyWith<$Res> {
  _$StorageFilePlacementResponseCopyWithImpl(this._self, this._then);

  final StorageFilePlacementResponse _self;
  final $Res Function(StorageFilePlacementResponse) _then;

/// Create a copy of StorageFilePlacementResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fileId = null,Object? folderId = null,Object? displayName = freezed,Object? resourceType = freezed,Object? resourceId = freezed,Object? createdAtUtc = null,Object? fileName = freezed,Object? mimeType = freezed,Object? fileSizeBytes = freezed,Object? permissions = freezed,Object? version = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,resourceType: freezed == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String?,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as StorageFilePermissionsResponse?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of StorageFilePlacementResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFilePermissionsResponseCopyWith<$Res>? get permissions {
    if (_self.permissions == null) {
    return null;
  }

  return $StorageFilePermissionsResponseCopyWith<$Res>(_self.permissions!, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}
}


/// Adds pattern-matching-related methods to [StorageFilePlacementResponse].
extension StorageFilePlacementResponsePatterns on StorageFilePlacementResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFilePlacementResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFilePlacementResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFilePlacementResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFilePlacementResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFilePlacementResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFilePlacementResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fileId,  String folderId,  String? displayName,  String? resourceType,  String? resourceId,  DateTime createdAtUtc,  String? fileName,  String? mimeType,  int? fileSizeBytes,  StorageFilePermissionsResponse? permissions,  int? version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFilePlacementResponse() when $default != null:
return $default(_that.id,_that.fileId,_that.folderId,_that.displayName,_that.resourceType,_that.resourceId,_that.createdAtUtc,_that.fileName,_that.mimeType,_that.fileSizeBytes,_that.permissions,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fileId,  String folderId,  String? displayName,  String? resourceType,  String? resourceId,  DateTime createdAtUtc,  String? fileName,  String? mimeType,  int? fileSizeBytes,  StorageFilePermissionsResponse? permissions,  int? version)  $default,) {final _that = this;
switch (_that) {
case _StorageFilePlacementResponse():
return $default(_that.id,_that.fileId,_that.folderId,_that.displayName,_that.resourceType,_that.resourceId,_that.createdAtUtc,_that.fileName,_that.mimeType,_that.fileSizeBytes,_that.permissions,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fileId,  String folderId,  String? displayName,  String? resourceType,  String? resourceId,  DateTime createdAtUtc,  String? fileName,  String? mimeType,  int? fileSizeBytes,  StorageFilePermissionsResponse? permissions,  int? version)?  $default,) {final _that = this;
switch (_that) {
case _StorageFilePlacementResponse() when $default != null:
return $default(_that.id,_that.fileId,_that.folderId,_that.displayName,_that.resourceType,_that.resourceId,_that.createdAtUtc,_that.fileName,_that.mimeType,_that.fileSizeBytes,_that.permissions,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFilePlacementResponse implements StorageFilePlacementResponse {
  const _StorageFilePlacementResponse({required this.id, required this.fileId, required this.folderId, this.displayName, this.resourceType, this.resourceId, required this.createdAtUtc, this.fileName, this.mimeType, this.fileSizeBytes, this.permissions, this.version});
  factory _StorageFilePlacementResponse.fromJson(Map<String, dynamic> json) => _$StorageFilePlacementResponseFromJson(json);

@override final  String id;
@override final  String fileId;
@override final  String folderId;
@override final  String? displayName;
@override final  String? resourceType;
@override final  String? resourceId;
@override final  DateTime createdAtUtc;
@override final  String? fileName;
@override final  String? mimeType;
@override final  int? fileSizeBytes;
@override final  StorageFilePermissionsResponse? permissions;
@override final  int? version;

/// Create a copy of StorageFilePlacementResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFilePlacementResponseCopyWith<_StorageFilePlacementResponse> get copyWith => __$StorageFilePlacementResponseCopyWithImpl<_StorageFilePlacementResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFilePlacementResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFilePlacementResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fileId,folderId,displayName,resourceType,resourceId,createdAtUtc,fileName,mimeType,fileSizeBytes,permissions,version);

@override
String toString() {
  return 'StorageFilePlacementResponse(id: $id, fileId: $fileId, folderId: $folderId, displayName: $displayName, resourceType: $resourceType, resourceId: $resourceId, createdAtUtc: $createdAtUtc, fileName: $fileName, mimeType: $mimeType, fileSizeBytes: $fileSizeBytes, permissions: $permissions, version: $version)';
}


}

/// @nodoc
abstract mixin class _$StorageFilePlacementResponseCopyWith<$Res> implements $StorageFilePlacementResponseCopyWith<$Res> {
  factory _$StorageFilePlacementResponseCopyWith(_StorageFilePlacementResponse value, $Res Function(_StorageFilePlacementResponse) _then) = __$StorageFilePlacementResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String fileId, String folderId, String? displayName, String? resourceType, String? resourceId, DateTime createdAtUtc, String? fileName, String? mimeType, int? fileSizeBytes, StorageFilePermissionsResponse? permissions, int? version
});


@override $StorageFilePermissionsResponseCopyWith<$Res>? get permissions;

}
/// @nodoc
class __$StorageFilePlacementResponseCopyWithImpl<$Res>
    implements _$StorageFilePlacementResponseCopyWith<$Res> {
  __$StorageFilePlacementResponseCopyWithImpl(this._self, this._then);

  final _StorageFilePlacementResponse _self;
  final $Res Function(_StorageFilePlacementResponse) _then;

/// Create a copy of StorageFilePlacementResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fileId = null,Object? folderId = null,Object? displayName = freezed,Object? resourceType = freezed,Object? resourceId = freezed,Object? createdAtUtc = null,Object? fileName = freezed,Object? mimeType = freezed,Object? fileSizeBytes = freezed,Object? permissions = freezed,Object? version = freezed,}) {
  return _then(_StorageFilePlacementResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,resourceType: freezed == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String?,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,fileSizeBytes: freezed == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,permissions: freezed == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as StorageFilePermissionsResponse?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of StorageFilePlacementResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFilePermissionsResponseCopyWith<$Res>? get permissions {
    if (_self.permissions == null) {
    return null;
  }

  return $StorageFilePermissionsResponseCopyWith<$Res>(_self.permissions!, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}
}


/// @nodoc
mixin _$MoveStorageFilePlacementPayload {

 String get targetFolderId; int get expectedVersion;
/// Create a copy of MoveStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveStorageFilePlacementPayloadCopyWith<MoveStorageFilePlacementPayload> get copyWith => _$MoveStorageFilePlacementPayloadCopyWithImpl<MoveStorageFilePlacementPayload>(this as MoveStorageFilePlacementPayload, _$identity);

  /// Serializes this MoveStorageFilePlacementPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveStorageFilePlacementPayload&&(identical(other.targetFolderId, targetFolderId) || other.targetFolderId == targetFolderId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetFolderId,expectedVersion);

@override
String toString() {
  return 'MoveStorageFilePlacementPayload(targetFolderId: $targetFolderId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $MoveStorageFilePlacementPayloadCopyWith<$Res>  {
  factory $MoveStorageFilePlacementPayloadCopyWith(MoveStorageFilePlacementPayload value, $Res Function(MoveStorageFilePlacementPayload) _then) = _$MoveStorageFilePlacementPayloadCopyWithImpl;
@useResult
$Res call({
 String targetFolderId, int expectedVersion
});




}
/// @nodoc
class _$MoveStorageFilePlacementPayloadCopyWithImpl<$Res>
    implements $MoveStorageFilePlacementPayloadCopyWith<$Res> {
  _$MoveStorageFilePlacementPayloadCopyWithImpl(this._self, this._then);

  final MoveStorageFilePlacementPayload _self;
  final $Res Function(MoveStorageFilePlacementPayload) _then;

/// Create a copy of MoveStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetFolderId = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
targetFolderId: null == targetFolderId ? _self.targetFolderId : targetFolderId // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MoveStorageFilePlacementPayload].
extension MoveStorageFilePlacementPayloadPatterns on MoveStorageFilePlacementPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoveStorageFilePlacementPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoveStorageFilePlacementPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoveStorageFilePlacementPayload value)  $default,){
final _that = this;
switch (_that) {
case _MoveStorageFilePlacementPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoveStorageFilePlacementPayload value)?  $default,){
final _that = this;
switch (_that) {
case _MoveStorageFilePlacementPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String targetFolderId,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoveStorageFilePlacementPayload() when $default != null:
return $default(_that.targetFolderId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String targetFolderId,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _MoveStorageFilePlacementPayload():
return $default(_that.targetFolderId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String targetFolderId,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _MoveStorageFilePlacementPayload() when $default != null:
return $default(_that.targetFolderId,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoveStorageFilePlacementPayload implements MoveStorageFilePlacementPayload {
  const _MoveStorageFilePlacementPayload({required this.targetFolderId, required this.expectedVersion});
  factory _MoveStorageFilePlacementPayload.fromJson(Map<String, dynamic> json) => _$MoveStorageFilePlacementPayloadFromJson(json);

@override final  String targetFolderId;
@override final  int expectedVersion;

/// Create a copy of MoveStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoveStorageFilePlacementPayloadCopyWith<_MoveStorageFilePlacementPayload> get copyWith => __$MoveStorageFilePlacementPayloadCopyWithImpl<_MoveStorageFilePlacementPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoveStorageFilePlacementPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoveStorageFilePlacementPayload&&(identical(other.targetFolderId, targetFolderId) || other.targetFolderId == targetFolderId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetFolderId,expectedVersion);

@override
String toString() {
  return 'MoveStorageFilePlacementPayload(targetFolderId: $targetFolderId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$MoveStorageFilePlacementPayloadCopyWith<$Res> implements $MoveStorageFilePlacementPayloadCopyWith<$Res> {
  factory _$MoveStorageFilePlacementPayloadCopyWith(_MoveStorageFilePlacementPayload value, $Res Function(_MoveStorageFilePlacementPayload) _then) = __$MoveStorageFilePlacementPayloadCopyWithImpl;
@override @useResult
$Res call({
 String targetFolderId, int expectedVersion
});




}
/// @nodoc
class __$MoveStorageFilePlacementPayloadCopyWithImpl<$Res>
    implements _$MoveStorageFilePlacementPayloadCopyWith<$Res> {
  __$MoveStorageFilePlacementPayloadCopyWithImpl(this._self, this._then);

  final _MoveStorageFilePlacementPayload _self;
  final $Res Function(_MoveStorageFilePlacementPayload) _then;

/// Create a copy of MoveStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetFolderId = null,Object? expectedVersion = null,}) {
  return _then(_MoveStorageFilePlacementPayload(
targetFolderId: null == targetFolderId ? _self.targetFolderId : targetFolderId // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateStorageFilePlacementPayload {

 String get folderId; String? get displayName; String? get resourceType; String? get resourceId;
/// Create a copy of CreateStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateStorageFilePlacementPayloadCopyWith<CreateStorageFilePlacementPayload> get copyWith => _$CreateStorageFilePlacementPayloadCopyWithImpl<CreateStorageFilePlacementPayload>(this as CreateStorageFilePlacementPayload, _$identity);

  /// Serializes this CreateStorageFilePlacementPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateStorageFilePlacementPayload&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,folderId,displayName,resourceType,resourceId);

@override
String toString() {
  return 'CreateStorageFilePlacementPayload(folderId: $folderId, displayName: $displayName, resourceType: $resourceType, resourceId: $resourceId)';
}


}

/// @nodoc
abstract mixin class $CreateStorageFilePlacementPayloadCopyWith<$Res>  {
  factory $CreateStorageFilePlacementPayloadCopyWith(CreateStorageFilePlacementPayload value, $Res Function(CreateStorageFilePlacementPayload) _then) = _$CreateStorageFilePlacementPayloadCopyWithImpl;
@useResult
$Res call({
 String folderId, String? displayName, String? resourceType, String? resourceId
});




}
/// @nodoc
class _$CreateStorageFilePlacementPayloadCopyWithImpl<$Res>
    implements $CreateStorageFilePlacementPayloadCopyWith<$Res> {
  _$CreateStorageFilePlacementPayloadCopyWithImpl(this._self, this._then);

  final CreateStorageFilePlacementPayload _self;
  final $Res Function(CreateStorageFilePlacementPayload) _then;

/// Create a copy of CreateStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderId = null,Object? displayName = freezed,Object? resourceType = freezed,Object? resourceId = freezed,}) {
  return _then(_self.copyWith(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,resourceType: freezed == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String?,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateStorageFilePlacementPayload].
extension CreateStorageFilePlacementPayloadPatterns on CreateStorageFilePlacementPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateStorageFilePlacementPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateStorageFilePlacementPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateStorageFilePlacementPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateStorageFilePlacementPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateStorageFilePlacementPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateStorageFilePlacementPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String folderId,  String? displayName,  String? resourceType,  String? resourceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateStorageFilePlacementPayload() when $default != null:
return $default(_that.folderId,_that.displayName,_that.resourceType,_that.resourceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String folderId,  String? displayName,  String? resourceType,  String? resourceId)  $default,) {final _that = this;
switch (_that) {
case _CreateStorageFilePlacementPayload():
return $default(_that.folderId,_that.displayName,_that.resourceType,_that.resourceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String folderId,  String? displayName,  String? resourceType,  String? resourceId)?  $default,) {final _that = this;
switch (_that) {
case _CreateStorageFilePlacementPayload() when $default != null:
return $default(_that.folderId,_that.displayName,_that.resourceType,_that.resourceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateStorageFilePlacementPayload implements CreateStorageFilePlacementPayload {
  const _CreateStorageFilePlacementPayload({required this.folderId, this.displayName, this.resourceType, this.resourceId});
  factory _CreateStorageFilePlacementPayload.fromJson(Map<String, dynamic> json) => _$CreateStorageFilePlacementPayloadFromJson(json);

@override final  String folderId;
@override final  String? displayName;
@override final  String? resourceType;
@override final  String? resourceId;

/// Create a copy of CreateStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateStorageFilePlacementPayloadCopyWith<_CreateStorageFilePlacementPayload> get copyWith => __$CreateStorageFilePlacementPayloadCopyWithImpl<_CreateStorageFilePlacementPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateStorageFilePlacementPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateStorageFilePlacementPayload&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,folderId,displayName,resourceType,resourceId);

@override
String toString() {
  return 'CreateStorageFilePlacementPayload(folderId: $folderId, displayName: $displayName, resourceType: $resourceType, resourceId: $resourceId)';
}


}

/// @nodoc
abstract mixin class _$CreateStorageFilePlacementPayloadCopyWith<$Res> implements $CreateStorageFilePlacementPayloadCopyWith<$Res> {
  factory _$CreateStorageFilePlacementPayloadCopyWith(_CreateStorageFilePlacementPayload value, $Res Function(_CreateStorageFilePlacementPayload) _then) = __$CreateStorageFilePlacementPayloadCopyWithImpl;
@override @useResult
$Res call({
 String folderId, String? displayName, String? resourceType, String? resourceId
});




}
/// @nodoc
class __$CreateStorageFilePlacementPayloadCopyWithImpl<$Res>
    implements _$CreateStorageFilePlacementPayloadCopyWith<$Res> {
  __$CreateStorageFilePlacementPayloadCopyWithImpl(this._self, this._then);

  final _CreateStorageFilePlacementPayload _self;
  final $Res Function(_CreateStorageFilePlacementPayload) _then;

/// Create a copy of CreateStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderId = null,Object? displayName = freezed,Object? resourceType = freezed,Object? resourceId = freezed,}) {
  return _then(_CreateStorageFilePlacementPayload(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,resourceType: freezed == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String?,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BulkCreateStorageFilePlacementPayload {

 List<String> get fileIds; String? get displayNamePrefix;
/// Create a copy of BulkCreateStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkCreateStorageFilePlacementPayloadCopyWith<BulkCreateStorageFilePlacementPayload> get copyWith => _$BulkCreateStorageFilePlacementPayloadCopyWithImpl<BulkCreateStorageFilePlacementPayload>(this as BulkCreateStorageFilePlacementPayload, _$identity);

  /// Serializes this BulkCreateStorageFilePlacementPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkCreateStorageFilePlacementPayload&&const DeepCollectionEquality().equals(other.fileIds, fileIds)&&(identical(other.displayNamePrefix, displayNamePrefix) || other.displayNamePrefix == displayNamePrefix));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(fileIds),displayNamePrefix);

@override
String toString() {
  return 'BulkCreateStorageFilePlacementPayload(fileIds: $fileIds, displayNamePrefix: $displayNamePrefix)';
}


}

/// @nodoc
abstract mixin class $BulkCreateStorageFilePlacementPayloadCopyWith<$Res>  {
  factory $BulkCreateStorageFilePlacementPayloadCopyWith(BulkCreateStorageFilePlacementPayload value, $Res Function(BulkCreateStorageFilePlacementPayload) _then) = _$BulkCreateStorageFilePlacementPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> fileIds, String? displayNamePrefix
});




}
/// @nodoc
class _$BulkCreateStorageFilePlacementPayloadCopyWithImpl<$Res>
    implements $BulkCreateStorageFilePlacementPayloadCopyWith<$Res> {
  _$BulkCreateStorageFilePlacementPayloadCopyWithImpl(this._self, this._then);

  final BulkCreateStorageFilePlacementPayload _self;
  final $Res Function(BulkCreateStorageFilePlacementPayload) _then;

/// Create a copy of BulkCreateStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileIds = null,Object? displayNamePrefix = freezed,}) {
  return _then(_self.copyWith(
fileIds: null == fileIds ? _self.fileIds : fileIds // ignore: cast_nullable_to_non_nullable
as List<String>,displayNamePrefix: freezed == displayNamePrefix ? _self.displayNamePrefix : displayNamePrefix // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkCreateStorageFilePlacementPayload].
extension BulkCreateStorageFilePlacementPayloadPatterns on BulkCreateStorageFilePlacementPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkCreateStorageFilePlacementPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkCreateStorageFilePlacementPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkCreateStorageFilePlacementPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkCreateStorageFilePlacementPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkCreateStorageFilePlacementPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkCreateStorageFilePlacementPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> fileIds,  String? displayNamePrefix)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkCreateStorageFilePlacementPayload() when $default != null:
return $default(_that.fileIds,_that.displayNamePrefix);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> fileIds,  String? displayNamePrefix)  $default,) {final _that = this;
switch (_that) {
case _BulkCreateStorageFilePlacementPayload():
return $default(_that.fileIds,_that.displayNamePrefix);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> fileIds,  String? displayNamePrefix)?  $default,) {final _that = this;
switch (_that) {
case _BulkCreateStorageFilePlacementPayload() when $default != null:
return $default(_that.fileIds,_that.displayNamePrefix);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkCreateStorageFilePlacementPayload implements BulkCreateStorageFilePlacementPayload {
  const _BulkCreateStorageFilePlacementPayload({required this.fileIds, this.displayNamePrefix});
  factory _BulkCreateStorageFilePlacementPayload.fromJson(Map<String, dynamic> json) => _$BulkCreateStorageFilePlacementPayloadFromJson(json);

@override final  List<String> fileIds;
@override final  String? displayNamePrefix;

/// Create a copy of BulkCreateStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkCreateStorageFilePlacementPayloadCopyWith<_BulkCreateStorageFilePlacementPayload> get copyWith => __$BulkCreateStorageFilePlacementPayloadCopyWithImpl<_BulkCreateStorageFilePlacementPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkCreateStorageFilePlacementPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkCreateStorageFilePlacementPayload&&const DeepCollectionEquality().equals(other.fileIds, fileIds)&&(identical(other.displayNamePrefix, displayNamePrefix) || other.displayNamePrefix == displayNamePrefix));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(fileIds),displayNamePrefix);

@override
String toString() {
  return 'BulkCreateStorageFilePlacementPayload(fileIds: $fileIds, displayNamePrefix: $displayNamePrefix)';
}


}

/// @nodoc
abstract mixin class _$BulkCreateStorageFilePlacementPayloadCopyWith<$Res> implements $BulkCreateStorageFilePlacementPayloadCopyWith<$Res> {
  factory _$BulkCreateStorageFilePlacementPayloadCopyWith(_BulkCreateStorageFilePlacementPayload value, $Res Function(_BulkCreateStorageFilePlacementPayload) _then) = __$BulkCreateStorageFilePlacementPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> fileIds, String? displayNamePrefix
});




}
/// @nodoc
class __$BulkCreateStorageFilePlacementPayloadCopyWithImpl<$Res>
    implements _$BulkCreateStorageFilePlacementPayloadCopyWith<$Res> {
  __$BulkCreateStorageFilePlacementPayloadCopyWithImpl(this._self, this._then);

  final _BulkCreateStorageFilePlacementPayload _self;
  final $Res Function(_BulkCreateStorageFilePlacementPayload) _then;

/// Create a copy of BulkCreateStorageFilePlacementPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileIds = null,Object? displayNamePrefix = freezed,}) {
  return _then(_BulkCreateStorageFilePlacementPayload(
fileIds: null == fileIds ? _self.fileIds : fileIds // ignore: cast_nullable_to_non_nullable
as List<String>,displayNamePrefix: freezed == displayNamePrefix ? _self.displayNamePrefix : displayNamePrefix // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StorageFolderChildrenResponse {

 StorageFolderResponse get folder; List<StorageFolderResponse> get folders; List<StorageFilePlacementResponse> get placements;
/// Create a copy of StorageFolderChildrenResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFolderChildrenResponseCopyWith<StorageFolderChildrenResponse> get copyWith => _$StorageFolderChildrenResponseCopyWithImpl<StorageFolderChildrenResponse>(this as StorageFolderChildrenResponse, _$identity);

  /// Serializes this StorageFolderChildrenResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFolderChildrenResponse&&(identical(other.folder, folder) || other.folder == folder)&&const DeepCollectionEquality().equals(other.folders, folders)&&const DeepCollectionEquality().equals(other.placements, placements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,folder,const DeepCollectionEquality().hash(folders),const DeepCollectionEquality().hash(placements));

@override
String toString() {
  return 'StorageFolderChildrenResponse(folder: $folder, folders: $folders, placements: $placements)';
}


}

/// @nodoc
abstract mixin class $StorageFolderChildrenResponseCopyWith<$Res>  {
  factory $StorageFolderChildrenResponseCopyWith(StorageFolderChildrenResponse value, $Res Function(StorageFolderChildrenResponse) _then) = _$StorageFolderChildrenResponseCopyWithImpl;
@useResult
$Res call({
 StorageFolderResponse folder, List<StorageFolderResponse> folders, List<StorageFilePlacementResponse> placements
});


$StorageFolderResponseCopyWith<$Res> get folder;

}
/// @nodoc
class _$StorageFolderChildrenResponseCopyWithImpl<$Res>
    implements $StorageFolderChildrenResponseCopyWith<$Res> {
  _$StorageFolderChildrenResponseCopyWithImpl(this._self, this._then);

  final StorageFolderChildrenResponse _self;
  final $Res Function(StorageFolderChildrenResponse) _then;

/// Create a copy of StorageFolderChildrenResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folder = null,Object? folders = null,Object? placements = null,}) {
  return _then(_self.copyWith(
folder: null == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as StorageFolderResponse,folders: null == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<StorageFolderResponse>,placements: null == placements ? _self.placements : placements // ignore: cast_nullable_to_non_nullable
as List<StorageFilePlacementResponse>,
  ));
}
/// Create a copy of StorageFolderChildrenResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFolderResponseCopyWith<$Res> get folder {
  
  return $StorageFolderResponseCopyWith<$Res>(_self.folder, (value) {
    return _then(_self.copyWith(folder: value));
  });
}
}


/// Adds pattern-matching-related methods to [StorageFolderChildrenResponse].
extension StorageFolderChildrenResponsePatterns on StorageFolderChildrenResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFolderChildrenResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFolderChildrenResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFolderChildrenResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFolderChildrenResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFolderChildrenResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFolderChildrenResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StorageFolderResponse folder,  List<StorageFolderResponse> folders,  List<StorageFilePlacementResponse> placements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFolderChildrenResponse() when $default != null:
return $default(_that.folder,_that.folders,_that.placements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StorageFolderResponse folder,  List<StorageFolderResponse> folders,  List<StorageFilePlacementResponse> placements)  $default,) {final _that = this;
switch (_that) {
case _StorageFolderChildrenResponse():
return $default(_that.folder,_that.folders,_that.placements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StorageFolderResponse folder,  List<StorageFolderResponse> folders,  List<StorageFilePlacementResponse> placements)?  $default,) {final _that = this;
switch (_that) {
case _StorageFolderChildrenResponse() when $default != null:
return $default(_that.folder,_that.folders,_that.placements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFolderChildrenResponse implements StorageFolderChildrenResponse {
  const _StorageFolderChildrenResponse({required this.folder, required this.folders, required this.placements});
  factory _StorageFolderChildrenResponse.fromJson(Map<String, dynamic> json) => _$StorageFolderChildrenResponseFromJson(json);

@override final  StorageFolderResponse folder;
@override final  List<StorageFolderResponse> folders;
@override final  List<StorageFilePlacementResponse> placements;

/// Create a copy of StorageFolderChildrenResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFolderChildrenResponseCopyWith<_StorageFolderChildrenResponse> get copyWith => __$StorageFolderChildrenResponseCopyWithImpl<_StorageFolderChildrenResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFolderChildrenResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFolderChildrenResponse&&(identical(other.folder, folder) || other.folder == folder)&&const DeepCollectionEquality().equals(other.folders, folders)&&const DeepCollectionEquality().equals(other.placements, placements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,folder,const DeepCollectionEquality().hash(folders),const DeepCollectionEquality().hash(placements));

@override
String toString() {
  return 'StorageFolderChildrenResponse(folder: $folder, folders: $folders, placements: $placements)';
}


}

/// @nodoc
abstract mixin class _$StorageFolderChildrenResponseCopyWith<$Res> implements $StorageFolderChildrenResponseCopyWith<$Res> {
  factory _$StorageFolderChildrenResponseCopyWith(_StorageFolderChildrenResponse value, $Res Function(_StorageFolderChildrenResponse) _then) = __$StorageFolderChildrenResponseCopyWithImpl;
@override @useResult
$Res call({
 StorageFolderResponse folder, List<StorageFolderResponse> folders, List<StorageFilePlacementResponse> placements
});


@override $StorageFolderResponseCopyWith<$Res> get folder;

}
/// @nodoc
class __$StorageFolderChildrenResponseCopyWithImpl<$Res>
    implements _$StorageFolderChildrenResponseCopyWith<$Res> {
  __$StorageFolderChildrenResponseCopyWithImpl(this._self, this._then);

  final _StorageFolderChildrenResponse _self;
  final $Res Function(_StorageFolderChildrenResponse) _then;

/// Create a copy of StorageFolderChildrenResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folder = null,Object? folders = null,Object? placements = null,}) {
  return _then(_StorageFolderChildrenResponse(
folder: null == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as StorageFolderResponse,folders: null == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<StorageFolderResponse>,placements: null == placements ? _self.placements : placements // ignore: cast_nullable_to_non_nullable
as List<StorageFilePlacementResponse>,
  ));
}

/// Create a copy of StorageFolderChildrenResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFolderResponseCopyWith<$Res> get folder {
  
  return $StorageFolderResponseCopyWith<$Res>(_self.folder, (value) {
    return _then(_self.copyWith(folder: value));
  });
}
}


/// @nodoc
mixin _$StorageFileUserStateResponse {

 String get fileId; bool get isFavorite; DateTime? get favoritedAtUtc; DateTime? get lastAccessedAtUtc;
/// Create a copy of StorageFileUserStateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFileUserStateResponseCopyWith<StorageFileUserStateResponse> get copyWith => _$StorageFileUserStateResponseCopyWithImpl<StorageFileUserStateResponse>(this as StorageFileUserStateResponse, _$identity);

  /// Serializes this StorageFileUserStateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFileUserStateResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.favoritedAtUtc, favoritedAtUtc) || other.favoritedAtUtc == favoritedAtUtc)&&(identical(other.lastAccessedAtUtc, lastAccessedAtUtc) || other.lastAccessedAtUtc == lastAccessedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,isFavorite,favoritedAtUtc,lastAccessedAtUtc);

@override
String toString() {
  return 'StorageFileUserStateResponse(fileId: $fileId, isFavorite: $isFavorite, favoritedAtUtc: $favoritedAtUtc, lastAccessedAtUtc: $lastAccessedAtUtc)';
}


}

/// @nodoc
abstract mixin class $StorageFileUserStateResponseCopyWith<$Res>  {
  factory $StorageFileUserStateResponseCopyWith(StorageFileUserStateResponse value, $Res Function(StorageFileUserStateResponse) _then) = _$StorageFileUserStateResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, bool isFavorite, DateTime? favoritedAtUtc, DateTime? lastAccessedAtUtc
});




}
/// @nodoc
class _$StorageFileUserStateResponseCopyWithImpl<$Res>
    implements $StorageFileUserStateResponseCopyWith<$Res> {
  _$StorageFileUserStateResponseCopyWithImpl(this._self, this._then);

  final StorageFileUserStateResponse _self;
  final $Res Function(StorageFileUserStateResponse) _then;

/// Create a copy of StorageFileUserStateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? isFavorite = null,Object? favoritedAtUtc = freezed,Object? lastAccessedAtUtc = freezed,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,favoritedAtUtc: freezed == favoritedAtUtc ? _self.favoritedAtUtc : favoritedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAccessedAtUtc: freezed == lastAccessedAtUtc ? _self.lastAccessedAtUtc : lastAccessedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageFileUserStateResponse].
extension StorageFileUserStateResponsePatterns on StorageFileUserStateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFileUserStateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFileUserStateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFileUserStateResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFileUserStateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFileUserStateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFileUserStateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  bool isFavorite,  DateTime? favoritedAtUtc,  DateTime? lastAccessedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFileUserStateResponse() when $default != null:
return $default(_that.fileId,_that.isFavorite,_that.favoritedAtUtc,_that.lastAccessedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  bool isFavorite,  DateTime? favoritedAtUtc,  DateTime? lastAccessedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _StorageFileUserStateResponse():
return $default(_that.fileId,_that.isFavorite,_that.favoritedAtUtc,_that.lastAccessedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  bool isFavorite,  DateTime? favoritedAtUtc,  DateTime? lastAccessedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _StorageFileUserStateResponse() when $default != null:
return $default(_that.fileId,_that.isFavorite,_that.favoritedAtUtc,_that.lastAccessedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFileUserStateResponse implements StorageFileUserStateResponse {
  const _StorageFileUserStateResponse({required this.fileId, required this.isFavorite, this.favoritedAtUtc, this.lastAccessedAtUtc});
  factory _StorageFileUserStateResponse.fromJson(Map<String, dynamic> json) => _$StorageFileUserStateResponseFromJson(json);

@override final  String fileId;
@override final  bool isFavorite;
@override final  DateTime? favoritedAtUtc;
@override final  DateTime? lastAccessedAtUtc;

/// Create a copy of StorageFileUserStateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFileUserStateResponseCopyWith<_StorageFileUserStateResponse> get copyWith => __$StorageFileUserStateResponseCopyWithImpl<_StorageFileUserStateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFileUserStateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFileUserStateResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.favoritedAtUtc, favoritedAtUtc) || other.favoritedAtUtc == favoritedAtUtc)&&(identical(other.lastAccessedAtUtc, lastAccessedAtUtc) || other.lastAccessedAtUtc == lastAccessedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,isFavorite,favoritedAtUtc,lastAccessedAtUtc);

@override
String toString() {
  return 'StorageFileUserStateResponse(fileId: $fileId, isFavorite: $isFavorite, favoritedAtUtc: $favoritedAtUtc, lastAccessedAtUtc: $lastAccessedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$StorageFileUserStateResponseCopyWith<$Res> implements $StorageFileUserStateResponseCopyWith<$Res> {
  factory _$StorageFileUserStateResponseCopyWith(_StorageFileUserStateResponse value, $Res Function(_StorageFileUserStateResponse) _then) = __$StorageFileUserStateResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, bool isFavorite, DateTime? favoritedAtUtc, DateTime? lastAccessedAtUtc
});




}
/// @nodoc
class __$StorageFileUserStateResponseCopyWithImpl<$Res>
    implements _$StorageFileUserStateResponseCopyWith<$Res> {
  __$StorageFileUserStateResponseCopyWithImpl(this._self, this._then);

  final _StorageFileUserStateResponse _self;
  final $Res Function(_StorageFileUserStateResponse) _then;

/// Create a copy of StorageFileUserStateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? isFavorite = null,Object? favoritedAtUtc = freezed,Object? lastAccessedAtUtc = freezed,}) {
  return _then(_StorageFileUserStateResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,favoritedAtUtc: freezed == favoritedAtUtc ? _self.favoritedAtUtc : favoritedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAccessedAtUtc: freezed == lastAccessedAtUtc ? _self.lastAccessedAtUtc : lastAccessedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SetStorageFileFavoritePayload {

 bool get isFavorite;
/// Create a copy of SetStorageFileFavoritePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetStorageFileFavoritePayloadCopyWith<SetStorageFileFavoritePayload> get copyWith => _$SetStorageFileFavoritePayloadCopyWithImpl<SetStorageFileFavoritePayload>(this as SetStorageFileFavoritePayload, _$identity);

  /// Serializes this SetStorageFileFavoritePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetStorageFileFavoritePayload&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFavorite);

@override
String toString() {
  return 'SetStorageFileFavoritePayload(isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $SetStorageFileFavoritePayloadCopyWith<$Res>  {
  factory $SetStorageFileFavoritePayloadCopyWith(SetStorageFileFavoritePayload value, $Res Function(SetStorageFileFavoritePayload) _then) = _$SetStorageFileFavoritePayloadCopyWithImpl;
@useResult
$Res call({
 bool isFavorite
});




}
/// @nodoc
class _$SetStorageFileFavoritePayloadCopyWithImpl<$Res>
    implements $SetStorageFileFavoritePayloadCopyWith<$Res> {
  _$SetStorageFileFavoritePayloadCopyWithImpl(this._self, this._then);

  final SetStorageFileFavoritePayload _self;
  final $Res Function(SetStorageFileFavoritePayload) _then;

/// Create a copy of SetStorageFileFavoritePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isFavorite = null,}) {
  return _then(_self.copyWith(
isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SetStorageFileFavoritePayload].
extension SetStorageFileFavoritePayloadPatterns on SetStorageFileFavoritePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetStorageFileFavoritePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetStorageFileFavoritePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetStorageFileFavoritePayload value)  $default,){
final _that = this;
switch (_that) {
case _SetStorageFileFavoritePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetStorageFileFavoritePayload value)?  $default,){
final _that = this;
switch (_that) {
case _SetStorageFileFavoritePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetStorageFileFavoritePayload() when $default != null:
return $default(_that.isFavorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _SetStorageFileFavoritePayload():
return $default(_that.isFavorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _SetStorageFileFavoritePayload() when $default != null:
return $default(_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetStorageFileFavoritePayload implements SetStorageFileFavoritePayload {
  const _SetStorageFileFavoritePayload({required this.isFavorite});
  factory _SetStorageFileFavoritePayload.fromJson(Map<String, dynamic> json) => _$SetStorageFileFavoritePayloadFromJson(json);

@override final  bool isFavorite;

/// Create a copy of SetStorageFileFavoritePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetStorageFileFavoritePayloadCopyWith<_SetStorageFileFavoritePayload> get copyWith => __$SetStorageFileFavoritePayloadCopyWithImpl<_SetStorageFileFavoritePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetStorageFileFavoritePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetStorageFileFavoritePayload&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFavorite);

@override
String toString() {
  return 'SetStorageFileFavoritePayload(isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$SetStorageFileFavoritePayloadCopyWith<$Res> implements $SetStorageFileFavoritePayloadCopyWith<$Res> {
  factory _$SetStorageFileFavoritePayloadCopyWith(_SetStorageFileFavoritePayload value, $Res Function(_SetStorageFileFavoritePayload) _then) = __$SetStorageFileFavoritePayloadCopyWithImpl;
@override @useResult
$Res call({
 bool isFavorite
});




}
/// @nodoc
class __$SetStorageFileFavoritePayloadCopyWithImpl<$Res>
    implements _$SetStorageFileFavoritePayloadCopyWith<$Res> {
  __$SetStorageFileFavoritePayloadCopyWithImpl(this._self, this._then);

  final _SetStorageFileFavoritePayload _self;
  final $Res Function(_SetStorageFileFavoritePayload) _then;

/// Create a copy of SetStorageFileFavoritePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isFavorite = null,}) {
  return _then(_SetStorageFileFavoritePayload(
isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StorageFileDeepLinkResponse {

 String get fileId; String? get workspaceId; String? get projectId; String get filePath; String get conversationPath;
/// Create a copy of StorageFileDeepLinkResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFileDeepLinkResponseCopyWith<StorageFileDeepLinkResponse> get copyWith => _$StorageFileDeepLinkResponseCopyWithImpl<StorageFileDeepLinkResponse>(this as StorageFileDeepLinkResponse, _$identity);

  /// Serializes this StorageFileDeepLinkResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFileDeepLinkResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.conversationPath, conversationPath) || other.conversationPath == conversationPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,workspaceId,projectId,filePath,conversationPath);

@override
String toString() {
  return 'StorageFileDeepLinkResponse(fileId: $fileId, workspaceId: $workspaceId, projectId: $projectId, filePath: $filePath, conversationPath: $conversationPath)';
}


}

/// @nodoc
abstract mixin class $StorageFileDeepLinkResponseCopyWith<$Res>  {
  factory $StorageFileDeepLinkResponseCopyWith(StorageFileDeepLinkResponse value, $Res Function(StorageFileDeepLinkResponse) _then) = _$StorageFileDeepLinkResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, String? workspaceId, String? projectId, String filePath, String conversationPath
});




}
/// @nodoc
class _$StorageFileDeepLinkResponseCopyWithImpl<$Res>
    implements $StorageFileDeepLinkResponseCopyWith<$Res> {
  _$StorageFileDeepLinkResponseCopyWithImpl(this._self, this._then);

  final StorageFileDeepLinkResponse _self;
  final $Res Function(StorageFileDeepLinkResponse) _then;

/// Create a copy of StorageFileDeepLinkResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? filePath = null,Object? conversationPath = null,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,conversationPath: null == conversationPath ? _self.conversationPath : conversationPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageFileDeepLinkResponse].
extension StorageFileDeepLinkResponsePatterns on StorageFileDeepLinkResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFileDeepLinkResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFileDeepLinkResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFileDeepLinkResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFileDeepLinkResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFileDeepLinkResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFileDeepLinkResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  String? workspaceId,  String? projectId,  String filePath,  String conversationPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFileDeepLinkResponse() when $default != null:
return $default(_that.fileId,_that.workspaceId,_that.projectId,_that.filePath,_that.conversationPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  String? workspaceId,  String? projectId,  String filePath,  String conversationPath)  $default,) {final _that = this;
switch (_that) {
case _StorageFileDeepLinkResponse():
return $default(_that.fileId,_that.workspaceId,_that.projectId,_that.filePath,_that.conversationPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  String? workspaceId,  String? projectId,  String filePath,  String conversationPath)?  $default,) {final _that = this;
switch (_that) {
case _StorageFileDeepLinkResponse() when $default != null:
return $default(_that.fileId,_that.workspaceId,_that.projectId,_that.filePath,_that.conversationPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFileDeepLinkResponse implements StorageFileDeepLinkResponse {
  const _StorageFileDeepLinkResponse({required this.fileId, this.workspaceId, this.projectId, required this.filePath, required this.conversationPath});
  factory _StorageFileDeepLinkResponse.fromJson(Map<String, dynamic> json) => _$StorageFileDeepLinkResponseFromJson(json);

@override final  String fileId;
@override final  String? workspaceId;
@override final  String? projectId;
@override final  String filePath;
@override final  String conversationPath;

/// Create a copy of StorageFileDeepLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFileDeepLinkResponseCopyWith<_StorageFileDeepLinkResponse> get copyWith => __$StorageFileDeepLinkResponseCopyWithImpl<_StorageFileDeepLinkResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFileDeepLinkResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFileDeepLinkResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.conversationPath, conversationPath) || other.conversationPath == conversationPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,workspaceId,projectId,filePath,conversationPath);

@override
String toString() {
  return 'StorageFileDeepLinkResponse(fileId: $fileId, workspaceId: $workspaceId, projectId: $projectId, filePath: $filePath, conversationPath: $conversationPath)';
}


}

/// @nodoc
abstract mixin class _$StorageFileDeepLinkResponseCopyWith<$Res> implements $StorageFileDeepLinkResponseCopyWith<$Res> {
  factory _$StorageFileDeepLinkResponseCopyWith(_StorageFileDeepLinkResponse value, $Res Function(_StorageFileDeepLinkResponse) _then) = __$StorageFileDeepLinkResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, String? workspaceId, String? projectId, String filePath, String conversationPath
});




}
/// @nodoc
class __$StorageFileDeepLinkResponseCopyWithImpl<$Res>
    implements _$StorageFileDeepLinkResponseCopyWith<$Res> {
  __$StorageFileDeepLinkResponseCopyWithImpl(this._self, this._then);

  final _StorageFileDeepLinkResponse _self;
  final $Res Function(_StorageFileDeepLinkResponse) _then;

/// Create a copy of StorageFileDeepLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? filePath = null,Object? conversationPath = null,}) {
  return _then(_StorageFileDeepLinkResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,conversationPath: null == conversationPath ? _self.conversationPath : conversationPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OnlyOfficeSessionResponse {

 String get fileId; String get documentType; String get documentServerUrl; String get documentKey; String get token; bool get canEdit;
/// Create a copy of OnlyOfficeSessionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlyOfficeSessionResponseCopyWith<OnlyOfficeSessionResponse> get copyWith => _$OnlyOfficeSessionResponseCopyWithImpl<OnlyOfficeSessionResponse>(this as OnlyOfficeSessionResponse, _$identity);

  /// Serializes this OnlyOfficeSessionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnlyOfficeSessionResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.documentServerUrl, documentServerUrl) || other.documentServerUrl == documentServerUrl)&&(identical(other.documentKey, documentKey) || other.documentKey == documentKey)&&(identical(other.token, token) || other.token == token)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,documentType,documentServerUrl,documentKey,token,canEdit);

@override
String toString() {
  return 'OnlyOfficeSessionResponse(fileId: $fileId, documentType: $documentType, documentServerUrl: $documentServerUrl, documentKey: $documentKey, token: $token, canEdit: $canEdit)';
}


}

/// @nodoc
abstract mixin class $OnlyOfficeSessionResponseCopyWith<$Res>  {
  factory $OnlyOfficeSessionResponseCopyWith(OnlyOfficeSessionResponse value, $Res Function(OnlyOfficeSessionResponse) _then) = _$OnlyOfficeSessionResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, String documentType, String documentServerUrl, String documentKey, String token, bool canEdit
});




}
/// @nodoc
class _$OnlyOfficeSessionResponseCopyWithImpl<$Res>
    implements $OnlyOfficeSessionResponseCopyWith<$Res> {
  _$OnlyOfficeSessionResponseCopyWithImpl(this._self, this._then);

  final OnlyOfficeSessionResponse _self;
  final $Res Function(OnlyOfficeSessionResponse) _then;

/// Create a copy of OnlyOfficeSessionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? documentType = null,Object? documentServerUrl = null,Object? documentKey = null,Object? token = null,Object? canEdit = null,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,documentServerUrl: null == documentServerUrl ? _self.documentServerUrl : documentServerUrl // ignore: cast_nullable_to_non_nullable
as String,documentKey: null == documentKey ? _self.documentKey : documentKey // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OnlyOfficeSessionResponse].
extension OnlyOfficeSessionResponsePatterns on OnlyOfficeSessionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnlyOfficeSessionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnlyOfficeSessionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnlyOfficeSessionResponse value)  $default,){
final _that = this;
switch (_that) {
case _OnlyOfficeSessionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnlyOfficeSessionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OnlyOfficeSessionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  String documentType,  String documentServerUrl,  String documentKey,  String token,  bool canEdit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnlyOfficeSessionResponse() when $default != null:
return $default(_that.fileId,_that.documentType,_that.documentServerUrl,_that.documentKey,_that.token,_that.canEdit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  String documentType,  String documentServerUrl,  String documentKey,  String token,  bool canEdit)  $default,) {final _that = this;
switch (_that) {
case _OnlyOfficeSessionResponse():
return $default(_that.fileId,_that.documentType,_that.documentServerUrl,_that.documentKey,_that.token,_that.canEdit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  String documentType,  String documentServerUrl,  String documentKey,  String token,  bool canEdit)?  $default,) {final _that = this;
switch (_that) {
case _OnlyOfficeSessionResponse() when $default != null:
return $default(_that.fileId,_that.documentType,_that.documentServerUrl,_that.documentKey,_that.token,_that.canEdit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnlyOfficeSessionResponse implements OnlyOfficeSessionResponse {
  const _OnlyOfficeSessionResponse({required this.fileId, required this.documentType, required this.documentServerUrl, required this.documentKey, required this.token, required this.canEdit});
  factory _OnlyOfficeSessionResponse.fromJson(Map<String, dynamic> json) => _$OnlyOfficeSessionResponseFromJson(json);

@override final  String fileId;
@override final  String documentType;
@override final  String documentServerUrl;
@override final  String documentKey;
@override final  String token;
@override final  bool canEdit;

/// Create a copy of OnlyOfficeSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnlyOfficeSessionResponseCopyWith<_OnlyOfficeSessionResponse> get copyWith => __$OnlyOfficeSessionResponseCopyWithImpl<_OnlyOfficeSessionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnlyOfficeSessionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnlyOfficeSessionResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.documentServerUrl, documentServerUrl) || other.documentServerUrl == documentServerUrl)&&(identical(other.documentKey, documentKey) || other.documentKey == documentKey)&&(identical(other.token, token) || other.token == token)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,documentType,documentServerUrl,documentKey,token,canEdit);

@override
String toString() {
  return 'OnlyOfficeSessionResponse(fileId: $fileId, documentType: $documentType, documentServerUrl: $documentServerUrl, documentKey: $documentKey, token: $token, canEdit: $canEdit)';
}


}

/// @nodoc
abstract mixin class _$OnlyOfficeSessionResponseCopyWith<$Res> implements $OnlyOfficeSessionResponseCopyWith<$Res> {
  factory _$OnlyOfficeSessionResponseCopyWith(_OnlyOfficeSessionResponse value, $Res Function(_OnlyOfficeSessionResponse) _then) = __$OnlyOfficeSessionResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, String documentType, String documentServerUrl, String documentKey, String token, bool canEdit
});




}
/// @nodoc
class __$OnlyOfficeSessionResponseCopyWithImpl<$Res>
    implements _$OnlyOfficeSessionResponseCopyWith<$Res> {
  __$OnlyOfficeSessionResponseCopyWithImpl(this._self, this._then);

  final _OnlyOfficeSessionResponse _self;
  final $Res Function(_OnlyOfficeSessionResponse) _then;

/// Create a copy of OnlyOfficeSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? documentType = null,Object? documentServerUrl = null,Object? documentKey = null,Object? token = null,Object? canEdit = null,}) {
  return _then(_OnlyOfficeSessionResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,documentServerUrl: null == documentServerUrl ? _self.documentServerUrl : documentServerUrl // ignore: cast_nullable_to_non_nullable
as String,documentKey: null == documentKey ? _self.documentKey : documentKey // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$OnlyOfficeCallbackPayload {

 String? get key; int get status; String? get url; List<String>? get users; List<Map<String, dynamic>>? get actions; Map<String, dynamic>? get history; String? get token;
/// Create a copy of OnlyOfficeCallbackPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlyOfficeCallbackPayloadCopyWith<OnlyOfficeCallbackPayload> get copyWith => _$OnlyOfficeCallbackPayloadCopyWithImpl<OnlyOfficeCallbackPayload>(this as OnlyOfficeCallbackPayload, _$identity);

  /// Serializes this OnlyOfficeCallbackPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnlyOfficeCallbackPayload&&(identical(other.key, key) || other.key == key)&&(identical(other.status, status) || other.status == status)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.users, users)&&const DeepCollectionEquality().equals(other.actions, actions)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,status,url,const DeepCollectionEquality().hash(users),const DeepCollectionEquality().hash(actions),const DeepCollectionEquality().hash(history),token);

@override
String toString() {
  return 'OnlyOfficeCallbackPayload(key: $key, status: $status, url: $url, users: $users, actions: $actions, history: $history, token: $token)';
}


}

/// @nodoc
abstract mixin class $OnlyOfficeCallbackPayloadCopyWith<$Res>  {
  factory $OnlyOfficeCallbackPayloadCopyWith(OnlyOfficeCallbackPayload value, $Res Function(OnlyOfficeCallbackPayload) _then) = _$OnlyOfficeCallbackPayloadCopyWithImpl;
@useResult
$Res call({
 String? key, int status, String? url, List<String>? users, List<Map<String, dynamic>>? actions, Map<String, dynamic>? history, String? token
});




}
/// @nodoc
class _$OnlyOfficeCallbackPayloadCopyWithImpl<$Res>
    implements $OnlyOfficeCallbackPayloadCopyWith<$Res> {
  _$OnlyOfficeCallbackPayloadCopyWithImpl(this._self, this._then);

  final OnlyOfficeCallbackPayload _self;
  final $Res Function(OnlyOfficeCallbackPayload) _then;

/// Create a copy of OnlyOfficeCallbackPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = freezed,Object? status = null,Object? url = freezed,Object? users = freezed,Object? actions = freezed,Object? history = freezed,Object? token = freezed,}) {
  return _then(_self.copyWith(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,users: freezed == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<String>?,actions: freezed == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,history: freezed == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnlyOfficeCallbackPayload].
extension OnlyOfficeCallbackPayloadPatterns on OnlyOfficeCallbackPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnlyOfficeCallbackPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnlyOfficeCallbackPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnlyOfficeCallbackPayload value)  $default,){
final _that = this;
switch (_that) {
case _OnlyOfficeCallbackPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnlyOfficeCallbackPayload value)?  $default,){
final _that = this;
switch (_that) {
case _OnlyOfficeCallbackPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? key,  int status,  String? url,  List<String>? users,  List<Map<String, dynamic>>? actions,  Map<String, dynamic>? history,  String? token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnlyOfficeCallbackPayload() when $default != null:
return $default(_that.key,_that.status,_that.url,_that.users,_that.actions,_that.history,_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? key,  int status,  String? url,  List<String>? users,  List<Map<String, dynamic>>? actions,  Map<String, dynamic>? history,  String? token)  $default,) {final _that = this;
switch (_that) {
case _OnlyOfficeCallbackPayload():
return $default(_that.key,_that.status,_that.url,_that.users,_that.actions,_that.history,_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? key,  int status,  String? url,  List<String>? users,  List<Map<String, dynamic>>? actions,  Map<String, dynamic>? history,  String? token)?  $default,) {final _that = this;
switch (_that) {
case _OnlyOfficeCallbackPayload() when $default != null:
return $default(_that.key,_that.status,_that.url,_that.users,_that.actions,_that.history,_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnlyOfficeCallbackPayload implements OnlyOfficeCallbackPayload {
  const _OnlyOfficeCallbackPayload({this.key, required this.status, this.url, this.users, this.actions, this.history, this.token});
  factory _OnlyOfficeCallbackPayload.fromJson(Map<String, dynamic> json) => _$OnlyOfficeCallbackPayloadFromJson(json);

@override final  String? key;
@override final  int status;
@override final  String? url;
@override final  List<String>? users;
@override final  List<Map<String, dynamic>>? actions;
@override final  Map<String, dynamic>? history;
@override final  String? token;

/// Create a copy of OnlyOfficeCallbackPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnlyOfficeCallbackPayloadCopyWith<_OnlyOfficeCallbackPayload> get copyWith => __$OnlyOfficeCallbackPayloadCopyWithImpl<_OnlyOfficeCallbackPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnlyOfficeCallbackPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnlyOfficeCallbackPayload&&(identical(other.key, key) || other.key == key)&&(identical(other.status, status) || other.status == status)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.users, users)&&const DeepCollectionEquality().equals(other.actions, actions)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,status,url,const DeepCollectionEquality().hash(users),const DeepCollectionEquality().hash(actions),const DeepCollectionEquality().hash(history),token);

@override
String toString() {
  return 'OnlyOfficeCallbackPayload(key: $key, status: $status, url: $url, users: $users, actions: $actions, history: $history, token: $token)';
}


}

/// @nodoc
abstract mixin class _$OnlyOfficeCallbackPayloadCopyWith<$Res> implements $OnlyOfficeCallbackPayloadCopyWith<$Res> {
  factory _$OnlyOfficeCallbackPayloadCopyWith(_OnlyOfficeCallbackPayload value, $Res Function(_OnlyOfficeCallbackPayload) _then) = __$OnlyOfficeCallbackPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? key, int status, String? url, List<String>? users, List<Map<String, dynamic>>? actions, Map<String, dynamic>? history, String? token
});




}
/// @nodoc
class __$OnlyOfficeCallbackPayloadCopyWithImpl<$Res>
    implements _$OnlyOfficeCallbackPayloadCopyWith<$Res> {
  __$OnlyOfficeCallbackPayloadCopyWithImpl(this._self, this._then);

  final _OnlyOfficeCallbackPayload _self;
  final $Res Function(_OnlyOfficeCallbackPayload) _then;

/// Create a copy of OnlyOfficeCallbackPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = freezed,Object? status = null,Object? url = freezed,Object? users = freezed,Object? actions = freezed,Object? history = freezed,Object? token = freezed,}) {
  return _then(_OnlyOfficeCallbackPayload(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,users: freezed == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<String>?,actions: freezed == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,history: freezed == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OnlyOfficeCallbackResponse {

 int get error;
/// Create a copy of OnlyOfficeCallbackResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlyOfficeCallbackResponseCopyWith<OnlyOfficeCallbackResponse> get copyWith => _$OnlyOfficeCallbackResponseCopyWithImpl<OnlyOfficeCallbackResponse>(this as OnlyOfficeCallbackResponse, _$identity);

  /// Serializes this OnlyOfficeCallbackResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnlyOfficeCallbackResponse&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'OnlyOfficeCallbackResponse(error: $error)';
}


}

/// @nodoc
abstract mixin class $OnlyOfficeCallbackResponseCopyWith<$Res>  {
  factory $OnlyOfficeCallbackResponseCopyWith(OnlyOfficeCallbackResponse value, $Res Function(OnlyOfficeCallbackResponse) _then) = _$OnlyOfficeCallbackResponseCopyWithImpl;
@useResult
$Res call({
 int error
});




}
/// @nodoc
class _$OnlyOfficeCallbackResponseCopyWithImpl<$Res>
    implements $OnlyOfficeCallbackResponseCopyWith<$Res> {
  _$OnlyOfficeCallbackResponseCopyWithImpl(this._self, this._then);

  final OnlyOfficeCallbackResponse _self;
  final $Res Function(OnlyOfficeCallbackResponse) _then;

/// Create a copy of OnlyOfficeCallbackResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? error = null,}) {
  return _then(_self.copyWith(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OnlyOfficeCallbackResponse].
extension OnlyOfficeCallbackResponsePatterns on OnlyOfficeCallbackResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnlyOfficeCallbackResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnlyOfficeCallbackResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnlyOfficeCallbackResponse value)  $default,){
final _that = this;
switch (_that) {
case _OnlyOfficeCallbackResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnlyOfficeCallbackResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OnlyOfficeCallbackResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnlyOfficeCallbackResponse() when $default != null:
return $default(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int error)  $default,) {final _that = this;
switch (_that) {
case _OnlyOfficeCallbackResponse():
return $default(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int error)?  $default,) {final _that = this;
switch (_that) {
case _OnlyOfficeCallbackResponse() when $default != null:
return $default(_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnlyOfficeCallbackResponse implements OnlyOfficeCallbackResponse {
  const _OnlyOfficeCallbackResponse({required this.error});
  factory _OnlyOfficeCallbackResponse.fromJson(Map<String, dynamic> json) => _$OnlyOfficeCallbackResponseFromJson(json);

@override final  int error;

/// Create a copy of OnlyOfficeCallbackResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnlyOfficeCallbackResponseCopyWith<_OnlyOfficeCallbackResponse> get copyWith => __$OnlyOfficeCallbackResponseCopyWithImpl<_OnlyOfficeCallbackResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnlyOfficeCallbackResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnlyOfficeCallbackResponse&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'OnlyOfficeCallbackResponse(error: $error)';
}


}

/// @nodoc
abstract mixin class _$OnlyOfficeCallbackResponseCopyWith<$Res> implements $OnlyOfficeCallbackResponseCopyWith<$Res> {
  factory _$OnlyOfficeCallbackResponseCopyWith(_OnlyOfficeCallbackResponse value, $Res Function(_OnlyOfficeCallbackResponse) _then) = __$OnlyOfficeCallbackResponseCopyWithImpl;
@override @useResult
$Res call({
 int error
});




}
/// @nodoc
class __$OnlyOfficeCallbackResponseCopyWithImpl<$Res>
    implements _$OnlyOfficeCallbackResponseCopyWith<$Res> {
  __$OnlyOfficeCallbackResponseCopyWithImpl(this._self, this._then);

  final _OnlyOfficeCallbackResponse _self;
  final $Res Function(_OnlyOfficeCallbackResponse) _then;

/// Create a copy of OnlyOfficeCallbackResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_OnlyOfficeCallbackResponse(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BulkDownloadZipPayload {

 List<String> get fileIds; String? get zipFileName;
/// Create a copy of BulkDownloadZipPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkDownloadZipPayloadCopyWith<BulkDownloadZipPayload> get copyWith => _$BulkDownloadZipPayloadCopyWithImpl<BulkDownloadZipPayload>(this as BulkDownloadZipPayload, _$identity);

  /// Serializes this BulkDownloadZipPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkDownloadZipPayload&&const DeepCollectionEquality().equals(other.fileIds, fileIds)&&(identical(other.zipFileName, zipFileName) || other.zipFileName == zipFileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(fileIds),zipFileName);

@override
String toString() {
  return 'BulkDownloadZipPayload(fileIds: $fileIds, zipFileName: $zipFileName)';
}


}

/// @nodoc
abstract mixin class $BulkDownloadZipPayloadCopyWith<$Res>  {
  factory $BulkDownloadZipPayloadCopyWith(BulkDownloadZipPayload value, $Res Function(BulkDownloadZipPayload) _then) = _$BulkDownloadZipPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> fileIds, String? zipFileName
});




}
/// @nodoc
class _$BulkDownloadZipPayloadCopyWithImpl<$Res>
    implements $BulkDownloadZipPayloadCopyWith<$Res> {
  _$BulkDownloadZipPayloadCopyWithImpl(this._self, this._then);

  final BulkDownloadZipPayload _self;
  final $Res Function(BulkDownloadZipPayload) _then;

/// Create a copy of BulkDownloadZipPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileIds = null,Object? zipFileName = freezed,}) {
  return _then(_self.copyWith(
fileIds: null == fileIds ? _self.fileIds : fileIds // ignore: cast_nullable_to_non_nullable
as List<String>,zipFileName: freezed == zipFileName ? _self.zipFileName : zipFileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkDownloadZipPayload].
extension BulkDownloadZipPayloadPatterns on BulkDownloadZipPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkDownloadZipPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkDownloadZipPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkDownloadZipPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkDownloadZipPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkDownloadZipPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkDownloadZipPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> fileIds,  String? zipFileName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkDownloadZipPayload() when $default != null:
return $default(_that.fileIds,_that.zipFileName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> fileIds,  String? zipFileName)  $default,) {final _that = this;
switch (_that) {
case _BulkDownloadZipPayload():
return $default(_that.fileIds,_that.zipFileName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> fileIds,  String? zipFileName)?  $default,) {final _that = this;
switch (_that) {
case _BulkDownloadZipPayload() when $default != null:
return $default(_that.fileIds,_that.zipFileName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkDownloadZipPayload implements BulkDownloadZipPayload {
  const _BulkDownloadZipPayload({required this.fileIds, this.zipFileName = 'zalaczniki.zip'});
  factory _BulkDownloadZipPayload.fromJson(Map<String, dynamic> json) => _$BulkDownloadZipPayloadFromJson(json);

@override final  List<String> fileIds;
@override@JsonKey() final  String? zipFileName;

/// Create a copy of BulkDownloadZipPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkDownloadZipPayloadCopyWith<_BulkDownloadZipPayload> get copyWith => __$BulkDownloadZipPayloadCopyWithImpl<_BulkDownloadZipPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkDownloadZipPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkDownloadZipPayload&&const DeepCollectionEquality().equals(other.fileIds, fileIds)&&(identical(other.zipFileName, zipFileName) || other.zipFileName == zipFileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(fileIds),zipFileName);

@override
String toString() {
  return 'BulkDownloadZipPayload(fileIds: $fileIds, zipFileName: $zipFileName)';
}


}

/// @nodoc
abstract mixin class _$BulkDownloadZipPayloadCopyWith<$Res> implements $BulkDownloadZipPayloadCopyWith<$Res> {
  factory _$BulkDownloadZipPayloadCopyWith(_BulkDownloadZipPayload value, $Res Function(_BulkDownloadZipPayload) _then) = __$BulkDownloadZipPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> fileIds, String? zipFileName
});




}
/// @nodoc
class __$BulkDownloadZipPayloadCopyWithImpl<$Res>
    implements _$BulkDownloadZipPayloadCopyWith<$Res> {
  __$BulkDownloadZipPayloadCopyWithImpl(this._self, this._then);

  final _BulkDownloadZipPayload _self;
  final $Res Function(_BulkDownloadZipPayload) _then;

/// Create a copy of BulkDownloadZipPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileIds = null,Object? zipFileName = freezed,}) {
  return _then(_BulkDownloadZipPayload(
fileIds: null == fileIds ? _self.fileIds : fileIds // ignore: cast_nullable_to_non_nullable
as List<String>,zipFileName: freezed == zipFileName ? _self.zipFileName : zipFileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StorageSemanticSearchResponse {

 String get status; String? get code; String get rankingVersion; List<StorageSemanticSearchHitResponse> get hits;
/// Create a copy of StorageSemanticSearchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageSemanticSearchResponseCopyWith<StorageSemanticSearchResponse> get copyWith => _$StorageSemanticSearchResponseCopyWithImpl<StorageSemanticSearchResponse>(this as StorageSemanticSearchResponse, _$identity);

  /// Serializes this StorageSemanticSearchResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageSemanticSearchResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&(identical(other.rankingVersion, rankingVersion) || other.rankingVersion == rankingVersion)&&const DeepCollectionEquality().equals(other.hits, hits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,code,rankingVersion,const DeepCollectionEquality().hash(hits));

@override
String toString() {
  return 'StorageSemanticSearchResponse(status: $status, code: $code, rankingVersion: $rankingVersion, hits: $hits)';
}


}

/// @nodoc
abstract mixin class $StorageSemanticSearchResponseCopyWith<$Res>  {
  factory $StorageSemanticSearchResponseCopyWith(StorageSemanticSearchResponse value, $Res Function(StorageSemanticSearchResponse) _then) = _$StorageSemanticSearchResponseCopyWithImpl;
@useResult
$Res call({
 String status, String? code, String rankingVersion, List<StorageSemanticSearchHitResponse> hits
});




}
/// @nodoc
class _$StorageSemanticSearchResponseCopyWithImpl<$Res>
    implements $StorageSemanticSearchResponseCopyWith<$Res> {
  _$StorageSemanticSearchResponseCopyWithImpl(this._self, this._then);

  final StorageSemanticSearchResponse _self;
  final $Res Function(StorageSemanticSearchResponse) _then;

/// Create a copy of StorageSemanticSearchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? code = freezed,Object? rankingVersion = null,Object? hits = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,rankingVersion: null == rankingVersion ? _self.rankingVersion : rankingVersion // ignore: cast_nullable_to_non_nullable
as String,hits: null == hits ? _self.hits : hits // ignore: cast_nullable_to_non_nullable
as List<StorageSemanticSearchHitResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageSemanticSearchResponse].
extension StorageSemanticSearchResponsePatterns on StorageSemanticSearchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageSemanticSearchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageSemanticSearchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageSemanticSearchResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageSemanticSearchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageSemanticSearchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageSemanticSearchResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? code,  String rankingVersion,  List<StorageSemanticSearchHitResponse> hits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageSemanticSearchResponse() when $default != null:
return $default(_that.status,_that.code,_that.rankingVersion,_that.hits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? code,  String rankingVersion,  List<StorageSemanticSearchHitResponse> hits)  $default,) {final _that = this;
switch (_that) {
case _StorageSemanticSearchResponse():
return $default(_that.status,_that.code,_that.rankingVersion,_that.hits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? code,  String rankingVersion,  List<StorageSemanticSearchHitResponse> hits)?  $default,) {final _that = this;
switch (_that) {
case _StorageSemanticSearchResponse() when $default != null:
return $default(_that.status,_that.code,_that.rankingVersion,_that.hits);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageSemanticSearchResponse implements StorageSemanticSearchResponse {
  const _StorageSemanticSearchResponse({required this.status, this.code, required this.rankingVersion, required this.hits});
  factory _StorageSemanticSearchResponse.fromJson(Map<String, dynamic> json) => _$StorageSemanticSearchResponseFromJson(json);

@override final  String status;
@override final  String? code;
@override final  String rankingVersion;
@override final  List<StorageSemanticSearchHitResponse> hits;

/// Create a copy of StorageSemanticSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageSemanticSearchResponseCopyWith<_StorageSemanticSearchResponse> get copyWith => __$StorageSemanticSearchResponseCopyWithImpl<_StorageSemanticSearchResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageSemanticSearchResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageSemanticSearchResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&(identical(other.rankingVersion, rankingVersion) || other.rankingVersion == rankingVersion)&&const DeepCollectionEquality().equals(other.hits, hits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,code,rankingVersion,const DeepCollectionEquality().hash(hits));

@override
String toString() {
  return 'StorageSemanticSearchResponse(status: $status, code: $code, rankingVersion: $rankingVersion, hits: $hits)';
}


}

/// @nodoc
abstract mixin class _$StorageSemanticSearchResponseCopyWith<$Res> implements $StorageSemanticSearchResponseCopyWith<$Res> {
  factory _$StorageSemanticSearchResponseCopyWith(_StorageSemanticSearchResponse value, $Res Function(_StorageSemanticSearchResponse) _then) = __$StorageSemanticSearchResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String? code, String rankingVersion, List<StorageSemanticSearchHitResponse> hits
});




}
/// @nodoc
class __$StorageSemanticSearchResponseCopyWithImpl<$Res>
    implements _$StorageSemanticSearchResponseCopyWith<$Res> {
  __$StorageSemanticSearchResponseCopyWithImpl(this._self, this._then);

  final _StorageSemanticSearchResponse _self;
  final $Res Function(_StorageSemanticSearchResponse) _then;

/// Create a copy of StorageSemanticSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? code = freezed,Object? rankingVersion = null,Object? hits = null,}) {
  return _then(_StorageSemanticSearchResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,rankingVersion: null == rankingVersion ? _self.rankingVersion : rankingVersion // ignore: cast_nullable_to_non_nullable
as String,hits: null == hits ? _self.hits : hits // ignore: cast_nullable_to_non_nullable
as List<StorageSemanticSearchHitResponse>,
  ));
}


}


/// @nodoc
mixin _$StorageSemanticSearchHitResponse {

 String get fileId; int get fileVersion; int get chunkIndex; String get text; double get distance; double get score; bool get fullTextMatch;
/// Create a copy of StorageSemanticSearchHitResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageSemanticSearchHitResponseCopyWith<StorageSemanticSearchHitResponse> get copyWith => _$StorageSemanticSearchHitResponseCopyWithImpl<StorageSemanticSearchHitResponse>(this as StorageSemanticSearchHitResponse, _$identity);

  /// Serializes this StorageSemanticSearchHitResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageSemanticSearchHitResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileVersion, fileVersion) || other.fileVersion == fileVersion)&&(identical(other.chunkIndex, chunkIndex) || other.chunkIndex == chunkIndex)&&(identical(other.text, text) || other.text == text)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.score, score) || other.score == score)&&(identical(other.fullTextMatch, fullTextMatch) || other.fullTextMatch == fullTextMatch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,fileVersion,chunkIndex,text,distance,score,fullTextMatch);

@override
String toString() {
  return 'StorageSemanticSearchHitResponse(fileId: $fileId, fileVersion: $fileVersion, chunkIndex: $chunkIndex, text: $text, distance: $distance, score: $score, fullTextMatch: $fullTextMatch)';
}


}

/// @nodoc
abstract mixin class $StorageSemanticSearchHitResponseCopyWith<$Res>  {
  factory $StorageSemanticSearchHitResponseCopyWith(StorageSemanticSearchHitResponse value, $Res Function(StorageSemanticSearchHitResponse) _then) = _$StorageSemanticSearchHitResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, int fileVersion, int chunkIndex, String text, double distance, double score, bool fullTextMatch
});




}
/// @nodoc
class _$StorageSemanticSearchHitResponseCopyWithImpl<$Res>
    implements $StorageSemanticSearchHitResponseCopyWith<$Res> {
  _$StorageSemanticSearchHitResponseCopyWithImpl(this._self, this._then);

  final StorageSemanticSearchHitResponse _self;
  final $Res Function(StorageSemanticSearchHitResponse) _then;

/// Create a copy of StorageSemanticSearchHitResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? fileVersion = null,Object? chunkIndex = null,Object? text = null,Object? distance = null,Object? score = null,Object? fullTextMatch = null,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileVersion: null == fileVersion ? _self.fileVersion : fileVersion // ignore: cast_nullable_to_non_nullable
as int,chunkIndex: null == chunkIndex ? _self.chunkIndex : chunkIndex // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,fullTextMatch: null == fullTextMatch ? _self.fullTextMatch : fullTextMatch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageSemanticSearchHitResponse].
extension StorageSemanticSearchHitResponsePatterns on StorageSemanticSearchHitResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageSemanticSearchHitResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageSemanticSearchHitResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageSemanticSearchHitResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageSemanticSearchHitResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageSemanticSearchHitResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageSemanticSearchHitResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  int fileVersion,  int chunkIndex,  String text,  double distance,  double score,  bool fullTextMatch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageSemanticSearchHitResponse() when $default != null:
return $default(_that.fileId,_that.fileVersion,_that.chunkIndex,_that.text,_that.distance,_that.score,_that.fullTextMatch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  int fileVersion,  int chunkIndex,  String text,  double distance,  double score,  bool fullTextMatch)  $default,) {final _that = this;
switch (_that) {
case _StorageSemanticSearchHitResponse():
return $default(_that.fileId,_that.fileVersion,_that.chunkIndex,_that.text,_that.distance,_that.score,_that.fullTextMatch);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  int fileVersion,  int chunkIndex,  String text,  double distance,  double score,  bool fullTextMatch)?  $default,) {final _that = this;
switch (_that) {
case _StorageSemanticSearchHitResponse() when $default != null:
return $default(_that.fileId,_that.fileVersion,_that.chunkIndex,_that.text,_that.distance,_that.score,_that.fullTextMatch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageSemanticSearchHitResponse implements StorageSemanticSearchHitResponse {
  const _StorageSemanticSearchHitResponse({required this.fileId, required this.fileVersion, required this.chunkIndex, required this.text, required this.distance, required this.score, required this.fullTextMatch});
  factory _StorageSemanticSearchHitResponse.fromJson(Map<String, dynamic> json) => _$StorageSemanticSearchHitResponseFromJson(json);

@override final  String fileId;
@override final  int fileVersion;
@override final  int chunkIndex;
@override final  String text;
@override final  double distance;
@override final  double score;
@override final  bool fullTextMatch;

/// Create a copy of StorageSemanticSearchHitResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageSemanticSearchHitResponseCopyWith<_StorageSemanticSearchHitResponse> get copyWith => __$StorageSemanticSearchHitResponseCopyWithImpl<_StorageSemanticSearchHitResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageSemanticSearchHitResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageSemanticSearchHitResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileVersion, fileVersion) || other.fileVersion == fileVersion)&&(identical(other.chunkIndex, chunkIndex) || other.chunkIndex == chunkIndex)&&(identical(other.text, text) || other.text == text)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.score, score) || other.score == score)&&(identical(other.fullTextMatch, fullTextMatch) || other.fullTextMatch == fullTextMatch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,fileVersion,chunkIndex,text,distance,score,fullTextMatch);

@override
String toString() {
  return 'StorageSemanticSearchHitResponse(fileId: $fileId, fileVersion: $fileVersion, chunkIndex: $chunkIndex, text: $text, distance: $distance, score: $score, fullTextMatch: $fullTextMatch)';
}


}

/// @nodoc
abstract mixin class _$StorageSemanticSearchHitResponseCopyWith<$Res> implements $StorageSemanticSearchHitResponseCopyWith<$Res> {
  factory _$StorageSemanticSearchHitResponseCopyWith(_StorageSemanticSearchHitResponse value, $Res Function(_StorageSemanticSearchHitResponse) _then) = __$StorageSemanticSearchHitResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, int fileVersion, int chunkIndex, String text, double distance, double score, bool fullTextMatch
});




}
/// @nodoc
class __$StorageSemanticSearchHitResponseCopyWithImpl<$Res>
    implements _$StorageSemanticSearchHitResponseCopyWith<$Res> {
  __$StorageSemanticSearchHitResponseCopyWithImpl(this._self, this._then);

  final _StorageSemanticSearchHitResponse _self;
  final $Res Function(_StorageSemanticSearchHitResponse) _then;

/// Create a copy of StorageSemanticSearchHitResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? fileVersion = null,Object? chunkIndex = null,Object? text = null,Object? distance = null,Object? score = null,Object? fullTextMatch = null,}) {
  return _then(_StorageSemanticSearchHitResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileVersion: null == fileVersion ? _self.fileVersion : fileVersion // ignore: cast_nullable_to_non_nullable
as int,chunkIndex: null == chunkIndex ? _self.chunkIndex : chunkIndex // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,fullTextMatch: null == fullTextMatch ? _self.fullTextMatch : fullTextMatch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StorageAiReportTypeResponse {

 String get reportType; String get promptVersion; int get schemaVersion; String get description; String get contractVersion; List<String>? get requiredSectionKeys; StorageAiReportScopeType get scopeType;
/// Create a copy of StorageAiReportTypeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageAiReportTypeResponseCopyWith<StorageAiReportTypeResponse> get copyWith => _$StorageAiReportTypeResponseCopyWithImpl<StorageAiReportTypeResponse>(this as StorageAiReportTypeResponse, _$identity);

  /// Serializes this StorageAiReportTypeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageAiReportTypeResponse&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.promptVersion, promptVersion) || other.promptVersion == promptVersion)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.description, description) || other.description == description)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&const DeepCollectionEquality().equals(other.requiredSectionKeys, requiredSectionKeys)&&(identical(other.scopeType, scopeType) || other.scopeType == scopeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,promptVersion,schemaVersion,description,contractVersion,const DeepCollectionEquality().hash(requiredSectionKeys),scopeType);

@override
String toString() {
  return 'StorageAiReportTypeResponse(reportType: $reportType, promptVersion: $promptVersion, schemaVersion: $schemaVersion, description: $description, contractVersion: $contractVersion, requiredSectionKeys: $requiredSectionKeys, scopeType: $scopeType)';
}


}

/// @nodoc
abstract mixin class $StorageAiReportTypeResponseCopyWith<$Res>  {
  factory $StorageAiReportTypeResponseCopyWith(StorageAiReportTypeResponse value, $Res Function(StorageAiReportTypeResponse) _then) = _$StorageAiReportTypeResponseCopyWithImpl;
@useResult
$Res call({
 String reportType, String promptVersion, int schemaVersion, String description, String contractVersion, List<String>? requiredSectionKeys, StorageAiReportScopeType scopeType
});




}
/// @nodoc
class _$StorageAiReportTypeResponseCopyWithImpl<$Res>
    implements $StorageAiReportTypeResponseCopyWith<$Res> {
  _$StorageAiReportTypeResponseCopyWithImpl(this._self, this._then);

  final StorageAiReportTypeResponse _self;
  final $Res Function(StorageAiReportTypeResponse) _then;

/// Create a copy of StorageAiReportTypeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportType = null,Object? promptVersion = null,Object? schemaVersion = null,Object? description = null,Object? contractVersion = null,Object? requiredSectionKeys = freezed,Object? scopeType = null,}) {
  return _then(_self.copyWith(
reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,promptVersion: null == promptVersion ? _self.promptVersion : promptVersion // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,requiredSectionKeys: freezed == requiredSectionKeys ? _self.requiredSectionKeys : requiredSectionKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,scopeType: null == scopeType ? _self.scopeType : scopeType // ignore: cast_nullable_to_non_nullable
as StorageAiReportScopeType,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageAiReportTypeResponse].
extension StorageAiReportTypeResponsePatterns on StorageAiReportTypeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageAiReportTypeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageAiReportTypeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageAiReportTypeResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportTypeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageAiReportTypeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportTypeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reportType,  String promptVersion,  int schemaVersion,  String description,  String contractVersion,  List<String>? requiredSectionKeys,  StorageAiReportScopeType scopeType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageAiReportTypeResponse() when $default != null:
return $default(_that.reportType,_that.promptVersion,_that.schemaVersion,_that.description,_that.contractVersion,_that.requiredSectionKeys,_that.scopeType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reportType,  String promptVersion,  int schemaVersion,  String description,  String contractVersion,  List<String>? requiredSectionKeys,  StorageAiReportScopeType scopeType)  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportTypeResponse():
return $default(_that.reportType,_that.promptVersion,_that.schemaVersion,_that.description,_that.contractVersion,_that.requiredSectionKeys,_that.scopeType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reportType,  String promptVersion,  int schemaVersion,  String description,  String contractVersion,  List<String>? requiredSectionKeys,  StorageAiReportScopeType scopeType)?  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportTypeResponse() when $default != null:
return $default(_that.reportType,_that.promptVersion,_that.schemaVersion,_that.description,_that.contractVersion,_that.requiredSectionKeys,_that.scopeType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageAiReportTypeResponse implements StorageAiReportTypeResponse {
  const _StorageAiReportTypeResponse({required this.reportType, required this.promptVersion, required this.schemaVersion, required this.description, this.contractVersion = 'ai.v1', this.requiredSectionKeys, this.scopeType = StorageAiReportScopeType.project});
  factory _StorageAiReportTypeResponse.fromJson(Map<String, dynamic> json) => _$StorageAiReportTypeResponseFromJson(json);

@override final  String reportType;
@override final  String promptVersion;
@override final  int schemaVersion;
@override final  String description;
@override@JsonKey() final  String contractVersion;
@override final  List<String>? requiredSectionKeys;
@override@JsonKey() final  StorageAiReportScopeType scopeType;

/// Create a copy of StorageAiReportTypeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageAiReportTypeResponseCopyWith<_StorageAiReportTypeResponse> get copyWith => __$StorageAiReportTypeResponseCopyWithImpl<_StorageAiReportTypeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageAiReportTypeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageAiReportTypeResponse&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.promptVersion, promptVersion) || other.promptVersion == promptVersion)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.description, description) || other.description == description)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&const DeepCollectionEquality().equals(other.requiredSectionKeys, requiredSectionKeys)&&(identical(other.scopeType, scopeType) || other.scopeType == scopeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,promptVersion,schemaVersion,description,contractVersion,const DeepCollectionEquality().hash(requiredSectionKeys),scopeType);

@override
String toString() {
  return 'StorageAiReportTypeResponse(reportType: $reportType, promptVersion: $promptVersion, schemaVersion: $schemaVersion, description: $description, contractVersion: $contractVersion, requiredSectionKeys: $requiredSectionKeys, scopeType: $scopeType)';
}


}

/// @nodoc
abstract mixin class _$StorageAiReportTypeResponseCopyWith<$Res> implements $StorageAiReportTypeResponseCopyWith<$Res> {
  factory _$StorageAiReportTypeResponseCopyWith(_StorageAiReportTypeResponse value, $Res Function(_StorageAiReportTypeResponse) _then) = __$StorageAiReportTypeResponseCopyWithImpl;
@override @useResult
$Res call({
 String reportType, String promptVersion, int schemaVersion, String description, String contractVersion, List<String>? requiredSectionKeys, StorageAiReportScopeType scopeType
});




}
/// @nodoc
class __$StorageAiReportTypeResponseCopyWithImpl<$Res>
    implements _$StorageAiReportTypeResponseCopyWith<$Res> {
  __$StorageAiReportTypeResponseCopyWithImpl(this._self, this._then);

  final _StorageAiReportTypeResponse _self;
  final $Res Function(_StorageAiReportTypeResponse) _then;

/// Create a copy of StorageAiReportTypeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportType = null,Object? promptVersion = null,Object? schemaVersion = null,Object? description = null,Object? contractVersion = null,Object? requiredSectionKeys = freezed,Object? scopeType = null,}) {
  return _then(_StorageAiReportTypeResponse(
reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,promptVersion: null == promptVersion ? _self.promptVersion : promptVersion // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,requiredSectionKeys: freezed == requiredSectionKeys ? _self.requiredSectionKeys : requiredSectionKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,scopeType: null == scopeType ? _self.scopeType : scopeType // ignore: cast_nullable_to_non_nullable
as StorageAiReportScopeType,
  ));
}


}


/// @nodoc
mixin _$CreateStorageAiReportPayload {

 String get reportType; String get contractVersion; String? get promptVersion;
/// Create a copy of CreateStorageAiReportPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateStorageAiReportPayloadCopyWith<CreateStorageAiReportPayload> get copyWith => _$CreateStorageAiReportPayloadCopyWithImpl<CreateStorageAiReportPayload>(this as CreateStorageAiReportPayload, _$identity);

  /// Serializes this CreateStorageAiReportPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateStorageAiReportPayload&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.promptVersion, promptVersion) || other.promptVersion == promptVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,contractVersion,promptVersion);

@override
String toString() {
  return 'CreateStorageAiReportPayload(reportType: $reportType, contractVersion: $contractVersion, promptVersion: $promptVersion)';
}


}

/// @nodoc
abstract mixin class $CreateStorageAiReportPayloadCopyWith<$Res>  {
  factory $CreateStorageAiReportPayloadCopyWith(CreateStorageAiReportPayload value, $Res Function(CreateStorageAiReportPayload) _then) = _$CreateStorageAiReportPayloadCopyWithImpl;
@useResult
$Res call({
 String reportType, String contractVersion, String? promptVersion
});




}
/// @nodoc
class _$CreateStorageAiReportPayloadCopyWithImpl<$Res>
    implements $CreateStorageAiReportPayloadCopyWith<$Res> {
  _$CreateStorageAiReportPayloadCopyWithImpl(this._self, this._then);

  final CreateStorageAiReportPayload _self;
  final $Res Function(CreateStorageAiReportPayload) _then;

/// Create a copy of CreateStorageAiReportPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportType = null,Object? contractVersion = null,Object? promptVersion = freezed,}) {
  return _then(_self.copyWith(
reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,promptVersion: freezed == promptVersion ? _self.promptVersion : promptVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateStorageAiReportPayload].
extension CreateStorageAiReportPayloadPatterns on CreateStorageAiReportPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateStorageAiReportPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateStorageAiReportPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateStorageAiReportPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateStorageAiReportPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateStorageAiReportPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateStorageAiReportPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reportType,  String contractVersion,  String? promptVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateStorageAiReportPayload() when $default != null:
return $default(_that.reportType,_that.contractVersion,_that.promptVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reportType,  String contractVersion,  String? promptVersion)  $default,) {final _that = this;
switch (_that) {
case _CreateStorageAiReportPayload():
return $default(_that.reportType,_that.contractVersion,_that.promptVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reportType,  String contractVersion,  String? promptVersion)?  $default,) {final _that = this;
switch (_that) {
case _CreateStorageAiReportPayload() when $default != null:
return $default(_that.reportType,_that.contractVersion,_that.promptVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateStorageAiReportPayload implements CreateStorageAiReportPayload {
  const _CreateStorageAiReportPayload({this.reportType = 'project.summary', this.contractVersion = 'ai.v1', this.promptVersion});
  factory _CreateStorageAiReportPayload.fromJson(Map<String, dynamic> json) => _$CreateStorageAiReportPayloadFromJson(json);

@override@JsonKey() final  String reportType;
@override@JsonKey() final  String contractVersion;
@override final  String? promptVersion;

/// Create a copy of CreateStorageAiReportPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateStorageAiReportPayloadCopyWith<_CreateStorageAiReportPayload> get copyWith => __$CreateStorageAiReportPayloadCopyWithImpl<_CreateStorageAiReportPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateStorageAiReportPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateStorageAiReportPayload&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.promptVersion, promptVersion) || other.promptVersion == promptVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,contractVersion,promptVersion);

@override
String toString() {
  return 'CreateStorageAiReportPayload(reportType: $reportType, contractVersion: $contractVersion, promptVersion: $promptVersion)';
}


}

/// @nodoc
abstract mixin class _$CreateStorageAiReportPayloadCopyWith<$Res> implements $CreateStorageAiReportPayloadCopyWith<$Res> {
  factory _$CreateStorageAiReportPayloadCopyWith(_CreateStorageAiReportPayload value, $Res Function(_CreateStorageAiReportPayload) _then) = __$CreateStorageAiReportPayloadCopyWithImpl;
@override @useResult
$Res call({
 String reportType, String contractVersion, String? promptVersion
});




}
/// @nodoc
class __$CreateStorageAiReportPayloadCopyWithImpl<$Res>
    implements _$CreateStorageAiReportPayloadCopyWith<$Res> {
  __$CreateStorageAiReportPayloadCopyWithImpl(this._self, this._then);

  final _CreateStorageAiReportPayload _self;
  final $Res Function(_CreateStorageAiReportPayload) _then;

/// Create a copy of CreateStorageAiReportPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportType = null,Object? contractVersion = null,Object? promptVersion = freezed,}) {
  return _then(_CreateStorageAiReportPayload(
reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,promptVersion: freezed == promptVersion ? _self.promptVersion : promptVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StorageAiReportSourceResponse {

 String get fileId; int get fileVersion; String get fileName; String? get contentSha256;
/// Create a copy of StorageAiReportSourceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageAiReportSourceResponseCopyWith<StorageAiReportSourceResponse> get copyWith => _$StorageAiReportSourceResponseCopyWithImpl<StorageAiReportSourceResponse>(this as StorageAiReportSourceResponse, _$identity);

  /// Serializes this StorageAiReportSourceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageAiReportSourceResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileVersion, fileVersion) || other.fileVersion == fileVersion)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,fileVersion,fileName,contentSha256);

@override
String toString() {
  return 'StorageAiReportSourceResponse(fileId: $fileId, fileVersion: $fileVersion, fileName: $fileName, contentSha256: $contentSha256)';
}


}

/// @nodoc
abstract mixin class $StorageAiReportSourceResponseCopyWith<$Res>  {
  factory $StorageAiReportSourceResponseCopyWith(StorageAiReportSourceResponse value, $Res Function(StorageAiReportSourceResponse) _then) = _$StorageAiReportSourceResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, int fileVersion, String fileName, String? contentSha256
});




}
/// @nodoc
class _$StorageAiReportSourceResponseCopyWithImpl<$Res>
    implements $StorageAiReportSourceResponseCopyWith<$Res> {
  _$StorageAiReportSourceResponseCopyWithImpl(this._self, this._then);

  final StorageAiReportSourceResponse _self;
  final $Res Function(StorageAiReportSourceResponse) _then;

/// Create a copy of StorageAiReportSourceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? fileVersion = null,Object? fileName = null,Object? contentSha256 = freezed,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileVersion: null == fileVersion ? _self.fileVersion : fileVersion // ignore: cast_nullable_to_non_nullable
as int,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageAiReportSourceResponse].
extension StorageAiReportSourceResponsePatterns on StorageAiReportSourceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageAiReportSourceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageAiReportSourceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageAiReportSourceResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportSourceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageAiReportSourceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportSourceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  int fileVersion,  String fileName,  String? contentSha256)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageAiReportSourceResponse() when $default != null:
return $default(_that.fileId,_that.fileVersion,_that.fileName,_that.contentSha256);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  int fileVersion,  String fileName,  String? contentSha256)  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportSourceResponse():
return $default(_that.fileId,_that.fileVersion,_that.fileName,_that.contentSha256);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  int fileVersion,  String fileName,  String? contentSha256)?  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportSourceResponse() when $default != null:
return $default(_that.fileId,_that.fileVersion,_that.fileName,_that.contentSha256);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageAiReportSourceResponse implements StorageAiReportSourceResponse {
  const _StorageAiReportSourceResponse({required this.fileId, required this.fileVersion, required this.fileName, this.contentSha256});
  factory _StorageAiReportSourceResponse.fromJson(Map<String, dynamic> json) => _$StorageAiReportSourceResponseFromJson(json);

@override final  String fileId;
@override final  int fileVersion;
@override final  String fileName;
@override final  String? contentSha256;

/// Create a copy of StorageAiReportSourceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageAiReportSourceResponseCopyWith<_StorageAiReportSourceResponse> get copyWith => __$StorageAiReportSourceResponseCopyWithImpl<_StorageAiReportSourceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageAiReportSourceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageAiReportSourceResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileVersion, fileVersion) || other.fileVersion == fileVersion)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,fileVersion,fileName,contentSha256);

@override
String toString() {
  return 'StorageAiReportSourceResponse(fileId: $fileId, fileVersion: $fileVersion, fileName: $fileName, contentSha256: $contentSha256)';
}


}

/// @nodoc
abstract mixin class _$StorageAiReportSourceResponseCopyWith<$Res> implements $StorageAiReportSourceResponseCopyWith<$Res> {
  factory _$StorageAiReportSourceResponseCopyWith(_StorageAiReportSourceResponse value, $Res Function(_StorageAiReportSourceResponse) _then) = __$StorageAiReportSourceResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, int fileVersion, String fileName, String? contentSha256
});




}
/// @nodoc
class __$StorageAiReportSourceResponseCopyWithImpl<$Res>
    implements _$StorageAiReportSourceResponseCopyWith<$Res> {
  __$StorageAiReportSourceResponseCopyWithImpl(this._self, this._then);

  final _StorageAiReportSourceResponse _self;
  final $Res Function(_StorageAiReportSourceResponse) _then;

/// Create a copy of StorageAiReportSourceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? fileVersion = null,Object? fileName = null,Object? contentSha256 = freezed,}) {
  return _then(_StorageAiReportSourceResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileVersion: null == fileVersion ? _self.fileVersion : fileVersion // ignore: cast_nullable_to_non_nullable
as int,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StorageAiReportDocumentSectionResponse {

 String get key; String get title; String get content; int get order;
/// Create a copy of StorageAiReportDocumentSectionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageAiReportDocumentSectionResponseCopyWith<StorageAiReportDocumentSectionResponse> get copyWith => _$StorageAiReportDocumentSectionResponseCopyWithImpl<StorageAiReportDocumentSectionResponse>(this as StorageAiReportDocumentSectionResponse, _$identity);

  /// Serializes this StorageAiReportDocumentSectionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageAiReportDocumentSectionResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,title,content,order);

@override
String toString() {
  return 'StorageAiReportDocumentSectionResponse(key: $key, title: $title, content: $content, order: $order)';
}


}

/// @nodoc
abstract mixin class $StorageAiReportDocumentSectionResponseCopyWith<$Res>  {
  factory $StorageAiReportDocumentSectionResponseCopyWith(StorageAiReportDocumentSectionResponse value, $Res Function(StorageAiReportDocumentSectionResponse) _then) = _$StorageAiReportDocumentSectionResponseCopyWithImpl;
@useResult
$Res call({
 String key, String title, String content, int order
});




}
/// @nodoc
class _$StorageAiReportDocumentSectionResponseCopyWithImpl<$Res>
    implements $StorageAiReportDocumentSectionResponseCopyWith<$Res> {
  _$StorageAiReportDocumentSectionResponseCopyWithImpl(this._self, this._then);

  final StorageAiReportDocumentSectionResponse _self;
  final $Res Function(StorageAiReportDocumentSectionResponse) _then;

/// Create a copy of StorageAiReportDocumentSectionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? title = null,Object? content = null,Object? order = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageAiReportDocumentSectionResponse].
extension StorageAiReportDocumentSectionResponsePatterns on StorageAiReportDocumentSectionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageAiReportDocumentSectionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentSectionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageAiReportDocumentSectionResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentSectionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageAiReportDocumentSectionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentSectionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String title,  String content,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentSectionResponse() when $default != null:
return $default(_that.key,_that.title,_that.content,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String title,  String content,  int order)  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentSectionResponse():
return $default(_that.key,_that.title,_that.content,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String title,  String content,  int order)?  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentSectionResponse() when $default != null:
return $default(_that.key,_that.title,_that.content,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageAiReportDocumentSectionResponse implements StorageAiReportDocumentSectionResponse {
  const _StorageAiReportDocumentSectionResponse({required this.key, required this.title, required this.content, required this.order});
  factory _StorageAiReportDocumentSectionResponse.fromJson(Map<String, dynamic> json) => _$StorageAiReportDocumentSectionResponseFromJson(json);

@override final  String key;
@override final  String title;
@override final  String content;
@override final  int order;

/// Create a copy of StorageAiReportDocumentSectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageAiReportDocumentSectionResponseCopyWith<_StorageAiReportDocumentSectionResponse> get copyWith => __$StorageAiReportDocumentSectionResponseCopyWithImpl<_StorageAiReportDocumentSectionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageAiReportDocumentSectionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageAiReportDocumentSectionResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,title,content,order);

@override
String toString() {
  return 'StorageAiReportDocumentSectionResponse(key: $key, title: $title, content: $content, order: $order)';
}


}

/// @nodoc
abstract mixin class _$StorageAiReportDocumentSectionResponseCopyWith<$Res> implements $StorageAiReportDocumentSectionResponseCopyWith<$Res> {
  factory _$StorageAiReportDocumentSectionResponseCopyWith(_StorageAiReportDocumentSectionResponse value, $Res Function(_StorageAiReportDocumentSectionResponse) _then) = __$StorageAiReportDocumentSectionResponseCopyWithImpl;
@override @useResult
$Res call({
 String key, String title, String content, int order
});




}
/// @nodoc
class __$StorageAiReportDocumentSectionResponseCopyWithImpl<$Res>
    implements _$StorageAiReportDocumentSectionResponseCopyWith<$Res> {
  __$StorageAiReportDocumentSectionResponseCopyWithImpl(this._self, this._then);

  final _StorageAiReportDocumentSectionResponse _self;
  final $Res Function(_StorageAiReportDocumentSectionResponse) _then;

/// Create a copy of StorageAiReportDocumentSectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? title = null,Object? content = null,Object? order = null,}) {
  return _then(_StorageAiReportDocumentSectionResponse(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StorageAiReportDocumentSourceResponse {

 String get sourceType; String get sourceId; int? get version; String? get contentSha256; String get displayName;
/// Create a copy of StorageAiReportDocumentSourceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageAiReportDocumentSourceResponseCopyWith<StorageAiReportDocumentSourceResponse> get copyWith => _$StorageAiReportDocumentSourceResponseCopyWithImpl<StorageAiReportDocumentSourceResponse>(this as StorageAiReportDocumentSourceResponse, _$identity);

  /// Serializes this StorageAiReportDocumentSourceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageAiReportDocumentSourceResponse&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.version, version) || other.version == version)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceType,sourceId,version,contentSha256,displayName);

@override
String toString() {
  return 'StorageAiReportDocumentSourceResponse(sourceType: $sourceType, sourceId: $sourceId, version: $version, contentSha256: $contentSha256, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $StorageAiReportDocumentSourceResponseCopyWith<$Res>  {
  factory $StorageAiReportDocumentSourceResponseCopyWith(StorageAiReportDocumentSourceResponse value, $Res Function(StorageAiReportDocumentSourceResponse) _then) = _$StorageAiReportDocumentSourceResponseCopyWithImpl;
@useResult
$Res call({
 String sourceType, String sourceId, int? version, String? contentSha256, String displayName
});




}
/// @nodoc
class _$StorageAiReportDocumentSourceResponseCopyWithImpl<$Res>
    implements $StorageAiReportDocumentSourceResponseCopyWith<$Res> {
  _$StorageAiReportDocumentSourceResponseCopyWithImpl(this._self, this._then);

  final StorageAiReportDocumentSourceResponse _self;
  final $Res Function(StorageAiReportDocumentSourceResponse) _then;

/// Create a copy of StorageAiReportDocumentSourceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceType = null,Object? sourceId = null,Object? version = freezed,Object? contentSha256 = freezed,Object? displayName = null,}) {
  return _then(_self.copyWith(
sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageAiReportDocumentSourceResponse].
extension StorageAiReportDocumentSourceResponsePatterns on StorageAiReportDocumentSourceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageAiReportDocumentSourceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentSourceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageAiReportDocumentSourceResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentSourceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageAiReportDocumentSourceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentSourceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceType,  String sourceId,  int? version,  String? contentSha256,  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentSourceResponse() when $default != null:
return $default(_that.sourceType,_that.sourceId,_that.version,_that.contentSha256,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceType,  String sourceId,  int? version,  String? contentSha256,  String displayName)  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentSourceResponse():
return $default(_that.sourceType,_that.sourceId,_that.version,_that.contentSha256,_that.displayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceType,  String sourceId,  int? version,  String? contentSha256,  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentSourceResponse() when $default != null:
return $default(_that.sourceType,_that.sourceId,_that.version,_that.contentSha256,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageAiReportDocumentSourceResponse implements StorageAiReportDocumentSourceResponse {
  const _StorageAiReportDocumentSourceResponse({required this.sourceType, required this.sourceId, this.version, this.contentSha256, required this.displayName});
  factory _StorageAiReportDocumentSourceResponse.fromJson(Map<String, dynamic> json) => _$StorageAiReportDocumentSourceResponseFromJson(json);

@override final  String sourceType;
@override final  String sourceId;
@override final  int? version;
@override final  String? contentSha256;
@override final  String displayName;

/// Create a copy of StorageAiReportDocumentSourceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageAiReportDocumentSourceResponseCopyWith<_StorageAiReportDocumentSourceResponse> get copyWith => __$StorageAiReportDocumentSourceResponseCopyWithImpl<_StorageAiReportDocumentSourceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageAiReportDocumentSourceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageAiReportDocumentSourceResponse&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.version, version) || other.version == version)&&(identical(other.contentSha256, contentSha256) || other.contentSha256 == contentSha256)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceType,sourceId,version,contentSha256,displayName);

@override
String toString() {
  return 'StorageAiReportDocumentSourceResponse(sourceType: $sourceType, sourceId: $sourceId, version: $version, contentSha256: $contentSha256, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$StorageAiReportDocumentSourceResponseCopyWith<$Res> implements $StorageAiReportDocumentSourceResponseCopyWith<$Res> {
  factory _$StorageAiReportDocumentSourceResponseCopyWith(_StorageAiReportDocumentSourceResponse value, $Res Function(_StorageAiReportDocumentSourceResponse) _then) = __$StorageAiReportDocumentSourceResponseCopyWithImpl;
@override @useResult
$Res call({
 String sourceType, String sourceId, int? version, String? contentSha256, String displayName
});




}
/// @nodoc
class __$StorageAiReportDocumentSourceResponseCopyWithImpl<$Res>
    implements _$StorageAiReportDocumentSourceResponseCopyWith<$Res> {
  __$StorageAiReportDocumentSourceResponseCopyWithImpl(this._self, this._then);

  final _StorageAiReportDocumentSourceResponse _self;
  final $Res Function(_StorageAiReportDocumentSourceResponse) _then;

/// Create a copy of StorageAiReportDocumentSourceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceType = null,Object? sourceId = null,Object? version = freezed,Object? contentSha256 = freezed,Object? displayName = null,}) {
  return _then(_StorageAiReportDocumentSourceResponse(
sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,contentSha256: freezed == contentSha256 ? _self.contentSha256 : contentSha256 // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StorageAiReportDocumentWarningResponse {

 String get code; String get message;
/// Create a copy of StorageAiReportDocumentWarningResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageAiReportDocumentWarningResponseCopyWith<StorageAiReportDocumentWarningResponse> get copyWith => _$StorageAiReportDocumentWarningResponseCopyWithImpl<StorageAiReportDocumentWarningResponse>(this as StorageAiReportDocumentWarningResponse, _$identity);

  /// Serializes this StorageAiReportDocumentWarningResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageAiReportDocumentWarningResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'StorageAiReportDocumentWarningResponse(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class $StorageAiReportDocumentWarningResponseCopyWith<$Res>  {
  factory $StorageAiReportDocumentWarningResponseCopyWith(StorageAiReportDocumentWarningResponse value, $Res Function(StorageAiReportDocumentWarningResponse) _then) = _$StorageAiReportDocumentWarningResponseCopyWithImpl;
@useResult
$Res call({
 String code, String message
});




}
/// @nodoc
class _$StorageAiReportDocumentWarningResponseCopyWithImpl<$Res>
    implements $StorageAiReportDocumentWarningResponseCopyWith<$Res> {
  _$StorageAiReportDocumentWarningResponseCopyWithImpl(this._self, this._then);

  final StorageAiReportDocumentWarningResponse _self;
  final $Res Function(StorageAiReportDocumentWarningResponse) _then;

/// Create a copy of StorageAiReportDocumentWarningResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageAiReportDocumentWarningResponse].
extension StorageAiReportDocumentWarningResponsePatterns on StorageAiReportDocumentWarningResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageAiReportDocumentWarningResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentWarningResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageAiReportDocumentWarningResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentWarningResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageAiReportDocumentWarningResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentWarningResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentWarningResponse() when $default != null:
return $default(_that.code,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message)  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentWarningResponse():
return $default(_that.code,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message)?  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentWarningResponse() when $default != null:
return $default(_that.code,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageAiReportDocumentWarningResponse implements StorageAiReportDocumentWarningResponse {
  const _StorageAiReportDocumentWarningResponse({required this.code, required this.message});
  factory _StorageAiReportDocumentWarningResponse.fromJson(Map<String, dynamic> json) => _$StorageAiReportDocumentWarningResponseFromJson(json);

@override final  String code;
@override final  String message;

/// Create a copy of StorageAiReportDocumentWarningResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageAiReportDocumentWarningResponseCopyWith<_StorageAiReportDocumentWarningResponse> get copyWith => __$StorageAiReportDocumentWarningResponseCopyWithImpl<_StorageAiReportDocumentWarningResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageAiReportDocumentWarningResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageAiReportDocumentWarningResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'StorageAiReportDocumentWarningResponse(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class _$StorageAiReportDocumentWarningResponseCopyWith<$Res> implements $StorageAiReportDocumentWarningResponseCopyWith<$Res> {
  factory _$StorageAiReportDocumentWarningResponseCopyWith(_StorageAiReportDocumentWarningResponse value, $Res Function(_StorageAiReportDocumentWarningResponse) _then) = __$StorageAiReportDocumentWarningResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, String message
});




}
/// @nodoc
class __$StorageAiReportDocumentWarningResponseCopyWithImpl<$Res>
    implements _$StorageAiReportDocumentWarningResponseCopyWith<$Res> {
  __$StorageAiReportDocumentWarningResponseCopyWithImpl(this._self, this._then);

  final _StorageAiReportDocumentWarningResponse _self;
  final $Res Function(_StorageAiReportDocumentWarningResponse) _then;

/// Create a copy of StorageAiReportDocumentWarningResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,}) {
  return _then(_StorageAiReportDocumentWarningResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StorageAiReportDocumentResponse {

 String get reportType; String get contractVersion; String get operationId; String get promptVersion; int get schemaVersion; DateTime get generatedAtUtc; List<StorageAiReportDocumentSectionResponse> get sections; List<StorageAiReportDocumentSourceResponse> get sources; List<StorageAiReportDocumentWarningResponse> get warnings; AiProviderKind get provider; String? get model; Map<String, dynamic>? get structuredData;
/// Create a copy of StorageAiReportDocumentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageAiReportDocumentResponseCopyWith<StorageAiReportDocumentResponse> get copyWith => _$StorageAiReportDocumentResponseCopyWithImpl<StorageAiReportDocumentResponse>(this as StorageAiReportDocumentResponse, _$identity);

  /// Serializes this StorageAiReportDocumentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageAiReportDocumentResponse&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.promptVersion, promptVersion) || other.promptVersion == promptVersion)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&const DeepCollectionEquality().equals(other.sections, sections)&&const DeepCollectionEquality().equals(other.sources, sources)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.structuredData, structuredData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,contractVersion,operationId,promptVersion,schemaVersion,generatedAtUtc,const DeepCollectionEquality().hash(sections),const DeepCollectionEquality().hash(sources),const DeepCollectionEquality().hash(warnings),provider,model,const DeepCollectionEquality().hash(structuredData));

@override
String toString() {
  return 'StorageAiReportDocumentResponse(reportType: $reportType, contractVersion: $contractVersion, operationId: $operationId, promptVersion: $promptVersion, schemaVersion: $schemaVersion, generatedAtUtc: $generatedAtUtc, sections: $sections, sources: $sources, warnings: $warnings, provider: $provider, model: $model, structuredData: $structuredData)';
}


}

/// @nodoc
abstract mixin class $StorageAiReportDocumentResponseCopyWith<$Res>  {
  factory $StorageAiReportDocumentResponseCopyWith(StorageAiReportDocumentResponse value, $Res Function(StorageAiReportDocumentResponse) _then) = _$StorageAiReportDocumentResponseCopyWithImpl;
@useResult
$Res call({
 String reportType, String contractVersion, String operationId, String promptVersion, int schemaVersion, DateTime generatedAtUtc, List<StorageAiReportDocumentSectionResponse> sections, List<StorageAiReportDocumentSourceResponse> sources, List<StorageAiReportDocumentWarningResponse> warnings, AiProviderKind provider, String? model, Map<String, dynamic>? structuredData
});




}
/// @nodoc
class _$StorageAiReportDocumentResponseCopyWithImpl<$Res>
    implements $StorageAiReportDocumentResponseCopyWith<$Res> {
  _$StorageAiReportDocumentResponseCopyWithImpl(this._self, this._then);

  final StorageAiReportDocumentResponse _self;
  final $Res Function(StorageAiReportDocumentResponse) _then;

/// Create a copy of StorageAiReportDocumentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportType = null,Object? contractVersion = null,Object? operationId = null,Object? promptVersion = null,Object? schemaVersion = null,Object? generatedAtUtc = null,Object? sections = null,Object? sources = null,Object? warnings = null,Object? provider = null,Object? model = freezed,Object? structuredData = freezed,}) {
  return _then(_self.copyWith(
reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,promptVersion: null == promptVersion ? _self.promptVersion : promptVersion // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<StorageAiReportDocumentSectionResponse>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<StorageAiReportDocumentSourceResponse>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<StorageAiReportDocumentWarningResponse>,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,structuredData: freezed == structuredData ? _self.structuredData : structuredData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageAiReportDocumentResponse].
extension StorageAiReportDocumentResponsePatterns on StorageAiReportDocumentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageAiReportDocumentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageAiReportDocumentResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageAiReportDocumentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportDocumentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reportType,  String contractVersion,  String operationId,  String promptVersion,  int schemaVersion,  DateTime generatedAtUtc,  List<StorageAiReportDocumentSectionResponse> sections,  List<StorageAiReportDocumentSourceResponse> sources,  List<StorageAiReportDocumentWarningResponse> warnings,  AiProviderKind provider,  String? model,  Map<String, dynamic>? structuredData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentResponse() when $default != null:
return $default(_that.reportType,_that.contractVersion,_that.operationId,_that.promptVersion,_that.schemaVersion,_that.generatedAtUtc,_that.sections,_that.sources,_that.warnings,_that.provider,_that.model,_that.structuredData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reportType,  String contractVersion,  String operationId,  String promptVersion,  int schemaVersion,  DateTime generatedAtUtc,  List<StorageAiReportDocumentSectionResponse> sections,  List<StorageAiReportDocumentSourceResponse> sources,  List<StorageAiReportDocumentWarningResponse> warnings,  AiProviderKind provider,  String? model,  Map<String, dynamic>? structuredData)  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentResponse():
return $default(_that.reportType,_that.contractVersion,_that.operationId,_that.promptVersion,_that.schemaVersion,_that.generatedAtUtc,_that.sections,_that.sources,_that.warnings,_that.provider,_that.model,_that.structuredData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reportType,  String contractVersion,  String operationId,  String promptVersion,  int schemaVersion,  DateTime generatedAtUtc,  List<StorageAiReportDocumentSectionResponse> sections,  List<StorageAiReportDocumentSourceResponse> sources,  List<StorageAiReportDocumentWarningResponse> warnings,  AiProviderKind provider,  String? model,  Map<String, dynamic>? structuredData)?  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportDocumentResponse() when $default != null:
return $default(_that.reportType,_that.contractVersion,_that.operationId,_that.promptVersion,_that.schemaVersion,_that.generatedAtUtc,_that.sections,_that.sources,_that.warnings,_that.provider,_that.model,_that.structuredData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageAiReportDocumentResponse implements StorageAiReportDocumentResponse {
  const _StorageAiReportDocumentResponse({required this.reportType, required this.contractVersion, required this.operationId, required this.promptVersion, required this.schemaVersion, required this.generatedAtUtc, required this.sections, required this.sources, required this.warnings, required this.provider, this.model, this.structuredData});
  factory _StorageAiReportDocumentResponse.fromJson(Map<String, dynamic> json) => _$StorageAiReportDocumentResponseFromJson(json);

@override final  String reportType;
@override final  String contractVersion;
@override final  String operationId;
@override final  String promptVersion;
@override final  int schemaVersion;
@override final  DateTime generatedAtUtc;
@override final  List<StorageAiReportDocumentSectionResponse> sections;
@override final  List<StorageAiReportDocumentSourceResponse> sources;
@override final  List<StorageAiReportDocumentWarningResponse> warnings;
@override final  AiProviderKind provider;
@override final  String? model;
@override final  Map<String, dynamic>? structuredData;

/// Create a copy of StorageAiReportDocumentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageAiReportDocumentResponseCopyWith<_StorageAiReportDocumentResponse> get copyWith => __$StorageAiReportDocumentResponseCopyWithImpl<_StorageAiReportDocumentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageAiReportDocumentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageAiReportDocumentResponse&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.promptVersion, promptVersion) || other.promptVersion == promptVersion)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&const DeepCollectionEquality().equals(other.sections, sections)&&const DeepCollectionEquality().equals(other.sources, sources)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.structuredData, structuredData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,contractVersion,operationId,promptVersion,schemaVersion,generatedAtUtc,const DeepCollectionEquality().hash(sections),const DeepCollectionEquality().hash(sources),const DeepCollectionEquality().hash(warnings),provider,model,const DeepCollectionEquality().hash(structuredData));

@override
String toString() {
  return 'StorageAiReportDocumentResponse(reportType: $reportType, contractVersion: $contractVersion, operationId: $operationId, promptVersion: $promptVersion, schemaVersion: $schemaVersion, generatedAtUtc: $generatedAtUtc, sections: $sections, sources: $sources, warnings: $warnings, provider: $provider, model: $model, structuredData: $structuredData)';
}


}

/// @nodoc
abstract mixin class _$StorageAiReportDocumentResponseCopyWith<$Res> implements $StorageAiReportDocumentResponseCopyWith<$Res> {
  factory _$StorageAiReportDocumentResponseCopyWith(_StorageAiReportDocumentResponse value, $Res Function(_StorageAiReportDocumentResponse) _then) = __$StorageAiReportDocumentResponseCopyWithImpl;
@override @useResult
$Res call({
 String reportType, String contractVersion, String operationId, String promptVersion, int schemaVersion, DateTime generatedAtUtc, List<StorageAiReportDocumentSectionResponse> sections, List<StorageAiReportDocumentSourceResponse> sources, List<StorageAiReportDocumentWarningResponse> warnings, AiProviderKind provider, String? model, Map<String, dynamic>? structuredData
});




}
/// @nodoc
class __$StorageAiReportDocumentResponseCopyWithImpl<$Res>
    implements _$StorageAiReportDocumentResponseCopyWith<$Res> {
  __$StorageAiReportDocumentResponseCopyWithImpl(this._self, this._then);

  final _StorageAiReportDocumentResponse _self;
  final $Res Function(_StorageAiReportDocumentResponse) _then;

/// Create a copy of StorageAiReportDocumentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportType = null,Object? contractVersion = null,Object? operationId = null,Object? promptVersion = null,Object? schemaVersion = null,Object? generatedAtUtc = null,Object? sections = null,Object? sources = null,Object? warnings = null,Object? provider = null,Object? model = freezed,Object? structuredData = freezed,}) {
  return _then(_StorageAiReportDocumentResponse(
reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,promptVersion: null == promptVersion ? _self.promptVersion : promptVersion // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<StorageAiReportDocumentSectionResponse>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<StorageAiReportDocumentSourceResponse>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<StorageAiReportDocumentWarningResponse>,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,structuredData: freezed == structuredData ? _self.structuredData : structuredData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$StorageAiReportResponse {

 String get reportId; StorageAiReportScopeType get scopeType; String get workspaceId; String get projectId; String get reportType; String get contractVersion; String get promptVersion; StorageAiReportJobStatus get status; int get attemptCount; int get maxAttempts; bool get retryable; AiProviderKind? get provider; String? get outputFileId; String? get resultDocumentJson; StorageAiReportDocumentResponse? get resultDocument; List<StorageAiReportSourceResponse> get sources; DateTime get createdAtUtc; DateTime get updatedAtUtc; DateTime get deadlineAtUtc; DateTime? get nextAttemptAtUtc; DateTime? get completedAtUtc; String? get lastError; StorageAiReportFailureCode? get failureCode; String? get operationId; String? get jobId; int? get schemaVersion; String? get scopeId; String? get operationStatus; AiOperationStatus? get operationLifecycleStatus; StorageAiReportErrorResponse? get error; int? get retryAfterSeconds;
/// Create a copy of StorageAiReportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageAiReportResponseCopyWith<StorageAiReportResponse> get copyWith => _$StorageAiReportResponseCopyWithImpl<StorageAiReportResponse>(this as StorageAiReportResponse, _$identity);

  /// Serializes this StorageAiReportResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageAiReportResponse&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.scopeType, scopeType) || other.scopeType == scopeType)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.promptVersion, promptVersion) || other.promptVersion == promptVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.outputFileId, outputFileId) || other.outputFileId == outputFileId)&&(identical(other.resultDocumentJson, resultDocumentJson) || other.resultDocumentJson == resultDocumentJson)&&(identical(other.resultDocument, resultDocument) || other.resultDocument == resultDocument)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.deadlineAtUtc, deadlineAtUtc) || other.deadlineAtUtc == deadlineAtUtc)&&(identical(other.nextAttemptAtUtc, nextAttemptAtUtc) || other.nextAttemptAtUtc == nextAttemptAtUtc)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.scopeId, scopeId) || other.scopeId == scopeId)&&(identical(other.operationStatus, operationStatus) || other.operationStatus == operationStatus)&&(identical(other.operationLifecycleStatus, operationLifecycleStatus) || other.operationLifecycleStatus == operationLifecycleStatus)&&(identical(other.error, error) || other.error == error)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,reportId,scopeType,workspaceId,projectId,reportType,contractVersion,promptVersion,status,attemptCount,maxAttempts,retryable,provider,outputFileId,resultDocumentJson,resultDocument,const DeepCollectionEquality().hash(sources),createdAtUtc,updatedAtUtc,deadlineAtUtc,nextAttemptAtUtc,completedAtUtc,lastError,failureCode,operationId,jobId,schemaVersion,scopeId,operationStatus,operationLifecycleStatus,error,retryAfterSeconds]);

@override
String toString() {
  return 'StorageAiReportResponse(reportId: $reportId, scopeType: $scopeType, workspaceId: $workspaceId, projectId: $projectId, reportType: $reportType, contractVersion: $contractVersion, promptVersion: $promptVersion, status: $status, attemptCount: $attemptCount, maxAttempts: $maxAttempts, retryable: $retryable, provider: $provider, outputFileId: $outputFileId, resultDocumentJson: $resultDocumentJson, resultDocument: $resultDocument, sources: $sources, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, deadlineAtUtc: $deadlineAtUtc, nextAttemptAtUtc: $nextAttemptAtUtc, completedAtUtc: $completedAtUtc, lastError: $lastError, failureCode: $failureCode, operationId: $operationId, jobId: $jobId, schemaVersion: $schemaVersion, scopeId: $scopeId, operationStatus: $operationStatus, operationLifecycleStatus: $operationLifecycleStatus, error: $error, retryAfterSeconds: $retryAfterSeconds)';
}


}

/// @nodoc
abstract mixin class $StorageAiReportResponseCopyWith<$Res>  {
  factory $StorageAiReportResponseCopyWith(StorageAiReportResponse value, $Res Function(StorageAiReportResponse) _then) = _$StorageAiReportResponseCopyWithImpl;
@useResult
$Res call({
 String reportId, StorageAiReportScopeType scopeType, String workspaceId, String projectId, String reportType, String contractVersion, String promptVersion, StorageAiReportJobStatus status, int attemptCount, int maxAttempts, bool retryable, AiProviderKind? provider, String? outputFileId, String? resultDocumentJson, StorageAiReportDocumentResponse? resultDocument, List<StorageAiReportSourceResponse> sources, DateTime createdAtUtc, DateTime updatedAtUtc, DateTime deadlineAtUtc, DateTime? nextAttemptAtUtc, DateTime? completedAtUtc, String? lastError, StorageAiReportFailureCode? failureCode, String? operationId, String? jobId, int? schemaVersion, String? scopeId, String? operationStatus, AiOperationStatus? operationLifecycleStatus, StorageAiReportErrorResponse? error, int? retryAfterSeconds
});


$StorageAiReportDocumentResponseCopyWith<$Res>? get resultDocument;$StorageAiReportErrorResponseCopyWith<$Res>? get error;

}
/// @nodoc
class _$StorageAiReportResponseCopyWithImpl<$Res>
    implements $StorageAiReportResponseCopyWith<$Res> {
  _$StorageAiReportResponseCopyWithImpl(this._self, this._then);

  final StorageAiReportResponse _self;
  final $Res Function(StorageAiReportResponse) _then;

/// Create a copy of StorageAiReportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportId = null,Object? scopeType = null,Object? workspaceId = null,Object? projectId = null,Object? reportType = null,Object? contractVersion = null,Object? promptVersion = null,Object? status = null,Object? attemptCount = null,Object? maxAttempts = null,Object? retryable = null,Object? provider = freezed,Object? outputFileId = freezed,Object? resultDocumentJson = freezed,Object? resultDocument = freezed,Object? sources = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? deadlineAtUtc = null,Object? nextAttemptAtUtc = freezed,Object? completedAtUtc = freezed,Object? lastError = freezed,Object? failureCode = freezed,Object? operationId = freezed,Object? jobId = freezed,Object? schemaVersion = freezed,Object? scopeId = freezed,Object? operationStatus = freezed,Object? operationLifecycleStatus = freezed,Object? error = freezed,Object? retryAfterSeconds = freezed,}) {
  return _then(_self.copyWith(
reportId: null == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as String,scopeType: null == scopeType ? _self.scopeType : scopeType // ignore: cast_nullable_to_non_nullable
as StorageAiReportScopeType,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,promptVersion: null == promptVersion ? _self.promptVersion : promptVersion // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StorageAiReportJobStatus,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind?,outputFileId: freezed == outputFileId ? _self.outputFileId : outputFileId // ignore: cast_nullable_to_non_nullable
as String?,resultDocumentJson: freezed == resultDocumentJson ? _self.resultDocumentJson : resultDocumentJson // ignore: cast_nullable_to_non_nullable
as String?,resultDocument: freezed == resultDocument ? _self.resultDocument : resultDocument // ignore: cast_nullable_to_non_nullable
as StorageAiReportDocumentResponse?,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<StorageAiReportSourceResponse>,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,deadlineAtUtc: null == deadlineAtUtc ? _self.deadlineAtUtc : deadlineAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,nextAttemptAtUtc: freezed == nextAttemptAtUtc ? _self.nextAttemptAtUtc : nextAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as StorageAiReportFailureCode?,operationId: freezed == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String?,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,schemaVersion: freezed == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int?,scopeId: freezed == scopeId ? _self.scopeId : scopeId // ignore: cast_nullable_to_non_nullable
as String?,operationStatus: freezed == operationStatus ? _self.operationStatus : operationStatus // ignore: cast_nullable_to_non_nullable
as String?,operationLifecycleStatus: freezed == operationLifecycleStatus ? _self.operationLifecycleStatus : operationLifecycleStatus // ignore: cast_nullable_to_non_nullable
as AiOperationStatus?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as StorageAiReportErrorResponse?,retryAfterSeconds: freezed == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of StorageAiReportResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageAiReportDocumentResponseCopyWith<$Res>? get resultDocument {
    if (_self.resultDocument == null) {
    return null;
  }

  return $StorageAiReportDocumentResponseCopyWith<$Res>(_self.resultDocument!, (value) {
    return _then(_self.copyWith(resultDocument: value));
  });
}/// Create a copy of StorageAiReportResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageAiReportErrorResponseCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $StorageAiReportErrorResponseCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [StorageAiReportResponse].
extension StorageAiReportResponsePatterns on StorageAiReportResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageAiReportResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageAiReportResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageAiReportResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageAiReportResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reportId,  StorageAiReportScopeType scopeType,  String workspaceId,  String projectId,  String reportType,  String contractVersion,  String promptVersion,  StorageAiReportJobStatus status,  int attemptCount,  int maxAttempts,  bool retryable,  AiProviderKind? provider,  String? outputFileId,  String? resultDocumentJson,  StorageAiReportDocumentResponse? resultDocument,  List<StorageAiReportSourceResponse> sources,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime deadlineAtUtc,  DateTime? nextAttemptAtUtc,  DateTime? completedAtUtc,  String? lastError,  StorageAiReportFailureCode? failureCode,  String? operationId,  String? jobId,  int? schemaVersion,  String? scopeId,  String? operationStatus,  AiOperationStatus? operationLifecycleStatus,  StorageAiReportErrorResponse? error,  int? retryAfterSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageAiReportResponse() when $default != null:
return $default(_that.reportId,_that.scopeType,_that.workspaceId,_that.projectId,_that.reportType,_that.contractVersion,_that.promptVersion,_that.status,_that.attemptCount,_that.maxAttempts,_that.retryable,_that.provider,_that.outputFileId,_that.resultDocumentJson,_that.resultDocument,_that.sources,_that.createdAtUtc,_that.updatedAtUtc,_that.deadlineAtUtc,_that.nextAttemptAtUtc,_that.completedAtUtc,_that.lastError,_that.failureCode,_that.operationId,_that.jobId,_that.schemaVersion,_that.scopeId,_that.operationStatus,_that.operationLifecycleStatus,_that.error,_that.retryAfterSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reportId,  StorageAiReportScopeType scopeType,  String workspaceId,  String projectId,  String reportType,  String contractVersion,  String promptVersion,  StorageAiReportJobStatus status,  int attemptCount,  int maxAttempts,  bool retryable,  AiProviderKind? provider,  String? outputFileId,  String? resultDocumentJson,  StorageAiReportDocumentResponse? resultDocument,  List<StorageAiReportSourceResponse> sources,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime deadlineAtUtc,  DateTime? nextAttemptAtUtc,  DateTime? completedAtUtc,  String? lastError,  StorageAiReportFailureCode? failureCode,  String? operationId,  String? jobId,  int? schemaVersion,  String? scopeId,  String? operationStatus,  AiOperationStatus? operationLifecycleStatus,  StorageAiReportErrorResponse? error,  int? retryAfterSeconds)  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportResponse():
return $default(_that.reportId,_that.scopeType,_that.workspaceId,_that.projectId,_that.reportType,_that.contractVersion,_that.promptVersion,_that.status,_that.attemptCount,_that.maxAttempts,_that.retryable,_that.provider,_that.outputFileId,_that.resultDocumentJson,_that.resultDocument,_that.sources,_that.createdAtUtc,_that.updatedAtUtc,_that.deadlineAtUtc,_that.nextAttemptAtUtc,_that.completedAtUtc,_that.lastError,_that.failureCode,_that.operationId,_that.jobId,_that.schemaVersion,_that.scopeId,_that.operationStatus,_that.operationLifecycleStatus,_that.error,_that.retryAfterSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reportId,  StorageAiReportScopeType scopeType,  String workspaceId,  String projectId,  String reportType,  String contractVersion,  String promptVersion,  StorageAiReportJobStatus status,  int attemptCount,  int maxAttempts,  bool retryable,  AiProviderKind? provider,  String? outputFileId,  String? resultDocumentJson,  StorageAiReportDocumentResponse? resultDocument,  List<StorageAiReportSourceResponse> sources,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime deadlineAtUtc,  DateTime? nextAttemptAtUtc,  DateTime? completedAtUtc,  String? lastError,  StorageAiReportFailureCode? failureCode,  String? operationId,  String? jobId,  int? schemaVersion,  String? scopeId,  String? operationStatus,  AiOperationStatus? operationLifecycleStatus,  StorageAiReportErrorResponse? error,  int? retryAfterSeconds)?  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportResponse() when $default != null:
return $default(_that.reportId,_that.scopeType,_that.workspaceId,_that.projectId,_that.reportType,_that.contractVersion,_that.promptVersion,_that.status,_that.attemptCount,_that.maxAttempts,_that.retryable,_that.provider,_that.outputFileId,_that.resultDocumentJson,_that.resultDocument,_that.sources,_that.createdAtUtc,_that.updatedAtUtc,_that.deadlineAtUtc,_that.nextAttemptAtUtc,_that.completedAtUtc,_that.lastError,_that.failureCode,_that.operationId,_that.jobId,_that.schemaVersion,_that.scopeId,_that.operationStatus,_that.operationLifecycleStatus,_that.error,_that.retryAfterSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageAiReportResponse implements StorageAiReportResponse {
  const _StorageAiReportResponse({required this.reportId, required this.scopeType, required this.workspaceId, required this.projectId, required this.reportType, required this.contractVersion, required this.promptVersion, required this.status, required this.attemptCount, required this.maxAttempts, required this.retryable, this.provider, this.outputFileId, this.resultDocumentJson, this.resultDocument, required this.sources, required this.createdAtUtc, required this.updatedAtUtc, required this.deadlineAtUtc, this.nextAttemptAtUtc, this.completedAtUtc, this.lastError, this.failureCode, this.operationId, this.jobId, this.schemaVersion, this.scopeId, this.operationStatus, this.operationLifecycleStatus, this.error, this.retryAfterSeconds});
  factory _StorageAiReportResponse.fromJson(Map<String, dynamic> json) => _$StorageAiReportResponseFromJson(json);

@override final  String reportId;
@override final  StorageAiReportScopeType scopeType;
@override final  String workspaceId;
@override final  String projectId;
@override final  String reportType;
@override final  String contractVersion;
@override final  String promptVersion;
@override final  StorageAiReportJobStatus status;
@override final  int attemptCount;
@override final  int maxAttempts;
@override final  bool retryable;
@override final  AiProviderKind? provider;
@override final  String? outputFileId;
@override final  String? resultDocumentJson;
@override final  StorageAiReportDocumentResponse? resultDocument;
@override final  List<StorageAiReportSourceResponse> sources;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  DateTime deadlineAtUtc;
@override final  DateTime? nextAttemptAtUtc;
@override final  DateTime? completedAtUtc;
@override final  String? lastError;
@override final  StorageAiReportFailureCode? failureCode;
@override final  String? operationId;
@override final  String? jobId;
@override final  int? schemaVersion;
@override final  String? scopeId;
@override final  String? operationStatus;
@override final  AiOperationStatus? operationLifecycleStatus;
@override final  StorageAiReportErrorResponse? error;
@override final  int? retryAfterSeconds;

/// Create a copy of StorageAiReportResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageAiReportResponseCopyWith<_StorageAiReportResponse> get copyWith => __$StorageAiReportResponseCopyWithImpl<_StorageAiReportResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageAiReportResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageAiReportResponse&&(identical(other.reportId, reportId) || other.reportId == reportId)&&(identical(other.scopeType, scopeType) || other.scopeType == scopeType)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.promptVersion, promptVersion) || other.promptVersion == promptVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.outputFileId, outputFileId) || other.outputFileId == outputFileId)&&(identical(other.resultDocumentJson, resultDocumentJson) || other.resultDocumentJson == resultDocumentJson)&&(identical(other.resultDocument, resultDocument) || other.resultDocument == resultDocument)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.deadlineAtUtc, deadlineAtUtc) || other.deadlineAtUtc == deadlineAtUtc)&&(identical(other.nextAttemptAtUtc, nextAttemptAtUtc) || other.nextAttemptAtUtc == nextAttemptAtUtc)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.scopeId, scopeId) || other.scopeId == scopeId)&&(identical(other.operationStatus, operationStatus) || other.operationStatus == operationStatus)&&(identical(other.operationLifecycleStatus, operationLifecycleStatus) || other.operationLifecycleStatus == operationLifecycleStatus)&&(identical(other.error, error) || other.error == error)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,reportId,scopeType,workspaceId,projectId,reportType,contractVersion,promptVersion,status,attemptCount,maxAttempts,retryable,provider,outputFileId,resultDocumentJson,resultDocument,const DeepCollectionEquality().hash(sources),createdAtUtc,updatedAtUtc,deadlineAtUtc,nextAttemptAtUtc,completedAtUtc,lastError,failureCode,operationId,jobId,schemaVersion,scopeId,operationStatus,operationLifecycleStatus,error,retryAfterSeconds]);

@override
String toString() {
  return 'StorageAiReportResponse(reportId: $reportId, scopeType: $scopeType, workspaceId: $workspaceId, projectId: $projectId, reportType: $reportType, contractVersion: $contractVersion, promptVersion: $promptVersion, status: $status, attemptCount: $attemptCount, maxAttempts: $maxAttempts, retryable: $retryable, provider: $provider, outputFileId: $outputFileId, resultDocumentJson: $resultDocumentJson, resultDocument: $resultDocument, sources: $sources, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, deadlineAtUtc: $deadlineAtUtc, nextAttemptAtUtc: $nextAttemptAtUtc, completedAtUtc: $completedAtUtc, lastError: $lastError, failureCode: $failureCode, operationId: $operationId, jobId: $jobId, schemaVersion: $schemaVersion, scopeId: $scopeId, operationStatus: $operationStatus, operationLifecycleStatus: $operationLifecycleStatus, error: $error, retryAfterSeconds: $retryAfterSeconds)';
}


}

/// @nodoc
abstract mixin class _$StorageAiReportResponseCopyWith<$Res> implements $StorageAiReportResponseCopyWith<$Res> {
  factory _$StorageAiReportResponseCopyWith(_StorageAiReportResponse value, $Res Function(_StorageAiReportResponse) _then) = __$StorageAiReportResponseCopyWithImpl;
@override @useResult
$Res call({
 String reportId, StorageAiReportScopeType scopeType, String workspaceId, String projectId, String reportType, String contractVersion, String promptVersion, StorageAiReportJobStatus status, int attemptCount, int maxAttempts, bool retryable, AiProviderKind? provider, String? outputFileId, String? resultDocumentJson, StorageAiReportDocumentResponse? resultDocument, List<StorageAiReportSourceResponse> sources, DateTime createdAtUtc, DateTime updatedAtUtc, DateTime deadlineAtUtc, DateTime? nextAttemptAtUtc, DateTime? completedAtUtc, String? lastError, StorageAiReportFailureCode? failureCode, String? operationId, String? jobId, int? schemaVersion, String? scopeId, String? operationStatus, AiOperationStatus? operationLifecycleStatus, StorageAiReportErrorResponse? error, int? retryAfterSeconds
});


@override $StorageAiReportDocumentResponseCopyWith<$Res>? get resultDocument;@override $StorageAiReportErrorResponseCopyWith<$Res>? get error;

}
/// @nodoc
class __$StorageAiReportResponseCopyWithImpl<$Res>
    implements _$StorageAiReportResponseCopyWith<$Res> {
  __$StorageAiReportResponseCopyWithImpl(this._self, this._then);

  final _StorageAiReportResponse _self;
  final $Res Function(_StorageAiReportResponse) _then;

/// Create a copy of StorageAiReportResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportId = null,Object? scopeType = null,Object? workspaceId = null,Object? projectId = null,Object? reportType = null,Object? contractVersion = null,Object? promptVersion = null,Object? status = null,Object? attemptCount = null,Object? maxAttempts = null,Object? retryable = null,Object? provider = freezed,Object? outputFileId = freezed,Object? resultDocumentJson = freezed,Object? resultDocument = freezed,Object? sources = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? deadlineAtUtc = null,Object? nextAttemptAtUtc = freezed,Object? completedAtUtc = freezed,Object? lastError = freezed,Object? failureCode = freezed,Object? operationId = freezed,Object? jobId = freezed,Object? schemaVersion = freezed,Object? scopeId = freezed,Object? operationStatus = freezed,Object? operationLifecycleStatus = freezed,Object? error = freezed,Object? retryAfterSeconds = freezed,}) {
  return _then(_StorageAiReportResponse(
reportId: null == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as String,scopeType: null == scopeType ? _self.scopeType : scopeType // ignore: cast_nullable_to_non_nullable
as StorageAiReportScopeType,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,promptVersion: null == promptVersion ? _self.promptVersion : promptVersion // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StorageAiReportJobStatus,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind?,outputFileId: freezed == outputFileId ? _self.outputFileId : outputFileId // ignore: cast_nullable_to_non_nullable
as String?,resultDocumentJson: freezed == resultDocumentJson ? _self.resultDocumentJson : resultDocumentJson // ignore: cast_nullable_to_non_nullable
as String?,resultDocument: freezed == resultDocument ? _self.resultDocument : resultDocument // ignore: cast_nullable_to_non_nullable
as StorageAiReportDocumentResponse?,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<StorageAiReportSourceResponse>,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,deadlineAtUtc: null == deadlineAtUtc ? _self.deadlineAtUtc : deadlineAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,nextAttemptAtUtc: freezed == nextAttemptAtUtc ? _self.nextAttemptAtUtc : nextAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as StorageAiReportFailureCode?,operationId: freezed == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String?,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,schemaVersion: freezed == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int?,scopeId: freezed == scopeId ? _self.scopeId : scopeId // ignore: cast_nullable_to_non_nullable
as String?,operationStatus: freezed == operationStatus ? _self.operationStatus : operationStatus // ignore: cast_nullable_to_non_nullable
as String?,operationLifecycleStatus: freezed == operationLifecycleStatus ? _self.operationLifecycleStatus : operationLifecycleStatus // ignore: cast_nullable_to_non_nullable
as AiOperationStatus?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as StorageAiReportErrorResponse?,retryAfterSeconds: freezed == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of StorageAiReportResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageAiReportDocumentResponseCopyWith<$Res>? get resultDocument {
    if (_self.resultDocument == null) {
    return null;
  }

  return $StorageAiReportDocumentResponseCopyWith<$Res>(_self.resultDocument!, (value) {
    return _then(_self.copyWith(resultDocument: value));
  });
}/// Create a copy of StorageAiReportResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageAiReportErrorResponseCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $StorageAiReportErrorResponseCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
mixin _$StorageAiReportErrorResponse {

 String get code; String get message; bool get retryable; int? get retryAfterSeconds;
/// Create a copy of StorageAiReportErrorResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageAiReportErrorResponseCopyWith<StorageAiReportErrorResponse> get copyWith => _$StorageAiReportErrorResponseCopyWithImpl<StorageAiReportErrorResponse>(this as StorageAiReportErrorResponse, _$identity);

  /// Serializes this StorageAiReportErrorResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageAiReportErrorResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,retryable,retryAfterSeconds);

@override
String toString() {
  return 'StorageAiReportErrorResponse(code: $code, message: $message, retryable: $retryable, retryAfterSeconds: $retryAfterSeconds)';
}


}

/// @nodoc
abstract mixin class $StorageAiReportErrorResponseCopyWith<$Res>  {
  factory $StorageAiReportErrorResponseCopyWith(StorageAiReportErrorResponse value, $Res Function(StorageAiReportErrorResponse) _then) = _$StorageAiReportErrorResponseCopyWithImpl;
@useResult
$Res call({
 String code, String message, bool retryable, int? retryAfterSeconds
});




}
/// @nodoc
class _$StorageAiReportErrorResponseCopyWithImpl<$Res>
    implements $StorageAiReportErrorResponseCopyWith<$Res> {
  _$StorageAiReportErrorResponseCopyWithImpl(this._self, this._then);

  final StorageAiReportErrorResponse _self;
  final $Res Function(StorageAiReportErrorResponse) _then;

/// Create a copy of StorageAiReportErrorResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? retryable = null,Object? retryAfterSeconds = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,retryAfterSeconds: freezed == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageAiReportErrorResponse].
extension StorageAiReportErrorResponsePatterns on StorageAiReportErrorResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageAiReportErrorResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageAiReportErrorResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageAiReportErrorResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportErrorResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageAiReportErrorResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageAiReportErrorResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  bool retryable,  int? retryAfterSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageAiReportErrorResponse() when $default != null:
return $default(_that.code,_that.message,_that.retryable,_that.retryAfterSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  bool retryable,  int? retryAfterSeconds)  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportErrorResponse():
return $default(_that.code,_that.message,_that.retryable,_that.retryAfterSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  bool retryable,  int? retryAfterSeconds)?  $default,) {final _that = this;
switch (_that) {
case _StorageAiReportErrorResponse() when $default != null:
return $default(_that.code,_that.message,_that.retryable,_that.retryAfterSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageAiReportErrorResponse implements StorageAiReportErrorResponse {
  const _StorageAiReportErrorResponse({required this.code, required this.message, required this.retryable, this.retryAfterSeconds});
  factory _StorageAiReportErrorResponse.fromJson(Map<String, dynamic> json) => _$StorageAiReportErrorResponseFromJson(json);

@override final  String code;
@override final  String message;
@override final  bool retryable;
@override final  int? retryAfterSeconds;

/// Create a copy of StorageAiReportErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageAiReportErrorResponseCopyWith<_StorageAiReportErrorResponse> get copyWith => __$StorageAiReportErrorResponseCopyWithImpl<_StorageAiReportErrorResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageAiReportErrorResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageAiReportErrorResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,retryable,retryAfterSeconds);

@override
String toString() {
  return 'StorageAiReportErrorResponse(code: $code, message: $message, retryable: $retryable, retryAfterSeconds: $retryAfterSeconds)';
}


}

/// @nodoc
abstract mixin class _$StorageAiReportErrorResponseCopyWith<$Res> implements $StorageAiReportErrorResponseCopyWith<$Res> {
  factory _$StorageAiReportErrorResponseCopyWith(_StorageAiReportErrorResponse value, $Res Function(_StorageAiReportErrorResponse) _then) = __$StorageAiReportErrorResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, bool retryable, int? retryAfterSeconds
});




}
/// @nodoc
class __$StorageAiReportErrorResponseCopyWithImpl<$Res>
    implements _$StorageAiReportErrorResponseCopyWith<$Res> {
  __$StorageAiReportErrorResponseCopyWithImpl(this._self, this._then);

  final _StorageAiReportErrorResponse _self;
  final $Res Function(_StorageAiReportErrorResponse) _then;

/// Create a copy of StorageAiReportErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? retryable = null,Object? retryAfterSeconds = freezed,}) {
  return _then(_StorageAiReportErrorResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,retryAfterSeconds: freezed == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
