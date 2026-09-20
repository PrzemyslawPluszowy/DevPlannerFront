import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';

/// Minimalny transportowy port listy projektów.
// ignore: one_member_abstracts
abstract interface class ProjectsListApi {
  /// Pobiera listę projektów z filtrem stanu i osobistego ukrycia.
  ///
  /// [includeHidden] pozostaje wspierany jako przestarzały alias (`true`
  /// odpowiada `visibility: all`); jawna wartość [visibility] ma pierwszeństwo.
  Future<DevPlannerHttpResponse> listProjects({
    required String workspaceId,
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    @Deprecated('Użyj visibility; wartość true odpowiada visibility=all.')
    bool? includeHidden,
  });
}

/// Adapter endpointu `GET /api/v1/workspaces/{workspaceId}/projects/`.
///
/// Wartości filtrów są mapowane jawnie ([ProjectListState.queryValue],
/// [ProjectListVisibility.queryValue]), bo kontrakt transportowy nie może
/// zależeć od nazw elementów enuma w Dartcie.
final class DevPlannerProjectsListApi implements ProjectsListApi {
  const DevPlannerProjectsListApi({required this.transport});

  final DevPlannerHttpTransport transport;

  @override
  Future<DevPlannerHttpResponse> listProjects({
    required String workspaceId,
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    @Deprecated('Użyj visibility; wartość true odpowiada visibility=all.')
    bool? includeHidden,
  }) {
    final effectiveVisibility = ProjectListVisibility.fromLegacy(
      visibility: visibility,
      includeHidden: includeHidden,
    );
    return transport.execute(
      DevPlannerHttpRequest(
        method: DevPlannerHttpMethod.get,
        path: '/api/v1/workspaces/$workspaceId/projects/',
        query: {
          'state': state.queryValue,
          'visibility': effectiveVisibility.queryValue,
        },
      ),
    );
  }
}
