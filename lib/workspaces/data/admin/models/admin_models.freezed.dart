// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SystemErrorLogResponse {

 String get id; String get traceId; int get statusCode; String get method; String get path; String get exceptionType; String get message; String? get stackTrace; String? get coreUserId; DateTime get occurredAtUtc; bool get isResolved; DateTime? get resolvedAtUtc;
/// Create a copy of SystemErrorLogResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemErrorLogResponseCopyWith<SystemErrorLogResponse> get copyWith => _$SystemErrorLogResponseCopyWithImpl<SystemErrorLogResponse>(this as SystemErrorLogResponse, _$identity);

  /// Serializes this SystemErrorLogResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemErrorLogResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.traceId, traceId) || other.traceId == traceId)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path)&&(identical(other.exceptionType, exceptionType) || other.exceptionType == exceptionType)&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.resolvedAtUtc, resolvedAtUtc) || other.resolvedAtUtc == resolvedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,traceId,statusCode,method,path,exceptionType,message,stackTrace,coreUserId,occurredAtUtc,isResolved,resolvedAtUtc);

@override
String toString() {
  return 'SystemErrorLogResponse(id: $id, traceId: $traceId, statusCode: $statusCode, method: $method, path: $path, exceptionType: $exceptionType, message: $message, stackTrace: $stackTrace, coreUserId: $coreUserId, occurredAtUtc: $occurredAtUtc, isResolved: $isResolved, resolvedAtUtc: $resolvedAtUtc)';
}


}

