import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';

/// Stabilne powody błędu katalogu, mapowane na komunikaty dopiero w UI.
enum WorkspacesFailureReason {
  transportUnavailable,
  unauthorized,
  forbidden,
  requestFailed,
  invalidResponse,
}

/// Błąd kontraktu katalogu workspace zachowujący status HTTP i kod backendu.
final class WorkspacesGatewayException implements Exception {
  const WorkspacesGatewayException({
    required this.reason,
    this.statusCode,
    this.backendCode,
  });

  final WorkspacesFailureReason reason;
  final int? statusCode;
  final String? backendCode;

  @override
  String toString() =>
      'WorkspacesGatewayException(reason: $reason, status: $statusCode, code: $backendCode)';
}

/// Port odczytu katalogu workspace dla rootowego ekranu aplikacji.
// ignore: one_member_abstracts
abstract interface class WorkspacesGateway {
  Future<List<WorkspaceSummary>> listWorkspaces();
}
