import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_column_page_loader.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_preference_intent_queue.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_quick_create_commands.dart';

/// Osobiste preferencje Kanbana i stronicowanie kolumn.
final class TasksBoardPreferenceCommands {
  TasksBoardPreferenceCommands({
    required TasksBoardCommandContext context,
    required KanbanRepository repository,
    required TasksRepository tasksRepository,
    TaskTemplateRepository? taskTemplateRepository,
    required int Function() boardQueryRevision,
  }) : _columnPages = TasksBoardColumnPageLoader(
         context: context,
         repository: repository,
         queryRevision: boardQueryRevision,
       ),
       _intentQueue = TasksBoardPreferenceIntentQueue(
         context: context,
         repository: repository,
       ),
       _quickCreate = TasksBoardQuickCreateCommands(
         context: context,
         tasksRepository: tasksRepository,
         taskTemplateRepository: taskTemplateRepository,
         boardQueryRevision: boardQueryRevision,
       );

  final TasksBoardColumnPageLoader _columnPages;
  final TasksBoardQuickCreateCommands _quickCreate;
  final TasksBoardPreferenceIntentQueue _intentQueue;

  /// Czy w kolejce czekają niezapisane intencje użytkownika.
  bool get hasPendingIntents => _intentQueue.hasPendingIntents;

  Future<void> toggleColumnCollapsed(KanbanColumnResponse column) async {
    await _intentQueue.toggleColumnCollapsed(column);
  }

  Future<void> setQuickFilter(KanbanQuickFilter quickFilter) async {
    await _intentQueue.setQuickFilter(quickFilter);
  }

  /// Ponawia zapis zaparkowanych intencji po nieudanym zapisie albo konflikcie.
  Future<void> retryPending() async {
    await _intentQueue.retryPending();
  }

  Future<void> loadMore(KanbanColumnResponse column) =>
      _columnPages.loadMore(column);

  Future<bool> createQuickTask({
    required KanbanColumnResponse column,
    required String title,
    String? taskTemplateId,
    bool useDefaultTemplate = true,
  }) => _quickCreate.createQuickTask(
    column: column,
    title: title,
    taskTemplateId: taskTemplateId,
    useDefaultTemplate: useDefaultTemplate,
  );

  Future<bool> applyTaskTemplate({
    required String templateId,
    required String title,
  }) => _quickCreate.applyTaskTemplate(templateId: templateId, title: title);
}
