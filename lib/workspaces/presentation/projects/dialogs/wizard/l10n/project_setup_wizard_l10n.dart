import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';

/// Tłumaczenia kreatora projektu.
///
/// Jedno miejsce mapujące stabilne kody, enumy i klucze katalogów na teksty
/// ARB. Dzięki temu widgety nie zawierają łańcuchów `switch` ani żadnych
/// hardkodowanych tekstów, a klucze katalogowe Backendu nigdy nie wyciekają
/// do interfejsu.
final class ProjectSetupWizardL10n {
  const ProjectSetupWizardL10n._();

  /// Nazwa kroku kreatora.
  static String stepTitle(AppLocalizations l10n, ProjectSetupStep step) =>
      switch (step) {
        ProjectSetupStep.start => l10n.projectSetupStepStartTitle,
        ProjectSetupStep.basics => l10n.projectSetupStepBasicsTitle,
        ProjectSetupStep.access => l10n.projectSetupStepAccessTitle,
        ProjectSetupStep.workflow => l10n.projectSetupStepWorkflowTitle,
        ProjectSetupStep.workingStyle => l10n.projectSetupStepWorkingStyleTitle,
        ProjectSetupStep.starterFeatures =>
          l10n.projectSetupStepStarterFeaturesTitle,
        ProjectSetupStep.summary => l10n.projectSetupStepSummaryTitle,
      };

  /// Nazwa katalogowego szablonu workflow.
  ///
  /// Nieznany klucz pokazujemy dosłownie, żeby nowy wpis Backendu nie zniknął
  /// z kreatora bez śladu.
  static String workflowTemplateName(AppLocalizations l10n, String key) =>
      switch (key) {
        'standard' => l10n.projectSetupWorkflowCatalogStandard,
        'marketing' => l10n.projectSetupWorkflowCatalogMarketing,
        'production' => l10n.projectSetupWorkflowCatalogProduction,
        'hr' => l10n.projectSetupWorkflowCatalogHr,
        'software' => l10n.projectSetupWorkflowCatalogSoftware,
        _ => key,
      };

  /// Nazwa przepisu automatyzacji z katalogu Backendu.
  static String recipeName(AppLocalizations l10n, String key) => switch (key) {
    'critical-to-blocked' => l10n.projectSetupRecipeCriticalToBlocked,
    'due-soon-high-priority' => l10n.projectSetupRecipeDueSoonHighPriority,
    'done-clear-due-date' => l10n.projectSetupRecipeDoneClearDueDate,
    'done-create-review-subtask' =>
      l10n.projectSetupRecipeDoneCreateReviewSubtask,
    _ => key,
  };

  /// Opis przepisu automatyzacji z katalogu Backendu.
  static String recipeDescription(AppLocalizations l10n, String key) =>
      switch (key) {
        'critical-to-blocked' =>
          l10n.projectSetupRecipeCriticalToBlockedDescription,
        'due-soon-high-priority' =>
          l10n.projectSetupRecipeDueSoonHighPriorityDescription,
        'done-clear-due-date' =>
          l10n.projectSetupRecipeDoneClearDueDateDescription,
        'done-create-review-subtask' =>
          l10n.projectSetupRecipeDoneCreateReviewSubtaskDescription,
        _ => key,
      };

  /// Nazwa kategorii analitycznej jawnego statusu.
  static String statusCategory(
    AppLocalizations l10n,
    TaskStatusCategory category,
  ) => switch (category) {
    TaskStatusCategory.todo => l10n.projectSetupStatusCategoryTodo,
    TaskStatusCategory.inProgress => l10n.projectSetupStatusCategoryInProgress,
    TaskStatusCategory.done => l10n.projectSetupStatusCategoryDone,
    TaskStatusCategory.cancelled => l10n.projectSetupStatusCategoryCancelled,
  };

  /// Nazwa statusu projektu.
  static String projectStatus(AppLocalizations l10n, ProjectStatus status) =>
      switch (status) {
        ProjectStatus.planned => l10n.projectSetupProjectStatusPlanned,
        ProjectStatus.active => l10n.projectSetupProjectStatusActive,
        ProjectStatus.onHold => l10n.projectSetupProjectStatusOnHold,
        ProjectStatus.completed => l10n.projectSetupProjectStatusCompleted,
      };

  /// Nazwa widoczności projektu.
  static String visibility(
    AppLocalizations l10n,
    ProjectVisibility visibility,
  ) => switch (visibility) {
    ProjectVisibility.shared => l10n.workspacesProjectVisibilityShared,
    ProjectVisibility.private => l10n.workspacesProjectVisibilityPrivate,
  };

  /// Nazwa trybu harmonogramu.
  static String scheduleMode(AppLocalizations l10n, AutoScheduleMode mode) =>
      switch (mode) {
        AutoScheduleMode.manual => l10n.projectSetupScheduleManual,
        AutoScheduleMode.pushSuccessorsOnly =>
          l10n.projectSetupSchedulePushSuccessors,
        AutoScheduleMode.strictCascade =>
          l10n.projectSetupScheduleStrictCascade,
      };

  /// Nazwa pola kafelka Kanban.
  static String cardField(AppLocalizations l10n, KanbanCardField field) =>
      switch (field) {
        KanbanCardField.assignee => l10n.projectSetupCardFieldAssignee,
        KanbanCardField.dueDate => l10n.projectSetupCardFieldDueDate,
        KanbanCardField.labels => l10n.projectSetupCardFieldLabels,
        KanbanCardField.checklist => l10n.projectSetupCardFieldChecklist,
        KanbanCardField.subtasks => l10n.projectSetupCardFieldSubtasks,
        KanbanCardField.timeTracking => l10n.projectSetupCardFieldTimeTracking,
        KanbanCardField.blockers => l10n.projectSetupCardFieldBlockers,
        KanbanCardField.coverAttachment =>
          l10n.projectSetupCardFieldCoverAttachment,
        KanbanCardField.customFields => l10n.projectSetupCardFieldCustomFields,
      };

