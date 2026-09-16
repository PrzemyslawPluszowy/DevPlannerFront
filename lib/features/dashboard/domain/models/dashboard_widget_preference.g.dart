// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_widget_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardWidgetPreference _$DashboardWidgetPreferenceFromJson(
  Map<String, dynamic> json,
) => _DashboardWidgetPreference(
  id: json['id'] as String,
  widgetTypeId: json['widgetTypeId'] as String,
  gridColumn: (json['gridColumn'] as num).toInt(),
  gridRow: (json['gridRow'] as num).toInt(),
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  preferredWidth: (json['preferredWidth'] as num?)?.toInt(),
  preferredHeight: (json['preferredHeight'] as num?)?.toInt(),
  exactDx: (json['exactDx'] as num?)?.toDouble(),
  exactDy: (json['exactDy'] as num?)?.toDouble(),
  settings: json['settings'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$DashboardWidgetPreferenceToJson(
  _DashboardWidgetPreference instance,
) => <String, dynamic>{
  'id': instance.id,
  'widgetTypeId': instance.widgetTypeId,
  'gridColumn': instance.gridColumn,
  'gridRow': instance.gridRow,
  'width': instance.width,
  'height': instance.height,
  'preferredWidth': instance.preferredWidth,
  'preferredHeight': instance.preferredHeight,
  'exactDx': instance.exactDx,
  'exactDy': instance.exactDy,
  'settings': instance.settings,
};
