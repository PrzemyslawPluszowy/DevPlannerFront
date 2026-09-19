import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';

TaskSavedViewSortField _parseSortField(String? value) {
  if (value == null) return TaskSavedViewSortField.position;
  return TaskSavedViewSortField.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => TaskSavedViewSortField.position,
  );
}

TaskSavedViewSortDirection _parseSortDirection(String? value) {
  if (value == null) return TaskSavedViewSortDirection.ascending;
  return TaskSavedViewSortDirection.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => TaskSavedViewSortDirection.ascending,
  );
}

TaskSavedViewGroupBy _parseGroupBy(String? value) {
  if (value == null) return TaskSavedViewGroupBy.status;
  return TaskSavedViewGroupBy.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => TaskSavedViewGroupBy.status,
  );
}

String _toPascal(String name) {
  if (name.isEmpty) return name;
  return name[0].toUpperCase() + name.substring(1);
}

/// Konfiguracja polityki listy zadań projektu określona przez administratora.
final class ProjectTaskListPolicyResponse {
  const ProjectTaskListPolicyResponse({
    required this.workspaceId,
    required this.projectId,
    required this.availableColumns,
    required this.requiredColumns,
    required this.defaultColumns,
    required this.defaultColumnWidths,
    required this.defaultSortField,
    required this.defaultSortDirection,
    required this.defaultGroupBy,
    required this.updatedAtUtc,
    required this.version,
  });

