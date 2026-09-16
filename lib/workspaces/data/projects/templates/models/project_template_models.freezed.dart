// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_template_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateProjectTemplatePayload {

/// Nazwa szablonu.
 String get name;
/// Create a copy of CreateProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProjectTemplatePayloadCopyWith<CreateProjectTemplatePayload> get copyWith => _$CreateProjectTemplatePayloadCopyWithImpl<CreateProjectTemplatePayload>(this as CreateProjectTemplatePayload, _$identity);

  /// Serializes this CreateProjectTemplatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProjectTemplatePayload&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CreateProjectTemplatePayload(name: $name)';
}


}

/// @nodoc
abstract mixin class $CreateProjectTemplatePayloadCopyWith<$Res>  {
  factory $CreateProjectTemplatePayloadCopyWith(CreateProjectTemplatePayload value, $Res Function(CreateProjectTemplatePayload) _then) = _$CreateProjectTemplatePayloadCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$CreateProjectTemplatePayloadCopyWithImpl<$Res>
    implements $CreateProjectTemplatePayloadCopyWith<$Res> {
  _$CreateProjectTemplatePayloadCopyWithImpl(this._self, this._then);

  final CreateProjectTemplatePayload _self;
  final $Res Function(CreateProjectTemplatePayload) _then;

/// Create a copy of CreateProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProjectTemplatePayload].
extension CreateProjectTemplatePayloadPatterns on CreateProjectTemplatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProjectTemplatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProjectTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProjectTemplatePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateProjectTemplatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProjectTemplatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProjectTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProjectTemplatePayload() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _CreateProjectTemplatePayload():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _CreateProjectTemplatePayload() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProjectTemplatePayload implements CreateProjectTemplatePayload {
  const _CreateProjectTemplatePayload({required this.name});
  factory _CreateProjectTemplatePayload.fromJson(Map<String, dynamic> json) => _$CreateProjectTemplatePayloadFromJson(json);

/// Nazwa szablonu.
@override final  String name;

/// Create a copy of CreateProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProjectTemplatePayloadCopyWith<_CreateProjectTemplatePayload> get copyWith => __$CreateProjectTemplatePayloadCopyWithImpl<_CreateProjectTemplatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProjectTemplatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProjectTemplatePayload&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CreateProjectTemplatePayload(name: $name)';
}


}

/// @nodoc
abstract mixin class _$CreateProjectTemplatePayloadCopyWith<$Res> implements $CreateProjectTemplatePayloadCopyWith<$Res> {
  factory _$CreateProjectTemplatePayloadCopyWith(_CreateProjectTemplatePayload value, $Res Function(_CreateProjectTemplatePayload) _then) = __$CreateProjectTemplatePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$CreateProjectTemplatePayloadCopyWithImpl<$Res>
    implements _$CreateProjectTemplatePayloadCopyWith<$Res> {
  __$CreateProjectTemplatePayloadCopyWithImpl(this._self, this._then);

  final _CreateProjectTemplatePayload _self;
  final $Res Function(_CreateProjectTemplatePayload) _then;

/// Create a copy of CreateProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_CreateProjectTemplatePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ApplyProjectTemplatePayload {

/// Nazwa nowego projektu.
 String get name;
/// Create a copy of ApplyProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyProjectTemplatePayloadCopyWith<ApplyProjectTemplatePayload> get copyWith => _$ApplyProjectTemplatePayloadCopyWithImpl<ApplyProjectTemplatePayload>(this as ApplyProjectTemplatePayload, _$identity);

  /// Serializes this ApplyProjectTemplatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyProjectTemplatePayload&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'ApplyProjectTemplatePayload(name: $name)';
}


}

/// @nodoc
abstract mixin class $ApplyProjectTemplatePayloadCopyWith<$Res>  {
  factory $ApplyProjectTemplatePayloadCopyWith(ApplyProjectTemplatePayload value, $Res Function(ApplyProjectTemplatePayload) _then) = _$ApplyProjectTemplatePayloadCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$ApplyProjectTemplatePayloadCopyWithImpl<$Res>
    implements $ApplyProjectTemplatePayloadCopyWith<$Res> {
  _$ApplyProjectTemplatePayloadCopyWithImpl(this._self, this._then);

  final ApplyProjectTemplatePayload _self;
  final $Res Function(ApplyProjectTemplatePayload) _then;

/// Create a copy of ApplyProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplyProjectTemplatePayload].
extension ApplyProjectTemplatePayloadPatterns on ApplyProjectTemplatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplyProjectTemplatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplyProjectTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplyProjectTemplatePayload value)  $default,){
final _that = this;
switch (_that) {
case _ApplyProjectTemplatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplyProjectTemplatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ApplyProjectTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplyProjectTemplatePayload() when $default != null:
return $default(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name)  $default,) {final _that = this;
switch (_that) {
case _ApplyProjectTemplatePayload():
return $default(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name)?  $default,) {final _that = this;
switch (_that) {
case _ApplyProjectTemplatePayload() when $default != null:
return $default(_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplyProjectTemplatePayload implements ApplyProjectTemplatePayload {
  const _ApplyProjectTemplatePayload({required this.name});
  factory _ApplyProjectTemplatePayload.fromJson(Map<String, dynamic> json) => _$ApplyProjectTemplatePayloadFromJson(json);

/// Nazwa nowego projektu.
@override final  String name;

/// Create a copy of ApplyProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplyProjectTemplatePayloadCopyWith<_ApplyProjectTemplatePayload> get copyWith => __$ApplyProjectTemplatePayloadCopyWithImpl<_ApplyProjectTemplatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplyProjectTemplatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplyProjectTemplatePayload&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'ApplyProjectTemplatePayload(name: $name)';
}


}

/// @nodoc
abstract mixin class _$ApplyProjectTemplatePayloadCopyWith<$Res> implements $ApplyProjectTemplatePayloadCopyWith<$Res> {
  factory _$ApplyProjectTemplatePayloadCopyWith(_ApplyProjectTemplatePayload value, $Res Function(_ApplyProjectTemplatePayload) _then) = __$ApplyProjectTemplatePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$ApplyProjectTemplatePayloadCopyWithImpl<$Res>
    implements _$ApplyProjectTemplatePayloadCopyWith<$Res> {
  __$ApplyProjectTemplatePayloadCopyWithImpl(this._self, this._then);

  final _ApplyProjectTemplatePayload _self;
  final $Res Function(_ApplyProjectTemplatePayload) _then;

/// Create a copy of ApplyProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_ApplyProjectTemplatePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RefreshProjectTemplatePayload {

/// Nowa nazwa szablonu.
 String get name;/// Oczekiwana wersja szablonu.
 int get expectedVersion;
/// Create a copy of RefreshProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefreshProjectTemplatePayloadCopyWith<RefreshProjectTemplatePayload> get copyWith => _$RefreshProjectTemplatePayloadCopyWithImpl<RefreshProjectTemplatePayload>(this as RefreshProjectTemplatePayload, _$identity);

  /// Serializes this RefreshProjectTemplatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshProjectTemplatePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,expectedVersion);

@override
String toString() {
  return 'RefreshProjectTemplatePayload(name: $name, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $RefreshProjectTemplatePayloadCopyWith<$Res>  {
  factory $RefreshProjectTemplatePayloadCopyWith(RefreshProjectTemplatePayload value, $Res Function(RefreshProjectTemplatePayload) _then) = _$RefreshProjectTemplatePayloadCopyWithImpl;
@useResult
$Res call({
 String name, int expectedVersion
});




}
/// @nodoc
class _$RefreshProjectTemplatePayloadCopyWithImpl<$Res>
    implements $RefreshProjectTemplatePayloadCopyWith<$Res> {
  _$RefreshProjectTemplatePayloadCopyWithImpl(this._self, this._then);

  final RefreshProjectTemplatePayload _self;
  final $Res Function(RefreshProjectTemplatePayload) _then;

/// Create a copy of RefreshProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RefreshProjectTemplatePayload].
extension RefreshProjectTemplatePayloadPatterns on RefreshProjectTemplatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefreshProjectTemplatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefreshProjectTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefreshProjectTemplatePayload value)  $default,){
final _that = this;
switch (_that) {
case _RefreshProjectTemplatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefreshProjectTemplatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _RefreshProjectTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefreshProjectTemplatePayload() when $default != null:
return $default(_that.name,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _RefreshProjectTemplatePayload():
return $default(_that.name,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _RefreshProjectTemplatePayload() when $default != null:
return $default(_that.name,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RefreshProjectTemplatePayload implements RefreshProjectTemplatePayload {
  const _RefreshProjectTemplatePayload({required this.name, required this.expectedVersion});
  factory _RefreshProjectTemplatePayload.fromJson(Map<String, dynamic> json) => _$RefreshProjectTemplatePayloadFromJson(json);

/// Nowa nazwa szablonu.
@override final  String name;
/// Oczekiwana wersja szablonu.
@override final  int expectedVersion;

/// Create a copy of RefreshProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefreshProjectTemplatePayloadCopyWith<_RefreshProjectTemplatePayload> get copyWith => __$RefreshProjectTemplatePayloadCopyWithImpl<_RefreshProjectTemplatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefreshProjectTemplatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefreshProjectTemplatePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,expectedVersion);

@override
String toString() {
  return 'RefreshProjectTemplatePayload(name: $name, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$RefreshProjectTemplatePayloadCopyWith<$Res> implements $RefreshProjectTemplatePayloadCopyWith<$Res> {
  factory _$RefreshProjectTemplatePayloadCopyWith(_RefreshProjectTemplatePayload value, $Res Function(_RefreshProjectTemplatePayload) _then) = __$RefreshProjectTemplatePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, int expectedVersion
});




}
/// @nodoc
class __$RefreshProjectTemplatePayloadCopyWithImpl<$Res>
    implements _$RefreshProjectTemplatePayloadCopyWith<$Res> {
  __$RefreshProjectTemplatePayloadCopyWithImpl(this._self, this._then);

  final _RefreshProjectTemplatePayload _self;
  final $Res Function(_RefreshProjectTemplatePayload) _then;

/// Create a copy of RefreshProjectTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? expectedVersion = null,}) {
  return _then(_RefreshProjectTemplatePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectTemplateResponse {

/// UUID szablonu.
 String get id;/// Nazwa szablonu.
 String get name;/// Czas ostatniej aktualizacji.
 DateTime get updatedAtUtc;/// Wersja szablonu.
 int get version;
/// Create a copy of ProjectTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTemplateResponseCopyWith<ProjectTemplateResponse> get copyWith => _$ProjectTemplateResponseCopyWithImpl<ProjectTemplateResponse>(this as ProjectTemplateResponse, _$identity);

  /// Serializes this ProjectTemplateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTemplateResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,updatedAtUtc,version);

@override
String toString() {
  return 'ProjectTemplateResponse(id: $id, name: $name, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $ProjectTemplateResponseCopyWith<$Res>  {
  factory $ProjectTemplateResponseCopyWith(ProjectTemplateResponse value, $Res Function(ProjectTemplateResponse) _then) = _$ProjectTemplateResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$ProjectTemplateResponseCopyWithImpl<$Res>
    implements $ProjectTemplateResponseCopyWith<$Res> {
  _$ProjectTemplateResponseCopyWithImpl(this._self, this._then);

  final ProjectTemplateResponse _self;
  final $Res Function(ProjectTemplateResponse) _then;

/// Create a copy of ProjectTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTemplateResponse].
extension ProjectTemplateResponsePatterns on ProjectTemplateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTemplateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTemplateResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTemplateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTemplateResponse() when $default != null:
return $default(_that.id,_that.name,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateResponse():
return $default(_that.id,_that.name,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateResponse() when $default != null:
return $default(_that.id,_that.name,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTemplateResponse implements ProjectTemplateResponse {
  const _ProjectTemplateResponse({required this.id, required this.name, required this.updatedAtUtc, required this.version});
  factory _ProjectTemplateResponse.fromJson(Map<String, dynamic> json) => _$ProjectTemplateResponseFromJson(json);

/// UUID szablonu.
@override final  String id;
/// Nazwa szablonu.
@override final  String name;
/// Czas ostatniej aktualizacji.
@override final  DateTime updatedAtUtc;
/// Wersja szablonu.
@override final  int version;

/// Create a copy of ProjectTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTemplateResponseCopyWith<_ProjectTemplateResponse> get copyWith => __$ProjectTemplateResponseCopyWithImpl<_ProjectTemplateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTemplateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTemplateResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,updatedAtUtc,version);

@override
String toString() {
  return 'ProjectTemplateResponse(id: $id, name: $name, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ProjectTemplateResponseCopyWith<$Res> implements $ProjectTemplateResponseCopyWith<$Res> {
  factory _$ProjectTemplateResponseCopyWith(_ProjectTemplateResponse value, $Res Function(_ProjectTemplateResponse) _then) = __$ProjectTemplateResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$ProjectTemplateResponseCopyWithImpl<$Res>
    implements _$ProjectTemplateResponseCopyWith<$Res> {
  __$ProjectTemplateResponseCopyWithImpl(this._self, this._then);

  final _ProjectTemplateResponse _self;
  final $Res Function(_ProjectTemplateResponse) _then;

/// Create a copy of ProjectTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_ProjectTemplateResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TemplateIdMappingResponse {

/// UUID elementu ze źródłowego szablonu.
 String get sourceId;/// UUID nowo utworzonego elementu.
 String get createdId;
/// Create a copy of TemplateIdMappingResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateIdMappingResponseCopyWith<TemplateIdMappingResponse> get copyWith => _$TemplateIdMappingResponseCopyWithImpl<TemplateIdMappingResponse>(this as TemplateIdMappingResponse, _$identity);

  /// Serializes this TemplateIdMappingResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateIdMappingResponse&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.createdId, createdId) || other.createdId == createdId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,createdId);

@override
String toString() {
  return 'TemplateIdMappingResponse(sourceId: $sourceId, createdId: $createdId)';
}


}

/// @nodoc
abstract mixin class $TemplateIdMappingResponseCopyWith<$Res>  {
  factory $TemplateIdMappingResponseCopyWith(TemplateIdMappingResponse value, $Res Function(TemplateIdMappingResponse) _then) = _$TemplateIdMappingResponseCopyWithImpl;
@useResult
$Res call({
 String sourceId, String createdId
});




}
/// @nodoc
class _$TemplateIdMappingResponseCopyWithImpl<$Res>
    implements $TemplateIdMappingResponseCopyWith<$Res> {
  _$TemplateIdMappingResponseCopyWithImpl(this._self, this._then);

  final TemplateIdMappingResponse _self;
  final $Res Function(TemplateIdMappingResponse) _then;

/// Create a copy of TemplateIdMappingResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceId = null,Object? createdId = null,}) {
  return _then(_self.copyWith(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,createdId: null == createdId ? _self.createdId : createdId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TemplateIdMappingResponse].
extension TemplateIdMappingResponsePatterns on TemplateIdMappingResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateIdMappingResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateIdMappingResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateIdMappingResponse value)  $default,){
final _that = this;
switch (_that) {
case _TemplateIdMappingResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateIdMappingResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateIdMappingResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceId,  String createdId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateIdMappingResponse() when $default != null:
return $default(_that.sourceId,_that.createdId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceId,  String createdId)  $default,) {final _that = this;
switch (_that) {
case _TemplateIdMappingResponse():
return $default(_that.sourceId,_that.createdId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceId,  String createdId)?  $default,) {final _that = this;
switch (_that) {
case _TemplateIdMappingResponse() when $default != null:
return $default(_that.sourceId,_that.createdId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateIdMappingResponse implements TemplateIdMappingResponse {
  const _TemplateIdMappingResponse({required this.sourceId, required this.createdId});
  factory _TemplateIdMappingResponse.fromJson(Map<String, dynamic> json) => _$TemplateIdMappingResponseFromJson(json);

/// UUID elementu ze źródłowego szablonu.
@override final  String sourceId;
/// UUID nowo utworzonego elementu.
@override final  String createdId;

/// Create a copy of TemplateIdMappingResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateIdMappingResponseCopyWith<_TemplateIdMappingResponse> get copyWith => __$TemplateIdMappingResponseCopyWithImpl<_TemplateIdMappingResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateIdMappingResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateIdMappingResponse&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.createdId, createdId) || other.createdId == createdId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,createdId);

@override
String toString() {
  return 'TemplateIdMappingResponse(sourceId: $sourceId, createdId: $createdId)';
}


}

/// @nodoc
abstract mixin class _$TemplateIdMappingResponseCopyWith<$Res> implements $TemplateIdMappingResponseCopyWith<$Res> {
  factory _$TemplateIdMappingResponseCopyWith(_TemplateIdMappingResponse value, $Res Function(_TemplateIdMappingResponse) _then) = __$TemplateIdMappingResponseCopyWithImpl;
@override @useResult
$Res call({
 String sourceId, String createdId
});




}
/// @nodoc
class __$TemplateIdMappingResponseCopyWithImpl<$Res>
    implements _$TemplateIdMappingResponseCopyWith<$Res> {
  __$TemplateIdMappingResponseCopyWithImpl(this._self, this._then);

  final _TemplateIdMappingResponse _self;
  final $Res Function(_TemplateIdMappingResponse) _then;

/// Create a copy of TemplateIdMappingResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceId = null,Object? createdId = null,}) {
  return _then(_TemplateIdMappingResponse(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,createdId: null == createdId ? _self.createdId : createdId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProjectTemplateWorkflowResponse {

/// Klucz statusu.
 String get status;/// Nazwa statusu.
 String get name;/// Kolor statusu.
 String get color;/// Pozycja statusu.
 int get position;/// Czy status początkowy.
 bool get isInitial;/// Czy status końcowy.
 bool get isTerminal;
/// Create a copy of ProjectTemplateWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTemplateWorkflowResponseCopyWith<ProjectTemplateWorkflowResponse> get copyWith => _$ProjectTemplateWorkflowResponseCopyWithImpl<ProjectTemplateWorkflowResponse>(this as ProjectTemplateWorkflowResponse, _$identity);

  /// Serializes this ProjectTemplateWorkflowResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTemplateWorkflowResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.isInitial, isInitial) || other.isInitial == isInitial)&&(identical(other.isTerminal, isTerminal) || other.isTerminal == isTerminal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,name,color,position,isInitial,isTerminal);

@override
String toString() {
  return 'ProjectTemplateWorkflowResponse(status: $status, name: $name, color: $color, position: $position, isInitial: $isInitial, isTerminal: $isTerminal)';
}


}

/// @nodoc
abstract mixin class $ProjectTemplateWorkflowResponseCopyWith<$Res>  {
  factory $ProjectTemplateWorkflowResponseCopyWith(ProjectTemplateWorkflowResponse value, $Res Function(ProjectTemplateWorkflowResponse) _then) = _$ProjectTemplateWorkflowResponseCopyWithImpl;
@useResult
$Res call({
 String status, String name, String color, int position, bool isInitial, bool isTerminal
});




}
/// @nodoc
class _$ProjectTemplateWorkflowResponseCopyWithImpl<$Res>
    implements $ProjectTemplateWorkflowResponseCopyWith<$Res> {
  _$ProjectTemplateWorkflowResponseCopyWithImpl(this._self, this._then);

  final ProjectTemplateWorkflowResponse _self;
  final $Res Function(ProjectTemplateWorkflowResponse) _then;

/// Create a copy of ProjectTemplateWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? name = null,Object? color = null,Object? position = null,Object? isInitial = null,Object? isTerminal = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isInitial: null == isInitial ? _self.isInitial : isInitial // ignore: cast_nullable_to_non_nullable
as bool,isTerminal: null == isTerminal ? _self.isTerminal : isTerminal // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTemplateWorkflowResponse].
extension ProjectTemplateWorkflowResponsePatterns on ProjectTemplateWorkflowResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTemplateWorkflowResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTemplateWorkflowResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTemplateWorkflowResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateWorkflowResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTemplateWorkflowResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateWorkflowResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String name,  String color,  int position,  bool isInitial,  bool isTerminal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTemplateWorkflowResponse() when $default != null:
return $default(_that.status,_that.name,_that.color,_that.position,_that.isInitial,_that.isTerminal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String name,  String color,  int position,  bool isInitial,  bool isTerminal)  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateWorkflowResponse():
return $default(_that.status,_that.name,_that.color,_that.position,_that.isInitial,_that.isTerminal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String name,  String color,  int position,  bool isInitial,  bool isTerminal)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateWorkflowResponse() when $default != null:
return $default(_that.status,_that.name,_that.color,_that.position,_that.isInitial,_that.isTerminal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTemplateWorkflowResponse implements ProjectTemplateWorkflowResponse {
  const _ProjectTemplateWorkflowResponse({required this.status, required this.name, required this.color, required this.position, required this.isInitial, required this.isTerminal});
  factory _ProjectTemplateWorkflowResponse.fromJson(Map<String, dynamic> json) => _$ProjectTemplateWorkflowResponseFromJson(json);

/// Klucz statusu.
@override final  String status;
/// Nazwa statusu.
@override final  String name;
/// Kolor statusu.
@override final  String color;
/// Pozycja statusu.
@override final  int position;
/// Czy status początkowy.
@override final  bool isInitial;
/// Czy status końcowy.
@override final  bool isTerminal;

/// Create a copy of ProjectTemplateWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTemplateWorkflowResponseCopyWith<_ProjectTemplateWorkflowResponse> get copyWith => __$ProjectTemplateWorkflowResponseCopyWithImpl<_ProjectTemplateWorkflowResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTemplateWorkflowResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTemplateWorkflowResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.isInitial, isInitial) || other.isInitial == isInitial)&&(identical(other.isTerminal, isTerminal) || other.isTerminal == isTerminal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,name,color,position,isInitial,isTerminal);

@override
String toString() {
  return 'ProjectTemplateWorkflowResponse(status: $status, name: $name, color: $color, position: $position, isInitial: $isInitial, isTerminal: $isTerminal)';
}


}

/// @nodoc
abstract mixin class _$ProjectTemplateWorkflowResponseCopyWith<$Res> implements $ProjectTemplateWorkflowResponseCopyWith<$Res> {
  factory _$ProjectTemplateWorkflowResponseCopyWith(_ProjectTemplateWorkflowResponse value, $Res Function(_ProjectTemplateWorkflowResponse) _then) = __$ProjectTemplateWorkflowResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String name, String color, int position, bool isInitial, bool isTerminal
});




}
/// @nodoc
class __$ProjectTemplateWorkflowResponseCopyWithImpl<$Res>
    implements _$ProjectTemplateWorkflowResponseCopyWith<$Res> {
  __$ProjectTemplateWorkflowResponseCopyWithImpl(this._self, this._then);

  final _ProjectTemplateWorkflowResponse _self;
  final $Res Function(_ProjectTemplateWorkflowResponse) _then;

/// Create a copy of ProjectTemplateWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? name = null,Object? color = null,Object? position = null,Object? isInitial = null,Object? isTerminal = null,}) {
  return _then(_ProjectTemplateWorkflowResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isInitial: null == isInitial ? _self.isInitial : isInitial // ignore: cast_nullable_to_non_nullable
as bool,isTerminal: null == isTerminal ? _self.isTerminal : isTerminal // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProjectTemplateTransitionResponse {

/// Status źródłowy.
 String get from;/// Status docelowy.
 String get to;
/// Create a copy of ProjectTemplateTransitionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTemplateTransitionResponseCopyWith<ProjectTemplateTransitionResponse> get copyWith => _$ProjectTemplateTransitionResponseCopyWithImpl<ProjectTemplateTransitionResponse>(this as ProjectTemplateTransitionResponse, _$identity);

  /// Serializes this ProjectTemplateTransitionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTemplateTransitionResponse&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'ProjectTemplateTransitionResponse(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $ProjectTemplateTransitionResponseCopyWith<$Res>  {
  factory $ProjectTemplateTransitionResponseCopyWith(ProjectTemplateTransitionResponse value, $Res Function(ProjectTemplateTransitionResponse) _then) = _$ProjectTemplateTransitionResponseCopyWithImpl;
@useResult
$Res call({
 String from, String to
});




}
/// @nodoc
class _$ProjectTemplateTransitionResponseCopyWithImpl<$Res>
    implements $ProjectTemplateTransitionResponseCopyWith<$Res> {
  _$ProjectTemplateTransitionResponseCopyWithImpl(this._self, this._then);

  final ProjectTemplateTransitionResponse _self;
  final $Res Function(ProjectTemplateTransitionResponse) _then;

/// Create a copy of ProjectTemplateTransitionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTemplateTransitionResponse].
extension ProjectTemplateTransitionResponsePatterns on ProjectTemplateTransitionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTemplateTransitionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTemplateTransitionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTemplateTransitionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateTransitionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTemplateTransitionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateTransitionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTemplateTransitionResponse() when $default != null:
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to)  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateTransitionResponse():
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateTransitionResponse() when $default != null:
return $default(_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTemplateTransitionResponse implements ProjectTemplateTransitionResponse {
  const _ProjectTemplateTransitionResponse({required this.from, required this.to});
  factory _ProjectTemplateTransitionResponse.fromJson(Map<String, dynamic> json) => _$ProjectTemplateTransitionResponseFromJson(json);

/// Status źródłowy.
@override final  String from;
/// Status docelowy.
@override final  String to;

/// Create a copy of ProjectTemplateTransitionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTemplateTransitionResponseCopyWith<_ProjectTemplateTransitionResponse> get copyWith => __$ProjectTemplateTransitionResponseCopyWithImpl<_ProjectTemplateTransitionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTemplateTransitionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTemplateTransitionResponse&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'ProjectTemplateTransitionResponse(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$ProjectTemplateTransitionResponseCopyWith<$Res> implements $ProjectTemplateTransitionResponseCopyWith<$Res> {
  factory _$ProjectTemplateTransitionResponseCopyWith(_ProjectTemplateTransitionResponse value, $Res Function(_ProjectTemplateTransitionResponse) _then) = __$ProjectTemplateTransitionResponseCopyWithImpl;
@override @useResult
$Res call({
 String from, String to
});




}
/// @nodoc
class __$ProjectTemplateTransitionResponseCopyWithImpl<$Res>
    implements _$ProjectTemplateTransitionResponseCopyWith<$Res> {
  __$ProjectTemplateTransitionResponseCopyWithImpl(this._self, this._then);

  final _ProjectTemplateTransitionResponse _self;
  final $Res Function(_ProjectTemplateTransitionResponse) _then;

/// Create a copy of ProjectTemplateTransitionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(_ProjectTemplateTransitionResponse(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProjectTemplateDefinitionResponse {

/// UUID źródłowy.
 String get sourceId;/// Nazwa elementu.
 String get name;/// Typ elementu.
 String get type;/// Kolor albo null.
 String? get color;/// Czy element jest wymagany.
@JsonKey(name: 'required') bool? get isRequired;/// Pozycja albo null.
 int? get position;/// Opcje pola albo null.
 List<String>? get options;
/// Create a copy of ProjectTemplateDefinitionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTemplateDefinitionResponseCopyWith<ProjectTemplateDefinitionResponse> get copyWith => _$ProjectTemplateDefinitionResponseCopyWithImpl<ProjectTemplateDefinitionResponse>(this as ProjectTemplateDefinitionResponse, _$identity);

  /// Serializes this ProjectTemplateDefinitionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTemplateDefinitionResponse&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,name,type,color,isRequired,position,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'ProjectTemplateDefinitionResponse(sourceId: $sourceId, name: $name, type: $type, color: $color, isRequired: $isRequired, position: $position, options: $options)';
}


}

/// @nodoc
abstract mixin class $ProjectTemplateDefinitionResponseCopyWith<$Res>  {
  factory $ProjectTemplateDefinitionResponseCopyWith(ProjectTemplateDefinitionResponse value, $Res Function(ProjectTemplateDefinitionResponse) _then) = _$ProjectTemplateDefinitionResponseCopyWithImpl;
@useResult
$Res call({
 String sourceId, String name, String type, String? color,@JsonKey(name: 'required') bool? isRequired, int? position, List<String>? options
});




}
/// @nodoc
class _$ProjectTemplateDefinitionResponseCopyWithImpl<$Res>
    implements $ProjectTemplateDefinitionResponseCopyWith<$Res> {
  _$ProjectTemplateDefinitionResponseCopyWithImpl(this._self, this._then);

  final ProjectTemplateDefinitionResponse _self;
  final $Res Function(ProjectTemplateDefinitionResponse) _then;

/// Create a copy of ProjectTemplateDefinitionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceId = null,Object? name = null,Object? type = null,Object? color = freezed,Object? isRequired = freezed,Object? position = freezed,Object? options = freezed,}) {
  return _then(_self.copyWith(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTemplateDefinitionResponse].
extension ProjectTemplateDefinitionResponsePatterns on ProjectTemplateDefinitionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTemplateDefinitionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTemplateDefinitionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTemplateDefinitionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateDefinitionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTemplateDefinitionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateDefinitionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceId,  String name,  String type,  String? color, @JsonKey(name: 'required')  bool? isRequired,  int? position,  List<String>? options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTemplateDefinitionResponse() when $default != null:
return $default(_that.sourceId,_that.name,_that.type,_that.color,_that.isRequired,_that.position,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceId,  String name,  String type,  String? color, @JsonKey(name: 'required')  bool? isRequired,  int? position,  List<String>? options)  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateDefinitionResponse():
return $default(_that.sourceId,_that.name,_that.type,_that.color,_that.isRequired,_that.position,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceId,  String name,  String type,  String? color, @JsonKey(name: 'required')  bool? isRequired,  int? position,  List<String>? options)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateDefinitionResponse() when $default != null:
return $default(_that.sourceId,_that.name,_that.type,_that.color,_that.isRequired,_that.position,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTemplateDefinitionResponse implements ProjectTemplateDefinitionResponse {
  const _ProjectTemplateDefinitionResponse({required this.sourceId, required this.name, required this.type, this.color, @JsonKey(name: 'required') this.isRequired, this.position, this.options});
  factory _ProjectTemplateDefinitionResponse.fromJson(Map<String, dynamic> json) => _$ProjectTemplateDefinitionResponseFromJson(json);

/// UUID źródłowy.
@override final  String sourceId;
/// Nazwa elementu.
@override final  String name;
/// Typ elementu.
@override final  String type;
/// Kolor albo null.
@override final  String? color;
/// Czy element jest wymagany.
@override@JsonKey(name: 'required') final  bool? isRequired;
/// Pozycja albo null.
@override final  int? position;
/// Opcje pola albo null.
@override final  List<String>? options;

/// Create a copy of ProjectTemplateDefinitionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTemplateDefinitionResponseCopyWith<_ProjectTemplateDefinitionResponse> get copyWith => __$ProjectTemplateDefinitionResponseCopyWithImpl<_ProjectTemplateDefinitionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTemplateDefinitionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTemplateDefinitionResponse&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,name,type,color,isRequired,position,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'ProjectTemplateDefinitionResponse(sourceId: $sourceId, name: $name, type: $type, color: $color, isRequired: $isRequired, position: $position, options: $options)';
}


}

/// @nodoc
abstract mixin class _$ProjectTemplateDefinitionResponseCopyWith<$Res> implements $ProjectTemplateDefinitionResponseCopyWith<$Res> {
  factory _$ProjectTemplateDefinitionResponseCopyWith(_ProjectTemplateDefinitionResponse value, $Res Function(_ProjectTemplateDefinitionResponse) _then) = __$ProjectTemplateDefinitionResponseCopyWithImpl;
@override @useResult
$Res call({
 String sourceId, String name, String type, String? color,@JsonKey(name: 'required') bool? isRequired, int? position, List<String>? options
});




}
/// @nodoc
class __$ProjectTemplateDefinitionResponseCopyWithImpl<$Res>
    implements _$ProjectTemplateDefinitionResponseCopyWith<$Res> {
  __$ProjectTemplateDefinitionResponseCopyWithImpl(this._self, this._then);

  final _ProjectTemplateDefinitionResponse _self;
  final $Res Function(_ProjectTemplateDefinitionResponse) _then;

/// Create a copy of ProjectTemplateDefinitionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceId = null,Object? name = null,Object? type = null,Object? color = freezed,Object? isRequired = freezed,Object? position = freezed,Object? options = freezed,}) {
  return _then(_ProjectTemplateDefinitionResponse(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isRequired: freezed == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$ProjectTemplateTaskCustomValueResponse {

/// UUID definicji pola ze źródłowego szablonu.
 String get fieldSourceId;/// Dowolna wartość JSON pola.
 Object? get value;
/// Create a copy of ProjectTemplateTaskCustomValueResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTemplateTaskCustomValueResponseCopyWith<ProjectTemplateTaskCustomValueResponse> get copyWith => _$ProjectTemplateTaskCustomValueResponseCopyWithImpl<ProjectTemplateTaskCustomValueResponse>(this as ProjectTemplateTaskCustomValueResponse, _$identity);

  /// Serializes this ProjectTemplateTaskCustomValueResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTemplateTaskCustomValueResponse&&(identical(other.fieldSourceId, fieldSourceId) || other.fieldSourceId == fieldSourceId)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldSourceId,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'ProjectTemplateTaskCustomValueResponse(fieldSourceId: $fieldSourceId, value: $value)';
}


}

/// @nodoc
abstract mixin class $ProjectTemplateTaskCustomValueResponseCopyWith<$Res>  {
  factory $ProjectTemplateTaskCustomValueResponseCopyWith(ProjectTemplateTaskCustomValueResponse value, $Res Function(ProjectTemplateTaskCustomValueResponse) _then) = _$ProjectTemplateTaskCustomValueResponseCopyWithImpl;
@useResult
$Res call({
 String fieldSourceId, Object? value
});




}
/// @nodoc
class _$ProjectTemplateTaskCustomValueResponseCopyWithImpl<$Res>
    implements $ProjectTemplateTaskCustomValueResponseCopyWith<$Res> {
  _$ProjectTemplateTaskCustomValueResponseCopyWithImpl(this._self, this._then);

  final ProjectTemplateTaskCustomValueResponse _self;
  final $Res Function(ProjectTemplateTaskCustomValueResponse) _then;

/// Create a copy of ProjectTemplateTaskCustomValueResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fieldSourceId = null,Object? value = freezed,}) {
  return _then(_self.copyWith(
fieldSourceId: null == fieldSourceId ? _self.fieldSourceId : fieldSourceId // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value ,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTemplateTaskCustomValueResponse].
extension ProjectTemplateTaskCustomValueResponsePatterns on ProjectTemplateTaskCustomValueResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTemplateTaskCustomValueResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTemplateTaskCustomValueResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTemplateTaskCustomValueResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateTaskCustomValueResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTemplateTaskCustomValueResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateTaskCustomValueResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fieldSourceId,  Object? value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTemplateTaskCustomValueResponse() when $default != null:
return $default(_that.fieldSourceId,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fieldSourceId,  Object? value)  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateTaskCustomValueResponse():
return $default(_that.fieldSourceId,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fieldSourceId,  Object? value)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateTaskCustomValueResponse() when $default != null:
return $default(_that.fieldSourceId,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTemplateTaskCustomValueResponse implements ProjectTemplateTaskCustomValueResponse {
  const _ProjectTemplateTaskCustomValueResponse({required this.fieldSourceId, required this.value});
  factory _ProjectTemplateTaskCustomValueResponse.fromJson(Map<String, dynamic> json) => _$ProjectTemplateTaskCustomValueResponseFromJson(json);

/// UUID definicji pola ze źródłowego szablonu.
@override final  String fieldSourceId;
/// Dowolna wartość JSON pola.
@override final  Object? value;

/// Create a copy of ProjectTemplateTaskCustomValueResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTemplateTaskCustomValueResponseCopyWith<_ProjectTemplateTaskCustomValueResponse> get copyWith => __$ProjectTemplateTaskCustomValueResponseCopyWithImpl<_ProjectTemplateTaskCustomValueResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTemplateTaskCustomValueResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTemplateTaskCustomValueResponse&&(identical(other.fieldSourceId, fieldSourceId) || other.fieldSourceId == fieldSourceId)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldSourceId,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'ProjectTemplateTaskCustomValueResponse(fieldSourceId: $fieldSourceId, value: $value)';
}


}

/// @nodoc
abstract mixin class _$ProjectTemplateTaskCustomValueResponseCopyWith<$Res> implements $ProjectTemplateTaskCustomValueResponseCopyWith<$Res> {
  factory _$ProjectTemplateTaskCustomValueResponseCopyWith(_ProjectTemplateTaskCustomValueResponse value, $Res Function(_ProjectTemplateTaskCustomValueResponse) _then) = __$ProjectTemplateTaskCustomValueResponseCopyWithImpl;
@override @useResult
$Res call({
 String fieldSourceId, Object? value
});




}
/// @nodoc
class __$ProjectTemplateTaskCustomValueResponseCopyWithImpl<$Res>
    implements _$ProjectTemplateTaskCustomValueResponseCopyWith<$Res> {
  __$ProjectTemplateTaskCustomValueResponseCopyWithImpl(this._self, this._then);

  final _ProjectTemplateTaskCustomValueResponse _self;
  final $Res Function(_ProjectTemplateTaskCustomValueResponse) _then;

/// Create a copy of ProjectTemplateTaskCustomValueResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fieldSourceId = null,Object? value = freezed,}) {
  return _then(_ProjectTemplateTaskCustomValueResponse(
fieldSourceId: null == fieldSourceId ? _self.fieldSourceId : fieldSourceId // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value ,
  ));
}


}


/// @nodoc
mixin _$ProjectTemplateCustomStatusResponse {

/// UUID statusu w projekcie źródłowym.
 String get sourceId;/// Nazwa kolumny.
 String get name;/// Kolor HEX kolumny.
 String get color;/// Kategoria analityczna statusu.
 String get category;/// Pozycja kolumny.
 int get position;/// Limit WIP albo null.
 int? get wipLimit;/// Czy kolumna jest domyślna dla nowych zadań.
 bool get isDefault;
/// Create a copy of ProjectTemplateCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTemplateCustomStatusResponseCopyWith<ProjectTemplateCustomStatusResponse> get copyWith => _$ProjectTemplateCustomStatusResponseCopyWithImpl<ProjectTemplateCustomStatusResponse>(this as ProjectTemplateCustomStatusResponse, _$identity);

  /// Serializes this ProjectTemplateCustomStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTemplateCustomStatusResponse&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.category, category) || other.category == category)&&(identical(other.position, position) || other.position == position)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,name,color,category,position,wipLimit,isDefault);

@override
String toString() {
  return 'ProjectTemplateCustomStatusResponse(sourceId: $sourceId, name: $name, color: $color, category: $category, position: $position, wipLimit: $wipLimit, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $ProjectTemplateCustomStatusResponseCopyWith<$Res>  {
  factory $ProjectTemplateCustomStatusResponseCopyWith(ProjectTemplateCustomStatusResponse value, $Res Function(ProjectTemplateCustomStatusResponse) _then) = _$ProjectTemplateCustomStatusResponseCopyWithImpl;
@useResult
$Res call({
 String sourceId, String name, String color, String category, int position, int? wipLimit, bool isDefault
});




}
/// @nodoc
class _$ProjectTemplateCustomStatusResponseCopyWithImpl<$Res>
    implements $ProjectTemplateCustomStatusResponseCopyWith<$Res> {
  _$ProjectTemplateCustomStatusResponseCopyWithImpl(this._self, this._then);

  final ProjectTemplateCustomStatusResponse _self;
  final $Res Function(ProjectTemplateCustomStatusResponse) _then;

/// Create a copy of ProjectTemplateCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceId = null,Object? name = null,Object? color = null,Object? category = null,Object? position = null,Object? wipLimit = freezed,Object? isDefault = null,}) {
  return _then(_self.copyWith(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTemplateCustomStatusResponse].
extension ProjectTemplateCustomStatusResponsePatterns on ProjectTemplateCustomStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTemplateCustomStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTemplateCustomStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTemplateCustomStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateCustomStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTemplateCustomStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateCustomStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceId,  String name,  String color,  String category,  int position,  int? wipLimit,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTemplateCustomStatusResponse() when $default != null:
return $default(_that.sourceId,_that.name,_that.color,_that.category,_that.position,_that.wipLimit,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceId,  String name,  String color,  String category,  int position,  int? wipLimit,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateCustomStatusResponse():
return $default(_that.sourceId,_that.name,_that.color,_that.category,_that.position,_that.wipLimit,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceId,  String name,  String color,  String category,  int position,  int? wipLimit,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateCustomStatusResponse() when $default != null:
return $default(_that.sourceId,_that.name,_that.color,_that.category,_that.position,_that.wipLimit,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTemplateCustomStatusResponse implements ProjectTemplateCustomStatusResponse {
  const _ProjectTemplateCustomStatusResponse({required this.sourceId, required this.name, required this.color, required this.category, required this.position, this.wipLimit, required this.isDefault});
  factory _ProjectTemplateCustomStatusResponse.fromJson(Map<String, dynamic> json) => _$ProjectTemplateCustomStatusResponseFromJson(json);

/// UUID statusu w projekcie źródłowym.
@override final  String sourceId;
/// Nazwa kolumny.
@override final  String name;
/// Kolor HEX kolumny.
@override final  String color;
/// Kategoria analityczna statusu.
@override final  String category;
/// Pozycja kolumny.
@override final  int position;
/// Limit WIP albo null.
@override final  int? wipLimit;
/// Czy kolumna jest domyślna dla nowych zadań.
@override final  bool isDefault;

/// Create a copy of ProjectTemplateCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTemplateCustomStatusResponseCopyWith<_ProjectTemplateCustomStatusResponse> get copyWith => __$ProjectTemplateCustomStatusResponseCopyWithImpl<_ProjectTemplateCustomStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTemplateCustomStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTemplateCustomStatusResponse&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.category, category) || other.category == category)&&(identical(other.position, position) || other.position == position)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceId,name,color,category,position,wipLimit,isDefault);

@override
String toString() {
  return 'ProjectTemplateCustomStatusResponse(sourceId: $sourceId, name: $name, color: $color, category: $category, position: $position, wipLimit: $wipLimit, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$ProjectTemplateCustomStatusResponseCopyWith<$Res> implements $ProjectTemplateCustomStatusResponseCopyWith<$Res> {
  factory _$ProjectTemplateCustomStatusResponseCopyWith(_ProjectTemplateCustomStatusResponse value, $Res Function(_ProjectTemplateCustomStatusResponse) _then) = __$ProjectTemplateCustomStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 String sourceId, String name, String color, String category, int position, int? wipLimit, bool isDefault
});




}
/// @nodoc
class __$ProjectTemplateCustomStatusResponseCopyWithImpl<$Res>
    implements _$ProjectTemplateCustomStatusResponseCopyWith<$Res> {
  __$ProjectTemplateCustomStatusResponseCopyWithImpl(this._self, this._then);

  final _ProjectTemplateCustomStatusResponse _self;
  final $Res Function(_ProjectTemplateCustomStatusResponse) _then;

/// Create a copy of ProjectTemplateCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceId = null,Object? name = null,Object? color = null,Object? category = null,Object? position = null,Object? wipLimit = freezed,Object? isDefault = null,}) {
  return _then(_ProjectTemplateCustomStatusResponse(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProjectTemplateTaskResponse {

/// UUID źródłowy zadania.
 String get sourceId;/// UUID źródłowego zadania nadrzędnego albo null.
 String? get parentSourceId;/// Tytuł zadania.
 String get title;/// Opis albo null.
 String? get description;/// Quill Delta JSON albo null.
 String? get descriptionDeltaJson;/// Status zapisany w szablonie.
 String get status;/// Priorytet zapisany w szablonie.
 String get priority;/// Typ zadania albo null.
 String? get taskType;/// Rozmiar albo null.
 int? get size;/// Złożoność albo null.
 int? get complexity;/// Ryzyko albo null.
 int? get risk;/// Wartość biznesowa albo null.
 int? get businessValue;/// Szacowany czas w minutach albo null.
 int? get estimatedMinutes;/// Początek zadania albo null.
 DateTime? get startAtUtc;/// Termin zadania albo null.
 DateTime? get dueAtUtc;/// Pozycja zadania.
 int get position;/// Pozycje checklisty.
 List<String> get checklist;/// Kryteria akceptacji.
 List<String> get acceptanceCriteria;/// UUID-y źródłowe etykiet.
 List<String> get labelSourceIds;/// UUID własnego statusu ze źródłowego projektu albo null.
 String? get customStatusSourceId;/// Wartości pól customowych.
 List<ProjectTemplateTaskCustomValueResponse> get customFieldValues;
/// Create a copy of ProjectTemplateTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTemplateTaskResponseCopyWith<ProjectTemplateTaskResponse> get copyWith => _$ProjectTemplateTaskResponseCopyWithImpl<ProjectTemplateTaskResponse>(this as ProjectTemplateTaskResponse, _$identity);

  /// Serializes this ProjectTemplateTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTemplateTaskResponse&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.parentSourceId, parentSourceId) || other.parentSourceId == parentSourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.labelSourceIds, labelSourceIds)&&(identical(other.customStatusSourceId, customStatusSourceId) || other.customStatusSourceId == customStatusSourceId)&&const DeepCollectionEquality().equals(other.customFieldValues, customFieldValues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,sourceId,parentSourceId,title,description,descriptionDeltaJson,status,priority,taskType,size,complexity,risk,businessValue,estimatedMinutes,startAtUtc,dueAtUtc,position,const DeepCollectionEquality().hash(checklist),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(labelSourceIds),customStatusSourceId,const DeepCollectionEquality().hash(customFieldValues)]);

@override
String toString() {
  return 'ProjectTemplateTaskResponse(sourceId: $sourceId, parentSourceId: $parentSourceId, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson, status: $status, priority: $priority, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, position: $position, checklist: $checklist, acceptanceCriteria: $acceptanceCriteria, labelSourceIds: $labelSourceIds, customStatusSourceId: $customStatusSourceId, customFieldValues: $customFieldValues)';
}


}

/// @nodoc
abstract mixin class $ProjectTemplateTaskResponseCopyWith<$Res>  {
  factory $ProjectTemplateTaskResponseCopyWith(ProjectTemplateTaskResponse value, $Res Function(ProjectTemplateTaskResponse) _then) = _$ProjectTemplateTaskResponseCopyWithImpl;
@useResult
$Res call({
 String sourceId, String? parentSourceId, String title, String? description, String? descriptionDeltaJson, String status, String priority, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, DateTime? startAtUtc, DateTime? dueAtUtc, int position, List<String> checklist, List<String> acceptanceCriteria, List<String> labelSourceIds, String? customStatusSourceId, List<ProjectTemplateTaskCustomValueResponse> customFieldValues
});




}
/// @nodoc
class _$ProjectTemplateTaskResponseCopyWithImpl<$Res>
    implements $ProjectTemplateTaskResponseCopyWith<$Res> {
  _$ProjectTemplateTaskResponseCopyWithImpl(this._self, this._then);

  final ProjectTemplateTaskResponse _self;
  final $Res Function(ProjectTemplateTaskResponse) _then;

/// Create a copy of ProjectTemplateTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceId = null,Object? parentSourceId = freezed,Object? title = null,Object? description = freezed,Object? descriptionDeltaJson = freezed,Object? status = null,Object? priority = null,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? position = null,Object? checklist = null,Object? acceptanceCriteria = null,Object? labelSourceIds = null,Object? customStatusSourceId = freezed,Object? customFieldValues = null,}) {
  return _then(_self.copyWith(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,parentSourceId: freezed == parentSourceId ? _self.parentSourceId : parentSourceId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<String>,acceptanceCriteria: null == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<String>,labelSourceIds: null == labelSourceIds ? _self.labelSourceIds : labelSourceIds // ignore: cast_nullable_to_non_nullable
as List<String>,customStatusSourceId: freezed == customStatusSourceId ? _self.customStatusSourceId : customStatusSourceId // ignore: cast_nullable_to_non_nullable
as String?,customFieldValues: null == customFieldValues ? _self.customFieldValues : customFieldValues // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateTaskCustomValueResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTemplateTaskResponse].
extension ProjectTemplateTaskResponsePatterns on ProjectTemplateTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTemplateTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTemplateTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTemplateTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTemplateTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceId,  String? parentSourceId,  String title,  String? description,  String? descriptionDeltaJson,  String status,  String priority,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  DateTime? startAtUtc,  DateTime? dueAtUtc,  int position,  List<String> checklist,  List<String> acceptanceCriteria,  List<String> labelSourceIds,  String? customStatusSourceId,  List<ProjectTemplateTaskCustomValueResponse> customFieldValues)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTemplateTaskResponse() when $default != null:
return $default(_that.sourceId,_that.parentSourceId,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.startAtUtc,_that.dueAtUtc,_that.position,_that.checklist,_that.acceptanceCriteria,_that.labelSourceIds,_that.customStatusSourceId,_that.customFieldValues);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceId,  String? parentSourceId,  String title,  String? description,  String? descriptionDeltaJson,  String status,  String priority,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  DateTime? startAtUtc,  DateTime? dueAtUtc,  int position,  List<String> checklist,  List<String> acceptanceCriteria,  List<String> labelSourceIds,  String? customStatusSourceId,  List<ProjectTemplateTaskCustomValueResponse> customFieldValues)  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateTaskResponse():
return $default(_that.sourceId,_that.parentSourceId,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.startAtUtc,_that.dueAtUtc,_that.position,_that.checklist,_that.acceptanceCriteria,_that.labelSourceIds,_that.customStatusSourceId,_that.customFieldValues);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceId,  String? parentSourceId,  String title,  String? description,  String? descriptionDeltaJson,  String status,  String priority,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  DateTime? startAtUtc,  DateTime? dueAtUtc,  int position,  List<String> checklist,  List<String> acceptanceCriteria,  List<String> labelSourceIds,  String? customStatusSourceId,  List<ProjectTemplateTaskCustomValueResponse> customFieldValues)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateTaskResponse() when $default != null:
return $default(_that.sourceId,_that.parentSourceId,_that.title,_that.description,_that.descriptionDeltaJson,_that.status,_that.priority,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.startAtUtc,_that.dueAtUtc,_that.position,_that.checklist,_that.acceptanceCriteria,_that.labelSourceIds,_that.customStatusSourceId,_that.customFieldValues);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTemplateTaskResponse implements ProjectTemplateTaskResponse {
  const _ProjectTemplateTaskResponse({required this.sourceId, this.parentSourceId, required this.title, this.description, this.descriptionDeltaJson, required this.status, required this.priority, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.startAtUtc, this.dueAtUtc, required this.position, required this.checklist, required this.acceptanceCriteria, required this.labelSourceIds, this.customStatusSourceId, required this.customFieldValues});
  factory _ProjectTemplateTaskResponse.fromJson(Map<String, dynamic> json) => _$ProjectTemplateTaskResponseFromJson(json);

/// UUID źródłowy zadania.
@override final  String sourceId;
/// UUID źródłowego zadania nadrzędnego albo null.
@override final  String? parentSourceId;
/// Tytuł zadania.
@override final  String title;
/// Opis albo null.
@override final  String? description;
/// Quill Delta JSON albo null.
@override final  String? descriptionDeltaJson;
/// Status zapisany w szablonie.
@override final  String status;
/// Priorytet zapisany w szablonie.
@override final  String priority;
/// Typ zadania albo null.
@override final  String? taskType;
/// Rozmiar albo null.
@override final  int? size;
/// Złożoność albo null.
@override final  int? complexity;
/// Ryzyko albo null.
@override final  int? risk;
/// Wartość biznesowa albo null.
@override final  int? businessValue;
/// Szacowany czas w minutach albo null.
@override final  int? estimatedMinutes;
/// Początek zadania albo null.
@override final  DateTime? startAtUtc;
/// Termin zadania albo null.
@override final  DateTime? dueAtUtc;
/// Pozycja zadania.
@override final  int position;
/// Pozycje checklisty.
@override final  List<String> checklist;
/// Kryteria akceptacji.
@override final  List<String> acceptanceCriteria;
/// UUID-y źródłowe etykiet.
@override final  List<String> labelSourceIds;
/// UUID własnego statusu ze źródłowego projektu albo null.
@override final  String? customStatusSourceId;
/// Wartości pól customowych.
@override final  List<ProjectTemplateTaskCustomValueResponse> customFieldValues;

/// Create a copy of ProjectTemplateTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTemplateTaskResponseCopyWith<_ProjectTemplateTaskResponse> get copyWith => __$ProjectTemplateTaskResponseCopyWithImpl<_ProjectTemplateTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTemplateTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTemplateTaskResponse&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.parentSourceId, parentSourceId) || other.parentSourceId == parentSourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionDeltaJson, descriptionDeltaJson) || other.descriptionDeltaJson == descriptionDeltaJson)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, acceptanceCriteria)&&const DeepCollectionEquality().equals(other.labelSourceIds, labelSourceIds)&&(identical(other.customStatusSourceId, customStatusSourceId) || other.customStatusSourceId == customStatusSourceId)&&const DeepCollectionEquality().equals(other.customFieldValues, customFieldValues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,sourceId,parentSourceId,title,description,descriptionDeltaJson,status,priority,taskType,size,complexity,risk,businessValue,estimatedMinutes,startAtUtc,dueAtUtc,position,const DeepCollectionEquality().hash(checklist),const DeepCollectionEquality().hash(acceptanceCriteria),const DeepCollectionEquality().hash(labelSourceIds),customStatusSourceId,const DeepCollectionEquality().hash(customFieldValues)]);

@override
String toString() {
  return 'ProjectTemplateTaskResponse(sourceId: $sourceId, parentSourceId: $parentSourceId, title: $title, description: $description, descriptionDeltaJson: $descriptionDeltaJson, status: $status, priority: $priority, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, position: $position, checklist: $checklist, acceptanceCriteria: $acceptanceCriteria, labelSourceIds: $labelSourceIds, customStatusSourceId: $customStatusSourceId, customFieldValues: $customFieldValues)';
}


}

/// @nodoc
abstract mixin class _$ProjectTemplateTaskResponseCopyWith<$Res> implements $ProjectTemplateTaskResponseCopyWith<$Res> {
  factory _$ProjectTemplateTaskResponseCopyWith(_ProjectTemplateTaskResponse value, $Res Function(_ProjectTemplateTaskResponse) _then) = __$ProjectTemplateTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String sourceId, String? parentSourceId, String title, String? description, String? descriptionDeltaJson, String status, String priority, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, DateTime? startAtUtc, DateTime? dueAtUtc, int position, List<String> checklist, List<String> acceptanceCriteria, List<String> labelSourceIds, String? customStatusSourceId, List<ProjectTemplateTaskCustomValueResponse> customFieldValues
});




}
/// @nodoc
class __$ProjectTemplateTaskResponseCopyWithImpl<$Res>
    implements _$ProjectTemplateTaskResponseCopyWith<$Res> {
  __$ProjectTemplateTaskResponseCopyWithImpl(this._self, this._then);

  final _ProjectTemplateTaskResponse _self;
  final $Res Function(_ProjectTemplateTaskResponse) _then;

/// Create a copy of ProjectTemplateTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceId = null,Object? parentSourceId = freezed,Object? title = null,Object? description = freezed,Object? descriptionDeltaJson = freezed,Object? status = null,Object? priority = null,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? position = null,Object? checklist = null,Object? acceptanceCriteria = null,Object? labelSourceIds = null,Object? customStatusSourceId = freezed,Object? customFieldValues = null,}) {
  return _then(_ProjectTemplateTaskResponse(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,parentSourceId: freezed == parentSourceId ? _self.parentSourceId : parentSourceId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionDeltaJson: freezed == descriptionDeltaJson ? _self.descriptionDeltaJson : descriptionDeltaJson // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<String>,acceptanceCriteria: null == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<String>,labelSourceIds: null == labelSourceIds ? _self.labelSourceIds : labelSourceIds // ignore: cast_nullable_to_non_nullable
as List<String>,customStatusSourceId: freezed == customStatusSourceId ? _self.customStatusSourceId : customStatusSourceId // ignore: cast_nullable_to_non_nullable
as String?,customFieldValues: null == customFieldValues ? _self.customFieldValues : customFieldValues // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateTaskCustomValueResponse>,
  ));
}


}


/// @nodoc
mixin _$ProjectTemplateDetailsResponse {

/// UUID szablonu.
 String get id;/// Nazwa szablonu.
 String get name;/// Opis albo null.
 String? get description;/// Ikona albo null.
 String? get icon;/// Kolor główny albo null.
 String? get primaryColor;/// Widoczność projektu zapisana jako tekst kontraktu C#.
 String get visibility;/// Status projektu zapisany jako tekst kontraktu C#.
 String get status;/// Statusy workflow.
 List<ProjectTemplateWorkflowResponse> get workflow;/// Przejścia workflow.
 List<ProjectTemplateTransitionResponse> get transitions;/// Własne kolumny Kanbanu projektu.
 List<ProjectTemplateCustomStatusResponse>? get customStatuses;/// Etykiety szablonu.
 List<ProjectTemplateDefinitionResponse> get labels;/// Pola customowe szablonu.
 List<ProjectTemplateDefinitionResponse> get customFields;/// Zadania szablonu.
 List<ProjectTemplateTaskResponse> get tasks;/// Czas aktualizacji.
 DateTime get updatedAtUtc;/// Wersja szablonu.
 int get version;
/// Create a copy of ProjectTemplateDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTemplateDetailsResponseCopyWith<ProjectTemplateDetailsResponse> get copyWith => _$ProjectTemplateDetailsResponseCopyWithImpl<ProjectTemplateDetailsResponse>(this as ProjectTemplateDetailsResponse, _$identity);

  /// Serializes this ProjectTemplateDetailsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTemplateDetailsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.workflow, workflow)&&const DeepCollectionEquality().equals(other.transitions, transitions)&&const DeepCollectionEquality().equals(other.customStatuses, customStatuses)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,icon,primaryColor,visibility,status,const DeepCollectionEquality().hash(workflow),const DeepCollectionEquality().hash(transitions),const DeepCollectionEquality().hash(customStatuses),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFields),const DeepCollectionEquality().hash(tasks),updatedAtUtc,version);

@override
String toString() {
  return 'ProjectTemplateDetailsResponse(id: $id, name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status, workflow: $workflow, transitions: $transitions, customStatuses: $customStatuses, labels: $labels, customFields: $customFields, tasks: $tasks, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $ProjectTemplateDetailsResponseCopyWith<$Res>  {
  factory $ProjectTemplateDetailsResponseCopyWith(ProjectTemplateDetailsResponse value, $Res Function(ProjectTemplateDetailsResponse) _then) = _$ProjectTemplateDetailsResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? icon, String? primaryColor, String visibility, String status, List<ProjectTemplateWorkflowResponse> workflow, List<ProjectTemplateTransitionResponse> transitions, List<ProjectTemplateCustomStatusResponse>? customStatuses, List<ProjectTemplateDefinitionResponse> labels, List<ProjectTemplateDefinitionResponse> customFields, List<ProjectTemplateTaskResponse> tasks, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$ProjectTemplateDetailsResponseCopyWithImpl<$Res>
    implements $ProjectTemplateDetailsResponseCopyWith<$Res> {
  _$ProjectTemplateDetailsResponseCopyWithImpl(this._self, this._then);

  final ProjectTemplateDetailsResponse _self;
  final $Res Function(ProjectTemplateDetailsResponse) _then;

/// Create a copy of ProjectTemplateDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,Object? workflow = null,Object? transitions = null,Object? customStatuses = freezed,Object? labels = null,Object? customFields = null,Object? tasks = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateWorkflowResponse>,transitions: null == transitions ? _self.transitions : transitions // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateTransitionResponse>,customStatuses: freezed == customStatuses ? _self.customStatuses : customStatuses // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateCustomStatusResponse>?,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateDefinitionResponse>,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateDefinitionResponse>,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateTaskResponse>,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTemplateDetailsResponse].
extension ProjectTemplateDetailsResponsePatterns on ProjectTemplateDetailsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTemplateDetailsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTemplateDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTemplateDetailsResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateDetailsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTemplateDetailsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTemplateDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? icon,  String? primaryColor,  String visibility,  String status,  List<ProjectTemplateWorkflowResponse> workflow,  List<ProjectTemplateTransitionResponse> transitions,  List<ProjectTemplateCustomStatusResponse>? customStatuses,  List<ProjectTemplateDefinitionResponse> labels,  List<ProjectTemplateDefinitionResponse> customFields,  List<ProjectTemplateTaskResponse> tasks,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTemplateDetailsResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.workflow,_that.transitions,_that.customStatuses,_that.labels,_that.customFields,_that.tasks,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? icon,  String? primaryColor,  String visibility,  String status,  List<ProjectTemplateWorkflowResponse> workflow,  List<ProjectTemplateTransitionResponse> transitions,  List<ProjectTemplateCustomStatusResponse>? customStatuses,  List<ProjectTemplateDefinitionResponse> labels,  List<ProjectTemplateDefinitionResponse> customFields,  List<ProjectTemplateTaskResponse> tasks,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateDetailsResponse():
return $default(_that.id,_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.workflow,_that.transitions,_that.customStatuses,_that.labels,_that.customFields,_that.tasks,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? icon,  String? primaryColor,  String visibility,  String status,  List<ProjectTemplateWorkflowResponse> workflow,  List<ProjectTemplateTransitionResponse> transitions,  List<ProjectTemplateCustomStatusResponse>? customStatuses,  List<ProjectTemplateDefinitionResponse> labels,  List<ProjectTemplateDefinitionResponse> customFields,  List<ProjectTemplateTaskResponse> tasks,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTemplateDetailsResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.workflow,_that.transitions,_that.customStatuses,_that.labels,_that.customFields,_that.tasks,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTemplateDetailsResponse implements ProjectTemplateDetailsResponse {
  const _ProjectTemplateDetailsResponse({required this.id, required this.name, this.description, this.icon, this.primaryColor, required this.visibility, required this.status, required this.workflow, required this.transitions, this.customStatuses, required this.labels, required this.customFields, required this.tasks, required this.updatedAtUtc, required this.version});
  factory _ProjectTemplateDetailsResponse.fromJson(Map<String, dynamic> json) => _$ProjectTemplateDetailsResponseFromJson(json);

/// UUID szablonu.
@override final  String id;
/// Nazwa szablonu.
@override final  String name;
/// Opis albo null.
@override final  String? description;
/// Ikona albo null.
@override final  String? icon;
/// Kolor główny albo null.
@override final  String? primaryColor;
/// Widoczność projektu zapisana jako tekst kontraktu C#.
@override final  String visibility;
/// Status projektu zapisany jako tekst kontraktu C#.
@override final  String status;
/// Statusy workflow.
@override final  List<ProjectTemplateWorkflowResponse> workflow;
/// Przejścia workflow.
@override final  List<ProjectTemplateTransitionResponse> transitions;
/// Własne kolumny Kanbanu projektu.
@override final  List<ProjectTemplateCustomStatusResponse>? customStatuses;
/// Etykiety szablonu.
@override final  List<ProjectTemplateDefinitionResponse> labels;
/// Pola customowe szablonu.
@override final  List<ProjectTemplateDefinitionResponse> customFields;
/// Zadania szablonu.
@override final  List<ProjectTemplateTaskResponse> tasks;
/// Czas aktualizacji.
@override final  DateTime updatedAtUtc;
/// Wersja szablonu.
@override final  int version;

/// Create a copy of ProjectTemplateDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTemplateDetailsResponseCopyWith<_ProjectTemplateDetailsResponse> get copyWith => __$ProjectTemplateDetailsResponseCopyWithImpl<_ProjectTemplateDetailsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTemplateDetailsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTemplateDetailsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.workflow, workflow)&&const DeepCollectionEquality().equals(other.transitions, transitions)&&const DeepCollectionEquality().equals(other.customStatuses, customStatuses)&&const DeepCollectionEquality().equals(other.labels, labels)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,icon,primaryColor,visibility,status,const DeepCollectionEquality().hash(workflow),const DeepCollectionEquality().hash(transitions),const DeepCollectionEquality().hash(customStatuses),const DeepCollectionEquality().hash(labels),const DeepCollectionEquality().hash(customFields),const DeepCollectionEquality().hash(tasks),updatedAtUtc,version);

@override
String toString() {
  return 'ProjectTemplateDetailsResponse(id: $id, name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status, workflow: $workflow, transitions: $transitions, customStatuses: $customStatuses, labels: $labels, customFields: $customFields, tasks: $tasks, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ProjectTemplateDetailsResponseCopyWith<$Res> implements $ProjectTemplateDetailsResponseCopyWith<$Res> {
  factory _$ProjectTemplateDetailsResponseCopyWith(_ProjectTemplateDetailsResponse value, $Res Function(_ProjectTemplateDetailsResponse) _then) = __$ProjectTemplateDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? icon, String? primaryColor, String visibility, String status, List<ProjectTemplateWorkflowResponse> workflow, List<ProjectTemplateTransitionResponse> transitions, List<ProjectTemplateCustomStatusResponse>? customStatuses, List<ProjectTemplateDefinitionResponse> labels, List<ProjectTemplateDefinitionResponse> customFields, List<ProjectTemplateTaskResponse> tasks, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$ProjectTemplateDetailsResponseCopyWithImpl<$Res>
    implements _$ProjectTemplateDetailsResponseCopyWith<$Res> {
  __$ProjectTemplateDetailsResponseCopyWithImpl(this._self, this._then);

  final _ProjectTemplateDetailsResponse _self;
  final $Res Function(_ProjectTemplateDetailsResponse) _then;

/// Create a copy of ProjectTemplateDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,Object? workflow = null,Object? transitions = null,Object? customStatuses = freezed,Object? labels = null,Object? customFields = null,Object? tasks = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_ProjectTemplateDetailsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateWorkflowResponse>,transitions: null == transitions ? _self.transitions : transitions // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateTransitionResponse>,customStatuses: freezed == customStatuses ? _self.customStatuses : customStatuses // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateCustomStatusResponse>?,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateDefinitionResponse>,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateDefinitionResponse>,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<ProjectTemplateTaskResponse>,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ApplyProjectTemplateResponse {

/// Utworzony projekt.
 ProjectResponse get project;/// Mapowanie zadań źródłowych na nowe.
 List<TemplateIdMappingResponse> get taskIdMappings;/// Mapowanie etykiet źródłowych na nowe.
 List<TemplateIdMappingResponse> get labelIdMappings;/// Mapowanie pól customowych źródłowych na nowe.
 List<TemplateIdMappingResponse> get customFieldIdMappings;/// Mapowanie własnych statusów Kanbanu źródłowych na nowe.
 List<TemplateIdMappingResponse>? get customStatusIdMappings;
/// Create a copy of ApplyProjectTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyProjectTemplateResponseCopyWith<ApplyProjectTemplateResponse> get copyWith => _$ApplyProjectTemplateResponseCopyWithImpl<ApplyProjectTemplateResponse>(this as ApplyProjectTemplateResponse, _$identity);

  /// Serializes this ApplyProjectTemplateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyProjectTemplateResponse&&(identical(other.project, project) || other.project == project)&&const DeepCollectionEquality().equals(other.taskIdMappings, taskIdMappings)&&const DeepCollectionEquality().equals(other.labelIdMappings, labelIdMappings)&&const DeepCollectionEquality().equals(other.customFieldIdMappings, customFieldIdMappings)&&const DeepCollectionEquality().equals(other.customStatusIdMappings, customStatusIdMappings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,project,const DeepCollectionEquality().hash(taskIdMappings),const DeepCollectionEquality().hash(labelIdMappings),const DeepCollectionEquality().hash(customFieldIdMappings),const DeepCollectionEquality().hash(customStatusIdMappings));

@override
String toString() {
  return 'ApplyProjectTemplateResponse(project: $project, taskIdMappings: $taskIdMappings, labelIdMappings: $labelIdMappings, customFieldIdMappings: $customFieldIdMappings, customStatusIdMappings: $customStatusIdMappings)';
}


}

/// @nodoc
abstract mixin class $ApplyProjectTemplateResponseCopyWith<$Res>  {
  factory $ApplyProjectTemplateResponseCopyWith(ApplyProjectTemplateResponse value, $Res Function(ApplyProjectTemplateResponse) _then) = _$ApplyProjectTemplateResponseCopyWithImpl;
@useResult
$Res call({
 ProjectResponse project, List<TemplateIdMappingResponse> taskIdMappings, List<TemplateIdMappingResponse> labelIdMappings, List<TemplateIdMappingResponse> customFieldIdMappings, List<TemplateIdMappingResponse>? customStatusIdMappings
});


$ProjectResponseCopyWith<$Res> get project;

}
/// @nodoc
class _$ApplyProjectTemplateResponseCopyWithImpl<$Res>
    implements $ApplyProjectTemplateResponseCopyWith<$Res> {
  _$ApplyProjectTemplateResponseCopyWithImpl(this._self, this._then);

  final ApplyProjectTemplateResponse _self;
  final $Res Function(ApplyProjectTemplateResponse) _then;

/// Create a copy of ApplyProjectTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? project = null,Object? taskIdMappings = null,Object? labelIdMappings = null,Object? customFieldIdMappings = null,Object? customStatusIdMappings = freezed,}) {
  return _then(_self.copyWith(
project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectResponse,taskIdMappings: null == taskIdMappings ? _self.taskIdMappings : taskIdMappings // ignore: cast_nullable_to_non_nullable
as List<TemplateIdMappingResponse>,labelIdMappings: null == labelIdMappings ? _self.labelIdMappings : labelIdMappings // ignore: cast_nullable_to_non_nullable
as List<TemplateIdMappingResponse>,customFieldIdMappings: null == customFieldIdMappings ? _self.customFieldIdMappings : customFieldIdMappings // ignore: cast_nullable_to_non_nullable
as List<TemplateIdMappingResponse>,customStatusIdMappings: freezed == customStatusIdMappings ? _self.customStatusIdMappings : customStatusIdMappings // ignore: cast_nullable_to_non_nullable
as List<TemplateIdMappingResponse>?,
  ));
}
/// Create a copy of ApplyProjectTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectResponseCopyWith<$Res> get project {
  
  return $ProjectResponseCopyWith<$Res>(_self.project, (value) {
    return _then(_self.copyWith(project: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApplyProjectTemplateResponse].
extension ApplyProjectTemplateResponsePatterns on ApplyProjectTemplateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplyProjectTemplateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplyProjectTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplyProjectTemplateResponse value)  $default,){
final _that = this;
switch (_that) {
case _ApplyProjectTemplateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplyProjectTemplateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ApplyProjectTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectResponse project,  List<TemplateIdMappingResponse> taskIdMappings,  List<TemplateIdMappingResponse> labelIdMappings,  List<TemplateIdMappingResponse> customFieldIdMappings,  List<TemplateIdMappingResponse>? customStatusIdMappings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplyProjectTemplateResponse() when $default != null:
return $default(_that.project,_that.taskIdMappings,_that.labelIdMappings,_that.customFieldIdMappings,_that.customStatusIdMappings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectResponse project,  List<TemplateIdMappingResponse> taskIdMappings,  List<TemplateIdMappingResponse> labelIdMappings,  List<TemplateIdMappingResponse> customFieldIdMappings,  List<TemplateIdMappingResponse>? customStatusIdMappings)  $default,) {final _that = this;
switch (_that) {
case _ApplyProjectTemplateResponse():
return $default(_that.project,_that.taskIdMappings,_that.labelIdMappings,_that.customFieldIdMappings,_that.customStatusIdMappings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectResponse project,  List<TemplateIdMappingResponse> taskIdMappings,  List<TemplateIdMappingResponse> labelIdMappings,  List<TemplateIdMappingResponse> customFieldIdMappings,  List<TemplateIdMappingResponse>? customStatusIdMappings)?  $default,) {final _that = this;
switch (_that) {
case _ApplyProjectTemplateResponse() when $default != null:
return $default(_that.project,_that.taskIdMappings,_that.labelIdMappings,_that.customFieldIdMappings,_that.customStatusIdMappings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplyProjectTemplateResponse implements ApplyProjectTemplateResponse {
  const _ApplyProjectTemplateResponse({required this.project, required this.taskIdMappings, required this.labelIdMappings, required this.customFieldIdMappings, this.customStatusIdMappings});
  factory _ApplyProjectTemplateResponse.fromJson(Map<String, dynamic> json) => _$ApplyProjectTemplateResponseFromJson(json);

/// Utworzony projekt.
@override final  ProjectResponse project;
/// Mapowanie zadań źródłowych na nowe.
@override final  List<TemplateIdMappingResponse> taskIdMappings;
/// Mapowanie etykiet źródłowych na nowe.
@override final  List<TemplateIdMappingResponse> labelIdMappings;
/// Mapowanie pól customowych źródłowych na nowe.
@override final  List<TemplateIdMappingResponse> customFieldIdMappings;
/// Mapowanie własnych statusów Kanbanu źródłowych na nowe.
@override final  List<TemplateIdMappingResponse>? customStatusIdMappings;

/// Create a copy of ApplyProjectTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplyProjectTemplateResponseCopyWith<_ApplyProjectTemplateResponse> get copyWith => __$ApplyProjectTemplateResponseCopyWithImpl<_ApplyProjectTemplateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplyProjectTemplateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplyProjectTemplateResponse&&(identical(other.project, project) || other.project == project)&&const DeepCollectionEquality().equals(other.taskIdMappings, taskIdMappings)&&const DeepCollectionEquality().equals(other.labelIdMappings, labelIdMappings)&&const DeepCollectionEquality().equals(other.customFieldIdMappings, customFieldIdMappings)&&const DeepCollectionEquality().equals(other.customStatusIdMappings, customStatusIdMappings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,project,const DeepCollectionEquality().hash(taskIdMappings),const DeepCollectionEquality().hash(labelIdMappings),const DeepCollectionEquality().hash(customFieldIdMappings),const DeepCollectionEquality().hash(customStatusIdMappings));

@override
String toString() {
  return 'ApplyProjectTemplateResponse(project: $project, taskIdMappings: $taskIdMappings, labelIdMappings: $labelIdMappings, customFieldIdMappings: $customFieldIdMappings, customStatusIdMappings: $customStatusIdMappings)';
}


}

/// @nodoc
abstract mixin class _$ApplyProjectTemplateResponseCopyWith<$Res> implements $ApplyProjectTemplateResponseCopyWith<$Res> {
  factory _$ApplyProjectTemplateResponseCopyWith(_ApplyProjectTemplateResponse value, $Res Function(_ApplyProjectTemplateResponse) _then) = __$ApplyProjectTemplateResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectResponse project, List<TemplateIdMappingResponse> taskIdMappings, List<TemplateIdMappingResponse> labelIdMappings, List<TemplateIdMappingResponse> customFieldIdMappings, List<TemplateIdMappingResponse>? customStatusIdMappings
});


@override $ProjectResponseCopyWith<$Res> get project;

}
/// @nodoc
class __$ApplyProjectTemplateResponseCopyWithImpl<$Res>
    implements _$ApplyProjectTemplateResponseCopyWith<$Res> {
  __$ApplyProjectTemplateResponseCopyWithImpl(this._self, this._then);

  final _ApplyProjectTemplateResponse _self;
  final $Res Function(_ApplyProjectTemplateResponse) _then;

/// Create a copy of ApplyProjectTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? project = null,Object? taskIdMappings = null,Object? labelIdMappings = null,Object? customFieldIdMappings = null,Object? customStatusIdMappings = freezed,}) {
  return _then(_ApplyProjectTemplateResponse(
project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectResponse,taskIdMappings: null == taskIdMappings ? _self.taskIdMappings : taskIdMappings // ignore: cast_nullable_to_non_nullable
as List<TemplateIdMappingResponse>,labelIdMappings: null == labelIdMappings ? _self.labelIdMappings : labelIdMappings // ignore: cast_nullable_to_non_nullable
as List<TemplateIdMappingResponse>,customFieldIdMappings: null == customFieldIdMappings ? _self.customFieldIdMappings : customFieldIdMappings // ignore: cast_nullable_to_non_nullable
as List<TemplateIdMappingResponse>,customStatusIdMappings: freezed == customStatusIdMappings ? _self.customStatusIdMappings : customStatusIdMappings // ignore: cast_nullable_to_non_nullable
as List<TemplateIdMappingResponse>?,
  ));
}

/// Create a copy of ApplyProjectTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectResponseCopyWith<$Res> get project {
  
  return $ProjectResponseCopyWith<$Res>(_self.project, (value) {
    return _then(_self.copyWith(project: value));
  });
}
}

// dart format on
