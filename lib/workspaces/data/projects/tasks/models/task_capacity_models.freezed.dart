// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_capacity_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateWorkspaceCapacityPayload {

 int get defaultDailyCapacityMinutes; int get expectedVersion;
/// Create a copy of UpdateWorkspaceCapacityPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateWorkspaceCapacityPayloadCopyWith<UpdateWorkspaceCapacityPayload> get copyWith => _$UpdateWorkspaceCapacityPayloadCopyWithImpl<UpdateWorkspaceCapacityPayload>(this as UpdateWorkspaceCapacityPayload, _$identity);

  /// Serializes this UpdateWorkspaceCapacityPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateWorkspaceCapacityPayload&&(identical(other.defaultDailyCapacityMinutes, defaultDailyCapacityMinutes) || other.defaultDailyCapacityMinutes == defaultDailyCapacityMinutes)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultDailyCapacityMinutes,expectedVersion);

@override
String toString() {
  return 'UpdateWorkspaceCapacityPayload(defaultDailyCapacityMinutes: $defaultDailyCapacityMinutes, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateWorkspaceCapacityPayloadCopyWith<$Res>  {
  factory $UpdateWorkspaceCapacityPayloadCopyWith(UpdateWorkspaceCapacityPayload value, $Res Function(UpdateWorkspaceCapacityPayload) _then) = _$UpdateWorkspaceCapacityPayloadCopyWithImpl;
@useResult
$Res call({
 int defaultDailyCapacityMinutes, int expectedVersion
});




}
/// @nodoc
class _$UpdateWorkspaceCapacityPayloadCopyWithImpl<$Res>
    implements $UpdateWorkspaceCapacityPayloadCopyWith<$Res> {
  _$UpdateWorkspaceCapacityPayloadCopyWithImpl(this._self, this._then);

  final UpdateWorkspaceCapacityPayload _self;
  final $Res Function(UpdateWorkspaceCapacityPayload) _then;

/// Create a copy of UpdateWorkspaceCapacityPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultDailyCapacityMinutes = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
defaultDailyCapacityMinutes: null == defaultDailyCapacityMinutes ? _self.defaultDailyCapacityMinutes : defaultDailyCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateWorkspaceCapacityPayload].
extension UpdateWorkspaceCapacityPayloadPatterns on UpdateWorkspaceCapacityPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateWorkspaceCapacityPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateWorkspaceCapacityPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateWorkspaceCapacityPayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkspaceCapacityPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateWorkspaceCapacityPayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateWorkspaceCapacityPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int defaultDailyCapacityMinutes,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateWorkspaceCapacityPayload() when $default != null:
return $default(_that.defaultDailyCapacityMinutes,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int defaultDailyCapacityMinutes,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkspaceCapacityPayload():
return $default(_that.defaultDailyCapacityMinutes,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int defaultDailyCapacityMinutes,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateWorkspaceCapacityPayload() when $default != null:
return $default(_that.defaultDailyCapacityMinutes,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateWorkspaceCapacityPayload implements UpdateWorkspaceCapacityPayload {
  const _UpdateWorkspaceCapacityPayload({required this.defaultDailyCapacityMinutes, required this.expectedVersion});
  factory _UpdateWorkspaceCapacityPayload.fromJson(Map<String, dynamic> json) => _$UpdateWorkspaceCapacityPayloadFromJson(json);

@override final  int defaultDailyCapacityMinutes;
@override final  int expectedVersion;

/// Create a copy of UpdateWorkspaceCapacityPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWorkspaceCapacityPayloadCopyWith<_UpdateWorkspaceCapacityPayload> get copyWith => __$UpdateWorkspaceCapacityPayloadCopyWithImpl<_UpdateWorkspaceCapacityPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateWorkspaceCapacityPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWorkspaceCapacityPayload&&(identical(other.defaultDailyCapacityMinutes, defaultDailyCapacityMinutes) || other.defaultDailyCapacityMinutes == defaultDailyCapacityMinutes)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultDailyCapacityMinutes,expectedVersion);

@override
String toString() {
  return 'UpdateWorkspaceCapacityPayload(defaultDailyCapacityMinutes: $defaultDailyCapacityMinutes, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateWorkspaceCapacityPayloadCopyWith<$Res> implements $UpdateWorkspaceCapacityPayloadCopyWith<$Res> {
  factory _$UpdateWorkspaceCapacityPayloadCopyWith(_UpdateWorkspaceCapacityPayload value, $Res Function(_UpdateWorkspaceCapacityPayload) _then) = __$UpdateWorkspaceCapacityPayloadCopyWithImpl;
@override @useResult
$Res call({
 int defaultDailyCapacityMinutes, int expectedVersion
});




}
/// @nodoc
class __$UpdateWorkspaceCapacityPayloadCopyWithImpl<$Res>
    implements _$UpdateWorkspaceCapacityPayloadCopyWith<$Res> {
  __$UpdateWorkspaceCapacityPayloadCopyWithImpl(this._self, this._then);

  final _UpdateWorkspaceCapacityPayload _self;
  final $Res Function(_UpdateWorkspaceCapacityPayload) _then;

/// Create a copy of UpdateWorkspaceCapacityPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultDailyCapacityMinutes = null,Object? expectedVersion = null,}) {
  return _then(_UpdateWorkspaceCapacityPayload(
defaultDailyCapacityMinutes: null == defaultDailyCapacityMinutes ? _self.defaultDailyCapacityMinutes : defaultDailyCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WorkspaceCapacityResponse {

 String get workspaceId; int get defaultDailyCapacityMinutes; int get version; DateTime? get updatedAtUtc;
/// Create a copy of WorkspaceCapacityResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceCapacityResponseCopyWith<WorkspaceCapacityResponse> get copyWith => _$WorkspaceCapacityResponseCopyWithImpl<WorkspaceCapacityResponse>(this as WorkspaceCapacityResponse, _$identity);

  /// Serializes this WorkspaceCapacityResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceCapacityResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.defaultDailyCapacityMinutes, defaultDailyCapacityMinutes) || other.defaultDailyCapacityMinutes == defaultDailyCapacityMinutes)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,defaultDailyCapacityMinutes,version,updatedAtUtc);

@override
String toString() {
  return 'WorkspaceCapacityResponse(workspaceId: $workspaceId, defaultDailyCapacityMinutes: $defaultDailyCapacityMinutes, version: $version, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WorkspaceCapacityResponseCopyWith<$Res>  {
  factory $WorkspaceCapacityResponseCopyWith(WorkspaceCapacityResponse value, $Res Function(WorkspaceCapacityResponse) _then) = _$WorkspaceCapacityResponseCopyWithImpl;
@useResult
$Res call({
 String workspaceId, int defaultDailyCapacityMinutes, int version, DateTime? updatedAtUtc
});




}
/// @nodoc
class _$WorkspaceCapacityResponseCopyWithImpl<$Res>
    implements $WorkspaceCapacityResponseCopyWith<$Res> {
  _$WorkspaceCapacityResponseCopyWithImpl(this._self, this._then);

  final WorkspaceCapacityResponse _self;
  final $Res Function(WorkspaceCapacityResponse) _then;

/// Create a copy of WorkspaceCapacityResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workspaceId = null,Object? defaultDailyCapacityMinutes = null,Object? version = null,Object? updatedAtUtc = freezed,}) {
  return _then(_self.copyWith(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,defaultDailyCapacityMinutes: null == defaultDailyCapacityMinutes ? _self.defaultDailyCapacityMinutes : defaultDailyCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceCapacityResponse].
extension WorkspaceCapacityResponsePatterns on WorkspaceCapacityResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceCapacityResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceCapacityResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceCapacityResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceCapacityResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceCapacityResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceCapacityResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workspaceId,  int defaultDailyCapacityMinutes,  int version,  DateTime? updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceCapacityResponse() when $default != null:
return $default(_that.workspaceId,_that.defaultDailyCapacityMinutes,_that.version,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workspaceId,  int defaultDailyCapacityMinutes,  int version,  DateTime? updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceCapacityResponse():
return $default(_that.workspaceId,_that.defaultDailyCapacityMinutes,_that.version,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workspaceId,  int defaultDailyCapacityMinutes,  int version,  DateTime? updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceCapacityResponse() when $default != null:
return $default(_that.workspaceId,_that.defaultDailyCapacityMinutes,_that.version,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkspaceCapacityResponse implements WorkspaceCapacityResponse {
  const _WorkspaceCapacityResponse({required this.workspaceId, required this.defaultDailyCapacityMinutes, required this.version, this.updatedAtUtc});
  factory _WorkspaceCapacityResponse.fromJson(Map<String, dynamic> json) => _$WorkspaceCapacityResponseFromJson(json);

@override final  String workspaceId;
@override final  int defaultDailyCapacityMinutes;
@override final  int version;
@override final  DateTime? updatedAtUtc;

/// Create a copy of WorkspaceCapacityResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceCapacityResponseCopyWith<_WorkspaceCapacityResponse> get copyWith => __$WorkspaceCapacityResponseCopyWithImpl<_WorkspaceCapacityResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceCapacityResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceCapacityResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.defaultDailyCapacityMinutes, defaultDailyCapacityMinutes) || other.defaultDailyCapacityMinutes == defaultDailyCapacityMinutes)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,defaultDailyCapacityMinutes,version,updatedAtUtc);

@override
String toString() {
  return 'WorkspaceCapacityResponse(workspaceId: $workspaceId, defaultDailyCapacityMinutes: $defaultDailyCapacityMinutes, version: $version, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceCapacityResponseCopyWith<$Res> implements $WorkspaceCapacityResponseCopyWith<$Res> {
  factory _$WorkspaceCapacityResponseCopyWith(_WorkspaceCapacityResponse value, $Res Function(_WorkspaceCapacityResponse) _then) = __$WorkspaceCapacityResponseCopyWithImpl;
@override @useResult
$Res call({
 String workspaceId, int defaultDailyCapacityMinutes, int version, DateTime? updatedAtUtc
});




}
/// @nodoc
class __$WorkspaceCapacityResponseCopyWithImpl<$Res>
    implements _$WorkspaceCapacityResponseCopyWith<$Res> {
  __$WorkspaceCapacityResponseCopyWithImpl(this._self, this._then);

  final _WorkspaceCapacityResponse _self;
  final $Res Function(_WorkspaceCapacityResponse) _then;

/// Create a copy of WorkspaceCapacityResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workspaceId = null,Object? defaultDailyCapacityMinutes = null,Object? version = null,Object? updatedAtUtc = freezed,}) {
  return _then(_WorkspaceCapacityResponse(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,defaultDailyCapacityMinutes: null == defaultDailyCapacityMinutes ? _self.defaultDailyCapacityMinutes : defaultDailyCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CreateUserCapacityOverridePayload {

 String get coreUserId; DateTime get startDate; DateTime get endDate; int get availableMinutesPerDay; String? get reason;
/// Create a copy of CreateUserCapacityOverridePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateUserCapacityOverridePayloadCopyWith<CreateUserCapacityOverridePayload> get copyWith => _$CreateUserCapacityOverridePayloadCopyWithImpl<CreateUserCapacityOverridePayload>(this as CreateUserCapacityOverridePayload, _$identity);

  /// Serializes this CreateUserCapacityOverridePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateUserCapacityOverridePayload&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.availableMinutesPerDay, availableMinutesPerDay) || other.availableMinutesPerDay == availableMinutesPerDay)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,startDate,endDate,availableMinutesPerDay,reason);

@override
String toString() {
  return 'CreateUserCapacityOverridePayload(coreUserId: $coreUserId, startDate: $startDate, endDate: $endDate, availableMinutesPerDay: $availableMinutesPerDay, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CreateUserCapacityOverridePayloadCopyWith<$Res>  {
  factory $CreateUserCapacityOverridePayloadCopyWith(CreateUserCapacityOverridePayload value, $Res Function(CreateUserCapacityOverridePayload) _then) = _$CreateUserCapacityOverridePayloadCopyWithImpl;
@useResult
$Res call({
 String coreUserId, DateTime startDate, DateTime endDate, int availableMinutesPerDay, String? reason
});




}
/// @nodoc
class _$CreateUserCapacityOverridePayloadCopyWithImpl<$Res>
    implements $CreateUserCapacityOverridePayloadCopyWith<$Res> {
  _$CreateUserCapacityOverridePayloadCopyWithImpl(this._self, this._then);

  final CreateUserCapacityOverridePayload _self;
  final $Res Function(CreateUserCapacityOverridePayload) _then;

/// Create a copy of CreateUserCapacityOverridePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coreUserId = null,Object? startDate = null,Object? endDate = null,Object? availableMinutesPerDay = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,availableMinutesPerDay: null == availableMinutesPerDay ? _self.availableMinutesPerDay : availableMinutesPerDay // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateUserCapacityOverridePayload].
extension CreateUserCapacityOverridePayloadPatterns on CreateUserCapacityOverridePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateUserCapacityOverridePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateUserCapacityOverridePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateUserCapacityOverridePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateUserCapacityOverridePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateUserCapacityOverridePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateUserCapacityOverridePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coreUserId,  DateTime startDate,  DateTime endDate,  int availableMinutesPerDay,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateUserCapacityOverridePayload() when $default != null:
return $default(_that.coreUserId,_that.startDate,_that.endDate,_that.availableMinutesPerDay,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coreUserId,  DateTime startDate,  DateTime endDate,  int availableMinutesPerDay,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _CreateUserCapacityOverridePayload():
return $default(_that.coreUserId,_that.startDate,_that.endDate,_that.availableMinutesPerDay,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coreUserId,  DateTime startDate,  DateTime endDate,  int availableMinutesPerDay,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _CreateUserCapacityOverridePayload() when $default != null:
return $default(_that.coreUserId,_that.startDate,_that.endDate,_that.availableMinutesPerDay,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateUserCapacityOverridePayload implements CreateUserCapacityOverridePayload {
  const _CreateUserCapacityOverridePayload({required this.coreUserId, required this.startDate, required this.endDate, required this.availableMinutesPerDay, this.reason});
  factory _CreateUserCapacityOverridePayload.fromJson(Map<String, dynamic> json) => _$CreateUserCapacityOverridePayloadFromJson(json);

@override final  String coreUserId;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  int availableMinutesPerDay;
@override final  String? reason;

/// Create a copy of CreateUserCapacityOverridePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateUserCapacityOverridePayloadCopyWith<_CreateUserCapacityOverridePayload> get copyWith => __$CreateUserCapacityOverridePayloadCopyWithImpl<_CreateUserCapacityOverridePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateUserCapacityOverridePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateUserCapacityOverridePayload&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.availableMinutesPerDay, availableMinutesPerDay) || other.availableMinutesPerDay == availableMinutesPerDay)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,startDate,endDate,availableMinutesPerDay,reason);

@override
String toString() {
  return 'CreateUserCapacityOverridePayload(coreUserId: $coreUserId, startDate: $startDate, endDate: $endDate, availableMinutesPerDay: $availableMinutesPerDay, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CreateUserCapacityOverridePayloadCopyWith<$Res> implements $CreateUserCapacityOverridePayloadCopyWith<$Res> {
  factory _$CreateUserCapacityOverridePayloadCopyWith(_CreateUserCapacityOverridePayload value, $Res Function(_CreateUserCapacityOverridePayload) _then) = __$CreateUserCapacityOverridePayloadCopyWithImpl;
@override @useResult
$Res call({
 String coreUserId, DateTime startDate, DateTime endDate, int availableMinutesPerDay, String? reason
});




}
/// @nodoc
class __$CreateUserCapacityOverridePayloadCopyWithImpl<$Res>
    implements _$CreateUserCapacityOverridePayloadCopyWith<$Res> {
  __$CreateUserCapacityOverridePayloadCopyWithImpl(this._self, this._then);

  final _CreateUserCapacityOverridePayload _self;
  final $Res Function(_CreateUserCapacityOverridePayload) _then;

/// Create a copy of CreateUserCapacityOverridePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coreUserId = null,Object? startDate = null,Object? endDate = null,Object? availableMinutesPerDay = null,Object? reason = freezed,}) {
  return _then(_CreateUserCapacityOverridePayload(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,availableMinutesPerDay: null == availableMinutesPerDay ? _self.availableMinutesPerDay : availableMinutesPerDay // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateUserCapacityOverridePayload {

 DateTime get startDate; DateTime get endDate; int get availableMinutesPerDay; String? get reason; int get expectedVersion;
/// Create a copy of UpdateUserCapacityOverridePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateUserCapacityOverridePayloadCopyWith<UpdateUserCapacityOverridePayload> get copyWith => _$UpdateUserCapacityOverridePayloadCopyWithImpl<UpdateUserCapacityOverridePayload>(this as UpdateUserCapacityOverridePayload, _$identity);

  /// Serializes this UpdateUserCapacityOverridePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUserCapacityOverridePayload&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.availableMinutesPerDay, availableMinutesPerDay) || other.availableMinutesPerDay == availableMinutesPerDay)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,availableMinutesPerDay,reason,expectedVersion);

@override
String toString() {
  return 'UpdateUserCapacityOverridePayload(startDate: $startDate, endDate: $endDate, availableMinutesPerDay: $availableMinutesPerDay, reason: $reason, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateUserCapacityOverridePayloadCopyWith<$Res>  {
  factory $UpdateUserCapacityOverridePayloadCopyWith(UpdateUserCapacityOverridePayload value, $Res Function(UpdateUserCapacityOverridePayload) _then) = _$UpdateUserCapacityOverridePayloadCopyWithImpl;
@useResult
$Res call({
 DateTime startDate, DateTime endDate, int availableMinutesPerDay, String? reason, int expectedVersion
});




}
/// @nodoc
class _$UpdateUserCapacityOverridePayloadCopyWithImpl<$Res>
    implements $UpdateUserCapacityOverridePayloadCopyWith<$Res> {
  _$UpdateUserCapacityOverridePayloadCopyWithImpl(this._self, this._then);

  final UpdateUserCapacityOverridePayload _self;
  final $Res Function(UpdateUserCapacityOverridePayload) _then;

/// Create a copy of UpdateUserCapacityOverridePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? endDate = null,Object? availableMinutesPerDay = null,Object? reason = freezed,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,availableMinutesPerDay: null == availableMinutesPerDay ? _self.availableMinutesPerDay : availableMinutesPerDay // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateUserCapacityOverridePayload].
extension UpdateUserCapacityOverridePayloadPatterns on UpdateUserCapacityOverridePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateUserCapacityOverridePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateUserCapacityOverridePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateUserCapacityOverridePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateUserCapacityOverridePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateUserCapacityOverridePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateUserCapacityOverridePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime startDate,  DateTime endDate,  int availableMinutesPerDay,  String? reason,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateUserCapacityOverridePayload() when $default != null:
return $default(_that.startDate,_that.endDate,_that.availableMinutesPerDay,_that.reason,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime startDate,  DateTime endDate,  int availableMinutesPerDay,  String? reason,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateUserCapacityOverridePayload():
return $default(_that.startDate,_that.endDate,_that.availableMinutesPerDay,_that.reason,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime startDate,  DateTime endDate,  int availableMinutesPerDay,  String? reason,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateUserCapacityOverridePayload() when $default != null:
return $default(_that.startDate,_that.endDate,_that.availableMinutesPerDay,_that.reason,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateUserCapacityOverridePayload implements UpdateUserCapacityOverridePayload {
  const _UpdateUserCapacityOverridePayload({required this.startDate, required this.endDate, required this.availableMinutesPerDay, this.reason, required this.expectedVersion});
  factory _UpdateUserCapacityOverridePayload.fromJson(Map<String, dynamic> json) => _$UpdateUserCapacityOverridePayloadFromJson(json);

@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  int availableMinutesPerDay;
@override final  String? reason;
@override final  int expectedVersion;

/// Create a copy of UpdateUserCapacityOverridePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateUserCapacityOverridePayloadCopyWith<_UpdateUserCapacityOverridePayload> get copyWith => __$UpdateUserCapacityOverridePayloadCopyWithImpl<_UpdateUserCapacityOverridePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateUserCapacityOverridePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateUserCapacityOverridePayload&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.availableMinutesPerDay, availableMinutesPerDay) || other.availableMinutesPerDay == availableMinutesPerDay)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,availableMinutesPerDay,reason,expectedVersion);

@override
String toString() {
  return 'UpdateUserCapacityOverridePayload(startDate: $startDate, endDate: $endDate, availableMinutesPerDay: $availableMinutesPerDay, reason: $reason, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateUserCapacityOverridePayloadCopyWith<$Res> implements $UpdateUserCapacityOverridePayloadCopyWith<$Res> {
  factory _$UpdateUserCapacityOverridePayloadCopyWith(_UpdateUserCapacityOverridePayload value, $Res Function(_UpdateUserCapacityOverridePayload) _then) = __$UpdateUserCapacityOverridePayloadCopyWithImpl;
@override @useResult
$Res call({
 DateTime startDate, DateTime endDate, int availableMinutesPerDay, String? reason, int expectedVersion
});




}
/// @nodoc
class __$UpdateUserCapacityOverridePayloadCopyWithImpl<$Res>
    implements _$UpdateUserCapacityOverridePayloadCopyWith<$Res> {
  __$UpdateUserCapacityOverridePayloadCopyWithImpl(this._self, this._then);

  final _UpdateUserCapacityOverridePayload _self;
  final $Res Function(_UpdateUserCapacityOverridePayload) _then;

/// Create a copy of UpdateUserCapacityOverridePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,Object? availableMinutesPerDay = null,Object? reason = freezed,Object? expectedVersion = null,}) {
  return _then(_UpdateUserCapacityOverridePayload(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,availableMinutesPerDay: null == availableMinutesPerDay ? _self.availableMinutesPerDay : availableMinutesPerDay // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UserCapacityOverrideResponse {

 String get id; String get workspaceId; String get projectId; String get coreUserId; DateTime get startDate; DateTime get endDate; int get availableMinutesPerDay; String? get reason; int get version; DateTime get updatedAtUtc;
/// Create a copy of UserCapacityOverrideResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCapacityOverrideResponseCopyWith<UserCapacityOverrideResponse> get copyWith => _$UserCapacityOverrideResponseCopyWithImpl<UserCapacityOverrideResponse>(this as UserCapacityOverrideResponse, _$identity);

  /// Serializes this UserCapacityOverrideResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserCapacityOverrideResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.availableMinutesPerDay, availableMinutesPerDay) || other.availableMinutesPerDay == availableMinutesPerDay)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,projectId,coreUserId,startDate,endDate,availableMinutesPerDay,reason,version,updatedAtUtc);

@override
String toString() {
  return 'UserCapacityOverrideResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, coreUserId: $coreUserId, startDate: $startDate, endDate: $endDate, availableMinutesPerDay: $availableMinutesPerDay, reason: $reason, version: $version, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $UserCapacityOverrideResponseCopyWith<$Res>  {
  factory $UserCapacityOverrideResponseCopyWith(UserCapacityOverrideResponse value, $Res Function(UserCapacityOverrideResponse) _then) = _$UserCapacityOverrideResponseCopyWithImpl;
@useResult
$Res call({
 String id, String workspaceId, String projectId, String coreUserId, DateTime startDate, DateTime endDate, int availableMinutesPerDay, String? reason, int version, DateTime updatedAtUtc
});




}
/// @nodoc
class _$UserCapacityOverrideResponseCopyWithImpl<$Res>
    implements $UserCapacityOverrideResponseCopyWith<$Res> {
  _$UserCapacityOverrideResponseCopyWithImpl(this._self, this._then);

  final UserCapacityOverrideResponse _self;
  final $Res Function(UserCapacityOverrideResponse) _then;

/// Create a copy of UserCapacityOverrideResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = null,Object? coreUserId = null,Object? startDate = null,Object? endDate = null,Object? availableMinutesPerDay = null,Object? reason = freezed,Object? version = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,availableMinutesPerDay: null == availableMinutesPerDay ? _self.availableMinutesPerDay : availableMinutesPerDay // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserCapacityOverrideResponse].
extension UserCapacityOverrideResponsePatterns on UserCapacityOverrideResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserCapacityOverrideResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserCapacityOverrideResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserCapacityOverrideResponse value)  $default,){
final _that = this;
switch (_that) {
case _UserCapacityOverrideResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserCapacityOverrideResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UserCapacityOverrideResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String projectId,  String coreUserId,  DateTime startDate,  DateTime endDate,  int availableMinutesPerDay,  String? reason,  int version,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserCapacityOverrideResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.coreUserId,_that.startDate,_that.endDate,_that.availableMinutesPerDay,_that.reason,_that.version,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String workspaceId,  String projectId,  String coreUserId,  DateTime startDate,  DateTime endDate,  int availableMinutesPerDay,  String? reason,  int version,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _UserCapacityOverrideResponse():
return $default(_that.id,_that.workspaceId,_that.projectId,_that.coreUserId,_that.startDate,_that.endDate,_that.availableMinutesPerDay,_that.reason,_that.version,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String workspaceId,  String projectId,  String coreUserId,  DateTime startDate,  DateTime endDate,  int availableMinutesPerDay,  String? reason,  int version,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _UserCapacityOverrideResponse() when $default != null:
return $default(_that.id,_that.workspaceId,_that.projectId,_that.coreUserId,_that.startDate,_that.endDate,_that.availableMinutesPerDay,_that.reason,_that.version,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserCapacityOverrideResponse implements UserCapacityOverrideResponse {
  const _UserCapacityOverrideResponse({required this.id, required this.workspaceId, required this.projectId, required this.coreUserId, required this.startDate, required this.endDate, required this.availableMinutesPerDay, this.reason, required this.version, required this.updatedAtUtc});
  factory _UserCapacityOverrideResponse.fromJson(Map<String, dynamic> json) => _$UserCapacityOverrideResponseFromJson(json);

@override final  String id;
@override final  String workspaceId;
@override final  String projectId;
@override final  String coreUserId;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  int availableMinutesPerDay;
@override final  String? reason;
@override final  int version;
@override final  DateTime updatedAtUtc;

/// Create a copy of UserCapacityOverrideResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCapacityOverrideResponseCopyWith<_UserCapacityOverrideResponse> get copyWith => __$UserCapacityOverrideResponseCopyWithImpl<_UserCapacityOverrideResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserCapacityOverrideResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserCapacityOverrideResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.availableMinutesPerDay, availableMinutesPerDay) || other.availableMinutesPerDay == availableMinutesPerDay)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,workspaceId,projectId,coreUserId,startDate,endDate,availableMinutesPerDay,reason,version,updatedAtUtc);

@override
String toString() {
  return 'UserCapacityOverrideResponse(id: $id, workspaceId: $workspaceId, projectId: $projectId, coreUserId: $coreUserId, startDate: $startDate, endDate: $endDate, availableMinutesPerDay: $availableMinutesPerDay, reason: $reason, version: $version, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$UserCapacityOverrideResponseCopyWith<$Res> implements $UserCapacityOverrideResponseCopyWith<$Res> {
  factory _$UserCapacityOverrideResponseCopyWith(_UserCapacityOverrideResponse value, $Res Function(_UserCapacityOverrideResponse) _then) = __$UserCapacityOverrideResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String workspaceId, String projectId, String coreUserId, DateTime startDate, DateTime endDate, int availableMinutesPerDay, String? reason, int version, DateTime updatedAtUtc
});




}
/// @nodoc
class __$UserCapacityOverrideResponseCopyWithImpl<$Res>
    implements _$UserCapacityOverrideResponseCopyWith<$Res> {
  __$UserCapacityOverrideResponseCopyWithImpl(this._self, this._then);

  final _UserCapacityOverrideResponse _self;
  final $Res Function(_UserCapacityOverrideResponse) _then;

/// Create a copy of UserCapacityOverrideResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? workspaceId = null,Object? projectId = null,Object? coreUserId = null,Object? startDate = null,Object? endDate = null,Object? availableMinutesPerDay = null,Object? reason = freezed,Object? version = null,Object? updatedAtUtc = null,}) {
  return _then(_UserCapacityOverrideResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,availableMinutesPerDay: null == availableMinutesPerDay ? _self.availableMinutesPerDay : availableMinutesPerDay // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskWorkloadUserResponse {

 String get coreUserId; int get assignedTaskCount; int get estimatedMinutes; int get loggedMinutes; int get unplannedEstimatedMinutes; int get availableCapacityMinutes; int get remainingCapacityMinutes; bool get isOverCapacity; CapacitySource get capacitySource;
/// Create a copy of TaskWorkloadUserResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskWorkloadUserResponseCopyWith<TaskWorkloadUserResponse> get copyWith => _$TaskWorkloadUserResponseCopyWithImpl<TaskWorkloadUserResponse>(this as TaskWorkloadUserResponse, _$identity);

  /// Serializes this TaskWorkloadUserResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskWorkloadUserResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.assignedTaskCount, assignedTaskCount) || other.assignedTaskCount == assignedTaskCount)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.loggedMinutes, loggedMinutes) || other.loggedMinutes == loggedMinutes)&&(identical(other.unplannedEstimatedMinutes, unplannedEstimatedMinutes) || other.unplannedEstimatedMinutes == unplannedEstimatedMinutes)&&(identical(other.availableCapacityMinutes, availableCapacityMinutes) || other.availableCapacityMinutes == availableCapacityMinutes)&&(identical(other.remainingCapacityMinutes, remainingCapacityMinutes) || other.remainingCapacityMinutes == remainingCapacityMinutes)&&(identical(other.isOverCapacity, isOverCapacity) || other.isOverCapacity == isOverCapacity)&&(identical(other.capacitySource, capacitySource) || other.capacitySource == capacitySource));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,assignedTaskCount,estimatedMinutes,loggedMinutes,unplannedEstimatedMinutes,availableCapacityMinutes,remainingCapacityMinutes,isOverCapacity,capacitySource);

@override
String toString() {
  return 'TaskWorkloadUserResponse(coreUserId: $coreUserId, assignedTaskCount: $assignedTaskCount, estimatedMinutes: $estimatedMinutes, loggedMinutes: $loggedMinutes, unplannedEstimatedMinutes: $unplannedEstimatedMinutes, availableCapacityMinutes: $availableCapacityMinutes, remainingCapacityMinutes: $remainingCapacityMinutes, isOverCapacity: $isOverCapacity, capacitySource: $capacitySource)';
}


}

/// @nodoc
abstract mixin class $TaskWorkloadUserResponseCopyWith<$Res>  {
  factory $TaskWorkloadUserResponseCopyWith(TaskWorkloadUserResponse value, $Res Function(TaskWorkloadUserResponse) _then) = _$TaskWorkloadUserResponseCopyWithImpl;
@useResult
$Res call({
 String coreUserId, int assignedTaskCount, int estimatedMinutes, int loggedMinutes, int unplannedEstimatedMinutes, int availableCapacityMinutes, int remainingCapacityMinutes, bool isOverCapacity, CapacitySource capacitySource
});




}
/// @nodoc
class _$TaskWorkloadUserResponseCopyWithImpl<$Res>
    implements $TaskWorkloadUserResponseCopyWith<$Res> {
  _$TaskWorkloadUserResponseCopyWithImpl(this._self, this._then);

  final TaskWorkloadUserResponse _self;
  final $Res Function(TaskWorkloadUserResponse) _then;

/// Create a copy of TaskWorkloadUserResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coreUserId = null,Object? assignedTaskCount = null,Object? estimatedMinutes = null,Object? loggedMinutes = null,Object? unplannedEstimatedMinutes = null,Object? availableCapacityMinutes = null,Object? remainingCapacityMinutes = null,Object? isOverCapacity = null,Object? capacitySource = null,}) {
  return _then(_self.copyWith(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,assignedTaskCount: null == assignedTaskCount ? _self.assignedTaskCount : assignedTaskCount // ignore: cast_nullable_to_non_nullable
as int,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,loggedMinutes: null == loggedMinutes ? _self.loggedMinutes : loggedMinutes // ignore: cast_nullable_to_non_nullable
as int,unplannedEstimatedMinutes: null == unplannedEstimatedMinutes ? _self.unplannedEstimatedMinutes : unplannedEstimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,availableCapacityMinutes: null == availableCapacityMinutes ? _self.availableCapacityMinutes : availableCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int,remainingCapacityMinutes: null == remainingCapacityMinutes ? _self.remainingCapacityMinutes : remainingCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int,isOverCapacity: null == isOverCapacity ? _self.isOverCapacity : isOverCapacity // ignore: cast_nullable_to_non_nullable
as bool,capacitySource: null == capacitySource ? _self.capacitySource : capacitySource // ignore: cast_nullable_to_non_nullable
as CapacitySource,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskWorkloadUserResponse].
extension TaskWorkloadUserResponsePatterns on TaskWorkloadUserResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskWorkloadUserResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskWorkloadUserResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskWorkloadUserResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskWorkloadUserResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskWorkloadUserResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskWorkloadUserResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String coreUserId,  int assignedTaskCount,  int estimatedMinutes,  int loggedMinutes,  int unplannedEstimatedMinutes,  int availableCapacityMinutes,  int remainingCapacityMinutes,  bool isOverCapacity,  CapacitySource capacitySource)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskWorkloadUserResponse() when $default != null:
return $default(_that.coreUserId,_that.assignedTaskCount,_that.estimatedMinutes,_that.loggedMinutes,_that.unplannedEstimatedMinutes,_that.availableCapacityMinutes,_that.remainingCapacityMinutes,_that.isOverCapacity,_that.capacitySource);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String coreUserId,  int assignedTaskCount,  int estimatedMinutes,  int loggedMinutes,  int unplannedEstimatedMinutes,  int availableCapacityMinutes,  int remainingCapacityMinutes,  bool isOverCapacity,  CapacitySource capacitySource)  $default,) {final _that = this;
switch (_that) {
case _TaskWorkloadUserResponse():
return $default(_that.coreUserId,_that.assignedTaskCount,_that.estimatedMinutes,_that.loggedMinutes,_that.unplannedEstimatedMinutes,_that.availableCapacityMinutes,_that.remainingCapacityMinutes,_that.isOverCapacity,_that.capacitySource);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String coreUserId,  int assignedTaskCount,  int estimatedMinutes,  int loggedMinutes,  int unplannedEstimatedMinutes,  int availableCapacityMinutes,  int remainingCapacityMinutes,  bool isOverCapacity,  CapacitySource capacitySource)?  $default,) {final _that = this;
switch (_that) {
case _TaskWorkloadUserResponse() when $default != null:
return $default(_that.coreUserId,_that.assignedTaskCount,_that.estimatedMinutes,_that.loggedMinutes,_that.unplannedEstimatedMinutes,_that.availableCapacityMinutes,_that.remainingCapacityMinutes,_that.isOverCapacity,_that.capacitySource);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskWorkloadUserResponse implements TaskWorkloadUserResponse {
  const _TaskWorkloadUserResponse({required this.coreUserId, required this.assignedTaskCount, required this.estimatedMinutes, required this.loggedMinutes, this.unplannedEstimatedMinutes = 0, this.availableCapacityMinutes = 0, this.remainingCapacityMinutes = 0, this.isOverCapacity = false, this.capacitySource = CapacitySource.workspaceDefault});
  factory _TaskWorkloadUserResponse.fromJson(Map<String, dynamic> json) => _$TaskWorkloadUserResponseFromJson(json);

@override final  String coreUserId;
@override final  int assignedTaskCount;
@override final  int estimatedMinutes;
@override final  int loggedMinutes;
@override@JsonKey() final  int unplannedEstimatedMinutes;
@override@JsonKey() final  int availableCapacityMinutes;
@override@JsonKey() final  int remainingCapacityMinutes;
@override@JsonKey() final  bool isOverCapacity;
@override@JsonKey() final  CapacitySource capacitySource;

/// Create a copy of TaskWorkloadUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskWorkloadUserResponseCopyWith<_TaskWorkloadUserResponse> get copyWith => __$TaskWorkloadUserResponseCopyWithImpl<_TaskWorkloadUserResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskWorkloadUserResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskWorkloadUserResponse&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.assignedTaskCount, assignedTaskCount) || other.assignedTaskCount == assignedTaskCount)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.loggedMinutes, loggedMinutes) || other.loggedMinutes == loggedMinutes)&&(identical(other.unplannedEstimatedMinutes, unplannedEstimatedMinutes) || other.unplannedEstimatedMinutes == unplannedEstimatedMinutes)&&(identical(other.availableCapacityMinutes, availableCapacityMinutes) || other.availableCapacityMinutes == availableCapacityMinutes)&&(identical(other.remainingCapacityMinutes, remainingCapacityMinutes) || other.remainingCapacityMinutes == remainingCapacityMinutes)&&(identical(other.isOverCapacity, isOverCapacity) || other.isOverCapacity == isOverCapacity)&&(identical(other.capacitySource, capacitySource) || other.capacitySource == capacitySource));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coreUserId,assignedTaskCount,estimatedMinutes,loggedMinutes,unplannedEstimatedMinutes,availableCapacityMinutes,remainingCapacityMinutes,isOverCapacity,capacitySource);

@override
String toString() {
  return 'TaskWorkloadUserResponse(coreUserId: $coreUserId, assignedTaskCount: $assignedTaskCount, estimatedMinutes: $estimatedMinutes, loggedMinutes: $loggedMinutes, unplannedEstimatedMinutes: $unplannedEstimatedMinutes, availableCapacityMinutes: $availableCapacityMinutes, remainingCapacityMinutes: $remainingCapacityMinutes, isOverCapacity: $isOverCapacity, capacitySource: $capacitySource)';
}


}

/// @nodoc
abstract mixin class _$TaskWorkloadUserResponseCopyWith<$Res> implements $TaskWorkloadUserResponseCopyWith<$Res> {
  factory _$TaskWorkloadUserResponseCopyWith(_TaskWorkloadUserResponse value, $Res Function(_TaskWorkloadUserResponse) _then) = __$TaskWorkloadUserResponseCopyWithImpl;
@override @useResult
$Res call({
 String coreUserId, int assignedTaskCount, int estimatedMinutes, int loggedMinutes, int unplannedEstimatedMinutes, int availableCapacityMinutes, int remainingCapacityMinutes, bool isOverCapacity, CapacitySource capacitySource
});




}
/// @nodoc
class __$TaskWorkloadUserResponseCopyWithImpl<$Res>
    implements _$TaskWorkloadUserResponseCopyWith<$Res> {
  __$TaskWorkloadUserResponseCopyWithImpl(this._self, this._then);

  final _TaskWorkloadUserResponse _self;
  final $Res Function(_TaskWorkloadUserResponse) _then;

/// Create a copy of TaskWorkloadUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coreUserId = null,Object? assignedTaskCount = null,Object? estimatedMinutes = null,Object? loggedMinutes = null,Object? unplannedEstimatedMinutes = null,Object? availableCapacityMinutes = null,Object? remainingCapacityMinutes = null,Object? isOverCapacity = null,Object? capacitySource = null,}) {
  return _then(_TaskWorkloadUserResponse(
coreUserId: null == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String,assignedTaskCount: null == assignedTaskCount ? _self.assignedTaskCount : assignedTaskCount // ignore: cast_nullable_to_non_nullable
as int,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,loggedMinutes: null == loggedMinutes ? _self.loggedMinutes : loggedMinutes // ignore: cast_nullable_to_non_nullable
as int,unplannedEstimatedMinutes: null == unplannedEstimatedMinutes ? _self.unplannedEstimatedMinutes : unplannedEstimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,availableCapacityMinutes: null == availableCapacityMinutes ? _self.availableCapacityMinutes : availableCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int,remainingCapacityMinutes: null == remainingCapacityMinutes ? _self.remainingCapacityMinutes : remainingCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int,isOverCapacity: null == isOverCapacity ? _self.isOverCapacity : isOverCapacity // ignore: cast_nullable_to_non_nullable
as bool,capacitySource: null == capacitySource ? _self.capacitySource : capacitySource // ignore: cast_nullable_to_non_nullable
as CapacitySource,
  ));
}


}


/// @nodoc
mixin _$TaskWorkloadResponse {

 String get projectId; List<TaskWorkloadUserResponse> get users; DateTime? get fromDate; DateTime? get toDate;
/// Create a copy of TaskWorkloadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskWorkloadResponseCopyWith<TaskWorkloadResponse> get copyWith => _$TaskWorkloadResponseCopyWithImpl<TaskWorkloadResponse>(this as TaskWorkloadResponse, _$identity);

  /// Serializes this TaskWorkloadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskWorkloadResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,const DeepCollectionEquality().hash(users),fromDate,toDate);

@override
String toString() {
  return 'TaskWorkloadResponse(projectId: $projectId, users: $users, fromDate: $fromDate, toDate: $toDate)';
}


}

/// @nodoc
abstract mixin class $TaskWorkloadResponseCopyWith<$Res>  {
  factory $TaskWorkloadResponseCopyWith(TaskWorkloadResponse value, $Res Function(TaskWorkloadResponse) _then) = _$TaskWorkloadResponseCopyWithImpl;
@useResult
$Res call({
 String projectId, List<TaskWorkloadUserResponse> users, DateTime? fromDate, DateTime? toDate
});




}
/// @nodoc
class _$TaskWorkloadResponseCopyWithImpl<$Res>
    implements $TaskWorkloadResponseCopyWith<$Res> {
  _$TaskWorkloadResponseCopyWithImpl(this._self, this._then);

  final TaskWorkloadResponse _self;
  final $Res Function(TaskWorkloadResponse) _then;

/// Create a copy of TaskWorkloadResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? users = null,Object? fromDate = freezed,Object? toDate = freezed,}) {
  return _then(_self.copyWith(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<TaskWorkloadUserResponse>,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskWorkloadResponse].
extension TaskWorkloadResponsePatterns on TaskWorkloadResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskWorkloadResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskWorkloadResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskWorkloadResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskWorkloadResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskWorkloadResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskWorkloadResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  List<TaskWorkloadUserResponse> users,  DateTime? fromDate,  DateTime? toDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskWorkloadResponse() when $default != null:
return $default(_that.projectId,_that.users,_that.fromDate,_that.toDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  List<TaskWorkloadUserResponse> users,  DateTime? fromDate,  DateTime? toDate)  $default,) {final _that = this;
switch (_that) {
case _TaskWorkloadResponse():
return $default(_that.projectId,_that.users,_that.fromDate,_that.toDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  List<TaskWorkloadUserResponse> users,  DateTime? fromDate,  DateTime? toDate)?  $default,) {final _that = this;
switch (_that) {
case _TaskWorkloadResponse() when $default != null:
return $default(_that.projectId,_that.users,_that.fromDate,_that.toDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskWorkloadResponse implements TaskWorkloadResponse {
  const _TaskWorkloadResponse({required this.projectId, required this.users, this.fromDate, this.toDate});
  factory _TaskWorkloadResponse.fromJson(Map<String, dynamic> json) => _$TaskWorkloadResponseFromJson(json);

@override final  String projectId;
@override final  List<TaskWorkloadUserResponse> users;
@override final  DateTime? fromDate;
@override final  DateTime? toDate;

/// Create a copy of TaskWorkloadResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskWorkloadResponseCopyWith<_TaskWorkloadResponse> get copyWith => __$TaskWorkloadResponseCopyWithImpl<_TaskWorkloadResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskWorkloadResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskWorkloadResponse&&(identical(other.projectId, projectId) || other.projectId == projectId)&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,projectId,const DeepCollectionEquality().hash(users),fromDate,toDate);

@override
String toString() {
  return 'TaskWorkloadResponse(projectId: $projectId, users: $users, fromDate: $fromDate, toDate: $toDate)';
}


}

/// @nodoc
abstract mixin class _$TaskWorkloadResponseCopyWith<$Res> implements $TaskWorkloadResponseCopyWith<$Res> {
  factory _$TaskWorkloadResponseCopyWith(_TaskWorkloadResponse value, $Res Function(_TaskWorkloadResponse) _then) = __$TaskWorkloadResponseCopyWithImpl;
@override @useResult
$Res call({
 String projectId, List<TaskWorkloadUserResponse> users, DateTime? fromDate, DateTime? toDate
});




}
/// @nodoc
class __$TaskWorkloadResponseCopyWithImpl<$Res>
    implements _$TaskWorkloadResponseCopyWith<$Res> {
  __$TaskWorkloadResponseCopyWithImpl(this._self, this._then);

  final _TaskWorkloadResponse _self;
  final $Res Function(_TaskWorkloadResponse) _then;

/// Create a copy of TaskWorkloadResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? users = null,Object? fromDate = freezed,Object? toDate = freezed,}) {
  return _then(_TaskWorkloadResponse(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<TaskWorkloadUserResponse>,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