  /// Nazwa gęstości kafelka Kanban.
  static String cardDensity(AppLocalizations l10n, KanbanCardDensity density) =>
      switch (density) {
        KanbanCardDensity.compact => l10n.projectSetupDensityCompact,
        KanbanCardDensity.comfortable => l10n.projectSetupDensityComfortable,
        KanbanCardDensity.detailed => l10n.projectSetupDensityDetailed,
      };

  /// Nazwa trybu torów Kanban.
  static String swimlaneMode(
    AppLocalizations l10n,
    KanbanSwimlaneMode mode,
  ) => switch (mode) {
    KanbanSwimlaneMode.none => l10n.projectSetupSwimlaneNone,
    KanbanSwimlaneMode.assignee => l10n.projectSetupSwimlaneAssignee,
    KanbanSwimlaneMode.priority => l10n.projectSetupSwimlanePriority,
    KanbanSwimlaneMode.milestone => l10n.projectSetupSwimlaneMilestone,
  };

  /// Nazwa pola sortowania listy.
  static String listSortField(
    AppLocalizations l10n,
    TaskSavedViewSortField field,
  ) => switch (field) {
    TaskSavedViewSortField.position => l10n.projectSetupListSortFieldPosition,
    TaskSavedViewSortField.updatedAtUtc =>
      l10n.projectSetupListSortFieldUpdatedAt,
    TaskSavedViewSortField.dueAtUtc => l10n.projectSetupListSortFieldDueAt,
    TaskSavedViewSortField.priority => l10n.projectSetupListSortFieldPriority,
    TaskSavedViewSortField.title => l10n.projectSetupListSortFieldTitle,
  };

  /// Nazwa kierunku sortowania listy.
  static String listSortDirection(
    AppLocalizations l10n,
    TaskSavedViewSortDirection direction,
  ) => switch (direction) {
    TaskSavedViewSortDirection.ascending =>
      l10n.projectSetupListSortDirectionAscending,
    TaskSavedViewSortDirection.descending =>
      l10n.projectSetupListSortDirectionDescending,
  };

  /// Nazwa grupowania listy.
  static String listGroupBy(
    AppLocalizations l10n,
    TaskSavedViewGroupBy groupBy,
  ) => switch (groupBy) {
    TaskSavedViewGroupBy.none => l10n.projectSetupListGroupByNone,
    TaskSavedViewGroupBy.status => l10n.projectSetupListGroupByStatus,
    TaskSavedViewGroupBy.customStatus =>
      l10n.projectSetupListGroupByCustomStatus,
    TaskSavedViewGroupBy.priority => l10n.projectSetupListGroupByPriority,
    TaskSavedViewGroupBy.assignee => l10n.projectSetupListGroupByAssignee,
  };

  /// Nazwa domyślnego widoku modułu Zadania.
  static String taskView(
    AppLocalizations l10n,
    ProjectSetupTaskViewKind view,
  ) => switch (view) {
    ProjectSetupTaskViewKind.list => l10n.projectSetupViewList,
    ProjectSetupTaskViewKind.board => l10n.projectSetupViewBoard,
  };

  /// Komunikat błędu walidacji przy konkretnym polu.
  static String validationError(
    AppLocalizations l10n,
    ProjectSetupValidationError error,
  ) => switch (error) {
    ProjectSetupValidationError.nameRequired =>
      l10n.projectSetupValidationNameRequired,
    ProjectSetupValidationError.nameTooLong =>
      l10n.projectSetupValidationNameTooLong,
    ProjectSetupValidationError.descriptionTooLong =>
      l10n.projectSetupValidationDescriptionTooLong,
    ProjectSetupValidationError.templateRequired =>
      l10n.projectSetupValidationTemplateRequired,
    ProjectSetupValidationError.memberDuplicated =>
      l10n.projectSetupValidationMemberDuplicated,
    ProjectSetupValidationError.statusNameRequired =>
      l10n.projectSetupValidationStatusNameRequired,
    ProjectSetupValidationError.statusNameInvalid =>
      l10n.projectSetupValidationStatusNameInvalid,
    ProjectSetupValidationError.statusesLimitExceeded =>
      l10n.projectSetupValidationStatusesLimitExceeded,
    ProjectSetupValidationError.statusWipInvalid =>
      l10n.projectSetupValidationStatusWipInvalid,
    ProjectSetupValidationError.capacityOutOfRange =>
      l10n.projectSetupValidationCapacityOutOfRange,
    ProjectSetupValidationError.boardFieldsRequired =>
      l10n.projectSetupValidationBoardFieldsRequired,
  };

  /// Komunikat ostrzeżenia planu po jego stabilnym kodzie.
  ///
  /// Nieznany kod pokazuje komunikat Backendu, żeby nowe ostrzeżenie nie
  /// zniknęło po cichu.
  static String warning(
    AppLocalizations l10n, {
    required String code,
    required String backendMessage,
  }) => switch (code) {
    'project_setup.members_ignored_for_shared' =>
      l10n.projectSetupWarningMembersIgnoredForShared,
    'project_setup.private_members_limited' =>
      l10n.projectSetupWarningPrivateMembersLimited,
    'project_setup.template_fields_overridden' =>
      l10n.projectSetupWarningTemplateFieldsOverridden,
    'project_setup.workspace_capacity_changed' =>
      l10n.projectSetupWarningWorkspaceCapacityChanged,
    _ => backendMessage,
  };
}
