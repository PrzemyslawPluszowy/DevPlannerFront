import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';

/// Wąski kontrakt mutacji katalogu używany przez nowe menu.
///
/// Nie udostępnia historycznego repozytorium ekranu katalogu shellowi.
// ignore: one_member_abstracts
abstract interface class WorkspaceManagementGateway {
  Future<WorkspaceSummary> createWorkspace({required String name});
}
