// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_error_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiErrorResponse {

 String get code; String get message; Map<String, List<String>>? get fields; String get traceId;
/// Create a copy of ApiErrorResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiErrorResponseCopyWith<ApiErrorResponse> get copyWith => _$ApiErrorResponseCopyWithImpl<ApiErrorResponse>(this as ApiErrorResponse, _$identity);

  /// Serializes this ApiErrorResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiErrorResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.traceId, traceId) || other.traceId == traceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(fields),traceId);

@override
String toString() {
  return 'ApiErrorResponse(code: $code, message: $message, fields: $fields, traceId: $traceId)';
}


}

/// @nodoc
abstract mixin class $ApiErrorResponseCopyWith<$Res>  {
  factory $ApiErrorResponseCopyWith(ApiErrorResponse value, $Res Function(ApiErrorResponse) _then) = _$ApiErrorResponseCopyWithImpl;
@useResult
$Res call({
 String code, String message, Map<String, List<String>>? fields, String traceId
});




}
/// @nodoc
class _$ApiErrorResponseCopyWithImpl<$Res>
    implements $ApiErrorResponseCopyWith<$Res> {
  _$ApiErrorResponseCopyWithImpl(this._self, this._then);

  final ApiErrorResponse _self;
  final $Res Function(ApiErrorResponse) _then;

/// Create a copy of ApiErrorResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? fields = freezed,Object? traceId = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,fields: freezed == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,traceId: null == traceId ? _self.traceId : traceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiErrorResponse].
extension ApiErrorResponsePatterns on ApiErrorResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiErrorResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiErrorResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiErrorResponse value)  $default,){
final _that = this;
switch (_that) {
case _ApiErrorResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiErrorResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ApiErrorResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  Map<String, List<String>>? fields,  String traceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiErrorResponse() when $default != null:
return $default(_that.code,_that.message,_that.fields,_that.traceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  Map<String, List<String>>? fields,  String traceId)  $default,) {final _that = this;
switch (_that) {
case _ApiErrorResponse():
return $default(_that.code,_that.message,_that.fields,_that.traceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  Map<String, List<String>>? fields,  String traceId)?  $default,) {final _that = this;
switch (_that) {
case _ApiErrorResponse() when $default != null:
return $default(_that.code,_that.message,_that.fields,_that.traceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiErrorResponse implements ApiErrorResponse {
  const _ApiErrorResponse({required this.code, required this.message, this.fields, required this.traceId});
  factory _ApiErrorResponse.fromJson(Map<String, dynamic> json) => _$ApiErrorResponseFromJson(json);

@override final  String code;
@override final  String message;
@override final  Map<String, List<String>>? fields;
@override final  String traceId;

/// Create a copy of ApiErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiErrorResponseCopyWith<_ApiErrorResponse> get copyWith => __$ApiErrorResponseCopyWithImpl<_ApiErrorResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiErrorResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiErrorResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.traceId, traceId) || other.traceId == traceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,const DeepCollectionEquality().hash(fields),traceId);

@override
String toString() {
  return 'ApiErrorResponse(code: $code, message: $message, fields: $fields, traceId: $traceId)';
}


}

/// @nodoc
abstract mixin class _$ApiErrorResponseCopyWith<$Res> implements $ApiErrorResponseCopyWith<$Res> {
  factory _$ApiErrorResponseCopyWith(_ApiErrorResponse value, $Res Function(_ApiErrorResponse) _then) = __$ApiErrorResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, Map<String, List<String>>? fields, String traceId
});




}
/// @nodoc
class __$ApiErrorResponseCopyWithImpl<$Res>
    implements _$ApiErrorResponseCopyWith<$Res> {
  __$ApiErrorResponseCopyWithImpl(this._self, this._then);

  final _ApiErrorResponse _self;
  final $Res Function(_ApiErrorResponse) _then;

/// Create a copy of ApiErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? fields = freezed,Object? traceId = null,}) {
  return _then(_ApiErrorResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,fields: freezed == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,traceId: null == traceId ? _self.traceId : traceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
