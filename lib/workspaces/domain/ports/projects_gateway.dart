import 'package:devplanner/workspaces/domain/models/project_list_item.dart';

/// Stabilne powody odmowy/awarii katalogu projektów.
enum ProjectsFailureReason {
  transportUnavailable,
  unauthorized,
  forbidden,
  notFound,
  requestFailed,
  invalidResponse,
}

/// Błąd listy projektów bez przecieku wyjątku transportowego do UI.
final class ProjectsGatewayException implements Exception {
  const ProjectsGatewayException({
    required this.reason,
    this.statusCode,
    this.backendCode,
    this.message,
    this.traceId,
  });

  final ProjectsFailureReason reason;
  final int? statusCode;
  final String? backendCode;
  final String? message;
  final String? traceId;

  @override
  String toString() =>
      'ProjectsGatewayException(reason: $reason, status: $statusCode, '
      'code: $backendCode, traceId: $traceId)';
}

/// Port leniwego katalogu projektów jednego workspace’u.
// ignore: one_member_abstracts
abstract interface class ProjectsGateway {
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  });
}
