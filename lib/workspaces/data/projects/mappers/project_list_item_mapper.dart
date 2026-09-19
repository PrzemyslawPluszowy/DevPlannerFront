import 'package:devplanner/workspaces/data/projects/responses/devplanner_project_list_item_response.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';

/// Mapuje lokalny DTO listy projektów na model domenowy.
final class ProjectListItemMapper {
  const ProjectListItemMapper._();

  static ProjectListItem toDomain(DevPlannerProjectListItemResponse response) =>
      ProjectListItem(
        id: response.id,
        workspaceId: response.workspaceId,
        name: response.name,
        description: response.description,
        icon: response.icon,
        primaryColor: response.primaryColor,
        visibility: response.visibility,
        status: response.status,
        myRole: response.myRole,
        isPinned: response.isPinned,
        sortPosition: response.sortPosition,
      );
}
