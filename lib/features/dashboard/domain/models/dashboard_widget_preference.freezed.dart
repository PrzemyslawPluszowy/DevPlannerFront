// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_widget_preference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardWidgetPreference {

/// Unikalny identyfikator instancji widgetu (np. UUID).
 String get id;/// Identyfikator typu widgetu (np. 'quick_actions').
 String get widgetTypeId;/// Kolumna siatki zajmowana przez lewy górny róg widgetu.
 int get gridColumn;/// Wiersz siatki zajmowany przez lewy górny róg widgetu.
 int get gridRow;/// Logiczna szerokość widgetu.
 int get width;/// Logiczna wysokość widgetu.
 int get height;/// Preferowana szerokość wybrana przez użytkownika (używana przy auto-restore).
 int? get preferredWidth;/// Preferowana wysokość wybrana przez użytkownika (używana przy auto-restore).
 int? get preferredHeight;/// Dokładna pozycja X na pulpicie (piksele), używana gdy wyłączona jest siatka.
 double? get exactDx;/// Dokładna pozycja Y na pulpicie (piksele), używana gdy wyłączona jest siatka.
 double? get exactDy;/// Dodatkowe opcje konfiguracyjne specyficzne dla danego widgetu.
 Map<String, dynamic>? get settings;
/// Create a copy of DashboardWidgetPreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardWidgetPreferenceCopyWith<DashboardWidgetPreference> get copyWith => _$DashboardWidgetPreferenceCopyWithImpl<DashboardWidgetPreference>(this as DashboardWidgetPreference, _$identity);

  /// Serializes this DashboardWidgetPreference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardWidgetPreference&&(identical(other.id, id) || other.id == id)&&(identical(other.widgetTypeId, widgetTypeId) || other.widgetTypeId == widgetTypeId)&&(identical(other.gridColumn, gridColumn) || other.gridColumn == gridColumn)&&(identical(other.gridRow, gridRow) || other.gridRow == gridRow)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.preferredWidth, preferredWidth) || other.preferredWidth == preferredWidth)&&(identical(other.preferredHeight, preferredHeight) || other.preferredHeight == preferredHeight)&&(identical(other.exactDx, exactDx) || other.exactDx == exactDx)&&(identical(other.exactDy, exactDy) || other.exactDy == exactDy)&&const DeepCollectionEquality().equals(other.settings, settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,widgetTypeId,gridColumn,gridRow,width,height,preferredWidth,preferredHeight,exactDx,exactDy,const DeepCollectionEquality().hash(settings));

@override
String toString() {
  return 'DashboardWidgetPreference(id: $id, widgetTypeId: $widgetTypeId, gridColumn: $gridColumn, gridRow: $gridRow, width: $width, height: $height, preferredWidth: $preferredWidth, preferredHeight: $preferredHeight, exactDx: $exactDx, exactDy: $exactDy, settings: $settings)';
}


}

