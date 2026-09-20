// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_setup_request_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectSetupSourceRequest {

/// `Blank` albo `ProjectTemplate`.
 ProjectSetupSourceKind get kind;/// UUID szablonu; wymagany wyłącznie dla `kind = projectTemplate`.
 String? get templateId;/// Wersja szablonu z ostatniego odczytu; niezgodność zwraca 409.
 int? get expectedVersion;
/// Create a copy of ProjectSetupSourceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupSourceRequestCopyWith<ProjectSetupSourceRequest> get copyWith => _$ProjectSetupSourceRequestCopyWithImpl<ProjectSetupSourceRequest>(this as ProjectSetupSourceRequest, _$identity);

  /// Serializes this ProjectSetupSourceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupSourceRequest&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,templateId,expectedVersion);

@override
String toString() {
  return 'ProjectSetupSourceRequest(kind: $kind, templateId: $templateId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupSourceRequestCopyWith<$Res>  {
  factory $ProjectSetupSourceRequestCopyWith(ProjectSetupSourceRequest value, $Res Function(ProjectSetupSourceRequest) _then) = _$ProjectSetupSourceRequestCopyWithImpl;
@useResult
$Res call({
 ProjectSetupSourceKind kind, String? templateId, int? expectedVersion
});




}
/// @nodoc
class _$ProjectSetupSourceRequestCopyWithImpl<$Res>
    implements $ProjectSetupSourceRequestCopyWith<$Res> {
  _$ProjectSetupSourceRequestCopyWithImpl(this._self, this._then);

  final ProjectSetupSourceRequest _self;
  final $Res Function(ProjectSetupSourceRequest) _then;

/// Create a copy of ProjectSetupSourceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? templateId = freezed,Object? expectedVersion = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProjectSetupSourceKind,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: freezed == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupSourceRequest].
extension ProjectSetupSourceRequestPatterns on ProjectSetupSourceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupSourceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupSourceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupSourceRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupSourceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupSourceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupSourceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectSetupSourceKind kind,  String? templateId,  int? expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupSourceRequest() when $default != null:
return $default(_that.kind,_that.templateId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectSetupSourceKind kind,  String? templateId,  int? expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupSourceRequest():
return $default(_that.kind,_that.templateId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectSetupSourceKind kind,  String? templateId,  int? expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupSourceRequest() when $default != null:
return $default(_that.kind,_that.templateId,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupSourceRequest implements ProjectSetupSourceRequest {
  const _ProjectSetupSourceRequest({required this.kind, this.templateId, this.expectedVersion});
  factory _ProjectSetupSourceRequest.fromJson(Map<String, dynamic> json) => _$ProjectSetupSourceRequestFromJson(json);

/// `Blank` albo `ProjectTemplate`.
@override final  ProjectSetupSourceKind kind;
/// UUID szablonu; wymagany wyłącznie dla `kind = projectTemplate`.
@override final  String? templateId;
/// Wersja szablonu z ostatniego odczytu; niezgodność zwraca 409.
@override final  int? expectedVersion;

/// Create a copy of ProjectSetupSourceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupSourceRequestCopyWith<_ProjectSetupSourceRequest> get copyWith => __$ProjectSetupSourceRequestCopyWithImpl<_ProjectSetupSourceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupSourceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupSourceRequest&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,templateId,expectedVersion);

@override
String toString() {
  return 'ProjectSetupSourceRequest(kind: $kind, templateId: $templateId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupSourceRequestCopyWith<$Res> implements $ProjectSetupSourceRequestCopyWith<$Res> {
  factory _$ProjectSetupSourceRequestCopyWith(_ProjectSetupSourceRequest value, $Res Function(_ProjectSetupSourceRequest) _then) = __$ProjectSetupSourceRequestCopyWithImpl;
@override @useResult
$Res call({
 ProjectSetupSourceKind kind, String? templateId, int? expectedVersion
});




}
/// @nodoc
class __$ProjectSetupSourceRequestCopyWithImpl<$Res>
    implements _$ProjectSetupSourceRequestCopyWith<$Res> {
  __$ProjectSetupSourceRequestCopyWithImpl(this._self, this._then);

  final _ProjectSetupSourceRequest _self;
  final $Res Function(_ProjectSetupSourceRequest) _then;

/// Create a copy of ProjectSetupSourceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? templateId = freezed,Object? expectedVersion = freezed,}) {
  return _then(_ProjectSetupSourceRequest(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProjectSetupSourceKind,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: freezed == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupProjectRequest {

/// Nazwa projektu od 1 do 160 znaków.
 String get name;/// Opis projektu do 4000 znaków.
 String? get description;/// Identyfikator ikony prezentacyjnej projektu.
 String? get icon;/// Kolor główny w formacie `#RRGGBB` albo `#RRGGBBAA`.
 String? get primaryColor;/// Widoczność projektu.
 ProjectVisibility? get visibility;/// Stan projektu.
 ProjectStatus? get status;
/// Create a copy of ProjectSetupProjectRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupProjectRequestCopyWith<ProjectSetupProjectRequest> get copyWith => _$ProjectSetupProjectRequestCopyWithImpl<ProjectSetupProjectRequest>(this as ProjectSetupProjectRequest, _$identity);

  /// Serializes this ProjectSetupProjectRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupProjectRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor,visibility,status);

@override
String toString() {
  return 'ProjectSetupProjectRequest(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupProjectRequestCopyWith<$Res>  {
  factory $ProjectSetupProjectRequestCopyWith(ProjectSetupProjectRequest value, $Res Function(ProjectSetupProjectRequest) _then) = _$ProjectSetupProjectRequestCopyWithImpl;
@useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor, ProjectVisibility? visibility, ProjectStatus? status
});




}
/// @nodoc
class _$ProjectSetupProjectRequestCopyWithImpl<$Res>
    implements $ProjectSetupProjectRequestCopyWith<$Res> {
  _$ProjectSetupProjectRequestCopyWithImpl(this._self, this._then);

  final ProjectSetupProjectRequest _self;
  final $Res Function(ProjectSetupProjectRequest) _then;

/// Create a copy of ProjectSetupProjectRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: freezed == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupProjectRequest].
extension ProjectSetupProjectRequestPatterns on ProjectSetupProjectRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupProjectRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupProjectRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupProjectRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupProjectRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupProjectRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupProjectRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility? visibility,  ProjectStatus? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupProjectRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility? visibility,  ProjectStatus? status)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupProjectRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility? visibility,  ProjectStatus? status)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupProjectRequest() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupProjectRequest implements ProjectSetupProjectRequest {
  const _ProjectSetupProjectRequest({required this.name, this.description, this.icon, this.primaryColor, this.visibility, this.status});
  factory _ProjectSetupProjectRequest.fromJson(Map<String, dynamic> json) => _$ProjectSetupProjectRequestFromJson(json);

/// Nazwa projektu od 1 do 160 znaków.
@override final  String name;
/// Opis projektu do 4000 znaków.
@override final  String? description;
/// Identyfikator ikony prezentacyjnej projektu.
@override final  String? icon;
/// Kolor główny w formacie `#RRGGBB` albo `#RRGGBBAA`.
@override final  String? primaryColor;
/// Widoczność projektu.
@override final  ProjectVisibility? visibility;
/// Stan projektu.
@override final  ProjectStatus? status;

/// Create a copy of ProjectSetupProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupProjectRequestCopyWith<_ProjectSetupProjectRequest> get copyWith => __$ProjectSetupProjectRequestCopyWithImpl<_ProjectSetupProjectRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupProjectRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupProjectRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor,visibility,status);

@override
String toString() {
  return 'ProjectSetupProjectRequest(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupProjectRequestCopyWith<$Res> implements $ProjectSetupProjectRequestCopyWith<$Res> {
  factory _$ProjectSetupProjectRequestCopyWith(_ProjectSetupProjectRequest value, $Res Function(_ProjectSetupProjectRequest) _then) = __$ProjectSetupProjectRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor, ProjectVisibility? visibility, ProjectStatus? status
});




}
/// @nodoc
class __$ProjectSetupProjectRequestCopyWithImpl<$Res>
    implements _$ProjectSetupProjectRequestCopyWith<$Res> {
  __$ProjectSetupProjectRequestCopyWithImpl(this._self, this._then);

  final _ProjectSetupProjectRequest _self;
  final $Res Function(_ProjectSetupProjectRequest) _then;

/// Create a copy of ProjectSetupProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = freezed,Object? status = freezed,}) {
  return _then(_ProjectSetupProjectRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: freezed == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus?,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupMemberAssignmentRequest {

/// UUID lokalnego użytkownika z aktywnym członkostwem w workspace.
 String get userId;/// Rola nadawana w projekcie.
 ProjectRole get role;
/// Create a copy of ProjectSetupMemberAssignmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupMemberAssignmentRequestCopyWith<ProjectSetupMemberAssignmentRequest> get copyWith => _$ProjectSetupMemberAssignmentRequestCopyWithImpl<ProjectSetupMemberAssignmentRequest>(this as ProjectSetupMemberAssignmentRequest, _$identity);

  /// Serializes this ProjectSetupMemberAssignmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupMemberAssignmentRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,role);

@override
String toString() {
  return 'ProjectSetupMemberAssignmentRequest(userId: $userId, role: $role)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupMemberAssignmentRequestCopyWith<$Res>  {
  factory $ProjectSetupMemberAssignmentRequestCopyWith(ProjectSetupMemberAssignmentRequest value, $Res Function(ProjectSetupMemberAssignmentRequest) _then) = _$ProjectSetupMemberAssignmentRequestCopyWithImpl;
@useResult
$Res call({
 String userId, ProjectRole role
});




}
/// @nodoc
class _$ProjectSetupMemberAssignmentRequestCopyWithImpl<$Res>
    implements $ProjectSetupMemberAssignmentRequestCopyWith<$Res> {
  _$ProjectSetupMemberAssignmentRequestCopyWithImpl(this._self, this._then);

  final ProjectSetupMemberAssignmentRequest _self;
  final $Res Function(ProjectSetupMemberAssignmentRequest) _then;

/// Create a copy of ProjectSetupMemberAssignmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? role = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupMemberAssignmentRequest].
extension ProjectSetupMemberAssignmentRequestPatterns on ProjectSetupMemberAssignmentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupMemberAssignmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupMemberAssignmentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupMemberAssignmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupMemberAssignmentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupMemberAssignmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupMemberAssignmentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  ProjectRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupMemberAssignmentRequest() when $default != null:
return $default(_that.userId,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  ProjectRole role)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupMemberAssignmentRequest():
return $default(_that.userId,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  ProjectRole role)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupMemberAssignmentRequest() when $default != null:
return $default(_that.userId,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupMemberAssignmentRequest implements ProjectSetupMemberAssignmentRequest {
  const _ProjectSetupMemberAssignmentRequest({required this.userId, required this.role});
  factory _ProjectSetupMemberAssignmentRequest.fromJson(Map<String, dynamic> json) => _$ProjectSetupMemberAssignmentRequestFromJson(json);

/// UUID lokalnego użytkownika z aktywnym członkostwem w workspace.
@override final  String userId;
/// Rola nadawana w projekcie.
@override final  ProjectRole role;

/// Create a copy of ProjectSetupMemberAssignmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupMemberAssignmentRequestCopyWith<_ProjectSetupMemberAssignmentRequest> get copyWith => __$ProjectSetupMemberAssignmentRequestCopyWithImpl<_ProjectSetupMemberAssignmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupMemberAssignmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupMemberAssignmentRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,role);

@override
String toString() {
  return 'ProjectSetupMemberAssignmentRequest(userId: $userId, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupMemberAssignmentRequestCopyWith<$Res> implements $ProjectSetupMemberAssignmentRequestCopyWith<$Res> {
  factory _$ProjectSetupMemberAssignmentRequestCopyWith(_ProjectSetupMemberAssignmentRequest value, $Res Function(_ProjectSetupMemberAssignmentRequest) _then) = __$ProjectSetupMemberAssignmentRequestCopyWithImpl;
@override @useResult
$Res call({
 String userId, ProjectRole role
});




}
/// @nodoc
class __$ProjectSetupMemberAssignmentRequestCopyWithImpl<$Res>
    implements _$ProjectSetupMemberAssignmentRequestCopyWith<$Res> {
  __$ProjectSetupMemberAssignmentRequestCopyWithImpl(this._self, this._then);

  final _ProjectSetupMemberAssignmentRequest _self;
  final $Res Function(_ProjectSetupMemberAssignmentRequest) _then;

/// Create a copy of ProjectSetupMemberAssignmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? role = null,}) {
  return _then(_ProjectSetupMemberAssignmentRequest(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupWorkflowRequest {

/// `Default`, `CatalogTemplate` albo `ExplicitStatuses`.
 ProjectSetupWorkflowKind get kind;/// Klucz katalogowego szablonu; wymagany dla `catalogTemplate`.
 String? get templateKey;/// Jawne statusy; wymagane dla `explicitStatuses`.
 List<ProjectSetupWorkflowStatusRequest>? get statuses;
/// Create a copy of ProjectSetupWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowRequestCopyWith<ProjectSetupWorkflowRequest> get copyWith => _$ProjectSetupWorkflowRequestCopyWithImpl<ProjectSetupWorkflowRequest>(this as ProjectSetupWorkflowRequest, _$identity);

  /// Serializes this ProjectSetupWorkflowRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupWorkflowRequest&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&const DeepCollectionEquality().equals(other.statuses, statuses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,templateKey,const DeepCollectionEquality().hash(statuses));

@override
String toString() {
  return 'ProjectSetupWorkflowRequest(kind: $kind, templateKey: $templateKey, statuses: $statuses)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupWorkflowRequestCopyWith<$Res>  {
  factory $ProjectSetupWorkflowRequestCopyWith(ProjectSetupWorkflowRequest value, $Res Function(ProjectSetupWorkflowRequest) _then) = _$ProjectSetupWorkflowRequestCopyWithImpl;
@useResult
$Res call({
 ProjectSetupWorkflowKind kind, String? templateKey, List<ProjectSetupWorkflowStatusRequest>? statuses
});




}
/// @nodoc
class _$ProjectSetupWorkflowRequestCopyWithImpl<$Res>
    implements $ProjectSetupWorkflowRequestCopyWith<$Res> {
  _$ProjectSetupWorkflowRequestCopyWithImpl(this._self, this._then);

  final ProjectSetupWorkflowRequest _self;
  final $Res Function(ProjectSetupWorkflowRequest) _then;

/// Create a copy of ProjectSetupWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? templateKey = freezed,Object? statuses = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowKind,templateKey: freezed == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String?,statuses: freezed == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupWorkflowStatusRequest>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupWorkflowRequest].
extension ProjectSetupWorkflowRequestPatterns on ProjectSetupWorkflowRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupWorkflowRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupWorkflowRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupWorkflowRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectSetupWorkflowKind kind,  String? templateKey,  List<ProjectSetupWorkflowStatusRequest>? statuses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowRequest() when $default != null:
return $default(_that.kind,_that.templateKey,_that.statuses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectSetupWorkflowKind kind,  String? templateKey,  List<ProjectSetupWorkflowStatusRequest>? statuses)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowRequest():
return $default(_that.kind,_that.templateKey,_that.statuses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectSetupWorkflowKind kind,  String? templateKey,  List<ProjectSetupWorkflowStatusRequest>? statuses)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowRequest() when $default != null:
return $default(_that.kind,_that.templateKey,_that.statuses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupWorkflowRequest implements ProjectSetupWorkflowRequest {
  const _ProjectSetupWorkflowRequest({required this.kind, this.templateKey, this.statuses});
  factory _ProjectSetupWorkflowRequest.fromJson(Map<String, dynamic> json) => _$ProjectSetupWorkflowRequestFromJson(json);

/// `Default`, `CatalogTemplate` albo `ExplicitStatuses`.
@override final  ProjectSetupWorkflowKind kind;
/// Klucz katalogowego szablonu; wymagany dla `catalogTemplate`.
@override final  String? templateKey;
/// Jawne statusy; wymagane dla `explicitStatuses`.
@override final  List<ProjectSetupWorkflowStatusRequest>? statuses;

/// Create a copy of ProjectSetupWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupWorkflowRequestCopyWith<_ProjectSetupWorkflowRequest> get copyWith => __$ProjectSetupWorkflowRequestCopyWithImpl<_ProjectSetupWorkflowRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupWorkflowRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupWorkflowRequest&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&const DeepCollectionEquality().equals(other.statuses, statuses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,templateKey,const DeepCollectionEquality().hash(statuses));

@override
String toString() {
  return 'ProjectSetupWorkflowRequest(kind: $kind, templateKey: $templateKey, statuses: $statuses)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupWorkflowRequestCopyWith<$Res> implements $ProjectSetupWorkflowRequestCopyWith<$Res> {
  factory _$ProjectSetupWorkflowRequestCopyWith(_ProjectSetupWorkflowRequest value, $Res Function(_ProjectSetupWorkflowRequest) _then) = __$ProjectSetupWorkflowRequestCopyWithImpl;
@override @useResult
$Res call({
 ProjectSetupWorkflowKind kind, String? templateKey, List<ProjectSetupWorkflowStatusRequest>? statuses
});




}
/// @nodoc
class __$ProjectSetupWorkflowRequestCopyWithImpl<$Res>
    implements _$ProjectSetupWorkflowRequestCopyWith<$Res> {
  __$ProjectSetupWorkflowRequestCopyWithImpl(this._self, this._then);

  final _ProjectSetupWorkflowRequest _self;
  final $Res Function(_ProjectSetupWorkflowRequest) _then;

/// Create a copy of ProjectSetupWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? templateKey = freezed,Object? statuses = freezed,}) {
  return _then(_ProjectSetupWorkflowRequest(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowKind,templateKey: freezed == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String?,statuses: freezed == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupWorkflowStatusRequest>?,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupWorkflowStatusRequest {

/// Nazwa kolumny do 60 znaków.
 String get name;/// Kolor kolumny w formacie `#RRGGBB` albo `#RRGGBBAA`.
 String get color;/// Kategoria analityczna kolumny.
 TaskStatusCategory get category;/// Opcjonalny limit WIP w zakresie 1-999.
 int? get wipLimit;/// Czy status jest domyślny dla nowych zadań.
 bool get isDefault;
/// Create a copy of ProjectSetupWorkflowStatusRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowStatusRequestCopyWith<ProjectSetupWorkflowStatusRequest> get copyWith => _$ProjectSetupWorkflowStatusRequestCopyWithImpl<ProjectSetupWorkflowStatusRequest>(this as ProjectSetupWorkflowStatusRequest, _$identity);

  /// Serializes this ProjectSetupWorkflowStatusRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupWorkflowStatusRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.category, category) || other.category == category)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,color,category,wipLimit,isDefault);

@override
String toString() {
  return 'ProjectSetupWorkflowStatusRequest(name: $name, color: $color, category: $category, wipLimit: $wipLimit, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupWorkflowStatusRequestCopyWith<$Res>  {
  factory $ProjectSetupWorkflowStatusRequestCopyWith(ProjectSetupWorkflowStatusRequest value, $Res Function(ProjectSetupWorkflowStatusRequest) _then) = _$ProjectSetupWorkflowStatusRequestCopyWithImpl;
@useResult
$Res call({
 String name, String color, TaskStatusCategory category, int? wipLimit, bool isDefault
});




}
/// @nodoc
class _$ProjectSetupWorkflowStatusRequestCopyWithImpl<$Res>
    implements $ProjectSetupWorkflowStatusRequestCopyWith<$Res> {
  _$ProjectSetupWorkflowStatusRequestCopyWithImpl(this._self, this._then);

  final ProjectSetupWorkflowStatusRequest _self;
  final $Res Function(ProjectSetupWorkflowStatusRequest) _then;

/// Create a copy of ProjectSetupWorkflowStatusRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? color = null,Object? category = null,Object? wipLimit = freezed,Object? isDefault = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupWorkflowStatusRequest].
extension ProjectSetupWorkflowStatusRequestPatterns on ProjectSetupWorkflowStatusRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupWorkflowStatusRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupWorkflowStatusRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupWorkflowStatusRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String color,  TaskStatusCategory category,  int? wipLimit,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusRequest() when $default != null:
return $default(_that.name,_that.color,_that.category,_that.wipLimit,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String color,  TaskStatusCategory category,  int? wipLimit,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusRequest():
return $default(_that.name,_that.color,_that.category,_that.wipLimit,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String color,  TaskStatusCategory category,  int? wipLimit,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusRequest() when $default != null:
return $default(_that.name,_that.color,_that.category,_that.wipLimit,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupWorkflowStatusRequest implements ProjectSetupWorkflowStatusRequest {
  const _ProjectSetupWorkflowStatusRequest({required this.name, required this.color, required this.category, this.wipLimit, required this.isDefault});
  factory _ProjectSetupWorkflowStatusRequest.fromJson(Map<String, dynamic> json) => _$ProjectSetupWorkflowStatusRequestFromJson(json);

/// Nazwa kolumny do 60 znaków.
@override final  String name;
/// Kolor kolumny w formacie `#RRGGBB` albo `#RRGGBBAA`.
@override final  String color;
/// Kategoria analityczna kolumny.
@override final  TaskStatusCategory category;
/// Opcjonalny limit WIP w zakresie 1-999.
@override final  int? wipLimit;
/// Czy status jest domyślny dla nowych zadań.
@override final  bool isDefault;

/// Create a copy of ProjectSetupWorkflowStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupWorkflowStatusRequestCopyWith<_ProjectSetupWorkflowStatusRequest> get copyWith => __$ProjectSetupWorkflowStatusRequestCopyWithImpl<_ProjectSetupWorkflowStatusRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupWorkflowStatusRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupWorkflowStatusRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.category, category) || other.category == category)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,color,category,wipLimit,isDefault);

@override
String toString() {
  return 'ProjectSetupWorkflowStatusRequest(name: $name, color: $color, category: $category, wipLimit: $wipLimit, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupWorkflowStatusRequestCopyWith<$Res> implements $ProjectSetupWorkflowStatusRequestCopyWith<$Res> {
  factory _$ProjectSetupWorkflowStatusRequestCopyWith(_ProjectSetupWorkflowStatusRequest value, $Res Function(_ProjectSetupWorkflowStatusRequest) _then) = __$ProjectSetupWorkflowStatusRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String color, TaskStatusCategory category, int? wipLimit, bool isDefault
});




}
/// @nodoc
class __$ProjectSetupWorkflowStatusRequestCopyWithImpl<$Res>
    implements _$ProjectSetupWorkflowStatusRequestCopyWith<$Res> {
  __$ProjectSetupWorkflowStatusRequestCopyWithImpl(this._self, this._then);

  final _ProjectSetupWorkflowStatusRequest _self;
  final $Res Function(_ProjectSetupWorkflowStatusRequest) _then;

/// Create a copy of ProjectSetupWorkflowStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? color = null,Object? category = null,Object? wipLimit = freezed,Object? isDefault = null,}) {
  return _then(_ProjectSetupWorkflowStatusRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupTaskViewRequest {

/// Domyślny widok modułu Zadania.
 ProjectSetupTaskViewKind get defaultView;/// Opcjonalne ustawienia polityki listy zadań.
 ProjectSetupListSettingsRequest? get list;/// Opcjonalne ustawienia tablicy Kanban.
 ProjectSetupBoardSettingsRequest? get board;
/// Create a copy of ProjectSetupTaskViewRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupTaskViewRequestCopyWith<ProjectSetupTaskViewRequest> get copyWith => _$ProjectSetupTaskViewRequestCopyWithImpl<ProjectSetupTaskViewRequest>(this as ProjectSetupTaskViewRequest, _$identity);

  /// Serializes this ProjectSetupTaskViewRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupTaskViewRequest&&(identical(other.defaultView, defaultView) || other.defaultView == defaultView)&&(identical(other.list, list) || other.list == list)&&(identical(other.board, board) || other.board == board));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultView,list,board);

@override
String toString() {
  return 'ProjectSetupTaskViewRequest(defaultView: $defaultView, list: $list, board: $board)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupTaskViewRequestCopyWith<$Res>  {
  factory $ProjectSetupTaskViewRequestCopyWith(ProjectSetupTaskViewRequest value, $Res Function(ProjectSetupTaskViewRequest) _then) = _$ProjectSetupTaskViewRequestCopyWithImpl;
@useResult
$Res call({
 ProjectSetupTaskViewKind defaultView, ProjectSetupListSettingsRequest? list, ProjectSetupBoardSettingsRequest? board
});


$ProjectSetupListSettingsRequestCopyWith<$Res>? get list;$ProjectSetupBoardSettingsRequestCopyWith<$Res>? get board;

}
/// @nodoc
class _$ProjectSetupTaskViewRequestCopyWithImpl<$Res>
    implements $ProjectSetupTaskViewRequestCopyWith<$Res> {
  _$ProjectSetupTaskViewRequestCopyWithImpl(this._self, this._then);

  final ProjectSetupTaskViewRequest _self;
  final $Res Function(ProjectSetupTaskViewRequest) _then;

/// Create a copy of ProjectSetupTaskViewRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultView = null,Object? list = freezed,Object? board = freezed,}) {
  return _then(_self.copyWith(
defaultView: null == defaultView ? _self.defaultView : defaultView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewKind,list: freezed == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as ProjectSetupListSettingsRequest?,board: freezed == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as ProjectSetupBoardSettingsRequest?,
  ));
}
/// Create a copy of ProjectSetupTaskViewRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupListSettingsRequestCopyWith<$Res>? get list {
    if (_self.list == null) {
    return null;
  }

  return $ProjectSetupListSettingsRequestCopyWith<$Res>(_self.list!, (value) {
    return _then(_self.copyWith(list: value));
  });
}/// Create a copy of ProjectSetupTaskViewRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupBoardSettingsRequestCopyWith<$Res>? get board {
    if (_self.board == null) {
    return null;
  }

  return $ProjectSetupBoardSettingsRequestCopyWith<$Res>(_self.board!, (value) {
    return _then(_self.copyWith(board: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectSetupTaskViewRequest].
extension ProjectSetupTaskViewRequestPatterns on ProjectSetupTaskViewRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupTaskViewRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupTaskViewRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupTaskViewRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupTaskViewRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupTaskViewRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupTaskViewRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectSetupTaskViewKind defaultView,  ProjectSetupListSettingsRequest? list,  ProjectSetupBoardSettingsRequest? board)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupTaskViewRequest() when $default != null:
return $default(_that.defaultView,_that.list,_that.board);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectSetupTaskViewKind defaultView,  ProjectSetupListSettingsRequest? list,  ProjectSetupBoardSettingsRequest? board)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupTaskViewRequest():
return $default(_that.defaultView,_that.list,_that.board);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectSetupTaskViewKind defaultView,  ProjectSetupListSettingsRequest? list,  ProjectSetupBoardSettingsRequest? board)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupTaskViewRequest() when $default != null:
return $default(_that.defaultView,_that.list,_that.board);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupTaskViewRequest implements ProjectSetupTaskViewRequest {
  const _ProjectSetupTaskViewRequest({required this.defaultView, this.list, this.board});
  factory _ProjectSetupTaskViewRequest.fromJson(Map<String, dynamic> json) => _$ProjectSetupTaskViewRequestFromJson(json);

/// Domyślny widok modułu Zadania.
@override final  ProjectSetupTaskViewKind defaultView;
/// Opcjonalne ustawienia polityki listy zadań.
@override final  ProjectSetupListSettingsRequest? list;
/// Opcjonalne ustawienia tablicy Kanban.
@override final  ProjectSetupBoardSettingsRequest? board;

/// Create a copy of ProjectSetupTaskViewRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupTaskViewRequestCopyWith<_ProjectSetupTaskViewRequest> get copyWith => __$ProjectSetupTaskViewRequestCopyWithImpl<_ProjectSetupTaskViewRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupTaskViewRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupTaskViewRequest&&(identical(other.defaultView, defaultView) || other.defaultView == defaultView)&&(identical(other.list, list) || other.list == list)&&(identical(other.board, board) || other.board == board));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultView,list,board);

@override
String toString() {
  return 'ProjectSetupTaskViewRequest(defaultView: $defaultView, list: $list, board: $board)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupTaskViewRequestCopyWith<$Res> implements $ProjectSetupTaskViewRequestCopyWith<$Res> {
  factory _$ProjectSetupTaskViewRequestCopyWith(_ProjectSetupTaskViewRequest value, $Res Function(_ProjectSetupTaskViewRequest) _then) = __$ProjectSetupTaskViewRequestCopyWithImpl;
@override @useResult
$Res call({
 ProjectSetupTaskViewKind defaultView, ProjectSetupListSettingsRequest? list, ProjectSetupBoardSettingsRequest? board
});


@override $ProjectSetupListSettingsRequestCopyWith<$Res>? get list;@override $ProjectSetupBoardSettingsRequestCopyWith<$Res>? get board;

}
/// @nodoc
class __$ProjectSetupTaskViewRequestCopyWithImpl<$Res>
    implements _$ProjectSetupTaskViewRequestCopyWith<$Res> {
  __$ProjectSetupTaskViewRequestCopyWithImpl(this._self, this._then);

  final _ProjectSetupTaskViewRequest _self;
  final $Res Function(_ProjectSetupTaskViewRequest) _then;

/// Create a copy of ProjectSetupTaskViewRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultView = null,Object? list = freezed,Object? board = freezed,}) {
  return _then(_ProjectSetupTaskViewRequest(
defaultView: null == defaultView ? _self.defaultView : defaultView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewKind,list: freezed == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as ProjectSetupListSettingsRequest?,board: freezed == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as ProjectSetupBoardSettingsRequest?,
  ));
}

/// Create a copy of ProjectSetupTaskViewRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupListSettingsRequestCopyWith<$Res>? get list {
    if (_self.list == null) {
    return null;
  }

  return $ProjectSetupListSettingsRequestCopyWith<$Res>(_self.list!, (value) {
    return _then(_self.copyWith(list: value));
  });
}/// Create a copy of ProjectSetupTaskViewRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupBoardSettingsRequestCopyWith<$Res>? get board {
    if (_self.board == null) {
    return null;
  }

  return $ProjectSetupBoardSettingsRequestCopyWith<$Res>(_self.board!, (value) {
    return _then(_self.copyWith(board: value));
  });
}
}


/// @nodoc
mixin _$ProjectSetupListSettingsRequest {

/// Domyślna kolejność kolumn listy.
 List<String>? get defaultColumns;/// Domyślne pole sortowania listy.
 TaskSavedViewSortField? get defaultSortField;/// Domyślny kierunek sortowania listy.
 TaskSavedViewSortDirection? get defaultSortDirection;/// Domyślny sposób grupowania listy.
 TaskSavedViewGroupBy? get defaultGroupBy;
/// Create a copy of ProjectSetupListSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupListSettingsRequestCopyWith<ProjectSetupListSettingsRequest> get copyWith => _$ProjectSetupListSettingsRequestCopyWithImpl<ProjectSetupListSettingsRequest>(this as ProjectSetupListSettingsRequest, _$identity);

  /// Serializes this ProjectSetupListSettingsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupListSettingsRequest&&const DeepCollectionEquality().equals(other.defaultColumns, defaultColumns)&&(identical(other.defaultSortField, defaultSortField) || other.defaultSortField == defaultSortField)&&(identical(other.defaultSortDirection, defaultSortDirection) || other.defaultSortDirection == defaultSortDirection)&&(identical(other.defaultGroupBy, defaultGroupBy) || other.defaultGroupBy == defaultGroupBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(defaultColumns),defaultSortField,defaultSortDirection,defaultGroupBy);

@override
String toString() {
  return 'ProjectSetupListSettingsRequest(defaultColumns: $defaultColumns, defaultSortField: $defaultSortField, defaultSortDirection: $defaultSortDirection, defaultGroupBy: $defaultGroupBy)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupListSettingsRequestCopyWith<$Res>  {
  factory $ProjectSetupListSettingsRequestCopyWith(ProjectSetupListSettingsRequest value, $Res Function(ProjectSetupListSettingsRequest) _then) = _$ProjectSetupListSettingsRequestCopyWithImpl;
@useResult
$Res call({
 List<String>? defaultColumns, TaskSavedViewSortField? defaultSortField, TaskSavedViewSortDirection? defaultSortDirection, TaskSavedViewGroupBy? defaultGroupBy
});




}
/// @nodoc
class _$ProjectSetupListSettingsRequestCopyWithImpl<$Res>
    implements $ProjectSetupListSettingsRequestCopyWith<$Res> {
  _$ProjectSetupListSettingsRequestCopyWithImpl(this._self, this._then);

  final ProjectSetupListSettingsRequest _self;
  final $Res Function(ProjectSetupListSettingsRequest) _then;

/// Create a copy of ProjectSetupListSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultColumns = freezed,Object? defaultSortField = freezed,Object? defaultSortDirection = freezed,Object? defaultGroupBy = freezed,}) {
  return _then(_self.copyWith(
defaultColumns: freezed == defaultColumns ? _self.defaultColumns : defaultColumns // ignore: cast_nullable_to_non_nullable
as List<String>?,defaultSortField: freezed == defaultSortField ? _self.defaultSortField : defaultSortField // ignore: cast_nullable_to_non_nullable
as TaskSavedViewSortField?,defaultSortDirection: freezed == defaultSortDirection ? _self.defaultSortDirection : defaultSortDirection // ignore: cast_nullable_to_non_nullable
as TaskSavedViewSortDirection?,defaultGroupBy: freezed == defaultGroupBy ? _self.defaultGroupBy : defaultGroupBy // ignore: cast_nullable_to_non_nullable
as TaskSavedViewGroupBy?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupListSettingsRequest].
extension ProjectSetupListSettingsRequestPatterns on ProjectSetupListSettingsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupListSettingsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupListSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupListSettingsRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupListSettingsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupListSettingsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupListSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String>? defaultColumns,  TaskSavedViewSortField? defaultSortField,  TaskSavedViewSortDirection? defaultSortDirection,  TaskSavedViewGroupBy? defaultGroupBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupListSettingsRequest() when $default != null:
return $default(_that.defaultColumns,_that.defaultSortField,_that.defaultSortDirection,_that.defaultGroupBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String>? defaultColumns,  TaskSavedViewSortField? defaultSortField,  TaskSavedViewSortDirection? defaultSortDirection,  TaskSavedViewGroupBy? defaultGroupBy)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupListSettingsRequest():
return $default(_that.defaultColumns,_that.defaultSortField,_that.defaultSortDirection,_that.defaultGroupBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String>? defaultColumns,  TaskSavedViewSortField? defaultSortField,  TaskSavedViewSortDirection? defaultSortDirection,  TaskSavedViewGroupBy? defaultGroupBy)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupListSettingsRequest() when $default != null:
return $default(_that.defaultColumns,_that.defaultSortField,_that.defaultSortDirection,_that.defaultGroupBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupListSettingsRequest implements ProjectSetupListSettingsRequest {
  const _ProjectSetupListSettingsRequest({this.defaultColumns, this.defaultSortField, this.defaultSortDirection, this.defaultGroupBy});
  factory _ProjectSetupListSettingsRequest.fromJson(Map<String, dynamic> json) => _$ProjectSetupListSettingsRequestFromJson(json);

/// Domyślna kolejność kolumn listy.
@override final  List<String>? defaultColumns;
/// Domyślne pole sortowania listy.
@override final  TaskSavedViewSortField? defaultSortField;
/// Domyślny kierunek sortowania listy.
@override final  TaskSavedViewSortDirection? defaultSortDirection;
/// Domyślny sposób grupowania listy.
@override final  TaskSavedViewGroupBy? defaultGroupBy;

/// Create a copy of ProjectSetupListSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupListSettingsRequestCopyWith<_ProjectSetupListSettingsRequest> get copyWith => __$ProjectSetupListSettingsRequestCopyWithImpl<_ProjectSetupListSettingsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupListSettingsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupListSettingsRequest&&const DeepCollectionEquality().equals(other.defaultColumns, defaultColumns)&&(identical(other.defaultSortField, defaultSortField) || other.defaultSortField == defaultSortField)&&(identical(other.defaultSortDirection, defaultSortDirection) || other.defaultSortDirection == defaultSortDirection)&&(identical(other.defaultGroupBy, defaultGroupBy) || other.defaultGroupBy == defaultGroupBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(defaultColumns),defaultSortField,defaultSortDirection,defaultGroupBy);

@override
String toString() {
  return 'ProjectSetupListSettingsRequest(defaultColumns: $defaultColumns, defaultSortField: $defaultSortField, defaultSortDirection: $defaultSortDirection, defaultGroupBy: $defaultGroupBy)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupListSettingsRequestCopyWith<$Res> implements $ProjectSetupListSettingsRequestCopyWith<$Res> {
  factory _$ProjectSetupListSettingsRequestCopyWith(_ProjectSetupListSettingsRequest value, $Res Function(_ProjectSetupListSettingsRequest) _then) = __$ProjectSetupListSettingsRequestCopyWithImpl;
@override @useResult
$Res call({
 List<String>? defaultColumns, TaskSavedViewSortField? defaultSortField, TaskSavedViewSortDirection? defaultSortDirection, TaskSavedViewGroupBy? defaultGroupBy
});




}
/// @nodoc
class __$ProjectSetupListSettingsRequestCopyWithImpl<$Res>
    implements _$ProjectSetupListSettingsRequestCopyWith<$Res> {
  __$ProjectSetupListSettingsRequestCopyWithImpl(this._self, this._then);

  final _ProjectSetupListSettingsRequest _self;
  final $Res Function(_ProjectSetupListSettingsRequest) _then;

/// Create a copy of ProjectSetupListSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultColumns = freezed,Object? defaultSortField = freezed,Object? defaultSortDirection = freezed,Object? defaultGroupBy = freezed,}) {
  return _then(_ProjectSetupListSettingsRequest(
defaultColumns: freezed == defaultColumns ? _self.defaultColumns : defaultColumns // ignore: cast_nullable_to_non_nullable
as List<String>?,defaultSortField: freezed == defaultSortField ? _self.defaultSortField : defaultSortField // ignore: cast_nullable_to_non_nullable
as TaskSavedViewSortField?,defaultSortDirection: freezed == defaultSortDirection ? _self.defaultSortDirection : defaultSortDirection // ignore: cast_nullable_to_non_nullable
as TaskSavedViewSortDirection?,defaultGroupBy: freezed == defaultGroupBy ? _self.defaultGroupBy : defaultGroupBy // ignore: cast_nullable_to_non_nullable
as TaskSavedViewGroupBy?,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupBoardSettingsRequest {

/// Sposób grupowania kart w tory.
 KanbanSwimlaneMode? get swimlaneMode;/// Typowane pola widoczne na kafelku.
 List<KanbanCardField>? get visibleCardFields;/// Domyślna gęstość kafelka.
 KanbanCardDensity? get defaultCardDensity;
/// Create a copy of ProjectSetupBoardSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupBoardSettingsRequestCopyWith<ProjectSetupBoardSettingsRequest> get copyWith => _$ProjectSetupBoardSettingsRequestCopyWithImpl<ProjectSetupBoardSettingsRequest>(this as ProjectSetupBoardSettingsRequest, _$identity);

  /// Serializes this ProjectSetupBoardSettingsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupBoardSettingsRequest&&(identical(other.swimlaneMode, swimlaneMode) || other.swimlaneMode == swimlaneMode)&&const DeepCollectionEquality().equals(other.visibleCardFields, visibleCardFields)&&(identical(other.defaultCardDensity, defaultCardDensity) || other.defaultCardDensity == defaultCardDensity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,swimlaneMode,const DeepCollectionEquality().hash(visibleCardFields),defaultCardDensity);

@override
String toString() {
  return 'ProjectSetupBoardSettingsRequest(swimlaneMode: $swimlaneMode, visibleCardFields: $visibleCardFields, defaultCardDensity: $defaultCardDensity)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupBoardSettingsRequestCopyWith<$Res>  {
  factory $ProjectSetupBoardSettingsRequestCopyWith(ProjectSetupBoardSettingsRequest value, $Res Function(ProjectSetupBoardSettingsRequest) _then) = _$ProjectSetupBoardSettingsRequestCopyWithImpl;
@useResult
$Res call({
 KanbanSwimlaneMode? swimlaneMode, List<KanbanCardField>? visibleCardFields, KanbanCardDensity? defaultCardDensity
});




}
/// @nodoc
class _$ProjectSetupBoardSettingsRequestCopyWithImpl<$Res>
    implements $ProjectSetupBoardSettingsRequestCopyWith<$Res> {
  _$ProjectSetupBoardSettingsRequestCopyWithImpl(this._self, this._then);

  final ProjectSetupBoardSettingsRequest _self;
  final $Res Function(ProjectSetupBoardSettingsRequest) _then;

/// Create a copy of ProjectSetupBoardSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? swimlaneMode = freezed,Object? visibleCardFields = freezed,Object? defaultCardDensity = freezed,}) {
  return _then(_self.copyWith(
swimlaneMode: freezed == swimlaneMode ? _self.swimlaneMode : swimlaneMode // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode?,visibleCardFields: freezed == visibleCardFields ? _self.visibleCardFields : visibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>?,defaultCardDensity: freezed == defaultCardDensity ? _self.defaultCardDensity : defaultCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupBoardSettingsRequest].
extension ProjectSetupBoardSettingsRequestPatterns on ProjectSetupBoardSettingsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupBoardSettingsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupBoardSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupBoardSettingsRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupBoardSettingsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupBoardSettingsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupBoardSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KanbanSwimlaneMode? swimlaneMode,  List<KanbanCardField>? visibleCardFields,  KanbanCardDensity? defaultCardDensity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupBoardSettingsRequest() when $default != null:
return $default(_that.swimlaneMode,_that.visibleCardFields,_that.defaultCardDensity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KanbanSwimlaneMode? swimlaneMode,  List<KanbanCardField>? visibleCardFields,  KanbanCardDensity? defaultCardDensity)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupBoardSettingsRequest():
return $default(_that.swimlaneMode,_that.visibleCardFields,_that.defaultCardDensity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KanbanSwimlaneMode? swimlaneMode,  List<KanbanCardField>? visibleCardFields,  KanbanCardDensity? defaultCardDensity)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupBoardSettingsRequest() when $default != null:
return $default(_that.swimlaneMode,_that.visibleCardFields,_that.defaultCardDensity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupBoardSettingsRequest implements ProjectSetupBoardSettingsRequest {
  const _ProjectSetupBoardSettingsRequest({this.swimlaneMode, this.visibleCardFields, this.defaultCardDensity});
  factory _ProjectSetupBoardSettingsRequest.fromJson(Map<String, dynamic> json) => _$ProjectSetupBoardSettingsRequestFromJson(json);

/// Sposób grupowania kart w tory.
@override final  KanbanSwimlaneMode? swimlaneMode;
/// Typowane pola widoczne na kafelku.
@override final  List<KanbanCardField>? visibleCardFields;
/// Domyślna gęstość kafelka.
@override final  KanbanCardDensity? defaultCardDensity;

/// Create a copy of ProjectSetupBoardSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupBoardSettingsRequestCopyWith<_ProjectSetupBoardSettingsRequest> get copyWith => __$ProjectSetupBoardSettingsRequestCopyWithImpl<_ProjectSetupBoardSettingsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupBoardSettingsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupBoardSettingsRequest&&(identical(other.swimlaneMode, swimlaneMode) || other.swimlaneMode == swimlaneMode)&&const DeepCollectionEquality().equals(other.visibleCardFields, visibleCardFields)&&(identical(other.defaultCardDensity, defaultCardDensity) || other.defaultCardDensity == defaultCardDensity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,swimlaneMode,const DeepCollectionEquality().hash(visibleCardFields),defaultCardDensity);

@override
String toString() {
  return 'ProjectSetupBoardSettingsRequest(swimlaneMode: $swimlaneMode, visibleCardFields: $visibleCardFields, defaultCardDensity: $defaultCardDensity)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupBoardSettingsRequestCopyWith<$Res> implements $ProjectSetupBoardSettingsRequestCopyWith<$Res> {
  factory _$ProjectSetupBoardSettingsRequestCopyWith(_ProjectSetupBoardSettingsRequest value, $Res Function(_ProjectSetupBoardSettingsRequest) _then) = __$ProjectSetupBoardSettingsRequestCopyWithImpl;
@override @useResult
$Res call({
 KanbanSwimlaneMode? swimlaneMode, List<KanbanCardField>? visibleCardFields, KanbanCardDensity? defaultCardDensity
});




}
/// @nodoc
class __$ProjectSetupBoardSettingsRequestCopyWithImpl<$Res>
    implements _$ProjectSetupBoardSettingsRequestCopyWith<$Res> {
  __$ProjectSetupBoardSettingsRequestCopyWithImpl(this._self, this._then);

  final _ProjectSetupBoardSettingsRequest _self;
  final $Res Function(_ProjectSetupBoardSettingsRequest) _then;

/// Create a copy of ProjectSetupBoardSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? swimlaneMode = freezed,Object? visibleCardFields = freezed,Object? defaultCardDensity = freezed,}) {
  return _then(_ProjectSetupBoardSettingsRequest(
swimlaneMode: freezed == swimlaneMode ? _self.swimlaneMode : swimlaneMode // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode?,visibleCardFields: freezed == visibleCardFields ? _self.visibleCardFields : visibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>?,defaultCardDensity: freezed == defaultCardDensity ? _self.defaultCardDensity : defaultCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity?,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupScheduleRequest {

/// Tryb harmonogramowania projektu.
 AutoScheduleMode get mode;/// Opcjonalna dzienna pojemność użytkownika w minutach (0-1440).
 int? get defaultDailyCapacityMinutes;
/// Create a copy of ProjectSetupScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupScheduleRequestCopyWith<ProjectSetupScheduleRequest> get copyWith => _$ProjectSetupScheduleRequestCopyWithImpl<ProjectSetupScheduleRequest>(this as ProjectSetupScheduleRequest, _$identity);

  /// Serializes this ProjectSetupScheduleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupScheduleRequest&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.defaultDailyCapacityMinutes, defaultDailyCapacityMinutes) || other.defaultDailyCapacityMinutes == defaultDailyCapacityMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,defaultDailyCapacityMinutes);

@override
String toString() {
  return 'ProjectSetupScheduleRequest(mode: $mode, defaultDailyCapacityMinutes: $defaultDailyCapacityMinutes)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupScheduleRequestCopyWith<$Res>  {
  factory $ProjectSetupScheduleRequestCopyWith(ProjectSetupScheduleRequest value, $Res Function(ProjectSetupScheduleRequest) _then) = _$ProjectSetupScheduleRequestCopyWithImpl;
@useResult
$Res call({
 AutoScheduleMode mode, int? defaultDailyCapacityMinutes
});




}
/// @nodoc
class _$ProjectSetupScheduleRequestCopyWithImpl<$Res>
    implements $ProjectSetupScheduleRequestCopyWith<$Res> {
  _$ProjectSetupScheduleRequestCopyWithImpl(this._self, this._then);

  final ProjectSetupScheduleRequest _self;
  final $Res Function(ProjectSetupScheduleRequest) _then;

/// Create a copy of ProjectSetupScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? defaultDailyCapacityMinutes = freezed,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AutoScheduleMode,defaultDailyCapacityMinutes: freezed == defaultDailyCapacityMinutes ? _self.defaultDailyCapacityMinutes : defaultDailyCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupScheduleRequest].
extension ProjectSetupScheduleRequestPatterns on ProjectSetupScheduleRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupScheduleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupScheduleRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupScheduleRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupScheduleRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupScheduleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupScheduleRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AutoScheduleMode mode,  int? defaultDailyCapacityMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupScheduleRequest() when $default != null:
return $default(_that.mode,_that.defaultDailyCapacityMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AutoScheduleMode mode,  int? defaultDailyCapacityMinutes)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupScheduleRequest():
return $default(_that.mode,_that.defaultDailyCapacityMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AutoScheduleMode mode,  int? defaultDailyCapacityMinutes)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupScheduleRequest() when $default != null:
return $default(_that.mode,_that.defaultDailyCapacityMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupScheduleRequest implements ProjectSetupScheduleRequest {
  const _ProjectSetupScheduleRequest({required this.mode, this.defaultDailyCapacityMinutes});
  factory _ProjectSetupScheduleRequest.fromJson(Map<String, dynamic> json) => _$ProjectSetupScheduleRequestFromJson(json);

/// Tryb harmonogramowania projektu.
@override final  AutoScheduleMode mode;
/// Opcjonalna dzienna pojemność użytkownika w minutach (0-1440).
@override final  int? defaultDailyCapacityMinutes;

/// Create a copy of ProjectSetupScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupScheduleRequestCopyWith<_ProjectSetupScheduleRequest> get copyWith => __$ProjectSetupScheduleRequestCopyWithImpl<_ProjectSetupScheduleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupScheduleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupScheduleRequest&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.defaultDailyCapacityMinutes, defaultDailyCapacityMinutes) || other.defaultDailyCapacityMinutes == defaultDailyCapacityMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,defaultDailyCapacityMinutes);

@override
String toString() {
  return 'ProjectSetupScheduleRequest(mode: $mode, defaultDailyCapacityMinutes: $defaultDailyCapacityMinutes)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupScheduleRequestCopyWith<$Res> implements $ProjectSetupScheduleRequestCopyWith<$Res> {
  factory _$ProjectSetupScheduleRequestCopyWith(_ProjectSetupScheduleRequest value, $Res Function(_ProjectSetupScheduleRequest) _then) = __$ProjectSetupScheduleRequestCopyWithImpl;
@override @useResult
$Res call({
 AutoScheduleMode mode, int? defaultDailyCapacityMinutes
});




}
/// @nodoc
class __$ProjectSetupScheduleRequestCopyWithImpl<$Res>
    implements _$ProjectSetupScheduleRequestCopyWith<$Res> {
  __$ProjectSetupScheduleRequestCopyWithImpl(this._self, this._then);

  final _ProjectSetupScheduleRequest _self;
  final $Res Function(_ProjectSetupScheduleRequest) _then;

/// Create a copy of ProjectSetupScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? defaultDailyCapacityMinutes = freezed,}) {
  return _then(_ProjectSetupScheduleRequest(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AutoScheduleMode,defaultDailyCapacityMinutes: freezed == defaultDailyCapacityMinutes ? _self.defaultDailyCapacityMinutes : defaultDailyCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$CreateProjectSetupRequest {

/// Sposób startu projektu.
 ProjectSetupSourceRequest get source;/// Podstawowe dane projektu.
 ProjectSetupProjectRequest get project;/// Początkowi członkowie projektu Private.
 List<ProjectSetupMemberAssignmentRequest>? get memberAssignments;/// Wybór workflow zadań.
 ProjectSetupWorkflowRequest? get workflow;/// Domyślny widok zadań i ustawienia Listy oraz Kanbanu.
 ProjectSetupTaskViewRequest? get taskView;/// Tryb harmonogramowania i pojemność.
 ProjectSetupScheduleRequest? get schedule;/// Klucze katalogowych przepisów automatyzacji.
 List<String>? get automationRecipeKeys;
/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProjectSetupRequestCopyWith<CreateProjectSetupRequest> get copyWith => _$CreateProjectSetupRequestCopyWithImpl<CreateProjectSetupRequest>(this as CreateProjectSetupRequest, _$identity);

  /// Serializes this CreateProjectSetupRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProjectSetupRequest&&(identical(other.source, source) || other.source == source)&&(identical(other.project, project) || other.project == project)&&const DeepCollectionEquality().equals(other.memberAssignments, memberAssignments)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&(identical(other.taskView, taskView) || other.taskView == taskView)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other.automationRecipeKeys, automationRecipeKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,project,const DeepCollectionEquality().hash(memberAssignments),workflow,taskView,schedule,const DeepCollectionEquality().hash(automationRecipeKeys));

@override
String toString() {
  return 'CreateProjectSetupRequest(source: $source, project: $project, memberAssignments: $memberAssignments, workflow: $workflow, taskView: $taskView, schedule: $schedule, automationRecipeKeys: $automationRecipeKeys)';
}


}

/// @nodoc
abstract mixin class $CreateProjectSetupRequestCopyWith<$Res>  {
  factory $CreateProjectSetupRequestCopyWith(CreateProjectSetupRequest value, $Res Function(CreateProjectSetupRequest) _then) = _$CreateProjectSetupRequestCopyWithImpl;
@useResult
$Res call({
 ProjectSetupSourceRequest source, ProjectSetupProjectRequest project, List<ProjectSetupMemberAssignmentRequest>? memberAssignments, ProjectSetupWorkflowRequest? workflow, ProjectSetupTaskViewRequest? taskView, ProjectSetupScheduleRequest? schedule, List<String>? automationRecipeKeys
});


$ProjectSetupSourceRequestCopyWith<$Res> get source;$ProjectSetupProjectRequestCopyWith<$Res> get project;$ProjectSetupWorkflowRequestCopyWith<$Res>? get workflow;$ProjectSetupTaskViewRequestCopyWith<$Res>? get taskView;$ProjectSetupScheduleRequestCopyWith<$Res>? get schedule;

}
/// @nodoc
class _$CreateProjectSetupRequestCopyWithImpl<$Res>
    implements $CreateProjectSetupRequestCopyWith<$Res> {
  _$CreateProjectSetupRequestCopyWithImpl(this._self, this._then);

  final CreateProjectSetupRequest _self;
  final $Res Function(CreateProjectSetupRequest) _then;

/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? project = null,Object? memberAssignments = freezed,Object? workflow = freezed,Object? taskView = freezed,Object? schedule = freezed,Object? automationRecipeKeys = freezed,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ProjectSetupSourceRequest,project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectSetupProjectRequest,memberAssignments: freezed == memberAssignments ? _self.memberAssignments : memberAssignments // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupMemberAssignmentRequest>?,workflow: freezed == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowRequest?,taskView: freezed == taskView ? _self.taskView : taskView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewRequest?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as ProjectSetupScheduleRequest?,automationRecipeKeys: freezed == automationRecipeKeys ? _self.automationRecipeKeys : automationRecipeKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}
/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupSourceRequestCopyWith<$Res> get source {
  
  return $ProjectSetupSourceRequestCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupProjectRequestCopyWith<$Res> get project {
  
  return $ProjectSetupProjectRequestCopyWith<$Res>(_self.project, (value) {
    return _then(_self.copyWith(project: value));
  });
}/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowRequestCopyWith<$Res>? get workflow {
    if (_self.workflow == null) {
    return null;
  }

  return $ProjectSetupWorkflowRequestCopyWith<$Res>(_self.workflow!, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupTaskViewRequestCopyWith<$Res>? get taskView {
    if (_self.taskView == null) {
    return null;
  }

  return $ProjectSetupTaskViewRequestCopyWith<$Res>(_self.taskView!, (value) {
    return _then(_self.copyWith(taskView: value));
  });
}/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupScheduleRequestCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $ProjectSetupScheduleRequestCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateProjectSetupRequest].
extension CreateProjectSetupRequestPatterns on CreateProjectSetupRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProjectSetupRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProjectSetupRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProjectSetupRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateProjectSetupRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProjectSetupRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProjectSetupRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectSetupSourceRequest source,  ProjectSetupProjectRequest project,  List<ProjectSetupMemberAssignmentRequest>? memberAssignments,  ProjectSetupWorkflowRequest? workflow,  ProjectSetupTaskViewRequest? taskView,  ProjectSetupScheduleRequest? schedule,  List<String>? automationRecipeKeys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProjectSetupRequest() when $default != null:
return $default(_that.source,_that.project,_that.memberAssignments,_that.workflow,_that.taskView,_that.schedule,_that.automationRecipeKeys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectSetupSourceRequest source,  ProjectSetupProjectRequest project,  List<ProjectSetupMemberAssignmentRequest>? memberAssignments,  ProjectSetupWorkflowRequest? workflow,  ProjectSetupTaskViewRequest? taskView,  ProjectSetupScheduleRequest? schedule,  List<String>? automationRecipeKeys)  $default,) {final _that = this;
switch (_that) {
case _CreateProjectSetupRequest():
return $default(_that.source,_that.project,_that.memberAssignments,_that.workflow,_that.taskView,_that.schedule,_that.automationRecipeKeys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectSetupSourceRequest source,  ProjectSetupProjectRequest project,  List<ProjectSetupMemberAssignmentRequest>? memberAssignments,  ProjectSetupWorkflowRequest? workflow,  ProjectSetupTaskViewRequest? taskView,  ProjectSetupScheduleRequest? schedule,  List<String>? automationRecipeKeys)?  $default,) {final _that = this;
switch (_that) {
case _CreateProjectSetupRequest() when $default != null:
return $default(_that.source,_that.project,_that.memberAssignments,_that.workflow,_that.taskView,_that.schedule,_that.automationRecipeKeys);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProjectSetupRequest implements CreateProjectSetupRequest {
  const _CreateProjectSetupRequest({required this.source, required this.project, this.memberAssignments, this.workflow, this.taskView, this.schedule, this.automationRecipeKeys});
  factory _CreateProjectSetupRequest.fromJson(Map<String, dynamic> json) => _$CreateProjectSetupRequestFromJson(json);

/// Sposób startu projektu.
@override final  ProjectSetupSourceRequest source;
/// Podstawowe dane projektu.
@override final  ProjectSetupProjectRequest project;
/// Początkowi członkowie projektu Private.
@override final  List<ProjectSetupMemberAssignmentRequest>? memberAssignments;
/// Wybór workflow zadań.
@override final  ProjectSetupWorkflowRequest? workflow;
/// Domyślny widok zadań i ustawienia Listy oraz Kanbanu.
@override final  ProjectSetupTaskViewRequest? taskView;
/// Tryb harmonogramowania i pojemność.
@override final  ProjectSetupScheduleRequest? schedule;
/// Klucze katalogowych przepisów automatyzacji.
@override final  List<String>? automationRecipeKeys;

/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProjectSetupRequestCopyWith<_CreateProjectSetupRequest> get copyWith => __$CreateProjectSetupRequestCopyWithImpl<_CreateProjectSetupRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProjectSetupRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProjectSetupRequest&&(identical(other.source, source) || other.source == source)&&(identical(other.project, project) || other.project == project)&&const DeepCollectionEquality().equals(other.memberAssignments, memberAssignments)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&(identical(other.taskView, taskView) || other.taskView == taskView)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other.automationRecipeKeys, automationRecipeKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,project,const DeepCollectionEquality().hash(memberAssignments),workflow,taskView,schedule,const DeepCollectionEquality().hash(automationRecipeKeys));

@override
String toString() {
  return 'CreateProjectSetupRequest(source: $source, project: $project, memberAssignments: $memberAssignments, workflow: $workflow, taskView: $taskView, schedule: $schedule, automationRecipeKeys: $automationRecipeKeys)';
}


}

/// @nodoc
abstract mixin class _$CreateProjectSetupRequestCopyWith<$Res> implements $CreateProjectSetupRequestCopyWith<$Res> {
  factory _$CreateProjectSetupRequestCopyWith(_CreateProjectSetupRequest value, $Res Function(_CreateProjectSetupRequest) _then) = __$CreateProjectSetupRequestCopyWithImpl;
@override @useResult
$Res call({
 ProjectSetupSourceRequest source, ProjectSetupProjectRequest project, List<ProjectSetupMemberAssignmentRequest>? memberAssignments, ProjectSetupWorkflowRequest? workflow, ProjectSetupTaskViewRequest? taskView, ProjectSetupScheduleRequest? schedule, List<String>? automationRecipeKeys
});


@override $ProjectSetupSourceRequestCopyWith<$Res> get source;@override $ProjectSetupProjectRequestCopyWith<$Res> get project;@override $ProjectSetupWorkflowRequestCopyWith<$Res>? get workflow;@override $ProjectSetupTaskViewRequestCopyWith<$Res>? get taskView;@override $ProjectSetupScheduleRequestCopyWith<$Res>? get schedule;

}
/// @nodoc
class __$CreateProjectSetupRequestCopyWithImpl<$Res>
    implements _$CreateProjectSetupRequestCopyWith<$Res> {
  __$CreateProjectSetupRequestCopyWithImpl(this._self, this._then);

  final _CreateProjectSetupRequest _self;
  final $Res Function(_CreateProjectSetupRequest) _then;

/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? project = null,Object? memberAssignments = freezed,Object? workflow = freezed,Object? taskView = freezed,Object? schedule = freezed,Object? automationRecipeKeys = freezed,}) {
  return _then(_CreateProjectSetupRequest(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ProjectSetupSourceRequest,project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectSetupProjectRequest,memberAssignments: freezed == memberAssignments ? _self.memberAssignments : memberAssignments // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupMemberAssignmentRequest>?,workflow: freezed == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowRequest?,taskView: freezed == taskView ? _self.taskView : taskView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewRequest?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as ProjectSetupScheduleRequest?,automationRecipeKeys: freezed == automationRecipeKeys ? _self.automationRecipeKeys : automationRecipeKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupSourceRequestCopyWith<$Res> get source {
  
  return $ProjectSetupSourceRequestCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupProjectRequestCopyWith<$Res> get project {
  
  return $ProjectSetupProjectRequestCopyWith<$Res>(_self.project, (value) {
    return _then(_self.copyWith(project: value));
  });
}/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowRequestCopyWith<$Res>? get workflow {
    if (_self.workflow == null) {
    return null;
  }

  return $ProjectSetupWorkflowRequestCopyWith<$Res>(_self.workflow!, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupTaskViewRequestCopyWith<$Res>? get taskView {
    if (_self.taskView == null) {
    return null;
  }

  return $ProjectSetupTaskViewRequestCopyWith<$Res>(_self.taskView!, (value) {
    return _then(_self.copyWith(taskView: value));
  });
}/// Create a copy of CreateProjectSetupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupScheduleRequestCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $ProjectSetupScheduleRequestCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

// dart format on