  factory ProjectTaskListPolicyResponse.fromJson(Map<String, dynamic> json) =>
      ProjectTaskListPolicyResponse(
        workspaceId: json['workspaceId'] as String,
        projectId: json['projectId'] as String,
        availableColumns:
            (json['availableColumns'] as List<dynamic>? ?? const [])
                .map((e) => e.toString())
                .toList(),
        requiredColumns: (json['requiredColumns'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
        defaultColumns: (json['defaultColumns'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
        defaultColumnWidths:
            (json['defaultColumnWidths'] as Map<String, dynamic>? ?? const {})
                .map((k, v) => MapEntry(k, (v as num).toDouble())),
        defaultSortField: _parseSortField(json['defaultSortField'] as String?),
        defaultSortDirection: _parseSortDirection(
          json['defaultSortDirection'] as String?,
        ),
        defaultGroupBy: _parseGroupBy(json['defaultGroupBy'] as String?),
        updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
        version: json['version'] as int? ?? 0,
      );

  final String workspaceId;
  final String projectId;
  final List<String> availableColumns;
  final List<String> requiredColumns;
  final List<String> defaultColumns;
  final Map<String, double> defaultColumnWidths;
  final TaskSavedViewSortField defaultSortField;
  final TaskSavedViewSortDirection defaultSortDirection;
  final TaskSavedViewGroupBy defaultGroupBy;
  final DateTime updatedAtUtc;
  final int version;

  Map<String, dynamic> toJson() => {
    'workspaceId': workspaceId,
    'projectId': projectId,
    'availableColumns': availableColumns,
    'requiredColumns': requiredColumns,
    'defaultColumns': defaultColumns,
    'defaultColumnWidths': defaultColumnWidths,
    'defaultSortField': _toPascal(defaultSortField.name),
    'defaultSortDirection': _toPascal(defaultSortDirection.name),
    'defaultGroupBy': _toPascal(defaultGroupBy.name),
    'updatedAtUtc': updatedAtUtc.toIso8601String(),
    'version': version,
  };
}

/// Osobiste preferencje układu listy zadań bieżącego użytkownika.
final class TaskListUserPreferenceResponse {
  const TaskListUserPreferenceResponse({
    required this.workspaceId,
    required this.projectId,
    required this.userId,
    required this.visibleColumns,
    required this.columnWidths,
    this.sortField,
    this.sortDirection,
    this.groupBy,
    this.activeSavedViewId,
    this.updatedAtUtc,
    required this.version,
  });

  factory TaskListUserPreferenceResponse.fromJson(Map<String, dynamic> json) =>
      TaskListUserPreferenceResponse(
        workspaceId: json['workspaceId'] as String,
        projectId: json['projectId'] as String,
        userId: json['userId'] as String,
        visibleColumns: (json['visibleColumns'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
        columnWidths:
            (json['columnWidths'] as Map<String, dynamic>? ?? const {}).map(
              (k, v) => MapEntry(k, (v as num).toDouble()),
            ),
        sortField: json['sortField'] != null
            ? _parseSortField(json['sortField'] as String?)
            : null,
        sortDirection: json['sortDirection'] != null
            ? _parseSortDirection(json['sortDirection'] as String?)
            : null,
        groupBy: json['groupBy'] != null
            ? _parseGroupBy(json['groupBy'] as String?)
            : null,
        activeSavedViewId: json['activeSavedViewId'] as String?,
        updatedAtUtc: json['updatedAtUtc'] != null
            ? DateTime.parse(json['updatedAtUtc'] as String)
            : null,
        version: json['version'] as int? ?? 0,
      );

  final String workspaceId;
  final String projectId;
  final String userId;
  final List<String> visibleColumns;
  final Map<String, double> columnWidths;
  final TaskSavedViewSortField? sortField;
  final TaskSavedViewSortDirection? sortDirection;
  final TaskSavedViewGroupBy? groupBy;
  final String? activeSavedViewId;
  final DateTime? updatedAtUtc;
  final int version;

  Map<String, dynamic> toJson() => {
    'workspaceId': workspaceId,
    'projectId': projectId,
    'userId': userId,
    'visibleColumns': visibleColumns,
    'columnWidths': columnWidths,
    if (sortField != null) 'sortField': _toPascal(sortField!.name),
    if (sortDirection != null) 'sortDirection': _toPascal(sortDirection!.name),
    if (groupBy != null) 'groupBy': _toPascal(groupBy!.name),
    if (activeSavedViewId != null) 'activeSavedViewId': activeSavedViewId,
    if (updatedAtUtc != null) 'updatedAtUtc': updatedAtUtc!.toIso8601String(),
    'version': version,
  };
}

/// Efektywna konfiguracja listy zadań łącząca politykę administratora z preferencjami użytkownika.
final class EffectiveTaskListConfigurationResponse {
  const EffectiveTaskListConfigurationResponse({
    required this.workspaceId,
    required this.projectId,
    required this.effectiveVisibleColumns,
    required this.effectiveColumnWidths,
    required this.availableColumns,
    required this.requiredColumns,
    required this.sortField,
    required this.sortDirection,
    required this.groupBy,
    this.activeSavedViewId,
    required this.userPreferenceVersion,
    required this.policyVersion,
  });

  factory EffectiveTaskListConfigurationResponse.fromJson(
    Map<String, dynamic> json,
  ) => EffectiveTaskListConfigurationResponse(
    workspaceId: json['workspaceId'] as String,
    projectId: json['projectId'] as String,
    effectiveVisibleColumns:
        (json['effectiveVisibleColumns'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
    effectiveColumnWidths:
        (json['effectiveColumnWidths'] as Map<String, dynamic>? ?? const {})
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
    availableColumns: (json['availableColumns'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    requiredColumns: (json['requiredColumns'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    sortField: _parseSortField(json['sortField'] as String?),
    sortDirection: _parseSortDirection(json['sortDirection'] as String?),
    groupBy: _parseGroupBy(json['groupBy'] as String?),
    activeSavedViewId: json['activeSavedViewId'] as String?,
    userPreferenceVersion: json['userPreferenceVersion'] as int? ?? 0,
    policyVersion: json['policyVersion'] as int? ?? 0,
  );

  final String workspaceId;
  final String projectId;
  final List<String> effectiveVisibleColumns;
  final Map<String, double> effectiveColumnWidths;
  final List<String> availableColumns;
  final List<String> requiredColumns;
  final TaskSavedViewSortField sortField;
  final TaskSavedViewSortDirection sortDirection;
  final TaskSavedViewGroupBy groupBy;
  final String? activeSavedViewId;
  final int userPreferenceVersion;
  final int policyVersion;
}

/// Payload aktualizacji polityki projektu.
final class UpdateProjectTaskListPolicyPayload {
  const UpdateProjectTaskListPolicyPayload({
    required this.availableColumns,
    required this.requiredColumns,
    required this.defaultColumns,
    required this.defaultColumnWidths,
    required this.defaultSortField,
    required this.defaultSortDirection,
    required this.defaultGroupBy,
    required this.expectedVersion,
  });

  final List<String> availableColumns;
  final List<String> requiredColumns;
  final List<String> defaultColumns;
  final Map<String, double> defaultColumnWidths;
  final TaskSavedViewSortField defaultSortField;
  final TaskSavedViewSortDirection defaultSortDirection;
  final TaskSavedViewGroupBy defaultGroupBy;
  final int expectedVersion;

  Map<String, dynamic> toJson() => {
    'availableColumns': availableColumns,
    'requiredColumns': requiredColumns,
    'defaultColumns': defaultColumns,
    'defaultColumnWidths': defaultColumnWidths,
    'defaultSortField': _toPascal(defaultSortField.name),
    'defaultSortDirection': _toPascal(defaultSortDirection.name),
    'defaultGroupBy': _toPascal(defaultGroupBy.name),
    'expectedVersion': expectedVersion,
  };
}

/// Payload aktualizacji preferencji użytkownika.
final class UpdateTaskListUserPreferencePayload {
  const UpdateTaskListUserPreferencePayload({
    required this.visibleColumns,
    required this.columnWidths,
    this.sortField,
    this.sortDirection,
    this.groupBy,
    this.activeSavedViewId,
    required this.expectedVersion,
  });

  final List<String> visibleColumns;
  final Map<String, double> columnWidths;
  final TaskSavedViewSortField? sortField;
  final TaskSavedViewSortDirection? sortDirection;
  final TaskSavedViewGroupBy? groupBy;
  final String? activeSavedViewId;
  final int expectedVersion;

  Map<String, dynamic> toJson() => {
    'visibleColumns': visibleColumns,
    'columnWidths': columnWidths,
    if (sortField != null) 'sortField': _toPascal(sortField!.name),
    if (sortDirection != null) 'sortDirection': _toPascal(sortDirection!.name),
    if (groupBy != null) 'groupBy': _toPascal(groupBy!.name),
    'activeSavedViewId': activeSavedViewId,
    'expectedVersion': expectedVersion,
  };
}
