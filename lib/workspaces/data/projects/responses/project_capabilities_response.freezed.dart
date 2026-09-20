// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_capabilities_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectCapabilitiesResponse {

/// Czy użytkownik może zmieniać dane aktywnego projektu.
 bool get canManage;/// Czy użytkownik może archiwizować i przywracać projekt.
 bool get canArchive;/// Czy użytkownik może trwale usunąć zarchiwizowany projekt.
 bool get canDelete;/// Czy użytkownik może zarządzać członkami projektu.
 bool get canManageMembers;/// Czy użytkownik może zapisać szablon z projektu.
 bool get canCreateTemplate;/// Czy użytkownik ma jawne członkostwo projektu, które może opuścić.
 bool get canLeave;/// Zarezerwowane dla transferu projektu; obecnie zawsze `false`.
 bool get canTransfer;
/// Create a copy of ProjectCapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectCapabilitiesResponseCopyWith<ProjectCapabilitiesResponse> get copyWith => _$ProjectCapabilitiesResponseCopyWithImpl<ProjectCapabilitiesResponse>(this as ProjectCapabilitiesResponse, _$identity);

  /// Serializes this ProjectCapabilitiesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectCapabilitiesResponse&&(identical(other.canManage, canManage) || other.canManage == canManage)&&(identical(other.canArchive, canArchive) || other.canArchive == canArchive)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.canManageMembers, canManageMembers) || other.canManageMembers == canManageMembers)&&(identical(other.canCreateTemplate, canCreateTemplate) || other.canCreateTemplate == canCreateTemplate)&&(identical(other.canLeave, canLeave) || other.canLeave == canLeave)&&(identical(other.canTransfer, canTransfer) || other.canTransfer == canTransfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canManage,canArchive,canDelete,canManageMembers,canCreateTemplate,canLeave,canTransfer);

@override
String toString() {
  return 'ProjectCapabilitiesResponse(canManage: $canManage, canArchive: $canArchive, canDelete: $canDelete, canManageMembers: $canManageMembers, canCreateTemplate: $canCreateTemplate, canLeave: $canLeave, canTransfer: $canTransfer)';
}


}

