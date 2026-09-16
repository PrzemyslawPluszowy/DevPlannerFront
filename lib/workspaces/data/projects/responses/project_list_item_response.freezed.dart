// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_list_item_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectListItemResponse {

/// UUID projektu.
 String get id;/// UUID workspace zawierającego projekt.
 String get workspaceId;/// Nazwa projektu.
 String get name;/// Opcjonalny opis projektu.
 String? get description;/// Opcjonalny identyfikator ikony projektu.
 String? get icon;/// Opcjonalny główny kolor projektu w formacie CSS.
 String? get primaryColor;/// Widoczność projektu.
 ProjectVisibility get visibility;/// Biznesowy status projektu.
 ProjectStatus get status;/// Rola bieżącego użytkownika albo null.
 ProjectRole? get myRole;/// Czy projekt jest przypięty przez bieżącego użytkownika.
 bool get isPinned;/// Osobista pozycja sortowania projektu albo null.
 int? get sortPosition;
/// Create a copy of ProjectListItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectListItemResponseCopyWith<ProjectListItemResponse> get copyWith => _$ProjectListItemResponseCopyWithImpl<ProjectListItemResponse>(this as ProjectListItemResponse, _$identity);

  /// Serializes this ProjectListItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectListItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&(identical(other.myRole, myRole) || other.myRole == myRole)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.sortPosition, sortPosition) || other.sortPosition == sortPosition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,name,description,icon,primaryColor,visibility,status,myRole,isPinned,sortPosition);

@override
String toString() {
  return 'ProjectListItemResponse(id: $id, workspaceId: $workspaceId, name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status, myRole: $myRole, isPinned: $isPinned, sortPosition: $sortPosition)';
}


}

/// @nodoc
abstract mixin class $ProjectListItemResponseCopyWith<$Res>  {
  factory $ProjectListItemResponseCopyWith(ProjectListItemResponse value, $Res Function(ProjectListItemResponse) _then) = _$ProjectListItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String name, String? description, String? icon, String? primaryColor, ProjectVisibility visibility, ProjectStatus status, ProjectRole? myRole, bool isPinned, int? sortPosition
});




}
/// @nodoc
class _$ProjectListItemResponseCopyWithImpl<$Res>
    implements $ProjectListItemResponseCopyWith<$Res> {
  _$ProjectListItemResponseCopyWithImpl(this._self, this._then);

  final ProjectListItemResponse _self;
  final $Res Function(ProjectListItemResponse) _then;

/// Create a copy of ProjectListItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,Object? myRole = freezed,Object? isPinned = null,Object? sortPosition = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,myRole: freezed == myRole ? _self.myRole : myRole // ignore: cast_nullable_to_non_nullable
as ProjectRole?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,sortPosition: freezed == sortPosition ? _self.sortPosition : sortPosition // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectListItemResponse].
extension ProjectListItemResponsePatterns on ProjectListItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectListItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectListItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectListItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectListItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectListItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectListItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  ProjectRole? myRole,  bool isPinned,  int? sortPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectListItemResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.myRole,_that.isPinned,_that.sortPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  ProjectRole? myRole,  bool isPinned,  int? sortPosition)  $default,) {final _that = this;
switch (_that) {
case _ProjectListItemResponse():
return $default(_that.id,_that.workspaceId,_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.myRole,_that.isPinned,_that.sortPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  ProjectRole? myRole,  bool isPinned,  int? sortPosition)?  $default,) {final _that = this;
switch (_that) {
case _ProjectListItemResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.myRole,_that.isPinned,_that.sortPosition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectListItemResponse implements ProjectListItemResponse {
  const _ProjectListItemResponse({required this.id, required this.workspaceId, required this.name, this.description, this.icon, this.primaryColor, required this.visibility, required this.status, this.myRole, required this.isPinned, this.sortPosition});
  factory _ProjectListItemResponse.fromJson(Map<String, dynamic> json) => _$ProjectListItemResponseFromJson(json);

/// UUID projektu.
@override final  String id;
/// UUID workspace zawierającego projekt.
@override final  String workspaceId;
/// Nazwa projektu.
@override final  String name;
/// Opcjonalny opis projektu.
@override final  String? description;
/// Opcjonalny identyfikator ikony projektu.
@override final  String? icon;
/// Opcjonalny główny kolor projektu w formacie CSS.
@override final  String? primaryColor;
/// Widoczność projektu.
@override final  ProjectVisibility visibility;
/// Biznesowy status projektu.
@override final  ProjectStatus status;
/// Rola bieżącego użytkownika albo null.
@override final  ProjectRole? myRole;
/// Czy projekt jest przypięty przez bieżącego użytkownika.
@override final  bool isPinned;
/// Osobista pozycja sortowania projektu albo null.
@override final  int? sortPosition;

/// Create a copy of ProjectListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectListItemResponseCopyWith<_ProjectListItemResponse> get copyWith => __$ProjectListItemResponseCopyWithImpl<_ProjectListItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectListItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectListItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&(identical(other.myRole, myRole) || other.myRole == myRole)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.sortPosition, sortPosition) || other.sortPosition == sortPosition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,name,description,icon,primaryColor,visibility,status,myRole,isPinned,sortPosition);

@override
String toString() {
  return 'ProjectListItemResponse(id: $id, workspaceId: $workspaceId, name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status, myRole: $myRole, isPinned: $isPinned, sortPosition: $sortPosition)';
}


}

/// @nodoc
abstract mixin class _$ProjectListItemResponseCopyWith<$Res> implements $ProjectListItemResponseCopyWith<$Res> {
  factory _$ProjectListItemResponseCopyWith(_ProjectListItemResponse value, $Res Function(_ProjectListItemResponse) _then) = __$ProjectListItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String name, String? description, String? icon, String? primaryColor, ProjectVisibility visibility, ProjectStatus status, ProjectRole? myRole, bool isPinned, int? sortPosition
});




}
/// @nodoc
class __$ProjectListItemResponseCopyWithImpl<$Res>
    implements _$ProjectListItemResponseCopyWith<$Res> {
  __$ProjectListItemResponseCopyWithImpl(this._self, this._then);

  final _ProjectListItemResponse _self;
  final $Res Function(_ProjectListItemResponse) _then;

/// Create a copy of ProjectListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,Object? myRole = freezed,Object? isPinned = null,Object? sortPosition = freezed,}) {
  return _then(_ProjectListItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,myRole: freezed == myRole ? _self.myRole : myRole // ignore: cast_nullable_to_non_nullable
as ProjectRole?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,sortPosition: freezed == sortPosition ? _self.sortPosition : sortPosition // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
