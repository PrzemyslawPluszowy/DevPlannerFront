// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'milestone_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateMilestonePayload {

/// Nazwa kamienia milowego.
 String get name;/// Opcjonalny opis.
 String? get description;/// Opcjonalny termin w UTC.
 DateTime? get dueAtUtc;
/// Create a copy of CreateMilestonePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateMilestonePayloadCopyWith<CreateMilestonePayload> get copyWith => _$CreateMilestonePayloadCopyWithImpl<CreateMilestonePayload>(this as CreateMilestonePayload, _$identity);

  /// Serializes this CreateMilestonePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateMilestonePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,dueAtUtc);

@override
String toString() {
  return 'CreateMilestonePayload(name: $name, description: $description, dueAtUtc: $dueAtUtc)';
}


}

/// @nodoc
abstract mixin class $CreateMilestonePayloadCopyWith<$Res>  {
  factory $CreateMilestonePayloadCopyWith(CreateMilestonePayload value, $Res Function(CreateMilestonePayload) _then) = _$CreateMilestonePayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description, DateTime? dueAtUtc
});




}
/// @nodoc
class _$CreateMilestonePayloadCopyWithImpl<$Res>
    implements $CreateMilestonePayloadCopyWith<$Res> {
  _$CreateMilestonePayloadCopyWithImpl(this._self, this._then);

  final CreateMilestonePayload _self;
  final $Res Function(CreateMilestonePayload) _then;

/// Create a copy of CreateMilestonePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? dueAtUtc = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateMilestonePayload].
extension CreateMilestonePayloadPatterns on CreateMilestonePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateMilestonePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateMilestonePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateMilestonePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateMilestonePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateMilestonePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateMilestonePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  DateTime? dueAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateMilestonePayload() when $default != null:
return $default(_that.name,_that.description,_that.dueAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  DateTime? dueAtUtc)  $default,) {final _that = this;
switch (_that) {
case _CreateMilestonePayload():
return $default(_that.name,_that.description,_that.dueAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  DateTime? dueAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _CreateMilestonePayload() when $default != null:
return $default(_that.name,_that.description,_that.dueAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateMilestonePayload implements CreateMilestonePayload {
  const _CreateMilestonePayload({required this.name, this.description, this.dueAtUtc});
  factory _CreateMilestonePayload.fromJson(Map<String, dynamic> json) => _$CreateMilestonePayloadFromJson(json);

/// Nazwa kamienia milowego.
@override final  String name;
/// Opcjonalny opis.
@override final  String? description;
/// Opcjonalny termin w UTC.
@override final  DateTime? dueAtUtc;

/// Create a copy of CreateMilestonePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateMilestonePayloadCopyWith<_CreateMilestonePayload> get copyWith => __$CreateMilestonePayloadCopyWithImpl<_CreateMilestonePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateMilestonePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateMilestonePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,dueAtUtc);

@override
String toString() {
  return 'CreateMilestonePayload(name: $name, description: $description, dueAtUtc: $dueAtUtc)';
}


}

/// @nodoc
abstract mixin class _$CreateMilestonePayloadCopyWith<$Res> implements $CreateMilestonePayloadCopyWith<$Res> {
  factory _$CreateMilestonePayloadCopyWith(_CreateMilestonePayload value, $Res Function(_CreateMilestonePayload) _then) = __$CreateMilestonePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, DateTime? dueAtUtc
});




}
/// @nodoc
class __$CreateMilestonePayloadCopyWithImpl<$Res>
    implements _$CreateMilestonePayloadCopyWith<$Res> {
  __$CreateMilestonePayloadCopyWithImpl(this._self, this._then);

  final _CreateMilestonePayload _self;
  final $Res Function(_CreateMilestonePayload) _then;

/// Create a copy of CreateMilestonePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? dueAtUtc = freezed,}) {
  return _then(_CreateMilestonePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$UpdateMilestonePayload {

/// Nazwa kamienia milowego.
 String get name;/// Opcjonalny opis.
 String? get description;/// Opcjonalny termin w UTC.
 DateTime? get dueAtUtc;/// Status kamienia milowego.
 MilestoneStatus get status;
/// Create a copy of UpdateMilestonePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateMilestonePayloadCopyWith<UpdateMilestonePayload> get copyWith => _$UpdateMilestonePayloadCopyWithImpl<UpdateMilestonePayload>(this as UpdateMilestonePayload, _$identity);

  /// Serializes this UpdateMilestonePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateMilestonePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,dueAtUtc,status);

@override
String toString() {
  return 'UpdateMilestonePayload(name: $name, description: $description, dueAtUtc: $dueAtUtc, status: $status)';
}


}

/// @nodoc
abstract mixin class $UpdateMilestonePayloadCopyWith<$Res>  {
  factory $UpdateMilestonePayloadCopyWith(UpdateMilestonePayload value, $Res Function(UpdateMilestonePayload) _then) = _$UpdateMilestonePayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description, DateTime? dueAtUtc, MilestoneStatus status
});




}
/// @nodoc
class _$UpdateMilestonePayloadCopyWithImpl<$Res>
    implements $UpdateMilestonePayloadCopyWith<$Res> {
  _$UpdateMilestonePayloadCopyWithImpl(this._self, this._then);

  final UpdateMilestonePayload _self;
  final $Res Function(UpdateMilestonePayload) _then;

/// Create a copy of UpdateMilestonePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? dueAtUtc = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MilestoneStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateMilestonePayload].
extension UpdateMilestonePayloadPatterns on UpdateMilestonePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateMilestonePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateMilestonePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateMilestonePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateMilestonePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateMilestonePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateMilestonePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  DateTime? dueAtUtc,  MilestoneStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateMilestonePayload() when $default != null:
return $default(_that.name,_that.description,_that.dueAtUtc,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  DateTime? dueAtUtc,  MilestoneStatus status)  $default,) {final _that = this;
switch (_that) {
case _UpdateMilestonePayload():
return $default(_that.name,_that.description,_that.dueAtUtc,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  DateTime? dueAtUtc,  MilestoneStatus status)?  $default,) {final _that = this;
switch (_that) {
case _UpdateMilestonePayload() when $default != null:
return $default(_that.name,_that.description,_that.dueAtUtc,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateMilestonePayload implements UpdateMilestonePayload {
  const _UpdateMilestonePayload({required this.name, this.description, this.dueAtUtc, required this.status});
  factory _UpdateMilestonePayload.fromJson(Map<String, dynamic> json) => _$UpdateMilestonePayloadFromJson(json);

/// Nazwa kamienia milowego.
@override final  String name;
/// Opcjonalny opis.
@override final  String? description;
/// Opcjonalny termin w UTC.
@override final  DateTime? dueAtUtc;
/// Status kamienia milowego.
@override final  MilestoneStatus status;

/// Create a copy of UpdateMilestonePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateMilestonePayloadCopyWith<_UpdateMilestonePayload> get copyWith => __$UpdateMilestonePayloadCopyWithImpl<_UpdateMilestonePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateMilestonePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateMilestonePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,dueAtUtc,status);

@override
String toString() {
  return 'UpdateMilestonePayload(name: $name, description: $description, dueAtUtc: $dueAtUtc, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateMilestonePayloadCopyWith<$Res> implements $UpdateMilestonePayloadCopyWith<$Res> {
  factory _$UpdateMilestonePayloadCopyWith(_UpdateMilestonePayload value, $Res Function(_UpdateMilestonePayload) _then) = __$UpdateMilestonePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, DateTime? dueAtUtc, MilestoneStatus status
});




}
/// @nodoc
class __$UpdateMilestonePayloadCopyWithImpl<$Res>
    implements _$UpdateMilestonePayloadCopyWith<$Res> {
  __$UpdateMilestonePayloadCopyWithImpl(this._self, this._then);

  final _UpdateMilestonePayload _self;
  final $Res Function(_UpdateMilestonePayload) _then;

/// Create a copy of UpdateMilestonePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? dueAtUtc = freezed,Object? status = null,}) {
  return _then(_UpdateMilestonePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MilestoneStatus,
  ));
}


}


/// @nodoc
mixin _$MilestoneResponse {

/// UUID kamienia milowego.
 String get id;/// UUID projektu.
 String get projectId;/// UUID workspace.
 String get workspaceId;/// Nazwa kamienia milowego.
 String get name;/// Opis albo null.
 String? get description;/// Termin w UTC albo null.
 DateTime? get dueAtUtc;/// Status kamienia milowego.
 MilestoneStatus get status;/// Procent wykonania.
 double get progress;/// Czas utworzenia.
 DateTime get createdAtUtc;/// Czas aktualizacji.
 DateTime get updatedAtUtc;/// Wersja optimistic concurrency.
 int get version;
/// Create a copy of MilestoneResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneResponseCopyWith<MilestoneResponse> get copyWith => _$MilestoneResponseCopyWithImpl<MilestoneResponse>(this as MilestoneResponse, _$identity);

  /// Serializes this MilestoneResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,workspaceId,name,description,dueAtUtc,status,progress,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'MilestoneResponse(id: $id, projectId: $projectId, workspaceId: $workspaceId, name: $name, description: $description, dueAtUtc: $dueAtUtc, status: $status, progress: $progress, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $MilestoneResponseCopyWith<$Res>  {
  factory $MilestoneResponseCopyWith(MilestoneResponse value, $Res Function(MilestoneResponse) _then) = _$MilestoneResponseCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String workspaceId, String name, String? description, DateTime? dueAtUtc, MilestoneStatus status, double progress, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$MilestoneResponseCopyWithImpl<$Res>
    implements $MilestoneResponseCopyWith<$Res> {
  _$MilestoneResponseCopyWithImpl(this._self, this._then);

  final MilestoneResponse _self;
  final $Res Function(MilestoneResponse) _then;

/// Create a copy of MilestoneResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? workspaceId = null,Object? name = null,Object? description = freezed,Object? dueAtUtc = freezed,Object? status = null,Object? progress = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MilestoneStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneResponse].
extension MilestoneResponsePatterns on MilestoneResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneResponse value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String workspaceId,  String name,  String? description,  DateTime? dueAtUtc,  MilestoneStatus status,  double progress,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MilestoneResponse() when $default != null:
return $default(_that.id,_that.projectId,_that.workspaceId,_that.name,_that.description,_that.dueAtUtc,_that.status,_that.progress,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String workspaceId,  String name,  String? description,  DateTime? dueAtUtc,  MilestoneStatus status,  double progress,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _MilestoneResponse():
return $default(_that.id,_that.projectId,_that.workspaceId,_that.name,_that.description,_that.dueAtUtc,_that.status,_that.progress,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String workspaceId,  String name,  String? description,  DateTime? dueAtUtc,  MilestoneStatus status,  double progress,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _MilestoneResponse() when $default != null:
return $default(_that.id,_that.projectId,_that.workspaceId,_that.name,_that.description,_that.dueAtUtc,_that.status,_that.progress,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MilestoneResponse implements MilestoneResponse {
  const _MilestoneResponse({required this.id, required this.projectId, required this.workspaceId, required this.name, this.description, this.dueAtUtc, required this.status, required this.progress, required this.createdAtUtc, required this.updatedAtUtc, required this.version});
  factory _MilestoneResponse.fromJson(Map<String, dynamic> json) => _$MilestoneResponseFromJson(json);

/// UUID kamienia milowego.
@override final  String id;
/// UUID projektu.
@override final  String projectId;
/// UUID workspace.
@override final  String workspaceId;
/// Nazwa kamienia milowego.
@override final  String name;
/// Opis albo null.
@override final  String? description;
/// Termin w UTC albo null.
@override final  DateTime? dueAtUtc;
/// Status kamienia milowego.
@override final  MilestoneStatus status;
/// Procent wykonania.
@override final  double progress;
/// Czas utworzenia.
@override final  DateTime createdAtUtc;
/// Czas aktualizacji.
@override final  DateTime updatedAtUtc;
/// Wersja optimistic concurrency.
@override final  int version;

/// Create a copy of MilestoneResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneResponseCopyWith<_MilestoneResponse> get copyWith => __$MilestoneResponseCopyWithImpl<_MilestoneResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,workspaceId,name,description,dueAtUtc,status,progress,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'MilestoneResponse(id: $id, projectId: $projectId, workspaceId: $workspaceId, name: $name, description: $description, dueAtUtc: $dueAtUtc, status: $status, progress: $progress, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$MilestoneResponseCopyWith<$Res> implements $MilestoneResponseCopyWith<$Res> {
  factory _$MilestoneResponseCopyWith(_MilestoneResponse value, $Res Function(_MilestoneResponse) _then) = __$MilestoneResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String workspaceId, String name, String? description, DateTime? dueAtUtc, MilestoneStatus status, double progress, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$MilestoneResponseCopyWithImpl<$Res>
    implements _$MilestoneResponseCopyWith<$Res> {
  __$MilestoneResponseCopyWithImpl(this._self, this._then);

  final _MilestoneResponse _self;
  final $Res Function(_MilestoneResponse) _then;

/// Create a copy of MilestoneResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? workspaceId = null,Object? name = null,Object? description = freezed,Object? dueAtUtc = freezed,Object? status = null,Object? progress = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_MilestoneResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MilestoneStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MilestoneTaskResponse {

/// UUID zadania.
 String get id;/// Numer zadania.
 int get number;/// Klucz zadania.
 String get key;/// Tytuł zadania.
 String get title;/// Status zadania.
 ProjectTaskStatus get status;/// Priorytet zadania.
 TaskPriority get priority;/// Termin zadania albo null.
 DateTime? get dueAtUtc;/// Wersja zadania.
 int get version;
/// Create a copy of MilestoneTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MilestoneTaskResponseCopyWith<MilestoneTaskResponse> get copyWith => _$MilestoneTaskResponseCopyWithImpl<MilestoneTaskResponse>(this as MilestoneTaskResponse, _$identity);

  /// Serializes this MilestoneTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MilestoneTaskResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,title,status,priority,dueAtUtc,version);

@override
String toString() {
  return 'MilestoneTaskResponse(id: $id, number: $number, key: $key, title: $title, status: $status, priority: $priority, dueAtUtc: $dueAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $MilestoneTaskResponseCopyWith<$Res>  {
  factory $MilestoneTaskResponseCopyWith(MilestoneTaskResponse value, $Res Function(MilestoneTaskResponse) _then) = _$MilestoneTaskResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? dueAtUtc, int version
});




}
/// @nodoc
class _$MilestoneTaskResponseCopyWithImpl<$Res>
    implements $MilestoneTaskResponseCopyWith<$Res> {
  _$MilestoneTaskResponseCopyWithImpl(this._self, this._then);

  final MilestoneTaskResponse _self;
  final $Res Function(MilestoneTaskResponse) _then;

/// Create a copy of MilestoneTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? title = null,Object? status = null,Object? priority = null,Object? dueAtUtc = freezed,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MilestoneTaskResponse].
extension MilestoneTaskResponsePatterns on MilestoneTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MilestoneTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MilestoneTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MilestoneTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _MilestoneTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MilestoneTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MilestoneTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MilestoneTaskResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.priority,_that.dueAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _MilestoneTaskResponse():
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.priority,_that.dueAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? dueAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _MilestoneTaskResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.title,_that.status,_that.priority,_that.dueAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MilestoneTaskResponse implements MilestoneTaskResponse {
  const _MilestoneTaskResponse({required this.id, required this.number, required this.key, required this.title, required this.status, required this.priority, this.dueAtUtc, required this.version});
  factory _MilestoneTaskResponse.fromJson(Map<String, dynamic> json) => _$MilestoneTaskResponseFromJson(json);

/// UUID zadania.
@override final  String id;
/// Numer zadania.
@override final  int number;
/// Klucz zadania.
@override final  String key;
/// Tytuł zadania.
@override final  String title;
/// Status zadania.
@override final  ProjectTaskStatus status;
/// Priorytet zadania.
@override final  TaskPriority priority;
/// Termin zadania albo null.
@override final  DateTime? dueAtUtc;
/// Wersja zadania.
@override final  int version;

/// Create a copy of MilestoneTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MilestoneTaskResponseCopyWith<_MilestoneTaskResponse> get copyWith => __$MilestoneTaskResponseCopyWithImpl<_MilestoneTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MilestoneTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MilestoneTaskResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,key,title,status,priority,dueAtUtc,version);

@override
String toString() {
  return 'MilestoneTaskResponse(id: $id, number: $number, key: $key, title: $title, status: $status, priority: $priority, dueAtUtc: $dueAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$MilestoneTaskResponseCopyWith<$Res> implements $MilestoneTaskResponseCopyWith<$Res> {
  factory _$MilestoneTaskResponseCopyWith(_MilestoneTaskResponse value, $Res Function(_MilestoneTaskResponse) _then) = __$MilestoneTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? dueAtUtc, int version
});




}
/// @nodoc
class __$MilestoneTaskResponseCopyWithImpl<$Res>
    implements _$MilestoneTaskResponseCopyWith<$Res> {
  __$MilestoneTaskResponseCopyWithImpl(this._self, this._then);

  final _MilestoneTaskResponse _self;
  final $Res Function(_MilestoneTaskResponse) _then;

/// Create a copy of MilestoneTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? title = null,Object? status = null,Object? priority = null,Object? dueAtUtc = freezed,Object? version = null,}) {
  return _then(_MilestoneTaskResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
