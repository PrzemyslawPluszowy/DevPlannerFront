import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_bulk_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_card_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
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
    _bulk = TasksBoardBulkCommands(
      context: this,
      repository: repository,
      canMoveTaskTo: _canMoveFromBulkCommand,
    );
  }

  final TaskWorkflowRepository? workflowRepository;
  final TaskCollaborationRepository? collaborationRepository;
  final TaskTemplateRepository? taskTemplateRepository;
  final ProjectMemberProfilesRepository? memberProfilesRepository;
  @override
  final String workspaceId;
  @override
  final String projectId;
  late final TasksBoardRuntimeCoordinator _runtime;
  late final TasksBoardCardCommands _cards;
  late final TasksBoardPreferenceCommands _preferences;
  late final TasksBoardBulkCommands _bulk;

  @override
  TasksBoardState get currentState => state;

  @override
  bool get isBoardClosed => isClosed;

  @override
  void publish(TasksBoardState state) => emit(state);

  @override
  Future<void> reloadBoard({bool force = false}) => load(force: force);

  Future<void> load({bool force = false}) => _runtime.load(force: force);
  Future<void> start() => _runtime.start();
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
  Future<void> loadMore(KanbanColumnResponse column) =>
      _preferences.loadMore(column);
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
    await _runtime.dispose();
    return super.close();
  }
}
