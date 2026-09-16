// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardPreferences {

 String get readyUserId; String get selectedWallpaperPath; List<String> get builtInWallpaperPaths; List<String> get customWallpaperPaths; List<DashboardWidgetPreference> get widgets; List<DashboardShortcutPreference> get shortcuts; DashboardStartupModule get startupModule; bool get snapToGrid; int get desktopGridVersion; DateTime get updatedAt;
/// Create a copy of DashboardPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPreferencesCopyWith<DashboardPreferences> get copyWith => _$DashboardPreferencesCopyWithImpl<DashboardPreferences>(this as DashboardPreferences, _$identity);

  /// Serializes this DashboardPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPreferences&&(identical(other.readyUserId, readyUserId) || other.readyUserId == readyUserId)&&(identical(other.selectedWallpaperPath, selectedWallpaperPath) || other.selectedWallpaperPath == selectedWallpaperPath)&&const DeepCollectionEquality().equals(other.builtInWallpaperPaths, builtInWallpaperPaths)&&const DeepCollectionEquality().equals(other.customWallpaperPaths, customWallpaperPaths)&&const DeepCollectionEquality().equals(other.widgets, widgets)&&const DeepCollectionEquality().equals(other.shortcuts, shortcuts)&&(identical(other.startupModule, startupModule) || other.startupModule == startupModule)&&(identical(other.snapToGrid, snapToGrid) || other.snapToGrid == snapToGrid)&&(identical(other.desktopGridVersion, desktopGridVersion) || other.desktopGridVersion == desktopGridVersion)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,readyUserId,selectedWallpaperPath,const DeepCollectionEquality().hash(builtInWallpaperPaths),const DeepCollectionEquality().hash(customWallpaperPaths),const DeepCollectionEquality().hash(widgets),const DeepCollectionEquality().hash(shortcuts),startupModule,snapToGrid,desktopGridVersion,updatedAt);

