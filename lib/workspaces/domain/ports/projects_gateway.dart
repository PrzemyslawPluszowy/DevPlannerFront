import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';

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
  /// Pobiera projekty jednego workspace’u zgodnie z filtrem stanu i ukrycia.
  ///
  /// [includeHidden] jest przestarzałym aliasem: `true` odpowiada
  /// `visibility: all`, a jawna wartość [visibility] ma pierwszeństwo.
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    @Deprecated('Użyj visibility; wartość true odpowiada visibility=all.')
    bool? includeHidden,
  });
}
