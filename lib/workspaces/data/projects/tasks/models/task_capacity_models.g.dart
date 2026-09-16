// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_capacity_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateWorkspaceCapacityPayload _$UpdateWorkspaceCapacityPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateWorkspaceCapacityPayload(
  defaultDailyCapacityMinutes: (json['defaultDailyCapacityMinutes'] as num)
      .toInt(),
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateWorkspaceCapacityPayloadToJson(
  _UpdateWorkspaceCapacityPayload instance,
) => <String, dynamic>{
  'defaultDailyCapacityMinutes': instance.defaultDailyCapacityMinutes,
  'expectedVersion': instance.expectedVersion,
};

_WorkspaceCapacityResponse _$WorkspaceCapacityResponseFromJson(
  Map<String, dynamic> json,
) => _WorkspaceCapacityResponse(
  workspaceId: json['workspaceId'] as String,
  defaultDailyCapacityMinutes: (json['defaultDailyCapacityMinutes'] as num)
      .toInt(),
  version: (json['version'] as num).toInt(),
  updatedAtUtc: json['updatedAtUtc'] == null
      ? null
      : DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$WorkspaceCapacityResponseToJson(
  _WorkspaceCapacityResponse instance,
) => <String, dynamic>{
  'workspaceId': instance.workspaceId,
  'defaultDailyCapacityMinutes': instance.defaultDailyCapacityMinutes,
  'version': instance.version,
  'updatedAtUtc': instance.updatedAtUtc?.toIso8601String(),
};

_CreateUserCapacityOverridePayload _$CreateUserCapacityOverridePayloadFromJson(
  Map<String, dynamic> json,
) => _CreateUserCapacityOverridePayload(
  coreUserId: json['coreUserId'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  availableMinutesPerDay: (json['availableMinutesPerDay'] as num).toInt(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$CreateUserCapacityOverridePayloadToJson(
  _CreateUserCapacityOverridePayload instance,
) => <String, dynamic>{
  'coreUserId': instance.coreUserId,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'availableMinutesPerDay': instance.availableMinutesPerDay,
  'reason': instance.reason,
};

_UpdateUserCapacityOverridePayload _$UpdateUserCapacityOverridePayloadFromJson(
  Map<String, dynamic> json,
) => _UpdateUserCapacityOverridePayload(
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  availableMinutesPerDay: (json['availableMinutesPerDay'] as num).toInt(),
  reason: json['reason'] as String?,
  expectedVersion: (json['expectedVersion'] as num).toInt(),
);

Map<String, dynamic> _$UpdateUserCapacityOverridePayloadToJson(
  _UpdateUserCapacityOverridePayload instance,
) => <String, dynamic>{
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'availableMinutesPerDay': instance.availableMinutesPerDay,
  'reason': instance.reason,
  'expectedVersion': instance.expectedVersion,
};

_UserCapacityOverrideResponse _$UserCapacityOverrideResponseFromJson(
  Map<String, dynamic> json,
) => _UserCapacityOverrideResponse(
  id: json['id'] as String,
  workspaceId: json['workspaceId'] as String,
  projectId: json['projectId'] as String,
  coreUserId: json['coreUserId'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  availableMinutesPerDay: (json['availableMinutesPerDay'] as num).toInt(),
  reason: json['reason'] as String?,
  version: (json['version'] as num).toInt(),
  updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
);

Map<String, dynamic> _$UserCapacityOverrideResponseToJson(
  _UserCapacityOverrideResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'coreUserId': instance.coreUserId,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'availableMinutesPerDay': instance.availableMinutesPerDay,
  'reason': instance.reason,
  'version': instance.version,
  'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
};

_TaskWorkloadUserResponse _$TaskWorkloadUserResponseFromJson(
  Map<String, dynamic> json,
) => _TaskWorkloadUserResponse(
  coreUserId: json['coreUserId'] as String,
  assignedTaskCount: (json['assignedTaskCount'] as num).toInt(),
  estimatedMinutes: (json['estimatedMinutes'] as num).toInt(),
  loggedMinutes: (json['loggedMinutes'] as num).toInt(),
  unplannedEstimatedMinutes:
      (json['unplannedEstimatedMinutes'] as num?)?.toInt() ?? 0,
  availableCapacityMinutes:
      (json['availableCapacityMinutes'] as num?)?.toInt() ?? 0,
  remainingCapacityMinutes:
      (json['remainingCapacityMinutes'] as num?)?.toInt() ?? 0,
  isOverCapacity: json['isOverCapacity'] as bool? ?? false,
  capacitySource:
      $enumDecodeNullable(_$CapacitySourceEnumMap, json['capacitySource']) ??
      CapacitySource.workspaceDefault,
);

Map<String, dynamic> _$TaskWorkloadUserResponseToJson(
  _TaskWorkloadUserResponse instance,
) => <String, dynamic>{
  'coreUserId': instance.coreUserId,
  'assignedTaskCount': instance.assignedTaskCount,
  'estimatedMinutes': instance.estimatedMinutes,
  'loggedMinutes': instance.loggedMinutes,
  'unplannedEstimatedMinutes': instance.unplannedEstimatedMinutes,
  'availableCapacityMinutes': instance.availableCapacityMinutes,
  'remainingCapacityMinutes': instance.remainingCapacityMinutes,
  'isOverCapacity': instance.isOverCapacity,
  'capacitySource': _$CapacitySourceEnumMap[instance.capacitySource]!,
};

const _$CapacitySourceEnumMap = {
  CapacitySource.workspaceDefault: 'WorkspaceDefault',
  CapacitySource.projectUserOverride: 'ProjectUserOverride',
};

_TaskWorkloadResponse _$TaskWorkloadResponseFromJson(
  Map<String, dynamic> json,
) => _TaskWorkloadResponse(
  projectId: json['projectId'] as String,
  users: (json['users'] as List<dynamic>)
      .map((e) => TaskWorkloadUserResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  fromDate: json['fromDate'] == null
      ? null
      : DateTime.parse(json['fromDate'] as String),
  toDate: json['toDate'] == null
      ? null
      : DateTime.parse(json['toDate'] as String),
);

Map<String, dynamic> _$TaskWorkloadResponseToJson(
  _TaskWorkloadResponse instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'users': instance.users,
  'fromDate': instance.fromDate?.toIso8601String(),
  'toDate': instance.toDate?.toIso8601String(),
};
