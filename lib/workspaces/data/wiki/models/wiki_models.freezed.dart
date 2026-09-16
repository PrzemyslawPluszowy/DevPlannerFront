// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wiki_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateWikiPagePayload {

 String? get parentPageId; String get title; String? get iconEmoji; String? get coverImageFileId; String get contentJson; int? get position;
/// Create a copy of CreateWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWikiPagePayloadCopyWith<CreateWikiPagePayload> get copyWith => _$CreateWikiPagePayloadCopyWithImpl<CreateWikiPagePayload>(this as CreateWikiPagePayload, _$identity);

  /// Serializes this CreateWikiPagePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWikiPagePayload&&(identical(other.parentPageId, parentPageId) || other.parentPageId == parentPageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.coverImageFileId, coverImageFileId) || other.coverImageFileId == coverImageFileId)&&(identical(other.contentJson, contentJson) || other.contentJson == contentJson)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,parentPageId,title,iconEmoji,coverImageFileId,contentJson,position);

@override
String toString() {
  return 'CreateWikiPagePayload(parentPageId: $parentPageId, title: $title, iconEmoji: $iconEmoji, coverImageFileId: $coverImageFileId, contentJson: $contentJson, position: $position)';
}


}

/// @nodoc
abstract mixin class $CreateWikiPagePayloadCopyWith<$Res>  {
  factory $CreateWikiPagePayloadCopyWith(CreateWikiPagePayload value, $Res Function(CreateWikiPagePayload) _then) = _$CreateWikiPagePayloadCopyWithImpl;
@useResult
$Res call({
 String? parentPageId, String title, String? iconEmoji, String? coverImageFileId, String contentJson, int? position
});




}
/// @nodoc
class _$CreateWikiPagePayloadCopyWithImpl<$Res>
    implements $CreateWikiPagePayloadCopyWith<$Res> {
  _$CreateWikiPagePayloadCopyWithImpl(this._self, this._then);

  final CreateWikiPagePayload _self;
  final $Res Function(CreateWikiPagePayload) _then;

/// Create a copy of CreateWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parentPageId = freezed,Object? title = null,Object? iconEmoji = freezed,Object? coverImageFileId = freezed,Object? contentJson = null,Object? position = freezed,}) {
  return _then(_self.copyWith(
parentPageId: freezed == parentPageId ? _self.parentPageId : parentPageId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,coverImageFileId: freezed == coverImageFileId ? _self.coverImageFileId : coverImageFileId // ignore: cast_nullable_to_non_nullable
as String?,contentJson: null == contentJson ? _self.contentJson : contentJson // ignore: cast_nullable_to_non_nullable
as String,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWikiPagePayload].
extension CreateWikiPagePayloadPatterns on CreateWikiPagePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWikiPagePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWikiPagePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWikiPagePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateWikiPagePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWikiPagePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWikiPagePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? parentPageId,  String title,  String? iconEmoji,  String? coverImageFileId,  String contentJson,  int? position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWikiPagePayload() when $default != null:
return $default(_that.parentPageId,_that.title,_that.iconEmoji,_that.coverImageFileId,_that.contentJson,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? parentPageId,  String title,  String? iconEmoji,  String? coverImageFileId,  String contentJson,  int? position)  $default,) {final _that = this;
switch (_that) {
case _CreateWikiPagePayload():
return $default(_that.parentPageId,_that.title,_that.iconEmoji,_that.coverImageFileId,_that.contentJson,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? parentPageId,  String title,  String? iconEmoji,  String? coverImageFileId,  String contentJson,  int? position)?  $default,) {final _that = this;
switch (_that) {
case _CreateWikiPagePayload() when $default != null:
return $default(_that.parentPageId,_that.title,_that.iconEmoji,_that.coverImageFileId,_that.contentJson,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWikiPagePayload implements CreateWikiPagePayload {
  const _CreateWikiPagePayload({this.parentPageId, required this.title, this.iconEmoji, this.coverImageFileId, required this.contentJson, this.position});
  factory _CreateWikiPagePayload.fromJson(Map<String, dynamic> json) => _$CreateWikiPagePayloadFromJson(json);

@override final  String? parentPageId;
@override final  String title;
@override final  String? iconEmoji;
@override final  String? coverImageFileId;
@override final  String contentJson;
@override final  int? position;

/// Create a copy of CreateWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWikiPagePayloadCopyWith<_CreateWikiPagePayload> get copyWith => __$CreateWikiPagePayloadCopyWithImpl<_CreateWikiPagePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWikiPagePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWikiPagePayload&&(identical(other.parentPageId, parentPageId) || other.parentPageId == parentPageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.coverImageFileId, coverImageFileId) || other.coverImageFileId == coverImageFileId)&&(identical(other.contentJson, contentJson) || other.contentJson == contentJson)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,parentPageId,title,iconEmoji,coverImageFileId,contentJson,position);

@override
String toString() {
  return 'CreateWikiPagePayload(parentPageId: $parentPageId, title: $title, iconEmoji: $iconEmoji, coverImageFileId: $coverImageFileId, contentJson: $contentJson, position: $position)';
}


}

/// @nodoc
abstract mixin class _$CreateWikiPagePayloadCopyWith<$Res> implements $CreateWikiPagePayloadCopyWith<$Res> {
  factory _$CreateWikiPagePayloadCopyWith(_CreateWikiPagePayload value, $Res Function(_CreateWikiPagePayload) _then) = __$CreateWikiPagePayloadCopyWithImpl;
@override @useResult
$Res call({
 String? parentPageId, String title, String? iconEmoji, String? coverImageFileId, String contentJson, int? position
});




}
/// @nodoc
class __$CreateWikiPagePayloadCopyWithImpl<$Res>
    implements _$CreateWikiPagePayloadCopyWith<$Res> {
  __$CreateWikiPagePayloadCopyWithImpl(this._self, this._then);

  final _CreateWikiPagePayload _self;
  final $Res Function(_CreateWikiPagePayload) _then;

/// Create a copy of CreateWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parentPageId = freezed,Object? title = null,Object? iconEmoji = freezed,Object? coverImageFileId = freezed,Object? contentJson = null,Object? position = freezed,}) {
  return _then(_CreateWikiPagePayload(
parentPageId: freezed == parentPageId ? _self.parentPageId : parentPageId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,coverImageFileId: freezed == coverImageFileId ? _self.coverImageFileId : coverImageFileId // ignore: cast_nullable_to_non_nullable
as String?,contentJson: null == contentJson ? _self.contentJson : contentJson // ignore: cast_nullable_to_non_nullable
as String,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$UpdateWikiPagePayload {

 String? get title; String? get iconEmoji; String? get coverImageFileId; String? get contentJson; int get expectedVersion; bool get clearIconEmoji; bool get clearCoverImage;
/// Create a copy of UpdateWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWikiPagePayloadCopyWith<UpdateWikiPagePayload> get copyWith => _$UpdateWikiPagePayloadCopyWithImpl<UpdateWikiPagePayload>(this as UpdateWikiPagePayload, _$identity);

  /// Serializes this UpdateWikiPagePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWikiPagePayload&&(identical(other.title, title) || other.title == title)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.coverImageFileId, coverImageFileId) || other.coverImageFileId == coverImageFileId)&&(identical(other.contentJson, contentJson) || other.contentJson == contentJson)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.clearIconEmoji, clearIconEmoji) || other.clearIconEmoji == clearIconEmoji)&&(identical(other.clearCoverImage, clearCoverImage) || other.clearCoverImage == clearCoverImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,iconEmoji,coverImageFileId,contentJson,expectedVersion,clearIconEmoji,clearCoverImage);

@override
String toString() {
  return 'UpdateWikiPagePayload(title: $title, iconEmoji: $iconEmoji, coverImageFileId: $coverImageFileId, contentJson: $contentJson, expectedVersion: $expectedVersion, clearIconEmoji: $clearIconEmoji, clearCoverImage: $clearCoverImage)';
}


}

/// @nodoc
abstract mixin class $UpdateWikiPagePayloadCopyWith<$Res>  {
  factory $UpdateWikiPagePayloadCopyWith(UpdateWikiPagePayload value, $Res Function(UpdateWikiPagePayload) _then) = _$UpdateWikiPagePayloadCopyWithImpl;
@useResult
$Res call({
 String? title, String? iconEmoji, String? coverImageFileId, String? contentJson, int expectedVersion, bool clearIconEmoji, bool clearCoverImage
});




}
/// @nodoc
class _$UpdateWikiPagePayloadCopyWithImpl<$Res>
    implements $UpdateWikiPagePayloadCopyWith<$Res> {
  _$UpdateWikiPagePayloadCopyWithImpl(this._self, this._then);

  final UpdateWikiPagePayload _self;
  final $Res Function(UpdateWikiPagePayload) _then;

/// Create a copy of UpdateWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? iconEmoji = freezed,Object? coverImageFileId = freezed,Object? contentJson = freezed,Object? expectedVersion = null,Object? clearIconEmoji = null,Object? clearCoverImage = null,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,coverImageFileId: freezed == coverImageFileId ? _self.coverImageFileId : coverImageFileId // ignore: cast_nullable_to_non_nullable
as String?,contentJson: freezed == contentJson ? _self.contentJson : contentJson // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,clearIconEmoji: null == clearIconEmoji ? _self.clearIconEmoji : clearIconEmoji // ignore: cast_nullable_to_non_nullable
as bool,clearCoverImage: null == clearCoverImage ? _self.clearCoverImage : clearCoverImage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWikiPagePayload].
extension UpdateWikiPagePayloadPatterns on UpdateWikiPagePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWikiPagePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWikiPagePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWikiPagePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWikiPagePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWikiPagePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWikiPagePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? iconEmoji,  String? coverImageFileId,  String? contentJson,  int expectedVersion,  bool clearIconEmoji,  bool clearCoverImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWikiPagePayload() when $default != null:
return $default(_that.title,_that.iconEmoji,_that.coverImageFileId,_that.contentJson,_that.expectedVersion,_that.clearIconEmoji,_that.clearCoverImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? iconEmoji,  String? coverImageFileId,  String? contentJson,  int expectedVersion,  bool clearIconEmoji,  bool clearCoverImage)  $default,) {final _that = this;
switch (_that) {
case _UpdateWikiPagePayload():
return $default(_that.title,_that.iconEmoji,_that.coverImageFileId,_that.contentJson,_that.expectedVersion,_that.clearIconEmoji,_that.clearCoverImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? iconEmoji,  String? coverImageFileId,  String? contentJson,  int expectedVersion,  bool clearIconEmoji,  bool clearCoverImage)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWikiPagePayload() when $default != null:
return $default(_that.title,_that.iconEmoji,_that.coverImageFileId,_that.contentJson,_that.expectedVersion,_that.clearIconEmoji,_that.clearCoverImage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWikiPagePayload implements UpdateWikiPagePayload {
  const _UpdateWikiPagePayload({this.title, this.iconEmoji, this.coverImageFileId, this.contentJson, required this.expectedVersion, this.clearIconEmoji = false, this.clearCoverImage = false});
  factory _UpdateWikiPagePayload.fromJson(Map<String, dynamic> json) => _$UpdateWikiPagePayloadFromJson(json);

@override final  String? title;
@override final  String? iconEmoji;
@override final  String? coverImageFileId;
@override final  String? contentJson;
@override final  int expectedVersion;
@override@JsonKey() final  bool clearIconEmoji;
@override@JsonKey() final  bool clearCoverImage;

/// Create a copy of UpdateWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWikiPagePayloadCopyWith<_UpdateWikiPagePayload> get copyWith => __$UpdateWikiPagePayloadCopyWithImpl<_UpdateWikiPagePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWikiPagePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWikiPagePayload&&(identical(other.title, title) || other.title == title)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.coverImageFileId, coverImageFileId) || other.coverImageFileId == coverImageFileId)&&(identical(other.contentJson, contentJson) || other.contentJson == contentJson)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.clearIconEmoji, clearIconEmoji) || other.clearIconEmoji == clearIconEmoji)&&(identical(other.clearCoverImage, clearCoverImage) || other.clearCoverImage == clearCoverImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,iconEmoji,coverImageFileId,contentJson,expectedVersion,clearIconEmoji,clearCoverImage);

@override
String toString() {
  return 'UpdateWikiPagePayload(title: $title, iconEmoji: $iconEmoji, coverImageFileId: $coverImageFileId, contentJson: $contentJson, expectedVersion: $expectedVersion, clearIconEmoji: $clearIconEmoji, clearCoverImage: $clearCoverImage)';
}


}

/// @nodoc
abstract mixin class _$UpdateWikiPagePayloadCopyWith<$Res> implements $UpdateWikiPagePayloadCopyWith<$Res> {
  factory _$UpdateWikiPagePayloadCopyWith(_UpdateWikiPagePayload value, $Res Function(_UpdateWikiPagePayload) _then) = __$UpdateWikiPagePayloadCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? iconEmoji, String? coverImageFileId, String? contentJson, int expectedVersion, bool clearIconEmoji, bool clearCoverImage
});




}
/// @nodoc
class __$UpdateWikiPagePayloadCopyWithImpl<$Res>
    implements _$UpdateWikiPagePayloadCopyWith<$Res> {
  __$UpdateWikiPagePayloadCopyWithImpl(this._self, this._then);

  final _UpdateWikiPagePayload _self;
  final $Res Function(_UpdateWikiPagePayload) _then;

/// Create a copy of UpdateWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? iconEmoji = freezed,Object? coverImageFileId = freezed,Object? contentJson = freezed,Object? expectedVersion = null,Object? clearIconEmoji = null,Object? clearCoverImage = null,}) {
  return _then(_UpdateWikiPagePayload(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,coverImageFileId: freezed == coverImageFileId ? _self.coverImageFileId : coverImageFileId // ignore: cast_nullable_to_non_nullable
as String?,contentJson: freezed == contentJson ? _self.contentJson : contentJson // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,clearIconEmoji: null == clearIconEmoji ? _self.clearIconEmoji : clearIconEmoji // ignore: cast_nullable_to_non_nullable
as bool,clearCoverImage: null == clearCoverImage ? _self.clearCoverImage : clearCoverImage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MoveWikiPagePayload {

 String? get parentPageId; int get position; int get expectedVersion;
/// Create a copy of MoveWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveWikiPagePayloadCopyWith<MoveWikiPagePayload> get copyWith => _$MoveWikiPagePayloadCopyWithImpl<MoveWikiPagePayload>(this as MoveWikiPagePayload, _$identity);

  /// Serializes this MoveWikiPagePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveWikiPagePayload&&(identical(other.parentPageId, parentPageId) || other.parentPageId == parentPageId)&&(identical(other.position, position) || other.position == position)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,parentPageId,position,expectedVersion);

@override
String toString() {
  return 'MoveWikiPagePayload(parentPageId: $parentPageId, position: $position, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $MoveWikiPagePayloadCopyWith<$Res>  {
  factory $MoveWikiPagePayloadCopyWith(MoveWikiPagePayload value, $Res Function(MoveWikiPagePayload) _then) = _$MoveWikiPagePayloadCopyWithImpl;
@useResult
$Res call({
 String? parentPageId, int position, int expectedVersion
});




}
/// @nodoc
class _$MoveWikiPagePayloadCopyWithImpl<$Res>
    implements $MoveWikiPagePayloadCopyWith<$Res> {
  _$MoveWikiPagePayloadCopyWithImpl(this._self, this._then);

  final MoveWikiPagePayload _self;
  final $Res Function(MoveWikiPagePayload) _then;

/// Create a copy of MoveWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parentPageId = freezed,Object? position = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
parentPageId: freezed == parentPageId ? _self.parentPageId : parentPageId // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MoveWikiPagePayload].
extension MoveWikiPagePayloadPatterns on MoveWikiPagePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoveWikiPagePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoveWikiPagePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoveWikiPagePayload value)  $default,){
final _that = this;
switch (_that) {
case _MoveWikiPagePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoveWikiPagePayload value)?  $default,){
final _that = this;
switch (_that) {
case _MoveWikiPagePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? parentPageId,  int position,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoveWikiPagePayload() when $default != null:
return $default(_that.parentPageId,_that.position,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? parentPageId,  int position,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _MoveWikiPagePayload():
return $default(_that.parentPageId,_that.position,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? parentPageId,  int position,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _MoveWikiPagePayload() when $default != null:
return $default(_that.parentPageId,_that.position,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoveWikiPagePayload implements MoveWikiPagePayload {
  const _MoveWikiPagePayload({this.parentPageId, required this.position, required this.expectedVersion});
  factory _MoveWikiPagePayload.fromJson(Map<String, dynamic> json) => _$MoveWikiPagePayloadFromJson(json);

@override final  String? parentPageId;
@override final  int position;
@override final  int expectedVersion;

/// Create a copy of MoveWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoveWikiPagePayloadCopyWith<_MoveWikiPagePayload> get copyWith => __$MoveWikiPagePayloadCopyWithImpl<_MoveWikiPagePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoveWikiPagePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoveWikiPagePayload&&(identical(other.parentPageId, parentPageId) || other.parentPageId == parentPageId)&&(identical(other.position, position) || other.position == position)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,parentPageId,position,expectedVersion);

@override
String toString() {
  return 'MoveWikiPagePayload(parentPageId: $parentPageId, position: $position, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$MoveWikiPagePayloadCopyWith<$Res> implements $MoveWikiPagePayloadCopyWith<$Res> {
  factory _$MoveWikiPagePayloadCopyWith(_MoveWikiPagePayload value, $Res Function(_MoveWikiPagePayload) _then) = __$MoveWikiPagePayloadCopyWithImpl;
@override @useResult
$Res call({
 String? parentPageId, int position, int expectedVersion
});




}
/// @nodoc
class __$MoveWikiPagePayloadCopyWithImpl<$Res>
    implements _$MoveWikiPagePayloadCopyWith<$Res> {
  __$MoveWikiPagePayloadCopyWithImpl(this._self, this._then);

  final _MoveWikiPagePayload _self;
  final $Res Function(_MoveWikiPagePayload) _then;

/// Create a copy of MoveWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parentPageId = freezed,Object? position = null,Object? expectedVersion = null,}) {
  return _then(_MoveWikiPagePayload(
parentPageId: freezed == parentPageId ? _self.parentPageId : parentPageId // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RestoreWikiPagePayload {

 int get expectedVersion;
/// Create a copy of RestoreWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestoreWikiPagePayloadCopyWith<RestoreWikiPagePayload> get copyWith => _$RestoreWikiPagePayloadCopyWithImpl<RestoreWikiPagePayload>(this as RestoreWikiPagePayload, _$identity);

  /// Serializes this RestoreWikiPagePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestoreWikiPagePayload&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expectedVersion);

@override
String toString() {
  return 'RestoreWikiPagePayload(expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $RestoreWikiPagePayloadCopyWith<$Res>  {
  factory $RestoreWikiPagePayloadCopyWith(RestoreWikiPagePayload value, $Res Function(RestoreWikiPagePayload) _then) = _$RestoreWikiPagePayloadCopyWithImpl;
@useResult
$Res call({
 int expectedVersion
});




}
/// @nodoc
class _$RestoreWikiPagePayloadCopyWithImpl<$Res>
    implements $RestoreWikiPagePayloadCopyWith<$Res> {
  _$RestoreWikiPagePayloadCopyWithImpl(this._self, this._then);

  final RestoreWikiPagePayload _self;
  final $Res Function(RestoreWikiPagePayload) _then;

/// Create a copy of RestoreWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RestoreWikiPagePayload].
extension RestoreWikiPagePayloadPatterns on RestoreWikiPagePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestoreWikiPagePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestoreWikiPagePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestoreWikiPagePayload value)  $default,){
final _that = this;
switch (_that) {
case _RestoreWikiPagePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestoreWikiPagePayload value)?  $default,){
final _that = this;
switch (_that) {
case _RestoreWikiPagePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestoreWikiPagePayload() when $default != null:
return $default(_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _RestoreWikiPagePayload():
return $default(_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _RestoreWikiPagePayload() when $default != null:
return $default(_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestoreWikiPagePayload implements RestoreWikiPagePayload {
  const _RestoreWikiPagePayload({required this.expectedVersion});
  factory _RestoreWikiPagePayload.fromJson(Map<String, dynamic> json) => _$RestoreWikiPagePayloadFromJson(json);

@override final  int expectedVersion;

/// Create a copy of RestoreWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestoreWikiPagePayloadCopyWith<_RestoreWikiPagePayload> get copyWith => __$RestoreWikiPagePayloadCopyWithImpl<_RestoreWikiPagePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestoreWikiPagePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestoreWikiPagePayload&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expectedVersion);

@override
String toString() {
  return 'RestoreWikiPagePayload(expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$RestoreWikiPagePayloadCopyWith<$Res> implements $RestoreWikiPagePayloadCopyWith<$Res> {
  factory _$RestoreWikiPagePayloadCopyWith(_RestoreWikiPagePayload value, $Res Function(_RestoreWikiPagePayload) _then) = __$RestoreWikiPagePayloadCopyWithImpl;
@override @useResult
$Res call({
 int expectedVersion
});




}
/// @nodoc
class __$RestoreWikiPagePayloadCopyWithImpl<$Res>
    implements _$RestoreWikiPagePayloadCopyWith<$Res> {
  __$RestoreWikiPagePayloadCopyWithImpl(this._self, this._then);

  final _RestoreWikiPagePayload _self;
  final $Res Function(_RestoreWikiPagePayload) _then;

/// Create a copy of RestoreWikiPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expectedVersion = null,}) {
  return _then(_RestoreWikiPagePayload(
expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WikiPageTreeNodeResponse {

 String get id; String? get parentPageId; String get title; String? get iconEmoji; int get position; bool get isVerified; List<WikiPageTreeNodeResponse> get children;
/// Create a copy of WikiPageTreeNodeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiPageTreeNodeResponseCopyWith<WikiPageTreeNodeResponse> get copyWith => _$WikiPageTreeNodeResponseCopyWithImpl<WikiPageTreeNodeResponse>(this as WikiPageTreeNodeResponse, _$identity);

  /// Serializes this WikiPageTreeNodeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiPageTreeNodeResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.parentPageId, parentPageId) || other.parentPageId == parentPageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.position, position) || other.position == position)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parentPageId,title,iconEmoji,position,isVerified,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'WikiPageTreeNodeResponse(id: $id, parentPageId: $parentPageId, title: $title, iconEmoji: $iconEmoji, position: $position, isVerified: $isVerified, children: $children)';
}


}

/// @nodoc
abstract mixin class $WikiPageTreeNodeResponseCopyWith<$Res>  {
  factory $WikiPageTreeNodeResponseCopyWith(WikiPageTreeNodeResponse value, $Res Function(WikiPageTreeNodeResponse) _then) = _$WikiPageTreeNodeResponseCopyWithImpl;
@useResult
$Res call({
 String id, String? parentPageId, String title, String? iconEmoji, int position, bool isVerified, List<WikiPageTreeNodeResponse> children
});




}
/// @nodoc
class _$WikiPageTreeNodeResponseCopyWithImpl<$Res>
    implements $WikiPageTreeNodeResponseCopyWith<$Res> {
  _$WikiPageTreeNodeResponseCopyWithImpl(this._self, this._then);

  final WikiPageTreeNodeResponse _self;
  final $Res Function(WikiPageTreeNodeResponse) _then;

/// Create a copy of WikiPageTreeNodeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? parentPageId = freezed,Object? title = null,Object? iconEmoji = freezed,Object? position = null,Object? isVerified = null,Object? children = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,parentPageId: freezed == parentPageId ? _self.parentPageId : parentPageId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<WikiPageTreeNodeResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiPageTreeNodeResponse].
extension WikiPageTreeNodeResponsePatterns on WikiPageTreeNodeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiPageTreeNodeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiPageTreeNodeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiPageTreeNodeResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiPageTreeNodeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiPageTreeNodeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiPageTreeNodeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? parentPageId,  String title,  String? iconEmoji,  int position,  bool isVerified,  List<WikiPageTreeNodeResponse> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiPageTreeNodeResponse() when $default != null:
return $default(_that.id,_that.parentPageId,_that.title,_that.iconEmoji,_that.position,_that.isVerified,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? parentPageId,  String title,  String? iconEmoji,  int position,  bool isVerified,  List<WikiPageTreeNodeResponse> children)  $default,) {final _that = this;
switch (_that) {
case _WikiPageTreeNodeResponse():
return $default(_that.id,_that.parentPageId,_that.title,_that.iconEmoji,_that.position,_that.isVerified,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? parentPageId,  String title,  String? iconEmoji,  int position,  bool isVerified,  List<WikiPageTreeNodeResponse> children)?  $default,) {final _that = this;
switch (_that) {
case _WikiPageTreeNodeResponse() when $default != null:
return $default(_that.id,_that.parentPageId,_that.title,_that.iconEmoji,_that.position,_that.isVerified,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiPageTreeNodeResponse implements WikiPageTreeNodeResponse {
  const _WikiPageTreeNodeResponse({required this.id, this.parentPageId, required this.title, this.iconEmoji, required this.position, required this.isVerified, required this.children});
  factory _WikiPageTreeNodeResponse.fromJson(Map<String, dynamic> json) => _$WikiPageTreeNodeResponseFromJson(json);

@override final  String id;
@override final  String? parentPageId;
@override final  String title;
@override final  String? iconEmoji;
@override final  int position;
@override final  bool isVerified;
@override final  List<WikiPageTreeNodeResponse> children;

/// Create a copy of WikiPageTreeNodeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiPageTreeNodeResponseCopyWith<_WikiPageTreeNodeResponse> get copyWith => __$WikiPageTreeNodeResponseCopyWithImpl<_WikiPageTreeNodeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiPageTreeNodeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiPageTreeNodeResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.parentPageId, parentPageId) || other.parentPageId == parentPageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.position, position) || other.position == position)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parentPageId,title,iconEmoji,position,isVerified,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'WikiPageTreeNodeResponse(id: $id, parentPageId: $parentPageId, title: $title, iconEmoji: $iconEmoji, position: $position, isVerified: $isVerified, children: $children)';
}


}

/// @nodoc
abstract mixin class _$WikiPageTreeNodeResponseCopyWith<$Res> implements $WikiPageTreeNodeResponseCopyWith<$Res> {
  factory _$WikiPageTreeNodeResponseCopyWith(_WikiPageTreeNodeResponse value, $Res Function(_WikiPageTreeNodeResponse) _then) = __$WikiPageTreeNodeResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String? parentPageId, String title, String? iconEmoji, int position, bool isVerified, List<WikiPageTreeNodeResponse> children
});




}
/// @nodoc
class __$WikiPageTreeNodeResponseCopyWithImpl<$Res>
    implements _$WikiPageTreeNodeResponseCopyWith<$Res> {
  __$WikiPageTreeNodeResponseCopyWithImpl(this._self, this._then);

  final _WikiPageTreeNodeResponse _self;
  final $Res Function(_WikiPageTreeNodeResponse) _then;

/// Create a copy of WikiPageTreeNodeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? parentPageId = freezed,Object? title = null,Object? iconEmoji = freezed,Object? position = null,Object? isVerified = null,Object? children = null,}) {
  return _then(_WikiPageTreeNodeResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,parentPageId: freezed == parentPageId ? _self.parentPageId : parentPageId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<WikiPageTreeNodeResponse>,
  ));
}


}


/// @nodoc
mixin _$WikiPageResponse {

 String get id; String get workspaceId; String? get projectId; String? get parentPageId; String get createdByUserId; String get title; String? get iconEmoji; String? get coverImageFileId; String get contentJson; int get position; bool get isVerified; String? get verifiedByUserId; DateTime? get verifiedAtUtc; int get version; DateTime get createdAtUtc; DateTime get updatedAtUtc;
/// Create a copy of WikiPageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiPageResponseCopyWith<WikiPageResponse> get copyWith => _$WikiPageResponseCopyWithImpl<WikiPageResponse>(this as WikiPageResponse, _$identity);

  /// Serializes this WikiPageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiPageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.parentPageId, parentPageId) || other.parentPageId == parentPageId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.coverImageFileId, coverImageFileId) || other.coverImageFileId == coverImageFileId)&&(identical(other.contentJson, contentJson) || other.contentJson == contentJson)&&(identical(other.position, position) || other.position == position)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.verifiedByUserId, verifiedByUserId) || other.verifiedByUserId == verifiedByUserId)&&(identical(other.verifiedAtUtc, verifiedAtUtc) || other.verifiedAtUtc == verifiedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,projectId,parentPageId,createdByUserId,title,iconEmoji,coverImageFileId,contentJson,position,isVerified,verifiedByUserId,verifiedAtUtc,version,createdAtUtc,updatedAtUtc);

@override
String toString() {
  return 'WikiPageResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, parentPageId: $parentPageId, createdByUserId: $createdByUserId, title: $title, iconEmoji: $iconEmoji, coverImageFileId: $coverImageFileId, contentJson: $contentJson, position: $position, isVerified: $isVerified, verifiedByUserId: $verifiedByUserId, verifiedAtUtc: $verifiedAtUtc, version: $version, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WikiPageResponseCopyWith<$Res>  {
  factory $WikiPageResponseCopyWith(WikiPageResponse value, $Res Function(WikiPageResponse) _then) = _$WikiPageResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String? projectId, String? parentPageId, String createdByUserId, String title, String? iconEmoji, String? coverImageFileId, String contentJson, int position, bool isVerified, String? verifiedByUserId, DateTime? verifiedAtUtc, int version, DateTime createdAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class _$WikiPageResponseCopyWithImpl<$Res>
    implements $WikiPageResponseCopyWith<$Res> {
  _$WikiPageResponseCopyWithImpl(this._self, this._then);

  final WikiPageResponse _self;
  final $Res Function(WikiPageResponse) _then;

/// Create a copy of WikiPageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = freezed,Object? parentPageId = freezed,Object? createdByUserId = null,Object? title = null,Object? iconEmoji = freezed,Object? coverImageFileId = freezed,Object? contentJson = null,Object? position = null,Object? isVerified = null,Object? verifiedByUserId = freezed,Object? verifiedAtUtc = freezed,Object? version = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,parentPageId: freezed == parentPageId ? _self.parentPageId : parentPageId // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,coverImageFileId: freezed == coverImageFileId ? _self.coverImageFileId : coverImageFileId // ignore: cast_nullable_to_non_nullable
as String?,contentJson: null == contentJson ? _self.contentJson : contentJson // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,verifiedByUserId: freezed == verifiedByUserId ? _self.verifiedByUserId : verifiedByUserId // ignore: cast_nullable_to_non_nullable
as String?,verifiedAtUtc: freezed == verifiedAtUtc ? _self.verifiedAtUtc : verifiedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiPageResponse].
extension WikiPageResponsePatterns on WikiPageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiPageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiPageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiPageResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiPageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiPageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiPageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String? projectId,  String? parentPageId,  String createdByUserId,  String title,  String? iconEmoji,  String? coverImageFileId,  String contentJson,  int position,  bool isVerified,  String? verifiedByUserId,  DateTime? verifiedAtUtc,  int version,  DateTime createdAtUtc,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiPageResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.parentPageId,_that.createdByUserId,_that.title,_that.iconEmoji,_that.coverImageFileId,_that.contentJson,_that.position,_that.isVerified,_that.verifiedByUserId,_that.verifiedAtUtc,_that.version,_that.createdAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String? projectId,  String? parentPageId,  String createdByUserId,  String title,  String? iconEmoji,  String? coverImageFileId,  String contentJson,  int position,  bool isVerified,  String? verifiedByUserId,  DateTime? verifiedAtUtc,  int version,  DateTime createdAtUtc,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WikiPageResponse():
return $default(_that.id,_that.workspaceId,_that.projectId,_that.parentPageId,_that.createdByUserId,_that.title,_that.iconEmoji,_that.coverImageFileId,_that.contentJson,_that.position,_that.isVerified,_that.verifiedByUserId,_that.verifiedAtUtc,_that.version,_that.createdAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String? projectId,  String? parentPageId,  String createdByUserId,  String title,  String? iconEmoji,  String? coverImageFileId,  String contentJson,  int position,  bool isVerified,  String? verifiedByUserId,  DateTime? verifiedAtUtc,  int version,  DateTime createdAtUtc,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WikiPageResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.parentPageId,_that.createdByUserId,_that.title,_that.iconEmoji,_that.coverImageFileId,_that.contentJson,_that.position,_that.isVerified,_that.verifiedByUserId,_that.verifiedAtUtc,_that.version,_that.createdAtUtc,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiPageResponse implements WikiPageResponse {
  const _WikiPageResponse({required this.id, required this.workspaceId, this.projectId, this.parentPageId, required this.createdByUserId, required this.title, this.iconEmoji, this.coverImageFileId, required this.contentJson, required this.position, required this.isVerified, this.verifiedByUserId, this.verifiedAtUtc, required this.version, required this.createdAtUtc, required this.updatedAtUtc});
  factory _WikiPageResponse.fromJson(Map<String, dynamic> json) => _$WikiPageResponseFromJson(json);

@override final  String id;
@override final  String workspaceId;
@override final  String? projectId;
@override final  String? parentPageId;
@override final  String createdByUserId;
@override final  String title;
@override final  String? iconEmoji;
@override final  String? coverImageFileId;
@override final  String contentJson;
@override final  int position;
@override final  bool isVerified;
@override final  String? verifiedByUserId;
@override final  DateTime? verifiedAtUtc;
@override final  int version;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;

/// Create a copy of WikiPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiPageResponseCopyWith<_WikiPageResponse> get copyWith => __$WikiPageResponseCopyWithImpl<_WikiPageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiPageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiPageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.parentPageId, parentPageId) || other.parentPageId == parentPageId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.iconEmoji, iconEmoji) || other.iconEmoji == iconEmoji)&&(identical(other.coverImageFileId, coverImageFileId) || other.coverImageFileId == coverImageFileId)&&(identical(other.contentJson, contentJson) || other.contentJson == contentJson)&&(identical(other.position, position) || other.position == position)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.verifiedByUserId, verifiedByUserId) || other.verifiedByUserId == verifiedByUserId)&&(identical(other.verifiedAtUtc, verifiedAtUtc) || other.verifiedAtUtc == verifiedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,projectId,parentPageId,createdByUserId,title,iconEmoji,coverImageFileId,contentJson,position,isVerified,verifiedByUserId,verifiedAtUtc,version,createdAtUtc,updatedAtUtc);

@override
String toString() {
  return 'WikiPageResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, parentPageId: $parentPageId, createdByUserId: $createdByUserId, title: $title, iconEmoji: $iconEmoji, coverImageFileId: $coverImageFileId, contentJson: $contentJson, position: $position, isVerified: $isVerified, verifiedByUserId: $verifiedByUserId, verifiedAtUtc: $verifiedAtUtc, version: $version, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WikiPageResponseCopyWith<$Res> implements $WikiPageResponseCopyWith<$Res> {
  factory _$WikiPageResponseCopyWith(_WikiPageResponse value, $Res Function(_WikiPageResponse) _then) = __$WikiPageResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String? projectId, String? parentPageId, String createdByUserId, String title, String? iconEmoji, String? coverImageFileId, String contentJson, int position, bool isVerified, String? verifiedByUserId, DateTime? verifiedAtUtc, int version, DateTime createdAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class __$WikiPageResponseCopyWithImpl<$Res>
    implements _$WikiPageResponseCopyWith<$Res> {
  __$WikiPageResponseCopyWithImpl(this._self, this._then);

  final _WikiPageResponse _self;
  final $Res Function(_WikiPageResponse) _then;

/// Create a copy of WikiPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = freezed,Object? parentPageId = freezed,Object? createdByUserId = null,Object? title = null,Object? iconEmoji = freezed,Object? coverImageFileId = freezed,Object? contentJson = null,Object? position = null,Object? isVerified = null,Object? verifiedByUserId = freezed,Object? verifiedAtUtc = freezed,Object? version = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,}) {
  return _then(_WikiPageResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,parentPageId: freezed == parentPageId ? _self.parentPageId : parentPageId // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,iconEmoji: freezed == iconEmoji ? _self.iconEmoji : iconEmoji // ignore: cast_nullable_to_non_nullable
as String?,coverImageFileId: freezed == coverImageFileId ? _self.coverImageFileId : coverImageFileId // ignore: cast_nullable_to_non_nullable
as String?,contentJson: null == contentJson ? _self.contentJson : contentJson // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,verifiedByUserId: freezed == verifiedByUserId ? _self.verifiedByUserId : verifiedByUserId // ignore: cast_nullable_to_non_nullable
as String?,verifiedAtUtc: freezed == verifiedAtUtc ? _self.verifiedAtUtc : verifiedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WikiPageRevisionSummaryResponse {

 String get id; String get pageId; int get version; String get createdByUserId; String get title; String get snapshotSha256; String? get changeSummary; DateTime get createdAtUtc;
/// Create a copy of WikiPageRevisionSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiPageRevisionSummaryResponseCopyWith<WikiPageRevisionSummaryResponse> get copyWith => _$WikiPageRevisionSummaryResponseCopyWithImpl<WikiPageRevisionSummaryResponse>(this as WikiPageRevisionSummaryResponse, _$identity);

  /// Serializes this WikiPageRevisionSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiPageRevisionSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.snapshotSha256, snapshotSha256) || other.snapshotSha256 == snapshotSha256)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pageId,version,createdByUserId,title,snapshotSha256,changeSummary,createdAtUtc);

@override
String toString() {
  return 'WikiPageRevisionSummaryResponse(id: $id, pageId: $pageId, version: $version, createdByUserId: $createdByUserId, title: $title, snapshotSha256: $snapshotSha256, changeSummary: $changeSummary, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $WikiPageRevisionSummaryResponseCopyWith<$Res>  {
  factory $WikiPageRevisionSummaryResponseCopyWith(WikiPageRevisionSummaryResponse value, $Res Function(WikiPageRevisionSummaryResponse) _then) = _$WikiPageRevisionSummaryResponseCopyWithImpl;
@useResult
$Res call({
 String id, String pageId, int version, String createdByUserId, String title, String snapshotSha256, String? changeSummary, DateTime createdAtUtc
});




}
/// @nodoc
class _$WikiPageRevisionSummaryResponseCopyWithImpl<$Res>
    implements $WikiPageRevisionSummaryResponseCopyWith<$Res> {
  _$WikiPageRevisionSummaryResponseCopyWithImpl(this._self, this._then);

  final WikiPageRevisionSummaryResponse _self;
  final $Res Function(WikiPageRevisionSummaryResponse) _then;

/// Create a copy of WikiPageRevisionSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pageId = null,Object? version = null,Object? createdByUserId = null,Object? title = null,Object? snapshotSha256 = null,Object? changeSummary = freezed,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,snapshotSha256: null == snapshotSha256 ? _self.snapshotSha256 : snapshotSha256 // ignore: cast_nullable_to_non_nullable
as String,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiPageRevisionSummaryResponse].
extension WikiPageRevisionSummaryResponsePatterns on WikiPageRevisionSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiPageRevisionSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiPageRevisionSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiPageRevisionSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiPageRevisionSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiPageRevisionSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiPageRevisionSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String pageId,  int version,  String createdByUserId,  String title,  String snapshotSha256,  String? changeSummary,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiPageRevisionSummaryResponse() when $default != null:
return $default(_that.id,_that.pageId,_that.version,_that.createdByUserId,_that.title,_that.snapshotSha256,_that.changeSummary,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String pageId,  int version,  String createdByUserId,  String title,  String snapshotSha256,  String? changeSummary,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WikiPageRevisionSummaryResponse():
return $default(_that.id,_that.pageId,_that.version,_that.createdByUserId,_that.title,_that.snapshotSha256,_that.changeSummary,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String pageId,  int version,  String createdByUserId,  String title,  String snapshotSha256,  String? changeSummary,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WikiPageRevisionSummaryResponse() when $default != null:
return $default(_that.id,_that.pageId,_that.version,_that.createdByUserId,_that.title,_that.snapshotSha256,_that.changeSummary,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiPageRevisionSummaryResponse implements WikiPageRevisionSummaryResponse {
  const _WikiPageRevisionSummaryResponse({required this.id, required this.pageId, required this.version, required this.createdByUserId, required this.title, required this.snapshotSha256, this.changeSummary, required this.createdAtUtc});
  factory _WikiPageRevisionSummaryResponse.fromJson(Map<String, dynamic> json) => _$WikiPageRevisionSummaryResponseFromJson(json);

@override final  String id;
@override final  String pageId;
@override final  int version;
@override final  String createdByUserId;
@override final  String title;
@override final  String snapshotSha256;
@override final  String? changeSummary;
@override final  DateTime createdAtUtc;

/// Create a copy of WikiPageRevisionSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiPageRevisionSummaryResponseCopyWith<_WikiPageRevisionSummaryResponse> get copyWith => __$WikiPageRevisionSummaryResponseCopyWithImpl<_WikiPageRevisionSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiPageRevisionSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiPageRevisionSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.snapshotSha256, snapshotSha256) || other.snapshotSha256 == snapshotSha256)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pageId,version,createdByUserId,title,snapshotSha256,changeSummary,createdAtUtc);

@override
String toString() {
  return 'WikiPageRevisionSummaryResponse(id: $id, pageId: $pageId, version: $version, createdByUserId: $createdByUserId, title: $title, snapshotSha256: $snapshotSha256, changeSummary: $changeSummary, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WikiPageRevisionSummaryResponseCopyWith<$Res> implements $WikiPageRevisionSummaryResponseCopyWith<$Res> {
  factory _$WikiPageRevisionSummaryResponseCopyWith(_WikiPageRevisionSummaryResponse value, $Res Function(_WikiPageRevisionSummaryResponse) _then) = __$WikiPageRevisionSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String pageId, int version, String createdByUserId, String title, String snapshotSha256, String? changeSummary, DateTime createdAtUtc
});




}
/// @nodoc
class __$WikiPageRevisionSummaryResponseCopyWithImpl<$Res>
    implements _$WikiPageRevisionSummaryResponseCopyWith<$Res> {
  __$WikiPageRevisionSummaryResponseCopyWithImpl(this._self, this._then);

  final _WikiPageRevisionSummaryResponse _self;
  final $Res Function(_WikiPageRevisionSummaryResponse) _then;

/// Create a copy of WikiPageRevisionSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pageId = null,Object? version = null,Object? createdByUserId = null,Object? title = null,Object? snapshotSha256 = null,Object? changeSummary = freezed,Object? createdAtUtc = null,}) {
  return _then(_WikiPageRevisionSummaryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,snapshotSha256: null == snapshotSha256 ? _self.snapshotSha256 : snapshotSha256 // ignore: cast_nullable_to_non_nullable
as String,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WikiPageRevisionResponse {

 String get id; String get pageId; int get version; String get createdByUserId; String get title; String get snapshotJson; String get snapshotSha256; String? get changeSummary; DateTime get createdAtUtc;
/// Create a copy of WikiPageRevisionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiPageRevisionResponseCopyWith<WikiPageRevisionResponse> get copyWith => _$WikiPageRevisionResponseCopyWithImpl<WikiPageRevisionResponse>(this as WikiPageRevisionResponse, _$identity);

  /// Serializes this WikiPageRevisionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiPageRevisionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.snapshotJson, snapshotJson) || other.snapshotJson == snapshotJson)&&(identical(other.snapshotSha256, snapshotSha256) || other.snapshotSha256 == snapshotSha256)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pageId,version,createdByUserId,title,snapshotJson,snapshotSha256,changeSummary,createdAtUtc);

@override
String toString() {
  return 'WikiPageRevisionResponse(id: $id, pageId: $pageId, version: $version, createdByUserId: $createdByUserId, title: $title, snapshotJson: $snapshotJson, snapshotSha256: $snapshotSha256, changeSummary: $changeSummary, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $WikiPageRevisionResponseCopyWith<$Res>  {
  factory $WikiPageRevisionResponseCopyWith(WikiPageRevisionResponse value, $Res Function(WikiPageRevisionResponse) _then) = _$WikiPageRevisionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String pageId, int version, String createdByUserId, String title, String snapshotJson, String snapshotSha256, String? changeSummary, DateTime createdAtUtc
});




}
/// @nodoc
class _$WikiPageRevisionResponseCopyWithImpl<$Res>
    implements $WikiPageRevisionResponseCopyWith<$Res> {
  _$WikiPageRevisionResponseCopyWithImpl(this._self, this._then);

  final WikiPageRevisionResponse _self;
  final $Res Function(WikiPageRevisionResponse) _then;

/// Create a copy of WikiPageRevisionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pageId = null,Object? version = null,Object? createdByUserId = null,Object? title = null,Object? snapshotJson = null,Object? snapshotSha256 = null,Object? changeSummary = freezed,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,snapshotJson: null == snapshotJson ? _self.snapshotJson : snapshotJson // ignore: cast_nullable_to_non_nullable
as String,snapshotSha256: null == snapshotSha256 ? _self.snapshotSha256 : snapshotSha256 // ignore: cast_nullable_to_non_nullable
as String,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiPageRevisionResponse].
extension WikiPageRevisionResponsePatterns on WikiPageRevisionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiPageRevisionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiPageRevisionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiPageRevisionResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiPageRevisionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiPageRevisionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiPageRevisionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String pageId,  int version,  String createdByUserId,  String title,  String snapshotJson,  String snapshotSha256,  String? changeSummary,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiPageRevisionResponse() when $default != null:
return $default(_that.id,_that.pageId,_that.version,_that.createdByUserId,_that.title,_that.snapshotJson,_that.snapshotSha256,_that.changeSummary,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String pageId,  int version,  String createdByUserId,  String title,  String snapshotJson,  String snapshotSha256,  String? changeSummary,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WikiPageRevisionResponse():
return $default(_that.id,_that.pageId,_that.version,_that.createdByUserId,_that.title,_that.snapshotJson,_that.snapshotSha256,_that.changeSummary,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String pageId,  int version,  String createdByUserId,  String title,  String snapshotJson,  String snapshotSha256,  String? changeSummary,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WikiPageRevisionResponse() when $default != null:
return $default(_that.id,_that.pageId,_that.version,_that.createdByUserId,_that.title,_that.snapshotJson,_that.snapshotSha256,_that.changeSummary,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiPageRevisionResponse implements WikiPageRevisionResponse {
  const _WikiPageRevisionResponse({required this.id, required this.pageId, required this.version, required this.createdByUserId, required this.title, required this.snapshotJson, required this.snapshotSha256, this.changeSummary, required this.createdAtUtc});
  factory _WikiPageRevisionResponse.fromJson(Map<String, dynamic> json) => _$WikiPageRevisionResponseFromJson(json);

@override final  String id;
@override final  String pageId;
@override final  int version;
@override final  String createdByUserId;
@override final  String title;
@override final  String snapshotJson;
@override final  String snapshotSha256;
@override final  String? changeSummary;
@override final  DateTime createdAtUtc;

/// Create a copy of WikiPageRevisionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiPageRevisionResponseCopyWith<_WikiPageRevisionResponse> get copyWith => __$WikiPageRevisionResponseCopyWithImpl<_WikiPageRevisionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiPageRevisionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiPageRevisionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.title, title) || other.title == title)&&(identical(other.snapshotJson, snapshotJson) || other.snapshotJson == snapshotJson)&&(identical(other.snapshotSha256, snapshotSha256) || other.snapshotSha256 == snapshotSha256)&&(identical(other.changeSummary, changeSummary) || other.changeSummary == changeSummary)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pageId,version,createdByUserId,title,snapshotJson,snapshotSha256,changeSummary,createdAtUtc);

@override
String toString() {
  return 'WikiPageRevisionResponse(id: $id, pageId: $pageId, version: $version, createdByUserId: $createdByUserId, title: $title, snapshotJson: $snapshotJson, snapshotSha256: $snapshotSha256, changeSummary: $changeSummary, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WikiPageRevisionResponseCopyWith<$Res> implements $WikiPageRevisionResponseCopyWith<$Res> {
  factory _$WikiPageRevisionResponseCopyWith(_WikiPageRevisionResponse value, $Res Function(_WikiPageRevisionResponse) _then) = __$WikiPageRevisionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String pageId, int version, String createdByUserId, String title, String snapshotJson, String snapshotSha256, String? changeSummary, DateTime createdAtUtc
});




}
/// @nodoc
class __$WikiPageRevisionResponseCopyWithImpl<$Res>
    implements _$WikiPageRevisionResponseCopyWith<$Res> {
  __$WikiPageRevisionResponseCopyWithImpl(this._self, this._then);

  final _WikiPageRevisionResponse _self;
  final $Res Function(_WikiPageRevisionResponse) _then;

/// Create a copy of WikiPageRevisionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pageId = null,Object? version = null,Object? createdByUserId = null,Object? title = null,Object? snapshotJson = null,Object? snapshotSha256 = null,Object? changeSummary = freezed,Object? createdAtUtc = null,}) {
  return _then(_WikiPageRevisionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,snapshotJson: null == snapshotJson ? _self.snapshotJson : snapshotJson // ignore: cast_nullable_to_non_nullable
as String,snapshotSha256: null == snapshotSha256 ? _self.snapshotSha256 : snapshotSha256 // ignore: cast_nullable_to_non_nullable
as String,changeSummary: freezed == changeSummary ? _self.changeSummary : changeSummary // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WikiRevisionDiffChangeResponse {

 String get path; String get changeType; String? get fromJson;/// Wartość pola `toJson` z kontraktu diffu. Nazwa Dartowa nie może
/// kolidować z generowaną metodą serializacji `toJson()` Freezed.
@JsonKey(name: 'toJson') String? get toJsonValue;
/// Create a copy of WikiRevisionDiffChangeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiRevisionDiffChangeResponseCopyWith<WikiRevisionDiffChangeResponse> get copyWith => _$WikiRevisionDiffChangeResponseCopyWithImpl<WikiRevisionDiffChangeResponse>(this as WikiRevisionDiffChangeResponse, _$identity);

  /// Serializes this WikiRevisionDiffChangeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiRevisionDiffChangeResponse&&(identical(other.path, path) || other.path == path)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&(identical(other.fromJson, fromJson) || other.fromJson == fromJson)&&(identical(other.toJsonValue, toJsonValue) || other.toJsonValue == toJsonValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,changeType,fromJson,toJsonValue);

@override
String toString() {
  return 'WikiRevisionDiffChangeResponse(path: $path, changeType: $changeType, fromJson: $fromJson, toJsonValue: $toJsonValue)';
}


}

/// @nodoc
abstract mixin class $WikiRevisionDiffChangeResponseCopyWith<$Res>  {
  factory $WikiRevisionDiffChangeResponseCopyWith(WikiRevisionDiffChangeResponse value, $Res Function(WikiRevisionDiffChangeResponse) _then) = _$WikiRevisionDiffChangeResponseCopyWithImpl;
@useResult
$Res call({
 String path, String changeType, String? fromJson,@JsonKey(name: 'toJson') String? toJsonValue
});




}
/// @nodoc
class _$WikiRevisionDiffChangeResponseCopyWithImpl<$Res>
    implements $WikiRevisionDiffChangeResponseCopyWith<$Res> {
  _$WikiRevisionDiffChangeResponseCopyWithImpl(this._self, this._then);

  final WikiRevisionDiffChangeResponse _self;
  final $Res Function(WikiRevisionDiffChangeResponse) _then;

/// Create a copy of WikiRevisionDiffChangeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? changeType = null,Object? fromJson = freezed,Object? toJsonValue = freezed,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,changeType: null == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as String,fromJson: freezed == fromJson ? _self.fromJson : fromJson // ignore: cast_nullable_to_non_nullable
as String?,toJsonValue: freezed == toJsonValue ? _self.toJsonValue : toJsonValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiRevisionDiffChangeResponse].
extension WikiRevisionDiffChangeResponsePatterns on WikiRevisionDiffChangeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiRevisionDiffChangeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiRevisionDiffChangeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiRevisionDiffChangeResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiRevisionDiffChangeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiRevisionDiffChangeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiRevisionDiffChangeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String changeType,  String? fromJson, @JsonKey(name: 'toJson')  String? toJsonValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiRevisionDiffChangeResponse() when $default != null:
return $default(_that.path,_that.changeType,_that.fromJson,_that.toJsonValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String changeType,  String? fromJson, @JsonKey(name: 'toJson')  String? toJsonValue)  $default,) {final _that = this;
switch (_that) {
case _WikiRevisionDiffChangeResponse():
return $default(_that.path,_that.changeType,_that.fromJson,_that.toJsonValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String changeType,  String? fromJson, @JsonKey(name: 'toJson')  String? toJsonValue)?  $default,) {final _that = this;
switch (_that) {
case _WikiRevisionDiffChangeResponse() when $default != null:
return $default(_that.path,_that.changeType,_that.fromJson,_that.toJsonValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiRevisionDiffChangeResponse implements WikiRevisionDiffChangeResponse {
  const _WikiRevisionDiffChangeResponse({required this.path, required this.changeType, this.fromJson, @JsonKey(name: 'toJson') this.toJsonValue});
  factory _WikiRevisionDiffChangeResponse.fromJson(Map<String, dynamic> json) => _$WikiRevisionDiffChangeResponseFromJson(json);

@override final  String path;
@override final  String changeType;
@override final  String? fromJson;
/// Wartość pola `toJson` z kontraktu diffu. Nazwa Dartowa nie może
/// kolidować z generowaną metodą serializacji `toJson()` Freezed.
@override@JsonKey(name: 'toJson') final  String? toJsonValue;

/// Create a copy of WikiRevisionDiffChangeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiRevisionDiffChangeResponseCopyWith<_WikiRevisionDiffChangeResponse> get copyWith => __$WikiRevisionDiffChangeResponseCopyWithImpl<_WikiRevisionDiffChangeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiRevisionDiffChangeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiRevisionDiffChangeResponse&&(identical(other.path, path) || other.path == path)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&(identical(other.fromJson, fromJson) || other.fromJson == fromJson)&&(identical(other.toJsonValue, toJsonValue) || other.toJsonValue == toJsonValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,changeType,fromJson,toJsonValue);

@override
String toString() {
  return 'WikiRevisionDiffChangeResponse(path: $path, changeType: $changeType, fromJson: $fromJson, toJsonValue: $toJsonValue)';
}


}

/// @nodoc
abstract mixin class _$WikiRevisionDiffChangeResponseCopyWith<$Res> implements $WikiRevisionDiffChangeResponseCopyWith<$Res> {
  factory _$WikiRevisionDiffChangeResponseCopyWith(_WikiRevisionDiffChangeResponse value, $Res Function(_WikiRevisionDiffChangeResponse) _then) = __$WikiRevisionDiffChangeResponseCopyWithImpl;
@override @useResult
$Res call({
 String path, String changeType, String? fromJson,@JsonKey(name: 'toJson') String? toJsonValue
});




}
/// @nodoc
class __$WikiRevisionDiffChangeResponseCopyWithImpl<$Res>
    implements _$WikiRevisionDiffChangeResponseCopyWith<$Res> {
  __$WikiRevisionDiffChangeResponseCopyWithImpl(this._self, this._then);

  final _WikiRevisionDiffChangeResponse _self;
  final $Res Function(_WikiRevisionDiffChangeResponse) _then;

/// Create a copy of WikiRevisionDiffChangeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? changeType = null,Object? fromJson = freezed,Object? toJsonValue = freezed,}) {
  return _then(_WikiRevisionDiffChangeResponse(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,changeType: null == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as String,fromJson: freezed == fromJson ? _self.fromJson : fromJson // ignore: cast_nullable_to_non_nullable
as String?,toJsonValue: freezed == toJsonValue ? _self.toJsonValue : toJsonValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WikiPageRevisionDiffResponse {

 String get pageId; String get fromRevisionId; int get fromVersion; String get fromTitle; DateTime get fromCreatedAtUtc; String get toRevisionId; int get toVersion; String get toTitle; DateTime get toCreatedAtUtc; bool get titleChanged; List<WikiRevisionDiffChangeResponse> get contentChanges; bool get isIdentical;
/// Create a copy of WikiPageRevisionDiffResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiPageRevisionDiffResponseCopyWith<WikiPageRevisionDiffResponse> get copyWith => _$WikiPageRevisionDiffResponseCopyWithImpl<WikiPageRevisionDiffResponse>(this as WikiPageRevisionDiffResponse, _$identity);

  /// Serializes this WikiPageRevisionDiffResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiPageRevisionDiffResponse&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.fromRevisionId, fromRevisionId) || other.fromRevisionId == fromRevisionId)&&(identical(other.fromVersion, fromVersion) || other.fromVersion == fromVersion)&&(identical(other.fromTitle, fromTitle) || other.fromTitle == fromTitle)&&(identical(other.fromCreatedAtUtc, fromCreatedAtUtc) || other.fromCreatedAtUtc == fromCreatedAtUtc)&&(identical(other.toRevisionId, toRevisionId) || other.toRevisionId == toRevisionId)&&(identical(other.toVersion, toVersion) || other.toVersion == toVersion)&&(identical(other.toTitle, toTitle) || other.toTitle == toTitle)&&(identical(other.toCreatedAtUtc, toCreatedAtUtc) || other.toCreatedAtUtc == toCreatedAtUtc)&&(identical(other.titleChanged, titleChanged) || other.titleChanged == titleChanged)&&const DeepCollectionEquality().equals(other.contentChanges, contentChanges)&&(identical(other.isIdentical, isIdentical) || other.isIdentical == isIdentical));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageId,fromRevisionId,fromVersion,fromTitle,fromCreatedAtUtc,toRevisionId,toVersion,toTitle,toCreatedAtUtc,titleChanged,const DeepCollectionEquality().hash(contentChanges),isIdentical);

@override
String toString() {
  return 'WikiPageRevisionDiffResponse(pageId: $pageId, fromRevisionId: $fromRevisionId, fromVersion: $fromVersion, fromTitle: $fromTitle, fromCreatedAtUtc: $fromCreatedAtUtc, toRevisionId: $toRevisionId, toVersion: $toVersion, toTitle: $toTitle, toCreatedAtUtc: $toCreatedAtUtc, titleChanged: $titleChanged, contentChanges: $contentChanges, isIdentical: $isIdentical)';
}


}

/// @nodoc
abstract mixin class $WikiPageRevisionDiffResponseCopyWith<$Res>  {
  factory $WikiPageRevisionDiffResponseCopyWith(WikiPageRevisionDiffResponse value, $Res Function(WikiPageRevisionDiffResponse) _then) = _$WikiPageRevisionDiffResponseCopyWithImpl;
@useResult
$Res call({
 String pageId, String fromRevisionId, int fromVersion, String fromTitle, DateTime fromCreatedAtUtc, String toRevisionId, int toVersion, String toTitle, DateTime toCreatedAtUtc, bool titleChanged, List<WikiRevisionDiffChangeResponse> contentChanges, bool isIdentical
});




}
/// @nodoc
class _$WikiPageRevisionDiffResponseCopyWithImpl<$Res>
    implements $WikiPageRevisionDiffResponseCopyWith<$Res> {
  _$WikiPageRevisionDiffResponseCopyWithImpl(this._self, this._then);

  final WikiPageRevisionDiffResponse _self;
  final $Res Function(WikiPageRevisionDiffResponse) _then;

/// Create a copy of WikiPageRevisionDiffResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageId = null,Object? fromRevisionId = null,Object? fromVersion = null,Object? fromTitle = null,Object? fromCreatedAtUtc = null,Object? toRevisionId = null,Object? toVersion = null,Object? toTitle = null,Object? toCreatedAtUtc = null,Object? titleChanged = null,Object? contentChanges = null,Object? isIdentical = null,}) {
  return _then(_self.copyWith(
pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,fromRevisionId: null == fromRevisionId ? _self.fromRevisionId : fromRevisionId // ignore: cast_nullable_to_non_nullable
as String,fromVersion: null == fromVersion ? _self.fromVersion : fromVersion // ignore: cast_nullable_to_non_nullable
as int,fromTitle: null == fromTitle ? _self.fromTitle : fromTitle // ignore: cast_nullable_to_non_nullable
as String,fromCreatedAtUtc: null == fromCreatedAtUtc ? _self.fromCreatedAtUtc : fromCreatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,toRevisionId: null == toRevisionId ? _self.toRevisionId : toRevisionId // ignore: cast_nullable_to_non_nullable
as String,toVersion: null == toVersion ? _self.toVersion : toVersion // ignore: cast_nullable_to_non_nullable
as int,toTitle: null == toTitle ? _self.toTitle : toTitle // ignore: cast_nullable_to_non_nullable
as String,toCreatedAtUtc: null == toCreatedAtUtc ? _self.toCreatedAtUtc : toCreatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,titleChanged: null == titleChanged ? _self.titleChanged : titleChanged // ignore: cast_nullable_to_non_nullable
as bool,contentChanges: null == contentChanges ? _self.contentChanges : contentChanges // ignore: cast_nullable_to_non_nullable
as List<WikiRevisionDiffChangeResponse>,isIdentical: null == isIdentical ? _self.isIdentical : isIdentical // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiPageRevisionDiffResponse].
extension WikiPageRevisionDiffResponsePatterns on WikiPageRevisionDiffResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiPageRevisionDiffResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiPageRevisionDiffResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiPageRevisionDiffResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiPageRevisionDiffResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiPageRevisionDiffResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiPageRevisionDiffResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pageId,  String fromRevisionId,  int fromVersion,  String fromTitle,  DateTime fromCreatedAtUtc,  String toRevisionId,  int toVersion,  String toTitle,  DateTime toCreatedAtUtc,  bool titleChanged,  List<WikiRevisionDiffChangeResponse> contentChanges,  bool isIdentical)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiPageRevisionDiffResponse() when $default != null:
return $default(_that.pageId,_that.fromRevisionId,_that.fromVersion,_that.fromTitle,_that.fromCreatedAtUtc,_that.toRevisionId,_that.toVersion,_that.toTitle,_that.toCreatedAtUtc,_that.titleChanged,_that.contentChanges,_that.isIdentical);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pageId,  String fromRevisionId,  int fromVersion,  String fromTitle,  DateTime fromCreatedAtUtc,  String toRevisionId,  int toVersion,  String toTitle,  DateTime toCreatedAtUtc,  bool titleChanged,  List<WikiRevisionDiffChangeResponse> contentChanges,  bool isIdentical)  $default,) {final _that = this;
switch (_that) {
case _WikiPageRevisionDiffResponse():
return $default(_that.pageId,_that.fromRevisionId,_that.fromVersion,_that.fromTitle,_that.fromCreatedAtUtc,_that.toRevisionId,_that.toVersion,_that.toTitle,_that.toCreatedAtUtc,_that.titleChanged,_that.contentChanges,_that.isIdentical);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pageId,  String fromRevisionId,  int fromVersion,  String fromTitle,  DateTime fromCreatedAtUtc,  String toRevisionId,  int toVersion,  String toTitle,  DateTime toCreatedAtUtc,  bool titleChanged,  List<WikiRevisionDiffChangeResponse> contentChanges,  bool isIdentical)?  $default,) {final _that = this;
switch (_that) {
case _WikiPageRevisionDiffResponse() when $default != null:
return $default(_that.pageId,_that.fromRevisionId,_that.fromVersion,_that.fromTitle,_that.fromCreatedAtUtc,_that.toRevisionId,_that.toVersion,_that.toTitle,_that.toCreatedAtUtc,_that.titleChanged,_that.contentChanges,_that.isIdentical);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiPageRevisionDiffResponse implements WikiPageRevisionDiffResponse {
  const _WikiPageRevisionDiffResponse({required this.pageId, required this.fromRevisionId, required this.fromVersion, required this.fromTitle, required this.fromCreatedAtUtc, required this.toRevisionId, required this.toVersion, required this.toTitle, required this.toCreatedAtUtc, required this.titleChanged, required this.contentChanges, required this.isIdentical});
  factory _WikiPageRevisionDiffResponse.fromJson(Map<String, dynamic> json) => _$WikiPageRevisionDiffResponseFromJson(json);

@override final  String pageId;
@override final  String fromRevisionId;
@override final  int fromVersion;
@override final  String fromTitle;
@override final  DateTime fromCreatedAtUtc;
@override final  String toRevisionId;
@override final  int toVersion;
@override final  String toTitle;
@override final  DateTime toCreatedAtUtc;
@override final  bool titleChanged;
@override final  List<WikiRevisionDiffChangeResponse> contentChanges;
@override final  bool isIdentical;

/// Create a copy of WikiPageRevisionDiffResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiPageRevisionDiffResponseCopyWith<_WikiPageRevisionDiffResponse> get copyWith => __$WikiPageRevisionDiffResponseCopyWithImpl<_WikiPageRevisionDiffResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiPageRevisionDiffResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiPageRevisionDiffResponse&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.fromRevisionId, fromRevisionId) || other.fromRevisionId == fromRevisionId)&&(identical(other.fromVersion, fromVersion) || other.fromVersion == fromVersion)&&(identical(other.fromTitle, fromTitle) || other.fromTitle == fromTitle)&&(identical(other.fromCreatedAtUtc, fromCreatedAtUtc) || other.fromCreatedAtUtc == fromCreatedAtUtc)&&(identical(other.toRevisionId, toRevisionId) || other.toRevisionId == toRevisionId)&&(identical(other.toVersion, toVersion) || other.toVersion == toVersion)&&(identical(other.toTitle, toTitle) || other.toTitle == toTitle)&&(identical(other.toCreatedAtUtc, toCreatedAtUtc) || other.toCreatedAtUtc == toCreatedAtUtc)&&(identical(other.titleChanged, titleChanged) || other.titleChanged == titleChanged)&&const DeepCollectionEquality().equals(other.contentChanges, contentChanges)&&(identical(other.isIdentical, isIdentical) || other.isIdentical == isIdentical));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageId,fromRevisionId,fromVersion,fromTitle,fromCreatedAtUtc,toRevisionId,toVersion,toTitle,toCreatedAtUtc,titleChanged,const DeepCollectionEquality().hash(contentChanges),isIdentical);

@override
String toString() {
  return 'WikiPageRevisionDiffResponse(pageId: $pageId, fromRevisionId: $fromRevisionId, fromVersion: $fromVersion, fromTitle: $fromTitle, fromCreatedAtUtc: $fromCreatedAtUtc, toRevisionId: $toRevisionId, toVersion: $toVersion, toTitle: $toTitle, toCreatedAtUtc: $toCreatedAtUtc, titleChanged: $titleChanged, contentChanges: $contentChanges, isIdentical: $isIdentical)';
}


}

/// @nodoc
abstract mixin class _$WikiPageRevisionDiffResponseCopyWith<$Res> implements $WikiPageRevisionDiffResponseCopyWith<$Res> {
  factory _$WikiPageRevisionDiffResponseCopyWith(_WikiPageRevisionDiffResponse value, $Res Function(_WikiPageRevisionDiffResponse) _then) = __$WikiPageRevisionDiffResponseCopyWithImpl;
@override @useResult
$Res call({
 String pageId, String fromRevisionId, int fromVersion, String fromTitle, DateTime fromCreatedAtUtc, String toRevisionId, int toVersion, String toTitle, DateTime toCreatedAtUtc, bool titleChanged, List<WikiRevisionDiffChangeResponse> contentChanges, bool isIdentical
});




}
/// @nodoc
class __$WikiPageRevisionDiffResponseCopyWithImpl<$Res>
    implements _$WikiPageRevisionDiffResponseCopyWith<$Res> {
  __$WikiPageRevisionDiffResponseCopyWithImpl(this._self, this._then);

  final _WikiPageRevisionDiffResponse _self;
  final $Res Function(_WikiPageRevisionDiffResponse) _then;

/// Create a copy of WikiPageRevisionDiffResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageId = null,Object? fromRevisionId = null,Object? fromVersion = null,Object? fromTitle = null,Object? fromCreatedAtUtc = null,Object? toRevisionId = null,Object? toVersion = null,Object? toTitle = null,Object? toCreatedAtUtc = null,Object? titleChanged = null,Object? contentChanges = null,Object? isIdentical = null,}) {
  return _then(_WikiPageRevisionDiffResponse(
pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,fromRevisionId: null == fromRevisionId ? _self.fromRevisionId : fromRevisionId // ignore: cast_nullable_to_non_nullable
as String,fromVersion: null == fromVersion ? _self.fromVersion : fromVersion // ignore: cast_nullable_to_non_nullable
as int,fromTitle: null == fromTitle ? _self.fromTitle : fromTitle // ignore: cast_nullable_to_non_nullable
as String,fromCreatedAtUtc: null == fromCreatedAtUtc ? _self.fromCreatedAtUtc : fromCreatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,toRevisionId: null == toRevisionId ? _self.toRevisionId : toRevisionId // ignore: cast_nullable_to_non_nullable
as String,toVersion: null == toVersion ? _self.toVersion : toVersion // ignore: cast_nullable_to_non_nullable
as int,toTitle: null == toTitle ? _self.toTitle : toTitle // ignore: cast_nullable_to_non_nullable
as String,toCreatedAtUtc: null == toCreatedAtUtc ? _self.toCreatedAtUtc : toCreatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,titleChanged: null == titleChanged ? _self.titleChanged : titleChanged // ignore: cast_nullable_to_non_nullable
as bool,contentChanges: null == contentChanges ? _self.contentChanges : contentChanges // ignore: cast_nullable_to_non_nullable
as List<WikiRevisionDiffChangeResponse>,isIdentical: null == isIdentical ? _self.isIdentical : isIdentical // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ConvertWikiSelectionToTaskPayload {

 String get selectionText; String? get blockId; int? get textStart; int? get textEnd; String? get title; String? get description; TaskPriority get priority; DateTime? get dueAtUtc; List<String>? get checklistItems;
/// Create a copy of ConvertWikiSelectionToTaskPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConvertWikiSelectionToTaskPayloadCopyWith<ConvertWikiSelectionToTaskPayload> get copyWith => _$ConvertWikiSelectionToTaskPayloadCopyWithImpl<ConvertWikiSelectionToTaskPayload>(this as ConvertWikiSelectionToTaskPayload, _$identity);

  /// Serializes this ConvertWikiSelectionToTaskPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConvertWikiSelectionToTaskPayload&&(identical(other.selectionText, selectionText) || other.selectionText == selectionText)&&(identical(other.blockId, blockId) || other.blockId == blockId)&&(identical(other.textStart, textStart) || other.textStart == textStart)&&(identical(other.textEnd, textEnd) || other.textEnd == textEnd)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectionText,blockId,textStart,textEnd,title,description,priority,dueAtUtc,const DeepCollectionEquality().hash(checklistItems));

@override
String toString() {
  return 'ConvertWikiSelectionToTaskPayload(selectionText: $selectionText, blockId: $blockId, textStart: $textStart, textEnd: $textEnd, title: $title, description: $description, priority: $priority, dueAtUtc: $dueAtUtc, checklistItems: $checklistItems)';
}


}

/// @nodoc
abstract mixin class $ConvertWikiSelectionToTaskPayloadCopyWith<$Res>  {
  factory $ConvertWikiSelectionToTaskPayloadCopyWith(ConvertWikiSelectionToTaskPayload value, $Res Function(ConvertWikiSelectionToTaskPayload) _then) = _$ConvertWikiSelectionToTaskPayloadCopyWithImpl;
@useResult
$Res call({
 String selectionText, String? blockId, int? textStart, int? textEnd, String? title, String? description, TaskPriority priority, DateTime? dueAtUtc, List<String>? checklistItems
});




}
/// @nodoc
class _$ConvertWikiSelectionToTaskPayloadCopyWithImpl<$Res>
    implements $ConvertWikiSelectionToTaskPayloadCopyWith<$Res> {
  _$ConvertWikiSelectionToTaskPayloadCopyWithImpl(this._self, this._then);

  final ConvertWikiSelectionToTaskPayload _self;
  final $Res Function(ConvertWikiSelectionToTaskPayload) _then;

/// Create a copy of ConvertWikiSelectionToTaskPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectionText = null,Object? blockId = freezed,Object? textStart = freezed,Object? textEnd = freezed,Object? title = freezed,Object? description = freezed,Object? priority = null,Object? dueAtUtc = freezed,Object? checklistItems = freezed,}) {
  return _then(_self.copyWith(
selectionText: null == selectionText ? _self.selectionText : selectionText // ignore: cast_nullable_to_non_nullable
as String,blockId: freezed == blockId ? _self.blockId : blockId // ignore: cast_nullable_to_non_nullable
as String?,textStart: freezed == textStart ? _self.textStart : textStart // ignore: cast_nullable_to_non_nullable
as int?,textEnd: freezed == textEnd ? _self.textEnd : textEnd // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,checklistItems: freezed == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConvertWikiSelectionToTaskPayload].
extension ConvertWikiSelectionToTaskPayloadPatterns on ConvertWikiSelectionToTaskPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConvertWikiSelectionToTaskPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConvertWikiSelectionToTaskPayload value)  $default,){
final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConvertWikiSelectionToTaskPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String selectionText,  String? blockId,  int? textStart,  int? textEnd,  String? title,  String? description,  TaskPriority priority,  DateTime? dueAtUtc,  List<String>? checklistItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskPayload() when $default != null:
return $default(_that.selectionText,_that.blockId,_that.textStart,_that.textEnd,_that.title,_that.description,_that.priority,_that.dueAtUtc,_that.checklistItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String selectionText,  String? blockId,  int? textStart,  int? textEnd,  String? title,  String? description,  TaskPriority priority,  DateTime? dueAtUtc,  List<String>? checklistItems)  $default,) {final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskPayload():
return $default(_that.selectionText,_that.blockId,_that.textStart,_that.textEnd,_that.title,_that.description,_that.priority,_that.dueAtUtc,_that.checklistItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String selectionText,  String? blockId,  int? textStart,  int? textEnd,  String? title,  String? description,  TaskPriority priority,  DateTime? dueAtUtc,  List<String>? checklistItems)?  $default,) {final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskPayload() when $default != null:
return $default(_that.selectionText,_that.blockId,_that.textStart,_that.textEnd,_that.title,_that.description,_that.priority,_that.dueAtUtc,_that.checklistItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConvertWikiSelectionToTaskPayload implements ConvertWikiSelectionToTaskPayload {
  const _ConvertWikiSelectionToTaskPayload({required this.selectionText, this.blockId, this.textStart, this.textEnd, this.title, this.description, this.priority = TaskPriority.normal, this.dueAtUtc, this.checklistItems});
  factory _ConvertWikiSelectionToTaskPayload.fromJson(Map<String, dynamic> json) => _$ConvertWikiSelectionToTaskPayloadFromJson(json);

@override final  String selectionText;
@override final  String? blockId;
@override final  int? textStart;
@override final  int? textEnd;
@override final  String? title;
@override final  String? description;
@override@JsonKey() final  TaskPriority priority;
@override final  DateTime? dueAtUtc;
@override final  List<String>? checklistItems;

/// Create a copy of ConvertWikiSelectionToTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConvertWikiSelectionToTaskPayloadCopyWith<_ConvertWikiSelectionToTaskPayload> get copyWith => __$ConvertWikiSelectionToTaskPayloadCopyWithImpl<_ConvertWikiSelectionToTaskPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConvertWikiSelectionToTaskPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConvertWikiSelectionToTaskPayload&&(identical(other.selectionText, selectionText) || other.selectionText == selectionText)&&(identical(other.blockId, blockId) || other.blockId == blockId)&&(identical(other.textStart, textStart) || other.textStart == textStart)&&(identical(other.textEnd, textEnd) || other.textEnd == textEnd)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectionText,blockId,textStart,textEnd,title,description,priority,dueAtUtc,const DeepCollectionEquality().hash(checklistItems));

@override
String toString() {
  return 'ConvertWikiSelectionToTaskPayload(selectionText: $selectionText, blockId: $blockId, textStart: $textStart, textEnd: $textEnd, title: $title, description: $description, priority: $priority, dueAtUtc: $dueAtUtc, checklistItems: $checklistItems)';
}


}

/// @nodoc
abstract mixin class _$ConvertWikiSelectionToTaskPayloadCopyWith<$Res> implements $ConvertWikiSelectionToTaskPayloadCopyWith<$Res> {
  factory _$ConvertWikiSelectionToTaskPayloadCopyWith(_ConvertWikiSelectionToTaskPayload value, $Res Function(_ConvertWikiSelectionToTaskPayload) _then) = __$ConvertWikiSelectionToTaskPayloadCopyWithImpl;
@override @useResult
$Res call({
 String selectionText, String? blockId, int? textStart, int? textEnd, String? title, String? description, TaskPriority priority, DateTime? dueAtUtc, List<String>? checklistItems
});




}
/// @nodoc
class __$ConvertWikiSelectionToTaskPayloadCopyWithImpl<$Res>
    implements _$ConvertWikiSelectionToTaskPayloadCopyWith<$Res> {
  __$ConvertWikiSelectionToTaskPayloadCopyWithImpl(this._self, this._then);

  final _ConvertWikiSelectionToTaskPayload _self;
  final $Res Function(_ConvertWikiSelectionToTaskPayload) _then;

/// Create a copy of ConvertWikiSelectionToTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectionText = null,Object? blockId = freezed,Object? textStart = freezed,Object? textEnd = freezed,Object? title = freezed,Object? description = freezed,Object? priority = null,Object? dueAtUtc = freezed,Object? checklistItems = freezed,}) {
  return _then(_ConvertWikiSelectionToTaskPayload(
selectionText: null == selectionText ? _self.selectionText : selectionText // ignore: cast_nullable_to_non_nullable
as String,blockId: freezed == blockId ? _self.blockId : blockId // ignore: cast_nullable_to_non_nullable
as String?,textStart: freezed == textStart ? _self.textStart : textStart // ignore: cast_nullable_to_non_nullable
as int?,textEnd: freezed == textEnd ? _self.textEnd : textEnd // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,checklistItems: freezed == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$WikiProjectTaskReferenceResponse {

 String get id; int get number; String get key; String get title; String get status; DateTime? get archivedAtUtc; int get version;
/// Create a copy of WikiProjectTaskReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiProjectTaskReferenceResponseCopyWith<WikiProjectTaskReferenceResponse> get copyWith => _$WikiProjectTaskReferenceResponseCopyWithImpl<WikiProjectTaskReferenceResponse>(this as WikiProjectTaskReferenceResponse, _$identity);

  /// Serializes this WikiProjectTaskReferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiProjectTaskReferenceResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,title,status,archivedAtUtc,version);

@override
String toString() {
  return 'WikiProjectTaskReferenceResponse(id: $id, number: $number, key: $key, title: $title, status: $status, archivedAtUtc: $archivedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $WikiProjectTaskReferenceResponseCopyWith<$Res>  {
  factory $WikiProjectTaskReferenceResponseCopyWith(WikiProjectTaskReferenceResponse value, $Res Function(WikiProjectTaskReferenceResponse) _then) = _$WikiProjectTaskReferenceResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String title, String status, DateTime? archivedAtUtc, int version
});




}
/// @nodoc
class _$WikiProjectTaskReferenceResponseCopyWithImpl<$Res>
    implements $WikiProjectTaskReferenceResponseCopyWith<$Res> {
  _$WikiProjectTaskReferenceResponseCopyWithImpl(this._self, this._then);

  final WikiProjectTaskReferenceResponse _self;
  final $Res Function(WikiProjectTaskReferenceResponse) _then;

/// Create a copy of WikiProjectTaskReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? title = null,Object? status = null,Object? archivedAtUtc = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiProjectTaskReferenceResponse].
extension WikiProjectTaskReferenceResponsePatterns on WikiProjectTaskReferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiProjectTaskReferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiProjectTaskReferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiProjectTaskReferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiProjectTaskReferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiProjectTaskReferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiProjectTaskReferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String title,  String status,  DateTime? archivedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiProjectTaskReferenceResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.archivedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String title,  String status,  DateTime? archivedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _WikiProjectTaskReferenceResponse():
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.archivedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String title,  String status,  DateTime? archivedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _WikiProjectTaskReferenceResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.archivedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiProjectTaskReferenceResponse implements WikiProjectTaskReferenceResponse {
  const _WikiProjectTaskReferenceResponse({required this.id, required this.number, required this.key, required this.title, required this.status, this.archivedAtUtc, required this.version});
  factory _WikiProjectTaskReferenceResponse.fromJson(Map<String, dynamic> json) => _$WikiProjectTaskReferenceResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String key;
@override final  String title;
@override final  String status;
@override final  DateTime? archivedAtUtc;
@override final  int version;

/// Create a copy of WikiProjectTaskReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiProjectTaskReferenceResponseCopyWith<_WikiProjectTaskReferenceResponse> get copyWith => __$WikiProjectTaskReferenceResponseCopyWithImpl<_WikiProjectTaskReferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiProjectTaskReferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiProjectTaskReferenceResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,title,status,archivedAtUtc,version);

@override
String toString() {
  return 'WikiProjectTaskReferenceResponse(id: $id, number: $number, key: $key, title: $title, status: $status, archivedAtUtc: $archivedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$WikiProjectTaskReferenceResponseCopyWith<$Res> implements $WikiProjectTaskReferenceResponseCopyWith<$Res> {
  factory _$WikiProjectTaskReferenceResponseCopyWith(_WikiProjectTaskReferenceResponse value, $Res Function(_WikiProjectTaskReferenceResponse) _then) = __$WikiProjectTaskReferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String title, String status, DateTime? archivedAtUtc, int version
});




}
/// @nodoc
class __$WikiProjectTaskReferenceResponseCopyWithImpl<$Res>
    implements _$WikiProjectTaskReferenceResponseCopyWith<$Res> {
  __$WikiProjectTaskReferenceResponseCopyWithImpl(this._self, this._then);

  final _WikiProjectTaskReferenceResponse _self;
  final $Res Function(_WikiProjectTaskReferenceResponse) _then;

/// Create a copy of WikiProjectTaskReferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? title = null,Object? status = null,Object? archivedAtUtc = freezed,Object? version = null,}) {
  return _then(_WikiProjectTaskReferenceResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WikiPageTaskLinkResponse {

 String get id; String get pageId; String get taskId; String get selectionText; String? get blockId; int? get textStart; int? get textEnd; DateTime get createdAtUtc; WikiProjectTaskReferenceResponse get task;
/// Create a copy of WikiPageTaskLinkResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiPageTaskLinkResponseCopyWith<WikiPageTaskLinkResponse> get copyWith => _$WikiPageTaskLinkResponseCopyWithImpl<WikiPageTaskLinkResponse>(this as WikiPageTaskLinkResponse, _$identity);

  /// Serializes this WikiPageTaskLinkResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiPageTaskLinkResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.selectionText, selectionText) || other.selectionText == selectionText)&&(identical(other.blockId, blockId) || other.blockId == blockId)&&(identical(other.textStart, textStart) || other.textStart == textStart)&&(identical(other.textEnd, textEnd) || other.textEnd == textEnd)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.task, task) || other.task == task));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pageId,taskId,selectionText,blockId,textStart,textEnd,createdAtUtc,task);

@override
String toString() {
  return 'WikiPageTaskLinkResponse(id: $id, pageId: $pageId, taskId: $taskId, selectionText: $selectionText, blockId: $blockId, textStart: $textStart, textEnd: $textEnd, createdAtUtc: $createdAtUtc, task: $task)';
}


}

/// @nodoc
abstract mixin class $WikiPageTaskLinkResponseCopyWith<$Res>  {
  factory $WikiPageTaskLinkResponseCopyWith(WikiPageTaskLinkResponse value, $Res Function(WikiPageTaskLinkResponse) _then) = _$WikiPageTaskLinkResponseCopyWithImpl;
@useResult
$Res call({
 String id, String pageId, String taskId, String selectionText, String? blockId, int? textStart, int? textEnd, DateTime createdAtUtc, WikiProjectTaskReferenceResponse task
});


$WikiProjectTaskReferenceResponseCopyWith<$Res> get task;

}
/// @nodoc
class _$WikiPageTaskLinkResponseCopyWithImpl<$Res>
    implements $WikiPageTaskLinkResponseCopyWith<$Res> {
  _$WikiPageTaskLinkResponseCopyWithImpl(this._self, this._then);

  final WikiPageTaskLinkResponse _self;
  final $Res Function(WikiPageTaskLinkResponse) _then;

/// Create a copy of WikiPageTaskLinkResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pageId = null,Object? taskId = null,Object? selectionText = null,Object? blockId = freezed,Object? textStart = freezed,Object? textEnd = freezed,Object? createdAtUtc = null,Object? task = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,selectionText: null == selectionText ? _self.selectionText : selectionText // ignore: cast_nullable_to_non_nullable
as String,blockId: freezed == blockId ? _self.blockId : blockId // ignore: cast_nullable_to_non_nullable
as String?,textStart: freezed == textStart ? _self.textStart : textStart // ignore: cast_nullable_to_non_nullable
as int?,textEnd: freezed == textEnd ? _self.textEnd : textEnd // ignore: cast_nullable_to_non_nullable
as int?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as WikiProjectTaskReferenceResponse,
  ));
}
/// Create a copy of WikiPageTaskLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WikiProjectTaskReferenceResponseCopyWith<$Res> get task {
  
  return $WikiProjectTaskReferenceResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [WikiPageTaskLinkResponse].
extension WikiPageTaskLinkResponsePatterns on WikiPageTaskLinkResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiPageTaskLinkResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiPageTaskLinkResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiPageTaskLinkResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiPageTaskLinkResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiPageTaskLinkResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiPageTaskLinkResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String pageId,  String taskId,  String selectionText,  String? blockId,  int? textStart,  int? textEnd,  DateTime createdAtUtc,  WikiProjectTaskReferenceResponse task)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiPageTaskLinkResponse() when $default != null:
return $default(_that.id,_that.pageId,_that.taskId,_that.selectionText,_that.blockId,_that.textStart,_that.textEnd,_that.createdAtUtc,_that.task);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String pageId,  String taskId,  String selectionText,  String? blockId,  int? textStart,  int? textEnd,  DateTime createdAtUtc,  WikiProjectTaskReferenceResponse task)  $default,) {final _that = this;
switch (_that) {
case _WikiPageTaskLinkResponse():
return $default(_that.id,_that.pageId,_that.taskId,_that.selectionText,_that.blockId,_that.textStart,_that.textEnd,_that.createdAtUtc,_that.task);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String pageId,  String taskId,  String selectionText,  String? blockId,  int? textStart,  int? textEnd,  DateTime createdAtUtc,  WikiProjectTaskReferenceResponse task)?  $default,) {final _that = this;
switch (_that) {
case _WikiPageTaskLinkResponse() when $default != null:
return $default(_that.id,_that.pageId,_that.taskId,_that.selectionText,_that.blockId,_that.textStart,_that.textEnd,_that.createdAtUtc,_that.task);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiPageTaskLinkResponse implements WikiPageTaskLinkResponse {
  const _WikiPageTaskLinkResponse({required this.id, required this.pageId, required this.taskId, required this.selectionText, this.blockId, this.textStart, this.textEnd, required this.createdAtUtc, required this.task});
  factory _WikiPageTaskLinkResponse.fromJson(Map<String, dynamic> json) => _$WikiPageTaskLinkResponseFromJson(json);

@override final  String id;
@override final  String pageId;
@override final  String taskId;
@override final  String selectionText;
@override final  String? blockId;
@override final  int? textStart;
@override final  int? textEnd;
@override final  DateTime createdAtUtc;
@override final  WikiProjectTaskReferenceResponse task;

/// Create a copy of WikiPageTaskLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiPageTaskLinkResponseCopyWith<_WikiPageTaskLinkResponse> get copyWith => __$WikiPageTaskLinkResponseCopyWithImpl<_WikiPageTaskLinkResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiPageTaskLinkResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiPageTaskLinkResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.selectionText, selectionText) || other.selectionText == selectionText)&&(identical(other.blockId, blockId) || other.blockId == blockId)&&(identical(other.textStart, textStart) || other.textStart == textStart)&&(identical(other.textEnd, textEnd) || other.textEnd == textEnd)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.task, task) || other.task == task));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pageId,taskId,selectionText,blockId,textStart,textEnd,createdAtUtc,task);

@override
String toString() {
  return 'WikiPageTaskLinkResponse(id: $id, pageId: $pageId, taskId: $taskId, selectionText: $selectionText, blockId: $blockId, textStart: $textStart, textEnd: $textEnd, createdAtUtc: $createdAtUtc, task: $task)';
}


}

/// @nodoc
abstract mixin class _$WikiPageTaskLinkResponseCopyWith<$Res> implements $WikiPageTaskLinkResponseCopyWith<$Res> {
  factory _$WikiPageTaskLinkResponseCopyWith(_WikiPageTaskLinkResponse value, $Res Function(_WikiPageTaskLinkResponse) _then) = __$WikiPageTaskLinkResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String pageId, String taskId, String selectionText, String? blockId, int? textStart, int? textEnd, DateTime createdAtUtc, WikiProjectTaskReferenceResponse task
});


@override $WikiProjectTaskReferenceResponseCopyWith<$Res> get task;

}
/// @nodoc
class __$WikiPageTaskLinkResponseCopyWithImpl<$Res>
    implements _$WikiPageTaskLinkResponseCopyWith<$Res> {
  __$WikiPageTaskLinkResponseCopyWithImpl(this._self, this._then);

  final _WikiPageTaskLinkResponse _self;
  final $Res Function(_WikiPageTaskLinkResponse) _then;

/// Create a copy of WikiPageTaskLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pageId = null,Object? taskId = null,Object? selectionText = null,Object? blockId = freezed,Object? textStart = freezed,Object? textEnd = freezed,Object? createdAtUtc = null,Object? task = null,}) {
  return _then(_WikiPageTaskLinkResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,selectionText: null == selectionText ? _self.selectionText : selectionText // ignore: cast_nullable_to_non_nullable
as String,blockId: freezed == blockId ? _self.blockId : blockId // ignore: cast_nullable_to_non_nullable
as String?,textStart: freezed == textStart ? _self.textStart : textStart // ignore: cast_nullable_to_non_nullable
as int?,textEnd: freezed == textEnd ? _self.textEnd : textEnd // ignore: cast_nullable_to_non_nullable
as int?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as WikiProjectTaskReferenceResponse,
  ));
}

/// Create a copy of WikiPageTaskLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WikiProjectTaskReferenceResponseCopyWith<$Res> get task {
  
  return $WikiProjectTaskReferenceResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// @nodoc
mixin _$WikiSummarizeResponse {

 String get summary; List<String> get keyPoints; String get provider; String? get model; DateTime get generatedAtUtc;
/// Create a copy of WikiSummarizeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiSummarizeResponseCopyWith<WikiSummarizeResponse> get copyWith => _$WikiSummarizeResponseCopyWithImpl<WikiSummarizeResponse>(this as WikiSummarizeResponse, _$identity);

  /// Serializes this WikiSummarizeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiSummarizeResponse&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.keyPoints, keyPoints)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(keyPoints),provider,model,generatedAtUtc);

@override
String toString() {
  return 'WikiSummarizeResponse(summary: $summary, keyPoints: $keyPoints, provider: $provider, model: $model, generatedAtUtc: $generatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WikiSummarizeResponseCopyWith<$Res>  {
  factory $WikiSummarizeResponseCopyWith(WikiSummarizeResponse value, $Res Function(WikiSummarizeResponse) _then) = _$WikiSummarizeResponseCopyWithImpl;
@useResult
$Res call({
 String summary, List<String> keyPoints, String provider, String? model, DateTime generatedAtUtc
});




}
/// @nodoc
class _$WikiSummarizeResponseCopyWithImpl<$Res>
    implements $WikiSummarizeResponseCopyWith<$Res> {
  _$WikiSummarizeResponseCopyWithImpl(this._self, this._then);

  final WikiSummarizeResponse _self;
  final $Res Function(WikiSummarizeResponse) _then;

/// Create a copy of WikiSummarizeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? keyPoints = null,Object? provider = null,Object? model = freezed,Object? generatedAtUtc = null,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,keyPoints: null == keyPoints ? _self.keyPoints : keyPoints // ignore: cast_nullable_to_non_nullable
as List<String>,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiSummarizeResponse].
extension WikiSummarizeResponsePatterns on WikiSummarizeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiSummarizeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiSummarizeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiSummarizeResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiSummarizeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiSummarizeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiSummarizeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String summary,  List<String> keyPoints,  String provider,  String? model,  DateTime generatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiSummarizeResponse() when $default != null:
return $default(_that.summary,_that.keyPoints,_that.provider,_that.model,_that.generatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String summary,  List<String> keyPoints,  String provider,  String? model,  DateTime generatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WikiSummarizeResponse():
return $default(_that.summary,_that.keyPoints,_that.provider,_that.model,_that.generatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String summary,  List<String> keyPoints,  String provider,  String? model,  DateTime generatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WikiSummarizeResponse() when $default != null:
return $default(_that.summary,_that.keyPoints,_that.provider,_that.model,_that.generatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiSummarizeResponse implements WikiSummarizeResponse {
  const _WikiSummarizeResponse({required this.summary, required this.keyPoints, required this.provider, this.model, required this.generatedAtUtc});
  factory _WikiSummarizeResponse.fromJson(Map<String, dynamic> json) => _$WikiSummarizeResponseFromJson(json);

@override final  String summary;
@override final  List<String> keyPoints;
@override final  String provider;
@override final  String? model;
@override final  DateTime generatedAtUtc;

/// Create a copy of WikiSummarizeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiSummarizeResponseCopyWith<_WikiSummarizeResponse> get copyWith => __$WikiSummarizeResponseCopyWithImpl<_WikiSummarizeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiSummarizeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiSummarizeResponse&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.keyPoints, keyPoints)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(keyPoints),provider,model,generatedAtUtc);

@override
String toString() {
  return 'WikiSummarizeResponse(summary: $summary, keyPoints: $keyPoints, provider: $provider, model: $model, generatedAtUtc: $generatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WikiSummarizeResponseCopyWith<$Res> implements $WikiSummarizeResponseCopyWith<$Res> {
  factory _$WikiSummarizeResponseCopyWith(_WikiSummarizeResponse value, $Res Function(_WikiSummarizeResponse) _then) = __$WikiSummarizeResponseCopyWithImpl;
@override @useResult
$Res call({
 String summary, List<String> keyPoints, String provider, String? model, DateTime generatedAtUtc
});




}
/// @nodoc
class __$WikiSummarizeResponseCopyWithImpl<$Res>
    implements _$WikiSummarizeResponseCopyWith<$Res> {
  __$WikiSummarizeResponseCopyWithImpl(this._self, this._then);

  final _WikiSummarizeResponse _self;
  final $Res Function(_WikiSummarizeResponse) _then;

/// Create a copy of WikiSummarizeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? keyPoints = null,Object? provider = null,Object? model = freezed,Object? generatedAtUtc = null,}) {
  return _then(_WikiSummarizeResponse(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,keyPoints: null == keyPoints ? _self.keyPoints : keyPoints // ignore: cast_nullable_to_non_nullable
as List<String>,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WikiActionItemResponse {

 String get title; String? get description; String? get dueHint;
/// Create a copy of WikiActionItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiActionItemResponseCopyWith<WikiActionItemResponse> get copyWith => _$WikiActionItemResponseCopyWithImpl<WikiActionItemResponse>(this as WikiActionItemResponse, _$identity);

  /// Serializes this WikiActionItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiActionItemResponse&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueHint, dueHint) || other.dueHint == dueHint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,dueHint);

@override
String toString() {
  return 'WikiActionItemResponse(title: $title, description: $description, dueHint: $dueHint)';
}


}

/// @nodoc
abstract mixin class $WikiActionItemResponseCopyWith<$Res>  {
  factory $WikiActionItemResponseCopyWith(WikiActionItemResponse value, $Res Function(WikiActionItemResponse) _then) = _$WikiActionItemResponseCopyWithImpl;
@useResult
$Res call({
 String title, String? description, String? dueHint
});




}
/// @nodoc
class _$WikiActionItemResponseCopyWithImpl<$Res>
    implements $WikiActionItemResponseCopyWith<$Res> {
  _$WikiActionItemResponseCopyWithImpl(this._self, this._then);

  final WikiActionItemResponse _self;
  final $Res Function(WikiActionItemResponse) _then;

/// Create a copy of WikiActionItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? dueHint = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueHint: freezed == dueHint ? _self.dueHint : dueHint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiActionItemResponse].
extension WikiActionItemResponsePatterns on WikiActionItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiActionItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiActionItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiActionItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiActionItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiActionItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiActionItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description,  String? dueHint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiActionItemResponse() when $default != null:
return $default(_that.title,_that.description,_that.dueHint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description,  String? dueHint)  $default,) {final _that = this;
switch (_that) {
case _WikiActionItemResponse():
return $default(_that.title,_that.description,_that.dueHint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description,  String? dueHint)?  $default,) {final _that = this;
switch (_that) {
case _WikiActionItemResponse() when $default != null:
return $default(_that.title,_that.description,_that.dueHint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiActionItemResponse implements WikiActionItemResponse {
  const _WikiActionItemResponse({required this.title, this.description, this.dueHint});
  factory _WikiActionItemResponse.fromJson(Map<String, dynamic> json) => _$WikiActionItemResponseFromJson(json);

@override final  String title;
@override final  String? description;
@override final  String? dueHint;

/// Create a copy of WikiActionItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiActionItemResponseCopyWith<_WikiActionItemResponse> get copyWith => __$WikiActionItemResponseCopyWithImpl<_WikiActionItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiActionItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiActionItemResponse&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueHint, dueHint) || other.dueHint == dueHint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,dueHint);

@override
String toString() {
  return 'WikiActionItemResponse(title: $title, description: $description, dueHint: $dueHint)';
}


}

/// @nodoc
abstract mixin class _$WikiActionItemResponseCopyWith<$Res> implements $WikiActionItemResponseCopyWith<$Res> {
  factory _$WikiActionItemResponseCopyWith(_WikiActionItemResponse value, $Res Function(_WikiActionItemResponse) _then) = __$WikiActionItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, String? dueHint
});




}
/// @nodoc
class __$WikiActionItemResponseCopyWithImpl<$Res>
    implements _$WikiActionItemResponseCopyWith<$Res> {
  __$WikiActionItemResponseCopyWithImpl(this._self, this._then);

  final _WikiActionItemResponse _self;
  final $Res Function(_WikiActionItemResponse) _then;

/// Create a copy of WikiActionItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? dueHint = freezed,}) {
  return _then(_WikiActionItemResponse(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueHint: freezed == dueHint ? _self.dueHint : dueHint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WikiActionItemsResponse {

 List<WikiActionItemResponse> get actionItems; String get provider; String? get model; DateTime get generatedAtUtc;
/// Create a copy of WikiActionItemsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiActionItemsResponseCopyWith<WikiActionItemsResponse> get copyWith => _$WikiActionItemsResponseCopyWithImpl<WikiActionItemsResponse>(this as WikiActionItemsResponse, _$identity);

  /// Serializes this WikiActionItemsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiActionItemsResponse&&const DeepCollectionEquality().equals(other.actionItems, actionItems)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(actionItems),provider,model,generatedAtUtc);

@override
String toString() {
  return 'WikiActionItemsResponse(actionItems: $actionItems, provider: $provider, model: $model, generatedAtUtc: $generatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WikiActionItemsResponseCopyWith<$Res>  {
  factory $WikiActionItemsResponseCopyWith(WikiActionItemsResponse value, $Res Function(WikiActionItemsResponse) _then) = _$WikiActionItemsResponseCopyWithImpl;
@useResult
$Res call({
 List<WikiActionItemResponse> actionItems, String provider, String? model, DateTime generatedAtUtc
});




}
/// @nodoc
class _$WikiActionItemsResponseCopyWithImpl<$Res>
    implements $WikiActionItemsResponseCopyWith<$Res> {
  _$WikiActionItemsResponseCopyWithImpl(this._self, this._then);

  final WikiActionItemsResponse _self;
  final $Res Function(WikiActionItemsResponse) _then;

/// Create a copy of WikiActionItemsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionItems = null,Object? provider = null,Object? model = freezed,Object? generatedAtUtc = null,}) {
  return _then(_self.copyWith(
actionItems: null == actionItems ? _self.actionItems : actionItems // ignore: cast_nullable_to_non_nullable
as List<WikiActionItemResponse>,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiActionItemsResponse].
extension WikiActionItemsResponsePatterns on WikiActionItemsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiActionItemsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiActionItemsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiActionItemsResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiActionItemsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiActionItemsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiActionItemsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WikiActionItemResponse> actionItems,  String provider,  String? model,  DateTime generatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiActionItemsResponse() when $default != null:
return $default(_that.actionItems,_that.provider,_that.model,_that.generatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WikiActionItemResponse> actionItems,  String provider,  String? model,  DateTime generatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WikiActionItemsResponse():
return $default(_that.actionItems,_that.provider,_that.model,_that.generatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WikiActionItemResponse> actionItems,  String provider,  String? model,  DateTime generatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WikiActionItemsResponse() when $default != null:
return $default(_that.actionItems,_that.provider,_that.model,_that.generatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiActionItemsResponse implements WikiActionItemsResponse {
  const _WikiActionItemsResponse({required this.actionItems, required this.provider, this.model, required this.generatedAtUtc});
  factory _WikiActionItemsResponse.fromJson(Map<String, dynamic> json) => _$WikiActionItemsResponseFromJson(json);

@override final  List<WikiActionItemResponse> actionItems;
@override final  String provider;
@override final  String? model;
@override final  DateTime generatedAtUtc;

/// Create a copy of WikiActionItemsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiActionItemsResponseCopyWith<_WikiActionItemsResponse> get copyWith => __$WikiActionItemsResponseCopyWithImpl<_WikiActionItemsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiActionItemsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiActionItemsResponse&&const DeepCollectionEquality().equals(other.actionItems, actionItems)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(actionItems),provider,model,generatedAtUtc);

@override
String toString() {
  return 'WikiActionItemsResponse(actionItems: $actionItems, provider: $provider, model: $model, generatedAtUtc: $generatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WikiActionItemsResponseCopyWith<$Res> implements $WikiActionItemsResponseCopyWith<$Res> {
  factory _$WikiActionItemsResponseCopyWith(_WikiActionItemsResponse value, $Res Function(_WikiActionItemsResponse) _then) = __$WikiActionItemsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<WikiActionItemResponse> actionItems, String provider, String? model, DateTime generatedAtUtc
});




}
/// @nodoc
class __$WikiActionItemsResponseCopyWithImpl<$Res>
    implements _$WikiActionItemsResponseCopyWith<$Res> {
  __$WikiActionItemsResponseCopyWithImpl(this._self, this._then);

  final _WikiActionItemsResponse _self;
  final $Res Function(_WikiActionItemsResponse) _then;

/// Create a copy of WikiActionItemsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actionItems = null,Object? provider = null,Object? model = freezed,Object? generatedAtUtc = null,}) {
  return _then(_WikiActionItemsResponse(
actionItems: null == actionItems ? _self.actionItems : actionItems // ignore: cast_nullable_to_non_nullable
as List<WikiActionItemResponse>,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ConvertWikiSelectionToTaskResponse {

 ProjectTaskResponse get task; WikiPageTaskLinkResponse get backlink;
/// Create a copy of ConvertWikiSelectionToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConvertWikiSelectionToTaskResponseCopyWith<ConvertWikiSelectionToTaskResponse> get copyWith => _$ConvertWikiSelectionToTaskResponseCopyWithImpl<ConvertWikiSelectionToTaskResponse>(this as ConvertWikiSelectionToTaskResponse, _$identity);

  /// Serializes this ConvertWikiSelectionToTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConvertWikiSelectionToTaskResponse&&(identical(other.task, task) || other.task == task)&&(identical(other.backlink, backlink) || other.backlink == backlink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,backlink);

@override
String toString() {
  return 'ConvertWikiSelectionToTaskResponse(task: $task, backlink: $backlink)';
}


}

/// @nodoc
abstract mixin class $ConvertWikiSelectionToTaskResponseCopyWith<$Res>  {
  factory $ConvertWikiSelectionToTaskResponseCopyWith(ConvertWikiSelectionToTaskResponse value, $Res Function(ConvertWikiSelectionToTaskResponse) _then) = _$ConvertWikiSelectionToTaskResponseCopyWithImpl;
@useResult
$Res call({
 ProjectTaskResponse task, WikiPageTaskLinkResponse backlink
});


$ProjectTaskResponseCopyWith<$Res> get task;$WikiPageTaskLinkResponseCopyWith<$Res> get backlink;

}
/// @nodoc
class _$ConvertWikiSelectionToTaskResponseCopyWithImpl<$Res>
    implements $ConvertWikiSelectionToTaskResponseCopyWith<$Res> {
  _$ConvertWikiSelectionToTaskResponseCopyWithImpl(this._self, this._then);

  final ConvertWikiSelectionToTaskResponse _self;
  final $Res Function(ConvertWikiSelectionToTaskResponse) _then;

/// Create a copy of ConvertWikiSelectionToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? backlink = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as ProjectTaskResponse,backlink: null == backlink ? _self.backlink : backlink // ignore: cast_nullable_to_non_nullable
as WikiPageTaskLinkResponse,
  ));
}
/// Create a copy of ConvertWikiSelectionToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskResponseCopyWith<$Res> get task {
  
  return $ProjectTaskResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}/// Create a copy of ConvertWikiSelectionToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WikiPageTaskLinkResponseCopyWith<$Res> get backlink {
  
  return $WikiPageTaskLinkResponseCopyWith<$Res>(_self.backlink, (value) {
    return _then(_self.copyWith(backlink: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConvertWikiSelectionToTaskResponse].
extension ConvertWikiSelectionToTaskResponsePatterns on ConvertWikiSelectionToTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConvertWikiSelectionToTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConvertWikiSelectionToTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConvertWikiSelectionToTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectTaskResponse task,  WikiPageTaskLinkResponse backlink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskResponse() when $default != null:
return $default(_that.task,_that.backlink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectTaskResponse task,  WikiPageTaskLinkResponse backlink)  $default,) {final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskResponse():
return $default(_that.task,_that.backlink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectTaskResponse task,  WikiPageTaskLinkResponse backlink)?  $default,) {final _that = this;
switch (_that) {
case _ConvertWikiSelectionToTaskResponse() when $default != null:
return $default(_that.task,_that.backlink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConvertWikiSelectionToTaskResponse implements ConvertWikiSelectionToTaskResponse {
  const _ConvertWikiSelectionToTaskResponse({required this.task, required this.backlink});
  factory _ConvertWikiSelectionToTaskResponse.fromJson(Map<String, dynamic> json) => _$ConvertWikiSelectionToTaskResponseFromJson(json);

@override final  ProjectTaskResponse task;
@override final  WikiPageTaskLinkResponse backlink;

/// Create a copy of ConvertWikiSelectionToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConvertWikiSelectionToTaskResponseCopyWith<_ConvertWikiSelectionToTaskResponse> get copyWith => __$ConvertWikiSelectionToTaskResponseCopyWithImpl<_ConvertWikiSelectionToTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConvertWikiSelectionToTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConvertWikiSelectionToTaskResponse&&(identical(other.task, task) || other.task == task)&&(identical(other.backlink, backlink) || other.backlink == backlink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,backlink);

@override
String toString() {
  return 'ConvertWikiSelectionToTaskResponse(task: $task, backlink: $backlink)';
}


}

/// @nodoc
abstract mixin class _$ConvertWikiSelectionToTaskResponseCopyWith<$Res> implements $ConvertWikiSelectionToTaskResponseCopyWith<$Res> {
  factory _$ConvertWikiSelectionToTaskResponseCopyWith(_ConvertWikiSelectionToTaskResponse value, $Res Function(_ConvertWikiSelectionToTaskResponse) _then) = __$ConvertWikiSelectionToTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectTaskResponse task, WikiPageTaskLinkResponse backlink
});


@override $ProjectTaskResponseCopyWith<$Res> get task;@override $WikiPageTaskLinkResponseCopyWith<$Res> get backlink;

}
/// @nodoc
class __$ConvertWikiSelectionToTaskResponseCopyWithImpl<$Res>
    implements _$ConvertWikiSelectionToTaskResponseCopyWith<$Res> {
  __$ConvertWikiSelectionToTaskResponseCopyWithImpl(this._self, this._then);

  final _ConvertWikiSelectionToTaskResponse _self;
  final $Res Function(_ConvertWikiSelectionToTaskResponse) _then;

/// Create a copy of ConvertWikiSelectionToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? backlink = null,}) {
  return _then(_ConvertWikiSelectionToTaskResponse(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as ProjectTaskResponse,backlink: null == backlink ? _self.backlink : backlink // ignore: cast_nullable_to_non_nullable
as WikiPageTaskLinkResponse,
  ));
}

/// Create a copy of ConvertWikiSelectionToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskResponseCopyWith<$Res> get task {
  
  return $ProjectTaskResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}/// Create a copy of ConvertWikiSelectionToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WikiPageTaskLinkResponseCopyWith<$Res> get backlink {
  
  return $WikiPageTaskLinkResponseCopyWith<$Res>(_self.backlink, (value) {
    return _then(_self.copyWith(backlink: value));
  });
}
}

// dart format on
