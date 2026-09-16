// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_payloads.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateWorkspacePayload {

 String get name; String? get description; String? get icon; String? get primaryColor;
/// Create a copy of CreateWorkspacePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWorkspacePayloadCopyWith<CreateWorkspacePayload> get copyWith => _$CreateWorkspacePayloadCopyWithImpl<CreateWorkspacePayload>(this as CreateWorkspacePayload, _$identity);

  /// Serializes this CreateWorkspacePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWorkspacePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor);

@override
String toString() {
  return 'CreateWorkspacePayload(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor)';
}


}

/// @nodoc
abstract mixin class $CreateWorkspacePayloadCopyWith<$Res>  {
  factory $CreateWorkspacePayloadCopyWith(CreateWorkspacePayload value, $Res Function(CreateWorkspacePayload) _then) = _$CreateWorkspacePayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor
});




}
/// @nodoc
class _$CreateWorkspacePayloadCopyWithImpl<$Res>
    implements $CreateWorkspacePayloadCopyWith<$Res> {
  _$CreateWorkspacePayloadCopyWithImpl(this._self, this._then);

  final CreateWorkspacePayload _self;
  final $Res Function(CreateWorkspacePayload) _then;

/// Create a copy of CreateWorkspacePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWorkspacePayload].
extension CreateWorkspacePayloadPatterns on CreateWorkspacePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWorkspacePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWorkspacePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWorkspacePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateWorkspacePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWorkspacePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWorkspacePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWorkspacePayload() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor)  $default,) {final _that = this;
switch (_that) {
case _CreateWorkspacePayload():
return $default(_that.name,_that.description,_that.icon,_that.primaryColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  String? icon,  String? primaryColor)?  $default,) {final _that = this;
switch (_that) {
case _CreateWorkspacePayload() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWorkspacePayload implements CreateWorkspacePayload {
  const _CreateWorkspacePayload({required this.name, this.description, this.icon, this.primaryColor});
  factory _CreateWorkspacePayload.fromJson(Map<String, dynamic> json) => _$CreateWorkspacePayloadFromJson(json);

@override final  String name;
@override final  String? description;
@override final  String? icon;
@override final  String? primaryColor;

/// Create a copy of CreateWorkspacePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWorkspacePayloadCopyWith<_CreateWorkspacePayload> get copyWith => __$CreateWorkspacePayloadCopyWithImpl<_CreateWorkspacePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWorkspacePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWorkspacePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor);

@override
String toString() {
  return 'CreateWorkspacePayload(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor)';
}


}

/// @nodoc
abstract mixin class _$CreateWorkspacePayloadCopyWith<$Res> implements $CreateWorkspacePayloadCopyWith<$Res> {
  factory _$CreateWorkspacePayloadCopyWith(_CreateWorkspacePayload value, $Res Function(_CreateWorkspacePayload) _then) = __$CreateWorkspacePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor
});




}
/// @nodoc
class __$CreateWorkspacePayloadCopyWithImpl<$Res>
    implements _$CreateWorkspacePayloadCopyWith<$Res> {
  __$CreateWorkspacePayloadCopyWithImpl(this._self, this._then);

  final _CreateWorkspacePayload _self;
  final $Res Function(_CreateWorkspacePayload) _then;

/// Create a copy of CreateWorkspacePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,}) {
  return _then(_CreateWorkspacePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateWorkspacePayload {

 String get name; String? get description; String? get icon; String? get primaryColor;
/// Create a copy of UpdateWorkspacePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWorkspacePayloadCopyWith<UpdateWorkspacePayload> get copyWith => _$UpdateWorkspacePayloadCopyWithImpl<UpdateWorkspacePayload>(this as UpdateWorkspacePayload, _$identity);

  /// Serializes this UpdateWorkspacePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWorkspacePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor);

@override
String toString() {
  return 'UpdateWorkspacePayload(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor)';
}


}

/// @nodoc
abstract mixin class $UpdateWorkspacePayloadCopyWith<$Res>  {
  factory $UpdateWorkspacePayloadCopyWith(UpdateWorkspacePayload value, $Res Function(UpdateWorkspacePayload) _then) = _$UpdateWorkspacePayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor
});




}
/// @nodoc
class _$UpdateWorkspacePayloadCopyWithImpl<$Res>
    implements $UpdateWorkspacePayloadCopyWith<$Res> {
  _$UpdateWorkspacePayloadCopyWithImpl(this._self, this._then);

  final UpdateWorkspacePayload _self;
  final $Res Function(UpdateWorkspacePayload) _then;

/// Create a copy of UpdateWorkspacePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWorkspacePayload].
extension UpdateWorkspacePayloadPatterns on UpdateWorkspacePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWorkspacePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWorkspacePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWorkspacePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkspacePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWorkspacePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkspacePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWorkspacePayload() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor)  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkspacePayload():
return $default(_that.name,_that.description,_that.icon,_that.primaryColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  String? icon,  String? primaryColor)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkspacePayload() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWorkspacePayload implements UpdateWorkspacePayload {
  const _UpdateWorkspacePayload({required this.name, this.description, this.icon, this.primaryColor});
  factory _UpdateWorkspacePayload.fromJson(Map<String, dynamic> json) => _$UpdateWorkspacePayloadFromJson(json);

@override final  String name;
@override final  String? description;
@override final  String? icon;
@override final  String? primaryColor;

/// Create a copy of UpdateWorkspacePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWorkspacePayloadCopyWith<_UpdateWorkspacePayload> get copyWith => __$UpdateWorkspacePayloadCopyWithImpl<_UpdateWorkspacePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWorkspacePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWorkspacePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor);

@override
String toString() {
  return 'UpdateWorkspacePayload(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor)';
}


}

/// @nodoc
abstract mixin class _$UpdateWorkspacePayloadCopyWith<$Res> implements $UpdateWorkspacePayloadCopyWith<$Res> {
  factory _$UpdateWorkspacePayloadCopyWith(_UpdateWorkspacePayload value, $Res Function(_UpdateWorkspacePayload) _then) = __$UpdateWorkspacePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor
});




}
/// @nodoc
class __$UpdateWorkspacePayloadCopyWithImpl<$Res>
    implements _$UpdateWorkspacePayloadCopyWith<$Res> {
  __$UpdateWorkspacePayloadCopyWithImpl(this._self, this._then);

  final _UpdateWorkspacePayload _self;
  final $Res Function(_UpdateWorkspacePayload) _then;

/// Create a copy of UpdateWorkspacePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,}) {
  return _then(_UpdateWorkspacePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateWorkspaceUserPreferencePayload {

 bool? get isHidden; bool? get isPinned;
/// Create a copy of UpdateWorkspaceUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWorkspaceUserPreferencePayloadCopyWith<UpdateWorkspaceUserPreferencePayload> get copyWith => _$UpdateWorkspaceUserPreferencePayloadCopyWithImpl<UpdateWorkspaceUserPreferencePayload>(this as UpdateWorkspaceUserPreferencePayload, _$identity);

  /// Serializes this UpdateWorkspaceUserPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWorkspaceUserPreferencePayload&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isHidden,isPinned);

@override
String toString() {
  return 'UpdateWorkspaceUserPreferencePayload(isHidden: $isHidden, isPinned: $isPinned)';
}


}

/// @nodoc
abstract mixin class $UpdateWorkspaceUserPreferencePayloadCopyWith<$Res>  {
  factory $UpdateWorkspaceUserPreferencePayloadCopyWith(UpdateWorkspaceUserPreferencePayload value, $Res Function(UpdateWorkspaceUserPreferencePayload) _then) = _$UpdateWorkspaceUserPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 bool? isHidden, bool? isPinned
});




}
/// @nodoc
class _$UpdateWorkspaceUserPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateWorkspaceUserPreferencePayloadCopyWith<$Res> {
  _$UpdateWorkspaceUserPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateWorkspaceUserPreferencePayload _self;
  final $Res Function(UpdateWorkspaceUserPreferencePayload) _then;

/// Create a copy of UpdateWorkspaceUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isHidden = freezed,Object? isPinned = freezed,}) {
  return _then(_self.copyWith(
isHidden: freezed == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool?,isPinned: freezed == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWorkspaceUserPreferencePayload].
extension UpdateWorkspaceUserPreferencePayloadPatterns on UpdateWorkspaceUserPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWorkspaceUserPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWorkspaceUserPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWorkspaceUserPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkspaceUserPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWorkspaceUserPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkspaceUserPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? isHidden,  bool? isPinned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWorkspaceUserPreferencePayload() when $default != null:
return $default(_that.isHidden,_that.isPinned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? isHidden,  bool? isPinned)  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkspaceUserPreferencePayload():
return $default(_that.isHidden,_that.isPinned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? isHidden,  bool? isPinned)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkspaceUserPreferencePayload() when $default != null:
return $default(_that.isHidden,_that.isPinned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWorkspaceUserPreferencePayload implements UpdateWorkspaceUserPreferencePayload {
  const _UpdateWorkspaceUserPreferencePayload({this.isHidden, this.isPinned});
  factory _UpdateWorkspaceUserPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateWorkspaceUserPreferencePayloadFromJson(json);

@override final  bool? isHidden;
@override final  bool? isPinned;

/// Create a copy of UpdateWorkspaceUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWorkspaceUserPreferencePayloadCopyWith<_UpdateWorkspaceUserPreferencePayload> get copyWith => __$UpdateWorkspaceUserPreferencePayloadCopyWithImpl<_UpdateWorkspaceUserPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWorkspaceUserPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWorkspaceUserPreferencePayload&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isHidden,isPinned);

@override
String toString() {
  return 'UpdateWorkspaceUserPreferencePayload(isHidden: $isHidden, isPinned: $isPinned)';
}


}

/// @nodoc
abstract mixin class _$UpdateWorkspaceUserPreferencePayloadCopyWith<$Res> implements $UpdateWorkspaceUserPreferencePayloadCopyWith<$Res> {
  factory _$UpdateWorkspaceUserPreferencePayloadCopyWith(_UpdateWorkspaceUserPreferencePayload value, $Res Function(_UpdateWorkspaceUserPreferencePayload) _then) = __$UpdateWorkspaceUserPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 bool? isHidden, bool? isPinned
});




}
/// @nodoc
class __$UpdateWorkspaceUserPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateWorkspaceUserPreferencePayloadCopyWith<$Res> {
  __$UpdateWorkspaceUserPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateWorkspaceUserPreferencePayload _self;
  final $Res Function(_UpdateWorkspaceUserPreferencePayload) _then;

/// Create a copy of UpdateWorkspaceUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isHidden = freezed,Object? isPinned = freezed,}) {
  return _then(_UpdateWorkspaceUserPreferencePayload(
isHidden: freezed == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool?,isPinned: freezed == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$UpdateWorkspaceOrderPayload {

 List<String> get workspaceIds;
/// Create a copy of UpdateWorkspaceOrderPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWorkspaceOrderPayloadCopyWith<UpdateWorkspaceOrderPayload> get copyWith => _$UpdateWorkspaceOrderPayloadCopyWithImpl<UpdateWorkspaceOrderPayload>(this as UpdateWorkspaceOrderPayload, _$identity);

  /// Serializes this UpdateWorkspaceOrderPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWorkspaceOrderPayload&&const DeepCollectionEquality().equals(other.workspaceIds, workspaceIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(workspaceIds));

@override
String toString() {
  return 'UpdateWorkspaceOrderPayload(workspaceIds: $workspaceIds)';
}


}

/// @nodoc
abstract mixin class $UpdateWorkspaceOrderPayloadCopyWith<$Res>  {
  factory $UpdateWorkspaceOrderPayloadCopyWith(UpdateWorkspaceOrderPayload value, $Res Function(UpdateWorkspaceOrderPayload) _then) = _$UpdateWorkspaceOrderPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> workspaceIds
});




}
/// @nodoc
class _$UpdateWorkspaceOrderPayloadCopyWithImpl<$Res>
    implements $UpdateWorkspaceOrderPayloadCopyWith<$Res> {
  _$UpdateWorkspaceOrderPayloadCopyWithImpl(this._self, this._then);

  final UpdateWorkspaceOrderPayload _self;
  final $Res Function(UpdateWorkspaceOrderPayload) _then;

/// Create a copy of UpdateWorkspaceOrderPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workspaceIds = null,}) {
  return _then(_self.copyWith(
workspaceIds: null == workspaceIds ? _self.workspaceIds : workspaceIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWorkspaceOrderPayload].
extension UpdateWorkspaceOrderPayloadPatterns on UpdateWorkspaceOrderPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWorkspaceOrderPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWorkspaceOrderPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWorkspaceOrderPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkspaceOrderPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWorkspaceOrderPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkspaceOrderPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> workspaceIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWorkspaceOrderPayload() when $default != null:
return $default(_that.workspaceIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> workspaceIds)  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkspaceOrderPayload():
return $default(_that.workspaceIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> workspaceIds)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkspaceOrderPayload() when $default != null:
return $default(_that.workspaceIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWorkspaceOrderPayload implements UpdateWorkspaceOrderPayload {
  const _UpdateWorkspaceOrderPayload({required this.workspaceIds});
  factory _UpdateWorkspaceOrderPayload.fromJson(Map<String, dynamic> json) => _$UpdateWorkspaceOrderPayloadFromJson(json);

@override final  List<String> workspaceIds;

/// Create a copy of UpdateWorkspaceOrderPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWorkspaceOrderPayloadCopyWith<_UpdateWorkspaceOrderPayload> get copyWith => __$UpdateWorkspaceOrderPayloadCopyWithImpl<_UpdateWorkspaceOrderPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWorkspaceOrderPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWorkspaceOrderPayload&&const DeepCollectionEquality().equals(other.workspaceIds, workspaceIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(workspaceIds));

@override
String toString() {
  return 'UpdateWorkspaceOrderPayload(workspaceIds: $workspaceIds)';
}


}

/// @nodoc
abstract mixin class _$UpdateWorkspaceOrderPayloadCopyWith<$Res> implements $UpdateWorkspaceOrderPayloadCopyWith<$Res> {
  factory _$UpdateWorkspaceOrderPayloadCopyWith(_UpdateWorkspaceOrderPayload value, $Res Function(_UpdateWorkspaceOrderPayload) _then) = __$UpdateWorkspaceOrderPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> workspaceIds
});




}
/// @nodoc
class __$UpdateWorkspaceOrderPayloadCopyWithImpl<$Res>
    implements _$UpdateWorkspaceOrderPayloadCopyWith<$Res> {
  __$UpdateWorkspaceOrderPayloadCopyWithImpl(this._self, this._then);

  final _UpdateWorkspaceOrderPayload _self;
  final $Res Function(_UpdateWorkspaceOrderPayload) _then;

/// Create a copy of UpdateWorkspaceOrderPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workspaceIds = null,}) {
  return _then(_UpdateWorkspaceOrderPayload(
workspaceIds: null == workspaceIds ? _self.workspaceIds : workspaceIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$UpdateWorkspaceNotificationPreferencePayload {

 bool? get inAppEnabled; bool? get emailEnabled; bool? get tasksEnabled; bool? get projectsEnabled; bool? get workspaceEnabled; bool? get membershipEnabled; bool? get invitationsEnabled; bool? get adminEnabled; bool? get ownerEnabled;
/// Create a copy of UpdateWorkspaceNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWorkspaceNotificationPreferencePayloadCopyWith<UpdateWorkspaceNotificationPreferencePayload> get copyWith => _$UpdateWorkspaceNotificationPreferencePayloadCopyWithImpl<UpdateWorkspaceNotificationPreferencePayload>(this as UpdateWorkspaceNotificationPreferencePayload, _$identity);

  /// Serializes this UpdateWorkspaceNotificationPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWorkspaceNotificationPreferencePayload&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.tasksEnabled, tasksEnabled) || other.tasksEnabled == tasksEnabled)&&(identical(other.projectsEnabled, projectsEnabled) || other.projectsEnabled == projectsEnabled)&&(identical(other.workspaceEnabled, workspaceEnabled) || other.workspaceEnabled == workspaceEnabled)&&(identical(other.membershipEnabled, membershipEnabled) || other.membershipEnabled == membershipEnabled)&&(identical(other.invitationsEnabled, invitationsEnabled) || other.invitationsEnabled == invitationsEnabled)&&(identical(other.adminEnabled, adminEnabled) || other.adminEnabled == adminEnabled)&&(identical(other.ownerEnabled, ownerEnabled) || other.ownerEnabled == ownerEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inAppEnabled,emailEnabled,tasksEnabled,projectsEnabled,workspaceEnabled,membershipEnabled,invitationsEnabled,adminEnabled,ownerEnabled);

@override
String toString() {
  return 'UpdateWorkspaceNotificationPreferencePayload(inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, tasksEnabled: $tasksEnabled, projectsEnabled: $projectsEnabled, workspaceEnabled: $workspaceEnabled, membershipEnabled: $membershipEnabled, invitationsEnabled: $invitationsEnabled, adminEnabled: $adminEnabled, ownerEnabled: $ownerEnabled)';
}


}

/// @nodoc
abstract mixin class $UpdateWorkspaceNotificationPreferencePayloadCopyWith<$Res>  {
  factory $UpdateWorkspaceNotificationPreferencePayloadCopyWith(UpdateWorkspaceNotificationPreferencePayload value, $Res Function(UpdateWorkspaceNotificationPreferencePayload) _then) = _$UpdateWorkspaceNotificationPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 bool? inAppEnabled, bool? emailEnabled, bool? tasksEnabled, bool? projectsEnabled, bool? workspaceEnabled, bool? membershipEnabled, bool? invitationsEnabled, bool? adminEnabled, bool? ownerEnabled
});




}
/// @nodoc
class _$UpdateWorkspaceNotificationPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateWorkspaceNotificationPreferencePayloadCopyWith<$Res> {
  _$UpdateWorkspaceNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateWorkspaceNotificationPreferencePayload _self;
  final $Res Function(UpdateWorkspaceNotificationPreferencePayload) _then;

/// Create a copy of UpdateWorkspaceNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inAppEnabled = freezed,Object? emailEnabled = freezed,Object? tasksEnabled = freezed,Object? projectsEnabled = freezed,Object? workspaceEnabled = freezed,Object? membershipEnabled = freezed,Object? invitationsEnabled = freezed,Object? adminEnabled = freezed,Object? ownerEnabled = freezed,}) {
  return _then(_self.copyWith(
inAppEnabled: freezed == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool?,emailEnabled: freezed == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool?,tasksEnabled: freezed == tasksEnabled ? _self.tasksEnabled : tasksEnabled // ignore: cast_nullable_to_non_nullable
as bool?,projectsEnabled: freezed == projectsEnabled ? _self.projectsEnabled : projectsEnabled // ignore: cast_nullable_to_non_nullable
as bool?,workspaceEnabled: freezed == workspaceEnabled ? _self.workspaceEnabled : workspaceEnabled // ignore: cast_nullable_to_non_nullable
as bool?,membershipEnabled: freezed == membershipEnabled ? _self.membershipEnabled : membershipEnabled // ignore: cast_nullable_to_non_nullable
as bool?,invitationsEnabled: freezed == invitationsEnabled ? _self.invitationsEnabled : invitationsEnabled // ignore: cast_nullable_to_non_nullable
as bool?,adminEnabled: freezed == adminEnabled ? _self.adminEnabled : adminEnabled // ignore: cast_nullable_to_non_nullable
as bool?,ownerEnabled: freezed == ownerEnabled ? _self.ownerEnabled : ownerEnabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWorkspaceNotificationPreferencePayload].
extension UpdateWorkspaceNotificationPreferencePayloadPatterns on UpdateWorkspaceNotificationPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWorkspaceNotificationPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWorkspaceNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWorkspaceNotificationPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkspaceNotificationPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWorkspaceNotificationPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkspaceNotificationPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? inAppEnabled,  bool? emailEnabled,  bool? tasksEnabled,  bool? projectsEnabled,  bool? workspaceEnabled,  bool? membershipEnabled,  bool? invitationsEnabled,  bool? adminEnabled,  bool? ownerEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWorkspaceNotificationPreferencePayload() when $default != null:
return $default(_that.inAppEnabled,_that.emailEnabled,_that.tasksEnabled,_that.projectsEnabled,_that.workspaceEnabled,_that.membershipEnabled,_that.invitationsEnabled,_that.adminEnabled,_that.ownerEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? inAppEnabled,  bool? emailEnabled,  bool? tasksEnabled,  bool? projectsEnabled,  bool? workspaceEnabled,  bool? membershipEnabled,  bool? invitationsEnabled,  bool? adminEnabled,  bool? ownerEnabled)  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkspaceNotificationPreferencePayload():
return $default(_that.inAppEnabled,_that.emailEnabled,_that.tasksEnabled,_that.projectsEnabled,_that.workspaceEnabled,_that.membershipEnabled,_that.invitationsEnabled,_that.adminEnabled,_that.ownerEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? inAppEnabled,  bool? emailEnabled,  bool? tasksEnabled,  bool? projectsEnabled,  bool? workspaceEnabled,  bool? membershipEnabled,  bool? invitationsEnabled,  bool? adminEnabled,  bool? ownerEnabled)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkspaceNotificationPreferencePayload() when $default != null:
return $default(_that.inAppEnabled,_that.emailEnabled,_that.tasksEnabled,_that.projectsEnabled,_that.workspaceEnabled,_that.membershipEnabled,_that.invitationsEnabled,_that.adminEnabled,_that.ownerEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWorkspaceNotificationPreferencePayload implements UpdateWorkspaceNotificationPreferencePayload {
  const _UpdateWorkspaceNotificationPreferencePayload({this.inAppEnabled, this.emailEnabled, this.tasksEnabled, this.projectsEnabled, this.workspaceEnabled, this.membershipEnabled, this.invitationsEnabled, this.adminEnabled, this.ownerEnabled});
  factory _UpdateWorkspaceNotificationPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateWorkspaceNotificationPreferencePayloadFromJson(json);

@override final  bool? inAppEnabled;
@override final  bool? emailEnabled;
@override final  bool? tasksEnabled;
@override final  bool? projectsEnabled;
@override final  bool? workspaceEnabled;
@override final  bool? membershipEnabled;
@override final  bool? invitationsEnabled;
@override final  bool? adminEnabled;
@override final  bool? ownerEnabled;

/// Create a copy of UpdateWorkspaceNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWorkspaceNotificationPreferencePayloadCopyWith<_UpdateWorkspaceNotificationPreferencePayload> get copyWith => __$UpdateWorkspaceNotificationPreferencePayloadCopyWithImpl<_UpdateWorkspaceNotificationPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWorkspaceNotificationPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWorkspaceNotificationPreferencePayload&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.tasksEnabled, tasksEnabled) || other.tasksEnabled == tasksEnabled)&&(identical(other.projectsEnabled, projectsEnabled) || other.projectsEnabled == projectsEnabled)&&(identical(other.workspaceEnabled, workspaceEnabled) || other.workspaceEnabled == workspaceEnabled)&&(identical(other.membershipEnabled, membershipEnabled) || other.membershipEnabled == membershipEnabled)&&(identical(other.invitationsEnabled, invitationsEnabled) || other.invitationsEnabled == invitationsEnabled)&&(identical(other.adminEnabled, adminEnabled) || other.adminEnabled == adminEnabled)&&(identical(other.ownerEnabled, ownerEnabled) || other.ownerEnabled == ownerEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inAppEnabled,emailEnabled,tasksEnabled,projectsEnabled,workspaceEnabled,membershipEnabled,invitationsEnabled,adminEnabled,ownerEnabled);

@override
String toString() {
  return 'UpdateWorkspaceNotificationPreferencePayload(inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, tasksEnabled: $tasksEnabled, projectsEnabled: $projectsEnabled, workspaceEnabled: $workspaceEnabled, membershipEnabled: $membershipEnabled, invitationsEnabled: $invitationsEnabled, adminEnabled: $adminEnabled, ownerEnabled: $ownerEnabled)';
}


}

/// @nodoc
abstract mixin class _$UpdateWorkspaceNotificationPreferencePayloadCopyWith<$Res> implements $UpdateWorkspaceNotificationPreferencePayloadCopyWith<$Res> {
  factory _$UpdateWorkspaceNotificationPreferencePayloadCopyWith(_UpdateWorkspaceNotificationPreferencePayload value, $Res Function(_UpdateWorkspaceNotificationPreferencePayload) _then) = __$UpdateWorkspaceNotificationPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 bool? inAppEnabled, bool? emailEnabled, bool? tasksEnabled, bool? projectsEnabled, bool? workspaceEnabled, bool? membershipEnabled, bool? invitationsEnabled, bool? adminEnabled, bool? ownerEnabled
});




}
/// @nodoc
class __$UpdateWorkspaceNotificationPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateWorkspaceNotificationPreferencePayloadCopyWith<$Res> {
  __$UpdateWorkspaceNotificationPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateWorkspaceNotificationPreferencePayload _self;
  final $Res Function(_UpdateWorkspaceNotificationPreferencePayload) _then;

/// Create a copy of UpdateWorkspaceNotificationPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inAppEnabled = freezed,Object? emailEnabled = freezed,Object? tasksEnabled = freezed,Object? projectsEnabled = freezed,Object? workspaceEnabled = freezed,Object? membershipEnabled = freezed,Object? invitationsEnabled = freezed,Object? adminEnabled = freezed,Object? ownerEnabled = freezed,}) {
  return _then(_UpdateWorkspaceNotificationPreferencePayload(
inAppEnabled: freezed == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool?,emailEnabled: freezed == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool?,tasksEnabled: freezed == tasksEnabled ? _self.tasksEnabled : tasksEnabled // ignore: cast_nullable_to_non_nullable
as bool?,projectsEnabled: freezed == projectsEnabled ? _self.projectsEnabled : projectsEnabled // ignore: cast_nullable_to_non_nullable
as bool?,workspaceEnabled: freezed == workspaceEnabled ? _self.workspaceEnabled : workspaceEnabled // ignore: cast_nullable_to_non_nullable
as bool?,membershipEnabled: freezed == membershipEnabled ? _self.membershipEnabled : membershipEnabled // ignore: cast_nullable_to_non_nullable
as bool?,invitationsEnabled: freezed == invitationsEnabled ? _self.invitationsEnabled : invitationsEnabled // ignore: cast_nullable_to_non_nullable
as bool?,adminEnabled: freezed == adminEnabled ? _self.adminEnabled : adminEnabled // ignore: cast_nullable_to_non_nullable
as bool?,ownerEnabled: freezed == ownerEnabled ? _self.ownerEnabled : ownerEnabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$CreateWorkspaceInvitationPayload {

 int get readyUserId; WorkspaceRole get role; String? get message;
/// Create a copy of CreateWorkspaceInvitationPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateWorkspaceInvitationPayloadCopyWith<CreateWorkspaceInvitationPayload> get copyWith => _$CreateWorkspaceInvitationPayloadCopyWithImpl<CreateWorkspaceInvitationPayload>(this as CreateWorkspaceInvitationPayload, _$identity);

  /// Serializes this CreateWorkspaceInvitationPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateWorkspaceInvitationPayload&&(identical(other.readyUserId, readyUserId) || other.readyUserId == readyUserId)&&(identical(other.role, role) || other.role == role)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,readyUserId,role,message);

@override
String toString() {
  return 'CreateWorkspaceInvitationPayload(readyUserId: $readyUserId, role: $role, message: $message)';
}


}

/// @nodoc
abstract mixin class $CreateWorkspaceInvitationPayloadCopyWith<$Res>  {
  factory $CreateWorkspaceInvitationPayloadCopyWith(CreateWorkspaceInvitationPayload value, $Res Function(CreateWorkspaceInvitationPayload) _then) = _$CreateWorkspaceInvitationPayloadCopyWithImpl;
@useResult
$Res call({
 int readyUserId, WorkspaceRole role, String? message
});




}
/// @nodoc
class _$CreateWorkspaceInvitationPayloadCopyWithImpl<$Res>
    implements $CreateWorkspaceInvitationPayloadCopyWith<$Res> {
  _$CreateWorkspaceInvitationPayloadCopyWithImpl(this._self, this._then);

  final CreateWorkspaceInvitationPayload _self;
  final $Res Function(CreateWorkspaceInvitationPayload) _then;

/// Create a copy of CreateWorkspaceInvitationPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? readyUserId = null,Object? role = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
readyUserId: null == readyUserId ? _self.readyUserId : readyUserId // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as WorkspaceRole,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateWorkspaceInvitationPayload].
extension CreateWorkspaceInvitationPayloadPatterns on CreateWorkspaceInvitationPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateWorkspaceInvitationPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateWorkspaceInvitationPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateWorkspaceInvitationPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateWorkspaceInvitationPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateWorkspaceInvitationPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateWorkspaceInvitationPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int readyUserId,  WorkspaceRole role,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateWorkspaceInvitationPayload() when $default != null:
return $default(_that.readyUserId,_that.role,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int readyUserId,  WorkspaceRole role,  String? message)  $default,) {final _that = this;
switch (_that) {
case _CreateWorkspaceInvitationPayload():
return $default(_that.readyUserId,_that.role,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int readyUserId,  WorkspaceRole role,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _CreateWorkspaceInvitationPayload() when $default != null:
return $default(_that.readyUserId,_that.role,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateWorkspaceInvitationPayload implements CreateWorkspaceInvitationPayload {
  const _CreateWorkspaceInvitationPayload({required this.readyUserId, required this.role, this.message});
  factory _CreateWorkspaceInvitationPayload.fromJson(Map<String, dynamic> json) => _$CreateWorkspaceInvitationPayloadFromJson(json);

@override final  int readyUserId;
@override final  WorkspaceRole role;
@override final  String? message;

/// Create a copy of CreateWorkspaceInvitationPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateWorkspaceInvitationPayloadCopyWith<_CreateWorkspaceInvitationPayload> get copyWith => __$CreateWorkspaceInvitationPayloadCopyWithImpl<_CreateWorkspaceInvitationPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateWorkspaceInvitationPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateWorkspaceInvitationPayload&&(identical(other.readyUserId, readyUserId) || other.readyUserId == readyUserId)&&(identical(other.role, role) || other.role == role)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,readyUserId,role,message);

@override
String toString() {
  return 'CreateWorkspaceInvitationPayload(readyUserId: $readyUserId, role: $role, message: $message)';
}


}

/// @nodoc
abstract mixin class _$CreateWorkspaceInvitationPayloadCopyWith<$Res> implements $CreateWorkspaceInvitationPayloadCopyWith<$Res> {
  factory _$CreateWorkspaceInvitationPayloadCopyWith(_CreateWorkspaceInvitationPayload value, $Res Function(_CreateWorkspaceInvitationPayload) _then) = __$CreateWorkspaceInvitationPayloadCopyWithImpl;
@override @useResult
$Res call({
 int readyUserId, WorkspaceRole role, String? message
});




}
/// @nodoc
class __$CreateWorkspaceInvitationPayloadCopyWithImpl<$Res>
    implements _$CreateWorkspaceInvitationPayloadCopyWith<$Res> {
  __$CreateWorkspaceInvitationPayloadCopyWithImpl(this._self, this._then);

  final _CreateWorkspaceInvitationPayload _self;
  final $Res Function(_CreateWorkspaceInvitationPayload) _then;

/// Create a copy of CreateWorkspaceInvitationPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? readyUserId = null,Object? role = null,Object? message = freezed,}) {
  return _then(_CreateWorkspaceInvitationPayload(
readyUserId: null == readyUserId ? _self.readyUserId : readyUserId // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as WorkspaceRole,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChangeWorkspaceMemberRolePayload {

 WorkspaceRole get role;
/// Create a copy of ChangeWorkspaceMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeWorkspaceMemberRolePayloadCopyWith<ChangeWorkspaceMemberRolePayload> get copyWith => _$ChangeWorkspaceMemberRolePayloadCopyWithImpl<ChangeWorkspaceMemberRolePayload>(this as ChangeWorkspaceMemberRolePayload, _$identity);

  /// Serializes this ChangeWorkspaceMemberRolePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeWorkspaceMemberRolePayload&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'ChangeWorkspaceMemberRolePayload(role: $role)';
}


}

/// @nodoc
abstract mixin class $ChangeWorkspaceMemberRolePayloadCopyWith<$Res>  {
  factory $ChangeWorkspaceMemberRolePayloadCopyWith(ChangeWorkspaceMemberRolePayload value, $Res Function(ChangeWorkspaceMemberRolePayload) _then) = _$ChangeWorkspaceMemberRolePayloadCopyWithImpl;
@useResult
$Res call({
 WorkspaceRole role
});




}
/// @nodoc
class _$ChangeWorkspaceMemberRolePayloadCopyWithImpl<$Res>
    implements $ChangeWorkspaceMemberRolePayloadCopyWith<$Res> {
  _$ChangeWorkspaceMemberRolePayloadCopyWithImpl(this._self, this._then);

  final ChangeWorkspaceMemberRolePayload _self;
  final $Res Function(ChangeWorkspaceMemberRolePayload) _then;

/// Create a copy of ChangeWorkspaceMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as WorkspaceRole,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangeWorkspaceMemberRolePayload].
extension ChangeWorkspaceMemberRolePayloadPatterns on ChangeWorkspaceMemberRolePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangeWorkspaceMemberRolePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangeWorkspaceMemberRolePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangeWorkspaceMemberRolePayload value)  $default,){
final _that = this;
switch (_that) {
case _ChangeWorkspaceMemberRolePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangeWorkspaceMemberRolePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ChangeWorkspaceMemberRolePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WorkspaceRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangeWorkspaceMemberRolePayload() when $default != null:
return $default(_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WorkspaceRole role)  $default,) {final _that = this;
switch (_that) {
case _ChangeWorkspaceMemberRolePayload():
return $default(_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WorkspaceRole role)?  $default,) {final _that = this;
switch (_that) {
case _ChangeWorkspaceMemberRolePayload() when $default != null:
return $default(_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChangeWorkspaceMemberRolePayload implements ChangeWorkspaceMemberRolePayload {
  const _ChangeWorkspaceMemberRolePayload({required this.role});
  factory _ChangeWorkspaceMemberRolePayload.fromJson(Map<String, dynamic> json) => _$ChangeWorkspaceMemberRolePayloadFromJson(json);

@override final  WorkspaceRole role;

/// Create a copy of ChangeWorkspaceMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeWorkspaceMemberRolePayloadCopyWith<_ChangeWorkspaceMemberRolePayload> get copyWith => __$ChangeWorkspaceMemberRolePayloadCopyWithImpl<_ChangeWorkspaceMemberRolePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangeWorkspaceMemberRolePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeWorkspaceMemberRolePayload&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'ChangeWorkspaceMemberRolePayload(role: $role)';
}


}

/// @nodoc
abstract mixin class _$ChangeWorkspaceMemberRolePayloadCopyWith<$Res> implements $ChangeWorkspaceMemberRolePayloadCopyWith<$Res> {
  factory _$ChangeWorkspaceMemberRolePayloadCopyWith(_ChangeWorkspaceMemberRolePayload value, $Res Function(_ChangeWorkspaceMemberRolePayload) _then) = __$ChangeWorkspaceMemberRolePayloadCopyWithImpl;
@override @useResult
$Res call({
 WorkspaceRole role
});




}
/// @nodoc
class __$ChangeWorkspaceMemberRolePayloadCopyWithImpl<$Res>
    implements _$ChangeWorkspaceMemberRolePayloadCopyWith<$Res> {
  __$ChangeWorkspaceMemberRolePayloadCopyWithImpl(this._self, this._then);

  final _ChangeWorkspaceMemberRolePayload _self;
  final $Res Function(_ChangeWorkspaceMemberRolePayload) _then;

/// Create a copy of ChangeWorkspaceMemberRolePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,}) {
  return _then(_ChangeWorkspaceMemberRolePayload(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as WorkspaceRole,
  ));
}


}

// dart format on
