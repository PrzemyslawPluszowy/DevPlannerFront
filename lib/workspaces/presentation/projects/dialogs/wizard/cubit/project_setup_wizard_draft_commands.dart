import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Komendy edycji draftu kreatora projektu.
///
/// Mixin trzyma wyłącznie lokalne mutacje draftu, dzięki czemu plik kontrolera
/// opisuje lifecycle kreatora (ładowanie, kroki, plan, submit), a ten plik —
/// pojedyncze pola formularza. Każda mutacja przelicza błędy tylko tych pól,
/// które użytkownik właśnie zmienił.
mixin ProjectSetupWizardDraftCommands on Cubit<ProjectSetupWizardState> {
  /// Zapisuje draft i przelicza błędy walidacji dla zmienionych pól.
  ///
  /// Implementuje kontroler; mixin nie wie, jak powstaje stan kreatora.
  @protected
  void applyDraft(
    ProjectSetupDraft draft, {
    Set<ProjectSetupField> touched = const <ProjectSetupField>{},
  });

  /// Zmienia nazwę projektu.
  void setName(String value) => applyDraft(
    state.draft.copyWith(name: value),
    touched: {ProjectSetupField.name},
  );

  /// Zmienia opis projektu.
  void setDescription(String value) => applyDraft(
    state.draft.copyWith(description: value),
    touched: {ProjectSetupField.name},
  );

  /// Zmienia ikonę projektu.
  void setIconKey(String value) =>
      applyDraft(state.draft.copyWith(iconKey: value));

  /// Zmienia kolor główny projektu.
  void setColorHex(String value) =>
      applyDraft(state.draft.copyWith(colorHex: value));

  /// Zmienia status początkowy projektu.
  void setStatus(ProjectStatus value) =>
      applyDraft(state.draft.copyWith(status: value));

  /// Wybiera pusty projekt.
  void selectBlankStart() => applyDraft(
    state.draft.copyWith(
      startKind: ProjectSetupSourceKind.blank,
      clearTemplate: true,
    ),
    touched: {ProjectSetupField.template},
  );

  /// Wybiera szablon całego projektu jako źródło.
  void selectTemplateStart(
    String templateId, {
    String? templateName,
    int? version,
  }) {
    final preview = state.templatePreviews[templateId];
    applyDraft(
      state.draft.copyWith(
        startKind: ProjectSetupSourceKind.projectTemplate,
        templateId: templateId,
        templateExpectedVersion: preview?.version ?? version,
        templateName: preview?.name ?? templateName,
        // Snapshot szablonu jest widoczny od razu: dopóki użytkownik nie zmieni
        // kroku dostępu, plan dziedziczy widoczność i status szablonu.
        visibility: preview == null
            ? state.draft.visibility
            : visibilityFromWire(preview.visibility),
        status: preview == null
            ? state.draft.status
            : statusFromWire(preview.status),
        workflowChoice: ProjectSetupWorkflowChoice.systemDefault,
      ),
      touched: {ProjectSetupField.template},
    );
  }

  /// Wybiera widoczność projektu.
  void setVisibility(ProjectVisibility value) =>
      applyDraft(state.draft.copyWith(visibility: value));

  /// Dodaje albo usuwa początkowego członka projektu Private.
  void toggleMember(String userId, {ProjectRole role = ProjectRole.member}) {
    final current = state.draft.members;
    final exists = current.any((member) => member.userId == userId);
    final next = exists
        ? [
            for (final member in current)
              if (member.userId != userId) member,
          ]
        : [...current, ProjectSetupMemberSelection(userId: userId, role: role)];
    applyDraft(
      state.draft.copyWith(members: List.unmodifiable(next)),
      touched: {ProjectSetupField.members},
    );
  }

  /// Zmienia rolę wybranego członka projektu.
  void setMemberRole(String userId, ProjectRole role) => applyDraft(
    state.draft.copyWith(
      members: List.unmodifiable([
        for (final member in state.draft.members)
          if (member.userId == userId) member.withRole(role) else member,
      ]),
    ),
  );

  /// Wybiera źródło workflow.
  void setWorkflowChoice(ProjectSetupWorkflowChoice choice) {
    final draft = state.draft.copyWith(workflowChoice: choice);
    // Jawne statusy startują z jednym sensownym wierszem, żeby krok nie zaczynał
    // się od błędu walidacji bez powodu.
    final withStatuses =
        choice == ProjectSetupWorkflowChoice.explicitStatuses &&
            draft.customStatuses.isEmpty
        ? draft.copyWith(
            customStatuses: [
              const ProjectSetupCustomStatusDraft(
                name: '',
                colorHex: '#64748B',
                category: TaskStatusCategory.todo,
                isDefault: true,
              ),
            ],
          )
        : draft;
    applyDraft(withStatuses, touched: {ProjectSetupField.customStatuses});
  }

  /// Wybiera katalogowy szablon workflow.
  void setWorkflowTemplateKey(String key) =>
      applyDraft(state.draft.copyWith(workflowTemplateKey: key));

  /// Dodaje jawny status workflow.
  void addCustomStatus() {
    final statuses = [
      ...state.draft.customStatuses,
      ProjectSetupCustomStatusDraft(
        name: '',
        colorHex: '#64748B',
        category: TaskStatusCategory.todo,
        isDefault: state.draft.customStatuses.isEmpty,
      ),
    ];
    applyDraft(
      state.draft.copyWith(customStatuses: List.unmodifiable(statuses)),
      touched: {ProjectSetupField.customStatuses},
    );
  }

  /// Usuwa jawny status workflow.
  void removeCustomStatus(int index) {
    final statuses = [...state.draft.customStatuses]..removeAt(index);
    final next = statuses.isEmpty || statuses.any((status) => status.isDefault)
        ? statuses
        : [
            statuses.first.copyWith(isDefault: true),
            ...statuses.skip(1),
          ];
    applyDraft(
      state.draft.copyWith(customStatuses: List.unmodifiable(next)),
      touched: {ProjectSetupField.customStatuses},
    );
  }

  /// Podmienia jawny status workflow.
  void updateCustomStatus(int index, ProjectSetupCustomStatusDraft status) {
    final statuses = [...state.draft.customStatuses];
    statuses[index] = status;
    final next = status.isDefault
        ? [
            for (var i = 0; i < statuses.length; i++)
              if (i == index)
                statuses[i]
              else
                statuses[i].copyWith(isDefault: false),
          ]
        : statuses;
    applyDraft(
      state.draft.copyWith(customStatuses: List.unmodifiable(next)),
      touched: {ProjectSetupField.customStatuses},
    );
  }

  /// Wybiera domyślne pole sortowania listy zadań.
  void setListSortField(TaskSavedViewSortField value) =>
      applyDraft(state.draft.copyWith(listSortField: value));

  /// Wybiera domyślny kierunek sortowania listy zadań.
  void setListSortDirection(TaskSavedViewSortDirection value) =>
      applyDraft(state.draft.copyWith(listSortDirection: value));

  /// Wybiera domyślne grupowanie listy zadań.
  void setListGroupBy(TaskSavedViewGroupBy value) =>
      applyDraft(state.draft.copyWith(listGroupBy: value));

  /// Wybiera domyślny widok modułu Zadania.
  void setDefaultView(ProjectSetupTaskViewKind view) =>
      applyDraft(state.draft.copyWith(defaultView: view));

  /// Wybiera tryb harmonogramowania projektu.
  void setScheduleMode(AutoScheduleMode mode) =>
      applyDraft(state.draft.copyWith(scheduleMode: mode));

  /// Ustawia dzienną pojemność workspace; `null` czyści wartość.
  void setCapacityMinutes(int? minutes) => applyDraft(
    minutes == null
        ? state.draft.copyWith(clearCapacity: true)
        : state.draft.copyWith(capacityMinutes: minutes),
    touched: {ProjectSetupField.capacity},
  );

  /// Wybiera sposób grupowania kart Kanban.
  void setBoardSwimlaneMode(KanbanSwimlaneMode mode) =>
      applyDraft(state.draft.copyWith(boardSwimlaneMode: mode));

  /// Wybiera gęstość kafelka Kanban.
  void setBoardDensity(KanbanCardDensity density) =>
      applyDraft(state.draft.copyWith(boardDensity: density));

  /// Włącza albo wyłącza pole widoczne na kafelku Kanban.
  void toggleBoardField(KanbanCardField field) {
    final fields = {...state.draft.boardVisibleFields};
    if (!fields.remove(field)) fields.add(field);
    applyDraft(
      state.draft.copyWith(boardVisibleFields: Set.unmodifiable(fields)),
      touched: {ProjectSetupField.boardFields},
    );
  }

  /// Włącza albo wyłącza przepis automatyzacji do instalacji.
  void toggleRecipe(String key) {
    final keys = {...state.draft.recipeKeys};
    if (!keys.remove(key)) keys.add(key);
    applyDraft(state.draft.copyWith(recipeKeys: Set.unmodifiable(keys)));
  }

  static ProjectVisibility visibilityFromWire(String value) =>
      value == 'Shared' ? ProjectVisibility.shared : ProjectVisibility.private;

  static ProjectStatus statusFromWire(String value) => switch (value) {
    'Planned' => ProjectStatus.planned,
    'OnHold' => ProjectStatus.onHold,
    'Completed' => ProjectStatus.completed,
    _ => ProjectStatus.active,
  };
}
