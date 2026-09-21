// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_setup_preview_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectSetupWarningResponse {

/// Stabilny kod ostrzeżenia, np. `project_setup.members_ignored_for_shared`.
 String get code;/// Komunikat ostrzeżenia dla użytkownika.
 String get message;
/// Create a copy of ProjectSetupWarningResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupWarningResponseCopyWith<ProjectSetupWarningResponse> get copyWith => _$ProjectSetupWarningResponseCopyWithImpl<ProjectSetupWarningResponse>(this as ProjectSetupWarningResponse, _$identity);

  /// Serializes this ProjectSetupWarningResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupWarningResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'ProjectSetupWarningResponse(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupWarningResponseCopyWith<$Res>  {
  factory $ProjectSetupWarningResponseCopyWith(ProjectSetupWarningResponse value, $Res Function(ProjectSetupWarningResponse) _then) = _$ProjectSetupWarningResponseCopyWithImpl;
@useResult
$Res call({
 String code, String message
});




}
/// @nodoc
class _$ProjectSetupWarningResponseCopyWithImpl<$Res>
    implements $ProjectSetupWarningResponseCopyWith<$Res> {
  _$ProjectSetupWarningResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupWarningResponse _self;
  final $Res Function(ProjectSetupWarningResponse) _then;

/// Create a copy of ProjectSetupWarningResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupWarningResponse].
extension ProjectSetupWarningResponsePatterns on ProjectSetupWarningResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupWarningResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupWarningResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupWarningResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWarningResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupWarningResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWarningResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupWarningResponse() when $default != null:
return $default(_that.code,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWarningResponse():
return $default(_that.code,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWarningResponse() when $default != null:
return $default(_that.code,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupWarningResponse implements ProjectSetupWarningResponse {
  const _ProjectSetupWarningResponse({required this.code, required this.message});
  factory _ProjectSetupWarningResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupWarningResponseFromJson(json);

/// Stabilny kod ostrzeżenia, np. `project_setup.members_ignored_for_shared`.
@override final  String code;
/// Komunikat ostrzeżenia dla użytkownika.
@override final  String message;

/// Create a copy of ProjectSetupWarningResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupWarningResponseCopyWith<_ProjectSetupWarningResponse> get copyWith => __$ProjectSetupWarningResponseCopyWithImpl<_ProjectSetupWarningResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupWarningResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupWarningResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'ProjectSetupWarningResponse(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupWarningResponseCopyWith<$Res> implements $ProjectSetupWarningResponseCopyWith<$Res> {
  factory _$ProjectSetupWarningResponseCopyWith(_ProjectSetupWarningResponse value, $Res Function(_ProjectSetupWarningResponse) _then) = __$ProjectSetupWarningResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, String message
});




}
/// @nodoc
class __$ProjectSetupWarningResponseCopyWithImpl<$Res>
    implements _$ProjectSetupWarningResponseCopyWith<$Res> {
  __$ProjectSetupWarningResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupWarningResponse _self;
  final $Res Function(_ProjectSetupWarningResponse) _then;

/// Create a copy of ProjectSetupWarningResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,}) {
  return _then(_ProjectSetupWarningResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupMemberPreviewResponse {

/// UUID lokalnego użytkownika.
 String get userId;/// Rola nadawana w projekcie.
 ProjectRole get role;/// Czy pozycja wynika z tego, że użytkownik tworzy projekt.
 bool get isCreator;
/// Create a copy of ProjectSetupMemberPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupMemberPreviewResponseCopyWith<ProjectSetupMemberPreviewResponse> get copyWith => _$ProjectSetupMemberPreviewResponseCopyWithImpl<ProjectSetupMemberPreviewResponse>(this as ProjectSetupMemberPreviewResponse, _$identity);

  /// Serializes this ProjectSetupMemberPreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupMemberPreviewResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.isCreator, isCreator) || other.isCreator == isCreator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,role,isCreator);

@override
String toString() {
  return 'ProjectSetupMemberPreviewResponse(userId: $userId, role: $role, isCreator: $isCreator)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupMemberPreviewResponseCopyWith<$Res>  {
  factory $ProjectSetupMemberPreviewResponseCopyWith(ProjectSetupMemberPreviewResponse value, $Res Function(ProjectSetupMemberPreviewResponse) _then) = _$ProjectSetupMemberPreviewResponseCopyWithImpl;
@useResult
$Res call({
 String userId, ProjectRole role, bool isCreator
});




}
/// @nodoc
class _$ProjectSetupMemberPreviewResponseCopyWithImpl<$Res>
    implements $ProjectSetupMemberPreviewResponseCopyWith<$Res> {
  _$ProjectSetupMemberPreviewResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupMemberPreviewResponse _self;
  final $Res Function(ProjectSetupMemberPreviewResponse) _then;

/// Create a copy of ProjectSetupMemberPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? role = null,Object? isCreator = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,isCreator: null == isCreator ? _self.isCreator : isCreator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupMemberPreviewResponse].
extension ProjectSetupMemberPreviewResponsePatterns on ProjectSetupMemberPreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupMemberPreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupMemberPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupMemberPreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupMemberPreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupMemberPreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupMemberPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  ProjectRole role,  bool isCreator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupMemberPreviewResponse() when $default != null:
return $default(_that.userId,_that.role,_that.isCreator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  ProjectRole role,  bool isCreator)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupMemberPreviewResponse():
return $default(_that.userId,_that.role,_that.isCreator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  ProjectRole role,  bool isCreator)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupMemberPreviewResponse() when $default != null:
return $default(_that.userId,_that.role,_that.isCreator);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupMemberPreviewResponse implements ProjectSetupMemberPreviewResponse {
  const _ProjectSetupMemberPreviewResponse({required this.userId, required this.role, required this.isCreator});
  factory _ProjectSetupMemberPreviewResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupMemberPreviewResponseFromJson(json);

/// UUID lokalnego użytkownika.
@override final  String userId;
/// Rola nadawana w projekcie.
@override final  ProjectRole role;
/// Czy pozycja wynika z tego, że użytkownik tworzy projekt.
@override final  bool isCreator;

/// Create a copy of ProjectSetupMemberPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupMemberPreviewResponseCopyWith<_ProjectSetupMemberPreviewResponse> get copyWith => __$ProjectSetupMemberPreviewResponseCopyWithImpl<_ProjectSetupMemberPreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupMemberPreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupMemberPreviewResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.isCreator, isCreator) || other.isCreator == isCreator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,role,isCreator);

@override
String toString() {
  return 'ProjectSetupMemberPreviewResponse(userId: $userId, role: $role, isCreator: $isCreator)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupMemberPreviewResponseCopyWith<$Res> implements $ProjectSetupMemberPreviewResponseCopyWith<$Res> {
  factory _$ProjectSetupMemberPreviewResponseCopyWith(_ProjectSetupMemberPreviewResponse value, $Res Function(_ProjectSetupMemberPreviewResponse) _then) = __$ProjectSetupMemberPreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 String userId, ProjectRole role, bool isCreator
});




}
/// @nodoc
class __$ProjectSetupMemberPreviewResponseCopyWithImpl<$Res>
    implements _$ProjectSetupMemberPreviewResponseCopyWith<$Res> {
  __$ProjectSetupMemberPreviewResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupMemberPreviewResponse _self;
  final $Res Function(_ProjectSetupMemberPreviewResponse) _then;

/// Create a copy of ProjectSetupMemberPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? role = null,Object? isCreator = null,}) {
  return _then(_ProjectSetupMemberPreviewResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ProjectRole,isCreator: null == isCreator ? _self.isCreator : isCreator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupTemplatePreviewResponse {

/// UUID użytego szablonu projektu.
 String get templateId;/// Nazwa szablonu.
 String get name;/// Wersja szablonu użyta do zbudowania planu.
 int get version;/// Liczba aktywnych zadań, które powstaną z szablonu.
 int get taskCount;/// Liczba etykiet, które powstaną z szablonu.
 int get labelCount;/// Liczba pól niestandardowych, które powstaną z szablonu.
 int get customFieldCount;/// Liczba własnych statusów workflow, które powstaną z szablonu.
 int get customStatusCount;
/// Create a copy of ProjectSetupTemplatePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupTemplatePreviewResponseCopyWith<ProjectSetupTemplatePreviewResponse> get copyWith => _$ProjectSetupTemplatePreviewResponseCopyWithImpl<ProjectSetupTemplatePreviewResponse>(this as ProjectSetupTemplatePreviewResponse, _$identity);

  /// Serializes this ProjectSetupTemplatePreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupTemplatePreviewResponse&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.taskCount, taskCount) || other.taskCount == taskCount)&&(identical(other.labelCount, labelCount) || other.labelCount == labelCount)&&(identical(other.customFieldCount, customFieldCount) || other.customFieldCount == customFieldCount)&&(identical(other.customStatusCount, customStatusCount) || other.customStatusCount == customStatusCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,name,version,taskCount,labelCount,customFieldCount,customStatusCount);

@override
String toString() {
  return 'ProjectSetupTemplatePreviewResponse(templateId: $templateId, name: $name, version: $version, taskCount: $taskCount, labelCount: $labelCount, customFieldCount: $customFieldCount, customStatusCount: $customStatusCount)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupTemplatePreviewResponseCopyWith<$Res>  {
  factory $ProjectSetupTemplatePreviewResponseCopyWith(ProjectSetupTemplatePreviewResponse value, $Res Function(ProjectSetupTemplatePreviewResponse) _then) = _$ProjectSetupTemplatePreviewResponseCopyWithImpl;
@useResult
$Res call({
 String templateId, String name, int version, int taskCount, int labelCount, int customFieldCount, int customStatusCount
});




}
/// @nodoc
class _$ProjectSetupTemplatePreviewResponseCopyWithImpl<$Res>
    implements $ProjectSetupTemplatePreviewResponseCopyWith<$Res> {
  _$ProjectSetupTemplatePreviewResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupTemplatePreviewResponse _self;
  final $Res Function(ProjectSetupTemplatePreviewResponse) _then;

/// Create a copy of ProjectSetupTemplatePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templateId = null,Object? name = null,Object? version = null,Object? taskCount = null,Object? labelCount = null,Object? customFieldCount = null,Object? customStatusCount = null,}) {
  return _then(_self.copyWith(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,taskCount: null == taskCount ? _self.taskCount : taskCount // ignore: cast_nullable_to_non_nullable
as int,labelCount: null == labelCount ? _self.labelCount : labelCount // ignore: cast_nullable_to_non_nullable
as int,customFieldCount: null == customFieldCount ? _self.customFieldCount : customFieldCount // ignore: cast_nullable_to_non_nullable
as int,customStatusCount: null == customStatusCount ? _self.customStatusCount : customStatusCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupTemplatePreviewResponse].
extension ProjectSetupTemplatePreviewResponsePatterns on ProjectSetupTemplatePreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupTemplatePreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupTemplatePreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupTemplatePreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupTemplatePreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupTemplatePreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupTemplatePreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String templateId,  String name,  int version,  int taskCount,  int labelCount,  int customFieldCount,  int customStatusCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupTemplatePreviewResponse() when $default != null:
return $default(_that.templateId,_that.name,_that.version,_that.taskCount,_that.labelCount,_that.customFieldCount,_that.customStatusCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String templateId,  String name,  int version,  int taskCount,  int labelCount,  int customFieldCount,  int customStatusCount)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupTemplatePreviewResponse():
return $default(_that.templateId,_that.name,_that.version,_that.taskCount,_that.labelCount,_that.customFieldCount,_that.customStatusCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String templateId,  String name,  int version,  int taskCount,  int labelCount,  int customFieldCount,  int customStatusCount)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupTemplatePreviewResponse() when $default != null:
return $default(_that.templateId,_that.name,_that.version,_that.taskCount,_that.labelCount,_that.customFieldCount,_that.customStatusCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupTemplatePreviewResponse implements ProjectSetupTemplatePreviewResponse {
  const _ProjectSetupTemplatePreviewResponse({required this.templateId, required this.name, required this.version, required this.taskCount, required this.labelCount, required this.customFieldCount, required this.customStatusCount});
  factory _ProjectSetupTemplatePreviewResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupTemplatePreviewResponseFromJson(json);

/// UUID użytego szablonu projektu.
@override final  String templateId;
/// Nazwa szablonu.
@override final  String name;
/// Wersja szablonu użyta do zbudowania planu.
@override final  int version;
/// Liczba aktywnych zadań, które powstaną z szablonu.
@override final  int taskCount;
/// Liczba etykiet, które powstaną z szablonu.
@override final  int labelCount;
/// Liczba pól niestandardowych, które powstaną z szablonu.
@override final  int customFieldCount;
/// Liczba własnych statusów workflow, które powstaną z szablonu.
@override final  int customStatusCount;

/// Create a copy of ProjectSetupTemplatePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupTemplatePreviewResponseCopyWith<_ProjectSetupTemplatePreviewResponse> get copyWith => __$ProjectSetupTemplatePreviewResponseCopyWithImpl<_ProjectSetupTemplatePreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupTemplatePreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupTemplatePreviewResponse&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.taskCount, taskCount) || other.taskCount == taskCount)&&(identical(other.labelCount, labelCount) || other.labelCount == labelCount)&&(identical(other.customFieldCount, customFieldCount) || other.customFieldCount == customFieldCount)&&(identical(other.customStatusCount, customStatusCount) || other.customStatusCount == customStatusCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,name,version,taskCount,labelCount,customFieldCount,customStatusCount);

@override
String toString() {
  return 'ProjectSetupTemplatePreviewResponse(templateId: $templateId, name: $name, version: $version, taskCount: $taskCount, labelCount: $labelCount, customFieldCount: $customFieldCount, customStatusCount: $customStatusCount)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupTemplatePreviewResponseCopyWith<$Res> implements $ProjectSetupTemplatePreviewResponseCopyWith<$Res> {
  factory _$ProjectSetupTemplatePreviewResponseCopyWith(_ProjectSetupTemplatePreviewResponse value, $Res Function(_ProjectSetupTemplatePreviewResponse) _then) = __$ProjectSetupTemplatePreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 String templateId, String name, int version, int taskCount, int labelCount, int customFieldCount, int customStatusCount
});




}
/// @nodoc
class __$ProjectSetupTemplatePreviewResponseCopyWithImpl<$Res>
    implements _$ProjectSetupTemplatePreviewResponseCopyWith<$Res> {
  __$ProjectSetupTemplatePreviewResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupTemplatePreviewResponse _self;
  final $Res Function(_ProjectSetupTemplatePreviewResponse) _then;

/// Create a copy of ProjectSetupTemplatePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templateId = null,Object? name = null,Object? version = null,Object? taskCount = null,Object? labelCount = null,Object? customFieldCount = null,Object? customStatusCount = null,}) {
  return _then(_ProjectSetupTemplatePreviewResponse(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,taskCount: null == taskCount ? _self.taskCount : taskCount // ignore: cast_nullable_to_non_nullable
as int,labelCount: null == labelCount ? _self.labelCount : labelCount // ignore: cast_nullable_to_non_nullable
as int,customFieldCount: null == customFieldCount ? _self.customFieldCount : customFieldCount // ignore: cast_nullable_to_non_nullable
as int,customStatusCount: null == customStatusCount ? _self.customStatusCount : customStatusCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupProjectPreviewResponse {

/// Nazwa projektu po normalizacji.
 String get name;/// Opis projektu po normalizacji.
 String? get description;/// Ikona projektu po normalizacji.
 String? get icon;/// Kolor główny projektu po normalizacji.
 String? get primaryColor;/// Efektywna widoczność projektu.
 ProjectVisibility get visibility;/// Efektywny stan projektu.
 ProjectStatus get status;/// Czy projekt dziedziczy dostęp wszystkich aktywnych członków workspace.
 bool get inheritsWorkspaceMembers;/// Liczba członkostw, które powstaną razem z projektem.
 int get memberCount;/// Lista członkostw, które powstaną razem z projektem.
 List<ProjectSetupMemberPreviewResponse> get members;
/// Create a copy of ProjectSetupProjectPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupProjectPreviewResponseCopyWith<ProjectSetupProjectPreviewResponse> get copyWith => _$ProjectSetupProjectPreviewResponseCopyWithImpl<ProjectSetupProjectPreviewResponse>(this as ProjectSetupProjectPreviewResponse, _$identity);

  /// Serializes this ProjectSetupProjectPreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupProjectPreviewResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&(identical(other.inheritsWorkspaceMembers, inheritsWorkspaceMembers) || other.inheritsWorkspaceMembers == inheritsWorkspaceMembers)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor,visibility,status,inheritsWorkspaceMembers,memberCount,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'ProjectSetupProjectPreviewResponse(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status, inheritsWorkspaceMembers: $inheritsWorkspaceMembers, memberCount: $memberCount, members: $members)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupProjectPreviewResponseCopyWith<$Res>  {
  factory $ProjectSetupProjectPreviewResponseCopyWith(ProjectSetupProjectPreviewResponse value, $Res Function(ProjectSetupProjectPreviewResponse) _then) = _$ProjectSetupProjectPreviewResponseCopyWithImpl;
@useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor, ProjectVisibility visibility, ProjectStatus status, bool inheritsWorkspaceMembers, int memberCount, List<ProjectSetupMemberPreviewResponse> members
});




}
/// @nodoc
class _$ProjectSetupProjectPreviewResponseCopyWithImpl<$Res>
    implements $ProjectSetupProjectPreviewResponseCopyWith<$Res> {
  _$ProjectSetupProjectPreviewResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupProjectPreviewResponse _self;
  final $Res Function(ProjectSetupProjectPreviewResponse) _then;

/// Create a copy of ProjectSetupProjectPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,Object? inheritsWorkspaceMembers = null,Object? memberCount = null,Object? members = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,inheritsWorkspaceMembers: null == inheritsWorkspaceMembers ? _self.inheritsWorkspaceMembers : inheritsWorkspaceMembers // ignore: cast_nullable_to_non_nullable
as bool,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupMemberPreviewResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupProjectPreviewResponse].
extension ProjectSetupProjectPreviewResponsePatterns on ProjectSetupProjectPreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupProjectPreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupProjectPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupProjectPreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupProjectPreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupProjectPreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupProjectPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  bool inheritsWorkspaceMembers,  int memberCount,  List<ProjectSetupMemberPreviewResponse> members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupProjectPreviewResponse() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.inheritsWorkspaceMembers,_that.memberCount,_that.members);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  bool inheritsWorkspaceMembers,  int memberCount,  List<ProjectSetupMemberPreviewResponse> members)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupProjectPreviewResponse():
return $default(_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.inheritsWorkspaceMembers,_that.memberCount,_that.members);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  String? icon,  String? primaryColor,  ProjectVisibility visibility,  ProjectStatus status,  bool inheritsWorkspaceMembers,  int memberCount,  List<ProjectSetupMemberPreviewResponse> members)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupProjectPreviewResponse() when $default != null:
return $default(_that.name,_that.description,_that.icon,_that.primaryColor,_that.visibility,_that.status,_that.inheritsWorkspaceMembers,_that.memberCount,_that.members);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupProjectPreviewResponse implements ProjectSetupProjectPreviewResponse {
  const _ProjectSetupProjectPreviewResponse({required this.name, this.description, this.icon, this.primaryColor, required this.visibility, required this.status, required this.inheritsWorkspaceMembers, required this.memberCount, required this.members});
  factory _ProjectSetupProjectPreviewResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupProjectPreviewResponseFromJson(json);

/// Nazwa projektu po normalizacji.
@override final  String name;
/// Opis projektu po normalizacji.
@override final  String? description;
/// Ikona projektu po normalizacji.
@override final  String? icon;
/// Kolor główny projektu po normalizacji.
@override final  String? primaryColor;
/// Efektywna widoczność projektu.
@override final  ProjectVisibility visibility;
/// Efektywny stan projektu.
@override final  ProjectStatus status;
/// Czy projekt dziedziczy dostęp wszystkich aktywnych członków workspace.
@override final  bool inheritsWorkspaceMembers;
/// Liczba członkostw, które powstaną razem z projektem.
@override final  int memberCount;
/// Lista członkostw, które powstaną razem z projektem.
@override final  List<ProjectSetupMemberPreviewResponse> members;

/// Create a copy of ProjectSetupProjectPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupProjectPreviewResponseCopyWith<_ProjectSetupProjectPreviewResponse> get copyWith => __$ProjectSetupProjectPreviewResponseCopyWithImpl<_ProjectSetupProjectPreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupProjectPreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupProjectPreviewResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&(identical(other.inheritsWorkspaceMembers, inheritsWorkspaceMembers) || other.inheritsWorkspaceMembers == inheritsWorkspaceMembers)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,icon,primaryColor,visibility,status,inheritsWorkspaceMembers,memberCount,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'ProjectSetupProjectPreviewResponse(name: $name, description: $description, icon: $icon, primaryColor: $primaryColor, visibility: $visibility, status: $status, inheritsWorkspaceMembers: $inheritsWorkspaceMembers, memberCount: $memberCount, members: $members)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupProjectPreviewResponseCopyWith<$Res> implements $ProjectSetupProjectPreviewResponseCopyWith<$Res> {
  factory _$ProjectSetupProjectPreviewResponseCopyWith(_ProjectSetupProjectPreviewResponse value, $Res Function(_ProjectSetupProjectPreviewResponse) _then) = __$ProjectSetupProjectPreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, String? icon, String? primaryColor, ProjectVisibility visibility, ProjectStatus status, bool inheritsWorkspaceMembers, int memberCount, List<ProjectSetupMemberPreviewResponse> members
});




}
/// @nodoc
class __$ProjectSetupProjectPreviewResponseCopyWithImpl<$Res>
    implements _$ProjectSetupProjectPreviewResponseCopyWith<$Res> {
  __$ProjectSetupProjectPreviewResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupProjectPreviewResponse _self;
  final $Res Function(_ProjectSetupProjectPreviewResponse) _then;

/// Create a copy of ProjectSetupProjectPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? icon = freezed,Object? primaryColor = freezed,Object? visibility = null,Object? status = null,Object? inheritsWorkspaceMembers = null,Object? memberCount = null,Object? members = null,}) {
  return _then(_ProjectSetupProjectPreviewResponse(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,primaryColor: freezed == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as ProjectVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,inheritsWorkspaceMembers: null == inheritsWorkspaceMembers ? _self.inheritsWorkspaceMembers : inheritsWorkspaceMembers // ignore: cast_nullable_to_non_nullable
as bool,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupMemberPreviewResponse>,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupWorkflowStatusPreviewResponse {

/// Nazwa kolumny.
 String get name;/// Kolor kolumny.
 String get color;/// Kategoria analityczna kolumny.
 TaskStatusCategory get category;/// Pozycja kolumny od zera.
 int get position;/// Limit WIP kolumny albo null.
 int? get wipLimit;/// Czy kolumna jest domyślna dla nowych zadań.
 bool get isDefault;
/// Create a copy of ProjectSetupWorkflowStatusPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowStatusPreviewResponseCopyWith<ProjectSetupWorkflowStatusPreviewResponse> get copyWith => _$ProjectSetupWorkflowStatusPreviewResponseCopyWithImpl<ProjectSetupWorkflowStatusPreviewResponse>(this as ProjectSetupWorkflowStatusPreviewResponse, _$identity);

  /// Serializes this ProjectSetupWorkflowStatusPreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupWorkflowStatusPreviewResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.category, category) || other.category == category)&&(identical(other.position, position) || other.position == position)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,color,category,position,wipLimit,isDefault);

@override
String toString() {
  return 'ProjectSetupWorkflowStatusPreviewResponse(name: $name, color: $color, category: $category, position: $position, wipLimit: $wipLimit, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupWorkflowStatusPreviewResponseCopyWith<$Res>  {
  factory $ProjectSetupWorkflowStatusPreviewResponseCopyWith(ProjectSetupWorkflowStatusPreviewResponse value, $Res Function(ProjectSetupWorkflowStatusPreviewResponse) _then) = _$ProjectSetupWorkflowStatusPreviewResponseCopyWithImpl;
@useResult
$Res call({
 String name, String color, TaskStatusCategory category, int position, int? wipLimit, bool isDefault
});




}
/// @nodoc
class _$ProjectSetupWorkflowStatusPreviewResponseCopyWithImpl<$Res>
    implements $ProjectSetupWorkflowStatusPreviewResponseCopyWith<$Res> {
  _$ProjectSetupWorkflowStatusPreviewResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupWorkflowStatusPreviewResponse _self;
  final $Res Function(ProjectSetupWorkflowStatusPreviewResponse) _then;

/// Create a copy of ProjectSetupWorkflowStatusPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? color = null,Object? category = null,Object? position = null,Object? wipLimit = freezed,Object? isDefault = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupWorkflowStatusPreviewResponse].
extension ProjectSetupWorkflowStatusPreviewResponsePatterns on ProjectSetupWorkflowStatusPreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupWorkflowStatusPreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupWorkflowStatusPreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusPreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupWorkflowStatusPreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String color,  TaskStatusCategory category,  int position,  int? wipLimit,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusPreviewResponse() when $default != null:
return $default(_that.name,_that.color,_that.category,_that.position,_that.wipLimit,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String color,  TaskStatusCategory category,  int position,  int? wipLimit,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusPreviewResponse():
return $default(_that.name,_that.color,_that.category,_that.position,_that.wipLimit,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String color,  TaskStatusCategory category,  int position,  int? wipLimit,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowStatusPreviewResponse() when $default != null:
return $default(_that.name,_that.color,_that.category,_that.position,_that.wipLimit,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupWorkflowStatusPreviewResponse implements ProjectSetupWorkflowStatusPreviewResponse {
  const _ProjectSetupWorkflowStatusPreviewResponse({required this.name, required this.color, required this.category, required this.position, this.wipLimit, required this.isDefault});
  factory _ProjectSetupWorkflowStatusPreviewResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupWorkflowStatusPreviewResponseFromJson(json);

/// Nazwa kolumny.
@override final  String name;
/// Kolor kolumny.
@override final  String color;
/// Kategoria analityczna kolumny.
@override final  TaskStatusCategory category;
/// Pozycja kolumny od zera.
@override final  int position;
/// Limit WIP kolumny albo null.
@override final  int? wipLimit;
/// Czy kolumna jest domyślna dla nowych zadań.
@override final  bool isDefault;

/// Create a copy of ProjectSetupWorkflowStatusPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupWorkflowStatusPreviewResponseCopyWith<_ProjectSetupWorkflowStatusPreviewResponse> get copyWith => __$ProjectSetupWorkflowStatusPreviewResponseCopyWithImpl<_ProjectSetupWorkflowStatusPreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupWorkflowStatusPreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupWorkflowStatusPreviewResponse&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.category, category) || other.category == category)&&(identical(other.position, position) || other.position == position)&&(identical(other.wipLimit, wipLimit) || other.wipLimit == wipLimit)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,color,category,position,wipLimit,isDefault);

@override
String toString() {
  return 'ProjectSetupWorkflowStatusPreviewResponse(name: $name, color: $color, category: $category, position: $position, wipLimit: $wipLimit, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupWorkflowStatusPreviewResponseCopyWith<$Res> implements $ProjectSetupWorkflowStatusPreviewResponseCopyWith<$Res> {
  factory _$ProjectSetupWorkflowStatusPreviewResponseCopyWith(_ProjectSetupWorkflowStatusPreviewResponse value, $Res Function(_ProjectSetupWorkflowStatusPreviewResponse) _then) = __$ProjectSetupWorkflowStatusPreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 String name, String color, TaskStatusCategory category, int position, int? wipLimit, bool isDefault
});




}
/// @nodoc
class __$ProjectSetupWorkflowStatusPreviewResponseCopyWithImpl<$Res>
    implements _$ProjectSetupWorkflowStatusPreviewResponseCopyWith<$Res> {
  __$ProjectSetupWorkflowStatusPreviewResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupWorkflowStatusPreviewResponse _self;
  final $Res Function(_ProjectSetupWorkflowStatusPreviewResponse) _then;

/// Create a copy of ProjectSetupWorkflowStatusPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? color = null,Object? category = null,Object? position = null,Object? wipLimit = freezed,Object? isDefault = null,}) {
  return _then(_ProjectSetupWorkflowStatusPreviewResponse(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskStatusCategory,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,wipLimit: freezed == wipLimit ? _self.wipLimit : wipLimit // ignore: cast_nullable_to_non_nullable
as int?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupWorkflowPreviewResponse {

/// Źródło workflow.
 ProjectSetupWorkflowKind get kind;/// Klucz katalogowego szablonu workflow albo null.
 String? get templateKey;/// Nazwa katalogowego szablonu workflow albo null.
 String? get templateName;/// Liczba statusów systemowych tworzonych zawsze dla nowego projektu.
 int get systemStatusCount;/// Własne statusy workflow, które powstaną razem z projektem.
 List<ProjectSetupWorkflowStatusPreviewResponse> get customStatuses;
/// Create a copy of ProjectSetupWorkflowPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowPreviewResponseCopyWith<ProjectSetupWorkflowPreviewResponse> get copyWith => _$ProjectSetupWorkflowPreviewResponseCopyWithImpl<ProjectSetupWorkflowPreviewResponse>(this as ProjectSetupWorkflowPreviewResponse, _$identity);

  /// Serializes this ProjectSetupWorkflowPreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupWorkflowPreviewResponse&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.templateName, templateName) || other.templateName == templateName)&&(identical(other.systemStatusCount, systemStatusCount) || other.systemStatusCount == systemStatusCount)&&const DeepCollectionEquality().equals(other.customStatuses, customStatuses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,templateKey,templateName,systemStatusCount,const DeepCollectionEquality().hash(customStatuses));

@override
String toString() {
  return 'ProjectSetupWorkflowPreviewResponse(kind: $kind, templateKey: $templateKey, templateName: $templateName, systemStatusCount: $systemStatusCount, customStatuses: $customStatuses)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupWorkflowPreviewResponseCopyWith<$Res>  {
  factory $ProjectSetupWorkflowPreviewResponseCopyWith(ProjectSetupWorkflowPreviewResponse value, $Res Function(ProjectSetupWorkflowPreviewResponse) _then) = _$ProjectSetupWorkflowPreviewResponseCopyWithImpl;
@useResult
$Res call({
 ProjectSetupWorkflowKind kind, String? templateKey, String? templateName, int systemStatusCount, List<ProjectSetupWorkflowStatusPreviewResponse> customStatuses
});




}
/// @nodoc
class _$ProjectSetupWorkflowPreviewResponseCopyWithImpl<$Res>
    implements $ProjectSetupWorkflowPreviewResponseCopyWith<$Res> {
  _$ProjectSetupWorkflowPreviewResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupWorkflowPreviewResponse _self;
  final $Res Function(ProjectSetupWorkflowPreviewResponse) _then;

/// Create a copy of ProjectSetupWorkflowPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? templateKey = freezed,Object? templateName = freezed,Object? systemStatusCount = null,Object? customStatuses = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowKind,templateKey: freezed == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String?,templateName: freezed == templateName ? _self.templateName : templateName // ignore: cast_nullable_to_non_nullable
as String?,systemStatusCount: null == systemStatusCount ? _self.systemStatusCount : systemStatusCount // ignore: cast_nullable_to_non_nullable
as int,customStatuses: null == customStatuses ? _self.customStatuses : customStatuses // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupWorkflowStatusPreviewResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupWorkflowPreviewResponse].
extension ProjectSetupWorkflowPreviewResponsePatterns on ProjectSetupWorkflowPreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupWorkflowPreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupWorkflowPreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowPreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupWorkflowPreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectSetupWorkflowKind kind,  String? templateKey,  String? templateName,  int systemStatusCount,  List<ProjectSetupWorkflowStatusPreviewResponse> customStatuses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowPreviewResponse() when $default != null:
return $default(_that.kind,_that.templateKey,_that.templateName,_that.systemStatusCount,_that.customStatuses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectSetupWorkflowKind kind,  String? templateKey,  String? templateName,  int systemStatusCount,  List<ProjectSetupWorkflowStatusPreviewResponse> customStatuses)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowPreviewResponse():
return $default(_that.kind,_that.templateKey,_that.templateName,_that.systemStatusCount,_that.customStatuses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectSetupWorkflowKind kind,  String? templateKey,  String? templateName,  int systemStatusCount,  List<ProjectSetupWorkflowStatusPreviewResponse> customStatuses)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowPreviewResponse() when $default != null:
return $default(_that.kind,_that.templateKey,_that.templateName,_that.systemStatusCount,_that.customStatuses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupWorkflowPreviewResponse implements ProjectSetupWorkflowPreviewResponse {
  const _ProjectSetupWorkflowPreviewResponse({required this.kind, this.templateKey, this.templateName, required this.systemStatusCount, required this.customStatuses});
  factory _ProjectSetupWorkflowPreviewResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupWorkflowPreviewResponseFromJson(json);

/// Źródło workflow.
@override final  ProjectSetupWorkflowKind kind;
/// Klucz katalogowego szablonu workflow albo null.
@override final  String? templateKey;
/// Nazwa katalogowego szablonu workflow albo null.
@override final  String? templateName;
/// Liczba statusów systemowych tworzonych zawsze dla nowego projektu.
@override final  int systemStatusCount;
/// Własne statusy workflow, które powstaną razem z projektem.
@override final  List<ProjectSetupWorkflowStatusPreviewResponse> customStatuses;

/// Create a copy of ProjectSetupWorkflowPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupWorkflowPreviewResponseCopyWith<_ProjectSetupWorkflowPreviewResponse> get copyWith => __$ProjectSetupWorkflowPreviewResponseCopyWithImpl<_ProjectSetupWorkflowPreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupWorkflowPreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupWorkflowPreviewResponse&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.templateName, templateName) || other.templateName == templateName)&&(identical(other.systemStatusCount, systemStatusCount) || other.systemStatusCount == systemStatusCount)&&const DeepCollectionEquality().equals(other.customStatuses, customStatuses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,templateKey,templateName,systemStatusCount,const DeepCollectionEquality().hash(customStatuses));

@override
String toString() {
  return 'ProjectSetupWorkflowPreviewResponse(kind: $kind, templateKey: $templateKey, templateName: $templateName, systemStatusCount: $systemStatusCount, customStatuses: $customStatuses)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupWorkflowPreviewResponseCopyWith<$Res> implements $ProjectSetupWorkflowPreviewResponseCopyWith<$Res> {
  factory _$ProjectSetupWorkflowPreviewResponseCopyWith(_ProjectSetupWorkflowPreviewResponse value, $Res Function(_ProjectSetupWorkflowPreviewResponse) _then) = __$ProjectSetupWorkflowPreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectSetupWorkflowKind kind, String? templateKey, String? templateName, int systemStatusCount, List<ProjectSetupWorkflowStatusPreviewResponse> customStatuses
});




}
/// @nodoc
class __$ProjectSetupWorkflowPreviewResponseCopyWithImpl<$Res>
    implements _$ProjectSetupWorkflowPreviewResponseCopyWith<$Res> {
  __$ProjectSetupWorkflowPreviewResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupWorkflowPreviewResponse _self;
  final $Res Function(_ProjectSetupWorkflowPreviewResponse) _then;

/// Create a copy of ProjectSetupWorkflowPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? templateKey = freezed,Object? templateName = freezed,Object? systemStatusCount = null,Object? customStatuses = null,}) {
  return _then(_ProjectSetupWorkflowPreviewResponse(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowKind,templateKey: freezed == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String?,templateName: freezed == templateName ? _self.templateName : templateName // ignore: cast_nullable_to_non_nullable
as String?,systemStatusCount: null == systemStatusCount ? _self.systemStatusCount : systemStatusCount // ignore: cast_nullable_to_non_nullable
as int,customStatuses: null == customStatuses ? _self.customStatuses : customStatuses // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupWorkflowStatusPreviewResponse>,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupTaskViewPreviewResponse {

/// Domyślny widok modułu Zadania zapisany w projekcie.
 ProjectSetupTaskViewKind get defaultView;/// Domyślne kolumny polityki listy zadań.
 List<String> get listDefaultColumns;/// Domyślne pole sortowania listy zadań.
 String get listSortField;/// Domyślny kierunek sortowania listy zadań.
 String get listSortDirection;/// Domyślny sposób grupowania listy zadań.
 String get listGroupBy;/// Sposób grupowania kart Kanban.
 KanbanSwimlaneMode get boardSwimlaneMode;/// Domyślna gęstość kafelka Kanban.
 KanbanCardDensity get boardCardDensity;/// Pola widoczne domyślnie na kafelku Kanban.
 List<KanbanCardField> get boardVisibleCardFields;/// Liczba kolumn z limitem WIP.
 int get boardWipLimitCount;/// Liczba ukrytych kolumn tablicy.
 int get boardHiddenColumnCount;
/// Create a copy of ProjectSetupTaskViewPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupTaskViewPreviewResponseCopyWith<ProjectSetupTaskViewPreviewResponse> get copyWith => _$ProjectSetupTaskViewPreviewResponseCopyWithImpl<ProjectSetupTaskViewPreviewResponse>(this as ProjectSetupTaskViewPreviewResponse, _$identity);

  /// Serializes this ProjectSetupTaskViewPreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupTaskViewPreviewResponse&&(identical(other.defaultView, defaultView) || other.defaultView == defaultView)&&const DeepCollectionEquality().equals(other.listDefaultColumns, listDefaultColumns)&&(identical(other.listSortField, listSortField) || other.listSortField == listSortField)&&(identical(other.listSortDirection, listSortDirection) || other.listSortDirection == listSortDirection)&&(identical(other.listGroupBy, listGroupBy) || other.listGroupBy == listGroupBy)&&(identical(other.boardSwimlaneMode, boardSwimlaneMode) || other.boardSwimlaneMode == boardSwimlaneMode)&&(identical(other.boardCardDensity, boardCardDensity) || other.boardCardDensity == boardCardDensity)&&const DeepCollectionEquality().equals(other.boardVisibleCardFields, boardVisibleCardFields)&&(identical(other.boardWipLimitCount, boardWipLimitCount) || other.boardWipLimitCount == boardWipLimitCount)&&(identical(other.boardHiddenColumnCount, boardHiddenColumnCount) || other.boardHiddenColumnCount == boardHiddenColumnCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultView,const DeepCollectionEquality().hash(listDefaultColumns),listSortField,listSortDirection,listGroupBy,boardSwimlaneMode,boardCardDensity,const DeepCollectionEquality().hash(boardVisibleCardFields),boardWipLimitCount,boardHiddenColumnCount);

@override
String toString() {
  return 'ProjectSetupTaskViewPreviewResponse(defaultView: $defaultView, listDefaultColumns: $listDefaultColumns, listSortField: $listSortField, listSortDirection: $listSortDirection, listGroupBy: $listGroupBy, boardSwimlaneMode: $boardSwimlaneMode, boardCardDensity: $boardCardDensity, boardVisibleCardFields: $boardVisibleCardFields, boardWipLimitCount: $boardWipLimitCount, boardHiddenColumnCount: $boardHiddenColumnCount)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupTaskViewPreviewResponseCopyWith<$Res>  {
  factory $ProjectSetupTaskViewPreviewResponseCopyWith(ProjectSetupTaskViewPreviewResponse value, $Res Function(ProjectSetupTaskViewPreviewResponse) _then) = _$ProjectSetupTaskViewPreviewResponseCopyWithImpl;
@useResult
$Res call({
 ProjectSetupTaskViewKind defaultView, List<String> listDefaultColumns, String listSortField, String listSortDirection, String listGroupBy, KanbanSwimlaneMode boardSwimlaneMode, KanbanCardDensity boardCardDensity, List<KanbanCardField> boardVisibleCardFields, int boardWipLimitCount, int boardHiddenColumnCount
});




}
/// @nodoc
class _$ProjectSetupTaskViewPreviewResponseCopyWithImpl<$Res>
    implements $ProjectSetupTaskViewPreviewResponseCopyWith<$Res> {
  _$ProjectSetupTaskViewPreviewResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupTaskViewPreviewResponse _self;
  final $Res Function(ProjectSetupTaskViewPreviewResponse) _then;

/// Create a copy of ProjectSetupTaskViewPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultView = null,Object? listDefaultColumns = null,Object? listSortField = null,Object? listSortDirection = null,Object? listGroupBy = null,Object? boardSwimlaneMode = null,Object? boardCardDensity = null,Object? boardVisibleCardFields = null,Object? boardWipLimitCount = null,Object? boardHiddenColumnCount = null,}) {
  return _then(_self.copyWith(
defaultView: null == defaultView ? _self.defaultView : defaultView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewKind,listDefaultColumns: null == listDefaultColumns ? _self.listDefaultColumns : listDefaultColumns // ignore: cast_nullable_to_non_nullable
as List<String>,listSortField: null == listSortField ? _self.listSortField : listSortField // ignore: cast_nullable_to_non_nullable
as String,listSortDirection: null == listSortDirection ? _self.listSortDirection : listSortDirection // ignore: cast_nullable_to_non_nullable
as String,listGroupBy: null == listGroupBy ? _self.listGroupBy : listGroupBy // ignore: cast_nullable_to_non_nullable
as String,boardSwimlaneMode: null == boardSwimlaneMode ? _self.boardSwimlaneMode : boardSwimlaneMode // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode,boardCardDensity: null == boardCardDensity ? _self.boardCardDensity : boardCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity,boardVisibleCardFields: null == boardVisibleCardFields ? _self.boardVisibleCardFields : boardVisibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>,boardWipLimitCount: null == boardWipLimitCount ? _self.boardWipLimitCount : boardWipLimitCount // ignore: cast_nullable_to_non_nullable
as int,boardHiddenColumnCount: null == boardHiddenColumnCount ? _self.boardHiddenColumnCount : boardHiddenColumnCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupTaskViewPreviewResponse].
extension ProjectSetupTaskViewPreviewResponsePatterns on ProjectSetupTaskViewPreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupTaskViewPreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupTaskViewPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupTaskViewPreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupTaskViewPreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupTaskViewPreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupTaskViewPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectSetupTaskViewKind defaultView,  List<String> listDefaultColumns,  String listSortField,  String listSortDirection,  String listGroupBy,  KanbanSwimlaneMode boardSwimlaneMode,  KanbanCardDensity boardCardDensity,  List<KanbanCardField> boardVisibleCardFields,  int boardWipLimitCount,  int boardHiddenColumnCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupTaskViewPreviewResponse() when $default != null:
return $default(_that.defaultView,_that.listDefaultColumns,_that.listSortField,_that.listSortDirection,_that.listGroupBy,_that.boardSwimlaneMode,_that.boardCardDensity,_that.boardVisibleCardFields,_that.boardWipLimitCount,_that.boardHiddenColumnCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectSetupTaskViewKind defaultView,  List<String> listDefaultColumns,  String listSortField,  String listSortDirection,  String listGroupBy,  KanbanSwimlaneMode boardSwimlaneMode,  KanbanCardDensity boardCardDensity,  List<KanbanCardField> boardVisibleCardFields,  int boardWipLimitCount,  int boardHiddenColumnCount)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupTaskViewPreviewResponse():
return $default(_that.defaultView,_that.listDefaultColumns,_that.listSortField,_that.listSortDirection,_that.listGroupBy,_that.boardSwimlaneMode,_that.boardCardDensity,_that.boardVisibleCardFields,_that.boardWipLimitCount,_that.boardHiddenColumnCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectSetupTaskViewKind defaultView,  List<String> listDefaultColumns,  String listSortField,  String listSortDirection,  String listGroupBy,  KanbanSwimlaneMode boardSwimlaneMode,  KanbanCardDensity boardCardDensity,  List<KanbanCardField> boardVisibleCardFields,  int boardWipLimitCount,  int boardHiddenColumnCount)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupTaskViewPreviewResponse() when $default != null:
return $default(_that.defaultView,_that.listDefaultColumns,_that.listSortField,_that.listSortDirection,_that.listGroupBy,_that.boardSwimlaneMode,_that.boardCardDensity,_that.boardVisibleCardFields,_that.boardWipLimitCount,_that.boardHiddenColumnCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupTaskViewPreviewResponse implements ProjectSetupTaskViewPreviewResponse {
  const _ProjectSetupTaskViewPreviewResponse({required this.defaultView, required this.listDefaultColumns, required this.listSortField, required this.listSortDirection, required this.listGroupBy, required this.boardSwimlaneMode, required this.boardCardDensity, required this.boardVisibleCardFields, required this.boardWipLimitCount, required this.boardHiddenColumnCount});
  factory _ProjectSetupTaskViewPreviewResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupTaskViewPreviewResponseFromJson(json);

/// Domyślny widok modułu Zadania zapisany w projekcie.
@override final  ProjectSetupTaskViewKind defaultView;
/// Domyślne kolumny polityki listy zadań.
@override final  List<String> listDefaultColumns;
/// Domyślne pole sortowania listy zadań.
@override final  String listSortField;
/// Domyślny kierunek sortowania listy zadań.
@override final  String listSortDirection;
/// Domyślny sposób grupowania listy zadań.
@override final  String listGroupBy;
/// Sposób grupowania kart Kanban.
@override final  KanbanSwimlaneMode boardSwimlaneMode;
/// Domyślna gęstość kafelka Kanban.
@override final  KanbanCardDensity boardCardDensity;
/// Pola widoczne domyślnie na kafelku Kanban.
@override final  List<KanbanCardField> boardVisibleCardFields;
/// Liczba kolumn z limitem WIP.
@override final  int boardWipLimitCount;
/// Liczba ukrytych kolumn tablicy.
@override final  int boardHiddenColumnCount;

/// Create a copy of ProjectSetupTaskViewPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupTaskViewPreviewResponseCopyWith<_ProjectSetupTaskViewPreviewResponse> get copyWith => __$ProjectSetupTaskViewPreviewResponseCopyWithImpl<_ProjectSetupTaskViewPreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupTaskViewPreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupTaskViewPreviewResponse&&(identical(other.defaultView, defaultView) || other.defaultView == defaultView)&&const DeepCollectionEquality().equals(other.listDefaultColumns, listDefaultColumns)&&(identical(other.listSortField, listSortField) || other.listSortField == listSortField)&&(identical(other.listSortDirection, listSortDirection) || other.listSortDirection == listSortDirection)&&(identical(other.listGroupBy, listGroupBy) || other.listGroupBy == listGroupBy)&&(identical(other.boardSwimlaneMode, boardSwimlaneMode) || other.boardSwimlaneMode == boardSwimlaneMode)&&(identical(other.boardCardDensity, boardCardDensity) || other.boardCardDensity == boardCardDensity)&&const DeepCollectionEquality().equals(other.boardVisibleCardFields, boardVisibleCardFields)&&(identical(other.boardWipLimitCount, boardWipLimitCount) || other.boardWipLimitCount == boardWipLimitCount)&&(identical(other.boardHiddenColumnCount, boardHiddenColumnCount) || other.boardHiddenColumnCount == boardHiddenColumnCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultView,const DeepCollectionEquality().hash(listDefaultColumns),listSortField,listSortDirection,listGroupBy,boardSwimlaneMode,boardCardDensity,const DeepCollectionEquality().hash(boardVisibleCardFields),boardWipLimitCount,boardHiddenColumnCount);

@override
String toString() {
  return 'ProjectSetupTaskViewPreviewResponse(defaultView: $defaultView, listDefaultColumns: $listDefaultColumns, listSortField: $listSortField, listSortDirection: $listSortDirection, listGroupBy: $listGroupBy, boardSwimlaneMode: $boardSwimlaneMode, boardCardDensity: $boardCardDensity, boardVisibleCardFields: $boardVisibleCardFields, boardWipLimitCount: $boardWipLimitCount, boardHiddenColumnCount: $boardHiddenColumnCount)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupTaskViewPreviewResponseCopyWith<$Res> implements $ProjectSetupTaskViewPreviewResponseCopyWith<$Res> {
  factory _$ProjectSetupTaskViewPreviewResponseCopyWith(_ProjectSetupTaskViewPreviewResponse value, $Res Function(_ProjectSetupTaskViewPreviewResponse) _then) = __$ProjectSetupTaskViewPreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectSetupTaskViewKind defaultView, List<String> listDefaultColumns, String listSortField, String listSortDirection, String listGroupBy, KanbanSwimlaneMode boardSwimlaneMode, KanbanCardDensity boardCardDensity, List<KanbanCardField> boardVisibleCardFields, int boardWipLimitCount, int boardHiddenColumnCount
});




}
/// @nodoc
class __$ProjectSetupTaskViewPreviewResponseCopyWithImpl<$Res>
    implements _$ProjectSetupTaskViewPreviewResponseCopyWith<$Res> {
  __$ProjectSetupTaskViewPreviewResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupTaskViewPreviewResponse _self;
  final $Res Function(_ProjectSetupTaskViewPreviewResponse) _then;

/// Create a copy of ProjectSetupTaskViewPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultView = null,Object? listDefaultColumns = null,Object? listSortField = null,Object? listSortDirection = null,Object? listGroupBy = null,Object? boardSwimlaneMode = null,Object? boardCardDensity = null,Object? boardVisibleCardFields = null,Object? boardWipLimitCount = null,Object? boardHiddenColumnCount = null,}) {
  return _then(_ProjectSetupTaskViewPreviewResponse(
defaultView: null == defaultView ? _self.defaultView : defaultView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewKind,listDefaultColumns: null == listDefaultColumns ? _self.listDefaultColumns : listDefaultColumns // ignore: cast_nullable_to_non_nullable
as List<String>,listSortField: null == listSortField ? _self.listSortField : listSortField // ignore: cast_nullable_to_non_nullable
as String,listSortDirection: null == listSortDirection ? _self.listSortDirection : listSortDirection // ignore: cast_nullable_to_non_nullable
as String,listGroupBy: null == listGroupBy ? _self.listGroupBy : listGroupBy // ignore: cast_nullable_to_non_nullable
as String,boardSwimlaneMode: null == boardSwimlaneMode ? _self.boardSwimlaneMode : boardSwimlaneMode // ignore: cast_nullable_to_non_nullable
as KanbanSwimlaneMode,boardCardDensity: null == boardCardDensity ? _self.boardCardDensity : boardCardDensity // ignore: cast_nullable_to_non_nullable
as KanbanCardDensity,boardVisibleCardFields: null == boardVisibleCardFields ? _self.boardVisibleCardFields : boardVisibleCardFields // ignore: cast_nullable_to_non_nullable
as List<KanbanCardField>,boardWipLimitCount: null == boardWipLimitCount ? _self.boardWipLimitCount : boardWipLimitCount // ignore: cast_nullable_to_non_nullable
as int,boardHiddenColumnCount: null == boardHiddenColumnCount ? _self.boardHiddenColumnCount : boardHiddenColumnCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupRecipePreviewResponse {

/// Klucz przepisu z katalogu automatyzacji.
 String get key;/// Nazwa przepisu.
 String get name;
/// Create a copy of ProjectSetupRecipePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupRecipePreviewResponseCopyWith<ProjectSetupRecipePreviewResponse> get copyWith => _$ProjectSetupRecipePreviewResponseCopyWithImpl<ProjectSetupRecipePreviewResponse>(this as ProjectSetupRecipePreviewResponse, _$identity);

  /// Serializes this ProjectSetupRecipePreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupRecipePreviewResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name);

@override
String toString() {
  return 'ProjectSetupRecipePreviewResponse(key: $key, name: $name)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupRecipePreviewResponseCopyWith<$Res>  {
  factory $ProjectSetupRecipePreviewResponseCopyWith(ProjectSetupRecipePreviewResponse value, $Res Function(ProjectSetupRecipePreviewResponse) _then) = _$ProjectSetupRecipePreviewResponseCopyWithImpl;
@useResult
$Res call({
 String key, String name
});




}
/// @nodoc
class _$ProjectSetupRecipePreviewResponseCopyWithImpl<$Res>
    implements $ProjectSetupRecipePreviewResponseCopyWith<$Res> {
  _$ProjectSetupRecipePreviewResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupRecipePreviewResponse _self;
  final $Res Function(ProjectSetupRecipePreviewResponse) _then;

/// Create a copy of ProjectSetupRecipePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupRecipePreviewResponse].
extension ProjectSetupRecipePreviewResponsePatterns on ProjectSetupRecipePreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupRecipePreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupRecipePreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupRecipePreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupRecipePreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupRecipePreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupRecipePreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupRecipePreviewResponse() when $default != null:
return $default(_that.key,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupRecipePreviewResponse():
return $default(_that.key,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupRecipePreviewResponse() when $default != null:
return $default(_that.key,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupRecipePreviewResponse implements ProjectSetupRecipePreviewResponse {
  const _ProjectSetupRecipePreviewResponse({required this.key, required this.name});
  factory _ProjectSetupRecipePreviewResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupRecipePreviewResponseFromJson(json);

/// Klucz przepisu z katalogu automatyzacji.
@override final  String key;
/// Nazwa przepisu.
@override final  String name;

/// Create a copy of ProjectSetupRecipePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupRecipePreviewResponseCopyWith<_ProjectSetupRecipePreviewResponse> get copyWith => __$ProjectSetupRecipePreviewResponseCopyWithImpl<_ProjectSetupRecipePreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupRecipePreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupRecipePreviewResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name);

@override
String toString() {
  return 'ProjectSetupRecipePreviewResponse(key: $key, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupRecipePreviewResponseCopyWith<$Res> implements $ProjectSetupRecipePreviewResponseCopyWith<$Res> {
  factory _$ProjectSetupRecipePreviewResponseCopyWith(_ProjectSetupRecipePreviewResponse value, $Res Function(_ProjectSetupRecipePreviewResponse) _then) = __$ProjectSetupRecipePreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 String key, String name
});




}
/// @nodoc
class __$ProjectSetupRecipePreviewResponseCopyWithImpl<$Res>
    implements _$ProjectSetupRecipePreviewResponseCopyWith<$Res> {
  __$ProjectSetupRecipePreviewResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupRecipePreviewResponse _self;
  final $Res Function(_ProjectSetupRecipePreviewResponse) _then;

/// Create a copy of ProjectSetupRecipePreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,}) {
  return _then(_ProjectSetupRecipePreviewResponse(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupPreviewResponse {

/// Sposób startu projektu przyjęty w planie.
 ProjectSetupSourceKind get source;/// Podsumowanie szablonu albo null dla pustego projektu.
 ProjectSetupTemplatePreviewResponse? get template;/// Znormalizowane dane projektu razem z listą przyszłych członkostw.
 ProjectSetupProjectPreviewResponse get project;/// Workflow, który powstanie razem z projektem.
 ProjectSetupWorkflowPreviewResponse get workflow;/// Ustawienia widoku zadań, które powstaną razem z projektem.
 ProjectSetupTaskViewPreviewResponse get taskView;/// Tryb harmonogramowania projektu.
 String get scheduleMode;/// Domyślna dzienna pojemność workspace, jeśli żądanie ją zmienia.
 int? get defaultDailyCapacityMinutes;/// Przepisy automatyzacji instalowane w projekcie.
 List<ProjectSetupRecipePreviewResponse> get automationRecipes;/// Ostrzeżenia planu; nie blokują wykonania.
 List<ProjectSetupWarningResponse> get warnings;/// Zadania, które powstaną razem z projektem, każde z nazwą kolumny
/// docelowej.
///
/// Pole jest opcjonalne, bo starsza wersja planu go nie wysyłała; brak listy
/// oznacza, że podgląd nadal korzysta z zawartości szablonu.
@JsonKey(name: 'tasks') List<ProjectSetupTaskPreviewResponse>? get tasks;
/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupPreviewResponseCopyWith<ProjectSetupPreviewResponse> get copyWith => _$ProjectSetupPreviewResponseCopyWithImpl<ProjectSetupPreviewResponse>(this as ProjectSetupPreviewResponse, _$identity);

  /// Serializes this ProjectSetupPreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupPreviewResponse&&(identical(other.source, source) || other.source == source)&&(identical(other.template, template) || other.template == template)&&(identical(other.project, project) || other.project == project)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&(identical(other.taskView, taskView) || other.taskView == taskView)&&(identical(other.scheduleMode, scheduleMode) || other.scheduleMode == scheduleMode)&&(identical(other.defaultDailyCapacityMinutes, defaultDailyCapacityMinutes) || other.defaultDailyCapacityMinutes == defaultDailyCapacityMinutes)&&const DeepCollectionEquality().equals(other.automationRecipes, automationRecipes)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&const DeepCollectionEquality().equals(other.tasks, tasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,template,project,workflow,taskView,scheduleMode,defaultDailyCapacityMinutes,const DeepCollectionEquality().hash(automationRecipes),const DeepCollectionEquality().hash(warnings),const DeepCollectionEquality().hash(tasks));

@override
String toString() {
  return 'ProjectSetupPreviewResponse(source: $source, template: $template, project: $project, workflow: $workflow, taskView: $taskView, scheduleMode: $scheduleMode, defaultDailyCapacityMinutes: $defaultDailyCapacityMinutes, automationRecipes: $automationRecipes, warnings: $warnings, tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupPreviewResponseCopyWith<$Res>  {
  factory $ProjectSetupPreviewResponseCopyWith(ProjectSetupPreviewResponse value, $Res Function(ProjectSetupPreviewResponse) _then) = _$ProjectSetupPreviewResponseCopyWithImpl;
@useResult
$Res call({
 ProjectSetupSourceKind source, ProjectSetupTemplatePreviewResponse? template, ProjectSetupProjectPreviewResponse project, ProjectSetupWorkflowPreviewResponse workflow, ProjectSetupTaskViewPreviewResponse taskView, String scheduleMode, int? defaultDailyCapacityMinutes, List<ProjectSetupRecipePreviewResponse> automationRecipes, List<ProjectSetupWarningResponse> warnings,@JsonKey(name: 'tasks') List<ProjectSetupTaskPreviewResponse>? tasks
});


$ProjectSetupTemplatePreviewResponseCopyWith<$Res>? get template;$ProjectSetupProjectPreviewResponseCopyWith<$Res> get project;$ProjectSetupWorkflowPreviewResponseCopyWith<$Res> get workflow;$ProjectSetupTaskViewPreviewResponseCopyWith<$Res> get taskView;

}
/// @nodoc
class _$ProjectSetupPreviewResponseCopyWithImpl<$Res>
    implements $ProjectSetupPreviewResponseCopyWith<$Res> {
  _$ProjectSetupPreviewResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupPreviewResponse _self;
  final $Res Function(ProjectSetupPreviewResponse) _then;

/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? template = freezed,Object? project = null,Object? workflow = null,Object? taskView = null,Object? scheduleMode = null,Object? defaultDailyCapacityMinutes = freezed,Object? automationRecipes = null,Object? warnings = null,Object? tasks = freezed,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ProjectSetupSourceKind,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as ProjectSetupTemplatePreviewResponse?,project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectSetupProjectPreviewResponse,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowPreviewResponse,taskView: null == taskView ? _self.taskView : taskView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewPreviewResponse,scheduleMode: null == scheduleMode ? _self.scheduleMode : scheduleMode // ignore: cast_nullable_to_non_nullable
as String,defaultDailyCapacityMinutes: freezed == defaultDailyCapacityMinutes ? _self.defaultDailyCapacityMinutes : defaultDailyCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int?,automationRecipes: null == automationRecipes ? _self.automationRecipes : automationRecipes // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupRecipePreviewResponse>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupWarningResponse>,tasks: freezed == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupTaskPreviewResponse>?,
  ));
}
/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupTemplatePreviewResponseCopyWith<$Res>? get template {
    if (_self.template == null) {
    return null;
  }

  return $ProjectSetupTemplatePreviewResponseCopyWith<$Res>(_self.template!, (value) {
    return _then(_self.copyWith(template: value));
  });
}/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupProjectPreviewResponseCopyWith<$Res> get project {
  
  return $ProjectSetupProjectPreviewResponseCopyWith<$Res>(_self.project, (value) {
    return _then(_self.copyWith(project: value));
  });
}/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowPreviewResponseCopyWith<$Res> get workflow {
  
  return $ProjectSetupWorkflowPreviewResponseCopyWith<$Res>(_self.workflow, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupTaskViewPreviewResponseCopyWith<$Res> get taskView {
  
  return $ProjectSetupTaskViewPreviewResponseCopyWith<$Res>(_self.taskView, (value) {
    return _then(_self.copyWith(taskView: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectSetupPreviewResponse].
extension ProjectSetupPreviewResponsePatterns on ProjectSetupPreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupPreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupPreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupPreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupPreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectSetupSourceKind source,  ProjectSetupTemplatePreviewResponse? template,  ProjectSetupProjectPreviewResponse project,  ProjectSetupWorkflowPreviewResponse workflow,  ProjectSetupTaskViewPreviewResponse taskView,  String scheduleMode,  int? defaultDailyCapacityMinutes,  List<ProjectSetupRecipePreviewResponse> automationRecipes,  List<ProjectSetupWarningResponse> warnings, @JsonKey(name: 'tasks')  List<ProjectSetupTaskPreviewResponse>? tasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupPreviewResponse() when $default != null:
return $default(_that.source,_that.template,_that.project,_that.workflow,_that.taskView,_that.scheduleMode,_that.defaultDailyCapacityMinutes,_that.automationRecipes,_that.warnings,_that.tasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectSetupSourceKind source,  ProjectSetupTemplatePreviewResponse? template,  ProjectSetupProjectPreviewResponse project,  ProjectSetupWorkflowPreviewResponse workflow,  ProjectSetupTaskViewPreviewResponse taskView,  String scheduleMode,  int? defaultDailyCapacityMinutes,  List<ProjectSetupRecipePreviewResponse> automationRecipes,  List<ProjectSetupWarningResponse> warnings, @JsonKey(name: 'tasks')  List<ProjectSetupTaskPreviewResponse>? tasks)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupPreviewResponse():
return $default(_that.source,_that.template,_that.project,_that.workflow,_that.taskView,_that.scheduleMode,_that.defaultDailyCapacityMinutes,_that.automationRecipes,_that.warnings,_that.tasks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectSetupSourceKind source,  ProjectSetupTemplatePreviewResponse? template,  ProjectSetupProjectPreviewResponse project,  ProjectSetupWorkflowPreviewResponse workflow,  ProjectSetupTaskViewPreviewResponse taskView,  String scheduleMode,  int? defaultDailyCapacityMinutes,  List<ProjectSetupRecipePreviewResponse> automationRecipes,  List<ProjectSetupWarningResponse> warnings, @JsonKey(name: 'tasks')  List<ProjectSetupTaskPreviewResponse>? tasks)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupPreviewResponse() when $default != null:
return $default(_that.source,_that.template,_that.project,_that.workflow,_that.taskView,_that.scheduleMode,_that.defaultDailyCapacityMinutes,_that.automationRecipes,_that.warnings,_that.tasks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupPreviewResponse implements ProjectSetupPreviewResponse {
  const _ProjectSetupPreviewResponse({required this.source, this.template, required this.project, required this.workflow, required this.taskView, required this.scheduleMode, this.defaultDailyCapacityMinutes, required this.automationRecipes, required this.warnings, @JsonKey(name: 'tasks') this.tasks});
  factory _ProjectSetupPreviewResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupPreviewResponseFromJson(json);

/// Sposób startu projektu przyjęty w planie.
@override final  ProjectSetupSourceKind source;
/// Podsumowanie szablonu albo null dla pustego projektu.
@override final  ProjectSetupTemplatePreviewResponse? template;
/// Znormalizowane dane projektu razem z listą przyszłych członkostw.
@override final  ProjectSetupProjectPreviewResponse project;
/// Workflow, który powstanie razem z projektem.
@override final  ProjectSetupWorkflowPreviewResponse workflow;
/// Ustawienia widoku zadań, które powstaną razem z projektem.
@override final  ProjectSetupTaskViewPreviewResponse taskView;
/// Tryb harmonogramowania projektu.
@override final  String scheduleMode;
/// Domyślna dzienna pojemność workspace, jeśli żądanie ją zmienia.
@override final  int? defaultDailyCapacityMinutes;
/// Przepisy automatyzacji instalowane w projekcie.
@override final  List<ProjectSetupRecipePreviewResponse> automationRecipes;
/// Ostrzeżenia planu; nie blokują wykonania.
@override final  List<ProjectSetupWarningResponse> warnings;
/// Zadania, które powstaną razem z projektem, każde z nazwą kolumny
/// docelowej.
///
/// Pole jest opcjonalne, bo starsza wersja planu go nie wysyłała; brak listy
/// oznacza, że podgląd nadal korzysta z zawartości szablonu.
@override@JsonKey(name: 'tasks') final  List<ProjectSetupTaskPreviewResponse>? tasks;

/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupPreviewResponseCopyWith<_ProjectSetupPreviewResponse> get copyWith => __$ProjectSetupPreviewResponseCopyWithImpl<_ProjectSetupPreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupPreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupPreviewResponse&&(identical(other.source, source) || other.source == source)&&(identical(other.template, template) || other.template == template)&&(identical(other.project, project) || other.project == project)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&(identical(other.taskView, taskView) || other.taskView == taskView)&&(identical(other.scheduleMode, scheduleMode) || other.scheduleMode == scheduleMode)&&(identical(other.defaultDailyCapacityMinutes, defaultDailyCapacityMinutes) || other.defaultDailyCapacityMinutes == defaultDailyCapacityMinutes)&&const DeepCollectionEquality().equals(other.automationRecipes, automationRecipes)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&const DeepCollectionEquality().equals(other.tasks, tasks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,template,project,workflow,taskView,scheduleMode,defaultDailyCapacityMinutes,const DeepCollectionEquality().hash(automationRecipes),const DeepCollectionEquality().hash(warnings),const DeepCollectionEquality().hash(tasks));

@override
String toString() {
  return 'ProjectSetupPreviewResponse(source: $source, template: $template, project: $project, workflow: $workflow, taskView: $taskView, scheduleMode: $scheduleMode, defaultDailyCapacityMinutes: $defaultDailyCapacityMinutes, automationRecipes: $automationRecipes, warnings: $warnings, tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupPreviewResponseCopyWith<$Res> implements $ProjectSetupPreviewResponseCopyWith<$Res> {
  factory _$ProjectSetupPreviewResponseCopyWith(_ProjectSetupPreviewResponse value, $Res Function(_ProjectSetupPreviewResponse) _then) = __$ProjectSetupPreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectSetupSourceKind source, ProjectSetupTemplatePreviewResponse? template, ProjectSetupProjectPreviewResponse project, ProjectSetupWorkflowPreviewResponse workflow, ProjectSetupTaskViewPreviewResponse taskView, String scheduleMode, int? defaultDailyCapacityMinutes, List<ProjectSetupRecipePreviewResponse> automationRecipes, List<ProjectSetupWarningResponse> warnings,@JsonKey(name: 'tasks') List<ProjectSetupTaskPreviewResponse>? tasks
});


@override $ProjectSetupTemplatePreviewResponseCopyWith<$Res>? get template;@override $ProjectSetupProjectPreviewResponseCopyWith<$Res> get project;@override $ProjectSetupWorkflowPreviewResponseCopyWith<$Res> get workflow;@override $ProjectSetupTaskViewPreviewResponseCopyWith<$Res> get taskView;

}
/// @nodoc
class __$ProjectSetupPreviewResponseCopyWithImpl<$Res>
    implements _$ProjectSetupPreviewResponseCopyWith<$Res> {
  __$ProjectSetupPreviewResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupPreviewResponse _self;
  final $Res Function(_ProjectSetupPreviewResponse) _then;

/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? template = freezed,Object? project = null,Object? workflow = null,Object? taskView = null,Object? scheduleMode = null,Object? defaultDailyCapacityMinutes = freezed,Object? automationRecipes = null,Object? warnings = null,Object? tasks = freezed,}) {
  return _then(_ProjectSetupPreviewResponse(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ProjectSetupSourceKind,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as ProjectSetupTemplatePreviewResponse?,project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectSetupProjectPreviewResponse,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowPreviewResponse,taskView: null == taskView ? _self.taskView : taskView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewPreviewResponse,scheduleMode: null == scheduleMode ? _self.scheduleMode : scheduleMode // ignore: cast_nullable_to_non_nullable
as String,defaultDailyCapacityMinutes: freezed == defaultDailyCapacityMinutes ? _self.defaultDailyCapacityMinutes : defaultDailyCapacityMinutes // ignore: cast_nullable_to_non_nullable
as int?,automationRecipes: null == automationRecipes ? _self.automationRecipes : automationRecipes // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupRecipePreviewResponse>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupWarningResponse>,tasks: freezed == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupTaskPreviewResponse>?,
  ));
}

/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupTemplatePreviewResponseCopyWith<$Res>? get template {
    if (_self.template == null) {
    return null;
  }

  return $ProjectSetupTemplatePreviewResponseCopyWith<$Res>(_self.template!, (value) {
    return _then(_self.copyWith(template: value));
  });
}/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupProjectPreviewResponseCopyWith<$Res> get project {
  
  return $ProjectSetupProjectPreviewResponseCopyWith<$Res>(_self.project, (value) {
    return _then(_self.copyWith(project: value));
  });
}/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowPreviewResponseCopyWith<$Res> get workflow {
  
  return $ProjectSetupWorkflowPreviewResponseCopyWith<$Res>(_self.workflow, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}/// Create a copy of ProjectSetupPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupTaskViewPreviewResponseCopyWith<$Res> get taskView {
  
  return $ProjectSetupTaskViewPreviewResponseCopyWith<$Res>(_self.taskView, (value) {
    return _then(_self.copyWith(taskView: value));
  });
}
}


/// @nodoc
mixin _$ProjectSetupTaskPreviewResponse {

/// Tytuł zadania.
 String get title;/// Nazwa kolumny (statusu), w której zadanie powstanie.
 String get statusName;/// Priorytet zadania w kontrakcie, np. `High`.
 String get priority;/// Nazwy etykiet przypisanych do zadania.
 List<String> get labels;
/// Create a copy of ProjectSetupTaskPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupTaskPreviewResponseCopyWith<ProjectSetupTaskPreviewResponse> get copyWith => _$ProjectSetupTaskPreviewResponseCopyWithImpl<ProjectSetupTaskPreviewResponse>(this as ProjectSetupTaskPreviewResponse, _$identity);

  /// Serializes this ProjectSetupTaskPreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupTaskPreviewResponse&&(identical(other.title, title) || other.title == title)&&(identical(other.statusName, statusName) || other.statusName == statusName)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.labels, labels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,statusName,priority,const DeepCollectionEquality().hash(labels));

@override
String toString() {
  return 'ProjectSetupTaskPreviewResponse(title: $title, statusName: $statusName, priority: $priority, labels: $labels)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupTaskPreviewResponseCopyWith<$Res>  {
  factory $ProjectSetupTaskPreviewResponseCopyWith(ProjectSetupTaskPreviewResponse value, $Res Function(ProjectSetupTaskPreviewResponse) _then) = _$ProjectSetupTaskPreviewResponseCopyWithImpl;
@useResult
$Res call({
 String title, String statusName, String priority, List<String> labels
});




}
/// @nodoc
class _$ProjectSetupTaskPreviewResponseCopyWithImpl<$Res>
    implements $ProjectSetupTaskPreviewResponseCopyWith<$Res> {
  _$ProjectSetupTaskPreviewResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupTaskPreviewResponse _self;
  final $Res Function(ProjectSetupTaskPreviewResponse) _then;

/// Create a copy of ProjectSetupTaskPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? statusName = null,Object? priority = null,Object? labels = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,statusName: null == statusName ? _self.statusName : statusName // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupTaskPreviewResponse].
extension ProjectSetupTaskPreviewResponsePatterns on ProjectSetupTaskPreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupTaskPreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupTaskPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupTaskPreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupTaskPreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupTaskPreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupTaskPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String statusName,  String priority,  List<String> labels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupTaskPreviewResponse() when $default != null:
return $default(_that.title,_that.statusName,_that.priority,_that.labels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String statusName,  String priority,  List<String> labels)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupTaskPreviewResponse():
return $default(_that.title,_that.statusName,_that.priority,_that.labels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String statusName,  String priority,  List<String> labels)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupTaskPreviewResponse() when $default != null:
return $default(_that.title,_that.statusName,_that.priority,_that.labels);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupTaskPreviewResponse implements ProjectSetupTaskPreviewResponse {
  const _ProjectSetupTaskPreviewResponse({required this.title, required this.statusName, required this.priority, required this.labels});
  factory _ProjectSetupTaskPreviewResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupTaskPreviewResponseFromJson(json);

/// Tytuł zadania.
@override final  String title;
/// Nazwa kolumny (statusu), w której zadanie powstanie.
@override final  String statusName;
/// Priorytet zadania w kontrakcie, np. `High`.
@override final  String priority;
/// Nazwy etykiet przypisanych do zadania.
@override final  List<String> labels;

/// Create a copy of ProjectSetupTaskPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupTaskPreviewResponseCopyWith<_ProjectSetupTaskPreviewResponse> get copyWith => __$ProjectSetupTaskPreviewResponseCopyWithImpl<_ProjectSetupTaskPreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupTaskPreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupTaskPreviewResponse&&(identical(other.title, title) || other.title == title)&&(identical(other.statusName, statusName) || other.statusName == statusName)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.labels, labels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,statusName,priority,const DeepCollectionEquality().hash(labels));

@override
String toString() {
  return 'ProjectSetupTaskPreviewResponse(title: $title, statusName: $statusName, priority: $priority, labels: $labels)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupTaskPreviewResponseCopyWith<$Res> implements $ProjectSetupTaskPreviewResponseCopyWith<$Res> {
  factory _$ProjectSetupTaskPreviewResponseCopyWith(_ProjectSetupTaskPreviewResponse value, $Res Function(_ProjectSetupTaskPreviewResponse) _then) = __$ProjectSetupTaskPreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 String title, String statusName, String priority, List<String> labels
});




}
/// @nodoc
class __$ProjectSetupTaskPreviewResponseCopyWithImpl<$Res>
    implements _$ProjectSetupTaskPreviewResponseCopyWith<$Res> {
  __$ProjectSetupTaskPreviewResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupTaskPreviewResponse _self;
  final $Res Function(_ProjectSetupTaskPreviewResponse) _then;

/// Create a copy of ProjectSetupTaskPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? statusName = null,Object? priority = null,Object? labels = null,}) {
  return _then(_ProjectSetupTaskPreviewResponse(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,statusName: null == statusName ? _self.statusName : statusName // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
