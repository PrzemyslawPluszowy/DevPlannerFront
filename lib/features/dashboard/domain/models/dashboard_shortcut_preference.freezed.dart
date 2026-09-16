// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_shortcut_preference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardShortcutPreference {

 String get shortcutId; String? get userLabel; bool get isVisible; int get position; int get gridColumn; int get gridRow; double? get exactDx; double? get exactDy;
/// Create a copy of DashboardShortcutPreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardShortcutPreferenceCopyWith<DashboardShortcutPreference> get copyWith => _$DashboardShortcutPreferenceCopyWithImpl<DashboardShortcutPreference>(this as DashboardShortcutPreference, _$identity);

  /// Serializes this DashboardShortcutPreference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardShortcutPreference&&(identical(other.shortcutId, shortcutId) || other.shortcutId == shortcutId)&&(identical(other.userLabel, userLabel) || other.userLabel == userLabel)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.position, position) || other.position == position)&&(identical(other.gridColumn, gridColumn) || other.gridColumn == gridColumn)&&(identical(other.gridRow, gridRow) || other.gridRow == gridRow)&&(identical(other.exactDx, exactDx) || other.exactDx == exactDx)&&(identical(other.exactDy, exactDy) || other.exactDy == exactDy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shortcutId,userLabel,isVisible,position,gridColumn,gridRow,exactDx,exactDy);

@override
String toString() {
  return 'DashboardShortcutPreference(shortcutId: $shortcutId, userLabel: $userLabel, isVisible: $isVisible, position: $position, gridColumn: $gridColumn, gridRow: $gridRow, exactDx: $exactDx, exactDy: $exactDy)';
}


}

