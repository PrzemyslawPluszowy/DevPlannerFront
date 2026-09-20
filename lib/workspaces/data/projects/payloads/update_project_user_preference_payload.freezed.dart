// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_project_user_preference_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateProjectUserPreferencePayload {

/// Czy projekt ma być ukryty na liście bieżącego użytkownika.
 bool get isHidden;/// Czy projekt ma być przypięty na liście bieżącego użytkownika.
 bool get isPinned;/// Oczekiwana wersja preferencji z poprzedniego odczytu lub zapisu
/// (a nie wersja projektu) albo null, gdy klient jej nie zna.
 int? get expectedVersion;
/// Create a copy of UpdateProjectUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProjectUserPreferencePayloadCopyWith<UpdateProjectUserPreferencePayload> get copyWith => _$UpdateProjectUserPreferencePayloadCopyWithImpl<UpdateProjectUserPreferencePayload>(this as UpdateProjectUserPreferencePayload, _$identity);

  /// Serializes this UpdateProjectUserPreferencePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProjectUserPreferencePayload&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isHidden,isPinned,expectedVersion);

@override
String toString() {
  return 'UpdateProjectUserPreferencePayload(isHidden: $isHidden, isPinned: $isPinned, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateProjectUserPreferencePayloadCopyWith<$Res>  {
  factory $UpdateProjectUserPreferencePayloadCopyWith(UpdateProjectUserPreferencePayload value, $Res Function(UpdateProjectUserPreferencePayload) _then) = _$UpdateProjectUserPreferencePayloadCopyWithImpl;
@useResult
$Res call({
 bool isHidden, bool isPinned, int? expectedVersion
});




}
/// @nodoc
class _$UpdateProjectUserPreferencePayloadCopyWithImpl<$Res>
    implements $UpdateProjectUserPreferencePayloadCopyWith<$Res> {
  _$UpdateProjectUserPreferencePayloadCopyWithImpl(this._self, this._then);

  final UpdateProjectUserPreferencePayload _self;
  final $Res Function(UpdateProjectUserPreferencePayload) _then;

/// Create a copy of UpdateProjectUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isHidden = null,Object? isPinned = null,Object? expectedVersion = freezed,}) {
  return _then(_self.copyWith(
isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: freezed == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProjectUserPreferencePayload].
extension UpdateProjectUserPreferencePayloadPatterns on UpdateProjectUserPreferencePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProjectUserPreferencePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProjectUserPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProjectUserPreferencePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectUserPreferencePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProjectUserPreferencePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectUserPreferencePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isHidden,  bool isPinned,  int? expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProjectUserPreferencePayload() when $default != null:
return $default(_that.isHidden,_that.isPinned,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isHidden,  bool isPinned,  int? expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectUserPreferencePayload():
return $default(_that.isHidden,_that.isPinned,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isHidden,  bool isPinned,  int? expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectUserPreferencePayload() when $default != null:
return $default(_that.isHidden,_that.isPinned,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProjectUserPreferencePayload implements UpdateProjectUserPreferencePayload {
  const _UpdateProjectUserPreferencePayload({required this.isHidden, required this.isPinned, this.expectedVersion});
  factory _UpdateProjectUserPreferencePayload.fromJson(Map<String, dynamic> json) => _$UpdateProjectUserPreferencePayloadFromJson(json);

/// Czy projekt ma być ukryty na liście bieżącego użytkownika.
@override final  bool isHidden;
/// Czy projekt ma być przypięty na liście bieżącego użytkownika.
@override final  bool isPinned;
/// Oczekiwana wersja preferencji z poprzedniego odczytu lub zapisu
/// (a nie wersja projektu) albo null, gdy klient jej nie zna.
@override final  int? expectedVersion;

/// Create a copy of UpdateProjectUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProjectUserPreferencePayloadCopyWith<_UpdateProjectUserPreferencePayload> get copyWith => __$UpdateProjectUserPreferencePayloadCopyWithImpl<_UpdateProjectUserPreferencePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProjectUserPreferencePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProjectUserPreferencePayload&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isHidden,isPinned,expectedVersion);

@override
String toString() {
  return 'UpdateProjectUserPreferencePayload(isHidden: $isHidden, isPinned: $isPinned, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateProjectUserPreferencePayloadCopyWith<$Res> implements $UpdateProjectUserPreferencePayloadCopyWith<$Res> {
  factory _$UpdateProjectUserPreferencePayloadCopyWith(_UpdateProjectUserPreferencePayload value, $Res Function(_UpdateProjectUserPreferencePayload) _then) = __$UpdateProjectUserPreferencePayloadCopyWithImpl;
@override @useResult
$Res call({
 bool isHidden, bool isPinned, int? expectedVersion
});




}
/// @nodoc
class __$UpdateProjectUserPreferencePayloadCopyWithImpl<$Res>
    implements _$UpdateProjectUserPreferencePayloadCopyWith<$Res> {
  __$UpdateProjectUserPreferencePayloadCopyWithImpl(this._self, this._then);

  final _UpdateProjectUserPreferencePayload _self;
  final $Res Function(_UpdateProjectUserPreferencePayload) _then;

/// Create a copy of UpdateProjectUserPreferencePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isHidden = null,Object? isPinned = null,Object? expectedVersion = freezed,}) {
  return _then(_UpdateProjectUserPreferencePayload(
isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: freezed == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
