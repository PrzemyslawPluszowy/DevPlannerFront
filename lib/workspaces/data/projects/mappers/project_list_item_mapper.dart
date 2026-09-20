import 'package:devplanner/workspaces/data/projects/responses/devplanner_project_list_item_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_capabilities_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_response.dart';
import 'package:devplanner/workspaces/domain/models/project_action_capabilities.dart';
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
        isHidden: response.isHidden,
        archivedAtUtc: response.archivedAtUtc,
        version: response.version,
        capabilities: response.capabilities,
      );

  /// Mapuje pełny widok projektu na wiersz drzewa.
  ///
  /// `sortPosition` jest opcjonalne, bo odpowiedź pojedynczego projektu nie
  /// publikuje kolejności osobistej użytkownika.
  static ProjectListItem fromProjectResponse(
    ProjectResponse response, {
    int? sortPosition,
  }) => ProjectListItem(
    id: response.id,
    workspaceId: response.workspaceId,
    name: response.name,
    description: response.description,
    icon: response.icon,
    primaryColor: response.primaryColor,
    visibility: response.visibility,
    status: response.status,
    myRole: response.myRole,
    sortPosition: sortPosition,
    archivedAtUtc: response.archivedAtUtc,
    version: response.version,
    capabilities: toDomainCapabilities(response.capabilities),
  );

  /// Mapuje możliwości z kontraktu transportowego na model domenowy.
  ///
  /// Brak obiektu w odpowiedzi zwraca `null`, a nie zestaw `false`, żeby
  /// prezentacja odróżniła „backend mówi nie” od „backend nie powiedział”.
  static ProjectActionCapabilities? toDomainCapabilities(
    ProjectCapabilitiesResponse? response,
  ) => response == null
      ? null
      : ProjectActionCapabilities(
          canManage: response.canManage,
          canArchive: response.canArchive,
          canDelete: response.canDelete,
          canManageMembers: response.canManageMembers,
          canCreateTemplate: response.canCreateTemplate,
          canLeave: response.canLeave,
          canTransfer: response.canTransfer,
        );
}
