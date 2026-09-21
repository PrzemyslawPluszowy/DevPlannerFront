import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_assignee_columns_preference.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_board_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_assignee_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_bulk_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_filter_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_preference_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_runtime_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cienka fasada publicznego API Kanbana.
///
/// Każda grupa odpowiedzialności ma własny komponent: lifecycle/realtime,
/// pojedyncze karty, preferencje/paginacja oraz operacje zbiorcze. FASADA nie
/// zna UI i jest jedynym właścicielem emisji `TasksBoardState`.
final class TasksBoardCubit extends Cubit<TasksBoardState>
    implements TasksBoardCommandContext {
  TasksBoardCubit(
    KanbanRepository repository,
    TaskProjectRealtime realtime,
    TasksRepository tasksRepository, {
    this.workflowRepository,
    this.collaborationRepository,
    this.taskTemplateRepository,
    this.memberProfilesRepository,
    this.viewPreferenceStore,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TasksBoardInitial()) {
    _runtime = TasksBoardRuntimeCoordinator(
      context: this,
      repository: repository,
      realtime: realtime,
      workflowRepository: workflowRepository,
      memberProfilesRepository: memberProfilesRepository,
    );
    _cards = TasksBoardCardCommands(
      context: this,
      tasksRepository: tasksRepository,
      collaborationRepository: collaborationRepository,
    );
    _preferences = TasksBoardPreferenceCommands(
      context: this,
      repository: repository,
      tasksRepository: tasksRepository,
      taskTemplateRepository: taskTemplateRepository,
      boardQueryRevision: () => _runtime.boardQueryRevision,
    );
    _filters = TasksBoardFilterCommands(context: this, runtime: _runtime);
    _bulk = TasksBoardBulkCommands(
      context: this,
      repository: repository,
      canMoveTaskTo: _canMoveFromBulkCommand,
    );
    _assignee = TasksBoardAssigneeCommands(
      context: this,
      repository: repository,
      viewPreferenceStore:
          viewPreferenceStore ?? const _VolatileViewPreferenceStore(),
    );
  }

  final TaskWorkflowRepository? workflowRepository;
  final TaskCollaborationRepository? collaborationRepository;
  final TaskTemplateRepository? taskTemplateRepository;
  final ProjectMemberProfilesRepository? memberProfilesRepository;

  /// Osobiste preferencje widoku tablicy (grupowanie, widoczność kolumn osób);
  /// brak adaptera oznacza wybór tylko w pamięci bieżącej sesji.
  final TasksBoardViewPreferenceStore? viewPreferenceStore;
  @override
  final String workspaceId;
  @override
  final String projectId;
  late final TasksBoardRuntimeCoordinator _runtime;
  late final TasksBoardCardCommands _cards;
  late final TasksBoardPreferenceCommands _preferences;
  late final TasksBoardFilterCommands _filters;
  late final TasksBoardBulkCommands _bulk;
  late final TasksBoardAssigneeCommands _assignee;

  @override
  TasksBoardState get currentState => state;

  @override
  bool get isBoardClosed => isClosed;

  @override
  void publish(TasksBoardState state) {
    final previous = this.state;
    emit(state);
    // Zmiana z innej sesji podnosi licznik realtime; przy aktywnym widoku osób
    // grupy trzeba przeczytać ponownie, bo event nie niesie ich stanu.
    if (state is TasksBoardReady &&
        previous is TasksBoardReady &&
        state.realtimeRevision != previous.realtimeRevision) {
      _assignee.refreshAfterRealtime();
    }
  }

  @override
  Future<void> reloadBoard({bool force = false}) => load(force: force);

  @override
  Future<void> reloadActiveBoard({bool force = false}) async {
    await _runtime.load(force: force);
    // Tablica osób trzyma własny snapshot grup, więc odświeżenie kolumn statusów
    // samo nie odświeży tego, co użytkownik ma na ekranie.
    await _assignee.reloadAfterFilterChange();
  }

  Future<void> load({bool force = false}) => _runtime.load(force: force);
  Future<void> start() async {
    await _runtime.start();
    await _assignee.restore();
  }

  Future<void> refreshWorkflow() => _runtime.refreshWorkflow();

  Future<bool> togglePinned(KanbanTaskCardResponse task) =>
      _cards.togglePinned(task);
  Future<bool> toggleWatching(KanbanTaskCardResponse task) =>
      _cards.toggleWatching(task);
  Future<bool> updateTaskPriority(String taskId, TaskPriority priority) =>
      _cards.updatePriority(taskId, priority);
  Future<bool> updateTaskDueDate(String taskId, DateTime? dueAtUtc) =>
      _cards.updateDueDate(taskId, dueAtUtc);
  Future<bool> replaceTaskAssignees(String taskId, List<String> userIds) =>
      _cards.replaceAssignees(taskId, userIds);
  void applyRecurrenceMutation(
    KanbanTaskCardResponse task,
    TaskMutationResponse<TaskRecurrenceResponse> mutation,
  ) => _cards.applyRecurrenceMutation(task, mutation);

  Future<void> toggleColumnCollapsed(KanbanColumnResponse column) =>
      _preferences.toggleColumnCollapsed(column);
  Future<void> setQuickFilter(KanbanQuickFilter quickFilter) =>
      _preferences.setQuickFilter(quickFilter);

  /// Ponawia ostatnią nieudaną operację widoku.
  ///
  /// Najpierw próbuje donieść zaparkowane intencje użytkownika, a gdy ich nie ma
  /// (np. nie udał się sam odczyt preferencji), ponawia odczyt.
  Future<void> retryFailedOperation() async {
    if (_preferences.hasPendingIntents) {
      await _preferences.retryPending();
      return;
    }
    await _runtime.reloadUserPreference();
  }

  /// Ukrywa komunikat błędu widoku.
  void clearViewError() {
    final current = state;
    if (current is TasksBoardReady) {
      publish(
        current.copyWith(clearError: true, failedTaskIds: const <String>{}),
      );
    }
  }

  /// Ustawia filtr wykonawcy tablicy; `null` czyści ten wymiar.
  Future<void> setFilterAssignee(String? assigneeUserId) async {
    await _filters.setAssignee(assigneeUserId);
    await _assignee.reloadAfterFilterChange();
  }

  /// Ustawia filtr priorytetu tablicy; `null` czyści ten wymiar.
  Future<void> setFilterPriority(TaskPriority? priority) async {
    await _filters.setPriority(priority);
    await _assignee.reloadAfterFilterChange();
  }

  /// Ustawia filtr kamienia milowego tablicy; `null` czyści ten wymiar.
  Future<void> setFilterMilestone(String? milestoneId) async {
    await _filters.setMilestone(milestoneId);
    await _assignee.reloadAfterFilterChange();
  }

  /// Ustawia filtr statusu kart (systemowy albo własny); bez argumentów czyści.
  ///
  /// W widoku osób status jest filtrem kart — kolumnę opisuje tam osoba.
  Future<void> setFilterStatusColumn({
    ProjectTaskStatus? status,
    String? customStatusId,
  }) async {
    await _filters.setStatusColumn(
      status: status,
      customStatusId: customStatusId,
    );
    await _assignee.reloadAfterFilterChange();
  }

  /// Czyści wszystkie filtry tablicy i wraca do pełnego projektu.
  Future<void> clearFilters() async {
    await _filters.clearFilters();
    await _assignee.reloadAfterFilterChange();
  }

  Future<void> loadMore(KanbanColumnResponse column) =>
      _preferences.loadMore(column);

  /// Przełącza grupowanie kolumn tablicy.
  ///
  /// Każdy widok zdejmuje filtr, którego kontrolka w nim znika — inaczej filtr
  /// zawężałby zawartość kolumn bez widocznej przyczyny:
  /// - widok osób: filtr wykonawcy (osoba jest tam kolumną),
  /// - widok statusów: filtr statusu (kolumna sama jest statusem).
  /// Pozostałe wymiary zostają i żaden z tych filtrów nie wraca sam.
  Future<void> setGrouping(TasksBoardGrouping grouping) async {
    final current = state;
    if (current is TasksBoardReady) {
      if (grouping == TasksBoardGrouping.assignee &&
          current.filter.assigneeUserId != null) {
        await _filters.setAssignee(null);
      }
      if (grouping == TasksBoardGrouping.status &&
          (current.filter.status != null ||
              current.filter.customStatusId != null)) {
        await _filters.setStatusColumn();
      }
    }
    await _assignee.setGrouping(grouping);
  }

  /// Doładowuje kolejną stronę jednej kolumny osoby.
  Future<void> loadMoreAssigneeGroup(AssigneeKanbanGroupResponse group) =>
      _assignee.loadMore(group);

  /// Pokazuje albo ukrywa kolumnę osoby w widoku grupowania po osobach.
  ///
  /// W widoku osób osoba opisuje kolumnę, więc widoczność kolumn zastępuje tam
  /// filtr wykonawcy: użytkownik nie filtruje kart po osobie, tylko decyduje,
  /// które kolumny widzi.
  Future<void> setAssigneeColumnVisible({
    required String groupKey,
    required bool visible,
  }) => _assignee.setAssigneeColumnVisible(
    groupKey: groupKey,
    visible: visible,
  );

  /// Włącza albo wyłącza ukrywanie kolumn osób bez zadań.
  Future<void> setHideEmptyAssigneeColumns(bool hideEmpty) =>
      _assignee.setHideEmptyAssigneeColumns(hideEmpty);

  /// Przywraca widoczność wszystkich kolumn osób.
  Future<void> showAllAssigneeColumns() => _assignee.showAllAssigneeColumns();

  /// Przenosi kartę do kolumny osoby bez zmiany statusu zadania.
  Future<bool> moveTaskToAssignee({
    required KanbanTaskCardResponse task,
    required String? targetUserId,
  }) => _assignee.moveToAssignee(task: task, targetUserId: targetUserId);
  Future<bool> createQuickTask({
    required KanbanColumnResponse column,
    required String title,
    String? taskTemplateId,
    bool useDefaultTemplate = true,
  }) => _preferences.createQuickTask(
    column: column,
    title: title,
    taskTemplateId: taskTemplateId,
    useDefaultTemplate: useDefaultTemplate,
  );
  Future<bool> applyTaskTemplate({
    required String templateId,
    required String title,
  }) => _preferences.applyTaskTemplate(templateId: templateId, title: title);

  void toggleTaskSelection(KanbanTaskCardResponse task) =>
      _bulk.toggleSelection(task);
  void clearTaskSelection() => _bulk.clearSelection();
  void selectAllLoadedTasks() => _bulk.selectAllLoaded();
  Future<void> bulkMoveTasks(KanbanColumnResponse targetColumn) =>
      _bulk.bulkMove(targetColumn);
  Future<void> bulkUpdatePriority(TaskPriority priority) =>
      _bulk.bulkUpdatePriority(priority);
  Future<void> bulkUpdateDueDate(DateTime dueAtUtc) =>
      _bulk.bulkUpdateDueDate(dueAtUtc);
  Future<void> moveTask({
    required KanbanTaskCardResponse task,
    required KanbanColumnResponse targetColumn,
    required int targetIndex,
  }) => _bulk.move(
    task: task,
    targetColumn: targetColumn,
    targetIndex: targetIndex,
  );

  bool canMoveTaskTo({
    required KanbanTaskCardResponse task,
    required KanbanColumnResponse targetColumn,
  }) => _runtime.canMoveTaskTo(task: task, targetColumn: targetColumn);

  bool _canMoveFromBulkCommand({
    required KanbanTaskCardResponse task,
    required KanbanColumnResponse targetColumn,
  }) => canMoveTaskTo(task: task, targetColumn: targetColumn);

  @override
  Future<void> close() async {
    _assignee.reset();
    await _runtime.dispose();
    return super.close();
  }
}

/// Preferencje widoku używane, gdy kompozycja nie dostarczyła adaptera.
///
/// Wybór działa wtedy w pamięci bieżącej sesji (stan żyje w Cubicie):
/// przełącznik i ukrywanie kolumn nie mogą zniknąć tylko dlatego, że platforma
/// nie ma trwałego storage.
final class _VolatileViewPreferenceStore
    implements TasksBoardViewPreferenceStore {
  const _VolatileViewPreferenceStore();

  @override
  Future<TasksBoardGrouping?> readGrouping({
    required String workspaceId,
    required String projectId,
  }) async => null;

  @override
  Future<void> writeGrouping({
    required String workspaceId,
    required String projectId,
    required TasksBoardGrouping grouping,
  }) async {}

  @override
  Future<TasksBoardAssigneeColumnsPreference> readAssigneeColumns({
    required String workspaceId,
    required String projectId,
  }) async => const TasksBoardAssigneeColumnsPreference();

  @override
  Future<void> writeAssigneeColumns({
    required String workspaceId,
    required String projectId,
    required TasksBoardAssigneeColumnsPreference preference,
  }) async {}
}
