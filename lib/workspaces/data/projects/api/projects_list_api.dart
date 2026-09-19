import 'package:devplanner/foundation/http/devplanner_http_transport.dart';

/// Minimalny transportowy port listy projektów.
// ignore: one_member_abstracts
abstract interface class ProjectsListApi {
  Future<DevPlannerHttpResponse> listProjects({
    required String workspaceId,
    bool includeHidden = false,
  });
}

/// Adapter endpointu `GET /api/v1/workspaces/{workspaceId}/projects/`.
final class DevPlannerProjectsListApi implements ProjectsListApi {
  const DevPlannerProjectsListApi({required this.transport});

  final DevPlannerHttpTransport transport;

  @override
  Future<DevPlannerHttpResponse> listProjects({
    required String workspaceId,
    bool includeHidden = false,
  }) => transport.execute(
    DevPlannerHttpRequest(
      method: DevPlannerHttpMethod.get,
      path: '/api/v1/workspaces/$workspaceId/projects/',
      query: {'includeHidden': includeHidden.toString()},
    ),
  );
}
