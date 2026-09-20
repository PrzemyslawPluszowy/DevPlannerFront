// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_user_preference_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectUserPreferenceResponse {

/// UUID projektu.
 String get projectId;/// Czy projekt jest ukryty na liście użytkownika.
 bool get isHidden;/// Czy projekt jest przypięty na liście użytkownika.
 bool get isPinned;/// Osobista pozycja sortowania albo null.
 int? get sortPosition;/// Czas aktualizacji preferencji.
 DateTime get updatedAtUtc;/// Wersja preferencji (`xmin`) albo null w starszym kontrakcie.
///
/// Wartość służy jako `expectedVersion` następnego zapisu preferencji;
/// niezgodność zwraca 409 z kodem `project.preference_version_conflict`.
 int? get version;
/// Create a copy of ProjectUserPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectUserPreferenceResponseCopyWith<ProjectUserPreferenceResponse> get copyWith => _$ProjectUserPreferenceResponseCopyWithImpl<ProjectUserPreferenceResponse>(this as ProjectUserPreferenceResponse, _$identity);

  /// Serializes this ProjectUserPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectUserPreferenceResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.sortPosition, sortPosition) || other.sortPosition == sortPosition)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,isHidden,isPinned,sortPosition,updatedAtUtc,version);

@override
String toString() {
  return 'ProjectUserPreferenceResponse(projectId: $projectId, isHidden: $isHidden, isPinned: $isPinned, sortPosition: $sortPosition, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $ProjectUserPreferenceResponseCopyWith<$Res>  {
  factory $ProjectUserPreferenceResponseCopyWith(ProjectUserPreferenceResponse value, $Res Function(ProjectUserPreferenceResponse) _then) = _$ProjectUserPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String projectId, bool isHidden, bool isPinned, int? sortPosition, DateTime updatedAtUtc, int? version
});




}
/// @nodoc
class _$ProjectUserPreferenceResponseCopyWithImpl<$Res>
    implements $ProjectUserPreferenceResponseCopyWith<$Res> {
  _$ProjectUserPreferenceResponseCopyWithImpl(this._self, this._then);

  final ProjectUserPreferenceResponse _self;
  final $Res Function(ProjectUserPreferenceResponse) _then;

/// Create a copy of ProjectUserPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? isHidden = null,Object? isPinned = null,Object? sortPosition = freezed,Object? updatedAtUtc = null,Object? version = freezed,}) {
  return _then(_self.copyWith(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,sortPosition: freezed == sortPosition ? _self.sortPosition : sortPosition // ignore: cast_nullable_to_non_nullable
as int?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectUserPreferenceResponse].
extension ProjectUserPreferenceResponsePatterns on ProjectUserPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectUserPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectUserPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectUserPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectUserPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectUserPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectUserPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  bool isHidden,  bool isPinned,  int? sortPosition,  DateTime updatedAtUtc,  int? version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectUserPreferenceResponse() when $default != null:
return $default(_that.projectId,_that.isHidden,_that.isPinned,_that.sortPosition,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  bool isHidden,  bool isPinned,  int? sortPosition,  DateTime updatedAtUtc,  int? version)  $default,) {final _that = this;
switch (_that) {
case _ProjectUserPreferenceResponse():
return $default(_that.projectId,_that.isHidden,_that.isPinned,_that.sortPosition,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  bool isHidden,  bool isPinned,  int? sortPosition,  DateTime updatedAtUtc,  int? version)?  $default,) {final _that = this;
switch (_that) {
case _ProjectUserPreferenceResponse() when $default != null:
return $default(_that.projectId,_that.isHidden,_that.isPinned,_that.sortPosition,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectUserPreferenceResponse implements ProjectUserPreferenceResponse {
  const _ProjectUserPreferenceResponse({required this.projectId, required this.isHidden, required this.isPinned, this.sortPosition, required this.updatedAtUtc, this.version});
  factory _ProjectUserPreferenceResponse.fromJson(Map<String, dynamic> json) => _$ProjectUserPreferenceResponseFromJson(json);

/// UUID projektu.
@override final  String projectId;
/// Czy projekt jest ukryty na liście użytkownika.
@override final  bool isHidden;
/// Czy projekt jest przypięty na liście użytkownika.
@override final  bool isPinned;
/// Osobista pozycja sortowania albo null.
@override final  int? sortPosition;
/// Czas aktualizacji preferencji.
@override final  DateTime updatedAtUtc;
/// Wersja preferencji (`xmin`) albo null w starszym kontrakcie.
///
/// Wartość służy jako `expectedVersion` następnego zapisu preferencji;
/// niezgodność zwraca 409 z kodem `project.preference_version_conflict`.
@override final  int? version;

/// Create a copy of ProjectUserPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectUserPreferenceResponseCopyWith<_ProjectUserPreferenceResponse> get copyWith => __$ProjectUserPreferenceResponseCopyWithImpl<_ProjectUserPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectUserPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectUserPreferenceResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.sortPosition, sortPosition) || other.sortPosition == sortPosition)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,isHidden,isPinned,sortPosition,updatedAtUtc,version);

@override
String toString() {
  return 'ProjectUserPreferenceResponse(projectId: $projectId, isHidden: $isHidden, isPinned: $isPinned, sortPosition: $sortPosition, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ProjectUserPreferenceResponseCopyWith<$Res> implements $ProjectUserPreferenceResponseCopyWith<$Res> {
  factory _$ProjectUserPreferenceResponseCopyWith(_ProjectUserPreferenceResponse value, $Res Function(_ProjectUserPreferenceResponse) _then) = __$ProjectUserPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String projectId, bool isHidden, bool isPinned, int? sortPosition, DateTime updatedAtUtc, int? version
});




}
/// @nodoc
class __$ProjectUserPreferenceResponseCopyWithImpl<$Res>
    implements _$ProjectUserPreferenceResponseCopyWith<$Res> {
  __$ProjectUserPreferenceResponseCopyWithImpl(this._self, this._then);

  final _ProjectUserPreferenceResponse _self;
  final $Res Function(_ProjectUserPreferenceResponse) _then;

/// Create a copy of ProjectUserPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? isHidden = null,Object? isPinned = null,Object? sortPosition = freezed,Object? updatedAtUtc = null,Object? version = freezed,}) {
  return _then(_ProjectUserPreferenceResponse(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,sortPosition: freezed == sortPosition ? _self.sortPosition : sortPosition // ignore: cast_nullable_to_non_nullable
as int?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
