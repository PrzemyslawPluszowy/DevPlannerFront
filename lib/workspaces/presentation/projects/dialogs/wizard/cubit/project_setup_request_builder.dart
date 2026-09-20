import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_request_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';

/// Buduje jedno żądanie kreatora dla `preview` i `create`.
///
/// Ten sam obiekt trafia do obu endpointów, więc podsumowanie pokazuje dokładnie
/// to, co powstanie, a ponowienie po timeoucie wysyła identyczne ciało żądania —
/// warunek odtworzenia wyniku z klucza idempotencji.
final class ProjectSetupRequestBuilder {
  const ProjectSetupRequestBuilder._();

  /// Zamienia draft na żądanie zgodne z `CreateProjectSetupRequest`.
  ///
  /// [currentUserId] jest wykluczony z listy członków, bo Backend zawsze nadaje
  /// twórcy rolę Ownera niezależnie od przesłanej wartości.
  /// [canManageWorkspaceCapacity] steruje wysłaniem pojemności: zapis wymaga
  /// roli Admin albo Owner w workspace.
  static CreateProjectSetupRequest build({
    required ProjectSetupDraft draft,
    required String? currentUserId,
    required bool canManageWorkspaceCapacity,
  }) {
    final creator = currentUserId?.trim();
    final assignments = <ProjectSetupMemberAssignmentRequest>[
      for (final member in draft.members)
        if (creator == null || member.userId != creator)
          ProjectSetupMemberAssignmentRequest(
            userId: member.userId,
            role: member.role,
          ),
    ];
    return CreateProjectSetupRequest(
      source: ProjectSetupSourceRequest(
        kind: draft.startKind,
        templateId: draft.usesTemplate ? draft.templateId : null,
        expectedVersion: draft.usesTemplate
            ? draft.templateExpectedVersion
            : null,
      ),
      project: ProjectSetupProjectRequest(
        name: draft.name.trim(),
        description: _emptyToNull(draft.description),
        icon: _emptyToNull(draft.iconKey),
        primaryColor: _emptyToNull(draft.colorHex),
        // Projekt z szablonu dziedziczy widoczność i status, dopóki użytkownik
        // nie wybierze ich w kroku dostępu i podstaw.
        visibility: draft.visibility,
        status: draft.status,
      ),
      memberAssignments: assignments.isEmpty ? null : assignments,
      workflow: _workflow(draft),
      taskView: ProjectSetupTaskViewRequest(
        defaultView: draft.defaultView,
        list: ProjectSetupListSettingsRequest(
          defaultSortField: draft.listSortField,
          defaultSortDirection: draft.listSortDirection,
          defaultGroupBy: draft.listGroupBy,
        ),
        board: ProjectSetupBoardSettingsRequest(
          swimlaneMode: draft.boardSwimlaneMode,
          visibleCardFields: [
            for (final field in draft.boardVisibleFields) field,
          ],
          defaultCardDensity: draft.boardDensity,
        ),
      ),
      schedule: ProjectSetupScheduleRequest(
        mode: draft.scheduleMode,
        defaultDailyCapacityMinutes: canManageWorkspaceCapacity
            ? draft.capacityMinutes
            : null,
      ),
      automationRecipeKeys: draft.recipeKeys.isEmpty
          ? null
          : [
              for (final key in ProjectSetupCatalog.automationRecipeKeys)
                if (draft.recipeKeys.contains(key)) key,
            ],
    );
  }

  /// Projekt z szablonu korzysta wyłącznie z workflow zapisanego w szablonie,
  /// więc nie wysyłamy żadnej sekcji wyboru — Backend odrzuca inne warianty.
  static ProjectSetupWorkflowRequest? _workflow(ProjectSetupDraft draft) {
    if (draft.usesTemplate) {
      return null;
    }
    return switch (draft.workflowChoice) {
      ProjectSetupWorkflowChoice.systemDefault =>
        const ProjectSetupWorkflowRequest(
          kind: ProjectSetupWorkflowKind.systemDefault,
        ),
      ProjectSetupWorkflowChoice.catalogTemplate => ProjectSetupWorkflowRequest(
        kind: ProjectSetupWorkflowKind.catalogTemplate,
        templateKey: draft.workflowTemplateKey,
      ),
      ProjectSetupWorkflowChoice.explicitStatuses =>
        ProjectSetupWorkflowRequest(
          kind: ProjectSetupWorkflowKind.explicitStatuses,
          statuses: [
            for (var index = 0; index < draft.customStatuses.length; index++)
              ProjectSetupWorkflowStatusRequest(
                name: draft.customStatuses[index].name.trim(),
                color: draft.customStatuses[index].colorHex,
                category: draft.customStatuses[index].category,
                wipLimit: draft.customStatuses[index].wipLimit,
                // Dokładnie jeden status jest domyślny; pierwszy wygrywa, gdy
                // użytkownik nie wskazał żadnego.
                isDefault: index == _defaultStatusIndex(draft),
              ),
          ],
        ),
    };
  }

  static int _defaultStatusIndex(ProjectSetupDraft draft) {
    final index = draft.customStatuses.indexWhere((status) => status.isDefault);
    return index < 0 ? 0 : index;
  }

  static String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
