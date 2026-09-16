// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_workflow_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectCustomStatusResponse {

/// UUID statusu.
 String get id;/// UUID projektu.
 String get projectId;/// Nazwa statusu.
 String get name;/// Kolor HEX kolumny.
 String get colorHex;/// Kategoria analityczna statusu.
 TaskStatusCategory get category;/// Pozycja statusu od zera.
 int get position;/// Limit WIP albo null.
 int? get wipLimit;/// Czy status jest domyślny dla nowych zadań.
 bool get isDefault;/// Liczba zadań w statusie.
 int get taskCount;/// Wersja optimistic concurrency.
 int get version;
/// Create a copy of ProjectCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectCustomStatusResponseCopyWith<ProjectCustomStatusResponse> get copyWith => _$ProjectCustomStatusResponseCopyWithImpl<ProjectCustomStatusResponse>(this as ProjectCustomStatusResponse, _$identity);

  /// Serializes this ProjectCustomStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectCustomStatusResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.category, category) || other.category == category)&&(identical(other.position, position) || other.position == position)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.taskCount, taskCount) || other.taskCount == taskCount)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name,colorHex,category,position,wipLimit,isDefault,taskCount,version);

@override
String toString() {
  return 'ProjectCustomStatusResponse(id: $id, projectId: $projectId, name: $name, colorHex: $colorHex, category: $category, position: $position, wipLimit: $wipLimit, isDefault: $isDefault, taskCount: $taskCount, version: $version)';
}


}

