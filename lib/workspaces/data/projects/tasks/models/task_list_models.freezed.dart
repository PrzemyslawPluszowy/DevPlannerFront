// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_list_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskAssigneeResponse {

 String get userId; bool get isPrimary; DateTime get createdAtUtc;
/// Create a copy of TaskAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskAssigneeResponseCopyWith<TaskAssigneeResponse> get copyWith => _$TaskAssigneeResponseCopyWithImpl<TaskAssigneeResponse>(this as TaskAssigneeResponse, _$identity);

  /// Serializes this TaskAssigneeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskAssigneeResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,isPrimary,createdAtUtc);

@override
String toString() {
  return 'TaskAssigneeResponse(userId: $userId, isPrimary: $isPrimary, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskAssigneeResponseCopyWith<$Res>  {
  factory $TaskAssigneeResponseCopyWith(TaskAssigneeResponse value, $Res Function(TaskAssigneeResponse) _then) = _$TaskAssigneeResponseCopyWithImpl;
@useResult
$Res call({
 String userId, bool isPrimary, DateTime createdAtUtc
});




}
/// @nodoc
class _$TaskAssigneeResponseCopyWithImpl<$Res>
    implements $TaskAssigneeResponseCopyWith<$Res> {
  _$TaskAssigneeResponseCopyWithImpl(this._self, this._then);

  final TaskAssigneeResponse _self;
  final $Res Function(TaskAssigneeResponse) _then;

/// Create a copy of TaskAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? isPrimary = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskAssigneeResponse].
extension TaskAssigneeResponsePatterns on TaskAssigneeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskAssigneeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskAssigneeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskAssigneeResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskAssigneeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskAssigneeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskAssigneeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool isPrimary,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskAssigneeResponse() when $default != null:
return $default(_that.userId,_that.isPrimary,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool isPrimary,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskAssigneeResponse():
return $default(_that.userId,_that.isPrimary,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool isPrimary,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskAssigneeResponse() when $default != null:
return $default(_that.userId,_that.isPrimary,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskAssigneeResponse implements TaskAssigneeResponse {
  const _TaskAssigneeResponse({required this.userId, required this.isPrimary, required this.createdAtUtc});
  factory _TaskAssigneeResponse.fromJson(Map<String, dynamic> json) => _$TaskAssigneeResponseFromJson(json);

@override final  String userId;
@override final  bool isPrimary;
@override final  DateTime createdAtUtc;

/// Create a copy of TaskAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskAssigneeResponseCopyWith<_TaskAssigneeResponse> get copyWith => __$TaskAssigneeResponseCopyWithImpl<_TaskAssigneeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskAssigneeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskAssigneeResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,isPrimary,createdAtUtc);

@override
String toString() {
  return 'TaskAssigneeResponse(userId: $userId, isPrimary: $isPrimary, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskAssigneeResponseCopyWith<$Res> implements $TaskAssigneeResponseCopyWith<$Res> {
  factory _$TaskAssigneeResponseCopyWith(_TaskAssigneeResponse value, $Res Function(_TaskAssigneeResponse) _then) = __$TaskAssigneeResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool isPrimary, DateTime createdAtUtc
});




}
/// @nodoc
class __$TaskAssigneeResponseCopyWithImpl<$Res>
    implements _$TaskAssigneeResponseCopyWith<$Res> {
  __$TaskAssigneeResponseCopyWithImpl(this._self, this._then);

  final _TaskAssigneeResponse _self;
  final $Res Function(_TaskAssigneeResponse) _then;

/// Create a copy of TaskAssigneeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? isPrimary = null,Object? createdAtUtc = null,}) {
  return _then(_TaskAssigneeResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskChecklistItemResponse {

 String get id; String get title; int get position; bool get isCompleted; String? get completedByUserId; DateTime? get completedAtUtc; DateTime get updatedAtUtc;
/// Create a copy of TaskChecklistItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskChecklistItemResponseCopyWith<TaskChecklistItemResponse> get copyWith => _$TaskChecklistItemResponseCopyWithImpl<TaskChecklistItemResponse>(this as TaskChecklistItemResponse, _$identity);

  /// Serializes this TaskChecklistItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskChecklistItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.position, position) || other.position == position)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedByUserId, completedByUserId) || other.completedByUserId == completedByUserId)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,position,isCompleted,completedByUserId,completedAtUtc,updatedAtUtc);

@override
String toString() {
  return 'TaskChecklistItemResponse(id: $id, title: $title, position: $position, isCompleted: $isCompleted, completedByUserId: $completedByUserId, completedAtUtc: $completedAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskChecklistItemResponseCopyWith<$Res>  {
  factory $TaskChecklistItemResponseCopyWith(TaskChecklistItemResponse value, $Res Function(TaskChecklistItemResponse) _then) = _$TaskChecklistItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, String title, int position, bool isCompleted, String? completedByUserId, DateTime? completedAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class _$TaskChecklistItemResponseCopyWithImpl<$Res>
    implements $TaskChecklistItemResponseCopyWith<$Res> {
  _$TaskChecklistItemResponseCopyWithImpl(this._self, this._then);

  final TaskChecklistItemResponse _self;
  final $Res Function(TaskChecklistItemResponse) _then;

/// Create a copy of TaskChecklistItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? position = null,Object? isCompleted = null,Object? completedByUserId = freezed,Object? completedAtUtc = freezed,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedByUserId: freezed == completedByUserId ? _self.completedByUserId : completedByUserId // ignore: cast_nullable_to_non_nullable
as String?,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskChecklistItemResponse].
extension TaskChecklistItemResponsePatterns on TaskChecklistItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskChecklistItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskChecklistItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskChecklistItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskChecklistItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskChecklistItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskChecklistItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  int position,  bool isCompleted,  String? completedByUserId,  DateTime? completedAtUtc,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskChecklistItemResponse() when $default != null:
return $default(_that.id,_that.title,_that.position,_that.isCompleted,_that.completedByUserId,_that.completedAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  int position,  bool isCompleted,  String? completedByUserId,  DateTime? completedAtUtc,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskChecklistItemResponse():
return $default(_that.id,_that.title,_that.position,_that.isCompleted,_that.completedByUserId,_that.completedAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  int position,  bool isCompleted,  String? completedByUserId,  DateTime? completedAtUtc,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskChecklistItemResponse() when $default != null:
return $default(_that.id,_that.title,_that.position,_that.isCompleted,_that.completedByUserId,_that.completedAtUtc,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskChecklistItemResponse implements TaskChecklistItemResponse {
  const _TaskChecklistItemResponse({required this.id, required this.title, required this.position, required this.isCompleted, this.completedByUserId, this.completedAtUtc, required this.updatedAtUtc});
  factory _TaskChecklistItemResponse.fromJson(Map<String, dynamic> json) => _$TaskChecklistItemResponseFromJson(json);

@override final  String id;
@override final  String title;
@override final  int position;
@override final  bool isCompleted;
@override final  String? completedByUserId;
@override final  DateTime? completedAtUtc;
@override final  DateTime updatedAtUtc;

/// Create a copy of TaskChecklistItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskChecklistItemResponseCopyWith<_TaskChecklistItemResponse> get copyWith => __$TaskChecklistItemResponseCopyWithImpl<_TaskChecklistItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskChecklistItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskChecklistItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.position, position) || other.position == position)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedByUserId, completedByUserId) || other.completedByUserId == completedByUserId)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,position,isCompleted,completedByUserId,completedAtUtc,updatedAtUtc);

@override
String toString() {
  return 'TaskChecklistItemResponse(id: $id, title: $title, position: $position, isCompleted: $isCompleted, completedByUserId: $completedByUserId, completedAtUtc: $completedAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskChecklistItemResponseCopyWith<$Res> implements $TaskChecklistItemResponseCopyWith<$Res> {
  factory _$TaskChecklistItemResponseCopyWith(_TaskChecklistItemResponse value, $Res Function(_TaskChecklistItemResponse) _then) = __$TaskChecklistItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int position, bool isCompleted, String? completedByUserId, DateTime? completedAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class __$TaskChecklistItemResponseCopyWithImpl<$Res>
    implements _$TaskChecklistItemResponseCopyWith<$Res> {
  __$TaskChecklistItemResponseCopyWithImpl(this._self, this._then);

  final _TaskChecklistItemResponse _self;
  final $Res Function(_TaskChecklistItemResponse) _then;

/// Create a copy of TaskChecklistItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? position = null,Object? isCompleted = null,Object? completedByUserId = freezed,Object? completedAtUtc = freezed,Object? updatedAtUtc = null,}) {
  return _then(_TaskChecklistItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedByUserId: freezed == completedByUserId ? _self.completedByUserId : completedByUserId // ignore: cast_nullable_to_non_nullable
as String?,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskLabelResponse {

 String get id; String get name; String get color; DateTime get createdAtUtc;
/// Create a copy of TaskLabelResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskLabelResponseCopyWith<TaskLabelResponse> get copyWith => _$TaskLabelResponseCopyWithImpl<TaskLabelResponse>(this as TaskLabelResponse, _$identity);

  /// Serializes this TaskLabelResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskLabelResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,createdAtUtc);

@override
String toString() {
  return 'TaskLabelResponse(id: $id, name: $name, color: $color, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskLabelResponseCopyWith<$Res>  {
  factory $TaskLabelResponseCopyWith(TaskLabelResponse value, $Res Function(TaskLabelResponse) _then) = _$TaskLabelResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String color, DateTime createdAtUtc
});




}
/// @nodoc
class _$TaskLabelResponseCopyWithImpl<$Res>
    implements $TaskLabelResponseCopyWith<$Res> {
  _$TaskLabelResponseCopyWithImpl(this._self, this._then);

  final TaskLabelResponse _self;
  final $Res Function(TaskLabelResponse) _then;

/// Create a copy of TaskLabelResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskLabelResponse].
extension TaskLabelResponsePatterns on TaskLabelResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskLabelResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskLabelResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskLabelResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskLabelResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskLabelResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskLabelResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String color,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskLabelResponse() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String color,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskLabelResponse():
return $default(_that.id,_that.name,_that.color,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String color,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskLabelResponse() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskLabelResponse implements TaskLabelResponse {
  const _TaskLabelResponse({required this.id, required this.name, required this.color, required this.createdAtUtc});
  factory _TaskLabelResponse.fromJson(Map<String, dynamic> json) => _$TaskLabelResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String color;
@override final  DateTime createdAtUtc;

/// Create a copy of TaskLabelResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskLabelResponseCopyWith<_TaskLabelResponse> get copyWith => __$TaskLabelResponseCopyWithImpl<_TaskLabelResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskLabelResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskLabelResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,createdAtUtc);

@override
String toString() {
  return 'TaskLabelResponse(id: $id, name: $name, color: $color, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskLabelResponseCopyWith<$Res> implements $TaskLabelResponseCopyWith<$Res> {
  factory _$TaskLabelResponseCopyWith(_TaskLabelResponse value, $Res Function(_TaskLabelResponse) _then) = __$TaskLabelResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String color, DateTime createdAtUtc
});




}
/// @nodoc
class __$TaskLabelResponseCopyWithImpl<$Res>
    implements _$TaskLabelResponseCopyWith<$Res> {
  __$TaskLabelResponseCopyWithImpl(this._self, this._then);

  final _TaskLabelResponse _self;
  final $Res Function(_TaskLabelResponse) _then;

/// Create a copy of TaskLabelResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? color = null,Object? createdAtUtc = null,}) {
  return _then(_TaskLabelResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskListItemResponse {

 String get id; int get number; String get key; String? get parentTaskId; String get title; ProjectTaskStatus get status; TaskPriority get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; List<TaskAssigneeResponse> get assignees; int get checklistCompletedCount; int get checklistTotalCount; int get subtaskCount; DateTime get updatedAtUtc; int get version; bool get isPinned; String? get customStatusId; List<TaskCustomFieldValueResponse> get customFields; DateTime? get createdAtUtc; String? get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; int? get actualMinutes; List<TaskLabelResponse> get labels; String? get customStatusName; String? get customStatusColor; int get watcherCount; bool get isWatchedByMe; TaskRecurrenceSummaryResponse? get recurrence; String? get milestoneId;
/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskListItemResponseCopyWith<ProjectTaskListItemResponse> get copyWith => _$ProjectTaskListItemResponseCopyWithImpl<ProjectTaskListItemResponse>(this as ProjectTaskListItemResponse, _$identity);

  /// Serializes this ProjectTaskListItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskListItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&(identical(other.checklistCompletedCount, checklistCompletedCount) || other.checklistCompletedCount == checklistCompletedCount)&&(identical(other.checklistTotalCount, checklistTotalCount) || other.checklistTotalCount == checklistTotalCount)&&(identical(other.subtaskCount, subtaskCount) || other.subtaskCount == subtaskCount)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.customStatusName, customStatusName) || other.customStatusName == customStatusName)&&(identical(other.customStatusColor, customStatusColor) || other.customStatusColor == customStatusColor)&&(identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount)&&(identical(other.isWatchedByMe, isWatchedByMe) || other.isWatchedByMe == isWatchedByMe)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,parentTaskId,title,status,priority,startAtUtc,dueAtUtc,const DeepCollectionEquality().hash(assignees),checklistCompletedCount,checklistTotalCount,subtaskCount,updatedAtUtc,version,isPinned,customStatusId,const DeepCollectionEquality().hash(customFields),createdAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,const DeepCollectionEquality().hash(labels),customStatusName,customStatusColor,watcherCount,isWatchedByMe,recurrence,milestoneId]);

@override
String toString() {
  return 'ProjectTaskListItemResponse(id: $id, number: $number, key: $key, parentTaskId: $parentTaskId, title: $title, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, assignees: $assignees, checklistCompletedCount: $checklistCompletedCount, checklistTotalCount: $checklistTotalCount, subtaskCount: $subtaskCount, updatedAtUtc: $updatedAtUtc, version: $version, isPinned: $isPinned, customStatusId: $customStatusId, customFields: $customFields, createdAtUtc: $createdAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, labels: $labels, customStatusName: $customStatusName, customStatusColor: $customStatusColor, watcherCount: $watcherCount, isWatchedByMe: $isWatchedByMe, recurrence: $recurrence, milestoneId: $milestoneId)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskListItemResponseCopyWith<$Res>  {
  factory $ProjectTaskListItemResponseCopyWith(ProjectTaskListItemResponse value, $Res Function(ProjectTaskListItemResponse) _then) = _$ProjectTaskListItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, int number, String key, String? parentTaskId, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, List<TaskAssigneeResponse> assignees, int checklistCompletedCount, int checklistTotalCount, int subtaskCount, DateTime updatedAtUtc, int version, bool isPinned, String? customStatusId, List<TaskCustomFieldValueResponse> customFields, DateTime? createdAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, List<TaskLabelResponse> labels, String? customStatusName, String? customStatusColor, int watcherCount, bool isWatchedByMe, TaskRecurrenceSummaryResponse? recurrence, String? milestoneId
});


$TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence;

}
/// @nodoc
class _$ProjectTaskListItemResponseCopyWithImpl<$Res>
    implements $ProjectTaskListItemResponseCopyWith<$Res> {
  _$ProjectTaskListItemResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskListItemResponse _self;
  final $Res Function(ProjectTaskListItemResponse) _then;

/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? key = null,Object? parentTaskId = freezed,Object? title = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? assignees = null,Object? checklistCompletedCount = null,Object? checklistTotalCount = null,Object? subtaskCount = null,Object? updatedAtUtc = null,Object? version = null,Object? isPinned = null,Object? customStatusId = freezed,Object? customFields = null,Object? createdAtUtc = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? labels = null,Object? customStatusName = freezed,Object? customStatusColor = freezed,Object? watcherCount = null,Object? isWatchedByMe = null,Object? recurrence = freezed,Object? milestoneId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<TaskAssigneeResponse>,checklistCompletedCount: null == checklistCompletedCount ? _self.checklistCompletedCount : checklistCompletedCount // ignore: cast_nullable_to_non_nullable
as int,checklistTotalCount: null == checklistTotalCount ? _self.checklistTotalCount : checklistTotalCount // ignore: cast_nullable_to_non_nullable
as int,subtaskCount: null == subtaskCount ? _self.subtaskCount : subtaskCount // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<TaskCustomFieldValueResponse>,createdAtUtc: freezed == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualMinutes: freezed == actualMinutes ? _self.actualMinutes : actualMinutes // ignore: cast_nullable_to_non_nullable
as int?,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskLabelResponse>,customStatusName: freezed == customStatusName ? _self.customStatusName : customStatusName // ignore: cast_nullable_to_non_nullable
as String?,customStatusColor: freezed == customStatusColor ? _self.customStatusColor : customStatusColor // ignore: cast_nullable_to_non_nullable
as String?,watcherCount: null == watcherCount ? _self.watcherCount : watcherCount // ignore: cast_nullable_to_non_nullable
as int,isWatchedByMe: null == isWatchedByMe ? _self.isWatchedByMe : isWatchedByMe // ignore: cast_nullable_to_non_nullable
as bool,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceSummaryResponse?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $TaskRecurrenceSummaryResponseCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectTaskListItemResponse].
extension ProjectTaskListItemResponsePatterns on ProjectTaskListItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskListItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskListItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskListItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String? parentTaskId,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<TaskAssigneeResponse> assignees,  int checklistCompletedCount,  int checklistTotalCount,  int subtaskCount,  DateTime updatedAtUtc,  int version,  bool isPinned,  String? customStatusId,  List<TaskCustomFieldValueResponse> customFields,  DateTime? createdAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  List<TaskLabelResponse> labels,  String? customStatusName,  String? customStatusColor,  int watcherCount,  bool isWatchedByMe,  TaskRecurrenceSummaryResponse? recurrence,  String? milestoneId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.parentTaskId,_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assignees,_that.checklistCompletedCount,_that.checklistTotalCount,_that.subtaskCount,_that.updatedAtUtc,_that.version,_that.isPinned,_that.customStatusId,_that.customFields,_that.createdAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.labels,_that.customStatusName,_that.customStatusColor,_that.watcherCount,_that.isWatchedByMe,_that.recurrence,_that.milestoneId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String key,  String? parentTaskId,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<TaskAssigneeResponse> assignees,  int checklistCompletedCount,  int checklistTotalCount,  int subtaskCount,  DateTime updatedAtUtc,  int version,  bool isPinned,  String? customStatusId,  List<TaskCustomFieldValueResponse> customFields,  DateTime? createdAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  List<TaskLabelResponse> labels,  String? customStatusName,  String? customStatusColor,  int watcherCount,  bool isWatchedByMe,  TaskRecurrenceSummaryResponse? recurrence,  String? milestoneId)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse():
return $default(_that.id,_that.number,_that.key,_that.parentTaskId,_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assignees,_that.checklistCompletedCount,_that.checklistTotalCount,_that.subtaskCount,_that.updatedAtUtc,_that.version,_that.isPinned,_that.customStatusId,_that.customFields,_that.createdAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.labels,_that.customStatusName,_that.customStatusColor,_that.watcherCount,_that.isWatchedByMe,_that.recurrence,_that.milestoneId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String key,  String? parentTaskId,  String title,  ProjectTaskStatus status,  TaskPriority priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  List<TaskAssigneeResponse> assignees,  int checklistCompletedCount,  int checklistTotalCount,  int subtaskCount,  DateTime updatedAtUtc,  int version,  bool isPinned,  String? customStatusId,  List<TaskCustomFieldValueResponse> customFields,  DateTime? createdAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  int? actualMinutes,  List<TaskLabelResponse> labels,  String? customStatusName,  String? customStatusColor,  int watcherCount,  bool isWatchedByMe,  TaskRecurrenceSummaryResponse? recurrence,  String? milestoneId)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskListItemResponse() when $default != null:
return $default(_that.id,_that.number,_that.key,_that.parentTaskId,_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.assignees,_that.checklistCompletedCount,_that.checklistTotalCount,_that.subtaskCount,_that.updatedAtUtc,_that.version,_that.isPinned,_that.customStatusId,_that.customFields,_that.createdAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.actualMinutes,_that.labels,_that.customStatusName,_that.customStatusColor,_that.watcherCount,_that.isWatchedByMe,_that.recurrence,_that.milestoneId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskListItemResponse implements ProjectTaskListItemResponse {
  const _ProjectTaskListItemResponse({required this.id, required this.number, required this.key, this.parentTaskId, required this.title, required this.status, required this.priority, this.startAtUtc, this.dueAtUtc, required this.assignees, required this.checklistCompletedCount, required this.checklistTotalCount, this.subtaskCount = 0, required this.updatedAtUtc, required this.version, this.isPinned = false, this.customStatusId, this.customFields = const [], this.createdAtUtc, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.actualMinutes, this.labels = const [], this.customStatusName, this.customStatusColor, this.watcherCount = 0, this.isWatchedByMe = false, this.recurrence, this.milestoneId});
  factory _ProjectTaskListItemResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskListItemResponseFromJson(json);

@override final  String id;
@override final  int number;
@override final  String key;
@override final  String? parentTaskId;
@override final  String title;
@override final  ProjectTaskStatus status;
@override final  TaskPriority priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override final  List<TaskAssigneeResponse> assignees;
@override final  int checklistCompletedCount;
@override final  int checklistTotalCount;
@override@JsonKey() final  int subtaskCount;
@override final  DateTime updatedAtUtc;
@override final  int version;
@override@JsonKey() final  bool isPinned;
@override final  String? customStatusId;
@override@JsonKey() final  List<TaskCustomFieldValueResponse> customFields;
@override final  DateTime? createdAtUtc;
@override final  String? taskType;
@override final  int? size;
@override final  int? complexity;
@override final  int? risk;
@override final  int? businessValue;
@override final  int? estimatedMinutes;
@override final  int? actualMinutes;
@override@JsonKey() final  List<TaskLabelResponse> labels;
@override final  String? customStatusName;
@override final  String? customStatusColor;
@override@JsonKey() final  int watcherCount;
@override@JsonKey() final  bool isWatchedByMe;
@override final  TaskRecurrenceSummaryResponse? recurrence;
@override final  String? milestoneId;

/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskListItemResponseCopyWith<_ProjectTaskListItemResponse> get copyWith => __$ProjectTaskListItemResponseCopyWithImpl<_ProjectTaskListItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskListItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskListItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.key, key) || other.key == key)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&const DeepCollectionEquality().equals(other.assignees, assignees)&&(identical(other.checklistCompletedCount, checklistCompletedCount) || other.checklistCompletedCount == checklistCompletedCount)&&(identical(other.checklistTotalCount, checklistTotalCount) || other.checklistTotalCount == checklistTotalCount)&&(identical(other.subtaskCount, subtaskCount) || other.subtaskCount == subtaskCount)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.actualMinutes, actualMinutes) || other.actualMinutes == actualMinutes)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.customStatusName, customStatusName) || other.customStatusName == customStatusName)&&(identical(other.customStatusColor, customStatusColor) || other.customStatusColor == customStatusColor)&&(identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount)&&(identical(other.isWatchedByMe, isWatchedByMe) || other.isWatchedByMe == isWatchedByMe)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,number,key,parentTaskId,title,status,priority,startAtUtc,dueAtUtc,const DeepCollectionEquality().hash(assignees),checklistCompletedCount,checklistTotalCount,subtaskCount,updatedAtUtc,version,isPinned,customStatusId,const DeepCollectionEquality().hash(customFields),createdAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,actualMinutes,const DeepCollectionEquality().hash(labels),customStatusName,customStatusColor,watcherCount,isWatchedByMe,recurrence,milestoneId]);

@override
String toString() {
  return 'ProjectTaskListItemResponse(id: $id, number: $number, key: $key, parentTaskId: $parentTaskId, title: $title, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, assignees: $assignees, checklistCompletedCount: $checklistCompletedCount, checklistTotalCount: $checklistTotalCount, subtaskCount: $subtaskCount, updatedAtUtc: $updatedAtUtc, version: $version, isPinned: $isPinned, customStatusId: $customStatusId, customFields: $customFields, createdAtUtc: $createdAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, labels: $labels, customStatusName: $customStatusName, customStatusColor: $customStatusColor, watcherCount: $watcherCount, isWatchedByMe: $isWatchedByMe, recurrence: $recurrence, milestoneId: $milestoneId)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskListItemResponseCopyWith<$Res> implements $ProjectTaskListItemResponseCopyWith<$Res> {
  factory _$ProjectTaskListItemResponseCopyWith(_ProjectTaskListItemResponse value, $Res Function(_ProjectTaskListItemResponse) _then) = __$ProjectTaskListItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String key, String? parentTaskId, String title, ProjectTaskStatus status, TaskPriority priority, DateTime? startAtUtc, DateTime? dueAtUtc, List<TaskAssigneeResponse> assignees, int checklistCompletedCount, int checklistTotalCount, int subtaskCount, DateTime updatedAtUtc, int version, bool isPinned, String? customStatusId, List<TaskCustomFieldValueResponse> customFields, DateTime? createdAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, int? actualMinutes, List<TaskLabelResponse> labels, String? customStatusName, String? customStatusColor, int watcherCount, bool isWatchedByMe, TaskRecurrenceSummaryResponse? recurrence, String? milestoneId
});


@override $TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence;

}
/// @nodoc
class __$ProjectTaskListItemResponseCopyWithImpl<$Res>
    implements _$ProjectTaskListItemResponseCopyWith<$Res> {
  __$ProjectTaskListItemResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskListItemResponse _self;
  final $Res Function(_ProjectTaskListItemResponse) _then;

/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? key = null,Object? parentTaskId = freezed,Object? title = null,Object? status = null,Object? priority = null,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? assignees = null,Object? checklistCompletedCount = null,Object? checklistTotalCount = null,Object? subtaskCount = null,Object? updatedAtUtc = null,Object? version = null,Object? isPinned = null,Object? customStatusId = freezed,Object? customFields = null,Object? createdAtUtc = freezed,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? actualMinutes = freezed,Object? labels = null,Object? customStatusName = freezed,Object? customStatusColor = freezed,Object? watcherCount = null,Object? isWatchedByMe = null,Object? recurrence = freezed,Object? milestoneId = freezed,}) {
  return _then(_ProjectTaskListItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,assignees: null == assignees ? _self.assignees : assignees // ignore: cast_nullable_to_non_nullable
as List<TaskAssigneeResponse>,checklistCompletedCount: null == checklistCompletedCount ? _self.checklistCompletedCount : checklistCompletedCount // ignore: cast_nullable_to_non_nullable
as int,checklistTotalCount: null == checklistTotalCount ? _self.checklistTotalCount : checklistTotalCount // ignore: cast_nullable_to_non_nullable
as int,subtaskCount: null == subtaskCount ? _self.subtaskCount : subtaskCount // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<TaskCustomFieldValueResponse>,createdAtUtc: freezed == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualMinutes: freezed == actualMinutes ? _self.actualMinutes : actualMinutes // ignore: cast_nullable_to_non_nullable
as int?,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<TaskLabelResponse>,customStatusName: freezed == customStatusName ? _self.customStatusName : customStatusName // ignore: cast_nullable_to_non_nullable
as String?,customStatusColor: freezed == customStatusColor ? _self.customStatusColor : customStatusColor // ignore: cast_nullable_to_non_nullable
as String?,watcherCount: null == watcherCount ? _self.watcherCount : watcherCount // ignore: cast_nullable_to_non_nullable
as int,isWatchedByMe: null == isWatchedByMe ? _self.isWatchedByMe : isWatchedByMe // ignore: cast_nullable_to_non_nullable
as bool,recurrence: freezed == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as TaskRecurrenceSummaryResponse?,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProjectTaskListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskRecurrenceSummaryResponseCopyWith<$Res>? get recurrence {
    if (_self.recurrence == null) {
    return null;
  }

  return $TaskRecurrenceSummaryResponseCopyWith<$Res>(_self.recurrence!, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// @nodoc
mixin _$ProjectTaskListGroupResponse {

 String get key; String get displayName; String? get color; int get position; int get totalCount; List<ProjectTaskListItemResponse> get items; String? get nextCursor;
/// Create a copy of ProjectTaskListGroupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskListGroupResponseCopyWith<ProjectTaskListGroupResponse> get copyWith => _$ProjectTaskListGroupResponseCopyWithImpl<ProjectTaskListGroupResponse>(this as ProjectTaskListGroupResponse, _$identity);

  /// Serializes this ProjectTaskListGroupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskListGroupResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,displayName,color,position,totalCount,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'ProjectTaskListGroupResponse(key: $key, displayName: $displayName, color: $color, position: $position, totalCount: $totalCount, items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskListGroupResponseCopyWith<$Res>  {
  factory $ProjectTaskListGroupResponseCopyWith(ProjectTaskListGroupResponse value, $Res Function(ProjectTaskListGroupResponse) _then) = _$ProjectTaskListGroupResponseCopyWithImpl;
@useResult
$Res call({
 String key, String displayName, String? color, int position, int totalCount, List<ProjectTaskListItemResponse> items, String? nextCursor
});




}
/// @nodoc
class _$ProjectTaskListGroupResponseCopyWithImpl<$Res>
    implements $ProjectTaskListGroupResponseCopyWith<$Res> {
  _$ProjectTaskListGroupResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskListGroupResponse _self;
  final $Res Function(ProjectTaskListGroupResponse) _then;

/// Create a copy of ProjectTaskListGroupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? displayName = null,Object? color = freezed,Object? position = null,Object? totalCount = null,Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskListItemResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskListGroupResponse].
extension ProjectTaskListGroupResponsePatterns on ProjectTaskListGroupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskListGroupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskListGroupResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskListGroupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String displayName,  String? color,  int position,  int totalCount,  List<ProjectTaskListItemResponse> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse() when $default != null:
return $default(_that.key,_that.displayName,_that.color,_that.position,_that.totalCount,_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String displayName,  String? color,  int position,  int totalCount,  List<ProjectTaskListItemResponse> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse():
return $default(_that.key,_that.displayName,_that.color,_that.position,_that.totalCount,_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String displayName,  String? color,  int position,  int totalCount,  List<ProjectTaskListItemResponse> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskListGroupResponse() when $default != null:
return $default(_that.key,_that.displayName,_that.color,_that.position,_that.totalCount,_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskListGroupResponse implements ProjectTaskListGroupResponse {
  const _ProjectTaskListGroupResponse({required this.key, required this.displayName, this.color, required this.position, required this.totalCount, required this.items, this.nextCursor});
  factory _ProjectTaskListGroupResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskListGroupResponseFromJson(json);

@override final  String key;
@override final  String displayName;
@override final  String? color;
@override final  int position;
@override final  int totalCount;
@override final  List<ProjectTaskListItemResponse> items;
@override final  String? nextCursor;

/// Create a copy of ProjectTaskListGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskListGroupResponseCopyWith<_ProjectTaskListGroupResponse> get copyWith => __$ProjectTaskListGroupResponseCopyWithImpl<_ProjectTaskListGroupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskListGroupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskListGroupResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.color, color) || other.color == color)&&(identical(other.position, position) || other.position == position)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,displayName,color,position,totalCount,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'ProjectTaskListGroupResponse(key: $key, displayName: $displayName, color: $color, position: $position, totalCount: $totalCount, items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskListGroupResponseCopyWith<$Res> implements $ProjectTaskListGroupResponseCopyWith<$Res> {
  factory _$ProjectTaskListGroupResponseCopyWith(_ProjectTaskListGroupResponse value, $Res Function(_ProjectTaskListGroupResponse) _then) = __$ProjectTaskListGroupResponseCopyWithImpl;
@override @useResult
$Res call({
 String key, String displayName, String? color, int position, int totalCount, List<ProjectTaskListItemResponse> items, String? nextCursor
});




}
/// @nodoc
class __$ProjectTaskListGroupResponseCopyWithImpl<$Res>
    implements _$ProjectTaskListGroupResponseCopyWith<$Res> {
  __$ProjectTaskListGroupResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskListGroupResponse _self;
  final $Res Function(_ProjectTaskListGroupResponse) _then;

/// Create a copy of ProjectTaskListGroupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? displayName = null,Object? color = freezed,Object? position = null,Object? totalCount = null,Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_ProjectTaskListGroupResponse(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskListItemResponse>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProjectTaskGroupedListResponse {

 int get totalCount; TaskSavedViewGroupBy get groupBy; List<ProjectTaskListGroupResponse> get groups;
/// Create a copy of ProjectTaskGroupedListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectTaskGroupedListResponseCopyWith<ProjectTaskGroupedListResponse> get copyWith => _$ProjectTaskGroupedListResponseCopyWithImpl<ProjectTaskGroupedListResponse>(this as ProjectTaskGroupedListResponse, _$identity);

  /// Serializes this ProjectTaskGroupedListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectTaskGroupedListResponse&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.groupBy, groupBy) || other.groupBy == groupBy)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCount,groupBy,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'ProjectTaskGroupedListResponse(totalCount: $totalCount, groupBy: $groupBy, groups: $groups)';
}


}

/// @nodoc
abstract mixin class $ProjectTaskGroupedListResponseCopyWith<$Res>  {
  factory $ProjectTaskGroupedListResponseCopyWith(ProjectTaskGroupedListResponse value, $Res Function(ProjectTaskGroupedListResponse) _then) = _$ProjectTaskGroupedListResponseCopyWithImpl;
@useResult
$Res call({
 int totalCount, TaskSavedViewGroupBy groupBy, List<ProjectTaskListGroupResponse> groups
});




}
/// @nodoc
class _$ProjectTaskGroupedListResponseCopyWithImpl<$Res>
    implements $ProjectTaskGroupedListResponseCopyWith<$Res> {
  _$ProjectTaskGroupedListResponseCopyWithImpl(this._self, this._then);

  final ProjectTaskGroupedListResponse _self;
  final $Res Function(ProjectTaskGroupedListResponse) _then;

/// Create a copy of ProjectTaskGroupedListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCount = null,Object? groupBy = null,Object? groups = null,}) {
  return _then(_self.copyWith(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,groupBy: null == groupBy ? _self.groupBy : groupBy // ignore: cast_nullable_to_non_nullable
as TaskSavedViewGroupBy,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskListGroupResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectTaskGroupedListResponse].
extension ProjectTaskGroupedListResponsePatterns on ProjectTaskGroupedListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectTaskGroupedListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectTaskGroupedListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectTaskGroupedListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCount,  TaskSavedViewGroupBy groupBy,  List<ProjectTaskListGroupResponse> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse() when $default != null:
return $default(_that.totalCount,_that.groupBy,_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCount,  TaskSavedViewGroupBy groupBy,  List<ProjectTaskListGroupResponse> groups)  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse():
return $default(_that.totalCount,_that.groupBy,_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCount,  TaskSavedViewGroupBy groupBy,  List<ProjectTaskListGroupResponse> groups)?  $default,) {final _that = this;
switch (_that) {
case _ProjectTaskGroupedListResponse() when $default != null:
return $default(_that.totalCount,_that.groupBy,_that.groups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectTaskGroupedListResponse implements ProjectTaskGroupedListResponse {
  const _ProjectTaskGroupedListResponse({required this.totalCount, required this.groupBy, required this.groups});
  factory _ProjectTaskGroupedListResponse.fromJson(Map<String, dynamic> json) => _$ProjectTaskGroupedListResponseFromJson(json);

@override final  int totalCount;
@override final  TaskSavedViewGroupBy groupBy;
@override final  List<ProjectTaskListGroupResponse> groups;

/// Create a copy of ProjectTaskGroupedListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectTaskGroupedListResponseCopyWith<_ProjectTaskGroupedListResponse> get copyWith => __$ProjectTaskGroupedListResponseCopyWithImpl<_ProjectTaskGroupedListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectTaskGroupedListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectTaskGroupedListResponse&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.groupBy, groupBy) || other.groupBy == groupBy)&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCount,groupBy,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'ProjectTaskGroupedListResponse(totalCount: $totalCount, groupBy: $groupBy, groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$ProjectTaskGroupedListResponseCopyWith<$Res> implements $ProjectTaskGroupedListResponseCopyWith<$Res> {
  factory _$ProjectTaskGroupedListResponseCopyWith(_ProjectTaskGroupedListResponse value, $Res Function(_ProjectTaskGroupedListResponse) _then) = __$ProjectTaskGroupedListResponseCopyWithImpl;
@override @useResult
$Res call({
 int totalCount, TaskSavedViewGroupBy groupBy, List<ProjectTaskListGroupResponse> groups
});




}
/// @nodoc
class __$ProjectTaskGroupedListResponseCopyWithImpl<$Res>
    implements _$ProjectTaskGroupedListResponseCopyWith<$Res> {
  __$ProjectTaskGroupedListResponseCopyWithImpl(this._self, this._then);

  final _ProjectTaskGroupedListResponse _self;
  final $Res Function(_ProjectTaskGroupedListResponse) _then;

/// Create a copy of ProjectTaskGroupedListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCount = null,Object? groupBy = null,Object? groups = null,}) {
  return _then(_ProjectTaskGroupedListResponse(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,groupBy: null == groupBy ? _self.groupBy : groupBy // ignore: cast_nullable_to_non_nullable
as TaskSavedViewGroupBy,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<ProjectTaskListGroupResponse>,
  ));
}


}


/// @nodoc
mixin _$CreateTaskSelectionTokenPayload {

 TaskSelectionQueryPayload get query;
/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskSelectionTokenPayloadCopyWith<CreateTaskSelectionTokenPayload> get copyWith => _$CreateTaskSelectionTokenPayloadCopyWithImpl<CreateTaskSelectionTokenPayload>(this as CreateTaskSelectionTokenPayload, _$identity);

  /// Serializes this CreateTaskSelectionTokenPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskSelectionTokenPayload&&(identical(other.query, query) || other.query == query));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'CreateTaskSelectionTokenPayload(query: $query)';
}


}

/// @nodoc
abstract mixin class $CreateTaskSelectionTokenPayloadCopyWith<$Res>  {
  factory $CreateTaskSelectionTokenPayloadCopyWith(CreateTaskSelectionTokenPayload value, $Res Function(CreateTaskSelectionTokenPayload) _then) = _$CreateTaskSelectionTokenPayloadCopyWithImpl;
@useResult
$Res call({
 TaskSelectionQueryPayload query
});


$TaskSelectionQueryPayloadCopyWith<$Res> get query;

}
/// @nodoc
class _$CreateTaskSelectionTokenPayloadCopyWithImpl<$Res>
    implements $CreateTaskSelectionTokenPayloadCopyWith<$Res> {
  _$CreateTaskSelectionTokenPayloadCopyWithImpl(this._self, this._then);

  final CreateTaskSelectionTokenPayload _self;
  final $Res Function(CreateTaskSelectionTokenPayload) _then;

/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as TaskSelectionQueryPayload,
  ));
}
/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSelectionQueryPayloadCopyWith<$Res> get query {
  
  return $TaskSelectionQueryPayloadCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateTaskSelectionTokenPayload].
extension CreateTaskSelectionTokenPayloadPatterns on CreateTaskSelectionTokenPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskSelectionTokenPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskSelectionTokenPayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskSelectionTokenPayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskSelectionQueryPayload query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload() when $default != null:
return $default(_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskSelectionQueryPayload query)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload():
return $default(_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskSelectionQueryPayload query)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskSelectionTokenPayload() when $default != null:
return $default(_that.query);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskSelectionTokenPayload implements CreateTaskSelectionTokenPayload {
  const _CreateTaskSelectionTokenPayload({required this.query});
  factory _CreateTaskSelectionTokenPayload.fromJson(Map<String, dynamic> json) => _$CreateTaskSelectionTokenPayloadFromJson(json);

@override final  TaskSelectionQueryPayload query;

/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskSelectionTokenPayloadCopyWith<_CreateTaskSelectionTokenPayload> get copyWith => __$CreateTaskSelectionTokenPayloadCopyWithImpl<_CreateTaskSelectionTokenPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskSelectionTokenPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskSelectionTokenPayload&&(identical(other.query, query) || other.query == query));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'CreateTaskSelectionTokenPayload(query: $query)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskSelectionTokenPayloadCopyWith<$Res> implements $CreateTaskSelectionTokenPayloadCopyWith<$Res> {
  factory _$CreateTaskSelectionTokenPayloadCopyWith(_CreateTaskSelectionTokenPayload value, $Res Function(_CreateTaskSelectionTokenPayload) _then) = __$CreateTaskSelectionTokenPayloadCopyWithImpl;
@override @useResult
$Res call({
 TaskSelectionQueryPayload query
});


@override $TaskSelectionQueryPayloadCopyWith<$Res> get query;

}
/// @nodoc
class __$CreateTaskSelectionTokenPayloadCopyWithImpl<$Res>
    implements _$CreateTaskSelectionTokenPayloadCopyWith<$Res> {
  __$CreateTaskSelectionTokenPayloadCopyWithImpl(this._self, this._then);

  final _CreateTaskSelectionTokenPayload _self;
  final $Res Function(_CreateTaskSelectionTokenPayload) _then;

/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_CreateTaskSelectionTokenPayload(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as TaskSelectionQueryPayload,
  ));
}

/// Create a copy of CreateTaskSelectionTokenPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskSelectionQueryPayloadCopyWith<$Res> get query {
  
  return $TaskSelectionQueryPayloadCopyWith<$Res>(_self.query, (value) {
    return _then(_self.copyWith(query: value));
  });
}
}


/// @nodoc
mixin _$TaskSelectionQueryPayload {

 String? get savedViewId; String? get status; String? get priority; String? get assigneeUserId; String? get myInvolvement; String? get search; DateTime? get dueFromUtc; DateTime? get dueToUtc; bool get includeArchived; bool get pinnedOnly; bool get unassignedOnly;
/// Create a copy of TaskSelectionQueryPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSelectionQueryPayloadCopyWith<TaskSelectionQueryPayload> get copyWith => _$TaskSelectionQueryPayloadCopyWithImpl<TaskSelectionQueryPayload>(this as TaskSelectionQueryPayload, _$identity);

  /// Serializes this TaskSelectionQueryPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSelectionQueryPayload&&(identical(other.savedViewId, savedViewId) || other.savedViewId == savedViewId)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assigneeUserId, assigneeUserId) || other.assigneeUserId == assigneeUserId)&&(identical(other.myInvolvement, myInvolvement) || other.myInvolvement == myInvolvement)&&(identical(other.search, search) || other.search == search)&&(identical(other.dueFromUtc, dueFromUtc) || other.dueFromUtc == dueFromUtc)&&(identical(other.dueToUtc, dueToUtc) || other.dueToUtc == dueToUtc)&&(identical(other.includeArchived, includeArchived) || other.includeArchived == includeArchived)&&(identical(other.pinnedOnly, pinnedOnly) || other.pinnedOnly == pinnedOnly)&&(identical(other.unassignedOnly, unassignedOnly) || other.unassignedOnly == unassignedOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,savedViewId,status,priority,assigneeUserId,myInvolvement,search,dueFromUtc,dueToUtc,includeArchived,pinnedOnly,unassignedOnly);

@override
String toString() {
  return 'TaskSelectionQueryPayload(savedViewId: $savedViewId, status: $status, priority: $priority, assigneeUserId: $assigneeUserId, myInvolvement: $myInvolvement, search: $search, dueFromUtc: $dueFromUtc, dueToUtc: $dueToUtc, includeArchived: $includeArchived, pinnedOnly: $pinnedOnly, unassignedOnly: $unassignedOnly)';
}


}

/// @nodoc
abstract mixin class $TaskSelectionQueryPayloadCopyWith<$Res>  {
  factory $TaskSelectionQueryPayloadCopyWith(TaskSelectionQueryPayload value, $Res Function(TaskSelectionQueryPayload) _then) = _$TaskSelectionQueryPayloadCopyWithImpl;
@useResult
$Res call({
 String? savedViewId, String? status, String? priority, String? assigneeUserId, String? myInvolvement, String? search, DateTime? dueFromUtc, DateTime? dueToUtc, bool includeArchived, bool pinnedOnly, bool unassignedOnly
});




}
/// @nodoc
class _$TaskSelectionQueryPayloadCopyWithImpl<$Res>
    implements $TaskSelectionQueryPayloadCopyWith<$Res> {
  _$TaskSelectionQueryPayloadCopyWithImpl(this._self, this._then);

  final TaskSelectionQueryPayload _self;
  final $Res Function(TaskSelectionQueryPayload) _then;

/// Create a copy of TaskSelectionQueryPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? savedViewId = freezed,Object? status = freezed,Object? priority = freezed,Object? assigneeUserId = freezed,Object? myInvolvement = freezed,Object? search = freezed,Object? dueFromUtc = freezed,Object? dueToUtc = freezed,Object? includeArchived = null,Object? pinnedOnly = null,Object? unassignedOnly = null,}) {
  return _then(_self.copyWith(
savedViewId: freezed == savedViewId ? _self.savedViewId : savedViewId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,assigneeUserId: freezed == assigneeUserId ? _self.assigneeUserId : assigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,myInvolvement: freezed == myInvolvement ? _self.myInvolvement : myInvolvement // ignore: cast_nullable_to_non_nullable
as String?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,dueFromUtc: freezed == dueFromUtc ? _self.dueFromUtc : dueFromUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueToUtc: freezed == dueToUtc ? _self.dueToUtc : dueToUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,includeArchived: null == includeArchived ? _self.includeArchived : includeArchived // ignore: cast_nullable_to_non_nullable
as bool,pinnedOnly: null == pinnedOnly ? _self.pinnedOnly : pinnedOnly // ignore: cast_nullable_to_non_nullable
as bool,unassignedOnly: null == unassignedOnly ? _self.unassignedOnly : unassignedOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskSelectionQueryPayload].
extension TaskSelectionQueryPayloadPatterns on TaskSelectionQueryPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSelectionQueryPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSelectionQueryPayload value)  $default,){
final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSelectionQueryPayload value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? savedViewId,  String? status,  String? priority,  String? assigneeUserId,  String? myInvolvement,  String? search,  DateTime? dueFromUtc,  DateTime? dueToUtc,  bool includeArchived,  bool pinnedOnly,  bool unassignedOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload() when $default != null:
return $default(_that.savedViewId,_that.status,_that.priority,_that.assigneeUserId,_that.myInvolvement,_that.search,_that.dueFromUtc,_that.dueToUtc,_that.includeArchived,_that.pinnedOnly,_that.unassignedOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? savedViewId,  String? status,  String? priority,  String? assigneeUserId,  String? myInvolvement,  String? search,  DateTime? dueFromUtc,  DateTime? dueToUtc,  bool includeArchived,  bool pinnedOnly,  bool unassignedOnly)  $default,) {final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload():
return $default(_that.savedViewId,_that.status,_that.priority,_that.assigneeUserId,_that.myInvolvement,_that.search,_that.dueFromUtc,_that.dueToUtc,_that.includeArchived,_that.pinnedOnly,_that.unassignedOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? savedViewId,  String? status,  String? priority,  String? assigneeUserId,  String? myInvolvement,  String? search,  DateTime? dueFromUtc,  DateTime? dueToUtc,  bool includeArchived,  bool pinnedOnly,  bool unassignedOnly)?  $default,) {final _that = this;
switch (_that) {
case _TaskSelectionQueryPayload() when $default != null:
return $default(_that.savedViewId,_that.status,_that.priority,_that.assigneeUserId,_that.myInvolvement,_that.search,_that.dueFromUtc,_that.dueToUtc,_that.includeArchived,_that.pinnedOnly,_that.unassignedOnly);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSelectionQueryPayload implements TaskSelectionQueryPayload {
  const _TaskSelectionQueryPayload({this.savedViewId, this.status, this.priority, this.assigneeUserId, this.myInvolvement, this.search, this.dueFromUtc, this.dueToUtc, this.includeArchived = false, this.pinnedOnly = false, this.unassignedOnly = false});
  factory _TaskSelectionQueryPayload.fromJson(Map<String, dynamic> json) => _$TaskSelectionQueryPayloadFromJson(json);

@override final  String? savedViewId;
@override final  String? status;
@override final  String? priority;
@override final  String? assigneeUserId;
@override final  String? myInvolvement;
@override final  String? search;
@override final  DateTime? dueFromUtc;
@override final  DateTime? dueToUtc;
@override@JsonKey() final  bool includeArchived;
@override@JsonKey() final  bool pinnedOnly;
@override@JsonKey() final  bool unassignedOnly;

/// Create a copy of TaskSelectionQueryPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSelectionQueryPayloadCopyWith<_TaskSelectionQueryPayload> get copyWith => __$TaskSelectionQueryPayloadCopyWithImpl<_TaskSelectionQueryPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSelectionQueryPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSelectionQueryPayload&&(identical(other.savedViewId, savedViewId) || other.savedViewId == savedViewId)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assigneeUserId, assigneeUserId) || other.assigneeUserId == assigneeUserId)&&(identical(other.myInvolvement, myInvolvement) || other.myInvolvement == myInvolvement)&&(identical(other.search, search) || other.search == search)&&(identical(other.dueFromUtc, dueFromUtc) || other.dueFromUtc == dueFromUtc)&&(identical(other.dueToUtc, dueToUtc) || other.dueToUtc == dueToUtc)&&(identical(other.includeArchived, includeArchived) || other.includeArchived == includeArchived)&&(identical(other.pinnedOnly, pinnedOnly) || other.pinnedOnly == pinnedOnly)&&(identical(other.unassignedOnly, unassignedOnly) || other.unassignedOnly == unassignedOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,savedViewId,status,priority,assigneeUserId,myInvolvement,search,dueFromUtc,dueToUtc,includeArchived,pinnedOnly,unassignedOnly);

@override
String toString() {
  return 'TaskSelectionQueryPayload(savedViewId: $savedViewId, status: $status, priority: $priority, assigneeUserId: $assigneeUserId, myInvolvement: $myInvolvement, search: $search, dueFromUtc: $dueFromUtc, dueToUtc: $dueToUtc, includeArchived: $includeArchived, pinnedOnly: $pinnedOnly, unassignedOnly: $unassignedOnly)';
}


}

/// @nodoc
abstract mixin class _$TaskSelectionQueryPayloadCopyWith<$Res> implements $TaskSelectionQueryPayloadCopyWith<$Res> {
  factory _$TaskSelectionQueryPayloadCopyWith(_TaskSelectionQueryPayload value, $Res Function(_TaskSelectionQueryPayload) _then) = __$TaskSelectionQueryPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? savedViewId, String? status, String? priority, String? assigneeUserId, String? myInvolvement, String? search, DateTime? dueFromUtc, DateTime? dueToUtc, bool includeArchived, bool pinnedOnly, bool unassignedOnly
});




}
/// @nodoc
class __$TaskSelectionQueryPayloadCopyWithImpl<$Res>
    implements _$TaskSelectionQueryPayloadCopyWith<$Res> {
  __$TaskSelectionQueryPayloadCopyWithImpl(this._self, this._then);

  final _TaskSelectionQueryPayload _self;
  final $Res Function(_TaskSelectionQueryPayload) _then;

/// Create a copy of TaskSelectionQueryPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? savedViewId = freezed,Object? status = freezed,Object? priority = freezed,Object? assigneeUserId = freezed,Object? myInvolvement = freezed,Object? search = freezed,Object? dueFromUtc = freezed,Object? dueToUtc = freezed,Object? includeArchived = null,Object? pinnedOnly = null,Object? unassignedOnly = null,}) {
  return _then(_TaskSelectionQueryPayload(
savedViewId: freezed == savedViewId ? _self.savedViewId : savedViewId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,assigneeUserId: freezed == assigneeUserId ? _self.assigneeUserId : assigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,myInvolvement: freezed == myInvolvement ? _self.myInvolvement : myInvolvement // ignore: cast_nullable_to_non_nullable
as String?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,dueFromUtc: freezed == dueFromUtc ? _self.dueFromUtc : dueFromUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueToUtc: freezed == dueToUtc ? _self.dueToUtc : dueToUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,includeArchived: null == includeArchived ? _self.includeArchived : includeArchived // ignore: cast_nullable_to_non_nullable
as bool,pinnedOnly: null == pinnedOnly ? _self.pinnedOnly : pinnedOnly // ignore: cast_nullable_to_non_nullable
as bool,unassignedOnly: null == unassignedOnly ? _self.unassignedOnly : unassignedOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TaskSelectionTokenResponse {

 String get token; int get totalCount; DateTime get expiresAtUtc;
/// Create a copy of TaskSelectionTokenResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSelectionTokenResponseCopyWith<TaskSelectionTokenResponse> get copyWith => _$TaskSelectionTokenResponseCopyWithImpl<TaskSelectionTokenResponse>(this as TaskSelectionTokenResponse, _$identity);

  /// Serializes this TaskSelectionTokenResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSelectionTokenResponse&&(identical(other.token, token) || other.token == token)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,totalCount,expiresAtUtc);

@override
String toString() {
  return 'TaskSelectionTokenResponse(token: $token, totalCount: $totalCount, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class $TaskSelectionTokenResponseCopyWith<$Res>  {
  factory $TaskSelectionTokenResponseCopyWith(TaskSelectionTokenResponse value, $Res Function(TaskSelectionTokenResponse) _then) = _$TaskSelectionTokenResponseCopyWithImpl;
@useResult
$Res call({
 String token, int totalCount, DateTime expiresAtUtc
});




}
/// @nodoc
class _$TaskSelectionTokenResponseCopyWithImpl<$Res>
    implements $TaskSelectionTokenResponseCopyWith<$Res> {
  _$TaskSelectionTokenResponseCopyWithImpl(this._self, this._then);

  final TaskSelectionTokenResponse _self;
  final $Res Function(TaskSelectionTokenResponse) _then;

/// Create a copy of TaskSelectionTokenResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? totalCount = null,Object? expiresAtUtc = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskSelectionTokenResponse].
extension TaskSelectionTokenResponsePatterns on TaskSelectionTokenResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSelectionTokenResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSelectionTokenResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSelectionTokenResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  int totalCount,  DateTime expiresAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse() when $default != null:
return $default(_that.token,_that.totalCount,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  int totalCount,  DateTime expiresAtUtc)  $default,) {final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse():
return $default(_that.token,_that.totalCount,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  int totalCount,  DateTime expiresAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _TaskSelectionTokenResponse() when $default != null:
return $default(_that.token,_that.totalCount,_that.expiresAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSelectionTokenResponse implements TaskSelectionTokenResponse {
  const _TaskSelectionTokenResponse({required this.token, required this.totalCount, required this.expiresAtUtc});
  factory _TaskSelectionTokenResponse.fromJson(Map<String, dynamic> json) => _$TaskSelectionTokenResponseFromJson(json);

@override final  String token;
@override final  int totalCount;
@override final  DateTime expiresAtUtc;

/// Create a copy of TaskSelectionTokenResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSelectionTokenResponseCopyWith<_TaskSelectionTokenResponse> get copyWith => __$TaskSelectionTokenResponseCopyWithImpl<_TaskSelectionTokenResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSelectionTokenResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSelectionTokenResponse&&(identical(other.token, token) || other.token == token)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,totalCount,expiresAtUtc);

@override
String toString() {
  return 'TaskSelectionTokenResponse(token: $token, totalCount: $totalCount, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class _$TaskSelectionTokenResponseCopyWith<$Res> implements $TaskSelectionTokenResponseCopyWith<$Res> {
  factory _$TaskSelectionTokenResponseCopyWith(_TaskSelectionTokenResponse value, $Res Function(_TaskSelectionTokenResponse) _then) = __$TaskSelectionTokenResponseCopyWithImpl;
@override @useResult
$Res call({
 String token, int totalCount, DateTime expiresAtUtc
});




}
/// @nodoc
class __$TaskSelectionTokenResponseCopyWithImpl<$Res>
    implements _$TaskSelectionTokenResponseCopyWith<$Res> {
  __$TaskSelectionTokenResponseCopyWithImpl(this._self, this._then);

  final _TaskSelectionTokenResponse _self;
  final $Res Function(_TaskSelectionTokenResponse) _then;

/// Create a copy of TaskSelectionTokenResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? totalCount = null,Object? expiresAtUtc = null,}) {
  return _then(_TaskSelectionTokenResponse(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$BulkUpdateTaskSelectionPayload {

 String get selectionToken; ProjectTaskStatus? get status; String? get customStatusId; bool get clearCustomStatus; TaskPriority? get priority; DateTime? get dueAtUtc; bool get clearDueAtUtc; List<String>? get assigneeIds; bool get archive; List<String> get returnTaskIds;
/// Create a copy of BulkUpdateTaskSelectionPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkUpdateTaskSelectionPayloadCopyWith<BulkUpdateTaskSelectionPayload> get copyWith => _$BulkUpdateTaskSelectionPayloadCopyWithImpl<BulkUpdateTaskSelectionPayload>(this as BulkUpdateTaskSelectionPayload, _$identity);

  /// Serializes this BulkUpdateTaskSelectionPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkUpdateTaskSelectionPayload&&(identical(other.selectionToken, selectionToken) || other.selectionToken == selectionToken)&&(identical(other.status, status) || other.status == status)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.clearCustomStatus, clearCustomStatus) || other.clearCustomStatus == clearCustomStatus)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.clearDueAtUtc, clearDueAtUtc) || other.clearDueAtUtc == clearDueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeIds, assigneeIds)&&(identical(other.archive, archive) || other.archive == archive)&&const DeepCollectionEquality().equals(other.returnTaskIds, returnTaskIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectionToken,status,customStatusId,clearCustomStatus,priority,dueAtUtc,clearDueAtUtc,const DeepCollectionEquality().hash(assigneeIds),archive,const DeepCollectionEquality().hash(returnTaskIds));

@override
String toString() {
  return 'BulkUpdateTaskSelectionPayload(selectionToken: $selectionToken, status: $status, customStatusId: $customStatusId, clearCustomStatus: $clearCustomStatus, priority: $priority, dueAtUtc: $dueAtUtc, clearDueAtUtc: $clearDueAtUtc, assigneeIds: $assigneeIds, archive: $archive, returnTaskIds: $returnTaskIds)';
}


}

/// @nodoc
abstract mixin class $BulkUpdateTaskSelectionPayloadCopyWith<$Res>  {
  factory $BulkUpdateTaskSelectionPayloadCopyWith(BulkUpdateTaskSelectionPayload value, $Res Function(BulkUpdateTaskSelectionPayload) _then) = _$BulkUpdateTaskSelectionPayloadCopyWithImpl;
@useResult
$Res call({
 String selectionToken, ProjectTaskStatus? status, String? customStatusId, bool clearCustomStatus, TaskPriority? priority, DateTime? dueAtUtc, bool clearDueAtUtc, List<String>? assigneeIds, bool archive, List<String> returnTaskIds
});




}
/// @nodoc
class _$BulkUpdateTaskSelectionPayloadCopyWithImpl<$Res>
    implements $BulkUpdateTaskSelectionPayloadCopyWith<$Res> {
  _$BulkUpdateTaskSelectionPayloadCopyWithImpl(this._self, this._then);

  final BulkUpdateTaskSelectionPayload _self;
  final $Res Function(BulkUpdateTaskSelectionPayload) _then;

/// Create a copy of BulkUpdateTaskSelectionPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectionToken = null,Object? status = freezed,Object? customStatusId = freezed,Object? clearCustomStatus = null,Object? priority = freezed,Object? dueAtUtc = freezed,Object? clearDueAtUtc = null,Object? assigneeIds = freezed,Object? archive = null,Object? returnTaskIds = null,}) {
  return _then(_self.copyWith(
selectionToken: null == selectionToken ? _self.selectionToken : selectionToken // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,clearCustomStatus: null == clearCustomStatus ? _self.clearCustomStatus : clearCustomStatus // ignore: cast_nullable_to_non_nullable
as bool,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,clearDueAtUtc: null == clearDueAtUtc ? _self.clearDueAtUtc : clearDueAtUtc // ignore: cast_nullable_to_non_nullable
as bool,assigneeIds: freezed == assigneeIds ? _self.assigneeIds : assigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>?,archive: null == archive ? _self.archive : archive // ignore: cast_nullable_to_non_nullable
as bool,returnTaskIds: null == returnTaskIds ? _self.returnTaskIds : returnTaskIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkUpdateTaskSelectionPayload].
extension BulkUpdateTaskSelectionPayloadPatterns on BulkUpdateTaskSelectionPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkUpdateTaskSelectionPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkUpdateTaskSelectionPayload value)  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkUpdateTaskSelectionPayload value)?  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String selectionToken,  ProjectTaskStatus? status,  String? customStatusId,  bool clearCustomStatus,  TaskPriority? priority,  DateTime? dueAtUtc,  bool clearDueAtUtc,  List<String>? assigneeIds,  bool archive,  List<String> returnTaskIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload() when $default != null:
return $default(_that.selectionToken,_that.status,_that.customStatusId,_that.clearCustomStatus,_that.priority,_that.dueAtUtc,_that.clearDueAtUtc,_that.assigneeIds,_that.archive,_that.returnTaskIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String selectionToken,  ProjectTaskStatus? status,  String? customStatusId,  bool clearCustomStatus,  TaskPriority? priority,  DateTime? dueAtUtc,  bool clearDueAtUtc,  List<String>? assigneeIds,  bool archive,  List<String> returnTaskIds)  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload():
return $default(_that.selectionToken,_that.status,_that.customStatusId,_that.clearCustomStatus,_that.priority,_that.dueAtUtc,_that.clearDueAtUtc,_that.assigneeIds,_that.archive,_that.returnTaskIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String selectionToken,  ProjectTaskStatus? status,  String? customStatusId,  bool clearCustomStatus,  TaskPriority? priority,  DateTime? dueAtUtc,  bool clearDueAtUtc,  List<String>? assigneeIds,  bool archive,  List<String> returnTaskIds)?  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionPayload() when $default != null:
return $default(_that.selectionToken,_that.status,_that.customStatusId,_that.clearCustomStatus,_that.priority,_that.dueAtUtc,_that.clearDueAtUtc,_that.assigneeIds,_that.archive,_that.returnTaskIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkUpdateTaskSelectionPayload implements BulkUpdateTaskSelectionPayload {
  const _BulkUpdateTaskSelectionPayload({required this.selectionToken, this.status, this.customStatusId, this.clearCustomStatus = false, this.priority, this.dueAtUtc, this.clearDueAtUtc = false, this.assigneeIds, this.archive = false, this.returnTaskIds = const <String>[]});
  factory _BulkUpdateTaskSelectionPayload.fromJson(Map<String, dynamic> json) => _$BulkUpdateTaskSelectionPayloadFromJson(json);

@override final  String selectionToken;
@override final  ProjectTaskStatus? status;
@override final  String? customStatusId;
@override@JsonKey() final  bool clearCustomStatus;
@override final  TaskPriority? priority;
@override final  DateTime? dueAtUtc;
@override@JsonKey() final  bool clearDueAtUtc;
@override final  List<String>? assigneeIds;
@override@JsonKey() final  bool archive;
@override@JsonKey() final  List<String> returnTaskIds;

/// Create a copy of BulkUpdateTaskSelectionPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkUpdateTaskSelectionPayloadCopyWith<_BulkUpdateTaskSelectionPayload> get copyWith => __$BulkUpdateTaskSelectionPayloadCopyWithImpl<_BulkUpdateTaskSelectionPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkUpdateTaskSelectionPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkUpdateTaskSelectionPayload&&(identical(other.selectionToken, selectionToken) || other.selectionToken == selectionToken)&&(identical(other.status, status) || other.status == status)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.clearCustomStatus, clearCustomStatus) || other.clearCustomStatus == clearCustomStatus)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.clearDueAtUtc, clearDueAtUtc) || other.clearDueAtUtc == clearDueAtUtc)&&const DeepCollectionEquality().equals(other.assigneeIds, assigneeIds)&&(identical(other.archive, archive) || other.archive == archive)&&const DeepCollectionEquality().equals(other.returnTaskIds, returnTaskIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectionToken,status,customStatusId,clearCustomStatus,priority,dueAtUtc,clearDueAtUtc,const DeepCollectionEquality().hash(assigneeIds),archive,const DeepCollectionEquality().hash(returnTaskIds));

@override
String toString() {
  return 'BulkUpdateTaskSelectionPayload(selectionToken: $selectionToken, status: $status, customStatusId: $customStatusId, clearCustomStatus: $clearCustomStatus, priority: $priority, dueAtUtc: $dueAtUtc, clearDueAtUtc: $clearDueAtUtc, assigneeIds: $assigneeIds, archive: $archive, returnTaskIds: $returnTaskIds)';
}


}

/// @nodoc
abstract mixin class _$BulkUpdateTaskSelectionPayloadCopyWith<$Res> implements $BulkUpdateTaskSelectionPayloadCopyWith<$Res> {
  factory _$BulkUpdateTaskSelectionPayloadCopyWith(_BulkUpdateTaskSelectionPayload value, $Res Function(_BulkUpdateTaskSelectionPayload) _then) = __$BulkUpdateTaskSelectionPayloadCopyWithImpl;
@override @useResult
$Res call({
 String selectionToken, ProjectTaskStatus? status, String? customStatusId, bool clearCustomStatus, TaskPriority? priority, DateTime? dueAtUtc, bool clearDueAtUtc, List<String>? assigneeIds, bool archive, List<String> returnTaskIds
});




}
/// @nodoc
class __$BulkUpdateTaskSelectionPayloadCopyWithImpl<$Res>
    implements _$BulkUpdateTaskSelectionPayloadCopyWith<$Res> {
  __$BulkUpdateTaskSelectionPayloadCopyWithImpl(this._self, this._then);

  final _BulkUpdateTaskSelectionPayload _self;
  final $Res Function(_BulkUpdateTaskSelectionPayload) _then;

/// Create a copy of BulkUpdateTaskSelectionPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectionToken = null,Object? status = freezed,Object? customStatusId = freezed,Object? clearCustomStatus = null,Object? priority = freezed,Object? dueAtUtc = freezed,Object? clearDueAtUtc = null,Object? assigneeIds = freezed,Object? archive = null,Object? returnTaskIds = null,}) {
  return _then(_BulkUpdateTaskSelectionPayload(
selectionToken: null == selectionToken ? _self.selectionToken : selectionToken // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,clearCustomStatus: null == clearCustomStatus ? _self.clearCustomStatus : clearCustomStatus // ignore: cast_nullable_to_non_nullable
as bool,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,clearDueAtUtc: null == clearDueAtUtc ? _self.clearDueAtUtc : clearDueAtUtc // ignore: cast_nullable_to_non_nullable
as bool,assigneeIds: freezed == assigneeIds ? _self.assigneeIds : assigneeIds // ignore: cast_nullable_to_non_nullable
as List<String>?,archive: null == archive ? _self.archive : archive // ignore: cast_nullable_to_non_nullable
as bool,returnTaskIds: null == returnTaskIds ? _self.returnTaskIds : returnTaskIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$BulkUpdateTaskSelectionResponse {

 int get updatedCount; List<BulkUpdatedTaskVersionResponse> get updatedTasks;
/// Create a copy of BulkUpdateTaskSelectionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkUpdateTaskSelectionResponseCopyWith<BulkUpdateTaskSelectionResponse> get copyWith => _$BulkUpdateTaskSelectionResponseCopyWithImpl<BulkUpdateTaskSelectionResponse>(this as BulkUpdateTaskSelectionResponse, _$identity);

  /// Serializes this BulkUpdateTaskSelectionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkUpdateTaskSelectionResponse&&(identical(other.updatedCount, updatedCount) || other.updatedCount == updatedCount)&&const DeepCollectionEquality().equals(other.updatedTasks, updatedTasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updatedCount,const DeepCollectionEquality().hash(updatedTasks));

@override
String toString() {
  return 'BulkUpdateTaskSelectionResponse(updatedCount: $updatedCount, updatedTasks: $updatedTasks)';
}


}

/// @nodoc
abstract mixin class $BulkUpdateTaskSelectionResponseCopyWith<$Res>  {
  factory $BulkUpdateTaskSelectionResponseCopyWith(BulkUpdateTaskSelectionResponse value, $Res Function(BulkUpdateTaskSelectionResponse) _then) = _$BulkUpdateTaskSelectionResponseCopyWithImpl;
@useResult
$Res call({
 int updatedCount, List<BulkUpdatedTaskVersionResponse> updatedTasks
});




}
/// @nodoc
class _$BulkUpdateTaskSelectionResponseCopyWithImpl<$Res>
    implements $BulkUpdateTaskSelectionResponseCopyWith<$Res> {
  _$BulkUpdateTaskSelectionResponseCopyWithImpl(this._self, this._then);

  final BulkUpdateTaskSelectionResponse _self;
  final $Res Function(BulkUpdateTaskSelectionResponse) _then;

/// Create a copy of BulkUpdateTaskSelectionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? updatedCount = null,Object? updatedTasks = null,}) {
  return _then(_self.copyWith(
updatedCount: null == updatedCount ? _self.updatedCount : updatedCount // ignore: cast_nullable_to_non_nullable
as int,updatedTasks: null == updatedTasks ? _self.updatedTasks : updatedTasks // ignore: cast_nullable_to_non_nullable
as List<BulkUpdatedTaskVersionResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkUpdateTaskSelectionResponse].
extension BulkUpdateTaskSelectionResponsePatterns on BulkUpdateTaskSelectionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkUpdateTaskSelectionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkUpdateTaskSelectionResponse value)  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkUpdateTaskSelectionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int updatedCount,  List<BulkUpdatedTaskVersionResponse> updatedTasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse() when $default != null:
return $default(_that.updatedCount,_that.updatedTasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int updatedCount,  List<BulkUpdatedTaskVersionResponse> updatedTasks)  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse():
return $default(_that.updatedCount,_that.updatedTasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int updatedCount,  List<BulkUpdatedTaskVersionResponse> updatedTasks)?  $default,) {final _that = this;
switch (_that) {
case _BulkUpdateTaskSelectionResponse() when $default != null:
return $default(_that.updatedCount,_that.updatedTasks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkUpdateTaskSelectionResponse implements BulkUpdateTaskSelectionResponse {
  const _BulkUpdateTaskSelectionResponse({required this.updatedCount, this.updatedTasks = const <BulkUpdatedTaskVersionResponse>[]});
  factory _BulkUpdateTaskSelectionResponse.fromJson(Map<String, dynamic> json) => _$BulkUpdateTaskSelectionResponseFromJson(json);

@override final  int updatedCount;
@override@JsonKey() final  List<BulkUpdatedTaskVersionResponse> updatedTasks;

/// Create a copy of BulkUpdateTaskSelectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkUpdateTaskSelectionResponseCopyWith<_BulkUpdateTaskSelectionResponse> get copyWith => __$BulkUpdateTaskSelectionResponseCopyWithImpl<_BulkUpdateTaskSelectionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkUpdateTaskSelectionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkUpdateTaskSelectionResponse&&(identical(other.updatedCount, updatedCount) || other.updatedCount == updatedCount)&&const DeepCollectionEquality().equals(other.updatedTasks, updatedTasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updatedCount,const DeepCollectionEquality().hash(updatedTasks));

@override
String toString() {
  return 'BulkUpdateTaskSelectionResponse(updatedCount: $updatedCount, updatedTasks: $updatedTasks)';
}


}

/// @nodoc
abstract mixin class _$BulkUpdateTaskSelectionResponseCopyWith<$Res> implements $BulkUpdateTaskSelectionResponseCopyWith<$Res> {
  factory _$BulkUpdateTaskSelectionResponseCopyWith(_BulkUpdateTaskSelectionResponse value, $Res Function(_BulkUpdateTaskSelectionResponse) _then) = __$BulkUpdateTaskSelectionResponseCopyWithImpl;
@override @useResult
$Res call({
 int updatedCount, List<BulkUpdatedTaskVersionResponse> updatedTasks
});




}
/// @nodoc
class __$BulkUpdateTaskSelectionResponseCopyWithImpl<$Res>
    implements _$BulkUpdateTaskSelectionResponseCopyWith<$Res> {
  __$BulkUpdateTaskSelectionResponseCopyWithImpl(this._self, this._then);

  final _BulkUpdateTaskSelectionResponse _self;
  final $Res Function(_BulkUpdateTaskSelectionResponse) _then;

/// Create a copy of BulkUpdateTaskSelectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? updatedCount = null,Object? updatedTasks = null,}) {
  return _then(_BulkUpdateTaskSelectionResponse(
updatedCount: null == updatedCount ? _self.updatedCount : updatedCount // ignore: cast_nullable_to_non_nullable
as int,updatedTasks: null == updatedTasks ? _self.updatedTasks : updatedTasks // ignore: cast_nullable_to_non_nullable
as List<BulkUpdatedTaskVersionResponse>,
  ));
}


}


/// @nodoc
mixin _$BulkUpdatedTaskVersionResponse {

 String get taskId; int get version; DateTime get updatedAtUtc;
/// Create a copy of BulkUpdatedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkUpdatedTaskVersionResponseCopyWith<BulkUpdatedTaskVersionResponse> get copyWith => _$BulkUpdatedTaskVersionResponseCopyWithImpl<BulkUpdatedTaskVersionResponse>(this as BulkUpdatedTaskVersionResponse, _$identity);

  /// Serializes this BulkUpdatedTaskVersionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkUpdatedTaskVersionResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,version,updatedAtUtc);

@override
String toString() {
  return 'BulkUpdatedTaskVersionResponse(taskId: $taskId, version: $version, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $BulkUpdatedTaskVersionResponseCopyWith<$Res>  {
  factory $BulkUpdatedTaskVersionResponseCopyWith(BulkUpdatedTaskVersionResponse value, $Res Function(BulkUpdatedTaskVersionResponse) _then) = _$BulkUpdatedTaskVersionResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, int version, DateTime updatedAtUtc
});




}
/// @nodoc
class _$BulkUpdatedTaskVersionResponseCopyWithImpl<$Res>
    implements $BulkUpdatedTaskVersionResponseCopyWith<$Res> {
  _$BulkUpdatedTaskVersionResponseCopyWithImpl(this._self, this._then);

  final BulkUpdatedTaskVersionResponse _self;
  final $Res Function(BulkUpdatedTaskVersionResponse) _then;

/// Create a copy of BulkUpdatedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? version = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkUpdatedTaskVersionResponse].
extension BulkUpdatedTaskVersionResponsePatterns on BulkUpdatedTaskVersionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkUpdatedTaskVersionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkUpdatedTaskVersionResponse value)  $default,){
final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkUpdatedTaskVersionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  int version,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse() when $default != null:
return $default(_that.taskId,_that.version,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  int version,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse():
return $default(_that.taskId,_that.version,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  int version,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _BulkUpdatedTaskVersionResponse() when $default != null:
return $default(_that.taskId,_that.version,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BulkUpdatedTaskVersionResponse implements BulkUpdatedTaskVersionResponse {
  const _BulkUpdatedTaskVersionResponse({required this.taskId, required this.version, required this.updatedAtUtc});
  factory _BulkUpdatedTaskVersionResponse.fromJson(Map<String, dynamic> json) => _$BulkUpdatedTaskVersionResponseFromJson(json);

@override final  String taskId;
@override final  int version;
@override final  DateTime updatedAtUtc;

/// Create a copy of BulkUpdatedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkUpdatedTaskVersionResponseCopyWith<_BulkUpdatedTaskVersionResponse> get copyWith => __$BulkUpdatedTaskVersionResponseCopyWithImpl<_BulkUpdatedTaskVersionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BulkUpdatedTaskVersionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkUpdatedTaskVersionResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,version,updatedAtUtc);

@override
String toString() {
  return 'BulkUpdatedTaskVersionResponse(taskId: $taskId, version: $version, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$BulkUpdatedTaskVersionResponseCopyWith<$Res> implements $BulkUpdatedTaskVersionResponseCopyWith<$Res> {
  factory _$BulkUpdatedTaskVersionResponseCopyWith(_BulkUpdatedTaskVersionResponse value, $Res Function(_BulkUpdatedTaskVersionResponse) _then) = __$BulkUpdatedTaskVersionResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, int version, DateTime updatedAtUtc
});




}
/// @nodoc
class __$BulkUpdatedTaskVersionResponseCopyWithImpl<$Res>
    implements _$BulkUpdatedTaskVersionResponseCopyWith<$Res> {
  __$BulkUpdatedTaskVersionResponseCopyWithImpl(this._self, this._then);

  final _BulkUpdatedTaskVersionResponse _self;
  final $Res Function(_BulkUpdatedTaskVersionResponse) _then;

/// Create a copy of BulkUpdatedTaskVersionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? version = null,Object? updatedAtUtc = null,}) {
  return _then(_BulkUpdatedTaskVersionResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskListItemPayload {

 String? get title;@JsonKey(includeIfNull: false) ProjectTaskStatus? get status; TaskPriority? get priority; DateTime? get startAtUtc; DateTime? get dueAtUtc; bool get clearStartAtUtc; bool get clearDueAtUtc; String? get taskType; int? get size; int? get complexity; int? get risk; int? get businessValue; int? get estimatedMinutes; bool get clearSize; bool get clearComplexity; bool get clearRisk; bool get clearBusinessValue; bool get clearEstimatedMinutes; String? get milestoneId; bool get clearMilestone;@JsonKey(includeIfNull: false) String? get customStatusId; int get expectedVersion;
/// Create a copy of UpdateTaskListItemPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskListItemPayloadCopyWith<UpdateTaskListItemPayload> get copyWith => _$UpdateTaskListItemPayloadCopyWithImpl<UpdateTaskListItemPayload>(this as UpdateTaskListItemPayload, _$identity);

  /// Serializes this UpdateTaskListItemPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskListItemPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.clearStartAtUtc, clearStartAtUtc) || other.clearStartAtUtc == clearStartAtUtc)&&(identical(other.clearDueAtUtc, clearDueAtUtc) || other.clearDueAtUtc == clearDueAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.clearSize, clearSize) || other.clearSize == clearSize)&&(identical(other.clearComplexity, clearComplexity) || other.clearComplexity == clearComplexity)&&(identical(other.clearRisk, clearRisk) || other.clearRisk == clearRisk)&&(identical(other.clearBusinessValue, clearBusinessValue) || other.clearBusinessValue == clearBusinessValue)&&(identical(other.clearEstimatedMinutes, clearEstimatedMinutes) || other.clearEstimatedMinutes == clearEstimatedMinutes)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.clearMilestone, clearMilestone) || other.clearMilestone == clearMilestone)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,status,priority,startAtUtc,dueAtUtc,clearStartAtUtc,clearDueAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,clearSize,clearComplexity,clearRisk,clearBusinessValue,clearEstimatedMinutes,milestoneId,clearMilestone,customStatusId,expectedVersion]);

@override
String toString() {
  return 'UpdateTaskListItemPayload(title: $title, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, clearStartAtUtc: $clearStartAtUtc, clearDueAtUtc: $clearDueAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, clearSize: $clearSize, clearComplexity: $clearComplexity, clearRisk: $clearRisk, clearBusinessValue: $clearBusinessValue, clearEstimatedMinutes: $clearEstimatedMinutes, milestoneId: $milestoneId, clearMilestone: $clearMilestone, customStatusId: $customStatusId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskListItemPayloadCopyWith<$Res>  {
  factory $UpdateTaskListItemPayloadCopyWith(UpdateTaskListItemPayload value, $Res Function(UpdateTaskListItemPayload) _then) = _$UpdateTaskListItemPayloadCopyWithImpl;
@useResult
$Res call({
 String? title,@JsonKey(includeIfNull: false) ProjectTaskStatus? status, TaskPriority? priority, DateTime? startAtUtc, DateTime? dueAtUtc, bool clearStartAtUtc, bool clearDueAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, bool clearSize, bool clearComplexity, bool clearRisk, bool clearBusinessValue, bool clearEstimatedMinutes, String? milestoneId, bool clearMilestone,@JsonKey(includeIfNull: false) String? customStatusId, int expectedVersion
});




}
/// @nodoc
class _$UpdateTaskListItemPayloadCopyWithImpl<$Res>
    implements $UpdateTaskListItemPayloadCopyWith<$Res> {
  _$UpdateTaskListItemPayloadCopyWithImpl(this._self, this._then);

  final UpdateTaskListItemPayload _self;
  final $Res Function(UpdateTaskListItemPayload) _then;

/// Create a copy of UpdateTaskListItemPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? status = freezed,Object? priority = freezed,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? clearStartAtUtc = null,Object? clearDueAtUtc = null,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? clearSize = null,Object? clearComplexity = null,Object? clearRisk = null,Object? clearBusinessValue = null,Object? clearEstimatedMinutes = null,Object? milestoneId = freezed,Object? clearMilestone = null,Object? customStatusId = freezed,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,clearStartAtUtc: null == clearStartAtUtc ? _self.clearStartAtUtc : clearStartAtUtc // ignore: cast_nullable_to_non_nullable
as bool,clearDueAtUtc: null == clearDueAtUtc ? _self.clearDueAtUtc : clearDueAtUtc // ignore: cast_nullable_to_non_nullable
as bool,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,clearSize: null == clearSize ? _self.clearSize : clearSize // ignore: cast_nullable_to_non_nullable
as bool,clearComplexity: null == clearComplexity ? _self.clearComplexity : clearComplexity // ignore: cast_nullable_to_non_nullable
as bool,clearRisk: null == clearRisk ? _self.clearRisk : clearRisk // ignore: cast_nullable_to_non_nullable
as bool,clearBusinessValue: null == clearBusinessValue ? _self.clearBusinessValue : clearBusinessValue // ignore: cast_nullable_to_non_nullable
as bool,clearEstimatedMinutes: null == clearEstimatedMinutes ? _self.clearEstimatedMinutes : clearEstimatedMinutes // ignore: cast_nullable_to_non_nullable
as bool,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,clearMilestone: null == clearMilestone ? _self.clearMilestone : clearMilestone // ignore: cast_nullable_to_non_nullable
as bool,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskListItemPayload].
extension UpdateTaskListItemPayloadPatterns on UpdateTaskListItemPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskListItemPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskListItemPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskListItemPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title, @JsonKey(includeIfNull: false)  ProjectTaskStatus? status,  TaskPriority? priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  bool clearStartAtUtc,  bool clearDueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  bool clearSize,  bool clearComplexity,  bool clearRisk,  bool clearBusinessValue,  bool clearEstimatedMinutes,  String? milestoneId,  bool clearMilestone, @JsonKey(includeIfNull: false)  String? customStatusId,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload() when $default != null:
return $default(_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.clearStartAtUtc,_that.clearDueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.clearSize,_that.clearComplexity,_that.clearRisk,_that.clearBusinessValue,_that.clearEstimatedMinutes,_that.milestoneId,_that.clearMilestone,_that.customStatusId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title, @JsonKey(includeIfNull: false)  ProjectTaskStatus? status,  TaskPriority? priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  bool clearStartAtUtc,  bool clearDueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  bool clearSize,  bool clearComplexity,  bool clearRisk,  bool clearBusinessValue,  bool clearEstimatedMinutes,  String? milestoneId,  bool clearMilestone, @JsonKey(includeIfNull: false)  String? customStatusId,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload():
return $default(_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.clearStartAtUtc,_that.clearDueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.clearSize,_that.clearComplexity,_that.clearRisk,_that.clearBusinessValue,_that.clearEstimatedMinutes,_that.milestoneId,_that.clearMilestone,_that.customStatusId,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title, @JsonKey(includeIfNull: false)  ProjectTaskStatus? status,  TaskPriority? priority,  DateTime? startAtUtc,  DateTime? dueAtUtc,  bool clearStartAtUtc,  bool clearDueAtUtc,  String? taskType,  int? size,  int? complexity,  int? risk,  int? businessValue,  int? estimatedMinutes,  bool clearSize,  bool clearComplexity,  bool clearRisk,  bool clearBusinessValue,  bool clearEstimatedMinutes,  String? milestoneId,  bool clearMilestone, @JsonKey(includeIfNull: false)  String? customStatusId,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskListItemPayload() when $default != null:
return $default(_that.title,_that.status,_that.priority,_that.startAtUtc,_that.dueAtUtc,_that.clearStartAtUtc,_that.clearDueAtUtc,_that.taskType,_that.size,_that.complexity,_that.risk,_that.businessValue,_that.estimatedMinutes,_that.clearSize,_that.clearComplexity,_that.clearRisk,_that.clearBusinessValue,_that.clearEstimatedMinutes,_that.milestoneId,_that.clearMilestone,_that.customStatusId,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskListItemPayload implements UpdateTaskListItemPayload {
  const _UpdateTaskListItemPayload({this.title, @JsonKey(includeIfNull: false) this.status, this.priority, this.startAtUtc, this.dueAtUtc, this.clearStartAtUtc = false, this.clearDueAtUtc = false, this.taskType, this.size, this.complexity, this.risk, this.businessValue, this.estimatedMinutes, this.clearSize = false, this.clearComplexity = false, this.clearRisk = false, this.clearBusinessValue = false, this.clearEstimatedMinutes = false, this.milestoneId, this.clearMilestone = false, @JsonKey(includeIfNull: false) this.customStatusId, required this.expectedVersion});
  factory _UpdateTaskListItemPayload.fromJson(Map<String, dynamic> json) => _$UpdateTaskListItemPayloadFromJson(json);

@override final  String? title;
@override@JsonKey(includeIfNull: false) final  ProjectTaskStatus? status;
@override final  TaskPriority? priority;
@override final  DateTime? startAtUtc;
@override final  DateTime? dueAtUtc;
@override@JsonKey() final  bool clearStartAtUtc;
@override@JsonKey() final  bool clearDueAtUtc;
@override final  String? taskType;
@override final  int? size;
@override final  int? complexity;
@override final  int? risk;
@override final  int? businessValue;
@override final  int? estimatedMinutes;
@override@JsonKey() final  bool clearSize;
@override@JsonKey() final  bool clearComplexity;
@override@JsonKey() final  bool clearRisk;
@override@JsonKey() final  bool clearBusinessValue;
@override@JsonKey() final  bool clearEstimatedMinutes;
@override final  String? milestoneId;
@override@JsonKey() final  bool clearMilestone;
@override@JsonKey(includeIfNull: false) final  String? customStatusId;
@override final  int expectedVersion;

/// Create a copy of UpdateTaskListItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskListItemPayloadCopyWith<_UpdateTaskListItemPayload> get copyWith => __$UpdateTaskListItemPayloadCopyWithImpl<_UpdateTaskListItemPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskListItemPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskListItemPayload&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.startAtUtc, startAtUtc) || other.startAtUtc == startAtUtc)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.clearStartAtUtc, clearStartAtUtc) || other.clearStartAtUtc == clearStartAtUtc)&&(identical(other.clearDueAtUtc, clearDueAtUtc) || other.clearDueAtUtc == clearDueAtUtc)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.size, size) || other.size == size)&&(identical(other.complexity, complexity) || other.complexity == complexity)&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.businessValue, businessValue) || other.businessValue == businessValue)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.clearSize, clearSize) || other.clearSize == clearSize)&&(identical(other.clearComplexity, clearComplexity) || other.clearComplexity == clearComplexity)&&(identical(other.clearRisk, clearRisk) || other.clearRisk == clearRisk)&&(identical(other.clearBusinessValue, clearBusinessValue) || other.clearBusinessValue == clearBusinessValue)&&(identical(other.clearEstimatedMinutes, clearEstimatedMinutes) || other.clearEstimatedMinutes == clearEstimatedMinutes)&&(identical(other.milestoneId, milestoneId) || other.milestoneId == milestoneId)&&(identical(other.clearMilestone, clearMilestone) || other.clearMilestone == clearMilestone)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,status,priority,startAtUtc,dueAtUtc,clearStartAtUtc,clearDueAtUtc,taskType,size,complexity,risk,businessValue,estimatedMinutes,clearSize,clearComplexity,clearRisk,clearBusinessValue,clearEstimatedMinutes,milestoneId,clearMilestone,customStatusId,expectedVersion]);

@override
String toString() {
  return 'UpdateTaskListItemPayload(title: $title, status: $status, priority: $priority, startAtUtc: $startAtUtc, dueAtUtc: $dueAtUtc, clearStartAtUtc: $clearStartAtUtc, clearDueAtUtc: $clearDueAtUtc, taskType: $taskType, size: $size, complexity: $complexity, risk: $risk, businessValue: $businessValue, estimatedMinutes: $estimatedMinutes, clearSize: $clearSize, clearComplexity: $clearComplexity, clearRisk: $clearRisk, clearBusinessValue: $clearBusinessValue, clearEstimatedMinutes: $clearEstimatedMinutes, milestoneId: $milestoneId, clearMilestone: $clearMilestone, customStatusId: $customStatusId, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskListItemPayloadCopyWith<$Res> implements $UpdateTaskListItemPayloadCopyWith<$Res> {
  factory _$UpdateTaskListItemPayloadCopyWith(_UpdateTaskListItemPayload value, $Res Function(_UpdateTaskListItemPayload) _then) = __$UpdateTaskListItemPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? title,@JsonKey(includeIfNull: false) ProjectTaskStatus? status, TaskPriority? priority, DateTime? startAtUtc, DateTime? dueAtUtc, bool clearStartAtUtc, bool clearDueAtUtc, String? taskType, int? size, int? complexity, int? risk, int? businessValue, int? estimatedMinutes, bool clearSize, bool clearComplexity, bool clearRisk, bool clearBusinessValue, bool clearEstimatedMinutes, String? milestoneId, bool clearMilestone,@JsonKey(includeIfNull: false) String? customStatusId, int expectedVersion
});




}
/// @nodoc
class __$UpdateTaskListItemPayloadCopyWithImpl<$Res>
    implements _$UpdateTaskListItemPayloadCopyWith<$Res> {
  __$UpdateTaskListItemPayloadCopyWithImpl(this._self, this._then);

  final _UpdateTaskListItemPayload _self;
  final $Res Function(_UpdateTaskListItemPayload) _then;

/// Create a copy of UpdateTaskListItemPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? status = freezed,Object? priority = freezed,Object? startAtUtc = freezed,Object? dueAtUtc = freezed,Object? clearStartAtUtc = null,Object? clearDueAtUtc = null,Object? taskType = freezed,Object? size = freezed,Object? complexity = freezed,Object? risk = freezed,Object? businessValue = freezed,Object? estimatedMinutes = freezed,Object? clearSize = null,Object? clearComplexity = null,Object? clearRisk = null,Object? clearBusinessValue = null,Object? clearEstimatedMinutes = null,Object? milestoneId = freezed,Object? clearMilestone = null,Object? customStatusId = freezed,Object? expectedVersion = null,}) {
  return _then(_UpdateTaskListItemPayload(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,startAtUtc: freezed == startAtUtc ? _self.startAtUtc : startAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,clearStartAtUtc: null == clearStartAtUtc ? _self.clearStartAtUtc : clearStartAtUtc // ignore: cast_nullable_to_non_nullable
as bool,clearDueAtUtc: null == clearDueAtUtc ? _self.clearDueAtUtc : clearDueAtUtc // ignore: cast_nullable_to_non_nullable
as bool,taskType: freezed == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,complexity: freezed == complexity ? _self.complexity : complexity // ignore: cast_nullable_to_non_nullable
as int?,risk: freezed == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as int?,businessValue: freezed == businessValue ? _self.businessValue : businessValue // ignore: cast_nullable_to_non_nullable
as int?,estimatedMinutes: freezed == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int?,clearSize: null == clearSize ? _self.clearSize : clearSize // ignore: cast_nullable_to_non_nullable
as bool,clearComplexity: null == clearComplexity ? _self.clearComplexity : clearComplexity // ignore: cast_nullable_to_non_nullable
as bool,clearRisk: null == clearRisk ? _self.clearRisk : clearRisk // ignore: cast_nullable_to_non_nullable
as bool,clearBusinessValue: null == clearBusinessValue ? _self.clearBusinessValue : clearBusinessValue // ignore: cast_nullable_to_non_nullable
as bool,clearEstimatedMinutes: null == clearEstimatedMinutes ? _self.clearEstimatedMinutes : clearEstimatedMinutes // ignore: cast_nullable_to_non_nullable
as bool,milestoneId: freezed == milestoneId ? _self.milestoneId : milestoneId // ignore: cast_nullable_to_non_nullable
as String?,clearMilestone: null == clearMilestone ? _self.clearMilestone : clearMilestone // ignore: cast_nullable_to_non_nullable
as bool,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MoveProjectTaskPayload {

 int get expectedVersion; String? get parentTaskId; String? get previousTaskId; String? get nextTaskId; ProjectTaskStatus? get status; String? get customStatusId;
/// Create a copy of MoveProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveProjectTaskPayloadCopyWith<MoveProjectTaskPayload> get copyWith => _$MoveProjectTaskPayloadCopyWithImpl<MoveProjectTaskPayload>(this as MoveProjectTaskPayload, _$identity);

  /// Serializes this MoveProjectTaskPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveProjectTaskPayload&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expectedVersion,parentTaskId,previousTaskId,nextTaskId,status,customStatusId);

@override
String toString() {
  return 'MoveProjectTaskPayload(expectedVersion: $expectedVersion, parentTaskId: $parentTaskId, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId, status: $status, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class $MoveProjectTaskPayloadCopyWith<$Res>  {
  factory $MoveProjectTaskPayloadCopyWith(MoveProjectTaskPayload value, $Res Function(MoveProjectTaskPayload) _then) = _$MoveProjectTaskPayloadCopyWithImpl;
@useResult
$Res call({
 int expectedVersion, String? parentTaskId, String? previousTaskId, String? nextTaskId, ProjectTaskStatus? status, String? customStatusId
});




}
/// @nodoc
class _$MoveProjectTaskPayloadCopyWithImpl<$Res>
    implements $MoveProjectTaskPayloadCopyWith<$Res> {
  _$MoveProjectTaskPayloadCopyWithImpl(this._self, this._then);

  final MoveProjectTaskPayload _self;
  final $Res Function(MoveProjectTaskPayload) _then;

/// Create a copy of MoveProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expectedVersion = null,Object? parentTaskId = freezed,Object? previousTaskId = freezed,Object? nextTaskId = freezed,Object? status = freezed,Object? customStatusId = freezed,}) {
  return _then(_self.copyWith(
expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,previousTaskId: freezed == previousTaskId ? _self.previousTaskId : previousTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextTaskId: freezed == nextTaskId ? _self.nextTaskId : nextTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MoveProjectTaskPayload].
extension MoveProjectTaskPayloadPatterns on MoveProjectTaskPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoveProjectTaskPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoveProjectTaskPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoveProjectTaskPayload value)  $default,){
final _that = this;
switch (_that) {
case _MoveProjectTaskPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoveProjectTaskPayload value)?  $default,){
final _that = this;
switch (_that) {
case _MoveProjectTaskPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int expectedVersion,  String? parentTaskId,  String? previousTaskId,  String? nextTaskId,  ProjectTaskStatus? status,  String? customStatusId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoveProjectTaskPayload() when $default != null:
return $default(_that.expectedVersion,_that.parentTaskId,_that.previousTaskId,_that.nextTaskId,_that.status,_that.customStatusId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int expectedVersion,  String? parentTaskId,  String? previousTaskId,  String? nextTaskId,  ProjectTaskStatus? status,  String? customStatusId)  $default,) {final _that = this;
switch (_that) {
case _MoveProjectTaskPayload():
return $default(_that.expectedVersion,_that.parentTaskId,_that.previousTaskId,_that.nextTaskId,_that.status,_that.customStatusId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int expectedVersion,  String? parentTaskId,  String? previousTaskId,  String? nextTaskId,  ProjectTaskStatus? status,  String? customStatusId)?  $default,) {final _that = this;
switch (_that) {
case _MoveProjectTaskPayload() when $default != null:
return $default(_that.expectedVersion,_that.parentTaskId,_that.previousTaskId,_that.nextTaskId,_that.status,_that.customStatusId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MoveProjectTaskPayload implements MoveProjectTaskPayload {
  const _MoveProjectTaskPayload({required this.expectedVersion, this.parentTaskId, this.previousTaskId, this.nextTaskId, this.status, this.customStatusId});
  factory _MoveProjectTaskPayload.fromJson(Map<String, dynamic> json) => _$MoveProjectTaskPayloadFromJson(json);

@override final  int expectedVersion;
@override final  String? parentTaskId;
@override final  String? previousTaskId;
@override final  String? nextTaskId;
@override final  ProjectTaskStatus? status;
@override final  String? customStatusId;

/// Create a copy of MoveProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoveProjectTaskPayloadCopyWith<_MoveProjectTaskPayload> get copyWith => __$MoveProjectTaskPayloadCopyWithImpl<_MoveProjectTaskPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoveProjectTaskPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoveProjectTaskPayload&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.previousTaskId, previousTaskId) || other.previousTaskId == previousTaskId)&&(identical(other.nextTaskId, nextTaskId) || other.nextTaskId == nextTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expectedVersion,parentTaskId,previousTaskId,nextTaskId,status,customStatusId);

@override
String toString() {
  return 'MoveProjectTaskPayload(expectedVersion: $expectedVersion, parentTaskId: $parentTaskId, previousTaskId: $previousTaskId, nextTaskId: $nextTaskId, status: $status, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class _$MoveProjectTaskPayloadCopyWith<$Res> implements $MoveProjectTaskPayloadCopyWith<$Res> {
  factory _$MoveProjectTaskPayloadCopyWith(_MoveProjectTaskPayload value, $Res Function(_MoveProjectTaskPayload) _then) = __$MoveProjectTaskPayloadCopyWithImpl;
@override @useResult
$Res call({
 int expectedVersion, String? parentTaskId, String? previousTaskId, String? nextTaskId, ProjectTaskStatus? status, String? customStatusId
});




}
/// @nodoc
class __$MoveProjectTaskPayloadCopyWithImpl<$Res>
    implements _$MoveProjectTaskPayloadCopyWith<$Res> {
  __$MoveProjectTaskPayloadCopyWithImpl(this._self, this._then);

  final _MoveProjectTaskPayload _self;
  final $Res Function(_MoveProjectTaskPayload) _then;

/// Create a copy of MoveProjectTaskPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expectedVersion = null,Object? parentTaskId = freezed,Object? previousTaskId = freezed,Object? nextTaskId = freezed,Object? status = freezed,Object? customStatusId = freezed,}) {
  return _then(_MoveProjectTaskPayload(
expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,previousTaskId: freezed == previousTaskId ? _self.previousTaskId : previousTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextTaskId: freezed == nextTaskId ? _self.nextTaskId : nextTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MovedProjectTaskResponse {

 String get taskId; String? get parentTaskId; ProjectTaskStatus get status; int get position; int get version; DateTime get updatedAtUtc; String? get customStatusId;
/// Create a copy of MovedProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovedProjectTaskResponseCopyWith<MovedProjectTaskResponse> get copyWith => _$MovedProjectTaskResponseCopyWithImpl<MovedProjectTaskResponse>(this as MovedProjectTaskResponse, _$identity);

  /// Serializes this MovedProjectTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovedProjectTaskResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,parentTaskId,status,position,version,updatedAtUtc,customStatusId);

@override
String toString() {
  return 'MovedProjectTaskResponse(taskId: $taskId, parentTaskId: $parentTaskId, status: $status, position: $position, version: $version, updatedAtUtc: $updatedAtUtc, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class $MovedProjectTaskResponseCopyWith<$Res>  {
  factory $MovedProjectTaskResponseCopyWith(MovedProjectTaskResponse value, $Res Function(MovedProjectTaskResponse) _then) = _$MovedProjectTaskResponseCopyWithImpl;
@useResult
$Res call({
 String taskId, String? parentTaskId, ProjectTaskStatus status, int position, int version, DateTime updatedAtUtc, String? customStatusId
});




}
/// @nodoc
class _$MovedProjectTaskResponseCopyWithImpl<$Res>
    implements $MovedProjectTaskResponseCopyWith<$Res> {
  _$MovedProjectTaskResponseCopyWithImpl(this._self, this._then);

  final MovedProjectTaskResponse _self;
  final $Res Function(MovedProjectTaskResponse) _then;

/// Create a copy of MovedProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? parentTaskId = freezed,Object? status = null,Object? position = null,Object? version = null,Object? updatedAtUtc = null,Object? customStatusId = freezed,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MovedProjectTaskResponse].
extension MovedProjectTaskResponsePatterns on MovedProjectTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovedProjectTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovedProjectTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovedProjectTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _MovedProjectTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovedProjectTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MovedProjectTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String? parentTaskId,  ProjectTaskStatus status,  int position,  int version,  DateTime updatedAtUtc,  String? customStatusId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovedProjectTaskResponse() when $default != null:
return $default(_that.taskId,_that.parentTaskId,_that.status,_that.position,_that.version,_that.updatedAtUtc,_that.customStatusId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String? parentTaskId,  ProjectTaskStatus status,  int position,  int version,  DateTime updatedAtUtc,  String? customStatusId)  $default,) {final _that = this;
switch (_that) {
case _MovedProjectTaskResponse():
return $default(_that.taskId,_that.parentTaskId,_that.status,_that.position,_that.version,_that.updatedAtUtc,_that.customStatusId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String? parentTaskId,  ProjectTaskStatus status,  int position,  int version,  DateTime updatedAtUtc,  String? customStatusId)?  $default,) {final _that = this;
switch (_that) {
case _MovedProjectTaskResponse() when $default != null:
return $default(_that.taskId,_that.parentTaskId,_that.status,_that.position,_that.version,_that.updatedAtUtc,_that.customStatusId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MovedProjectTaskResponse implements MovedProjectTaskResponse {
  const _MovedProjectTaskResponse({required this.taskId, this.parentTaskId, required this.status, required this.position, required this.version, required this.updatedAtUtc, this.customStatusId});
  factory _MovedProjectTaskResponse.fromJson(Map<String, dynamic> json) => _$MovedProjectTaskResponseFromJson(json);

@override final  String taskId;
@override final  String? parentTaskId;
@override final  ProjectTaskStatus status;
@override final  int position;
@override final  int version;
@override final  DateTime updatedAtUtc;
@override final  String? customStatusId;

/// Create a copy of MovedProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovedProjectTaskResponseCopyWith<_MovedProjectTaskResponse> get copyWith => __$MovedProjectTaskResponseCopyWithImpl<_MovedProjectTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovedProjectTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovedProjectTaskResponse&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.parentTaskId, parentTaskId) || other.parentTaskId == parentTaskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.customStatusId, customStatusId) || other.customStatusId == customStatusId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,parentTaskId,status,position,version,updatedAtUtc,customStatusId);

@override
String toString() {
  return 'MovedProjectTaskResponse(taskId: $taskId, parentTaskId: $parentTaskId, status: $status, position: $position, version: $version, updatedAtUtc: $updatedAtUtc, customStatusId: $customStatusId)';
}


}

/// @nodoc
abstract mixin class _$MovedProjectTaskResponseCopyWith<$Res> implements $MovedProjectTaskResponseCopyWith<$Res> {
  factory _$MovedProjectTaskResponseCopyWith(_MovedProjectTaskResponse value, $Res Function(_MovedProjectTaskResponse) _then) = __$MovedProjectTaskResponseCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String? parentTaskId, ProjectTaskStatus status, int position, int version, DateTime updatedAtUtc, String? customStatusId
});




}
/// @nodoc
class __$MovedProjectTaskResponseCopyWithImpl<$Res>
    implements _$MovedProjectTaskResponseCopyWith<$Res> {
  __$MovedProjectTaskResponseCopyWithImpl(this._self, this._then);

  final _MovedProjectTaskResponse _self;
  final $Res Function(_MovedProjectTaskResponse) _then;

/// Create a copy of MovedProjectTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? parentTaskId = freezed,Object? status = null,Object? position = null,Object? version = null,Object? updatedAtUtc = null,Object? customStatusId = freezed,}) {
  return _then(_MovedProjectTaskResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,parentTaskId: freezed == parentTaskId ? _self.parentTaskId : parentTaskId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,customStatusId: freezed == customStatusId ? _self.customStatusId : customStatusId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
