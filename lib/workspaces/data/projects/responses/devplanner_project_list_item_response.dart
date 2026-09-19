import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';

/// DTO listy projektów zgodny z backendowym `ProjectListItemResponse`.
final class DevPlannerProjectListItemResponse {
  const DevPlannerProjectListItemResponse({
    required this.id,
    required this.workspaceId,
    required this.name,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.visibility,
    required this.status,
    required this.myRole,
    required this.isPinned,
    required this.sortPosition,
  });

  factory DevPlannerProjectListItemResponse.fromJson(Object? value) {
    if (value is! Map) throw const FormatException('project_item_not_object');
    final id = value['id'];
    final workspaceId = value['workspaceId'];
    final name = value['name'];
    final visibility = _enumValue<ProjectVisibility>(
      value['visibility'],
      ProjectVisibility.values,
    );
    final status = _enumValue<ProjectStatus>(
      value['status'],
      ProjectStatus.values,
    );
    final myRole = _nullableEnumValue<ProjectRole>(
      value['myRole'],
      ProjectRole.values,
    );
    if (id is! String ||
        id.trim().isEmpty ||
        workspaceId is! String ||
        workspaceId.trim().isEmpty ||
        name is! String ||
        name.trim().isEmpty ||
        visibility == null ||
        status == null ||
        value['isPinned'] is! bool) {
      throw const FormatException('project_item_invalid_fields');
    }
    return DevPlannerProjectListItemResponse(
      id: id,
      workspaceId: workspaceId,
      name: name,
      description: value['description'] is String
          ? value['description'] as String
          : null,
      icon: value['icon'] is String ? value['icon'] as String : null,
      primaryColor: value['primaryColor'] is String
          ? value['primaryColor'] as String
          : null,
      visibility: visibility,
      status: status,
      myRole: myRole,
      isPinned: value['isPinned'] as bool,
      sortPosition: value['sortPosition'] is num
          ? (value['sortPosition'] as num).toInt()
          : null,
    );
  }

  final String id;
  final String workspaceId;
  final String name;
  final String? description;
  final String? icon;
  final String? primaryColor;
  final ProjectVisibility visibility;
  final ProjectStatus status;
  final ProjectRole? myRole;
  final bool isPinned;
  final int? sortPosition;

  static T? _enumValue<T>(Object? raw, List<T> values) {
    if (raw is! String) return null;
    for (final value in values) {
      if (value.toString().split('.').last.toLowerCase() == raw.toLowerCase()) {
        return value;
      }
    }
    return null;
  }

  static T? _nullableEnumValue<T>(Object? raw, List<T> values) {
    if (raw == null) return null;
    return _enumValue(raw, values);
  }
}
