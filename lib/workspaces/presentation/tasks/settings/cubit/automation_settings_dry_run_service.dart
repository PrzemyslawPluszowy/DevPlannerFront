import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/workspaces/models/automation_models.dart';
import 'package:devplanner/workspaces/domain/repositories/automation_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';

/// Wynik odczytu selektora taska dla dry-run bez zależności od Cubita.
sealed class AutomationDryRunTasksResult {
  const AutomationDryRunTasksResult();
}

final class AutomationDryRunTasksFailure extends AutomationDryRunTasksResult {
  const AutomationDryRunTasksFailure(this.message);

  final String message;
}

final class AutomationDryRunTasksSuccess extends AutomationDryRunTasksResult {
  const AutomationDryRunTasksSuccess(this.tasks);

  final List<ProjectTaskListItemResponse> tasks;
}

/// Wynik symulacji reguły, który Cubit publikuje jako stan ekranu.
sealed class AutomationDryRunResult {
  const AutomationDryRunResult();
}

final class AutomationDryRunFailure extends AutomationDryRunResult {
  const AutomationDryRunFailure(this.message);

  final String message;
}

final class AutomationDryRunSuccess extends AutomationDryRunResult {
  const AutomationDryRunSuccess(this.response);

  final AutomationDryRunResponse response;
}

/// Wykonuje odczyt tasków i dry-run przez jawne porty domenowe.
final class AutomationSettingsDryRunService {
  const AutomationSettingsDryRunService({
    required this.repository,
    required this.tasksRepository,
    required this.workspaceId,
    required this.projectId,
  });

  final AutomationRepository repository;
  final TasksRepository tasksRepository;
  final String workspaceId;
  final String projectId;

  Future<AutomationDryRunTasksResult> loadTasks() async {
    final result = await tasksRepository.listProjectTasks(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    return result.fold(
      (error) => AutomationDryRunTasksFailure(error.message),
      (page) => AutomationDryRunTasksSuccess(page.items),
    );
  }

  Future<AutomationDryRunResult> run({
    required AutomationRuleResponse rule,
    required ProjectTaskListItemResponse task,
  }) async {
    final result = await repository.dryRun(
      workspaceId: workspaceId,
      projectId: projectId,
      ruleId: rule.id,
      payload: AutomationDryRunPayload(taskId: task.id, eventPayload: const {}),
    );
    return result.fold(
      (error) => AutomationDryRunFailure(error.message),
      AutomationDryRunSuccess.new,
    );
  }
}
