// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_shortcut_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardShortcutPreference _$DashboardShortcutPreferenceFromJson(
  Map<String, dynamic> json,
) => _DashboardShortcutPreference(
  shortcutId: json['shortcutId'] as String,
  userLabel: json['userLabel'] as String?,
  isVisible: json['isVisible'] as bool,
  position: (json['position'] as num).toInt(),
  gridColumn: (json['gridColumn'] as num).toInt(),
  gridRow: (json['gridRow'] as num).toInt(),
  exactDx: (json['exactDx'] as num?)?.toDouble(),
  exactDy: (json['exactDy'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DashboardShortcutPreferenceToJson(
  _DashboardShortcutPreference instance,
) => <String, dynamic>{
  'shortcutId': instance.shortcutId,
  'userLabel': instance.userLabel,
  'isVisible': instance.isVisible,
  'position': instance.position,
  'gridColumn': instance.gridColumn,
  'gridRow': instance.gridRow,
  'exactDx': instance.exactDx,
  'exactDy': instance.exactDy,
};
