import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';

/// Port katalogu używanego przez drzewo nawigacji.
///
/// Port jest celowo węższy niż przyszłe źródło projektów. Dzięki temu menu nie
/// dostaje dostępu do HTTP ani do DTO, a brak lokalnego kontraktu projektów
/// pozostaje widoczny zamiast być ukryty przez dane testowe.
// ignore: one_member_abstracts
abstract interface class WorkspaceNavigationGateway {
  Future<List<WorkspaceSummary>> listWorkspaces();
}
