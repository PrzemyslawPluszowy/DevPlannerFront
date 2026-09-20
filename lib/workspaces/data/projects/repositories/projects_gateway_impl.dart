import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/projects/api/projects_list_api.dart';
import 'package:devplanner/workspaces/data/projects/mappers/project_list_item_mapper.dart';
import 'package:devplanner/workspaces/data/projects/responses/devplanner_project_list_item_response.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';

/// Produkcyjny adapter listy projektów oparty o lokalny transport DevPlanner.
final class ProjectsGatewayImpl implements ProjectsGateway {
  const ProjectsGatewayImpl({required this.api});

  final ProjectsListApi api;

  @override
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    @Deprecated('Użyj visibility; wartość true odpowiada visibility=all.')
    bool? includeHidden,
  }) async {
    try {
      final response = await api.listProjects(
        workspaceId: workspaceId,
        state: state,
        visibility: visibility,
        includeHidden: includeHidden,
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw _errorFrom(response);
      }
      final body = response.body;
      if (body is! List) {
        throw const ProjectsGatewayException(
          reason: ProjectsFailureReason.invalidResponse,
        );
      }
      try {
        return body
            .map(DevPlannerProjectListItemResponse.fromJson)
            .map(
              (item) {
                if (item.workspaceId != workspaceId) {
                  throw const FormatException('project_workspace_mismatch');
                }
                return ProjectListItemMapper.toDomain(item);
              },
            )
            .toList(growable: false);
      } on FormatException {
        throw const ProjectsGatewayException(
          reason: ProjectsFailureReason.invalidResponse,
        );
      }
    } on DevPlannerHttpTransportException {
      throw const ProjectsGatewayException(
        reason: ProjectsFailureReason.transportUnavailable,
      );
    }
  }

  ProjectsGatewayException _errorFrom(DevPlannerHttpResponse response) {
    final reason = switch (response.statusCode) {
      401 => ProjectsFailureReason.unauthorized,
      403 => ProjectsFailureReason.forbidden,
      404 => ProjectsFailureReason.notFound,
      _ => ProjectsFailureReason.requestFailed,
    };
    final body = response.body;
    return ProjectsGatewayException(
      reason: reason,
      statusCode: response.statusCode,
      backendCode: body is Map && body['code'] is String
          ? body['code'] as String
          : null,
      message: body is Map && body['message'] is String
          ? body['message'] as String
          : null,
      traceId: response.traceId,
    );
  }
}
