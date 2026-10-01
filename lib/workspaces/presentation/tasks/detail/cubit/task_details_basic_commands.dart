import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_basic_mutation_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_mutation_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_response_assembler.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

/// Polecenia podstawowej edycji z kontrolą uprawnień i wersji agregatu.
final class TaskDetailsBasicCommands {
  const TaskDetailsBasicCommands({
    required this.service,
    required this.coordinator,
    required this.assembler,
    required this.readState,
    required this.emitReady,
  });
  final TaskDetailsBasicMutationService service;
  final TaskDetailsMutationCoordinator coordinator;
  final TaskDetailsResponseAssembler assembler;
  final TaskDetailsState Function() readState;
  final void Function(TaskDetailsReady) emitReady;

  /// Zmienia tylko status, zachowując najnowszy tytuł, priorytet i wersję.
  Future<bool> changeSystemStatus(ProjectTaskStatus status) async {
    if (coordinator.isClosed()) return false;
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving || !current.canEdit) {
      return false;
    }
    final task = current.details.task;
    if (task.status == status) return true;
    final allowed =
        current.details.workflow.transitions.isEmpty ||
        current.details.workflow.transitions.any(
          (transition) =>
              transition.fromStatus == task.status &&
              transition.toStatus == status,
        );
    if (!allowed) return false;
    return updateBasics(
      title: task.title,
      status: status,
      priority: task.priority,
    );
  }

  /// Zmienia tylko priorytet, zachowując najnowszy tytuł, status i wersję.
  Future<bool> changePriority(TaskPriority priority) async {
    if (coordinator.isClosed()) return false;
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving || !current.canEdit) {
      return false;
    }
    final task = current.details.task;
    if (task.priority == priority) return true;
    return updateBasics(
      title: task.title,
      status: task.status,
      priority: priority,
    );
  }

  /// Zapisuje pola podstawowe z wersją agregatu zwróconą przez backend.
  Future<bool> updateBasics({
    required String title,
    required ProjectTaskStatus status,
    required TaskPriority priority,
  }) async {
    if (coordinator.isClosed()) return false;
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving || !current.canEdit) {
      return false;
    }
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) return false;
    final task = current.details.task;
    return coordinator.executeProjectTask(
      current,
      service.updateBasics(
        task: task,
        title: normalizedTitle,
        status: status,
        priority: priority,
      ),
      assembler,
    );
  }

  /// Aktualizuje harmonogram i estymację, zachowując pozostałe pola agregatu.
  Future<bool> updatePlanning({
    required DateTime? startAtUtc,
    required DateTime? dueAtUtc,
    required int? estimatedMinutes,
  }) async {
    if (coordinator.isClosed()) return false;
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving || !current.canEdit) {
      return false;
    }
    if (estimatedMinutes != null && estimatedMinutes <= 0) return false;
    if (startAtUtc != null &&
        dueAtUtc != null &&
        dueAtUtc.isBefore(startAtUtc)) {
      return false;
    }
    final task = current.details.task;
    return coordinator.executeProjectTask(
      current,
      service.updatePlanning(
        task: task,
        startAtUtc: startAtUtc,
        dueAtUtc: dueAtUtc,
        estimatedMinutes: estimatedMinutes,
      ),
      assembler,
    );
  }

  /// Zapisuje opis plain-text oraz jego kanoniczny Quill Delta JSON.
  Future<bool> updateDescription({
    required String description,
    required String descriptionDeltaJson,
  }) async {
    if (coordinator.isClosed()) return false;
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving || !current.canEdit) {
      return false;
    }
    final task = current.details.task;
    return coordinator.executeProjectTask(
      current,
      service.updateDescription(
        task: task,
        description: description,
        descriptionDeltaJson: descriptionDeltaJson,
      ),
      assembler,
    );
  }

  /// Archiwizuje albo przywraca zadanie z kontrolą wersji agregatu.
  Future<bool> toggleArchive() async {
    if (coordinator.isClosed()) return false;
    final current = readState();
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        !current.canToggleArchive) {
      return false;
    }
    final task = current.details.task;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.executeAndRefresh(
      current: current,
      operation: service.toggleArchive(task),
    );
  }

  /// Tworzy jednopoziomowe podzadanie i odświeża agregat rodzica.
  Future<bool> createSubtask(String title) async {
    if (coordinator.isClosed()) return false;
    final current = readState();
    final normalized = title.trim();
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        !current.canEdit ||
        normalized.isEmpty) {
      return false;
    }
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    final task = current.details.task;
    return coordinator.executeAndRefresh(
      current: current,
      operation: service.createSubtask(
        task: task,
        title: normalized,
      ),
    );
  }
}
