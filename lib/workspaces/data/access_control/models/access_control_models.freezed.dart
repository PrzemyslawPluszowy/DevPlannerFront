// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access_control_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrantResourceAccessPayload {

 ResourceAccessLevel get accessLevel; int get expectedVersion;
/// Create a copy of GrantResourceAccessPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrantResourceAccessPayloadCopyWith<GrantResourceAccessPayload> get copyWith => _$GrantResourceAccessPayloadCopyWithImpl<GrantResourceAccessPayload>(this as GrantResourceAccessPayload, _$identity);

  /// Serializes this GrantResourceAccessPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrantResourceAccessPayload&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessLevel,expectedVersion);

@override
String toString() {
  return 'GrantResourceAccessPayload(accessLevel: $accessLevel, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $GrantResourceAccessPayloadCopyWith<$Res>  {
  factory $GrantResourceAccessPayloadCopyWith(GrantResourceAccessPayload value, $Res Function(GrantResourceAccessPayload) _then) = _$GrantResourceAccessPayloadCopyWithImpl;
@useResult
$Res call({
 ResourceAccessLevel accessLevel, int expectedVersion
});




}
/// @nodoc
class _$GrantResourceAccessPayloadCopyWithImpl<$Res>
    implements $GrantResourceAccessPayloadCopyWith<$Res> {
  _$GrantResourceAccessPayloadCopyWithImpl(this._self, this._then);

  final GrantResourceAccessPayload _self;
  final $Res Function(GrantResourceAccessPayload) _then;

/// Create a copy of GrantResourceAccessPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessLevel = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as ResourceAccessLevel,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GrantResourceAccessPayload].
extension GrantResourceAccessPayloadPatterns on GrantResourceAccessPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrantResourceAccessPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrantResourceAccessPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrantResourceAccessPayload value)  $default,){
final _that = this;
switch (_that) {
case _GrantResourceAccessPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrantResourceAccessPayload value)?  $default,){
final _that = this;
switch (_that) {
case _GrantResourceAccessPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ResourceAccessLevel accessLevel,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrantResourceAccessPayload() when $default != null:
return $default(_that.accessLevel,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ResourceAccessLevel accessLevel,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _GrantResourceAccessPayload():
return $default(_that.accessLevel,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ResourceAccessLevel accessLevel,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _GrantResourceAccessPayload() when $default != null:
return $default(_that.accessLevel,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrantResourceAccessPayload implements GrantResourceAccessPayload {
  const _GrantResourceAccessPayload({required this.accessLevel, required this.expectedVersion});
  factory _GrantResourceAccessPayload.fromJson(Map<String, dynamic> json) => _$GrantResourceAccessPayloadFromJson(json);

@override final  ResourceAccessLevel accessLevel;
@override final  int expectedVersion;

/// Create a copy of GrantResourceAccessPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrantResourceAccessPayloadCopyWith<_GrantResourceAccessPayload> get copyWith => __$GrantResourceAccessPayloadCopyWithImpl<_GrantResourceAccessPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrantResourceAccessPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrantResourceAccessPayload&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessLevel,expectedVersion);

@override
String toString() {
  return 'GrantResourceAccessPayload(accessLevel: $accessLevel, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$GrantResourceAccessPayloadCopyWith<$Res> implements $GrantResourceAccessPayloadCopyWith<$Res> {
  factory _$GrantResourceAccessPayloadCopyWith(_GrantResourceAccessPayload value, $Res Function(_GrantResourceAccessPayload) _then) = __$GrantResourceAccessPayloadCopyWithImpl;
@override @useResult
$Res call({
 ResourceAccessLevel accessLevel, int expectedVersion
});




}
/// @nodoc
class __$GrantResourceAccessPayloadCopyWithImpl<$Res>
    implements _$GrantResourceAccessPayloadCopyWith<$Res> {
  __$GrantResourceAccessPayloadCopyWithImpl(this._self, this._then);

  final _GrantResourceAccessPayload _self;
  final $Res Function(_GrantResourceAccessPayload) _then;

/// Create a copy of GrantResourceAccessPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessLevel = null,Object? expectedVersion = null,}) {
  return _then(_GrantResourceAccessPayload(
accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as ResourceAccessLevel,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WikiPageAccessGrantResponse {

 String get id; String get wikiPageId; String get coreUserId; ResourceAccessLevel get accessLevel; String get grantedByUserId; DateTime get createdAtUtc; DateTime get updatedAtUtc; int get version;
/// Create a copy of WikiPageAccessGrantResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WikiPageAccessGrantResponseCopyWith<WikiPageAccessGrantResponse> get copyWith => _$WikiPageAccessGrantResponseCopyWithImpl<WikiPageAccessGrantResponse>(this as WikiPageAccessGrantResponse, _$identity);

  /// Serializes this WikiPageAccessGrantResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WikiPageAccessGrantResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.wikiPageId, wikiPageId) || other.wikiPageId == wikiPageId)&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.grantedByUserId, grantedByUserId) || other.grantedByUserId == grantedByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,wikiPageId,coreUserId,accessLevel,grantedByUserId,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'WikiPageAccessGrantResponse(id: $id, wikiPageId: $wikiPageId, coreUserId: $coreUserId, accessLevel: $accessLevel, grantedByUserId: $grantedByUserId, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $WikiPageAccessGrantResponseCopyWith<$Res>  {
  factory $WikiPageAccessGrantResponseCopyWith(WikiPageAccessGrantResponse value, $Res Function(WikiPageAccessGrantResponse) _then) = _$WikiPageAccessGrantResponseCopyWithImpl;
@useResult
$Res call({
 String id, String wikiPageId, String coreUserId, ResourceAccessLevel accessLevel, String grantedByUserId, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$WikiPageAccessGrantResponseCopyWithImpl<$Res>
    implements $WikiPageAccessGrantResponseCopyWith<$Res> {
  _$WikiPageAccessGrantResponseCopyWithImpl(this._self, this._then);

  final WikiPageAccessGrantResponse _self;
  final $Res Function(WikiPageAccessGrantResponse) _then;

/// Create a copy of WikiPageAccessGrantResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? wikiPageId = null,Object? coreUserId = null,Object? accessLevel = null,Object? grantedByUserId = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,wikiPageId: null == wikiPageId ? _self.wikiPageId : wikiPageId // ignore: cast_nullable_to_non_nullable
as String,coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as ResourceAccessLevel,grantedByUserId: null == grantedByUserId ? _self.grantedByUserId : grantedByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WikiPageAccessGrantResponse].
extension WikiPageAccessGrantResponsePatterns on WikiPageAccessGrantResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WikiPageAccessGrantResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WikiPageAccessGrantResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WikiPageAccessGrantResponse value)  $default,){
final _that = this;
switch (_that) {
case _WikiPageAccessGrantResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WikiPageAccessGrantResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WikiPageAccessGrantResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String wikiPageId,  String coreUserId,  ResourceAccessLevel accessLevel,  String grantedByUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WikiPageAccessGrantResponse() when $default != null:
return $default(_that.id,_that.wikiPageId,_that.coreUserId,_that.accessLevel,_that.grantedByUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String wikiPageId,  String coreUserId,  ResourceAccessLevel accessLevel,  String grantedByUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _WikiPageAccessGrantResponse():
return $default(_that.id,_that.wikiPageId,_that.coreUserId,_that.accessLevel,_that.grantedByUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String wikiPageId,  String coreUserId,  ResourceAccessLevel accessLevel,  String grantedByUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _WikiPageAccessGrantResponse() when $default != null:
return $default(_that.id,_that.wikiPageId,_that.coreUserId,_that.accessLevel,_that.grantedByUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WikiPageAccessGrantResponse implements WikiPageAccessGrantResponse {
  const _WikiPageAccessGrantResponse({required this.id, required this.wikiPageId, required this.coreUserId, required this.accessLevel, required this.grantedByUserId, required this.createdAtUtc, required this.updatedAtUtc, required this.version});
  factory _WikiPageAccessGrantResponse.fromJson(Map<String, dynamic> json) => _$WikiPageAccessGrantResponseFromJson(json);

@override final  String id;
@override final  String wikiPageId;
@override final  String coreUserId;
@override final  ResourceAccessLevel accessLevel;
@override final  String grantedByUserId;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of WikiPageAccessGrantResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WikiPageAccessGrantResponseCopyWith<_WikiPageAccessGrantResponse> get copyWith => __$WikiPageAccessGrantResponseCopyWithImpl<_WikiPageAccessGrantResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WikiPageAccessGrantResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WikiPageAccessGrantResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.wikiPageId, wikiPageId) || other.wikiPageId == wikiPageId)&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.grantedByUserId, grantedByUserId) || other.grantedByUserId == grantedByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,wikiPageId,coreUserId,accessLevel,grantedByUserId,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'WikiPageAccessGrantResponse(id: $id, wikiPageId: $wikiPageId, coreUserId: $coreUserId, accessLevel: $accessLevel, grantedByUserId: $grantedByUserId, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$WikiPageAccessGrantResponseCopyWith<$Res> implements $WikiPageAccessGrantResponseCopyWith<$Res> {
  factory _$WikiPageAccessGrantResponseCopyWith(_WikiPageAccessGrantResponse value, $Res Function(_WikiPageAccessGrantResponse) _then) = __$WikiPageAccessGrantResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String wikiPageId, String coreUserId, ResourceAccessLevel accessLevel, String grantedByUserId, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$WikiPageAccessGrantResponseCopyWithImpl<$Res>
    implements _$WikiPageAccessGrantResponseCopyWith<$Res> {
  __$WikiPageAccessGrantResponseCopyWithImpl(this._self, this._then);

  final _WikiPageAccessGrantResponse _self;
  final $Res Function(_WikiPageAccessGrantResponse) _then;

/// Create a copy of WikiPageAccessGrantResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? wikiPageId = null,Object? coreUserId = null,Object? accessLevel = null,Object? grantedByUserId = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_WikiPageAccessGrantResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,wikiPageId: null == wikiPageId ? _self.wikiPageId : wikiPageId // ignore: cast_nullable_to_non_nullable
as String,coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as ResourceAccessLevel,grantedByUserId: null == grantedByUserId ? _self.grantedByUserId : grantedByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WhiteboardAccessGrantResponse {

 String get id; String get whiteboardId; String get coreUserId; ResourceAccessLevel get accessLevel; String get grantedByUserId; DateTime get createdAtUtc; DateTime get updatedAtUtc; int get version;
/// Create a copy of WhiteboardAccessGrantResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardAccessGrantResponseCopyWith<WhiteboardAccessGrantResponse> get copyWith => _$WhiteboardAccessGrantResponseCopyWithImpl<WhiteboardAccessGrantResponse>(this as WhiteboardAccessGrantResponse, _$identity);

  /// Serializes this WhiteboardAccessGrantResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardAccessGrantResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.whiteboardId, whiteboardId) || other.whiteboardId == whiteboardId)&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.grantedByUserId, grantedByUserId) || other.grantedByUserId == grantedByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,whiteboardId,coreUserId,accessLevel,grantedByUserId,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'WhiteboardAccessGrantResponse(id: $id, whiteboardId: $whiteboardId, coreUserId: $coreUserId, accessLevel: $accessLevel, grantedByUserId: $grantedByUserId, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $WhiteboardAccessGrantResponseCopyWith<$Res>  {
  factory $WhiteboardAccessGrantResponseCopyWith(WhiteboardAccessGrantResponse value, $Res Function(WhiteboardAccessGrantResponse) _then) = _$WhiteboardAccessGrantResponseCopyWithImpl;
@useResult
$Res call({
 String id, String whiteboardId, String coreUserId, ResourceAccessLevel accessLevel, String grantedByUserId, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$WhiteboardAccessGrantResponseCopyWithImpl<$Res>
    implements $WhiteboardAccessGrantResponseCopyWith<$Res> {
  _$WhiteboardAccessGrantResponseCopyWithImpl(this._self, this._then);

  final WhiteboardAccessGrantResponse _self;
  final $Res Function(WhiteboardAccessGrantResponse) _then;

/// Create a copy of WhiteboardAccessGrantResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? whiteboardId = null,Object? coreUserId = null,Object? accessLevel = null,Object? grantedByUserId = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,whiteboardId: null == whiteboardId ? _self.whiteboardId : whiteboardId // ignore: cast_nullable_to_non_nullable
as String,coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as ResourceAccessLevel,grantedByUserId: null == grantedByUserId ? _self.grantedByUserId : grantedByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardAccessGrantResponse].
extension WhiteboardAccessGrantResponsePatterns on WhiteboardAccessGrantResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardAccessGrantResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardAccessGrantResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardAccessGrantResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAccessGrantResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardAccessGrantResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAccessGrantResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String whiteboardId,  String coreUserId,  ResourceAccessLevel accessLevel,  String grantedByUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardAccessGrantResponse() when $default != null:
return $default(_that.id,_that.whiteboardId,_that.coreUserId,_that.accessLevel,_that.grantedByUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String whiteboardId,  String coreUserId,  ResourceAccessLevel accessLevel,  String grantedByUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAccessGrantResponse():
return $default(_that.id,_that.whiteboardId,_that.coreUserId,_that.accessLevel,_that.grantedByUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String whiteboardId,  String coreUserId,  ResourceAccessLevel accessLevel,  String grantedByUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAccessGrantResponse() when $default != null:
return $default(_that.id,_that.whiteboardId,_that.coreUserId,_that.accessLevel,_that.grantedByUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardAccessGrantResponse implements WhiteboardAccessGrantResponse {
  const _WhiteboardAccessGrantResponse({required this.id, required this.whiteboardId, required this.coreUserId, required this.accessLevel, required this.grantedByUserId, required this.createdAtUtc, required this.updatedAtUtc, required this.version});
  factory _WhiteboardAccessGrantResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardAccessGrantResponseFromJson(json);

@override final  String id;
@override final  String whiteboardId;
@override final  String coreUserId;
@override final  ResourceAccessLevel accessLevel;
@override final  String grantedByUserId;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of WhiteboardAccessGrantResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardAccessGrantResponseCopyWith<_WhiteboardAccessGrantResponse> get copyWith => __$WhiteboardAccessGrantResponseCopyWithImpl<_WhiteboardAccessGrantResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardAccessGrantResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardAccessGrantResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.whiteboardId, whiteboardId) || other.whiteboardId == whiteboardId)&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&(identical(other.grantedByUserId, grantedByUserId) || other.grantedByUserId == grantedByUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,whiteboardId,coreUserId,accessLevel,grantedByUserId,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'WhiteboardAccessGrantResponse(id: $id, whiteboardId: $whiteboardId, coreUserId: $coreUserId, accessLevel: $accessLevel, grantedByUserId: $grantedByUserId, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardAccessGrantResponseCopyWith<$Res> implements $WhiteboardAccessGrantResponseCopyWith<$Res> {
  factory _$WhiteboardAccessGrantResponseCopyWith(_WhiteboardAccessGrantResponse value, $Res Function(_WhiteboardAccessGrantResponse) _then) = __$WhiteboardAccessGrantResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String whiteboardId, String coreUserId, ResourceAccessLevel accessLevel, String grantedByUserId, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$WhiteboardAccessGrantResponseCopyWithImpl<$Res>
    implements _$WhiteboardAccessGrantResponseCopyWith<$Res> {
  __$WhiteboardAccessGrantResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardAccessGrantResponse _self;
  final $Res Function(_WhiteboardAccessGrantResponse) _then;

/// Create a copy of WhiteboardAccessGrantResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? whiteboardId = null,Object? coreUserId = null,Object? accessLevel = null,Object? grantedByUserId = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_WhiteboardAccessGrantResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,whiteboardId: null == whiteboardId ? _self.whiteboardId : whiteboardId // ignore: cast_nullable_to_non_nullable
as String,coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,accessLevel: null == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as ResourceAccessLevel,grantedByUserId: null == grantedByUserId ? _self.grantedByUserId : grantedByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
