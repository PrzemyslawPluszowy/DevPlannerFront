// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_setup_result_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectSetupAutomationRuleResponse {

/// UUID utworzonej reguły automatyzacji.
 String get id;/// Klucz przepisu, z którego powstała reguła.
 String get recipeKey;/// Nazwa reguły.
 String get name;/// Czy reguła jest aktywna po utworzeniu.
 bool get isEnabled;
/// Create a copy of ProjectSetupAutomationRuleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupAutomationRuleResponseCopyWith<ProjectSetupAutomationRuleResponse> get copyWith => _$ProjectSetupAutomationRuleResponseCopyWithImpl<ProjectSetupAutomationRuleResponse>(this as ProjectSetupAutomationRuleResponse, _$identity);

  /// Serializes this ProjectSetupAutomationRuleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupAutomationRuleResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.recipeKey, recipeKey) || other.recipeKey == recipeKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recipeKey,name,isEnabled);

@override
String toString() {
  return 'ProjectSetupAutomationRuleResponse(id: $id, recipeKey: $recipeKey, name: $name, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupAutomationRuleResponseCopyWith<$Res>  {
  factory $ProjectSetupAutomationRuleResponseCopyWith(ProjectSetupAutomationRuleResponse value, $Res Function(ProjectSetupAutomationRuleResponse) _then) = _$ProjectSetupAutomationRuleResponseCopyWithImpl;
@useResult
$Res call({
 String id, String recipeKey, String name, bool isEnabled
});




}
/// @nodoc
class _$ProjectSetupAutomationRuleResponseCopyWithImpl<$Res>
    implements $ProjectSetupAutomationRuleResponseCopyWith<$Res> {
  _$ProjectSetupAutomationRuleResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupAutomationRuleResponse _self;
  final $Res Function(ProjectSetupAutomationRuleResponse) _then;

/// Create a copy of ProjectSetupAutomationRuleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipeKey = null,Object? name = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipeKey: null == recipeKey ? _self.recipeKey : recipeKey // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupAutomationRuleResponse].
extension ProjectSetupAutomationRuleResponsePatterns on ProjectSetupAutomationRuleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupAutomationRuleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupAutomationRuleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupAutomationRuleResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupAutomationRuleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupAutomationRuleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupAutomationRuleResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String recipeKey,  String name,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupAutomationRuleResponse() when $default != null:
return $default(_that.id,_that.recipeKey,_that.name,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String recipeKey,  String name,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupAutomationRuleResponse():
return $default(_that.id,_that.recipeKey,_that.name,_that.isEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String recipeKey,  String name,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupAutomationRuleResponse() when $default != null:
return $default(_that.id,_that.recipeKey,_that.name,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupAutomationRuleResponse implements ProjectSetupAutomationRuleResponse {
  const _ProjectSetupAutomationRuleResponse({required this.id, required this.recipeKey, required this.name, required this.isEnabled});
  factory _ProjectSetupAutomationRuleResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupAutomationRuleResponseFromJson(json);

/// UUID utworzonej reguły automatyzacji.
@override final  String id;
/// Klucz przepisu, z którego powstała reguła.
@override final  String recipeKey;
/// Nazwa reguły.
@override final  String name;
/// Czy reguła jest aktywna po utworzeniu.
@override final  bool isEnabled;

/// Create a copy of ProjectSetupAutomationRuleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupAutomationRuleResponseCopyWith<_ProjectSetupAutomationRuleResponse> get copyWith => __$ProjectSetupAutomationRuleResponseCopyWithImpl<_ProjectSetupAutomationRuleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupAutomationRuleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupAutomationRuleResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.recipeKey, recipeKey) || other.recipeKey == recipeKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recipeKey,name,isEnabled);

@override
String toString() {
  return 'ProjectSetupAutomationRuleResponse(id: $id, recipeKey: $recipeKey, name: $name, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupAutomationRuleResponseCopyWith<$Res> implements $ProjectSetupAutomationRuleResponseCopyWith<$Res> {
  factory _$ProjectSetupAutomationRuleResponseCopyWith(_ProjectSetupAutomationRuleResponse value, $Res Function(_ProjectSetupAutomationRuleResponse) _then) = __$ProjectSetupAutomationRuleResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String recipeKey, String name, bool isEnabled
});




}
/// @nodoc
class __$ProjectSetupAutomationRuleResponseCopyWithImpl<$Res>
    implements _$ProjectSetupAutomationRuleResponseCopyWith<$Res> {
  __$ProjectSetupAutomationRuleResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupAutomationRuleResponse _self;
  final $Res Function(_ProjectSetupAutomationRuleResponse) _then;

/// Create a copy of ProjectSetupAutomationRuleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipeKey = null,Object? name = null,Object? isEnabled = null,}) {
  return _then(_ProjectSetupAutomationRuleResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipeKey: null == recipeKey ? _self.recipeKey : recipeKey // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupWorkflowResponse {

/// Źródło workflow zapisane w projekcie.
 ProjectSetupWorkflowKind get kind;/// Klucz katalogowego szablonu workflow albo null.
 String? get templateKey;/// Liczba zapisanych własnych statusów workflow.
 int get customStatusCount;/// Liczba zapisanych statusów systemowych.
 int get systemStatusCount;
/// Create a copy of ProjectSetupWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowResponseCopyWith<ProjectSetupWorkflowResponse> get copyWith => _$ProjectSetupWorkflowResponseCopyWithImpl<ProjectSetupWorkflowResponse>(this as ProjectSetupWorkflowResponse, _$identity);

  /// Serializes this ProjectSetupWorkflowResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupWorkflowResponse&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.customStatusCount, customStatusCount) || other.customStatusCount == customStatusCount)&&(identical(other.systemStatusCount, systemStatusCount) || other.systemStatusCount == systemStatusCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,templateKey,customStatusCount,systemStatusCount);

@override
String toString() {
  return 'ProjectSetupWorkflowResponse(kind: $kind, templateKey: $templateKey, customStatusCount: $customStatusCount, systemStatusCount: $systemStatusCount)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupWorkflowResponseCopyWith<$Res>  {
  factory $ProjectSetupWorkflowResponseCopyWith(ProjectSetupWorkflowResponse value, $Res Function(ProjectSetupWorkflowResponse) _then) = _$ProjectSetupWorkflowResponseCopyWithImpl;
@useResult
$Res call({
 ProjectSetupWorkflowKind kind, String? templateKey, int customStatusCount, int systemStatusCount
});




}
/// @nodoc
class _$ProjectSetupWorkflowResponseCopyWithImpl<$Res>
    implements $ProjectSetupWorkflowResponseCopyWith<$Res> {
  _$ProjectSetupWorkflowResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupWorkflowResponse _self;
  final $Res Function(ProjectSetupWorkflowResponse) _then;

/// Create a copy of ProjectSetupWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? templateKey = freezed,Object? customStatusCount = null,Object? systemStatusCount = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowKind,templateKey: freezed == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String?,customStatusCount: null == customStatusCount ? _self.customStatusCount : customStatusCount // ignore: cast_nullable_to_non_nullable
as int,systemStatusCount: null == systemStatusCount ? _self.systemStatusCount : systemStatusCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupWorkflowResponse].
extension ProjectSetupWorkflowResponsePatterns on ProjectSetupWorkflowResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupWorkflowResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupWorkflowResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupWorkflowResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupWorkflowResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectSetupWorkflowKind kind,  String? templateKey,  int customStatusCount,  int systemStatusCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowResponse() when $default != null:
return $default(_that.kind,_that.templateKey,_that.customStatusCount,_that.systemStatusCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectSetupWorkflowKind kind,  String? templateKey,  int customStatusCount,  int systemStatusCount)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowResponse():
return $default(_that.kind,_that.templateKey,_that.customStatusCount,_that.systemStatusCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectSetupWorkflowKind kind,  String? templateKey,  int customStatusCount,  int systemStatusCount)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupWorkflowResponse() when $default != null:
return $default(_that.kind,_that.templateKey,_that.customStatusCount,_that.systemStatusCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupWorkflowResponse implements ProjectSetupWorkflowResponse {
  const _ProjectSetupWorkflowResponse({required this.kind, this.templateKey, required this.customStatusCount, required this.systemStatusCount});
  factory _ProjectSetupWorkflowResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupWorkflowResponseFromJson(json);

/// Źródło workflow zapisane w projekcie.
@override final  ProjectSetupWorkflowKind kind;
/// Klucz katalogowego szablonu workflow albo null.
@override final  String? templateKey;
/// Liczba zapisanych własnych statusów workflow.
@override final  int customStatusCount;
/// Liczba zapisanych statusów systemowych.
@override final  int systemStatusCount;

/// Create a copy of ProjectSetupWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupWorkflowResponseCopyWith<_ProjectSetupWorkflowResponse> get copyWith => __$ProjectSetupWorkflowResponseCopyWithImpl<_ProjectSetupWorkflowResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupWorkflowResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupWorkflowResponse&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.templateKey, templateKey) || other.templateKey == templateKey)&&(identical(other.customStatusCount, customStatusCount) || other.customStatusCount == customStatusCount)&&(identical(other.systemStatusCount, systemStatusCount) || other.systemStatusCount == systemStatusCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,templateKey,customStatusCount,systemStatusCount);

@override
String toString() {
  return 'ProjectSetupWorkflowResponse(kind: $kind, templateKey: $templateKey, customStatusCount: $customStatusCount, systemStatusCount: $systemStatusCount)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupWorkflowResponseCopyWith<$Res> implements $ProjectSetupWorkflowResponseCopyWith<$Res> {
  factory _$ProjectSetupWorkflowResponseCopyWith(_ProjectSetupWorkflowResponse value, $Res Function(_ProjectSetupWorkflowResponse) _then) = __$ProjectSetupWorkflowResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectSetupWorkflowKind kind, String? templateKey, int customStatusCount, int systemStatusCount
});




}
/// @nodoc
class __$ProjectSetupWorkflowResponseCopyWithImpl<$Res>
    implements _$ProjectSetupWorkflowResponseCopyWith<$Res> {
  __$ProjectSetupWorkflowResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupWorkflowResponse _self;
  final $Res Function(_ProjectSetupWorkflowResponse) _then;

/// Create a copy of ProjectSetupWorkflowResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? templateKey = freezed,Object? customStatusCount = null,Object? systemStatusCount = null,}) {
  return _then(_ProjectSetupWorkflowResponse(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowKind,templateKey: freezed == templateKey ? _self.templateKey : templateKey // ignore: cast_nullable_to_non_nullable
as String?,customStatusCount: null == customStatusCount ? _self.customStatusCount : customStatusCount // ignore: cast_nullable_to_non_nullable
as int,systemStatusCount: null == systemStatusCount ? _self.systemStatusCount : systemStatusCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupTaskViewResponse {

/// Domyślny widok modułu Zadania zapisany w projekcie.
 ProjectSetupTaskViewKind get defaultView;/// Wersja zapisanej polityki listy zadań.
 int get listPolicyVersion;/// Wersja zapisanych ustawień tablicy Kanban.
 int get boardSettingsVersion;
/// Create a copy of ProjectSetupTaskViewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupTaskViewResponseCopyWith<ProjectSetupTaskViewResponse> get copyWith => _$ProjectSetupTaskViewResponseCopyWithImpl<ProjectSetupTaskViewResponse>(this as ProjectSetupTaskViewResponse, _$identity);

  /// Serializes this ProjectSetupTaskViewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupTaskViewResponse&&(identical(other.defaultView, defaultView) || other.defaultView == defaultView)&&(identical(other.listPolicyVersion, listPolicyVersion) || other.listPolicyVersion == listPolicyVersion)&&(identical(other.boardSettingsVersion, boardSettingsVersion) || other.boardSettingsVersion == boardSettingsVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultView,listPolicyVersion,boardSettingsVersion);

@override
String toString() {
  return 'ProjectSetupTaskViewResponse(defaultView: $defaultView, listPolicyVersion: $listPolicyVersion, boardSettingsVersion: $boardSettingsVersion)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupTaskViewResponseCopyWith<$Res>  {
  factory $ProjectSetupTaskViewResponseCopyWith(ProjectSetupTaskViewResponse value, $Res Function(ProjectSetupTaskViewResponse) _then) = _$ProjectSetupTaskViewResponseCopyWithImpl;
@useResult
$Res call({
 ProjectSetupTaskViewKind defaultView, int listPolicyVersion, int boardSettingsVersion
});




}
/// @nodoc
class _$ProjectSetupTaskViewResponseCopyWithImpl<$Res>
    implements $ProjectSetupTaskViewResponseCopyWith<$Res> {
  _$ProjectSetupTaskViewResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupTaskViewResponse _self;
  final $Res Function(ProjectSetupTaskViewResponse) _then;

/// Create a copy of ProjectSetupTaskViewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultView = null,Object? listPolicyVersion = null,Object? boardSettingsVersion = null,}) {
  return _then(_self.copyWith(
defaultView: null == defaultView ? _self.defaultView : defaultView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewKind,listPolicyVersion: null == listPolicyVersion ? _self.listPolicyVersion : listPolicyVersion // ignore: cast_nullable_to_non_nullable
as int,boardSettingsVersion: null == boardSettingsVersion ? _self.boardSettingsVersion : boardSettingsVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectSetupTaskViewResponse].
extension ProjectSetupTaskViewResponsePatterns on ProjectSetupTaskViewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupTaskViewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupTaskViewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupTaskViewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupTaskViewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupTaskViewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupTaskViewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectSetupTaskViewKind defaultView,  int listPolicyVersion,  int boardSettingsVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupTaskViewResponse() when $default != null:
return $default(_that.defaultView,_that.listPolicyVersion,_that.boardSettingsVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectSetupTaskViewKind defaultView,  int listPolicyVersion,  int boardSettingsVersion)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupTaskViewResponse():
return $default(_that.defaultView,_that.listPolicyVersion,_that.boardSettingsVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectSetupTaskViewKind defaultView,  int listPolicyVersion,  int boardSettingsVersion)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupTaskViewResponse() when $default != null:
return $default(_that.defaultView,_that.listPolicyVersion,_that.boardSettingsVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupTaskViewResponse implements ProjectSetupTaskViewResponse {
  const _ProjectSetupTaskViewResponse({required this.defaultView, required this.listPolicyVersion, required this.boardSettingsVersion});
  factory _ProjectSetupTaskViewResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupTaskViewResponseFromJson(json);

/// Domyślny widok modułu Zadania zapisany w projekcie.
@override final  ProjectSetupTaskViewKind defaultView;
/// Wersja zapisanej polityki listy zadań.
@override final  int listPolicyVersion;
/// Wersja zapisanych ustawień tablicy Kanban.
@override final  int boardSettingsVersion;

/// Create a copy of ProjectSetupTaskViewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupTaskViewResponseCopyWith<_ProjectSetupTaskViewResponse> get copyWith => __$ProjectSetupTaskViewResponseCopyWithImpl<_ProjectSetupTaskViewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupTaskViewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupTaskViewResponse&&(identical(other.defaultView, defaultView) || other.defaultView == defaultView)&&(identical(other.listPolicyVersion, listPolicyVersion) || other.listPolicyVersion == listPolicyVersion)&&(identical(other.boardSettingsVersion, boardSettingsVersion) || other.boardSettingsVersion == boardSettingsVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultView,listPolicyVersion,boardSettingsVersion);

@override
String toString() {
  return 'ProjectSetupTaskViewResponse(defaultView: $defaultView, listPolicyVersion: $listPolicyVersion, boardSettingsVersion: $boardSettingsVersion)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupTaskViewResponseCopyWith<$Res> implements $ProjectSetupTaskViewResponseCopyWith<$Res> {
  factory _$ProjectSetupTaskViewResponseCopyWith(_ProjectSetupTaskViewResponse value, $Res Function(_ProjectSetupTaskViewResponse) _then) = __$ProjectSetupTaskViewResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectSetupTaskViewKind defaultView, int listPolicyVersion, int boardSettingsVersion
});




}
/// @nodoc
class __$ProjectSetupTaskViewResponseCopyWithImpl<$Res>
    implements _$ProjectSetupTaskViewResponseCopyWith<$Res> {
  __$ProjectSetupTaskViewResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupTaskViewResponse _self;
  final $Res Function(_ProjectSetupTaskViewResponse) _then;

/// Create a copy of ProjectSetupTaskViewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultView = null,Object? listPolicyVersion = null,Object? boardSettingsVersion = null,}) {
  return _then(_ProjectSetupTaskViewResponse(
defaultView: null == defaultView ? _self.defaultView : defaultView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewKind,listPolicyVersion: null == listPolicyVersion ? _self.listPolicyVersion : listPolicyVersion // ignore: cast_nullable_to_non_nullable
as int,boardSettingsVersion: null == boardSettingsVersion ? _self.boardSettingsVersion : boardSettingsVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectSetupResponse {

/// Utworzony projekt razem z wersją i capabilities twórcy.
 ProjectResponse get project;/// Workflow zapisany razem z projektem.
 ProjectSetupWorkflowResponse get workflow;/// Ustawienia widoku zadań zapisane razem z projektem.
 ProjectSetupTaskViewResponse get taskView;/// Tryb harmonogramowania zapisany w projekcie.
 String get scheduleMode;/// Liczba członkostw utworzonych razem z projektem.
 int get memberCount;/// Reguły automatyzacji zainstalowane razem z projektem.
 List<ProjectSetupAutomationRuleResponse> get automationRules;/// Klucz idempotencji, którym oznaczono operację.
 String get idempotencyKey;/// Czy odpowiedź odtworzono z wcześniej zapisanego wyniku.
 bool get replayed;/// Czas zatwierdzenia operacji w UTC.
 DateTime get completedAtUtc;
/// Create a copy of ProjectSetupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSetupResponseCopyWith<ProjectSetupResponse> get copyWith => _$ProjectSetupResponseCopyWithImpl<ProjectSetupResponse>(this as ProjectSetupResponse, _$identity);

  /// Serializes this ProjectSetupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSetupResponse&&(identical(other.project, project) || other.project == project)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&(identical(other.taskView, taskView) || other.taskView == taskView)&&(identical(other.scheduleMode, scheduleMode) || other.scheduleMode == scheduleMode)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other.automationRules, automationRules)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.replayed, replayed) || other.replayed == replayed)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,project,workflow,taskView,scheduleMode,memberCount,const DeepCollectionEquality().hash(automationRules),idempotencyKey,replayed,completedAtUtc);

@override
String toString() {
  return 'ProjectSetupResponse(project: $project, workflow: $workflow, taskView: $taskView, scheduleMode: $scheduleMode, memberCount: $memberCount, automationRules: $automationRules, idempotencyKey: $idempotencyKey, replayed: $replayed, completedAtUtc: $completedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ProjectSetupResponseCopyWith<$Res>  {
  factory $ProjectSetupResponseCopyWith(ProjectSetupResponse value, $Res Function(ProjectSetupResponse) _then) = _$ProjectSetupResponseCopyWithImpl;
@useResult
$Res call({
 ProjectResponse project, ProjectSetupWorkflowResponse workflow, ProjectSetupTaskViewResponse taskView, String scheduleMode, int memberCount, List<ProjectSetupAutomationRuleResponse> automationRules, String idempotencyKey, bool replayed, DateTime completedAtUtc
});


$ProjectResponseCopyWith<$Res> get project;$ProjectSetupWorkflowResponseCopyWith<$Res> get workflow;$ProjectSetupTaskViewResponseCopyWith<$Res> get taskView;

}
/// @nodoc
class _$ProjectSetupResponseCopyWithImpl<$Res>
    implements $ProjectSetupResponseCopyWith<$Res> {
  _$ProjectSetupResponseCopyWithImpl(this._self, this._then);

  final ProjectSetupResponse _self;
  final $Res Function(ProjectSetupResponse) _then;

/// Create a copy of ProjectSetupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? project = null,Object? workflow = null,Object? taskView = null,Object? scheduleMode = null,Object? memberCount = null,Object? automationRules = null,Object? idempotencyKey = null,Object? replayed = null,Object? completedAtUtc = null,}) {
  return _then(_self.copyWith(
project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectResponse,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowResponse,taskView: null == taskView ? _self.taskView : taskView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewResponse,scheduleMode: null == scheduleMode ? _self.scheduleMode : scheduleMode // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,automationRules: null == automationRules ? _self.automationRules : automationRules // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupAutomationRuleResponse>,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,replayed: null == replayed ? _self.replayed : replayed // ignore: cast_nullable_to_non_nullable
as bool,completedAtUtc: null == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ProjectSetupResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectResponseCopyWith<$Res> get project {
  
  return $ProjectResponseCopyWith<$Res>(_self.project, (value) {
    return _then(_self.copyWith(project: value));
  });
}/// Create a copy of ProjectSetupResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowResponseCopyWith<$Res> get workflow {
  
  return $ProjectSetupWorkflowResponseCopyWith<$Res>(_self.workflow, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}/// Create a copy of ProjectSetupResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupTaskViewResponseCopyWith<$Res> get taskView {
  
  return $ProjectSetupTaskViewResponseCopyWith<$Res>(_self.taskView, (value) {
    return _then(_self.copyWith(taskView: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectSetupResponse].
extension ProjectSetupResponsePatterns on ProjectSetupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSetupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSetupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSetupResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSetupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSetupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProjectResponse project,  ProjectSetupWorkflowResponse workflow,  ProjectSetupTaskViewResponse taskView,  String scheduleMode,  int memberCount,  List<ProjectSetupAutomationRuleResponse> automationRules,  String idempotencyKey,  bool replayed,  DateTime completedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSetupResponse() when $default != null:
return $default(_that.project,_that.workflow,_that.taskView,_that.scheduleMode,_that.memberCount,_that.automationRules,_that.idempotencyKey,_that.replayed,_that.completedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProjectResponse project,  ProjectSetupWorkflowResponse workflow,  ProjectSetupTaskViewResponse taskView,  String scheduleMode,  int memberCount,  List<ProjectSetupAutomationRuleResponse> automationRules,  String idempotencyKey,  bool replayed,  DateTime completedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupResponse():
return $default(_that.project,_that.workflow,_that.taskView,_that.scheduleMode,_that.memberCount,_that.automationRules,_that.idempotencyKey,_that.replayed,_that.completedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProjectResponse project,  ProjectSetupWorkflowResponse workflow,  ProjectSetupTaskViewResponse taskView,  String scheduleMode,  int memberCount,  List<ProjectSetupAutomationRuleResponse> automationRules,  String idempotencyKey,  bool replayed,  DateTime completedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSetupResponse() when $default != null:
return $default(_that.project,_that.workflow,_that.taskView,_that.scheduleMode,_that.memberCount,_that.automationRules,_that.idempotencyKey,_that.replayed,_that.completedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSetupResponse implements ProjectSetupResponse {
  const _ProjectSetupResponse({required this.project, required this.workflow, required this.taskView, required this.scheduleMode, required this.memberCount, required this.automationRules, required this.idempotencyKey, required this.replayed, required this.completedAtUtc});
  factory _ProjectSetupResponse.fromJson(Map<String, dynamic> json) => _$ProjectSetupResponseFromJson(json);

/// Utworzony projekt razem z wersją i capabilities twórcy.
@override final  ProjectResponse project;
/// Workflow zapisany razem z projektem.
@override final  ProjectSetupWorkflowResponse workflow;
/// Ustawienia widoku zadań zapisane razem z projektem.
@override final  ProjectSetupTaskViewResponse taskView;
/// Tryb harmonogramowania zapisany w projekcie.
@override final  String scheduleMode;
/// Liczba członkostw utworzonych razem z projektem.
@override final  int memberCount;
/// Reguły automatyzacji zainstalowane razem z projektem.
@override final  List<ProjectSetupAutomationRuleResponse> automationRules;
/// Klucz idempotencji, którym oznaczono operację.
@override final  String idempotencyKey;
/// Czy odpowiedź odtworzono z wcześniej zapisanego wyniku.
@override final  bool replayed;
/// Czas zatwierdzenia operacji w UTC.
@override final  DateTime completedAtUtc;

/// Create a copy of ProjectSetupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSetupResponseCopyWith<_ProjectSetupResponse> get copyWith => __$ProjectSetupResponseCopyWithImpl<_ProjectSetupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSetupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSetupResponse&&(identical(other.project, project) || other.project == project)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&(identical(other.taskView, taskView) || other.taskView == taskView)&&(identical(other.scheduleMode, scheduleMode) || other.scheduleMode == scheduleMode)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other.automationRules, automationRules)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.replayed, replayed) || other.replayed == replayed)&&(identical(other.completedAtUtc, completedAtUtc) || other.completedAtUtc == completedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,project,workflow,taskView,scheduleMode,memberCount,const DeepCollectionEquality().hash(automationRules),idempotencyKey,replayed,completedAtUtc);

@override
String toString() {
  return 'ProjectSetupResponse(project: $project, workflow: $workflow, taskView: $taskView, scheduleMode: $scheduleMode, memberCount: $memberCount, automationRules: $automationRules, idempotencyKey: $idempotencyKey, replayed: $replayed, completedAtUtc: $completedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ProjectSetupResponseCopyWith<$Res> implements $ProjectSetupResponseCopyWith<$Res> {
  factory _$ProjectSetupResponseCopyWith(_ProjectSetupResponse value, $Res Function(_ProjectSetupResponse) _then) = __$ProjectSetupResponseCopyWithImpl;
@override @useResult
$Res call({
 ProjectResponse project, ProjectSetupWorkflowResponse workflow, ProjectSetupTaskViewResponse taskView, String scheduleMode, int memberCount, List<ProjectSetupAutomationRuleResponse> automationRules, String idempotencyKey, bool replayed, DateTime completedAtUtc
});


@override $ProjectResponseCopyWith<$Res> get project;@override $ProjectSetupWorkflowResponseCopyWith<$Res> get workflow;@override $ProjectSetupTaskViewResponseCopyWith<$Res> get taskView;

}
/// @nodoc
class __$ProjectSetupResponseCopyWithImpl<$Res>
    implements _$ProjectSetupResponseCopyWith<$Res> {
  __$ProjectSetupResponseCopyWithImpl(this._self, this._then);

  final _ProjectSetupResponse _self;
  final $Res Function(_ProjectSetupResponse) _then;

/// Create a copy of ProjectSetupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? project = null,Object? workflow = null,Object? taskView = null,Object? scheduleMode = null,Object? memberCount = null,Object? automationRules = null,Object? idempotencyKey = null,Object? replayed = null,Object? completedAtUtc = null,}) {
  return _then(_ProjectSetupResponse(
project: null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as ProjectResponse,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as ProjectSetupWorkflowResponse,taskView: null == taskView ? _self.taskView : taskView // ignore: cast_nullable_to_non_nullable
as ProjectSetupTaskViewResponse,scheduleMode: null == scheduleMode ? _self.scheduleMode : scheduleMode // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,automationRules: null == automationRules ? _self.automationRules : automationRules // ignore: cast_nullable_to_non_nullable
as List<ProjectSetupAutomationRuleResponse>,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,replayed: null == replayed ? _self.replayed : replayed // ignore: cast_nullable_to_non_nullable
as bool,completedAtUtc: null == completedAtUtc ? _self.completedAtUtc : completedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ProjectSetupResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectResponseCopyWith<$Res> get project {
  
  return $ProjectResponseCopyWith<$Res>(_self.project, (value) {
    return _then(_self.copyWith(project: value));
  });
}/// Create a copy of ProjectSetupResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupWorkflowResponseCopyWith<$Res> get workflow {
  
  return $ProjectSetupWorkflowResponseCopyWith<$Res>(_self.workflow, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}/// Create a copy of ProjectSetupResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProjectSetupTaskViewResponseCopyWith<$Res> get taskView {
  
  return $ProjectSetupTaskViewResponseCopyWith<$Res>(_self.taskView, (value) {
    return _then(_self.copyWith(taskView: value));
  });
}
}

// dart format on
