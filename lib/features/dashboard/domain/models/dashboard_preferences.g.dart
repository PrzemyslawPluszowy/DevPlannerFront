// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardPreferences _$DashboardPreferencesFromJson(
  Map<String, dynamic> json,
) => _DashboardPreferences(
  readyUserId: json['readyUserId'] as String,
  selectedWallpaperPath: json['selectedWallpaperPath'] as String,
  builtInWallpaperPaths: (json['builtInWallpaperPaths'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  customWallpaperPaths: (json['customWallpaperPaths'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  widgets: (json['widgets'] as List<dynamic>)
      .map((e) => DashboardWidgetPreference.fromJson(e as Map<String, dynamic>))
      .toList(),
  shortcuts: (json['shortcuts'] as List<dynamic>)
      .map(
        (e) => DashboardShortcutPreference.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  startupModule: $enumDecode(
    _$DashboardStartupModuleEnumMap,
    json['startupModule'],
  ),
  snapToGrid: json['snapToGrid'] as bool? ?? true,
  desktopGridVersion: (json['desktopGridVersion'] as num).toInt(),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$DashboardPreferencesToJson(
  _DashboardPreferences instance,
) => <String, dynamic>{
  'readyUserId': instance.readyUserId,
  'selectedWallpaperPath': instance.selectedWallpaperPath,
  'builtInWallpaperPaths': instance.builtInWallpaperPaths,
  'customWallpaperPaths': instance.customWallpaperPaths,
  'widgets': instance.widgets,
  'shortcuts': instance.shortcuts,
  'startupModule': _$DashboardStartupModuleEnumMap[instance.startupModule]!,
  'snapToGrid': instance.snapToGrid,
  'desktopGridVersion': instance.desktopGridVersion,
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$DashboardStartupModuleEnumMap = {
  DashboardStartupModule.dashboard: 'dashboard',
  DashboardStartupModule.inventory: 'inventory',
  DashboardStartupModule.bhp: 'bhp',
  DashboardStartupModule.settings: 'settings',
};
