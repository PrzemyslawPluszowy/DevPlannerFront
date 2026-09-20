// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_project_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateProjectPayload {

/// Nowa nazwa projektu.
 String get name;/// Nowy opis projektu albo null.
 String? get description;/// Nowy identyfikator ikony albo null.
 String? get icon;/// Nowy kolor główny projektu albo null.
 String? get primaryColor;/// Nowa widoczność projektu.
 ProjectVisibility get visibility;/// Nowy status projektu.
 ProjectStatus get status;/// Oczekiwana wersja projektu z ostatniego odczytu albo null.
///
/// Niezgodność zwraca 409 z kodem `project.version_conflict`, więc klient
/// nie nadpisuje zmiany wykonanej w drugiej sesji.
 int? get expectedVersion;
/// Create a copy of UpdateProjectPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProjectPayloadCopyWith<UpdateProjectPayload> get copyWith => _$UpdateProjectPayloadCopyWithImpl<UpdateProjectPayload>(this as UpdateProjectPayload, _$identity);

  /// Serializes this UpdateProjectPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProjectPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor,visibility,status,expectedVersion);

@override
String toString() {
  return 'UpdateProjectPayload(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateProjectPayloadCopyWith<$Res>  {
  factory $UpdateProjectPayloadCopyWith(UpdateProjectPayload value, $Res Function(UpdateProjectPayload) _then) = _$UpdateProjectPayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor, ProjectVisibility visibility, ProjectStatus status, int? expectedVersion
});




}
/// @nodoc
class _$UpdateProjectPayloadCopyWithImpl<$Res>
    implements $UpdateProjectPayloadCopyWith<$Res> {
  _$UpdateProjectPayloadCopyWithImpl(this._self, this._then);

  final UpdateProjectPayload _self;
  final $Res Function(UpdateProjectPayload) _then;

/// Create a copy of UpdateProjectPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,Object? expectedVersion = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,expectedVersion: freezed == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProjectPayload].
extension UpdateProjectPayloadPatterns on UpdateProjectPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProjectPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProjectPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProjectPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProjectPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  int? expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProjectPayload() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  int? expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectPayload():
return $default(_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  int? expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectPayload() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProjectPayload implements UpdateProjectPayload {
  const _UpdateProjectPayload({required this.name, this.description, this.icon, this.primaryColor, required this.visibility, required this.status, this.expectedVersion});
  factory _UpdateProjectPayload.fromJson(Map<String, dynamic> json) => _$UpdateProjectPayloadFromJson(json);

/// Nowa nazwa projektu.
@override final  String name;
/// Nowy opis projektu albo null.
@override final  String? description;
/// Nowy identyfikator ikony albo null.
@override final  String? icon;
/// Nowy kolor główny projektu albo null.
@override final  String? primaryColor;
/// Nowa widoczność projektu.
@override final  ProjectVisibility visibility;
/// Nowy status projektu.
@override final  ProjectStatus status;
/// Oczekiwana wersja projektu z ostatniego odczytu albo null.
///
/// Niezgodność zwraca 409 z kodem `project.version_conflict`, więc klient
/// nie nadpisuje zmiany wykonanej w drugiej sesji.
@override final  int? expectedVersion;

/// Create a copy of UpdateProjectPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProjectPayloadCopyWith<_UpdateProjectPayload> get copyWith => __$UpdateProjectPayloadCopyWithImpl<_UpdateProjectPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProjectPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProjectPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor,visibility,status,expectedVersion);

@override
String toString() {
  return 'UpdateProjectPayload(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateProjectPayloadCopyWith<$Res> implements $UpdateProjectPayloadCopyWith<$Res> {
  factory _$UpdateProjectPayloadCopyWith(_UpdateProjectPayload value, $Res Function(_UpdateProjectPayload) _then) = __$UpdateProjectPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor, ProjectVisibility visibility, ProjectStatus status, int? expectedVersion
});




}
/// @nodoc
class __$UpdateProjectPayloadCopyWithImpl<$Res>
    implements _$UpdateProjectPayloadCopyWith<$Res> {
  __$UpdateProjectPayloadCopyWithImpl(this._self, this._then);

  final _UpdateProjectPayload _self;
  final $Res Function(_UpdateProjectPayload) _then;

/// Create a copy of UpdateProjectPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,Object? expectedVersion = freezed,}) {
  return _then(_UpdateProjectPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,expectedVersion: freezed == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
