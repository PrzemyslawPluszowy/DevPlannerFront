// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatePortfolioPayload _$CreatePortfolioPayloadFromJson(
  Map<String, dynamic> json,
) => _CreatePortfolioPayload(
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$CreatePortfolioPayloadToJson(
  _CreatePortfolioPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
};

_UpdatePortfolioPayload _$UpdatePortfolioPayloadFromJson(
  Map<String, dynamic> json,
) => _UpdatePortfolioPayload(
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$UpdatePortfolioPayloadToJson(
  _UpdatePortfolioPayload instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
};

_AddPortfolioProjectsPayload _$AddPortfolioProjectsPayloadFromJson(
  Map<String, dynamic> json,
) => _AddPortfolioProjectsPayload(
  projectIds: (json['projectIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AddPortfolioProjectsPayloadToJson(
  _AddPortfolioProjectsPayload instance,
) => <String, dynamic>{'projectIds': instance.projectIds};

_PortfolioResponse _$PortfolioResponseFromJson(Map<String, dynamic> json) =>
    _PortfolioResponse(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      createdByCoreUserId: json['createdByCoreUserId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      progress: (json['progress'] as num).toDouble(),
      projectIds: (json['projectIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$PortfolioResponseToJson(_PortfolioResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'createdByCoreUserId': instance.createdByCoreUserId,
      'name': instance.name,
      'description': instance.description,
      'progress': instance.progress,
      'projectIds': instance.projectIds,
      'createdAtUtc': instance.createdAtUtc.toIso8601String(),
      'updatedAtUtc': instance.updatedAtUtc.toIso8601String(),
      'version': instance.version,
    };

_PortfolioDashboardResponse _$PortfolioDashboardResponseFromJson(
  Map<String, dynamic> json,
) => _PortfolioDashboardResponse(
  portfolioId: json['portfolioId'] as String,
  projectCount: (json['projectCount'] as num).toInt(),
  progress: (json['progress'] as num).toDouble(),
  openTaskCount: (json['openTaskCount'] as num).toInt(),
  doneTaskCount: (json['doneTaskCount'] as num).toInt(),
  overdueTaskCount: (json['overdueTaskCount'] as num).toInt(),
  activeMilestoneCount: (json['activeMilestoneCount'] as num).toInt(),
  calculatedAtUtc: DateTime.parse(json['calculatedAtUtc'] as String),
);

Map<String, dynamic> _$PortfolioDashboardResponseToJson(
  _PortfolioDashboardResponse instance,
) => <String, dynamic>{
  'portfolioId': instance.portfolioId,
  'projectCount': instance.projectCount,
  'progress': instance.progress,
  'openTaskCount': instance.openTaskCount,
  'doneTaskCount': instance.doneTaskCount,
  'overdueTaskCount': instance.overdueTaskCount,
  'activeMilestoneCount': instance.activeMilestoneCount,
  'calculatedAtUtc': instance.calculatedAtUtc.toIso8601String(),
};