@override
String toString() {
  return 'DashboardPreferences(readyUserId: $readyUserId, selectedWallpaperPath: $selectedWallpaperPath, builtInWallpaperPaths: $builtInWallpaperPaths, customWallpaperPaths: $customWallpaperPaths, widgets: $widgets, shortcuts: $shortcuts, startupModule: $startupModule, snapToGrid: $snapToGrid, desktopGridVersion: $desktopGridVersion, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DashboardPreferencesCopyWith<$Res>  {
  factory $DashboardPreferencesCopyWith(DashboardPreferences value, $Res Function(DashboardPreferences) _then) = _$DashboardPreferencesCopyWithImpl;
@useResult
$Res call({
 String readyUserId, String selectedWallpaperPath, List<String> builtInWallpaperPaths, List<String> customWallpaperPaths, List<DashboardWidgetPreference> widgets, List<DashboardShortcutPreference> shortcuts, DashboardStartupModule startupModule, bool snapToGrid, int desktopGridVersion, DateTime updatedAt
});




}
/// @nodoc
class _$DashboardPreferencesCopyWithImpl<$Res>
    implements $DashboardPreferencesCopyWith<$Res> {
  _$DashboardPreferencesCopyWithImpl(this._self, this._then);

  final DashboardPreferences _self;
  final $Res Function(DashboardPreferences) _then;

/// Create a copy of DashboardPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? readyUserId = null,Object? selectedWallpaperPath = null,Object? builtInWallpaperPaths = null,Object? customWallpaperPaths = null,Object? widgets = null,Object? shortcuts = null,Object? startupModule = null,Object? snapToGrid = null,Object? desktopGridVersion = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
readyUserId: null == readyUserId ? _self.readyUserId : readyUserId // ignore: cast_nullable_to_non_nullable
as String,selectedWallpaperPath: null == selectedWallpaperPath ? _self.selectedWallpaperPath : selectedWallpaperPath // ignore: cast_nullable_to_non_nullable
as String,builtInWallpaperPaths: null == builtInWallpaperPaths ? _self.builtInWallpaperPaths : builtInWallpaperPaths // ignore: cast_nullable_to_non_nullable
as List<String>,customWallpaperPaths: null == customWallpaperPaths ? _self.customWallpaperPaths : customWallpaperPaths // ignore: cast_nullable_to_non_nullable
as List<String>,widgets: null == widgets ? _self.widgets : widgets // ignore: cast_nullable_to_non_nullable
as List<DashboardWidgetPreference>,shortcuts: null == shortcuts ? _self.shortcuts : shortcuts // ignore: cast_nullable_to_non_nullable
as List<DashboardShortcutPreference>,startupModule: null == startupModule ? _self.startupModule : startupModule // ignore: cast_nullable_to_non_nullable
as DashboardStartupModule,snapToGrid: null == snapToGrid ? _self.snapToGrid : snapToGrid // ignore: cast_nullable_to_non_nullable
as bool,desktopGridVersion: null == desktopGridVersion ? _self.desktopGridVersion : desktopGridVersion // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPreferences].
extension DashboardPreferencesPatterns on DashboardPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPreferences value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String readyUserId,  String selectedWallpaperPath,  List<String> builtInWallpaperPaths,  List<String> customWallpaperPaths,  List<DashboardWidgetPreference> widgets,  List<DashboardShortcutPreference> shortcuts,  DashboardStartupModule startupModule,  bool snapToGrid,  int desktopGridVersion,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPreferences() when $default != null:
return $default(_that.readyUserId,_that.selectedWallpaperPath,_that.builtInWallpaperPaths,_that.customWallpaperPaths,_that.widgets,_that.shortcuts,_that.startupModule,_that.snapToGrid,_that.desktopGridVersion,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String readyUserId,  String selectedWallpaperPath,  List<String> builtInWallpaperPaths,  List<String> customWallpaperPaths,  List<DashboardWidgetPreference> widgets,  List<DashboardShortcutPreference> shortcuts,  DashboardStartupModule startupModule,  bool snapToGrid,  int desktopGridVersion,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DashboardPreferences():
return $default(_that.readyUserId,_that.selectedWallpaperPath,_that.builtInWallpaperPaths,_that.customWallpaperPaths,_that.widgets,_that.shortcuts,_that.startupModule,_that.snapToGrid,_that.desktopGridVersion,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String readyUserId,  String selectedWallpaperPath,  List<String> builtInWallpaperPaths,  List<String> customWallpaperPaths,  List<DashboardWidgetPreference> widgets,  List<DashboardShortcutPreference> shortcuts,  DashboardStartupModule startupModule,  bool snapToGrid,  int desktopGridVersion,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPreferences() when $default != null:
return $default(_that.readyUserId,_that.selectedWallpaperPath,_that.builtInWallpaperPaths,_that.customWallpaperPaths,_that.widgets,_that.shortcuts,_that.startupModule,_that.snapToGrid,_that.desktopGridVersion,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardPreferences implements DashboardPreferences {
  const _DashboardPreferences({required this.readyUserId, required this.selectedWallpaperPath, required this.builtInWallpaperPaths, required this.customWallpaperPaths, required this.widgets, required this.shortcuts, required this.startupModule, this.snapToGrid = true, required this.desktopGridVersion, required this.updatedAt});
  factory _DashboardPreferences.fromJson(Map<String, dynamic> json) => _$DashboardPreferencesFromJson(json);

@override final  String readyUserId;
@override final  String selectedWallpaperPath;
@override final  List<String> builtInWallpaperPaths;
@override final  List<String> customWallpaperPaths;
@override final  List<DashboardWidgetPreference> widgets;
@override final  List<DashboardShortcutPreference> shortcuts;
@override final  DashboardStartupModule startupModule;
@override@JsonKey() final  bool snapToGrid;
@override final  int desktopGridVersion;
@override final  DateTime updatedAt;

/// Create a copy of DashboardPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPreferencesCopyWith<_DashboardPreferences> get copyWith => __$DashboardPreferencesCopyWithImpl<_DashboardPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPreferences&&(identical(other.readyUserId, readyUserId) || other.readyUserId == readyUserId)&&(identical(other.selectedWallpaperPath, selectedWallpaperPath) || other.selectedWallpaperPath == selectedWallpaperPath)&&const DeepCollectionEquality().equals(other.builtInWallpaperPaths, builtInWallpaperPaths)&&const DeepCollectionEquality().equals(other.customWallpaperPaths, customWallpaperPaths)&&const DeepCollectionEquality().equals(other.widgets, widgets)&&const DeepCollectionEquality().equals(other.shortcuts, shortcuts)&&(identical(other.startupModule, startupModule) || other.startupModule == startupModule)&&(identical(other.snapToGrid, snapToGrid) || other.snapToGrid == snapToGrid)&&(identical(other.desktopGridVersion, desktopGridVersion) || other.desktopGridVersion == desktopGridVersion)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,readyUserId,selectedWallpaperPath,const DeepCollectionEquality().hash(builtInWallpaperPaths),const DeepCollectionEquality().hash(customWallpaperPaths),const DeepCollectionEquality().hash(widgets),const DeepCollectionEquality().hash(shortcuts),startupModule,snapToGrid,desktopGridVersion,updatedAt);

@override
String toString() {
  return 'DashboardPreferences(readyUserId: $readyUserId, selectedWallpaperPath: $selectedWallpaperPath, builtInWallpaperPaths: $builtInWallpaperPaths, customWallpaperPaths: $customWallpaperPaths, widgets: $widgets, shortcuts: $shortcuts, startupModule: $startupModule, snapToGrid: $snapToGrid, desktopGridVersion: $desktopGridVersion, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DashboardPreferencesCopyWith<$Res> implements $DashboardPreferencesCopyWith<$Res> {
  factory _$DashboardPreferencesCopyWith(_DashboardPreferences value, $Res Function(_DashboardPreferences) _then) = __$DashboardPreferencesCopyWithImpl;
@override @useResult
$Res call({
 String readyUserId, String selectedWallpaperPath, List<String> builtInWallpaperPaths, List<String> customWallpaperPaths, List<DashboardWidgetPreference> widgets, List<DashboardShortcutPreference> shortcuts, DashboardStartupModule startupModule, bool snapToGrid, int desktopGridVersion, DateTime updatedAt
});




}
/// @nodoc
class __$DashboardPreferencesCopyWithImpl<$Res>
    implements _$DashboardPreferencesCopyWith<$Res> {
  __$DashboardPreferencesCopyWithImpl(this._self, this._then);

  final _DashboardPreferences _self;
  final $Res Function(_DashboardPreferences) _then;

/// Create a copy of DashboardPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? readyUserId = null,Object? selectedWallpaperPath = null,Object? builtInWallpaperPaths = null,Object? customWallpaperPaths = null,Object? widgets = null,Object? shortcuts = null,Object? startupModule = null,Object? snapToGrid = null,Object? desktopGridVersion = null,Object? updatedAt = null,}) {
  return _then(_DashboardPreferences(
readyUserId: null == readyUserId ? _self.readyUserId : readyUserId // ignore: cast_nullable_to_non_nullable
as String,selectedWallpaperPath: null == selectedWallpaperPath ? _self.selectedWallpaperPath : selectedWallpaperPath // ignore: cast_nullable_to_non_nullable
as String,builtInWallpaperPaths: null == builtInWallpaperPaths ? _self.builtInWallpaperPaths : builtInWallpaperPaths // ignore: cast_nullable_to_non_nullable
as List<String>,customWallpaperPaths: null == customWallpaperPaths ? _self.customWallpaperPaths : customWallpaperPaths // ignore: cast_nullable_to_non_nullable
as List<String>,widgets: null == widgets ? _self.widgets : widgets // ignore: cast_nullable_to_non_nullable
as List<DashboardWidgetPreference>,shortcuts: null == shortcuts ? _self.shortcuts : shortcuts // ignore: cast_nullable_to_non_nullable
as List<DashboardShortcutPreference>,startupModule: null == startupModule ? _self.startupModule : startupModule // ignore: cast_nullable_to_non_nullable
as DashboardStartupModule,snapToGrid: null == snapToGrid ? _self.snapToGrid : snapToGrid // ignore: cast_nullable_to_non_nullable
as bool,desktopGridVersion: null == desktopGridVersion ? _self.desktopGridVersion : desktopGridVersion // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
