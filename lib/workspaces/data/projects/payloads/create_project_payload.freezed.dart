// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_project_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateProjectPayload {

/// Nazwa projektu od 1 do 160 znaków.
 String get name;/// Opcjonalny opis projektu do 4000 znaków.
 String? get description;/// Opcjonalny identyfikator ikony prezentacyjnej projektu.
 String? get icon;/// Opcjonalny kolor główny projektu w formacie CSS.
 String? get primaryColor;/// Widoczność projektu: Shared albo Private.
 ProjectVisibility get visibility;/// Stan projektu: Planned, Active, OnHold albo Completed.
 ProjectStatus get status;
/// Create a copy of CreateProjectPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProjectPayloadCopyWith<CreateProjectPayload> get copyWith => _$CreateProjectPayloadCopyWithImpl<CreateProjectPayload>(this as CreateProjectPayload, _$identity);

  /// Serializes this CreateProjectPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProjectPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor,visibility,status);

@override
String toString() {
  return 'CreateProjectPayload(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status)';
}


}

/// @nodoc
abstract mixin class $CreateProjectPayloadCopyWith<$Res>  {
  factory $CreateProjectPayloadCopyWith(CreateProjectPayload value, $Res Function(CreateProjectPayload) _then) = _$CreateProjectPayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor, ProjectVisibility visibility, ProjectStatus status
});




}
/// @nodoc
class _$CreateProjectPayloadCopyWithImpl<$Res>
    implements $CreateProjectPayloadCopyWith<$Res> {
  _$CreateProjectPayloadCopyWithImpl(this._self, this._then);

  final CreateProjectPayload _self;
  final $Res Function(CreateProjectPayload) _then;

/// Create a copy of CreateProjectPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProjectPayload].
extension CreateProjectPayloadPatterns on CreateProjectPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProjectPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProjectPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProjectPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateProjectPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProjectPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProjectPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProjectPayload() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status)  $default,) {final _that = this;
switch (_that) {
case _CreateProjectPayload():
return $default(_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status)?  $default,) {final _that = this;
switch (_that) {
case _CreateProjectPayload() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProjectPayload implements CreateProjectPayload {
  const _CreateProjectPayload({required this.name, this.description, this.icon, this.primaryColor, required this.visibility, required this.status});
  factory _CreateProjectPayload.fromJson(Map<String, dynamic> json) => _$CreateProjectPayloadFromJson(json);

/// Nazwa projektu od 1 do 160 znaków.
@override final  String name;
/// Opcjonalny opis projektu do 4000 znaków.
@override final  String? description;
/// Opcjonalny identyfikator ikony prezentacyjnej projektu.
@override final  String? icon;
/// Opcjonalny kolor główny projektu w formacie CSS.
@override final  String? primaryColor;
/// Widoczność projektu: Shared albo Private.
@override final  ProjectVisibility visibility;
/// Stan projektu: Planned, Active, OnHold albo Completed.
@override final  ProjectStatus status;

/// Create a copy of CreateProjectPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProjectPayloadCopyWith<_CreateProjectPayload> get copyWith => __$CreateProjectPayloadCopyWithImpl<_CreateProjectPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProjectPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProjectPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor,visibility,status);

@override
String toString() {
  return 'CreateProjectPayload(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CreateProjectPayloadCopyWith<$Res> implements $CreateProjectPayloadCopyWith<$Res> {
  factory _$CreateProjectPayloadCopyWith(_CreateProjectPayload value, $Res Function(_CreateProjectPayload) _then) = __$CreateProjectPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor, ProjectVisibility visibility, ProjectStatus status
});




}
/// @nodoc
class __$CreateProjectPayloadCopyWithImpl<$Res>
    implements _$CreateProjectPayloadCopyWith<$Res> {
  __$CreateProjectPayloadCopyWithImpl(this._self, this._then);

  final _CreateProjectPayload _self;
  final $Res Function(_CreateProjectPayload) _then;

/// Create a copy of CreateProjectPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,}) {
  return _then(_CreateProjectPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,
  ));
}


}

// dart format on
