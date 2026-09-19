import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_response.freezed.dart';
part 'project_response.g.dart';

/// Pełny, bezpieczny widok projektu zwracany przez Workspaces.
@freezed
abstract class ProjectResponse with _$ProjectResponse {
  /// Tworzy odpowiedź zgodną z `ProjectResponse`.
  const factory ProjectResponse({
    /// UUID projektu.
    required String id,

    /// UUID workspace zawierającego projekt.
    required String workspaceId,

    /// Nazwa projektu.
    required String name,

    /// Opis projektu albo null.
    String? description,

    /// Identyfikator ikony albo null.
    String? icon,

    /// Główny kolor projektu albo null.
    String? primaryColor,

    /// Widoczność projektu.
    required ProjectVisibility visibility,

    /// Status projektu.
    required ProjectStatus status,

    /// UUID twórcy projektu.
    required String createdByUserId,

    /// Rola bieżącego użytkownika albo null.
    ProjectRole? myRole,

    /// Czas utworzenia projektu.
    required DateTime createdAtUtc,

    /// Czas ostatniej aktualizacji projektu.
    required DateTime updatedAtUtc,

    /// Czas archiwizacji albo null dla aktywnego projektu.
    DateTime? archivedAtUtc,
  }) = _ProjectResponse;

  /// Odtwarza pełny projekt z odpowiedzi JSON Workspaces.
  factory ProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectResponseFromJson(json);
}
