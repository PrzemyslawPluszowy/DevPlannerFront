// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'automation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AutomationCondition {

 AutomationConditionType get type; ProjectTaskStatus? get status; TaskPriority? get priority; String? get userId; String? get labelId; int? get days; String? get text;
/// Create a copy of AutomationCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationConditionCopyWith<AutomationCondition> get copyWith => _$AutomationConditionCopyWithImpl<AutomationCondition>(this as AutomationCondition, _$identity);

  /// Serializes this AutomationCondition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationCondition&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.labelId, labelId) || other.labelId == labelId)&&(identical(other.days, days) || other.days == days)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,status,priority,userId,labelId,days,text);

@override
String toString() {
  return 'AutomationCondition(type: $type, status: $status, priority: $priority, userId: $userId, labelId: $labelId, days: $days, text: $text)';
}


}

/// @nodoc
abstract mixin class $AutomationConditionCopyWith<$Res>  {
  factory $AutomationConditionCopyWith(AutomationCondition value, $Res Function(AutomationCondition) _then) = _$AutomationConditionCopyWithImpl;
@useResult
$Res call({
 AutomationConditionType type, ProjectTaskStatus? status, TaskPriority? priority, String? userId, String? labelId, int? days, String? text
});




}
/// @nodoc
class _$AutomationConditionCopyWithImpl<$Res>
    implements $AutomationConditionCopyWith<$Res> {
  _$AutomationConditionCopyWithImpl(this._self, this._then);

  final AutomationCondition _self;
  final $Res Function(AutomationCondition) _then;

/// Create a copy of AutomationCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? status = freezed,Object? priority = freezed,Object? userId = freezed,Object? labelId = freezed,Object? days = freezed,Object? text = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationConditionType,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,labelId: freezed == labelId ? _self.labelId : labelId // ignore: cast_nullable_to_non_nullable
as String?,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationCondition].
extension AutomationConditionPatterns on AutomationCondition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationCondition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationCondition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationCondition value)  $default,){
final _that = this;
switch (_that) {
case _AutomationCondition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationCondition value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationCondition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AutomationConditionType type,  ProjectTaskStatus? status,  TaskPriority? priority,  String? userId,  String? labelId,  int? days,  String? text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationCondition() when $default != null:
return $default(_that.type,_that.status,_that.priority,_that.userId,_that.labelId,_that.days,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AutomationConditionType type,  ProjectTaskStatus? status,  TaskPriority? priority,  String? userId,  String? labelId,  int? days,  String? text)  $default,) {final _that = this;
switch (_that) {
case _AutomationCondition():
return $default(_that.type,_that.status,_that.priority,_that.userId,_that.labelId,_that.days,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AutomationConditionType type,  ProjectTaskStatus? status,  TaskPriority? priority,  String? userId,  String? labelId,  int? days,  String? text)?  $default,) {final _that = this;
switch (_that) {
case _AutomationCondition() when $default != null:
return $default(_that.type,_that.status,_that.priority,_that.userId,_that.labelId,_that.days,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationCondition implements AutomationCondition {
  const _AutomationCondition({required this.type, this.status, this.priority, this.userId, this.labelId, this.days, this.text});
  factory _AutomationCondition.fromJson(Map<String, dynamic> json) => _$AutomationConditionFromJson(json);

@override final  AutomationConditionType type;
@override final  ProjectTaskStatus? status;
@override final  TaskPriority? priority;
@override final  String? userId;
@override final  String? labelId;
@override final  int? days;
@override final  String? text;

/// Create a copy of AutomationCondition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationConditionCopyWith<_AutomationCondition> get copyWith => __$AutomationConditionCopyWithImpl<_AutomationCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationCondition&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.labelId, labelId) || other.labelId == labelId)&&(identical(other.days, days) || other.days == days)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,status,priority,userId,labelId,days,text);

@override
String toString() {
  return 'AutomationCondition(type: $type, status: $status, priority: $priority, userId: $userId, labelId: $labelId, days: $days, text: $text)';
}


}

/// @nodoc
abstract mixin class _$AutomationConditionCopyWith<$Res> implements $AutomationConditionCopyWith<$Res> {
  factory _$AutomationConditionCopyWith(_AutomationCondition value, $Res Function(_AutomationCondition) _then) = __$AutomationConditionCopyWithImpl;
@override @useResult
$Res call({
 AutomationConditionType type, ProjectTaskStatus? status, TaskPriority? priority, String? userId, String? labelId, int? days, String? text
});




}
/// @nodoc
class __$AutomationConditionCopyWithImpl<$Res>
    implements _$AutomationConditionCopyWith<$Res> {
  __$AutomationConditionCopyWithImpl(this._self, this._then);

  final _AutomationCondition _self;
  final $Res Function(_AutomationCondition) _then;

/// Create a copy of AutomationCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? status = freezed,Object? priority = freezed,Object? userId = freezed,Object? labelId = freezed,Object? days = freezed,Object? text = freezed,}) {
  return _then(_AutomationCondition(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationConditionType,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,labelId: freezed == labelId ? _self.labelId : labelId // ignore: cast_nullable_to_non_nullable
as String?,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AutomationAction {

 AutomationActionType get type; ProjectTaskStatus? get status; TaskPriority? get priority; String? get userId; String? get labelId; DateTime? get dueAtUtc; String? get text; String? get title; String? get description; String? get conversationId; String? get keyResultId; double? get value; String? get webhookUrl; Map<String, dynamic>? get payload; String? get storageFileId;
/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationActionCopyWith<AutomationAction> get copyWith => _$AutomationActionCopyWithImpl<AutomationAction>(this as AutomationAction, _$identity);

  /// Serializes this AutomationAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationAction&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.labelId, labelId) || other.labelId == labelId)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.text, text) || other.text == text)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.keyResultId, keyResultId) || other.keyResultId == keyResultId)&&(identical(other.value, value) || other.value == value)&&(identical(other.webhookUrl, webhookUrl) || other.webhookUrl == webhookUrl)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,status,priority,userId,labelId,dueAtUtc,text,title,description,conversationId,keyResultId,value,webhookUrl,const DeepCollectionEquality().hash(payload),storageFileId);

@override
String toString() {
  return 'AutomationAction(type: $type, status: $status, priority: $priority, userId: $userId, labelId: $labelId, dueAtUtc: $dueAtUtc, text: $text, title: $title, description: $description, conversationId: $conversationId, keyResultId: $keyResultId, value: $value, webhookUrl: $webhookUrl, payload: $payload, storageFileId: $storageFileId)';
}


}

/// @nodoc
abstract mixin class $AutomationActionCopyWith<$Res>  {
  factory $AutomationActionCopyWith(AutomationAction value, $Res Function(AutomationAction) _then) = _$AutomationActionCopyWithImpl;
@useResult
$Res call({
 AutomationActionType type, ProjectTaskStatus? status, TaskPriority? priority, String? userId, String? labelId, DateTime? dueAtUtc, String? text, String? title, String? description, String? conversationId, String? keyResultId, double? value, String? webhookUrl, Map<String, dynamic>? payload, String? storageFileId
});




}
/// @nodoc
class _$AutomationActionCopyWithImpl<$Res>
    implements $AutomationActionCopyWith<$Res> {
  _$AutomationActionCopyWithImpl(this._self, this._then);

  final AutomationAction _self;
  final $Res Function(AutomationAction) _then;

/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? status = freezed,Object? priority = freezed,Object? userId = freezed,Object? labelId = freezed,Object? dueAtUtc = freezed,Object? text = freezed,Object? title = freezed,Object? description = freezed,Object? conversationId = freezed,Object? keyResultId = freezed,Object? value = freezed,Object? webhookUrl = freezed,Object? payload = freezed,Object? storageFileId = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationActionType,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,labelId: freezed == labelId ? _self.labelId : labelId // ignore: cast_nullable_to_non_nullable
as String?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,keyResultId: freezed == keyResultId ? _self.keyResultId : keyResultId // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double?,webhookUrl: freezed == webhookUrl ? _self.webhookUrl : webhookUrl // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,storageFileId: freezed == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationAction].
extension AutomationActionPatterns on AutomationAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationAction value)  $default,){
final _that = this;
switch (_that) {
case _AutomationAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationAction value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AutomationActionType type,  ProjectTaskStatus? status,  TaskPriority? priority,  String? userId,  String? labelId,  DateTime? dueAtUtc,  String? text,  String? title,  String? description,  String? conversationId,  String? keyResultId,  double? value,  String? webhookUrl,  Map<String, dynamic>? payload,  String? storageFileId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationAction() when $default != null:
return $default(_that.type,_that.status,_that.priority,_that.userId,_that.labelId,_that.dueAtUtc,_that.text,_that.title,_that.description,_that.conversationId,_that.keyResultId,_that.value,_that.webhookUrl,_that.payload,_that.storageFileId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AutomationActionType type,  ProjectTaskStatus? status,  TaskPriority? priority,  String? userId,  String? labelId,  DateTime? dueAtUtc,  String? text,  String? title,  String? description,  String? conversationId,  String? keyResultId,  double? value,  String? webhookUrl,  Map<String, dynamic>? payload,  String? storageFileId)  $default,) {final _that = this;
switch (_that) {
case _AutomationAction():
return $default(_that.type,_that.status,_that.priority,_that.userId,_that.labelId,_that.dueAtUtc,_that.text,_that.title,_that.description,_that.conversationId,_that.keyResultId,_that.value,_that.webhookUrl,_that.payload,_that.storageFileId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AutomationActionType type,  ProjectTaskStatus? status,  TaskPriority? priority,  String? userId,  String? labelId,  DateTime? dueAtUtc,  String? text,  String? title,  String? description,  String? conversationId,  String? keyResultId,  double? value,  String? webhookUrl,  Map<String, dynamic>? payload,  String? storageFileId)?  $default,) {final _that = this;
switch (_that) {
case _AutomationAction() when $default != null:
return $default(_that.type,_that.status,_that.priority,_that.userId,_that.labelId,_that.dueAtUtc,_that.text,_that.title,_that.description,_that.conversationId,_that.keyResultId,_that.value,_that.webhookUrl,_that.payload,_that.storageFileId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationAction implements AutomationAction {
  const _AutomationAction({required this.type, this.status, this.priority, this.userId, this.labelId, this.dueAtUtc, this.text, this.title, this.description, this.conversationId, this.keyResultId, this.value, this.webhookUrl, this.payload, this.storageFileId});
  factory _AutomationAction.fromJson(Map<String, dynamic> json) => _$AutomationActionFromJson(json);

@override final  AutomationActionType type;
@override final  ProjectTaskStatus? status;
@override final  TaskPriority? priority;
@override final  String? userId;
@override final  String? labelId;
@override final  DateTime? dueAtUtc;
@override final  String? text;
@override final  String? title;
@override final  String? description;
@override final  String? conversationId;
@override final  String? keyResultId;
@override final  double? value;
@override final  String? webhookUrl;
@override final  Map<String, dynamic>? payload;
@override final  String? storageFileId;

/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationActionCopyWith<_AutomationAction> get copyWith => __$AutomationActionCopyWithImpl<_AutomationAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationAction&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.labelId, labelId) || other.labelId == labelId)&&(identical(other.dueAtUtc, dueAtUtc) || other.dueAtUtc == dueAtUtc)&&(identical(other.text, text) || other.text == text)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.keyResultId, keyResultId) || other.keyResultId == keyResultId)&&(identical(other.value, value) || other.value == value)&&(identical(other.webhookUrl, webhookUrl) || other.webhookUrl == webhookUrl)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.storageFileId, storageFileId) || other.storageFileId == storageFileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,status,priority,userId,labelId,dueAtUtc,text,title,description,conversationId,keyResultId,value,webhookUrl,const DeepCollectionEquality().hash(payload),storageFileId);

@override
String toString() {
  return 'AutomationAction(type: $type, status: $status, priority: $priority, userId: $userId, labelId: $labelId, dueAtUtc: $dueAtUtc, text: $text, title: $title, description: $description, conversationId: $conversationId, keyResultId: $keyResultId, value: $value, webhookUrl: $webhookUrl, payload: $payload, storageFileId: $storageFileId)';
}


}

/// @nodoc
abstract mixin class _$AutomationActionCopyWith<$Res> implements $AutomationActionCopyWith<$Res> {
  factory _$AutomationActionCopyWith(_AutomationAction value, $Res Function(_AutomationAction) _then) = __$AutomationActionCopyWithImpl;
@override @useResult
$Res call({
 AutomationActionType type, ProjectTaskStatus? status, TaskPriority? priority, String? userId, String? labelId, DateTime? dueAtUtc, String? text, String? title, String? description, String? conversationId, String? keyResultId, double? value, String? webhookUrl, Map<String, dynamic>? payload, String? storageFileId
});




}
/// @nodoc
class __$AutomationActionCopyWithImpl<$Res>
    implements _$AutomationActionCopyWith<$Res> {
  __$AutomationActionCopyWithImpl(this._self, this._then);

  final _AutomationAction _self;
  final $Res Function(_AutomationAction) _then;

/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? status = freezed,Object? priority = freezed,Object? userId = freezed,Object? labelId = freezed,Object? dueAtUtc = freezed,Object? text = freezed,Object? title = freezed,Object? description = freezed,Object? conversationId = freezed,Object? keyResultId = freezed,Object? value = freezed,Object? webhookUrl = freezed,Object? payload = freezed,Object? storageFileId = freezed,}) {
  return _then(_AutomationAction(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationActionType,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectTaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,labelId: freezed == labelId ? _self.labelId : labelId // ignore: cast_nullable_to_non_nullable
as String?,dueAtUtc: freezed == dueAtUtc ? _self.dueAtUtc : dueAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,keyResultId: freezed == keyResultId ? _self.keyResultId : keyResultId // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double?,webhookUrl: freezed == webhookUrl ? _self.webhookUrl : webhookUrl // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,storageFileId: freezed == storageFileId ? _self.storageFileId : storageFileId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateAutomationRulePayload {

 String get name; AutomationTriggerType get triggerType; Map<String, dynamic> get triggerConfig; List<AutomationCondition> get conditions; List<AutomationAction> get actions;
/// Create a copy of CreateAutomationRulePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAutomationRulePayloadCopyWith<CreateAutomationRulePayload> get copyWith => _$CreateAutomationRulePayloadCopyWithImpl<CreateAutomationRulePayload>(this as CreateAutomationRulePayload, _$identity);

  /// Serializes this CreateAutomationRulePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAutomationRulePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.triggerType, triggerType) || other.triggerType == triggerType)&&const DeepCollectionEquality().equals(other.triggerConfig, triggerConfig)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&const DeepCollectionEquality().equals(other.actions, actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,triggerType,const DeepCollectionEquality().hash(triggerConfig),const DeepCollectionEquality().hash(conditions),const DeepCollectionEquality().hash(actions));

@override
String toString() {
  return 'CreateAutomationRulePayload(name: $name, triggerType: $triggerType, triggerConfig: $triggerConfig, conditions: $conditions, actions: $actions)';
}


}

/// @nodoc
abstract mixin class $CreateAutomationRulePayloadCopyWith<$Res>  {
  factory $CreateAutomationRulePayloadCopyWith(CreateAutomationRulePayload value, $Res Function(CreateAutomationRulePayload) _then) = _$CreateAutomationRulePayloadCopyWithImpl;
@useResult
$Res call({
 String name, AutomationTriggerType triggerType, Map<String, dynamic> triggerConfig, List<AutomationCondition> conditions, List<AutomationAction> actions
});




}
/// @nodoc
class _$CreateAutomationRulePayloadCopyWithImpl<$Res>
    implements $CreateAutomationRulePayloadCopyWith<$Res> {
  _$CreateAutomationRulePayloadCopyWithImpl(this._self, this._then);

  final CreateAutomationRulePayload _self;
  final $Res Function(CreateAutomationRulePayload) _then;

/// Create a copy of CreateAutomationRulePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? triggerType = null,Object? triggerConfig = null,Object? conditions = null,Object? actions = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,triggerType: null == triggerType ? _self.triggerType : triggerType // ignore: cast_nullable_to_non_nullable
as AutomationTriggerType,triggerConfig: null == triggerConfig ? _self.triggerConfig : triggerConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<AutomationCondition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateAutomationRulePayload].
extension CreateAutomationRulePayloadPatterns on CreateAutomationRulePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateAutomationRulePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateAutomationRulePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateAutomationRulePayload value)  $default,){
final _that = this;
switch (_that) {
case _CreateAutomationRulePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateAutomationRulePayload value)?  $default,){
final _that = this;
switch (_that) {
case _CreateAutomationRulePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateAutomationRulePayload() when $default != null:
return $default(_that.name,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions)  $default,) {final _that = this;
switch (_that) {
case _CreateAutomationRulePayload():
return $default(_that.name,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions)?  $default,) {final _that = this;
switch (_that) {
case _CreateAutomationRulePayload() when $default != null:
return $default(_that.name,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateAutomationRulePayload implements CreateAutomationRulePayload {
  const _CreateAutomationRulePayload({required this.name, required this.triggerType, required this.triggerConfig, required this.conditions, required this.actions});
  factory _CreateAutomationRulePayload.fromJson(Map<String, dynamic> json) => _$CreateAutomationRulePayloadFromJson(json);

@override final  String name;
@override final  AutomationTriggerType triggerType;
@override final  Map<String, dynamic> triggerConfig;
@override final  List<AutomationCondition> conditions;
@override final  List<AutomationAction> actions;

/// Create a copy of CreateAutomationRulePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAutomationRulePayloadCopyWith<_CreateAutomationRulePayload> get copyWith => __$CreateAutomationRulePayloadCopyWithImpl<_CreateAutomationRulePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateAutomationRulePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAutomationRulePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.triggerType, triggerType) || other.triggerType == triggerType)&&const DeepCollectionEquality().equals(other.triggerConfig, triggerConfig)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&const DeepCollectionEquality().equals(other.actions, actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,triggerType,const DeepCollectionEquality().hash(triggerConfig),const DeepCollectionEquality().hash(conditions),const DeepCollectionEquality().hash(actions));

@override
String toString() {
  return 'CreateAutomationRulePayload(name: $name, triggerType: $triggerType, triggerConfig: $triggerConfig, conditions: $conditions, actions: $actions)';
}


}

/// @nodoc
abstract mixin class _$CreateAutomationRulePayloadCopyWith<$Res> implements $CreateAutomationRulePayloadCopyWith<$Res> {
  factory _$CreateAutomationRulePayloadCopyWith(_CreateAutomationRulePayload value, $Res Function(_CreateAutomationRulePayload) _then) = __$CreateAutomationRulePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, AutomationTriggerType triggerType, Map<String, dynamic> triggerConfig, List<AutomationCondition> conditions, List<AutomationAction> actions
});




}
/// @nodoc
class __$CreateAutomationRulePayloadCopyWithImpl<$Res>
    implements _$CreateAutomationRulePayloadCopyWith<$Res> {
  __$CreateAutomationRulePayloadCopyWithImpl(this._self, this._then);

  final _CreateAutomationRulePayload _self;
  final $Res Function(_CreateAutomationRulePayload) _then;

/// Create a copy of CreateAutomationRulePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? triggerType = null,Object? triggerConfig = null,Object? conditions = null,Object? actions = null,}) {
  return _then(_CreateAutomationRulePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,triggerType: null == triggerType ? _self.triggerType : triggerType // ignore: cast_nullable_to_non_nullable
as AutomationTriggerType,triggerConfig: null == triggerConfig ? _self.triggerConfig : triggerConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<AutomationCondition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,
  ));
}


}


/// @nodoc
mixin _$UpdateAutomationRulePayload {

 String get name; AutomationTriggerType get triggerType; Map<String, dynamic> get triggerConfig; List<AutomationCondition> get conditions; List<AutomationAction> get actions; int get expectedVersion;
/// Create a copy of UpdateAutomationRulePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAutomationRulePayloadCopyWith<UpdateAutomationRulePayload> get copyWith => _$UpdateAutomationRulePayloadCopyWithImpl<UpdateAutomationRulePayload>(this as UpdateAutomationRulePayload, _$identity);

  /// Serializes this UpdateAutomationRulePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAutomationRulePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.triggerType, triggerType) || other.triggerType == triggerType)&&const DeepCollectionEquality().equals(other.triggerConfig, triggerConfig)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,triggerType,const DeepCollectionEquality().hash(triggerConfig),const DeepCollectionEquality().hash(conditions),const DeepCollectionEquality().hash(actions),expectedVersion);

@override
String toString() {
  return 'UpdateAutomationRulePayload(name: $name, triggerType: $triggerType, triggerConfig: $triggerConfig, conditions: $conditions, actions: $actions, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $UpdateAutomationRulePayloadCopyWith<$Res>  {
  factory $UpdateAutomationRulePayloadCopyWith(UpdateAutomationRulePayload value, $Res Function(UpdateAutomationRulePayload) _then) = _$UpdateAutomationRulePayloadCopyWithImpl;
@useResult
$Res call({
 String name, AutomationTriggerType triggerType, Map<String, dynamic> triggerConfig, List<AutomationCondition> conditions, List<AutomationAction> actions, int expectedVersion
});




}
/// @nodoc
class _$UpdateAutomationRulePayloadCopyWithImpl<$Res>
    implements $UpdateAutomationRulePayloadCopyWith<$Res> {
  _$UpdateAutomationRulePayloadCopyWithImpl(this._self, this._then);

  final UpdateAutomationRulePayload _self;
  final $Res Function(UpdateAutomationRulePayload) _then;

/// Create a copy of UpdateAutomationRulePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? triggerType = null,Object? triggerConfig = null,Object? conditions = null,Object? actions = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,triggerType: null == triggerType ? _self.triggerType : triggerType // ignore: cast_nullable_to_non_nullable
as AutomationTriggerType,triggerConfig: null == triggerConfig ? _self.triggerConfig : triggerConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<AutomationCondition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateAutomationRulePayload].
extension UpdateAutomationRulePayloadPatterns on UpdateAutomationRulePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateAutomationRulePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateAutomationRulePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateAutomationRulePayload value)  $default,){
final _that = this;
switch (_that) {
case _UpdateAutomationRulePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateAutomationRulePayload value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateAutomationRulePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateAutomationRulePayload() when $default != null:
return $default(_that.name,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _UpdateAutomationRulePayload():
return $default(_that.name,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _UpdateAutomationRulePayload() when $default != null:
return $default(_that.name,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateAutomationRulePayload implements UpdateAutomationRulePayload {
  const _UpdateAutomationRulePayload({required this.name, required this.triggerType, required this.triggerConfig, required this.conditions, required this.actions, required this.expectedVersion});
  factory _UpdateAutomationRulePayload.fromJson(Map<String, dynamic> json) => _$UpdateAutomationRulePayloadFromJson(json);

@override final  String name;
@override final  AutomationTriggerType triggerType;
@override final  Map<String, dynamic> triggerConfig;
@override final  List<AutomationCondition> conditions;
@override final  List<AutomationAction> actions;
@override final  int expectedVersion;

/// Create a copy of UpdateAutomationRulePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAutomationRulePayloadCopyWith<_UpdateAutomationRulePayload> get copyWith => __$UpdateAutomationRulePayloadCopyWithImpl<_UpdateAutomationRulePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateAutomationRulePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAutomationRulePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.triggerType, triggerType) || other.triggerType == triggerType)&&const DeepCollectionEquality().equals(other.triggerConfig, triggerConfig)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,triggerType,const DeepCollectionEquality().hash(triggerConfig),const DeepCollectionEquality().hash(conditions),const DeepCollectionEquality().hash(actions),expectedVersion);

@override
String toString() {
  return 'UpdateAutomationRulePayload(name: $name, triggerType: $triggerType, triggerConfig: $triggerConfig, conditions: $conditions, actions: $actions, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateAutomationRulePayloadCopyWith<$Res> implements $UpdateAutomationRulePayloadCopyWith<$Res> {
  factory _$UpdateAutomationRulePayloadCopyWith(_UpdateAutomationRulePayload value, $Res Function(_UpdateAutomationRulePayload) _then) = __$UpdateAutomationRulePayloadCopyWithImpl;
@override @useResult
$Res call({
 String name, AutomationTriggerType triggerType, Map<String, dynamic> triggerConfig, List<AutomationCondition> conditions, List<AutomationAction> actions, int expectedVersion
});




}
/// @nodoc
class __$UpdateAutomationRulePayloadCopyWithImpl<$Res>
    implements _$UpdateAutomationRulePayloadCopyWith<$Res> {
  __$UpdateAutomationRulePayloadCopyWithImpl(this._self, this._then);

  final _UpdateAutomationRulePayload _self;
  final $Res Function(_UpdateAutomationRulePayload) _then;

/// Create a copy of UpdateAutomationRulePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? triggerType = null,Object? triggerConfig = null,Object? conditions = null,Object? actions = null,Object? expectedVersion = null,}) {
  return _then(_UpdateAutomationRulePayload(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,triggerType: null == triggerType ? _self.triggerType : triggerType // ignore: cast_nullable_to_non_nullable
as AutomationTriggerType,triggerConfig: null == triggerConfig ? _self.triggerConfig : triggerConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<AutomationCondition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SetAutomationRuleEnabledPayload {

 bool get enabled; int get expectedVersion;
/// Create a copy of SetAutomationRuleEnabledPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetAutomationRuleEnabledPayloadCopyWith<SetAutomationRuleEnabledPayload> get copyWith => _$SetAutomationRuleEnabledPayloadCopyWithImpl<SetAutomationRuleEnabledPayload>(this as SetAutomationRuleEnabledPayload, _$identity);

  /// Serializes this SetAutomationRuleEnabledPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetAutomationRuleEnabledPayload&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,expectedVersion);

@override
String toString() {
  return 'SetAutomationRuleEnabledPayload(enabled: $enabled, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $SetAutomationRuleEnabledPayloadCopyWith<$Res>  {
  factory $SetAutomationRuleEnabledPayloadCopyWith(SetAutomationRuleEnabledPayload value, $Res Function(SetAutomationRuleEnabledPayload) _then) = _$SetAutomationRuleEnabledPayloadCopyWithImpl;
@useResult
$Res call({
 bool enabled, int expectedVersion
});




}
/// @nodoc
class _$SetAutomationRuleEnabledPayloadCopyWithImpl<$Res>
    implements $SetAutomationRuleEnabledPayloadCopyWith<$Res> {
  _$SetAutomationRuleEnabledPayloadCopyWithImpl(this._self, this._then);

  final SetAutomationRuleEnabledPayload _self;
  final $Res Function(SetAutomationRuleEnabledPayload) _then;

/// Create a copy of SetAutomationRuleEnabledPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? expectedVersion = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SetAutomationRuleEnabledPayload].
extension SetAutomationRuleEnabledPayloadPatterns on SetAutomationRuleEnabledPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetAutomationRuleEnabledPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetAutomationRuleEnabledPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetAutomationRuleEnabledPayload value)  $default,){
final _that = this;
switch (_that) {
case _SetAutomationRuleEnabledPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetAutomationRuleEnabledPayload value)?  $default,){
final _that = this;
switch (_that) {
case _SetAutomationRuleEnabledPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  int expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetAutomationRuleEnabledPayload() when $default != null:
return $default(_that.enabled,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  int expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _SetAutomationRuleEnabledPayload():
return $default(_that.enabled,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  int expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _SetAutomationRuleEnabledPayload() when $default != null:
return $default(_that.enabled,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetAutomationRuleEnabledPayload implements SetAutomationRuleEnabledPayload {
  const _SetAutomationRuleEnabledPayload({required this.enabled, required this.expectedVersion});
  factory _SetAutomationRuleEnabledPayload.fromJson(Map<String, dynamic> json) => _$SetAutomationRuleEnabledPayloadFromJson(json);

@override final  bool enabled;
@override final  int expectedVersion;

/// Create a copy of SetAutomationRuleEnabledPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetAutomationRuleEnabledPayloadCopyWith<_SetAutomationRuleEnabledPayload> get copyWith => __$SetAutomationRuleEnabledPayloadCopyWithImpl<_SetAutomationRuleEnabledPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetAutomationRuleEnabledPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetAutomationRuleEnabledPayload&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,expectedVersion);

@override
String toString() {
  return 'SetAutomationRuleEnabledPayload(enabled: $enabled, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$SetAutomationRuleEnabledPayloadCopyWith<$Res> implements $SetAutomationRuleEnabledPayloadCopyWith<$Res> {
  factory _$SetAutomationRuleEnabledPayloadCopyWith(_SetAutomationRuleEnabledPayload value, $Res Function(_SetAutomationRuleEnabledPayload) _then) = __$SetAutomationRuleEnabledPayloadCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, int expectedVersion
});




}
/// @nodoc
class __$SetAutomationRuleEnabledPayloadCopyWithImpl<$Res>
    implements _$SetAutomationRuleEnabledPayloadCopyWith<$Res> {
  __$SetAutomationRuleEnabledPayloadCopyWithImpl(this._self, this._then);

  final _SetAutomationRuleEnabledPayload _self;
  final $Res Function(_SetAutomationRuleEnabledPayload) _then;

/// Create a copy of SetAutomationRuleEnabledPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? expectedVersion = null,}) {
  return _then(_SetAutomationRuleEnabledPayload(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,expectedVersion: null == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AutomationRuleResponse {

 String get id; String get projectId; String get name; AutomationTriggerType get triggerType; Map<String, dynamic> get triggerConfig; List<AutomationCondition> get conditions; List<AutomationAction> get actions; bool get isEnabled; int get executionCount; DateTime? get lastExecutedAtUtc; DateTime get updatedAtUtc; int get version; DateTime? get archivedAtUtc;
/// Create a copy of AutomationRuleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationRuleResponseCopyWith<AutomationRuleResponse> get copyWith => _$AutomationRuleResponseCopyWithImpl<AutomationRuleResponse>(this as AutomationRuleResponse, _$identity);

  /// Serializes this AutomationRuleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationRuleResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.triggerType, triggerType) || other.triggerType == triggerType)&&const DeepCollectionEquality().equals(other.triggerConfig, triggerConfig)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.executionCount, executionCount) || other.executionCount == executionCount)&&(identical(other.lastExecutedAtUtc, lastExecutedAtUtc) || other.lastExecutedAtUtc == lastExecutedAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name,triggerType,const DeepCollectionEquality().hash(triggerConfig),const DeepCollectionEquality().hash(conditions),const DeepCollectionEquality().hash(actions),isEnabled,executionCount,lastExecutedAtUtc,updatedAtUtc,version,archivedAtUtc);

@override
String toString() {
  return 'AutomationRuleResponse(id: $id, projectId: $projectId, name: $name, triggerType: $triggerType, triggerConfig: $triggerConfig, conditions: $conditions, actions: $actions, isEnabled: $isEnabled, executionCount: $executionCount, lastExecutedAtUtc: $lastExecutedAtUtc, updatedAtUtc: $updatedAtUtc, version: $version, archivedAtUtc: $archivedAtUtc)';
}


}

/// @nodoc
abstract mixin class $AutomationRuleResponseCopyWith<$Res>  {
  factory $AutomationRuleResponseCopyWith(AutomationRuleResponse value, $Res Function(AutomationRuleResponse) _then) = _$AutomationRuleResponseCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String name, AutomationTriggerType triggerType, Map<String, dynamic> triggerConfig, List<AutomationCondition> conditions, List<AutomationAction> actions, bool isEnabled, int executionCount, DateTime? lastExecutedAtUtc, DateTime updatedAtUtc, int version, DateTime? archivedAtUtc
});




}
/// @nodoc
class _$AutomationRuleResponseCopyWithImpl<$Res>
    implements $AutomationRuleResponseCopyWith<$Res> {
  _$AutomationRuleResponseCopyWithImpl(this._self, this._then);

  final AutomationRuleResponse _self;
  final $Res Function(AutomationRuleResponse) _then;

/// Create a copy of AutomationRuleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? name = null,Object? triggerType = null,Object? triggerConfig = null,Object? conditions = null,Object? actions = null,Object? isEnabled = null,Object? executionCount = null,Object? lastExecutedAtUtc = freezed,Object? updatedAtUtc = null,Object? version = null,Object? archivedAtUtc = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,triggerType: null == triggerType ? _self.triggerType : triggerType // ignore: cast_nullable_to_non_nullable
as AutomationTriggerType,triggerConfig: null == triggerConfig ? _self.triggerConfig : triggerConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<AutomationCondition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,executionCount: null == executionCount ? _self.executionCount : executionCount // ignore: cast_nullable_to_non_nullable
as int,lastExecutedAtUtc: freezed == lastExecutedAtUtc ? _self.lastExecutedAtUtc : lastExecutedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationRuleResponse].
extension AutomationRuleResponsePatterns on AutomationRuleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationRuleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationRuleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationRuleResponse value)  $default,){
final _that = this;
switch (_that) {
case _AutomationRuleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationRuleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationRuleResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String name,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions,  bool isEnabled,  int executionCount,  DateTime? lastExecutedAtUtc,  DateTime updatedAtUtc,  int version,  DateTime? archivedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationRuleResponse() when $default != null:
return $default(_that.id,_that.projectId,_that.name,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions,_that.isEnabled,_that.executionCount,_that.lastExecutedAtUtc,_that.updatedAtUtc,_that.version,_that.archivedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String name,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions,  bool isEnabled,  int executionCount,  DateTime? lastExecutedAtUtc,  DateTime updatedAtUtc,  int version,  DateTime? archivedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _AutomationRuleResponse():
return $default(_that.id,_that.projectId,_that.name,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions,_that.isEnabled,_that.executionCount,_that.lastExecutedAtUtc,_that.updatedAtUtc,_that.version,_that.archivedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String name,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions,  bool isEnabled,  int executionCount,  DateTime? lastExecutedAtUtc,  DateTime updatedAtUtc,  int version,  DateTime? archivedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _AutomationRuleResponse() when $default != null:
return $default(_that.id,_that.projectId,_that.name,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions,_that.isEnabled,_that.executionCount,_that.lastExecutedAtUtc,_that.updatedAtUtc,_that.version,_that.archivedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationRuleResponse implements AutomationRuleResponse {
  const _AutomationRuleResponse({required this.id, required this.projectId, required this.name, required this.triggerType, required this.triggerConfig, required this.conditions, required this.actions, required this.isEnabled, required this.executionCount, this.lastExecutedAtUtc, required this.updatedAtUtc, required this.version, this.archivedAtUtc});
  factory _AutomationRuleResponse.fromJson(Map<String, dynamic> json) => _$AutomationRuleResponseFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  String name;
@override final  AutomationTriggerType triggerType;
@override final  Map<String, dynamic> triggerConfig;
@override final  List<AutomationCondition> conditions;
@override final  List<AutomationAction> actions;
@override final  bool isEnabled;
@override final  int executionCount;
@override final  DateTime? lastExecutedAtUtc;
@override final  DateTime updatedAtUtc;
@override final  int version;
@override final  DateTime? archivedAtUtc;

/// Create a copy of AutomationRuleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationRuleResponseCopyWith<_AutomationRuleResponse> get copyWith => __$AutomationRuleResponseCopyWithImpl<_AutomationRuleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationRuleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationRuleResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.triggerType, triggerType) || other.triggerType == triggerType)&&const DeepCollectionEquality().equals(other.triggerConfig, triggerConfig)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.executionCount, executionCount) || other.executionCount == executionCount)&&(identical(other.lastExecutedAtUtc, lastExecutedAtUtc) || other.lastExecutedAtUtc == lastExecutedAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.version, version) || other.version == version)&&(identical(other.archivedAtUtc, archivedAtUtc) || other.archivedAtUtc == archivedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name,triggerType,const DeepCollectionEquality().hash(triggerConfig),const DeepCollectionEquality().hash(conditions),const DeepCollectionEquality().hash(actions),isEnabled,executionCount,lastExecutedAtUtc,updatedAtUtc,version,archivedAtUtc);

@override
String toString() {
  return 'AutomationRuleResponse(id: $id, projectId: $projectId, name: $name, triggerType: $triggerType, triggerConfig: $triggerConfig, conditions: $conditions, actions: $actions, isEnabled: $isEnabled, executionCount: $executionCount, lastExecutedAtUtc: $lastExecutedAtUtc, updatedAtUtc: $updatedAtUtc, version: $version, archivedAtUtc: $archivedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$AutomationRuleResponseCopyWith<$Res> implements $AutomationRuleResponseCopyWith<$Res> {
  factory _$AutomationRuleResponseCopyWith(_AutomationRuleResponse value, $Res Function(_AutomationRuleResponse) _then) = __$AutomationRuleResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String name, AutomationTriggerType triggerType, Map<String, dynamic> triggerConfig, List<AutomationCondition> conditions, List<AutomationAction> actions, bool isEnabled, int executionCount, DateTime? lastExecutedAtUtc, DateTime updatedAtUtc, int version, DateTime? archivedAtUtc
});




}
/// @nodoc
class __$AutomationRuleResponseCopyWithImpl<$Res>
    implements _$AutomationRuleResponseCopyWith<$Res> {
  __$AutomationRuleResponseCopyWithImpl(this._self, this._then);

  final _AutomationRuleResponse _self;
  final $Res Function(_AutomationRuleResponse) _then;

/// Create a copy of AutomationRuleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? name = null,Object? triggerType = null,Object? triggerConfig = null,Object? conditions = null,Object? actions = null,Object? isEnabled = null,Object? executionCount = null,Object? lastExecutedAtUtc = freezed,Object? updatedAtUtc = null,Object? version = null,Object? archivedAtUtc = freezed,}) {
  return _then(_AutomationRuleResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,triggerType: null == triggerType ? _self.triggerType : triggerType // ignore: cast_nullable_to_non_nullable
as AutomationTriggerType,triggerConfig: null == triggerConfig ? _self.triggerConfig : triggerConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<AutomationCondition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,executionCount: null == executionCount ? _self.executionCount : executionCount // ignore: cast_nullable_to_non_nullable
as int,lastExecutedAtUtc: freezed == lastExecutedAtUtc ? _self.lastExecutedAtUtc : lastExecutedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,archivedAtUtc: freezed == archivedAtUtc ? _self.archivedAtUtc : archivedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AutomationRunResponse {

 String get id; String get ruleId; String get triggerEventId; String get triggerSourceEntity; String get triggerSourceEntityId; AutomationRunStatus get status; int get durationMs; String? get errorMessage; Map<String, dynamic> get executionDetails; DateTime get executedAtUtc; String get correlationId; int get chainDepth;
/// Create a copy of AutomationRunResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationRunResponseCopyWith<AutomationRunResponse> get copyWith => _$AutomationRunResponseCopyWithImpl<AutomationRunResponse>(this as AutomationRunResponse, _$identity);

  /// Serializes this AutomationRunResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationRunResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.ruleId, ruleId) || other.ruleId == ruleId)&&(identical(other.triggerEventId, triggerEventId) || other.triggerEventId == triggerEventId)&&(identical(other.triggerSourceEntity, triggerSourceEntity) || other.triggerSourceEntity == triggerSourceEntity)&&(identical(other.triggerSourceEntityId, triggerSourceEntityId) || other.triggerSourceEntityId == triggerSourceEntityId)&&(identical(other.status, status) || other.status == status)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.executionDetails, executionDetails)&&(identical(other.executedAtUtc, executedAtUtc) || other.executedAtUtc == executedAtUtc)&&(identical(other.correlationId, correlationId) || other.correlationId == correlationId)&&(identical(other.chainDepth, chainDepth) || other.chainDepth == chainDepth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ruleId,triggerEventId,triggerSourceEntity,triggerSourceEntityId,status,durationMs,errorMessage,const DeepCollectionEquality().hash(executionDetails),executedAtUtc,correlationId,chainDepth);

@override
String toString() {
  return 'AutomationRunResponse(id: $id, ruleId: $ruleId, triggerEventId: $triggerEventId, triggerSourceEntity: $triggerSourceEntity, triggerSourceEntityId: $triggerSourceEntityId, status: $status, durationMs: $durationMs, errorMessage: $errorMessage, executionDetails: $executionDetails, executedAtUtc: $executedAtUtc, correlationId: $correlationId, chainDepth: $chainDepth)';
}


}

/// @nodoc
abstract mixin class $AutomationRunResponseCopyWith<$Res>  {
  factory $AutomationRunResponseCopyWith(AutomationRunResponse value, $Res Function(AutomationRunResponse) _then) = _$AutomationRunResponseCopyWithImpl;
@useResult
$Res call({
 String id, String ruleId, String triggerEventId, String triggerSourceEntity, String triggerSourceEntityId, AutomationRunStatus status, int durationMs, String? errorMessage, Map<String, dynamic> executionDetails, DateTime executedAtUtc, String correlationId, int chainDepth
});




}
/// @nodoc
class _$AutomationRunResponseCopyWithImpl<$Res>
    implements $AutomationRunResponseCopyWith<$Res> {
  _$AutomationRunResponseCopyWithImpl(this._self, this._then);

  final AutomationRunResponse _self;
  final $Res Function(AutomationRunResponse) _then;

/// Create a copy of AutomationRunResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ruleId = null,Object? triggerEventId = null,Object? triggerSourceEntity = null,Object? triggerSourceEntityId = null,Object? status = null,Object? durationMs = null,Object? errorMessage = freezed,Object? executionDetails = null,Object? executedAtUtc = null,Object? correlationId = null,Object? chainDepth = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ruleId: null == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String,triggerEventId: null == triggerEventId ? _self.triggerEventId : triggerEventId // ignore: cast_nullable_to_non_nullable
as String,triggerSourceEntity: null == triggerSourceEntity ? _self.triggerSourceEntity : triggerSourceEntity // ignore: cast_nullable_to_non_nullable
as String,triggerSourceEntityId: null == triggerSourceEntityId ? _self.triggerSourceEntityId : triggerSourceEntityId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AutomationRunStatus,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,executionDetails: null == executionDetails ? _self.executionDetails : executionDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,executedAtUtc: null == executedAtUtc ? _self.executedAtUtc : executedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,correlationId: null == correlationId ? _self.correlationId : correlationId // ignore: cast_nullable_to_non_nullable
as String,chainDepth: null == chainDepth ? _self.chainDepth : chainDepth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationRunResponse].
extension AutomationRunResponsePatterns on AutomationRunResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationRunResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationRunResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationRunResponse value)  $default,){
final _that = this;
switch (_that) {
case _AutomationRunResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationRunResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationRunResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ruleId,  String triggerEventId,  String triggerSourceEntity,  String triggerSourceEntityId,  AutomationRunStatus status,  int durationMs,  String? errorMessage,  Map<String, dynamic> executionDetails,  DateTime executedAtUtc,  String correlationId,  int chainDepth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationRunResponse() when $default != null:
return $default(_that.id,_that.ruleId,_that.triggerEventId,_that.triggerSourceEntity,_that.triggerSourceEntityId,_that.status,_that.durationMs,_that.errorMessage,_that.executionDetails,_that.executedAtUtc,_that.correlationId,_that.chainDepth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ruleId,  String triggerEventId,  String triggerSourceEntity,  String triggerSourceEntityId,  AutomationRunStatus status,  int durationMs,  String? errorMessage,  Map<String, dynamic> executionDetails,  DateTime executedAtUtc,  String correlationId,  int chainDepth)  $default,) {final _that = this;
switch (_that) {
case _AutomationRunResponse():
return $default(_that.id,_that.ruleId,_that.triggerEventId,_that.triggerSourceEntity,_that.triggerSourceEntityId,_that.status,_that.durationMs,_that.errorMessage,_that.executionDetails,_that.executedAtUtc,_that.correlationId,_that.chainDepth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ruleId,  String triggerEventId,  String triggerSourceEntity,  String triggerSourceEntityId,  AutomationRunStatus status,  int durationMs,  String? errorMessage,  Map<String, dynamic> executionDetails,  DateTime executedAtUtc,  String correlationId,  int chainDepth)?  $default,) {final _that = this;
switch (_that) {
case _AutomationRunResponse() when $default != null:
return $default(_that.id,_that.ruleId,_that.triggerEventId,_that.triggerSourceEntity,_that.triggerSourceEntityId,_that.status,_that.durationMs,_that.errorMessage,_that.executionDetails,_that.executedAtUtc,_that.correlationId,_that.chainDepth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationRunResponse implements AutomationRunResponse {
  const _AutomationRunResponse({required this.id, required this.ruleId, required this.triggerEventId, required this.triggerSourceEntity, required this.triggerSourceEntityId, required this.status, required this.durationMs, this.errorMessage, required this.executionDetails, required this.executedAtUtc, required this.correlationId, required this.chainDepth});
  factory _AutomationRunResponse.fromJson(Map<String, dynamic> json) => _$AutomationRunResponseFromJson(json);

@override final  String id;
@override final  String ruleId;
@override final  String triggerEventId;
@override final  String triggerSourceEntity;
@override final  String triggerSourceEntityId;
@override final  AutomationRunStatus status;
@override final  int durationMs;
@override final  String? errorMessage;
@override final  Map<String, dynamic> executionDetails;
@override final  DateTime executedAtUtc;
@override final  String correlationId;
@override final  int chainDepth;

/// Create a copy of AutomationRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationRunResponseCopyWith<_AutomationRunResponse> get copyWith => __$AutomationRunResponseCopyWithImpl<_AutomationRunResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationRunResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationRunResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.ruleId, ruleId) || other.ruleId == ruleId)&&(identical(other.triggerEventId, triggerEventId) || other.triggerEventId == triggerEventId)&&(identical(other.triggerSourceEntity, triggerSourceEntity) || other.triggerSourceEntity == triggerSourceEntity)&&(identical(other.triggerSourceEntityId, triggerSourceEntityId) || other.triggerSourceEntityId == triggerSourceEntityId)&&(identical(other.status, status) || other.status == status)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.executionDetails, executionDetails)&&(identical(other.executedAtUtc, executedAtUtc) || other.executedAtUtc == executedAtUtc)&&(identical(other.correlationId, correlationId) || other.correlationId == correlationId)&&(identical(other.chainDepth, chainDepth) || other.chainDepth == chainDepth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ruleId,triggerEventId,triggerSourceEntity,triggerSourceEntityId,status,durationMs,errorMessage,const DeepCollectionEquality().hash(executionDetails),executedAtUtc,correlationId,chainDepth);

@override
String toString() {
  return 'AutomationRunResponse(id: $id, ruleId: $ruleId, triggerEventId: $triggerEventId, triggerSourceEntity: $triggerSourceEntity, triggerSourceEntityId: $triggerSourceEntityId, status: $status, durationMs: $durationMs, errorMessage: $errorMessage, executionDetails: $executionDetails, executedAtUtc: $executedAtUtc, correlationId: $correlationId, chainDepth: $chainDepth)';
}


}

/// @nodoc
abstract mixin class _$AutomationRunResponseCopyWith<$Res> implements $AutomationRunResponseCopyWith<$Res> {
  factory _$AutomationRunResponseCopyWith(_AutomationRunResponse value, $Res Function(_AutomationRunResponse) _then) = __$AutomationRunResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String ruleId, String triggerEventId, String triggerSourceEntity, String triggerSourceEntityId, AutomationRunStatus status, int durationMs, String? errorMessage, Map<String, dynamic> executionDetails, DateTime executedAtUtc, String correlationId, int chainDepth
});




}
/// @nodoc
class __$AutomationRunResponseCopyWithImpl<$Res>
    implements _$AutomationRunResponseCopyWith<$Res> {
  __$AutomationRunResponseCopyWithImpl(this._self, this._then);

  final _AutomationRunResponse _self;
  final $Res Function(_AutomationRunResponse) _then;

/// Create a copy of AutomationRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ruleId = null,Object? triggerEventId = null,Object? triggerSourceEntity = null,Object? triggerSourceEntityId = null,Object? status = null,Object? durationMs = null,Object? errorMessage = freezed,Object? executionDetails = null,Object? executedAtUtc = null,Object? correlationId = null,Object? chainDepth = null,}) {
  return _then(_AutomationRunResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ruleId: null == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String,triggerEventId: null == triggerEventId ? _self.triggerEventId : triggerEventId // ignore: cast_nullable_to_non_nullable
as String,triggerSourceEntity: null == triggerSourceEntity ? _self.triggerSourceEntity : triggerSourceEntity // ignore: cast_nullable_to_non_nullable
as String,triggerSourceEntityId: null == triggerSourceEntityId ? _self.triggerSourceEntityId : triggerSourceEntityId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AutomationRunStatus,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,executionDetails: null == executionDetails ? _self.executionDetails : executionDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,executedAtUtc: null == executedAtUtc ? _self.executedAtUtc : executedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,correlationId: null == correlationId ? _self.correlationId : correlationId // ignore: cast_nullable_to_non_nullable
as String,chainDepth: null == chainDepth ? _self.chainDepth : chainDepth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AutomationDryRunPayload {

 String get taskId; Map<String, dynamic> get eventPayload;
/// Create a copy of AutomationDryRunPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationDryRunPayloadCopyWith<AutomationDryRunPayload> get copyWith => _$AutomationDryRunPayloadCopyWithImpl<AutomationDryRunPayload>(this as AutomationDryRunPayload, _$identity);

  /// Serializes this AutomationDryRunPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationDryRunPayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&const DeepCollectionEquality().equals(other.eventPayload, eventPayload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,const DeepCollectionEquality().hash(eventPayload));

@override
String toString() {
  return 'AutomationDryRunPayload(taskId: $taskId, eventPayload: $eventPayload)';
}


}

/// @nodoc
abstract mixin class $AutomationDryRunPayloadCopyWith<$Res>  {
  factory $AutomationDryRunPayloadCopyWith(AutomationDryRunPayload value, $Res Function(AutomationDryRunPayload) _then) = _$AutomationDryRunPayloadCopyWithImpl;
@useResult
$Res call({
 String taskId, Map<String, dynamic> eventPayload
});




}
/// @nodoc
class _$AutomationDryRunPayloadCopyWithImpl<$Res>
    implements $AutomationDryRunPayloadCopyWith<$Res> {
  _$AutomationDryRunPayloadCopyWithImpl(this._self, this._then);

  final AutomationDryRunPayload _self;
  final $Res Function(AutomationDryRunPayload) _then;

/// Create a copy of AutomationDryRunPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? eventPayload = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,eventPayload: null == eventPayload ? _self.eventPayload : eventPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationDryRunPayload].
extension AutomationDryRunPayloadPatterns on AutomationDryRunPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationDryRunPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationDryRunPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationDryRunPayload value)  $default,){
final _that = this;
switch (_that) {
case _AutomationDryRunPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationDryRunPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationDryRunPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  Map<String, dynamic> eventPayload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationDryRunPayload() when $default != null:
return $default(_that.taskId,_that.eventPayload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  Map<String, dynamic> eventPayload)  $default,) {final _that = this;
switch (_that) {
case _AutomationDryRunPayload():
return $default(_that.taskId,_that.eventPayload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  Map<String, dynamic> eventPayload)?  $default,) {final _that = this;
switch (_that) {
case _AutomationDryRunPayload() when $default != null:
return $default(_that.taskId,_that.eventPayload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationDryRunPayload implements AutomationDryRunPayload {
  const _AutomationDryRunPayload({required this.taskId, required this.eventPayload});
  factory _AutomationDryRunPayload.fromJson(Map<String, dynamic> json) => _$AutomationDryRunPayloadFromJson(json);

@override final  String taskId;
@override final  Map<String, dynamic> eventPayload;

/// Create a copy of AutomationDryRunPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationDryRunPayloadCopyWith<_AutomationDryRunPayload> get copyWith => __$AutomationDryRunPayloadCopyWithImpl<_AutomationDryRunPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationDryRunPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationDryRunPayload&&(identical(other.taskId, taskId) || other.taskId == taskId)&&const DeepCollectionEquality().equals(other.eventPayload, eventPayload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,const DeepCollectionEquality().hash(eventPayload));

@override
String toString() {
  return 'AutomationDryRunPayload(taskId: $taskId, eventPayload: $eventPayload)';
}


}

/// @nodoc
abstract mixin class _$AutomationDryRunPayloadCopyWith<$Res> implements $AutomationDryRunPayloadCopyWith<$Res> {
  factory _$AutomationDryRunPayloadCopyWith(_AutomationDryRunPayload value, $Res Function(_AutomationDryRunPayload) _then) = __$AutomationDryRunPayloadCopyWithImpl;
@override @useResult
$Res call({
 String taskId, Map<String, dynamic> eventPayload
});




}
/// @nodoc
class __$AutomationDryRunPayloadCopyWithImpl<$Res>
    implements _$AutomationDryRunPayloadCopyWith<$Res> {
  __$AutomationDryRunPayloadCopyWithImpl(this._self, this._then);

  final _AutomationDryRunPayload _self;
  final $Res Function(_AutomationDryRunPayload) _then;

/// Create a copy of AutomationDryRunPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? eventPayload = null,}) {
  return _then(_AutomationDryRunPayload(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,eventPayload: null == eventPayload ? _self.eventPayload : eventPayload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$AutomationActionPreview {

 AutomationActionType get type; bool get supported; String get description;
/// Create a copy of AutomationActionPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationActionPreviewCopyWith<AutomationActionPreview> get copyWith => _$AutomationActionPreviewCopyWithImpl<AutomationActionPreview>(this as AutomationActionPreview, _$identity);

  /// Serializes this AutomationActionPreview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationActionPreview&&(identical(other.type, type) || other.type == type)&&(identical(other.supported, supported) || other.supported == supported)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,supported,description);

@override
String toString() {
  return 'AutomationActionPreview(type: $type, supported: $supported, description: $description)';
}


}

/// @nodoc
abstract mixin class $AutomationActionPreviewCopyWith<$Res>  {
  factory $AutomationActionPreviewCopyWith(AutomationActionPreview value, $Res Function(AutomationActionPreview) _then) = _$AutomationActionPreviewCopyWithImpl;
@useResult
$Res call({
 AutomationActionType type, bool supported, String description
});




}
/// @nodoc
class _$AutomationActionPreviewCopyWithImpl<$Res>
    implements $AutomationActionPreviewCopyWith<$Res> {
  _$AutomationActionPreviewCopyWithImpl(this._self, this._then);

  final AutomationActionPreview _self;
  final $Res Function(AutomationActionPreview) _then;

/// Create a copy of AutomationActionPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? supported = null,Object? description = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationActionType,supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationActionPreview].
extension AutomationActionPreviewPatterns on AutomationActionPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationActionPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationActionPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationActionPreview value)  $default,){
final _that = this;
switch (_that) {
case _AutomationActionPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationActionPreview value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationActionPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AutomationActionType type,  bool supported,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationActionPreview() when $default != null:
return $default(_that.type,_that.supported,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AutomationActionType type,  bool supported,  String description)  $default,) {final _that = this;
switch (_that) {
case _AutomationActionPreview():
return $default(_that.type,_that.supported,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AutomationActionType type,  bool supported,  String description)?  $default,) {final _that = this;
switch (_that) {
case _AutomationActionPreview() when $default != null:
return $default(_that.type,_that.supported,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationActionPreview implements AutomationActionPreview {
  const _AutomationActionPreview({required this.type, required this.supported, required this.description});
  factory _AutomationActionPreview.fromJson(Map<String, dynamic> json) => _$AutomationActionPreviewFromJson(json);

@override final  AutomationActionType type;
@override final  bool supported;
@override final  String description;

/// Create a copy of AutomationActionPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationActionPreviewCopyWith<_AutomationActionPreview> get copyWith => __$AutomationActionPreviewCopyWithImpl<_AutomationActionPreview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationActionPreviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationActionPreview&&(identical(other.type, type) || other.type == type)&&(identical(other.supported, supported) || other.supported == supported)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,supported,description);

@override
String toString() {
  return 'AutomationActionPreview(type: $type, supported: $supported, description: $description)';
}


}

/// @nodoc
abstract mixin class _$AutomationActionPreviewCopyWith<$Res> implements $AutomationActionPreviewCopyWith<$Res> {
  factory _$AutomationActionPreviewCopyWith(_AutomationActionPreview value, $Res Function(_AutomationActionPreview) _then) = __$AutomationActionPreviewCopyWithImpl;
@override @useResult
$Res call({
 AutomationActionType type, bool supported, String description
});




}
/// @nodoc
class __$AutomationActionPreviewCopyWithImpl<$Res>
    implements _$AutomationActionPreviewCopyWith<$Res> {
  __$AutomationActionPreviewCopyWithImpl(this._self, this._then);

  final _AutomationActionPreview _self;
  final $Res Function(_AutomationActionPreview) _then;

/// Create a copy of AutomationActionPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? supported = null,Object? description = null,}) {
  return _then(_AutomationActionPreview(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationActionType,supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AutomationDryRunResponse {

 String get ruleId; String get taskId; bool get conditionsMatched; List<AutomationActionPreview> get actions; String? get skipReason;
/// Create a copy of AutomationDryRunResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationDryRunResponseCopyWith<AutomationDryRunResponse> get copyWith => _$AutomationDryRunResponseCopyWithImpl<AutomationDryRunResponse>(this as AutomationDryRunResponse, _$identity);

  /// Serializes this AutomationDryRunResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationDryRunResponse&&(identical(other.ruleId, ruleId) || other.ruleId == ruleId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.conditionsMatched, conditionsMatched) || other.conditionsMatched == conditionsMatched)&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.skipReason, skipReason) || other.skipReason == skipReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ruleId,taskId,conditionsMatched,const DeepCollectionEquality().hash(actions),skipReason);

@override
String toString() {
  return 'AutomationDryRunResponse(ruleId: $ruleId, taskId: $taskId, conditionsMatched: $conditionsMatched, actions: $actions, skipReason: $skipReason)';
}


}

/// @nodoc
abstract mixin class $AutomationDryRunResponseCopyWith<$Res>  {
  factory $AutomationDryRunResponseCopyWith(AutomationDryRunResponse value, $Res Function(AutomationDryRunResponse) _then) = _$AutomationDryRunResponseCopyWithImpl;
@useResult
$Res call({
 String ruleId, String taskId, bool conditionsMatched, List<AutomationActionPreview> actions, String? skipReason
});




}
/// @nodoc
class _$AutomationDryRunResponseCopyWithImpl<$Res>
    implements $AutomationDryRunResponseCopyWith<$Res> {
  _$AutomationDryRunResponseCopyWithImpl(this._self, this._then);

  final AutomationDryRunResponse _self;
  final $Res Function(AutomationDryRunResponse) _then;

/// Create a copy of AutomationDryRunResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ruleId = null,Object? taskId = null,Object? conditionsMatched = null,Object? actions = null,Object? skipReason = freezed,}) {
  return _then(_self.copyWith(
ruleId: null == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,conditionsMatched: null == conditionsMatched ? _self.conditionsMatched : conditionsMatched // ignore: cast_nullable_to_non_nullable
as bool,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationActionPreview>,skipReason: freezed == skipReason ? _self.skipReason : skipReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationDryRunResponse].
extension AutomationDryRunResponsePatterns on AutomationDryRunResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationDryRunResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationDryRunResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationDryRunResponse value)  $default,){
final _that = this;
switch (_that) {
case _AutomationDryRunResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationDryRunResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationDryRunResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ruleId,  String taskId,  bool conditionsMatched,  List<AutomationActionPreview> actions,  String? skipReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationDryRunResponse() when $default != null:
return $default(_that.ruleId,_that.taskId,_that.conditionsMatched,_that.actions,_that.skipReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ruleId,  String taskId,  bool conditionsMatched,  List<AutomationActionPreview> actions,  String? skipReason)  $default,) {final _that = this;
switch (_that) {
case _AutomationDryRunResponse():
return $default(_that.ruleId,_that.taskId,_that.conditionsMatched,_that.actions,_that.skipReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ruleId,  String taskId,  bool conditionsMatched,  List<AutomationActionPreview> actions,  String? skipReason)?  $default,) {final _that = this;
switch (_that) {
case _AutomationDryRunResponse() when $default != null:
return $default(_that.ruleId,_that.taskId,_that.conditionsMatched,_that.actions,_that.skipReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationDryRunResponse implements AutomationDryRunResponse {
  const _AutomationDryRunResponse({required this.ruleId, required this.taskId, required this.conditionsMatched, required this.actions, this.skipReason});
  factory _AutomationDryRunResponse.fromJson(Map<String, dynamic> json) => _$AutomationDryRunResponseFromJson(json);

@override final  String ruleId;
@override final  String taskId;
@override final  bool conditionsMatched;
@override final  List<AutomationActionPreview> actions;
@override final  String? skipReason;

/// Create a copy of AutomationDryRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationDryRunResponseCopyWith<_AutomationDryRunResponse> get copyWith => __$AutomationDryRunResponseCopyWithImpl<_AutomationDryRunResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationDryRunResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationDryRunResponse&&(identical(other.ruleId, ruleId) || other.ruleId == ruleId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.conditionsMatched, conditionsMatched) || other.conditionsMatched == conditionsMatched)&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.skipReason, skipReason) || other.skipReason == skipReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ruleId,taskId,conditionsMatched,const DeepCollectionEquality().hash(actions),skipReason);

@override
String toString() {
  return 'AutomationDryRunResponse(ruleId: $ruleId, taskId: $taskId, conditionsMatched: $conditionsMatched, actions: $actions, skipReason: $skipReason)';
}


}

/// @nodoc
abstract mixin class _$AutomationDryRunResponseCopyWith<$Res> implements $AutomationDryRunResponseCopyWith<$Res> {
  factory _$AutomationDryRunResponseCopyWith(_AutomationDryRunResponse value, $Res Function(_AutomationDryRunResponse) _then) = __$AutomationDryRunResponseCopyWithImpl;
@override @useResult
$Res call({
 String ruleId, String taskId, bool conditionsMatched, List<AutomationActionPreview> actions, String? skipReason
});




}
/// @nodoc
class __$AutomationDryRunResponseCopyWithImpl<$Res>
    implements _$AutomationDryRunResponseCopyWith<$Res> {
  __$AutomationDryRunResponseCopyWithImpl(this._self, this._then);

  final _AutomationDryRunResponse _self;
  final $Res Function(_AutomationDryRunResponse) _then;

/// Create a copy of AutomationDryRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ruleId = null,Object? taskId = null,Object? conditionsMatched = null,Object? actions = null,Object? skipReason = freezed,}) {
  return _then(_AutomationDryRunResponse(
ruleId: null == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,conditionsMatched: null == conditionsMatched ? _self.conditionsMatched : conditionsMatched // ignore: cast_nullable_to_non_nullable
as bool,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationActionPreview>,skipReason: freezed == skipReason ? _self.skipReason : skipReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AutomationRecipe {

 String get key; String get name; String get description; AutomationTriggerType get triggerType; Map<String, dynamic> get triggerConfig; List<AutomationCondition> get conditions; List<AutomationAction> get actions;
/// Create a copy of AutomationRecipe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationRecipeCopyWith<AutomationRecipe> get copyWith => _$AutomationRecipeCopyWithImpl<AutomationRecipe>(this as AutomationRecipe, _$identity);

  /// Serializes this AutomationRecipe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationRecipe&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.triggerType, triggerType) || other.triggerType == triggerType)&&const DeepCollectionEquality().equals(other.triggerConfig, triggerConfig)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&const DeepCollectionEquality().equals(other.actions, actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,description,triggerType,const DeepCollectionEquality().hash(triggerConfig),const DeepCollectionEquality().hash(conditions),const DeepCollectionEquality().hash(actions));

@override
String toString() {
  return 'AutomationRecipe(key: $key, name: $name, description: $description, triggerType: $triggerType, triggerConfig: $triggerConfig, conditions: $conditions, actions: $actions)';
}


}

/// @nodoc
abstract mixin class $AutomationRecipeCopyWith<$Res>  {
  factory $AutomationRecipeCopyWith(AutomationRecipe value, $Res Function(AutomationRecipe) _then) = _$AutomationRecipeCopyWithImpl;
@useResult
$Res call({
 String key, String name, String description, AutomationTriggerType triggerType, Map<String, dynamic> triggerConfig, List<AutomationCondition> conditions, List<AutomationAction> actions
});




}
/// @nodoc
class _$AutomationRecipeCopyWithImpl<$Res>
    implements $AutomationRecipeCopyWith<$Res> {
  _$AutomationRecipeCopyWithImpl(this._self, this._then);

  final AutomationRecipe _self;
  final $Res Function(AutomationRecipe) _then;

/// Create a copy of AutomationRecipe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? description = null,Object? triggerType = null,Object? triggerConfig = null,Object? conditions = null,Object? actions = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,triggerType: null == triggerType ? _self.triggerType : triggerType // ignore: cast_nullable_to_non_nullable
as AutomationTriggerType,triggerConfig: null == triggerConfig ? _self.triggerConfig : triggerConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<AutomationCondition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationRecipe].
extension AutomationRecipePatterns on AutomationRecipe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationRecipe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationRecipe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationRecipe value)  $default,){
final _that = this;
switch (_that) {
case _AutomationRecipe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationRecipe value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationRecipe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  String description,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationRecipe() when $default != null:
return $default(_that.key,_that.name,_that.description,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  String description,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions)  $default,) {final _that = this;
switch (_that) {
case _AutomationRecipe():
return $default(_that.key,_that.name,_that.description,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  String description,  AutomationTriggerType triggerType,  Map<String, dynamic> triggerConfig,  List<AutomationCondition> conditions,  List<AutomationAction> actions)?  $default,) {final _that = this;
switch (_that) {
case _AutomationRecipe() when $default != null:
return $default(_that.key,_that.name,_that.description,_that.triggerType,_that.triggerConfig,_that.conditions,_that.actions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationRecipe implements AutomationRecipe {
  const _AutomationRecipe({required this.key, required this.name, required this.description, required this.triggerType, required this.triggerConfig, required this.conditions, required this.actions});
  factory _AutomationRecipe.fromJson(Map<String, dynamic> json) => _$AutomationRecipeFromJson(json);

@override final  String key;
@override final  String name;
@override final  String description;
@override final  AutomationTriggerType triggerType;
@override final  Map<String, dynamic> triggerConfig;
@override final  List<AutomationCondition> conditions;
@override final  List<AutomationAction> actions;

/// Create a copy of AutomationRecipe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationRecipeCopyWith<_AutomationRecipe> get copyWith => __$AutomationRecipeCopyWithImpl<_AutomationRecipe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationRecipeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationRecipe&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.triggerType, triggerType) || other.triggerType == triggerType)&&const DeepCollectionEquality().equals(other.triggerConfig, triggerConfig)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&const DeepCollectionEquality().equals(other.actions, actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,description,triggerType,const DeepCollectionEquality().hash(triggerConfig),const DeepCollectionEquality().hash(conditions),const DeepCollectionEquality().hash(actions));

@override
String toString() {
  return 'AutomationRecipe(key: $key, name: $name, description: $description, triggerType: $triggerType, triggerConfig: $triggerConfig, conditions: $conditions, actions: $actions)';
}


}

/// @nodoc
abstract mixin class _$AutomationRecipeCopyWith<$Res> implements $AutomationRecipeCopyWith<$Res> {
  factory _$AutomationRecipeCopyWith(_AutomationRecipe value, $Res Function(_AutomationRecipe) _then) = __$AutomationRecipeCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, String description, AutomationTriggerType triggerType, Map<String, dynamic> triggerConfig, List<AutomationCondition> conditions, List<AutomationAction> actions
});




}
/// @nodoc
class __$AutomationRecipeCopyWithImpl<$Res>
    implements _$AutomationRecipeCopyWith<$Res> {
  __$AutomationRecipeCopyWithImpl(this._self, this._then);

  final _AutomationRecipe _self;
  final $Res Function(_AutomationRecipe) _then;

/// Create a copy of AutomationRecipe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? description = null,Object? triggerType = null,Object? triggerConfig = null,Object? conditions = null,Object? actions = null,}) {
  return _then(_AutomationRecipe(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,triggerType: null == triggerType ? _self.triggerType : triggerType // ignore: cast_nullable_to_non_nullable
as AutomationTriggerType,triggerConfig: null == triggerConfig ? _self.triggerConfig : triggerConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<AutomationCondition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,
  ));
}


}


/// @nodoc
mixin _$ApplyAutomationRecipePayload {

 String? get name; int? get expectedVersion;
/// Create a copy of ApplyAutomationRecipePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyAutomationRecipePayloadCopyWith<ApplyAutomationRecipePayload> get copyWith => _$ApplyAutomationRecipePayloadCopyWithImpl<ApplyAutomationRecipePayload>(this as ApplyAutomationRecipePayload, _$identity);

  /// Serializes this ApplyAutomationRecipePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyAutomationRecipePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,expectedVersion);

@override
String toString() {
  return 'ApplyAutomationRecipePayload(name: $name, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class $ApplyAutomationRecipePayloadCopyWith<$Res>  {
  factory $ApplyAutomationRecipePayloadCopyWith(ApplyAutomationRecipePayload value, $Res Function(ApplyAutomationRecipePayload) _then) = _$ApplyAutomationRecipePayloadCopyWithImpl;
@useResult
$Res call({
 String? name, int? expectedVersion
});




}
/// @nodoc
class _$ApplyAutomationRecipePayloadCopyWithImpl<$Res>
    implements $ApplyAutomationRecipePayloadCopyWith<$Res> {
  _$ApplyAutomationRecipePayloadCopyWithImpl(this._self, this._then);

  final ApplyAutomationRecipePayload _self;
  final $Res Function(ApplyAutomationRecipePayload) _then;

/// Create a copy of ApplyAutomationRecipePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? expectedVersion = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: freezed == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplyAutomationRecipePayload].
extension ApplyAutomationRecipePayloadPatterns on ApplyAutomationRecipePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplyAutomationRecipePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplyAutomationRecipePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplyAutomationRecipePayload value)  $default,){
final _that = this;
switch (_that) {
case _ApplyAutomationRecipePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplyAutomationRecipePayload value)?  $default,){
final _that = this;
switch (_that) {
case _ApplyAutomationRecipePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  int? expectedVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplyAutomationRecipePayload() when $default != null:
return $default(_that.name,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  int? expectedVersion)  $default,) {final _that = this;
switch (_that) {
case _ApplyAutomationRecipePayload():
return $default(_that.name,_that.expectedVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  int? expectedVersion)?  $default,) {final _that = this;
switch (_that) {
case _ApplyAutomationRecipePayload() when $default != null:
return $default(_that.name,_that.expectedVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplyAutomationRecipePayload implements ApplyAutomationRecipePayload {
  const _ApplyAutomationRecipePayload({this.name, this.expectedVersion});
  factory _ApplyAutomationRecipePayload.fromJson(Map<String, dynamic> json) => _$ApplyAutomationRecipePayloadFromJson(json);

@override final  String? name;
@override final  int? expectedVersion;

/// Create a copy of ApplyAutomationRecipePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplyAutomationRecipePayloadCopyWith<_ApplyAutomationRecipePayload> get copyWith => __$ApplyAutomationRecipePayloadCopyWithImpl<_ApplyAutomationRecipePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplyAutomationRecipePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplyAutomationRecipePayload&&(identical(other.name, name) || other.name == name)&&(identical(other.expectedVersion, expectedVersion) || other.expectedVersion == expectedVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,expectedVersion);

@override
String toString() {
  return 'ApplyAutomationRecipePayload(name: $name, expectedVersion: $expectedVersion)';
}


}

/// @nodoc
abstract mixin class _$ApplyAutomationRecipePayloadCopyWith<$Res> implements $ApplyAutomationRecipePayloadCopyWith<$Res> {
  factory _$ApplyAutomationRecipePayloadCopyWith(_ApplyAutomationRecipePayload value, $Res Function(_ApplyAutomationRecipePayload) _then) = __$ApplyAutomationRecipePayloadCopyWithImpl;
@override @useResult
$Res call({
 String? name, int? expectedVersion
});




}
/// @nodoc
class __$ApplyAutomationRecipePayloadCopyWithImpl<$Res>
    implements _$ApplyAutomationRecipePayloadCopyWith<$Res> {
  __$ApplyAutomationRecipePayloadCopyWithImpl(this._self, this._then);

  final _ApplyAutomationRecipePayload _self;
  final $Res Function(_ApplyAutomationRecipePayload) _then;

/// Create a copy of ApplyAutomationRecipePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? expectedVersion = freezed,}) {
  return _then(_ApplyAutomationRecipePayload(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,expectedVersion: freezed == expectedVersion ? _self.expectedVersion : expectedVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AutomationTriggerDefinition {

 AutomationTriggerType get type; bool get supported; String get description;
/// Create a copy of AutomationTriggerDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationTriggerDefinitionCopyWith<AutomationTriggerDefinition> get copyWith => _$AutomationTriggerDefinitionCopyWithImpl<AutomationTriggerDefinition>(this as AutomationTriggerDefinition, _$identity);

  /// Serializes this AutomationTriggerDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationTriggerDefinition&&(identical(other.type, type) || other.type == type)&&(identical(other.supported, supported) || other.supported == supported)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,supported,description);

@override
String toString() {
  return 'AutomationTriggerDefinition(type: $type, supported: $supported, description: $description)';
}


}

/// @nodoc
abstract mixin class $AutomationTriggerDefinitionCopyWith<$Res>  {
  factory $AutomationTriggerDefinitionCopyWith(AutomationTriggerDefinition value, $Res Function(AutomationTriggerDefinition) _then) = _$AutomationTriggerDefinitionCopyWithImpl;
@useResult
$Res call({
 AutomationTriggerType type, bool supported, String description
});




}
/// @nodoc
class _$AutomationTriggerDefinitionCopyWithImpl<$Res>
    implements $AutomationTriggerDefinitionCopyWith<$Res> {
  _$AutomationTriggerDefinitionCopyWithImpl(this._self, this._then);

  final AutomationTriggerDefinition _self;
  final $Res Function(AutomationTriggerDefinition) _then;

/// Create a copy of AutomationTriggerDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? supported = null,Object? description = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationTriggerType,supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationTriggerDefinition].
extension AutomationTriggerDefinitionPatterns on AutomationTriggerDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationTriggerDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationTriggerDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationTriggerDefinition value)  $default,){
final _that = this;
switch (_that) {
case _AutomationTriggerDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationTriggerDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationTriggerDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AutomationTriggerType type,  bool supported,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationTriggerDefinition() when $default != null:
return $default(_that.type,_that.supported,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AutomationTriggerType type,  bool supported,  String description)  $default,) {final _that = this;
switch (_that) {
case _AutomationTriggerDefinition():
return $default(_that.type,_that.supported,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AutomationTriggerType type,  bool supported,  String description)?  $default,) {final _that = this;
switch (_that) {
case _AutomationTriggerDefinition() when $default != null:
return $default(_that.type,_that.supported,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationTriggerDefinition implements AutomationTriggerDefinition {
  const _AutomationTriggerDefinition({required this.type, required this.supported, required this.description});
  factory _AutomationTriggerDefinition.fromJson(Map<String, dynamic> json) => _$AutomationTriggerDefinitionFromJson(json);

@override final  AutomationTriggerType type;
@override final  bool supported;
@override final  String description;

/// Create a copy of AutomationTriggerDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationTriggerDefinitionCopyWith<_AutomationTriggerDefinition> get copyWith => __$AutomationTriggerDefinitionCopyWithImpl<_AutomationTriggerDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationTriggerDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationTriggerDefinition&&(identical(other.type, type) || other.type == type)&&(identical(other.supported, supported) || other.supported == supported)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,supported,description);

@override
String toString() {
  return 'AutomationTriggerDefinition(type: $type, supported: $supported, description: $description)';
}


}

/// @nodoc
abstract mixin class _$AutomationTriggerDefinitionCopyWith<$Res> implements $AutomationTriggerDefinitionCopyWith<$Res> {
  factory _$AutomationTriggerDefinitionCopyWith(_AutomationTriggerDefinition value, $Res Function(_AutomationTriggerDefinition) _then) = __$AutomationTriggerDefinitionCopyWithImpl;
@override @useResult
$Res call({
 AutomationTriggerType type, bool supported, String description
});




}
/// @nodoc
class __$AutomationTriggerDefinitionCopyWithImpl<$Res>
    implements _$AutomationTriggerDefinitionCopyWith<$Res> {
  __$AutomationTriggerDefinitionCopyWithImpl(this._self, this._then);

  final _AutomationTriggerDefinition _self;
  final $Res Function(_AutomationTriggerDefinition) _then;

/// Create a copy of AutomationTriggerDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? supported = null,Object? description = null,}) {
  return _then(_AutomationTriggerDefinition(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationTriggerType,supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AutomationConditionDefinition {

 AutomationConditionType get type; String get description;
/// Create a copy of AutomationConditionDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationConditionDefinitionCopyWith<AutomationConditionDefinition> get copyWith => _$AutomationConditionDefinitionCopyWithImpl<AutomationConditionDefinition>(this as AutomationConditionDefinition, _$identity);

  /// Serializes this AutomationConditionDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationConditionDefinition&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,description);

@override
String toString() {
  return 'AutomationConditionDefinition(type: $type, description: $description)';
}


}

/// @nodoc
abstract mixin class $AutomationConditionDefinitionCopyWith<$Res>  {
  factory $AutomationConditionDefinitionCopyWith(AutomationConditionDefinition value, $Res Function(AutomationConditionDefinition) _then) = _$AutomationConditionDefinitionCopyWithImpl;
@useResult
$Res call({
 AutomationConditionType type, String description
});




}
/// @nodoc
class _$AutomationConditionDefinitionCopyWithImpl<$Res>
    implements $AutomationConditionDefinitionCopyWith<$Res> {
  _$AutomationConditionDefinitionCopyWithImpl(this._self, this._then);

  final AutomationConditionDefinition _self;
  final $Res Function(AutomationConditionDefinition) _then;

/// Create a copy of AutomationConditionDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? description = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationConditionType,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationConditionDefinition].
extension AutomationConditionDefinitionPatterns on AutomationConditionDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationConditionDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationConditionDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationConditionDefinition value)  $default,){
final _that = this;
switch (_that) {
case _AutomationConditionDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationConditionDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationConditionDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AutomationConditionType type,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationConditionDefinition() when $default != null:
return $default(_that.type,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AutomationConditionType type,  String description)  $default,) {final _that = this;
switch (_that) {
case _AutomationConditionDefinition():
return $default(_that.type,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AutomationConditionType type,  String description)?  $default,) {final _that = this;
switch (_that) {
case _AutomationConditionDefinition() when $default != null:
return $default(_that.type,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationConditionDefinition implements AutomationConditionDefinition {
  const _AutomationConditionDefinition({required this.type, required this.description});
  factory _AutomationConditionDefinition.fromJson(Map<String, dynamic> json) => _$AutomationConditionDefinitionFromJson(json);

@override final  AutomationConditionType type;
@override final  String description;

/// Create a copy of AutomationConditionDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationConditionDefinitionCopyWith<_AutomationConditionDefinition> get copyWith => __$AutomationConditionDefinitionCopyWithImpl<_AutomationConditionDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationConditionDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationConditionDefinition&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,description);

@override
String toString() {
  return 'AutomationConditionDefinition(type: $type, description: $description)';
}


}

/// @nodoc
abstract mixin class _$AutomationConditionDefinitionCopyWith<$Res> implements $AutomationConditionDefinitionCopyWith<$Res> {
  factory _$AutomationConditionDefinitionCopyWith(_AutomationConditionDefinition value, $Res Function(_AutomationConditionDefinition) _then) = __$AutomationConditionDefinitionCopyWithImpl;
@override @useResult
$Res call({
 AutomationConditionType type, String description
});




}
/// @nodoc
class __$AutomationConditionDefinitionCopyWithImpl<$Res>
    implements _$AutomationConditionDefinitionCopyWith<$Res> {
  __$AutomationConditionDefinitionCopyWithImpl(this._self, this._then);

  final _AutomationConditionDefinition _self;
  final $Res Function(_AutomationConditionDefinition) _then;

/// Create a copy of AutomationConditionDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? description = null,}) {
  return _then(_AutomationConditionDefinition(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationConditionType,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AutomationActionDefinition {

 AutomationActionType get type; bool get supported; String get description;
/// Create a copy of AutomationActionDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationActionDefinitionCopyWith<AutomationActionDefinition> get copyWith => _$AutomationActionDefinitionCopyWithImpl<AutomationActionDefinition>(this as AutomationActionDefinition, _$identity);

  /// Serializes this AutomationActionDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationActionDefinition&&(identical(other.type, type) || other.type == type)&&(identical(other.supported, supported) || other.supported == supported)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,supported,description);

@override
String toString() {
  return 'AutomationActionDefinition(type: $type, supported: $supported, description: $description)';
}


}

/// @nodoc
abstract mixin class $AutomationActionDefinitionCopyWith<$Res>  {
  factory $AutomationActionDefinitionCopyWith(AutomationActionDefinition value, $Res Function(AutomationActionDefinition) _then) = _$AutomationActionDefinitionCopyWithImpl;
@useResult
$Res call({
 AutomationActionType type, bool supported, String description
});




}
/// @nodoc
class _$AutomationActionDefinitionCopyWithImpl<$Res>
    implements $AutomationActionDefinitionCopyWith<$Res> {
  _$AutomationActionDefinitionCopyWithImpl(this._self, this._then);

  final AutomationActionDefinition _self;
  final $Res Function(AutomationActionDefinition) _then;

/// Create a copy of AutomationActionDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? supported = null,Object? description = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationActionType,supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationActionDefinition].
extension AutomationActionDefinitionPatterns on AutomationActionDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationActionDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationActionDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationActionDefinition value)  $default,){
final _that = this;
switch (_that) {
case _AutomationActionDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationActionDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationActionDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AutomationActionType type,  bool supported,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationActionDefinition() when $default != null:
return $default(_that.type,_that.supported,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AutomationActionType type,  bool supported,  String description)  $default,) {final _that = this;
switch (_that) {
case _AutomationActionDefinition():
return $default(_that.type,_that.supported,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AutomationActionType type,  bool supported,  String description)?  $default,) {final _that = this;
switch (_that) {
case _AutomationActionDefinition() when $default != null:
return $default(_that.type,_that.supported,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationActionDefinition implements AutomationActionDefinition {
  const _AutomationActionDefinition({required this.type, required this.supported, required this.description});
  factory _AutomationActionDefinition.fromJson(Map<String, dynamic> json) => _$AutomationActionDefinitionFromJson(json);

@override final  AutomationActionType type;
@override final  bool supported;
@override final  String description;

/// Create a copy of AutomationActionDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationActionDefinitionCopyWith<_AutomationActionDefinition> get copyWith => __$AutomationActionDefinitionCopyWithImpl<_AutomationActionDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationActionDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationActionDefinition&&(identical(other.type, type) || other.type == type)&&(identical(other.supported, supported) || other.supported == supported)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,supported,description);

@override
String toString() {
  return 'AutomationActionDefinition(type: $type, supported: $supported, description: $description)';
}


}

/// @nodoc
abstract mixin class _$AutomationActionDefinitionCopyWith<$Res> implements $AutomationActionDefinitionCopyWith<$Res> {
  factory _$AutomationActionDefinitionCopyWith(_AutomationActionDefinition value, $Res Function(_AutomationActionDefinition) _then) = __$AutomationActionDefinitionCopyWithImpl;
@override @useResult
$Res call({
 AutomationActionType type, bool supported, String description
});




}
/// @nodoc
class __$AutomationActionDefinitionCopyWithImpl<$Res>
    implements _$AutomationActionDefinitionCopyWith<$Res> {
  __$AutomationActionDefinitionCopyWithImpl(this._self, this._then);

  final _AutomationActionDefinition _self;
  final $Res Function(_AutomationActionDefinition) _then;

/// Create a copy of AutomationActionDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? supported = null,Object? description = null,}) {
  return _then(_AutomationActionDefinition(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AutomationActionType,supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AutomationCatalogResponse {

 List<AutomationTriggerDefinition> get triggers; List<AutomationConditionDefinition> get conditions; List<AutomationActionDefinition> get actions;
/// Create a copy of AutomationCatalogResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationCatalogResponseCopyWith<AutomationCatalogResponse> get copyWith => _$AutomationCatalogResponseCopyWithImpl<AutomationCatalogResponse>(this as AutomationCatalogResponse, _$identity);

  /// Serializes this AutomationCatalogResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationCatalogResponse&&const DeepCollectionEquality().equals(other.triggers, triggers)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&const DeepCollectionEquality().equals(other.actions, actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(triggers),const DeepCollectionEquality().hash(conditions),const DeepCollectionEquality().hash(actions));

@override
String toString() {
  return 'AutomationCatalogResponse(triggers: $triggers, conditions: $conditions, actions: $actions)';
}


}

/// @nodoc
abstract mixin class $AutomationCatalogResponseCopyWith<$Res>  {
  factory $AutomationCatalogResponseCopyWith(AutomationCatalogResponse value, $Res Function(AutomationCatalogResponse) _then) = _$AutomationCatalogResponseCopyWithImpl;
@useResult
$Res call({
 List<AutomationTriggerDefinition> triggers, List<AutomationConditionDefinition> conditions, List<AutomationActionDefinition> actions
});




}
/// @nodoc
class _$AutomationCatalogResponseCopyWithImpl<$Res>
    implements $AutomationCatalogResponseCopyWith<$Res> {
  _$AutomationCatalogResponseCopyWithImpl(this._self, this._then);

  final AutomationCatalogResponse _self;
  final $Res Function(AutomationCatalogResponse) _then;

/// Create a copy of AutomationCatalogResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? triggers = null,Object? conditions = null,Object? actions = null,}) {
  return _then(_self.copyWith(
triggers: null == triggers ? _self.triggers : triggers // ignore: cast_nullable_to_non_nullable
as List<AutomationTriggerDefinition>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<AutomationConditionDefinition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationActionDefinition>,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationCatalogResponse].
extension AutomationCatalogResponsePatterns on AutomationCatalogResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationCatalogResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationCatalogResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationCatalogResponse value)  $default,){
final _that = this;
switch (_that) {
case _AutomationCatalogResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationCatalogResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationCatalogResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AutomationTriggerDefinition> triggers,  List<AutomationConditionDefinition> conditions,  List<AutomationActionDefinition> actions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationCatalogResponse() when $default != null:
return $default(_that.triggers,_that.conditions,_that.actions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AutomationTriggerDefinition> triggers,  List<AutomationConditionDefinition> conditions,  List<AutomationActionDefinition> actions)  $default,) {final _that = this;
switch (_that) {
case _AutomationCatalogResponse():
return $default(_that.triggers,_that.conditions,_that.actions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AutomationTriggerDefinition> triggers,  List<AutomationConditionDefinition> conditions,  List<AutomationActionDefinition> actions)?  $default,) {final _that = this;
switch (_that) {
case _AutomationCatalogResponse() when $default != null:
return $default(_that.triggers,_that.conditions,_that.actions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationCatalogResponse implements AutomationCatalogResponse {
  const _AutomationCatalogResponse({required this.triggers, required this.conditions, required this.actions});
  factory _AutomationCatalogResponse.fromJson(Map<String, dynamic> json) => _$AutomationCatalogResponseFromJson(json);

@override final  List<AutomationTriggerDefinition> triggers;
@override final  List<AutomationConditionDefinition> conditions;
@override final  List<AutomationActionDefinition> actions;

/// Create a copy of AutomationCatalogResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationCatalogResponseCopyWith<_AutomationCatalogResponse> get copyWith => __$AutomationCatalogResponseCopyWithImpl<_AutomationCatalogResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationCatalogResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationCatalogResponse&&const DeepCollectionEquality().equals(other.triggers, triggers)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&const DeepCollectionEquality().equals(other.actions, actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(triggers),const DeepCollectionEquality().hash(conditions),const DeepCollectionEquality().hash(actions));

@override
String toString() {
  return 'AutomationCatalogResponse(triggers: $triggers, conditions: $conditions, actions: $actions)';
}


}

/// @nodoc
abstract mixin class _$AutomationCatalogResponseCopyWith<$Res> implements $AutomationCatalogResponseCopyWith<$Res> {
  factory _$AutomationCatalogResponseCopyWith(_AutomationCatalogResponse value, $Res Function(_AutomationCatalogResponse) _then) = __$AutomationCatalogResponseCopyWithImpl;
@override @useResult
$Res call({
 List<AutomationTriggerDefinition> triggers, List<AutomationConditionDefinition> conditions, List<AutomationActionDefinition> actions
});




}
/// @nodoc
class __$AutomationCatalogResponseCopyWithImpl<$Res>
    implements _$AutomationCatalogResponseCopyWith<$Res> {
  __$AutomationCatalogResponseCopyWithImpl(this._self, this._then);

  final _AutomationCatalogResponse _self;
  final $Res Function(_AutomationCatalogResponse) _then;

/// Create a copy of AutomationCatalogResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? triggers = null,Object? conditions = null,Object? actions = null,}) {
  return _then(_AutomationCatalogResponse(
triggers: null == triggers ? _self.triggers : triggers // ignore: cast_nullable_to_non_nullable
as List<AutomationTriggerDefinition>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<AutomationConditionDefinition>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationActionDefinition>,
  ));
}


}

// dart format on
