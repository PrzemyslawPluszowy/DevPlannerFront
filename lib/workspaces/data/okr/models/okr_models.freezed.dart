// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'okr_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateObjectivePayload {

 String get name; String? get description; DateTime? get targetDate;
/// Create a copy of CreateObjectivePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateObjectivePayloadCopyWith<CreateObjectivePayload> get copyWith => _$CreateObjectivePayloadCopyWithImpl<CreateObjectivePayload>(this as CreateObjectivePayload, _$identity);

  /// Serializes this CreateObjectivePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateObjectivePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,targetDate);

@override
String toString() {
  return 'CreateObjectivePayload(name: $name, description: $description, targetDate: $targetDate)';
}


}

/// @nodoc
abstract mixin class $CreateObjectivePayloadCopyWith<$Res>  {
  factory $CreateObjectivePayloadCopyWith(CreateObjectivePayload value, $Res Function(CreateObjectivePayload) _then) = _$CreateObjectivePayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description, DateTime? targetDate
});




}
/// @nodoc
class _$CreateObjectivePayloadCopyWithImpl<$Res>
    implements $CreateObjectivePayloadCopyWith<$Res> {
  _$CreateObjectivePayloadCopyWithImpl(this._self, this._then);

  final CreateObjectivePayload _self;
  final $Res Function(CreateObjectivePayload) _then;

/// Create a copy of CreateObjectivePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? targetDate = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateObjectivePayload].
extension CreateObjectivePayloadPatterns on CreateObjectivePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateObjectivePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateObjectivePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateObjectivePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateObjectivePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateObjectivePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateObjectivePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  DateTime? targetDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateObjectivePayload() when $default != null:
return $default(_that.name,_that.description,_that.targetDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  DateTime? targetDate)  $default,) {final _that = this;
switch (_that) {
case _CreateObjectivePayload():
return $default(_that.name,_that.description,_that.targetDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  DateTime? targetDate)?  $default,) {final _that = this;
switch (_that) {
case _CreateObjectivePayload() when $default != null:
return $default(_that.name,_that.description,_that.targetDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateObjectivePayload implements CreateObjectivePayload {
  const _CreateObjectivePayload({required this.name, this.description, this.targetDate});
  factory _CreateObjectivePayload.fromJson(Map<String, dynamic> json) => _$CreateObjectivePayloadFromJson(json);

@override final  String name;
@override final  String? description;
@override final  DateTime? targetDate;

/// Create a copy of CreateObjectivePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateObjectivePayloadCopyWith<_CreateObjectivePayload> get copyWith => __$CreateObjectivePayloadCopyWithImpl<_CreateObjectivePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateObjectivePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateObjectivePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,targetDate);

@override
String toString() {
  return 'CreateObjectivePayload(name: $name, description: $description, targetDate: $targetDate)';
}


}

/// @nodoc
abstract mixin class _$CreateObjectivePayloadCopyWith<$Res> implements $CreateObjectivePayloadCopyWith<$Res> {
  factory _$CreateObjectivePayloadCopyWith(_CreateObjectivePayload value, $Res Function(_CreateObjectivePayload) _then) = __$CreateObjectivePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, DateTime? targetDate
});




}
/// @nodoc
class __$CreateObjectivePayloadCopyWithImpl<$Res>
    implements _$CreateObjectivePayloadCopyWith<$Res> {
  __$CreateObjectivePayloadCopyWithImpl(this._self, this._then);

  final _CreateObjectivePayload _self;
  final $Res Function(_CreateObjectivePayload) _then;

/// Create a copy of CreateObjectivePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? targetDate = freezed,}) {
  return _then(_CreateObjectivePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$UpdateObjectivePayload {

 String get name; String? get description; DateTime? get targetDate;
/// Create a copy of UpdateObjectivePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateObjectivePayloadCopyWith<UpdateObjectivePayload> get copyWith => _$UpdateObjectivePayloadCopyWithImpl<UpdateObjectivePayload>(this as UpdateObjectivePayload, _$identity);

  /// Serializes this UpdateObjectivePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateObjectivePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,targetDate);

@override
String toString() {
  return 'UpdateObjectivePayload(name: $name, description: $description, targetDate: $targetDate)';
}


}

/// @nodoc
abstract mixin class $UpdateObjectivePayloadCopyWith<$Res>  {
  factory $UpdateObjectivePayloadCopyWith(UpdateObjectivePayload value, $Res Function(UpdateObjectivePayload) _then) = _$UpdateObjectivePayloadCopyWithImpl;
@useResult
$Res call({
 String name, String? description, DateTime? targetDate
});




}
/// @nodoc
class _$UpdateObjectivePayloadCopyWithImpl<$Res>
    implements $UpdateObjectivePayloadCopyWith<$Res> {
  _$UpdateObjectivePayloadCopyWithImpl(this._self, this._then);

  final UpdateObjectivePayload _self;
  final $Res Function(UpdateObjectivePayload) _then;

/// Create a copy of UpdateObjectivePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? targetDate = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateObjectivePayload].
extension UpdateObjectivePayloadPatterns on UpdateObjectivePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateObjectivePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateObjectivePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateObjectivePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateObjectivePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateObjectivePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateObjectivePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  DateTime? targetDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateObjectivePayload() when $default != null:
return $default(_that.name,_that.description,_that.targetDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  DateTime? targetDate)  $default,) {final _that = this;
switch (_that) {
case _UpdateObjectivePayload():
return $default(_that.name,_that.description,_that.targetDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  DateTime? targetDate)?  $default,) {final _that = this;
switch (_that) {
case _UpdateObjectivePayload() when $default != null:
return $default(_that.name,_that.description,_that.targetDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateObjectivePayload implements UpdateObjectivePayload {
  const _UpdateObjectivePayload({required this.name, this.description, this.targetDate});
  factory _UpdateObjectivePayload.fromJson(Map<String, dynamic> json) => _$UpdateObjectivePayloadFromJson(json);

@override final  String name;
@override final  String? description;
@override final  DateTime? targetDate;

/// Create a copy of UpdateObjectivePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateObjectivePayloadCopyWith<_UpdateObjectivePayload> get copyWith => __$UpdateObjectivePayloadCopyWithImpl<_UpdateObjectivePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateObjectivePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateObjectivePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,targetDate);

@override
String toString() {
  return 'UpdateObjectivePayload(name: $name, description: $description, targetDate: $targetDate)';
}


}

/// @nodoc
abstract mixin class _$UpdateObjectivePayloadCopyWith<$Res> implements $UpdateObjectivePayloadCopyWith<$Res> {
  factory _$UpdateObjectivePayloadCopyWith(_UpdateObjectivePayload value, $Res Function(_UpdateObjectivePayload) _then) = __$UpdateObjectivePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, DateTime? targetDate
});




}
/// @nodoc
class __$UpdateObjectivePayloadCopyWithImpl<$Res>
    implements _$UpdateObjectivePayloadCopyWith<$Res> {
  __$UpdateObjectivePayloadCopyWithImpl(this._self, this._then);

  final _UpdateObjectivePayload _self;
  final $Res Function(_UpdateObjectivePayload) _then;

/// Create a copy of UpdateObjectivePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? targetDate = freezed,}) {
  return _then(_UpdateObjectivePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CreateKeyResultPayload {

 String get name; KeyResultType get type; double get targetValue; String? get linkedProjectId; String? get linkedMilestoneId; double get weight;
/// Create a copy of CreateKeyResultPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateKeyResultPayloadCopyWith<CreateKeyResultPayload> get copyWith => _$CreateKeyResultPayloadCopyWithImpl<CreateKeyResultPayload>(this as CreateKeyResultPayload, _$identity);

  /// Serializes this CreateKeyResultPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateKeyResultPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.linkedProjectId, linkedProjectId) || other.linkedProjectId == linkedProjectId)&&(identical(other.linkedMilestoneId, linkedMilestoneId) || other.linkedMilestoneId == linkedMilestoneId)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,targetValue,linkedProjectId,linkedMilestoneId,weight);

@override
String toString() {
  return 'CreateKeyResultPayload(name: $name, type: $type, targetValue: $targetValue, linkedProjectId: $linkedProjectId, linkedMilestoneId: $linkedMilestoneId, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $CreateKeyResultPayloadCopyWith<$Res>  {
  factory $CreateKeyResultPayloadCopyWith(CreateKeyResultPayload value, $Res Function(CreateKeyResultPayload) _then) = _$CreateKeyResultPayloadCopyWithImpl;
@useResult
$Res call({
 String name, KeyResultType type, double targetValue, String? linkedProjectId, String? linkedMilestoneId, double weight
});




}
/// @nodoc
class _$CreateKeyResultPayloadCopyWithImpl<$Res>
    implements $CreateKeyResultPayloadCopyWith<$Res> {
  _$CreateKeyResultPayloadCopyWithImpl(this._self, this._then);

  final CreateKeyResultPayload _self;
  final $Res Function(CreateKeyResultPayload) _then;

/// Create a copy of CreateKeyResultPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? targetValue = null,Object? linkedProjectId = freezed,Object? linkedMilestoneId = freezed,Object? weight = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as KeyResultType,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,linkedProjectId: freezed == linkedProjectId ? _self.linkedProjectId : linkedProjectId // ignore: cast_nullable_to_non_nullable
as String?,linkedMilestoneId: freezed == linkedMilestoneId ? _self.linkedMilestoneId : linkedMilestoneId // ignore: cast_nullable_to_non_nullable
as String?,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateKeyResultPayload].
extension CreateKeyResultPayloadPatterns on CreateKeyResultPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateKeyResultPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateKeyResultPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateKeyResultPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateKeyResultPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateKeyResultPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateKeyResultPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  KeyResultType type,  double targetValue,  String? linkedProjectId,  String? linkedMilestoneId,  double weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateKeyResultPayload() when $default != null:
return $default(_that.name,_that.type,_that.targetValue,_that.linkedProjectId,_that.linkedMilestoneId,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  KeyResultType type,  double targetValue,  String? linkedProjectId,  String? linkedMilestoneId,  double weight)  $default,) {final _that = this;
switch (_that) {
case _CreateKeyResultPayload():
return $default(_that.name,_that.type,_that.targetValue,_that.linkedProjectId,_that.linkedMilestoneId,_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  KeyResultType type,  double targetValue,  String? linkedProjectId,  String? linkedMilestoneId,  double weight)?  $default,) {final _that = this;
switch (_that) {
case _CreateKeyResultPayload() when $default != null:
return $default(_that.name,_that.type,_that.targetValue,_that.linkedProjectId,_that.linkedMilestoneId,_that.weight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateKeyResultPayload implements CreateKeyResultPayload {
  const _CreateKeyResultPayload({required this.name, required this.type, required this.targetValue, this.linkedProjectId, this.linkedMilestoneId, this.weight = 1.0});
  factory _CreateKeyResultPayload.fromJson(Map<String, dynamic> json) => _$CreateKeyResultPayloadFromJson(json);

@override final  String name;
@override final  KeyResultType type;
@override final  double targetValue;
@override final  String? linkedProjectId;
@override final  String? linkedMilestoneId;
@override@JsonKey() final  double weight;

/// Create a copy of CreateKeyResultPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateKeyResultPayloadCopyWith<_CreateKeyResultPayload> get copyWith => __$CreateKeyResultPayloadCopyWithImpl<_CreateKeyResultPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateKeyResultPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateKeyResultPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.linkedProjectId, linkedProjectId) || other.linkedProjectId == linkedProjectId)&&(identical(other.linkedMilestoneId, linkedMilestoneId) || other.linkedMilestoneId == linkedMilestoneId)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,targetValue,linkedProjectId,linkedMilestoneId,weight);

@override
String toString() {
  return 'CreateKeyResultPayload(name: $name, type: $type, targetValue: $targetValue, linkedProjectId: $linkedProjectId, linkedMilestoneId: $linkedMilestoneId, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$CreateKeyResultPayloadCopyWith<$Res> implements $CreateKeyResultPayloadCopyWith<$Res> {
  factory _$CreateKeyResultPayloadCopyWith(_CreateKeyResultPayload value, $Res Function(_CreateKeyResultPayload) _then) = __$CreateKeyResultPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, KeyResultType type, double targetValue, String? linkedProjectId, String? linkedMilestoneId, double weight
});




}
/// @nodoc
class __$CreateKeyResultPayloadCopyWithImpl<$Res>
    implements _$CreateKeyResultPayloadCopyWith<$Res> {
  __$CreateKeyResultPayloadCopyWithImpl(this._self, this._then);

  final _CreateKeyResultPayload _self;
  final $Res Function(_CreateKeyResultPayload) _then;

/// Create a copy of CreateKeyResultPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? targetValue = null,Object? linkedProjectId = freezed,Object? linkedMilestoneId = freezed,Object? weight = null,}) {
  return _then(_CreateKeyResultPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as KeyResultType,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,linkedProjectId: freezed == linkedProjectId ? _self.linkedProjectId : linkedProjectId // ignore: cast_nullable_to_non_nullable
as String?,linkedMilestoneId: freezed == linkedMilestoneId ? _self.linkedMilestoneId : linkedMilestoneId // ignore: cast_nullable_to_non_nullable
as String?,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$UpdateKeyResultPayload {

 String get name; double get targetValue; double get weight; double? get currentValue;
/// Create a copy of UpdateKeyResultPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateKeyResultPayloadCopyWith<UpdateKeyResultPayload> get copyWith => _$UpdateKeyResultPayloadCopyWithImpl<UpdateKeyResultPayload>(this as UpdateKeyResultPayload, _$identity);

  /// Serializes this UpdateKeyResultPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateKeyResultPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,targetValue,weight,currentValue);

@override
String toString() {
  return 'UpdateKeyResultPayload(name: $name, targetValue: $targetValue, weight: $weight, currentValue: $currentValue)';
}


}

/// @nodoc
abstract mixin class $UpdateKeyResultPayloadCopyWith<$Res>  {
  factory $UpdateKeyResultPayloadCopyWith(UpdateKeyResultPayload value, $Res Function(UpdateKeyResultPayload) _then) = _$UpdateKeyResultPayloadCopyWithImpl;
@useResult
$Res call({
 String name, double targetValue, double weight, double? currentValue
});




}
/// @nodoc
class _$UpdateKeyResultPayloadCopyWithImpl<$Res>
    implements $UpdateKeyResultPayloadCopyWith<$Res> {
  _$UpdateKeyResultPayloadCopyWithImpl(this._self, this._then);

  final UpdateKeyResultPayload _self;
  final $Res Function(UpdateKeyResultPayload) _then;

/// Create a copy of UpdateKeyResultPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? targetValue = null,Object? weight = null,Object? currentValue = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,currentValue: freezed == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateKeyResultPayload].
extension UpdateKeyResultPayloadPatterns on UpdateKeyResultPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateKeyResultPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateKeyResultPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateKeyResultPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateKeyResultPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateKeyResultPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateKeyResultPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double targetValue,  double weight,  double? currentValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateKeyResultPayload() when $default != null:
return $default(_that.name,_that.targetValue,_that.weight,_that.currentValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double targetValue,  double weight,  double? currentValue)  $default,) {final _that = this;
switch (_that) {
case _UpdateKeyResultPayload():
return $default(_that.name,_that.targetValue,_that.weight,_that.currentValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double targetValue,  double weight,  double? currentValue)?  $default,) {final _that = this;
switch (_that) {
case _UpdateKeyResultPayload() when $default != null:
return $default(_that.name,_that.targetValue,_that.weight,_that.currentValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateKeyResultPayload implements UpdateKeyResultPayload {
  const _UpdateKeyResultPayload({required this.name, required this.targetValue, required this.weight, this.currentValue});
  factory _UpdateKeyResultPayload.fromJson(Map<String, dynamic> json) => _$UpdateKeyResultPayloadFromJson(json);

@override final  String name;
@override final  double targetValue;
@override final  double weight;
@override final  double? currentValue;

/// Create a copy of UpdateKeyResultPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateKeyResultPayloadCopyWith<_UpdateKeyResultPayload> get copyWith => __$UpdateKeyResultPayloadCopyWithImpl<_UpdateKeyResultPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateKeyResultPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateKeyResultPayload&&(identical(other.name, name) || other.name == name)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,targetValue,weight,currentValue);

@override
String toString() {
  return 'UpdateKeyResultPayload(name: $name, targetValue: $targetValue, weight: $weight, currentValue: $currentValue)';
}


}

/// @nodoc
abstract mixin class _$UpdateKeyResultPayloadCopyWith<$Res> implements $UpdateKeyResultPayloadCopyWith<$Res> {
  factory _$UpdateKeyResultPayloadCopyWith(_UpdateKeyResultPayload value, $Res Function(_UpdateKeyResultPayload) _then) = __$UpdateKeyResultPayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, double targetValue, double weight, double? currentValue
});




}
/// @nodoc
class __$UpdateKeyResultPayloadCopyWithImpl<$Res>
    implements _$UpdateKeyResultPayloadCopyWith<$Res> {
  __$UpdateKeyResultPayloadCopyWithImpl(this._self, this._then);

  final _UpdateKeyResultPayload _self;
  final $Res Function(_UpdateKeyResultPayload) _then;

/// Create a copy of UpdateKeyResultPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? targetValue = null,Object? weight = null,Object? currentValue = freezed,}) {
  return _then(_UpdateKeyResultPayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,currentValue: freezed == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$KeyResultResponse {

 String get id; String get objectiveId; String get workspaceId; String get name; KeyResultType get type; double get currentValue; double get targetValue; String? get linkedProjectId; String? get linkedMilestoneId; double get weight; DateTime get createdAtUtc; DateTime get updatedAtUtc; int get version;
/// Create a copy of KeyResultResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyResultResponseCopyWith<KeyResultResponse> get copyWith => _$KeyResultResponseCopyWithImpl<KeyResultResponse>(this as KeyResultResponse, _$identity);

  /// Serializes this KeyResultResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyResultResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.objectiveId, objectiveId) || other.objectiveId == objectiveId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.linkedProjectId, linkedProjectId) || other.linkedProjectId == linkedProjectId)&&(identical(other.linkedMilestoneId, linkedMilestoneId) || other.linkedMilestoneId == linkedMilestoneId)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,objectiveId,workspaceId,name,type,currentValue,targetValue,linkedProjectId,linkedMilestoneId,weight,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'KeyResultResponse(id: $id, objectiveId: $objectiveId, workspaceId: $workspaceId, name: $name, type: $type, currentValue: $currentValue, targetValue: $targetValue, linkedProjectId: $linkedProjectId, linkedMilestoneId: $linkedMilestoneId, weight: $weight, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $KeyResultResponseCopyWith<$Res>  {
  factory $KeyResultResponseCopyWith(KeyResultResponse value, $Res Function(KeyResultResponse) _then) = _$KeyResultResponseCopyWithImpl;
@useResult
$Res call({
 String id, String objectiveId, String workspaceId, String name, KeyResultType type, double currentValue, double targetValue, String? linkedProjectId, String? linkedMilestoneId, double weight, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$KeyResultResponseCopyWithImpl<$Res>
    implements $KeyResultResponseCopyWith<$Res> {
  _$KeyResultResponseCopyWithImpl(this._self, this._then);

  final KeyResultResponse _self;
  final $Res Function(KeyResultResponse) _then;

/// Create a copy of KeyResultResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? objectiveId = null,Object? workspaceId = null,Object? name = null,Object? type = null,Object? currentValue = null,Object? targetValue = null,Object? linkedProjectId = freezed,Object? linkedMilestoneId = freezed,Object? weight = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,objectiveId: null == objectiveId ? _self.objectiveId : objectiveId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as KeyResultType,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,linkedProjectId: freezed == linkedProjectId ? _self.linkedProjectId : linkedProjectId // ignore: cast_nullable_to_non_nullable
as String?,linkedMilestoneId: freezed == linkedMilestoneId ? _self.linkedMilestoneId : linkedMilestoneId // ignore: cast_nullable_to_non_nullable
as String?,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyResultResponse].
extension KeyResultResponsePatterns on KeyResultResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyResultResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyResultResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyResultResponse value)  $default,){
final _that = this;
switch (_that) {
case _KeyResultResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyResultResponse value)?  $default,){
final _that = this;
switch (_that) {
case _KeyResultResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String objectiveId,  String workspaceId,  String name,  KeyResultType type,  double currentValue,  double targetValue,  String? linkedProjectId,  String? linkedMilestoneId,  double weight,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyResultResponse() when $default != null:
return $default(_that.id,_that.objectiveId,_that.workspaceId,_that.name,_that.type,_that.currentValue,_that.targetValue,_that.linkedProjectId,_that.linkedMilestoneId,_that.weight,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String objectiveId,  String workspaceId,  String name,  KeyResultType type,  double currentValue,  double targetValue,  String? linkedProjectId,  String? linkedMilestoneId,  double weight,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _KeyResultResponse():
return $default(_that.id,_that.objectiveId,_that.workspaceId,_that.name,_that.type,_that.currentValue,_that.targetValue,_that.linkedProjectId,_that.linkedMilestoneId,_that.weight,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String objectiveId,  String workspaceId,  String name,  KeyResultType type,  double currentValue,  double targetValue,  String? linkedProjectId,  String? linkedMilestoneId,  double weight,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _KeyResultResponse() when $default != null:
return $default(_that.id,_that.objectiveId,_that.workspaceId,_that.name,_that.type,_that.currentValue,_that.targetValue,_that.linkedProjectId,_that.linkedMilestoneId,_that.weight,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KeyResultResponse implements KeyResultResponse {
  const _KeyResultResponse({required this.id, required this.objectiveId, required this.workspaceId, required this.name, required this.type, required this.currentValue, required this.targetValue, this.linkedProjectId, this.linkedMilestoneId, required this.weight, required this.createdAtUtc, required this.updatedAtUtc, required this.version});
  factory _KeyResultResponse.fromJson(Map<String, dynamic> json) => _$KeyResultResponseFromJson(json);

@override final  String id;
@override final  String objectiveId;
@override final  String workspaceId;
@override final  String name;
@override final  KeyResultType type;
@override final  double currentValue;
@override final  double targetValue;
@override final  String? linkedProjectId;
@override final  String? linkedMilestoneId;
@override final  double weight;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of KeyResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyResultResponseCopyWith<_KeyResultResponse> get copyWith => __$KeyResultResponseCopyWithImpl<_KeyResultResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyResultResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyResultResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.objectiveId, objectiveId) || other.objectiveId == objectiveId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.linkedProjectId, linkedProjectId) || other.linkedProjectId == linkedProjectId)&&(identical(other.linkedMilestoneId, linkedMilestoneId) || other.linkedMilestoneId == linkedMilestoneId)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,objectiveId,workspaceId,name,type,currentValue,targetValue,linkedProjectId,linkedMilestoneId,weight,createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'KeyResultResponse(id: $id, objectiveId: $objectiveId, workspaceId: $workspaceId, name: $name, type: $type, currentValue: $currentValue, targetValue: $targetValue, linkedProjectId: $linkedProjectId, linkedMilestoneId: $linkedMilestoneId, weight: $weight, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$KeyResultResponseCopyWith<$Res> implements $KeyResultResponseCopyWith<$Res> {
  factory _$KeyResultResponseCopyWith(_KeyResultResponse value, $Res Function(_KeyResultResponse) _then) = __$KeyResultResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String objectiveId, String workspaceId, String name, KeyResultType type, double currentValue, double targetValue, String? linkedProjectId, String? linkedMilestoneId, double weight, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$KeyResultResponseCopyWithImpl<$Res>
    implements _$KeyResultResponseCopyWith<$Res> {
  __$KeyResultResponseCopyWithImpl(this._self, this._then);

  final _KeyResultResponse _self;
  final $Res Function(_KeyResultResponse) _then;

/// Create a copy of KeyResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? objectiveId = null,Object? workspaceId = null,Object? name = null,Object? type = null,Object? currentValue = null,Object? targetValue = null,Object? linkedProjectId = freezed,Object? linkedMilestoneId = freezed,Object? weight = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_KeyResultResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,objectiveId: null == objectiveId ? _self.objectiveId : objectiveId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as KeyResultType,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,linkedProjectId: freezed == linkedProjectId ? _self.linkedProjectId : linkedProjectId // ignore: cast_nullable_to_non_nullable
as String?,linkedMilestoneId: freezed == linkedMilestoneId ? _self.linkedMilestoneId : linkedMilestoneId // ignore: cast_nullable_to_non_nullable
as String?,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ObjectiveResponse {

 String get id; String get workspaceId; String get createdByCoreUserId; String get name; String? get description; DateTime? get targetDate; double get progress; List<KeyResultResponse> get keyResults; DateTime get createdAtUtc; DateTime get updatedAtUtc; int get version;
/// Create a copy of ObjectiveResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectiveResponseCopyWith<ObjectiveResponse> get copyWith => _$ObjectiveResponseCopyWithImpl<ObjectiveResponse>(this as ObjectiveResponse, _$identity);

  /// Serializes this ObjectiveResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectiveResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other.keyResults, keyResults)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,createdByCoreUserId,name,description,targetDate,progress,const DeepCollectionEquality().hash(keyResults),createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'ObjectiveResponse(id: $id, workspaceId: $workspaceId, createdByCoreUserId: $createdByCoreUserId, name: $name, description: $description, targetDate: $targetDate, progress: $progress, keyResults: $keyResults, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class $ObjectiveResponseCopyWith<$Res>  {
  factory $ObjectiveResponseCopyWith(ObjectiveResponse value, $Res Function(ObjectiveResponse) _then) = _$ObjectiveResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String createdByCoreUserId, String name, String? description, DateTime? targetDate, double progress, List<KeyResultResponse> keyResults, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class _$ObjectiveResponseCopyWithImpl<$Res>
    implements $ObjectiveResponseCopyWith<$Res> {
  _$ObjectiveResponseCopyWithImpl(this._self, this._then);

  final ObjectiveResponse _self;
  final $Res Function(ObjectiveResponse) _then;

/// Create a copy of ObjectiveResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? createdByCoreUserId = null,Object? name = null,Object? description = freezed,Object? targetDate = freezed,Object? progress = null,Object? keyResults = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,createdByCoreUserId: null == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,keyResults: null == keyResults ? _self.keyResults : keyResults // ignore: cast_nullable_to_non_nullable
as List<KeyResultResponse>,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ObjectiveResponse].
extension ObjectiveResponsePatterns on ObjectiveResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ObjectiveResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ObjectiveResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ObjectiveResponse value)  $default,){
final _that = this;
switch (_that) {
case _ObjectiveResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ObjectiveResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ObjectiveResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String createdByCoreUserId,  String name,  String? description,  DateTime? targetDate,  double progress,  List<KeyResultResponse> keyResults,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ObjectiveResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.createdByCoreUserId,_that.name,_that.description,_that.targetDate,_that.progress,_that.keyResults,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String createdByCoreUserId,  String name,  String? description,  DateTime? targetDate,  double progress,  List<KeyResultResponse> keyResults,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)  $default,) {final _that = this;
switch (_that) {
case _ObjectiveResponse():
return $default(_that.id,_that.workspaceId,_that.createdByCoreUserId,_that.name,_that.description,_that.targetDate,_that.progress,_that.keyResults,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String createdByCoreUserId,  String name,  String? description,  DateTime? targetDate,  double progress,  List<KeyResultResponse> keyResults,  DateTime createdAtUtc,  DateTime updatedAtUtc,  int version)?  $default,) {final _that = this;
switch (_that) {
case _ObjectiveResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.createdByCoreUserId,_that.name,_that.description,_that.targetDate,_that.progress,_that.keyResults,_that.createdAtUtc,_that.updatedAtUtc,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ObjectiveResponse implements ObjectiveResponse {
  const _ObjectiveResponse({required this.id, required this.workspaceId, required this.createdByCoreUserId, required this.name, this.description, this.targetDate, required this.progress, required this.keyResults, required this.createdAtUtc, required this.updatedAtUtc, required this.version});
  factory _ObjectiveResponse.fromJson(Map<String, dynamic> json) => _$ObjectiveResponseFromJson(json);

@override final  String id;
@override final  String workspaceId;
@override final  String createdByCoreUserId;
@override final  String name;
@override final  String? description;
@override final  DateTime? targetDate;
@override final  double progress;
@override final  List<KeyResultResponse> keyResults;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  int version;

/// Create a copy of ObjectiveResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObjectiveResponseCopyWith<_ObjectiveResponse> get copyWith => __$ObjectiveResponseCopyWithImpl<_ObjectiveResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ObjectiveResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ObjectiveResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.progress, progress) || other.progress == progress)&&const DeepCollectionEquality().equals(other.keyResults, keyResults)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,createdByCoreUserId,name,description,targetDate,progress,const DeepCollectionEquality().hash(keyResults),createdAtUtc,updatedAtUtc,version);

@override
String toString() {
  return 'ObjectiveResponse(id: $id, workspaceId: $workspaceId, createdByCoreUserId: $createdByCoreUserId, name: $name, description: $description, targetDate: $targetDate, progress: $progress, keyResults: $keyResults, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ObjectiveResponseCopyWith<$Res> implements $ObjectiveResponseCopyWith<$Res> {
  factory _$ObjectiveResponseCopyWith(_ObjectiveResponse value, $Res Function(_ObjectiveResponse) _then) = __$ObjectiveResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String createdByCoreUserId, String name, String? description, DateTime? targetDate, double progress, List<KeyResultResponse> keyResults, DateTime createdAtUtc, DateTime updatedAtUtc, int version
});




}
/// @nodoc
class __$ObjectiveResponseCopyWithImpl<$Res>
    implements _$ObjectiveResponseCopyWith<$Res> {
  __$ObjectiveResponseCopyWithImpl(this._self, this._then);

  final _ObjectiveResponse _self;
  final $Res Function(_ObjectiveResponse) _then;

/// Create a copy of ObjectiveResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? createdByCoreUserId = null,Object? name = null,Object? description = freezed,Object? targetDate = freezed,Object? progress = null,Object? keyResults = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? version = null,}) {
  return _then(_ObjectiveResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,createdByCoreUserId: null == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,keyResults: null == keyResults ? _self.keyResults : keyResults // ignore: cast_nullable_to_non_nullable
as List<KeyResultResponse>,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