/// @nodoc
abstract mixin class $DashboardShortcutPreferenceCopyWith<$Res>  {
  factory $DashboardShortcutPreferenceCopyWith(DashboardShortcutPreference value, $Res Function(DashboardShortcutPreference) _then) = _$DashboardShortcutPreferenceCopyWithImpl;
@useResult
$Res call({
 String shortcutId, String? userLabel, bool isVisible, int position, int gridColumn, int gridRow, double? exactDx, double? exactDy
});




}
/// @nodoc
class _$DashboardShortcutPreferenceCopyWithImpl<$Res>
    implements $DashboardShortcutPreferenceCopyWith<$Res> {
  _$DashboardShortcutPreferenceCopyWithImpl(this._self, this._then);

  final DashboardShortcutPreference _self;
  final $Res Function(DashboardShortcutPreference) _then;

/// Create a copy of DashboardShortcutPreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shortcutId = null,Object? userLabel = freezed,Object? isVisible = null,Object? position = null,Object? gridColumn = null,Object? gridRow = null,Object? exactDx = freezed,Object? exactDy = freezed,}) {
  return _then(_self.copyWith(
shortcutId: null == shortcutId ? _self.shortcutId : shortcutId // ignore: cast_nullable_to_non_nullable
as String,userLabel: freezed == userLabel ? _self.userLabel : userLabel // ignore: cast_nullable_to_non_nullable
as String?,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,gridColumn: null == gridColumn ? _self.gridColumn : gridColumn // ignore: cast_nullable_to_non_nullable
as int,gridRow: null == gridRow ? _self.gridRow : gridRow // ignore: cast_nullable_to_non_nullable
as int,exactDx: freezed == exactDx ? _self.exactDx : exactDx // ignore: cast_nullable_to_non_nullable
as double?,exactDy: freezed == exactDy ? _self.exactDy : exactDy // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardShortcutPreference].
extension DashboardShortcutPreferencePatterns on DashboardShortcutPreference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardShortcutPreference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardShortcutPreference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardShortcutPreference value)  $default,){
final _that = this;
switch (_that) {
case _DashboardShortcutPreference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardShortcutPreference value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardShortcutPreference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String shortcutId,  String? userLabel,  bool isVisible,  int position,  int gridColumn,  int gridRow,  double? exactDx,  double? exactDy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardShortcutPreference() when $default != null:
return $default(_that.shortcutId,_that.userLabel,_that.isVisible,_that.position,_that.gridColumn,_that.gridRow,_that.exactDx,_that.exactDy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String shortcutId,  String? userLabel,  bool isVisible,  int position,  int gridColumn,  int gridRow,  double? exactDx,  double? exactDy)  $default,) {final _that = this;
switch (_that) {
case _DashboardShortcutPreference():
return $default(_that.shortcutId,_that.userLabel,_that.isVisible,_that.position,_that.gridColumn,_that.gridRow,_that.exactDx,_that.exactDy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String shortcutId,  String? userLabel,  bool isVisible,  int position,  int gridColumn,  int gridRow,  double? exactDx,  double? exactDy)?  $default,) {final _that = this;
switch (_that) {
case _DashboardShortcutPreference() when $default != null:
return $default(_that.shortcutId,_that.userLabel,_that.isVisible,_that.position,_that.gridColumn,_that.gridRow,_that.exactDx,_that.exactDy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardShortcutPreference implements DashboardShortcutPreference {
  const _DashboardShortcutPreference({required this.shortcutId, this.userLabel, required this.isVisible, required this.position, required this.gridColumn, required this.gridRow, this.exactDx, this.exactDy});
  factory _DashboardShortcutPreference.fromJson(Map<String, dynamic> json) => _$DashboardShortcutPreferenceFromJson(json);

@override final  String shortcutId;
@override final  String? userLabel;
@override final  bool isVisible;
@override final  int position;
@override final  int gridColumn;
@override final  int gridRow;
@override final  double? exactDx;
@override final  double? exactDy;

/// Create a copy of DashboardShortcutPreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardShortcutPreferenceCopyWith<_DashboardShortcutPreference> get copyWith => __$DashboardShortcutPreferenceCopyWithImpl<_DashboardShortcutPreference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardShortcutPreferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardShortcutPreference&&(identical(other.shortcutId, shortcutId) || other.shortcutId == shortcutId)&&(identical(other.userLabel, userLabel) || other.userLabel == userLabel)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.position, position) || other.position == position)&&(identical(other.gridColumn, gridColumn) || other.gridColumn == gridColumn)&&(identical(other.gridRow, gridRow) || other.gridRow == gridRow)&&(identical(other.exactDx, exactDx) || other.exactDx == exactDx)&&(identical(other.exactDy, exactDy) || other.exactDy == exactDy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shortcutId,userLabel,isVisible,position,gridColumn,gridRow,exactDx,exactDy);

@override
String toString() {
  return 'DashboardShortcutPreference(shortcutId: $shortcutId, userLabel: $userLabel, isVisible: $isVisible, position: $position, gridColumn: $gridColumn, gridRow: $gridRow, exactDx: $exactDx, exactDy: $exactDy)';
}


}

/// @nodoc
abstract mixin class _$DashboardShortcutPreferenceCopyWith<$Res> implements $DashboardShortcutPreferenceCopyWith<$Res> {
  factory _$DashboardShortcutPreferenceCopyWith(_DashboardShortcutPreference value, $Res Function(_DashboardShortcutPreference) _then) = __$DashboardShortcutPreferenceCopyWithImpl;
@override @useResult
$Res call({
 String shortcutId, String? userLabel, bool isVisible, int position, int gridColumn, int gridRow, double? exactDx, double? exactDy
});




}
/// @nodoc
class __$DashboardShortcutPreferenceCopyWithImpl<$Res>
    implements _$DashboardShortcutPreferenceCopyWith<$Res> {
  __$DashboardShortcutPreferenceCopyWithImpl(this._self, this._then);

  final _DashboardShortcutPreference _self;
  final $Res Function(_DashboardShortcutPreference) _then;

/// Create a copy of DashboardShortcutPreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shortcutId = null,Object? userLabel = freezed,Object? isVisible = null,Object? position = null,Object? gridColumn = null,Object? gridRow = null,Object? exactDx = freezed,Object? exactDy = freezed,}) {
  return _then(_DashboardShortcutPreference(
shortcutId: null == shortcutId ? _self.shortcutId : shortcutId // ignore: cast_nullable_to_non_nullable
as String,userLabel: freezed == userLabel ? _self.userLabel : userLabel // ignore: cast_nullable_to_non_nullable
as String?,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,gridColumn: null == gridColumn ? _self.gridColumn : gridColumn // ignore: cast_nullable_to_non_nullable
as int,gridRow: null == gridRow ? _self.gridRow : gridRow // ignore: cast_nullable_to_non_nullable
as int,exactDx: freezed == exactDx ? _self.exactDx : exactDx // ignore: cast_nullable_to_non_nullable
as double?,exactDy: freezed == exactDy ? _self.exactDy : exactDy // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
