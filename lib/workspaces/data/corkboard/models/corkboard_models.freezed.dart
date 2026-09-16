// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'corkboard_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateCorkboardSectionPayload {

 String get name; int get position;
/// Create a copy of CreateCorkboardSectionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateCorkboardSectionPayloadCopyWith<CreateCorkboardSectionPayload> get copyWith => _$CreateCorkboardSectionPayloadCopyWithImpl<CreateCorkboardSectionPayload>(this as CreateCorkboardSectionPayload, _$identity);

  /// Serializes this CreateCorkboardSectionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateCorkboardSectionPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,position);

@override
String toString() {
  return 'CreateCorkboardSectionPayload(name: $name, position: $position)';
}


}

/// @nodoc
abstract mixin class $CreateCorkboardSectionPayloadCopyWith<$Res>  {
  factory $CreateCorkboardSectionPayloadCopyWith(CreateCorkboardSectionPayload value, $Res Function(CreateCorkboardSectionPayload) _then) = _$CreateCorkboardSectionPayloadCopyWithImpl;
@useResult
$Res call({
 String name, int position
});




}
/// @nodoc
class _$CreateCorkboardSectionPayloadCopyWithImpl<$Res>
    implements $CreateCorkboardSectionPayloadCopyWith<$Res> {
  _$CreateCorkboardSectionPayloadCopyWithImpl(this._self, this._then);

  final CreateCorkboardSectionPayload _self;
  final $Res Function(CreateCorkboardSectionPayload) _then;

/// Create a copy of CreateCorkboardSectionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? position = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateCorkboardSectionPayload].
extension CreateCorkboardSectionPayloadPatterns on CreateCorkboardSectionPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateCorkboardSectionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateCorkboardSectionPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateCorkboardSectionPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateCorkboardSectionPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateCorkboardSectionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateCorkboardSectionPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateCorkboardSectionPayload() when $default != null:
return $default(_that.name,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int position)  $default,) {final _that = this;
switch (_that) {
case _CreateCorkboardSectionPayload():
return $default(_that.name,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int position)?  $default,) {final _that = this;
switch (_that) {
case _CreateCorkboardSectionPayload() when $default != null:
return $default(_that.name,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateCorkboardSectionPayload implements CreateCorkboardSectionPayload {
  const _CreateCorkboardSectionPayload({required this.name, this.position = 0});
  factory _CreateCorkboardSectionPayload.fromJson(Map<String, dynamic> json) => _$CreateCorkboardSectionPayloadFromJson(json);

@override final  String name;
@override@JsonKey() final  int position;

/// Create a copy of CreateCorkboardSectionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCorkboardSectionPayloadCopyWith<_CreateCorkboardSectionPayload> get copyWith => __$CreateCorkboardSectionPayloadCopyWithImpl<_CreateCorkboardSectionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateCorkboardSectionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateCorkboardSectionPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,position);

@override
String toString() {
  return 'CreateCorkboardSectionPayload(name: $name, position: $position)';
}


}

/// @nodoc
abstract mixin class _$CreateCorkboardSectionPayloadCopyWith<$Res> implements $CreateCorkboardSectionPayloadCopyWith<$Res> {
  factory _$CreateCorkboardSectionPayloadCopyWith(_CreateCorkboardSectionPayload value, $Res Function(_CreateCorkboardSectionPayload) _then) = __$CreateCorkboardSectionPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, int position
});




}
/// @nodoc
class __$CreateCorkboardSectionPayloadCopyWithImpl<$Res>
    implements _$CreateCorkboardSectionPayloadCopyWith<$Res> {
  __$CreateCorkboardSectionPayloadCopyWithImpl(this._self, this._then);

  final _CreateCorkboardSectionPayload _self;
  final $Res Function(_CreateCorkboardSectionPayload) _then;

/// Create a copy of CreateCorkboardSectionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? position = null,}) {
  return _then(_CreateCorkboardSectionPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateCorkboardCardPayload {

 String get content; CorkboardCardColor get color; int get position; String? get sectionId;
/// Create a copy of CreateCorkboardCardPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateCorkboardCardPayloadCopyWith<CreateCorkboardCardPayload> get copyWith => _$CreateCorkboardCardPayloadCopyWithImpl<CreateCorkboardCardPayload>(this as CreateCorkboardCardPayload, _$identity);

  /// Serializes this CreateCorkboardCardPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateCorkboardCardPayload&&(identical(other.content, content) || other.content == content)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,color,position,sectionId);

@override
String toString() {
  return 'CreateCorkboardCardPayload(content: $content, color: $color, position: $position, sectionId: $sectionId)';
}


}

/// @nodoc
abstract mixin class $CreateCorkboardCardPayloadCopyWith<$Res>  {
  factory $CreateCorkboardCardPayloadCopyWith(CreateCorkboardCardPayload value, $Res Function(CreateCorkboardCardPayload) _then) = _$CreateCorkboardCardPayloadCopyWithImpl;
@useResult
$Res call({
 String content, CorkboardCardColor color, int position, String? sectionId
});




}
/// @nodoc
class _$CreateCorkboardCardPayloadCopyWithImpl<$Res>
    implements $CreateCorkboardCardPayloadCopyWith<$Res> {
  _$CreateCorkboardCardPayloadCopyWithImpl(this._self, this._then);

  final CreateCorkboardCardPayload _self;
  final $Res Function(CreateCorkboardCardPayload) _then;

/// Create a copy of CreateCorkboardCardPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? color = null,Object? position = null,Object? sectionId = freezed,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as CorkboardCardColor,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateCorkboardCardPayload].
extension CreateCorkboardCardPayloadPatterns on CreateCorkboardCardPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateCorkboardCardPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateCorkboardCardPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateCorkboardCardPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateCorkboardCardPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateCorkboardCardPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateCorkboardCardPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  CorkboardCardColor color,  int position,  String? sectionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateCorkboardCardPayload() when $default != null:
return $default(_that.content,_that.color,_that.position,_that.sectionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  CorkboardCardColor color,  int position,  String? sectionId)  $default,) {final _that = this;
switch (_that) {
case _CreateCorkboardCardPayload():
return $default(_that.content,_that.color,_that.position,_that.sectionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  CorkboardCardColor color,  int position,  String? sectionId)?  $default,) {final _that = this;
switch (_that) {
case _CreateCorkboardCardPayload() when $default != null:
return $default(_that.content,_that.color,_that.position,_that.sectionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateCorkboardCardPayload implements CreateCorkboardCardPayload {
  const _CreateCorkboardCardPayload({required this.content, required this.color, this.position = 0, this.sectionId});
  factory _CreateCorkboardCardPayload.fromJson(Map<String, dynamic> json) => _$CreateCorkboardCardPayloadFromJson(json);

@override final  String content;
@override final  CorkboardCardColor color;
@override@JsonKey() final  int position;
@override final  String? sectionId;

/// Create a copy of CreateCorkboardCardPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCorkboardCardPayloadCopyWith<_CreateCorkboardCardPayload> get copyWith => __$CreateCorkboardCardPayloadCopyWithImpl<_CreateCorkboardCardPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateCorkboardCardPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateCorkboardCardPayload&&(identical(other.content, content) || other.content == content)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,color,position,sectionId);

@override
String toString() {
  return 'CreateCorkboardCardPayload(content: $content, color: $color, position: $position, sectionId: $sectionId)';
}


}

/// @nodoc
abstract mixin class _$CreateCorkboardCardPayloadCopyWith<$Res> implements $CreateCorkboardCardPayloadCopyWith<$Res> {
  factory _$CreateCorkboardCardPayloadCopyWith(_CreateCorkboardCardPayload value, $Res Function(_CreateCorkboardCardPayload) _then) = __$CreateCorkboardCardPayloadCopyWithImpl;
@override @useResult
$Res call({
 String content, CorkboardCardColor color, int position, String? sectionId
});




}
/// @nodoc
class __$CreateCorkboardCardPayloadCopyWithImpl<$Res>
    implements _$CreateCorkboardCardPayloadCopyWith<$Res> {
  __$CreateCorkboardCardPayloadCopyWithImpl(this._self, this._then);

  final _CreateCorkboardCardPayload _self;
  final $Res Function(_CreateCorkboardCardPayload) _then;

/// Create a copy of CreateCorkboardCardPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? color = null,Object? position = null,Object? sectionId = freezed,}) {
  return _then(_CreateCorkboardCardPayload(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as CorkboardCardColor,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AttachCorkboardFilePayload {

 String get storageFileId;
/// Create a copy of AttachCorkboardFilePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachCorkboardFilePayloadCopyWith<AttachCorkboardFilePayload> get copyWith => _$AttachCorkboardFilePayloadCopyWithImpl<AttachCorkboardFilePayload>(this as AttachCorkboardFilePayload, _$identity);

  /// Serializes this AttachCorkboardFilePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachCorkboardFilePayload&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageFileId);

@override
String toString() {
  return 'AttachCorkboardFilePayload(storageFileId: $storageFileId)';
}


}

/// @nodoc
abstract mixin class $AttachCorkboardFilePayloadCopyWith<$Res>  {
  factory $AttachCorkboardFilePayloadCopyWith(AttachCorkboardFilePayload value, $Res Function(AttachCorkboardFilePayload) _then) = _$AttachCorkboardFilePayloadCopyWithImpl;
@useResult
$Res call({
 String storageFileId
});




}
/// @nodoc
class _$AttachCorkboardFilePayloadCopyWithImpl<$Res>
    implements $AttachCorkboardFilePayloadCopyWith<$Res> {
  _$AttachCorkboardFilePayloadCopyWithImpl(this._self, this._then);

  final AttachCorkboardFilePayload _self;
  final $Res Function(AttachCorkboardFilePayload) _then;

/// Create a copy of AttachCorkboardFilePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storageFileId = null,}) {
  return _then(_self.copyWith(
storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachCorkboardFilePayload].
extension AttachCorkboardFilePayloadPatterns on AttachCorkboardFilePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachCorkboardFilePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachCorkboardFilePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachCorkboardFilePayload value)  $default,){
final _that = this;
switch (_that) {
case _AttachCorkboardFilePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachCorkboardFilePayload value)?  $default,){
final _that = this;
switch (_that) {
case _AttachCorkboardFilePayload() when $default != null:
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
case _AttachCorkboardFilePayload() when $default != null:
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
case _AttachCorkboardFilePayload():
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
case _AttachCorkboardFilePayload() when $default != null:
return $default(_that.storageFileId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttachCorkboardFilePayload implements AttachCorkboardFilePayload {
  const _AttachCorkboardFilePayload({required this.storageFileId});
  factory _AttachCorkboardFilePayload.fromJson(Map<String, dynamic> json) => _$AttachCorkboardFilePayloadFromJson(json);

@override final  String storageFileId;

/// Create a copy of AttachCorkboardFilePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachCorkboardFilePayloadCopyWith<_AttachCorkboardFilePayload> get copyWith => __$AttachCorkboardFilePayloadCopyWithImpl<_AttachCorkboardFilePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachCorkboardFilePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachCorkboardFilePayload&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storageFileId);

@override
String toString() {
  return 'AttachCorkboardFilePayload(storageFileId: $storageFileId)';
}


}

/// @nodoc
abstract mixin class _$AttachCorkboardFilePayloadCopyWith<$Res> implements $AttachCorkboardFilePayloadCopyWith<$Res> {
  factory _$AttachCorkboardFilePayloadCopyWith(_AttachCorkboardFilePayload value, $Res Function(_AttachCorkboardFilePayload) _then) = __$AttachCorkboardFilePayloadCopyWithImpl;
@override @useResult
$Res call({
 String storageFileId
});




}
/// @nodoc
class __$AttachCorkboardFilePayloadCopyWithImpl<$Res>
    implements _$AttachCorkboardFilePayloadCopyWith<$Res> {
  __$AttachCorkboardFilePayloadCopyWithImpl(this._self, this._then);

  final _AttachCorkboardFilePayload _self;
  final $Res Function(_AttachCorkboardFilePayload) _then;

/// Create a copy of AttachCorkboardFilePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storageFileId = null,}) {
  return _then(_AttachCorkboardFilePayload(
storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CorkboardSectionResponse {

 String get id; String get name; int get position; int get version;
/// Create a copy of CorkboardSectionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorkboardSectionResponseCopyWith<CorkboardSectionResponse> get copyWith => _$CorkboardSectionResponseCopyWithImpl<CorkboardSectionResponse>(this as CorkboardSectionResponse, _$identity);

  /// Serializes this CorkboardSectionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorkboardSectionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position,version);

@override
String toString() {
  return 'CorkboardSectionResponse(id: $id, name: $name, position: $position, version: $version)';
}


}

/// @nodoc
abstract mixin class $CorkboardSectionResponseCopyWith<$Res>  {
  factory $CorkboardSectionResponseCopyWith(CorkboardSectionResponse value, $Res Function(CorkboardSectionResponse) _then) = _$CorkboardSectionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, int position, int version
});




}
/// @nodoc
class _$CorkboardSectionResponseCopyWithImpl<$Res>
    implements $CorkboardSectionResponseCopyWith<$Res> {
  _$CorkboardSectionResponseCopyWithImpl(this._self, this._then);

  final CorkboardSectionResponse _self;
  final $Res Function(CorkboardSectionResponse) _then;

/// Create a copy of CorkboardSectionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? position = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CorkboardSectionResponse].
extension CorkboardSectionResponsePatterns on CorkboardSectionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorkboardSectionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorkboardSectionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorkboardSectionResponse value)  $default,){
final _that = this;
switch (_that) {
case _CorkboardSectionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorkboardSectionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CorkboardSectionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int position,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorkboardSectionResponse() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int position,  int version)  $default,) {final _that = this;
switch (_that) {
case _CorkboardSectionResponse():
return $default(_that.id,_that.name,_that.position,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int position,  int version)?  $default,) {final _that = this;
switch (_that) {
case _CorkboardSectionResponse() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CorkboardSectionResponse implements CorkboardSectionResponse {
  const _CorkboardSectionResponse({required this.id, required this.name, required this.position, required this.version});
  factory _CorkboardSectionResponse.fromJson(Map<String, dynamic> json) => _$CorkboardSectionResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  int position;
@override final  int version;

/// Create a copy of CorkboardSectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorkboardSectionResponseCopyWith<_CorkboardSectionResponse> get copyWith => __$CorkboardSectionResponseCopyWithImpl<_CorkboardSectionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorkboardSectionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorkboardSectionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position,version);

@override
String toString() {
  return 'CorkboardSectionResponse(id: $id, name: $name, position: $position, version: $version)';
}


}

/// @nodoc
abstract mixin class _$CorkboardSectionResponseCopyWith<$Res> implements $CorkboardSectionResponseCopyWith<$Res> {
  factory _$CorkboardSectionResponseCopyWith(_CorkboardSectionResponse value, $Res Function(_CorkboardSectionResponse) _then) = __$CorkboardSectionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int position, int version
});




}
/// @nodoc
class __$CorkboardSectionResponseCopyWithImpl<$Res>
    implements _$CorkboardSectionResponseCopyWith<$Res> {
  __$CorkboardSectionResponseCopyWithImpl(this._self, this._then);

  final _CorkboardSectionResponse _self;
  final $Res Function(_CorkboardSectionResponse) _then;

/// Create a copy of CorkboardSectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? position = null,Object? version = null,}) {
  return _then(_CorkboardSectionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CorkboardAttachmentResponse {

 String get id; String get storageFileId; DateTime get attachedAtUtc;
/// Create a copy of CorkboardAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorkboardAttachmentResponseCopyWith<CorkboardAttachmentResponse> get copyWith => _$CorkboardAttachmentResponseCopyWithImpl<CorkboardAttachmentResponse>(this as CorkboardAttachmentResponse, _$identity);

  /// Serializes this CorkboardAttachmentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorkboardAttachmentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.attachedAtUtc, attachedAtUtc) || other.attachedAtUtc == attachedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storageFileId,attachedAtUtc);

@override
String toString() {
  return 'CorkboardAttachmentResponse(id: $id, storageFileId: $storageFileId, attachedAtUtc: $attachedAtUtc)';
}


}

/// @nodoc
abstract mixin class $CorkboardAttachmentResponseCopyWith<$Res>  {
  factory $CorkboardAttachmentResponseCopyWith(CorkboardAttachmentResponse value, $Res Function(CorkboardAttachmentResponse) _then) = _$CorkboardAttachmentResponseCopyWithImpl;
@useResult
$Res call({
 String id, String storageFileId, DateTime attachedAtUtc
});




}
/// @nodoc
class _$CorkboardAttachmentResponseCopyWithImpl<$Res>
    implements $CorkboardAttachmentResponseCopyWith<$Res> {
  _$CorkboardAttachmentResponseCopyWithImpl(this._self, this._then);

  final CorkboardAttachmentResponse _self;
  final $Res Function(CorkboardAttachmentResponse) _then;

/// Create a copy of CorkboardAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storageFileId = null,Object? attachedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,attachedAtUtc: null == attachedAtUtc ? _self.attachedAtUtc : attachedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CorkboardAttachmentResponse].
extension CorkboardAttachmentResponsePatterns on CorkboardAttachmentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorkboardAttachmentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorkboardAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorkboardAttachmentResponse value)  $default,){
final _that = this;
switch (_that) {
case _CorkboardAttachmentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorkboardAttachmentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CorkboardAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storageFileId,  DateTime attachedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorkboardAttachmentResponse() when $default != null:
return $default(_that.id,_that.storageFileId,_that.attachedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storageFileId,  DateTime attachedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _CorkboardAttachmentResponse():
return $default(_that.id,_that.storageFileId,_that.attachedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storageFileId,  DateTime attachedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _CorkboardAttachmentResponse() when $default != null:
return $default(_that.id,_that.storageFileId,_that.attachedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CorkboardAttachmentResponse implements CorkboardAttachmentResponse {
  const _CorkboardAttachmentResponse({required this.id, required this.storageFileId, required this.attachedAtUtc});
  factory _CorkboardAttachmentResponse.fromJson(Map<String, dynamic> json) => _$CorkboardAttachmentResponseFromJson(json);

@override final  String id;
@override final  String storageFileId;
@override final  DateTime attachedAtUtc;

/// Create a copy of CorkboardAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorkboardAttachmentResponseCopyWith<_CorkboardAttachmentResponse> get copyWith => __$CorkboardAttachmentResponseCopyWithImpl<_CorkboardAttachmentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorkboardAttachmentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorkboardAttachmentResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId)&&(identical(other.attachedAtUtc, attachedAtUtc) || other.attachedAtUtc == attachedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storageFileId,attachedAtUtc);

@override
String toString() {
  return 'CorkboardAttachmentResponse(id: $id, storageFileId: $storageFileId, attachedAtUtc: $attachedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$CorkboardAttachmentResponseCopyWith<$Res> implements $CorkboardAttachmentResponseCopyWith<$Res> {
  factory _$CorkboardAttachmentResponseCopyWith(_CorkboardAttachmentResponse value, $Res Function(_CorkboardAttachmentResponse) _then) = __$CorkboardAttachmentResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String storageFileId, DateTime attachedAtUtc
});




}
/// @nodoc
class __$CorkboardAttachmentResponseCopyWithImpl<$Res>
    implements _$CorkboardAttachmentResponseCopyWith<$Res> {
  __$CorkboardAttachmentResponseCopyWithImpl(this._self, this._then);

  final _CorkboardAttachmentResponse _self;
  final $Res Function(_CorkboardAttachmentResponse) _then;

/// Create a copy of CorkboardAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storageFileId = null,Object? attachedAtUtc = null,}) {
  return _then(_CorkboardAttachmentResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storageFileId: null == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String,attachedAtUtc: null == attachedAtUtc ? _self.attachedAtUtc : attachedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CorkboardCardResponse {

 String get id; String? get sectionId; String get content; CorkboardCardColor get color; int get position; bool get isPinned; String? get conversationId; String? get convertedToTaskId; int get version; List<CorkboardAttachmentResponse> get attachments;
/// Create a copy of CorkboardCardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorkboardCardResponseCopyWith<CorkboardCardResponse> get copyWith => _$CorkboardCardResponseCopyWithImpl<CorkboardCardResponse>(this as CorkboardCardResponse, _$identity);

  /// Serializes this CorkboardCardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorkboardCardResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.content, content) || other.content == content)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.convertedToTaskId, convertedToTaskId) || other.convertedToTaskId == convertedToTaskId)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.attachments, attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sectionId,content,color,position,isPinned,conversationId,convertedToTaskId,version,const DeepCollectionEquality().hash(attachments));

@override
String toString() {
  return 'CorkboardCardResponse(id: $id, sectionId: $sectionId, content: $content, color: $color, position: $position, isPinned: $isPinned, conversationId: $conversationId, convertedToTaskId: $convertedToTaskId, version: $version, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class $CorkboardCardResponseCopyWith<$Res>  {
  factory $CorkboardCardResponseCopyWith(CorkboardCardResponse value, $Res Function(CorkboardCardResponse) _then) = _$CorkboardCardResponseCopyWithImpl;
@useResult
$Res call({
 String id, String? sectionId, String content, CorkboardCardColor color, int position, bool isPinned, String? conversationId, String? convertedToTaskId, int version, List<CorkboardAttachmentResponse> attachments
});




}
/// @nodoc
class _$CorkboardCardResponseCopyWithImpl<$Res>
    implements $CorkboardCardResponseCopyWith<$Res> {
  _$CorkboardCardResponseCopyWithImpl(this._self, this._then);

  final CorkboardCardResponse _self;
  final $Res Function(CorkboardCardResponse) _then;

/// Create a copy of CorkboardCardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sectionId = freezed,Object? content = null,Object? color = null,Object? position = null,Object? isPinned = null,Object? conversationId = freezed,Object? convertedToTaskId = freezed,Object? version = null,Object? attachments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as CorkboardCardColor,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,convertedToTaskId: freezed == convertedToTaskId ? _self.convertedToTaskId : convertedToTaskId // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<CorkboardAttachmentResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [CorkboardCardResponse].
extension CorkboardCardResponsePatterns on CorkboardCardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorkboardCardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorkboardCardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorkboardCardResponse value)  $default,){
final _that = this;
switch (_that) {
case _CorkboardCardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorkboardCardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CorkboardCardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? sectionId,  String content,  CorkboardCardColor color,  int position,  bool isPinned,  String? conversationId,  String? convertedToTaskId,  int version,  List<CorkboardAttachmentResponse> attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorkboardCardResponse() when $default != null:
return $default(_that.id,_that.sectionId,_that.content,_that.color,_that.position,_that.isPinned,_that.conversationId,_that.convertedToTaskId,_that.version,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? sectionId,  String content,  CorkboardCardColor color,  int position,  bool isPinned,  String? conversationId,  String? convertedToTaskId,  int version,  List<CorkboardAttachmentResponse> attachments)  $default,) {final _that = this;
switch (_that) {
case _CorkboardCardResponse():
return $default(_that.id,_that.sectionId,_that.content,_that.color,_that.position,_that.isPinned,_that.conversationId,_that.convertedToTaskId,_that.version,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? sectionId,  String content,  CorkboardCardColor color,  int position,  bool isPinned,  String? conversationId,  String? convertedToTaskId,  int version,  List<CorkboardAttachmentResponse> attachments)?  $default,) {final _that = this;
switch (_that) {
case _CorkboardCardResponse() when $default != null:
return $default(_that.id,_that.sectionId,_that.content,_that.color,_that.position,_that.isPinned,_that.conversationId,_that.convertedToTaskId,_that.version,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CorkboardCardResponse implements CorkboardCardResponse {
  const _CorkboardCardResponse({required this.id, this.sectionId, required this.content, required this.color, required this.position, required this.isPinned, this.conversationId, this.convertedToTaskId, required this.version, required this.attachments});
  factory _CorkboardCardResponse.fromJson(Map<String, dynamic> json) => _$CorkboardCardResponseFromJson(json);

@override final  String id;
@override final  String? sectionId;
@override final  String content;
@override final  CorkboardCardColor color;
@override final  int position;
@override final  bool isPinned;
@override final  String? conversationId;
@override final  String? convertedToTaskId;
@override final  int version;
@override final  List<CorkboardAttachmentResponse> attachments;

/// Create a copy of CorkboardCardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorkboardCardResponseCopyWith<_CorkboardCardResponse> get copyWith => __$CorkboardCardResponseCopyWithImpl<_CorkboardCardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorkboardCardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorkboardCardResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.content, content) || other.content == content)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.convertedToTaskId, convertedToTaskId) || other.convertedToTaskId == convertedToTaskId)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.attachments, attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sectionId,content,color,position,isPinned,conversationId,convertedToTaskId,version,const DeepCollectionEquality().hash(attachments));

@override
String toString() {
  return 'CorkboardCardResponse(id: $id, sectionId: $sectionId, content: $content, color: $color, position: $position, isPinned: $isPinned, conversationId: $conversationId, convertedToTaskId: $convertedToTaskId, version: $version, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$CorkboardCardResponseCopyWith<$Res> implements $CorkboardCardResponseCopyWith<$Res> {
  factory _$CorkboardCardResponseCopyWith(_CorkboardCardResponse value, $Res Function(_CorkboardCardResponse) _then) = __$CorkboardCardResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String? sectionId, String content, CorkboardCardColor color, int position, bool isPinned, String? conversationId, String? convertedToTaskId, int version, List<CorkboardAttachmentResponse> attachments
});




}
/// @nodoc
class __$CorkboardCardResponseCopyWithImpl<$Res>
    implements _$CorkboardCardResponseCopyWith<$Res> {
  __$CorkboardCardResponseCopyWithImpl(this._self, this._then);

  final _CorkboardCardResponse _self;
  final $Res Function(_CorkboardCardResponse) _then;

/// Create a copy of CorkboardCardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sectionId = freezed,Object? content = null,Object? color = null,Object? position = null,Object? isPinned = null,Object? conversationId = freezed,Object? convertedToTaskId = freezed,Object? version = null,Object? attachments = null,}) {
  return _then(_CorkboardCardResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as CorkboardCardColor,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,convertedToTaskId: freezed == convertedToTaskId ? _self.convertedToTaskId : convertedToTaskId // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<CorkboardAttachmentResponse>,
  ));
}


}


/// @nodoc
mixin _$CorkboardAiClusterPayload {

 List<String>? get cardIds; String? get instruction;
/// Create a copy of CorkboardAiClusterPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorkboardAiClusterPayloadCopyWith<CorkboardAiClusterPayload> get copyWith => _$CorkboardAiClusterPayloadCopyWithImpl<CorkboardAiClusterPayload>(this as CorkboardAiClusterPayload, _$identity);

  /// Serializes this CorkboardAiClusterPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorkboardAiClusterPayload&&const DeepCollectionEquality().equals(other.cardIds, cardIds)&&(identical(other.instruction, instruction) || other.instruction == instruction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cardIds),instruction);

@override
String toString() {
  return 'CorkboardAiClusterPayload(cardIds: $cardIds, instruction: $instruction)';
}


}

/// @nodoc
abstract mixin class $CorkboardAiClusterPayloadCopyWith<$Res>  {
  factory $CorkboardAiClusterPayloadCopyWith(CorkboardAiClusterPayload value, $Res Function(CorkboardAiClusterPayload) _then) = _$CorkboardAiClusterPayloadCopyWithImpl;
@useResult
$Res call({
 List<String>? cardIds, String? instruction
});




}
/// @nodoc
class _$CorkboardAiClusterPayloadCopyWithImpl<$Res>
    implements $CorkboardAiClusterPayloadCopyWith<$Res> {
  _$CorkboardAiClusterPayloadCopyWithImpl(this._self, this._then);

  final CorkboardAiClusterPayload _self;
  final $Res Function(CorkboardAiClusterPayload) _then;

/// Create a copy of CorkboardAiClusterPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardIds = freezed,Object? instruction = freezed,}) {
  return _then(_self.copyWith(
cardIds: freezed == cardIds ? _self.cardIds : cardIds // ignore: cast_nullable_to_non_nullable
as List<String>?,instruction: freezed == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CorkboardAiClusterPayload].
extension CorkboardAiClusterPayloadPatterns on CorkboardAiClusterPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorkboardAiClusterPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorkboardAiClusterPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorkboardAiClusterPayload value)  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiClusterPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorkboardAiClusterPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiClusterPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String>? cardIds,  String? instruction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorkboardAiClusterPayload() when $default != null:
return $default(_that.cardIds,_that.instruction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String>? cardIds,  String? instruction)  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiClusterPayload():
return $default(_that.cardIds,_that.instruction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String>? cardIds,  String? instruction)?  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiClusterPayload() when $default != null:
return $default(_that.cardIds,_that.instruction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CorkboardAiClusterPayload implements CorkboardAiClusterPayload {
  const _CorkboardAiClusterPayload({this.cardIds, this.instruction});
  factory _CorkboardAiClusterPayload.fromJson(Map<String, dynamic> json) => _$CorkboardAiClusterPayloadFromJson(json);

@override final  List<String>? cardIds;
@override final  String? instruction;

/// Create a copy of CorkboardAiClusterPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorkboardAiClusterPayloadCopyWith<_CorkboardAiClusterPayload> get copyWith => __$CorkboardAiClusterPayloadCopyWithImpl<_CorkboardAiClusterPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorkboardAiClusterPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorkboardAiClusterPayload&&const DeepCollectionEquality().equals(other.cardIds, cardIds)&&(identical(other.instruction, instruction) || other.instruction == instruction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cardIds),instruction);

@override
String toString() {
  return 'CorkboardAiClusterPayload(cardIds: $cardIds, instruction: $instruction)';
}


}

/// @nodoc
abstract mixin class _$CorkboardAiClusterPayloadCopyWith<$Res> implements $CorkboardAiClusterPayloadCopyWith<$Res> {
  factory _$CorkboardAiClusterPayloadCopyWith(_CorkboardAiClusterPayload value, $Res Function(_CorkboardAiClusterPayload) _then) = __$CorkboardAiClusterPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String>? cardIds, String? instruction
});




}
/// @nodoc
class __$CorkboardAiClusterPayloadCopyWithImpl<$Res>
    implements _$CorkboardAiClusterPayloadCopyWith<$Res> {
  __$CorkboardAiClusterPayloadCopyWithImpl(this._self, this._then);

  final _CorkboardAiClusterPayload _self;
  final $Res Function(_CorkboardAiClusterPayload) _then;

/// Create a copy of CorkboardAiClusterPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardIds = freezed,Object? instruction = freezed,}) {
  return _then(_CorkboardAiClusterPayload(
cardIds: freezed == cardIds ? _self.cardIds : cardIds // ignore: cast_nullable_to_non_nullable
as List<String>?,instruction: freezed == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CorkboardAiSummarizeToWikiPayload {

 String? get sectionId;
/// Create a copy of CorkboardAiSummarizeToWikiPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorkboardAiSummarizeToWikiPayloadCopyWith<CorkboardAiSummarizeToWikiPayload> get copyWith => _$CorkboardAiSummarizeToWikiPayloadCopyWithImpl<CorkboardAiSummarizeToWikiPayload>(this as CorkboardAiSummarizeToWikiPayload, _$identity);

  /// Serializes this CorkboardAiSummarizeToWikiPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorkboardAiSummarizeToWikiPayload&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sectionId);

@override
String toString() {
  return 'CorkboardAiSummarizeToWikiPayload(sectionId: $sectionId)';
}


}

/// @nodoc
abstract mixin class $CorkboardAiSummarizeToWikiPayloadCopyWith<$Res>  {
  factory $CorkboardAiSummarizeToWikiPayloadCopyWith(CorkboardAiSummarizeToWikiPayload value, $Res Function(CorkboardAiSummarizeToWikiPayload) _then) = _$CorkboardAiSummarizeToWikiPayloadCopyWithImpl;
@useResult
$Res call({
 String? sectionId
});




}
/// @nodoc
class _$CorkboardAiSummarizeToWikiPayloadCopyWithImpl<$Res>
    implements $CorkboardAiSummarizeToWikiPayloadCopyWith<$Res> {
  _$CorkboardAiSummarizeToWikiPayloadCopyWithImpl(this._self, this._then);

  final CorkboardAiSummarizeToWikiPayload _self;
  final $Res Function(CorkboardAiSummarizeToWikiPayload) _then;

/// Create a copy of CorkboardAiSummarizeToWikiPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sectionId = freezed,}) {
  return _then(_self.copyWith(
sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CorkboardAiSummarizeToWikiPayload].
extension CorkboardAiSummarizeToWikiPayloadPatterns on CorkboardAiSummarizeToWikiPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorkboardAiSummarizeToWikiPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorkboardAiSummarizeToWikiPayload value)  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorkboardAiSummarizeToWikiPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sectionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiPayload() when $default != null:
return $default(_that.sectionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sectionId)  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiPayload():
return $default(_that.sectionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sectionId)?  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiPayload() when $default != null:
return $default(_that.sectionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CorkboardAiSummarizeToWikiPayload implements CorkboardAiSummarizeToWikiPayload {
  const _CorkboardAiSummarizeToWikiPayload({this.sectionId});
  factory _CorkboardAiSummarizeToWikiPayload.fromJson(Map<String, dynamic> json) => _$CorkboardAiSummarizeToWikiPayloadFromJson(json);

@override final  String? sectionId;

/// Create a copy of CorkboardAiSummarizeToWikiPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorkboardAiSummarizeToWikiPayloadCopyWith<_CorkboardAiSummarizeToWikiPayload> get copyWith => __$CorkboardAiSummarizeToWikiPayloadCopyWithImpl<_CorkboardAiSummarizeToWikiPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorkboardAiSummarizeToWikiPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorkboardAiSummarizeToWikiPayload&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sectionId);

@override
String toString() {
  return 'CorkboardAiSummarizeToWikiPayload(sectionId: $sectionId)';
}


}

/// @nodoc
abstract mixin class _$CorkboardAiSummarizeToWikiPayloadCopyWith<$Res> implements $CorkboardAiSummarizeToWikiPayloadCopyWith<$Res> {
  factory _$CorkboardAiSummarizeToWikiPayloadCopyWith(_CorkboardAiSummarizeToWikiPayload value, $Res Function(_CorkboardAiSummarizeToWikiPayload) _then) = __$CorkboardAiSummarizeToWikiPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? sectionId
});




}
/// @nodoc
class __$CorkboardAiSummarizeToWikiPayloadCopyWithImpl<$Res>
    implements _$CorkboardAiSummarizeToWikiPayloadCopyWith<$Res> {
  __$CorkboardAiSummarizeToWikiPayloadCopyWithImpl(this._self, this._then);

  final _CorkboardAiSummarizeToWikiPayload _self;
  final $Res Function(_CorkboardAiSummarizeToWikiPayload) _then;

/// Create a copy of CorkboardAiSummarizeToWikiPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sectionId = freezed,}) {
  return _then(_CorkboardAiSummarizeToWikiPayload(
sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CorkboardAiClusterGroupResponse {

 String get sectionId; String get name; List<String> get cardIds;
/// Create a copy of CorkboardAiClusterGroupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorkboardAiClusterGroupResponseCopyWith<CorkboardAiClusterGroupResponse> get copyWith => _$CorkboardAiClusterGroupResponseCopyWithImpl<CorkboardAiClusterGroupResponse>(this as CorkboardAiClusterGroupResponse, _$identity);

  /// Serializes this CorkboardAiClusterGroupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorkboardAiClusterGroupResponse&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.cardIds, cardIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sectionId,name,const DeepCollectionEquality().hash(cardIds));

@override
String toString() {
  return 'CorkboardAiClusterGroupResponse(sectionId: $sectionId, name: $name, cardIds: $cardIds)';
}


}

/// @nodoc
abstract mixin class $CorkboardAiClusterGroupResponseCopyWith<$Res>  {
  factory $CorkboardAiClusterGroupResponseCopyWith(CorkboardAiClusterGroupResponse value, $Res Function(CorkboardAiClusterGroupResponse) _then) = _$CorkboardAiClusterGroupResponseCopyWithImpl;
@useResult
$Res call({
 String sectionId, String name, List<String> cardIds
});




}
/// @nodoc
class _$CorkboardAiClusterGroupResponseCopyWithImpl<$Res>
    implements $CorkboardAiClusterGroupResponseCopyWith<$Res> {
  _$CorkboardAiClusterGroupResponseCopyWithImpl(this._self, this._then);

  final CorkboardAiClusterGroupResponse _self;
  final $Res Function(CorkboardAiClusterGroupResponse) _then;

/// Create a copy of CorkboardAiClusterGroupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sectionId = null,Object? name = null,Object? cardIds = null,}) {
  return _then(_self.copyWith(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cardIds: null == cardIds ? _self.cardIds : cardIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CorkboardAiClusterGroupResponse].
extension CorkboardAiClusterGroupResponsePatterns on CorkboardAiClusterGroupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorkboardAiClusterGroupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorkboardAiClusterGroupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorkboardAiClusterGroupResponse value)  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiClusterGroupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorkboardAiClusterGroupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiClusterGroupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sectionId,  String name,  List<String> cardIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorkboardAiClusterGroupResponse() when $default != null:
return $default(_that.sectionId,_that.name,_that.cardIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sectionId,  String name,  List<String> cardIds)  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiClusterGroupResponse():
return $default(_that.sectionId,_that.name,_that.cardIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sectionId,  String name,  List<String> cardIds)?  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiClusterGroupResponse() when $default != null:
return $default(_that.sectionId,_that.name,_that.cardIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CorkboardAiClusterGroupResponse implements CorkboardAiClusterGroupResponse {
  const _CorkboardAiClusterGroupResponse({required this.sectionId, required this.name, required this.cardIds});
  factory _CorkboardAiClusterGroupResponse.fromJson(Map<String, dynamic> json) => _$CorkboardAiClusterGroupResponseFromJson(json);

@override final  String sectionId;
@override final  String name;
@override final  List<String> cardIds;

/// Create a copy of CorkboardAiClusterGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorkboardAiClusterGroupResponseCopyWith<_CorkboardAiClusterGroupResponse> get copyWith => __$CorkboardAiClusterGroupResponseCopyWithImpl<_CorkboardAiClusterGroupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorkboardAiClusterGroupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorkboardAiClusterGroupResponse&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.cardIds, cardIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sectionId,name,const DeepCollectionEquality().hash(cardIds));

@override
String toString() {
  return 'CorkboardAiClusterGroupResponse(sectionId: $sectionId, name: $name, cardIds: $cardIds)';
}


}

/// @nodoc
abstract mixin class _$CorkboardAiClusterGroupResponseCopyWith<$Res> implements $CorkboardAiClusterGroupResponseCopyWith<$Res> {
  factory _$CorkboardAiClusterGroupResponseCopyWith(_CorkboardAiClusterGroupResponse value, $Res Function(_CorkboardAiClusterGroupResponse) _then) = __$CorkboardAiClusterGroupResponseCopyWithImpl;
@override @useResult
$Res call({
 String sectionId, String name, List<String> cardIds
});




}
/// @nodoc
class __$CorkboardAiClusterGroupResponseCopyWithImpl<$Res>
    implements _$CorkboardAiClusterGroupResponseCopyWith<$Res> {
  __$CorkboardAiClusterGroupResponseCopyWithImpl(this._self, this._then);

  final _CorkboardAiClusterGroupResponse _self;
  final $Res Function(_CorkboardAiClusterGroupResponse) _then;

/// Create a copy of CorkboardAiClusterGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sectionId = null,Object? name = null,Object? cardIds = null,}) {
  return _then(_CorkboardAiClusterGroupResponse(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cardIds: null == cardIds ? _self.cardIds : cardIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$CorkboardAiClusterResponse {

 String get operationId; String get operationType; String get provider; bool get idempotentReplay; List<CorkboardAiClusterGroupResponse> get groups;
/// Create a copy of CorkboardAiClusterResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorkboardAiClusterResponseCopyWith<CorkboardAiClusterResponse> get copyWith => _$CorkboardAiClusterResponseCopyWithImpl<CorkboardAiClusterResponse>(this as CorkboardAiClusterResponse, _$identity);

  /// Serializes this CorkboardAiClusterResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorkboardAiClusterResponse&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.idempotentReplay, idempotentReplay) || other.idempotentReplay == idempotentReplay)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationId,operationType,provider,idempotentReplay,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'CorkboardAiClusterResponse(operationId: $operationId, operationType: $operationType, provider: $provider, idempotentReplay: $idempotentReplay, groups: $groups)';
}


}

/// @nodoc
abstract mixin class $CorkboardAiClusterResponseCopyWith<$Res>  {
  factory $CorkboardAiClusterResponseCopyWith(CorkboardAiClusterResponse value, $Res Function(CorkboardAiClusterResponse) _then) = _$CorkboardAiClusterResponseCopyWithImpl;
@useResult
$Res call({
 String operationId, String operationType, String provider, bool idempotentReplay, List<CorkboardAiClusterGroupResponse> groups
});




}
/// @nodoc
class _$CorkboardAiClusterResponseCopyWithImpl<$Res>
    implements $CorkboardAiClusterResponseCopyWith<$Res> {
  _$CorkboardAiClusterResponseCopyWithImpl(this._self, this._then);

  final CorkboardAiClusterResponse _self;
  final $Res Function(CorkboardAiClusterResponse) _then;

/// Create a copy of CorkboardAiClusterResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operationId = null,Object? operationType = null,Object? provider = null,Object? idempotentReplay = null,Object? groups = null,}) {
  return _then(_self.copyWith(
operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,idempotentReplay: null == idempotentReplay ? _self.idempotentReplay : idempotentReplay // ignore: cast_nullable_to_non_nullable
as bool,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<CorkboardAiClusterGroupResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [CorkboardAiClusterResponse].
extension CorkboardAiClusterResponsePatterns on CorkboardAiClusterResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorkboardAiClusterResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorkboardAiClusterResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorkboardAiClusterResponse value)  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiClusterResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorkboardAiClusterResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiClusterResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  List<CorkboardAiClusterGroupResponse> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorkboardAiClusterResponse() when $default != null:
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  List<CorkboardAiClusterGroupResponse> groups)  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiClusterResponse():
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  List<CorkboardAiClusterGroupResponse> groups)?  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiClusterResponse() when $default != null:
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.groups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CorkboardAiClusterResponse implements CorkboardAiClusterResponse {
  const _CorkboardAiClusterResponse({required this.operationId, required this.operationType, required this.provider, required this.idempotentReplay, required this.groups});
  factory _CorkboardAiClusterResponse.fromJson(Map<String, dynamic> json) => _$CorkboardAiClusterResponseFromJson(json);

@override final  String operationId;
@override final  String operationType;
@override final  String provider;
@override final  bool idempotentReplay;
@override final  List<CorkboardAiClusterGroupResponse> groups;

/// Create a copy of CorkboardAiClusterResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorkboardAiClusterResponseCopyWith<_CorkboardAiClusterResponse> get copyWith => __$CorkboardAiClusterResponseCopyWithImpl<_CorkboardAiClusterResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorkboardAiClusterResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorkboardAiClusterResponse&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.idempotentReplay, idempotentReplay) || other.idempotentReplay == idempotentReplay)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationId,operationType,provider,idempotentReplay,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'CorkboardAiClusterResponse(operationId: $operationId, operationType: $operationType, provider: $provider, idempotentReplay: $idempotentReplay, groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$CorkboardAiClusterResponseCopyWith<$Res> implements $CorkboardAiClusterResponseCopyWith<$Res> {
  factory _$CorkboardAiClusterResponseCopyWith(_CorkboardAiClusterResponse value, $Res Function(_CorkboardAiClusterResponse) _then) = __$CorkboardAiClusterResponseCopyWithImpl;
@override @useResult
$Res call({
 String operationId, String operationType, String provider, bool idempotentReplay, List<CorkboardAiClusterGroupResponse> groups
});




}
/// @nodoc
class __$CorkboardAiClusterResponseCopyWithImpl<$Res>
    implements _$CorkboardAiClusterResponseCopyWith<$Res> {
  __$CorkboardAiClusterResponseCopyWithImpl(this._self, this._then);

  final _CorkboardAiClusterResponse _self;
  final $Res Function(_CorkboardAiClusterResponse) _then;

/// Create a copy of CorkboardAiClusterResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operationId = null,Object? operationType = null,Object? provider = null,Object? idempotentReplay = null,Object? groups = null,}) {
  return _then(_CorkboardAiClusterResponse(
operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,idempotentReplay: null == idempotentReplay ? _self.idempotentReplay : idempotentReplay // ignore: cast_nullable_to_non_nullable
as bool,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<CorkboardAiClusterGroupResponse>,
  ));
}


}


/// @nodoc
mixin _$CorkboardAiSummarizeToWikiResponse {

 String get operationId; String get operationType; String get provider; bool get idempotentReplay; WikiPageResponse get wikiPage;
/// Create a copy of CorkboardAiSummarizeToWikiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorkboardAiSummarizeToWikiResponseCopyWith<CorkboardAiSummarizeToWikiResponse> get copyWith => _$CorkboardAiSummarizeToWikiResponseCopyWithImpl<CorkboardAiSummarizeToWikiResponse>(this as CorkboardAiSummarizeToWikiResponse, _$identity);

  /// Serializes this CorkboardAiSummarizeToWikiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorkboardAiSummarizeToWikiResponse&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.idempotentReplay, idempotentReplay) || other.idempotentReplay == idempotentReplay)&&(identical(other.wikiPage, wikiPage) || other.wikiPage == wikiPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationId,operationType,provider,idempotentReplay,wikiPage);

@override
String toString() {
  return 'CorkboardAiSummarizeToWikiResponse(operationId: $operationId, operationType: $operationType, provider: $provider, idempotentReplay: $idempotentReplay, wikiPage: $wikiPage)';
}


}

/// @nodoc
abstract mixin class $CorkboardAiSummarizeToWikiResponseCopyWith<$Res>  {
  factory $CorkboardAiSummarizeToWikiResponseCopyWith(CorkboardAiSummarizeToWikiResponse value, $Res Function(CorkboardAiSummarizeToWikiResponse) _then) = _$CorkboardAiSummarizeToWikiResponseCopyWithImpl;
@useResult
$Res call({
 String operationId, String operationType, String provider, bool idempotentReplay, WikiPageResponse wikiPage
});


$WikiPageResponseCopyWith<$Res> get wikiPage;

}
/// @nodoc
class _$CorkboardAiSummarizeToWikiResponseCopyWithImpl<$Res>
    implements $CorkboardAiSummarizeToWikiResponseCopyWith<$Res> {
  _$CorkboardAiSummarizeToWikiResponseCopyWithImpl(this._self, this._then);

  final CorkboardAiSummarizeToWikiResponse _self;
  final $Res Function(CorkboardAiSummarizeToWikiResponse) _then;

/// Create a copy of CorkboardAiSummarizeToWikiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operationId = null,Object? operationType = null,Object? provider = null,Object? idempotentReplay = null,Object? wikiPage = null,}) {
  return _then(_self.copyWith(
operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,idempotentReplay: null == idempotentReplay ? _self.idempotentReplay : idempotentReplay // ignore: cast_nullable_to_non_nullable
as bool,wikiPage: null == wikiPage ? _self.wikiPage : wikiPage // ignore: cast_nullable_to_non_nullable
as WikiPageResponse,
  ));
}
/// Create a copy of CorkboardAiSummarizeToWikiResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WikiPageResponseCopyWith<$Res> get wikiPage {
  
  return $WikiPageResponseCopyWith<$Res>(_self.wikiPage, (value) {
    return _then(_self.copyWith(wikiPage: value));
  });
}
}


/// Adds pattern-matching-related methods to [CorkboardAiSummarizeToWikiResponse].
extension CorkboardAiSummarizeToWikiResponsePatterns on CorkboardAiSummarizeToWikiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorkboardAiSummarizeToWikiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorkboardAiSummarizeToWikiResponse value)  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorkboardAiSummarizeToWikiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  WikiPageResponse wikiPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiResponse() when $default != null:
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.wikiPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  WikiPageResponse wikiPage)  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiResponse():
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.wikiPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  WikiPageResponse wikiPage)?  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiSummarizeToWikiResponse() when $default != null:
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.wikiPage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CorkboardAiSummarizeToWikiResponse implements CorkboardAiSummarizeToWikiResponse {
  const _CorkboardAiSummarizeToWikiResponse({required this.operationId, required this.operationType, required this.provider, required this.idempotentReplay, required this.wikiPage});
  factory _CorkboardAiSummarizeToWikiResponse.fromJson(Map<String, dynamic> json) => _$CorkboardAiSummarizeToWikiResponseFromJson(json);

@override final  String operationId;
@override final  String operationType;
@override final  String provider;
@override final  bool idempotentReplay;
@override final  WikiPageResponse wikiPage;

/// Create a copy of CorkboardAiSummarizeToWikiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorkboardAiSummarizeToWikiResponseCopyWith<_CorkboardAiSummarizeToWikiResponse> get copyWith => __$CorkboardAiSummarizeToWikiResponseCopyWithImpl<_CorkboardAiSummarizeToWikiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorkboardAiSummarizeToWikiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorkboardAiSummarizeToWikiResponse&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.idempotentReplay, idempotentReplay) || other.idempotentReplay == idempotentReplay)&&(identical(other.wikiPage, wikiPage) || other.wikiPage == wikiPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationId,operationType,provider,idempotentReplay,wikiPage);

@override
String toString() {
  return 'CorkboardAiSummarizeToWikiResponse(operationId: $operationId, operationType: $operationType, provider: $provider, idempotentReplay: $idempotentReplay, wikiPage: $wikiPage)';
}


}

/// @nodoc
abstract mixin class _$CorkboardAiSummarizeToWikiResponseCopyWith<$Res> implements $CorkboardAiSummarizeToWikiResponseCopyWith<$Res> {
  factory _$CorkboardAiSummarizeToWikiResponseCopyWith(_CorkboardAiSummarizeToWikiResponse value, $Res Function(_CorkboardAiSummarizeToWikiResponse) _then) = __$CorkboardAiSummarizeToWikiResponseCopyWithImpl;
@override @useResult
$Res call({
 String operationId, String operationType, String provider, bool idempotentReplay, WikiPageResponse wikiPage
});


@override $WikiPageResponseCopyWith<$Res> get wikiPage;

}
/// @nodoc
class __$CorkboardAiSummarizeToWikiResponseCopyWithImpl<$Res>
    implements _$CorkboardAiSummarizeToWikiResponseCopyWith<$Res> {
  __$CorkboardAiSummarizeToWikiResponseCopyWithImpl(this._self, this._then);

  final _CorkboardAiSummarizeToWikiResponse _self;
  final $Res Function(_CorkboardAiSummarizeToWikiResponse) _then;

/// Create a copy of CorkboardAiSummarizeToWikiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operationId = null,Object? operationType = null,Object? provider = null,Object? idempotentReplay = null,Object? wikiPage = null,}) {
  return _then(_CorkboardAiSummarizeToWikiResponse(
operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,idempotentReplay: null == idempotentReplay ? _self.idempotentReplay : idempotentReplay // ignore: cast_nullable_to_non_nullable
as bool,wikiPage: null == wikiPage ? _self.wikiPage : wikiPage // ignore: cast_nullable_to_non_nullable
as WikiPageResponse,
  ));
}

/// Create a copy of CorkboardAiSummarizeToWikiResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WikiPageResponseCopyWith<$Res> get wikiPage {
  
  return $WikiPageResponseCopyWith<$Res>(_self.wikiPage, (value) {
    return _then(_self.copyWith(wikiPage: value));
  });
}
}


/// @nodoc
mixin _$CorkboardAiConvertToTaskResponse {

 String get operationId; String get operationType; String get provider; bool get idempotentReplay; String get cardId; ProjectTaskResponse get task;
/// Create a copy of CorkboardAiConvertToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorkboardAiConvertToTaskResponseCopyWith<CorkboardAiConvertToTaskResponse> get copyWith => _$CorkboardAiConvertToTaskResponseCopyWithImpl<CorkboardAiConvertToTaskResponse>(this as CorkboardAiConvertToTaskResponse, _$identity);

  /// Serializes this CorkboardAiConvertToTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorkboardAiConvertToTaskResponse&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.idempotentReplay, idempotentReplay) || other.idempotentReplay == idempotentReplay)&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.task, task) || other.task == task));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationId,operationType,provider,idempotentReplay,cardId,task);

@override
String toString() {
  return 'CorkboardAiConvertToTaskResponse(operationId: $operationId, operationType: $operationType, provider: $provider, idempotentReplay: $idempotentReplay, cardId: $cardId, task: $task)';
}


}

/// @nodoc
abstract mixin class $CorkboardAiConvertToTaskResponseCopyWith<$Res>  {
  factory $CorkboardAiConvertToTaskResponseCopyWith(CorkboardAiConvertToTaskResponse value, $Res Function(CorkboardAiConvertToTaskResponse) _then) = _$CorkboardAiConvertToTaskResponseCopyWithImpl;
@useResult
$Res call({
 String operationId, String operationType, String provider, bool idempotentReplay, String cardId, ProjectTaskResponse task
});


$ProjectTaskResponseCopyWith<$Res> get task;

}
/// @nodoc
class _$CorkboardAiConvertToTaskResponseCopyWithImpl<$Res>
    implements $CorkboardAiConvertToTaskResponseCopyWith<$Res> {
  _$CorkboardAiConvertToTaskResponseCopyWithImpl(this._self, this._then);

  final CorkboardAiConvertToTaskResponse _self;
  final $Res Function(CorkboardAiConvertToTaskResponse) _then;

/// Create a copy of CorkboardAiConvertToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operationId = null,Object? operationType = null,Object? provider = null,Object? idempotentReplay = null,Object? cardId = null,Object? task = null,}) {
  return _then(_self.copyWith(
operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,idempotentReplay: null == idempotentReplay ? _self.idempotentReplay : idempotentReplay // ignore: cast_nullable_to_non_nullable
as bool,cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as ProjectTaskResponse,
  ));
}
/// Create a copy of CorkboardAiConvertToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskResponseCopyWith<$Res> get task {
  
  return $ProjectTaskResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [CorkboardAiConvertToTaskResponse].
extension CorkboardAiConvertToTaskResponsePatterns on CorkboardAiConvertToTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorkboardAiConvertToTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorkboardAiConvertToTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorkboardAiConvertToTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiConvertToTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorkboardAiConvertToTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CorkboardAiConvertToTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  String cardId,  ProjectTaskResponse task)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorkboardAiConvertToTaskResponse() when $default != null:
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.cardId,_that.task);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  String cardId,  ProjectTaskResponse task)  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiConvertToTaskResponse():
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.cardId,_that.task);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String operationId,  String operationType,  String provider,  bool idempotentReplay,  String cardId,  ProjectTaskResponse task)?  $default,) {final _that = this;
switch (_that) {
case _CorkboardAiConvertToTaskResponse() when $default != null:
return $default(_that.operationId,_that.operationType,_that.provider,_that.idempotentReplay,_that.cardId,_that.task);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CorkboardAiConvertToTaskResponse implements CorkboardAiConvertToTaskResponse {
  const _CorkboardAiConvertToTaskResponse({required this.operationId, required this.operationType, required this.provider, required this.idempotentReplay, required this.cardId, required this.task});
  factory _CorkboardAiConvertToTaskResponse.fromJson(Map<String, dynamic> json) => _$CorkboardAiConvertToTaskResponseFromJson(json);

@override final  String operationId;
@override final  String operationType;
@override final  String provider;
@override final  bool idempotentReplay;
@override final  String cardId;
@override final  ProjectTaskResponse task;

/// Create a copy of CorkboardAiConvertToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorkboardAiConvertToTaskResponseCopyWith<_CorkboardAiConvertToTaskResponse> get copyWith => __$CorkboardAiConvertToTaskResponseCopyWithImpl<_CorkboardAiConvertToTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorkboardAiConvertToTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorkboardAiConvertToTaskResponse&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.idempotentReplay, idempotentReplay) || other.idempotentReplay == idempotentReplay)&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.task, task) || other.task == task));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationId,operationType,provider,idempotentReplay,cardId,task);

@override
String toString() {
  return 'CorkboardAiConvertToTaskResponse(operationId: $operationId, operationType: $operationType, provider: $provider, idempotentReplay: $idempotentReplay, cardId: $cardId, task: $task)';
}


}

/// @nodoc
abstract mixin class _$CorkboardAiConvertToTaskResponseCopyWith<$Res> implements $CorkboardAiConvertToTaskResponseCopyWith<$Res> {
  factory _$CorkboardAiConvertToTaskResponseCopyWith(_CorkboardAiConvertToTaskResponse value, $Res Function(_CorkboardAiConvertToTaskResponse) _then) = __$CorkboardAiConvertToTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String operationId, String operationType, String provider, bool idempotentReplay, String cardId, ProjectTaskResponse task
});


@override $ProjectTaskResponseCopyWith<$Res> get task;

}
/// @nodoc
class __$CorkboardAiConvertToTaskResponseCopyWithImpl<$Res>
    implements _$CorkboardAiConvertToTaskResponseCopyWith<$Res> {
  __$CorkboardAiConvertToTaskResponseCopyWithImpl(this._self, this._then);

  final _CorkboardAiConvertToTaskResponse _self;
  final $Res Function(_CorkboardAiConvertToTaskResponse) _then;

/// Create a copy of CorkboardAiConvertToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operationId = null,Object? operationType = null,Object? provider = null,Object? idempotentReplay = null,Object? cardId = null,Object? task = null,}) {
  return _then(_CorkboardAiConvertToTaskResponse(
operationId: null == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,idempotentReplay: null == idempotentReplay ? _self.idempotentReplay : idempotentReplay // ignore: cast_nullable_to_non_nullable
as bool,cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as ProjectTaskResponse,
  ));
}

/// Create a copy of CorkboardAiConvertToTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectTaskResponseCopyWith<$Res> get task {
  
  return $ProjectTaskResponseCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
