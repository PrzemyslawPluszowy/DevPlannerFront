// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectResponse {

/// UUID projektu.
 String get id;/// UUID workspace zawierającego projekt.
 String get workspaceId;/// Nazwa projektu.
 String get name;/// Opis projektu albo null.
 String? get description;/// Identyfikator ikony albo null.
 String? get icon;/// Główny kolor projektu albo null.
 String? get primaryColor;/// Widoczność projektu.
 ProjectVisibility get visibility;/// Status projektu.
 ProjectStatus get status;/// UUID twórcy projektu.
 String get createdByCoreUserId;/// Rola bieżącego użytkownika albo null.
 ProjectRole? get myRole;/// Czas utworzenia projektu.
 DateTime get createdAtUtc;/// Czas ostatniej aktualizacji projektu.
 DateTime get updatedAtUtc;/// Czas archiwizacji albo null dla aktywnego projektu.
 DateTime? get archivedAtUtc;
/// Create a copy of ProjectResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectResponseCopyWith<ProjectResponse> get copyWith => _$ProjectResponseCopyWithImpl<ProjectResponse>(this as ProjectResponse, _$identity);

  /// Serializes this ProjectResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&(identical(other.myRole, myRole) || other.myRole == myRole)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,name,description,icon,primaryColor,visibility,status,createdByCoreUserId,myRole,createdAtUtc,updatedAtUtc,archivedAtUtc);

@override
String toString() {
  return 'ProjectResponse(id: $id, workspaceId: $workspaceId, name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status, createdByCoreUserId: $createdByCoreUserId, myRole: $myRole, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, archivedAtUtc: $archivedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ProjectResponseCopyWith<$Res>  {
  factory $ProjectResponseCopyWith(ProjectResponse value, $Res Function(ProjectResponse) _then) = _$ProjectResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String name, String? description, String? icon, String? primaryColor, ProjectVisibility visibility, ProjectStatus status, String createdByCoreUserId, ProjectRole? myRole, DateTime createdAtUtc, DateTime updatedAtUtc, DateTime? archivedAtUtc
});




}
/// @nodoc
class _$ProjectResponseCopyWithImpl<$Res>
    implements $ProjectResponseCopyWith<$Res> {
  _$ProjectResponseCopyWithImpl(this._self, this._then);

  final ProjectResponse _self;
  final $Res Function(ProjectResponse) _then;

/// Create a copy of ProjectResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,Object? createdByCoreUserId = null,Object? myRole = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? archivedAtUtc = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,createdByCoreUserId: null == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String,myRole: freezed == myRole ? _self.myRole : myRole // ignore: cast_nullable_to_non_nullable
as ProjectRole?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectResponse].
extension ProjectResponsePatterns on ProjectResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  String createdByCoreUserId,  ProjectRole? myRole,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.createdByCoreUserId,_that.myRole,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  String createdByCoreUserId,  ProjectRole? myRole,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ProjectResponse():
return $default(_that.id,_that.workspaceId,_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.createdByCoreUserId,_that.myRole,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  String createdByCoreUserId,  ProjectRole? myRole,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ProjectResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.createdByCoreUserId,_that.myRole,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectResponse implements ProjectResponse {
  const _ProjectResponse({required this.id, required this.workspaceId, required this.name, this.description, this.icon, this.primaryColor, required this.visibility, required this.status, required this.createdByCoreUserId, this.myRole, required this.createdAtUtc, required this.updatedAtUtc, this.archivedAtUtc});
  factory _ProjectResponse.fromJson(Map<String, dynamic> json) => _$ProjectResponseFromJson(json);

/// UUID projektu.
@override final  String id;
/// UUID workspace zawierającego projekt.
@override final  String workspaceId;
/// Nazwa projektu.
@override final  String name;
/// Opis projektu albo null.
@override final  String? description;
/// Identyfikator ikony albo null.
@override final  String? icon;
/// Główny kolor projektu albo null.
@override final  String? primaryColor;
/// Widoczność projektu.
@override final  ProjectVisibility visibility;
/// Status projektu.
@override final  ProjectStatus status;
/// UUID twórcy projektu.
@override final  String createdByCoreUserId;
/// Rola bieżącego użytkownika albo null.
@override final  ProjectRole? myRole;
/// Czas utworzenia projektu.
@override final  DateTime createdAtUtc;
/// Czas ostatniej aktualizacji projektu.
@override final  DateTime updatedAtUtc;
/// Czas archiwizacji albo null dla aktywnego projektu.
@override final  DateTime? archivedAtUtc;

/// Create a copy of ProjectResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectResponseCopyWith<_ProjectResponse> get copyWith => __$ProjectResponseCopyWithImpl<_ProjectResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&(identical(other.myRole, myRole) || other.myRole == myRole)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,name,description,icon,primaryColor,visibility,status,createdByCoreUserId,myRole,createdAtUtc,updatedAtUtc,archivedAtUtc);

@override
String toString() {
  return 'ProjectResponse(id: $id, workspaceId: $workspaceId, name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status, createdByCoreUserId: $createdByCoreUserId, myRole: $myRole, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, archivedAtUtc: $archivedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ProjectResponseCopyWith<$Res> implements $ProjectResponseCopyWith<$Res> {
  factory _$ProjectResponseCopyWith(_ProjectResponse value, $Res Function(_ProjectResponse) _then) = __$ProjectResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String name, String? description, String? icon, String? primaryColor, ProjectVisibility visibility, ProjectStatus status, String createdByCoreUserId, ProjectRole? myRole, DateTime createdAtUtc, DateTime updatedAtUtc, DateTime? archivedAtUtc
});




}
/// @nodoc
class __$ProjectResponseCopyWithImpl<$Res>
    implements _$ProjectResponseCopyWith<$Res> {
  __$ProjectResponseCopyWithImpl(this._self, this._then);

  final _ProjectResponse _self;
  final $Res Function(_ProjectResponse) _then;

/// Create a copy of ProjectResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,Object? createdByCoreUserId = null,Object? myRole = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? archivedAtUtc = freezed,}) {
  return _then(_ProjectResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,createdByCoreUserId: null == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String,myRole: freezed == myRole ? _self.myRole : myRole // ignore: cast_nullable_to_non_nullable
as ProjectRole?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