/// @nodoc
abstract mixin class $SystemErrorLogResponseCopyWith<$Res>  {
  factory $SystemErrorLogResponseCopyWith(SystemErrorLogResponse value, $Res Function(SystemErrorLogResponse) _then) = _$SystemErrorLogResponseCopyWithImpl;
@useResult
$Res call({
 String id, String traceId, int statusCode, String method, String path, String exceptionType, String message, String? stackTrace, String? coreUserId, DateTime occurredAtUtc, bool isResolved, DateTime? resolvedAtUtc
});




}
/// @nodoc
class _$SystemErrorLogResponseCopyWithImpl<$Res>
    implements $SystemErrorLogResponseCopyWith<$Res> {
  _$SystemErrorLogResponseCopyWithImpl(this._self, this._then);

  final SystemErrorLogResponse _self;
  final $Res Function(SystemErrorLogResponse) _then;

/// Create a copy of SystemErrorLogResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? traceId = null,Object? statusCode = null,Object? method = null,Object? path = null,Object? exceptionType = null,Object? message = null,Object? stackTrace = freezed,Object? coreUserId = freezed,Object? occurredAtUtc = null,Object? isResolved = null,Object? resolvedAtUtc = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,traceId: null == traceId ? _self.traceId : traceId // ignore: cast_nullable_to_non_nullable
as String,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,exceptionType: null == exceptionType ? _self.exceptionType : exceptionType // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String?,coreUserId: freezed == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String?,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,resolvedAtUtc: freezed == resolvedAtUtc ? _self.resolvedAtUtc : resolvedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SystemErrorLogResponse].
extension SystemErrorLogResponsePatterns on SystemErrorLogResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SystemErrorLogResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SystemErrorLogResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SystemErrorLogResponse value)  $default,){
final _that = this;
switch (_that) {
case _SystemErrorLogResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SystemErrorLogResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SystemErrorLogResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String traceId,  int statusCode,  String method,  String path,  String exceptionType,  String message,  String? stackTrace,  String? coreUserId,  DateTime occurredAtUtc,  bool isResolved,  DateTime? resolvedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SystemErrorLogResponse() when $default != null:
return $default(_that.id,_that.traceId,_that.statusCode,_that.method,_that.path,_that.exceptionType,_that.message,_that.stackTrace,_that.coreUserId,_that.occurredAtUtc,_that.isResolved,_that.resolvedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String traceId,  int statusCode,  String method,  String path,  String exceptionType,  String message,  String? stackTrace,  String? coreUserId,  DateTime occurredAtUtc,  bool isResolved,  DateTime? resolvedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _SystemErrorLogResponse():
return $default(_that.id,_that.traceId,_that.statusCode,_that.method,_that.path,_that.exceptionType,_that.message,_that.stackTrace,_that.coreUserId,_that.occurredAtUtc,_that.isResolved,_that.resolvedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String traceId,  int statusCode,  String method,  String path,  String exceptionType,  String message,  String? stackTrace,  String? coreUserId,  DateTime occurredAtUtc,  bool isResolved,  DateTime? resolvedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _SystemErrorLogResponse() when $default != null:
return $default(_that.id,_that.traceId,_that.statusCode,_that.method,_that.path,_that.exceptionType,_that.message,_that.stackTrace,_that.coreUserId,_that.occurredAtUtc,_that.isResolved,_that.resolvedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SystemErrorLogResponse implements SystemErrorLogResponse {
  const _SystemErrorLogResponse({required this.id, required this.traceId, required this.statusCode, required this.method, required this.path, required this.exceptionType, required this.message, this.stackTrace, this.coreUserId, required this.occurredAtUtc, required this.isResolved, this.resolvedAtUtc});
  factory _SystemErrorLogResponse.fromJson(Map<String, dynamic> json) => _$SystemErrorLogResponseFromJson(json);

@override final  String id;
@override final  String traceId;
@override final  int statusCode;
@override final  String method;
@override final  String path;
@override final  String exceptionType;
@override final  String message;
@override final  String? stackTrace;
@override final  String? coreUserId;
@override final  DateTime occurredAtUtc;
@override final  bool isResolved;
@override final  DateTime? resolvedAtUtc;

/// Create a copy of SystemErrorLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SystemErrorLogResponseCopyWith<_SystemErrorLogResponse> get copyWith => __$SystemErrorLogResponseCopyWithImpl<_SystemErrorLogResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SystemErrorLogResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SystemErrorLogResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.traceId, traceId) || other.traceId == traceId)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path)&&(identical(other.exceptionType, exceptionType) || other.exceptionType == exceptionType)&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&(identical(other.coreUserId, coreUserId) || other.coreUserId == coreUserId)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.resolvedAtUtc, resolvedAtUtc) || other.resolvedAtUtc == resolvedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,traceId,statusCode,method,path,exceptionType,message,stackTrace,coreUserId,occurredAtUtc,isResolved,resolvedAtUtc);

@override
String toString() {
  return 'SystemErrorLogResponse(id: $id, traceId: $traceId, statusCode: $statusCode, method: $method, path: $path, exceptionType: $exceptionType, message: $message, stackTrace: $stackTrace, coreUserId: $coreUserId, occurredAtUtc: $occurredAtUtc, isResolved: $isResolved, resolvedAtUtc: $resolvedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$SystemErrorLogResponseCopyWith<$Res> implements $SystemErrorLogResponseCopyWith<$Res> {
  factory _$SystemErrorLogResponseCopyWith(_SystemErrorLogResponse value, $Res Function(_SystemErrorLogResponse) _then) = __$SystemErrorLogResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String traceId, int statusCode, String method, String path, String exceptionType, String message, String? stackTrace, String? coreUserId, DateTime occurredAtUtc, bool isResolved, DateTime? resolvedAtUtc
});




}
/// @nodoc
class __$SystemErrorLogResponseCopyWithImpl<$Res>
    implements _$SystemErrorLogResponseCopyWith<$Res> {
  __$SystemErrorLogResponseCopyWithImpl(this._self, this._then);

  final _SystemErrorLogResponse _self;
  final $Res Function(_SystemErrorLogResponse) _then;

/// Create a copy of SystemErrorLogResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? traceId = null,Object? statusCode = null,Object? method = null,Object? path = null,Object? exceptionType = null,Object? message = null,Object? stackTrace = freezed,Object? coreUserId = freezed,Object? occurredAtUtc = null,Object? isResolved = null,Object? resolvedAtUtc = freezed,}) {
  return _then(_SystemErrorLogResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,traceId: null == traceId ? _self.traceId : traceId // ignore: cast_nullable_to_non_nullable
as String,statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,exceptionType: null == exceptionType ? _self.exceptionType : exceptionType // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String?,coreUserId: freezed == coreUserId ? _self.coreUserId : coreUserId // ignore: cast_nullable_to_non_nullable
as String?,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,resolvedAtUtc: freezed == resolvedAtUtc ? _self.resolvedAtUtc : resolvedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AdminMaintenanceResultResponse {

 int get affectedRecords; DateTime get executedAtUtc;
/// Create a copy of AdminMaintenanceResultResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminMaintenanceResultResponseCopyWith<AdminMaintenanceResultResponse> get copyWith => _$AdminMaintenanceResultResponseCopyWithImpl<AdminMaintenanceResultResponse>(this as AdminMaintenanceResultResponse, _$identity);

  /// Serializes this AdminMaintenanceResultResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminMaintenanceResultResponse&&(identical(other.affectedRecords, affectedRecords) || other.affectedRecords == affectedRecords)&&(identical(other.executedAtUtc, executedAtUtc) || other.executedAtUtc == executedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,affectedRecords,executedAtUtc);

@override
String toString() {
  return 'AdminMaintenanceResultResponse(affectedRecords: $affectedRecords, executedAtUtc: $executedAtUtc)';
}


}

/// @nodoc
abstract mixin class $AdminMaintenanceResultResponseCopyWith<$Res>  {
  factory $AdminMaintenanceResultResponseCopyWith(AdminMaintenanceResultResponse value, $Res Function(AdminMaintenanceResultResponse) _then) = _$AdminMaintenanceResultResponseCopyWithImpl;
@useResult
$Res call({
 int affectedRecords, DateTime executedAtUtc
});




}
/// @nodoc
class _$AdminMaintenanceResultResponseCopyWithImpl<$Res>
    implements $AdminMaintenanceResultResponseCopyWith<$Res> {
  _$AdminMaintenanceResultResponseCopyWithImpl(this._self, this._then);

  final AdminMaintenanceResultResponse _self;
  final $Res Function(AdminMaintenanceResultResponse) _then;

/// Create a copy of AdminMaintenanceResultResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? affectedRecords = null,Object? executedAtUtc = null,}) {
  return _then(_self.copyWith(
affectedRecords: null == affectedRecords ? _self.affectedRecords : affectedRecords // ignore: cast_nullable_to_non_nullable
as int,executedAtUtc: null == executedAtUtc ? _self.executedAtUtc : executedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminMaintenanceResultResponse].
extension AdminMaintenanceResultResponsePatterns on AdminMaintenanceResultResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminMaintenanceResultResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminMaintenanceResultResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminMaintenanceResultResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminMaintenanceResultResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminMaintenanceResultResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminMaintenanceResultResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int affectedRecords,  DateTime executedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminMaintenanceResultResponse() when $default != null:
return $default(_that.affectedRecords,_that.executedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int affectedRecords,  DateTime executedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _AdminMaintenanceResultResponse():
return $default(_that.affectedRecords,_that.executedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int affectedRecords,  DateTime executedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _AdminMaintenanceResultResponse() when $default != null:
return $default(_that.affectedRecords,_that.executedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminMaintenanceResultResponse implements AdminMaintenanceResultResponse {
  const _AdminMaintenanceResultResponse({required this.affectedRecords, required this.executedAtUtc});
  factory _AdminMaintenanceResultResponse.fromJson(Map<String, dynamic> json) => _$AdminMaintenanceResultResponseFromJson(json);

@override final  int affectedRecords;
@override final  DateTime executedAtUtc;

/// Create a copy of AdminMaintenanceResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminMaintenanceResultResponseCopyWith<_AdminMaintenanceResultResponse> get copyWith => __$AdminMaintenanceResultResponseCopyWithImpl<_AdminMaintenanceResultResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminMaintenanceResultResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminMaintenanceResultResponse&&(identical(other.affectedRecords, affectedRecords) || other.affectedRecords == affectedRecords)&&(identical(other.executedAtUtc, executedAtUtc) || other.executedAtUtc == executedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,affectedRecords,executedAtUtc);

@override
String toString() {
  return 'AdminMaintenanceResultResponse(affectedRecords: $affectedRecords, executedAtUtc: $executedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$AdminMaintenanceResultResponseCopyWith<$Res> implements $AdminMaintenanceResultResponseCopyWith<$Res> {
  factory _$AdminMaintenanceResultResponseCopyWith(_AdminMaintenanceResultResponse value, $Res Function(_AdminMaintenanceResultResponse) _then) = __$AdminMaintenanceResultResponseCopyWithImpl;
@override @useResult
$Res call({
 int affectedRecords, DateTime executedAtUtc
});




}
/// @nodoc
class __$AdminMaintenanceResultResponseCopyWithImpl<$Res>
    implements _$AdminMaintenanceResultResponseCopyWith<$Res> {
  __$AdminMaintenanceResultResponseCopyWithImpl(this._self, this._then);

  final _AdminMaintenanceResultResponse _self;
  final $Res Function(_AdminMaintenanceResultResponse) _then;

/// Create a copy of AdminMaintenanceResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? affectedRecords = null,Object? executedAtUtc = null,}) {
  return _then(_AdminMaintenanceResultResponse(
affectedRecords: null == affectedRecords ? _self.affectedRecords : affectedRecords // ignore: cast_nullable_to_non_nullable
as int,executedAtUtc: null == executedAtUtc ? _self.executedAtUtc : executedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PurgeSystemErrorsPayload {

 int get olderThanDays; bool get onlyResolved;
/// Create a copy of PurgeSystemErrorsPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurgeSystemErrorsPayloadCopyWith<PurgeSystemErrorsPayload> get copyWith => _$PurgeSystemErrorsPayloadCopyWithImpl<PurgeSystemErrorsPayload>(this as PurgeSystemErrorsPayload, _$identity);

  /// Serializes this PurgeSystemErrorsPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurgeSystemErrorsPayload&&(identical(other.olderThanDays, olderThanDays) || other.olderThanDays == olderThanDays)&&(identical(other.onlyResolved, onlyResolved) || other.onlyResolved == onlyResolved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,olderThanDays,onlyResolved);

@override
String toString() {
  return 'PurgeSystemErrorsPayload(olderThanDays: $olderThanDays, onlyResolved: $onlyResolved)';
}


}

/// @nodoc
abstract mixin class $PurgeSystemErrorsPayloadCopyWith<$Res>  {
  factory $PurgeSystemErrorsPayloadCopyWith(PurgeSystemErrorsPayload value, $Res Function(PurgeSystemErrorsPayload) _then) = _$PurgeSystemErrorsPayloadCopyWithImpl;
@useResult
$Res call({
 int olderThanDays, bool onlyResolved
});




}
/// @nodoc
class _$PurgeSystemErrorsPayloadCopyWithImpl<$Res>
    implements $PurgeSystemErrorsPayloadCopyWith<$Res> {
  _$PurgeSystemErrorsPayloadCopyWithImpl(this._self, this._then);

  final PurgeSystemErrorsPayload _self;
  final $Res Function(PurgeSystemErrorsPayload) _then;

/// Create a copy of PurgeSystemErrorsPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? olderThanDays = null,Object? onlyResolved = null,}) {
  return _then(_self.copyWith(
olderThanDays: null == olderThanDays ? _self.olderThanDays : olderThanDays // ignore: cast_nullable_to_non_nullable
as int,onlyResolved: null == onlyResolved ? _self.onlyResolved : onlyResolved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PurgeSystemErrorsPayload].
extension PurgeSystemErrorsPayloadPatterns on PurgeSystemErrorsPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurgeSystemErrorsPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurgeSystemErrorsPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurgeSystemErrorsPayload value)  $default,){
final _that = this;
switch (_that) {
case _PurgeSystemErrorsPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurgeSystemErrorsPayload value)?  $default,){
final _that = this;
switch (_that) {
case _PurgeSystemErrorsPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int olderThanDays,  bool onlyResolved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurgeSystemErrorsPayload() when $default != null:
return $default(_that.olderThanDays,_that.onlyResolved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int olderThanDays,  bool onlyResolved)  $default,) {final _that = this;
switch (_that) {
case _PurgeSystemErrorsPayload():
return $default(_that.olderThanDays,_that.onlyResolved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int olderThanDays,  bool onlyResolved)?  $default,) {final _that = this;
switch (_that) {
case _PurgeSystemErrorsPayload() when $default != null:
return $default(_that.olderThanDays,_that.onlyResolved);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurgeSystemErrorsPayload implements PurgeSystemErrorsPayload {
  const _PurgeSystemErrorsPayload({required this.olderThanDays, this.onlyResolved = false});
  factory _PurgeSystemErrorsPayload.fromJson(Map<String, dynamic> json) => _$PurgeSystemErrorsPayloadFromJson(json);

@override final  int olderThanDays;
@override@JsonKey() final  bool onlyResolved;

/// Create a copy of PurgeSystemErrorsPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurgeSystemErrorsPayloadCopyWith<_PurgeSystemErrorsPayload> get copyWith => __$PurgeSystemErrorsPayloadCopyWithImpl<_PurgeSystemErrorsPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurgeSystemErrorsPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurgeSystemErrorsPayload&&(identical(other.olderThanDays, olderThanDays) || other.olderThanDays == olderThanDays)&&(identical(other.onlyResolved, onlyResolved) || other.onlyResolved == onlyResolved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,olderThanDays,onlyResolved);

@override
String toString() {
  return 'PurgeSystemErrorsPayload(olderThanDays: $olderThanDays, onlyResolved: $onlyResolved)';
}


}

/// @nodoc
abstract mixin class _$PurgeSystemErrorsPayloadCopyWith<$Res> implements $PurgeSystemErrorsPayloadCopyWith<$Res> {
  factory _$PurgeSystemErrorsPayloadCopyWith(_PurgeSystemErrorsPayload value, $Res Function(_PurgeSystemErrorsPayload) _then) = __$PurgeSystemErrorsPayloadCopyWithImpl;
@override @useResult
$Res call({
 int olderThanDays, bool onlyResolved
});




}
/// @nodoc
class __$PurgeSystemErrorsPayloadCopyWithImpl<$Res>
    implements _$PurgeSystemErrorsPayloadCopyWith<$Res> {
  __$PurgeSystemErrorsPayloadCopyWithImpl(this._self, this._then);

  final _PurgeSystemErrorsPayload _self;
  final $Res Function(_PurgeSystemErrorsPayload) _then;

/// Create a copy of PurgeSystemErrorsPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? olderThanDays = null,Object? onlyResolved = null,}) {
  return _then(_PurgeSystemErrorsPayload(
olderThanDays: null == olderThanDays ? _self.olderThanDays : olderThanDays // ignore: cast_nullable_to_non_nullable
as int,onlyResolved: null == onlyResolved ? _self.onlyResolved : onlyResolved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ClamAvProbeResponse {

 bool get enabled; bool get reachable; String get host; int get port; String? get signatureVersion; DateTime? get lastSignatureUpdateUtc; int get scannedFilesLast24Hours; int get threatsDetectedLast24Hours; int get quarantinedFiles;
/// Create a copy of ClamAvProbeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClamAvProbeResponseCopyWith<ClamAvProbeResponse> get copyWith => _$ClamAvProbeResponseCopyWithImpl<ClamAvProbeResponse>(this as ClamAvProbeResponse, _$identity);

  /// Serializes this ClamAvProbeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClamAvProbeResponse&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.reachable, reachable) || other.reachable == reachable)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.signatureVersion, signatureVersion) || other.signatureVersion == signatureVersion)&&(identical(other.lastSignatureUpdateUtc, lastSignatureUpdateUtc) || other.lastSignatureUpdateUtc == lastSignatureUpdateUtc)&&(identical(other.scannedFilesLast24Hours, scannedFilesLast24Hours) || other.scannedFilesLast24Hours == scannedFilesLast24Hours)&&(identical(other.threatsDetectedLast24Hours, threatsDetectedLast24Hours) || other.threatsDetectedLast24Hours == threatsDetectedLast24Hours)&&(identical(other.quarantinedFiles, quarantinedFiles) || other.quarantinedFiles == quarantinedFiles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,reachable,host,port,signatureVersion,lastSignatureUpdateUtc,scannedFilesLast24Hours,threatsDetectedLast24Hours,quarantinedFiles);

@override
String toString() {
  return 'ClamAvProbeResponse(enabled: $enabled, reachable: $reachable, host: $host, port: $port, signatureVersion: $signatureVersion, lastSignatureUpdateUtc: $lastSignatureUpdateUtc, scannedFilesLast24Hours: $scannedFilesLast24Hours, threatsDetectedLast24Hours: $threatsDetectedLast24Hours, quarantinedFiles: $quarantinedFiles)';
}


}

/// @nodoc
abstract mixin class $ClamAvProbeResponseCopyWith<$Res>  {
  factory $ClamAvProbeResponseCopyWith(ClamAvProbeResponse value, $Res Function(ClamAvProbeResponse) _then) = _$ClamAvProbeResponseCopyWithImpl;
@useResult
$Res call({
 bool enabled, bool reachable, String host, int port, String? signatureVersion, DateTime? lastSignatureUpdateUtc, int scannedFilesLast24Hours, int threatsDetectedLast24Hours, int quarantinedFiles
});




}
/// @nodoc
class _$ClamAvProbeResponseCopyWithImpl<$Res>
    implements $ClamAvProbeResponseCopyWith<$Res> {
  _$ClamAvProbeResponseCopyWithImpl(this._self, this._then);

  final ClamAvProbeResponse _self;
  final $Res Function(ClamAvProbeResponse) _then;

/// Create a copy of ClamAvProbeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? reachable = null,Object? host = null,Object? port = null,Object? signatureVersion = freezed,Object? lastSignatureUpdateUtc = freezed,Object? scannedFilesLast24Hours = null,Object? threatsDetectedLast24Hours = null,Object? quarantinedFiles = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,reachable: null == reachable ? _self.reachable : reachable // ignore: cast_nullable_to_non_nullable
as bool,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,signatureVersion: freezed == signatureVersion ? _self.signatureVersion : signatureVersion // ignore: cast_nullable_to_non_nullable
as String?,lastSignatureUpdateUtc: freezed == lastSignatureUpdateUtc ? _self.lastSignatureUpdateUtc : lastSignatureUpdateUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,scannedFilesLast24Hours: null == scannedFilesLast24Hours ? _self.scannedFilesLast24Hours : scannedFilesLast24Hours // ignore: cast_nullable_to_non_nullable
as int,threatsDetectedLast24Hours: null == threatsDetectedLast24Hours ? _self.threatsDetectedLast24Hours : threatsDetectedLast24Hours // ignore: cast_nullable_to_non_nullable
as int,quarantinedFiles: null == quarantinedFiles ? _self.quarantinedFiles : quarantinedFiles // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ClamAvProbeResponse].
extension ClamAvProbeResponsePatterns on ClamAvProbeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClamAvProbeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClamAvProbeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClamAvProbeResponse value)  $default,){
final _that = this;
switch (_that) {
case _ClamAvProbeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClamAvProbeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ClamAvProbeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  bool reachable,  String host,  int port,  String? signatureVersion,  DateTime? lastSignatureUpdateUtc,  int scannedFilesLast24Hours,  int threatsDetectedLast24Hours,  int quarantinedFiles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClamAvProbeResponse() when $default != null:
return $default(_that.enabled,_that.reachable,_that.host,_that.port,_that.signatureVersion,_that.lastSignatureUpdateUtc,_that.scannedFilesLast24Hours,_that.threatsDetectedLast24Hours,_that.quarantinedFiles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  bool reachable,  String host,  int port,  String? signatureVersion,  DateTime? lastSignatureUpdateUtc,  int scannedFilesLast24Hours,  int threatsDetectedLast24Hours,  int quarantinedFiles)  $default,) {final _that = this;
switch (_that) {
case _ClamAvProbeResponse():
return $default(_that.enabled,_that.reachable,_that.host,_that.port,_that.signatureVersion,_that.lastSignatureUpdateUtc,_that.scannedFilesLast24Hours,_that.threatsDetectedLast24Hours,_that.quarantinedFiles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  bool reachable,  String host,  int port,  String? signatureVersion,  DateTime? lastSignatureUpdateUtc,  int scannedFilesLast24Hours,  int threatsDetectedLast24Hours,  int quarantinedFiles)?  $default,) {final _that = this;
switch (_that) {
case _ClamAvProbeResponse() when $default != null:
return $default(_that.enabled,_that.reachable,_that.host,_that.port,_that.signatureVersion,_that.lastSignatureUpdateUtc,_that.scannedFilesLast24Hours,_that.threatsDetectedLast24Hours,_that.quarantinedFiles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClamAvProbeResponse implements ClamAvProbeResponse {
  const _ClamAvProbeResponse({required this.enabled, required this.reachable, required this.host, required this.port, this.signatureVersion, this.lastSignatureUpdateUtc, this.scannedFilesLast24Hours = 0, this.threatsDetectedLast24Hours = 0, this.quarantinedFiles = 0});
  factory _ClamAvProbeResponse.fromJson(Map<String, dynamic> json) => _$ClamAvProbeResponseFromJson(json);

@override final  bool enabled;
@override final  bool reachable;
@override final  String host;
@override final  int port;
@override final  String? signatureVersion;
@override final  DateTime? lastSignatureUpdateUtc;
@override@JsonKey() final  int scannedFilesLast24Hours;
@override@JsonKey() final  int threatsDetectedLast24Hours;
@override@JsonKey() final  int quarantinedFiles;

/// Create a copy of ClamAvProbeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClamAvProbeResponseCopyWith<_ClamAvProbeResponse> get copyWith => __$ClamAvProbeResponseCopyWithImpl<_ClamAvProbeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClamAvProbeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClamAvProbeResponse&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.reachable, reachable) || other.reachable == reachable)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.signatureVersion, signatureVersion) || other.signatureVersion == signatureVersion)&&(identical(other.lastSignatureUpdateUtc, lastSignatureUpdateUtc) || other.lastSignatureUpdateUtc == lastSignatureUpdateUtc)&&(identical(other.scannedFilesLast24Hours, scannedFilesLast24Hours) || other.scannedFilesLast24Hours == scannedFilesLast24Hours)&&(identical(other.threatsDetectedLast24Hours, threatsDetectedLast24Hours) || other.threatsDetectedLast24Hours == threatsDetectedLast24Hours)&&(identical(other.quarantinedFiles, quarantinedFiles) || other.quarantinedFiles == quarantinedFiles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,reachable,host,port,signatureVersion,lastSignatureUpdateUtc,scannedFilesLast24Hours,threatsDetectedLast24Hours,quarantinedFiles);

@override
String toString() {
  return 'ClamAvProbeResponse(enabled: $enabled, reachable: $reachable, host: $host, port: $port, signatureVersion: $signatureVersion, lastSignatureUpdateUtc: $lastSignatureUpdateUtc, scannedFilesLast24Hours: $scannedFilesLast24Hours, threatsDetectedLast24Hours: $threatsDetectedLast24Hours, quarantinedFiles: $quarantinedFiles)';
}


}

/// @nodoc
abstract mixin class _$ClamAvProbeResponseCopyWith<$Res> implements $ClamAvProbeResponseCopyWith<$Res> {
  factory _$ClamAvProbeResponseCopyWith(_ClamAvProbeResponse value, $Res Function(_ClamAvProbeResponse) _then) = __$ClamAvProbeResponseCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, bool reachable, String host, int port, String? signatureVersion, DateTime? lastSignatureUpdateUtc, int scannedFilesLast24Hours, int threatsDetectedLast24Hours, int quarantinedFiles
});




}
/// @nodoc
class __$ClamAvProbeResponseCopyWithImpl<$Res>
    implements _$ClamAvProbeResponseCopyWith<$Res> {
  __$ClamAvProbeResponseCopyWithImpl(this._self, this._then);

  final _ClamAvProbeResponse _self;
  final $Res Function(_ClamAvProbeResponse) _then;

/// Create a copy of ClamAvProbeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? reachable = null,Object? host = null,Object? port = null,Object? signatureVersion = freezed,Object? lastSignatureUpdateUtc = freezed,Object? scannedFilesLast24Hours = null,Object? threatsDetectedLast24Hours = null,Object? quarantinedFiles = null,}) {
  return _then(_ClamAvProbeResponse(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,reachable: null == reachable ? _self.reachable : reachable // ignore: cast_nullable_to_non_nullable
as bool,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,signatureVersion: freezed == signatureVersion ? _self.signatureVersion : signatureVersion // ignore: cast_nullable_to_non_nullable
as String?,lastSignatureUpdateUtc: freezed == lastSignatureUpdateUtc ? _self.lastSignatureUpdateUtc : lastSignatureUpdateUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,scannedFilesLast24Hours: null == scannedFilesLast24Hours ? _self.scannedFilesLast24Hours : scannedFilesLast24Hours // ignore: cast_nullable_to_non_nullable
as int,threatsDetectedLast24Hours: null == threatsDetectedLast24Hours ? _self.threatsDetectedLast24Hours : threatsDetectedLast24Hours // ignore: cast_nullable_to_non_nullable
as int,quarantinedFiles: null == quarantinedFiles ? _self.quarantinedFiles : quarantinedFiles // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StorageRescanPayload {

 String? get fileId; int get limit;
/// Create a copy of StorageRescanPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageRescanPayloadCopyWith<StorageRescanPayload> get copyWith => _$StorageRescanPayloadCopyWithImpl<StorageRescanPayload>(this as StorageRescanPayload, _$identity);

  /// Serializes this StorageRescanPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageRescanPayload&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,limit);

@override
String toString() {
  return 'StorageRescanPayload(fileId: $fileId, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $StorageRescanPayloadCopyWith<$Res>  {
  factory $StorageRescanPayloadCopyWith(StorageRescanPayload value, $Res Function(StorageRescanPayload) _then) = _$StorageRescanPayloadCopyWithImpl;
@useResult
$Res call({
 String? fileId, int limit
});




}
/// @nodoc
class _$StorageRescanPayloadCopyWithImpl<$Res>
    implements $StorageRescanPayloadCopyWith<$Res> {
  _$StorageRescanPayloadCopyWithImpl(this._self, this._then);

  final StorageRescanPayload _self;
  final $Res Function(StorageRescanPayload) _then;

/// Create a copy of StorageRescanPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = freezed,Object? limit = null,}) {
  return _then(_self.copyWith(
fileId: freezed == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageRescanPayload].
extension StorageRescanPayloadPatterns on StorageRescanPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageRescanPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageRescanPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageRescanPayload value)  $default,){
final _that = this;
switch (_that) {
case _StorageRescanPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageRescanPayload value)?  $default,){
final _that = this;
switch (_that) {
case _StorageRescanPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fileId,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageRescanPayload() when $default != null:
return $default(_that.fileId,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fileId,  int limit)  $default,) {final _that = this;
switch (_that) {
case _StorageRescanPayload():
return $default(_that.fileId,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fileId,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _StorageRescanPayload() when $default != null:
return $default(_that.fileId,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageRescanPayload implements StorageRescanPayload {
  const _StorageRescanPayload({this.fileId, this.limit = 100});
  factory _StorageRescanPayload.fromJson(Map<String, dynamic> json) => _$StorageRescanPayloadFromJson(json);

@override final  String? fileId;
@override@JsonKey() final  int limit;

/// Create a copy of StorageRescanPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageRescanPayloadCopyWith<_StorageRescanPayload> get copyWith => __$StorageRescanPayloadCopyWithImpl<_StorageRescanPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageRescanPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageRescanPayload&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,limit);

@override
String toString() {
  return 'StorageRescanPayload(fileId: $fileId, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$StorageRescanPayloadCopyWith<$Res> implements $StorageRescanPayloadCopyWith<$Res> {
  factory _$StorageRescanPayloadCopyWith(_StorageRescanPayload value, $Res Function(_StorageRescanPayload) _then) = __$StorageRescanPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? fileId, int limit
});




}
/// @nodoc
class __$StorageRescanPayloadCopyWithImpl<$Res>
    implements _$StorageRescanPayloadCopyWith<$Res> {
  __$StorageRescanPayloadCopyWithImpl(this._self, this._then);

  final _StorageRescanPayload _self;
  final $Res Function(_StorageRescanPayload) _then;

/// Create a copy of StorageRescanPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = freezed,Object? limit = null,}) {
  return _then(_StorageRescanPayload(
fileId: freezed == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StorageRescanResponse {

 DateTime get executedAtUtc; int get requestedFiles; int get scannedFiles; int get infectedFiles; int get failedFiles;
/// Create a copy of StorageRescanResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageRescanResponseCopyWith<StorageRescanResponse> get copyWith => _$StorageRescanResponseCopyWithImpl<StorageRescanResponse>(this as StorageRescanResponse, _$identity);

  /// Serializes this StorageRescanResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageRescanResponse&&(identical(other.executedAtUtc, executedAtUtc) || other.executedAtUtc == executedAtUtc)&&(identical(other.requestedFiles, requestedFiles) || other.requestedFiles == requestedFiles)&&(identical(other.scannedFiles, scannedFiles) || other.scannedFiles == scannedFiles)&&(identical(other.infectedFiles, infectedFiles) || other.infectedFiles == infectedFiles)&&(identical(other.failedFiles, failedFiles) || other.failedFiles == failedFiles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,executedAtUtc,requestedFiles,scannedFiles,infectedFiles,failedFiles);

@override
String toString() {
  return 'StorageRescanResponse(executedAtUtc: $executedAtUtc, requestedFiles: $requestedFiles, scannedFiles: $scannedFiles, infectedFiles: $infectedFiles, failedFiles: $failedFiles)';
}


}

/// @nodoc
abstract mixin class $StorageRescanResponseCopyWith<$Res>  {
  factory $StorageRescanResponseCopyWith(StorageRescanResponse value, $Res Function(StorageRescanResponse) _then) = _$StorageRescanResponseCopyWithImpl;
@useResult
$Res call({
 DateTime executedAtUtc, int requestedFiles, int scannedFiles, int infectedFiles, int failedFiles
});




}
/// @nodoc
class _$StorageRescanResponseCopyWithImpl<$Res>
    implements $StorageRescanResponseCopyWith<$Res> {
  _$StorageRescanResponseCopyWithImpl(this._self, this._then);

  final StorageRescanResponse _self;
  final $Res Function(StorageRescanResponse) _then;

/// Create a copy of StorageRescanResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? executedAtUtc = null,Object? requestedFiles = null,Object? scannedFiles = null,Object? infectedFiles = null,Object? failedFiles = null,}) {
  return _then(_self.copyWith(
executedAtUtc: null == executedAtUtc ? _self.executedAtUtc : executedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,requestedFiles: null == requestedFiles ? _self.requestedFiles : requestedFiles // ignore: cast_nullable_to_non_nullable
as int,scannedFiles: null == scannedFiles ? _self.scannedFiles : scannedFiles // ignore: cast_nullable_to_non_nullable
as int,infectedFiles: null == infectedFiles ? _self.infectedFiles : infectedFiles // ignore: cast_nullable_to_non_nullable
as int,failedFiles: null == failedFiles ? _self.failedFiles : failedFiles // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageRescanResponse].
extension StorageRescanResponsePatterns on StorageRescanResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageRescanResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageRescanResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageRescanResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageRescanResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageRescanResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageRescanResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime executedAtUtc,  int requestedFiles,  int scannedFiles,  int infectedFiles,  int failedFiles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageRescanResponse() when $default != null:
return $default(_that.executedAtUtc,_that.requestedFiles,_that.scannedFiles,_that.infectedFiles,_that.failedFiles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime executedAtUtc,  int requestedFiles,  int scannedFiles,  int infectedFiles,  int failedFiles)  $default,) {final _that = this;
switch (_that) {
case _StorageRescanResponse():
return $default(_that.executedAtUtc,_that.requestedFiles,_that.scannedFiles,_that.infectedFiles,_that.failedFiles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime executedAtUtc,  int requestedFiles,  int scannedFiles,  int infectedFiles,  int failedFiles)?  $default,) {final _that = this;
switch (_that) {
case _StorageRescanResponse() when $default != null:
return $default(_that.executedAtUtc,_that.requestedFiles,_that.scannedFiles,_that.infectedFiles,_that.failedFiles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageRescanResponse implements StorageRescanResponse {
  const _StorageRescanResponse({required this.executedAtUtc, required this.requestedFiles, required this.scannedFiles, required this.infectedFiles, required this.failedFiles});
  factory _StorageRescanResponse.fromJson(Map<String, dynamic> json) => _$StorageRescanResponseFromJson(json);

@override final  DateTime executedAtUtc;
@override final  int requestedFiles;
@override final  int scannedFiles;
@override final  int infectedFiles;
@override final  int failedFiles;

/// Create a copy of StorageRescanResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageRescanResponseCopyWith<_StorageRescanResponse> get copyWith => __$StorageRescanResponseCopyWithImpl<_StorageRescanResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageRescanResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageRescanResponse&&(identical(other.executedAtUtc, executedAtUtc) || other.executedAtUtc == executedAtUtc)&&(identical(other.requestedFiles, requestedFiles) || other.requestedFiles == requestedFiles)&&(identical(other.scannedFiles, scannedFiles) || other.scannedFiles == scannedFiles)&&(identical(other.infectedFiles, infectedFiles) || other.infectedFiles == infectedFiles)&&(identical(other.failedFiles, failedFiles) || other.failedFiles == failedFiles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,executedAtUtc,requestedFiles,scannedFiles,infectedFiles,failedFiles);

@override
String toString() {
  return 'StorageRescanResponse(executedAtUtc: $executedAtUtc, requestedFiles: $requestedFiles, scannedFiles: $scannedFiles, infectedFiles: $infectedFiles, failedFiles: $failedFiles)';
}


}

/// @nodoc
abstract mixin class _$StorageRescanResponseCopyWith<$Res> implements $StorageRescanResponseCopyWith<$Res> {
  factory _$StorageRescanResponseCopyWith(_StorageRescanResponse value, $Res Function(_StorageRescanResponse) _then) = __$StorageRescanResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime executedAtUtc, int requestedFiles, int scannedFiles, int infectedFiles, int failedFiles
});




}
/// @nodoc
class __$StorageRescanResponseCopyWithImpl<$Res>
    implements _$StorageRescanResponseCopyWith<$Res> {
  __$StorageRescanResponseCopyWithImpl(this._self, this._then);

  final _StorageRescanResponse _self;
  final $Res Function(_StorageRescanResponse) _then;

/// Create a copy of StorageRescanResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? executedAtUtc = null,Object? requestedFiles = null,Object? scannedFiles = null,Object? infectedFiles = null,Object? failedFiles = null,}) {
  return _then(_StorageRescanResponse(
executedAtUtc: null == executedAtUtc ? _self.executedAtUtc : executedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,requestedFiles: null == requestedFiles ? _self.requestedFiles : requestedFiles // ignore: cast_nullable_to_non_nullable
as int,scannedFiles: null == scannedFiles ? _self.scannedFiles : scannedFiles // ignore: cast_nullable_to_non_nullable
as int,infectedFiles: null == infectedFiles ? _self.infectedFiles : infectedFiles // ignore: cast_nullable_to_non_nullable
as int,failedFiles: null == failedFiles ? _self.failedFiles : failedFiles // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DeadLetterItemResponse {

 String get queueName; String get id; int get attemptCount; DateTime get createdAtUtc; DateTime get nextAttemptAtUtc; String? get lastError; String? get detail;
/// Create a copy of DeadLetterItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeadLetterItemResponseCopyWith<DeadLetterItemResponse> get copyWith => _$DeadLetterItemResponseCopyWithImpl<DeadLetterItemResponse>(this as DeadLetterItemResponse, _$identity);

  /// Serializes this DeadLetterItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeadLetterItemResponse&&(identical(other.queueName, queueName) || other.queueName == queueName)&&(identical(other.id, id) || other.id == id)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.nextAttemptAtUtc, nextAttemptAtUtc) || other.nextAttemptAtUtc == nextAttemptAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,queueName,id,attemptCount,createdAtUtc,nextAttemptAtUtc,lastError,detail);

@override
String toString() {
  return 'DeadLetterItemResponse(queueName: $queueName, id: $id, attemptCount: $attemptCount, createdAtUtc: $createdAtUtc, nextAttemptAtUtc: $nextAttemptAtUtc, lastError: $lastError, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $DeadLetterItemResponseCopyWith<$Res>  {
  factory $DeadLetterItemResponseCopyWith(DeadLetterItemResponse value, $Res Function(DeadLetterItemResponse) _then) = _$DeadLetterItemResponseCopyWithImpl;
@useResult
$Res call({
 String queueName, String id, int attemptCount, DateTime createdAtUtc, DateTime nextAttemptAtUtc, String? lastError, String? detail
});




}
/// @nodoc
class _$DeadLetterItemResponseCopyWithImpl<$Res>
    implements $DeadLetterItemResponseCopyWith<$Res> {
  _$DeadLetterItemResponseCopyWithImpl(this._self, this._then);

  final DeadLetterItemResponse _self;
  final $Res Function(DeadLetterItemResponse) _then;

/// Create a copy of DeadLetterItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? queueName = null,Object? id = null,Object? attemptCount = null,Object? createdAtUtc = null,Object? nextAttemptAtUtc = null,Object? lastError = freezed,Object? detail = freezed,}) {
  return _then(_self.copyWith(
queueName: null == queueName ? _self.queueName : queueName // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,nextAttemptAtUtc: null == nextAttemptAtUtc ? _self.nextAttemptAtUtc : nextAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeadLetterItemResponse].
extension DeadLetterItemResponsePatterns on DeadLetterItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeadLetterItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeadLetterItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeadLetterItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _DeadLetterItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeadLetterItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DeadLetterItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String queueName,  String id,  int attemptCount,  DateTime createdAtUtc,  DateTime nextAttemptAtUtc,  String? lastError,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeadLetterItemResponse() when $default != null:
return $default(_that.queueName,_that.id,_that.attemptCount,_that.createdAtUtc,_that.nextAttemptAtUtc,_that.lastError,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String queueName,  String id,  int attemptCount,  DateTime createdAtUtc,  DateTime nextAttemptAtUtc,  String? lastError,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _DeadLetterItemResponse():
return $default(_that.queueName,_that.id,_that.attemptCount,_that.createdAtUtc,_that.nextAttemptAtUtc,_that.lastError,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String queueName,  String id,  int attemptCount,  DateTime createdAtUtc,  DateTime nextAttemptAtUtc,  String? lastError,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _DeadLetterItemResponse() when $default != null:
return $default(_that.queueName,_that.id,_that.attemptCount,_that.createdAtUtc,_that.nextAttemptAtUtc,_that.lastError,_that.detail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeadLetterItemResponse implements DeadLetterItemResponse {
  const _DeadLetterItemResponse({required this.queueName, required this.id, required this.attemptCount, required this.createdAtUtc, required this.nextAttemptAtUtc, this.lastError, this.detail});
  factory _DeadLetterItemResponse.fromJson(Map<String, dynamic> json) => _$DeadLetterItemResponseFromJson(json);

@override final  String queueName;
@override final  String id;
@override final  int attemptCount;
@override final  DateTime createdAtUtc;
@override final  DateTime nextAttemptAtUtc;
@override final  String? lastError;
@override final  String? detail;

/// Create a copy of DeadLetterItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeadLetterItemResponseCopyWith<_DeadLetterItemResponse> get copyWith => __$DeadLetterItemResponseCopyWithImpl<_DeadLetterItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeadLetterItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeadLetterItemResponse&&(identical(other.queueName, queueName) || other.queueName == queueName)&&(identical(other.id, id) || other.id == id)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.nextAttemptAtUtc, nextAttemptAtUtc) || other.nextAttemptAtUtc == nextAttemptAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,queueName,id,attemptCount,createdAtUtc,nextAttemptAtUtc,lastError,detail);

@override
String toString() {
  return 'DeadLetterItemResponse(queueName: $queueName, id: $id, attemptCount: $attemptCount, createdAtUtc: $createdAtUtc, nextAttemptAtUtc: $nextAttemptAtUtc, lastError: $lastError, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$DeadLetterItemResponseCopyWith<$Res> implements $DeadLetterItemResponseCopyWith<$Res> {
  factory _$DeadLetterItemResponseCopyWith(_DeadLetterItemResponse value, $Res Function(_DeadLetterItemResponse) _then) = __$DeadLetterItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String queueName, String id, int attemptCount, DateTime createdAtUtc, DateTime nextAttemptAtUtc, String? lastError, String? detail
});




}
/// @nodoc
class __$DeadLetterItemResponseCopyWithImpl<$Res>
    implements _$DeadLetterItemResponseCopyWith<$Res> {
  __$DeadLetterItemResponseCopyWithImpl(this._self, this._then);

  final _DeadLetterItemResponse _self;
  final $Res Function(_DeadLetterItemResponse) _then;

/// Create a copy of DeadLetterItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? queueName = null,Object? id = null,Object? attemptCount = null,Object? createdAtUtc = null,Object? nextAttemptAtUtc = null,Object? lastError = freezed,Object? detail = freezed,}) {
  return _then(_DeadLetterItemResponse(
queueName: null == queueName ? _self.queueName : queueName // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,nextAttemptAtUtc: null == nextAttemptAtUtc ? _self.nextAttemptAtUtc : nextAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AdminRealtimeHubResponse {

 String get hub; int get activeConnections; int get openRooms; int get activeUsers;
/// Create a copy of AdminRealtimeHubResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRealtimeHubResponseCopyWith<AdminRealtimeHubResponse> get copyWith => _$AdminRealtimeHubResponseCopyWithImpl<AdminRealtimeHubResponse>(this as AdminRealtimeHubResponse, _$identity);

  /// Serializes this AdminRealtimeHubResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRealtimeHubResponse&&(identical(other.hub, hub) || other.hub == hub)&&(identical(other.activeConnections, activeConnections) || other.activeConnections == activeConnections)&&(identical(other.openRooms, openRooms) || other.openRooms == openRooms)&&(identical(other.activeUsers, activeUsers) || other.activeUsers == activeUsers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hub,activeConnections,openRooms,activeUsers);

@override
String toString() {
  return 'AdminRealtimeHubResponse(hub: $hub, activeConnections: $activeConnections, openRooms: $openRooms, activeUsers: $activeUsers)';
}


}

/// @nodoc
abstract mixin class $AdminRealtimeHubResponseCopyWith<$Res>  {
  factory $AdminRealtimeHubResponseCopyWith(AdminRealtimeHubResponse value, $Res Function(AdminRealtimeHubResponse) _then) = _$AdminRealtimeHubResponseCopyWithImpl;
@useResult
$Res call({
 String hub, int activeConnections, int openRooms, int activeUsers
});




}
/// @nodoc
class _$AdminRealtimeHubResponseCopyWithImpl<$Res>
    implements $AdminRealtimeHubResponseCopyWith<$Res> {
  _$AdminRealtimeHubResponseCopyWithImpl(this._self, this._then);

  final AdminRealtimeHubResponse _self;
  final $Res Function(AdminRealtimeHubResponse) _then;

/// Create a copy of AdminRealtimeHubResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hub = null,Object? activeConnections = null,Object? openRooms = null,Object? activeUsers = null,}) {
  return _then(_self.copyWith(
hub: null == hub ? _self.hub : hub // ignore: cast_nullable_to_non_nullable
as String,activeConnections: null == activeConnections ? _self.activeConnections : activeConnections // ignore: cast_nullable_to_non_nullable
as int,openRooms: null == openRooms ? _self.openRooms : openRooms // ignore: cast_nullable_to_non_nullable
as int,activeUsers: null == activeUsers ? _self.activeUsers : activeUsers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminRealtimeHubResponse].
extension AdminRealtimeHubResponsePatterns on AdminRealtimeHubResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRealtimeHubResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRealtimeHubResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRealtimeHubResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminRealtimeHubResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRealtimeHubResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRealtimeHubResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hub,  int activeConnections,  int openRooms,  int activeUsers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRealtimeHubResponse() when $default != null:
return $default(_that.hub,_that.activeConnections,_that.openRooms,_that.activeUsers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hub,  int activeConnections,  int openRooms,  int activeUsers)  $default,) {final _that = this;
switch (_that) {
case _AdminRealtimeHubResponse():
return $default(_that.hub,_that.activeConnections,_that.openRooms,_that.activeUsers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hub,  int activeConnections,  int openRooms,  int activeUsers)?  $default,) {final _that = this;
switch (_that) {
case _AdminRealtimeHubResponse() when $default != null:
return $default(_that.hub,_that.activeConnections,_that.openRooms,_that.activeUsers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRealtimeHubResponse implements AdminRealtimeHubResponse {
  const _AdminRealtimeHubResponse({required this.hub, required this.activeConnections, required this.openRooms, required this.activeUsers});
  factory _AdminRealtimeHubResponse.fromJson(Map<String, dynamic> json) => _$AdminRealtimeHubResponseFromJson(json);

@override final  String hub;
@override final  int activeConnections;
@override final  int openRooms;
@override final  int activeUsers;

/// Create a copy of AdminRealtimeHubResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRealtimeHubResponseCopyWith<_AdminRealtimeHubResponse> get copyWith => __$AdminRealtimeHubResponseCopyWithImpl<_AdminRealtimeHubResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRealtimeHubResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRealtimeHubResponse&&(identical(other.hub, hub) || other.hub == hub)&&(identical(other.activeConnections, activeConnections) || other.activeConnections == activeConnections)&&(identical(other.openRooms, openRooms) || other.openRooms == openRooms)&&(identical(other.activeUsers, activeUsers) || other.activeUsers == activeUsers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hub,activeConnections,openRooms,activeUsers);

@override
String toString() {
  return 'AdminRealtimeHubResponse(hub: $hub, activeConnections: $activeConnections, openRooms: $openRooms, activeUsers: $activeUsers)';
}


}

/// @nodoc
abstract mixin class _$AdminRealtimeHubResponseCopyWith<$Res> implements $AdminRealtimeHubResponseCopyWith<$Res> {
  factory _$AdminRealtimeHubResponseCopyWith(_AdminRealtimeHubResponse value, $Res Function(_AdminRealtimeHubResponse) _then) = __$AdminRealtimeHubResponseCopyWithImpl;
@override @useResult
$Res call({
 String hub, int activeConnections, int openRooms, int activeUsers
});




}
/// @nodoc
class __$AdminRealtimeHubResponseCopyWithImpl<$Res>
    implements _$AdminRealtimeHubResponseCopyWith<$Res> {
  __$AdminRealtimeHubResponseCopyWithImpl(this._self, this._then);

  final _AdminRealtimeHubResponse _self;
  final $Res Function(_AdminRealtimeHubResponse) _then;

/// Create a copy of AdminRealtimeHubResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hub = null,Object? activeConnections = null,Object? openRooms = null,Object? activeUsers = null,}) {
  return _then(_AdminRealtimeHubResponse(
hub: null == hub ? _self.hub : hub // ignore: cast_nullable_to_non_nullable
as String,activeConnections: null == activeConnections ? _self.activeConnections : activeConnections // ignore: cast_nullable_to_non_nullable
as int,openRooms: null == openRooms ? _self.openRooms : openRooms // ignore: cast_nullable_to_non_nullable
as int,activeUsers: null == activeUsers ? _self.activeUsers : activeUsers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AdminRealtimeInspectorResponse {

 DateTime get generatedAtUtc; List<AdminRealtimeHubResponse> get hubs; int get pendingOutbox; bool get redisConfigured;
/// Create a copy of AdminRealtimeInspectorResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRealtimeInspectorResponseCopyWith<AdminRealtimeInspectorResponse> get copyWith => _$AdminRealtimeInspectorResponseCopyWithImpl<AdminRealtimeInspectorResponse>(this as AdminRealtimeInspectorResponse, _$identity);

  /// Serializes this AdminRealtimeInspectorResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRealtimeInspectorResponse&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&const DeepCollectionEquality().equals(other.hubs, hubs)&&(identical(other.pendingOutbox, pendingOutbox) || other.pendingOutbox == pendingOutbox)&&(identical(other.redisConfigured, redisConfigured) || other.redisConfigured == redisConfigured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAtUtc,const DeepCollectionEquality().hash(hubs),pendingOutbox,redisConfigured);

@override
String toString() {
  return 'AdminRealtimeInspectorResponse(generatedAtUtc: $generatedAtUtc, hubs: $hubs, pendingOutbox: $pendingOutbox, redisConfigured: $redisConfigured)';
}


}

/// @nodoc
abstract mixin class $AdminRealtimeInspectorResponseCopyWith<$Res>  {
  factory $AdminRealtimeInspectorResponseCopyWith(AdminRealtimeInspectorResponse value, $Res Function(AdminRealtimeInspectorResponse) _then) = _$AdminRealtimeInspectorResponseCopyWithImpl;
@useResult
$Res call({
 DateTime generatedAtUtc, List<AdminRealtimeHubResponse> hubs, int pendingOutbox, bool redisConfigured
});




}
/// @nodoc
class _$AdminRealtimeInspectorResponseCopyWithImpl<$Res>
    implements $AdminRealtimeInspectorResponseCopyWith<$Res> {
  _$AdminRealtimeInspectorResponseCopyWithImpl(this._self, this._then);

  final AdminRealtimeInspectorResponse _self;
  final $Res Function(AdminRealtimeInspectorResponse) _then;

/// Create a copy of AdminRealtimeInspectorResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generatedAtUtc = null,Object? hubs = null,Object? pendingOutbox = null,Object? redisConfigured = null,}) {
  return _then(_self.copyWith(
generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,hubs: null == hubs ? _self.hubs : hubs // ignore: cast_nullable_to_non_nullable
as List<AdminRealtimeHubResponse>,pendingOutbox: null == pendingOutbox ? _self.pendingOutbox : pendingOutbox // ignore: cast_nullable_to_non_nullable
as int,redisConfigured: null == redisConfigured ? _self.redisConfigured : redisConfigured // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminRealtimeInspectorResponse].
extension AdminRealtimeInspectorResponsePatterns on AdminRealtimeInspectorResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRealtimeInspectorResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRealtimeInspectorResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRealtimeInspectorResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminRealtimeInspectorResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRealtimeInspectorResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRealtimeInspectorResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime generatedAtUtc,  List<AdminRealtimeHubResponse> hubs,  int pendingOutbox,  bool redisConfigured)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRealtimeInspectorResponse() when $default != null:
return $default(_that.generatedAtUtc,_that.hubs,_that.pendingOutbox,_that.redisConfigured);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime generatedAtUtc,  List<AdminRealtimeHubResponse> hubs,  int pendingOutbox,  bool redisConfigured)  $default,) {final _that = this;
switch (_that) {
case _AdminRealtimeInspectorResponse():
return $default(_that.generatedAtUtc,_that.hubs,_that.pendingOutbox,_that.redisConfigured);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime generatedAtUtc,  List<AdminRealtimeHubResponse> hubs,  int pendingOutbox,  bool redisConfigured)?  $default,) {final _that = this;
switch (_that) {
case _AdminRealtimeInspectorResponse() when $default != null:
return $default(_that.generatedAtUtc,_that.hubs,_that.pendingOutbox,_that.redisConfigured);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRealtimeInspectorResponse implements AdminRealtimeInspectorResponse {
  const _AdminRealtimeInspectorResponse({required this.generatedAtUtc, required this.hubs, required this.pendingOutbox, required this.redisConfigured});
  factory _AdminRealtimeInspectorResponse.fromJson(Map<String, dynamic> json) => _$AdminRealtimeInspectorResponseFromJson(json);

@override final  DateTime generatedAtUtc;
@override final  List<AdminRealtimeHubResponse> hubs;
@override final  int pendingOutbox;
@override final  bool redisConfigured;

/// Create a copy of AdminRealtimeInspectorResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRealtimeInspectorResponseCopyWith<_AdminRealtimeInspectorResponse> get copyWith => __$AdminRealtimeInspectorResponseCopyWithImpl<_AdminRealtimeInspectorResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRealtimeInspectorResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRealtimeInspectorResponse&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&const DeepCollectionEquality().equals(other.hubs, hubs)&&(identical(other.pendingOutbox, pendingOutbox) || other.pendingOutbox == pendingOutbox)&&(identical(other.redisConfigured, redisConfigured) || other.redisConfigured == redisConfigured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAtUtc,const DeepCollectionEquality().hash(hubs),pendingOutbox,redisConfigured);

@override
String toString() {
  return 'AdminRealtimeInspectorResponse(generatedAtUtc: $generatedAtUtc, hubs: $hubs, pendingOutbox: $pendingOutbox, redisConfigured: $redisConfigured)';
}


}

/// @nodoc
abstract mixin class _$AdminRealtimeInspectorResponseCopyWith<$Res> implements $AdminRealtimeInspectorResponseCopyWith<$Res> {
  factory _$AdminRealtimeInspectorResponseCopyWith(_AdminRealtimeInspectorResponse value, $Res Function(_AdminRealtimeInspectorResponse) _then) = __$AdminRealtimeInspectorResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime generatedAtUtc, List<AdminRealtimeHubResponse> hubs, int pendingOutbox, bool redisConfigured
});




}
/// @nodoc
class __$AdminRealtimeInspectorResponseCopyWithImpl<$Res>
    implements _$AdminRealtimeInspectorResponseCopyWith<$Res> {
  __$AdminRealtimeInspectorResponseCopyWithImpl(this._self, this._then);

  final _AdminRealtimeInspectorResponse _self;
  final $Res Function(_AdminRealtimeInspectorResponse) _then;

/// Create a copy of AdminRealtimeInspectorResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatedAtUtc = null,Object? hubs = null,Object? pendingOutbox = null,Object? redisConfigured = null,}) {
  return _then(_AdminRealtimeInspectorResponse(
generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,hubs: null == hubs ? _self.hubs : hubs // ignore: cast_nullable_to_non_nullable
as List<AdminRealtimeHubResponse>,pendingOutbox: null == pendingOutbox ? _self.pendingOutbox : pendingOutbox // ignore: cast_nullable_to_non_nullable
as int,redisConfigured: null == redisConfigured ? _self.redisConfigured : redisConfigured // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WorkerHeartbeatResponse {

 String get workerName; DateTime get lastBeatAtUtc; DateTime? get lastErrorAtUtc; String? get lastError; int get processedItems; int get pendingQueueSize; int get deadLetterCount; bool get healthy;
/// Create a copy of WorkerHeartbeatResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerHeartbeatResponseCopyWith<WorkerHeartbeatResponse> get copyWith => _$WorkerHeartbeatResponseCopyWithImpl<WorkerHeartbeatResponse>(this as WorkerHeartbeatResponse, _$identity);

  /// Serializes this WorkerHeartbeatResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerHeartbeatResponse&&(identical(other.workerName, workerName) || other.workerName == workerName)&&(identical(other.lastBeatAtUtc, lastBeatAtUtc) || other.lastBeatAtUtc == lastBeatAtUtc)&&(identical(other.lastErrorAtUtc, lastErrorAtUtc) || other.lastErrorAtUtc == lastErrorAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.processedItems, processedItems) || other.processedItems == processedItems)&&(identical(other.pendingQueueSize, pendingQueueSize) || other.pendingQueueSize == pendingQueueSize)&&(identical(other.deadLetterCount, deadLetterCount) || other.deadLetterCount == deadLetterCount)&&(identical(other.healthy, healthy) || other.healthy == healthy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workerName,lastBeatAtUtc,lastErrorAtUtc,lastError,processedItems,pendingQueueSize,deadLetterCount,healthy);

@override
String toString() {
  return 'WorkerHeartbeatResponse(workerName: $workerName, lastBeatAtUtc: $lastBeatAtUtc, lastErrorAtUtc: $lastErrorAtUtc, lastError: $lastError, processedItems: $processedItems, pendingQueueSize: $pendingQueueSize, deadLetterCount: $deadLetterCount, healthy: $healthy)';
}


}

/// @nodoc
abstract mixin class $WorkerHeartbeatResponseCopyWith<$Res>  {
  factory $WorkerHeartbeatResponseCopyWith(WorkerHeartbeatResponse value, $Res Function(WorkerHeartbeatResponse) _then) = _$WorkerHeartbeatResponseCopyWithImpl;
@useResult
$Res call({
 String workerName, DateTime lastBeatAtUtc, DateTime? lastErrorAtUtc, String? lastError, int processedItems, int pendingQueueSize, int deadLetterCount, bool healthy
});




}
/// @nodoc
class _$WorkerHeartbeatResponseCopyWithImpl<$Res>
    implements $WorkerHeartbeatResponseCopyWith<$Res> {
  _$WorkerHeartbeatResponseCopyWithImpl(this._self, this._then);

  final WorkerHeartbeatResponse _self;
  final $Res Function(WorkerHeartbeatResponse) _then;

/// Create a copy of WorkerHeartbeatResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workerName = null,Object? lastBeatAtUtc = null,Object? lastErrorAtUtc = freezed,Object? lastError = freezed,Object? processedItems = null,Object? pendingQueueSize = null,Object? deadLetterCount = null,Object? healthy = null,}) {
  return _then(_self.copyWith(
workerName: null == workerName ? _self.workerName : workerName // ignore: cast_nullable_to_non_nullable
as String,lastBeatAtUtc: null == lastBeatAtUtc ? _self.lastBeatAtUtc : lastBeatAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lastErrorAtUtc: freezed == lastErrorAtUtc ? _self.lastErrorAtUtc : lastErrorAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,processedItems: null == processedItems ? _self.processedItems : processedItems // ignore: cast_nullable_to_non_nullable
as int,pendingQueueSize: null == pendingQueueSize ? _self.pendingQueueSize : pendingQueueSize // ignore: cast_nullable_to_non_nullable
as int,deadLetterCount: null == deadLetterCount ? _self.deadLetterCount : deadLetterCount // ignore: cast_nullable_to_non_nullable
as int,healthy: null == healthy ? _self.healthy : healthy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerHeartbeatResponse].
extension WorkerHeartbeatResponsePatterns on WorkerHeartbeatResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerHeartbeatResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerHeartbeatResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerHeartbeatResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkerHeartbeatResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerHeartbeatResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerHeartbeatResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workerName,  DateTime lastBeatAtUtc,  DateTime? lastErrorAtUtc,  String? lastError,  int processedItems,  int pendingQueueSize,  int deadLetterCount,  bool healthy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerHeartbeatResponse() when $default != null:
return $default(_that.workerName,_that.lastBeatAtUtc,_that.lastErrorAtUtc,_that.lastError,_that.processedItems,_that.pendingQueueSize,_that.deadLetterCount,_that.healthy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workerName,  DateTime lastBeatAtUtc,  DateTime? lastErrorAtUtc,  String? lastError,  int processedItems,  int pendingQueueSize,  int deadLetterCount,  bool healthy)  $default,) {final _that = this;
switch (_that) {
case _WorkerHeartbeatResponse():
return $default(_that.workerName,_that.lastBeatAtUtc,_that.lastErrorAtUtc,_that.lastError,_that.processedItems,_that.pendingQueueSize,_that.deadLetterCount,_that.healthy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workerName,  DateTime lastBeatAtUtc,  DateTime? lastErrorAtUtc,  String? lastError,  int processedItems,  int pendingQueueSize,  int deadLetterCount,  bool healthy)?  $default,) {final _that = this;
switch (_that) {
case _WorkerHeartbeatResponse() when $default != null:
return $default(_that.workerName,_that.lastBeatAtUtc,_that.lastErrorAtUtc,_that.lastError,_that.processedItems,_that.pendingQueueSize,_that.deadLetterCount,_that.healthy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerHeartbeatResponse implements WorkerHeartbeatResponse {
  const _WorkerHeartbeatResponse({required this.workerName, required this.lastBeatAtUtc, this.lastErrorAtUtc, this.lastError, required this.processedItems, required this.pendingQueueSize, required this.deadLetterCount, required this.healthy});
  factory _WorkerHeartbeatResponse.fromJson(Map<String, dynamic> json) => _$WorkerHeartbeatResponseFromJson(json);

@override final  String workerName;
@override final  DateTime lastBeatAtUtc;
@override final  DateTime? lastErrorAtUtc;
@override final  String? lastError;
@override final  int processedItems;
@override final  int pendingQueueSize;
@override final  int deadLetterCount;
@override final  bool healthy;

/// Create a copy of WorkerHeartbeatResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerHeartbeatResponseCopyWith<_WorkerHeartbeatResponse> get copyWith => __$WorkerHeartbeatResponseCopyWithImpl<_WorkerHeartbeatResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerHeartbeatResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerHeartbeatResponse&&(identical(other.workerName, workerName) || other.workerName == workerName)&&(identical(other.lastBeatAtUtc, lastBeatAtUtc) || other.lastBeatAtUtc == lastBeatAtUtc)&&(identical(other.lastErrorAtUtc, lastErrorAtUtc) || other.lastErrorAtUtc == lastErrorAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.processedItems, processedItems) || other.processedItems == processedItems)&&(identical(other.pendingQueueSize, pendingQueueSize) || other.pendingQueueSize == pendingQueueSize)&&(identical(other.deadLetterCount, deadLetterCount) || other.deadLetterCount == deadLetterCount)&&(identical(other.healthy, healthy) || other.healthy == healthy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workerName,lastBeatAtUtc,lastErrorAtUtc,lastError,processedItems,pendingQueueSize,deadLetterCount,healthy);

@override
String toString() {
  return 'WorkerHeartbeatResponse(workerName: $workerName, lastBeatAtUtc: $lastBeatAtUtc, lastErrorAtUtc: $lastErrorAtUtc, lastError: $lastError, processedItems: $processedItems, pendingQueueSize: $pendingQueueSize, deadLetterCount: $deadLetterCount, healthy: $healthy)';
}


}

/// @nodoc
abstract mixin class _$WorkerHeartbeatResponseCopyWith<$Res> implements $WorkerHeartbeatResponseCopyWith<$Res> {
  factory _$WorkerHeartbeatResponseCopyWith(_WorkerHeartbeatResponse value, $Res Function(_WorkerHeartbeatResponse) _then) = __$WorkerHeartbeatResponseCopyWithImpl;
@override @useResult
$Res call({
 String workerName, DateTime lastBeatAtUtc, DateTime? lastErrorAtUtc, String? lastError, int processedItems, int pendingQueueSize, int deadLetterCount, bool healthy
});




}
/// @nodoc
class __$WorkerHeartbeatResponseCopyWithImpl<$Res>
    implements _$WorkerHeartbeatResponseCopyWith<$Res> {
  __$WorkerHeartbeatResponseCopyWithImpl(this._self, this._then);

  final _WorkerHeartbeatResponse _self;
  final $Res Function(_WorkerHeartbeatResponse) _then;

/// Create a copy of WorkerHeartbeatResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workerName = null,Object? lastBeatAtUtc = null,Object? lastErrorAtUtc = freezed,Object? lastError = freezed,Object? processedItems = null,Object? pendingQueueSize = null,Object? deadLetterCount = null,Object? healthy = null,}) {
  return _then(_WorkerHeartbeatResponse(
workerName: null == workerName ? _self.workerName : workerName // ignore: cast_nullable_to_non_nullable
as String,lastBeatAtUtc: null == lastBeatAtUtc ? _self.lastBeatAtUtc : lastBeatAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lastErrorAtUtc: freezed == lastErrorAtUtc ? _self.lastErrorAtUtc : lastErrorAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,processedItems: null == processedItems ? _self.processedItems : processedItems // ignore: cast_nullable_to_non_nullable
as int,pendingQueueSize: null == pendingQueueSize ? _self.pendingQueueSize : pendingQueueSize // ignore: cast_nullable_to_non_nullable
as int,deadLetterCount: null == deadLetterCount ? _self.deadLetterCount : deadLetterCount // ignore: cast_nullable_to_non_nullable
as int,healthy: null == healthy ? _self.healthy : healthy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AdminIntegrationHealthResponse {

 String get name; bool get configured; bool get reachable; int get latencyMilliseconds; String? get detail; double? get databaseSizeMb; int? get activeConnections; int? get idleConnections; int? get maxConnections; int? get slowQueries; int? get deadlocks; int? get successfulRequestsLastHour; int? get failedRequestsLastHour; int? get activeSessions;
/// Create a copy of AdminIntegrationHealthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminIntegrationHealthResponseCopyWith<AdminIntegrationHealthResponse> get copyWith => _$AdminIntegrationHealthResponseCopyWithImpl<AdminIntegrationHealthResponse>(this as AdminIntegrationHealthResponse, _$identity);

  /// Serializes this AdminIntegrationHealthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminIntegrationHealthResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.configured, configured) || other.configured == configured)&&(identical(other.reachable, reachable) || other.reachable == reachable)&&(identical(other.latencyMilliseconds, latencyMilliseconds) || other.latencyMilliseconds == latencyMilliseconds)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.databaseSizeMb, databaseSizeMb) || other.databaseSizeMb == databaseSizeMb)&&(identical(other.activeConnections, activeConnections) || other.activeConnections == activeConnections)&&(identical(other.idleConnections, idleConnections) || other.idleConnections == idleConnections)&&(identical(other.maxConnections, maxConnections) || other.maxConnections == maxConnections)&&(identical(other.slowQueries, slowQueries) || other.slowQueries == slowQueries)&&(identical(other.deadlocks, deadlocks) || other.deadlocks == deadlocks)&&(identical(other.successfulRequestsLastHour, successfulRequestsLastHour) || other.successfulRequestsLastHour == successfulRequestsLastHour)&&(identical(other.failedRequestsLastHour, failedRequestsLastHour) || other.failedRequestsLastHour == failedRequestsLastHour)&&(identical(other.activeSessions, activeSessions) || other.activeSessions == activeSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,configured,reachable,latencyMilliseconds,detail,databaseSizeMb,activeConnections,idleConnections,maxConnections,slowQueries,deadlocks,successfulRequestsLastHour,failedRequestsLastHour,activeSessions);

@override
String toString() {
  return 'AdminIntegrationHealthResponse(name: $name, configured: $configured, reachable: $reachable, latencyMilliseconds: $latencyMilliseconds, detail: $detail, databaseSizeMb: $databaseSizeMb, activeConnections: $activeConnections, idleConnections: $idleConnections, maxConnections: $maxConnections, slowQueries: $slowQueries, deadlocks: $deadlocks, successfulRequestsLastHour: $successfulRequestsLastHour, failedRequestsLastHour: $failedRequestsLastHour, activeSessions: $activeSessions)';
}


}

/// @nodoc
abstract mixin class $AdminIntegrationHealthResponseCopyWith<$Res>  {
  factory $AdminIntegrationHealthResponseCopyWith(AdminIntegrationHealthResponse value, $Res Function(AdminIntegrationHealthResponse) _then) = _$AdminIntegrationHealthResponseCopyWithImpl;
@useResult
$Res call({
 String name, bool configured, bool reachable, int latencyMilliseconds, String? detail, double? databaseSizeMb, int? activeConnections, int? idleConnections, int? maxConnections, int? slowQueries, int? deadlocks, int? successfulRequestsLastHour, int? failedRequestsLastHour, int? activeSessions
});




}
/// @nodoc
class _$AdminIntegrationHealthResponseCopyWithImpl<$Res>
    implements $AdminIntegrationHealthResponseCopyWith<$Res> {
  _$AdminIntegrationHealthResponseCopyWithImpl(this._self, this._then);

  final AdminIntegrationHealthResponse _self;
  final $Res Function(AdminIntegrationHealthResponse) _then;

/// Create a copy of AdminIntegrationHealthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? configured = null,Object? reachable = null,Object? latencyMilliseconds = null,Object? detail = freezed,Object? databaseSizeMb = freezed,Object? activeConnections = freezed,Object? idleConnections = freezed,Object? maxConnections = freezed,Object? slowQueries = freezed,Object? deadlocks = freezed,Object? successfulRequestsLastHour = freezed,Object? failedRequestsLastHour = freezed,Object? activeSessions = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,configured: null == configured ? _self.configured : configured // ignore: cast_nullable_to_non_nullable
as bool,reachable: null == reachable ? _self.reachable : reachable // ignore: cast_nullable_to_non_nullable
as bool,latencyMilliseconds: null == latencyMilliseconds ? _self.latencyMilliseconds : latencyMilliseconds // ignore: cast_nullable_to_non_nullable
as int,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,databaseSizeMb: freezed == databaseSizeMb ? _self.databaseSizeMb : databaseSizeMb // ignore: cast_nullable_to_non_nullable
as double?,activeConnections: freezed == activeConnections ? _self.activeConnections : activeConnections // ignore: cast_nullable_to_non_nullable
as int?,idleConnections: freezed == idleConnections ? _self.idleConnections : idleConnections // ignore: cast_nullable_to_non_nullable
as int?,maxConnections: freezed == maxConnections ? _self.maxConnections : maxConnections // ignore: cast_nullable_to_non_nullable
as int?,slowQueries: freezed == slowQueries ? _self.slowQueries : slowQueries // ignore: cast_nullable_to_non_nullable
as int?,deadlocks: freezed == deadlocks ? _self.deadlocks : deadlocks // ignore: cast_nullable_to_non_nullable
as int?,successfulRequestsLastHour: freezed == successfulRequestsLastHour ? _self.successfulRequestsLastHour : successfulRequestsLastHour // ignore: cast_nullable_to_non_nullable
as int?,failedRequestsLastHour: freezed == failedRequestsLastHour ? _self.failedRequestsLastHour : failedRequestsLastHour // ignore: cast_nullable_to_non_nullable
as int?,activeSessions: freezed == activeSessions ? _self.activeSessions : activeSessions // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminIntegrationHealthResponse].
extension AdminIntegrationHealthResponsePatterns on AdminIntegrationHealthResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminIntegrationHealthResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminIntegrationHealthResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminIntegrationHealthResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminIntegrationHealthResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminIntegrationHealthResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminIntegrationHealthResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool configured,  bool reachable,  int latencyMilliseconds,  String? detail,  double? databaseSizeMb,  int? activeConnections,  int? idleConnections,  int? maxConnections,  int? slowQueries,  int? deadlocks,  int? successfulRequestsLastHour,  int? failedRequestsLastHour,  int? activeSessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminIntegrationHealthResponse() when $default != null:
return $default(_that.name,_that.configured,_that.reachable,_that.latencyMilliseconds,_that.detail,_that.databaseSizeMb,_that.activeConnections,_that.idleConnections,_that.maxConnections,_that.slowQueries,_that.deadlocks,_that.successfulRequestsLastHour,_that.failedRequestsLastHour,_that.activeSessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool configured,  bool reachable,  int latencyMilliseconds,  String? detail,  double? databaseSizeMb,  int? activeConnections,  int? idleConnections,  int? maxConnections,  int? slowQueries,  int? deadlocks,  int? successfulRequestsLastHour,  int? failedRequestsLastHour,  int? activeSessions)  $default,) {final _that = this;
switch (_that) {
case _AdminIntegrationHealthResponse():
return $default(_that.name,_that.configured,_that.reachable,_that.latencyMilliseconds,_that.detail,_that.databaseSizeMb,_that.activeConnections,_that.idleConnections,_that.maxConnections,_that.slowQueries,_that.deadlocks,_that.successfulRequestsLastHour,_that.failedRequestsLastHour,_that.activeSessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool configured,  bool reachable,  int latencyMilliseconds,  String? detail,  double? databaseSizeMb,  int? activeConnections,  int? idleConnections,  int? maxConnections,  int? slowQueries,  int? deadlocks,  int? successfulRequestsLastHour,  int? failedRequestsLastHour,  int? activeSessions)?  $default,) {final _that = this;
switch (_that) {
case _AdminIntegrationHealthResponse() when $default != null:
return $default(_that.name,_that.configured,_that.reachable,_that.latencyMilliseconds,_that.detail,_that.databaseSizeMb,_that.activeConnections,_that.idleConnections,_that.maxConnections,_that.slowQueries,_that.deadlocks,_that.successfulRequestsLastHour,_that.failedRequestsLastHour,_that.activeSessions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminIntegrationHealthResponse implements AdminIntegrationHealthResponse {
  const _AdminIntegrationHealthResponse({required this.name, required this.configured, required this.reachable, required this.latencyMilliseconds, this.detail, this.databaseSizeMb, this.activeConnections, this.idleConnections, this.maxConnections, this.slowQueries, this.deadlocks, this.successfulRequestsLastHour, this.failedRequestsLastHour, this.activeSessions});
  factory _AdminIntegrationHealthResponse.fromJson(Map<String, dynamic> json) => _$AdminIntegrationHealthResponseFromJson(json);

@override final  String name;
@override final  bool configured;
@override final  bool reachable;
@override final  int latencyMilliseconds;
@override final  String? detail;
@override final  double? databaseSizeMb;
@override final  int? activeConnections;
@override final  int? idleConnections;
@override final  int? maxConnections;
@override final  int? slowQueries;
@override final  int? deadlocks;
@override final  int? successfulRequestsLastHour;
@override final  int? failedRequestsLastHour;
@override final  int? activeSessions;

/// Create a copy of AdminIntegrationHealthResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminIntegrationHealthResponseCopyWith<_AdminIntegrationHealthResponse> get copyWith => __$AdminIntegrationHealthResponseCopyWithImpl<_AdminIntegrationHealthResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminIntegrationHealthResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminIntegrationHealthResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.configured, configured) || other.configured == configured)&&(identical(other.reachable, reachable) || other.reachable == reachable)&&(identical(other.latencyMilliseconds, latencyMilliseconds) || other.latencyMilliseconds == latencyMilliseconds)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.databaseSizeMb, databaseSizeMb) || other.databaseSizeMb == databaseSizeMb)&&(identical(other.activeConnections, activeConnections) || other.activeConnections == activeConnections)&&(identical(other.idleConnections, idleConnections) || other.idleConnections == idleConnections)&&(identical(other.maxConnections, maxConnections) || other.maxConnections == maxConnections)&&(identical(other.slowQueries, slowQueries) || other.slowQueries == slowQueries)&&(identical(other.deadlocks, deadlocks) || other.deadlocks == deadlocks)&&(identical(other.successfulRequestsLastHour, successfulRequestsLastHour) || other.successfulRequestsLastHour == successfulRequestsLastHour)&&(identical(other.failedRequestsLastHour, failedRequestsLastHour) || other.failedRequestsLastHour == failedRequestsLastHour)&&(identical(other.activeSessions, activeSessions) || other.activeSessions == activeSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,configured,reachable,latencyMilliseconds,detail,databaseSizeMb,activeConnections,idleConnections,maxConnections,slowQueries,deadlocks,successfulRequestsLastHour,failedRequestsLastHour,activeSessions);

@override
String toString() {
  return 'AdminIntegrationHealthResponse(name: $name, configured: $configured, reachable: $reachable, latencyMilliseconds: $latencyMilliseconds, detail: $detail, databaseSizeMb: $databaseSizeMb, activeConnections: $activeConnections, idleConnections: $idleConnections, maxConnections: $maxConnections, slowQueries: $slowQueries, deadlocks: $deadlocks, successfulRequestsLastHour: $successfulRequestsLastHour, failedRequestsLastHour: $failedRequestsLastHour, activeSessions: $activeSessions)';
}


}

/// @nodoc
abstract mixin class _$AdminIntegrationHealthResponseCopyWith<$Res> implements $AdminIntegrationHealthResponseCopyWith<$Res> {
  factory _$AdminIntegrationHealthResponseCopyWith(_AdminIntegrationHealthResponse value, $Res Function(_AdminIntegrationHealthResponse) _then) = __$AdminIntegrationHealthResponseCopyWithImpl;
@override @useResult
$Res call({
 String name, bool configured, bool reachable, int latencyMilliseconds, String? detail, double? databaseSizeMb, int? activeConnections, int? idleConnections, int? maxConnections, int? slowQueries, int? deadlocks, int? successfulRequestsLastHour, int? failedRequestsLastHour, int? activeSessions
});




}
/// @nodoc
class __$AdminIntegrationHealthResponseCopyWithImpl<$Res>
    implements _$AdminIntegrationHealthResponseCopyWith<$Res> {
  __$AdminIntegrationHealthResponseCopyWithImpl(this._self, this._then);

  final _AdminIntegrationHealthResponse _self;
  final $Res Function(_AdminIntegrationHealthResponse) _then;

/// Create a copy of AdminIntegrationHealthResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? configured = null,Object? reachable = null,Object? latencyMilliseconds = null,Object? detail = freezed,Object? databaseSizeMb = freezed,Object? activeConnections = freezed,Object? idleConnections = freezed,Object? maxConnections = freezed,Object? slowQueries = freezed,Object? deadlocks = freezed,Object? successfulRequestsLastHour = freezed,Object? failedRequestsLastHour = freezed,Object? activeSessions = freezed,}) {
  return _then(_AdminIntegrationHealthResponse(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,configured: null == configured ? _self.configured : configured // ignore: cast_nullable_to_non_nullable
as bool,reachable: null == reachable ? _self.reachable : reachable // ignore: cast_nullable_to_non_nullable
as bool,latencyMilliseconds: null == latencyMilliseconds ? _self.latencyMilliseconds : latencyMilliseconds // ignore: cast_nullable_to_non_nullable
as int,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,databaseSizeMb: freezed == databaseSizeMb ? _self.databaseSizeMb : databaseSizeMb // ignore: cast_nullable_to_non_nullable
as double?,activeConnections: freezed == activeConnections ? _self.activeConnections : activeConnections // ignore: cast_nullable_to_non_nullable
as int?,idleConnections: freezed == idleConnections ? _self.idleConnections : idleConnections // ignore: cast_nullable_to_non_nullable
as int?,maxConnections: freezed == maxConnections ? _self.maxConnections : maxConnections // ignore: cast_nullable_to_non_nullable
as int?,slowQueries: freezed == slowQueries ? _self.slowQueries : slowQueries // ignore: cast_nullable_to_non_nullable
as int?,deadlocks: freezed == deadlocks ? _self.deadlocks : deadlocks // ignore: cast_nullable_to_non_nullable
as int?,successfulRequestsLastHour: freezed == successfulRequestsLastHour ? _self.successfulRequestsLastHour : successfulRequestsLastHour // ignore: cast_nullable_to_non_nullable
as int?,failedRequestsLastHour: freezed == failedRequestsLastHour ? _self.failedRequestsLastHour : failedRequestsLastHour // ignore: cast_nullable_to_non_nullable
as int?,activeSessions: freezed == activeSessions ? _self.activeSessions : activeSessions // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AdminIntegrationsResponse {

 DateTime get generatedAtUtc; AdminIntegrationHealthResponse get database; AdminIntegrationHealthResponse get redis; AdminIntegrationHealthResponse get onlyOffice; AdminIntegrationHealthResponse get aiProvider;
/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminIntegrationsResponseCopyWith<AdminIntegrationsResponse> get copyWith => _$AdminIntegrationsResponseCopyWithImpl<AdminIntegrationsResponse>(this as AdminIntegrationsResponse, _$identity);

  /// Serializes this AdminIntegrationsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminIntegrationsResponse&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&(identical(other.database, database) || other.database == database)&&(identical(other.redis, redis) || other.redis == redis)&&(identical(other.onlyOffice, onlyOffice) || other.onlyOffice == onlyOffice)&&(identical(other.aiProvider, aiProvider) || other.aiProvider == aiProvider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAtUtc,database,redis,onlyOffice,aiProvider);

@override
String toString() {
  return 'AdminIntegrationsResponse(generatedAtUtc: $generatedAtUtc, database: $database, redis: $redis, onlyOffice: $onlyOffice, aiProvider: $aiProvider)';
}


}

/// @nodoc
abstract mixin class $AdminIntegrationsResponseCopyWith<$Res>  {
  factory $AdminIntegrationsResponseCopyWith(AdminIntegrationsResponse value, $Res Function(AdminIntegrationsResponse) _then) = _$AdminIntegrationsResponseCopyWithImpl;
@useResult
$Res call({
 DateTime generatedAtUtc, AdminIntegrationHealthResponse database, AdminIntegrationHealthResponse redis, AdminIntegrationHealthResponse onlyOffice, AdminIntegrationHealthResponse aiProvider
});


$AdminIntegrationHealthResponseCopyWith<$Res> get database;$AdminIntegrationHealthResponseCopyWith<$Res> get redis;$AdminIntegrationHealthResponseCopyWith<$Res> get onlyOffice;$AdminIntegrationHealthResponseCopyWith<$Res> get aiProvider;

}
/// @nodoc
class _$AdminIntegrationsResponseCopyWithImpl<$Res>
    implements $AdminIntegrationsResponseCopyWith<$Res> {
  _$AdminIntegrationsResponseCopyWithImpl(this._self, this._then);

  final AdminIntegrationsResponse _self;
  final $Res Function(AdminIntegrationsResponse) _then;

/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generatedAtUtc = null,Object? database = null,Object? redis = null,Object? onlyOffice = null,Object? aiProvider = null,}) {
  return _then(_self.copyWith(
generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,database: null == database ? _self.database : database // ignore: cast_nullable_to_non_nullable
as AdminIntegrationHealthResponse,redis: null == redis ? _self.redis : redis // ignore: cast_nullable_to_non_nullable
as AdminIntegrationHealthResponse,onlyOffice: null == onlyOffice ? _self.onlyOffice : onlyOffice // ignore: cast_nullable_to_non_nullable
as AdminIntegrationHealthResponse,aiProvider: null == aiProvider ? _self.aiProvider : aiProvider // ignore: cast_nullable_to_non_nullable
as AdminIntegrationHealthResponse,
  ));
}
/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminIntegrationHealthResponseCopyWith<$Res> get database {
  
  return $AdminIntegrationHealthResponseCopyWith<$Res>(_self.database, (value) {
    return _then(_self.copyWith(database: value));
  });
}/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminIntegrationHealthResponseCopyWith<$Res> get redis {
  
  return $AdminIntegrationHealthResponseCopyWith<$Res>(_self.redis, (value) {
    return _then(_self.copyWith(redis: value));
  });
}/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminIntegrationHealthResponseCopyWith<$Res> get onlyOffice {
  
  return $AdminIntegrationHealthResponseCopyWith<$Res>(_self.onlyOffice, (value) {
    return _then(_self.copyWith(onlyOffice: value));
  });
}/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminIntegrationHealthResponseCopyWith<$Res> get aiProvider {
  
  return $AdminIntegrationHealthResponseCopyWith<$Res>(_self.aiProvider, (value) {
    return _then(_self.copyWith(aiProvider: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminIntegrationsResponse].
extension AdminIntegrationsResponsePatterns on AdminIntegrationsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminIntegrationsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminIntegrationsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminIntegrationsResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminIntegrationsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminIntegrationsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminIntegrationsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime generatedAtUtc,  AdminIntegrationHealthResponse database,  AdminIntegrationHealthResponse redis,  AdminIntegrationHealthResponse onlyOffice,  AdminIntegrationHealthResponse aiProvider)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminIntegrationsResponse() when $default != null:
return $default(_that.generatedAtUtc,_that.database,_that.redis,_that.onlyOffice,_that.aiProvider);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime generatedAtUtc,  AdminIntegrationHealthResponse database,  AdminIntegrationHealthResponse redis,  AdminIntegrationHealthResponse onlyOffice,  AdminIntegrationHealthResponse aiProvider)  $default,) {final _that = this;
switch (_that) {
case _AdminIntegrationsResponse():
return $default(_that.generatedAtUtc,_that.database,_that.redis,_that.onlyOffice,_that.aiProvider);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime generatedAtUtc,  AdminIntegrationHealthResponse database,  AdminIntegrationHealthResponse redis,  AdminIntegrationHealthResponse onlyOffice,  AdminIntegrationHealthResponse aiProvider)?  $default,) {final _that = this;
switch (_that) {
case _AdminIntegrationsResponse() when $default != null:
return $default(_that.generatedAtUtc,_that.database,_that.redis,_that.onlyOffice,_that.aiProvider);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminIntegrationsResponse implements AdminIntegrationsResponse {
  const _AdminIntegrationsResponse({required this.generatedAtUtc, required this.database, required this.redis, required this.onlyOffice, required this.aiProvider});
  factory _AdminIntegrationsResponse.fromJson(Map<String, dynamic> json) => _$AdminIntegrationsResponseFromJson(json);

@override final  DateTime generatedAtUtc;
@override final  AdminIntegrationHealthResponse database;
@override final  AdminIntegrationHealthResponse redis;
@override final  AdminIntegrationHealthResponse onlyOffice;
@override final  AdminIntegrationHealthResponse aiProvider;

/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminIntegrationsResponseCopyWith<_AdminIntegrationsResponse> get copyWith => __$AdminIntegrationsResponseCopyWithImpl<_AdminIntegrationsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminIntegrationsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminIntegrationsResponse&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&(identical(other.database, database) || other.database == database)&&(identical(other.redis, redis) || other.redis == redis)&&(identical(other.onlyOffice, onlyOffice) || other.onlyOffice == onlyOffice)&&(identical(other.aiProvider, aiProvider) || other.aiProvider == aiProvider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAtUtc,database,redis,onlyOffice,aiProvider);

@override
String toString() {
  return 'AdminIntegrationsResponse(generatedAtUtc: $generatedAtUtc, database: $database, redis: $redis, onlyOffice: $onlyOffice, aiProvider: $aiProvider)';
}


}

/// @nodoc
abstract mixin class _$AdminIntegrationsResponseCopyWith<$Res> implements $AdminIntegrationsResponseCopyWith<$Res> {
  factory _$AdminIntegrationsResponseCopyWith(_AdminIntegrationsResponse value, $Res Function(_AdminIntegrationsResponse) _then) = __$AdminIntegrationsResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime generatedAtUtc, AdminIntegrationHealthResponse database, AdminIntegrationHealthResponse redis, AdminIntegrationHealthResponse onlyOffice, AdminIntegrationHealthResponse aiProvider
});


@override $AdminIntegrationHealthResponseCopyWith<$Res> get database;@override $AdminIntegrationHealthResponseCopyWith<$Res> get redis;@override $AdminIntegrationHealthResponseCopyWith<$Res> get onlyOffice;@override $AdminIntegrationHealthResponseCopyWith<$Res> get aiProvider;

}
/// @nodoc
class __$AdminIntegrationsResponseCopyWithImpl<$Res>
    implements _$AdminIntegrationsResponseCopyWith<$Res> {
  __$AdminIntegrationsResponseCopyWithImpl(this._self, this._then);

  final _AdminIntegrationsResponse _self;
  final $Res Function(_AdminIntegrationsResponse) _then;

/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatedAtUtc = null,Object? database = null,Object? redis = null,Object? onlyOffice = null,Object? aiProvider = null,}) {
  return _then(_AdminIntegrationsResponse(
generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,database: null == database ? _self.database : database // ignore: cast_nullable_to_non_nullable
as AdminIntegrationHealthResponse,redis: null == redis ? _self.redis : redis // ignore: cast_nullable_to_non_nullable
as AdminIntegrationHealthResponse,onlyOffice: null == onlyOffice ? _self.onlyOffice : onlyOffice // ignore: cast_nullable_to_non_nullable
as AdminIntegrationHealthResponse,aiProvider: null == aiProvider ? _self.aiProvider : aiProvider // ignore: cast_nullable_to_non_nullable
as AdminIntegrationHealthResponse,
  ));
}

/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminIntegrationHealthResponseCopyWith<$Res> get database {
  
  return $AdminIntegrationHealthResponseCopyWith<$Res>(_self.database, (value) {
    return _then(_self.copyWith(database: value));
  });
}/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminIntegrationHealthResponseCopyWith<$Res> get redis {
  
  return $AdminIntegrationHealthResponseCopyWith<$Res>(_self.redis, (value) {
    return _then(_self.copyWith(redis: value));
  });
}/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminIntegrationHealthResponseCopyWith<$Res> get onlyOffice {
  
  return $AdminIntegrationHealthResponseCopyWith<$Res>(_self.onlyOffice, (value) {
    return _then(_self.copyWith(onlyOffice: value));
  });
}/// Create a copy of AdminIntegrationsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminIntegrationHealthResponseCopyWith<$Res> get aiProvider {
  
  return $AdminIntegrationHealthResponseCopyWith<$Res>(_self.aiProvider, (value) {
    return _then(_self.copyWith(aiProvider: value));
  });
}
}


/// @nodoc
mixin _$AdminOpsDashboardResponse {

 DateTime get generatedAtUtc; int get bufferedErrors; int get errorsLast24Hours; int get pendingRealtimeOutbox; int get activeStorageFiles; int get activeSignalRConnections; int get openRealtimeRooms; int get activeRealtimeUsers; bool get redisConfigured; bool get onlyOfficeConfigured; bool get aiConfigured; List<WorkerHeartbeatResponse> get workers;
/// Create a copy of AdminOpsDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOpsDashboardResponseCopyWith<AdminOpsDashboardResponse> get copyWith => _$AdminOpsDashboardResponseCopyWithImpl<AdminOpsDashboardResponse>(this as AdminOpsDashboardResponse, _$identity);

  /// Serializes this AdminOpsDashboardResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOpsDashboardResponse&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&(identical(other.bufferedErrors, bufferedErrors) || other.bufferedErrors == bufferedErrors)&&(identical(other.errorsLast24Hours, errorsLast24Hours) || other.errorsLast24Hours == errorsLast24Hours)&&(identical(other.pendingRealtimeOutbox, pendingRealtimeOutbox) || other.pendingRealtimeOutbox == pendingRealtimeOutbox)&&(identical(other.activeStorageFiles, activeStorageFiles) || other.activeStorageFiles == activeStorageFiles)&&(identical(other.activeSignalRConnections, activeSignalRConnections) || other.activeSignalRConnections == activeSignalRConnections)&&(identical(other.openRealtimeRooms, openRealtimeRooms) || other.openRealtimeRooms == openRealtimeRooms)&&(identical(other.activeRealtimeUsers, activeRealtimeUsers) || other.activeRealtimeUsers == activeRealtimeUsers)&&(identical(other.redisConfigured, redisConfigured) || other.redisConfigured == redisConfigured)&&(identical(other.onlyOfficeConfigured, onlyOfficeConfigured) || other.onlyOfficeConfigured == onlyOfficeConfigured)&&(identical(other.aiConfigured, aiConfigured) || other.aiConfigured == aiConfigured)&&const DeepCollectionEquality().equals(other.workers, workers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAtUtc,bufferedErrors,errorsLast24Hours,pendingRealtimeOutbox,activeStorageFiles,activeSignalRConnections,openRealtimeRooms,activeRealtimeUsers,redisConfigured,onlyOfficeConfigured,aiConfigured,const DeepCollectionEquality().hash(workers));

@override
String toString() {
  return 'AdminOpsDashboardResponse(generatedAtUtc: $generatedAtUtc, bufferedErrors: $bufferedErrors, errorsLast24Hours: $errorsLast24Hours, pendingRealtimeOutbox: $pendingRealtimeOutbox, activeStorageFiles: $activeStorageFiles, activeSignalRConnections: $activeSignalRConnections, openRealtimeRooms: $openRealtimeRooms, activeRealtimeUsers: $activeRealtimeUsers, redisConfigured: $redisConfigured, onlyOfficeConfigured: $onlyOfficeConfigured, aiConfigured: $aiConfigured, workers: $workers)';
}


}

/// @nodoc
abstract mixin class $AdminOpsDashboardResponseCopyWith<$Res>  {
  factory $AdminOpsDashboardResponseCopyWith(AdminOpsDashboardResponse value, $Res Function(AdminOpsDashboardResponse) _then) = _$AdminOpsDashboardResponseCopyWithImpl;
@useResult
$Res call({
 DateTime generatedAtUtc, int bufferedErrors, int errorsLast24Hours, int pendingRealtimeOutbox, int activeStorageFiles, int activeSignalRConnections, int openRealtimeRooms, int activeRealtimeUsers, bool redisConfigured, bool onlyOfficeConfigured, bool aiConfigured, List<WorkerHeartbeatResponse> workers
});




}
/// @nodoc
class _$AdminOpsDashboardResponseCopyWithImpl<$Res>
    implements $AdminOpsDashboardResponseCopyWith<$Res> {
  _$AdminOpsDashboardResponseCopyWithImpl(this._self, this._then);

  final AdminOpsDashboardResponse _self;
  final $Res Function(AdminOpsDashboardResponse) _then;

/// Create a copy of AdminOpsDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generatedAtUtc = null,Object? bufferedErrors = null,Object? errorsLast24Hours = null,Object? pendingRealtimeOutbox = null,Object? activeStorageFiles = null,Object? activeSignalRConnections = null,Object? openRealtimeRooms = null,Object? activeRealtimeUsers = null,Object? redisConfigured = null,Object? onlyOfficeConfigured = null,Object? aiConfigured = null,Object? workers = null,}) {
  return _then(_self.copyWith(
generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,bufferedErrors: null == bufferedErrors ? _self.bufferedErrors : bufferedErrors // ignore: cast_nullable_to_non_nullable
as int,errorsLast24Hours: null == errorsLast24Hours ? _self.errorsLast24Hours : errorsLast24Hours // ignore: cast_nullable_to_non_nullable
as int,pendingRealtimeOutbox: null == pendingRealtimeOutbox ? _self.pendingRealtimeOutbox : pendingRealtimeOutbox // ignore: cast_nullable_to_non_nullable
as int,activeStorageFiles: null == activeStorageFiles ? _self.activeStorageFiles : activeStorageFiles // ignore: cast_nullable_to_non_nullable
as int,activeSignalRConnections: null == activeSignalRConnections ? _self.activeSignalRConnections : activeSignalRConnections // ignore: cast_nullable_to_non_nullable
as int,openRealtimeRooms: null == openRealtimeRooms ? _self.openRealtimeRooms : openRealtimeRooms // ignore: cast_nullable_to_non_nullable
as int,activeRealtimeUsers: null == activeRealtimeUsers ? _self.activeRealtimeUsers : activeRealtimeUsers // ignore: cast_nullable_to_non_nullable
as int,redisConfigured: null == redisConfigured ? _self.redisConfigured : redisConfigured // ignore: cast_nullable_to_non_nullable
as bool,onlyOfficeConfigured: null == onlyOfficeConfigured ? _self.onlyOfficeConfigured : onlyOfficeConfigured // ignore: cast_nullable_to_non_nullable
as bool,aiConfigured: null == aiConfigured ? _self.aiConfigured : aiConfigured // ignore: cast_nullable_to_non_nullable
as bool,workers: null == workers ? _self.workers : workers // ignore: cast_nullable_to_non_nullable
as List<WorkerHeartbeatResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminOpsDashboardResponse].
extension AdminOpsDashboardResponsePatterns on AdminOpsDashboardResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminOpsDashboardResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminOpsDashboardResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminOpsDashboardResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminOpsDashboardResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminOpsDashboardResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminOpsDashboardResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime generatedAtUtc,  int bufferedErrors,  int errorsLast24Hours,  int pendingRealtimeOutbox,  int activeStorageFiles,  int activeSignalRConnections,  int openRealtimeRooms,  int activeRealtimeUsers,  bool redisConfigured,  bool onlyOfficeConfigured,  bool aiConfigured,  List<WorkerHeartbeatResponse> workers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminOpsDashboardResponse() when $default != null:
return $default(_that.generatedAtUtc,_that.bufferedErrors,_that.errorsLast24Hours,_that.pendingRealtimeOutbox,_that.activeStorageFiles,_that.activeSignalRConnections,_that.openRealtimeRooms,_that.activeRealtimeUsers,_that.redisConfigured,_that.onlyOfficeConfigured,_that.aiConfigured,_that.workers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime generatedAtUtc,  int bufferedErrors,  int errorsLast24Hours,  int pendingRealtimeOutbox,  int activeStorageFiles,  int activeSignalRConnections,  int openRealtimeRooms,  int activeRealtimeUsers,  bool redisConfigured,  bool onlyOfficeConfigured,  bool aiConfigured,  List<WorkerHeartbeatResponse> workers)  $default,) {final _that = this;
switch (_that) {
case _AdminOpsDashboardResponse():
return $default(_that.generatedAtUtc,_that.bufferedErrors,_that.errorsLast24Hours,_that.pendingRealtimeOutbox,_that.activeStorageFiles,_that.activeSignalRConnections,_that.openRealtimeRooms,_that.activeRealtimeUsers,_that.redisConfigured,_that.onlyOfficeConfigured,_that.aiConfigured,_that.workers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime generatedAtUtc,  int bufferedErrors,  int errorsLast24Hours,  int pendingRealtimeOutbox,  int activeStorageFiles,  int activeSignalRConnections,  int openRealtimeRooms,  int activeRealtimeUsers,  bool redisConfigured,  bool onlyOfficeConfigured,  bool aiConfigured,  List<WorkerHeartbeatResponse> workers)?  $default,) {final _that = this;
switch (_that) {
case _AdminOpsDashboardResponse() when $default != null:
return $default(_that.generatedAtUtc,_that.bufferedErrors,_that.errorsLast24Hours,_that.pendingRealtimeOutbox,_that.activeStorageFiles,_that.activeSignalRConnections,_that.openRealtimeRooms,_that.activeRealtimeUsers,_that.redisConfigured,_that.onlyOfficeConfigured,_that.aiConfigured,_that.workers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminOpsDashboardResponse implements AdminOpsDashboardResponse {
  const _AdminOpsDashboardResponse({required this.generatedAtUtc, required this.bufferedErrors, required this.errorsLast24Hours, required this.pendingRealtimeOutbox, required this.activeStorageFiles, required this.activeSignalRConnections, required this.openRealtimeRooms, required this.activeRealtimeUsers, required this.redisConfigured, required this.onlyOfficeConfigured, required this.aiConfigured, required this.workers});
  factory _AdminOpsDashboardResponse.fromJson(Map<String, dynamic> json) => _$AdminOpsDashboardResponseFromJson(json);

@override final  DateTime generatedAtUtc;
@override final  int bufferedErrors;
@override final  int errorsLast24Hours;
@override final  int pendingRealtimeOutbox;
@override final  int activeStorageFiles;
@override final  int activeSignalRConnections;
@override final  int openRealtimeRooms;
@override final  int activeRealtimeUsers;
@override final  bool redisConfigured;
@override final  bool onlyOfficeConfigured;
@override final  bool aiConfigured;
@override final  List<WorkerHeartbeatResponse> workers;

/// Create a copy of AdminOpsDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminOpsDashboardResponseCopyWith<_AdminOpsDashboardResponse> get copyWith => __$AdminOpsDashboardResponseCopyWithImpl<_AdminOpsDashboardResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminOpsDashboardResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminOpsDashboardResponse&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&(identical(other.bufferedErrors, bufferedErrors) || other.bufferedErrors == bufferedErrors)&&(identical(other.errorsLast24Hours, errorsLast24Hours) || other.errorsLast24Hours == errorsLast24Hours)&&(identical(other.pendingRealtimeOutbox, pendingRealtimeOutbox) || other.pendingRealtimeOutbox == pendingRealtimeOutbox)&&(identical(other.activeStorageFiles, activeStorageFiles) || other.activeStorageFiles == activeStorageFiles)&&(identical(other.activeSignalRConnections, activeSignalRConnections) || other.activeSignalRConnections == activeSignalRConnections)&&(identical(other.openRealtimeRooms, openRealtimeRooms) || other.openRealtimeRooms == openRealtimeRooms)&&(identical(other.activeRealtimeUsers, activeRealtimeUsers) || other.activeRealtimeUsers == activeRealtimeUsers)&&(identical(other.redisConfigured, redisConfigured) || other.redisConfigured == redisConfigured)&&(identical(other.onlyOfficeConfigured, onlyOfficeConfigured) || other.onlyOfficeConfigured == onlyOfficeConfigured)&&(identical(other.aiConfigured, aiConfigured) || other.aiConfigured == aiConfigured)&&const DeepCollectionEquality().equals(other.workers, workers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAtUtc,bufferedErrors,errorsLast24Hours,pendingRealtimeOutbox,activeStorageFiles,activeSignalRConnections,openRealtimeRooms,activeRealtimeUsers,redisConfigured,onlyOfficeConfigured,aiConfigured,const DeepCollectionEquality().hash(workers));

@override
String toString() {
  return 'AdminOpsDashboardResponse(generatedAtUtc: $generatedAtUtc, bufferedErrors: $bufferedErrors, errorsLast24Hours: $errorsLast24Hours, pendingRealtimeOutbox: $pendingRealtimeOutbox, activeStorageFiles: $activeStorageFiles, activeSignalRConnections: $activeSignalRConnections, openRealtimeRooms: $openRealtimeRooms, activeRealtimeUsers: $activeRealtimeUsers, redisConfigured: $redisConfigured, onlyOfficeConfigured: $onlyOfficeConfigured, aiConfigured: $aiConfigured, workers: $workers)';
}


}

/// @nodoc
abstract mixin class _$AdminOpsDashboardResponseCopyWith<$Res> implements $AdminOpsDashboardResponseCopyWith<$Res> {
  factory _$AdminOpsDashboardResponseCopyWith(_AdminOpsDashboardResponse value, $Res Function(_AdminOpsDashboardResponse) _then) = __$AdminOpsDashboardResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime generatedAtUtc, int bufferedErrors, int errorsLast24Hours, int pendingRealtimeOutbox, int activeStorageFiles, int activeSignalRConnections, int openRealtimeRooms, int activeRealtimeUsers, bool redisConfigured, bool onlyOfficeConfigured, bool aiConfigured, List<WorkerHeartbeatResponse> workers
});




}
/// @nodoc
class __$AdminOpsDashboardResponseCopyWithImpl<$Res>
    implements _$AdminOpsDashboardResponseCopyWith<$Res> {
  __$AdminOpsDashboardResponseCopyWithImpl(this._self, this._then);

  final _AdminOpsDashboardResponse _self;
  final $Res Function(_AdminOpsDashboardResponse) _then;

/// Create a copy of AdminOpsDashboardResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatedAtUtc = null,Object? bufferedErrors = null,Object? errorsLast24Hours = null,Object? pendingRealtimeOutbox = null,Object? activeStorageFiles = null,Object? activeSignalRConnections = null,Object? openRealtimeRooms = null,Object? activeRealtimeUsers = null,Object? redisConfigured = null,Object? onlyOfficeConfigured = null,Object? aiConfigured = null,Object? workers = null,}) {
  return _then(_AdminOpsDashboardResponse(
generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,bufferedErrors: null == bufferedErrors ? _self.bufferedErrors : bufferedErrors // ignore: cast_nullable_to_non_nullable
as int,errorsLast24Hours: null == errorsLast24Hours ? _self.errorsLast24Hours : errorsLast24Hours // ignore: cast_nullable_to_non_nullable
as int,pendingRealtimeOutbox: null == pendingRealtimeOutbox ? _self.pendingRealtimeOutbox : pendingRealtimeOutbox // ignore: cast_nullable_to_non_nullable
as int,activeStorageFiles: null == activeStorageFiles ? _self.activeStorageFiles : activeStorageFiles // ignore: cast_nullable_to_non_nullable
as int,activeSignalRConnections: null == activeSignalRConnections ? _self.activeSignalRConnections : activeSignalRConnections // ignore: cast_nullable_to_non_nullable
as int,openRealtimeRooms: null == openRealtimeRooms ? _self.openRealtimeRooms : openRealtimeRooms // ignore: cast_nullable_to_non_nullable
as int,activeRealtimeUsers: null == activeRealtimeUsers ? _self.activeRealtimeUsers : activeRealtimeUsers // ignore: cast_nullable_to_non_nullable
as int,redisConfigured: null == redisConfigured ? _self.redisConfigured : redisConfigured // ignore: cast_nullable_to_non_nullable
as bool,onlyOfficeConfigured: null == onlyOfficeConfigured ? _self.onlyOfficeConfigured : onlyOfficeConfigured // ignore: cast_nullable_to_non_nullable
as bool,aiConfigured: null == aiConfigured ? _self.aiConfigured : aiConfigured // ignore: cast_nullable_to_non_nullable
as bool,workers: null == workers ? _self.workers : workers // ignore: cast_nullable_to_non_nullable
as List<WorkerHeartbeatResponse>,
  ));
}


}


/// @nodoc
mixin _$StorageOrphanItemResponse {

 String get fileId; String get originalFileName; String get storageObjectKey; int get fileSizeBytes; String get reason; DateTime get createdAtUtc;
/// Create a copy of StorageOrphanItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageOrphanItemResponseCopyWith<StorageOrphanItemResponse> get copyWith => _$StorageOrphanItemResponseCopyWithImpl<StorageOrphanItemResponse>(this as StorageOrphanItemResponse, _$identity);

  /// Serializes this StorageOrphanItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageOrphanItemResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.originalFileName, originalFileName) || other.originalFileName == originalFileName)&&(identical(other.storageObjectKey, storageObjectKey) || other.storageObjectKey == storageObjectKey)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,originalFileName,storageObjectKey,fileSizeBytes,reason,createdAtUtc);

@override
String toString() {
  return 'StorageOrphanItemResponse(fileId: $fileId, originalFileName: $originalFileName, storageObjectKey: $storageObjectKey, fileSizeBytes: $fileSizeBytes, reason: $reason, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class $StorageOrphanItemResponseCopyWith<$Res>  {
  factory $StorageOrphanItemResponseCopyWith(StorageOrphanItemResponse value, $Res Function(StorageOrphanItemResponse) _then) = _$StorageOrphanItemResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, String originalFileName, String storageObjectKey, int fileSizeBytes, String reason, DateTime createdAtUtc
});




}
/// @nodoc
class _$StorageOrphanItemResponseCopyWithImpl<$Res>
    implements $StorageOrphanItemResponseCopyWith<$Res> {
  _$StorageOrphanItemResponseCopyWithImpl(this._self, this._then);

  final StorageOrphanItemResponse _self;
  final $Res Function(StorageOrphanItemResponse) _then;

/// Create a copy of StorageOrphanItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? originalFileName = null,Object? storageObjectKey = null,Object? fileSizeBytes = null,Object? reason = null,Object? createdAtUtc = null,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,originalFileName: null == originalFileName ? _self.originalFileName : originalFileName // ignore: cast_nullable_to_non_nullable
as String,storageObjectKey: null == storageObjectKey ? _self.storageObjectKey : storageObjectKey // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageOrphanItemResponse].
extension StorageOrphanItemResponsePatterns on StorageOrphanItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageOrphanItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageOrphanItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageOrphanItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageOrphanItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageOrphanItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageOrphanItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  String originalFileName,  String storageObjectKey,  int fileSizeBytes,  String reason,  DateTime createdAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageOrphanItemResponse() when $default != null:
return $default(_that.fileId,_that.originalFileName,_that.storageObjectKey,_that.fileSizeBytes,_that.reason,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  String originalFileName,  String storageObjectKey,  int fileSizeBytes,  String reason,  DateTime createdAtUtc)  $default,) {final _that = this;
switch (_that) {
case _StorageOrphanItemResponse():
return $default(_that.fileId,_that.originalFileName,_that.storageObjectKey,_that.fileSizeBytes,_that.reason,_that.createdAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  String originalFileName,  String storageObjectKey,  int fileSizeBytes,  String reason,  DateTime createdAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _StorageOrphanItemResponse() when $default != null:
return $default(_that.fileId,_that.originalFileName,_that.storageObjectKey,_that.fileSizeBytes,_that.reason,_that.createdAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageOrphanItemResponse implements StorageOrphanItemResponse {
  const _StorageOrphanItemResponse({required this.fileId, required this.originalFileName, required this.storageObjectKey, required this.fileSizeBytes, required this.reason, required this.createdAtUtc});
  factory _StorageOrphanItemResponse.fromJson(Map<String, dynamic> json) => _$StorageOrphanItemResponseFromJson(json);

@override final  String fileId;
@override final  String originalFileName;
@override final  String storageObjectKey;
@override final  int fileSizeBytes;
@override final  String reason;
@override final  DateTime createdAtUtc;

/// Create a copy of StorageOrphanItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageOrphanItemResponseCopyWith<_StorageOrphanItemResponse> get copyWith => __$StorageOrphanItemResponseCopyWithImpl<_StorageOrphanItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageOrphanItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageOrphanItemResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.originalFileName, originalFileName) || other.originalFileName == originalFileName)&&(identical(other.storageObjectKey, storageObjectKey) || other.storageObjectKey == storageObjectKey)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,originalFileName,storageObjectKey,fileSizeBytes,reason,createdAtUtc);

@override
String toString() {
  return 'StorageOrphanItemResponse(fileId: $fileId, originalFileName: $originalFileName, storageObjectKey: $storageObjectKey, fileSizeBytes: $fileSizeBytes, reason: $reason, createdAtUtc: $createdAtUtc)';
}


}

/// @nodoc
abstract mixin class _$StorageOrphanItemResponseCopyWith<$Res> implements $StorageOrphanItemResponseCopyWith<$Res> {
  factory _$StorageOrphanItemResponseCopyWith(_StorageOrphanItemResponse value, $Res Function(_StorageOrphanItemResponse) _then) = __$StorageOrphanItemResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, String originalFileName, String storageObjectKey, int fileSizeBytes, String reason, DateTime createdAtUtc
});




}
/// @nodoc
class __$StorageOrphanItemResponseCopyWithImpl<$Res>
    implements _$StorageOrphanItemResponseCopyWith<$Res> {
  __$StorageOrphanItemResponseCopyWithImpl(this._self, this._then);

  final _StorageOrphanItemResponse _self;
  final $Res Function(_StorageOrphanItemResponse) _then;

/// Create a copy of StorageOrphanItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? originalFileName = null,Object? storageObjectKey = null,Object? fileSizeBytes = null,Object? reason = null,Object? createdAtUtc = null,}) {
  return _then(_StorageOrphanItemResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,originalFileName: null == originalFileName ? _self.originalFileName : originalFileName // ignore: cast_nullable_to_non_nullable
as String,storageObjectKey: null == storageObjectKey ? _self.storageObjectKey : storageObjectKey // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StorageOrphanScanReportResponse {

 DateTime get scannedAtUtc; int get expiredIncompleteUploadsCount; int get expiredIncompleteUploadsSizeBytes; int get expiredTrashFilesCount; int get expiredTrashFilesSizeBytes; int get totalReclaimableSizeBytes; List<StorageOrphanItemResponse> get items;
/// Create a copy of StorageOrphanScanReportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageOrphanScanReportResponseCopyWith<StorageOrphanScanReportResponse> get copyWith => _$StorageOrphanScanReportResponseCopyWithImpl<StorageOrphanScanReportResponse>(this as StorageOrphanScanReportResponse, _$identity);

  /// Serializes this StorageOrphanScanReportResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageOrphanScanReportResponse&&(identical(other.scannedAtUtc, scannedAtUtc) || other.scannedAtUtc == scannedAtUtc)&&(identical(other.expiredIncompleteUploadsCount, expiredIncompleteUploadsCount) || other.expiredIncompleteUploadsCount == expiredIncompleteUploadsCount)&&(identical(other.expiredIncompleteUploadsSizeBytes, expiredIncompleteUploadsSizeBytes) || other.expiredIncompleteUploadsSizeBytes == expiredIncompleteUploadsSizeBytes)&&(identical(other.expiredTrashFilesCount, expiredTrashFilesCount) || other.expiredTrashFilesCount == expiredTrashFilesCount)&&(identical(other.expiredTrashFilesSizeBytes, expiredTrashFilesSizeBytes) || other.expiredTrashFilesSizeBytes == expiredTrashFilesSizeBytes)&&(identical(other.totalReclaimableSizeBytes, totalReclaimableSizeBytes) || other.totalReclaimableSizeBytes == totalReclaimableSizeBytes)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scannedAtUtc,expiredIncompleteUploadsCount,expiredIncompleteUploadsSizeBytes,expiredTrashFilesCount,expiredTrashFilesSizeBytes,totalReclaimableSizeBytes,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'StorageOrphanScanReportResponse(scannedAtUtc: $scannedAtUtc, expiredIncompleteUploadsCount: $expiredIncompleteUploadsCount, expiredIncompleteUploadsSizeBytes: $expiredIncompleteUploadsSizeBytes, expiredTrashFilesCount: $expiredTrashFilesCount, expiredTrashFilesSizeBytes: $expiredTrashFilesSizeBytes, totalReclaimableSizeBytes: $totalReclaimableSizeBytes, items: $items)';
}


}

/// @nodoc
abstract mixin class $StorageOrphanScanReportResponseCopyWith<$Res>  {
  factory $StorageOrphanScanReportResponseCopyWith(StorageOrphanScanReportResponse value, $Res Function(StorageOrphanScanReportResponse) _then) = _$StorageOrphanScanReportResponseCopyWithImpl;
@useResult
$Res call({
 DateTime scannedAtUtc, int expiredIncompleteUploadsCount, int expiredIncompleteUploadsSizeBytes, int expiredTrashFilesCount, int expiredTrashFilesSizeBytes, int totalReclaimableSizeBytes, List<StorageOrphanItemResponse> items
});




}
/// @nodoc
class _$StorageOrphanScanReportResponseCopyWithImpl<$Res>
    implements $StorageOrphanScanReportResponseCopyWith<$Res> {
  _$StorageOrphanScanReportResponseCopyWithImpl(this._self, this._then);

  final StorageOrphanScanReportResponse _self;
  final $Res Function(StorageOrphanScanReportResponse) _then;

/// Create a copy of StorageOrphanScanReportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scannedAtUtc = null,Object? expiredIncompleteUploadsCount = null,Object? expiredIncompleteUploadsSizeBytes = null,Object? expiredTrashFilesCount = null,Object? expiredTrashFilesSizeBytes = null,Object? totalReclaimableSizeBytes = null,Object? items = null,}) {
  return _then(_self.copyWith(
scannedAtUtc: null == scannedAtUtc ? _self.scannedAtUtc : scannedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,expiredIncompleteUploadsCount: null == expiredIncompleteUploadsCount ? _self.expiredIncompleteUploadsCount : expiredIncompleteUploadsCount // ignore: cast_nullable_to_non_nullable
as int,expiredIncompleteUploadsSizeBytes: null == expiredIncompleteUploadsSizeBytes ? _self.expiredIncompleteUploadsSizeBytes : expiredIncompleteUploadsSizeBytes // ignore: cast_nullable_to_non_nullable
as int,expiredTrashFilesCount: null == expiredTrashFilesCount ? _self.expiredTrashFilesCount : expiredTrashFilesCount // ignore: cast_nullable_to_non_nullable
as int,expiredTrashFilesSizeBytes: null == expiredTrashFilesSizeBytes ? _self.expiredTrashFilesSizeBytes : expiredTrashFilesSizeBytes // ignore: cast_nullable_to_non_nullable
as int,totalReclaimableSizeBytes: null == totalReclaimableSizeBytes ? _self.totalReclaimableSizeBytes : totalReclaimableSizeBytes // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StorageOrphanItemResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageOrphanScanReportResponse].
extension StorageOrphanScanReportResponsePatterns on StorageOrphanScanReportResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageOrphanScanReportResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageOrphanScanReportResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageOrphanScanReportResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageOrphanScanReportResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageOrphanScanReportResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageOrphanScanReportResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime scannedAtUtc,  int expiredIncompleteUploadsCount,  int expiredIncompleteUploadsSizeBytes,  int expiredTrashFilesCount,  int expiredTrashFilesSizeBytes,  int totalReclaimableSizeBytes,  List<StorageOrphanItemResponse> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageOrphanScanReportResponse() when $default != null:
return $default(_that.scannedAtUtc,_that.expiredIncompleteUploadsCount,_that.expiredIncompleteUploadsSizeBytes,_that.expiredTrashFilesCount,_that.expiredTrashFilesSizeBytes,_that.totalReclaimableSizeBytes,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime scannedAtUtc,  int expiredIncompleteUploadsCount,  int expiredIncompleteUploadsSizeBytes,  int expiredTrashFilesCount,  int expiredTrashFilesSizeBytes,  int totalReclaimableSizeBytes,  List<StorageOrphanItemResponse> items)  $default,) {final _that = this;
switch (_that) {
case _StorageOrphanScanReportResponse():
return $default(_that.scannedAtUtc,_that.expiredIncompleteUploadsCount,_that.expiredIncompleteUploadsSizeBytes,_that.expiredTrashFilesCount,_that.expiredTrashFilesSizeBytes,_that.totalReclaimableSizeBytes,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime scannedAtUtc,  int expiredIncompleteUploadsCount,  int expiredIncompleteUploadsSizeBytes,  int expiredTrashFilesCount,  int expiredTrashFilesSizeBytes,  int totalReclaimableSizeBytes,  List<StorageOrphanItemResponse> items)?  $default,) {final _that = this;
switch (_that) {
case _StorageOrphanScanReportResponse() when $default != null:
return $default(_that.scannedAtUtc,_that.expiredIncompleteUploadsCount,_that.expiredIncompleteUploadsSizeBytes,_that.expiredTrashFilesCount,_that.expiredTrashFilesSizeBytes,_that.totalReclaimableSizeBytes,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageOrphanScanReportResponse implements StorageOrphanScanReportResponse {
  const _StorageOrphanScanReportResponse({required this.scannedAtUtc, required this.expiredIncompleteUploadsCount, required this.expiredIncompleteUploadsSizeBytes, required this.expiredTrashFilesCount, required this.expiredTrashFilesSizeBytes, required this.totalReclaimableSizeBytes, required this.items});
  factory _StorageOrphanScanReportResponse.fromJson(Map<String, dynamic> json) => _$StorageOrphanScanReportResponseFromJson(json);

@override final  DateTime scannedAtUtc;
@override final  int expiredIncompleteUploadsCount;
@override final  int expiredIncompleteUploadsSizeBytes;
@override final  int expiredTrashFilesCount;
@override final  int expiredTrashFilesSizeBytes;
@override final  int totalReclaimableSizeBytes;
@override final  List<StorageOrphanItemResponse> items;

/// Create a copy of StorageOrphanScanReportResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageOrphanScanReportResponseCopyWith<_StorageOrphanScanReportResponse> get copyWith => __$StorageOrphanScanReportResponseCopyWithImpl<_StorageOrphanScanReportResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageOrphanScanReportResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageOrphanScanReportResponse&&(identical(other.scannedAtUtc, scannedAtUtc) || other.scannedAtUtc == scannedAtUtc)&&(identical(other.expiredIncompleteUploadsCount, expiredIncompleteUploadsCount) || other.expiredIncompleteUploadsCount == expiredIncompleteUploadsCount)&&(identical(other.expiredIncompleteUploadsSizeBytes, expiredIncompleteUploadsSizeBytes) || other.expiredIncompleteUploadsSizeBytes == expiredIncompleteUploadsSizeBytes)&&(identical(other.expiredTrashFilesCount, expiredTrashFilesCount) || other.expiredTrashFilesCount == expiredTrashFilesCount)&&(identical(other.expiredTrashFilesSizeBytes, expiredTrashFilesSizeBytes) || other.expiredTrashFilesSizeBytes == expiredTrashFilesSizeBytes)&&(identical(other.totalReclaimableSizeBytes, totalReclaimableSizeBytes) || other.totalReclaimableSizeBytes == totalReclaimableSizeBytes)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scannedAtUtc,expiredIncompleteUploadsCount,expiredIncompleteUploadsSizeBytes,expiredTrashFilesCount,expiredTrashFilesSizeBytes,totalReclaimableSizeBytes,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'StorageOrphanScanReportResponse(scannedAtUtc: $scannedAtUtc, expiredIncompleteUploadsCount: $expiredIncompleteUploadsCount, expiredIncompleteUploadsSizeBytes: $expiredIncompleteUploadsSizeBytes, expiredTrashFilesCount: $expiredTrashFilesCount, expiredTrashFilesSizeBytes: $expiredTrashFilesSizeBytes, totalReclaimableSizeBytes: $totalReclaimableSizeBytes, items: $items)';
}


}

/// @nodoc
abstract mixin class _$StorageOrphanScanReportResponseCopyWith<$Res> implements $StorageOrphanScanReportResponseCopyWith<$Res> {
  factory _$StorageOrphanScanReportResponseCopyWith(_StorageOrphanScanReportResponse value, $Res Function(_StorageOrphanScanReportResponse) _then) = __$StorageOrphanScanReportResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime scannedAtUtc, int expiredIncompleteUploadsCount, int expiredIncompleteUploadsSizeBytes, int expiredTrashFilesCount, int expiredTrashFilesSizeBytes, int totalReclaimableSizeBytes, List<StorageOrphanItemResponse> items
});




}
/// @nodoc
class __$StorageOrphanScanReportResponseCopyWithImpl<$Res>
    implements _$StorageOrphanScanReportResponseCopyWith<$Res> {
  __$StorageOrphanScanReportResponseCopyWithImpl(this._self, this._then);

  final _StorageOrphanScanReportResponse _self;
  final $Res Function(_StorageOrphanScanReportResponse) _then;

/// Create a copy of StorageOrphanScanReportResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scannedAtUtc = null,Object? expiredIncompleteUploadsCount = null,Object? expiredIncompleteUploadsSizeBytes = null,Object? expiredTrashFilesCount = null,Object? expiredTrashFilesSizeBytes = null,Object? totalReclaimableSizeBytes = null,Object? items = null,}) {
  return _then(_StorageOrphanScanReportResponse(
scannedAtUtc: null == scannedAtUtc ? _self.scannedAtUtc : scannedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,expiredIncompleteUploadsCount: null == expiredIncompleteUploadsCount ? _self.expiredIncompleteUploadsCount : expiredIncompleteUploadsCount // ignore: cast_nullable_to_non_nullable
as int,expiredIncompleteUploadsSizeBytes: null == expiredIncompleteUploadsSizeBytes ? _self.expiredIncompleteUploadsSizeBytes : expiredIncompleteUploadsSizeBytes // ignore: cast_nullable_to_non_nullable
as int,expiredTrashFilesCount: null == expiredTrashFilesCount ? _self.expiredTrashFilesCount : expiredTrashFilesCount // ignore: cast_nullable_to_non_nullable
as int,expiredTrashFilesSizeBytes: null == expiredTrashFilesSizeBytes ? _self.expiredTrashFilesSizeBytes : expiredTrashFilesSizeBytes // ignore: cast_nullable_to_non_nullable
as int,totalReclaimableSizeBytes: null == totalReclaimableSizeBytes ? _self.totalReclaimableSizeBytes : totalReclaimableSizeBytes // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StorageOrphanItemResponse>,
  ));
}


}


/// @nodoc
mixin _$StorageOrphanPurgePayload {

 int get trashRetentionDays; bool get purgeIncompleteUploads; bool get purgeTrash;
/// Create a copy of StorageOrphanPurgePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageOrphanPurgePayloadCopyWith<StorageOrphanPurgePayload> get copyWith => _$StorageOrphanPurgePayloadCopyWithImpl<StorageOrphanPurgePayload>(this as StorageOrphanPurgePayload, _$identity);

  /// Serializes this StorageOrphanPurgePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageOrphanPurgePayload&&(identical(other.trashRetentionDays, trashRetentionDays) || other.trashRetentionDays == trashRetentionDays)&&(identical(other.purgeIncompleteUploads, purgeIncompleteUploads) || other.purgeIncompleteUploads == purgeIncompleteUploads)&&(identical(other.purgeTrash, purgeTrash) || other.purgeTrash == purgeTrash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trashRetentionDays,purgeIncompleteUploads,purgeTrash);

@override
String toString() {
  return 'StorageOrphanPurgePayload(trashRetentionDays: $trashRetentionDays, purgeIncompleteUploads: $purgeIncompleteUploads, purgeTrash: $purgeTrash)';
}


}

/// @nodoc
abstract mixin class $StorageOrphanPurgePayloadCopyWith<$Res>  {
  factory $StorageOrphanPurgePayloadCopyWith(StorageOrphanPurgePayload value, $Res Function(StorageOrphanPurgePayload) _then) = _$StorageOrphanPurgePayloadCopyWithImpl;
@useResult
$Res call({
 int trashRetentionDays, bool purgeIncompleteUploads, bool purgeTrash
});




}
/// @nodoc
class _$StorageOrphanPurgePayloadCopyWithImpl<$Res>
    implements $StorageOrphanPurgePayloadCopyWith<$Res> {
  _$StorageOrphanPurgePayloadCopyWithImpl(this._self, this._then);

  final StorageOrphanPurgePayload _self;
  final $Res Function(StorageOrphanPurgePayload) _then;

/// Create a copy of StorageOrphanPurgePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trashRetentionDays = null,Object? purgeIncompleteUploads = null,Object? purgeTrash = null,}) {
  return _then(_self.copyWith(
trashRetentionDays: null == trashRetentionDays ? _self.trashRetentionDays : trashRetentionDays // ignore: cast_nullable_to_non_nullable
as int,purgeIncompleteUploads: null == purgeIncompleteUploads ? _self.purgeIncompleteUploads : purgeIncompleteUploads // ignore: cast_nullable_to_non_nullable
as bool,purgeTrash: null == purgeTrash ? _self.purgeTrash : purgeTrash // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageOrphanPurgePayload].
extension StorageOrphanPurgePayloadPatterns on StorageOrphanPurgePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageOrphanPurgePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageOrphanPurgePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageOrphanPurgePayload value)  $default,){
final _that = this;
switch (_that) {
case _StorageOrphanPurgePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageOrphanPurgePayload value)?  $default,){
final _that = this;
switch (_that) {
case _StorageOrphanPurgePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int trashRetentionDays,  bool purgeIncompleteUploads,  bool purgeTrash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageOrphanPurgePayload() when $default != null:
return $default(_that.trashRetentionDays,_that.purgeIncompleteUploads,_that.purgeTrash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int trashRetentionDays,  bool purgeIncompleteUploads,  bool purgeTrash)  $default,) {final _that = this;
switch (_that) {
case _StorageOrphanPurgePayload():
return $default(_that.trashRetentionDays,_that.purgeIncompleteUploads,_that.purgeTrash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int trashRetentionDays,  bool purgeIncompleteUploads,  bool purgeTrash)?  $default,) {final _that = this;
switch (_that) {
case _StorageOrphanPurgePayload() when $default != null:
return $default(_that.trashRetentionDays,_that.purgeIncompleteUploads,_that.purgeTrash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageOrphanPurgePayload implements StorageOrphanPurgePayload {
  const _StorageOrphanPurgePayload({this.trashRetentionDays = 30, this.purgeIncompleteUploads = true, this.purgeTrash = true});
  factory _StorageOrphanPurgePayload.fromJson(Map<String, dynamic> json) => _$StorageOrphanPurgePayloadFromJson(json);

@override@JsonKey() final  int trashRetentionDays;
@override@JsonKey() final  bool purgeIncompleteUploads;
@override@JsonKey() final  bool purgeTrash;

/// Create a copy of StorageOrphanPurgePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageOrphanPurgePayloadCopyWith<_StorageOrphanPurgePayload> get copyWith => __$StorageOrphanPurgePayloadCopyWithImpl<_StorageOrphanPurgePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageOrphanPurgePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageOrphanPurgePayload&&(identical(other.trashRetentionDays, trashRetentionDays) || other.trashRetentionDays == trashRetentionDays)&&(identical(other.purgeIncompleteUploads, purgeIncompleteUploads) || other.purgeIncompleteUploads == purgeIncompleteUploads)&&(identical(other.purgeTrash, purgeTrash) || other.purgeTrash == purgeTrash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trashRetentionDays,purgeIncompleteUploads,purgeTrash);

@override
String toString() {
  return 'StorageOrphanPurgePayload(trashRetentionDays: $trashRetentionDays, purgeIncompleteUploads: $purgeIncompleteUploads, purgeTrash: $purgeTrash)';
}


}

/// @nodoc
abstract mixin class _$StorageOrphanPurgePayloadCopyWith<$Res> implements $StorageOrphanPurgePayloadCopyWith<$Res> {
  factory _$StorageOrphanPurgePayloadCopyWith(_StorageOrphanPurgePayload value, $Res Function(_StorageOrphanPurgePayload) _then) = __$StorageOrphanPurgePayloadCopyWithImpl;
@override @useResult
$Res call({
 int trashRetentionDays, bool purgeIncompleteUploads, bool purgeTrash
});




}
/// @nodoc
class __$StorageOrphanPurgePayloadCopyWithImpl<$Res>
    implements _$StorageOrphanPurgePayloadCopyWith<$Res> {
  __$StorageOrphanPurgePayloadCopyWithImpl(this._self, this._then);

  final _StorageOrphanPurgePayload _self;
  final $Res Function(_StorageOrphanPurgePayload) _then;

/// Create a copy of StorageOrphanPurgePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trashRetentionDays = null,Object? purgeIncompleteUploads = null,Object? purgeTrash = null,}) {
  return _then(_StorageOrphanPurgePayload(
trashRetentionDays: null == trashRetentionDays ? _self.trashRetentionDays : trashRetentionDays // ignore: cast_nullable_to_non_nullable
as int,purgeIncompleteUploads: null == purgeIncompleteUploads ? _self.purgeIncompleteUploads : purgeIncompleteUploads // ignore: cast_nullable_to_non_nullable
as bool,purgeTrash: null == purgeTrash ? _self.purgeTrash : purgeTrash // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StorageOrphanPurgeReportResponse {

 DateTime get purgedAtUtc; int get purgedFilesCount; int get purgedSizeBytes; List<String> get purgedObjectKeys;
/// Create a copy of StorageOrphanPurgeReportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageOrphanPurgeReportResponseCopyWith<StorageOrphanPurgeReportResponse> get copyWith => _$StorageOrphanPurgeReportResponseCopyWithImpl<StorageOrphanPurgeReportResponse>(this as StorageOrphanPurgeReportResponse, _$identity);

  /// Serializes this StorageOrphanPurgeReportResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageOrphanPurgeReportResponse&&(identical(other.purgedAtUtc, purgedAtUtc) || other.purgedAtUtc == purgedAtUtc)&&(identical(other.purgedFilesCount, purgedFilesCount) || other.purgedFilesCount == purgedFilesCount)&&(identical(other.purgedSizeBytes, purgedSizeBytes) || other.purgedSizeBytes == purgedSizeBytes)&&const DeepCollectionEquality().equals(other.purgedObjectKeys, purgedObjectKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,purgedAtUtc,purgedFilesCount,purgedSizeBytes,const DeepCollectionEquality().hash(purgedObjectKeys));

@override
String toString() {
  return 'StorageOrphanPurgeReportResponse(purgedAtUtc: $purgedAtUtc, purgedFilesCount: $purgedFilesCount, purgedSizeBytes: $purgedSizeBytes, purgedObjectKeys: $purgedObjectKeys)';
}


}

/// @nodoc
abstract mixin class $StorageOrphanPurgeReportResponseCopyWith<$Res>  {
  factory $StorageOrphanPurgeReportResponseCopyWith(StorageOrphanPurgeReportResponse value, $Res Function(StorageOrphanPurgeReportResponse) _then) = _$StorageOrphanPurgeReportResponseCopyWithImpl;
@useResult
$Res call({
 DateTime purgedAtUtc, int purgedFilesCount, int purgedSizeBytes, List<String> purgedObjectKeys
});




}
/// @nodoc
class _$StorageOrphanPurgeReportResponseCopyWithImpl<$Res>
    implements $StorageOrphanPurgeReportResponseCopyWith<$Res> {
  _$StorageOrphanPurgeReportResponseCopyWithImpl(this._self, this._then);

  final StorageOrphanPurgeReportResponse _self;
  final $Res Function(StorageOrphanPurgeReportResponse) _then;

/// Create a copy of StorageOrphanPurgeReportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? purgedAtUtc = null,Object? purgedFilesCount = null,Object? purgedSizeBytes = null,Object? purgedObjectKeys = null,}) {
  return _then(_self.copyWith(
purgedAtUtc: null == purgedAtUtc ? _self.purgedAtUtc : purgedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,purgedFilesCount: null == purgedFilesCount ? _self.purgedFilesCount : purgedFilesCount // ignore: cast_nullable_to_non_nullable
as int,purgedSizeBytes: null == purgedSizeBytes ? _self.purgedSizeBytes : purgedSizeBytes // ignore: cast_nullable_to_non_nullable
as int,purgedObjectKeys: null == purgedObjectKeys ? _self.purgedObjectKeys : purgedObjectKeys // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageOrphanPurgeReportResponse].
extension StorageOrphanPurgeReportResponsePatterns on StorageOrphanPurgeReportResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageOrphanPurgeReportResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageOrphanPurgeReportResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageOrphanPurgeReportResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageOrphanPurgeReportResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageOrphanPurgeReportResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageOrphanPurgeReportResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime purgedAtUtc,  int purgedFilesCount,  int purgedSizeBytes,  List<String> purgedObjectKeys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageOrphanPurgeReportResponse() when $default != null:
return $default(_that.purgedAtUtc,_that.purgedFilesCount,_that.purgedSizeBytes,_that.purgedObjectKeys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime purgedAtUtc,  int purgedFilesCount,  int purgedSizeBytes,  List<String> purgedObjectKeys)  $default,) {final _that = this;
switch (_that) {
case _StorageOrphanPurgeReportResponse():
return $default(_that.purgedAtUtc,_that.purgedFilesCount,_that.purgedSizeBytes,_that.purgedObjectKeys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime purgedAtUtc,  int purgedFilesCount,  int purgedSizeBytes,  List<String> purgedObjectKeys)?  $default,) {final _that = this;
switch (_that) {
case _StorageOrphanPurgeReportResponse() when $default != null:
return $default(_that.purgedAtUtc,_that.purgedFilesCount,_that.purgedSizeBytes,_that.purgedObjectKeys);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageOrphanPurgeReportResponse implements StorageOrphanPurgeReportResponse {
  const _StorageOrphanPurgeReportResponse({required this.purgedAtUtc, required this.purgedFilesCount, required this.purgedSizeBytes, required this.purgedObjectKeys});
  factory _StorageOrphanPurgeReportResponse.fromJson(Map<String, dynamic> json) => _$StorageOrphanPurgeReportResponseFromJson(json);

@override final  DateTime purgedAtUtc;
@override final  int purgedFilesCount;
@override final  int purgedSizeBytes;
@override final  List<String> purgedObjectKeys;

/// Create a copy of StorageOrphanPurgeReportResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageOrphanPurgeReportResponseCopyWith<_StorageOrphanPurgeReportResponse> get copyWith => __$StorageOrphanPurgeReportResponseCopyWithImpl<_StorageOrphanPurgeReportResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageOrphanPurgeReportResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageOrphanPurgeReportResponse&&(identical(other.purgedAtUtc, purgedAtUtc) || other.purgedAtUtc == purgedAtUtc)&&(identical(other.purgedFilesCount, purgedFilesCount) || other.purgedFilesCount == purgedFilesCount)&&(identical(other.purgedSizeBytes, purgedSizeBytes) || other.purgedSizeBytes == purgedSizeBytes)&&const DeepCollectionEquality().equals(other.purgedObjectKeys, purgedObjectKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,purgedAtUtc,purgedFilesCount,purgedSizeBytes,const DeepCollectionEquality().hash(purgedObjectKeys));

@override
String toString() {
  return 'StorageOrphanPurgeReportResponse(purgedAtUtc: $purgedAtUtc, purgedFilesCount: $purgedFilesCount, purgedSizeBytes: $purgedSizeBytes, purgedObjectKeys: $purgedObjectKeys)';
}


}

/// @nodoc
abstract mixin class _$StorageOrphanPurgeReportResponseCopyWith<$Res> implements $StorageOrphanPurgeReportResponseCopyWith<$Res> {
  factory _$StorageOrphanPurgeReportResponseCopyWith(_StorageOrphanPurgeReportResponse value, $Res Function(_StorageOrphanPurgeReportResponse) _then) = __$StorageOrphanPurgeReportResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime purgedAtUtc, int purgedFilesCount, int purgedSizeBytes, List<String> purgedObjectKeys
});




}
/// @nodoc
class __$StorageOrphanPurgeReportResponseCopyWithImpl<$Res>
    implements _$StorageOrphanPurgeReportResponseCopyWith<$Res> {
  __$StorageOrphanPurgeReportResponseCopyWithImpl(this._self, this._then);

  final _StorageOrphanPurgeReportResponse _self;
  final $Res Function(_StorageOrphanPurgeReportResponse) _then;

/// Create a copy of StorageOrphanPurgeReportResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? purgedAtUtc = null,Object? purgedFilesCount = null,Object? purgedSizeBytes = null,Object? purgedObjectKeys = null,}) {
  return _then(_StorageOrphanPurgeReportResponse(
purgedAtUtc: null == purgedAtUtc ? _self.purgedAtUtc : purgedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,purgedFilesCount: null == purgedFilesCount ? _self.purgedFilesCount : purgedFilesCount // ignore: cast_nullable_to_non_nullable
as int,purgedSizeBytes: null == purgedSizeBytes ? _self.purgedSizeBytes : purgedSizeBytes // ignore: cast_nullable_to_non_nullable
as int,purgedObjectKeys: null == purgedObjectKeys ? _self.purgedObjectKeys : purgedObjectKeys // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
