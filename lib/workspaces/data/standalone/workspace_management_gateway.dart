import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/standalone/workspaces_gateway.dart';
import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_management_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';

/// Adapter tworzenia workspace'u dla samodzielnego shella.
final class DevPlannerWorkspaceManagementGateway
    implements WorkspaceManagementGateway {
  const DevPlannerWorkspaceManagementGateway({required this.transport});

  final DevPlannerHttpTransport transport;

  @override
  Future<WorkspaceSummary> createWorkspace({required String name}) async {
    try {
      final response = await transport.execute(
        DevPlannerHttpRequest(
          method: DevPlannerHttpMethod.post,
          path: '/api/v1/workspaces/',
          body: {'name': name},
        ),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw _errorFrom(response);
      }
      try {
        return WorkspaceSummaryJson.from(response.body);
      } on FormatException {
        throw const WorkspacesGatewayException(
          reason: WorkspacesFailureReason.invalidResponse,
        );
      }
    } on DevPlannerHttpTransportException {
      throw const WorkspacesGatewayException(
        reason: WorkspacesFailureReason.transportUnavailable,
      );
    }
  }

  WorkspacesGatewayException _errorFrom(DevPlannerHttpResponse response) {
    final body = response.body;
    return WorkspacesGatewayException(
      reason: switch (response.statusCode) {
        401 => WorkspacesFailureReason.unauthorized,
        403 => WorkspacesFailureReason.forbidden,
        _ => WorkspacesFailureReason.requestFailed,
      },
      statusCode: response.statusCode,
      backendCode: body is Map && body['code'] is String
          ? body['code'] as String
          : null,
    );
  }
}
