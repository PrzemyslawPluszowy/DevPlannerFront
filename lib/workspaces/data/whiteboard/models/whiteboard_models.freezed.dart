// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'whiteboard_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateWhiteboardPayload {

 String get name; String? get description; String get type;
/// Create a copy of CreateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWhiteboardPayloadCopyWith<CreateWhiteboardPayload> get copyWith => _$CreateWhiteboardPayloadCopyWithImpl<CreateWhiteboardPayload>(this as CreateWhiteboardPayload, _$identity);

  /// Serializes this CreateWhiteboardPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWhiteboardPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,type);

@override
String toString() {
  return 'CreateWhiteboardPayload(name: $name, description: $description, type: $type)';
}


}

/// @nodoc
abstract mixin class $CreateWhiteboardPayloadCopyWith<$Res>  {
  factory $CreateWhiteboardPayloadCopyWith(CreateWhiteboardPayload value, $Res Function(CreateWhiteboardPayload) _then) = _$CreateWhiteboardPayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description, String type
});




}
/// @nodoc
class _$CreateWhiteboardPayloadCopyWithImpl<$Res>
    implements $CreateWhiteboardPayloadCopyWith<$Res> {
  _$CreateWhiteboardPayloadCopyWithImpl(this._self, this._then);

  final CreateWhiteboardPayload _self;
  final $Res Function(CreateWhiteboardPayload) _then;

/// Create a copy of CreateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWhiteboardPayload].
extension CreateWhiteboardPayloadPatterns on CreateWhiteboardPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWhiteboardPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWhiteboardPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWhiteboardPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateWhiteboardPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWhiteboardPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWhiteboardPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWhiteboardPayload() when $default != null:
return $default(_that.name,_that.description,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  String type)  $default,) {final _that = this;
switch (_that) {
case _CreateWhiteboardPayload():
return $default(_that.name,_that.description,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  String type)?  $default,) {final _that = this;
switch (_that) {
case _CreateWhiteboardPayload() when $default != null:
return $default(_that.name,_that.description,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWhiteboardPayload implements CreateWhiteboardPayload {
  const _CreateWhiteboardPayload({required this.name, this.description, this.type = 'Canvas'});
  factory _CreateWhiteboardPayload.fromJson(Map<String, dynamic> json) => _$CreateWhiteboardPayloadFromJson(json);

@override final  String name;
@override final  String? description;
@override@JsonKey() final  String type;

/// Create a copy of CreateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWhiteboardPayloadCopyWith<_CreateWhiteboardPayload> get copyWith => __$CreateWhiteboardPayloadCopyWithImpl<_CreateWhiteboardPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWhiteboardPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWhiteboardPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,type);

@override
String toString() {
  return 'CreateWhiteboardPayload(name: $name, description: $description, type: $type)';
}


}

/// @nodoc
abstract mixin class _$CreateWhiteboardPayloadCopyWith<$Res> implements $CreateWhiteboardPayloadCopyWith<$Res> {
  factory _$CreateWhiteboardPayloadCopyWith(_CreateWhiteboardPayload value, $Res Function(_CreateWhiteboardPayload) _then) = __$CreateWhiteboardPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, String type
});




}
/// @nodoc
class __$CreateWhiteboardPayloadCopyWithImpl<$Res>
    implements _$CreateWhiteboardPayloadCopyWith<$Res> {
  __$CreateWhiteboardPayloadCopyWithImpl(this._self, this._then);

  final _CreateWhiteboardPayload _self;
  final $Res Function(_CreateWhiteboardPayload) _then;

/// Create a copy of CreateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? type = null,}) {
  return _then(_CreateWhiteboardPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpdateWhiteboardPayload {

 String get name; String? get description; int get expectedVersion;
/// Create a copy of UpdateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWhiteboardPayloadCopyWith<UpdateWhiteboardPayload> get copyWith => _$UpdateWhiteboardPayloadCopyWithImpl<UpdateWhiteboardPayload>(this as UpdateWhiteboardPayload, _$identity);

  /// Serializes this UpdateWhiteboardPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWhiteboardPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,expectedVersion);

@override
String toString() {
  return 'UpdateWhiteboardPayload(name: $name, description: $description, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateWhiteboardPayloadCopyWith<$Res>  {
  factory $UpdateWhiteboardPayloadCopyWith(UpdateWhiteboardPayload value, $Res Function(UpdateWhiteboardPayload) _then) = _$UpdateWhiteboardPayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description, int expectedVersion
});




}
/// @nodoc
class _$UpdateWhiteboardPayloadCopyWithImpl<$Res>
    implements $UpdateWhiteboardPayloadCopyWith<$Res> {
  _$UpdateWhiteboardPayloadCopyWithImpl(this._self, this._then);

  final UpdateWhiteboardPayload _self;
  final $Res Function(UpdateWhiteboardPayload) _then;

/// Create a copy of UpdateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWhiteboardPayload].
extension UpdateWhiteboardPayloadPatterns on UpdateWhiteboardPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWhiteboardPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWhiteboardPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWhiteboardPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWhiteboardPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWhiteboardPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWhiteboardPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWhiteboardPayload() when $default != null:
return $default(_that.name,_that.description,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateWhiteboardPayload():
return $default(_that.name,_that.description,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWhiteboardPayload() when $default != null:
return $default(_that.name,_that.description,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWhiteboardPayload implements UpdateWhiteboardPayload {
  const _UpdateWhiteboardPayload({required this.name, this.description, required this.expectedVersion});
  factory _UpdateWhiteboardPayload.fromJson(Map<String, dynamic> json) => _$UpdateWhiteboardPayloadFromJson(json);

@override final  String name;
@override final  String? description;
@override final  int expectedVersion;

/// Create a copy of UpdateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWhiteboardPayloadCopyWith<_UpdateWhiteboardPayload> get copyWith => __$UpdateWhiteboardPayloadCopyWithImpl<_UpdateWhiteboardPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWhiteboardPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWhiteboardPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,expectedVersion);

@override
String toString() {
  return 'UpdateWhiteboardPayload(name: $name, description: $description, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateWhiteboardPayloadCopyWith<$Res> implements $UpdateWhiteboardPayloadCopyWith<$Res> {
  factory _$UpdateWhiteboardPayloadCopyWith(_UpdateWhiteboardPayload value, $Res Function(_UpdateWhiteboardPayload) _then) = __$UpdateWhiteboardPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, int expectedVersion
});




}
/// @nodoc
class __$UpdateWhiteboardPayloadCopyWithImpl<$Res>
    implements _$UpdateWhiteboardPayloadCopyWith<$Res> {
  __$UpdateWhiteboardPayloadCopyWithImpl(this._self, this._then);

  final _UpdateWhiteboardPayload _self;
  final $Res Function(_UpdateWhiteboardPayload) _then;

/// Create a copy of UpdateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? expectedVersion = null,}) {
  return _then(_UpdateWhiteboardPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateWhiteboardPagePayload {

 String get name; String get orientation; String get pageFormat; int? get position; String? get clientOperationId;
/// Create a copy of CreateWhiteboardPagePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWhiteboardPagePayloadCopyWith<CreateWhiteboardPagePayload> get copyWith => _$CreateWhiteboardPagePayloadCopyWithImpl<CreateWhiteboardPagePayload>(this as CreateWhiteboardPagePayload, _$identity);

  /// Serializes this CreateWhiteboardPagePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWhiteboardPagePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.pageFormat, pageFormat) || other.pageFormat == pageFormat)&&(identical(other.position, position) || other.position == position)&&(identical(other.clientOperationId, clientOperationId) || other.clientOperationId == clientOperationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,orientation,pageFormat,position,clientOperationId);

@override
String toString() {
  return 'CreateWhiteboardPagePayload(name: $name, orientation: $orientation, pageFormat: $pageFormat, position: $position, clientOperationId: $clientOperationId)';
}


}

/// @nodoc
abstract mixin class $CreateWhiteboardPagePayloadCopyWith<$Res>  {
  factory $CreateWhiteboardPagePayloadCopyWith(CreateWhiteboardPagePayload value, $Res Function(CreateWhiteboardPagePayload) _then) = _$CreateWhiteboardPagePayloadCopyWithImpl;
@useResult
$Res call({
 String name, String orientation, String pageFormat, int? position, String? clientOperationId
});




}
/// @nodoc
class _$CreateWhiteboardPagePayloadCopyWithImpl<$Res>
    implements $CreateWhiteboardPagePayloadCopyWith<$Res> {
  _$CreateWhiteboardPagePayloadCopyWithImpl(this._self, this._then);

  final CreateWhiteboardPagePayload _self;
  final $Res Function(CreateWhiteboardPagePayload) _then;

/// Create a copy of CreateWhiteboardPagePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? orientation = null,Object? pageFormat = null,Object? position = freezed,Object? clientOperationId = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as String,pageFormat: null == pageFormat ? _self.pageFormat : pageFormat // ignore: cast_nullable_to_non_nullable
as String,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,clientOperationId: freezed == clientOperationId ? _self.clientOperationId : clientOperationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWhiteboardPagePayload].
extension CreateWhiteboardPagePayloadPatterns on CreateWhiteboardPagePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWhiteboardPagePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWhiteboardPagePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWhiteboardPagePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateWhiteboardPagePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWhiteboardPagePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWhiteboardPagePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String orientation,  String pageFormat,  int? position,  String? clientOperationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWhiteboardPagePayload() when $default != null:
return $default(_that.name,_that.orientation,_that.pageFormat,_that.position,_that.clientOperationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String orientation,  String pageFormat,  int? position,  String? clientOperationId)  $default,) {final _that = this;
switch (_that) {
case _CreateWhiteboardPagePayload():
return $default(_that.name,_that.orientation,_that.pageFormat,_that.position,_that.clientOperationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String orientation,  String pageFormat,  int? position,  String? clientOperationId)?  $default,) {final _that = this;
switch (_that) {
case _CreateWhiteboardPagePayload() when $default != null:
return $default(_that.name,_that.orientation,_that.pageFormat,_that.position,_that.clientOperationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWhiteboardPagePayload implements CreateWhiteboardPagePayload {
  const _CreateWhiteboardPagePayload({required this.name, this.orientation = 'Portrait', this.pageFormat = 'A4', this.position, this.clientOperationId});
  factory _CreateWhiteboardPagePayload.fromJson(Map<String, dynamic> json) => _$CreateWhiteboardPagePayloadFromJson(json);

@override final  String name;
@override@JsonKey() final  String orientation;
@override@JsonKey() final  String pageFormat;
@override final  int? position;
@override final  String? clientOperationId;

/// Create a copy of CreateWhiteboardPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWhiteboardPagePayloadCopyWith<_CreateWhiteboardPagePayload> get copyWith => __$CreateWhiteboardPagePayloadCopyWithImpl<_CreateWhiteboardPagePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWhiteboardPagePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWhiteboardPagePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.pageFormat, pageFormat) || other.pageFormat == pageFormat)&&(identical(other.position, position) || other.position == position)&&(identical(other.clientOperationId, clientOperationId) || other.clientOperationId == clientOperationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,orientation,pageFormat,position,clientOperationId);

@override
String toString() {
  return 'CreateWhiteboardPagePayload(name: $name, orientation: $orientation, pageFormat: $pageFormat, position: $position, clientOperationId: $clientOperationId)';
}


}

/// @nodoc
abstract mixin class _$CreateWhiteboardPagePayloadCopyWith<$Res> implements $CreateWhiteboardPagePayloadCopyWith<$Res> {
  factory _$CreateWhiteboardPagePayloadCopyWith(_CreateWhiteboardPagePayload value, $Res Function(_CreateWhiteboardPagePayload) _then) = __$CreateWhiteboardPagePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String orientation, String pageFormat, int? position, String? clientOperationId
});




}
/// @nodoc
class __$CreateWhiteboardPagePayloadCopyWithImpl<$Res>
    implements _$CreateWhiteboardPagePayloadCopyWith<$Res> {
  __$CreateWhiteboardPagePayloadCopyWithImpl(this._self, this._then);

  final _CreateWhiteboardPagePayload _self;
  final $Res Function(_CreateWhiteboardPagePayload) _then;

/// Create a copy of CreateWhiteboardPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? orientation = null,Object? pageFormat = null,Object? position = freezed,Object? clientOperationId = freezed,}) {
  return _then(_CreateWhiteboardPagePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as String,pageFormat: null == pageFormat ? _self.pageFormat : pageFormat // ignore: cast_nullable_to_non_nullable
as String,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,clientOperationId: freezed == clientOperationId ? _self.clientOperationId : clientOperationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateWhiteboardPagePayload {

 String get name; String get orientation; int get expectedVersion;
/// Create a copy of UpdateWhiteboardPagePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWhiteboardPagePayloadCopyWith<UpdateWhiteboardPagePayload> get copyWith => _$UpdateWhiteboardPagePayloadCopyWithImpl<UpdateWhiteboardPagePayload>(this as UpdateWhiteboardPagePayload, _$identity);

  /// Serializes this UpdateWhiteboardPagePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWhiteboardPagePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,orientation,expectedVersion);

@override
String toString() {
  return 'UpdateWhiteboardPagePayload(name: $name, orientation: $orientation, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateWhiteboardPagePayloadCopyWith<$Res>  {
  factory $UpdateWhiteboardPagePayloadCopyWith(UpdateWhiteboardPagePayload value, $Res Function(UpdateWhiteboardPagePayload) _then) = _$UpdateWhiteboardPagePayloadCopyWithImpl;
@useResult
$Res call({
 String name, String orientation, int expectedVersion
});




}
/// @nodoc
class _$UpdateWhiteboardPagePayloadCopyWithImpl<$Res>
    implements $UpdateWhiteboardPagePayloadCopyWith<$Res> {
  _$UpdateWhiteboardPagePayloadCopyWithImpl(this._self, this._then);

  final UpdateWhiteboardPagePayload _self;
  final $Res Function(UpdateWhiteboardPagePayload) _then;

/// Create a copy of UpdateWhiteboardPagePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? orientation = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWhiteboardPagePayload].
extension UpdateWhiteboardPagePayloadPatterns on UpdateWhiteboardPagePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWhiteboardPagePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWhiteboardPagePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWhiteboardPagePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWhiteboardPagePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWhiteboardPagePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWhiteboardPagePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String orientation,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWhiteboardPagePayload() when $default != null:
return $default(_that.name,_that.orientation,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String orientation,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateWhiteboardPagePayload():
return $default(_that.name,_that.orientation,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String orientation,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWhiteboardPagePayload() when $default != null:
return $default(_that.name,_that.orientation,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWhiteboardPagePayload implements UpdateWhiteboardPagePayload {
  const _UpdateWhiteboardPagePayload({required this.name, required this.orientation, required this.expectedVersion});
  factory _UpdateWhiteboardPagePayload.fromJson(Map<String, dynamic> json) => _$UpdateWhiteboardPagePayloadFromJson(json);

@override final  String name;
@override final  String orientation;
@override final  int expectedVersion;

/// Create a copy of UpdateWhiteboardPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWhiteboardPagePayloadCopyWith<_UpdateWhiteboardPagePayload> get copyWith => __$UpdateWhiteboardPagePayloadCopyWithImpl<_UpdateWhiteboardPagePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWhiteboardPagePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWhiteboardPagePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,orientation,expectedVersion);

@override
String toString() {
  return 'UpdateWhiteboardPagePayload(name: $name, orientation: $orientation, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateWhiteboardPagePayloadCopyWith<$Res> implements $UpdateWhiteboardPagePayloadCopyWith<$Res> {
  factory _$UpdateWhiteboardPagePayloadCopyWith(_UpdateWhiteboardPagePayload value, $Res Function(_UpdateWhiteboardPagePayload) _then) = __$UpdateWhiteboardPagePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String orientation, int expectedVersion
});




}
/// @nodoc
class __$UpdateWhiteboardPagePayloadCopyWithImpl<$Res>
    implements _$UpdateWhiteboardPagePayloadCopyWith<$Res> {
  __$UpdateWhiteboardPagePayloadCopyWithImpl(this._self, this._then);

  final _UpdateWhiteboardPagePayload _self;
  final $Res Function(_UpdateWhiteboardPagePayload) _then;

/// Create a copy of UpdateWhiteboardPagePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? orientation = null,Object? expectedVersion = null,}) {
  return _then(_UpdateWhiteboardPagePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WhiteboardPoint {

 double get x; double get y;
/// Create a copy of WhiteboardPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardPointCopyWith<WhiteboardPoint> get copyWith => _$WhiteboardPointCopyWithImpl<WhiteboardPoint>(this as WhiteboardPoint, _$identity);

  /// Serializes this WhiteboardPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardPoint&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y);

@override
String toString() {
  return 'WhiteboardPoint(x: $x, y: $y)';
}


}

/// @nodoc
abstract mixin class $WhiteboardPointCopyWith<$Res>  {
  factory $WhiteboardPointCopyWith(WhiteboardPoint value, $Res Function(WhiteboardPoint) _then) = _$WhiteboardPointCopyWithImpl;
@useResult
$Res call({
 double x, double y
});




}
/// @nodoc
class _$WhiteboardPointCopyWithImpl<$Res>
    implements $WhiteboardPointCopyWith<$Res> {
  _$WhiteboardPointCopyWithImpl(this._self, this._then);

  final WhiteboardPoint _self;
  final $Res Function(WhiteboardPoint) _then;

/// Create a copy of WhiteboardPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,}) {
  return _then(_self.copyWith(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardPoint].
extension WhiteboardPointPatterns on WhiteboardPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardPoint value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardPoint value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double x,  double y)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardPoint() when $default != null:
return $default(_that.x,_that.y);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double x,  double y)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardPoint():
return $default(_that.x,_that.y);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double x,  double y)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardPoint() when $default != null:
return $default(_that.x,_that.y);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardPoint implements WhiteboardPoint {
  const _WhiteboardPoint({required this.x, required this.y});
  factory _WhiteboardPoint.fromJson(Map<String, dynamic> json) => _$WhiteboardPointFromJson(json);

@override final  double x;
@override final  double y;

/// Create a copy of WhiteboardPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardPointCopyWith<_WhiteboardPoint> get copyWith => __$WhiteboardPointCopyWithImpl<_WhiteboardPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardPoint&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y);

@override
String toString() {
  return 'WhiteboardPoint(x: $x, y: $y)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardPointCopyWith<$Res> implements $WhiteboardPointCopyWith<$Res> {
  factory _$WhiteboardPointCopyWith(_WhiteboardPoint value, $Res Function(_WhiteboardPoint) _then) = __$WhiteboardPointCopyWithImpl;
@override @useResult
$Res call({
 double x, double y
});




}
/// @nodoc
class __$WhiteboardPointCopyWithImpl<$Res>
    implements _$WhiteboardPointCopyWith<$Res> {
  __$WhiteboardPointCopyWithImpl(this._self, this._then);

  final _WhiteboardPoint _self;
  final $Res Function(_WhiteboardPoint) _then;

/// Create a copy of WhiteboardPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,}) {
  return _then(_WhiteboardPoint(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$WhiteboardConnectorGeometry {

 String get sourceObjectId; String get targetObjectId; String? get sourcePort; String? get targetPort; List<WhiteboardPoint> get controlPoints; String get endCap;
/// Create a copy of WhiteboardConnectorGeometry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardConnectorGeometryCopyWith<WhiteboardConnectorGeometry> get copyWith => _$WhiteboardConnectorGeometryCopyWithImpl<WhiteboardConnectorGeometry>(this as WhiteboardConnectorGeometry, _$identity);

  /// Serializes this WhiteboardConnectorGeometry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardConnectorGeometry&&(identical(other.sourceObjectId, sourceObjectId) || other.sourceObjectId == sourceObjectId)&&(identical(other.targetObjectId, targetObjectId) || other.targetObjectId == targetObjectId)&&(identical(other.sourcePort, sourcePort) || other.sourcePort == sourcePort)&&(identical(other.targetPort, targetPort) || other.targetPort == targetPort)&&const DeepCollectionEquality().equals(other.controlPoints, controlPoints)&&(identical(other.endCap, endCap) || other.endCap == endCap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceObjectId,targetObjectId,sourcePort,targetPort,const DeepCollectionEquality().hash(controlPoints),endCap);

@override
String toString() {
  return 'WhiteboardConnectorGeometry(sourceObjectId: $sourceObjectId, targetObjectId: $targetObjectId, sourcePort: $sourcePort, targetPort: $targetPort, controlPoints: $controlPoints, endCap: $endCap)';
}


}

/// @nodoc
abstract mixin class $WhiteboardConnectorGeometryCopyWith<$Res>  {
  factory $WhiteboardConnectorGeometryCopyWith(WhiteboardConnectorGeometry value, $Res Function(WhiteboardConnectorGeometry) _then) = _$WhiteboardConnectorGeometryCopyWithImpl;
@useResult
$Res call({
 String sourceObjectId, String targetObjectId, String? sourcePort, String? targetPort, List<WhiteboardPoint> controlPoints, String endCap
});




}
/// @nodoc
class _$WhiteboardConnectorGeometryCopyWithImpl<$Res>
    implements $WhiteboardConnectorGeometryCopyWith<$Res> {
  _$WhiteboardConnectorGeometryCopyWithImpl(this._self, this._then);

  final WhiteboardConnectorGeometry _self;
  final $Res Function(WhiteboardConnectorGeometry) _then;

/// Create a copy of WhiteboardConnectorGeometry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceObjectId = null,Object? targetObjectId = null,Object? sourcePort = freezed,Object? targetPort = freezed,Object? controlPoints = null,Object? endCap = null,}) {
  return _then(_self.copyWith(
sourceObjectId: null == sourceObjectId ? _self.sourceObjectId : sourceObjectId // ignore: cast_nullable_to_non_nullable
as String,targetObjectId: null == targetObjectId ? _self.targetObjectId : targetObjectId // ignore: cast_nullable_to_non_nullable
as String,sourcePort: freezed == sourcePort ? _self.sourcePort : sourcePort // ignore: cast_nullable_to_non_nullable
as String?,targetPort: freezed == targetPort ? _self.targetPort : targetPort // ignore: cast_nullable_to_non_nullable
as String?,controlPoints: null == controlPoints ? _self.controlPoints : controlPoints // ignore: cast_nullable_to_non_nullable
as List<WhiteboardPoint>,endCap: null == endCap ? _self.endCap : endCap // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardConnectorGeometry].
extension WhiteboardConnectorGeometryPatterns on WhiteboardConnectorGeometry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardConnectorGeometry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardConnectorGeometry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardConnectorGeometry value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardConnectorGeometry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardConnectorGeometry value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardConnectorGeometry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceObjectId,  String targetObjectId,  String? sourcePort,  String? targetPort,  List<WhiteboardPoint> controlPoints,  String endCap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardConnectorGeometry() when $default != null:
return $default(_that.sourceObjectId,_that.targetObjectId,_that.sourcePort,_that.targetPort,_that.controlPoints,_that.endCap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceObjectId,  String targetObjectId,  String? sourcePort,  String? targetPort,  List<WhiteboardPoint> controlPoints,  String endCap)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardConnectorGeometry():
return $default(_that.sourceObjectId,_that.targetObjectId,_that.sourcePort,_that.targetPort,_that.controlPoints,_that.endCap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceObjectId,  String targetObjectId,  String? sourcePort,  String? targetPort,  List<WhiteboardPoint> controlPoints,  String endCap)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardConnectorGeometry() when $default != null:
return $default(_that.sourceObjectId,_that.targetObjectId,_that.sourcePort,_that.targetPort,_that.controlPoints,_that.endCap);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardConnectorGeometry implements WhiteboardConnectorGeometry {
  const _WhiteboardConnectorGeometry({required this.sourceObjectId, required this.targetObjectId, this.sourcePort, this.targetPort, required this.controlPoints, this.endCap = 'FilledArrow'});
  factory _WhiteboardConnectorGeometry.fromJson(Map<String, dynamic> json) => _$WhiteboardConnectorGeometryFromJson(json);

@override final  String sourceObjectId;
@override final  String targetObjectId;
@override final  String? sourcePort;
@override final  String? targetPort;
@override final  List<WhiteboardPoint> controlPoints;
@override@JsonKey() final  String endCap;

/// Create a copy of WhiteboardConnectorGeometry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardConnectorGeometryCopyWith<_WhiteboardConnectorGeometry> get copyWith => __$WhiteboardConnectorGeometryCopyWithImpl<_WhiteboardConnectorGeometry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardConnectorGeometryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardConnectorGeometry&&(identical(other.sourceObjectId, sourceObjectId) || other.sourceObjectId == sourceObjectId)&&(identical(other.targetObjectId, targetObjectId) || other.targetObjectId == targetObjectId)&&(identical(other.sourcePort, sourcePort) || other.sourcePort == sourcePort)&&(identical(other.targetPort, targetPort) || other.targetPort == targetPort)&&const DeepCollectionEquality().equals(other.controlPoints, controlPoints)&&(identical(other.endCap, endCap) || other.endCap == endCap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceObjectId,targetObjectId,sourcePort,targetPort,const DeepCollectionEquality().hash(controlPoints),endCap);

@override
String toString() {
  return 'WhiteboardConnectorGeometry(sourceObjectId: $sourceObjectId, targetObjectId: $targetObjectId, sourcePort: $sourcePort, targetPort: $targetPort, controlPoints: $controlPoints, endCap: $endCap)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardConnectorGeometryCopyWith<$Res> implements $WhiteboardConnectorGeometryCopyWith<$Res> {
  factory _$WhiteboardConnectorGeometryCopyWith(_WhiteboardConnectorGeometry value, $Res Function(_WhiteboardConnectorGeometry) _then) = __$WhiteboardConnectorGeometryCopyWithImpl;
@override @useResult
$Res call({
 String sourceObjectId, String targetObjectId, String? sourcePort, String? targetPort, List<WhiteboardPoint> controlPoints, String endCap
});




}
/// @nodoc
class __$WhiteboardConnectorGeometryCopyWithImpl<$Res>
    implements _$WhiteboardConnectorGeometryCopyWith<$Res> {
  __$WhiteboardConnectorGeometryCopyWithImpl(this._self, this._then);

  final _WhiteboardConnectorGeometry _self;
  final $Res Function(_WhiteboardConnectorGeometry) _then;

/// Create a copy of WhiteboardConnectorGeometry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceObjectId = null,Object? targetObjectId = null,Object? sourcePort = freezed,Object? targetPort = freezed,Object? controlPoints = null,Object? endCap = null,}) {
  return _then(_WhiteboardConnectorGeometry(
sourceObjectId: null == sourceObjectId ? _self.sourceObjectId : sourceObjectId // ignore: cast_nullable_to_non_nullable
as String,targetObjectId: null == targetObjectId ? _self.targetObjectId : targetObjectId // ignore: cast_nullable_to_non_nullable
as String,sourcePort: freezed == sourcePort ? _self.sourcePort : sourcePort // ignore: cast_nullable_to_non_nullable
as String?,targetPort: freezed == targetPort ? _self.targetPort : targetPort // ignore: cast_nullable_to_non_nullable
as String?,controlPoints: null == controlPoints ? _self.controlPoints : controlPoints // ignore: cast_nullable_to_non_nullable
as List<WhiteboardPoint>,endCap: null == endCap ? _self.endCap : endCap // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CreateWhiteboardObjectPayload {

 String get kind; WhiteboardPoint get position; double get width; double get height; double get rotation; Map<String, dynamic> get data; WhiteboardConnectorGeometry? get connector; String? get pageId; String? get clientOperationId;
/// Create a copy of CreateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWhiteboardObjectPayloadCopyWith<CreateWhiteboardObjectPayload> get copyWith => _$CreateWhiteboardObjectPayloadCopyWithImpl<CreateWhiteboardObjectPayload>(this as CreateWhiteboardObjectPayload, _$identity);

  /// Serializes this CreateWhiteboardObjectPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWhiteboardObjectPayload&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.connector, connector) || other.connector == connector)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.clientOperationId, clientOperationId) || other.clientOperationId == clientOperationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,position,width,height,rotation,const DeepCollectionEquality().hash(data),connector,pageId,clientOperationId);

@override
String toString() {
  return 'CreateWhiteboardObjectPayload(kind: $kind, position: $position, width: $width, height: $height, rotation: $rotation, data: $data, connector: $connector, pageId: $pageId, clientOperationId: $clientOperationId)';
}


}

/// @nodoc
abstract mixin class $CreateWhiteboardObjectPayloadCopyWith<$Res>  {
  factory $CreateWhiteboardObjectPayloadCopyWith(CreateWhiteboardObjectPayload value, $Res Function(CreateWhiteboardObjectPayload) _then) = _$CreateWhiteboardObjectPayloadCopyWithImpl;
@useResult
$Res call({
 String kind, WhiteboardPoint position, double width, double height, double rotation, Map<String, dynamic> data, WhiteboardConnectorGeometry? connector, String? pageId, String? clientOperationId
});


$WhiteboardPointCopyWith<$Res> get position;$WhiteboardConnectorGeometryCopyWith<$Res>? get connector;

}
/// @nodoc
class _$CreateWhiteboardObjectPayloadCopyWithImpl<$Res>
    implements $CreateWhiteboardObjectPayloadCopyWith<$Res> {
  _$CreateWhiteboardObjectPayloadCopyWithImpl(this._self, this._then);

  final CreateWhiteboardObjectPayload _self;
  final $Res Function(CreateWhiteboardObjectPayload) _then;

/// Create a copy of CreateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? position = null,Object? width = null,Object? height = null,Object? rotation = null,Object? data = null,Object? connector = freezed,Object? pageId = freezed,Object? clientOperationId = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as WhiteboardPoint,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,connector: freezed == connector ? _self.connector : connector // ignore: cast_nullable_to_non_nullable
as WhiteboardConnectorGeometry?,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,clientOperationId: freezed == clientOperationId ? _self.clientOperationId : clientOperationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CreateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardPointCopyWith<$Res> get position {
  
  return $WhiteboardPointCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of CreateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardConnectorGeometryCopyWith<$Res>? get connector {
    if (_self.connector == null) {
    return null;
  }

  return $WhiteboardConnectorGeometryCopyWith<$Res>(_self.connector!, (value) {
    return _then(_self.copyWith(connector: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateWhiteboardObjectPayload].
extension CreateWhiteboardObjectPayloadPatterns on CreateWhiteboardObjectPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWhiteboardObjectPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWhiteboardObjectPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWhiteboardObjectPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateWhiteboardObjectPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWhiteboardObjectPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWhiteboardObjectPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  WhiteboardPoint position,  double width,  double height,  double rotation,  Map<String, dynamic> data,  WhiteboardConnectorGeometry? connector,  String? pageId,  String? clientOperationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWhiteboardObjectPayload() when $default != null:
return $default(_that.kind,_that.position,_that.width,_that.height,_that.rotation,_that.data,_that.connector,_that.pageId,_that.clientOperationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  WhiteboardPoint position,  double width,  double height,  double rotation,  Map<String, dynamic> data,  WhiteboardConnectorGeometry? connector,  String? pageId,  String? clientOperationId)  $default,) {final _that = this;
switch (_that) {
case _CreateWhiteboardObjectPayload():
return $default(_that.kind,_that.position,_that.width,_that.height,_that.rotation,_that.data,_that.connector,_that.pageId,_that.clientOperationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  WhiteboardPoint position,  double width,  double height,  double rotation,  Map<String, dynamic> data,  WhiteboardConnectorGeometry? connector,  String? pageId,  String? clientOperationId)?  $default,) {final _that = this;
switch (_that) {
case _CreateWhiteboardObjectPayload() when $default != null:
return $default(_that.kind,_that.position,_that.width,_that.height,_that.rotation,_that.data,_that.connector,_that.pageId,_that.clientOperationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWhiteboardObjectPayload implements CreateWhiteboardObjectPayload {
  const _CreateWhiteboardObjectPayload({required this.kind, required this.position, required this.width, required this.height, required this.rotation, required this.data, this.connector, this.pageId, this.clientOperationId});
  factory _CreateWhiteboardObjectPayload.fromJson(Map<String, dynamic> json) => _$CreateWhiteboardObjectPayloadFromJson(json);

@override final  String kind;
@override final  WhiteboardPoint position;
@override final  double width;
@override final  double height;
@override final  double rotation;
@override final  Map<String, dynamic> data;
@override final  WhiteboardConnectorGeometry? connector;
@override final  String? pageId;
@override final  String? clientOperationId;

/// Create a copy of CreateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWhiteboardObjectPayloadCopyWith<_CreateWhiteboardObjectPayload> get copyWith => __$CreateWhiteboardObjectPayloadCopyWithImpl<_CreateWhiteboardObjectPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWhiteboardObjectPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWhiteboardObjectPayload&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.connector, connector) || other.connector == connector)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.clientOperationId, clientOperationId) || other.clientOperationId == clientOperationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,position,width,height,rotation,const DeepCollectionEquality().hash(data),connector,pageId,clientOperationId);

@override
String toString() {
  return 'CreateWhiteboardObjectPayload(kind: $kind, position: $position, width: $width, height: $height, rotation: $rotation, data: $data, connector: $connector, pageId: $pageId, clientOperationId: $clientOperationId)';
}


}

/// @nodoc
abstract mixin class _$CreateWhiteboardObjectPayloadCopyWith<$Res> implements $CreateWhiteboardObjectPayloadCopyWith<$Res> {
  factory _$CreateWhiteboardObjectPayloadCopyWith(_CreateWhiteboardObjectPayload value, $Res Function(_CreateWhiteboardObjectPayload) _then) = __$CreateWhiteboardObjectPayloadCopyWithImpl;
@override @useResult
$Res call({
 String kind, WhiteboardPoint position, double width, double height, double rotation, Map<String, dynamic> data, WhiteboardConnectorGeometry? connector, String? pageId, String? clientOperationId
});


@override $WhiteboardPointCopyWith<$Res> get position;@override $WhiteboardConnectorGeometryCopyWith<$Res>? get connector;

}
/// @nodoc
class __$CreateWhiteboardObjectPayloadCopyWithImpl<$Res>
    implements _$CreateWhiteboardObjectPayloadCopyWith<$Res> {
  __$CreateWhiteboardObjectPayloadCopyWithImpl(this._self, this._then);

  final _CreateWhiteboardObjectPayload _self;
  final $Res Function(_CreateWhiteboardObjectPayload) _then;

/// Create a copy of CreateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? position = null,Object? width = null,Object? height = null,Object? rotation = null,Object? data = null,Object? connector = freezed,Object? pageId = freezed,Object? clientOperationId = freezed,}) {
  return _then(_CreateWhiteboardObjectPayload(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as WhiteboardPoint,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,connector: freezed == connector ? _self.connector : connector // ignore: cast_nullable_to_non_nullable
as WhiteboardConnectorGeometry?,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,clientOperationId: freezed == clientOperationId ? _self.clientOperationId : clientOperationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CreateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardPointCopyWith<$Res> get position {
  
  return $WhiteboardPointCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of CreateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardConnectorGeometryCopyWith<$Res>? get connector {
    if (_self.connector == null) {
    return null;
  }

  return $WhiteboardConnectorGeometryCopyWith<$Res>(_self.connector!, (value) {
    return _then(_self.copyWith(connector: value));
  });
}
}


/// @nodoc
mixin _$UpdateWhiteboardObjectPayload {

 WhiteboardPoint get position; double get width; double get height; double get rotation; Map<String, dynamic> get data; WhiteboardConnectorGeometry? get connector; int get expectedVersion;
/// Create a copy of UpdateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWhiteboardObjectPayloadCopyWith<UpdateWhiteboardObjectPayload> get copyWith => _$UpdateWhiteboardObjectPayloadCopyWithImpl<UpdateWhiteboardObjectPayload>(this as UpdateWhiteboardObjectPayload, _$identity);

  /// Serializes this UpdateWhiteboardObjectPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWhiteboardObjectPayload&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.connector, connector) || other.connector == connector)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,width,height,rotation,const DeepCollectionEquality().hash(data),connector,expectedVersion);

@override
String toString() {
  return 'UpdateWhiteboardObjectPayload(position: $position, width: $width, height: $height, rotation: $rotation, data: $data, connector: $connector, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateWhiteboardObjectPayloadCopyWith<$Res>  {
  factory $UpdateWhiteboardObjectPayloadCopyWith(UpdateWhiteboardObjectPayload value, $Res Function(UpdateWhiteboardObjectPayload) _then) = _$UpdateWhiteboardObjectPayloadCopyWithImpl;
@useResult
$Res call({
 WhiteboardPoint position, double width, double height, double rotation, Map<String, dynamic> data, WhiteboardConnectorGeometry? connector, int expectedVersion
});


$WhiteboardPointCopyWith<$Res> get position;$WhiteboardConnectorGeometryCopyWith<$Res>? get connector;

}
/// @nodoc
class _$UpdateWhiteboardObjectPayloadCopyWithImpl<$Res>
    implements $UpdateWhiteboardObjectPayloadCopyWith<$Res> {
  _$UpdateWhiteboardObjectPayloadCopyWithImpl(this._self, this._then);

  final UpdateWhiteboardObjectPayload _self;
  final $Res Function(UpdateWhiteboardObjectPayload) _then;

/// Create a copy of UpdateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? width = null,Object? height = null,Object? rotation = null,Object? data = null,Object? connector = freezed,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as WhiteboardPoint,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,connector: freezed == connector ? _self.connector : connector // ignore: cast_nullable_to_non_nullable
as WhiteboardConnectorGeometry?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of UpdateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardPointCopyWith<$Res> get position {
  
  return $WhiteboardPointCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of UpdateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardConnectorGeometryCopyWith<$Res>? get connector {
    if (_self.connector == null) {
    return null;
  }

  return $WhiteboardConnectorGeometryCopyWith<$Res>(_self.connector!, (value) {
    return _then(_self.copyWith(connector: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateWhiteboardObjectPayload].
extension UpdateWhiteboardObjectPayloadPatterns on UpdateWhiteboardObjectPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWhiteboardObjectPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWhiteboardObjectPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWhiteboardObjectPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWhiteboardObjectPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWhiteboardObjectPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWhiteboardObjectPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WhiteboardPoint position,  double width,  double height,  double rotation,  Map<String, dynamic> data,  WhiteboardConnectorGeometry? connector,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWhiteboardObjectPayload() when $default != null:
return $default(_that.position,_that.width,_that.height,_that.rotation,_that.data,_that.connector,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WhiteboardPoint position,  double width,  double height,  double rotation,  Map<String, dynamic> data,  WhiteboardConnectorGeometry? connector,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateWhiteboardObjectPayload():
return $default(_that.position,_that.width,_that.height,_that.rotation,_that.data,_that.connector,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WhiteboardPoint position,  double width,  double height,  double rotation,  Map<String, dynamic> data,  WhiteboardConnectorGeometry? connector,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWhiteboardObjectPayload() when $default != null:
return $default(_that.position,_that.width,_that.height,_that.rotation,_that.data,_that.connector,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWhiteboardObjectPayload implements UpdateWhiteboardObjectPayload {
  const _UpdateWhiteboardObjectPayload({required this.position, required this.width, required this.height, required this.rotation, required this.data, this.connector, required this.expectedVersion});
  factory _UpdateWhiteboardObjectPayload.fromJson(Map<String, dynamic> json) => _$UpdateWhiteboardObjectPayloadFromJson(json);

@override final  WhiteboardPoint position;
@override final  double width;
@override final  double height;
@override final  double rotation;
@override final  Map<String, dynamic> data;
@override final  WhiteboardConnectorGeometry? connector;
@override final  int expectedVersion;

/// Create a copy of UpdateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWhiteboardObjectPayloadCopyWith<_UpdateWhiteboardObjectPayload> get copyWith => __$UpdateWhiteboardObjectPayloadCopyWithImpl<_UpdateWhiteboardObjectPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWhiteboardObjectPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWhiteboardObjectPayload&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.connector, connector) || other.connector == connector)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,width,height,rotation,const DeepCollectionEquality().hash(data),connector,expectedVersion);

@override
String toString() {
  return 'UpdateWhiteboardObjectPayload(position: $position, width: $width, height: $height, rotation: $rotation, data: $data, connector: $connector, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateWhiteboardObjectPayloadCopyWith<$Res> implements $UpdateWhiteboardObjectPayloadCopyWith<$Res> {
  factory _$UpdateWhiteboardObjectPayloadCopyWith(_UpdateWhiteboardObjectPayload value, $Res Function(_UpdateWhiteboardObjectPayload) _then) = __$UpdateWhiteboardObjectPayloadCopyWithImpl;
@override @useResult
$Res call({
 WhiteboardPoint position, double width, double height, double rotation, Map<String, dynamic> data, WhiteboardConnectorGeometry? connector, int expectedVersion
});


@override $WhiteboardPointCopyWith<$Res> get position;@override $WhiteboardConnectorGeometryCopyWith<$Res>? get connector;

}
/// @nodoc
class __$UpdateWhiteboardObjectPayloadCopyWithImpl<$Res>
    implements _$UpdateWhiteboardObjectPayloadCopyWith<$Res> {
  __$UpdateWhiteboardObjectPayloadCopyWithImpl(this._self, this._then);

  final _UpdateWhiteboardObjectPayload _self;
  final $Res Function(_UpdateWhiteboardObjectPayload) _then;

/// Create a copy of UpdateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? width = null,Object? height = null,Object? rotation = null,Object? data = null,Object? connector = freezed,Object? expectedVersion = null,}) {
  return _then(_UpdateWhiteboardObjectPayload(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as WhiteboardPoint,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,connector: freezed == connector ? _self.connector : connector // ignore: cast_nullable_to_non_nullable
as WhiteboardConnectorGeometry?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of UpdateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardPointCopyWith<$Res> get position {
  
  return $WhiteboardPointCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of UpdateWhiteboardObjectPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardConnectorGeometryCopyWith<$Res>? get connector {
    if (_self.connector == null) {
    return null;
  }

  return $WhiteboardConnectorGeometryCopyWith<$Res>(_self.connector!, (value) {
    return _then(_self.copyWith(connector: value));
  });
}
}


/// @nodoc
mixin _$WhiteboardOperation {

 String get operationId; String get kind; String? get objectId; Map<String, dynamic> get payload;
/// Create a copy of WhiteboardOperation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardOperationCopyWith<WhiteboardOperation> get copyWith => _$WhiteboardOperationCopyWithImpl<WhiteboardOperation>(this as WhiteboardOperation, _$identity);

  /// Serializes this WhiteboardOperation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardOperation&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.objectId, objectId) || other.objectId == objectId)&&const DeepCollectionEquality().equals(other.payload, payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationId,kind,objectId,const DeepCollectionEquality().hash(payload));

@override
String toString() {
  return 'WhiteboardOperation(operationId: $operationId, kind: $kind, objectId: $objectId, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $WhiteboardOperationCopyWith<$Res>  {
  factory $WhiteboardOperationCopyWith(WhiteboardOperation value, $Res Function(WhiteboardOperation) _then) = _$WhiteboardOperationCopyWithImpl;
@useResult
$Res call({
 String operationId, String kind, String? objectId, Map<String, dynamic> payload
});




}
/// @nodoc
class _$WhiteboardOperationCopyWithImpl<$Res>
    implements $WhiteboardOperationCopyWith<$Res> {
  _$WhiteboardOperationCopyWithImpl(this._self, this._then);

  final WhiteboardOperation _self;
  final $Res Function(WhiteboardOperation) _then;

/// Create a copy of WhiteboardOperation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operationId = null,Object? kind = null,Object? objectId = freezed,Object? payload = null,}) {
  return _then(_self.copyWith(
operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,objectId: freezed == objectId ? _self.objectId : objectId // ignore: cast_nullable_to_non_nullable
as String?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardOperation].
extension WhiteboardOperationPatterns on WhiteboardOperation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardOperation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardOperation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardOperation value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardOperation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardOperation value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardOperation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String operationId,  String kind,  String? objectId,  Map<String, dynamic> payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardOperation() when $default != null:
return $default(_that.operationId,_that.kind,_that.objectId,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String operationId,  String kind,  String? objectId,  Map<String, dynamic> payload)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardOperation():
return $default(_that.operationId,_that.kind,_that.objectId,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String operationId,  String kind,  String? objectId,  Map<String, dynamic> payload)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardOperation() when $default != null:
return $default(_that.operationId,_that.kind,_that.objectId,_that.payload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardOperation implements WhiteboardOperation {
  const _WhiteboardOperation({required this.operationId, required this.kind, this.objectId, required this.payload});
  factory _WhiteboardOperation.fromJson(Map<String, dynamic> json) => _$WhiteboardOperationFromJson(json);

@override final  String operationId;
@override final  String kind;
@override final  String? objectId;
@override final  Map<String, dynamic> payload;

/// Create a copy of WhiteboardOperation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardOperationCopyWith<_WhiteboardOperation> get copyWith => __$WhiteboardOperationCopyWithImpl<_WhiteboardOperation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardOperationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardOperation&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.objectId, objectId) || other.objectId == objectId)&&const DeepCollectionEquality().equals(other.payload, payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationId,kind,objectId,const DeepCollectionEquality().hash(payload));

@override
String toString() {
  return 'WhiteboardOperation(operationId: $operationId, kind: $kind, objectId: $objectId, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardOperationCopyWith<$Res> implements $WhiteboardOperationCopyWith<$Res> {
  factory _$WhiteboardOperationCopyWith(_WhiteboardOperation value, $Res Function(_WhiteboardOperation) _then) = __$WhiteboardOperationCopyWithImpl;
@override @useResult
$Res call({
 String operationId, String kind, String? objectId, Map<String, dynamic> payload
});




}
/// @nodoc
class __$WhiteboardOperationCopyWithImpl<$Res>
    implements _$WhiteboardOperationCopyWith<$Res> {
  __$WhiteboardOperationCopyWithImpl(this._self, this._then);

  final _WhiteboardOperation _self;
  final $Res Function(_WhiteboardOperation) _then;

/// Create a copy of WhiteboardOperation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operationId = null,Object? kind = null,Object? objectId = freezed,Object? payload = null,}) {
  return _then(_WhiteboardOperation(
operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,objectId: freezed == objectId ? _self.objectId : objectId // ignore: cast_nullable_to_non_nullable
as String?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$ApplyWhiteboardOperationsPayload {

 int get baseVersion; List<WhiteboardOperation> get operations;
/// Create a copy of ApplyWhiteboardOperationsPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyWhiteboardOperationsPayloadCopyWith<ApplyWhiteboardOperationsPayload> get copyWith => _$ApplyWhiteboardOperationsPayloadCopyWithImpl<ApplyWhiteboardOperationsPayload>(this as ApplyWhiteboardOperationsPayload, _$identity);

  /// Serializes this ApplyWhiteboardOperationsPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyWhiteboardOperationsPayload&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&const DeepCollectionEquality().equals(other.operations, operations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseVersion,const DeepCollectionEquality().hash(operations));

@override
String toString() {
  return 'ApplyWhiteboardOperationsPayload(baseVersion: $baseVersion, operations: $operations)';
}


}

/// @nodoc
abstract mixin class $ApplyWhiteboardOperationsPayloadCopyWith<$Res>  {
  factory $ApplyWhiteboardOperationsPayloadCopyWith(ApplyWhiteboardOperationsPayload value, $Res Function(ApplyWhiteboardOperationsPayload) _then) = _$ApplyWhiteboardOperationsPayloadCopyWithImpl;
@useResult
$Res call({
 int baseVersion, List<WhiteboardOperation> operations
});




}
/// @nodoc
class _$ApplyWhiteboardOperationsPayloadCopyWithImpl<$Res>
    implements $ApplyWhiteboardOperationsPayloadCopyWith<$Res> {
  _$ApplyWhiteboardOperationsPayloadCopyWithImpl(this._self, this._then);

  final ApplyWhiteboardOperationsPayload _self;
  final $Res Function(ApplyWhiteboardOperationsPayload) _then;

/// Create a copy of ApplyWhiteboardOperationsPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseVersion = null,Object? operations = null,}) {
  return _then(_self.copyWith(
baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,operations: null == operations ? _self.operations : operations // ignore: cast_nullable_to_non_nullable
as List<WhiteboardOperation>,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplyWhiteboardOperationsPayload].
extension ApplyWhiteboardOperationsPayloadPatterns on ApplyWhiteboardOperationsPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplyWhiteboardOperationsPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplyWhiteboardOperationsPayload value)  $default,){
final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplyWhiteboardOperationsPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int baseVersion,  List<WhiteboardOperation> operations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsPayload() when $default != null:
return $default(_that.baseVersion,_that.operations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int baseVersion,  List<WhiteboardOperation> operations)  $default,) {final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsPayload():
return $default(_that.baseVersion,_that.operations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int baseVersion,  List<WhiteboardOperation> operations)?  $default,) {final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsPayload() when $default != null:
return $default(_that.baseVersion,_that.operations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplyWhiteboardOperationsPayload implements ApplyWhiteboardOperationsPayload {
  const _ApplyWhiteboardOperationsPayload({required this.baseVersion, required this.operations});
  factory _ApplyWhiteboardOperationsPayload.fromJson(Map<String, dynamic> json) => _$ApplyWhiteboardOperationsPayloadFromJson(json);

@override final  int baseVersion;
@override final  List<WhiteboardOperation> operations;

/// Create a copy of ApplyWhiteboardOperationsPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplyWhiteboardOperationsPayloadCopyWith<_ApplyWhiteboardOperationsPayload> get copyWith => __$ApplyWhiteboardOperationsPayloadCopyWithImpl<_ApplyWhiteboardOperationsPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplyWhiteboardOperationsPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplyWhiteboardOperationsPayload&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&const DeepCollectionEquality().equals(other.operations, operations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseVersion,const DeepCollectionEquality().hash(operations));

@override
String toString() {
  return 'ApplyWhiteboardOperationsPayload(baseVersion: $baseVersion, operations: $operations)';
}


}

/// @nodoc
abstract mixin class _$ApplyWhiteboardOperationsPayloadCopyWith<$Res> implements $ApplyWhiteboardOperationsPayloadCopyWith<$Res> {
  factory _$ApplyWhiteboardOperationsPayloadCopyWith(_ApplyWhiteboardOperationsPayload value, $Res Function(_ApplyWhiteboardOperationsPayload) _then) = __$ApplyWhiteboardOperationsPayloadCopyWithImpl;
@override @useResult
$Res call({
 int baseVersion, List<WhiteboardOperation> operations
});




}
/// @nodoc
class __$ApplyWhiteboardOperationsPayloadCopyWithImpl<$Res>
    implements _$ApplyWhiteboardOperationsPayloadCopyWith<$Res> {
  __$ApplyWhiteboardOperationsPayloadCopyWithImpl(this._self, this._then);

  final _ApplyWhiteboardOperationsPayload _self;
  final $Res Function(_ApplyWhiteboardOperationsPayload) _then;

/// Create a copy of ApplyWhiteboardOperationsPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseVersion = null,Object? operations = null,}) {
  return _then(_ApplyWhiteboardOperationsPayload(
baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,operations: null == operations ? _self.operations : operations // ignore: cast_nullable_to_non_nullable
as List<WhiteboardOperation>,
  ));
}


}


/// @nodoc
mixin _$WhiteboardSummaryResponse {

 String get id; String get projectId; String get name; String? get description; String get type; int get version; DateTime get updatedAtUtc; String? get taskId; Map<String, dynamic>? get taskMetadata;
/// Create a copy of WhiteboardSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardSummaryResponseCopyWith<WhiteboardSummaryResponse> get copyWith => _$WhiteboardSummaryResponseCopyWithImpl<WhiteboardSummaryResponse>(this as WhiteboardSummaryResponse, _$identity);

  /// Serializes this WhiteboardSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&const DeepCollectionEquality().equals(other.taskMetadata, taskMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name,description,type,version,updatedAtUtc,taskId,const DeepCollectionEquality().hash(taskMetadata));

@override
String toString() {
  return 'WhiteboardSummaryResponse(id: $id, projectId: $projectId, name: $name, description: $description, type: $type, version: $version, updatedAtUtc: $updatedAtUtc, taskId: $taskId, taskMetadata: $taskMetadata)';
}


}

/// @nodoc
abstract mixin class $WhiteboardSummaryResponseCopyWith<$Res>  {
  factory $WhiteboardSummaryResponseCopyWith(WhiteboardSummaryResponse value, $Res Function(WhiteboardSummaryResponse) _then) = _$WhiteboardSummaryResponseCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String name, String? description, String type, int version, DateTime updatedAtUtc, String? taskId, Map<String, dynamic>? taskMetadata
});




}
/// @nodoc
class _$WhiteboardSummaryResponseCopyWithImpl<$Res>
    implements $WhiteboardSummaryResponseCopyWith<$Res> {
  _$WhiteboardSummaryResponseCopyWithImpl(this._self, this._then);

  final WhiteboardSummaryResponse _self;
  final $Res Function(WhiteboardSummaryResponse) _then;

/// Create a copy of WhiteboardSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? name = null,Object? description = freezed,Object? type = null,Object? version = null,Object? updatedAtUtc = null,Object? taskId = freezed,Object? taskMetadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,taskMetadata: freezed == taskMetadata ? _self.taskMetadata : taskMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardSummaryResponse].
extension WhiteboardSummaryResponsePatterns on WhiteboardSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String name,  String? description,  String type,  int version,  DateTime updatedAtUtc,  String? taskId,  Map<String, dynamic>? taskMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardSummaryResponse() when $default != null:
return $default(_that.id,_that.projectId,_that.name,_that.description,_that.type,_that.version,_that.updatedAtUtc,_that.taskId,_that.taskMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String name,  String? description,  String type,  int version,  DateTime updatedAtUtc,  String? taskId,  Map<String, dynamic>? taskMetadata)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardSummaryResponse():
return $default(_that.id,_that.projectId,_that.name,_that.description,_that.type,_that.version,_that.updatedAtUtc,_that.taskId,_that.taskMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String name,  String? description,  String type,  int version,  DateTime updatedAtUtc,  String? taskId,  Map<String, dynamic>? taskMetadata)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardSummaryResponse() when $default != null:
return $default(_that.id,_that.projectId,_that.name,_that.description,_that.type,_that.version,_that.updatedAtUtc,_that.taskId,_that.taskMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardSummaryResponse implements WhiteboardSummaryResponse {
  const _WhiteboardSummaryResponse({required this.id, required this.projectId, required this.name, this.description, required this.type, required this.version, required this.updatedAtUtc, this.taskId, this.taskMetadata});
  factory _WhiteboardSummaryResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardSummaryResponseFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  String name;
@override final  String? description;
@override final  String type;
@override final  int version;
@override final  DateTime updatedAtUtc;
@override final  String? taskId;
@override final  Map<String, dynamic>? taskMetadata;

/// Create a copy of WhiteboardSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardSummaryResponseCopyWith<_WhiteboardSummaryResponse> get copyWith => __$WhiteboardSummaryResponseCopyWithImpl<_WhiteboardSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&const DeepCollectionEquality().equals(other.taskMetadata, taskMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name,description,type,version,updatedAtUtc,taskId,const DeepCollectionEquality().hash(taskMetadata));

@override
String toString() {
  return 'WhiteboardSummaryResponse(id: $id, projectId: $projectId, name: $name, description: $description, type: $type, version: $version, updatedAtUtc: $updatedAtUtc, taskId: $taskId, taskMetadata: $taskMetadata)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardSummaryResponseCopyWith<$Res> implements $WhiteboardSummaryResponseCopyWith<$Res> {
  factory _$WhiteboardSummaryResponseCopyWith(_WhiteboardSummaryResponse value, $Res Function(_WhiteboardSummaryResponse) _then) = __$WhiteboardSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String name, String? description, String type, int version, DateTime updatedAtUtc, String? taskId, Map<String, dynamic>? taskMetadata
});




}
/// @nodoc
class __$WhiteboardSummaryResponseCopyWithImpl<$Res>
    implements _$WhiteboardSummaryResponseCopyWith<$Res> {
  __$WhiteboardSummaryResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardSummaryResponse _self;
  final $Res Function(_WhiteboardSummaryResponse) _then;

/// Create a copy of WhiteboardSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? name = null,Object? description = freezed,Object? type = null,Object? version = null,Object? updatedAtUtc = null,Object? taskId = freezed,Object? taskMetadata = freezed,}) {
  return _then(_WhiteboardSummaryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,taskMetadata: freezed == taskMetadata ? _self.taskMetadata : taskMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$WhiteboardResponse {

 String get id; String get workspaceId; String get projectId; String get name; String? get description; String get type; int get version; String? get currentCursor; DateTime get createdAtUtc; DateTime get updatedAtUtc;
/// Create a copy of WhiteboardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardResponseCopyWith<WhiteboardResponse> get copyWith => _$WhiteboardResponseCopyWithImpl<WhiteboardResponse>(this as WhiteboardResponse, _$identity);

  /// Serializes this WhiteboardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.currentCursor, currentCursor) || other.currentCursor == currentCursor)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,projectId,name,description,type,version,currentCursor,createdAtUtc,updatedAtUtc);

@override
String toString() {
  return 'WhiteboardResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, name: $name, description: $description, type: $type, version: $version, currentCursor: $currentCursor, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WhiteboardResponseCopyWith<$Res>  {
  factory $WhiteboardResponseCopyWith(WhiteboardResponse value, $Res Function(WhiteboardResponse) _then) = _$WhiteboardResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String projectId, String name, String? description, String type, int version, String? currentCursor, DateTime createdAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class _$WhiteboardResponseCopyWithImpl<$Res>
    implements $WhiteboardResponseCopyWith<$Res> {
  _$WhiteboardResponseCopyWithImpl(this._self, this._then);

  final WhiteboardResponse _self;
  final $Res Function(WhiteboardResponse) _then;

/// Create a copy of WhiteboardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = null,Object? name = null,Object? description = freezed,Object? type = null,Object? version = null,Object? currentCursor = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,currentCursor: freezed == currentCursor ? _self.currentCursor : currentCursor // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardResponse].
extension WhiteboardResponsePatterns on WhiteboardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String projectId,  String name,  String? description,  String type,  int version,  String? currentCursor,  DateTime createdAtUtc,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.name,_that.description,_that.type,_that.version,_that.currentCursor,_that.createdAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String projectId,  String name,  String? description,  String type,  int version,  String? currentCursor,  DateTime createdAtUtc,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardResponse():
return $default(_that.id,_that.workspaceId,_that.projectId,_that.name,_that.description,_that.type,_that.version,_that.currentCursor,_that.createdAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String projectId,  String name,  String? description,  String type,  int version,  String? currentCursor,  DateTime createdAtUtc,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.name,_that.description,_that.type,_that.version,_that.currentCursor,_that.createdAtUtc,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardResponse implements WhiteboardResponse {
  const _WhiteboardResponse({required this.id, required this.workspaceId, required this.projectId, required this.name, this.description, required this.type, required this.version, this.currentCursor, required this.createdAtUtc, required this.updatedAtUtc});
  factory _WhiteboardResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardResponseFromJson(json);

@override final  String id;
@override final  String workspaceId;
@override final  String projectId;
@override final  String name;
@override final  String? description;
@override final  String type;
@override final  int version;
@override final  String? currentCursor;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;

/// Create a copy of WhiteboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardResponseCopyWith<_WhiteboardResponse> get copyWith => __$WhiteboardResponseCopyWithImpl<_WhiteboardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.currentCursor, currentCursor) || other.currentCursor == currentCursor)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,projectId,name,description,type,version,currentCursor,createdAtUtc,updatedAtUtc);

@override
String toString() {
  return 'WhiteboardResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, name: $name, description: $description, type: $type, version: $version, currentCursor: $currentCursor, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardResponseCopyWith<$Res> implements $WhiteboardResponseCopyWith<$Res> {
  factory _$WhiteboardResponseCopyWith(_WhiteboardResponse value, $Res Function(_WhiteboardResponse) _then) = __$WhiteboardResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String projectId, String name, String? description, String type, int version, String? currentCursor, DateTime createdAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class __$WhiteboardResponseCopyWithImpl<$Res>
    implements _$WhiteboardResponseCopyWith<$Res> {
  __$WhiteboardResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardResponse _self;
  final $Res Function(_WhiteboardResponse) _then;

/// Create a copy of WhiteboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = null,Object? name = null,Object? description = freezed,Object? type = null,Object? version = null,Object? currentCursor = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,}) {
  return _then(_WhiteboardResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,currentCursor: freezed == currentCursor ? _self.currentCursor : currentCursor // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WhiteboardPageResponse {

 String get id; String get whiteboardId; String get name; String get orientation; String get pageFormat; int get position; int get version; DateTime get createdAtUtc; DateTime get updatedAtUtc;
/// Create a copy of WhiteboardPageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardPageResponseCopyWith<WhiteboardPageResponse> get copyWith => _$WhiteboardPageResponseCopyWithImpl<WhiteboardPageResponse>(this as WhiteboardPageResponse, _$identity);

  /// Serializes this WhiteboardPageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardPageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.whiteboardId, whiteboardId) || other.whiteboardId == whiteboardId)&&(identical(other.name, name) || other.name == name)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.pageFormat, pageFormat) || other.pageFormat == pageFormat)&&(identical(other.position, position) || other.position == position)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,whiteboardId,name,orientation,pageFormat,position,version,createdAtUtc,updatedAtUtc);

@override
String toString() {
  return 'WhiteboardPageResponse(id: $id, whiteboardId: $whiteboardId, name: $name, orientation: $orientation, pageFormat: $pageFormat, position: $position, version: $version, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WhiteboardPageResponseCopyWith<$Res>  {
  factory $WhiteboardPageResponseCopyWith(WhiteboardPageResponse value, $Res Function(WhiteboardPageResponse) _then) = _$WhiteboardPageResponseCopyWithImpl;
@useResult
$Res call({
 String id, String whiteboardId, String name, String orientation, String pageFormat, int position, int version, DateTime createdAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class _$WhiteboardPageResponseCopyWithImpl<$Res>
    implements $WhiteboardPageResponseCopyWith<$Res> {
  _$WhiteboardPageResponseCopyWithImpl(this._self, this._then);

  final WhiteboardPageResponse _self;
  final $Res Function(WhiteboardPageResponse) _then;

/// Create a copy of WhiteboardPageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? whiteboardId = null,Object? name = null,Object? orientation = null,Object? pageFormat = null,Object? position = null,Object? version = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,whiteboardId: null == whiteboardId ? _self.whiteboardId : whiteboardId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as String,pageFormat: null == pageFormat ? _self.pageFormat : pageFormat // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardPageResponse].
extension WhiteboardPageResponsePatterns on WhiteboardPageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardPageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardPageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardPageResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardPageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardPageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardPageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String whiteboardId,  String name,  String orientation,  String pageFormat,  int position,  int version,  DateTime createdAtUtc,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardPageResponse() when $default != null:
return $default(_that.id,_that.whiteboardId,_that.name,_that.orientation,_that.pageFormat,_that.position,_that.version,_that.createdAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String whiteboardId,  String name,  String orientation,  String pageFormat,  int position,  int version,  DateTime createdAtUtc,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardPageResponse():
return $default(_that.id,_that.whiteboardId,_that.name,_that.orientation,_that.pageFormat,_that.position,_that.version,_that.createdAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String whiteboardId,  String name,  String orientation,  String pageFormat,  int position,  int version,  DateTime createdAtUtc,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardPageResponse() when $default != null:
return $default(_that.id,_that.whiteboardId,_that.name,_that.orientation,_that.pageFormat,_that.position,_that.version,_that.createdAtUtc,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardPageResponse implements WhiteboardPageResponse {
  const _WhiteboardPageResponse({required this.id, required this.whiteboardId, required this.name, required this.orientation, required this.pageFormat, required this.position, required this.version, required this.createdAtUtc, required this.updatedAtUtc});
  factory _WhiteboardPageResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardPageResponseFromJson(json);

@override final  String id;
@override final  String whiteboardId;
@override final  String name;
@override final  String orientation;
@override final  String pageFormat;
@override final  int position;
@override final  int version;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;

/// Create a copy of WhiteboardPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardPageResponseCopyWith<_WhiteboardPageResponse> get copyWith => __$WhiteboardPageResponseCopyWithImpl<_WhiteboardPageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardPageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardPageResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.whiteboardId, whiteboardId) || other.whiteboardId == whiteboardId)&&(identical(other.name, name) || other.name == name)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.pageFormat, pageFormat) || other.pageFormat == pageFormat)&&(identical(other.position, position) || other.position == position)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,whiteboardId,name,orientation,pageFormat,position,version,createdAtUtc,updatedAtUtc);

@override
String toString() {
  return 'WhiteboardPageResponse(id: $id, whiteboardId: $whiteboardId, name: $name, orientation: $orientation, pageFormat: $pageFormat, position: $position, version: $version, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardPageResponseCopyWith<$Res> implements $WhiteboardPageResponseCopyWith<$Res> {
  factory _$WhiteboardPageResponseCopyWith(_WhiteboardPageResponse value, $Res Function(_WhiteboardPageResponse) _then) = __$WhiteboardPageResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String whiteboardId, String name, String orientation, String pageFormat, int position, int version, DateTime createdAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class __$WhiteboardPageResponseCopyWithImpl<$Res>
    implements _$WhiteboardPageResponseCopyWith<$Res> {
  __$WhiteboardPageResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardPageResponse _self;
  final $Res Function(_WhiteboardPageResponse) _then;

/// Create a copy of WhiteboardPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? whiteboardId = null,Object? name = null,Object? orientation = null,Object? pageFormat = null,Object? position = null,Object? version = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,}) {
  return _then(_WhiteboardPageResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,whiteboardId: null == whiteboardId ? _self.whiteboardId : whiteboardId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as String,pageFormat: null == pageFormat ? _self.pageFormat : pageFormat // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WhiteboardObjectResponse {

 String get id; String get whiteboardId; String? get pageId; String get kind; WhiteboardPoint get position; double get width; double get height; double get rotation; Map<String, dynamic> get data; WhiteboardConnectorGeometry? get connector; int get version; DateTime get updatedAtUtc; String? get taskId; Map<String, dynamic>? get taskMetadata;
/// Create a copy of WhiteboardObjectResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardObjectResponseCopyWith<WhiteboardObjectResponse> get copyWith => _$WhiteboardObjectResponseCopyWithImpl<WhiteboardObjectResponse>(this as WhiteboardObjectResponse, _$identity);

  /// Serializes this WhiteboardObjectResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardObjectResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.whiteboardId, whiteboardId) || other.whiteboardId == whiteboardId)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.connector, connector) || other.connector == connector)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&const DeepCollectionEquality().equals(other.taskMetadata, taskMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,whiteboardId,pageId,kind,position,width,height,rotation,const DeepCollectionEquality().hash(data),connector,version,updatedAtUtc,taskId,const DeepCollectionEquality().hash(taskMetadata));

@override
String toString() {
  return 'WhiteboardObjectResponse(id: $id, whiteboardId: $whiteboardId, pageId: $pageId, kind: $kind, position: $position, width: $width, height: $height, rotation: $rotation, data: $data, connector: $connector, version: $version, updatedAtUtc: $updatedAtUtc, taskId: $taskId, taskMetadata: $taskMetadata)';
}


}

/// @nodoc
abstract mixin class $WhiteboardObjectResponseCopyWith<$Res>  {
  factory $WhiteboardObjectResponseCopyWith(WhiteboardObjectResponse value, $Res Function(WhiteboardObjectResponse) _then) = _$WhiteboardObjectResponseCopyWithImpl;
@useResult
$Res call({
 String id, String whiteboardId, String? pageId, String kind, WhiteboardPoint position, double width, double height, double rotation, Map<String, dynamic> data, WhiteboardConnectorGeometry? connector, int version, DateTime updatedAtUtc, String? taskId, Map<String, dynamic>? taskMetadata
});


$WhiteboardPointCopyWith<$Res> get position;$WhiteboardConnectorGeometryCopyWith<$Res>? get connector;

}
/// @nodoc
class _$WhiteboardObjectResponseCopyWithImpl<$Res>
    implements $WhiteboardObjectResponseCopyWith<$Res> {
  _$WhiteboardObjectResponseCopyWithImpl(this._self, this._then);

  final WhiteboardObjectResponse _self;
  final $Res Function(WhiteboardObjectResponse) _then;

/// Create a copy of WhiteboardObjectResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? whiteboardId = null,Object? pageId = freezed,Object? kind = null,Object? position = null,Object? width = null,Object? height = null,Object? rotation = null,Object? data = null,Object? connector = freezed,Object? version = null,Object? updatedAtUtc = null,Object? taskId = freezed,Object? taskMetadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,whiteboardId: null == whiteboardId ? _self.whiteboardId : whiteboardId // ignore: cast_nullable_to_non_nullable
as String,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as WhiteboardPoint,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,connector: freezed == connector ? _self.connector : connector // ignore: cast_nullable_to_non_nullable
as WhiteboardConnectorGeometry?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,taskMetadata: freezed == taskMetadata ? _self.taskMetadata : taskMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of WhiteboardObjectResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardPointCopyWith<$Res> get position {
  
  return $WhiteboardPointCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of WhiteboardObjectResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardConnectorGeometryCopyWith<$Res>? get connector {
    if (_self.connector == null) {
    return null;
  }

  return $WhiteboardConnectorGeometryCopyWith<$Res>(_self.connector!, (value) {
    return _then(_self.copyWith(connector: value));
  });
}
}


/// Adds pattern-matching-related methods to [WhiteboardObjectResponse].
extension WhiteboardObjectResponsePatterns on WhiteboardObjectResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardObjectResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardObjectResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardObjectResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardObjectResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardObjectResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardObjectResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String whiteboardId,  String? pageId,  String kind,  WhiteboardPoint position,  double width,  double height,  double rotation,  Map<String, dynamic> data,  WhiteboardConnectorGeometry? connector,  int version,  DateTime updatedAtUtc,  String? taskId,  Map<String, dynamic>? taskMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardObjectResponse() when $default != null:
return $default(_that.id,_that.whiteboardId,_that.pageId,_that.kind,_that.position,_that.width,_that.height,_that.rotation,_that.data,_that.connector,_that.version,_that.updatedAtUtc,_that.taskId,_that.taskMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String whiteboardId,  String? pageId,  String kind,  WhiteboardPoint position,  double width,  double height,  double rotation,  Map<String, dynamic> data,  WhiteboardConnectorGeometry? connector,  int version,  DateTime updatedAtUtc,  String? taskId,  Map<String, dynamic>? taskMetadata)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardObjectResponse():
return $default(_that.id,_that.whiteboardId,_that.pageId,_that.kind,_that.position,_that.width,_that.height,_that.rotation,_that.data,_that.connector,_that.version,_that.updatedAtUtc,_that.taskId,_that.taskMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String whiteboardId,  String? pageId,  String kind,  WhiteboardPoint position,  double width,  double height,  double rotation,  Map<String, dynamic> data,  WhiteboardConnectorGeometry? connector,  int version,  DateTime updatedAtUtc,  String? taskId,  Map<String, dynamic>? taskMetadata)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardObjectResponse() when $default != null:
return $default(_that.id,_that.whiteboardId,_that.pageId,_that.kind,_that.position,_that.width,_that.height,_that.rotation,_that.data,_that.connector,_that.version,_that.updatedAtUtc,_that.taskId,_that.taskMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardObjectResponse implements WhiteboardObjectResponse {
  const _WhiteboardObjectResponse({required this.id, required this.whiteboardId, this.pageId, required this.kind, required this.position, required this.width, required this.height, required this.rotation, required this.data, this.connector, required this.version, required this.updatedAtUtc, this.taskId, this.taskMetadata});
  factory _WhiteboardObjectResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardObjectResponseFromJson(json);

@override final  String id;
@override final  String whiteboardId;
@override final  String? pageId;
@override final  String kind;
@override final  WhiteboardPoint position;
@override final  double width;
@override final  double height;
@override final  double rotation;
@override final  Map<String, dynamic> data;
@override final  WhiteboardConnectorGeometry? connector;
@override final  int version;
@override final  DateTime updatedAtUtc;
@override final  String? taskId;
@override final  Map<String, dynamic>? taskMetadata;

/// Create a copy of WhiteboardObjectResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardObjectResponseCopyWith<_WhiteboardObjectResponse> get copyWith => __$WhiteboardObjectResponseCopyWithImpl<_WhiteboardObjectResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardObjectResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardObjectResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.whiteboardId, whiteboardId) || other.whiteboardId == whiteboardId)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.connector, connector) || other.connector == connector)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&const DeepCollectionEquality().equals(other.taskMetadata, taskMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,whiteboardId,pageId,kind,position,width,height,rotation,const DeepCollectionEquality().hash(data),connector,version,updatedAtUtc,taskId,const DeepCollectionEquality().hash(taskMetadata));

@override
String toString() {
  return 'WhiteboardObjectResponse(id: $id, whiteboardId: $whiteboardId, pageId: $pageId, kind: $kind, position: $position, width: $width, height: $height, rotation: $rotation, data: $data, connector: $connector, version: $version, updatedAtUtc: $updatedAtUtc, taskId: $taskId, taskMetadata: $taskMetadata)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardObjectResponseCopyWith<$Res> implements $WhiteboardObjectResponseCopyWith<$Res> {
  factory _$WhiteboardObjectResponseCopyWith(_WhiteboardObjectResponse value, $Res Function(_WhiteboardObjectResponse) _then) = __$WhiteboardObjectResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String whiteboardId, String? pageId, String kind, WhiteboardPoint position, double width, double height, double rotation, Map<String, dynamic> data, WhiteboardConnectorGeometry? connector, int version, DateTime updatedAtUtc, String? taskId, Map<String, dynamic>? taskMetadata
});


@override $WhiteboardPointCopyWith<$Res> get position;@override $WhiteboardConnectorGeometryCopyWith<$Res>? get connector;

}
/// @nodoc
class __$WhiteboardObjectResponseCopyWithImpl<$Res>
    implements _$WhiteboardObjectResponseCopyWith<$Res> {
  __$WhiteboardObjectResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardObjectResponse _self;
  final $Res Function(_WhiteboardObjectResponse) _then;

/// Create a copy of WhiteboardObjectResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? whiteboardId = null,Object? pageId = freezed,Object? kind = null,Object? position = null,Object? width = null,Object? height = null,Object? rotation = null,Object? data = null,Object? connector = freezed,Object? version = null,Object? updatedAtUtc = null,Object? taskId = freezed,Object? taskMetadata = freezed,}) {
  return _then(_WhiteboardObjectResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,whiteboardId: null == whiteboardId ? _self.whiteboardId : whiteboardId // ignore: cast_nullable_to_non_nullable
as String,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as WhiteboardPoint,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,connector: freezed == connector ? _self.connector : connector // ignore: cast_nullable_to_non_nullable
as WhiteboardConnectorGeometry?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,taskMetadata: freezed == taskMetadata ? _self.taskMetadata : taskMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of WhiteboardObjectResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardPointCopyWith<$Res> get position {
  
  return $WhiteboardPointCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}/// Create a copy of WhiteboardObjectResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardConnectorGeometryCopyWith<$Res>? get connector {
    if (_self.connector == null) {
    return null;
  }

  return $WhiteboardConnectorGeometryCopyWith<$Res>(_self.connector!, (value) {
    return _then(_self.copyWith(connector: value));
  });
}
}


/// @nodoc
mixin _$StickyNoteTaskResponse {

 String get objectId; String get taskId; String get title; String get status; String get priority; bool get alreadyLinked; int get objectVersion; DateTime get updatedAtUtc;
/// Create a copy of StickyNoteTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StickyNoteTaskResponseCopyWith<StickyNoteTaskResponse> get copyWith => _$StickyNoteTaskResponseCopyWithImpl<StickyNoteTaskResponse>(this as StickyNoteTaskResponse, _$identity);

  /// Serializes this StickyNoteTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StickyNoteTaskResponse&&(identical(other.objectId, objectId) || other.objectId == objectId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.alreadyLinked, alreadyLinked) || other.alreadyLinked == alreadyLinked)&&(identical(other.objectVersion, objectVersion) || other.objectVersion == objectVersion)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,objectId,taskId,title,status,priority,alreadyLinked,objectVersion,updatedAtUtc);

@override
String toString() {
  return 'StickyNoteTaskResponse(objectId: $objectId, taskId: $taskId, title: $title, status: $status, priority: $priority, alreadyLinked: $alreadyLinked, objectVersion: $objectVersion, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $StickyNoteTaskResponseCopyWith<$Res>  {
  factory $StickyNoteTaskResponseCopyWith(StickyNoteTaskResponse value, $Res Function(StickyNoteTaskResponse) _then) = _$StickyNoteTaskResponseCopyWithImpl;
@useResult
$Res call({
 String objectId, String taskId, String title, String status, String priority, bool alreadyLinked, int objectVersion, DateTime updatedAtUtc
});




}
/// @nodoc
class _$StickyNoteTaskResponseCopyWithImpl<$Res>
    implements $StickyNoteTaskResponseCopyWith<$Res> {
  _$StickyNoteTaskResponseCopyWithImpl(this._self, this._then);

  final StickyNoteTaskResponse _self;
  final $Res Function(StickyNoteTaskResponse) _then;

/// Create a copy of StickyNoteTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? objectId = null,Object? taskId = null,Object? title = null,Object? status = null,Object? priority = null,Object? alreadyLinked = null,Object? objectVersion = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
objectId: null == objectId ? _self.objectId : objectId // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,alreadyLinked: null == alreadyLinked ? _self.alreadyLinked : alreadyLinked // ignore: cast_nullable_to_non_nullable
as bool,objectVersion: null == objectVersion ? _self.objectVersion : objectVersion // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StickyNoteTaskResponse].
extension StickyNoteTaskResponsePatterns on StickyNoteTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StickyNoteTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StickyNoteTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StickyNoteTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _StickyNoteTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StickyNoteTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StickyNoteTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String objectId,  String taskId,  String title,  String status,  String priority,  bool alreadyLinked,  int objectVersion,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StickyNoteTaskResponse() when $default != null:
return $default(_that.objectId,_that.taskId,_that.title,_that.status,_that.priority,_that.alreadyLinked,_that.objectVersion,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String objectId,  String taskId,  String title,  String status,  String priority,  bool alreadyLinked,  int objectVersion,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _StickyNoteTaskResponse():
return $default(_that.objectId,_that.taskId,_that.title,_that.status,_that.priority,_that.alreadyLinked,_that.objectVersion,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String objectId,  String taskId,  String title,  String status,  String priority,  bool alreadyLinked,  int objectVersion,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _StickyNoteTaskResponse() when $default != null:
return $default(_that.objectId,_that.taskId,_that.title,_that.status,_that.priority,_that.alreadyLinked,_that.objectVersion,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StickyNoteTaskResponse implements StickyNoteTaskResponse {
  const _StickyNoteTaskResponse({required this.objectId, required this.taskId, required this.title, required this.status, required this.priority, required this.alreadyLinked, required this.objectVersion, required this.updatedAtUtc});
  factory _StickyNoteTaskResponse.fromJson(Map<String, dynamic> json) => _$StickyNoteTaskResponseFromJson(json);

@override final  String objectId;
@override final  String taskId;
@override final  String title;
@override final  String status;
@override final  String priority;
@override final  bool alreadyLinked;
@override final  int objectVersion;
@override final  DateTime updatedAtUtc;

/// Create a copy of StickyNoteTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StickyNoteTaskResponseCopyWith<_StickyNoteTaskResponse> get copyWith => __$StickyNoteTaskResponseCopyWithImpl<_StickyNoteTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StickyNoteTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StickyNoteTaskResponse&&(identical(other.objectId, objectId) || other.objectId == objectId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.alreadyLinked, alreadyLinked) || other.alreadyLinked == alreadyLinked)&&(identical(other.objectVersion, objectVersion) || other.objectVersion == objectVersion)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,objectId,taskId,title,status,priority,alreadyLinked,objectVersion,updatedAtUtc);

@override
String toString() {
  return 'StickyNoteTaskResponse(objectId: $objectId, taskId: $taskId, title: $title, status: $status, priority: $priority, alreadyLinked: $alreadyLinked, objectVersion: $objectVersion, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$StickyNoteTaskResponseCopyWith<$Res> implements $StickyNoteTaskResponseCopyWith<$Res> {
  factory _$StickyNoteTaskResponseCopyWith(_StickyNoteTaskResponse value, $Res Function(_StickyNoteTaskResponse) _then) = __$StickyNoteTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String objectId, String taskId, String title, String status, String priority, bool alreadyLinked, int objectVersion, DateTime updatedAtUtc
});




}
/// @nodoc
class __$StickyNoteTaskResponseCopyWithImpl<$Res>
    implements _$StickyNoteTaskResponseCopyWith<$Res> {
  __$StickyNoteTaskResponseCopyWithImpl(this._self, this._then);

  final _StickyNoteTaskResponse _self;
  final $Res Function(_StickyNoteTaskResponse) _then;

/// Create a copy of StickyNoteTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? objectId = null,Object? taskId = null,Object? title = null,Object? status = null,Object? priority = null,Object? alreadyLinked = null,Object? objectVersion = null,Object? updatedAtUtc = null,}) {
  return _then(_StickyNoteTaskResponse(
objectId: null == objectId ? _self.objectId : objectId // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,alreadyLinked: null == alreadyLinked ? _self.alreadyLinked : alreadyLinked // ignore: cast_nullable_to_non_nullable
as bool,objectVersion: null == objectVersion ? _self.objectVersion : objectVersion // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CreateTaskFromStickyNotePayload {

 String? get title; String? get description; TaskPriority get priority; DateTime? get dueAtUtc; List<String>? get assigneeCoreUserIds;
/// Create a copy of CreateTaskFromStickyNotePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskFromStickyNotePayloadCopyWith<CreateTaskFromStickyNotePayload> get copyWith => _$CreateTaskFromStickyNotePayloadCopyWithImpl<CreateTaskFromStickyNotePayload>(this as CreateTaskFromStickyNotePayload, _$identity);

  /// Serializes this CreateTaskFromStickyNotePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskFromStickyNotePayload&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,priority,dueAtUtc,const DeepCollectionEquality().hash(assigneeCoreUserIds));

@override
String toString() {
  return 'CreateTaskFromStickyNotePayload(title: $title, description: $description, priority: $priority, dueAtUtc: $dueAtUtc, assigneeCoreUserIds: $assigneeCoreUserIds)';
}


}

/// @nodoc
abstract mixin class $CreateTaskFromStickyNotePayloadCopyWith<$Res>  {
  factory $CreateTaskFromStickyNotePayloadCopyWith(CreateTaskFromStickyNotePayload value, $Res Function(CreateTaskFromStickyNotePayload) _then) = _$CreateTaskFromStickyNotePayloadCopyWithImpl;
@useResult
$Res call({
 String? title, String? description, TaskPriority priority, DateTime? dueAtUtc, List<String>? assigneeCoreUserIds
});




}
/// @nodoc
class _$CreateTaskFromStickyNotePayloadCopyWithImpl<$Res>
    implements $CreateTaskFromStickyNotePayloadCopyWith<$Res> {
  _$CreateTaskFromStickyNotePayloadCopyWithImpl(this._self, this._then);

  final CreateTaskFromStickyNotePayload _self;
  final $Res Function(CreateTaskFromStickyNotePayload) _then;

/// Create a copy of CreateTaskFromStickyNotePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? priority = null,Object? dueAtUtc = freezed,Object? assigneeCoreUserIds = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assigneeCoreUserIds: freezed == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskFromStickyNotePayload].
extension CreateTaskFromStickyNotePayloadPatterns on CreateTaskFromStickyNotePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskFromStickyNotePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskFromStickyNotePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskFromStickyNotePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskFromStickyNotePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskFromStickyNotePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskFromStickyNotePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description,  TaskPriority priority,  DateTime? dueAtUtc,  List<String>? assigneeCoreUserIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskFromStickyNotePayload() when $default != null:
return $default(_that.title,_that.description,_that.priority,_that.dueAtUtc,_that.assigneeCoreUserIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description,  TaskPriority priority,  DateTime? dueAtUtc,  List<String>? assigneeCoreUserIds)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskFromStickyNotePayload():
return $default(_that.title,_that.description,_that.priority,_that.dueAtUtc,_that.assigneeCoreUserIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description,  TaskPriority priority,  DateTime? dueAtUtc,  List<String>? assigneeCoreUserIds)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskFromStickyNotePayload() when $default != null:
return $default(_that.title,_that.description,_that.priority,_that.dueAtUtc,_that.assigneeCoreUserIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskFromStickyNotePayload implements CreateTaskFromStickyNotePayload {
  const _CreateTaskFromStickyNotePayload({this.title, this.description, this.priority = TaskPriority.normal, this.dueAtUtc, this.assigneeCoreUserIds});
  factory _CreateTaskFromStickyNotePayload.fromJson(Map<String, dynamic> json) => _$CreateTaskFromStickyNotePayloadFromJson(json);

@override final  String? title;
@override final  String? description;
@override@JsonKey() final  TaskPriority priority;
@override final  DateTime? dueAtUtc;
@override final  List<String>? assigneeCoreUserIds;

/// Create a copy of CreateTaskFromStickyNotePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskFromStickyNotePayloadCopyWith<_CreateTaskFromStickyNotePayload> get copyWith => __$CreateTaskFromStickyNotePayloadCopyWithImpl<_CreateTaskFromStickyNotePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskFromStickyNotePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskFromStickyNotePayload&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,priority,dueAtUtc,const DeepCollectionEquality().hash(assigneeCoreUserIds));

@override
String toString() {
  return 'CreateTaskFromStickyNotePayload(title: $title, description: $description, priority: $priority, dueAtUtc: $dueAtUtc, assigneeCoreUserIds: $assigneeCoreUserIds)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskFromStickyNotePayloadCopyWith<$Res> implements $CreateTaskFromStickyNotePayloadCopyWith<$Res> {
  factory _$CreateTaskFromStickyNotePayloadCopyWith(_CreateTaskFromStickyNotePayload value, $Res Function(_CreateTaskFromStickyNotePayload) _then) = __$CreateTaskFromStickyNotePayloadCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description, TaskPriority priority, DateTime? dueAtUtc, List<String>? assigneeCoreUserIds
});




}
/// @nodoc
class __$CreateTaskFromStickyNotePayloadCopyWithImpl<$Res>
    implements _$CreateTaskFromStickyNotePayloadCopyWith<$Res> {
  __$CreateTaskFromStickyNotePayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskFromStickyNotePayload _self;
  final $Res Function(_CreateTaskFromStickyNotePayload) _then;

/// Create a copy of CreateTaskFromStickyNotePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? priority = null,Object? dueAtUtc = freezed,Object? assigneeCoreUserIds = freezed,}) {
  return _then(_CreateTaskFromStickyNotePayload(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assigneeCoreUserIds: freezed == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$BulkCreateTasksFromStickyNotesPayload {

 List<String> get objectIds; String? get description; TaskPriority get priority; DateTime? get dueAtUtc; List<String>? get assigneeCoreUserIds;
/// Create a copy of BulkCreateTasksFromStickyNotesPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkCreateTasksFromStickyNotesPayloadCopyWith<BulkCreateTasksFromStickyNotesPayload> get copyWith => _$BulkCreateTasksFromStickyNotesPayloadCopyWithImpl<BulkCreateTasksFromStickyNotesPayload>(this as BulkCreateTasksFromStickyNotesPayload, _$identity);

  /// Serializes this BulkCreateTasksFromStickyNotesPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkCreateTasksFromStickyNotesPayload&&const DeepCollectionEquality().equals(other.objectIds, objectIds)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(objectIds),description,priority,dueAtUtc,const DeepCollectionEquality().hash(assigneeCoreUserIds));

@override
String toString() {
  return 'BulkCreateTasksFromStickyNotesPayload(objectIds: $objectIds, description: $description, priority: $priority, dueAtUtc: $dueAtUtc, assigneeCoreUserIds: $assigneeCoreUserIds)';
}


}

/// @nodoc
abstract mixin class $BulkCreateTasksFromStickyNotesPayloadCopyWith<$Res>  {
  factory $BulkCreateTasksFromStickyNotesPayloadCopyWith(BulkCreateTasksFromStickyNotesPayload value, $Res Function(BulkCreateTasksFromStickyNotesPayload) _then) = _$BulkCreateTasksFromStickyNotesPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> objectIds, String? description, TaskPriority priority, DateTime? dueAtUtc, List<String>? assigneeCoreUserIds
});




}
/// @nodoc
class _$BulkCreateTasksFromStickyNotesPayloadCopyWithImpl<$Res>
    implements $BulkCreateTasksFromStickyNotesPayloadCopyWith<$Res> {
  _$BulkCreateTasksFromStickyNotesPayloadCopyWithImpl(this._self, this._then);

  final BulkCreateTasksFromStickyNotesPayload _self;
  final $Res Function(BulkCreateTasksFromStickyNotesPayload) _then;

/// Create a copy of BulkCreateTasksFromStickyNotesPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? objectIds = null,Object? description = freezed,Object? priority = null,Object? dueAtUtc = freezed,Object? assigneeCoreUserIds = freezed,}) {
  return _then(_self.copyWith(
objectIds: null == objectIds ? _self.objectIds : objectIds // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assigneeCoreUserIds: freezed == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkCreateTasksFromStickyNotesPayload].
extension BulkCreateTasksFromStickyNotesPayloadPatterns on BulkCreateTasksFromStickyNotesPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkCreateTasksFromStickyNotesPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkCreateTasksFromStickyNotesPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkCreateTasksFromStickyNotesPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> objectIds,  String? description,  TaskPriority priority,  DateTime? dueAtUtc,  List<String>? assigneeCoreUserIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesPayload() when $default != null:
return $default(_that.objectIds,_that.description,_that.priority,_that.dueAtUtc,_that.assigneeCoreUserIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> objectIds,  String? description,  TaskPriority priority,  DateTime? dueAtUtc,  List<String>? assigneeCoreUserIds)  $default,) {final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesPayload():
return $default(_that.objectIds,_that.description,_that.priority,_that.dueAtUtc,_that.assigneeCoreUserIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> objectIds,  String? description,  TaskPriority priority,  DateTime? dueAtUtc,  List<String>? assigneeCoreUserIds)?  $default,) {final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesPayload() when $default != null:
return $default(_that.objectIds,_that.description,_that.priority,_that.dueAtUtc,_that.assigneeCoreUserIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkCreateTasksFromStickyNotesPayload implements BulkCreateTasksFromStickyNotesPayload {
  const _BulkCreateTasksFromStickyNotesPayload({required this.objectIds, this.description, this.priority = TaskPriority.normal, this.dueAtUtc, this.assigneeCoreUserIds});
  factory _BulkCreateTasksFromStickyNotesPayload.fromJson(Map<String, dynamic> json) => _$BulkCreateTasksFromStickyNotesPayloadFromJson(json);

@override final  List<String> objectIds;
@override final  String? description;
@override@JsonKey() final  TaskPriority priority;
@override final  DateTime? dueAtUtc;
@override final  List<String>? assigneeCoreUserIds;

/// Create a copy of BulkCreateTasksFromStickyNotesPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkCreateTasksFromStickyNotesPayloadCopyWith<_BulkCreateTasksFromStickyNotesPayload> get copyWith => __$BulkCreateTasksFromStickyNotesPayloadCopyWithImpl<_BulkCreateTasksFromStickyNotesPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkCreateTasksFromStickyNotesPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkCreateTasksFromStickyNotesPayload&&const DeepCollectionEquality().equals(other.objectIds, objectIds)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeCoreUserIds, assigneeCoreUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(objectIds),description,priority,dueAtUtc,const DeepCollectionEquality().hash(assigneeCoreUserIds));

@override
String toString() {
  return 'BulkCreateTasksFromStickyNotesPayload(objectIds: $objectIds, description: $description, priority: $priority, dueAtUtc: $dueAtUtc, assigneeCoreUserIds: $assigneeCoreUserIds)';
}


}

/// @nodoc
abstract mixin class _$BulkCreateTasksFromStickyNotesPayloadCopyWith<$Res> implements $BulkCreateTasksFromStickyNotesPayloadCopyWith<$Res> {
  factory _$BulkCreateTasksFromStickyNotesPayloadCopyWith(_BulkCreateTasksFromStickyNotesPayload value, $Res Function(_BulkCreateTasksFromStickyNotesPayload) _then) = __$BulkCreateTasksFromStickyNotesPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> objectIds, String? description, TaskPriority priority, DateTime? dueAtUtc, List<String>? assigneeCoreUserIds
});




}
/// @nodoc
class __$BulkCreateTasksFromStickyNotesPayloadCopyWithImpl<$Res>
    implements _$BulkCreateTasksFromStickyNotesPayloadCopyWith<$Res> {
  __$BulkCreateTasksFromStickyNotesPayloadCopyWithImpl(this._self, this._then);

  final _BulkCreateTasksFromStickyNotesPayload _self;
  final $Res Function(_BulkCreateTasksFromStickyNotesPayload) _then;

/// Create a copy of BulkCreateTasksFromStickyNotesPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? objectIds = null,Object? description = freezed,Object? priority = null,Object? dueAtUtc = freezed,Object? assigneeCoreUserIds = freezed,}) {
  return _then(_BulkCreateTasksFromStickyNotesPayload(
objectIds: null == objectIds ? _self.objectIds : objectIds // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assigneeCoreUserIds: freezed == assigneeCoreUserIds ? _self.assigneeCoreUserIds : assigneeCoreUserIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$BulkCreateTasksFromStickyNotesResponse {

 List<StickyNoteTaskResponse> get items; int get createdCount; int get alreadyLinkedCount;
/// Create a copy of BulkCreateTasksFromStickyNotesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkCreateTasksFromStickyNotesResponseCopyWith<BulkCreateTasksFromStickyNotesResponse> get copyWith => _$BulkCreateTasksFromStickyNotesResponseCopyWithImpl<BulkCreateTasksFromStickyNotesResponse>(this as BulkCreateTasksFromStickyNotesResponse, _$identity);

  /// Serializes this BulkCreateTasksFromStickyNotesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkCreateTasksFromStickyNotesResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdCount, createdCount) || other.createdCount == createdCount)&&(identical(other.alreadyLinkedCount, alreadyLinkedCount) || other.alreadyLinkedCount == alreadyLinkedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),createdCount,alreadyLinkedCount);

@override
String toString() {
  return 'BulkCreateTasksFromStickyNotesResponse(items: $items, createdCount: $createdCount, alreadyLinkedCount: $alreadyLinkedCount)';
}


}

/// @nodoc
abstract mixin class $BulkCreateTasksFromStickyNotesResponseCopyWith<$Res>  {
  factory $BulkCreateTasksFromStickyNotesResponseCopyWith(BulkCreateTasksFromStickyNotesResponse value, $Res Function(BulkCreateTasksFromStickyNotesResponse) _then) = _$BulkCreateTasksFromStickyNotesResponseCopyWithImpl;
@useResult
$Res call({
 List<StickyNoteTaskResponse> items, int createdCount, int alreadyLinkedCount
});




}
/// @nodoc
class _$BulkCreateTasksFromStickyNotesResponseCopyWithImpl<$Res>
    implements $BulkCreateTasksFromStickyNotesResponseCopyWith<$Res> {
  _$BulkCreateTasksFromStickyNotesResponseCopyWithImpl(this._self, this._then);

  final BulkCreateTasksFromStickyNotesResponse _self;
  final $Res Function(BulkCreateTasksFromStickyNotesResponse) _then;

/// Create a copy of BulkCreateTasksFromStickyNotesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? createdCount = null,Object? alreadyLinkedCount = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StickyNoteTaskResponse>,createdCount: null == createdCount ? _self.createdCount : createdCount // ignore: cast_nullable_to_non_nullable
as int,alreadyLinkedCount: null == alreadyLinkedCount ? _self.alreadyLinkedCount : alreadyLinkedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkCreateTasksFromStickyNotesResponse].
extension BulkCreateTasksFromStickyNotesResponsePatterns on BulkCreateTasksFromStickyNotesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkCreateTasksFromStickyNotesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkCreateTasksFromStickyNotesResponse value)  $default,){
final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkCreateTasksFromStickyNotesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StickyNoteTaskResponse> items,  int createdCount,  int alreadyLinkedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesResponse() when $default != null:
return $default(_that.items,_that.createdCount,_that.alreadyLinkedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StickyNoteTaskResponse> items,  int createdCount,  int alreadyLinkedCount)  $default,) {final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesResponse():
return $default(_that.items,_that.createdCount,_that.alreadyLinkedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StickyNoteTaskResponse> items,  int createdCount,  int alreadyLinkedCount)?  $default,) {final _that = this;
switch (_that) {
case _BulkCreateTasksFromStickyNotesResponse() when $default != null:
return $default(_that.items,_that.createdCount,_that.alreadyLinkedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkCreateTasksFromStickyNotesResponse implements BulkCreateTasksFromStickyNotesResponse {
  const _BulkCreateTasksFromStickyNotesResponse({required this.items, required this.createdCount, required this.alreadyLinkedCount});
  factory _BulkCreateTasksFromStickyNotesResponse.fromJson(Map<String, dynamic> json) => _$BulkCreateTasksFromStickyNotesResponseFromJson(json);

@override final  List<StickyNoteTaskResponse> items;
@override final  int createdCount;
@override final  int alreadyLinkedCount;

/// Create a copy of BulkCreateTasksFromStickyNotesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkCreateTasksFromStickyNotesResponseCopyWith<_BulkCreateTasksFromStickyNotesResponse> get copyWith => __$BulkCreateTasksFromStickyNotesResponseCopyWithImpl<_BulkCreateTasksFromStickyNotesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkCreateTasksFromStickyNotesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkCreateTasksFromStickyNotesResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdCount, createdCount) || other.createdCount == createdCount)&&(identical(other.alreadyLinkedCount, alreadyLinkedCount) || other.alreadyLinkedCount == alreadyLinkedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),createdCount,alreadyLinkedCount);

@override
String toString() {
  return 'BulkCreateTasksFromStickyNotesResponse(items: $items, createdCount: $createdCount, alreadyLinkedCount: $alreadyLinkedCount)';
}


}

/// @nodoc
abstract mixin class _$BulkCreateTasksFromStickyNotesResponseCopyWith<$Res> implements $BulkCreateTasksFromStickyNotesResponseCopyWith<$Res> {
  factory _$BulkCreateTasksFromStickyNotesResponseCopyWith(_BulkCreateTasksFromStickyNotesResponse value, $Res Function(_BulkCreateTasksFromStickyNotesResponse) _then) = __$BulkCreateTasksFromStickyNotesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<StickyNoteTaskResponse> items, int createdCount, int alreadyLinkedCount
});




}
/// @nodoc
class __$BulkCreateTasksFromStickyNotesResponseCopyWithImpl<$Res>
    implements _$BulkCreateTasksFromStickyNotesResponseCopyWith<$Res> {
  __$BulkCreateTasksFromStickyNotesResponseCopyWithImpl(this._self, this._then);

  final _BulkCreateTasksFromStickyNotesResponse _self;
  final $Res Function(_BulkCreateTasksFromStickyNotesResponse) _then;

/// Create a copy of BulkCreateTasksFromStickyNotesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? createdCount = null,Object? alreadyLinkedCount = null,}) {
  return _then(_BulkCreateTasksFromStickyNotesResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StickyNoteTaskResponse>,createdCount: null == createdCount ? _self.createdCount : createdCount // ignore: cast_nullable_to_non_nullable
as int,alreadyLinkedCount: null == alreadyLinkedCount ? _self.alreadyLinkedCount : alreadyLinkedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WhiteboardSnapshotResponse {

 WhiteboardResponse get whiteboard; List<WhiteboardPageResponse> get pages; List<WhiteboardObjectResponse> get objects; String? get nextCursor; bool get resyncRequired;
/// Create a copy of WhiteboardSnapshotResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardSnapshotResponseCopyWith<WhiteboardSnapshotResponse> get copyWith => _$WhiteboardSnapshotResponseCopyWithImpl<WhiteboardSnapshotResponse>(this as WhiteboardSnapshotResponse, _$identity);

  /// Serializes this WhiteboardSnapshotResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardSnapshotResponse&&(identical(other.whiteboard, whiteboard) || other.whiteboard == whiteboard)&&const DeepCollectionEquality().equals(other.pages, pages)&&const DeepCollectionEquality().equals(other.objects, objects)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.resyncRequired, resyncRequired) || other.resyncRequired == resyncRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,whiteboard,const DeepCollectionEquality().hash(pages),const DeepCollectionEquality().hash(objects),nextCursor,resyncRequired);

@override
String toString() {
  return 'WhiteboardSnapshotResponse(whiteboard: $whiteboard, pages: $pages, objects: $objects, nextCursor: $nextCursor, resyncRequired: $resyncRequired)';
}


}

/// @nodoc
abstract mixin class $WhiteboardSnapshotResponseCopyWith<$Res>  {
  factory $WhiteboardSnapshotResponseCopyWith(WhiteboardSnapshotResponse value, $Res Function(WhiteboardSnapshotResponse) _then) = _$WhiteboardSnapshotResponseCopyWithImpl;
@useResult
$Res call({
 WhiteboardResponse whiteboard, List<WhiteboardPageResponse> pages, List<WhiteboardObjectResponse> objects, String? nextCursor, bool resyncRequired
});


$WhiteboardResponseCopyWith<$Res> get whiteboard;

}
/// @nodoc
class _$WhiteboardSnapshotResponseCopyWithImpl<$Res>
    implements $WhiteboardSnapshotResponseCopyWith<$Res> {
  _$WhiteboardSnapshotResponseCopyWithImpl(this._self, this._then);

  final WhiteboardSnapshotResponse _self;
  final $Res Function(WhiteboardSnapshotResponse) _then;

/// Create a copy of WhiteboardSnapshotResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? whiteboard = null,Object? pages = null,Object? objects = null,Object? nextCursor = freezed,Object? resyncRequired = null,}) {
  return _then(_self.copyWith(
whiteboard: null == whiteboard ? _self.whiteboard : whiteboard // ignore: cast_nullable_to_non_nullable
as WhiteboardResponse,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<WhiteboardPageResponse>,objects: null == objects ? _self.objects : objects // ignore: cast_nullable_to_non_nullable
as List<WhiteboardObjectResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,resyncRequired: null == resyncRequired ? _self.resyncRequired : resyncRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of WhiteboardSnapshotResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardResponseCopyWith<$Res> get whiteboard {
  
  return $WhiteboardResponseCopyWith<$Res>(_self.whiteboard, (value) {
    return _then(_self.copyWith(whiteboard: value));
  });
}
}


/// Adds pattern-matching-related methods to [WhiteboardSnapshotResponse].
extension WhiteboardSnapshotResponsePatterns on WhiteboardSnapshotResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardSnapshotResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardSnapshotResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardSnapshotResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardSnapshotResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardSnapshotResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardSnapshotResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WhiteboardResponse whiteboard,  List<WhiteboardPageResponse> pages,  List<WhiteboardObjectResponse> objects,  String? nextCursor,  bool resyncRequired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardSnapshotResponse() when $default != null:
return $default(_that.whiteboard,_that.pages,_that.objects,_that.nextCursor,_that.resyncRequired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WhiteboardResponse whiteboard,  List<WhiteboardPageResponse> pages,  List<WhiteboardObjectResponse> objects,  String? nextCursor,  bool resyncRequired)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardSnapshotResponse():
return $default(_that.whiteboard,_that.pages,_that.objects,_that.nextCursor,_that.resyncRequired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WhiteboardResponse whiteboard,  List<WhiteboardPageResponse> pages,  List<WhiteboardObjectResponse> objects,  String? nextCursor,  bool resyncRequired)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardSnapshotResponse() when $default != null:
return $default(_that.whiteboard,_that.pages,_that.objects,_that.nextCursor,_that.resyncRequired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardSnapshotResponse implements WhiteboardSnapshotResponse {
  const _WhiteboardSnapshotResponse({required this.whiteboard, required this.pages, required this.objects, this.nextCursor, required this.resyncRequired});
  factory _WhiteboardSnapshotResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardSnapshotResponseFromJson(json);

@override final  WhiteboardResponse whiteboard;
@override final  List<WhiteboardPageResponse> pages;
@override final  List<WhiteboardObjectResponse> objects;
@override final  String? nextCursor;
@override final  bool resyncRequired;

/// Create a copy of WhiteboardSnapshotResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardSnapshotResponseCopyWith<_WhiteboardSnapshotResponse> get copyWith => __$WhiteboardSnapshotResponseCopyWithImpl<_WhiteboardSnapshotResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardSnapshotResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardSnapshotResponse&&(identical(other.whiteboard, whiteboard) || other.whiteboard == whiteboard)&&const DeepCollectionEquality().equals(other.pages, pages)&&const DeepCollectionEquality().equals(other.objects, objects)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.resyncRequired, resyncRequired) || other.resyncRequired == resyncRequired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,whiteboard,const DeepCollectionEquality().hash(pages),const DeepCollectionEquality().hash(objects),nextCursor,resyncRequired);

@override
String toString() {
  return 'WhiteboardSnapshotResponse(whiteboard: $whiteboard, pages: $pages, objects: $objects, nextCursor: $nextCursor, resyncRequired: $resyncRequired)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardSnapshotResponseCopyWith<$Res> implements $WhiteboardSnapshotResponseCopyWith<$Res> {
  factory _$WhiteboardSnapshotResponseCopyWith(_WhiteboardSnapshotResponse value, $Res Function(_WhiteboardSnapshotResponse) _then) = __$WhiteboardSnapshotResponseCopyWithImpl;
@override @useResult
$Res call({
 WhiteboardResponse whiteboard, List<WhiteboardPageResponse> pages, List<WhiteboardObjectResponse> objects, String? nextCursor, bool resyncRequired
});


@override $WhiteboardResponseCopyWith<$Res> get whiteboard;

}
/// @nodoc
class __$WhiteboardSnapshotResponseCopyWithImpl<$Res>
    implements _$WhiteboardSnapshotResponseCopyWith<$Res> {
  __$WhiteboardSnapshotResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardSnapshotResponse _self;
  final $Res Function(_WhiteboardSnapshotResponse) _then;

/// Create a copy of WhiteboardSnapshotResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? whiteboard = null,Object? pages = null,Object? objects = null,Object? nextCursor = freezed,Object? resyncRequired = null,}) {
  return _then(_WhiteboardSnapshotResponse(
whiteboard: null == whiteboard ? _self.whiteboard : whiteboard // ignore: cast_nullable_to_non_nullable
as WhiteboardResponse,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<WhiteboardPageResponse>,objects: null == objects ? _self.objects : objects // ignore: cast_nullable_to_non_nullable
as List<WhiteboardObjectResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,resyncRequired: null == resyncRequired ? _self.resyncRequired : resyncRequired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of WhiteboardSnapshotResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardResponseCopyWith<$Res> get whiteboard {
  
  return $WhiteboardResponseCopyWith<$Res>(_self.whiteboard, (value) {
    return _then(_self.copyWith(whiteboard: value));
  });
}
}


/// @nodoc
mixin _$WhiteboardEventResponse {

 String get eventId; String get operationId; int get version; String get eventType; String? get pageId; String? get objectId; Map<String, dynamic> get payload; DateTime get createdAtUtc;
/// Create a copy of WhiteboardEventResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardEventResponseCopyWith<WhiteboardEventResponse> get copyWith => _$WhiteboardEventResponseCopyWithImpl<WhiteboardEventResponse>(this as WhiteboardEventResponse, _$identity);

  /// Serializes this WhiteboardEventResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardEventResponse&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.version, version) || other.version == version)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.objectId, objectId) || other.objectId == objectId)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,operationId,version,eventType,pageId,objectId,const DeepCollectionEquality().hash(payload),createdAtUtc);

@override
String toString() {
  return 'WhiteboardEventResponse(eventId: $eventId, operationId: $operationId, version: $version, eventType: $eventType, pageId: $pageId, objectId: $objectId, payload: $payload, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $WhiteboardEventResponseCopyWith<$Res>  {
  factory $WhiteboardEventResponseCopyWith(WhiteboardEventResponse value, $Res Function(WhiteboardEventResponse) _then) = _$WhiteboardEventResponseCopyWithImpl;
@useResult
$Res call({
 String eventId, String operationId, int version, String eventType, String? pageId, String? objectId, Map<String, dynamic> payload, DateTime createdAtUtc
});




}
/// @nodoc
class _$WhiteboardEventResponseCopyWithImpl<$Res>
    implements $WhiteboardEventResponseCopyWith<$Res> {
  _$WhiteboardEventResponseCopyWithImpl(this._self, this._then);

  final WhiteboardEventResponse _self;
  final $Res Function(WhiteboardEventResponse) _then;

/// Create a copy of WhiteboardEventResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? operationId = null,Object? version = null,Object? eventType = null,Object? pageId = freezed,Object? objectId = freezed,Object? payload = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,objectId: freezed == objectId ? _self.objectId : objectId // ignore: cast_nullable_to_non_nullable
as String?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardEventResponse].
extension WhiteboardEventResponsePatterns on WhiteboardEventResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardEventResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardEventResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardEventResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardEventResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardEventResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardEventResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  String operationId,  int version,  String eventType,  String? pageId,  String? objectId,  Map<String, dynamic> payload,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardEventResponse() when $default != null:
return $default(_that.eventId,_that.operationId,_that.version,_that.eventType,_that.pageId,_that.objectId,_that.payload,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  String operationId,  int version,  String eventType,  String? pageId,  String? objectId,  Map<String, dynamic> payload,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardEventResponse():
return $default(_that.eventId,_that.operationId,_that.version,_that.eventType,_that.pageId,_that.objectId,_that.payload,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  String operationId,  int version,  String eventType,  String? pageId,  String? objectId,  Map<String, dynamic> payload,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardEventResponse() when $default != null:
return $default(_that.eventId,_that.operationId,_that.version,_that.eventType,_that.pageId,_that.objectId,_that.payload,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardEventResponse implements WhiteboardEventResponse {
  const _WhiteboardEventResponse({required this.eventId, required this.operationId, required this.version, required this.eventType, this.pageId, this.objectId, required this.payload, required this.createdAtUtc});
  factory _WhiteboardEventResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardEventResponseFromJson(json);

@override final  String eventId;
@override final  String operationId;
@override final  int version;
@override final  String eventType;
@override final  String? pageId;
@override final  String? objectId;
@override final  Map<String, dynamic> payload;
@override final  DateTime createdAtUtc;

/// Create a copy of WhiteboardEventResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardEventResponseCopyWith<_WhiteboardEventResponse> get copyWith => __$WhiteboardEventResponseCopyWithImpl<_WhiteboardEventResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardEventResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardEventResponse&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.version, version) || other.version == version)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.objectId, objectId) || other.objectId == objectId)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,operationId,version,eventType,pageId,objectId,const DeepCollectionEquality().hash(payload),createdAtUtc);

@override
String toString() {
  return 'WhiteboardEventResponse(eventId: $eventId, operationId: $operationId, version: $version, eventType: $eventType, pageId: $pageId, objectId: $objectId, payload: $payload, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardEventResponseCopyWith<$Res> implements $WhiteboardEventResponseCopyWith<$Res> {
  factory _$WhiteboardEventResponseCopyWith(_WhiteboardEventResponse value, $Res Function(_WhiteboardEventResponse) _then) = __$WhiteboardEventResponseCopyWithImpl;
@override @useResult
$Res call({
 String eventId, String operationId, int version, String eventType, String? pageId, String? objectId, Map<String, dynamic> payload, DateTime createdAtUtc
});




}
/// @nodoc
class __$WhiteboardEventResponseCopyWithImpl<$Res>
    implements _$WhiteboardEventResponseCopyWith<$Res> {
  __$WhiteboardEventResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardEventResponse _self;
  final $Res Function(_WhiteboardEventResponse) _then;

/// Create a copy of WhiteboardEventResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? operationId = null,Object? version = null,Object? eventType = null,Object? pageId = freezed,Object? objectId = freezed,Object? payload = null,Object? createdAtUtc = null,}) {
  return _then(_WhiteboardEventResponse(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,objectId: freezed == objectId ? _self.objectId : objectId // ignore: cast_nullable_to_non_nullable
as String?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ApplyWhiteboardOperationsResponse {

 int get version; String? get cursor; List<String> get appliedOperationIds;
/// Create a copy of ApplyWhiteboardOperationsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyWhiteboardOperationsResponseCopyWith<ApplyWhiteboardOperationsResponse> get copyWith => _$ApplyWhiteboardOperationsResponseCopyWithImpl<ApplyWhiteboardOperationsResponse>(this as ApplyWhiteboardOperationsResponse, _$identity);

  /// Serializes this ApplyWhiteboardOperationsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyWhiteboardOperationsResponse&&(identical(other.version, version) || other.version == version)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&const DeepCollectionEquality().equals(other.appliedOperationIds, appliedOperationIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,cursor,const DeepCollectionEquality().hash(appliedOperationIds));

@override
String toString() {
  return 'ApplyWhiteboardOperationsResponse(version: $version, cursor: $cursor, appliedOperationIds: $appliedOperationIds)';
}


}

/// @nodoc
abstract mixin class $ApplyWhiteboardOperationsResponseCopyWith<$Res>  {
  factory $ApplyWhiteboardOperationsResponseCopyWith(ApplyWhiteboardOperationsResponse value, $Res Function(ApplyWhiteboardOperationsResponse) _then) = _$ApplyWhiteboardOperationsResponseCopyWithImpl;
@useResult
$Res call({
 int version, String? cursor, List<String> appliedOperationIds
});




}
/// @nodoc
class _$ApplyWhiteboardOperationsResponseCopyWithImpl<$Res>
    implements $ApplyWhiteboardOperationsResponseCopyWith<$Res> {
  _$ApplyWhiteboardOperationsResponseCopyWithImpl(this._self, this._then);

  final ApplyWhiteboardOperationsResponse _self;
  final $Res Function(ApplyWhiteboardOperationsResponse) _then;

/// Create a copy of ApplyWhiteboardOperationsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? cursor = freezed,Object? appliedOperationIds = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,appliedOperationIds: null == appliedOperationIds ? _self.appliedOperationIds : appliedOperationIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplyWhiteboardOperationsResponse].
extension ApplyWhiteboardOperationsResponsePatterns on ApplyWhiteboardOperationsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplyWhiteboardOperationsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplyWhiteboardOperationsResponse value)  $default,){
final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplyWhiteboardOperationsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  String? cursor,  List<String> appliedOperationIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsResponse() when $default != null:
return $default(_that.version,_that.cursor,_that.appliedOperationIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  String? cursor,  List<String> appliedOperationIds)  $default,) {final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsResponse():
return $default(_that.version,_that.cursor,_that.appliedOperationIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  String? cursor,  List<String> appliedOperationIds)?  $default,) {final _that = this;
switch (_that) {
case _ApplyWhiteboardOperationsResponse() when $default != null:
return $default(_that.version,_that.cursor,_that.appliedOperationIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplyWhiteboardOperationsResponse implements ApplyWhiteboardOperationsResponse {
  const _ApplyWhiteboardOperationsResponse({required this.version, this.cursor, required this.appliedOperationIds});
  factory _ApplyWhiteboardOperationsResponse.fromJson(Map<String, dynamic> json) => _$ApplyWhiteboardOperationsResponseFromJson(json);

@override final  int version;
@override final  String? cursor;
@override final  List<String> appliedOperationIds;

/// Create a copy of ApplyWhiteboardOperationsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplyWhiteboardOperationsResponseCopyWith<_ApplyWhiteboardOperationsResponse> get copyWith => __$ApplyWhiteboardOperationsResponseCopyWithImpl<_ApplyWhiteboardOperationsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplyWhiteboardOperationsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplyWhiteboardOperationsResponse&&(identical(other.version, version) || other.version == version)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&const DeepCollectionEquality().equals(other.appliedOperationIds, appliedOperationIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,cursor,const DeepCollectionEquality().hash(appliedOperationIds));

@override
String toString() {
  return 'ApplyWhiteboardOperationsResponse(version: $version, cursor: $cursor, appliedOperationIds: $appliedOperationIds)';
}


}

/// @nodoc
abstract mixin class _$ApplyWhiteboardOperationsResponseCopyWith<$Res> implements $ApplyWhiteboardOperationsResponseCopyWith<$Res> {
  factory _$ApplyWhiteboardOperationsResponseCopyWith(_ApplyWhiteboardOperationsResponse value, $Res Function(_ApplyWhiteboardOperationsResponse) _then) = __$ApplyWhiteboardOperationsResponseCopyWithImpl;
@override @useResult
$Res call({
 int version, String? cursor, List<String> appliedOperationIds
});




}
/// @nodoc
class __$ApplyWhiteboardOperationsResponseCopyWithImpl<$Res>
    implements _$ApplyWhiteboardOperationsResponseCopyWith<$Res> {
  __$ApplyWhiteboardOperationsResponseCopyWithImpl(this._self, this._then);

  final _ApplyWhiteboardOperationsResponse _self;
  final $Res Function(_ApplyWhiteboardOperationsResponse) _then;

/// Create a copy of ApplyWhiteboardOperationsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? cursor = freezed,Object? appliedOperationIds = null,}) {
  return _then(_ApplyWhiteboardOperationsResponse(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,appliedOperationIds: null == appliedOperationIds ? _self.appliedOperationIds : appliedOperationIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$WhiteboardTemplateResponse {

 String get id; String get name; String get description; String get type; int get pageCount; int get objectCount;
/// Create a copy of WhiteboardTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardTemplateResponseCopyWith<WhiteboardTemplateResponse> get copyWith => _$WhiteboardTemplateResponseCopyWithImpl<WhiteboardTemplateResponse>(this as WhiteboardTemplateResponse, _$identity);

  /// Serializes this WhiteboardTemplateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardTemplateResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.objectCount, objectCount) || other.objectCount == objectCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,type,pageCount,objectCount);

@override
String toString() {
  return 'WhiteboardTemplateResponse(id: $id, name: $name, description: $description, type: $type, pageCount: $pageCount, objectCount: $objectCount)';
}


}

/// @nodoc
abstract mixin class $WhiteboardTemplateResponseCopyWith<$Res>  {
  factory $WhiteboardTemplateResponseCopyWith(WhiteboardTemplateResponse value, $Res Function(WhiteboardTemplateResponse) _then) = _$WhiteboardTemplateResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String type, int pageCount, int objectCount
});




}
/// @nodoc
class _$WhiteboardTemplateResponseCopyWithImpl<$Res>
    implements $WhiteboardTemplateResponseCopyWith<$Res> {
  _$WhiteboardTemplateResponseCopyWithImpl(this._self, this._then);

  final WhiteboardTemplateResponse _self;
  final $Res Function(WhiteboardTemplateResponse) _then;

/// Create a copy of WhiteboardTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? type = null,Object? pageCount = null,Object? objectCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,objectCount: null == objectCount ? _self.objectCount : objectCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardTemplateResponse].
extension WhiteboardTemplateResponsePatterns on WhiteboardTemplateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardTemplateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardTemplateResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardTemplateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardTemplateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String type,  int pageCount,  int objectCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardTemplateResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.type,_that.pageCount,_that.objectCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String type,  int pageCount,  int objectCount)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardTemplateResponse():
return $default(_that.id,_that.name,_that.description,_that.type,_that.pageCount,_that.objectCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String type,  int pageCount,  int objectCount)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardTemplateResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.type,_that.pageCount,_that.objectCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardTemplateResponse implements WhiteboardTemplateResponse {
  const _WhiteboardTemplateResponse({required this.id, required this.name, required this.description, required this.type, required this.pageCount, required this.objectCount});
  factory _WhiteboardTemplateResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardTemplateResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String type;
@override final  int pageCount;
@override final  int objectCount;

/// Create a copy of WhiteboardTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardTemplateResponseCopyWith<_WhiteboardTemplateResponse> get copyWith => __$WhiteboardTemplateResponseCopyWithImpl<_WhiteboardTemplateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardTemplateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardTemplateResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.objectCount, objectCount) || other.objectCount == objectCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,type,pageCount,objectCount);

@override
String toString() {
  return 'WhiteboardTemplateResponse(id: $id, name: $name, description: $description, type: $type, pageCount: $pageCount, objectCount: $objectCount)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardTemplateResponseCopyWith<$Res> implements $WhiteboardTemplateResponseCopyWith<$Res> {
  factory _$WhiteboardTemplateResponseCopyWith(_WhiteboardTemplateResponse value, $Res Function(_WhiteboardTemplateResponse) _then) = __$WhiteboardTemplateResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String type, int pageCount, int objectCount
});




}
/// @nodoc
class __$WhiteboardTemplateResponseCopyWithImpl<$Res>
    implements _$WhiteboardTemplateResponseCopyWith<$Res> {
  __$WhiteboardTemplateResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardTemplateResponse _self;
  final $Res Function(_WhiteboardTemplateResponse) _then;

/// Create a copy of WhiteboardTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? type = null,Object? pageCount = null,Object? objectCount = null,}) {
  return _then(_WhiteboardTemplateResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,objectCount: null == objectCount ? _self.objectCount : objectCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateWhiteboardFromTemplatePayload {

 String get templateId; String get name; String? get description;
/// Create a copy of CreateWhiteboardFromTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWhiteboardFromTemplatePayloadCopyWith<CreateWhiteboardFromTemplatePayload> get copyWith => _$CreateWhiteboardFromTemplatePayloadCopyWithImpl<CreateWhiteboardFromTemplatePayload>(this as CreateWhiteboardFromTemplatePayload, _$identity);

  /// Serializes this CreateWhiteboardFromTemplatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWhiteboardFromTemplatePayload&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,name,description);

@override
String toString() {
  return 'CreateWhiteboardFromTemplatePayload(templateId: $templateId, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $CreateWhiteboardFromTemplatePayloadCopyWith<$Res>  {
  factory $CreateWhiteboardFromTemplatePayloadCopyWith(CreateWhiteboardFromTemplatePayload value, $Res Function(CreateWhiteboardFromTemplatePayload) _then) = _$CreateWhiteboardFromTemplatePayloadCopyWithImpl;
@useResult
$Res call({
 String templateId, String name, String? description
});




}
/// @nodoc
class _$CreateWhiteboardFromTemplatePayloadCopyWithImpl<$Res>
    implements $CreateWhiteboardFromTemplatePayloadCopyWith<$Res> {
  _$CreateWhiteboardFromTemplatePayloadCopyWithImpl(this._self, this._then);

  final CreateWhiteboardFromTemplatePayload _self;
  final $Res Function(CreateWhiteboardFromTemplatePayload) _then;

/// Create a copy of CreateWhiteboardFromTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templateId = null,Object? name = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWhiteboardFromTemplatePayload].
extension CreateWhiteboardFromTemplatePayloadPatterns on CreateWhiteboardFromTemplatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWhiteboardFromTemplatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWhiteboardFromTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWhiteboardFromTemplatePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateWhiteboardFromTemplatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWhiteboardFromTemplatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWhiteboardFromTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String templateId,  String name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWhiteboardFromTemplatePayload() when $default != null:
return $default(_that.templateId,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String templateId,  String name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _CreateWhiteboardFromTemplatePayload():
return $default(_that.templateId,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String templateId,  String name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _CreateWhiteboardFromTemplatePayload() when $default != null:
return $default(_that.templateId,_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWhiteboardFromTemplatePayload implements CreateWhiteboardFromTemplatePayload {
  const _CreateWhiteboardFromTemplatePayload({required this.templateId, required this.name, this.description});
  factory _CreateWhiteboardFromTemplatePayload.fromJson(Map<String, dynamic> json) => _$CreateWhiteboardFromTemplatePayloadFromJson(json);

@override final  String templateId;
@override final  String name;
@override final  String? description;

/// Create a copy of CreateWhiteboardFromTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWhiteboardFromTemplatePayloadCopyWith<_CreateWhiteboardFromTemplatePayload> get copyWith => __$CreateWhiteboardFromTemplatePayloadCopyWithImpl<_CreateWhiteboardFromTemplatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWhiteboardFromTemplatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWhiteboardFromTemplatePayload&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,name,description);

@override
String toString() {
  return 'CreateWhiteboardFromTemplatePayload(templateId: $templateId, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CreateWhiteboardFromTemplatePayloadCopyWith<$Res> implements $CreateWhiteboardFromTemplatePayloadCopyWith<$Res> {
  factory _$CreateWhiteboardFromTemplatePayloadCopyWith(_CreateWhiteboardFromTemplatePayload value, $Res Function(_CreateWhiteboardFromTemplatePayload) _then) = __$CreateWhiteboardFromTemplatePayloadCopyWithImpl;
@override @useResult
$Res call({
 String templateId, String name, String? description
});




}
/// @nodoc
class __$CreateWhiteboardFromTemplatePayloadCopyWithImpl<$Res>
    implements _$CreateWhiteboardFromTemplatePayloadCopyWith<$Res> {
  __$CreateWhiteboardFromTemplatePayloadCopyWithImpl(this._self, this._then);

  final _CreateWhiteboardFromTemplatePayload _self;
  final $Res Function(_CreateWhiteboardFromTemplatePayload) _then;

/// Create a copy of CreateWhiteboardFromTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templateId = null,Object? name = null,Object? description = freezed,}) {
  return _then(_CreateWhiteboardFromTemplatePayload(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DuplicateWhiteboardPayload {

 String? get targetProjectId; String? get name; String? get description;
/// Create a copy of DuplicateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuplicateWhiteboardPayloadCopyWith<DuplicateWhiteboardPayload> get copyWith => _$DuplicateWhiteboardPayloadCopyWithImpl<DuplicateWhiteboardPayload>(this as DuplicateWhiteboardPayload, _$identity);

  /// Serializes this DuplicateWhiteboardPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuplicateWhiteboardPayload&&(identical(other.targetProjectId, targetProjectId) || other.targetProjectId == targetProjectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetProjectId,name,description);

@override
String toString() {
  return 'DuplicateWhiteboardPayload(targetProjectId: $targetProjectId, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $DuplicateWhiteboardPayloadCopyWith<$Res>  {
  factory $DuplicateWhiteboardPayloadCopyWith(DuplicateWhiteboardPayload value, $Res Function(DuplicateWhiteboardPayload) _then) = _$DuplicateWhiteboardPayloadCopyWithImpl;
@useResult
$Res call({
 String? targetProjectId, String? name, String? description
});




}
/// @nodoc
class _$DuplicateWhiteboardPayloadCopyWithImpl<$Res>
    implements $DuplicateWhiteboardPayloadCopyWith<$Res> {
  _$DuplicateWhiteboardPayloadCopyWithImpl(this._self, this._then);

  final DuplicateWhiteboardPayload _self;
  final $Res Function(DuplicateWhiteboardPayload) _then;

/// Create a copy of DuplicateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetProjectId = freezed,Object? name = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DuplicateWhiteboardPayload].
extension DuplicateWhiteboardPayloadPatterns on DuplicateWhiteboardPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuplicateWhiteboardPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuplicateWhiteboardPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuplicateWhiteboardPayload value)  $default,){
final _that = this;
switch (_that) {
case _DuplicateWhiteboardPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuplicateWhiteboardPayload value)?  $default,){
final _that = this;
switch (_that) {
case _DuplicateWhiteboardPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? targetProjectId,  String? name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuplicateWhiteboardPayload() when $default != null:
return $default(_that.targetProjectId,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? targetProjectId,  String? name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _DuplicateWhiteboardPayload():
return $default(_that.targetProjectId,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? targetProjectId,  String? name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _DuplicateWhiteboardPayload() when $default != null:
return $default(_that.targetProjectId,_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DuplicateWhiteboardPayload implements DuplicateWhiteboardPayload {
  const _DuplicateWhiteboardPayload({this.targetProjectId, this.name, this.description});
  factory _DuplicateWhiteboardPayload.fromJson(Map<String, dynamic> json) => _$DuplicateWhiteboardPayloadFromJson(json);

@override final  String? targetProjectId;
@override final  String? name;
@override final  String? description;

/// Create a copy of DuplicateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuplicateWhiteboardPayloadCopyWith<_DuplicateWhiteboardPayload> get copyWith => __$DuplicateWhiteboardPayloadCopyWithImpl<_DuplicateWhiteboardPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuplicateWhiteboardPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuplicateWhiteboardPayload&&(identical(other.targetProjectId, targetProjectId) || other.targetProjectId == targetProjectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetProjectId,name,description);

@override
String toString() {
  return 'DuplicateWhiteboardPayload(targetProjectId: $targetProjectId, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$DuplicateWhiteboardPayloadCopyWith<$Res> implements $DuplicateWhiteboardPayloadCopyWith<$Res> {
  factory _$DuplicateWhiteboardPayloadCopyWith(_DuplicateWhiteboardPayload value, $Res Function(_DuplicateWhiteboardPayload) _then) = __$DuplicateWhiteboardPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? targetProjectId, String? name, String? description
});




}
/// @nodoc
class __$DuplicateWhiteboardPayloadCopyWithImpl<$Res>
    implements _$DuplicateWhiteboardPayloadCopyWith<$Res> {
  __$DuplicateWhiteboardPayloadCopyWithImpl(this._self, this._then);

  final _DuplicateWhiteboardPayload _self;
  final $Res Function(_DuplicateWhiteboardPayload) _then;

/// Create a copy of DuplicateWhiteboardPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetProjectId = freezed,Object? name = freezed,Object? description = freezed,}) {
  return _then(_DuplicateWhiteboardPayload(
targetProjectId: freezed == targetProjectId ? _self.targetProjectId : targetProjectId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateWhiteboardExportPayload {

 WhiteboardExportFormat get format; WhiteboardExportScope get scope; String? get pageId; WhiteboardExportViewport? get viewport;
/// Create a copy of CreateWhiteboardExportPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWhiteboardExportPayloadCopyWith<CreateWhiteboardExportPayload> get copyWith => _$CreateWhiteboardExportPayloadCopyWithImpl<CreateWhiteboardExportPayload>(this as CreateWhiteboardExportPayload, _$identity);

  /// Serializes this CreateWhiteboardExportPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWhiteboardExportPayload&&(identical(other.format, format) || other.format == format)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.viewport, viewport) || other.viewport == viewport));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,format,scope,pageId,viewport);

@override
String toString() {
  return 'CreateWhiteboardExportPayload(format: $format, scope: $scope, pageId: $pageId, viewport: $viewport)';
}


}

/// @nodoc
abstract mixin class $CreateWhiteboardExportPayloadCopyWith<$Res>  {
  factory $CreateWhiteboardExportPayloadCopyWith(CreateWhiteboardExportPayload value, $Res Function(CreateWhiteboardExportPayload) _then) = _$CreateWhiteboardExportPayloadCopyWithImpl;
@useResult
$Res call({
 WhiteboardExportFormat format, WhiteboardExportScope scope, String? pageId, WhiteboardExportViewport? viewport
});


$WhiteboardExportViewportCopyWith<$Res>? get viewport;

}
/// @nodoc
class _$CreateWhiteboardExportPayloadCopyWithImpl<$Res>
    implements $CreateWhiteboardExportPayloadCopyWith<$Res> {
  _$CreateWhiteboardExportPayloadCopyWithImpl(this._self, this._then);

  final CreateWhiteboardExportPayload _self;
  final $Res Function(CreateWhiteboardExportPayload) _then;

/// Create a copy of CreateWhiteboardExportPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? format = null,Object? scope = null,Object? pageId = freezed,Object? viewport = freezed,}) {
  return _then(_self.copyWith(
format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as WhiteboardExportFormat,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as WhiteboardExportScope,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,viewport: freezed == viewport ? _self.viewport : viewport // ignore: cast_nullable_to_non_nullable
as WhiteboardExportViewport?,
  ));
}
/// Create a copy of CreateWhiteboardExportPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardExportViewportCopyWith<$Res>? get viewport {
    if (_self.viewport == null) {
    return null;
  }

  return $WhiteboardExportViewportCopyWith<$Res>(_self.viewport!, (value) {
    return _then(_self.copyWith(viewport: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateWhiteboardExportPayload].
extension CreateWhiteboardExportPayloadPatterns on CreateWhiteboardExportPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWhiteboardExportPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWhiteboardExportPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWhiteboardExportPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateWhiteboardExportPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWhiteboardExportPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWhiteboardExportPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WhiteboardExportFormat format,  WhiteboardExportScope scope,  String? pageId,  WhiteboardExportViewport? viewport)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWhiteboardExportPayload() when $default != null:
return $default(_that.format,_that.scope,_that.pageId,_that.viewport);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WhiteboardExportFormat format,  WhiteboardExportScope scope,  String? pageId,  WhiteboardExportViewport? viewport)  $default,) {final _that = this;
switch (_that) {
case _CreateWhiteboardExportPayload():
return $default(_that.format,_that.scope,_that.pageId,_that.viewport);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WhiteboardExportFormat format,  WhiteboardExportScope scope,  String? pageId,  WhiteboardExportViewport? viewport)?  $default,) {final _that = this;
switch (_that) {
case _CreateWhiteboardExportPayload() when $default != null:
return $default(_that.format,_that.scope,_that.pageId,_that.viewport);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWhiteboardExportPayload implements CreateWhiteboardExportPayload {
  const _CreateWhiteboardExportPayload({required this.format, required this.scope, this.pageId, this.viewport});
  factory _CreateWhiteboardExportPayload.fromJson(Map<String, dynamic> json) => _$CreateWhiteboardExportPayloadFromJson(json);

@override final  WhiteboardExportFormat format;
@override final  WhiteboardExportScope scope;
@override final  String? pageId;
@override final  WhiteboardExportViewport? viewport;

/// Create a copy of CreateWhiteboardExportPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWhiteboardExportPayloadCopyWith<_CreateWhiteboardExportPayload> get copyWith => __$CreateWhiteboardExportPayloadCopyWithImpl<_CreateWhiteboardExportPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWhiteboardExportPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWhiteboardExportPayload&&(identical(other.format, format) || other.format == format)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.viewport, viewport) || other.viewport == viewport));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,format,scope,pageId,viewport);

@override
String toString() {
  return 'CreateWhiteboardExportPayload(format: $format, scope: $scope, pageId: $pageId, viewport: $viewport)';
}


}

/// @nodoc
abstract mixin class _$CreateWhiteboardExportPayloadCopyWith<$Res> implements $CreateWhiteboardExportPayloadCopyWith<$Res> {
  factory _$CreateWhiteboardExportPayloadCopyWith(_CreateWhiteboardExportPayload value, $Res Function(_CreateWhiteboardExportPayload) _then) = __$CreateWhiteboardExportPayloadCopyWithImpl;
@override @useResult
$Res call({
 WhiteboardExportFormat format, WhiteboardExportScope scope, String? pageId, WhiteboardExportViewport? viewport
});


@override $WhiteboardExportViewportCopyWith<$Res>? get viewport;

}
/// @nodoc
class __$CreateWhiteboardExportPayloadCopyWithImpl<$Res>
    implements _$CreateWhiteboardExportPayloadCopyWith<$Res> {
  __$CreateWhiteboardExportPayloadCopyWithImpl(this._self, this._then);

  final _CreateWhiteboardExportPayload _self;
  final $Res Function(_CreateWhiteboardExportPayload) _then;

/// Create a copy of CreateWhiteboardExportPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? format = null,Object? scope = null,Object? pageId = freezed,Object? viewport = freezed,}) {
  return _then(_CreateWhiteboardExportPayload(
format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as WhiteboardExportFormat,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as WhiteboardExportScope,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,viewport: freezed == viewport ? _self.viewport : viewport // ignore: cast_nullable_to_non_nullable
as WhiteboardExportViewport?,
  ));
}

/// Create a copy of CreateWhiteboardExportPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardExportViewportCopyWith<$Res>? get viewport {
    if (_self.viewport == null) {
    return null;
  }

  return $WhiteboardExportViewportCopyWith<$Res>(_self.viewport!, (value) {
    return _then(_self.copyWith(viewport: value));
  });
}
}


/// @nodoc
mixin _$WhiteboardExportViewport {

 double get x; double get y; double get width; double get height;
/// Create a copy of WhiteboardExportViewport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardExportViewportCopyWith<WhiteboardExportViewport> get copyWith => _$WhiteboardExportViewportCopyWithImpl<WhiteboardExportViewport>(this as WhiteboardExportViewport, _$identity);

  /// Serializes this WhiteboardExportViewport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardExportViewport&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y,width,height);

@override
String toString() {
  return 'WhiteboardExportViewport(x: $x, y: $y, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $WhiteboardExportViewportCopyWith<$Res>  {
  factory $WhiteboardExportViewportCopyWith(WhiteboardExportViewport value, $Res Function(WhiteboardExportViewport) _then) = _$WhiteboardExportViewportCopyWithImpl;
@useResult
$Res call({
 double x, double y, double width, double height
});




}
/// @nodoc
class _$WhiteboardExportViewportCopyWithImpl<$Res>
    implements $WhiteboardExportViewportCopyWith<$Res> {
  _$WhiteboardExportViewportCopyWithImpl(this._self, this._then);

  final WhiteboardExportViewport _self;
  final $Res Function(WhiteboardExportViewport) _then;

/// Create a copy of WhiteboardExportViewport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardExportViewport].
extension WhiteboardExportViewportPatterns on WhiteboardExportViewport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardExportViewport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardExportViewport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardExportViewport value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardExportViewport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardExportViewport value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardExportViewport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double x,  double y,  double width,  double height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardExportViewport() when $default != null:
return $default(_that.x,_that.y,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double x,  double y,  double width,  double height)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardExportViewport():
return $default(_that.x,_that.y,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double x,  double y,  double width,  double height)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardExportViewport() when $default != null:
return $default(_that.x,_that.y,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardExportViewport implements WhiteboardExportViewport {
  const _WhiteboardExportViewport({required this.x, required this.y, required this.width, required this.height});
  factory _WhiteboardExportViewport.fromJson(Map<String, dynamic> json) => _$WhiteboardExportViewportFromJson(json);

@override final  double x;
@override final  double y;
@override final  double width;
@override final  double height;

/// Create a copy of WhiteboardExportViewport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardExportViewportCopyWith<_WhiteboardExportViewport> get copyWith => __$WhiteboardExportViewportCopyWithImpl<_WhiteboardExportViewport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardExportViewportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardExportViewport&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y,width,height);

@override
String toString() {
  return 'WhiteboardExportViewport(x: $x, y: $y, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardExportViewportCopyWith<$Res> implements $WhiteboardExportViewportCopyWith<$Res> {
  factory _$WhiteboardExportViewportCopyWith(_WhiteboardExportViewport value, $Res Function(_WhiteboardExportViewport) _then) = __$WhiteboardExportViewportCopyWithImpl;
@override @useResult
$Res call({
 double x, double y, double width, double height
});




}
/// @nodoc
class __$WhiteboardExportViewportCopyWithImpl<$Res>
    implements _$WhiteboardExportViewportCopyWith<$Res> {
  __$WhiteboardExportViewportCopyWithImpl(this._self, this._then);

  final _WhiteboardExportViewport _self;
  final $Res Function(_WhiteboardExportViewport) _then;

/// Create a copy of WhiteboardExportViewport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,Object? width = null,Object? height = null,}) {
  return _then(_WhiteboardExportViewport(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$WhiteboardExportResponse {

 String get id; WhiteboardExportJobStatus get status; WhiteboardExportFormat get format; WhiteboardExportScope get scope; String? get storageFileId; String? get failureCode; DateTime get createdAtUtc; DateTime? get completedAtUtc;
/// Create a copy of WhiteboardExportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardExportResponseCopyWith<WhiteboardExportResponse> get copyWith => _$WhiteboardExportResponseCopyWithImpl<WhiteboardExportResponse>(this as WhiteboardExportResponse, _$identity);

  /// Serializes this WhiteboardExportResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardExportResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.format, format) || other.format == format)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,format,scope,storageFileId,failureCode,createdAtUtc,completedAtUtc);

@override
String toString() {
  return 'WhiteboardExportResponse(id: $id, status: $status, format: $format, scope: $scope, storageFileId: $storageFileId, failureCode: $failureCode, createdAtUtc: $createdAtUtc, completedAtUtc: $completedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WhiteboardExportResponseCopyWith<$Res>  {
  factory $WhiteboardExportResponseCopyWith(WhiteboardExportResponse value, $Res Function(WhiteboardExportResponse) _then) = _$WhiteboardExportResponseCopyWithImpl;
@useResult
$Res call({
 String id, WhiteboardExportJobStatus status, WhiteboardExportFormat format, WhiteboardExportScope scope, String? storageFileId, String? failureCode, DateTime createdAtUtc, DateTime? completedAtUtc
});




}
/// @nodoc
class _$WhiteboardExportResponseCopyWithImpl<$Res>
    implements $WhiteboardExportResponseCopyWith<$Res> {
  _$WhiteboardExportResponseCopyWithImpl(this._self, this._then);

  final WhiteboardExportResponse _self;
  final $Res Function(WhiteboardExportResponse) _then;

/// Create a copy of WhiteboardExportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? format = null,Object? scope = null,Object? storageFileId = freezed,Object? failureCode = freezed,Object? createdAtUtc = null,Object? completedAtUtc = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WhiteboardExportJobStatus,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as WhiteboardExportFormat,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as WhiteboardExportScope,storageFileId: freezed == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardExportResponse].
extension WhiteboardExportResponsePatterns on WhiteboardExportResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardExportResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardExportResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardExportResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardExportResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardExportResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardExportResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  WhiteboardExportJobStatus status,  WhiteboardExportFormat format,  WhiteboardExportScope scope,  String? storageFileId,  String? failureCode,  DateTime createdAtUtc,  DateTime? completedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardExportResponse() when $default != null:
return $default(_that.id,_that.status,_that.format,_that.scope,_that.storageFileId,_that.failureCode,_that.createdAtUtc,_that.completedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  WhiteboardExportJobStatus status,  WhiteboardExportFormat format,  WhiteboardExportScope scope,  String? storageFileId,  String? failureCode,  DateTime createdAtUtc,  DateTime? completedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardExportResponse():
return $default(_that.id,_that.status,_that.format,_that.scope,_that.storageFileId,_that.failureCode,_that.createdAtUtc,_that.completedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  WhiteboardExportJobStatus status,  WhiteboardExportFormat format,  WhiteboardExportScope scope,  String? storageFileId,  String? failureCode,  DateTime createdAtUtc,  DateTime? completedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardExportResponse() when $default != null:
return $default(_that.id,_that.status,_that.format,_that.scope,_that.storageFileId,_that.failureCode,_that.createdAtUtc,_that.completedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardExportResponse implements WhiteboardExportResponse {
  const _WhiteboardExportResponse({required this.id, required this.status, required this.format, required this.scope, this.storageFileId, this.failureCode, required this.createdAtUtc, this.completedAtUtc});
  factory _WhiteboardExportResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardExportResponseFromJson(json);

@override final  String id;
@override final  WhiteboardExportJobStatus status;
@override final  WhiteboardExportFormat format;
@override final  WhiteboardExportScope scope;
@override final  String? storageFileId;
@override final  String? failureCode;
@override final  DateTime createdAtUtc;
@override final  DateTime? completedAtUtc;

/// Create a copy of WhiteboardExportResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardExportResponseCopyWith<_WhiteboardExportResponse> get copyWith => __$WhiteboardExportResponseCopyWithImpl<_WhiteboardExportResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardExportResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardExportResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.format, format) || other.format == format)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,format,scope,storageFileId,failureCode,createdAtUtc,completedAtUtc);

@override
String toString() {
  return 'WhiteboardExportResponse(id: $id, status: $status, format: $format, scope: $scope, storageFileId: $storageFileId, failureCode: $failureCode, createdAtUtc: $createdAtUtc, completedAtUtc: $completedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardExportResponseCopyWith<$Res> implements $WhiteboardExportResponseCopyWith<$Res> {
  factory _$WhiteboardExportResponseCopyWith(_WhiteboardExportResponse value, $Res Function(_WhiteboardExportResponse) _then) = __$WhiteboardExportResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, WhiteboardExportJobStatus status, WhiteboardExportFormat format, WhiteboardExportScope scope, String? storageFileId, String? failureCode, DateTime createdAtUtc, DateTime? completedAtUtc
});




}
/// @nodoc
class __$WhiteboardExportResponseCopyWithImpl<$Res>
    implements _$WhiteboardExportResponseCopyWith<$Res> {
  __$WhiteboardExportResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardExportResponse _self;
  final $Res Function(_WhiteboardExportResponse) _then;

/// Create a copy of WhiteboardExportResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? format = null,Object? scope = null,Object? storageFileId = freezed,Object? failureCode = freezed,Object? createdAtUtc = null,Object? completedAtUtc = freezed,}) {
  return _then(_WhiteboardExportResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WhiteboardExportJobStatus,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as WhiteboardExportFormat,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as WhiteboardExportScope,storageFileId: freezed == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$WhiteboardAiClusterPayload {

 List<String> get objectIds; String? get instruction;
/// Create a copy of WhiteboardAiClusterPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardAiClusterPayloadCopyWith<WhiteboardAiClusterPayload> get copyWith => _$WhiteboardAiClusterPayloadCopyWithImpl<WhiteboardAiClusterPayload>(this as WhiteboardAiClusterPayload, _$identity);

  /// Serializes this WhiteboardAiClusterPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardAiClusterPayload&&const DeepCollectionEquality().equals(other.objectIds, objectIds)&&(identical(other.instruction, instruction) || other.instruction == instruction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(objectIds),instruction);

@override
String toString() {
  return 'WhiteboardAiClusterPayload(objectIds: $objectIds, instruction: $instruction)';
}


}

/// @nodoc
abstract mixin class $WhiteboardAiClusterPayloadCopyWith<$Res>  {
  factory $WhiteboardAiClusterPayloadCopyWith(WhiteboardAiClusterPayload value, $Res Function(WhiteboardAiClusterPayload) _then) = _$WhiteboardAiClusterPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> objectIds, String? instruction
});




}
/// @nodoc
class _$WhiteboardAiClusterPayloadCopyWithImpl<$Res>
    implements $WhiteboardAiClusterPayloadCopyWith<$Res> {
  _$WhiteboardAiClusterPayloadCopyWithImpl(this._self, this._then);

  final WhiteboardAiClusterPayload _self;
  final $Res Function(WhiteboardAiClusterPayload) _then;

/// Create a copy of WhiteboardAiClusterPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? objectIds = null,Object? instruction = freezed,}) {
  return _then(_self.copyWith(
objectIds: null == objectIds ? _self.objectIds : objectIds // ignore: cast_nullable_to_non_nullable
as List<String>,instruction: freezed == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardAiClusterPayload].
extension WhiteboardAiClusterPayloadPatterns on WhiteboardAiClusterPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardAiClusterPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardAiClusterPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardAiClusterPayload value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiClusterPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardAiClusterPayload value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiClusterPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> objectIds,  String? instruction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardAiClusterPayload() when $default != null:
return $default(_that.objectIds,_that.instruction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> objectIds,  String? instruction)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiClusterPayload():
return $default(_that.objectIds,_that.instruction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> objectIds,  String? instruction)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiClusterPayload() when $default != null:
return $default(_that.objectIds,_that.instruction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardAiClusterPayload implements WhiteboardAiClusterPayload {
  const _WhiteboardAiClusterPayload({required this.objectIds, this.instruction});
  factory _WhiteboardAiClusterPayload.fromJson(Map<String, dynamic> json) => _$WhiteboardAiClusterPayloadFromJson(json);

@override final  List<String> objectIds;
@override final  String? instruction;

/// Create a copy of WhiteboardAiClusterPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardAiClusterPayloadCopyWith<_WhiteboardAiClusterPayload> get copyWith => __$WhiteboardAiClusterPayloadCopyWithImpl<_WhiteboardAiClusterPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardAiClusterPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardAiClusterPayload&&const DeepCollectionEquality().equals(other.objectIds, objectIds)&&(identical(other.instruction, instruction) || other.instruction == instruction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(objectIds),instruction);

@override
String toString() {
  return 'WhiteboardAiClusterPayload(objectIds: $objectIds, instruction: $instruction)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardAiClusterPayloadCopyWith<$Res> implements $WhiteboardAiClusterPayloadCopyWith<$Res> {
  factory _$WhiteboardAiClusterPayloadCopyWith(_WhiteboardAiClusterPayload value, $Res Function(_WhiteboardAiClusterPayload) _then) = __$WhiteboardAiClusterPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> objectIds, String? instruction
});




}
/// @nodoc
class __$WhiteboardAiClusterPayloadCopyWithImpl<$Res>
    implements _$WhiteboardAiClusterPayloadCopyWith<$Res> {
  __$WhiteboardAiClusterPayloadCopyWithImpl(this._self, this._then);

  final _WhiteboardAiClusterPayload _self;
  final $Res Function(_WhiteboardAiClusterPayload) _then;

/// Create a copy of WhiteboardAiClusterPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? objectIds = null,Object? instruction = freezed,}) {
  return _then(_WhiteboardAiClusterPayload(
objectIds: null == objectIds ? _self.objectIds : objectIds // ignore: cast_nullable_to_non_nullable
as List<String>,instruction: freezed == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WhiteboardAiGenerateFlowPayload {

 String get instruction; String? get pageId; List<String>? get contextObjectIds;
/// Create a copy of WhiteboardAiGenerateFlowPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardAiGenerateFlowPayloadCopyWith<WhiteboardAiGenerateFlowPayload> get copyWith => _$WhiteboardAiGenerateFlowPayloadCopyWithImpl<WhiteboardAiGenerateFlowPayload>(this as WhiteboardAiGenerateFlowPayload, _$identity);

  /// Serializes this WhiteboardAiGenerateFlowPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardAiGenerateFlowPayload&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&const DeepCollectionEquality().equals(other.contextObjectIds, contextObjectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instruction,pageId,const DeepCollectionEquality().hash(contextObjectIds));

@override
String toString() {
  return 'WhiteboardAiGenerateFlowPayload(instruction: $instruction, pageId: $pageId, contextObjectIds: $contextObjectIds)';
}


}

/// @nodoc
abstract mixin class $WhiteboardAiGenerateFlowPayloadCopyWith<$Res>  {
  factory $WhiteboardAiGenerateFlowPayloadCopyWith(WhiteboardAiGenerateFlowPayload value, $Res Function(WhiteboardAiGenerateFlowPayload) _then) = _$WhiteboardAiGenerateFlowPayloadCopyWithImpl;
@useResult
$Res call({
 String instruction, String? pageId, List<String>? contextObjectIds
});




}
/// @nodoc
class _$WhiteboardAiGenerateFlowPayloadCopyWithImpl<$Res>
    implements $WhiteboardAiGenerateFlowPayloadCopyWith<$Res> {
  _$WhiteboardAiGenerateFlowPayloadCopyWithImpl(this._self, this._then);

  final WhiteboardAiGenerateFlowPayload _self;
  final $Res Function(WhiteboardAiGenerateFlowPayload) _then;

/// Create a copy of WhiteboardAiGenerateFlowPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instruction = null,Object? pageId = freezed,Object? contextObjectIds = freezed,}) {
  return _then(_self.copyWith(
instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,contextObjectIds: freezed == contextObjectIds ? _self.contextObjectIds : contextObjectIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardAiGenerateFlowPayload].
extension WhiteboardAiGenerateFlowPayloadPatterns on WhiteboardAiGenerateFlowPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardAiGenerateFlowPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardAiGenerateFlowPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardAiGenerateFlowPayload value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiGenerateFlowPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardAiGenerateFlowPayload value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiGenerateFlowPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String instruction,  String? pageId,  List<String>? contextObjectIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardAiGenerateFlowPayload() when $default != null:
return $default(_that.instruction,_that.pageId,_that.contextObjectIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String instruction,  String? pageId,  List<String>? contextObjectIds)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiGenerateFlowPayload():
return $default(_that.instruction,_that.pageId,_that.contextObjectIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String instruction,  String? pageId,  List<String>? contextObjectIds)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiGenerateFlowPayload() when $default != null:
return $default(_that.instruction,_that.pageId,_that.contextObjectIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardAiGenerateFlowPayload implements WhiteboardAiGenerateFlowPayload {
  const _WhiteboardAiGenerateFlowPayload({required this.instruction, this.pageId, this.contextObjectIds});
  factory _WhiteboardAiGenerateFlowPayload.fromJson(Map<String, dynamic> json) => _$WhiteboardAiGenerateFlowPayloadFromJson(json);

@override final  String instruction;
@override final  String? pageId;
@override final  List<String>? contextObjectIds;

/// Create a copy of WhiteboardAiGenerateFlowPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardAiGenerateFlowPayloadCopyWith<_WhiteboardAiGenerateFlowPayload> get copyWith => __$WhiteboardAiGenerateFlowPayloadCopyWithImpl<_WhiteboardAiGenerateFlowPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardAiGenerateFlowPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardAiGenerateFlowPayload&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.pageId, pageId) || other.pageId == pageId)&&const DeepCollectionEquality().equals(other.contextObjectIds, contextObjectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instruction,pageId,const DeepCollectionEquality().hash(contextObjectIds));

@override
String toString() {
  return 'WhiteboardAiGenerateFlowPayload(instruction: $instruction, pageId: $pageId, contextObjectIds: $contextObjectIds)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardAiGenerateFlowPayloadCopyWith<$Res> implements $WhiteboardAiGenerateFlowPayloadCopyWith<$Res> {
  factory _$WhiteboardAiGenerateFlowPayloadCopyWith(_WhiteboardAiGenerateFlowPayload value, $Res Function(_WhiteboardAiGenerateFlowPayload) _then) = __$WhiteboardAiGenerateFlowPayloadCopyWithImpl;
@override @useResult
$Res call({
 String instruction, String? pageId, List<String>? contextObjectIds
});




}
/// @nodoc
class __$WhiteboardAiGenerateFlowPayloadCopyWithImpl<$Res>
    implements _$WhiteboardAiGenerateFlowPayloadCopyWith<$Res> {
  __$WhiteboardAiGenerateFlowPayloadCopyWithImpl(this._self, this._then);

  final _WhiteboardAiGenerateFlowPayload _self;
  final $Res Function(_WhiteboardAiGenerateFlowPayload) _then;

/// Create a copy of WhiteboardAiGenerateFlowPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instruction = null,Object? pageId = freezed,Object? contextObjectIds = freezed,}) {
  return _then(_WhiteboardAiGenerateFlowPayload(
instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,pageId: freezed == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String?,contextObjectIds: freezed == contextObjectIds ? _self.contextObjectIds : contextObjectIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$WhiteboardAiClusterResponse {

 String get clusterId; String get label; List<String> get objectIds;
/// Create a copy of WhiteboardAiClusterResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardAiClusterResponseCopyWith<WhiteboardAiClusterResponse> get copyWith => _$WhiteboardAiClusterResponseCopyWithImpl<WhiteboardAiClusterResponse>(this as WhiteboardAiClusterResponse, _$identity);

  /// Serializes this WhiteboardAiClusterResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardAiClusterResponse&&(identical(other.clusterId, clusterId) || other.clusterId == clusterId)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.objectIds, objectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clusterId,label,const DeepCollectionEquality().hash(objectIds));

@override
String toString() {
  return 'WhiteboardAiClusterResponse(clusterId: $clusterId, label: $label, objectIds: $objectIds)';
}


}

/// @nodoc
abstract mixin class $WhiteboardAiClusterResponseCopyWith<$Res>  {
  factory $WhiteboardAiClusterResponseCopyWith(WhiteboardAiClusterResponse value, $Res Function(WhiteboardAiClusterResponse) _then) = _$WhiteboardAiClusterResponseCopyWithImpl;
@useResult
$Res call({
 String clusterId, String label, List<String> objectIds
});




}
/// @nodoc
class _$WhiteboardAiClusterResponseCopyWithImpl<$Res>
    implements $WhiteboardAiClusterResponseCopyWith<$Res> {
  _$WhiteboardAiClusterResponseCopyWithImpl(this._self, this._then);

  final WhiteboardAiClusterResponse _self;
  final $Res Function(WhiteboardAiClusterResponse) _then;

/// Create a copy of WhiteboardAiClusterResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clusterId = null,Object? label = null,Object? objectIds = null,}) {
  return _then(_self.copyWith(
clusterId: null == clusterId ? _self.clusterId : clusterId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,objectIds: null == objectIds ? _self.objectIds : objectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardAiClusterResponse].
extension WhiteboardAiClusterResponsePatterns on WhiteboardAiClusterResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardAiClusterResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardAiClusterResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardAiClusterResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiClusterResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardAiClusterResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiClusterResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clusterId,  String label,  List<String> objectIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardAiClusterResponse() when $default != null:
return $default(_that.clusterId,_that.label,_that.objectIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clusterId,  String label,  List<String> objectIds)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiClusterResponse():
return $default(_that.clusterId,_that.label,_that.objectIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clusterId,  String label,  List<String> objectIds)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiClusterResponse() when $default != null:
return $default(_that.clusterId,_that.label,_that.objectIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardAiClusterResponse implements WhiteboardAiClusterResponse {
  const _WhiteboardAiClusterResponse({required this.clusterId, required this.label, required this.objectIds});
  factory _WhiteboardAiClusterResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardAiClusterResponseFromJson(json);

@override final  String clusterId;
@override final  String label;
@override final  List<String> objectIds;

/// Create a copy of WhiteboardAiClusterResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardAiClusterResponseCopyWith<_WhiteboardAiClusterResponse> get copyWith => __$WhiteboardAiClusterResponseCopyWithImpl<_WhiteboardAiClusterResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardAiClusterResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardAiClusterResponse&&(identical(other.clusterId, clusterId) || other.clusterId == clusterId)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.objectIds, objectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clusterId,label,const DeepCollectionEquality().hash(objectIds));

@override
String toString() {
  return 'WhiteboardAiClusterResponse(clusterId: $clusterId, label: $label, objectIds: $objectIds)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardAiClusterResponseCopyWith<$Res> implements $WhiteboardAiClusterResponseCopyWith<$Res> {
  factory _$WhiteboardAiClusterResponseCopyWith(_WhiteboardAiClusterResponse value, $Res Function(_WhiteboardAiClusterResponse) _then) = __$WhiteboardAiClusterResponseCopyWithImpl;
@override @useResult
$Res call({
 String clusterId, String label, List<String> objectIds
});




}
/// @nodoc
class __$WhiteboardAiClusterResponseCopyWithImpl<$Res>
    implements _$WhiteboardAiClusterResponseCopyWith<$Res> {
  __$WhiteboardAiClusterResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardAiClusterResponse _self;
  final $Res Function(_WhiteboardAiClusterResponse) _then;

/// Create a copy of WhiteboardAiClusterResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clusterId = null,Object? label = null,Object? objectIds = null,}) {
  return _then(_WhiteboardAiClusterResponse(
clusterId: null == clusterId ? _self.clusterId : clusterId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,objectIds: null == objectIds ? _self.objectIds : objectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$WhiteboardAiGeneratedObjectResponse {

 String get id; String get clientId; String get kind; WhiteboardPoint get position; double get width; double get height; Map<String, dynamic> get data;
/// Create a copy of WhiteboardAiGeneratedObjectResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardAiGeneratedObjectResponseCopyWith<WhiteboardAiGeneratedObjectResponse> get copyWith => _$WhiteboardAiGeneratedObjectResponseCopyWithImpl<WhiteboardAiGeneratedObjectResponse>(this as WhiteboardAiGeneratedObjectResponse, _$identity);

  /// Serializes this WhiteboardAiGeneratedObjectResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardAiGeneratedObjectResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,kind,position,width,height,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'WhiteboardAiGeneratedObjectResponse(id: $id, clientId: $clientId, kind: $kind, position: $position, width: $width, height: $height, data: $data)';
}


}

/// @nodoc
abstract mixin class $WhiteboardAiGeneratedObjectResponseCopyWith<$Res>  {
  factory $WhiteboardAiGeneratedObjectResponseCopyWith(WhiteboardAiGeneratedObjectResponse value, $Res Function(WhiteboardAiGeneratedObjectResponse) _then) = _$WhiteboardAiGeneratedObjectResponseCopyWithImpl;
@useResult
$Res call({
 String id, String clientId, String kind, WhiteboardPoint position, double width, double height, Map<String, dynamic> data
});


$WhiteboardPointCopyWith<$Res> get position;

}
/// @nodoc
class _$WhiteboardAiGeneratedObjectResponseCopyWithImpl<$Res>
    implements $WhiteboardAiGeneratedObjectResponseCopyWith<$Res> {
  _$WhiteboardAiGeneratedObjectResponseCopyWithImpl(this._self, this._then);

  final WhiteboardAiGeneratedObjectResponse _self;
  final $Res Function(WhiteboardAiGeneratedObjectResponse) _then;

/// Create a copy of WhiteboardAiGeneratedObjectResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? kind = null,Object? position = null,Object? width = null,Object? height = null,Object? data = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as WhiteboardPoint,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}
/// Create a copy of WhiteboardAiGeneratedObjectResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardPointCopyWith<$Res> get position {
  
  return $WhiteboardPointCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// Adds pattern-matching-related methods to [WhiteboardAiGeneratedObjectResponse].
extension WhiteboardAiGeneratedObjectResponsePatterns on WhiteboardAiGeneratedObjectResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardAiGeneratedObjectResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedObjectResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardAiGeneratedObjectResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedObjectResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardAiGeneratedObjectResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedObjectResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientId,  String kind,  WhiteboardPoint position,  double width,  double height,  Map<String, dynamic> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedObjectResponse() when $default != null:
return $default(_that.id,_that.clientId,_that.kind,_that.position,_that.width,_that.height,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientId,  String kind,  WhiteboardPoint position,  double width,  double height,  Map<String, dynamic> data)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedObjectResponse():
return $default(_that.id,_that.clientId,_that.kind,_that.position,_that.width,_that.height,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientId,  String kind,  WhiteboardPoint position,  double width,  double height,  Map<String, dynamic> data)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedObjectResponse() when $default != null:
return $default(_that.id,_that.clientId,_that.kind,_that.position,_that.width,_that.height,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardAiGeneratedObjectResponse implements WhiteboardAiGeneratedObjectResponse {
  const _WhiteboardAiGeneratedObjectResponse({required this.id, required this.clientId, required this.kind, required this.position, required this.width, required this.height, required this.data});
  factory _WhiteboardAiGeneratedObjectResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardAiGeneratedObjectResponseFromJson(json);

@override final  String id;
@override final  String clientId;
@override final  String kind;
@override final  WhiteboardPoint position;
@override final  double width;
@override final  double height;
@override final  Map<String, dynamic> data;

/// Create a copy of WhiteboardAiGeneratedObjectResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardAiGeneratedObjectResponseCopyWith<_WhiteboardAiGeneratedObjectResponse> get copyWith => __$WhiteboardAiGeneratedObjectResponseCopyWithImpl<_WhiteboardAiGeneratedObjectResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardAiGeneratedObjectResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardAiGeneratedObjectResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,kind,position,width,height,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'WhiteboardAiGeneratedObjectResponse(id: $id, clientId: $clientId, kind: $kind, position: $position, width: $width, height: $height, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardAiGeneratedObjectResponseCopyWith<$Res> implements $WhiteboardAiGeneratedObjectResponseCopyWith<$Res> {
  factory _$WhiteboardAiGeneratedObjectResponseCopyWith(_WhiteboardAiGeneratedObjectResponse value, $Res Function(_WhiteboardAiGeneratedObjectResponse) _then) = __$WhiteboardAiGeneratedObjectResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientId, String kind, WhiteboardPoint position, double width, double height, Map<String, dynamic> data
});


@override $WhiteboardPointCopyWith<$Res> get position;

}
/// @nodoc
class __$WhiteboardAiGeneratedObjectResponseCopyWithImpl<$Res>
    implements _$WhiteboardAiGeneratedObjectResponseCopyWith<$Res> {
  __$WhiteboardAiGeneratedObjectResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardAiGeneratedObjectResponse _self;
  final $Res Function(_WhiteboardAiGeneratedObjectResponse) _then;

/// Create a copy of WhiteboardAiGeneratedObjectResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? kind = null,Object? position = null,Object? width = null,Object? height = null,Object? data = null,}) {
  return _then(_WhiteboardAiGeneratedObjectResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as WhiteboardPoint,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of WhiteboardAiGeneratedObjectResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WhiteboardPointCopyWith<$Res> get position {
  
  return $WhiteboardPointCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// @nodoc
mixin _$WhiteboardAiGeneratedConnectorResponse {

 String get id; String get sourceClientId; String get targetClientId; String? get label;
/// Create a copy of WhiteboardAiGeneratedConnectorResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardAiGeneratedConnectorResponseCopyWith<WhiteboardAiGeneratedConnectorResponse> get copyWith => _$WhiteboardAiGeneratedConnectorResponseCopyWithImpl<WhiteboardAiGeneratedConnectorResponse>(this as WhiteboardAiGeneratedConnectorResponse, _$identity);

  /// Serializes this WhiteboardAiGeneratedConnectorResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardAiGeneratedConnectorResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceClientId, sourceClientId) || other.sourceClientId == sourceClientId)&&(identical(other.targetClientId, targetClientId) || other.targetClientId == targetClientId)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceClientId,targetClientId,label);

@override
String toString() {
  return 'WhiteboardAiGeneratedConnectorResponse(id: $id, sourceClientId: $sourceClientId, targetClientId: $targetClientId, label: $label)';
}


}

/// @nodoc
abstract mixin class $WhiteboardAiGeneratedConnectorResponseCopyWith<$Res>  {
  factory $WhiteboardAiGeneratedConnectorResponseCopyWith(WhiteboardAiGeneratedConnectorResponse value, $Res Function(WhiteboardAiGeneratedConnectorResponse) _then) = _$WhiteboardAiGeneratedConnectorResponseCopyWithImpl;
@useResult
$Res call({
 String id, String sourceClientId, String targetClientId, String? label
});




}
/// @nodoc
class _$WhiteboardAiGeneratedConnectorResponseCopyWithImpl<$Res>
    implements $WhiteboardAiGeneratedConnectorResponseCopyWith<$Res> {
  _$WhiteboardAiGeneratedConnectorResponseCopyWithImpl(this._self, this._then);

  final WhiteboardAiGeneratedConnectorResponse _self;
  final $Res Function(WhiteboardAiGeneratedConnectorResponse) _then;

/// Create a copy of WhiteboardAiGeneratedConnectorResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceClientId = null,Object? targetClientId = null,Object? label = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceClientId: null == sourceClientId ? _self.sourceClientId : sourceClientId // ignore: cast_nullable_to_non_nullable
as String,targetClientId: null == targetClientId ? _self.targetClientId : targetClientId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardAiGeneratedConnectorResponse].
extension WhiteboardAiGeneratedConnectorResponsePatterns on WhiteboardAiGeneratedConnectorResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardAiGeneratedConnectorResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedConnectorResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardAiGeneratedConnectorResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedConnectorResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardAiGeneratedConnectorResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedConnectorResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceClientId,  String targetClientId,  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedConnectorResponse() when $default != null:
return $default(_that.id,_that.sourceClientId,_that.targetClientId,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceClientId,  String targetClientId,  String? label)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedConnectorResponse():
return $default(_that.id,_that.sourceClientId,_that.targetClientId,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceClientId,  String targetClientId,  String? label)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiGeneratedConnectorResponse() when $default != null:
return $default(_that.id,_that.sourceClientId,_that.targetClientId,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardAiGeneratedConnectorResponse implements WhiteboardAiGeneratedConnectorResponse {
  const _WhiteboardAiGeneratedConnectorResponse({required this.id, required this.sourceClientId, required this.targetClientId, this.label});
  factory _WhiteboardAiGeneratedConnectorResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardAiGeneratedConnectorResponseFromJson(json);

@override final  String id;
@override final  String sourceClientId;
@override final  String targetClientId;
@override final  String? label;

/// Create a copy of WhiteboardAiGeneratedConnectorResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardAiGeneratedConnectorResponseCopyWith<_WhiteboardAiGeneratedConnectorResponse> get copyWith => __$WhiteboardAiGeneratedConnectorResponseCopyWithImpl<_WhiteboardAiGeneratedConnectorResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardAiGeneratedConnectorResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardAiGeneratedConnectorResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceClientId, sourceClientId) || other.sourceClientId == sourceClientId)&&(identical(other.targetClientId, targetClientId) || other.targetClientId == targetClientId)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceClientId,targetClientId,label);

@override
String toString() {
  return 'WhiteboardAiGeneratedConnectorResponse(id: $id, sourceClientId: $sourceClientId, targetClientId: $targetClientId, label: $label)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardAiGeneratedConnectorResponseCopyWith<$Res> implements $WhiteboardAiGeneratedConnectorResponseCopyWith<$Res> {
  factory _$WhiteboardAiGeneratedConnectorResponseCopyWith(_WhiteboardAiGeneratedConnectorResponse value, $Res Function(_WhiteboardAiGeneratedConnectorResponse) _then) = __$WhiteboardAiGeneratedConnectorResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceClientId, String targetClientId, String? label
});




}
/// @nodoc
class __$WhiteboardAiGeneratedConnectorResponseCopyWithImpl<$Res>
    implements _$WhiteboardAiGeneratedConnectorResponseCopyWith<$Res> {
  __$WhiteboardAiGeneratedConnectorResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardAiGeneratedConnectorResponse _self;
  final $Res Function(_WhiteboardAiGeneratedConnectorResponse) _then;

/// Create a copy of WhiteboardAiGeneratedConnectorResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceClientId = null,Object? targetClientId = null,Object? label = freezed,}) {
  return _then(_WhiteboardAiGeneratedConnectorResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceClientId: null == sourceClientId ? _self.sourceClientId : sourceClientId // ignore: cast_nullable_to_non_nullable
as String,targetClientId: null == targetClientId ? _self.targetClientId : targetClientId // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WhiteboardAiOperationResponse {

 String get operationId; String get operationType; String get provider; bool get idempotentReplay; int get boardVersion; List<WhiteboardAiClusterResponse> get clusters; List<WhiteboardAiGeneratedObjectResponse> get objects; List<WhiteboardAiGeneratedConnectorResponse> get connectors; List<String> get warnings;
/// Create a copy of WhiteboardAiOperationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WhiteboardAiOperationResponseCopyWith<WhiteboardAiOperationResponse> get copyWith => _$WhiteboardAiOperationResponseCopyWithImpl<WhiteboardAiOperationResponse>(this as WhiteboardAiOperationResponse, _$identity);

  /// Serializes this WhiteboardAiOperationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WhiteboardAiOperationResponse&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.idempotentReplay, idempotentReplay) || other.idempotentReplay == idempotentReplay)&&(identical(other.boardVersion, boardVersion) || other.boardVersion == boardVersion)&&const DeepCollectionEquality().equals(other.clusters, clusters)&&const DeepCollectionEquality().equals(other.objects, objects)&&const DeepCollectionEquality().equals(other.connectors, connectors)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationId,operationType,provider,idempotentReplay,boardVersion,const DeepCollectionEquality().hash(clusters),const DeepCollectionEquality().hash(objects),const DeepCollectionEquality().hash(connectors),const DeepCollectionEquality().hash(warnings));

@override
String toString() {
  return 'WhiteboardAiOperationResponse(operationId: $operationId, operationType: $operationType, provider: $provider, idempotentReplay: $idempotentReplay, boardVersion: $boardVersion, clusters: $clusters, objects: $objects, connectors: $connectors, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class $WhiteboardAiOperationResponseCopyWith<$Res>  {
  factory $WhiteboardAiOperationResponseCopyWith(WhiteboardAiOperationResponse value, $Res Function(WhiteboardAiOperationResponse) _then) = _$WhiteboardAiOperationResponseCopyWithImpl;
@useResult
$Res call({
 String operationId, String operationType, String provider, bool idempotentReplay, int boardVersion, List<WhiteboardAiClusterResponse> clusters, List<WhiteboardAiGeneratedObjectResponse> objects, List<WhiteboardAiGeneratedConnectorResponse> connectors, List<String> warnings
});




}
/// @nodoc
class _$WhiteboardAiOperationResponseCopyWithImpl<$Res>
    implements $WhiteboardAiOperationResponseCopyWith<$Res> {
  _$WhiteboardAiOperationResponseCopyWithImpl(this._self, this._then);

  final WhiteboardAiOperationResponse _self;
  final $Res Function(WhiteboardAiOperationResponse) _then;

/// Create a copy of WhiteboardAiOperationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operationId = null,Object? operationType = null,Object? provider = null,Object? idempotentReplay = null,Object? boardVersion = null,Object? clusters = null,Object? objects = null,Object? connectors = null,Object? warnings = null,}) {
  return _then(_self.copyWith(
operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,idempotentReplay: null == idempotentReplay ? _self.idempotentReplay : idempotentReplay // ignore: cast_nullable_to_non_nullable
as bool,boardVersion: null == boardVersion ? _self.boardVersion : boardVersion // ignore: cast_nullable_to_non_nullable
as int,clusters: null == clusters ? _self.clusters : clusters // ignore: cast_nullable_to_non_nullable
as List<WhiteboardAiClusterResponse>,objects: null == objects ? _self.objects : objects // ignore: cast_nullable_to_non_nullable
as List<WhiteboardAiGeneratedObjectResponse>,connectors: null == connectors ? _self.connectors : connectors // ignore: cast_nullable_to_non_nullable
as List<WhiteboardAiGeneratedConnectorResponse>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [WhiteboardAiOperationResponse].
extension WhiteboardAiOperationResponsePatterns on WhiteboardAiOperationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WhiteboardAiOperationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WhiteboardAiOperationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WhiteboardAiOperationResponse value)  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiOperationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WhiteboardAiOperationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WhiteboardAiOperationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  int boardVersion,  List<WhiteboardAiClusterResponse> clusters,  List<WhiteboardAiGeneratedObjectResponse> objects,  List<WhiteboardAiGeneratedConnectorResponse> connectors,  List<String> warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WhiteboardAiOperationResponse() when $default != null:
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.boardVersion,_that.clusters,_that.objects,_that.connectors,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  int boardVersion,  List<WhiteboardAiClusterResponse> clusters,  List<WhiteboardAiGeneratedObjectResponse> objects,  List<WhiteboardAiGeneratedConnectorResponse> connectors,  List<String> warnings)  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiOperationResponse():
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.boardVersion,_that.clusters,_that.objects,_that.connectors,_that.warnings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  int boardVersion,  List<WhiteboardAiClusterResponse> clusters,  List<WhiteboardAiGeneratedObjectResponse> objects,  List<WhiteboardAiGeneratedConnectorResponse> connectors,  List<String> warnings)?  $default,) {final _that = this;
switch (_that) {
case _WhiteboardAiOperationResponse() when $default != null:
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.boardVersion,_that.clusters,_that.objects,_that.connectors,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WhiteboardAiOperationResponse implements WhiteboardAiOperationResponse {
  const _WhiteboardAiOperationResponse({required this.operationId, required this.operationType, required this.provider, required this.idempotentReplay, required this.boardVersion, required this.clusters, required this.objects, required this.connectors, required this.warnings});
  factory _WhiteboardAiOperationResponse.fromJson(Map<String, dynamic> json) => _$WhiteboardAiOperationResponseFromJson(json);

@override final  String operationId;
@override final  String operationType;
@override final  String provider;
@override final  bool idempotentReplay;
@override final  int boardVersion;
@override final  List<WhiteboardAiClusterResponse> clusters;
@override final  List<WhiteboardAiGeneratedObjectResponse> objects;
@override final  List<WhiteboardAiGeneratedConnectorResponse> connectors;
@override final  List<String> warnings;

/// Create a copy of WhiteboardAiOperationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WhiteboardAiOperationResponseCopyWith<_WhiteboardAiOperationResponse> get copyWith => __$WhiteboardAiOperationResponseCopyWithImpl<_WhiteboardAiOperationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WhiteboardAiOperationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WhiteboardAiOperationResponse&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.idempotentReplay, idempotentReplay) || other.idempotentReplay == idempotentReplay)&&(identical(other.boardVersion, boardVersion) || other.boardVersion == boardVersion)&&const DeepCollectionEquality().equals(other.clusters, clusters)&&const DeepCollectionEquality().equals(other.objects, objects)&&const DeepCollectionEquality().equals(other.connectors, connectors)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationId,operationType,provider,idempotentReplay,boardVersion,const DeepCollectionEquality().hash(clusters),const DeepCollectionEquality().hash(objects),const DeepCollectionEquality().hash(connectors),const DeepCollectionEquality().hash(warnings));

@override
String toString() {
  return 'WhiteboardAiOperationResponse(operationId: $operationId, operationType: $operationType, provider: $provider, idempotentReplay: $idempotentReplay, boardVersion: $boardVersion, clusters: $clusters, objects: $objects, connectors: $connectors, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$WhiteboardAiOperationResponseCopyWith<$Res> implements $WhiteboardAiOperationResponseCopyWith<$Res> {
  factory _$WhiteboardAiOperationResponseCopyWith(_WhiteboardAiOperationResponse value, $Res Function(_WhiteboardAiOperationResponse) _then) = __$WhiteboardAiOperationResponseCopyWithImpl;
@override @useResult
$Res call({
 String operationId, String operationType, String provider, bool idempotentReplay, int boardVersion, List<WhiteboardAiClusterResponse> clusters, List<WhiteboardAiGeneratedObjectResponse> objects, List<WhiteboardAiGeneratedConnectorResponse> connectors, List<String> warnings
});




}
/// @nodoc
class __$WhiteboardAiOperationResponseCopyWithImpl<$Res>
    implements _$WhiteboardAiOperationResponseCopyWith<$Res> {
  __$WhiteboardAiOperationResponseCopyWithImpl(this._self, this._then);

  final _WhiteboardAiOperationResponse _self;
  final $Res Function(_WhiteboardAiOperationResponse) _then;

/// Create a copy of WhiteboardAiOperationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operationId = null,Object? operationType = null,Object? provider = null,Object? idempotentReplay = null,Object? boardVersion = null,Object? clusters = null,Object? objects = null,Object? connectors = null,Object? warnings = null,}) {
  return _then(_WhiteboardAiOperationResponse(
operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,idempotentReplay: null == idempotentReplay ? _self.idempotentReplay : idempotentReplay // ignore: cast_nullable_to_non_nullable
as bool,boardVersion: null == boardVersion ? _self.boardVersion : boardVersion // ignore: cast_nullable_to_non_nullable
as int,clusters: null == clusters ? _self.clusters : clusters // ignore: cast_nullable_to_non_nullable
as List<WhiteboardAiClusterResponse>,objects: null == objects ? _self.objects : objects // ignore: cast_nullable_to_non_nullable
as List<WhiteboardAiGeneratedObjectResponse>,connectors: null == connectors ? _self.connectors : connectors // ignore: cast_nullable_to_non_nullable
as List<WhiteboardAiGeneratedConnectorResponse>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
