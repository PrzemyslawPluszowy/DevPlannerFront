// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'portfolio_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatePortfolioPayload {

/// Nazwa portfolio.
 String get name;/// Opcjonalny opis portfolio.
 String? get description;
/// Create a copy of CreatePortfolioPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePortfolioPayloadCopyWith<CreatePortfolioPayload> get copyWith => _$CreatePortfolioPayloadCopyWithImpl<CreatePortfolioPayload>(this as CreatePortfolioPayload, _$identity);

  /// Serializes this CreatePortfolioPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePortfolioPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description);

@override
String toString() {
  return 'CreatePortfolioPayload(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $CreatePortfolioPayloadCopyWith<$Res>  {
  factory $CreatePortfolioPayloadCopyWith(CreatePortfolioPayload value, $Res Function(CreatePortfolioPayload) _then) = _$CreatePortfolioPayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description
});




}
/// @nodoc
class _$CreatePortfolioPayloadCopyWithImpl<$Res>
    implements $CreatePortfolioPayloadCopyWith<$Res> {
  _$CreatePortfolioPayloadCopyWithImpl(this._self, this._then);

  final CreatePortfolioPayload _self;
  final $Res Function(CreatePortfolioPayload) _then;

/// Create a copy of CreatePortfolioPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatePortfolioPayload].
extension CreatePortfolioPayloadPatterns on CreatePortfolioPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePortfolioPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePortfolioPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePortfolioPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreatePortfolioPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePortfolioPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePortfolioPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePortfolioPayload() when $default != null:
return $default(_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _CreatePortfolioPayload():
return $default(_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _CreatePortfolioPayload() when $default != null:
return $default(_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePortfolioPayload implements CreatePortfolioPayload {
  const _CreatePortfolioPayload({required this.name, this.description});
  factory _CreatePortfolioPayload.fromJson(Map<String, dynamic> json) => _$CreatePortfolioPayloadFromJson(json);

/// Nazwa portfolio.
@override final  String name;
/// Opcjonalny opis portfolio.
@override final  String? description;

/// Create a copy of CreatePortfolioPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePortfolioPayloadCopyWith<_CreatePortfolioPayload> get copyWith => __$CreatePortfolioPayloadCopyWithImpl<_CreatePortfolioPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePortfolioPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePortfolioPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description);

@override
String toString() {
  return 'CreatePortfolioPayload(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CreatePortfolioPayloadCopyWith<$Res> implements $CreatePortfolioPayloadCopyWith<$Res> {
  factory _$CreatePortfolioPayloadCopyWith(_CreatePortfolioPayload value, $Res Function(_CreatePortfolioPayload) _then) = __$CreatePortfolioPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description
});




}
/// @nodoc
class __$CreatePortfolioPayloadCopyWithImpl<$Res>
    implements _$CreatePortfolioPayloadCopyWith<$Res> {
  __$CreatePortfolioPayloadCopyWithImpl(this._self, this._then);

  final _CreatePortfolioPayload _self;
  final $Res Function(_CreatePortfolioPayload) _then;

/// Create a copy of CreatePortfolioPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,}) {
  return _then(_CreatePortfolioPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdatePortfolioPayload {

/// Nowa nazwa portfolio.
 String get name;/// Nowy opis portfolio albo null.
 String? get description;
/// Create a copy of UpdatePortfolioPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatePortfolioPayloadCopyWith<UpdatePortfolioPayload> get copyWith => _$UpdatePortfolioPayloadCopyWithImpl<UpdatePortfolioPayload>(this as UpdatePortfolioPayload, _$identity);

  /// Serializes this UpdatePortfolioPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatePortfolioPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description);

@override
String toString() {
  return 'UpdatePortfolioPayload(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $UpdatePortfolioPayloadCopyWith<$Res>  {
  factory $UpdatePortfolioPayloadCopyWith(UpdatePortfolioPayload value, $Res Function(UpdatePortfolioPayload) _then) = _$UpdatePortfolioPayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description
});




}
/// @nodoc
class _$UpdatePortfolioPayloadCopyWithImpl<$Res>
    implements $UpdatePortfolioPayloadCopyWith<$Res> {
  _$UpdatePortfolioPayloadCopyWithImpl(this._self, this._then);

  final UpdatePortfolioPayload _self;
  final $Res Function(UpdatePortfolioPayload) _then;

/// Create a copy of UpdatePortfolioPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdatePortfolioPayload].
extension UpdatePortfolioPayloadPatterns on UpdatePortfolioPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdatePortfolioPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdatePortfolioPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdatePortfolioPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdatePortfolioPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdatePortfolioPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdatePortfolioPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdatePortfolioPayload() when $default != null:
return $default(_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _UpdatePortfolioPayload():
return $default(_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _UpdatePortfolioPayload() when $default != null:
return $default(_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdatePortfolioPayload implements UpdatePortfolioPayload {
  const _UpdatePortfolioPayload({required this.name, this.description});
  factory _UpdatePortfolioPayload.fromJson(Map<String, dynamic> json) => _$UpdatePortfolioPayloadFromJson(json);

/// Nowa nazwa portfolio.
@override final  String name;
/// Nowy opis portfolio albo null.
@override final  String? description;

/// Create a copy of UpdatePortfolioPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePortfolioPayloadCopyWith<_UpdatePortfolioPayload> get copyWith => __$UpdatePortfolioPayloadCopyWithImpl<_UpdatePortfolioPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdatePortfolioPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePortfolioPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description);

@override
String toString() {
  return 'UpdatePortfolioPayload(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$UpdatePortfolioPayloadCopyWith<$Res> implements $UpdatePortfolioPayloadCopyWith<$Res> {
  factory _$UpdatePortfolioPayloadCopyWith(_UpdatePortfolioPayload value, $Res Function(_UpdatePortfolioPayload) _then) = __$UpdatePortfolioPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description
});




}
/// @nodoc
class __$UpdatePortfolioPayloadCopyWithImpl<$Res>
    implements _$UpdatePortfolioPayloadCopyWith<$Res> {
  __$UpdatePortfolioPayloadCopyWithImpl(this._self, this._then);

  final _UpdatePortfolioPayload _self;
  final $Res Function(_UpdatePortfolioPayload) _then;

/// Create a copy of UpdatePortfolioPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,}) {
  return _then(_UpdatePortfolioPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AddPortfolioProjectsPayload {

/// UUID-y aktywnych projektów należących do tego samego workspace.
 List<String> get projectIds;
/// Create a copy of AddPortfolioProjectsPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddPortfolioProjectsPayloadCopyWith<AddPortfolioProjectsPayload> get copyWith => _$AddPortfolioProjectsPayloadCopyWithImpl<AddPortfolioProjectsPayload>(this as AddPortfolioProjectsPayload, _$identity);

  /// Serializes this AddPortfolioProjectsPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddPortfolioProjectsPayload&&const DeepCollectionEquality().equals(other.projectIds, projectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(projectIds));

@override
String toString() {
  return 'AddPortfolioProjectsPayload(projectIds: $projectIds)';
}


}

/// @nodoc
abstract mixin class $AddPortfolioProjectsPayloadCopyWith<$Res>  {
  factory $AddPortfolioProjectsPayloadCopyWith(AddPortfolioProjectsPayload value, $Res Function(AddPortfolioProjectsPayload) _then) = _$AddPortfolioProjectsPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> projectIds
});




}
/// @nodoc
class _$AddPortfolioProjectsPayloadCopyWithImpl<$Res>
    implements $AddPortfolioProjectsPayloadCopyWith<$Res> {
  _$AddPortfolioProjectsPayloadCopyWithImpl(this._self, this._then);

  final AddPortfolioProjectsPayload _self;
  final $Res Function(AddPortfolioProjectsPayload) _then;

/// Create a copy of AddPortfolioProjectsPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectIds = null,}) {
  return _then(_self.copyWith(
projectIds: null == projectIds ? _self.projectIds : projectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AddPortfolioProjectsPayload].
extension AddPortfolioProjectsPayloadPatterns on AddPortfolioProjectsPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddPortfolioProjectsPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddPortfolioProjectsPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddPortfolioProjectsPayload value)  $default,){
final _that = this;
switch (_that) {
case _AddPortfolioProjectsPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddPortfolioProjectsPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AddPortfolioProjectsPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> projectIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddPortfolioProjectsPayload() when $default != null:
return $default(_that.projectIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> projectIds)  $default,) {final _that = this;
switch (_that) {
case _AddPortfolioProjectsPayload():
return $default(_that.projectIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> projectIds)?  $default,) {final _that = this;
switch (_that) {
case _AddPortfolioProjectsPayload() when $default != null:
return $default(_that.projectIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddPortfolioProjectsPayload implements AddPortfolioProjectsPayload {
  const _AddPortfolioProjectsPayload({required this.projectIds});
  factory _AddPortfolioProjectsPayload.fromJson(Map<String, dynamic> json) => _$AddPortfolioProjectsPayloadFromJson(json);

/// UUID-y aktywnych projektów należących do tego samego workspace.
@override final  List<String> projectIds;

/// Create a copy of AddPortfolioProjectsPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddPortfolioProjectsPayloadCopyWith<_AddPortfolioProjectsPayload> get copyWith => __$AddPortfolioProjectsPayloadCopyWithImpl<_AddPortfolioProjectsPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddPortfolioProjectsPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddPortfolioProjectsPayload&&const DeepCollectionEquality().equals(other.projectIds, projectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(projectIds));

@override
String toString() {
  return 'AddPortfolioProjectsPayload(projectIds: $projectIds)';
}


}

/// @nodoc
abstract mixin class _$AddPortfolioProjectsPayloadCopyWith<$Res> implements $AddPortfolioProjectsPayloadCopyWith<$Res> {
  factory _$AddPortfolioProjectsPayloadCopyWith(_AddPortfolioProjectsPayload value, $Res Function(_AddPortfolioProjectsPayload) _then) = __$AddPortfolioProjectsPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> projectIds
});




}
/// @nodoc
class __$AddPortfolioProjectsPayloadCopyWithImpl<$Res>
    implements _$AddPortfolioProjectsPayloadCopyWith<$Res> {
  __$AddPortfolioProjectsPayloadCopyWithImpl(this._self, this._then);

  final _AddPortfolioProjectsPayload _self;
  final $Res Function(_AddPortfolioProjectsPayload) _then;

/// Create a copy of AddPortfolioProjectsPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectIds = null,}) {
  return _then(_AddPortfolioProjectsPayload(
projectIds: null == projectIds ? _self.projectIds : projectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PortfolioResponse {

/// UUID portfolio.
 String get id;/// UUID workspace.
 String get workspaceId;/// UUID twórcy portfolio.
 String get createdByCoreUserId;/// Nazwa portfolio.
 String get name;/// Opis albo null.
 String? get description;/// Procent wykonania.
 double get progress;/// UUID-y projektów należących do portfolio.
 List<String> get projectIds;/// Czas utworzenia.
 DateTime get createdAtUtc;/// Czas aktualizacji.
 DateTime get updatedAtUtc;/// Wersja optimistic concurrency.
 int get version;
/// Create a copy of PortfolioResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioResponseCopyWith<PortfolioResponse> get copyWith => _$PortfolioResponseCopyWithImpl<PortfolioResponse>(this as PortfolioResponse, _$identity);

  /// Serializes this PortfolioResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other.projectIds, projectIds)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,createdByCoreUserId,name,description,progress,const DeepCollectionEquality().hash(projectIds),createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'PortfolioResponse(id: $id, workspaceId: $workspaceId, createdByCoreUserId: $createdByCoreUserId, name: $name, description: $description, progress: $progress, projectIds: $projectIds, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $PortfolioResponseCopyWith<$Res>  {
  factory $PortfolioResponseCopyWith(PortfolioResponse value, $Res Function(PortfolioResponse) _then) = _$PortfolioResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String createdByCoreUserId, String name, String? description, double progress, List<String> projectIds, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$PortfolioResponseCopyWithImpl<$Res>
    implements $PortfolioResponseCopyWith<$Res> {
  _$PortfolioResponseCopyWithImpl(this._self, this._then);

  final PortfolioResponse _self;
  final $Res Function(PortfolioResponse) _then;

/// Create a copy of PortfolioResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? createdByCoreUserId = null,Object? name = null,Object? description = freezed,Object? progress = null,Object? projectIds = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,createdByCoreUserId: null == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,projectIds: null == projectIds ? _self.projectIds : projectIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PortfolioResponse].
extension PortfolioResponsePatterns on PortfolioResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioResponse value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String createdByCoreUserId,  String name,  String? description,  double progress,  List<String> projectIds,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.createdByCoreUserId,_that.name,_that.description,_that.progress,_that.projectIds,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String createdByCoreUserId,  String name,  String? description,  double progress,  List<String> projectIds,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _PortfolioResponse():
return $default(_that.id,_that.workspaceId,_that.createdByCoreUserId,_that.name,_that.description,_that.progress,_that.projectIds,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String createdByCoreUserId,  String name,  String? description,  double progress,  List<String> projectIds,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.createdByCoreUserId,_that.name,_that.description,_that.progress,_that.projectIds,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortfolioResponse implements PortfolioResponse {
  const _PortfolioResponse({required this.id, required this.workspaceId, required this.createdByCoreUserId, required this.name, this.description, required this.progress, required this.projectIds, required this.createdAtUtc, required this.updatedAtUtc, required this.version});
  factory _PortfolioResponse.fromJson(Map<String, dynamic> json) => _$PortfolioResponseFromJson(json);

/// UUID portfolio.
@override final  String id;
/// UUID workspace.
@override final  String workspaceId;
/// UUID twórcy portfolio.
@override final  String createdByCoreUserId;
/// Nazwa portfolio.
@override final  String name;
/// Opis albo null.
@override final  String? description;
/// Procent wykonania.
@override final  double progress;
/// UUID-y projektów należących do portfolio.
@override final  List<String> projectIds;
/// Czas utworzenia.
@override final  DateTime createdAtUtc;
/// Czas aktualizacji.
@override final  DateTime updatedAtUtc;
/// Wersja optimistic concurrency.
@override final  int version;

/// Create a copy of PortfolioResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioResponseCopyWith<_PortfolioResponse> get copyWith => __$PortfolioResponseCopyWithImpl<_PortfolioResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortfolioResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other.projectIds, projectIds)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,createdByCoreUserId,name,description,progress,const DeepCollectionEquality().hash(projectIds),createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'PortfolioResponse(id: $id, workspaceId: $workspaceId, createdByCoreUserId: $createdByCoreUserId, name: $name, description: $description, progress: $progress, projectIds: $projectIds, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$PortfolioResponseCopyWith<$Res> implements $PortfolioResponseCopyWith<$Res> {
  factory _$PortfolioResponseCopyWith(_PortfolioResponse value, $Res Function(_PortfolioResponse) _then) = __$PortfolioResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String createdByCoreUserId, String name, String? description, double progress, List<String> projectIds, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$PortfolioResponseCopyWithImpl<$Res>
    implements _$PortfolioResponseCopyWith<$Res> {
  __$PortfolioResponseCopyWithImpl(this._self, this._then);

  final _PortfolioResponse _self;
  final $Res Function(_PortfolioResponse) _then;

/// Create a copy of PortfolioResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? createdByCoreUserId = null,Object? name = null,Object? description = freezed,Object? progress = null,Object? projectIds = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_PortfolioResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,createdByCoreUserId: null == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,projectIds: null == projectIds ? _self.projectIds : projectIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PortfolioDashboardResponse {

/// UUID portfolio.
 String get portfolioId;/// Liczba projektów.
 int get projectCount;/// Procent wykonania.
 double get progress;/// Liczba otwartych zadań.
 int get openTaskCount;/// Liczba zakończonych zadań.
 int get doneTaskCount;/// Liczba zadań po terminie.
 int get overdueTaskCount;/// Liczba aktywnych milestone’ów.
 int get activeMilestoneCount;/// Czas obliczenia agregatów.
 DateTime get calculatedAtUtc;
/// Create a copy of PortfolioDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioDashboardResponseCopyWith<PortfolioDashboardResponse> get copyWith => _$PortfolioDashboardResponseCopyWithImpl<PortfolioDashboardResponse>(this as PortfolioDashboardResponse, _$identity);

  /// Serializes this PortfolioDashboardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PortfolioDashboardResponse&&(identical(other.portfolioId, portfolioId) || other.portfolioId == portfolioId)&&(identical(other.projectCount, projectCount) || other.projectCount == projectCount)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.openTaskCount, openTaskCount) || other.openTaskCount == openTaskCount)&&(identical(other.doneTaskCount, doneTaskCount) || other.doneTaskCount == doneTaskCount)&&(identical(other.overdueTaskCount, overdueTaskCount) || other.overdueTaskCount == overdueTaskCount)&&(identical(other.activeMilestoneCount, activeMilestoneCount) || other.activeMilestoneCount == activeMilestoneCount)&&(identical(other.calculatedAtUtc, calculatedAtUtc) || other.calculatedAtUtc == calculatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,portfolioId,projectCount,progress,openTaskCount,doneTaskCount,overdueTaskCount,activeMilestoneCount,calculatedAtUtc);

@override
String toString() {
  return 'PortfolioDashboardResponse(portfolioId: $portfolioId, projectCount: $projectCount, progress: $progress, openTaskCount: $openTaskCount, doneTaskCount: $doneTaskCount, overdueTaskCount: $overdueTaskCount, activeMilestoneCount: $activeMilestoneCount, calculatedAtUtc: $calculatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $PortfolioDashboardResponseCopyWith<$Res>  {
  factory $PortfolioDashboardResponseCopyWith(PortfolioDashboardResponse value, $Res Function(PortfolioDashboardResponse) _then) = _$PortfolioDashboardResponseCopyWithImpl;
@useResult
$Res call({
 String portfolioId, int projectCount, double progress, int openTaskCount, int doneTaskCount, int overdueTaskCount, int activeMilestoneCount, DateTime calculatedAtUtc
});




}
/// @nodoc
class _$PortfolioDashboardResponseCopyWithImpl<$Res>
    implements $PortfolioDashboardResponseCopyWith<$Res> {
  _$PortfolioDashboardResponseCopyWithImpl(this._self, this._then);

  final PortfolioDashboardResponse _self;
  final $Res Function(PortfolioDashboardResponse) _then;

/// Create a copy of PortfolioDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? portfolioId = null,Object? projectCount = null,Object? progress = null,Object? openTaskCount = null,Object? doneTaskCount = null,Object? overdueTaskCount = null,Object? activeMilestoneCount = null,Object? calculatedAtUtc = null,}) {
  return _then(_self.copyWith(
portfolioId: null == portfolioId ? _self.portfolioId : portfolioId // ignore: cast_nullable_to_non_nullable
as String,projectCount: null == projectCount ? _self.projectCount : projectCount // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,openTaskCount: null == openTaskCount ? _self.openTaskCount : openTaskCount // ignore: cast_nullable_to_non_nullable
as int,doneTaskCount: null == doneTaskCount ? _self.doneTaskCount : doneTaskCount // ignore: cast_nullable_to_non_nullable
as int,overdueTaskCount: null == overdueTaskCount ? _self.overdueTaskCount : overdueTaskCount // ignore: cast_nullable_to_non_nullable
as int,activeMilestoneCount: null == activeMilestoneCount ? _self.activeMilestoneCount : activeMilestoneCount // ignore: cast_nullable_to_non_nullable
as int,calculatedAtUtc: null == calculatedAtUtc ? _self.calculatedAtUtc : calculatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PortfolioDashboardResponse].
extension PortfolioDashboardResponsePatterns on PortfolioDashboardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PortfolioDashboardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PortfolioDashboardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PortfolioDashboardResponse value)  $default,){
final _that = this;
switch (_that) {
case _PortfolioDashboardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PortfolioDashboardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PortfolioDashboardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String portfolioId,  int projectCount,  double progress,  int openTaskCount,  int doneTaskCount,  int overdueTaskCount,  int activeMilestoneCount,  DateTime calculatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PortfolioDashboardResponse() when $default != null:
return $default(_that.portfolioId,_that.projectCount,_that.progress,_that.openTaskCount,_that.doneTaskCount,_that.overdueTaskCount,_that.activeMilestoneCount,_that.calculatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String portfolioId,  int projectCount,  double progress,  int openTaskCount,  int doneTaskCount,  int overdueTaskCount,  int activeMilestoneCount,  DateTime calculatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _PortfolioDashboardResponse():
return $default(_that.portfolioId,_that.projectCount,_that.progress,_that.openTaskCount,_that.doneTaskCount,_that.overdueTaskCount,_that.activeMilestoneCount,_that.calculatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String portfolioId,  int projectCount,  double progress,  int openTaskCount,  int doneTaskCount,  int overdueTaskCount,  int activeMilestoneCount,  DateTime calculatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _PortfolioDashboardResponse() when $default != null:
return $default(_that.portfolioId,_that.projectCount,_that.progress,_that.openTaskCount,_that.doneTaskCount,_that.overdueTaskCount,_that.activeMilestoneCount,_that.calculatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PortfolioDashboardResponse implements PortfolioDashboardResponse {
  const _PortfolioDashboardResponse({required this.portfolioId, required this.projectCount, required this.progress, required this.openTaskCount, required this.doneTaskCount, required this.overdueTaskCount, required this.activeMilestoneCount, required this.calculatedAtUtc});
  factory _PortfolioDashboardResponse.fromJson(Map<String, dynamic> json) => _$PortfolioDashboardResponseFromJson(json);

/// UUID portfolio.
@override final  String portfolioId;
/// Liczba projektów.
@override final  int projectCount;
/// Procent wykonania.
@override final  double progress;
/// Liczba otwartych zadań.
@override final  int openTaskCount;
/// Liczba zakończonych zadań.
@override final  int doneTaskCount;
/// Liczba zadań po terminie.
@override final  int overdueTaskCount;
/// Liczba aktywnych milestone’ów.
@override final  int activeMilestoneCount;
/// Czas obliczenia agregatów.
@override final  DateTime calculatedAtUtc;

/// Create a copy of PortfolioDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioDashboardResponseCopyWith<_PortfolioDashboardResponse> get copyWith => __$PortfolioDashboardResponseCopyWithImpl<_PortfolioDashboardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortfolioDashboardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PortfolioDashboardResponse&&(identical(other.portfolioId, portfolioId) || other.portfolioId == portfolioId)&&(identical(other.projectCount, projectCount) || other.projectCount == projectCount)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.openTaskCount, openTaskCount) || other.openTaskCount == openTaskCount)&&(identical(other.doneTaskCount, doneTaskCount) || other.doneTaskCount == doneTaskCount)&&(identical(other.overdueTaskCount, overdueTaskCount) || other.overdueTaskCount == overdueTaskCount)&&(identical(other.activeMilestoneCount, activeMilestoneCount) || other.activeMilestoneCount == activeMilestoneCount)&&(identical(other.calculatedAtUtc, calculatedAtUtc) || other.calculatedAtUtc == calculatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,portfolioId,projectCount,progress,openTaskCount,doneTaskCount,overdueTaskCount,activeMilestoneCount,calculatedAtUtc);

@override
String toString() {
  return 'PortfolioDashboardResponse(portfolioId: $portfolioId, projectCount: $projectCount, progress: $progress, openTaskCount: $openTaskCount, doneTaskCount: $doneTaskCount, overdueTaskCount: $overdueTaskCount, activeMilestoneCount: $activeMilestoneCount, calculatedAtUtc: $calculatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$PortfolioDashboardResponseCopyWith<$Res> implements $PortfolioDashboardResponseCopyWith<$Res> {
  factory _$PortfolioDashboardResponseCopyWith(_PortfolioDashboardResponse value, $Res Function(_PortfolioDashboardResponse) _then) = __$PortfolioDashboardResponseCopyWithImpl;
@override @useResult
$Res call({
 String portfolioId, int projectCount, double progress, int openTaskCount, int doneTaskCount, int overdueTaskCount, int activeMilestoneCount, DateTime calculatedAtUtc
});




}
/// @nodoc
class __$PortfolioDashboardResponseCopyWithImpl<$Res>
    implements _$PortfolioDashboardResponseCopyWith<$Res> {
  __$PortfolioDashboardResponseCopyWithImpl(this._self, this._then);

  final _PortfolioDashboardResponse _self;
  final $Res Function(_PortfolioDashboardResponse) _then;

/// Create a copy of PortfolioDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? portfolioId = null,Object? projectCount = null,Object? progress = null,Object? openTaskCount = null,Object? doneTaskCount = null,Object? overdueTaskCount = null,Object? activeMilestoneCount = null,Object? calculatedAtUtc = null,}) {
  return _then(_PortfolioDashboardResponse(
portfolioId: null == portfolioId ? _self.portfolioId : portfolioId // ignore: cast_nullable_to_non_nullable
as String,projectCount: null == projectCount ? _self.projectCount : projectCount // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,openTaskCount: null == openTaskCount ? _self.openTaskCount : openTaskCount // ignore: cast_nullable_to_non_nullable
as int,doneTaskCount: null == doneTaskCount ? _self.doneTaskCount : doneTaskCount // ignore: cast_nullable_to_non_nullable
as int,overdueTaskCount: null == overdueTaskCount ? _self.overdueTaskCount : overdueTaskCount // ignore: cast_nullable_to_non_nullable
as int,activeMilestoneCount: null == activeMilestoneCount ? _self.activeMilestoneCount : activeMilestoneCount // ignore: cast_nullable_to_non_nullable
as int,calculatedAtUtc: null == calculatedAtUtc ? _self.calculatedAtUtc : calculatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
