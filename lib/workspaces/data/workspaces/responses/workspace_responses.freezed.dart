// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_responses.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkspaceListItemResponse {

 String get id; String get name; String? get description; String? get icon; String? get primaryColor; bool get isPinned; bool get isHidden; int? get sortPosition; String? get createdByCoreUserId; bool get isOwner;
/// Create a copy of WorkspaceListItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceListItemResponseCopyWith<WorkspaceListItemResponse> get copyWith => _$WorkspaceListItemResponseCopyWithImpl<WorkspaceListItemResponse>(this as WorkspaceListItemResponse, _$identity);

  /// Serializes this WorkspaceListItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceListItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.sortPosition, sortPosition) || other.sortPosition == sortPosition)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,icon,primaryColor,isPinned,isHidden,sortPosition,createdByCoreUserId,isOwner);

@override
String toString() {
  return 'WorkspaceListItemResponse(id: $id, name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, isPinned: $isPinned, isHidden: $isHidden, sortPosition: $sortPosition, createdByCoreUserId: $createdByCoreUserId, isOwner: $isOwner)';
}


}

/// @nodoc
abstract mixin class $WorkspaceListItemResponseCopyWith<$Res>  {
  factory $WorkspaceListItemResponseCopyWith(WorkspaceListItemResponse value, $Res Function(WorkspaceListItemResponse) _then) = _$WorkspaceListItemResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? icon, String? primaryColor, bool isPinned, bool isHidden, int? sortPosition, String? createdByCoreUserId, bool isOwner
});




}
/// @nodoc
class _$WorkspaceListItemResponseCopyWithImpl<$Res>
    implements $WorkspaceListItemResponseCopyWith<$Res> {
  _$WorkspaceListItemResponseCopyWithImpl(this._self, this._then);

  final WorkspaceListItemResponse _self;
  final $Res Function(WorkspaceListItemResponse) _then;

/// Create a copy of WorkspaceListItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? isPinned = null,Object? isHidden = null,Object? sortPosition = freezed,Object? createdByCoreUserId = freezed,Object? isOwner = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,sortPosition: freezed == sortPosition ? _self.sortPosition : sortPosition // ignore: cast_nullable_to_non_nullable
as int?,createdByCoreUserId: freezed == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceListItemResponse].
extension WorkspaceListItemResponsePatterns on WorkspaceListItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceListItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceListItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceListItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceListItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceListItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceListItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? icon,  String? primaryColor,  bool isPinned,  bool isHidden,  int? sortPosition,  String? createdByCoreUserId,  bool isOwner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceListItemResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.icon,_that.primaryColor,_that.isPinned,_that.isHidden,_that.sortPosition,_that.createdByCoreUserId,_that.isOwner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? icon,  String? primaryColor,  bool isPinned,  bool isHidden,  int? sortPosition,  String? createdByCoreUserId,  bool isOwner)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceListItemResponse():
return $default(_that.id,_that.name,_that.description,_that.icon,_that.primaryColor,_that.isPinned,_that.isHidden,_that.sortPosition,_that.createdByCoreUserId,_that.isOwner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? icon,  String? primaryColor,  bool isPinned,  bool isHidden,  int? sortPosition,  String? createdByCoreUserId,  bool isOwner)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceListItemResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.icon,_that.primaryColor,_that.isPinned,_that.isHidden,_that.sortPosition,_that.createdByCoreUserId,_that.isOwner);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceListItemResponse implements WorkspaceListItemResponse {
  const _WorkspaceListItemResponse({required this.id, required this.name, this.description, this.icon, this.primaryColor, required this.isPinned, this.isHidden = false, this.sortPosition, this.createdByCoreUserId, this.isOwner = false});
  factory _WorkspaceListItemResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceListItemResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? icon;
@override final  String? primaryColor;
@override final  bool isPinned;
@override@JsonKey() final  bool isHidden;
@override final  int? sortPosition;
@override final  String? createdByCoreUserId;
@override@JsonKey() final  bool isOwner;

/// Create a copy of WorkspaceListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceListItemResponseCopyWith<_WorkspaceListItemResponse> get copyWith => __$WorkspaceListItemResponseCopyWithImpl<_WorkspaceListItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceListItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceListItemResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.sortPosition, sortPosition) || other.sortPosition == sortPosition)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,icon,primaryColor,isPinned,isHidden,sortPosition,createdByCoreUserId,isOwner);

@override
String toString() {
  return 'WorkspaceListItemResponse(id: $id, name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, isPinned: $isPinned, isHidden: $isHidden, sortPosition: $sortPosition, createdByCoreUserId: $createdByCoreUserId, isOwner: $isOwner)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceListItemResponseCopyWith<$Res> implements $WorkspaceListItemResponseCopyWith<$Res> {
  factory _$WorkspaceListItemResponseCopyWith(_WorkspaceListItemResponse value, $Res Function(_WorkspaceListItemResponse) _then) = __$WorkspaceListItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? icon, String? primaryColor, bool isPinned, bool isHidden, int? sortPosition, String? createdByCoreUserId, bool isOwner
});




}
/// @nodoc
class __$WorkspaceListItemResponseCopyWithImpl<$Res>
    implements _$WorkspaceListItemResponseCopyWith<$Res> {
  __$WorkspaceListItemResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceListItemResponse _self;
  final $Res Function(_WorkspaceListItemResponse) _then;

/// Create a copy of WorkspaceListItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? isPinned = null,Object? isHidden = null,Object? sortPosition = freezed,Object? createdByCoreUserId = freezed,Object? isOwner = null,}) {
  return _then(_WorkspaceListItemResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,sortPosition: freezed == sortPosition ? _self.sortPosition : sortPosition // ignore: cast_nullable_to_non_nullable
as int?,createdByCoreUserId: freezed == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String?,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WorkspaceResponse {

 String get id; String get name; String? get description; String? get icon; String? get primaryColor; String get createdByCoreUserId; DateTime get createdAtUtc; DateTime get updatedAtUtc; DateTime? get archivedAtUtc;
/// Create a copy of WorkspaceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceResponseCopyWith<WorkspaceResponse> get copyWith => _$WorkspaceResponseCopyWithImpl<WorkspaceResponse>(this as WorkspaceResponse, _$identity);

  /// Serializes this WorkspaceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,icon,primaryColor,createdByCoreUserId,createdAtUtc,updatedAtUtc,archivedAtUtc);

@override
String toString() {
  return 'WorkspaceResponse(id: $id, name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, createdByCoreUserId: $createdByCoreUserId, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, archivedAtUtc: $archivedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WorkspaceResponseCopyWith<$Res>  {
  factory $WorkspaceResponseCopyWith(WorkspaceResponse value, $Res Function(WorkspaceResponse) _then) = _$WorkspaceResponseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? icon, String? primaryColor, String createdByCoreUserId, DateTime createdAtUtc, DateTime updatedAtUtc, DateTime? archivedAtUtc
});




}
/// @nodoc
class _$WorkspaceResponseCopyWithImpl<$Res>
    implements $WorkspaceResponseCopyWith<$Res> {
  _$WorkspaceResponseCopyWithImpl(this._self, this._then);

  final WorkspaceResponse _self;
  final $Res Function(WorkspaceResponse) _then;

/// Create a copy of WorkspaceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? createdByCoreUserId = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? archivedAtUtc = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,createdByCoreUserId: null == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceResponse].
extension WorkspaceResponsePatterns on WorkspaceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? icon,  String? primaryColor,  String createdByCoreUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.icon,_that.primaryColor,_that.createdByCoreUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? icon,  String? primaryColor,  String createdByCoreUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceResponse():
return $default(_that.id,_that.name,_that.description,_that.icon,_that.primaryColor,_that.createdByCoreUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? icon,  String? primaryColor,  String createdByCoreUserId,  DateTime createdAtUtc,  DateTime updatedAtUtc,  DateTime? archivedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceResponse() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.icon,_that.primaryColor,_that.createdByCoreUserId,_that.createdAtUtc,_that.updatedAtUtc,_that.archivedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceResponse implements WorkspaceResponse {
  const _WorkspaceResponse({required this.id, required this.name, this.description, this.icon, this.primaryColor, required this.createdByCoreUserId, required this.createdAtUtc, required this.updatedAtUtc, this.archivedAtUtc});
  factory _WorkspaceResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceResponseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? icon;
@override final  String? primaryColor;
@override final  String createdByCoreUserId;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;
@override final  DateTime? archivedAtUtc;

/// Create a copy of WorkspaceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceResponseCopyWith<_WorkspaceResponse> get copyWith => __$WorkspaceResponseCopyWithImpl<_WorkspaceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.createdByCoreUserId, createdByCoreUserId) || other.createdByCoreUserId == createdByCoreUserId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,icon,primaryColor,createdByCoreUserId,createdAtUtc,updatedAtUtc,archivedAtUtc);

@override
String toString() {
  return 'WorkspaceResponse(id: $id, name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, createdByCoreUserId: $createdByCoreUserId, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, archivedAtUtc: $archivedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceResponseCopyWith<$Res> implements $WorkspaceResponseCopyWith<$Res> {
  factory _$WorkspaceResponseCopyWith(_WorkspaceResponse value, $Res Function(_WorkspaceResponse) _then) = __$WorkspaceResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? icon, String? primaryColor, String createdByCoreUserId, DateTime createdAtUtc, DateTime updatedAtUtc, DateTime? archivedAtUtc
});




}
/// @nodoc
class __$WorkspaceResponseCopyWithImpl<$Res>
    implements _$WorkspaceResponseCopyWith<$Res> {
  __$WorkspaceResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceResponse _self;
  final $Res Function(_WorkspaceResponse) _then;

/// Create a copy of WorkspaceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? createdByCoreUserId = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,Object? archivedAtUtc = freezed,}) {
  return _then(_WorkspaceResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,createdByCoreUserId: null == createdByCoreUserId ? _self.createdByCoreUserId : createdByCoreUserId // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$WorkspaceUserPreferenceResponse {

 String get workspaceId; bool get isHidden; bool get isPinned; int? get sortPosition;
/// Create a copy of WorkspaceUserPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceUserPreferenceResponseCopyWith<WorkspaceUserPreferenceResponse> get copyWith => _$WorkspaceUserPreferenceResponseCopyWithImpl<WorkspaceUserPreferenceResponse>(this as WorkspaceUserPreferenceResponse, _$identity);

  /// Serializes this WorkspaceUserPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceUserPreferenceResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.sortPosition, sortPosition) || other.sortPosition == sortPosition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,isHidden,isPinned,sortPosition);

@override
String toString() {
  return 'WorkspaceUserPreferenceResponse(workspaceId: $workspaceId, isHidden: $isHidden, isPinned: $isPinned, sortPosition: $sortPosition)';
}


}

/// @nodoc
abstract mixin class $WorkspaceUserPreferenceResponseCopyWith<$Res>  {
  factory $WorkspaceUserPreferenceResponseCopyWith(WorkspaceUserPreferenceResponse value, $Res Function(WorkspaceUserPreferenceResponse) _then) = _$WorkspaceUserPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String workspaceId, bool isHidden, bool isPinned, int? sortPosition
});




}
/// @nodoc
class _$WorkspaceUserPreferenceResponseCopyWithImpl<$Res>
    implements $WorkspaceUserPreferenceResponseCopyWith<$Res> {
  _$WorkspaceUserPreferenceResponseCopyWithImpl(this._self, this._then);

  final WorkspaceUserPreferenceResponse _self;
  final $Res Function(WorkspaceUserPreferenceResponse) _then;

/// Create a copy of WorkspaceUserPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workspaceId = null,Object? isHidden = null,Object? isPinned = null,Object? sortPosition = freezed,}) {
  return _then(_self.copyWith(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,sortPosition: freezed == sortPosition ? _self.sortPosition : sortPosition // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceUserPreferenceResponse].
extension WorkspaceUserPreferenceResponsePatterns on WorkspaceUserPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceUserPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceUserPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceUserPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceUserPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceUserPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceUserPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workspaceId,  bool isHidden,  bool isPinned,  int? sortPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceUserPreferenceResponse() when $default != null:
return $default(_that.workspaceId,_that.isHidden,_that.isPinned,_that.sortPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workspaceId,  bool isHidden,  bool isPinned,  int? sortPosition)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceUserPreferenceResponse():
return $default(_that.workspaceId,_that.isHidden,_that.isPinned,_that.sortPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workspaceId,  bool isHidden,  bool isPinned,  int? sortPosition)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceUserPreferenceResponse() when $default != null:
return $default(_that.workspaceId,_that.isHidden,_that.isPinned,_that.sortPosition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceUserPreferenceResponse implements WorkspaceUserPreferenceResponse {
  const _WorkspaceUserPreferenceResponse({required this.workspaceId, required this.isHidden, required this.isPinned, this.sortPosition});
  factory _WorkspaceUserPreferenceResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceUserPreferenceResponseFromJson(json);

@override final  String workspaceId;
@override final  bool isHidden;
@override final  bool isPinned;
@override final  int? sortPosition;

/// Create a copy of WorkspaceUserPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceUserPreferenceResponseCopyWith<_WorkspaceUserPreferenceResponse> get copyWith => __$WorkspaceUserPreferenceResponseCopyWithImpl<_WorkspaceUserPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceUserPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceUserPreferenceResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.sortPosition, sortPosition) || other.sortPosition == sortPosition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,isHidden,isPinned,sortPosition);

@override
String toString() {
  return 'WorkspaceUserPreferenceResponse(workspaceId: $workspaceId, isHidden: $isHidden, isPinned: $isPinned, sortPosition: $sortPosition)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceUserPreferenceResponseCopyWith<$Res> implements $WorkspaceUserPreferenceResponseCopyWith<$Res> {
  factory _$WorkspaceUserPreferenceResponseCopyWith(_WorkspaceUserPreferenceResponse value, $Res Function(_WorkspaceUserPreferenceResponse) _then) = __$WorkspaceUserPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String workspaceId, bool isHidden, bool isPinned, int? sortPosition
});




}
/// @nodoc
class __$WorkspaceUserPreferenceResponseCopyWithImpl<$Res>
    implements _$WorkspaceUserPreferenceResponseCopyWith<$Res> {
  __$WorkspaceUserPreferenceResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceUserPreferenceResponse _self;
  final $Res Function(_WorkspaceUserPreferenceResponse) _then;

/// Create a copy of WorkspaceUserPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workspaceId = null,Object? isHidden = null,Object? isPinned = null,Object? sortPosition = freezed,}) {
  return _then(_WorkspaceUserPreferenceResponse(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,sortPosition: freezed == sortPosition ? _self.sortPosition : sortPosition // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$WorkspaceNotificationPreferenceResponse {

 String get workspaceId; bool get inAppEnabled; bool get emailEnabled; bool get tasksEnabled; bool get projectsEnabled; bool get workspaceEnabled; bool get membershipEnabled; bool get invitationsEnabled; bool get adminEnabled; bool get ownerEnabled;
/// Create a copy of WorkspaceNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceNotificationPreferenceResponseCopyWith<WorkspaceNotificationPreferenceResponse> get copyWith => _$WorkspaceNotificationPreferenceResponseCopyWithImpl<WorkspaceNotificationPreferenceResponse>(this as WorkspaceNotificationPreferenceResponse, _$identity);

  /// Serializes this WorkspaceNotificationPreferenceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceNotificationPreferenceResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.tasksEnabled, tasksEnabled) || other.tasksEnabled == tasksEnabled)&&(identical(other.projectsEnabled, projectsEnabled) || other.projectsEnabled == projectsEnabled)&&(identical(other.workspaceEnabled, workspaceEnabled) || other.workspaceEnabled == workspaceEnabled)&&(identical(other.membershipEnabled, membershipEnabled) || other.membershipEnabled == membershipEnabled)&&(identical(other.invitationsEnabled, invitationsEnabled) || other.invitationsEnabled == invitationsEnabled)&&(identical(other.adminEnabled, adminEnabled) || other.adminEnabled == adminEnabled)&&(identical(other.ownerEnabled, ownerEnabled) || other.ownerEnabled == ownerEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,inAppEnabled,emailEnabled,tasksEnabled,projectsEnabled,workspaceEnabled,membershipEnabled,invitationsEnabled,adminEnabled,ownerEnabled);

@override
String toString() {
  return 'WorkspaceNotificationPreferenceResponse(workspaceId: $workspaceId, inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, tasksEnabled: $tasksEnabled, projectsEnabled: $projectsEnabled, workspaceEnabled: $workspaceEnabled, membershipEnabled: $membershipEnabled, invitationsEnabled: $invitationsEnabled, adminEnabled: $adminEnabled, ownerEnabled: $ownerEnabled)';
}


}

/// @nodoc
abstract mixin class $WorkspaceNotificationPreferenceResponseCopyWith<$Res>  {
  factory $WorkspaceNotificationPreferenceResponseCopyWith(WorkspaceNotificationPreferenceResponse value, $Res Function(WorkspaceNotificationPreferenceResponse) _then) = _$WorkspaceNotificationPreferenceResponseCopyWithImpl;
@useResult
$Res call({
 String workspaceId, bool inAppEnabled, bool emailEnabled, bool tasksEnabled, bool projectsEnabled, bool workspaceEnabled, bool membershipEnabled, bool invitationsEnabled, bool adminEnabled, bool ownerEnabled
});




}
/// @nodoc
class _$WorkspaceNotificationPreferenceResponseCopyWithImpl<$Res>
    implements $WorkspaceNotificationPreferenceResponseCopyWith<$Res> {
  _$WorkspaceNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final WorkspaceNotificationPreferenceResponse _self;
  final $Res Function(WorkspaceNotificationPreferenceResponse) _then;

/// Create a copy of WorkspaceNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workspaceId = null,Object? inAppEnabled = null,Object? emailEnabled = null,Object? tasksEnabled = null,Object? projectsEnabled = null,Object? workspaceEnabled = null,Object? membershipEnabled = null,Object? invitationsEnabled = null,Object? adminEnabled = null,Object? ownerEnabled = null,}) {
  return _then(_self.copyWith(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,inAppEnabled: null == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool,emailEnabled: null == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool,tasksEnabled: null == tasksEnabled ? _self.tasksEnabled : tasksEnabled // ignore: cast_nullable_to_non_nullable
as bool,projectsEnabled: null == projectsEnabled ? _self.projectsEnabled : projectsEnabled // ignore: cast_nullable_to_non_nullable
as bool,workspaceEnabled: null == workspaceEnabled ? _self.workspaceEnabled : workspaceEnabled // ignore: cast_nullable_to_non_nullable
as bool,membershipEnabled: null == membershipEnabled ? _self.membershipEnabled : membershipEnabled // ignore: cast_nullable_to_non_nullable
as bool,invitationsEnabled: null == invitationsEnabled ? _self.invitationsEnabled : invitationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,adminEnabled: null == adminEnabled ? _self.adminEnabled : adminEnabled // ignore: cast_nullable_to_non_nullable
as bool,ownerEnabled: null == ownerEnabled ? _self.ownerEnabled : ownerEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceNotificationPreferenceResponse].
extension WorkspaceNotificationPreferenceResponsePatterns on WorkspaceNotificationPreferenceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceNotificationPreferenceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceNotificationPreferenceResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceNotificationPreferenceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceNotificationPreferenceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceNotificationPreferenceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workspaceId,  bool inAppEnabled,  bool emailEnabled,  bool tasksEnabled,  bool projectsEnabled,  bool workspaceEnabled,  bool membershipEnabled,  bool invitationsEnabled,  bool adminEnabled,  bool ownerEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceNotificationPreferenceResponse() when $default != null:
return $default(_that.workspaceId,_that.inAppEnabled,_that.emailEnabled,_that.tasksEnabled,_that.projectsEnabled,_that.workspaceEnabled,_that.membershipEnabled,_that.invitationsEnabled,_that.adminEnabled,_that.ownerEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workspaceId,  bool inAppEnabled,  bool emailEnabled,  bool tasksEnabled,  bool projectsEnabled,  bool workspaceEnabled,  bool membershipEnabled,  bool invitationsEnabled,  bool adminEnabled,  bool ownerEnabled)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceNotificationPreferenceResponse():
return $default(_that.workspaceId,_that.inAppEnabled,_that.emailEnabled,_that.tasksEnabled,_that.projectsEnabled,_that.workspaceEnabled,_that.membershipEnabled,_that.invitationsEnabled,_that.adminEnabled,_that.ownerEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workspaceId,  bool inAppEnabled,  bool emailEnabled,  bool tasksEnabled,  bool projectsEnabled,  bool workspaceEnabled,  bool membershipEnabled,  bool invitationsEnabled,  bool adminEnabled,  bool ownerEnabled)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceNotificationPreferenceResponse() when $default != null:
return $default(_that.workspaceId,_that.inAppEnabled,_that.emailEnabled,_that.tasksEnabled,_that.projectsEnabled,_that.workspaceEnabled,_that.membershipEnabled,_that.invitationsEnabled,_that.adminEnabled,_that.ownerEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceNotificationPreferenceResponse implements WorkspaceNotificationPreferenceResponse {
  const _WorkspaceNotificationPreferenceResponse({required this.workspaceId, required this.inAppEnabled, required this.emailEnabled, required this.tasksEnabled, required this.projectsEnabled, required this.workspaceEnabled, required this.membershipEnabled, required this.invitationsEnabled, required this.adminEnabled, required this.ownerEnabled});
  factory _WorkspaceNotificationPreferenceResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceNotificationPreferenceResponseFromJson(json);

@override final  String workspaceId;
@override final  bool inAppEnabled;
@override final  bool emailEnabled;
@override final  bool tasksEnabled;
@override final  bool projectsEnabled;
@override final  bool workspaceEnabled;
@override final  bool membershipEnabled;
@override final  bool invitationsEnabled;
@override final  bool adminEnabled;
@override final  bool ownerEnabled;

/// Create a copy of WorkspaceNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceNotificationPreferenceResponseCopyWith<_WorkspaceNotificationPreferenceResponse> get copyWith => __$WorkspaceNotificationPreferenceResponseCopyWithImpl<_WorkspaceNotificationPreferenceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceNotificationPreferenceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceNotificationPreferenceResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.inAppEnabled, inAppEnabled) || other.inAppEnabled == inAppEnabled)&&(identical(other.emailEnabled, emailEnabled) || other.emailEnabled == emailEnabled)&&(identical(other.tasksEnabled, tasksEnabled) || other.tasksEnabled == tasksEnabled)&&(identical(other.projectsEnabled, projectsEnabled) || other.projectsEnabled == projectsEnabled)&&(identical(other.workspaceEnabled, workspaceEnabled) || other.workspaceEnabled == workspaceEnabled)&&(identical(other.membershipEnabled, membershipEnabled) || other.membershipEnabled == membershipEnabled)&&(identical(other.invitationsEnabled, invitationsEnabled) || other.invitationsEnabled == invitationsEnabled)&&(identical(other.adminEnabled, adminEnabled) || other.adminEnabled == adminEnabled)&&(identical(other.ownerEnabled, ownerEnabled) || other.ownerEnabled == ownerEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,inAppEnabled,emailEnabled,tasksEnabled,projectsEnabled,workspaceEnabled,membershipEnabled,invitationsEnabled,adminEnabled,ownerEnabled);

@override
String toString() {
  return 'WorkspaceNotificationPreferenceResponse(workspaceId: $workspaceId, inAppEnabled: $inAppEnabled, emailEnabled: $emailEnabled, tasksEnabled: $tasksEnabled, projectsEnabled: $projectsEnabled, workspaceEnabled: $workspaceEnabled, membershipEnabled: $membershipEnabled, invitationsEnabled: $invitationsEnabled, adminEnabled: $adminEnabled, ownerEnabled: $ownerEnabled)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceNotificationPreferenceResponseCopyWith<$Res> implements $WorkspaceNotificationPreferenceResponseCopyWith<$Res> {
  factory _$WorkspaceNotificationPreferenceResponseCopyWith(_WorkspaceNotificationPreferenceResponse value, $Res Function(_WorkspaceNotificationPreferenceResponse) _then) = __$WorkspaceNotificationPreferenceResponseCopyWithImpl;
@override @useResult
$Res call({
 String workspaceId, bool inAppEnabled, bool emailEnabled, bool tasksEnabled, bool projectsEnabled, bool workspaceEnabled, bool membershipEnabled, bool invitationsEnabled, bool adminEnabled, bool ownerEnabled
});




}
/// @nodoc
class __$WorkspaceNotificationPreferenceResponseCopyWithImpl<$Res>
    implements _$WorkspaceNotificationPreferenceResponseCopyWith<$Res> {
  __$WorkspaceNotificationPreferenceResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceNotificationPreferenceResponse _self;
  final $Res Function(_WorkspaceNotificationPreferenceResponse) _then;

/// Create a copy of WorkspaceNotificationPreferenceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workspaceId = null,Object? inAppEnabled = null,Object? emailEnabled = null,Object? tasksEnabled = null,Object? projectsEnabled = null,Object? workspaceEnabled = null,Object? membershipEnabled = null,Object? invitationsEnabled = null,Object? adminEnabled = null,Object? ownerEnabled = null,}) {
  return _then(_WorkspaceNotificationPreferenceResponse(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,inAppEnabled: null == inAppEnabled ? _self.inAppEnabled : inAppEnabled // ignore: cast_nullable_to_non_nullable
as bool,emailEnabled: null == emailEnabled ? _self.emailEnabled : emailEnabled // ignore: cast_nullable_to_non_nullable
as bool,tasksEnabled: null == tasksEnabled ? _self.tasksEnabled : tasksEnabled // ignore: cast_nullable_to_non_nullable
as bool,projectsEnabled: null == projectsEnabled ? _self.projectsEnabled : projectsEnabled // ignore: cast_nullable_to_non_nullable
as bool,workspaceEnabled: null == workspaceEnabled ? _self.workspaceEnabled : workspaceEnabled // ignore: cast_nullable_to_non_nullable
as bool,membershipEnabled: null == membershipEnabled ? _self.membershipEnabled : membershipEnabled // ignore: cast_nullable_to_non_nullable
as bool,invitationsEnabled: null == invitationsEnabled ? _self.invitationsEnabled : invitationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,adminEnabled: null == adminEnabled ? _self.adminEnabled : adminEnabled // ignore: cast_nullable_to_non_nullable
as bool,ownerEnabled: null == ownerEnabled ? _self.ownerEnabled : ownerEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WorkspaceMemberResponse {

 String get id; String get userId; WorkspaceRole get role; DateTime get createdAtUtc; DateTime get updatedAtUtc;
/// Create a copy of WorkspaceMemberResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceMemberResponseCopyWith<WorkspaceMemberResponse> get copyWith => _$WorkspaceMemberResponseCopyWithImpl<WorkspaceMemberResponse>(this as WorkspaceMemberResponse, _$identity);

  /// Serializes this WorkspaceMemberResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceMemberResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,role,createdAtUtc,updatedAtUtc);

@override
String toString() {
  return 'WorkspaceMemberResponse(id: $id, userId: $userId, role: $role, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WorkspaceMemberResponseCopyWith<$Res>  {
  factory $WorkspaceMemberResponseCopyWith(WorkspaceMemberResponse value, $Res Function(WorkspaceMemberResponse) _then) = _$WorkspaceMemberResponseCopyWithImpl;
@useResult
$Res call({
 String id, String userId, WorkspaceRole role, DateTime createdAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class _$WorkspaceMemberResponseCopyWithImpl<$Res>
    implements $WorkspaceMemberResponseCopyWith<$Res> {
  _$WorkspaceMemberResponseCopyWithImpl(this._self, this._then);

  final WorkspaceMemberResponse _self;
  final $Res Function(WorkspaceMemberResponse) _then;

/// Create a copy of WorkspaceMemberResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? role = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as WorkspaceRole,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceMemberResponse].
extension WorkspaceMemberResponsePatterns on WorkspaceMemberResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceMemberResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceMemberResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceMemberResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceMemberResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceMemberResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceMemberResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  WorkspaceRole role,  DateTime createdAtUtc,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceMemberResponse() when $default != null:
return $default(_that.id,_that.userId,_that.role,_that.createdAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  WorkspaceRole role,  DateTime createdAtUtc,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceMemberResponse():
return $default(_that.id,_that.userId,_that.role,_that.createdAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  WorkspaceRole role,  DateTime createdAtUtc,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceMemberResponse() when $default != null:
return $default(_that.id,_that.userId,_that.role,_that.createdAtUtc,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceMemberResponse implements WorkspaceMemberResponse {
  const _WorkspaceMemberResponse({required this.id, required this.userId, required this.role, required this.createdAtUtc, required this.updatedAtUtc});
  factory _WorkspaceMemberResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceMemberResponseFromJson(json);

@override final  String id;
@override final  String userId;
@override final  WorkspaceRole role;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;

/// Create a copy of WorkspaceMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceMemberResponseCopyWith<_WorkspaceMemberResponse> get copyWith => __$WorkspaceMemberResponseCopyWithImpl<_WorkspaceMemberResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceMemberResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceMemberResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,role,createdAtUtc,updatedAtUtc);

@override
String toString() {
  return 'WorkspaceMemberResponse(id: $id, userId: $userId, role: $role, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceMemberResponseCopyWith<$Res> implements $WorkspaceMemberResponseCopyWith<$Res> {
  factory _$WorkspaceMemberResponseCopyWith(_WorkspaceMemberResponse value, $Res Function(_WorkspaceMemberResponse) _then) = __$WorkspaceMemberResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, WorkspaceRole role, DateTime createdAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class __$WorkspaceMemberResponseCopyWithImpl<$Res>
    implements _$WorkspaceMemberResponseCopyWith<$Res> {
  __$WorkspaceMemberResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceMemberResponse _self;
  final $Res Function(_WorkspaceMemberResponse) _then;

/// Create a copy of WorkspaceMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? role = null,Object? createdAtUtc = null,Object? updatedAtUtc = null,}) {
  return _then(_WorkspaceMemberResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as WorkspaceRole,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WorkspaceMemberRevocationResponse {

 String get membershipId; DateTime get revokedAtUtc;
/// Create a copy of WorkspaceMemberRevocationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceMemberRevocationResponseCopyWith<WorkspaceMemberRevocationResponse> get copyWith => _$WorkspaceMemberRevocationResponseCopyWithImpl<WorkspaceMemberRevocationResponse>(this as WorkspaceMemberRevocationResponse, _$identity);

  /// Serializes this WorkspaceMemberRevocationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceMemberRevocationResponse&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.revokedAtUtc, revokedAtUtc) || other.revokedAtUtc == revokedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,membershipId,revokedAtUtc);

@override
String toString() {
  return 'WorkspaceMemberRevocationResponse(membershipId: $membershipId, revokedAtUtc: $revokedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WorkspaceMemberRevocationResponseCopyWith<$Res>  {
  factory $WorkspaceMemberRevocationResponseCopyWith(WorkspaceMemberRevocationResponse value, $Res Function(WorkspaceMemberRevocationResponse) _then) = _$WorkspaceMemberRevocationResponseCopyWithImpl;
@useResult
$Res call({
 String membershipId, DateTime revokedAtUtc
});




}
/// @nodoc
class _$WorkspaceMemberRevocationResponseCopyWithImpl<$Res>
    implements $WorkspaceMemberRevocationResponseCopyWith<$Res> {
  _$WorkspaceMemberRevocationResponseCopyWithImpl(this._self, this._then);

  final WorkspaceMemberRevocationResponse _self;
  final $Res Function(WorkspaceMemberRevocationResponse) _then;

/// Create a copy of WorkspaceMemberRevocationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membershipId = null,Object? revokedAtUtc = null,}) {
  return _then(_self.copyWith(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,revokedAtUtc: null == revokedAtUtc ? _self.revokedAtUtc : revokedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceMemberRevocationResponse].
extension WorkspaceMemberRevocationResponsePatterns on WorkspaceMemberRevocationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceMemberRevocationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceMemberRevocationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceMemberRevocationResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceMemberRevocationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceMemberRevocationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceMemberRevocationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String membershipId,  DateTime revokedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceMemberRevocationResponse() when $default != null:
return $default(_that.membershipId,_that.revokedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String membershipId,  DateTime revokedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceMemberRevocationResponse():
return $default(_that.membershipId,_that.revokedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String membershipId,  DateTime revokedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceMemberRevocationResponse() when $default != null:
return $default(_that.membershipId,_that.revokedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceMemberRevocationResponse implements WorkspaceMemberRevocationResponse {
  const _WorkspaceMemberRevocationResponse({required this.membershipId, required this.revokedAtUtc});
  factory _WorkspaceMemberRevocationResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceMemberRevocationResponseFromJson(json);

@override final  String membershipId;
@override final  DateTime revokedAtUtc;

/// Create a copy of WorkspaceMemberRevocationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceMemberRevocationResponseCopyWith<_WorkspaceMemberRevocationResponse> get copyWith => __$WorkspaceMemberRevocationResponseCopyWithImpl<_WorkspaceMemberRevocationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceMemberRevocationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceMemberRevocationResponse&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.revokedAtUtc, revokedAtUtc) || other.revokedAtUtc == revokedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,membershipId,revokedAtUtc);

@override
String toString() {
  return 'WorkspaceMemberRevocationResponse(membershipId: $membershipId, revokedAtUtc: $revokedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceMemberRevocationResponseCopyWith<$Res> implements $WorkspaceMemberRevocationResponseCopyWith<$Res> {
  factory _$WorkspaceMemberRevocationResponseCopyWith(_WorkspaceMemberRevocationResponse value, $Res Function(_WorkspaceMemberRevocationResponse) _then) = __$WorkspaceMemberRevocationResponseCopyWithImpl;
@override @useResult
$Res call({
 String membershipId, DateTime revokedAtUtc
});




}
/// @nodoc
class __$WorkspaceMemberRevocationResponseCopyWithImpl<$Res>
    implements _$WorkspaceMemberRevocationResponseCopyWith<$Res> {
  __$WorkspaceMemberRevocationResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceMemberRevocationResponse _self;
  final $Res Function(_WorkspaceMemberRevocationResponse) _then;

/// Create a copy of WorkspaceMemberRevocationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membershipId = null,Object? revokedAtUtc = null,}) {
  return _then(_WorkspaceMemberRevocationResponse(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,revokedAtUtc: null == revokedAtUtc ? _self.revokedAtUtc : revokedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$LocalUserDirectoryResponse {

 String get userId; String get login; String get displayName; String? get email; bool get emailVerified; String? get avatarFileId;
/// Create a copy of LocalUserDirectoryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalUserDirectoryResponseCopyWith<LocalUserDirectoryResponse> get copyWith => _$LocalUserDirectoryResponseCopyWithImpl<LocalUserDirectoryResponse>(this as LocalUserDirectoryResponse, _$identity);

  /// Serializes this LocalUserDirectoryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalUserDirectoryResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.avatarFileId, avatarFileId) || other.avatarFileId == avatarFileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,email,emailVerified,avatarFileId);

@override
String toString() {
  return 'LocalUserDirectoryResponse(userId: $userId, login: $login, displayName: $displayName, email: $email, emailVerified: $emailVerified, avatarFileId: $avatarFileId)';
}


}

/// @nodoc
abstract mixin class $LocalUserDirectoryResponseCopyWith<$Res>  {
  factory $LocalUserDirectoryResponseCopyWith(LocalUserDirectoryResponse value, $Res Function(LocalUserDirectoryResponse) _then) = _$LocalUserDirectoryResponseCopyWithImpl;
@useResult
$Res call({
 String userId, String login, String displayName, String? email, bool emailVerified, String? avatarFileId
});




}
/// @nodoc
class _$LocalUserDirectoryResponseCopyWithImpl<$Res>
    implements $LocalUserDirectoryResponseCopyWith<$Res> {
  _$LocalUserDirectoryResponseCopyWithImpl(this._self, this._then);

  final LocalUserDirectoryResponse _self;
  final $Res Function(LocalUserDirectoryResponse) _then;

/// Create a copy of LocalUserDirectoryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? login = null,Object? displayName = null,Object? email = freezed,Object? emailVerified = null,Object? avatarFileId = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,avatarFileId: freezed == avatarFileId ? _self.avatarFileId : avatarFileId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalUserDirectoryResponse].
extension LocalUserDirectoryResponsePatterns on LocalUserDirectoryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalUserDirectoryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalUserDirectoryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalUserDirectoryResponse value)  $default,){
final _that = this;
switch (_that) {
case _LocalUserDirectoryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalUserDirectoryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LocalUserDirectoryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String login,  String displayName,  String? email,  bool emailVerified,  String? avatarFileId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalUserDirectoryResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.email,_that.emailVerified,_that.avatarFileId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String login,  String displayName,  String? email,  bool emailVerified,  String? avatarFileId)  $default,) {final _that = this;
switch (_that) {
case _LocalUserDirectoryResponse():
return $default(_that.userId,_that.login,_that.displayName,_that.email,_that.emailVerified,_that.avatarFileId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String login,  String displayName,  String? email,  bool emailVerified,  String? avatarFileId)?  $default,) {final _that = this;
switch (_that) {
case _LocalUserDirectoryResponse() when $default != null:
return $default(_that.userId,_that.login,_that.displayName,_that.email,_that.emailVerified,_that.avatarFileId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocalUserDirectoryResponse implements LocalUserDirectoryResponse {
  const _LocalUserDirectoryResponse({required this.userId, required this.login, required this.displayName, this.email, required this.emailVerified, this.avatarFileId});
  factory _LocalUserDirectoryResponse.fromJson(Map<String, dynamic> json) => _$LocalUserDirectoryResponseFromJson(json);

@override final  String userId;
@override final  String login;
@override final  String displayName;
@override final  String? email;
@override final  bool emailVerified;
@override final  String? avatarFileId;

/// Create a copy of LocalUserDirectoryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalUserDirectoryResponseCopyWith<_LocalUserDirectoryResponse> get copyWith => __$LocalUserDirectoryResponseCopyWithImpl<_LocalUserDirectoryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalUserDirectoryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalUserDirectoryResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.avatarFileId, avatarFileId) || other.avatarFileId == avatarFileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,login,displayName,email,emailVerified,avatarFileId);

@override
String toString() {
  return 'LocalUserDirectoryResponse(userId: $userId, login: $login, displayName: $displayName, email: $email, emailVerified: $emailVerified, avatarFileId: $avatarFileId)';
}


}

/// @nodoc
abstract mixin class _$LocalUserDirectoryResponseCopyWith<$Res> implements $LocalUserDirectoryResponseCopyWith<$Res> {
  factory _$LocalUserDirectoryResponseCopyWith(_LocalUserDirectoryResponse value, $Res Function(_LocalUserDirectoryResponse) _then) = __$LocalUserDirectoryResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, String login, String displayName, String? email, bool emailVerified, String? avatarFileId
});




}
/// @nodoc
class __$LocalUserDirectoryResponseCopyWithImpl<$Res>
    implements _$LocalUserDirectoryResponseCopyWith<$Res> {
  __$LocalUserDirectoryResponseCopyWithImpl(this._self, this._then);

  final _LocalUserDirectoryResponse _self;
  final $Res Function(_LocalUserDirectoryResponse) _then;

/// Create a copy of LocalUserDirectoryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? login = null,Object? displayName = null,Object? email = freezed,Object? emailVerified = null,Object? avatarFileId = freezed,}) {
  return _then(_LocalUserDirectoryResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,avatarFileId: freezed == avatarFileId ? _self.avatarFileId : avatarFileId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WorkspaceInvitationResponse {

 String get id; String get workspaceId; String get userId; WorkspaceRole get role; WorkspaceInvitationStatus get status; String get login; String get displayName; String? get email; String? get message; DateTime get createdAtUtc; DateTime get expiresAtUtc; DateTime? get respondedAtUtc;
/// Create a copy of WorkspaceInvitationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceInvitationResponseCopyWith<WorkspaceInvitationResponse> get copyWith => _$WorkspaceInvitationResponseCopyWithImpl<WorkspaceInvitationResponse>(this as WorkspaceInvitationResponse, _$identity);

  /// Serializes this WorkspaceInvitationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceInvitationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.respondedAtUtc, respondedAtUtc) || other.respondedAtUtc == respondedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,userId,role,status,login,displayName,email,message,createdAtUtc,expiresAtUtc,respondedAtUtc);

@override
String toString() {
  return 'WorkspaceInvitationResponse(id: $id, workspaceId: $workspaceId, userId: $userId, role: $role, status: $status, login: $login, displayName: $displayName, email: $email, message: $message, createdAtUtc: $createdAtUtc, expiresAtUtc: $expiresAtUtc, respondedAtUtc: $respondedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WorkspaceInvitationResponseCopyWith<$Res>  {
  factory $WorkspaceInvitationResponseCopyWith(WorkspaceInvitationResponse value, $Res Function(WorkspaceInvitationResponse) _then) = _$WorkspaceInvitationResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String userId, WorkspaceRole role, WorkspaceInvitationStatus status, String login, String displayName, String? email, String? message, DateTime createdAtUtc, DateTime expiresAtUtc, DateTime? respondedAtUtc
});




}
/// @nodoc
class _$WorkspaceInvitationResponseCopyWithImpl<$Res>
    implements $WorkspaceInvitationResponseCopyWith<$Res> {
  _$WorkspaceInvitationResponseCopyWithImpl(this._self, this._then);

  final WorkspaceInvitationResponse _self;
  final $Res Function(WorkspaceInvitationResponse) _then;

/// Create a copy of WorkspaceInvitationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? userId = null,Object? role = null,Object? status = null,Object? login = null,Object? displayName = null,Object? email = freezed,Object? message = freezed,Object? createdAtUtc = null,Object? expiresAtUtc = null,Object? respondedAtUtc = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as WorkspaceRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkspaceInvitationStatus,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAtUtc: freezed == respondedAtUtc ? _self.respondedAtUtc : respondedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceInvitationResponse].
extension WorkspaceInvitationResponsePatterns on WorkspaceInvitationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceInvitationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceInvitationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceInvitationResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceInvitationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceInvitationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceInvitationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String userId,  WorkspaceRole role,  WorkspaceInvitationStatus status,  String login,  String displayName,  String? email,  String? message,  DateTime createdAtUtc,  DateTime expiresAtUtc,  DateTime? respondedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceInvitationResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.userId,_that.role,_that.status,_that.login,_that.displayName,_that.email,_that.message,_that.createdAtUtc,_that.expiresAtUtc,_that.respondedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String userId,  WorkspaceRole role,  WorkspaceInvitationStatus status,  String login,  String displayName,  String? email,  String? message,  DateTime createdAtUtc,  DateTime expiresAtUtc,  DateTime? respondedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceInvitationResponse():
return $default(_that.id,_that.workspaceId,_that.userId,_that.role,_that.status,_that.login,_that.displayName,_that.email,_that.message,_that.createdAtUtc,_that.expiresAtUtc,_that.respondedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String userId,  WorkspaceRole role,  WorkspaceInvitationStatus status,  String login,  String displayName,  String? email,  String? message,  DateTime createdAtUtc,  DateTime expiresAtUtc,  DateTime? respondedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceInvitationResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.userId,_that.role,_that.status,_that.login,_that.displayName,_that.email,_that.message,_that.createdAtUtc,_that.expiresAtUtc,_that.respondedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceInvitationResponse implements WorkspaceInvitationResponse {
  const _WorkspaceInvitationResponse({required this.id, required this.workspaceId, required this.userId, required this.role, required this.status, required this.login, required this.displayName, this.email, this.message, required this.createdAtUtc, required this.expiresAtUtc, this.respondedAtUtc});
  factory _WorkspaceInvitationResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceInvitationResponseFromJson(json);

@override final  String id;
@override final  String workspaceId;
@override final  String userId;
@override final  WorkspaceRole role;
@override final  WorkspaceInvitationStatus status;
@override final  String login;
@override final  String displayName;
@override final  String? email;
@override final  String? message;
@override final  DateTime createdAtUtc;
@override final  DateTime expiresAtUtc;
@override final  DateTime? respondedAtUtc;

/// Create a copy of WorkspaceInvitationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceInvitationResponseCopyWith<_WorkspaceInvitationResponse> get copyWith => __$WorkspaceInvitationResponseCopyWithImpl<_WorkspaceInvitationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceInvitationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceInvitationResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.login, login) || other.login == login)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc)&&(identical(other.respondedAtUtc, respondedAtUtc) || other.respondedAtUtc == respondedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,userId,role,status,login,displayName,email,message,createdAtUtc,expiresAtUtc,respondedAtUtc);

@override
String toString() {
  return 'WorkspaceInvitationResponse(id: $id, workspaceId: $workspaceId, userId: $userId, role: $role, status: $status, login: $login, displayName: $displayName, email: $email, message: $message, createdAtUtc: $createdAtUtc, expiresAtUtc: $expiresAtUtc, respondedAtUtc: $respondedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceInvitationResponseCopyWith<$Res> implements $WorkspaceInvitationResponseCopyWith<$Res> {
  factory _$WorkspaceInvitationResponseCopyWith(_WorkspaceInvitationResponse value, $Res Function(_WorkspaceInvitationResponse) _then) = __$WorkspaceInvitationResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String userId, WorkspaceRole role, WorkspaceInvitationStatus status, String login, String displayName, String? email, String? message, DateTime createdAtUtc, DateTime expiresAtUtc, DateTime? respondedAtUtc
});




}
/// @nodoc
class __$WorkspaceInvitationResponseCopyWithImpl<$Res>
    implements _$WorkspaceInvitationResponseCopyWith<$Res> {
  __$WorkspaceInvitationResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceInvitationResponse _self;
  final $Res Function(_WorkspaceInvitationResponse) _then;

/// Create a copy of WorkspaceInvitationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? userId = null,Object? role = null,Object? status = null,Object? login = null,Object? displayName = null,Object? email = freezed,Object? message = freezed,Object? createdAtUtc = null,Object? expiresAtUtc = null,Object? respondedAtUtc = freezed,}) {
  return _then(_WorkspaceInvitationResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as WorkspaceRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkspaceInvitationStatus,login: null == login ? _self.login : login // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAtUtc: freezed == respondedAtUtc ? _self.respondedAtUtc : respondedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
