import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/domain/ports/project_management_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';

/// Adapter minimalnej mutacji projektu używanej przez nowy sidebar.
final class DevPlannerProjectManagementGateway
    implements ProjectManagementGateway {
  const DevPlannerProjectManagementGateway({required this.transport});

  final DevPlannerHttpTransport transport;

  @override
  Future<String> createProject({
    required String workspaceId,
    required String name,
  }) async {
    try {
      final response = await transport.execute(
        DevPlannerHttpRequest(
          method: DevPlannerHttpMethod.post,
          path: '/api/v1/workspaces/$workspaceId/projects/',
          body: {
            'name': name,
            'visibility': 'Shared',
            'status': 'Active',
          },
        ),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw _errorFrom(response);
      }
      final body = response.body;
      final id = body is Map ? body['id'] : null;
      if (id is! String || id.isEmpty) {
        throw const ProjectsGatewayException(
          reason: ProjectsFailureReason.invalidResponse,
        );
      }
      return id;
    } on DevPlannerHttpTransportException {
      throw const ProjectsGatewayException(
        reason: ProjectsFailureReason.transportUnavailable,
      );
    }
  }

  ProjectsGatewayException _errorFrom(DevPlannerHttpResponse response) =>
      ProjectsGatewayException(
        reason: switch (response.statusCode) {
          401 => ProjectsFailureReason.unauthorized,
          403 => ProjectsFailureReason.forbidden,
          404 => ProjectsFailureReason.notFound,
          _ => ProjectsFailureReason.requestFailed,
        },
        statusCode: response.statusCode,
        traceId: response.traceId,
      );
}
