import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';

/// Adapter lokalnego kontraktu `GET /api/v1/workspaces/`.
final class DevPlannerWorkspacesGateway implements WorkspacesGateway {
  const DevPlannerWorkspacesGateway({required this.transport});

  final DevPlannerHttpTransport transport;

  @override
  Future<List<WorkspaceSummary>> listWorkspaces() async {
    try {
      final response = await transport.execute(
        const DevPlannerHttpRequest(
          method: DevPlannerHttpMethod.get,
          path: '/api/v1/workspaces/',
          query: {'includeHidden': 'false'},
        ),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw _errorFrom(response);
      }
      final body = response.body;
      if (body is! List) {
        throw const WorkspacesGatewayException(
          reason: WorkspacesFailureReason.invalidResponse,
        );
      }
      try {
        return body.map(WorkspaceSummaryJson.from).toList(growable: false);
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
    if (body is Map) {
      final code = body['code'];
      return WorkspacesGatewayException(
        reason: switch (response.statusCode) {
          401 => WorkspacesFailureReason.unauthorized,
          403 => WorkspacesFailureReason.forbidden,
          _ => WorkspacesFailureReason.requestFailed,
        },
        statusCode: response.statusCode,
        backendCode: code is String ? code : null,
      );
    }
    return WorkspacesGatewayException(
      reason: switch (response.statusCode) {
        401 => WorkspacesFailureReason.unauthorized,
        403 => WorkspacesFailureReason.forbidden,
        _ => WorkspacesFailureReason.requestFailed,
      },
      statusCode: response.statusCode,
    );
  }
}

/// Parser lokalnego DTO pozostaje w warstwie data, poza widgetem i Cubitem.
final class WorkspaceSummaryJson {
  const WorkspaceSummaryJson._();

  static WorkspaceSummary from(Object? value) {
    if (value is! Map) {
      throw const FormatException();
    }
    final id = value['id'];
    final name = value['name'];
    if (id is! String ||
        id.trim().isEmpty ||
        name is! String ||
        name.trim().isEmpty) {
      throw const FormatException();
    }
    return WorkspaceSummary(
      id: id,
      name: name,
      description: value['description'] is String
          ? value['description'] as String
          : null,
      isPinned: value['isPinned'] == true,
      isHidden: value['isHidden'] == true,
      isOwner: value['isOwner'] == true,
    );
  }
}