/// @nodoc
abstract mixin class $DashboardWidgetPreferenceCopyWith<$Res>  {
  factory $DashboardWidgetPreferenceCopyWith(DashboardWidgetPreference value, $Res Function(DashboardWidgetPreference) _then) = _$DashboardWidgetPreferenceCopyWithImpl;
@useResult
$Res call({
 String id, String widgetTypeId, int gridColumn, int gridRow, int width, int height, int? preferredWidth, int? preferredHeight, double? exactDx, double? exactDy, Map<String, dynamic>? settings
});




}
/// @nodoc
class _$DashboardWidgetPreferenceCopyWithImpl<$Res>
    implements $DashboardWidgetPreferenceCopyWith<$Res> {
  _$DashboardWidgetPreferenceCopyWithImpl(this._self, this._then);

  final DashboardWidgetPreference _self;
  final $Res Function(DashboardWidgetPreference) _then;

/// Create a copy of DashboardWidgetPreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? widgetTypeId = null,Object? gridColumn = null,Object? gridRow = null,Object? width = null,Object? height = null,Object? preferredWidth = freezed,Object? preferredHeight = freezed,Object? exactDx = freezed,Object? exactDy = freezed,Object? settings = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,widgetTypeId: null == widgetTypeId ? _self.widgetTypeId : widgetTypeId // ignore: cast_nullable_to_non_nullable
as String,gridColumn: null == gridColumn ? _self.gridColumn : gridColumn // ignore: cast_nullable_to_non_nullable
as int,gridRow: null == gridRow ? _self.gridRow : gridRow // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,preferredWidth: freezed == preferredWidth ? _self.preferredWidth : preferredWidth // ignore: cast_nullable_to_non_nullable
as int?,preferredHeight: freezed == preferredHeight ? _self.preferredHeight : preferredHeight // ignore: cast_nullable_to_non_nullable
as int?,exactDx: freezed == exactDx ? _self.exactDx : exactDx // ignore: cast_nullable_to_non_nullable
as double?,exactDy: freezed == exactDy ? _self.exactDy : exactDy // ignore: cast_nullable_to_non_nullable
as double?,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardWidgetPreference].
extension DashboardWidgetPreferencePatterns on DashboardWidgetPreference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardWidgetPreference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardWidgetPreference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardWidgetPreference value)  $default,){
final _that = this;
switch (_that) {
case _DashboardWidgetPreference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardWidgetPreference value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardWidgetPreference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String widgetTypeId,  int gridColumn,  int gridRow,  int width,  int height,  int? preferredWidth,  int? preferredHeight,  double? exactDx,  double? exactDy,  Map<String, dynamic>? settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardWidgetPreference() when $default != null:
return $default(_that.id,_that.widgetTypeId,_that.gridColumn,_that.gridRow,_that.width,_that.height,_that.preferredWidth,_that.preferredHeight,_that.exactDx,_that.exactDy,_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String widgetTypeId,  int gridColumn,  int gridRow,  int width,  int height,  int? preferredWidth,  int? preferredHeight,  double? exactDx,  double? exactDy,  Map<String, dynamic>? settings)  $default,) {final _that = this;
switch (_that) {
case _DashboardWidgetPreference():
return $default(_that.id,_that.widgetTypeId,_that.gridColumn,_that.gridRow,_that.width,_that.height,_that.preferredWidth,_that.preferredHeight,_that.exactDx,_that.exactDy,_that.settings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String widgetTypeId,  int gridColumn,  int gridRow,  int width,  int height,  int? preferredWidth,  int? preferredHeight,  double? exactDx,  double? exactDy,  Map<String, dynamic>? settings)?  $default,) {final _that = this;
switch (_that) {
case _DashboardWidgetPreference() when $default != null:
return $default(_that.id,_that.widgetTypeId,_that.gridColumn,_that.gridRow,_that.width,_that.height,_that.preferredWidth,_that.preferredHeight,_that.exactDx,_that.exactDy,_that.settings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardWidgetPreference implements DashboardWidgetPreference {
  const _DashboardWidgetPreference({required this.id, required this.widgetTypeId, required this.gridColumn, required this.gridRow, required this.width, required this.height, this.preferredWidth, this.preferredHeight, this.exactDx, this.exactDy, this.settings});
  factory _DashboardWidgetPreference.fromJson(Map<String, dynamic> json) => _$DashboardWidgetPreferenceFromJson(json);

/// Unikalny identyfikator instancji widgetu (np. UUID).
@override final  String id;
/// Identyfikator typu widgetu (np. 'quick_actions').
@override final  String widgetTypeId;
/// Kolumna siatki zajmowana przez lewy górny róg widgetu.
@override final  int gridColumn;
/// Wiersz siatki zajmowany przez lewy górny róg widgetu.
@override final  int gridRow;
/// Logiczna szerokość widgetu.
@override final  int width;
/// Logiczna wysokość widgetu.
@override final  int height;
/// Preferowana szerokość wybrana przez użytkownika (używana przy auto-restore).
@override final  int? preferredWidth;
/// Preferowana wysokość wybrana przez użytkownika (używana przy auto-restore).
@override final  int? preferredHeight;
/// Dokładna pozycja X na pulpicie (piksele), używana gdy wyłączona jest siatka.
@override final  double? exactDx;
/// Dokładna pozycja Y na pulpicie (piksele), używana gdy wyłączona jest siatka.
@override final  double? exactDy;
/// Dodatkowe opcje konfiguracyjne specyficzne dla danego widgetu.
@override final  Map<String, dynamic>? settings;

/// Create a copy of DashboardWidgetPreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardWidgetPreferenceCopyWith<_DashboardWidgetPreference> get copyWith => __$DashboardWidgetPreferenceCopyWithImpl<_DashboardWidgetPreference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardWidgetPreferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardWidgetPreference&&(identical(other.id, id) || other.id == id)&&(identical(other.widgetTypeId, widgetTypeId) || other.widgetTypeId == widgetTypeId)&&(identical(other.gridColumn, gridColumn) || other.gridColumn == gridColumn)&&(identical(other.gridRow, gridRow) || other.gridRow == gridRow)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.preferredWidth, preferredWidth) || other.preferredWidth == preferredWidth)&&(identical(other.preferredHeight, preferredHeight) || other.preferredHeight == preferredHeight)&&(identical(other.exactDx, exactDx) || other.exactDx == exactDx)&&(identical(other.exactDy, exactDy) || other.exactDy == exactDy)&&const DeepCollectionEquality().equals(other.settings, settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,widgetTypeId,gridColumn,gridRow,width,height,preferredWidth,preferredHeight,exactDx,exactDy,const DeepCollectionEquality().hash(settings));

@override
String toString() {
  return 'DashboardWidgetPreference(id: $id, widgetTypeId: $widgetTypeId, gridColumn: $gridColumn, gridRow: $gridRow, width: $width, height: $height, preferredWidth: $preferredWidth, preferredHeight: $preferredHeight, exactDx: $exactDx, exactDy: $exactDy, settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$DashboardWidgetPreferenceCopyWith<$Res> implements $DashboardWidgetPreferenceCopyWith<$Res> {
  factory _$DashboardWidgetPreferenceCopyWith(_DashboardWidgetPreference value, $Res Function(_DashboardWidgetPreference) _then) = __$DashboardWidgetPreferenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String widgetTypeId, int gridColumn, int gridRow, int width, int height, int? preferredWidth, int? preferredHeight, double? exactDx, double? exactDy, Map<String, dynamic>? settings
});




}
/// @nodoc
class __$DashboardWidgetPreferenceCopyWithImpl<$Res>
    implements _$DashboardWidgetPreferenceCopyWith<$Res> {
  __$DashboardWidgetPreferenceCopyWithImpl(this._self, this._then);

  final _DashboardWidgetPreference _self;
  final $Res Function(_DashboardWidgetPreference) _then;

/// Create a copy of DashboardWidgetPreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? widgetTypeId = null,Object? gridColumn = null,Object? gridRow = null,Object? width = null,Object? height = null,Object? preferredWidth = freezed,Object? preferredHeight = freezed,Object? exactDx = freezed,Object? exactDy = freezed,Object? settings = freezed,}) {
  return _then(_DashboardWidgetPreference(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,widgetTypeId: null == widgetTypeId ? _self.widgetTypeId : widgetTypeId // ignore: cast_nullable_to_non_nullable
as String,gridColumn: null == gridColumn ? _self.gridColumn : gridColumn // ignore: cast_nullable_to_non_nullable
as int,gridRow: null == gridRow ? _self.gridRow : gridRow // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,preferredWidth: freezed == preferredWidth ? _self.preferredWidth : preferredWidth // ignore: cast_nullable_to_non_nullable
as int?,preferredHeight: freezed == preferredHeight ? _self.preferredHeight : preferredHeight // ignore: cast_nullable_to_non_nullable
as int?,exactDx: freezed == exactDx ? _self.exactDx : exactDx // ignore: cast_nullable_to_non_nullable
as double?,exactDy: freezed == exactDy ? _self.exactDy : exactDy // ignore: cast_nullable_to_non_nullable
as double?,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