/// @nodoc
abstract mixin class $ProjectCustomStatusResponseCopyWith<$Res>  {
  factory $ProjectCustomStatusResponseCopyWith(ProjectCustomStatusResponse value, $Res Function(ProjectCustomStatusResponse) _then) = _$ProjectCustomStatusResponseCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String name, String colorHex, TaskStatusCategory category, int position, int? wipLimit, bool isDefault, int taskCount, int version
});




}
/// @nodoc
class _$ProjectCustomStatusResponseCopyWithImpl<$Res>
    implements $ProjectCustomStatusResponseCopyWith<$Res> {
  _$ProjectCustomStatusResponseCopyWithImpl(this._self, this._then);

  final ProjectCustomStatusResponse _self;
  final $Res Function(ProjectCustomStatusResponse) _then;

/// Create a copy of ProjectCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? name = null,Object? colorHex = null,Object? category = null,Object? position = null,Object? wipLimit = freezed,Object? isDefault = null,Object? taskCount = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,taskCount: null == taskCount ? _self.taskCount : taskCount // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectCustomStatusResponse].
extension ProjectCustomStatusResponsePatterns on ProjectCustomStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectCustomStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectCustomStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectCustomStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectCustomStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectCustomStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectCustomStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String name,  String colorHex,  TaskStatusCategory category,  int position,  int? wipLimit,  bool isDefault,  int taskCount,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectCustomStatusResponse() when $default != null:
return $default(_that.id,_that.projectId,_that.name,_that.colorHex,_that.category,_that.position,_that.wipLimit,_that.isDefault,_that.taskCount,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String name,  String colorHex,  TaskStatusCategory category,  int position,  int? wipLimit,  bool isDefault,  int taskCount,  int version)  $default,) {final _that = this;
switch (_that) {
case _ProjectCustomStatusResponse():
return $default(_that.id,_that.projectId,_that.name,_that.colorHex,_that.category,_that.position,_that.wipLimit,_that.isDefault,_that.taskCount,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String name,  String colorHex,  TaskStatusCategory category,  int position,  int? wipLimit,  bool isDefault,  int taskCount,  int version)?  $default,) {final _that = this;
switch (_that) {
case _ProjectCustomStatusResponse() when $default != null:
return $default(_that.id,_that.projectId,_that.name,_that.colorHex,_that.category,_that.position,_that.wipLimit,_that.isDefault,_that.taskCount,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectCustomStatusResponse implements ProjectCustomStatusResponse {
  const _ProjectCustomStatusResponse({required this.id, required this.projectId, required this.name, required this.colorHex, required this.category, required this.position, this.wipLimit, required this.isDefault, required this.taskCount, required this.version});
  factory _ProjectCustomStatusResponse.fromJson(Map<String, dynamic> json) => _$ProjectCustomStatusResponseFromJson(json);

/// UUID statusu.
@override final  String id;
/// UUID projektu.
@override final  String projectId;
/// Nazwa statusu.
@override final  String name;
/// Kolor HEX kolumny.
@override final  String colorHex;
/// Kategoria analityczna statusu.
@override final  TaskStatusCategory category;
/// Pozycja statusu od zera.
@override final  int position;
/// Limit WIP albo null.
@override final  int? wipLimit;
/// Czy status jest domyślny dla nowych zadań.
@override final  bool isDefault;
/// Liczba zadań w statusie.
@override final  int taskCount;
/// Wersja optimistic concurrency.
@override final  int version;

/// Create a copy of ProjectCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectCustomStatusResponseCopyWith<_ProjectCustomStatusResponse> get copyWith => __$ProjectCustomStatusResponseCopyWithImpl<_ProjectCustomStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectCustomStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectCustomStatusResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.category, category) || other.category == category)&&(identical(other.position, position) || other.position == position)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.taskCount, taskCount) || other.taskCount == taskCount)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name,colorHex,category,position,wipLimit,isDefault,taskCount,version);

@override
String toString() {
  return 'ProjectCustomStatusResponse(id: $id, projectId: $projectId, name: $name, colorHex: $colorHex, category: $category, position: $position, wipLimit: $wipLimit, isDefault: $isDefault, taskCount: $taskCount, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ProjectCustomStatusResponseCopyWith<$Res> implements $ProjectCustomStatusResponseCopyWith<$Res> {
  factory _$ProjectCustomStatusResponseCopyWith(_ProjectCustomStatusResponse value, $Res Function(_ProjectCustomStatusResponse) _then) = __$ProjectCustomStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String name, String colorHex, TaskStatusCategory category, int position, int? wipLimit, bool isDefault, int taskCount, int version
});




}
/// @nodoc
class __$ProjectCustomStatusResponseCopyWithImpl<$Res>
    implements _$ProjectCustomStatusResponseCopyWith<$Res> {
  __$ProjectCustomStatusResponseCopyWithImpl(this._self, this._then);

  final _ProjectCustomStatusResponse _self;
  final $Res Function(_ProjectCustomStatusResponse) _then;

/// Create a copy of ProjectCustomStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? name = null,Object? colorHex = null,Object? category = null,Object? position = null,Object? wipLimit = freezed,Object? isDefault = null,Object? taskCount = null,Object? version = null,}) {
  return _then(_ProjectCustomStatusResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,taskCount: null == taskCount ? _self.taskCount : taskCount // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateProjectCustomStatusPayload {

/// Nazwa statusu.
 String get name;/// Kolor HEX kolumny.
 String get colorHex;/// Kategoria analityczna.
 TaskStatusCategory get category;/// Pozycja od zera albo null.
 int? get position;/// Limit WIP albo null.
 int? get wipLimit;/// Czy status jest domyślny.
 bool get isDefault;
/// Create a copy of CreateProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProjectCustomStatusPayloadCopyWith<CreateProjectCustomStatusPayload> get copyWith => _$CreateProjectCustomStatusPayloadCopyWithImpl<CreateProjectCustomStatusPayload>(this as CreateProjectCustomStatusPayload, _$identity);

  /// Serializes this CreateProjectCustomStatusPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProjectCustomStatusPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.category, category) || other.category == category)&&(identical(other.position, position) || other.position == position)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,colorHex,category,position,wipLimit,isDefault);

@override
String toString() {
  return 'CreateProjectCustomStatusPayload(name: $name, colorHex: $colorHex, category: $category, position: $position, wipLimit: $wipLimit, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $CreateProjectCustomStatusPayloadCopyWith<$Res>  {
  factory $CreateProjectCustomStatusPayloadCopyWith(CreateProjectCustomStatusPayload value, $Res Function(CreateProjectCustomStatusPayload) _then) = _$CreateProjectCustomStatusPayloadCopyWithImpl;
@useResult
$Res call({
 String name, String colorHex, TaskStatusCategory category, int? position, int? wipLimit, bool isDefault
});




}
/// @nodoc
class _$CreateProjectCustomStatusPayloadCopyWithImpl<$Res>
    implements $CreateProjectCustomStatusPayloadCopyWith<$Res> {
  _$CreateProjectCustomStatusPayloadCopyWithImpl(this._self, this._then);

  final CreateProjectCustomStatusPayload _self;
  final $Res Function(CreateProjectCustomStatusPayload) _then;

/// Create a copy of CreateProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? colorHex = null,Object? category = null,Object? position = freezed,Object? wipLimit = freezed,Object? isDefault = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProjectCustomStatusPayload].
extension CreateProjectCustomStatusPayloadPatterns on CreateProjectCustomStatusPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProjectCustomStatusPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProjectCustomStatusPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProjectCustomStatusPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateProjectCustomStatusPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProjectCustomStatusPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProjectCustomStatusPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String colorHex,  TaskStatusCategory category,  int? position,  int? wipLimit,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProjectCustomStatusPayload() when $default != null:
return $default(_that.name,_that.colorHex,_that.category,_that.position,_that.wipLimit,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String colorHex,  TaskStatusCategory category,  int? position,  int? wipLimit,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _CreateProjectCustomStatusPayload():
return $default(_that.name,_that.colorHex,_that.category,_that.position,_that.wipLimit,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String colorHex,  TaskStatusCategory category,  int? position,  int? wipLimit,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _CreateProjectCustomStatusPayload() when $default != null:
return $default(_that.name,_that.colorHex,_that.category,_that.position,_that.wipLimit,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProjectCustomStatusPayload implements CreateProjectCustomStatusPayload {
  const _CreateProjectCustomStatusPayload({required this.name, required this.colorHex, required this.category, this.position, this.wipLimit, this.isDefault = false});
  factory _CreateProjectCustomStatusPayload.fromJson(Map<String, dynamic> json) => _$CreateProjectCustomStatusPayloadFromJson(json);

/// Nazwa statusu.
@override final  String name;
/// Kolor HEX kolumny.
@override final  String colorHex;
/// Kategoria analityczna.
@override final  TaskStatusCategory category;
/// Pozycja od zera albo null.
@override final  int? position;
/// Limit WIP albo null.
@override final  int? wipLimit;
/// Czy status jest domyślny.
@override@JsonKey() final  bool isDefault;

/// Create a copy of CreateProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProjectCustomStatusPayloadCopyWith<_CreateProjectCustomStatusPayload> get copyWith => __$CreateProjectCustomStatusPayloadCopyWithImpl<_CreateProjectCustomStatusPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProjectCustomStatusPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProjectCustomStatusPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.category, category) || other.category == category)&&(identical(other.position, position) || other.position == position)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,colorHex,category,position,wipLimit,isDefault);

@override
String toString() {
  return 'CreateProjectCustomStatusPayload(name: $name, colorHex: $colorHex, category: $category, position: $position, wipLimit: $wipLimit, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$CreateProjectCustomStatusPayloadCopyWith<$Res> implements $CreateProjectCustomStatusPayloadCopyWith<$Res> {
  factory _$CreateProjectCustomStatusPayloadCopyWith(_CreateProjectCustomStatusPayload value, $Res Function(_CreateProjectCustomStatusPayload) _then) = __$CreateProjectCustomStatusPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String colorHex, TaskStatusCategory category, int? position, int? wipLimit, bool isDefault
});




}
/// @nodoc
class __$CreateProjectCustomStatusPayloadCopyWithImpl<$Res>
    implements _$CreateProjectCustomStatusPayloadCopyWith<$Res> {
  __$CreateProjectCustomStatusPayloadCopyWithImpl(this._self, this._then);

  final _CreateProjectCustomStatusPayload _self;
  final $Res Function(_CreateProjectCustomStatusPayload) _then;

/// Create a copy of CreateProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? colorHex = null,Object? category = null,Object? position = freezed,Object? wipLimit = freezed,Object? isDefault = null,}) {
  return _then(_CreateProjectCustomStatusPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UpdateProjectCustomStatusPayload {

/// Nowa nazwa statusu.
 String get name;/// Nowy kolor HEX.
 String get colorHex;/// Nowa kategoria analityczna.
 TaskStatusCategory get category;/// Nowy limit WIP albo null.
 int? get wipLimit;/// Czy status ma być domyślny.
 bool get isDefault;/// Oczekiwana wersja statusu.
 int get expectedVersion;
/// Create a copy of UpdateProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProjectCustomStatusPayloadCopyWith<UpdateProjectCustomStatusPayload> get copyWith => _$UpdateProjectCustomStatusPayloadCopyWithImpl<UpdateProjectCustomStatusPayload>(this as UpdateProjectCustomStatusPayload, _$identity);

  /// Serializes this UpdateProjectCustomStatusPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProjectCustomStatusPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.category, category) || other.category == category)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,colorHex,category,wipLimit,isDefault,expectedVersion);

@override
String toString() {
  return 'UpdateProjectCustomStatusPayload(name: $name, colorHex: $colorHex, category: $category, wipLimit: $wipLimit, isDefault: $isDefault, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateProjectCustomStatusPayloadCopyWith<$Res>  {
  factory $UpdateProjectCustomStatusPayloadCopyWith(UpdateProjectCustomStatusPayload value, $Res Function(UpdateProjectCustomStatusPayload) _then) = _$UpdateProjectCustomStatusPayloadCopyWithImpl;
@useResult
$Res call({
 String name, String colorHex, TaskStatusCategory category, int? wipLimit, bool isDefault, int expectedVersion
});




}
/// @nodoc
class _$UpdateProjectCustomStatusPayloadCopyWithImpl<$Res>
    implements $UpdateProjectCustomStatusPayloadCopyWith<$Res> {
  _$UpdateProjectCustomStatusPayloadCopyWithImpl(this._self, this._then);

  final UpdateProjectCustomStatusPayload _self;
  final $Res Function(UpdateProjectCustomStatusPayload) _then;

/// Create a copy of UpdateProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? colorHex = null,Object? category = null,Object? wipLimit = freezed,Object? isDefault = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProjectCustomStatusPayload].
extension UpdateProjectCustomStatusPayloadPatterns on UpdateProjectCustomStatusPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProjectCustomStatusPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProjectCustomStatusPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProjectCustomStatusPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectCustomStatusPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProjectCustomStatusPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectCustomStatusPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String colorHex,  TaskStatusCategory category,  int? wipLimit,  bool isDefault,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProjectCustomStatusPayload() when $default != null:
return $default(_that.name,_that.colorHex,_that.category,_that.wipLimit,_that.isDefault,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String colorHex,  TaskStatusCategory category,  int? wipLimit,  bool isDefault,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectCustomStatusPayload():
return $default(_that.name,_that.colorHex,_that.category,_that.wipLimit,_that.isDefault,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String colorHex,  TaskStatusCategory category,  int? wipLimit,  bool isDefault,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectCustomStatusPayload() when $default != null:
return $default(_that.name,_that.colorHex,_that.category,_that.wipLimit,_that.isDefault,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProjectCustomStatusPayload implements UpdateProjectCustomStatusPayload {
  const _UpdateProjectCustomStatusPayload({required this.name, required this.colorHex, required this.category, this.wipLimit, required this.isDefault, required this.expectedVersion});
  factory _UpdateProjectCustomStatusPayload.fromJson(Map<String, dynamic> json) => _$UpdateProjectCustomStatusPayloadFromJson(json);

/// Nowa nazwa statusu.
@override final  String name;
/// Nowy kolor HEX.
@override final  String colorHex;
/// Nowa kategoria analityczna.
@override final  TaskStatusCategory category;
/// Nowy limit WIP albo null.
@override final  int? wipLimit;
/// Czy status ma być domyślny.
@override final  bool isDefault;
/// Oczekiwana wersja statusu.
@override final  int expectedVersion;

/// Create a copy of UpdateProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProjectCustomStatusPayloadCopyWith<_UpdateProjectCustomStatusPayload> get copyWith => __$UpdateProjectCustomStatusPayloadCopyWithImpl<_UpdateProjectCustomStatusPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProjectCustomStatusPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProjectCustomStatusPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.category, category) || other.category == category)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,colorHex,category,wipLimit,isDefault,expectedVersion);

@override
String toString() {
  return 'UpdateProjectCustomStatusPayload(name: $name, colorHex: $colorHex, category: $category, wipLimit: $wipLimit, isDefault: $isDefault, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateProjectCustomStatusPayloadCopyWith<$Res> implements $UpdateProjectCustomStatusPayloadCopyWith<$Res> {
  factory _$UpdateProjectCustomStatusPayloadCopyWith(_UpdateProjectCustomStatusPayload value, $Res Function(_UpdateProjectCustomStatusPayload) _then) = __$UpdateProjectCustomStatusPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String colorHex, TaskStatusCategory category, int? wipLimit, bool isDefault, int expectedVersion
});




}
/// @nodoc
class __$UpdateProjectCustomStatusPayloadCopyWithImpl<$Res>
    implements _$UpdateProjectCustomStatusPayloadCopyWith<$Res> {
  __$UpdateProjectCustomStatusPayloadCopyWithImpl(this._self, this._then);

  final _UpdateProjectCustomStatusPayload _self;
  final $Res Function(_UpdateProjectCustomStatusPayload) _then;

/// Create a copy of UpdateProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? colorHex = null,Object? category = null,Object? wipLimit = freezed,Object? isDefault = null,Object? expectedVersion = null,}) {
  return _then(_UpdateProjectCustomStatusPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReorderProjectCustomStatusesPayload {

/// UUID-y statusów w nowej kolejności.
 List<String> get statusIds;
/// Create a copy of ReorderProjectCustomStatusesPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReorderProjectCustomStatusesPayloadCopyWith<ReorderProjectCustomStatusesPayload> get copyWith => _$ReorderProjectCustomStatusesPayloadCopyWithImpl<ReorderProjectCustomStatusesPayload>(this as ReorderProjectCustomStatusesPayload, _$identity);

  /// Serializes this ReorderProjectCustomStatusesPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReorderProjectCustomStatusesPayload&&const DeepCollectionEquality().equals(other.statusIds, statusIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(statusIds));

@override
String toString() {
  return 'ReorderProjectCustomStatusesPayload(statusIds: $statusIds)';
}


}

/// @nodoc
abstract mixin class $ReorderProjectCustomStatusesPayloadCopyWith<$Res>  {
  factory $ReorderProjectCustomStatusesPayloadCopyWith(ReorderProjectCustomStatusesPayload value, $Res Function(ReorderProjectCustomStatusesPayload) _then) = _$ReorderProjectCustomStatusesPayloadCopyWithImpl;
@useResult
$Res call({
 List<String> statusIds
});




}
/// @nodoc
class _$ReorderProjectCustomStatusesPayloadCopyWithImpl<$Res>
    implements $ReorderProjectCustomStatusesPayloadCopyWith<$Res> {
  _$ReorderProjectCustomStatusesPayloadCopyWithImpl(this._self, this._then);

  final ReorderProjectCustomStatusesPayload _self;
  final $Res Function(ReorderProjectCustomStatusesPayload) _then;

/// Create a copy of ReorderProjectCustomStatusesPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusIds = null,}) {
  return _then(_self.copyWith(
statusIds: null == statusIds ? _self.statusIds : statusIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReorderProjectCustomStatusesPayload].
extension ReorderProjectCustomStatusesPayloadPatterns on ReorderProjectCustomStatusesPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReorderProjectCustomStatusesPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReorderProjectCustomStatusesPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReorderProjectCustomStatusesPayload value)  $default,){
final _that = this;
switch (_that) {
case _ReorderProjectCustomStatusesPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReorderProjectCustomStatusesPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ReorderProjectCustomStatusesPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> statusIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReorderProjectCustomStatusesPayload() when $default != null:
return $default(_that.statusIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> statusIds)  $default,) {final _that = this;
switch (_that) {
case _ReorderProjectCustomStatusesPayload():
return $default(_that.statusIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> statusIds)?  $default,) {final _that = this;
switch (_that) {
case _ReorderProjectCustomStatusesPayload() when $default != null:
return $default(_that.statusIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReorderProjectCustomStatusesPayload implements ReorderProjectCustomStatusesPayload {
  const _ReorderProjectCustomStatusesPayload({required this.statusIds});
  factory _ReorderProjectCustomStatusesPayload.fromJson(Map<String, dynamic> json) => _$ReorderProjectCustomStatusesPayloadFromJson(json);

/// UUID-y statusów w nowej kolejności.
@override final  List<String> statusIds;

/// Create a copy of ReorderProjectCustomStatusesPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReorderProjectCustomStatusesPayloadCopyWith<_ReorderProjectCustomStatusesPayload> get copyWith => __$ReorderProjectCustomStatusesPayloadCopyWithImpl<_ReorderProjectCustomStatusesPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReorderProjectCustomStatusesPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReorderProjectCustomStatusesPayload&&const DeepCollectionEquality().equals(other.statusIds, statusIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(statusIds));

@override
String toString() {
  return 'ReorderProjectCustomStatusesPayload(statusIds: $statusIds)';
}


}

/// @nodoc
abstract mixin class _$ReorderProjectCustomStatusesPayloadCopyWith<$Res> implements $ReorderProjectCustomStatusesPayloadCopyWith<$Res> {
  factory _$ReorderProjectCustomStatusesPayloadCopyWith(_ReorderProjectCustomStatusesPayload value, $Res Function(_ReorderProjectCustomStatusesPayload) _then) = __$ReorderProjectCustomStatusesPayloadCopyWithImpl;
@override @useResult
$Res call({
 List<String> statusIds
});




}
/// @nodoc
class __$ReorderProjectCustomStatusesPayloadCopyWithImpl<$Res>
    implements _$ReorderProjectCustomStatusesPayloadCopyWith<$Res> {
  __$ReorderProjectCustomStatusesPayloadCopyWithImpl(this._self, this._then);

  final _ReorderProjectCustomStatusesPayload _self;
  final $Res Function(_ReorderProjectCustomStatusesPayload) _then;

/// Create a copy of ReorderProjectCustomStatusesPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusIds = null,}) {
  return _then(_ReorderProjectCustomStatusesPayload(
statusIds: null == statusIds ? _self.statusIds : statusIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$DeleteProjectCustomStatusPayload {

/// UUID statusu, do którego zostaną przeniesione zadania.
 String get fallbackStatusId;/// Oczekiwana wersja archiwizowanego statusu.
 int get expectedVersion;
/// Create a copy of DeleteProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteProjectCustomStatusPayloadCopyWith<DeleteProjectCustomStatusPayload> get copyWith => _$DeleteProjectCustomStatusPayloadCopyWithImpl<DeleteProjectCustomStatusPayload>(this as DeleteProjectCustomStatusPayload, _$identity);

  /// Serializes this DeleteProjectCustomStatusPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteProjectCustomStatusPayload&&(identical(other.fallbackStatusId, fallbackStatusId) || other.fallbackStatusId == fallbackStatusId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fallbackStatusId,expectedVersion);

@override
String toString() {
  return 'DeleteProjectCustomStatusPayload(fallbackStatusId: $fallbackStatusId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $DeleteProjectCustomStatusPayloadCopyWith<$Res>  {
  factory $DeleteProjectCustomStatusPayloadCopyWith(DeleteProjectCustomStatusPayload value, $Res Function(DeleteProjectCustomStatusPayload) _then) = _$DeleteProjectCustomStatusPayloadCopyWithImpl;
@useResult
$Res call({
 String fallbackStatusId, int expectedVersion
});




}
/// @nodoc
class _$DeleteProjectCustomStatusPayloadCopyWithImpl<$Res>
    implements $DeleteProjectCustomStatusPayloadCopyWith<$Res> {
  _$DeleteProjectCustomStatusPayloadCopyWithImpl(this._self, this._then);

  final DeleteProjectCustomStatusPayload _self;
  final $Res Function(DeleteProjectCustomStatusPayload) _then;

/// Create a copy of DeleteProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fallbackStatusId = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
fallbackStatusId: null == fallbackStatusId ? _self.fallbackStatusId : fallbackStatusId // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteProjectCustomStatusPayload].
extension DeleteProjectCustomStatusPayloadPatterns on DeleteProjectCustomStatusPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteProjectCustomStatusPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteProjectCustomStatusPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteProjectCustomStatusPayload value)  $default,){
final _that = this;
switch (_that) {
case _DeleteProjectCustomStatusPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteProjectCustomStatusPayload value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteProjectCustomStatusPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fallbackStatusId,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeleteProjectCustomStatusPayload() when $default != null:
return $default(_that.fallbackStatusId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fallbackStatusId,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _DeleteProjectCustomStatusPayload():
return $default(_that.fallbackStatusId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fallbackStatusId,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _DeleteProjectCustomStatusPayload() when $default != null:
return $default(_that.fallbackStatusId,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeleteProjectCustomStatusPayload implements DeleteProjectCustomStatusPayload {
  const _DeleteProjectCustomStatusPayload({required this.fallbackStatusId, required this.expectedVersion});
  factory _DeleteProjectCustomStatusPayload.fromJson(Map<String, dynamic> json) => _$DeleteProjectCustomStatusPayloadFromJson(json);

/// UUID statusu, do którego zostaną przeniesione zadania.
@override final  String fallbackStatusId;
/// Oczekiwana wersja archiwizowanego statusu.
@override final  int expectedVersion;

/// Create a copy of DeleteProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteProjectCustomStatusPayloadCopyWith<_DeleteProjectCustomStatusPayload> get copyWith => __$DeleteProjectCustomStatusPayloadCopyWithImpl<_DeleteProjectCustomStatusPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteProjectCustomStatusPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteProjectCustomStatusPayload&&(identical(other.fallbackStatusId, fallbackStatusId) || other.fallbackStatusId == fallbackStatusId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fallbackStatusId,expectedVersion);

@override
String toString() {
  return 'DeleteProjectCustomStatusPayload(fallbackStatusId: $fallbackStatusId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$DeleteProjectCustomStatusPayloadCopyWith<$Res> implements $DeleteProjectCustomStatusPayloadCopyWith<$Res> {
  factory _$DeleteProjectCustomStatusPayloadCopyWith(_DeleteProjectCustomStatusPayload value, $Res Function(_DeleteProjectCustomStatusPayload) _then) = __$DeleteProjectCustomStatusPayloadCopyWithImpl;
@override @useResult
$Res call({
 String fallbackStatusId, int expectedVersion
});




}
/// @nodoc
class __$DeleteProjectCustomStatusPayloadCopyWithImpl<$Res>
    implements _$DeleteProjectCustomStatusPayloadCopyWith<$Res> {
  __$DeleteProjectCustomStatusPayloadCopyWithImpl(this._self, this._then);

  final _DeleteProjectCustomStatusPayload _self;
  final $Res Function(_DeleteProjectCustomStatusPayload) _then;

/// Create a copy of DeleteProjectCustomStatusPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fallbackStatusId = null,Object? expectedVersion = null,}) {
  return _then(_DeleteProjectCustomStatusPayload(
fallbackStatusId: null == fallbackStatusId ? _self.fallbackStatusId : fallbackStatusId // ignore: cast_nullable_to_non_nullable
as String,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ApplyWorkflowTemplatePayload {

/// Klucz szablonu workflow.
 String get templateKey;/// Czy zastąpić istniejący workflow.
 bool get replaceExisting;
/// Create a copy of ApplyWorkflowTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyWorkflowTemplatePayloadCopyWith<ApplyWorkflowTemplatePayload> get copyWith => _$ApplyWorkflowTemplatePayloadCopyWithImpl<ApplyWorkflowTemplatePayload>(this as ApplyWorkflowTemplatePayload, _$identity);

  /// Serializes this ApplyWorkflowTemplatePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyWorkflowTemplatePayload&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.replaceExisting, replaceExisting) || other.replaceExisting == replaceExisting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateKey,replaceExisting);

@override
String toString() {
  return 'ApplyWorkflowTemplatePayload(templateKey: $templateKey, replaceExisting: $replaceExisting)';
}


}

/// @nodoc
abstract mixin class $ApplyWorkflowTemplatePayloadCopyWith<$Res>  {
  factory $ApplyWorkflowTemplatePayloadCopyWith(ApplyWorkflowTemplatePayload value, $Res Function(ApplyWorkflowTemplatePayload) _then) = _$ApplyWorkflowTemplatePayloadCopyWithImpl;
@useResult
$Res call({
 String templateKey, bool replaceExisting
});




}
/// @nodoc
class _$ApplyWorkflowTemplatePayloadCopyWithImpl<$Res>
    implements $ApplyWorkflowTemplatePayloadCopyWith<$Res> {
  _$ApplyWorkflowTemplatePayloadCopyWithImpl(this._self, this._then);

  final ApplyWorkflowTemplatePayload _self;
  final $Res Function(ApplyWorkflowTemplatePayload) _then;

/// Create a copy of ApplyWorkflowTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templateKey = null,Object? replaceExisting = null,}) {
  return _then(_self.copyWith(
templateKey: null == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String,replaceExisting: null == replaceExisting ? _self.replaceExisting : replaceExisting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplyWorkflowTemplatePayload].
extension ApplyWorkflowTemplatePayloadPatterns on ApplyWorkflowTemplatePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplyWorkflowTemplatePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplyWorkflowTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplyWorkflowTemplatePayload value)  $default,){
final _that = this;
switch (_that) {
case _ApplyWorkflowTemplatePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplyWorkflowTemplatePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ApplyWorkflowTemplatePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String templateKey,  bool replaceExisting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplyWorkflowTemplatePayload() when $default != null:
return $default(_that.templateKey,_that.replaceExisting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String templateKey,  bool replaceExisting)  $default,) {final _that = this;
switch (_that) {
case _ApplyWorkflowTemplatePayload():
return $default(_that.templateKey,_that.replaceExisting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String templateKey,  bool replaceExisting)?  $default,) {final _that = this;
switch (_that) {
case _ApplyWorkflowTemplatePayload() when $default != null:
return $default(_that.templateKey,_that.replaceExisting);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplyWorkflowTemplatePayload implements ApplyWorkflowTemplatePayload {
  const _ApplyWorkflowTemplatePayload({required this.templateKey, this.replaceExisting = false});
  factory _ApplyWorkflowTemplatePayload.fromJson(Map<String, dynamic> json) => _$ApplyWorkflowTemplatePayloadFromJson(json);

/// Klucz szablonu workflow.
@override final  String templateKey;
/// Czy zastąpić istniejący workflow.
@override@JsonKey() final  bool replaceExisting;

/// Create a copy of ApplyWorkflowTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplyWorkflowTemplatePayloadCopyWith<_ApplyWorkflowTemplatePayload> get copyWith => __$ApplyWorkflowTemplatePayloadCopyWithImpl<_ApplyWorkflowTemplatePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplyWorkflowTemplatePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplyWorkflowTemplatePayload&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.replaceExisting, replaceExisting) || other.replaceExisting == replaceExisting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateKey,replaceExisting);

@override
String toString() {
  return 'ApplyWorkflowTemplatePayload(templateKey: $templateKey, replaceExisting: $replaceExisting)';
}


}

/// @nodoc
abstract mixin class _$ApplyWorkflowTemplatePayloadCopyWith<$Res> implements $ApplyWorkflowTemplatePayloadCopyWith<$Res> {
  factory _$ApplyWorkflowTemplatePayloadCopyWith(_ApplyWorkflowTemplatePayload value, $Res Function(_ApplyWorkflowTemplatePayload) _then) = __$ApplyWorkflowTemplatePayloadCopyWithImpl;
@override @useResult
$Res call({
 String templateKey, bool replaceExisting
});




}
/// @nodoc
class __$ApplyWorkflowTemplatePayloadCopyWithImpl<$Res>
    implements _$ApplyWorkflowTemplatePayloadCopyWith<$Res> {
  __$ApplyWorkflowTemplatePayloadCopyWithImpl(this._self, this._then);

  final _ApplyWorkflowTemplatePayload _self;
  final $Res Function(_ApplyWorkflowTemplatePayload) _then;

/// Create a copy of ApplyWorkflowTemplatePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templateKey = null,Object? replaceExisting = null,}) {
  return _then(_ApplyWorkflowTemplatePayload(
templateKey: null == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String,replaceExisting: null == replaceExisting ? _self.replaceExisting : replaceExisting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WorkflowTemplateSummary {

/// Stabilny klucz szablonu.
 String get key;/// Nazwa szablonu.
 String get name;/// Nazwy statusów w szablonie.
 List<String> get statusNames;
/// Create a copy of WorkflowTemplateSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowTemplateSummaryCopyWith<WorkflowTemplateSummary> get copyWith => _$WorkflowTemplateSummaryCopyWithImpl<WorkflowTemplateSummary>(this as WorkflowTemplateSummary, _$identity);

  /// Serializes this WorkflowTemplateSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowTemplateSummary&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.statusNames, statusNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,const DeepCollectionEquality().hash(statusNames));

@override
String toString() {
  return 'WorkflowTemplateSummary(key: $key, name: $name, statusNames: $statusNames)';
}


}

/// @nodoc
abstract mixin class $WorkflowTemplateSummaryCopyWith<$Res>  {
  factory $WorkflowTemplateSummaryCopyWith(WorkflowTemplateSummary value, $Res Function(WorkflowTemplateSummary) _then) = _$WorkflowTemplateSummaryCopyWithImpl;
@useResult
$Res call({
 String key, String name, List<String> statusNames
});




}
/// @nodoc
class _$WorkflowTemplateSummaryCopyWithImpl<$Res>
    implements $WorkflowTemplateSummaryCopyWith<$Res> {
  _$WorkflowTemplateSummaryCopyWithImpl(this._self, this._then);

  final WorkflowTemplateSummary _self;
  final $Res Function(WorkflowTemplateSummary) _then;

/// Create a copy of WorkflowTemplateSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? statusNames = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,statusNames: null == statusNames ? _self.statusNames : statusNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowTemplateSummary].
extension WorkflowTemplateSummaryPatterns on WorkflowTemplateSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowTemplateSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowTemplateSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowTemplateSummary value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowTemplateSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowTemplateSummary value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowTemplateSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  List<String> statusNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowTemplateSummary() when $default != null:
return $default(_that.key,_that.name,_that.statusNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  List<String> statusNames)  $default,) {final _that = this;
switch (_that) {
case _WorkflowTemplateSummary():
return $default(_that.key,_that.name,_that.statusNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  List<String> statusNames)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowTemplateSummary() when $default != null:
return $default(_that.key,_that.name,_that.statusNames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkflowTemplateSummary implements WorkflowTemplateSummary {
  const _WorkflowTemplateSummary({required this.key, required this.name, required this.statusNames});
  factory _WorkflowTemplateSummary.fromJson(Map<String, dynamic> json) => _$WorkflowTemplateSummaryFromJson(json);

/// Stabilny klucz szablonu.
@override final  String key;
/// Nazwa szablonu.
@override final  String name;
/// Nazwy statusów w szablonie.
@override final  List<String> statusNames;

/// Create a copy of WorkflowTemplateSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowTemplateSummaryCopyWith<_WorkflowTemplateSummary> get copyWith => __$WorkflowTemplateSummaryCopyWithImpl<_WorkflowTemplateSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkflowTemplateSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowTemplateSummary&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.statusNames, statusNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,const DeepCollectionEquality().hash(statusNames));

@override
String toString() {
  return 'WorkflowTemplateSummary(key: $key, name: $name, statusNames: $statusNames)';
}


}

/// @nodoc
abstract mixin class _$WorkflowTemplateSummaryCopyWith<$Res> implements $WorkflowTemplateSummaryCopyWith<$Res> {
  factory _$WorkflowTemplateSummaryCopyWith(_WorkflowTemplateSummary value, $Res Function(_WorkflowTemplateSummary) _then) = __$WorkflowTemplateSummaryCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, List<String> statusNames
});




}
/// @nodoc
class __$WorkflowTemplateSummaryCopyWithImpl<$Res>
    implements _$WorkflowTemplateSummaryCopyWith<$Res> {
  __$WorkflowTemplateSummaryCopyWithImpl(this._self, this._then);

  final _WorkflowTemplateSummary _self;
  final $Res Function(_WorkflowTemplateSummary) _then;

/// Create a copy of WorkflowTemplateSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? statusNames = null,}) {
  return _then(_WorkflowTemplateSummary(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,statusNames: null == statusNames ? _self.statusNames : statusNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$AdminMutationResponse {

/// Stabilny komunikat operacji.
 String? get message;
/// Create a copy of AdminMutationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminMutationResponseCopyWith<AdminMutationResponse> get copyWith => _$AdminMutationResponseCopyWithImpl<AdminMutationResponse>(this as AdminMutationResponse, _$identity);

  /// Serializes this AdminMutationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminMutationResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AdminMutationResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class $AdminMutationResponseCopyWith<$Res>  {
  factory $AdminMutationResponseCopyWith(AdminMutationResponse value, $Res Function(AdminMutationResponse) _then) = _$AdminMutationResponseCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$AdminMutationResponseCopyWithImpl<$Res>
    implements $AdminMutationResponseCopyWith<$Res> {
  _$AdminMutationResponseCopyWithImpl(this._self, this._then);

  final AdminMutationResponse _self;
  final $Res Function(AdminMutationResponse) _then;

/// Create a copy of AdminMutationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminMutationResponse].
extension AdminMutationResponsePatterns on AdminMutationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminMutationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminMutationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminMutationResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminMutationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminMutationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminMutationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminMutationResponse() when $default != null:
return $default(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? message)  $default,) {final _that = this;
switch (_that) {
case _AdminMutationResponse():
return $default(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? message)?  $default,) {final _that = this;
switch (_that) {
case _AdminMutationResponse() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminMutationResponse implements AdminMutationResponse {
  const _AdminMutationResponse({this.message});
  factory _AdminMutationResponse.fromJson(Map<String, dynamic> json) => _$AdminMutationResponseFromJson(json);

/// Stabilny komunikat operacji.
@override final  String? message;

/// Create a copy of AdminMutationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminMutationResponseCopyWith<_AdminMutationResponse> get copyWith => __$AdminMutationResponseCopyWithImpl<_AdminMutationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminMutationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminMutationResponse&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AdminMutationResponse(message: $message)';
}


}

/// @nodoc
abstract mixin class _$AdminMutationResponseCopyWith<$Res> implements $AdminMutationResponseCopyWith<$Res> {
  factory _$AdminMutationResponseCopyWith(_AdminMutationResponse value, $Res Function(_AdminMutationResponse) _then) = __$AdminMutationResponseCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$AdminMutationResponseCopyWithImpl<$Res>
    implements _$AdminMutationResponseCopyWith<$Res> {
  __$AdminMutationResponseCopyWithImpl(this._self, this._then);

  final _AdminMutationResponse _self;
  final $Res Function(_AdminMutationResponse) _then;

/// Create a copy of AdminMutationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_AdminMutationResponse(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
