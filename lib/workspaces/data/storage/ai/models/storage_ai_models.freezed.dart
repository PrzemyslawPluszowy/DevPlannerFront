// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage_ai_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiDetectedEntity {

 String get type; String get value; double? get confidence;
/// Create a copy of AiDetectedEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiDetectedEntityCopyWith<AiDetectedEntity> get copyWith => _$AiDetectedEntityCopyWithImpl<AiDetectedEntity>(this as AiDetectedEntity, _$identity);

  /// Serializes this AiDetectedEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiDetectedEntity&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,value,confidence);

@override
String toString() {
  return 'AiDetectedEntity(type: $type, value: $value, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $AiDetectedEntityCopyWith<$Res>  {
  factory $AiDetectedEntityCopyWith(AiDetectedEntity value, $Res Function(AiDetectedEntity) _then) = _$AiDetectedEntityCopyWithImpl;
@useResult
$Res call({
 String type, String value, double? confidence
});




}
/// @nodoc
class _$AiDetectedEntityCopyWithImpl<$Res>
    implements $AiDetectedEntityCopyWith<$Res> {
  _$AiDetectedEntityCopyWithImpl(this._self, this._then);

  final AiDetectedEntity _self;
  final $Res Function(AiDetectedEntity) _then;

/// Create a copy of AiDetectedEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? value = null,Object? confidence = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiDetectedEntity].
extension AiDetectedEntityPatterns on AiDetectedEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiDetectedEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiDetectedEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiDetectedEntity value)  $default,){
final _that = this;
switch (_that) {
case _AiDetectedEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiDetectedEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AiDetectedEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String value,  double? confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiDetectedEntity() when $default != null:
return $default(_that.type,_that.value,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String value,  double? confidence)  $default,) {final _that = this;
switch (_that) {
case _AiDetectedEntity():
return $default(_that.type,_that.value,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String value,  double? confidence)?  $default,) {final _that = this;
switch (_that) {
case _AiDetectedEntity() when $default != null:
return $default(_that.type,_that.value,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiDetectedEntity implements AiDetectedEntity {
  const _AiDetectedEntity({required this.type, required this.value, this.confidence});
  factory _AiDetectedEntity.fromJson(Map<String, dynamic> json) => _$AiDetectedEntityFromJson(json);

@override final  String type;
@override final  String value;
@override final  double? confidence;

/// Create a copy of AiDetectedEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiDetectedEntityCopyWith<_AiDetectedEntity> get copyWith => __$AiDetectedEntityCopyWithImpl<_AiDetectedEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiDetectedEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiDetectedEntity&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,value,confidence);

@override
String toString() {
  return 'AiDetectedEntity(type: $type, value: $value, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$AiDetectedEntityCopyWith<$Res> implements $AiDetectedEntityCopyWith<$Res> {
  factory _$AiDetectedEntityCopyWith(_AiDetectedEntity value, $Res Function(_AiDetectedEntity) _then) = __$AiDetectedEntityCopyWithImpl;
@override @useResult
$Res call({
 String type, String value, double? confidence
});




}
/// @nodoc
class __$AiDetectedEntityCopyWithImpl<$Res>
    implements _$AiDetectedEntityCopyWith<$Res> {
  __$AiDetectedEntityCopyWithImpl(this._self, this._then);

  final _AiDetectedEntity _self;
  final $Res Function(_AiDetectedEntity) _then;

/// Create a copy of AiDetectedEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? value = null,Object? confidence = freezed,}) {
  return _then(_AiDetectedEntity(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$AiFileAnalysisAuditEventResponse {

 String get eventId; String get analysisJobId; String get fileId; int get fileVersion; String? get workspaceId; String? get projectId; AiOperationAuditEventType get eventType; AiProviderKind? get provider; int get attempt; int get inputBytes; int get outputBytes; StorageAnalysisFailureCode? get failureCode; DateTime get occurredAtUtc;
/// Create a copy of AiFileAnalysisAuditEventResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiFileAnalysisAuditEventResponseCopyWith<AiFileAnalysisAuditEventResponse> get copyWith => _$AiFileAnalysisAuditEventResponseCopyWithImpl<AiFileAnalysisAuditEventResponse>(this as AiFileAnalysisAuditEventResponse, _$identity);

  /// Serializes this AiFileAnalysisAuditEventResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiFileAnalysisAuditEventResponse&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.analysisJobId, analysisJobId) || other.analysisJobId == analysisJobId)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileVersion, fileVersion) || other.fileVersion == fileVersion)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.attempt, attempt) || other.attempt == attempt)&&(identical(other.inputBytes, inputBytes) || other.inputBytes == inputBytes)&&(identical(other.outputBytes, outputBytes) || other.outputBytes == outputBytes)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,analysisJobId,fileId,fileVersion,workspaceId,projectId,eventType,provider,attempt,inputBytes,outputBytes,failureCode,occurredAtUtc);

@override
String toString() {
  return 'AiFileAnalysisAuditEventResponse(eventId: $eventId, analysisJobId: $analysisJobId, fileId: $fileId, fileVersion: $fileVersion, workspaceId: $workspaceId, projectId: $projectId, eventType: $eventType, provider: $provider, attempt: $attempt, inputBytes: $inputBytes, outputBytes: $outputBytes, failureCode: $failureCode, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class $AiFileAnalysisAuditEventResponseCopyWith<$Res>  {
  factory $AiFileAnalysisAuditEventResponseCopyWith(AiFileAnalysisAuditEventResponse value, $Res Function(AiFileAnalysisAuditEventResponse) _then) = _$AiFileAnalysisAuditEventResponseCopyWithImpl;
@useResult
$Res call({
 String eventId, String analysisJobId, String fileId, int fileVersion, String? workspaceId, String? projectId, AiOperationAuditEventType eventType, AiProviderKind? provider, int attempt, int inputBytes, int outputBytes, StorageAnalysisFailureCode? failureCode, DateTime occurredAtUtc
});




}
/// @nodoc
class _$AiFileAnalysisAuditEventResponseCopyWithImpl<$Res>
    implements $AiFileAnalysisAuditEventResponseCopyWith<$Res> {
  _$AiFileAnalysisAuditEventResponseCopyWithImpl(this._self, this._then);

  final AiFileAnalysisAuditEventResponse _self;
  final $Res Function(AiFileAnalysisAuditEventResponse) _then;

/// Create a copy of AiFileAnalysisAuditEventResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? analysisJobId = null,Object? fileId = null,Object? fileVersion = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? eventType = null,Object? provider = freezed,Object? attempt = null,Object? inputBytes = null,Object? outputBytes = null,Object? failureCode = freezed,Object? occurredAtUtc = null,}) {
  return _then(_self.copyWith(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,analysisJobId: null == analysisJobId ? _self.analysisJobId : analysisJobId // ignore: cast_nullable_to_non_nullable
as String,fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileVersion: null == fileVersion ? _self.fileVersion : fileVersion // ignore: cast_nullable_to_non_nullable
as int,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as AiOperationAuditEventType,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind?,attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,inputBytes: null == inputBytes ? _self.inputBytes : inputBytes // ignore: cast_nullable_to_non_nullable
as int,outputBytes: null == outputBytes ? _self.outputBytes : outputBytes // ignore: cast_nullable_to_non_nullable
as int,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as StorageAnalysisFailureCode?,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AiFileAnalysisAuditEventResponse].
extension AiFileAnalysisAuditEventResponsePatterns on AiFileAnalysisAuditEventResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiFileAnalysisAuditEventResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiFileAnalysisAuditEventResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiFileAnalysisAuditEventResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiFileAnalysisAuditEventResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiFileAnalysisAuditEventResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiFileAnalysisAuditEventResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  String analysisJobId,  String fileId,  int fileVersion,  String? workspaceId,  String? projectId,  AiOperationAuditEventType eventType,  AiProviderKind? provider,  int attempt,  int inputBytes,  int outputBytes,  StorageAnalysisFailureCode? failureCode,  DateTime occurredAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiFileAnalysisAuditEventResponse() when $default != null:
return $default(_that.eventId,_that.analysisJobId,_that.fileId,_that.fileVersion,_that.workspaceId,_that.projectId,_that.eventType,_that.provider,_that.attempt,_that.inputBytes,_that.outputBytes,_that.failureCode,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  String analysisJobId,  String fileId,  int fileVersion,  String? workspaceId,  String? projectId,  AiOperationAuditEventType eventType,  AiProviderKind? provider,  int attempt,  int inputBytes,  int outputBytes,  StorageAnalysisFailureCode? failureCode,  DateTime occurredAtUtc)  $default,) {final _that = this;
switch (_that) {
case _AiFileAnalysisAuditEventResponse():
return $default(_that.eventId,_that.analysisJobId,_that.fileId,_that.fileVersion,_that.workspaceId,_that.projectId,_that.eventType,_that.provider,_that.attempt,_that.inputBytes,_that.outputBytes,_that.failureCode,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  String analysisJobId,  String fileId,  int fileVersion,  String? workspaceId,  String? projectId,  AiOperationAuditEventType eventType,  AiProviderKind? provider,  int attempt,  int inputBytes,  int outputBytes,  StorageAnalysisFailureCode? failureCode,  DateTime occurredAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _AiFileAnalysisAuditEventResponse() when $default != null:
return $default(_that.eventId,_that.analysisJobId,_that.fileId,_that.fileVersion,_that.workspaceId,_that.projectId,_that.eventType,_that.provider,_that.attempt,_that.inputBytes,_that.outputBytes,_that.failureCode,_that.occurredAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiFileAnalysisAuditEventResponse implements AiFileAnalysisAuditEventResponse {
  const _AiFileAnalysisAuditEventResponse({required this.eventId, required this.analysisJobId, required this.fileId, required this.fileVersion, this.workspaceId, this.projectId, required this.eventType, this.provider, required this.attempt, required this.inputBytes, required this.outputBytes, this.failureCode, required this.occurredAtUtc});
  factory _AiFileAnalysisAuditEventResponse.fromJson(Map<String, dynamic> json) => _$AiFileAnalysisAuditEventResponseFromJson(json);

@override final  String eventId;
@override final  String analysisJobId;
@override final  String fileId;
@override final  int fileVersion;
@override final  String? workspaceId;
@override final  String? projectId;
@override final  AiOperationAuditEventType eventType;
@override final  AiProviderKind? provider;
@override final  int attempt;
@override final  int inputBytes;
@override final  int outputBytes;
@override final  StorageAnalysisFailureCode? failureCode;
@override final  DateTime occurredAtUtc;

/// Create a copy of AiFileAnalysisAuditEventResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiFileAnalysisAuditEventResponseCopyWith<_AiFileAnalysisAuditEventResponse> get copyWith => __$AiFileAnalysisAuditEventResponseCopyWithImpl<_AiFileAnalysisAuditEventResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiFileAnalysisAuditEventResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiFileAnalysisAuditEventResponse&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.analysisJobId, analysisJobId) || other.analysisJobId == analysisJobId)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileVersion, fileVersion) || other.fileVersion == fileVersion)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.attempt, attempt) || other.attempt == attempt)&&(identical(other.inputBytes, inputBytes) || other.inputBytes == inputBytes)&&(identical(other.outputBytes, outputBytes) || other.outputBytes == outputBytes)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,analysisJobId,fileId,fileVersion,workspaceId,projectId,eventType,provider,attempt,inputBytes,outputBytes,failureCode,occurredAtUtc);

@override
String toString() {
  return 'AiFileAnalysisAuditEventResponse(eventId: $eventId, analysisJobId: $analysisJobId, fileId: $fileId, fileVersion: $fileVersion, workspaceId: $workspaceId, projectId: $projectId, eventType: $eventType, provider: $provider, attempt: $attempt, inputBytes: $inputBytes, outputBytes: $outputBytes, failureCode: $failureCode, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class _$AiFileAnalysisAuditEventResponseCopyWith<$Res> implements $AiFileAnalysisAuditEventResponseCopyWith<$Res> {
  factory _$AiFileAnalysisAuditEventResponseCopyWith(_AiFileAnalysisAuditEventResponse value, $Res Function(_AiFileAnalysisAuditEventResponse) _then) = __$AiFileAnalysisAuditEventResponseCopyWithImpl;
@override @useResult
$Res call({
 String eventId, String analysisJobId, String fileId, int fileVersion, String? workspaceId, String? projectId, AiOperationAuditEventType eventType, AiProviderKind? provider, int attempt, int inputBytes, int outputBytes, StorageAnalysisFailureCode? failureCode, DateTime occurredAtUtc
});




}
/// @nodoc
class __$AiFileAnalysisAuditEventResponseCopyWithImpl<$Res>
    implements _$AiFileAnalysisAuditEventResponseCopyWith<$Res> {
  __$AiFileAnalysisAuditEventResponseCopyWithImpl(this._self, this._then);

  final _AiFileAnalysisAuditEventResponse _self;
  final $Res Function(_AiFileAnalysisAuditEventResponse) _then;

/// Create a copy of AiFileAnalysisAuditEventResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? analysisJobId = null,Object? fileId = null,Object? fileVersion = null,Object? workspaceId = freezed,Object? projectId = freezed,Object? eventType = null,Object? provider = freezed,Object? attempt = null,Object? inputBytes = null,Object? outputBytes = null,Object? failureCode = freezed,Object? occurredAtUtc = null,}) {
  return _then(_AiFileAnalysisAuditEventResponse(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,analysisJobId: null == analysisJobId ? _self.analysisJobId : analysisJobId // ignore: cast_nullable_to_non_nullable
as String,fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileVersion: null == fileVersion ? _self.fileVersion : fileVersion // ignore: cast_nullable_to_non_nullable
as int,workspaceId: freezed == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as AiOperationAuditEventType,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind?,attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,inputBytes: null == inputBytes ? _self.inputBytes : inputBytes // ignore: cast_nullable_to_non_nullable
as int,outputBytes: null == outputBytes ? _self.outputBytes : outputBytes // ignore: cast_nullable_to_non_nullable
as int,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as StorageAnalysisFailureCode?,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AiUsageBucketResponse {

 String get operationType; AiProviderKind? get provider; String? get model; int get startedCount; int get completedCount; int get failedCount; int get inputCharacters; int get outputBytes;
/// Create a copy of AiUsageBucketResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiUsageBucketResponseCopyWith<AiUsageBucketResponse> get copyWith => _$AiUsageBucketResponseCopyWithImpl<AiUsageBucketResponse>(this as AiUsageBucketResponse, _$identity);

  /// Serializes this AiUsageBucketResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiUsageBucketResponse&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.startedCount, startedCount) || other.startedCount == startedCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount)&&(identical(other.inputCharacters, inputCharacters) || other.inputCharacters == inputCharacters)&&(identical(other.outputBytes, outputBytes) || other.outputBytes == outputBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationType,provider,model,startedCount,completedCount,failedCount,inputCharacters,outputBytes);

@override
String toString() {
  return 'AiUsageBucketResponse(operationType: $operationType, provider: $provider, model: $model, startedCount: $startedCount, completedCount: $completedCount, failedCount: $failedCount, inputCharacters: $inputCharacters, outputBytes: $outputBytes)';
}


}

/// @nodoc
abstract mixin class $AiUsageBucketResponseCopyWith<$Res>  {
  factory $AiUsageBucketResponseCopyWith(AiUsageBucketResponse value, $Res Function(AiUsageBucketResponse) _then) = _$AiUsageBucketResponseCopyWithImpl;
@useResult
$Res call({
 String operationType, AiProviderKind? provider, String? model, int startedCount, int completedCount, int failedCount, int inputCharacters, int outputBytes
});




}
/// @nodoc
class _$AiUsageBucketResponseCopyWithImpl<$Res>
    implements $AiUsageBucketResponseCopyWith<$Res> {
  _$AiUsageBucketResponseCopyWithImpl(this._self, this._then);

  final AiUsageBucketResponse _self;
  final $Res Function(AiUsageBucketResponse) _then;

/// Create a copy of AiUsageBucketResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operationType = null,Object? provider = freezed,Object? model = freezed,Object? startedCount = null,Object? completedCount = null,Object? failedCount = null,Object? inputCharacters = null,Object? outputBytes = null,}) {
  return _then(_self.copyWith(
operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,startedCount: null == startedCount ? _self.startedCount : startedCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,inputCharacters: null == inputCharacters ? _self.inputCharacters : inputCharacters // ignore: cast_nullable_to_non_nullable
as int,outputBytes: null == outputBytes ? _self.outputBytes : outputBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AiUsageBucketResponse].
extension AiUsageBucketResponsePatterns on AiUsageBucketResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiUsageBucketResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiUsageBucketResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiUsageBucketResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiUsageBucketResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiUsageBucketResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiUsageBucketResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String operationType,  AiProviderKind? provider,  String? model,  int startedCount,  int completedCount,  int failedCount,  int inputCharacters,  int outputBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiUsageBucketResponse() when $default != null:
return $default(_that.operationType,_that.provider,_that.model,_that.startedCount,_that.completedCount,_that.failedCount,_that.inputCharacters,_that.outputBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String operationType,  AiProviderKind? provider,  String? model,  int startedCount,  int completedCount,  int failedCount,  int inputCharacters,  int outputBytes)  $default,) {final _that = this;
switch (_that) {
case _AiUsageBucketResponse():
return $default(_that.operationType,_that.provider,_that.model,_that.startedCount,_that.completedCount,_that.failedCount,_that.inputCharacters,_that.outputBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String operationType,  AiProviderKind? provider,  String? model,  int startedCount,  int completedCount,  int failedCount,  int inputCharacters,  int outputBytes)?  $default,) {final _that = this;
switch (_that) {
case _AiUsageBucketResponse() when $default != null:
return $default(_that.operationType,_that.provider,_that.model,_that.startedCount,_that.completedCount,_that.failedCount,_that.inputCharacters,_that.outputBytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiUsageBucketResponse implements AiUsageBucketResponse {
  const _AiUsageBucketResponse({required this.operationType, this.provider, this.model, required this.startedCount, required this.completedCount, required this.failedCount, required this.inputCharacters, required this.outputBytes});
  factory _AiUsageBucketResponse.fromJson(Map<String, dynamic> json) => _$AiUsageBucketResponseFromJson(json);

@override final  String operationType;
@override final  AiProviderKind? provider;
@override final  String? model;
@override final  int startedCount;
@override final  int completedCount;
@override final  int failedCount;
@override final  int inputCharacters;
@override final  int outputBytes;

/// Create a copy of AiUsageBucketResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiUsageBucketResponseCopyWith<_AiUsageBucketResponse> get copyWith => __$AiUsageBucketResponseCopyWithImpl<_AiUsageBucketResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiUsageBucketResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiUsageBucketResponse&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.startedCount, startedCount) || other.startedCount == startedCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount)&&(identical(other.inputCharacters, inputCharacters) || other.inputCharacters == inputCharacters)&&(identical(other.outputBytes, outputBytes) || other.outputBytes == outputBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operationType,provider,model,startedCount,completedCount,failedCount,inputCharacters,outputBytes);

@override
String toString() {
  return 'AiUsageBucketResponse(operationType: $operationType, provider: $provider, model: $model, startedCount: $startedCount, completedCount: $completedCount, failedCount: $failedCount, inputCharacters: $inputCharacters, outputBytes: $outputBytes)';
}


}

/// @nodoc
abstract mixin class _$AiUsageBucketResponseCopyWith<$Res> implements $AiUsageBucketResponseCopyWith<$Res> {
  factory _$AiUsageBucketResponseCopyWith(_AiUsageBucketResponse value, $Res Function(_AiUsageBucketResponse) _then) = __$AiUsageBucketResponseCopyWithImpl;
@override @useResult
$Res call({
 String operationType, AiProviderKind? provider, String? model, int startedCount, int completedCount, int failedCount, int inputCharacters, int outputBytes
});




}
/// @nodoc
class __$AiUsageBucketResponseCopyWithImpl<$Res>
    implements _$AiUsageBucketResponseCopyWith<$Res> {
  __$AiUsageBucketResponseCopyWithImpl(this._self, this._then);

  final _AiUsageBucketResponse _self;
  final $Res Function(_AiUsageBucketResponse) _then;

/// Create a copy of AiUsageBucketResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operationType = null,Object? provider = freezed,Object? model = freezed,Object? startedCount = null,Object? completedCount = null,Object? failedCount = null,Object? inputCharacters = null,Object? outputBytes = null,}) {
  return _then(_AiUsageBucketResponse(
operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,startedCount: null == startedCount ? _self.startedCount : startedCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,inputCharacters: null == inputCharacters ? _self.inputCharacters : inputCharacters // ignore: cast_nullable_to_non_nullable
as int,outputBytes: null == outputBytes ? _self.outputBytes : outputBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AiUsageSummaryResponse {

 String get workspaceId; DateTime get fromUtc; DateTime get toUtc; int get startedCount; int get completedCount; int get failedCount; int get inputCharacters; int get outputBytes; List<AiUsageBucketResponse> get buckets;
/// Create a copy of AiUsageSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiUsageSummaryResponseCopyWith<AiUsageSummaryResponse> get copyWith => _$AiUsageSummaryResponseCopyWithImpl<AiUsageSummaryResponse>(this as AiUsageSummaryResponse, _$identity);

  /// Serializes this AiUsageSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiUsageSummaryResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.fromUtc, fromUtc) || other.fromUtc == fromUtc)&&(identical(other.toUtc, toUtc) || other.toUtc == toUtc)&&(identical(other.startedCount, startedCount) || other.startedCount == startedCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount)&&(identical(other.inputCharacters, inputCharacters) || other.inputCharacters == inputCharacters)&&(identical(other.outputBytes, outputBytes) || other.outputBytes == outputBytes)&&const DeepCollectionEquality().equals(other.buckets, buckets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,fromUtc,toUtc,startedCount,completedCount,failedCount,inputCharacters,outputBytes,const DeepCollectionEquality().hash(buckets));

@override
String toString() {
  return 'AiUsageSummaryResponse(workspaceId: $workspaceId, fromUtc: $fromUtc, toUtc: $toUtc, startedCount: $startedCount, completedCount: $completedCount, failedCount: $failedCount, inputCharacters: $inputCharacters, outputBytes: $outputBytes, buckets: $buckets)';
}


}

/// @nodoc
abstract mixin class $AiUsageSummaryResponseCopyWith<$Res>  {
  factory $AiUsageSummaryResponseCopyWith(AiUsageSummaryResponse value, $Res Function(AiUsageSummaryResponse) _then) = _$AiUsageSummaryResponseCopyWithImpl;
@useResult
$Res call({
 String workspaceId, DateTime fromUtc, DateTime toUtc, int startedCount, int completedCount, int failedCount, int inputCharacters, int outputBytes, List<AiUsageBucketResponse> buckets
});




}
/// @nodoc
class _$AiUsageSummaryResponseCopyWithImpl<$Res>
    implements $AiUsageSummaryResponseCopyWith<$Res> {
  _$AiUsageSummaryResponseCopyWithImpl(this._self, this._then);

  final AiUsageSummaryResponse _self;
  final $Res Function(AiUsageSummaryResponse) _then;

/// Create a copy of AiUsageSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workspaceId = null,Object? fromUtc = null,Object? toUtc = null,Object? startedCount = null,Object? completedCount = null,Object? failedCount = null,Object? inputCharacters = null,Object? outputBytes = null,Object? buckets = null,}) {
  return _then(_self.copyWith(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,fromUtc: null == fromUtc ? _self.fromUtc : fromUtc // ignore: cast_nullable_to_non_nullable
as DateTime,toUtc: null == toUtc ? _self.toUtc : toUtc // ignore: cast_nullable_to_non_nullable
as DateTime,startedCount: null == startedCount ? _self.startedCount : startedCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,inputCharacters: null == inputCharacters ? _self.inputCharacters : inputCharacters // ignore: cast_nullable_to_non_nullable
as int,outputBytes: null == outputBytes ? _self.outputBytes : outputBytes // ignore: cast_nullable_to_non_nullable
as int,buckets: null == buckets ? _self.buckets : buckets // ignore: cast_nullable_to_non_nullable
as List<AiUsageBucketResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiUsageSummaryResponse].
extension AiUsageSummaryResponsePatterns on AiUsageSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiUsageSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiUsageSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiUsageSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiUsageSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiUsageSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiUsageSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String workspaceId,  DateTime fromUtc,  DateTime toUtc,  int startedCount,  int completedCount,  int failedCount,  int inputCharacters,  int outputBytes,  List<AiUsageBucketResponse> buckets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiUsageSummaryResponse() when $default != null:
return $default(_that.workspaceId,_that.fromUtc,_that.toUtc,_that.startedCount,_that.completedCount,_that.failedCount,_that.inputCharacters,_that.outputBytes,_that.buckets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String workspaceId,  DateTime fromUtc,  DateTime toUtc,  int startedCount,  int completedCount,  int failedCount,  int inputCharacters,  int outputBytes,  List<AiUsageBucketResponse> buckets)  $default,) {final _that = this;
switch (_that) {
case _AiUsageSummaryResponse():
return $default(_that.workspaceId,_that.fromUtc,_that.toUtc,_that.startedCount,_that.completedCount,_that.failedCount,_that.inputCharacters,_that.outputBytes,_that.buckets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String workspaceId,  DateTime fromUtc,  DateTime toUtc,  int startedCount,  int completedCount,  int failedCount,  int inputCharacters,  int outputBytes,  List<AiUsageBucketResponse> buckets)?  $default,) {final _that = this;
switch (_that) {
case _AiUsageSummaryResponse() when $default != null:
return $default(_that.workspaceId,_that.fromUtc,_that.toUtc,_that.startedCount,_that.completedCount,_that.failedCount,_that.inputCharacters,_that.outputBytes,_that.buckets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiUsageSummaryResponse implements AiUsageSummaryResponse {
  const _AiUsageSummaryResponse({required this.workspaceId, required this.fromUtc, required this.toUtc, required this.startedCount, required this.completedCount, required this.failedCount, required this.inputCharacters, required this.outputBytes, required this.buckets});
  factory _AiUsageSummaryResponse.fromJson(Map<String, dynamic> json) => _$AiUsageSummaryResponseFromJson(json);

@override final  String workspaceId;
@override final  DateTime fromUtc;
@override final  DateTime toUtc;
@override final  int startedCount;
@override final  int completedCount;
@override final  int failedCount;
@override final  int inputCharacters;
@override final  int outputBytes;
@override final  List<AiUsageBucketResponse> buckets;

/// Create a copy of AiUsageSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiUsageSummaryResponseCopyWith<_AiUsageSummaryResponse> get copyWith => __$AiUsageSummaryResponseCopyWithImpl<_AiUsageSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiUsageSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiUsageSummaryResponse&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.fromUtc, fromUtc) || other.fromUtc == fromUtc)&&(identical(other.toUtc, toUtc) || other.toUtc == toUtc)&&(identical(other.startedCount, startedCount) || other.startedCount == startedCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount)&&(identical(other.inputCharacters, inputCharacters) || other.inputCharacters == inputCharacters)&&(identical(other.outputBytes, outputBytes) || other.outputBytes == outputBytes)&&const DeepCollectionEquality().equals(other.buckets, buckets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workspaceId,fromUtc,toUtc,startedCount,completedCount,failedCount,inputCharacters,outputBytes,const DeepCollectionEquality().hash(buckets));

@override
String toString() {
  return 'AiUsageSummaryResponse(workspaceId: $workspaceId, fromUtc: $fromUtc, toUtc: $toUtc, startedCount: $startedCount, completedCount: $completedCount, failedCount: $failedCount, inputCharacters: $inputCharacters, outputBytes: $outputBytes, buckets: $buckets)';
}


}

/// @nodoc
abstract mixin class _$AiUsageSummaryResponseCopyWith<$Res> implements $AiUsageSummaryResponseCopyWith<$Res> {
  factory _$AiUsageSummaryResponseCopyWith(_AiUsageSummaryResponse value, $Res Function(_AiUsageSummaryResponse) _then) = __$AiUsageSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String workspaceId, DateTime fromUtc, DateTime toUtc, int startedCount, int completedCount, int failedCount, int inputCharacters, int outputBytes, List<AiUsageBucketResponse> buckets
});




}
/// @nodoc
class __$AiUsageSummaryResponseCopyWithImpl<$Res>
    implements _$AiUsageSummaryResponseCopyWith<$Res> {
  __$AiUsageSummaryResponseCopyWithImpl(this._self, this._then);

  final _AiUsageSummaryResponse _self;
  final $Res Function(_AiUsageSummaryResponse) _then;

/// Create a copy of AiUsageSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workspaceId = null,Object? fromUtc = null,Object? toUtc = null,Object? startedCount = null,Object? completedCount = null,Object? failedCount = null,Object? inputCharacters = null,Object? outputBytes = null,Object? buckets = null,}) {
  return _then(_AiUsageSummaryResponse(
workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,fromUtc: null == fromUtc ? _self.fromUtc : fromUtc // ignore: cast_nullable_to_non_nullable
as DateTime,toUtc: null == toUtc ? _self.toUtc : toUtc // ignore: cast_nullable_to_non_nullable
as DateTime,startedCount: null == startedCount ? _self.startedCount : startedCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,inputCharacters: null == inputCharacters ? _self.inputCharacters : inputCharacters // ignore: cast_nullable_to_non_nullable
as int,outputBytes: null == outputBytes ? _self.outputBytes : outputBytes // ignore: cast_nullable_to_non_nullable
as int,buckets: null == buckets ? _self.buckets : buckets // ignore: cast_nullable_to_non_nullable
as List<AiUsageBucketResponse>,
  ));
}


}


/// @nodoc
mixin _$AiReportScheduleRecipientPayload {

 String get userId; AiReportDeliveryChannel get channel; String? get emailAddress;
/// Create a copy of AiReportScheduleRecipientPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiReportScheduleRecipientPayloadCopyWith<AiReportScheduleRecipientPayload> get copyWith => _$AiReportScheduleRecipientPayloadCopyWithImpl<AiReportScheduleRecipientPayload>(this as AiReportScheduleRecipientPayload, _$identity);

  /// Serializes this AiReportScheduleRecipientPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiReportScheduleRecipientPayload&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,channel,emailAddress);

@override
String toString() {
  return 'AiReportScheduleRecipientPayload(userId: $userId, channel: $channel, emailAddress: $emailAddress)';
}


}

/// @nodoc
abstract mixin class $AiReportScheduleRecipientPayloadCopyWith<$Res>  {
  factory $AiReportScheduleRecipientPayloadCopyWith(AiReportScheduleRecipientPayload value, $Res Function(AiReportScheduleRecipientPayload) _then) = _$AiReportScheduleRecipientPayloadCopyWithImpl;
@useResult
$Res call({
 String userId, AiReportDeliveryChannel channel, String? emailAddress
});




}
/// @nodoc
class _$AiReportScheduleRecipientPayloadCopyWithImpl<$Res>
    implements $AiReportScheduleRecipientPayloadCopyWith<$Res> {
  _$AiReportScheduleRecipientPayloadCopyWithImpl(this._self, this._then);

  final AiReportScheduleRecipientPayload _self;
  final $Res Function(AiReportScheduleRecipientPayload) _then;

/// Create a copy of AiReportScheduleRecipientPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? channel = null,Object? emailAddress = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as AiReportDeliveryChannel,emailAddress: freezed == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiReportScheduleRecipientPayload].
extension AiReportScheduleRecipientPayloadPatterns on AiReportScheduleRecipientPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiReportScheduleRecipientPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiReportScheduleRecipientPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiReportScheduleRecipientPayload value)  $default,){
final _that = this;
switch (_that) {
case _AiReportScheduleRecipientPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiReportScheduleRecipientPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AiReportScheduleRecipientPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  AiReportDeliveryChannel channel,  String? emailAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiReportScheduleRecipientPayload() when $default != null:
return $default(_that.userId,_that.channel,_that.emailAddress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  AiReportDeliveryChannel channel,  String? emailAddress)  $default,) {final _that = this;
switch (_that) {
case _AiReportScheduleRecipientPayload():
return $default(_that.userId,_that.channel,_that.emailAddress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  AiReportDeliveryChannel channel,  String? emailAddress)?  $default,) {final _that = this;
switch (_that) {
case _AiReportScheduleRecipientPayload() when $default != null:
return $default(_that.userId,_that.channel,_that.emailAddress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiReportScheduleRecipientPayload implements AiReportScheduleRecipientPayload {
  const _AiReportScheduleRecipientPayload({required this.userId, required this.channel, this.emailAddress});
  factory _AiReportScheduleRecipientPayload.fromJson(Map<String, dynamic> json) => _$AiReportScheduleRecipientPayloadFromJson(json);

@override final  String userId;
@override final  AiReportDeliveryChannel channel;
@override final  String? emailAddress;

/// Create a copy of AiReportScheduleRecipientPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiReportScheduleRecipientPayloadCopyWith<_AiReportScheduleRecipientPayload> get copyWith => __$AiReportScheduleRecipientPayloadCopyWithImpl<_AiReportScheduleRecipientPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiReportScheduleRecipientPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiReportScheduleRecipientPayload&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,channel,emailAddress);

@override
String toString() {
  return 'AiReportScheduleRecipientPayload(userId: $userId, channel: $channel, emailAddress: $emailAddress)';
}


}

/// @nodoc
abstract mixin class _$AiReportScheduleRecipientPayloadCopyWith<$Res> implements $AiReportScheduleRecipientPayloadCopyWith<$Res> {
  factory _$AiReportScheduleRecipientPayloadCopyWith(_AiReportScheduleRecipientPayload value, $Res Function(_AiReportScheduleRecipientPayload) _then) = __$AiReportScheduleRecipientPayloadCopyWithImpl;
@override @useResult
$Res call({
 String userId, AiReportDeliveryChannel channel, String? emailAddress
});




}
/// @nodoc
class __$AiReportScheduleRecipientPayloadCopyWithImpl<$Res>
    implements _$AiReportScheduleRecipientPayloadCopyWith<$Res> {
  __$AiReportScheduleRecipientPayloadCopyWithImpl(this._self, this._then);

  final _AiReportScheduleRecipientPayload _self;
  final $Res Function(_AiReportScheduleRecipientPayload) _then;

/// Create a copy of AiReportScheduleRecipientPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? channel = null,Object? emailAddress = freezed,}) {
  return _then(_AiReportScheduleRecipientPayload(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as AiReportDeliveryChannel,emailAddress: freezed == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateAiReportSchedulePayload {

 String get reportType; String get contractVersion; String get reportVersion; AiReportScheduleCadence get cadence; String get timeZoneId; String get localTime; String? get weekday; int? get dayOfMonth; String? get executionUserId; List<AiReportScheduleRecipientPayload> get recipients;
/// Create a copy of CreateAiReportSchedulePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAiReportSchedulePayloadCopyWith<CreateAiReportSchedulePayload> get copyWith => _$CreateAiReportSchedulePayloadCopyWithImpl<CreateAiReportSchedulePayload>(this as CreateAiReportSchedulePayload, _$identity);

  /// Serializes this CreateAiReportSchedulePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAiReportSchedulePayload&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.reportVersion, reportVersion) || other.reportVersion == reportVersion)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.executionUserId, executionUserId) || other.executionUserId == executionUserId)&&const DeepCollectionEquality().equals(other.recipients, recipients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,contractVersion,reportVersion,cadence,timeZoneId,localTime,weekday,dayOfMonth,executionUserId,const DeepCollectionEquality().hash(recipients));

@override
String toString() {
  return 'CreateAiReportSchedulePayload(reportType: $reportType, contractVersion: $contractVersion, reportVersion: $reportVersion, cadence: $cadence, timeZoneId: $timeZoneId, localTime: $localTime, weekday: $weekday, dayOfMonth: $dayOfMonth, executionUserId: $executionUserId, recipients: $recipients)';
}


}

/// @nodoc
abstract mixin class $CreateAiReportSchedulePayloadCopyWith<$Res>  {
  factory $CreateAiReportSchedulePayloadCopyWith(CreateAiReportSchedulePayload value, $Res Function(CreateAiReportSchedulePayload) _then) = _$CreateAiReportSchedulePayloadCopyWithImpl;
@useResult
$Res call({
 String reportType, String contractVersion, String reportVersion, AiReportScheduleCadence cadence, String timeZoneId, String localTime, String? weekday, int? dayOfMonth, String? executionUserId, List<AiReportScheduleRecipientPayload> recipients
});




}
/// @nodoc
class _$CreateAiReportSchedulePayloadCopyWithImpl<$Res>
    implements $CreateAiReportSchedulePayloadCopyWith<$Res> {
  _$CreateAiReportSchedulePayloadCopyWithImpl(this._self, this._then);

  final CreateAiReportSchedulePayload _self;
  final $Res Function(CreateAiReportSchedulePayload) _then;

/// Create a copy of CreateAiReportSchedulePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportType = null,Object? contractVersion = null,Object? reportVersion = null,Object? cadence = null,Object? timeZoneId = null,Object? localTime = null,Object? weekday = freezed,Object? dayOfMonth = freezed,Object? executionUserId = freezed,Object? recipients = null,}) {
  return _then(_self.copyWith(
reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,reportVersion: null == reportVersion ? _self.reportVersion : reportVersion // ignore: cast_nullable_to_non_nullable
as String,cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as AiReportScheduleCadence,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as String,weekday: freezed == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as String?,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,executionUserId: freezed == executionUserId ? _self.executionUserId : executionUserId // ignore: cast_nullable_to_non_nullable
as String?,recipients: null == recipients ? _self.recipients : recipients // ignore: cast_nullable_to_non_nullable
as List<AiReportScheduleRecipientPayload>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateAiReportSchedulePayload].
extension CreateAiReportSchedulePayloadPatterns on CreateAiReportSchedulePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateAiReportSchedulePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateAiReportSchedulePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateAiReportSchedulePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateAiReportSchedulePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateAiReportSchedulePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateAiReportSchedulePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reportType,  String contractVersion,  String reportVersion,  AiReportScheduleCadence cadence,  String timeZoneId,  String localTime,  String? weekday,  int? dayOfMonth,  String? executionUserId,  List<AiReportScheduleRecipientPayload> recipients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateAiReportSchedulePayload() when $default != null:
return $default(_that.reportType,_that.contractVersion,_that.reportVersion,_that.cadence,_that.timeZoneId,_that.localTime,_that.weekday,_that.dayOfMonth,_that.executionUserId,_that.recipients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reportType,  String contractVersion,  String reportVersion,  AiReportScheduleCadence cadence,  String timeZoneId,  String localTime,  String? weekday,  int? dayOfMonth,  String? executionUserId,  List<AiReportScheduleRecipientPayload> recipients)  $default,) {final _that = this;
switch (_that) {
case _CreateAiReportSchedulePayload():
return $default(_that.reportType,_that.contractVersion,_that.reportVersion,_that.cadence,_that.timeZoneId,_that.localTime,_that.weekday,_that.dayOfMonth,_that.executionUserId,_that.recipients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reportType,  String contractVersion,  String reportVersion,  AiReportScheduleCadence cadence,  String timeZoneId,  String localTime,  String? weekday,  int? dayOfMonth,  String? executionUserId,  List<AiReportScheduleRecipientPayload> recipients)?  $default,) {final _that = this;
switch (_that) {
case _CreateAiReportSchedulePayload() when $default != null:
return $default(_that.reportType,_that.contractVersion,_that.reportVersion,_that.cadence,_that.timeZoneId,_that.localTime,_that.weekday,_that.dayOfMonth,_that.executionUserId,_that.recipients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateAiReportSchedulePayload implements CreateAiReportSchedulePayload {
  const _CreateAiReportSchedulePayload({required this.reportType, required this.contractVersion, required this.reportVersion, required this.cadence, required this.timeZoneId, required this.localTime, this.weekday, this.dayOfMonth, this.executionUserId, required this.recipients});
  factory _CreateAiReportSchedulePayload.fromJson(Map<String, dynamic> json) => _$CreateAiReportSchedulePayloadFromJson(json);

@override final  String reportType;
@override final  String contractVersion;
@override final  String reportVersion;
@override final  AiReportScheduleCadence cadence;
@override final  String timeZoneId;
@override final  String localTime;
@override final  String? weekday;
@override final  int? dayOfMonth;
@override final  String? executionUserId;
@override final  List<AiReportScheduleRecipientPayload> recipients;

/// Create a copy of CreateAiReportSchedulePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAiReportSchedulePayloadCopyWith<_CreateAiReportSchedulePayload> get copyWith => __$CreateAiReportSchedulePayloadCopyWithImpl<_CreateAiReportSchedulePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateAiReportSchedulePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAiReportSchedulePayload&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.reportVersion, reportVersion) || other.reportVersion == reportVersion)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.executionUserId, executionUserId) || other.executionUserId == executionUserId)&&const DeepCollectionEquality().equals(other.recipients, recipients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportType,contractVersion,reportVersion,cadence,timeZoneId,localTime,weekday,dayOfMonth,executionUserId,const DeepCollectionEquality().hash(recipients));

@override
String toString() {
  return 'CreateAiReportSchedulePayload(reportType: $reportType, contractVersion: $contractVersion, reportVersion: $reportVersion, cadence: $cadence, timeZoneId: $timeZoneId, localTime: $localTime, weekday: $weekday, dayOfMonth: $dayOfMonth, executionUserId: $executionUserId, recipients: $recipients)';
}


}

/// @nodoc
abstract mixin class _$CreateAiReportSchedulePayloadCopyWith<$Res> implements $CreateAiReportSchedulePayloadCopyWith<$Res> {
  factory _$CreateAiReportSchedulePayloadCopyWith(_CreateAiReportSchedulePayload value, $Res Function(_CreateAiReportSchedulePayload) _then) = __$CreateAiReportSchedulePayloadCopyWithImpl;
@override @useResult
$Res call({
 String reportType, String contractVersion, String reportVersion, AiReportScheduleCadence cadence, String timeZoneId, String localTime, String? weekday, int? dayOfMonth, String? executionUserId, List<AiReportScheduleRecipientPayload> recipients
});




}
/// @nodoc
class __$CreateAiReportSchedulePayloadCopyWithImpl<$Res>
    implements _$CreateAiReportSchedulePayloadCopyWith<$Res> {
  __$CreateAiReportSchedulePayloadCopyWithImpl(this._self, this._then);

  final _CreateAiReportSchedulePayload _self;
  final $Res Function(_CreateAiReportSchedulePayload) _then;

/// Create a copy of CreateAiReportSchedulePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportType = null,Object? contractVersion = null,Object? reportVersion = null,Object? cadence = null,Object? timeZoneId = null,Object? localTime = null,Object? weekday = freezed,Object? dayOfMonth = freezed,Object? executionUserId = freezed,Object? recipients = null,}) {
  return _then(_CreateAiReportSchedulePayload(
reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,reportVersion: null == reportVersion ? _self.reportVersion : reportVersion // ignore: cast_nullable_to_non_nullable
as String,cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as AiReportScheduleCadence,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as String,weekday: freezed == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as String?,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,executionUserId: freezed == executionUserId ? _self.executionUserId : executionUserId // ignore: cast_nullable_to_non_nullable
as String?,recipients: null == recipients ? _self.recipients : recipients // ignore: cast_nullable_to_non_nullable
as List<AiReportScheduleRecipientPayload>,
  ));
}


}


/// @nodoc
mixin _$UpdateAiReportSchedulePayload {

 AiReportScheduleCadence get cadence; String get timeZoneId; String get localTime; String? get weekday; int? get dayOfMonth; String get executionUserId;
/// Create a copy of UpdateAiReportSchedulePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAiReportSchedulePayloadCopyWith<UpdateAiReportSchedulePayload> get copyWith => _$UpdateAiReportSchedulePayloadCopyWithImpl<UpdateAiReportSchedulePayload>(this as UpdateAiReportSchedulePayload, _$identity);

  /// Serializes this UpdateAiReportSchedulePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAiReportSchedulePayload&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.executionUserId, executionUserId) || other.executionUserId == executionUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cadence,timeZoneId,localTime,weekday,dayOfMonth,executionUserId);

@override
String toString() {
  return 'UpdateAiReportSchedulePayload(cadence: $cadence, timeZoneId: $timeZoneId, localTime: $localTime, weekday: $weekday, dayOfMonth: $dayOfMonth, executionUserId: $executionUserId)';
}


}

/// @nodoc
abstract mixin class $UpdateAiReportSchedulePayloadCopyWith<$Res>  {
  factory $UpdateAiReportSchedulePayloadCopyWith(UpdateAiReportSchedulePayload value, $Res Function(UpdateAiReportSchedulePayload) _then) = _$UpdateAiReportSchedulePayloadCopyWithImpl;
@useResult
$Res call({
 AiReportScheduleCadence cadence, String timeZoneId, String localTime, String? weekday, int? dayOfMonth, String executionUserId
});




}
/// @nodoc
class _$UpdateAiReportSchedulePayloadCopyWithImpl<$Res>
    implements $UpdateAiReportSchedulePayloadCopyWith<$Res> {
  _$UpdateAiReportSchedulePayloadCopyWithImpl(this._self, this._then);

  final UpdateAiReportSchedulePayload _self;
  final $Res Function(UpdateAiReportSchedulePayload) _then;

/// Create a copy of UpdateAiReportSchedulePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cadence = null,Object? timeZoneId = null,Object? localTime = null,Object? weekday = freezed,Object? dayOfMonth = freezed,Object? executionUserId = null,}) {
  return _then(_self.copyWith(
cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as AiReportScheduleCadence,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as String,weekday: freezed == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as String?,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,executionUserId: null == executionUserId ? _self.executionUserId : executionUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateAiReportSchedulePayload].
extension UpdateAiReportSchedulePayloadPatterns on UpdateAiReportSchedulePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateAiReportSchedulePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateAiReportSchedulePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateAiReportSchedulePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateAiReportSchedulePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateAiReportSchedulePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateAiReportSchedulePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiReportScheduleCadence cadence,  String timeZoneId,  String localTime,  String? weekday,  int? dayOfMonth,  String executionUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateAiReportSchedulePayload() when $default != null:
return $default(_that.cadence,_that.timeZoneId,_that.localTime,_that.weekday,_that.dayOfMonth,_that.executionUserId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiReportScheduleCadence cadence,  String timeZoneId,  String localTime,  String? weekday,  int? dayOfMonth,  String executionUserId)  $default,) {final _that = this;
switch (_that) {
case _UpdateAiReportSchedulePayload():
return $default(_that.cadence,_that.timeZoneId,_that.localTime,_that.weekday,_that.dayOfMonth,_that.executionUserId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiReportScheduleCadence cadence,  String timeZoneId,  String localTime,  String? weekday,  int? dayOfMonth,  String executionUserId)?  $default,) {final _that = this;
switch (_that) {
case _UpdateAiReportSchedulePayload() when $default != null:
return $default(_that.cadence,_that.timeZoneId,_that.localTime,_that.weekday,_that.dayOfMonth,_that.executionUserId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateAiReportSchedulePayload implements UpdateAiReportSchedulePayload {
  const _UpdateAiReportSchedulePayload({required this.cadence, required this.timeZoneId, required this.localTime, this.weekday, this.dayOfMonth, required this.executionUserId});
  factory _UpdateAiReportSchedulePayload.fromJson(Map<String, dynamic> json) => _$UpdateAiReportSchedulePayloadFromJson(json);

@override final  AiReportScheduleCadence cadence;
@override final  String timeZoneId;
@override final  String localTime;
@override final  String? weekday;
@override final  int? dayOfMonth;
@override final  String executionUserId;

/// Create a copy of UpdateAiReportSchedulePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAiReportSchedulePayloadCopyWith<_UpdateAiReportSchedulePayload> get copyWith => __$UpdateAiReportSchedulePayloadCopyWithImpl<_UpdateAiReportSchedulePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateAiReportSchedulePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAiReportSchedulePayload&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.executionUserId, executionUserId) || other.executionUserId == executionUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cadence,timeZoneId,localTime,weekday,dayOfMonth,executionUserId);

@override
String toString() {
  return 'UpdateAiReportSchedulePayload(cadence: $cadence, timeZoneId: $timeZoneId, localTime: $localTime, weekday: $weekday, dayOfMonth: $dayOfMonth, executionUserId: $executionUserId)';
}


}

/// @nodoc
abstract mixin class _$UpdateAiReportSchedulePayloadCopyWith<$Res> implements $UpdateAiReportSchedulePayloadCopyWith<$Res> {
  factory _$UpdateAiReportSchedulePayloadCopyWith(_UpdateAiReportSchedulePayload value, $Res Function(_UpdateAiReportSchedulePayload) _then) = __$UpdateAiReportSchedulePayloadCopyWithImpl;
@override @useResult
$Res call({
 AiReportScheduleCadence cadence, String timeZoneId, String localTime, String? weekday, int? dayOfMonth, String executionUserId
});




}
/// @nodoc
class __$UpdateAiReportSchedulePayloadCopyWithImpl<$Res>
    implements _$UpdateAiReportSchedulePayloadCopyWith<$Res> {
  __$UpdateAiReportSchedulePayloadCopyWithImpl(this._self, this._then);

  final _UpdateAiReportSchedulePayload _self;
  final $Res Function(_UpdateAiReportSchedulePayload) _then;

/// Create a copy of UpdateAiReportSchedulePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cadence = null,Object? timeZoneId = null,Object? localTime = null,Object? weekday = freezed,Object? dayOfMonth = freezed,Object? executionUserId = null,}) {
  return _then(_UpdateAiReportSchedulePayload(
cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as AiReportScheduleCadence,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as String,weekday: freezed == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as String?,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,executionUserId: null == executionUserId ? _self.executionUserId : executionUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AiReportScheduleRecipientResponse {

 String get userId; AiReportDeliveryChannel get channel; String? get emailAddress; bool get enabled;
/// Create a copy of AiReportScheduleRecipientResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiReportScheduleRecipientResponseCopyWith<AiReportScheduleRecipientResponse> get copyWith => _$AiReportScheduleRecipientResponseCopyWithImpl<AiReportScheduleRecipientResponse>(this as AiReportScheduleRecipientResponse, _$identity);

  /// Serializes this AiReportScheduleRecipientResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiReportScheduleRecipientResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,channel,emailAddress,enabled);

@override
String toString() {
  return 'AiReportScheduleRecipientResponse(userId: $userId, channel: $channel, emailAddress: $emailAddress, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $AiReportScheduleRecipientResponseCopyWith<$Res>  {
  factory $AiReportScheduleRecipientResponseCopyWith(AiReportScheduleRecipientResponse value, $Res Function(AiReportScheduleRecipientResponse) _then) = _$AiReportScheduleRecipientResponseCopyWithImpl;
@useResult
$Res call({
 String userId, AiReportDeliveryChannel channel, String? emailAddress, bool enabled
});




}
/// @nodoc
class _$AiReportScheduleRecipientResponseCopyWithImpl<$Res>
    implements $AiReportScheduleRecipientResponseCopyWith<$Res> {
  _$AiReportScheduleRecipientResponseCopyWithImpl(this._self, this._then);

  final AiReportScheduleRecipientResponse _self;
  final $Res Function(AiReportScheduleRecipientResponse) _then;

/// Create a copy of AiReportScheduleRecipientResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? channel = null,Object? emailAddress = freezed,Object? enabled = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as AiReportDeliveryChannel,emailAddress: freezed == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiReportScheduleRecipientResponse].
extension AiReportScheduleRecipientResponsePatterns on AiReportScheduleRecipientResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiReportScheduleRecipientResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiReportScheduleRecipientResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiReportScheduleRecipientResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiReportScheduleRecipientResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiReportScheduleRecipientResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiReportScheduleRecipientResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  AiReportDeliveryChannel channel,  String? emailAddress,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiReportScheduleRecipientResponse() when $default != null:
return $default(_that.userId,_that.channel,_that.emailAddress,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  AiReportDeliveryChannel channel,  String? emailAddress,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _AiReportScheduleRecipientResponse():
return $default(_that.userId,_that.channel,_that.emailAddress,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  AiReportDeliveryChannel channel,  String? emailAddress,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _AiReportScheduleRecipientResponse() when $default != null:
return $default(_that.userId,_that.channel,_that.emailAddress,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiReportScheduleRecipientResponse implements AiReportScheduleRecipientResponse {
  const _AiReportScheduleRecipientResponse({required this.userId, required this.channel, this.emailAddress, required this.enabled});
  factory _AiReportScheduleRecipientResponse.fromJson(Map<String, dynamic> json) => _$AiReportScheduleRecipientResponseFromJson(json);

@override final  String userId;
@override final  AiReportDeliveryChannel channel;
@override final  String? emailAddress;
@override final  bool enabled;

/// Create a copy of AiReportScheduleRecipientResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiReportScheduleRecipientResponseCopyWith<_AiReportScheduleRecipientResponse> get copyWith => __$AiReportScheduleRecipientResponseCopyWithImpl<_AiReportScheduleRecipientResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiReportScheduleRecipientResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiReportScheduleRecipientResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.emailAddress, emailAddress) || other.emailAddress == emailAddress)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,channel,emailAddress,enabled);

@override
String toString() {
  return 'AiReportScheduleRecipientResponse(userId: $userId, channel: $channel, emailAddress: $emailAddress, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$AiReportScheduleRecipientResponseCopyWith<$Res> implements $AiReportScheduleRecipientResponseCopyWith<$Res> {
  factory _$AiReportScheduleRecipientResponseCopyWith(_AiReportScheduleRecipientResponse value, $Res Function(_AiReportScheduleRecipientResponse) _then) = __$AiReportScheduleRecipientResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, AiReportDeliveryChannel channel, String? emailAddress, bool enabled
});




}
/// @nodoc
class __$AiReportScheduleRecipientResponseCopyWithImpl<$Res>
    implements _$AiReportScheduleRecipientResponseCopyWith<$Res> {
  __$AiReportScheduleRecipientResponseCopyWithImpl(this._self, this._then);

  final _AiReportScheduleRecipientResponse _self;
  final $Res Function(_AiReportScheduleRecipientResponse) _then;

/// Create a copy of AiReportScheduleRecipientResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? channel = null,Object? emailAddress = freezed,Object? enabled = null,}) {
  return _then(_AiReportScheduleRecipientResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as AiReportDeliveryChannel,emailAddress: freezed == emailAddress ? _self.emailAddress : emailAddress // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AiReportScheduleResponse {

 String get scheduleId; String get workspaceId; String get projectId; String get reportType; String get contractVersion; String get reportVersion; AiReportScheduleCadence get cadence; String get timeZoneId; String get localTime; String? get weekday; int? get dayOfMonth; String get executionUserId; DateTime get nextRunAtUtc; bool get enabled; List<AiReportScheduleRecipientResponse> get recipients;
/// Create a copy of AiReportScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiReportScheduleResponseCopyWith<AiReportScheduleResponse> get copyWith => _$AiReportScheduleResponseCopyWithImpl<AiReportScheduleResponse>(this as AiReportScheduleResponse, _$identity);

  /// Serializes this AiReportScheduleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiReportScheduleResponse&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.reportVersion, reportVersion) || other.reportVersion == reportVersion)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.executionUserId, executionUserId) || other.executionUserId == executionUserId)&&(identical(other.nextRunAtUtc, nextRunAtUtc) || other.nextRunAtUtc == nextRunAtUtc)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.recipients, recipients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scheduleId,workspaceId,projectId,reportType,contractVersion,reportVersion,cadence,timeZoneId,localTime,weekday,dayOfMonth,executionUserId,nextRunAtUtc,enabled,const DeepCollectionEquality().hash(recipients));

@override
String toString() {
  return 'AiReportScheduleResponse(scheduleId: $scheduleId, workspaceId: $workspaceId, projectId: $projectId, reportType: $reportType, contractVersion: $contractVersion, reportVersion: $reportVersion, cadence: $cadence, timeZoneId: $timeZoneId, localTime: $localTime, weekday: $weekday, dayOfMonth: $dayOfMonth, executionUserId: $executionUserId, nextRunAtUtc: $nextRunAtUtc, enabled: $enabled, recipients: $recipients)';
}


}

/// @nodoc
abstract mixin class $AiReportScheduleResponseCopyWith<$Res>  {
  factory $AiReportScheduleResponseCopyWith(AiReportScheduleResponse value, $Res Function(AiReportScheduleResponse) _then) = _$AiReportScheduleResponseCopyWithImpl;
@useResult
$Res call({
 String scheduleId, String workspaceId, String projectId, String reportType, String contractVersion, String reportVersion, AiReportScheduleCadence cadence, String timeZoneId, String localTime, String? weekday, int? dayOfMonth, String executionUserId, DateTime nextRunAtUtc, bool enabled, List<AiReportScheduleRecipientResponse> recipients
});




}
/// @nodoc
class _$AiReportScheduleResponseCopyWithImpl<$Res>
    implements $AiReportScheduleResponseCopyWith<$Res> {
  _$AiReportScheduleResponseCopyWithImpl(this._self, this._then);

  final AiReportScheduleResponse _self;
  final $Res Function(AiReportScheduleResponse) _then;

/// Create a copy of AiReportScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleId = null,Object? workspaceId = null,Object? projectId = null,Object? reportType = null,Object? contractVersion = null,Object? reportVersion = null,Object? cadence = null,Object? timeZoneId = null,Object? localTime = null,Object? weekday = freezed,Object? dayOfMonth = freezed,Object? executionUserId = null,Object? nextRunAtUtc = null,Object? enabled = null,Object? recipients = null,}) {
  return _then(_self.copyWith(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,reportVersion: null == reportVersion ? _self.reportVersion : reportVersion // ignore: cast_nullable_to_non_nullable
as String,cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as AiReportScheduleCadence,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as String,weekday: freezed == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as String?,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,executionUserId: null == executionUserId ? _self.executionUserId : executionUserId // ignore: cast_nullable_to_non_nullable
as String,nextRunAtUtc: null == nextRunAtUtc ? _self.nextRunAtUtc : nextRunAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,recipients: null == recipients ? _self.recipients : recipients // ignore: cast_nullable_to_non_nullable
as List<AiReportScheduleRecipientResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiReportScheduleResponse].
extension AiReportScheduleResponsePatterns on AiReportScheduleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiReportScheduleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiReportScheduleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiReportScheduleResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiReportScheduleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiReportScheduleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiReportScheduleResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String scheduleId,  String workspaceId,  String projectId,  String reportType,  String contractVersion,  String reportVersion,  AiReportScheduleCadence cadence,  String timeZoneId,  String localTime,  String? weekday,  int? dayOfMonth,  String executionUserId,  DateTime nextRunAtUtc,  bool enabled,  List<AiReportScheduleRecipientResponse> recipients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiReportScheduleResponse() when $default != null:
return $default(_that.scheduleId,_that.workspaceId,_that.projectId,_that.reportType,_that.contractVersion,_that.reportVersion,_that.cadence,_that.timeZoneId,_that.localTime,_that.weekday,_that.dayOfMonth,_that.executionUserId,_that.nextRunAtUtc,_that.enabled,_that.recipients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String scheduleId,  String workspaceId,  String projectId,  String reportType,  String contractVersion,  String reportVersion,  AiReportScheduleCadence cadence,  String timeZoneId,  String localTime,  String? weekday,  int? dayOfMonth,  String executionUserId,  DateTime nextRunAtUtc,  bool enabled,  List<AiReportScheduleRecipientResponse> recipients)  $default,) {final _that = this;
switch (_that) {
case _AiReportScheduleResponse():
return $default(_that.scheduleId,_that.workspaceId,_that.projectId,_that.reportType,_that.contractVersion,_that.reportVersion,_that.cadence,_that.timeZoneId,_that.localTime,_that.weekday,_that.dayOfMonth,_that.executionUserId,_that.nextRunAtUtc,_that.enabled,_that.recipients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String scheduleId,  String workspaceId,  String projectId,  String reportType,  String contractVersion,  String reportVersion,  AiReportScheduleCadence cadence,  String timeZoneId,  String localTime,  String? weekday,  int? dayOfMonth,  String executionUserId,  DateTime nextRunAtUtc,  bool enabled,  List<AiReportScheduleRecipientResponse> recipients)?  $default,) {final _that = this;
switch (_that) {
case _AiReportScheduleResponse() when $default != null:
return $default(_that.scheduleId,_that.workspaceId,_that.projectId,_that.reportType,_that.contractVersion,_that.reportVersion,_that.cadence,_that.timeZoneId,_that.localTime,_that.weekday,_that.dayOfMonth,_that.executionUserId,_that.nextRunAtUtc,_that.enabled,_that.recipients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiReportScheduleResponse implements AiReportScheduleResponse {
  const _AiReportScheduleResponse({required this.scheduleId, required this.workspaceId, required this.projectId, required this.reportType, required this.contractVersion, required this.reportVersion, required this.cadence, required this.timeZoneId, required this.localTime, this.weekday, this.dayOfMonth, required this.executionUserId, required this.nextRunAtUtc, required this.enabled, required this.recipients});
  factory _AiReportScheduleResponse.fromJson(Map<String, dynamic> json) => _$AiReportScheduleResponseFromJson(json);

@override final  String scheduleId;
@override final  String workspaceId;
@override final  String projectId;
@override final  String reportType;
@override final  String contractVersion;
@override final  String reportVersion;
@override final  AiReportScheduleCadence cadence;
@override final  String timeZoneId;
@override final  String localTime;
@override final  String? weekday;
@override final  int? dayOfMonth;
@override final  String executionUserId;
@override final  DateTime nextRunAtUtc;
@override final  bool enabled;
@override final  List<AiReportScheduleRecipientResponse> recipients;

/// Create a copy of AiReportScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiReportScheduleResponseCopyWith<_AiReportScheduleResponse> get copyWith => __$AiReportScheduleResponseCopyWithImpl<_AiReportScheduleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiReportScheduleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiReportScheduleResponse&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.reportVersion, reportVersion) || other.reportVersion == reportVersion)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.executionUserId, executionUserId) || other.executionUserId == executionUserId)&&(identical(other.nextRunAtUtc, nextRunAtUtc) || other.nextRunAtUtc == nextRunAtUtc)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.recipients, recipients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scheduleId,workspaceId,projectId,reportType,contractVersion,reportVersion,cadence,timeZoneId,localTime,weekday,dayOfMonth,executionUserId,nextRunAtUtc,enabled,const DeepCollectionEquality().hash(recipients));

@override
String toString() {
  return 'AiReportScheduleResponse(scheduleId: $scheduleId, workspaceId: $workspaceId, projectId: $projectId, reportType: $reportType, contractVersion: $contractVersion, reportVersion: $reportVersion, cadence: $cadence, timeZoneId: $timeZoneId, localTime: $localTime, weekday: $weekday, dayOfMonth: $dayOfMonth, executionUserId: $executionUserId, nextRunAtUtc: $nextRunAtUtc, enabled: $enabled, recipients: $recipients)';
}


}

/// @nodoc
abstract mixin class _$AiReportScheduleResponseCopyWith<$Res> implements $AiReportScheduleResponseCopyWith<$Res> {
  factory _$AiReportScheduleResponseCopyWith(_AiReportScheduleResponse value, $Res Function(_AiReportScheduleResponse) _then) = __$AiReportScheduleResponseCopyWithImpl;
@override @useResult
$Res call({
 String scheduleId, String workspaceId, String projectId, String reportType, String contractVersion, String reportVersion, AiReportScheduleCadence cadence, String timeZoneId, String localTime, String? weekday, int? dayOfMonth, String executionUserId, DateTime nextRunAtUtc, bool enabled, List<AiReportScheduleRecipientResponse> recipients
});




}
/// @nodoc
class __$AiReportScheduleResponseCopyWithImpl<$Res>
    implements _$AiReportScheduleResponseCopyWith<$Res> {
  __$AiReportScheduleResponseCopyWithImpl(this._self, this._then);

  final _AiReportScheduleResponse _self;
  final $Res Function(_AiReportScheduleResponse) _then;

/// Create a copy of AiReportScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleId = null,Object? workspaceId = null,Object? projectId = null,Object? reportType = null,Object? contractVersion = null,Object? reportVersion = null,Object? cadence = null,Object? timeZoneId = null,Object? localTime = null,Object? weekday = freezed,Object? dayOfMonth = freezed,Object? executionUserId = null,Object? nextRunAtUtc = null,Object? enabled = null,Object? recipients = null,}) {
  return _then(_AiReportScheduleResponse(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,reportVersion: null == reportVersion ? _self.reportVersion : reportVersion // ignore: cast_nullable_to_non_nullable
as String,cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as AiReportScheduleCadence,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as String,weekday: freezed == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as String?,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,executionUserId: null == executionUserId ? _self.executionUserId : executionUserId // ignore: cast_nullable_to_non_nullable
as String,nextRunAtUtc: null == nextRunAtUtc ? _self.nextRunAtUtc : nextRunAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,recipients: null == recipients ? _self.recipients : recipients // ignore: cast_nullable_to_non_nullable
as List<AiReportScheduleRecipientResponse>,
  ));
}


}


/// @nodoc
mixin _$AiReportScheduleRunResponse {

 String get runId; String get scheduleId; String get occurrenceKey; DateTime get scheduledForUtc; String? get reportJobId; AiReportScheduleRunStatus get status; int get runAttemptCount; int get maxAttempts; DateTime get nextAttemptAtUtc; DateTime get createdAtUtc; DateTime? get completedAtUtc; String? get lastError;
/// Create a copy of AiReportScheduleRunResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiReportScheduleRunResponseCopyWith<AiReportScheduleRunResponse> get copyWith => _$AiReportScheduleRunResponseCopyWithImpl<AiReportScheduleRunResponse>(this as AiReportScheduleRunResponse, _$identity);

  /// Serializes this AiReportScheduleRunResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiReportScheduleRunResponse&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.occurrenceKey, occurrenceKey) || other.occurrenceKey == occurrenceKey)&&(identical(other.scheduledForUtc, scheduledForUtc) || other.scheduledForUtc == scheduledForUtc)&&(identical(other.reportJobId, reportJobId) || other.reportJobId == reportJobId)&&(identical(other.status, status) || other.status == status)&&(identical(other.runAttemptCount, runAttemptCount) || other.runAttemptCount == runAttemptCount)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.nextAttemptAtUtc, nextAttemptAtUtc) || other.nextAttemptAtUtc == nextAttemptAtUtc)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,scheduleId,occurrenceKey,scheduledForUtc,reportJobId,status,runAttemptCount,maxAttempts,nextAttemptAtUtc,createdAtUtc,completedAtUtc,lastError);

@override
String toString() {
  return 'AiReportScheduleRunResponse(runId: $runId, scheduleId: $scheduleId, occurrenceKey: $occurrenceKey, scheduledForUtc: $scheduledForUtc, reportJobId: $reportJobId, status: $status, runAttemptCount: $runAttemptCount, maxAttempts: $maxAttempts, nextAttemptAtUtc: $nextAttemptAtUtc, createdAtUtc: $createdAtUtc, completedAtUtc: $completedAtUtc, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class $AiReportScheduleRunResponseCopyWith<$Res>  {
  factory $AiReportScheduleRunResponseCopyWith(AiReportScheduleRunResponse value, $Res Function(AiReportScheduleRunResponse) _then) = _$AiReportScheduleRunResponseCopyWithImpl;
@useResult
$Res call({
 String runId, String scheduleId, String occurrenceKey, DateTime scheduledForUtc, String? reportJobId, AiReportScheduleRunStatus status, int runAttemptCount, int maxAttempts, DateTime nextAttemptAtUtc, DateTime createdAtUtc, DateTime? completedAtUtc, String? lastError
});




}
/// @nodoc
class _$AiReportScheduleRunResponseCopyWithImpl<$Res>
    implements $AiReportScheduleRunResponseCopyWith<$Res> {
  _$AiReportScheduleRunResponseCopyWithImpl(this._self, this._then);

  final AiReportScheduleRunResponse _self;
  final $Res Function(AiReportScheduleRunResponse) _then;

/// Create a copy of AiReportScheduleRunResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runId = null,Object? scheduleId = null,Object? occurrenceKey = null,Object? scheduledForUtc = null,Object? reportJobId = freezed,Object? status = null,Object? runAttemptCount = null,Object? maxAttempts = null,Object? nextAttemptAtUtc = null,Object? createdAtUtc = null,Object? completedAtUtc = freezed,Object? lastError = freezed,}) {
  return _then(_self.copyWith(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,occurrenceKey: null == occurrenceKey ? _self.occurrenceKey : occurrenceKey // ignore: cast_nullable_to_non_nullable
as String,scheduledForUtc: null == scheduledForUtc ? _self.scheduledForUtc : scheduledForUtc // ignore: cast_nullable_to_non_nullable
as DateTime,reportJobId: freezed == reportJobId ? _self.reportJobId : reportJobId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiReportScheduleRunStatus,runAttemptCount: null == runAttemptCount ? _self.runAttemptCount : runAttemptCount // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,nextAttemptAtUtc: null == nextAttemptAtUtc ? _self.nextAttemptAtUtc : nextAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiReportScheduleRunResponse].
extension AiReportScheduleRunResponsePatterns on AiReportScheduleRunResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiReportScheduleRunResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiReportScheduleRunResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiReportScheduleRunResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiReportScheduleRunResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiReportScheduleRunResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiReportScheduleRunResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String runId,  String scheduleId,  String occurrenceKey,  DateTime scheduledForUtc,  String? reportJobId,  AiReportScheduleRunStatus status,  int runAttemptCount,  int maxAttempts,  DateTime nextAttemptAtUtc,  DateTime createdAtUtc,  DateTime? completedAtUtc,  String? lastError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiReportScheduleRunResponse() when $default != null:
return $default(_that.runId,_that.scheduleId,_that.occurrenceKey,_that.scheduledForUtc,_that.reportJobId,_that.status,_that.runAttemptCount,_that.maxAttempts,_that.nextAttemptAtUtc,_that.createdAtUtc,_that.completedAtUtc,_that.lastError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String runId,  String scheduleId,  String occurrenceKey,  DateTime scheduledForUtc,  String? reportJobId,  AiReportScheduleRunStatus status,  int runAttemptCount,  int maxAttempts,  DateTime nextAttemptAtUtc,  DateTime createdAtUtc,  DateTime? completedAtUtc,  String? lastError)  $default,) {final _that = this;
switch (_that) {
case _AiReportScheduleRunResponse():
return $default(_that.runId,_that.scheduleId,_that.occurrenceKey,_that.scheduledForUtc,_that.reportJobId,_that.status,_that.runAttemptCount,_that.maxAttempts,_that.nextAttemptAtUtc,_that.createdAtUtc,_that.completedAtUtc,_that.lastError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String runId,  String scheduleId,  String occurrenceKey,  DateTime scheduledForUtc,  String? reportJobId,  AiReportScheduleRunStatus status,  int runAttemptCount,  int maxAttempts,  DateTime nextAttemptAtUtc,  DateTime createdAtUtc,  DateTime? completedAtUtc,  String? lastError)?  $default,) {final _that = this;
switch (_that) {
case _AiReportScheduleRunResponse() when $default != null:
return $default(_that.runId,_that.scheduleId,_that.occurrenceKey,_that.scheduledForUtc,_that.reportJobId,_that.status,_that.runAttemptCount,_that.maxAttempts,_that.nextAttemptAtUtc,_that.createdAtUtc,_that.completedAtUtc,_that.lastError);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiReportScheduleRunResponse implements AiReportScheduleRunResponse {
  const _AiReportScheduleRunResponse({required this.runId, required this.scheduleId, required this.occurrenceKey, required this.scheduledForUtc, this.reportJobId, required this.status, required this.runAttemptCount, required this.maxAttempts, required this.nextAttemptAtUtc, required this.createdAtUtc, this.completedAtUtc, this.lastError});
  factory _AiReportScheduleRunResponse.fromJson(Map<String, dynamic> json) => _$AiReportScheduleRunResponseFromJson(json);

@override final  String runId;
@override final  String scheduleId;
@override final  String occurrenceKey;
@override final  DateTime scheduledForUtc;
@override final  String? reportJobId;
@override final  AiReportScheduleRunStatus status;
@override final  int runAttemptCount;
@override final  int maxAttempts;
@override final  DateTime nextAttemptAtUtc;
@override final  DateTime createdAtUtc;
@override final  DateTime? completedAtUtc;
@override final  String? lastError;

/// Create a copy of AiReportScheduleRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiReportScheduleRunResponseCopyWith<_AiReportScheduleRunResponse> get copyWith => __$AiReportScheduleRunResponseCopyWithImpl<_AiReportScheduleRunResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiReportScheduleRunResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiReportScheduleRunResponse&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.occurrenceKey, occurrenceKey) || other.occurrenceKey == occurrenceKey)&&(identical(other.scheduledForUtc, scheduledForUtc) || other.scheduledForUtc == scheduledForUtc)&&(identical(other.reportJobId, reportJobId) || other.reportJobId == reportJobId)&&(identical(other.status, status) || other.status == status)&&(identical(other.runAttemptCount, runAttemptCount) || other.runAttemptCount == runAttemptCount)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.nextAttemptAtUtc, nextAttemptAtUtc) || other.nextAttemptAtUtc == nextAttemptAtUtc)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,scheduleId,occurrenceKey,scheduledForUtc,reportJobId,status,runAttemptCount,maxAttempts,nextAttemptAtUtc,createdAtUtc,completedAtUtc,lastError);

@override
String toString() {
  return 'AiReportScheduleRunResponse(runId: $runId, scheduleId: $scheduleId, occurrenceKey: $occurrenceKey, scheduledForUtc: $scheduledForUtc, reportJobId: $reportJobId, status: $status, runAttemptCount: $runAttemptCount, maxAttempts: $maxAttempts, nextAttemptAtUtc: $nextAttemptAtUtc, createdAtUtc: $createdAtUtc, completedAtUtc: $completedAtUtc, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class _$AiReportScheduleRunResponseCopyWith<$Res> implements $AiReportScheduleRunResponseCopyWith<$Res> {
  factory _$AiReportScheduleRunResponseCopyWith(_AiReportScheduleRunResponse value, $Res Function(_AiReportScheduleRunResponse) _then) = __$AiReportScheduleRunResponseCopyWithImpl;
@override @useResult
$Res call({
 String runId, String scheduleId, String occurrenceKey, DateTime scheduledForUtc, String? reportJobId, AiReportScheduleRunStatus status, int runAttemptCount, int maxAttempts, DateTime nextAttemptAtUtc, DateTime createdAtUtc, DateTime? completedAtUtc, String? lastError
});




}
/// @nodoc
class __$AiReportScheduleRunResponseCopyWithImpl<$Res>
    implements _$AiReportScheduleRunResponseCopyWith<$Res> {
  __$AiReportScheduleRunResponseCopyWithImpl(this._self, this._then);

  final _AiReportScheduleRunResponse _self;
  final $Res Function(_AiReportScheduleRunResponse) _then;

/// Create a copy of AiReportScheduleRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runId = null,Object? scheduleId = null,Object? occurrenceKey = null,Object? scheduledForUtc = null,Object? reportJobId = freezed,Object? status = null,Object? runAttemptCount = null,Object? maxAttempts = null,Object? nextAttemptAtUtc = null,Object? createdAtUtc = null,Object? completedAtUtc = freezed,Object? lastError = freezed,}) {
  return _then(_AiReportScheduleRunResponse(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,occurrenceKey: null == occurrenceKey ? _self.occurrenceKey : occurrenceKey // ignore: cast_nullable_to_non_nullable
as String,scheduledForUtc: null == scheduledForUtc ? _self.scheduledForUtc : scheduledForUtc // ignore: cast_nullable_to_non_nullable
as DateTime,reportJobId: freezed == reportJobId ? _self.reportJobId : reportJobId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiReportScheduleRunStatus,runAttemptCount: null == runAttemptCount ? _self.runAttemptCount : runAttemptCount // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,nextAttemptAtUtc: null == nextAttemptAtUtc ? _self.nextAttemptAtUtc : nextAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AiReportDeliveryResponse {

 String get deliveryId; String get scheduleRunId; String get reportJobId; String get recipientUserId; AiReportDeliveryChannel get channel; AiReportDeliveryStatus get status; int get attemptCount; int get maxAttempts; DateTime get availableAtUtc; DateTime? get deliveredAtUtc; DateTime? get failedAtUtc; DateTime? get sentUnknownAtUtc; String? get lastError;
/// Create a copy of AiReportDeliveryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiReportDeliveryResponseCopyWith<AiReportDeliveryResponse> get copyWith => _$AiReportDeliveryResponseCopyWithImpl<AiReportDeliveryResponse>(this as AiReportDeliveryResponse, _$identity);

  /// Serializes this AiReportDeliveryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiReportDeliveryResponse&&(identical(other.deliveryId, deliveryId) || other.deliveryId == deliveryId)&&(identical(other.scheduleRunId, scheduleRunId) || other.scheduleRunId == scheduleRunId)&&(identical(other.reportJobId, reportJobId) || other.reportJobId == reportJobId)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.status, status) || other.status == status)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.availableAtUtc, availableAtUtc) || other.availableAtUtc == availableAtUtc)&&(identical(other.deliveredAtUtc, deliveredAtUtc) || other.deliveredAtUtc == deliveredAtUtc)&&(identical(other.failedAtUtc, failedAtUtc) || other.failedAtUtc == failedAtUtc)&&(identical(other.sentUnknownAtUtc, sentUnknownAtUtc) || other.sentUnknownAtUtc == sentUnknownAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deliveryId,scheduleRunId,reportJobId,recipientUserId,channel,status,attemptCount,maxAttempts,availableAtUtc,deliveredAtUtc,failedAtUtc,sentUnknownAtUtc,lastError);

@override
String toString() {
  return 'AiReportDeliveryResponse(deliveryId: $deliveryId, scheduleRunId: $scheduleRunId, reportJobId: $reportJobId, recipientUserId: $recipientUserId, channel: $channel, status: $status, attemptCount: $attemptCount, maxAttempts: $maxAttempts, availableAtUtc: $availableAtUtc, deliveredAtUtc: $deliveredAtUtc, failedAtUtc: $failedAtUtc, sentUnknownAtUtc: $sentUnknownAtUtc, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class $AiReportDeliveryResponseCopyWith<$Res>  {
  factory $AiReportDeliveryResponseCopyWith(AiReportDeliveryResponse value, $Res Function(AiReportDeliveryResponse) _then) = _$AiReportDeliveryResponseCopyWithImpl;
@useResult
$Res call({
 String deliveryId, String scheduleRunId, String reportJobId, String recipientUserId, AiReportDeliveryChannel channel, AiReportDeliveryStatus status, int attemptCount, int maxAttempts, DateTime availableAtUtc, DateTime? deliveredAtUtc, DateTime? failedAtUtc, DateTime? sentUnknownAtUtc, String? lastError
});




}
/// @nodoc
class _$AiReportDeliveryResponseCopyWithImpl<$Res>
    implements $AiReportDeliveryResponseCopyWith<$Res> {
  _$AiReportDeliveryResponseCopyWithImpl(this._self, this._then);

  final AiReportDeliveryResponse _self;
  final $Res Function(AiReportDeliveryResponse) _then;

/// Create a copy of AiReportDeliveryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deliveryId = null,Object? scheduleRunId = null,Object? reportJobId = null,Object? recipientUserId = null,Object? channel = null,Object? status = null,Object? attemptCount = null,Object? maxAttempts = null,Object? availableAtUtc = null,Object? deliveredAtUtc = freezed,Object? failedAtUtc = freezed,Object? sentUnknownAtUtc = freezed,Object? lastError = freezed,}) {
  return _then(_self.copyWith(
deliveryId: null == deliveryId ? _self.deliveryId : deliveryId // ignore: cast_nullable_to_non_nullable
as String,scheduleRunId: null == scheduleRunId ? _self.scheduleRunId : scheduleRunId // ignore: cast_nullable_to_non_nullable
as String,reportJobId: null == reportJobId ? _self.reportJobId : reportJobId // ignore: cast_nullable_to_non_nullable
as String,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as AiReportDeliveryChannel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiReportDeliveryStatus,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,availableAtUtc: null == availableAtUtc ? _self.availableAtUtc : availableAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,deliveredAtUtc: freezed == deliveredAtUtc ? _self.deliveredAtUtc : deliveredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,failedAtUtc: freezed == failedAtUtc ? _self.failedAtUtc : failedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,sentUnknownAtUtc: freezed == sentUnknownAtUtc ? _self.sentUnknownAtUtc : sentUnknownAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiReportDeliveryResponse].
extension AiReportDeliveryResponsePatterns on AiReportDeliveryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiReportDeliveryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiReportDeliveryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiReportDeliveryResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiReportDeliveryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiReportDeliveryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiReportDeliveryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deliveryId,  String scheduleRunId,  String reportJobId,  String recipientUserId,  AiReportDeliveryChannel channel,  AiReportDeliveryStatus status,  int attemptCount,  int maxAttempts,  DateTime availableAtUtc,  DateTime? deliveredAtUtc,  DateTime? failedAtUtc,  DateTime? sentUnknownAtUtc,  String? lastError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiReportDeliveryResponse() when $default != null:
return $default(_that.deliveryId,_that.scheduleRunId,_that.reportJobId,_that.recipientUserId,_that.channel,_that.status,_that.attemptCount,_that.maxAttempts,_that.availableAtUtc,_that.deliveredAtUtc,_that.failedAtUtc,_that.sentUnknownAtUtc,_that.lastError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deliveryId,  String scheduleRunId,  String reportJobId,  String recipientUserId,  AiReportDeliveryChannel channel,  AiReportDeliveryStatus status,  int attemptCount,  int maxAttempts,  DateTime availableAtUtc,  DateTime? deliveredAtUtc,  DateTime? failedAtUtc,  DateTime? sentUnknownAtUtc,  String? lastError)  $default,) {final _that = this;
switch (_that) {
case _AiReportDeliveryResponse():
return $default(_that.deliveryId,_that.scheduleRunId,_that.reportJobId,_that.recipientUserId,_that.channel,_that.status,_that.attemptCount,_that.maxAttempts,_that.availableAtUtc,_that.deliveredAtUtc,_that.failedAtUtc,_that.sentUnknownAtUtc,_that.lastError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deliveryId,  String scheduleRunId,  String reportJobId,  String recipientUserId,  AiReportDeliveryChannel channel,  AiReportDeliveryStatus status,  int attemptCount,  int maxAttempts,  DateTime availableAtUtc,  DateTime? deliveredAtUtc,  DateTime? failedAtUtc,  DateTime? sentUnknownAtUtc,  String? lastError)?  $default,) {final _that = this;
switch (_that) {
case _AiReportDeliveryResponse() when $default != null:
return $default(_that.deliveryId,_that.scheduleRunId,_that.reportJobId,_that.recipientUserId,_that.channel,_that.status,_that.attemptCount,_that.maxAttempts,_that.availableAtUtc,_that.deliveredAtUtc,_that.failedAtUtc,_that.sentUnknownAtUtc,_that.lastError);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiReportDeliveryResponse implements AiReportDeliveryResponse {
  const _AiReportDeliveryResponse({required this.deliveryId, required this.scheduleRunId, required this.reportJobId, required this.recipientUserId, required this.channel, required this.status, required this.attemptCount, required this.maxAttempts, required this.availableAtUtc, this.deliveredAtUtc, this.failedAtUtc, this.sentUnknownAtUtc, this.lastError});
  factory _AiReportDeliveryResponse.fromJson(Map<String, dynamic> json) => _$AiReportDeliveryResponseFromJson(json);

@override final  String deliveryId;
@override final  String scheduleRunId;
@override final  String reportJobId;
@override final  String recipientUserId;
@override final  AiReportDeliveryChannel channel;
@override final  AiReportDeliveryStatus status;
@override final  int attemptCount;
@override final  int maxAttempts;
@override final  DateTime availableAtUtc;
@override final  DateTime? deliveredAtUtc;
@override final  DateTime? failedAtUtc;
@override final  DateTime? sentUnknownAtUtc;
@override final  String? lastError;

/// Create a copy of AiReportDeliveryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiReportDeliveryResponseCopyWith<_AiReportDeliveryResponse> get copyWith => __$AiReportDeliveryResponseCopyWithImpl<_AiReportDeliveryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiReportDeliveryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiReportDeliveryResponse&&(identical(other.deliveryId, deliveryId) || other.deliveryId == deliveryId)&&(identical(other.scheduleRunId, scheduleRunId) || other.scheduleRunId == scheduleRunId)&&(identical(other.reportJobId, reportJobId) || other.reportJobId == reportJobId)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.status, status) || other.status == status)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.availableAtUtc, availableAtUtc) || other.availableAtUtc == availableAtUtc)&&(identical(other.deliveredAtUtc, deliveredAtUtc) || other.deliveredAtUtc == deliveredAtUtc)&&(identical(other.failedAtUtc, failedAtUtc) || other.failedAtUtc == failedAtUtc)&&(identical(other.sentUnknownAtUtc, sentUnknownAtUtc) || other.sentUnknownAtUtc == sentUnknownAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deliveryId,scheduleRunId,reportJobId,recipientUserId,channel,status,attemptCount,maxAttempts,availableAtUtc,deliveredAtUtc,failedAtUtc,sentUnknownAtUtc,lastError);

@override
String toString() {
  return 'AiReportDeliveryResponse(deliveryId: $deliveryId, scheduleRunId: $scheduleRunId, reportJobId: $reportJobId, recipientUserId: $recipientUserId, channel: $channel, status: $status, attemptCount: $attemptCount, maxAttempts: $maxAttempts, availableAtUtc: $availableAtUtc, deliveredAtUtc: $deliveredAtUtc, failedAtUtc: $failedAtUtc, sentUnknownAtUtc: $sentUnknownAtUtc, lastError: $lastError)';
}


}

/// @nodoc
abstract mixin class _$AiReportDeliveryResponseCopyWith<$Res> implements $AiReportDeliveryResponseCopyWith<$Res> {
  factory _$AiReportDeliveryResponseCopyWith(_AiReportDeliveryResponse value, $Res Function(_AiReportDeliveryResponse) _then) = __$AiReportDeliveryResponseCopyWithImpl;
@override @useResult
$Res call({
 String deliveryId, String scheduleRunId, String reportJobId, String recipientUserId, AiReportDeliveryChannel channel, AiReportDeliveryStatus status, int attemptCount, int maxAttempts, DateTime availableAtUtc, DateTime? deliveredAtUtc, DateTime? failedAtUtc, DateTime? sentUnknownAtUtc, String? lastError
});




}
/// @nodoc
class __$AiReportDeliveryResponseCopyWithImpl<$Res>
    implements _$AiReportDeliveryResponseCopyWith<$Res> {
  __$AiReportDeliveryResponseCopyWithImpl(this._self, this._then);

  final _AiReportDeliveryResponse _self;
  final $Res Function(_AiReportDeliveryResponse) _then;

/// Create a copy of AiReportDeliveryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deliveryId = null,Object? scheduleRunId = null,Object? reportJobId = null,Object? recipientUserId = null,Object? channel = null,Object? status = null,Object? attemptCount = null,Object? maxAttempts = null,Object? availableAtUtc = null,Object? deliveredAtUtc = freezed,Object? failedAtUtc = freezed,Object? sentUnknownAtUtc = freezed,Object? lastError = freezed,}) {
  return _then(_AiReportDeliveryResponse(
deliveryId: null == deliveryId ? _self.deliveryId : deliveryId // ignore: cast_nullable_to_non_nullable
as String,scheduleRunId: null == scheduleRunId ? _self.scheduleRunId : scheduleRunId // ignore: cast_nullable_to_non_nullable
as String,reportJobId: null == reportJobId ? _self.reportJobId : reportJobId // ignore: cast_nullable_to_non_nullable
as String,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as AiReportDeliveryChannel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiReportDeliveryStatus,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,availableAtUtc: null == availableAtUtc ? _self.availableAtUtc : availableAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,deliveredAtUtc: freezed == deliveredAtUtc ? _self.deliveredAtUtc : deliveredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,failedAtUtc: freezed == failedAtUtc ? _self.failedAtUtc : failedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,sentUnknownAtUtc: freezed == sentUnknownAtUtc ? _self.sentUnknownAtUtc : sentUnknownAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ResolveAiReportDeliveryPayload {

 AiReportDeliveryResolutionStatus get targetStatus; String? get error;
/// Create a copy of ResolveAiReportDeliveryPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolveAiReportDeliveryPayloadCopyWith<ResolveAiReportDeliveryPayload> get copyWith => _$ResolveAiReportDeliveryPayloadCopyWithImpl<ResolveAiReportDeliveryPayload>(this as ResolveAiReportDeliveryPayload, _$identity);

  /// Serializes this ResolveAiReportDeliveryPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolveAiReportDeliveryPayload&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetStatus,error);

@override
String toString() {
  return 'ResolveAiReportDeliveryPayload(targetStatus: $targetStatus, error: $error)';
}


}

/// @nodoc
abstract mixin class $ResolveAiReportDeliveryPayloadCopyWith<$Res>  {
  factory $ResolveAiReportDeliveryPayloadCopyWith(ResolveAiReportDeliveryPayload value, $Res Function(ResolveAiReportDeliveryPayload) _then) = _$ResolveAiReportDeliveryPayloadCopyWithImpl;
@useResult
$Res call({
 AiReportDeliveryResolutionStatus targetStatus, String? error
});




}
/// @nodoc
class _$ResolveAiReportDeliveryPayloadCopyWithImpl<$Res>
    implements $ResolveAiReportDeliveryPayloadCopyWith<$Res> {
  _$ResolveAiReportDeliveryPayloadCopyWithImpl(this._self, this._then);

  final ResolveAiReportDeliveryPayload _self;
  final $Res Function(ResolveAiReportDeliveryPayload) _then;

/// Create a copy of ResolveAiReportDeliveryPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetStatus = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
targetStatus: null == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as AiReportDeliveryResolutionStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResolveAiReportDeliveryPayload].
extension ResolveAiReportDeliveryPayloadPatterns on ResolveAiReportDeliveryPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResolveAiReportDeliveryPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResolveAiReportDeliveryPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResolveAiReportDeliveryPayload value)  $default,){
final _that = this;
switch (_that) {
case _ResolveAiReportDeliveryPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResolveAiReportDeliveryPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ResolveAiReportDeliveryPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiReportDeliveryResolutionStatus targetStatus,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResolveAiReportDeliveryPayload() when $default != null:
return $default(_that.targetStatus,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiReportDeliveryResolutionStatus targetStatus,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ResolveAiReportDeliveryPayload():
return $default(_that.targetStatus,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiReportDeliveryResolutionStatus targetStatus,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ResolveAiReportDeliveryPayload() when $default != null:
return $default(_that.targetStatus,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResolveAiReportDeliveryPayload implements ResolveAiReportDeliveryPayload {
  const _ResolveAiReportDeliveryPayload({required this.targetStatus, this.error});
  factory _ResolveAiReportDeliveryPayload.fromJson(Map<String, dynamic> json) => _$ResolveAiReportDeliveryPayloadFromJson(json);

@override final  AiReportDeliveryResolutionStatus targetStatus;
@override final  String? error;

/// Create a copy of ResolveAiReportDeliveryPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResolveAiReportDeliveryPayloadCopyWith<_ResolveAiReportDeliveryPayload> get copyWith => __$ResolveAiReportDeliveryPayloadCopyWithImpl<_ResolveAiReportDeliveryPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResolveAiReportDeliveryPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResolveAiReportDeliveryPayload&&(identical(other.targetStatus, targetStatus) || other.targetStatus == targetStatus)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetStatus,error);

@override
String toString() {
  return 'ResolveAiReportDeliveryPayload(targetStatus: $targetStatus, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ResolveAiReportDeliveryPayloadCopyWith<$Res> implements $ResolveAiReportDeliveryPayloadCopyWith<$Res> {
  factory _$ResolveAiReportDeliveryPayloadCopyWith(_ResolveAiReportDeliveryPayload value, $Res Function(_ResolveAiReportDeliveryPayload) _then) = __$ResolveAiReportDeliveryPayloadCopyWithImpl;
@override @useResult
$Res call({
 AiReportDeliveryResolutionStatus targetStatus, String? error
});




}
/// @nodoc
class __$ResolveAiReportDeliveryPayloadCopyWithImpl<$Res>
    implements _$ResolveAiReportDeliveryPayloadCopyWith<$Res> {
  __$ResolveAiReportDeliveryPayloadCopyWithImpl(this._self, this._then);

  final _ResolveAiReportDeliveryPayload _self;
  final $Res Function(_ResolveAiReportDeliveryPayload) _then;

/// Create a copy of ResolveAiReportDeliveryPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetStatus = null,Object? error = freezed,}) {
  return _then(_ResolveAiReportDeliveryPayload(
targetStatus: null == targetStatus ? _self.targetStatus : targetStatus // ignore: cast_nullable_to_non_nullable
as AiReportDeliveryResolutionStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AiReportAuditEventResponse {

 String get eventId; String get reportJobId; String get workspaceId; String get projectId; String get requestedByUserId; String get operationType; String get contractVersion; String get promptVersion; AiOperationAuditEventType get eventType; AiProviderKind? get provider; String? get model; int get attempt; int get inputCharacters; int get outputBytes; StorageAiReportFailureCode? get failureCode; DateTime get occurredAtUtc;
/// Create a copy of AiReportAuditEventResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiReportAuditEventResponseCopyWith<AiReportAuditEventResponse> get copyWith => _$AiReportAuditEventResponseCopyWithImpl<AiReportAuditEventResponse>(this as AiReportAuditEventResponse, _$identity);

  /// Serializes this AiReportAuditEventResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiReportAuditEventResponse&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.reportJobId, reportJobId) || other.reportJobId == reportJobId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.requestedByUserId, requestedByUserId) || other.requestedByUserId == requestedByUserId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.promptVersion, promptVersion) || other.promptVersion == promptVersion)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.attempt, attempt) || other.attempt == attempt)&&(identical(other.inputCharacters, inputCharacters) || other.inputCharacters == inputCharacters)&&(identical(other.outputBytes, outputBytes) || other.outputBytes == outputBytes)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,reportJobId,workspaceId,projectId,requestedByUserId,operationType,contractVersion,promptVersion,eventType,provider,model,attempt,inputCharacters,outputBytes,failureCode,occurredAtUtc);

@override
String toString() {
  return 'AiReportAuditEventResponse(eventId: $eventId, reportJobId: $reportJobId, workspaceId: $workspaceId, projectId: $projectId, requestedByUserId: $requestedByUserId, operationType: $operationType, contractVersion: $contractVersion, promptVersion: $promptVersion, eventType: $eventType, provider: $provider, model: $model, attempt: $attempt, inputCharacters: $inputCharacters, outputBytes: $outputBytes, failureCode: $failureCode, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class $AiReportAuditEventResponseCopyWith<$Res>  {
  factory $AiReportAuditEventResponseCopyWith(AiReportAuditEventResponse value, $Res Function(AiReportAuditEventResponse) _then) = _$AiReportAuditEventResponseCopyWithImpl;
@useResult
$Res call({
 String eventId, String reportJobId, String workspaceId, String projectId, String requestedByUserId, String operationType, String contractVersion, String promptVersion, AiOperationAuditEventType eventType, AiProviderKind? provider, String? model, int attempt, int inputCharacters, int outputBytes, StorageAiReportFailureCode? failureCode, DateTime occurredAtUtc
});




}
/// @nodoc
class _$AiReportAuditEventResponseCopyWithImpl<$Res>
    implements $AiReportAuditEventResponseCopyWith<$Res> {
  _$AiReportAuditEventResponseCopyWithImpl(this._self, this._then);

  final AiReportAuditEventResponse _self;
  final $Res Function(AiReportAuditEventResponse) _then;

/// Create a copy of AiReportAuditEventResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? reportJobId = null,Object? workspaceId = null,Object? projectId = null,Object? requestedByUserId = null,Object? operationType = null,Object? contractVersion = null,Object? promptVersion = null,Object? eventType = null,Object? provider = freezed,Object? model = freezed,Object? attempt = null,Object? inputCharacters = null,Object? outputBytes = null,Object? failureCode = freezed,Object? occurredAtUtc = null,}) {
  return _then(_self.copyWith(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,reportJobId: null == reportJobId ? _self.reportJobId : reportJobId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,requestedByUserId: null == requestedByUserId ? _self.requestedByUserId : requestedByUserId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,promptVersion: null == promptVersion ? _self.promptVersion : promptVersion // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as AiOperationAuditEventType,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,inputCharacters: null == inputCharacters ? _self.inputCharacters : inputCharacters // ignore: cast_nullable_to_non_nullable
as int,outputBytes: null == outputBytes ? _self.outputBytes : outputBytes // ignore: cast_nullable_to_non_nullable
as int,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as StorageAiReportFailureCode?,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AiReportAuditEventResponse].
extension AiReportAuditEventResponsePatterns on AiReportAuditEventResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiReportAuditEventResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiReportAuditEventResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiReportAuditEventResponse value)  $default,){
final _that = this;
switch (_that) {
case _AiReportAuditEventResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiReportAuditEventResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AiReportAuditEventResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  String reportJobId,  String workspaceId,  String projectId,  String requestedByUserId,  String operationType,  String contractVersion,  String promptVersion,  AiOperationAuditEventType eventType,  AiProviderKind? provider,  String? model,  int attempt,  int inputCharacters,  int outputBytes,  StorageAiReportFailureCode? failureCode,  DateTime occurredAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiReportAuditEventResponse() when $default != null:
return $default(_that.eventId,_that.reportJobId,_that.workspaceId,_that.projectId,_that.requestedByUserId,_that.operationType,_that.contractVersion,_that.promptVersion,_that.eventType,_that.provider,_that.model,_that.attempt,_that.inputCharacters,_that.outputBytes,_that.failureCode,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  String reportJobId,  String workspaceId,  String projectId,  String requestedByUserId,  String operationType,  String contractVersion,  String promptVersion,  AiOperationAuditEventType eventType,  AiProviderKind? provider,  String? model,  int attempt,  int inputCharacters,  int outputBytes,  StorageAiReportFailureCode? failureCode,  DateTime occurredAtUtc)  $default,) {final _that = this;
switch (_that) {
case _AiReportAuditEventResponse():
return $default(_that.eventId,_that.reportJobId,_that.workspaceId,_that.projectId,_that.requestedByUserId,_that.operationType,_that.contractVersion,_that.promptVersion,_that.eventType,_that.provider,_that.model,_that.attempt,_that.inputCharacters,_that.outputBytes,_that.failureCode,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  String reportJobId,  String workspaceId,  String projectId,  String requestedByUserId,  String operationType,  String contractVersion,  String promptVersion,  AiOperationAuditEventType eventType,  AiProviderKind? provider,  String? model,  int attempt,  int inputCharacters,  int outputBytes,  StorageAiReportFailureCode? failureCode,  DateTime occurredAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _AiReportAuditEventResponse() when $default != null:
return $default(_that.eventId,_that.reportJobId,_that.workspaceId,_that.projectId,_that.requestedByUserId,_that.operationType,_that.contractVersion,_that.promptVersion,_that.eventType,_that.provider,_that.model,_that.attempt,_that.inputCharacters,_that.outputBytes,_that.failureCode,_that.occurredAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiReportAuditEventResponse implements AiReportAuditEventResponse {
  const _AiReportAuditEventResponse({required this.eventId, required this.reportJobId, required this.workspaceId, required this.projectId, required this.requestedByUserId, required this.operationType, required this.contractVersion, required this.promptVersion, required this.eventType, this.provider, this.model, required this.attempt, required this.inputCharacters, required this.outputBytes, this.failureCode, required this.occurredAtUtc});
  factory _AiReportAuditEventResponse.fromJson(Map<String, dynamic> json) => _$AiReportAuditEventResponseFromJson(json);

@override final  String eventId;
@override final  String reportJobId;
@override final  String workspaceId;
@override final  String projectId;
@override final  String requestedByUserId;
@override final  String operationType;
@override final  String contractVersion;
@override final  String promptVersion;
@override final  AiOperationAuditEventType eventType;
@override final  AiProviderKind? provider;
@override final  String? model;
@override final  int attempt;
@override final  int inputCharacters;
@override final  int outputBytes;
@override final  StorageAiReportFailureCode? failureCode;
@override final  DateTime occurredAtUtc;

/// Create a copy of AiReportAuditEventResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiReportAuditEventResponseCopyWith<_AiReportAuditEventResponse> get copyWith => __$AiReportAuditEventResponseCopyWithImpl<_AiReportAuditEventResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiReportAuditEventResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiReportAuditEventResponse&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.reportJobId, reportJobId) || other.reportJobId == reportJobId)&&(identical(other.workspaceId, workspaceId) || other.workspaceId == workspaceId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.requestedByUserId, requestedByUserId) || other.requestedByUserId == requestedByUserId)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.promptVersion, promptVersion) || other.promptVersion == promptVersion)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.attempt, attempt) || other.attempt == attempt)&&(identical(other.inputCharacters, inputCharacters) || other.inputCharacters == inputCharacters)&&(identical(other.outputBytes, outputBytes) || other.outputBytes == outputBytes)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,reportJobId,workspaceId,projectId,requestedByUserId,operationType,contractVersion,promptVersion,eventType,provider,model,attempt,inputCharacters,outputBytes,failureCode,occurredAtUtc);

@override
String toString() {
  return 'AiReportAuditEventResponse(eventId: $eventId, reportJobId: $reportJobId, workspaceId: $workspaceId, projectId: $projectId, requestedByUserId: $requestedByUserId, operationType: $operationType, contractVersion: $contractVersion, promptVersion: $promptVersion, eventType: $eventType, provider: $provider, model: $model, attempt: $attempt, inputCharacters: $inputCharacters, outputBytes: $outputBytes, failureCode: $failureCode, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class _$AiReportAuditEventResponseCopyWith<$Res> implements $AiReportAuditEventResponseCopyWith<$Res> {
  factory _$AiReportAuditEventResponseCopyWith(_AiReportAuditEventResponse value, $Res Function(_AiReportAuditEventResponse) _then) = __$AiReportAuditEventResponseCopyWithImpl;
@override @useResult
$Res call({
 String eventId, String reportJobId, String workspaceId, String projectId, String requestedByUserId, String operationType, String contractVersion, String promptVersion, AiOperationAuditEventType eventType, AiProviderKind? provider, String? model, int attempt, int inputCharacters, int outputBytes, StorageAiReportFailureCode? failureCode, DateTime occurredAtUtc
});




}
/// @nodoc
class __$AiReportAuditEventResponseCopyWithImpl<$Res>
    implements _$AiReportAuditEventResponseCopyWith<$Res> {
  __$AiReportAuditEventResponseCopyWithImpl(this._self, this._then);

  final _AiReportAuditEventResponse _self;
  final $Res Function(_AiReportAuditEventResponse) _then;

/// Create a copy of AiReportAuditEventResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? reportJobId = null,Object? workspaceId = null,Object? projectId = null,Object? requestedByUserId = null,Object? operationType = null,Object? contractVersion = null,Object? promptVersion = null,Object? eventType = null,Object? provider = freezed,Object? model = freezed,Object? attempt = null,Object? inputCharacters = null,Object? outputBytes = null,Object? failureCode = freezed,Object? occurredAtUtc = null,}) {
  return _then(_AiReportAuditEventResponse(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,reportJobId: null == reportJobId ? _self.reportJobId : reportJobId // ignore: cast_nullable_to_non_nullable
as String,workspaceId: null == workspaceId ? _self.workspaceId : workspaceId // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,requestedByUserId: null == requestedByUserId ? _self.requestedByUserId : requestedByUserId // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,contractVersion: null == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String,promptVersion: null == promptVersion ? _self.promptVersion : promptVersion // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as AiOperationAuditEventType,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,inputCharacters: null == inputCharacters ? _self.inputCharacters : inputCharacters // ignore: cast_nullable_to_non_nullable
as int,outputBytes: null == outputBytes ? _self.outputBytes : outputBytes // ignore: cast_nullable_to_non_nullable
as int,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as StorageAiReportFailureCode?,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StorageFileAnalysisJobResponse {

 String get jobId; String get fileId; int get fileVersion; StorageFileAnalysisJobStatus get status; int get attemptCount; int get maxAttempts; DateTime? get nextAttemptAtUtc; String? get lastError; AiProviderKind get provider; AiProviderStatus get providerStatus; bool get retryable; DateTime? get lastAttemptAtUtc; StorageAnalysisFailureCode? get failureCode; String? get contractVersion; String? get operationId; AiOperationStatus? get operationLifecycleStatus; int? get retryAfterSeconds; StorageFileAnalysisErrorResponse? get error;
/// Create a copy of StorageFileAnalysisJobResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFileAnalysisJobResponseCopyWith<StorageFileAnalysisJobResponse> get copyWith => _$StorageFileAnalysisJobResponseCopyWithImpl<StorageFileAnalysisJobResponse>(this as StorageFileAnalysisJobResponse, _$identity);

  /// Serializes this StorageFileAnalysisJobResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFileAnalysisJobResponse&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileVersion, fileVersion) || other.fileVersion == fileVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.nextAttemptAtUtc, nextAttemptAtUtc) || other.nextAttemptAtUtc == nextAttemptAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.providerStatus, providerStatus) || other.providerStatus == providerStatus)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.lastAttemptAtUtc, lastAttemptAtUtc) || other.lastAttemptAtUtc == lastAttemptAtUtc)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationLifecycleStatus, operationLifecycleStatus) || other.operationLifecycleStatus == operationLifecycleStatus)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,fileId,fileVersion,status,attemptCount,maxAttempts,nextAttemptAtUtc,lastError,provider,providerStatus,retryable,lastAttemptAtUtc,failureCode,contractVersion,operationId,operationLifecycleStatus,retryAfterSeconds,error);

@override
String toString() {
  return 'StorageFileAnalysisJobResponse(jobId: $jobId, fileId: $fileId, fileVersion: $fileVersion, status: $status, attemptCount: $attemptCount, maxAttempts: $maxAttempts, nextAttemptAtUtc: $nextAttemptAtUtc, lastError: $lastError, provider: $provider, providerStatus: $providerStatus, retryable: $retryable, lastAttemptAtUtc: $lastAttemptAtUtc, failureCode: $failureCode, contractVersion: $contractVersion, operationId: $operationId, operationLifecycleStatus: $operationLifecycleStatus, retryAfterSeconds: $retryAfterSeconds, error: $error)';
}


}

/// @nodoc
abstract mixin class $StorageFileAnalysisJobResponseCopyWith<$Res>  {
  factory $StorageFileAnalysisJobResponseCopyWith(StorageFileAnalysisJobResponse value, $Res Function(StorageFileAnalysisJobResponse) _then) = _$StorageFileAnalysisJobResponseCopyWithImpl;
@useResult
$Res call({
 String jobId, String fileId, int fileVersion, StorageFileAnalysisJobStatus status, int attemptCount, int maxAttempts, DateTime? nextAttemptAtUtc, String? lastError, AiProviderKind provider, AiProviderStatus providerStatus, bool retryable, DateTime? lastAttemptAtUtc, StorageAnalysisFailureCode? failureCode, String? contractVersion, String? operationId, AiOperationStatus? operationLifecycleStatus, int? retryAfterSeconds, StorageFileAnalysisErrorResponse? error
});


$StorageFileAnalysisErrorResponseCopyWith<$Res>? get error;

}
/// @nodoc
class _$StorageFileAnalysisJobResponseCopyWithImpl<$Res>
    implements $StorageFileAnalysisJobResponseCopyWith<$Res> {
  _$StorageFileAnalysisJobResponseCopyWithImpl(this._self, this._then);

  final StorageFileAnalysisJobResponse _self;
  final $Res Function(StorageFileAnalysisJobResponse) _then;

/// Create a copy of StorageFileAnalysisJobResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobId = null,Object? fileId = null,Object? fileVersion = null,Object? status = null,Object? attemptCount = null,Object? maxAttempts = null,Object? nextAttemptAtUtc = freezed,Object? lastError = freezed,Object? provider = null,Object? providerStatus = null,Object? retryable = null,Object? lastAttemptAtUtc = freezed,Object? failureCode = freezed,Object? contractVersion = freezed,Object? operationId = freezed,Object? operationLifecycleStatus = freezed,Object? retryAfterSeconds = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileVersion: null == fileVersion ? _self.fileVersion : fileVersion // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StorageFileAnalysisJobStatus,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,nextAttemptAtUtc: freezed == nextAttemptAtUtc ? _self.nextAttemptAtUtc : nextAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind,providerStatus: null == providerStatus ? _self.providerStatus : providerStatus // ignore: cast_nullable_to_non_nullable
as AiProviderStatus,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,lastAttemptAtUtc: freezed == lastAttemptAtUtc ? _self.lastAttemptAtUtc : lastAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as StorageAnalysisFailureCode?,contractVersion: freezed == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String?,operationId: freezed == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String?,operationLifecycleStatus: freezed == operationLifecycleStatus ? _self.operationLifecycleStatus : operationLifecycleStatus // ignore: cast_nullable_to_non_nullable
as AiOperationStatus?,retryAfterSeconds: freezed == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as StorageFileAnalysisErrorResponse?,
  ));
}
/// Create a copy of StorageFileAnalysisJobResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFileAnalysisErrorResponseCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $StorageFileAnalysisErrorResponseCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [StorageFileAnalysisJobResponse].
extension StorageFileAnalysisJobResponsePatterns on StorageFileAnalysisJobResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFileAnalysisJobResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFileAnalysisJobResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFileAnalysisJobResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFileAnalysisJobResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFileAnalysisJobResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFileAnalysisJobResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jobId,  String fileId,  int fileVersion,  StorageFileAnalysisJobStatus status,  int attemptCount,  int maxAttempts,  DateTime? nextAttemptAtUtc,  String? lastError,  AiProviderKind provider,  AiProviderStatus providerStatus,  bool retryable,  DateTime? lastAttemptAtUtc,  StorageAnalysisFailureCode? failureCode,  String? contractVersion,  String? operationId,  AiOperationStatus? operationLifecycleStatus,  int? retryAfterSeconds,  StorageFileAnalysisErrorResponse? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFileAnalysisJobResponse() when $default != null:
return $default(_that.jobId,_that.fileId,_that.fileVersion,_that.status,_that.attemptCount,_that.maxAttempts,_that.nextAttemptAtUtc,_that.lastError,_that.provider,_that.providerStatus,_that.retryable,_that.lastAttemptAtUtc,_that.failureCode,_that.contractVersion,_that.operationId,_that.operationLifecycleStatus,_that.retryAfterSeconds,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jobId,  String fileId,  int fileVersion,  StorageFileAnalysisJobStatus status,  int attemptCount,  int maxAttempts,  DateTime? nextAttemptAtUtc,  String? lastError,  AiProviderKind provider,  AiProviderStatus providerStatus,  bool retryable,  DateTime? lastAttemptAtUtc,  StorageAnalysisFailureCode? failureCode,  String? contractVersion,  String? operationId,  AiOperationStatus? operationLifecycleStatus,  int? retryAfterSeconds,  StorageFileAnalysisErrorResponse? error)  $default,) {final _that = this;
switch (_that) {
case _StorageFileAnalysisJobResponse():
return $default(_that.jobId,_that.fileId,_that.fileVersion,_that.status,_that.attemptCount,_that.maxAttempts,_that.nextAttemptAtUtc,_that.lastError,_that.provider,_that.providerStatus,_that.retryable,_that.lastAttemptAtUtc,_that.failureCode,_that.contractVersion,_that.operationId,_that.operationLifecycleStatus,_that.retryAfterSeconds,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jobId,  String fileId,  int fileVersion,  StorageFileAnalysisJobStatus status,  int attemptCount,  int maxAttempts,  DateTime? nextAttemptAtUtc,  String? lastError,  AiProviderKind provider,  AiProviderStatus providerStatus,  bool retryable,  DateTime? lastAttemptAtUtc,  StorageAnalysisFailureCode? failureCode,  String? contractVersion,  String? operationId,  AiOperationStatus? operationLifecycleStatus,  int? retryAfterSeconds,  StorageFileAnalysisErrorResponse? error)?  $default,) {final _that = this;
switch (_that) {
case _StorageFileAnalysisJobResponse() when $default != null:
return $default(_that.jobId,_that.fileId,_that.fileVersion,_that.status,_that.attemptCount,_that.maxAttempts,_that.nextAttemptAtUtc,_that.lastError,_that.provider,_that.providerStatus,_that.retryable,_that.lastAttemptAtUtc,_that.failureCode,_that.contractVersion,_that.operationId,_that.operationLifecycleStatus,_that.retryAfterSeconds,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFileAnalysisJobResponse implements StorageFileAnalysisJobResponse {
  const _StorageFileAnalysisJobResponse({required this.jobId, required this.fileId, required this.fileVersion, required this.status, required this.attemptCount, required this.maxAttempts, this.nextAttemptAtUtc, this.lastError, this.provider = AiProviderKind.disabled, this.providerStatus = AiProviderStatus.unknown, this.retryable = true, this.lastAttemptAtUtc, this.failureCode, this.contractVersion, this.operationId, this.operationLifecycleStatus, this.retryAfterSeconds, this.error});
  factory _StorageFileAnalysisJobResponse.fromJson(Map<String, dynamic> json) => _$StorageFileAnalysisJobResponseFromJson(json);

@override final  String jobId;
@override final  String fileId;
@override final  int fileVersion;
@override final  StorageFileAnalysisJobStatus status;
@override final  int attemptCount;
@override final  int maxAttempts;
@override final  DateTime? nextAttemptAtUtc;
@override final  String? lastError;
@override@JsonKey() final  AiProviderKind provider;
@override@JsonKey() final  AiProviderStatus providerStatus;
@override@JsonKey() final  bool retryable;
@override final  DateTime? lastAttemptAtUtc;
@override final  StorageAnalysisFailureCode? failureCode;
@override final  String? contractVersion;
@override final  String? operationId;
@override final  AiOperationStatus? operationLifecycleStatus;
@override final  int? retryAfterSeconds;
@override final  StorageFileAnalysisErrorResponse? error;

/// Create a copy of StorageFileAnalysisJobResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFileAnalysisJobResponseCopyWith<_StorageFileAnalysisJobResponse> get copyWith => __$StorageFileAnalysisJobResponseCopyWithImpl<_StorageFileAnalysisJobResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFileAnalysisJobResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFileAnalysisJobResponse&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileVersion, fileVersion) || other.fileVersion == fileVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.nextAttemptAtUtc, nextAttemptAtUtc) || other.nextAttemptAtUtc == nextAttemptAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.providerStatus, providerStatus) || other.providerStatus == providerStatus)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.lastAttemptAtUtc, lastAttemptAtUtc) || other.lastAttemptAtUtc == lastAttemptAtUtc)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationLifecycleStatus, operationLifecycleStatus) || other.operationLifecycleStatus == operationLifecycleStatus)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,fileId,fileVersion,status,attemptCount,maxAttempts,nextAttemptAtUtc,lastError,provider,providerStatus,retryable,lastAttemptAtUtc,failureCode,contractVersion,operationId,operationLifecycleStatus,retryAfterSeconds,error);

@override
String toString() {
  return 'StorageFileAnalysisJobResponse(jobId: $jobId, fileId: $fileId, fileVersion: $fileVersion, status: $status, attemptCount: $attemptCount, maxAttempts: $maxAttempts, nextAttemptAtUtc: $nextAttemptAtUtc, lastError: $lastError, provider: $provider, providerStatus: $providerStatus, retryable: $retryable, lastAttemptAtUtc: $lastAttemptAtUtc, failureCode: $failureCode, contractVersion: $contractVersion, operationId: $operationId, operationLifecycleStatus: $operationLifecycleStatus, retryAfterSeconds: $retryAfterSeconds, error: $error)';
}


}

/// @nodoc
abstract mixin class _$StorageFileAnalysisJobResponseCopyWith<$Res> implements $StorageFileAnalysisJobResponseCopyWith<$Res> {
  factory _$StorageFileAnalysisJobResponseCopyWith(_StorageFileAnalysisJobResponse value, $Res Function(_StorageFileAnalysisJobResponse) _then) = __$StorageFileAnalysisJobResponseCopyWithImpl;
@override @useResult
$Res call({
 String jobId, String fileId, int fileVersion, StorageFileAnalysisJobStatus status, int attemptCount, int maxAttempts, DateTime? nextAttemptAtUtc, String? lastError, AiProviderKind provider, AiProviderStatus providerStatus, bool retryable, DateTime? lastAttemptAtUtc, StorageAnalysisFailureCode? failureCode, String? contractVersion, String? operationId, AiOperationStatus? operationLifecycleStatus, int? retryAfterSeconds, StorageFileAnalysisErrorResponse? error
});


@override $StorageFileAnalysisErrorResponseCopyWith<$Res>? get error;

}
/// @nodoc
class __$StorageFileAnalysisJobResponseCopyWithImpl<$Res>
    implements _$StorageFileAnalysisJobResponseCopyWith<$Res> {
  __$StorageFileAnalysisJobResponseCopyWithImpl(this._self, this._then);

  final _StorageFileAnalysisJobResponse _self;
  final $Res Function(_StorageFileAnalysisJobResponse) _then;

/// Create a copy of StorageFileAnalysisJobResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobId = null,Object? fileId = null,Object? fileVersion = null,Object? status = null,Object? attemptCount = null,Object? maxAttempts = null,Object? nextAttemptAtUtc = freezed,Object? lastError = freezed,Object? provider = null,Object? providerStatus = null,Object? retryable = null,Object? lastAttemptAtUtc = freezed,Object? failureCode = freezed,Object? contractVersion = freezed,Object? operationId = freezed,Object? operationLifecycleStatus = freezed,Object? retryAfterSeconds = freezed,Object? error = freezed,}) {
  return _then(_StorageFileAnalysisJobResponse(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileVersion: null == fileVersion ? _self.fileVersion : fileVersion // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StorageFileAnalysisJobStatus,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,nextAttemptAtUtc: freezed == nextAttemptAtUtc ? _self.nextAttemptAtUtc : nextAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind,providerStatus: null == providerStatus ? _self.providerStatus : providerStatus // ignore: cast_nullable_to_non_nullable
as AiProviderStatus,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,lastAttemptAtUtc: freezed == lastAttemptAtUtc ? _self.lastAttemptAtUtc : lastAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as StorageAnalysisFailureCode?,contractVersion: freezed == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String?,operationId: freezed == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String?,operationLifecycleStatus: freezed == operationLifecycleStatus ? _self.operationLifecycleStatus : operationLifecycleStatus // ignore: cast_nullable_to_non_nullable
as AiOperationStatus?,retryAfterSeconds: freezed == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as StorageFileAnalysisErrorResponse?,
  ));
}

/// Create a copy of StorageFileAnalysisJobResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFileAnalysisErrorResponseCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $StorageFileAnalysisErrorResponseCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
mixin _$StorageFileAnalysisStatusResponse {

 String get fileId; int get fileVersion; StorageScanStatus get scanStatus; StorageAiStatus get status; String? get jobId; StorageFileAnalysisJobStatus? get jobStatus; int get attemptCount; int get maxAttempts; AiProviderKind get provider; AiProviderStatus get providerStatus; bool get retryable; DateTime? get createdAtUtc; DateTime? get updatedAtUtc; DateTime? get startedAtUtc; DateTime? get completedAtUtc; DateTime? get failedAtUtc; DateTime? get nextAttemptAtUtc; String? get lastError; StorageAnalysisFailureCode? get failureCode; String? get contractVersion; String? get operationId; AiOperationStatus? get operationLifecycleStatus; int? get retryAfterSeconds; StorageFileAnalysisErrorResponse? get error;
/// Create a copy of StorageFileAnalysisStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFileAnalysisStatusResponseCopyWith<StorageFileAnalysisStatusResponse> get copyWith => _$StorageFileAnalysisStatusResponseCopyWithImpl<StorageFileAnalysisStatusResponse>(this as StorageFileAnalysisStatusResponse, _$identity);

  /// Serializes this StorageFileAnalysisStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFileAnalysisStatusResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileVersion, fileVersion) || other.fileVersion == fileVersion)&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobStatus, jobStatus) || other.jobStatus == jobStatus)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.providerStatus, providerStatus) || other.providerStatus == providerStatus)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.startedAtUtc, startedAtUtc) || other.startedAtUtc == startedAtUtc)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc)&&(identical(other.failedAtUtc, failedAtUtc) || other.failedAtUtc == failedAtUtc)&&(identical(other.nextAttemptAtUtc, nextAttemptAtUtc) || other.nextAttemptAtUtc == nextAttemptAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationLifecycleStatus, operationLifecycleStatus) || other.operationLifecycleStatus == operationLifecycleStatus)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,fileId,fileVersion,scanStatus,status,jobId,jobStatus,attemptCount,maxAttempts,provider,providerStatus,retryable,createdAtUtc,updatedAtUtc,startedAtUtc,completedAtUtc,failedAtUtc,nextAttemptAtUtc,lastError,failureCode,contractVersion,operationId,operationLifecycleStatus,retryAfterSeconds,error]);

@override
String toString() {
  return 'StorageFileAnalysisStatusResponse(fileId: $fileId, fileVersion: $fileVersion, scanStatus: $scanStatus, status: $status, jobId: $jobId, jobStatus: $jobStatus, attemptCount: $attemptCount, maxAttempts: $maxAttempts, provider: $provider, providerStatus: $providerStatus, retryable: $retryable, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, startedAtUtc: $startedAtUtc, completedAtUtc: $completedAtUtc, failedAtUtc: $failedAtUtc, nextAttemptAtUtc: $nextAttemptAtUtc, lastError: $lastError, failureCode: $failureCode, contractVersion: $contractVersion, operationId: $operationId, operationLifecycleStatus: $operationLifecycleStatus, retryAfterSeconds: $retryAfterSeconds, error: $error)';
}


}

/// @nodoc
abstract mixin class $StorageFileAnalysisStatusResponseCopyWith<$Res>  {
  factory $StorageFileAnalysisStatusResponseCopyWith(StorageFileAnalysisStatusResponse value, $Res Function(StorageFileAnalysisStatusResponse) _then) = _$StorageFileAnalysisStatusResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, int fileVersion, StorageScanStatus scanStatus, StorageAiStatus status, String? jobId, StorageFileAnalysisJobStatus? jobStatus, int attemptCount, int maxAttempts, AiProviderKind provider, AiProviderStatus providerStatus, bool retryable, DateTime? createdAtUtc, DateTime? updatedAtUtc, DateTime? startedAtUtc, DateTime? completedAtUtc, DateTime? failedAtUtc, DateTime? nextAttemptAtUtc, String? lastError, StorageAnalysisFailureCode? failureCode, String? contractVersion, String? operationId, AiOperationStatus? operationLifecycleStatus, int? retryAfterSeconds, StorageFileAnalysisErrorResponse? error
});


$StorageFileAnalysisErrorResponseCopyWith<$Res>? get error;

}
/// @nodoc
class _$StorageFileAnalysisStatusResponseCopyWithImpl<$Res>
    implements $StorageFileAnalysisStatusResponseCopyWith<$Res> {
  _$StorageFileAnalysisStatusResponseCopyWithImpl(this._self, this._then);

  final StorageFileAnalysisStatusResponse _self;
  final $Res Function(StorageFileAnalysisStatusResponse) _then;

/// Create a copy of StorageFileAnalysisStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? fileVersion = null,Object? scanStatus = null,Object? status = null,Object? jobId = freezed,Object? jobStatus = freezed,Object? attemptCount = null,Object? maxAttempts = null,Object? provider = null,Object? providerStatus = null,Object? retryable = null,Object? createdAtUtc = freezed,Object? updatedAtUtc = freezed,Object? startedAtUtc = freezed,Object? completedAtUtc = freezed,Object? failedAtUtc = freezed,Object? nextAttemptAtUtc = freezed,Object? lastError = freezed,Object? failureCode = freezed,Object? contractVersion = freezed,Object? operationId = freezed,Object? operationLifecycleStatus = freezed,Object? retryAfterSeconds = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileVersion: null == fileVersion ? _self.fileVersion : fileVersion // ignore: cast_nullable_to_non_nullable
as int,scanStatus: null == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as StorageScanStatus,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StorageAiStatus,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobStatus: freezed == jobStatus ? _self.jobStatus : jobStatus // ignore: cast_nullable_to_non_nullable
as StorageFileAnalysisJobStatus?,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind,providerStatus: null == providerStatus ? _self.providerStatus : providerStatus // ignore: cast_nullable_to_non_nullable
as AiProviderStatus,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: freezed == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAtUtc: freezed == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,failedAtUtc: freezed == failedAtUtc ? _self.failedAtUtc : failedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,nextAttemptAtUtc: freezed == nextAttemptAtUtc ? _self.nextAttemptAtUtc : nextAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as StorageAnalysisFailureCode?,contractVersion: freezed == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String?,operationId: freezed == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String?,operationLifecycleStatus: freezed == operationLifecycleStatus ? _self.operationLifecycleStatus : operationLifecycleStatus // ignore: cast_nullable_to_non_nullable
as AiOperationStatus?,retryAfterSeconds: freezed == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as StorageFileAnalysisErrorResponse?,
  ));
}
/// Create a copy of StorageFileAnalysisStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFileAnalysisErrorResponseCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $StorageFileAnalysisErrorResponseCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [StorageFileAnalysisStatusResponse].
extension StorageFileAnalysisStatusResponsePatterns on StorageFileAnalysisStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFileAnalysisStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFileAnalysisStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFileAnalysisStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFileAnalysisStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFileAnalysisStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFileAnalysisStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  int fileVersion,  StorageScanStatus scanStatus,  StorageAiStatus status,  String? jobId,  StorageFileAnalysisJobStatus? jobStatus,  int attemptCount,  int maxAttempts,  AiProviderKind provider,  AiProviderStatus providerStatus,  bool retryable,  DateTime? createdAtUtc,  DateTime? updatedAtUtc,  DateTime? startedAtUtc,  DateTime? completedAtUtc,  DateTime? failedAtUtc,  DateTime? nextAttemptAtUtc,  String? lastError,  StorageAnalysisFailureCode? failureCode,  String? contractVersion,  String? operationId,  AiOperationStatus? operationLifecycleStatus,  int? retryAfterSeconds,  StorageFileAnalysisErrorResponse? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFileAnalysisStatusResponse() when $default != null:
return $default(_that.fileId,_that.fileVersion,_that.scanStatus,_that.status,_that.jobId,_that.jobStatus,_that.attemptCount,_that.maxAttempts,_that.provider,_that.providerStatus,_that.retryable,_that.createdAtUtc,_that.updatedAtUtc,_that.startedAtUtc,_that.completedAtUtc,_that.failedAtUtc,_that.nextAttemptAtUtc,_that.lastError,_that.failureCode,_that.contractVersion,_that.operationId,_that.operationLifecycleStatus,_that.retryAfterSeconds,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  int fileVersion,  StorageScanStatus scanStatus,  StorageAiStatus status,  String? jobId,  StorageFileAnalysisJobStatus? jobStatus,  int attemptCount,  int maxAttempts,  AiProviderKind provider,  AiProviderStatus providerStatus,  bool retryable,  DateTime? createdAtUtc,  DateTime? updatedAtUtc,  DateTime? startedAtUtc,  DateTime? completedAtUtc,  DateTime? failedAtUtc,  DateTime? nextAttemptAtUtc,  String? lastError,  StorageAnalysisFailureCode? failureCode,  String? contractVersion,  String? operationId,  AiOperationStatus? operationLifecycleStatus,  int? retryAfterSeconds,  StorageFileAnalysisErrorResponse? error)  $default,) {final _that = this;
switch (_that) {
case _StorageFileAnalysisStatusResponse():
return $default(_that.fileId,_that.fileVersion,_that.scanStatus,_that.status,_that.jobId,_that.jobStatus,_that.attemptCount,_that.maxAttempts,_that.provider,_that.providerStatus,_that.retryable,_that.createdAtUtc,_that.updatedAtUtc,_that.startedAtUtc,_that.completedAtUtc,_that.failedAtUtc,_that.nextAttemptAtUtc,_that.lastError,_that.failureCode,_that.contractVersion,_that.operationId,_that.operationLifecycleStatus,_that.retryAfterSeconds,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  int fileVersion,  StorageScanStatus scanStatus,  StorageAiStatus status,  String? jobId,  StorageFileAnalysisJobStatus? jobStatus,  int attemptCount,  int maxAttempts,  AiProviderKind provider,  AiProviderStatus providerStatus,  bool retryable,  DateTime? createdAtUtc,  DateTime? updatedAtUtc,  DateTime? startedAtUtc,  DateTime? completedAtUtc,  DateTime? failedAtUtc,  DateTime? nextAttemptAtUtc,  String? lastError,  StorageAnalysisFailureCode? failureCode,  String? contractVersion,  String? operationId,  AiOperationStatus? operationLifecycleStatus,  int? retryAfterSeconds,  StorageFileAnalysisErrorResponse? error)?  $default,) {final _that = this;
switch (_that) {
case _StorageFileAnalysisStatusResponse() when $default != null:
return $default(_that.fileId,_that.fileVersion,_that.scanStatus,_that.status,_that.jobId,_that.jobStatus,_that.attemptCount,_that.maxAttempts,_that.provider,_that.providerStatus,_that.retryable,_that.createdAtUtc,_that.updatedAtUtc,_that.startedAtUtc,_that.completedAtUtc,_that.failedAtUtc,_that.nextAttemptAtUtc,_that.lastError,_that.failureCode,_that.contractVersion,_that.operationId,_that.operationLifecycleStatus,_that.retryAfterSeconds,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFileAnalysisStatusResponse implements StorageFileAnalysisStatusResponse {
  const _StorageFileAnalysisStatusResponse({required this.fileId, required this.fileVersion, required this.scanStatus, required this.status, this.jobId, this.jobStatus, required this.attemptCount, required this.maxAttempts, required this.provider, required this.providerStatus, required this.retryable, this.createdAtUtc, this.updatedAtUtc, this.startedAtUtc, this.completedAtUtc, this.failedAtUtc, this.nextAttemptAtUtc, this.lastError, this.failureCode, this.contractVersion, this.operationId, this.operationLifecycleStatus, this.retryAfterSeconds, this.error});
  factory _StorageFileAnalysisStatusResponse.fromJson(Map<String, dynamic> json) => _$StorageFileAnalysisStatusResponseFromJson(json);

@override final  String fileId;
@override final  int fileVersion;
@override final  StorageScanStatus scanStatus;
@override final  StorageAiStatus status;
@override final  String? jobId;
@override final  StorageFileAnalysisJobStatus? jobStatus;
@override final  int attemptCount;
@override final  int maxAttempts;
@override final  AiProviderKind provider;
@override final  AiProviderStatus providerStatus;
@override final  bool retryable;
@override final  DateTime? createdAtUtc;
@override final  DateTime? updatedAtUtc;
@override final  DateTime? startedAtUtc;
@override final  DateTime? completedAtUtc;
@override final  DateTime? failedAtUtc;
@override final  DateTime? nextAttemptAtUtc;
@override final  String? lastError;
@override final  StorageAnalysisFailureCode? failureCode;
@override final  String? contractVersion;
@override final  String? operationId;
@override final  AiOperationStatus? operationLifecycleStatus;
@override final  int? retryAfterSeconds;
@override final  StorageFileAnalysisErrorResponse? error;

/// Create a copy of StorageFileAnalysisStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFileAnalysisStatusResponseCopyWith<_StorageFileAnalysisStatusResponse> get copyWith => __$StorageFileAnalysisStatusResponseCopyWithImpl<_StorageFileAnalysisStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFileAnalysisStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFileAnalysisStatusResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.fileVersion, fileVersion) || other.fileVersion == fileVersion)&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus)&&(identical(other.status, status) || other.status == status)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobStatus, jobStatus) || other.jobStatus == jobStatus)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.providerStatus, providerStatus) || other.providerStatus == providerStatus)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.startedAtUtc, startedAtUtc) || other.startedAtUtc == startedAtUtc)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc)&&(identical(other.failedAtUtc, failedAtUtc) || other.failedAtUtc == failedAtUtc)&&(identical(other.nextAttemptAtUtc, nextAttemptAtUtc) || other.nextAttemptAtUtc == nextAttemptAtUtc)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.contractVersion, contractVersion) || other.contractVersion == contractVersion)&&(identical(other.operationId, operationId) || other.operationId == operationId)&&(identical(other.operationLifecycleStatus, operationLifecycleStatus) || other.operationLifecycleStatus == operationLifecycleStatus)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,fileId,fileVersion,scanStatus,status,jobId,jobStatus,attemptCount,maxAttempts,provider,providerStatus,retryable,createdAtUtc,updatedAtUtc,startedAtUtc,completedAtUtc,failedAtUtc,nextAttemptAtUtc,lastError,failureCode,contractVersion,operationId,operationLifecycleStatus,retryAfterSeconds,error]);

@override
String toString() {
  return 'StorageFileAnalysisStatusResponse(fileId: $fileId, fileVersion: $fileVersion, scanStatus: $scanStatus, status: $status, jobId: $jobId, jobStatus: $jobStatus, attemptCount: $attemptCount, maxAttempts: $maxAttempts, provider: $provider, providerStatus: $providerStatus, retryable: $retryable, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, startedAtUtc: $startedAtUtc, completedAtUtc: $completedAtUtc, failedAtUtc: $failedAtUtc, nextAttemptAtUtc: $nextAttemptAtUtc, lastError: $lastError, failureCode: $failureCode, contractVersion: $contractVersion, operationId: $operationId, operationLifecycleStatus: $operationLifecycleStatus, retryAfterSeconds: $retryAfterSeconds, error: $error)';
}


}

/// @nodoc
abstract mixin class _$StorageFileAnalysisStatusResponseCopyWith<$Res> implements $StorageFileAnalysisStatusResponseCopyWith<$Res> {
  factory _$StorageFileAnalysisStatusResponseCopyWith(_StorageFileAnalysisStatusResponse value, $Res Function(_StorageFileAnalysisStatusResponse) _then) = __$StorageFileAnalysisStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, int fileVersion, StorageScanStatus scanStatus, StorageAiStatus status, String? jobId, StorageFileAnalysisJobStatus? jobStatus, int attemptCount, int maxAttempts, AiProviderKind provider, AiProviderStatus providerStatus, bool retryable, DateTime? createdAtUtc, DateTime? updatedAtUtc, DateTime? startedAtUtc, DateTime? completedAtUtc, DateTime? failedAtUtc, DateTime? nextAttemptAtUtc, String? lastError, StorageAnalysisFailureCode? failureCode, String? contractVersion, String? operationId, AiOperationStatus? operationLifecycleStatus, int? retryAfterSeconds, StorageFileAnalysisErrorResponse? error
});


@override $StorageFileAnalysisErrorResponseCopyWith<$Res>? get error;

}
/// @nodoc
class __$StorageFileAnalysisStatusResponseCopyWithImpl<$Res>
    implements _$StorageFileAnalysisStatusResponseCopyWith<$Res> {
  __$StorageFileAnalysisStatusResponseCopyWithImpl(this._self, this._then);

  final _StorageFileAnalysisStatusResponse _self;
  final $Res Function(_StorageFileAnalysisStatusResponse) _then;

/// Create a copy of StorageFileAnalysisStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? fileVersion = null,Object? scanStatus = null,Object? status = null,Object? jobId = freezed,Object? jobStatus = freezed,Object? attemptCount = null,Object? maxAttempts = null,Object? provider = null,Object? providerStatus = null,Object? retryable = null,Object? createdAtUtc = freezed,Object? updatedAtUtc = freezed,Object? startedAtUtc = freezed,Object? completedAtUtc = freezed,Object? failedAtUtc = freezed,Object? nextAttemptAtUtc = freezed,Object? lastError = freezed,Object? failureCode = freezed,Object? contractVersion = freezed,Object? operationId = freezed,Object? operationLifecycleStatus = freezed,Object? retryAfterSeconds = freezed,Object? error = freezed,}) {
  return _then(_StorageFileAnalysisStatusResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,fileVersion: null == fileVersion ? _self.fileVersion : fileVersion // ignore: cast_nullable_to_non_nullable
as int,scanStatus: null == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as StorageScanStatus,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StorageAiStatus,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,jobStatus: freezed == jobStatus ? _self.jobStatus : jobStatus // ignore: cast_nullable_to_non_nullable
as StorageFileAnalysisJobStatus?,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as AiProviderKind,providerStatus: null == providerStatus ? _self.providerStatus : providerStatus // ignore: cast_nullable_to_non_nullable
as AiProviderStatus,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,createdAtUtc: freezed == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAtUtc: freezed == startedAtUtc ? _self.startedAtUtc : startedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAtUtc: freezed == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,failedAtUtc: freezed == failedAtUtc ? _self.failedAtUtc : failedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,nextAttemptAtUtc: freezed == nextAttemptAtUtc ? _self.nextAttemptAtUtc : nextAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as StorageAnalysisFailureCode?,contractVersion: freezed == contractVersion ? _self.contractVersion : contractVersion // ignore: cast_nullable_to_non_nullable
as String?,operationId: freezed == operationId ? _self.operationId : operationId // ignore: cast_nullable_to_non_nullable
as String?,operationLifecycleStatus: freezed == operationLifecycleStatus ? _self.operationLifecycleStatus : operationLifecycleStatus // ignore: cast_nullable_to_non_nullable
as AiOperationStatus?,retryAfterSeconds: freezed == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as StorageFileAnalysisErrorResponse?,
  ));
}

/// Create a copy of StorageFileAnalysisStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StorageFileAnalysisErrorResponseCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $StorageFileAnalysisErrorResponseCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
mixin _$StorageFileAnalysisErrorResponse {

 String get code; String get message; bool get retryable; int? get retryAfterSeconds;
/// Create a copy of StorageFileAnalysisErrorResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFileAnalysisErrorResponseCopyWith<StorageFileAnalysisErrorResponse> get copyWith => _$StorageFileAnalysisErrorResponseCopyWithImpl<StorageFileAnalysisErrorResponse>(this as StorageFileAnalysisErrorResponse, _$identity);

  /// Serializes this StorageFileAnalysisErrorResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFileAnalysisErrorResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,retryable,retryAfterSeconds);

@override
String toString() {
  return 'StorageFileAnalysisErrorResponse(code: $code, message: $message, retryable: $retryable, retryAfterSeconds: $retryAfterSeconds)';
}


}

/// @nodoc
abstract mixin class $StorageFileAnalysisErrorResponseCopyWith<$Res>  {
  factory $StorageFileAnalysisErrorResponseCopyWith(StorageFileAnalysisErrorResponse value, $Res Function(StorageFileAnalysisErrorResponse) _then) = _$StorageFileAnalysisErrorResponseCopyWithImpl;
@useResult
$Res call({
 String code, String message, bool retryable, int? retryAfterSeconds
});




}
/// @nodoc
class _$StorageFileAnalysisErrorResponseCopyWithImpl<$Res>
    implements $StorageFileAnalysisErrorResponseCopyWith<$Res> {
  _$StorageFileAnalysisErrorResponseCopyWithImpl(this._self, this._then);

  final StorageFileAnalysisErrorResponse _self;
  final $Res Function(StorageFileAnalysisErrorResponse) _then;

/// Create a copy of StorageFileAnalysisErrorResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? retryable = null,Object? retryAfterSeconds = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,retryAfterSeconds: freezed == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageFileAnalysisErrorResponse].
extension StorageFileAnalysisErrorResponsePatterns on StorageFileAnalysisErrorResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageFileAnalysisErrorResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageFileAnalysisErrorResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageFileAnalysisErrorResponse value)  $default,){
final _that = this;
switch (_that) {
case _StorageFileAnalysisErrorResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageFileAnalysisErrorResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StorageFileAnalysisErrorResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  bool retryable,  int? retryAfterSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageFileAnalysisErrorResponse() when $default != null:
return $default(_that.code,_that.message,_that.retryable,_that.retryAfterSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  bool retryable,  int? retryAfterSeconds)  $default,) {final _that = this;
switch (_that) {
case _StorageFileAnalysisErrorResponse():
return $default(_that.code,_that.message,_that.retryable,_that.retryAfterSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  bool retryable,  int? retryAfterSeconds)?  $default,) {final _that = this;
switch (_that) {
case _StorageFileAnalysisErrorResponse() when $default != null:
return $default(_that.code,_that.message,_that.retryable,_that.retryAfterSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageFileAnalysisErrorResponse implements StorageFileAnalysisErrorResponse {
  const _StorageFileAnalysisErrorResponse({required this.code, required this.message, required this.retryable, this.retryAfterSeconds});
  factory _StorageFileAnalysisErrorResponse.fromJson(Map<String, dynamic> json) => _$StorageFileAnalysisErrorResponseFromJson(json);

@override final  String code;
@override final  String message;
@override final  bool retryable;
@override final  int? retryAfterSeconds;

/// Create a copy of StorageFileAnalysisErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageFileAnalysisErrorResponseCopyWith<_StorageFileAnalysisErrorResponse> get copyWith => __$StorageFileAnalysisErrorResponseCopyWithImpl<_StorageFileAnalysisErrorResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageFileAnalysisErrorResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageFileAnalysisErrorResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.retryAfterSeconds, retryAfterSeconds) || other.retryAfterSeconds == retryAfterSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,retryable,retryAfterSeconds);

@override
String toString() {
  return 'StorageFileAnalysisErrorResponse(code: $code, message: $message, retryable: $retryable, retryAfterSeconds: $retryAfterSeconds)';
}


}

/// @nodoc
abstract mixin class _$StorageFileAnalysisErrorResponseCopyWith<$Res> implements $StorageFileAnalysisErrorResponseCopyWith<$Res> {
  factory _$StorageFileAnalysisErrorResponseCopyWith(_StorageFileAnalysisErrorResponse value, $Res Function(_StorageFileAnalysisErrorResponse) _then) = __$StorageFileAnalysisErrorResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, bool retryable, int? retryAfterSeconds
});




}
/// @nodoc
class __$StorageFileAnalysisErrorResponseCopyWithImpl<$Res>
    implements _$StorageFileAnalysisErrorResponseCopyWith<$Res> {
  __$StorageFileAnalysisErrorResponseCopyWithImpl(this._self, this._then);

  final _StorageFileAnalysisErrorResponse _self;
  final $Res Function(_StorageFileAnalysisErrorResponse) _then;

/// Create a copy of StorageFileAnalysisErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? retryable = null,Object? retryAfterSeconds = freezed,}) {
  return _then(_StorageFileAnalysisErrorResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,retryAfterSeconds: freezed == retryAfterSeconds ? _self.retryAfterSeconds : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
