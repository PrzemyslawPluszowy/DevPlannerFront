// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_schedule_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectScheduleSettingsResponse _$ProjectScheduleSettingsResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectScheduleSettingsResponse(
  mode: $enumDecode(_$AutoScheduleModeEnumMap, json['mode']),
);

Map<String, dynamic> _$ProjectScheduleSettingsResponseToJson(
  _ProjectScheduleSettingsResponse instance,
) => <String, dynamic>{'mode': _$AutoScheduleModeEnumMap[instance.mode]!};

const _$AutoScheduleModeEnumMap = {
  AutoScheduleMode.manual: 'Manual',
  AutoScheduleMode.pushSuccessorsOnly: 'PushSuccessorsOnly',
  AutoScheduleMode.strictCascade: 'StrictCascade',
};

_PreviewScheduleCascadePayload _$PreviewScheduleCascadePayloadFromJson(
  Map<String, dynamic> json,
) => _PreviewScheduleCascadePayload(
  taskId: json['taskId'] as String,
  newStartAtUtc: DateTime.parse(json['newStartAtUtc'] as String),
  newDueAtUtc: DateTime.parse(json['newDueAtUtc'] as String),
);

Map<String, dynamic> _$PreviewScheduleCascadePayloadToJson(
  _PreviewScheduleCascadePayload instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'newStartAtUtc': instance.newStartAtUtc.toIso8601String(),
  'newDueAtUtc': instance.newDueAtUtc.toIso8601String(),
};

_ApplyScheduleCascadePayload _$ApplyScheduleCascadePayloadFromJson(
  Map<String, dynamic> json,
) => _ApplyScheduleCascadePayload(
  taskId: json['taskId'] as String,
  newStartAtUtc: DateTime.parse(json['newStartAtUtc'] as String),
  newDueAtUtc: DateTime.parse(json['newDueAtUtc'] as String),
  expectedTaskVersions: Map<String, int>.from(
    json['expectedTaskVersions'] as Map,
  ),
);

Map<String, dynamic> _$ApplyScheduleCascadePayloadToJson(
  _ApplyScheduleCascadePayload instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'newStartAtUtc': instance.newStartAtUtc.toIso8601String(),
  'newDueAtUtc': instance.newDueAtUtc.toIso8601String(),
  'expectedTaskVersions': instance.expectedTaskVersions,
};

_TaskDateShiftResponse _$TaskDateShiftResponseFromJson(
  Map<String, dynamic> json,
) => _TaskDateShiftResponse(
  taskId: json['taskId'] as String,
  title: json['title'] as String,
  currentStartAtUtc: json['currentStartAtUtc'] == null
      ? null
      : DateTime.parse(json['currentStartAtUtc'] as String),
  proposedStartAtUtc: DateTime.parse(json['proposedStartAtUtc'] as String),
  currentDueAtUtc: json['currentDueAtUtc'] == null
      ? null
      : DateTime.parse(json['currentDueAtUtc'] as String),
  proposedDueAtUtc: DateTime.parse(json['proposedDueAtUtc'] as String),
  shiftWorkingDays: (json['shiftWorkingDays'] as num).toInt(),
  isOnCriticalPath: json['isOnCriticalPath'] as bool,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$TaskDateShiftResponseToJson(
  _TaskDateShiftResponse instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'title': instance.title,
  'currentStartAtUtc': instance.currentStartAtUtc?.toIso8601String(),
  'proposedStartAtUtc': instance.proposedStartAtUtc.toIso8601String(),
  'currentDueAtUtc': instance.currentDueAtUtc?.toIso8601String(),
  'proposedDueAtUtc': instance.proposedDueAtUtc.toIso8601String(),
  'shiftWorkingDays': instance.shiftWorkingDays,
  'isOnCriticalPath': instance.isOnCriticalPath,
  'expectedVersion': instance.expectedVersion,
};

_TaskFloatResponse _$TaskFloatResponseFromJson(Map<String, dynamic> json) =>
    _TaskFloatResponse(
      taskId: json['taskId'] as String,
      earlyStartUtc: DateTime.parse(json['earlyStartUtc'] as String),
      earlyFinishUtc: DateTime.parse(json['earlyFinishUtc'] as String),
      lateStartUtc: DateTime.parse(json['lateStartUtc'] as String),
      lateFinishUtc: DateTime.parse(json['lateFinishUtc'] as String),
      totalFloatDays: (json['totalFloatDays'] as num).toInt(),
      isCritical: json['isCritical'] as bool,
    );

Map<String, dynamic> _$TaskFloatResponseToJson(_TaskFloatResponse instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'earlyStartUtc': instance.earlyStartUtc.toIso8601String(),
      'earlyFinishUtc': instance.earlyFinishUtc.toIso8601String(),
      'lateStartUtc': instance.lateStartUtc.toIso8601String(),
      'lateFinishUtc': instance.lateFinishUtc.toIso8601String(),
      'totalFloatDays': instance.totalFloatDays,
      'isCritical': instance.isCritical,
    };

_ScheduleCascadeResponse _$ScheduleCascadeResponseFromJson(
  Map<String, dynamic> json,
) => _ScheduleCascadeResponse(
  dateShifts: (json['dateShifts'] as List<dynamic>)
      .map((e) => TaskDateShiftResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  criticalPathTaskIds: (json['criticalPathTaskIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  totalProjectWorkingDays: (json['totalProjectWorkingDays'] as num).toInt(),
  taskFloats: (json['taskFloats'] as List<dynamic>)
      .map((e) => TaskFloatResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ScheduleCascadeResponseToJson(
  _ScheduleCascadeResponse instance,
) => <String, dynamic>{
  'dateShifts': instance.dateShifts,
  'criticalPathTaskIds': instance.criticalPathTaskIds,
  'totalProjectWorkingDays': instance.totalProjectWorkingDays,
  'taskFloats': instance.taskFloats,
};

_SetScheduleModePayload _$SetScheduleModePayloadFromJson(
  Map<String, dynamic> json,
) => _SetScheduleModePayload(
  mode: $enumDecode(_$AutoScheduleModeEnumMap, json['mode']),
);

Map<String, dynamic> _$SetScheduleModePayloadToJson(
  _SetScheduleModePayload instance,
) => <String, dynamic>{'mode': _$AutoScheduleModeEnumMap[instance.mode]!};

_CreateWorkspaceHolidayPayload _$CreateWorkspaceHolidayPayloadFromJson(
  Map<String, dynamic> json,
) => _CreateWorkspaceHolidayPayload(
  date: DateTime.parse(json['date'] as String),
  name: json['name'] as String,
);

Map<String, dynamic> _$CreateWorkspaceHolidayPayloadToJson(
  _CreateWorkspaceHolidayPayload instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'name': instance.name,
};

_WorkspaceHolidayResponse _$WorkspaceHolidayResponseFromJson(
  Map<String, dynamic> json,
) => _WorkspaceHolidayResponse(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  name: json['name'] as String,
);

Map<String, dynamic> _$WorkspaceHolidayResponseToJson(
  _WorkspaceHolidayResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'name': instance.name,
};