/// @nodoc
abstract mixin class $ProjectCapabilitiesResponseCopyWith<$Res>  {
  factory $ProjectCapabilitiesResponseCopyWith(ProjectCapabilitiesResponse value, $Res Function(ProjectCapabilitiesResponse) _then) = _$ProjectCapabilitiesResponseCopyWithImpl;
@useResult
$Res call({
 bool canManage, bool canArchive, bool canDelete, bool canManageMembers, bool canCreateTemplate, bool canLeave, bool canTransfer
});




}
/// @nodoc
class _$ProjectCapabilitiesResponseCopyWithImpl<$Res>
    implements $ProjectCapabilitiesResponseCopyWith<$Res> {
  _$ProjectCapabilitiesResponseCopyWithImpl(this._self, this._then);

  final ProjectCapabilitiesResponse _self;
  final $Res Function(ProjectCapabilitiesResponse) _then;

/// Create a copy of ProjectCapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? canManage = null,Object? canArchive = null,Object? canDelete = null,Object? canManageMembers = null,Object? canCreateTemplate = null,Object? canLeave = null,Object? canTransfer = null,}) {
  return _then(_self.copyWith(
canManage: null == canManage ? _self.canManage : canManage // ignore: cast_nullable_to_non_nullable
as bool,canArchive: null == canArchive ? _self.canArchive : canArchive // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,canManageMembers: null == canManageMembers ? _self.canManageMembers : canManageMembers // ignore: cast_nullable_to_non_nullable
as bool,canCreateTemplate: null == canCreateTemplate ? _self.canCreateTemplate : canCreateTemplate // ignore: cast_nullable_to_non_nullable
as bool,canLeave: null == canLeave ? _self.canLeave : canLeave // ignore: cast_nullable_to_non_nullable
as bool,canTransfer: null == canTransfer ? _self.canTransfer : canTransfer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectCapabilitiesResponse].
extension ProjectCapabilitiesResponsePatterns on ProjectCapabilitiesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectCapabilitiesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectCapabilitiesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectCapabilitiesResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectCapabilitiesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectCapabilitiesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectCapabilitiesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool canManage,  bool canArchive,  bool canDelete,  bool canManageMembers,  bool canCreateTemplate,  bool canLeave,  bool canTransfer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectCapabilitiesResponse() when $default != null:
return $default(_that.canManage,_that.canArchive,_that.canDelete,_that.canManageMembers,_that.canCreateTemplate,_that.canLeave,_that.canTransfer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool canManage,  bool canArchive,  bool canDelete,  bool canManageMembers,  bool canCreateTemplate,  bool canLeave,  bool canTransfer)  $default,) {final _that = this;
switch (_that) {
case _ProjectCapabilitiesResponse():
return $default(_that.canManage,_that.canArchive,_that.canDelete,_that.canManageMembers,_that.canCreateTemplate,_that.canLeave,_that.canTransfer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool canManage,  bool canArchive,  bool canDelete,  bool canManageMembers,  bool canCreateTemplate,  bool canLeave,  bool canTransfer)?  $default,) {final _that = this;
switch (_that) {
case _ProjectCapabilitiesResponse() when $default != null:
return $default(_that.canManage,_that.canArchive,_that.canDelete,_that.canManageMembers,_that.canCreateTemplate,_that.canLeave,_that.canTransfer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectCapabilitiesResponse implements ProjectCapabilitiesResponse {
  const _ProjectCapabilitiesResponse({this.canManage = false, this.canArchive = false, this.canDelete = false, this.canManageMembers = false, this.canCreateTemplate = false, this.canLeave = false, this.canTransfer = false});
  factory _ProjectCapabilitiesResponse.fromJson(Map<String, dynamic> json) => _$ProjectCapabilitiesResponseFromJson(json);

/// Czy użytkownik może zmieniać dane aktywnego projektu.
@override@JsonKey() final  bool canManage;
/// Czy użytkownik może archiwizować i przywracać projekt.
@override@JsonKey() final  bool canArchive;
/// Czy użytkownik może trwale usunąć zarchiwizowany projekt.
@override@JsonKey() final  bool canDelete;
/// Czy użytkownik może zarządzać członkami projektu.
@override@JsonKey() final  bool canManageMembers;
/// Czy użytkownik może zapisać szablon z projektu.
@override@JsonKey() final  bool canCreateTemplate;
/// Czy użytkownik ma jawne członkostwo projektu, które może opuścić.
@override@JsonKey() final  bool canLeave;
/// Zarezerwowane dla transferu projektu; obecnie zawsze `false`.
@override@JsonKey() final  bool canTransfer;

/// Create a copy of ProjectCapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectCapabilitiesResponseCopyWith<_ProjectCapabilitiesResponse> get copyWith => __$ProjectCapabilitiesResponseCopyWithImpl<_ProjectCapabilitiesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectCapabilitiesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectCapabilitiesResponse&&(identical(other.canManage, canManage) || other.canManage == canManage)&&(identical(other.canArchive, canArchive) || other.canArchive == canArchive)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.canManageMembers, canManageMembers) || other.canManageMembers == canManageMembers)&&(identical(other.canCreateTemplate, canCreateTemplate) || other.canCreateTemplate == canCreateTemplate)&&(identical(other.canLeave, canLeave) || other.canLeave == canLeave)&&(identical(other.canTransfer, canTransfer) || other.canTransfer == canTransfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canManage,canArchive,canDelete,canManageMembers,canCreateTemplate,canLeave,canTransfer);

@override
String toString() {
  return 'ProjectCapabilitiesResponse(canManage: $canManage, canArchive: $canArchive, canDelete: $canDelete, canManageMembers: $canManageMembers, canCreateTemplate: $canCreateTemplate, canLeave: $canLeave, canTransfer: $canTransfer)';
}


}

/// @nodoc
abstract mixin class _$ProjectCapabilitiesResponseCopyWith<$Res> implements $ProjectCapabilitiesResponseCopyWith<$Res> {
  factory _$ProjectCapabilitiesResponseCopyWith(_ProjectCapabilitiesResponse value, $Res Function(_ProjectCapabilitiesResponse) _then) = __$ProjectCapabilitiesResponseCopyWithImpl;
@override @useResult
$Res call({
 bool canManage, bool canArchive, bool canDelete, bool canManageMembers, bool canCreateTemplate, bool canLeave, bool canTransfer
});




}
/// @nodoc
class __$ProjectCapabilitiesResponseCopyWithImpl<$Res>
    implements _$ProjectCapabilitiesResponseCopyWith<$Res> {
  __$ProjectCapabilitiesResponseCopyWithImpl(this._self, this._then);

  final _ProjectCapabilitiesResponse _self;
  final $Res Function(_ProjectCapabilitiesResponse) _then;

/// Create a copy of ProjectCapabilitiesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? canManage = null,Object? canArchive = null,Object? canDelete = null,Object? canManageMembers = null,Object? canCreateTemplate = null,Object? canLeave = null,Object? canTransfer = null,}) {
  return _then(_ProjectCapabilitiesResponse(
canManage: null == canManage ? _self.canManage : canManage // ignore: cast_nullable_to_non_nullable
as bool,canArchive: null == canArchive ? _self.canArchive : canArchive // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,canManageMembers: null == canManageMembers ? _self.canManageMembers : canManageMembers // ignore: cast_nullable_to_non_nullable
as bool,canCreateTemplate: null == canCreateTemplate ? _self.canCreateTemplate : canCreateTemplate // ignore: cast_nullable_to_non_nullable
as bool,canLeave: null == canLeave ? _self.canLeave : canLeave // ignore: cast_nullable_to_non_nullable
as bool,canTransfer: null == canTransfer ? _self.canTransfer : canTransfer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
