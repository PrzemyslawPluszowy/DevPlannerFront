import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

final class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  TaskDetailsCubit({
    required this.repository,
    required this.acceptanceCriteriaRepository,
    required this.checklistRepository,
    this.collaborationRepository,
    this.metadataRepository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  }) : super(const TaskDetailsInitial());

  final TasksRepository repository;
  final TaskAcceptanceCriteriaRepository acceptanceCriteriaRepository;
  final TaskChecklistRepository checklistRepository;

  /// Opcjonalne wyłącznie dla izolowanych preview i istniejących testów cubitu.
  /// Aplikacja produkcyjna zawsze dostarcza je przez DI.
  final TaskCollaborationRepository? collaborationRepository;

  /// Opcjonalne dla izolowanych preview; produkcja dostarcza je przez DI.
  final TaskMetadataRepository? metadataRepository;
  final String workspaceId;
  final String projectId;
  final String taskId;

  Future<void> load() async {
    emit(const TaskDetailsLoading());
    final result = await repository.getTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        TaskDetailsFailure(
          kind: switch (error.type) {
            ApiErrorType.forbidden ||
            ApiErrorType.unauthorized => TaskDetailsFailureKind.forbidden,
            ApiErrorType.notFound => TaskDetailsFailureKind.notFound,
            ApiErrorType.conflict => TaskDetailsFailureKind.conflict,
            ApiErrorType.connection ||
            ApiErrorType.connectionTimeout ||
            ApiErrorType.sendTimeout ||
            ApiErrorType.receiveTimeout => TaskDetailsFailureKind.offline,
            _ => TaskDetailsFailureKind.other,
          },
          message: error.message,
          backendCode: error.backendCode,
        ),
      ),
      (details) => emit(TaskDetailsReady(details)),
    );
  }

  /// Zapisuje pola podstawowe z wersją agregatu zwróconą przez backend.
  Future<bool> updateBasics({
    required String title,
    required ProjectTaskStatus status,
    required TaskPriority priority,
  }) async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) return false;
    final task = current.details.task;
    return _save(
      current,
      _payloadFrom(
        task,
        title: normalizedTitle,
        status: status,
        priority: priority,
        startAtUtc: task.startAtUtc,
        dueAtUtc: task.dueAtUtc,
        estimatedMinutes: task.estimatedMinutes,
      ),
    );
  }

  /// Aktualizuje harmonogram i estymację, zachowując pozostałe pola agregatu.
  Future<bool> updatePlanning({
    required DateTime? startAtUtc,
    required DateTime? dueAtUtc,
    required int? estimatedMinutes,
  }) async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    if (estimatedMinutes != null && estimatedMinutes <= 0) return false;
    if (startAtUtc != null &&
        dueAtUtc != null &&
        dueAtUtc.isBefore(startAtUtc)) {
      return false;
    }
    final task = current.details.task;
    return _save(
      current,
      _payloadFrom(
        task,
        startAtUtc: startAtUtc,
        dueAtUtc: dueAtUtc,
        estimatedMinutes: estimatedMinutes,
      ),
    );
  }

  /// Zapisuje opis plain-text oraz jego kanoniczny Quill Delta JSON.
  Future<bool> updateDescription({
    required String description,
    required String descriptionDeltaJson,
  }) async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    final task = current.details.task;
    return _save(
      current,
      _payloadFrom(
        task,
        description: description.trim().isEmpty ? null : description.trim(),
        descriptionDeltaJson: descriptionDeltaJson,
      ),
    );
  }

  /// Zastępuje wykonawców i zachowuje wersję agregatu zwróconą przez backend.
  Future<bool> replaceAssignees(List<String> coreUserIds) async {
    final current = state;
    final collaboration = collaborationRepository;
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        collaboration == null) {
      return false;
    }
    final normalized = coreUserIds.toSet().toList(growable: false);
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await collaboration.replaceAssignees(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      coreUserIds: normalized,
      expectedVersion: current.details.task.version,
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        if (error.type == ApiErrorType.conflict) {
          await _reloadAfterConflict(current, error);
        } else {
          emit(
            current.copyWith(
              isSaving: false,
              mutationError: error.message,
              mutationSerial: current.mutationSerial + 1,
            ),
          );
        }
        return false;
      },
      (response) async {
        emit(
          current.copyWith(
            details: current.details.copyWith(task: response.data),
            isSaving: false,
            clearMutationError: true,
          ),
        );
        return true;
      },
    );
  }

  /// Archiwizuje albo przywraca zadanie z kontrolą wersji agregatu.
  Future<bool> toggleArchive() async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    final task = current.details.task;
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = task.archivedAtUtc == null
        ? await repository.archiveTask(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: taskId,
            expectedVersion: task.version,
          )
        : await repository.restoreTask(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: taskId,
            expectedVersion: task.version,
          );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        if (error.type == ApiErrorType.conflict) {
          await _reloadAfterConflict(current, error);
        } else {
          emit(
            current.copyWith(
              isSaving: false,
              mutationError: error.message,
              mutationSerial: current.mutationSerial + 1,
            ),
          );
        }
        return false;
      },
      (response) async {
        emit(
          current.copyWith(
            details: current.details.copyWith(task: response.data),
            isSaving: false,
            clearMutationError: true,
          ),
        );
        return true;
      },
    );
  }

  /// Tworzy jednopoziomowe podzadanie i odświeża agregat rodzica.
  Future<bool> createSubtask(String title) async {
    final current = state;
    final normalized = title.trim();
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        normalized.isEmpty) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final task = current.details.task;
    final result = await repository.quickCreateTask(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: QuickCreateProjectTaskPayload(
        title: normalized,
        parentTaskId: task.id,
        targetStatus: ProjectTaskStatus.todo,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(
          current.copyWith(
            isSaving: false,
            mutationError: error.message,
            mutationSerial: current.mutationSerial + 1,
          ),
        );
        return false;
      },
      (_) => _refreshDetailsAfterCollaborationMutation(current),
    );
  }

  Future<bool> _save(
    TaskDetailsReady current,
    UpdateProjectTaskPayload payload,
  ) async {
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await repository.updateTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: payload,
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        if (error.type == ApiErrorType.conflict) {
          await _reloadAfterConflict(current, error);
        } else {
          emit(
            current.copyWith(
              isSaving: false,
              mutationError: error.message,
              mutationSerial: current.mutationSerial + 1,
            ),
          );
        }
        return false;
      },
      (response) async {
        emit(
          current.copyWith(
            details: current.details.copyWith(task: response.data),
            isSaving: false,
            clearMutationError: true,
          ),
        );
        return true;
      },
    );
  }

  UpdateProjectTaskPayload _payloadFrom(
    ProjectTaskResponse task, {
    String? title,
    ProjectTaskStatus? status,
    TaskPriority? priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    int? estimatedMinutes,
    String? description,
    String? descriptionDeltaJson,
  }) => UpdateProjectTaskPayload(
    title: title ?? task.title,
    description: description ?? task.description,
    status: status ?? task.status,
    priority: priority ?? task.priority,
    startAtUtc: startAtUtc,
    dueAtUtc: dueAtUtc,
    position: task.position,
    expectedVersion: task.version,
    taskType: task.taskType,
    size: task.size,
    complexity: task.complexity,
    risk: task.risk,
    businessValue: task.businessValue,
    estimatedMinutes: estimatedMinutes,
    actualMinutes: task.actualMinutes,
    descriptionDeltaJson: descriptionDeltaJson ?? task.descriptionDeltaJson,
  );

  Future<void> _reloadAfterConflict(
    TaskDetailsReady previous,
    ApiError conflict,
  ) async {
    final refreshed = await repository.getTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );
    if (isClosed) return;
    refreshed.fold(
      (_) => emit(
        previous.copyWith(
          isSaving: false,
          mutationError: conflict.message,
          mutationSerial: previous.mutationSerial + 1,
        ),
      ),
      (details) => emit(
        previous.copyWith(
          details: details,
          isSaving: false,
          mutationError: conflict.message,
          mutationSerial: previous.mutationSerial + 1,
        ),
      ),
    );
  }

  Future<bool> addChecklistItem(String title) async {
    final current = state;
    final normalized = title.trim();
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        normalized.isEmpty) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await checklistRepository.addItem(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: CreateTaskChecklistItemPayload(
        title: normalized,
        expectedVersion: current.details.task.version,
      ),
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) async {
        final items = [...current.details.task.checklistItems, response.data]
          ..sort((a, b) => a.position.compareTo(b.position));
        emit(_withChecklistMutation(current, items, response));
        return true;
      },
    );
  }

  Future<bool> toggleChecklistItem(TaskChecklistItemResponse item) =>
      updateChecklistItem(item, isCompleted: !item.isCompleted);

  Future<bool> updateChecklistItem(
    TaskChecklistItemResponse item, {
    String? title,
    bool? isCompleted,
  }) async {
    final current = state;
    final normalizedTitle = (title ?? item.title).trim();
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        normalizedTitle.isEmpty) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await checklistRepository.updateItem(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      itemId: item.id,
      payload: UpdateTaskChecklistItemPayload(
        title: normalizedTitle,
        position: item.position,
        isCompleted: isCompleted ?? item.isCompleted,
        expectedVersion: current.details.task.version,
      ),
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) async {
        final items = current.details.task.checklistItems
            .map(
              (candidate) =>
                  candidate.id == item.id ? response.data : candidate,
            )
            .toList(growable: false);
        emit(_withChecklistMutation(current, items, response));
        return true;
      },
    );
  }

  Future<bool> deleteChecklistItem(TaskChecklistItemResponse item) async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await checklistRepository.deleteItem(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      itemId: item.id,
      expectedVersion: current.details.task.version,
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) async {
        final items = current.details.task.checklistItems
            .where((candidate) => candidate.id != item.id)
            .toList(growable: false);
        emit(_withChecklistMutation(current, items, response));
        return true;
      },
    );
  }

  TaskDetailsReady _withChecklistMutation<T>(
    TaskDetailsReady current,
    List<TaskChecklistItemResponse> items,
    TaskMutationResponse<T> response,
  ) => current.copyWith(
    details: current.details.copyWith(
      task: current.details.task.copyWith(
        checklistItems: items,
        version: response.taskVersion,
        updatedAtUtc: response.taskUpdatedAtUtc,
      ),
    ),
    isSaving: false,
    clearMutationError: true,
  );

  Future<void> _handleTaskMutationError(
    TaskDetailsReady current,
    ApiError error,
  ) async {
    if (error.type == ApiErrorType.conflict) {
      await _reloadAfterConflict(current, error);
      return;
    }
    emit(
      current.copyWith(
        isSaving: false,
        mutationError: error.message,
        mutationSerial: current.mutationSerial + 1,
      ),
    );
  }

  /// Przełącza obserwowanie przez bieżącego użytkownika i odświeża agregat.
  Future<bool> toggleWatching() async {
    final current = state;
    final repository = collaborationRepository;
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        repository == null) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = current.details.isWatchedByMe
        ? await repository.unfollow(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: taskId,
            expectedVersion: current.details.task.version,
          )
        : await repository.follow(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: taskId,
            expectedVersion: current.details.task.version,
          );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (_) => _refreshDetailsAfterCollaborationMutation(current),
    );
  }

  /// Przełącza osobiste przypięcie bez zmieniania współdzielonego taska.
  Future<bool> togglePinned() async {
    final current = state;
    final repository = collaborationRepository;
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        repository == null) {
      return false;
    }
    final isPinned = !current.details.isPinnedByMe;
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await repository.updatePinned(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      isPinned: isPinned,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(
          current.copyWith(
            isSaving: false,
            mutationError: error.message,
            mutationSerial: current.mutationSerial + 1,
          ),
        );
        return false;
      },
      (_) {
        emit(
          current.copyWith(
            details: current.details.copyWith(isPinnedByMe: isPinned),
            isSaving: false,
            clearMutationError: true,
          ),
        );
        return true;
      },
    );
  }

  /// Zapisuje pełną listę etykiet taska z kontrolą wersji agregatu.
  Future<bool> replaceLabels(Iterable<String> labelIds) async {
    final current = state;
    final repository = metadataRepository;
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        repository == null) {
      return false;
    }
    final ids = labelIds.toSet().toList(growable: false);
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await repository.replaceLabels(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: ReplaceTaskLabelsPayload(
        labelIds: ids,
        expectedVersion: current.details.task.version,
      ),
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) async {
        emit(
          current.copyWith(
            details: current.details.copyWith(
              labels: response.data,
              task: current.details.task.copyWith(
                version: response.taskVersion,
                updatedAtUtc: response.taskUpdatedAtUtc,
              ),
            ),
            isSaving: false,
            clearMutationError: true,
          ),
        );
        return true;
      },
    );
  }

  /// Pobiera projektowe etykiety do selektora, bez utrwalania ich w stanie.
  Future<List<TaskLabelResponse>> loadProjectLabels() async {
    final repository = metadataRepository;
    if (repository == null) return const [];
    final result = await repository.listLabels(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return const [];
    return result.fold((_) => const [], (labels) => labels);
  }

  /// Zapisuje wartości pól własnych i scala odpowiedź z pełnym detailem.
  Future<bool> replaceCustomFieldValues(Map<String, dynamic> values) async {
    final current = state;
    final repository = metadataRepository;
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        repository == null) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await repository.replaceCustomFieldValues(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: ReplaceTaskCustomFieldValuesPayload(
        values: Map<String, dynamic>.unmodifiable(values),
        expectedVersion: current.details.task.version,
      ),
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) async {
        final updatedValues = {
          for (final value in response.data) value.fieldId: value,
        };
        final fields = current.details.customFields
            .map(
              (field) {
                final value = updatedValues[field.id];
                return value == null
                    ? field
                    : field.copyWith(
                        value: value.value,
                        valueUpdatedAtUtc: value.updatedAtUtc,
                      );
              },
            )
            .toList(growable: false);
        emit(
          current.copyWith(
            details: current.details.copyWith(
              customFields: fields,
              task: current.details.task.copyWith(
                version: response.taskVersion,
                updatedAtUtc: response.taskUpdatedAtUtc,
              ),
            ),
            isSaving: false,
            clearMutationError: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> _refreshDetailsAfterCollaborationMutation(
    TaskDetailsReady previous,
  ) async {
    final refreshed = await repository.getTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );
    if (isClosed) return false;
    return refreshed.fold(
      (error) {
        emit(
          previous.copyWith(
            isSaving: false,
            mutationError: error.message,
            mutationSerial: previous.mutationSerial + 1,
          ),
        );
        return false;
      },
      (details) {
        emit(
          previous.copyWith(
            details: details,
            isSaving: false,
            clearMutationError: true,
          ),
        );
        return true;
      },
    );
  }

  /// Wyszukuje zadania projektu do bezpiecznego wyboru relacji w UI.
  Future<List<ProjectTaskListItemResponse>> searchProjectTasks(
    String phrase,
  ) async {
    final query = phrase.trim();
    if (query.length < 2) return const [];
    final result = await repository.listProjectTasks(
      workspaceId: workspaceId,
      projectId: projectId,
      query: ProjectTasksQuery(search: query, limit: 20),
    );
    if (isClosed) return const [];
    return result.fold((_) => const [], (page) => page.items);
  }

  Future<bool> createDependency({
    required String targetTaskId,
    required TaskDependencyType type,
    TaskDependencyKind dependencyKind = TaskDependencyKind.finishToStart,
    int lagDays = 0,
  }) async {
    final current = state;
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        targetTaskId == taskId ||
        lagDays < -365 ||
        lagDays > 365) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await repository.createDependency(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: CreateTaskDependencyPayload(
        targetTaskId: targetTaskId,
        type: type,
        expectedVersion: current.details.task.version,
        dependencyKind: dependencyKind,
        lagDays: lagDays,
      ),
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) async {
        final refreshed = await repository.getTask(
          workspaceId: workspaceId,
          projectId: projectId,
          taskId: taskId,
        );
        if (isClosed) return false;
        return refreshed.fold(
          (error) {
            emit(
              current.copyWith(
                isSaving: false,
                mutationError: error.message,
                mutationSerial: current.mutationSerial + 1,
              ),
            );
            return false;
          },
          (details) {
            emit(
              current.copyWith(
                details: details,
                isSaving: false,
                clearMutationError: true,
              ),
            );
            return true;
          },
        );
      },
    );
  }

  /// Zmienia rodzaj Gantta i lag istniejącej relacji z aktualną wersją zadania.
  Future<bool> updateDependency({
    required TaskDependencyDetailsResponse dependency,
    required TaskDependencyKind dependencyKind,
    required int lagDays,
  }) async {
    final current = state;
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        lagDays < -365 ||
        lagDays > 365) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await repository.updateDependency(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      dependencyId: dependency.id,
      payload: UpdateTaskDependencyPayload(
        dependencyKind: dependencyKind,
        lagDays: lagDays,
        expectedVersion: current.details.task.version,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) {
        emit(
          current.copyWith(
            details: current.details.copyWith(
              dependencies: [
                for (final item in current.details.dependencies)
                  if (item.id == dependency.id)
                    item.copyWith(
                      dependencyKind: response.data.dependencyKind,
                      lagDays: response.data.lagDays,
                    )
                  else
                    item,
              ],
              task: current.details.task.copyWith(
                version: response.taskVersion,
                updatedAtUtc: response.taskUpdatedAtUtc,
              ),
            ),
            isSaving: false,
            clearMutationError: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> deleteDependency(
    TaskDependencyDetailsResponse dependency,
  ) async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await repository.deleteDependency(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      dependencyId: dependency.id,
      expectedVersion: current.details.task.version,
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) async {
        emit(
          current.copyWith(
            details: current.details.copyWith(
              dependencies: current.details.dependencies
                  .where((candidate) => candidate.id != dependency.id)
                  .toList(growable: false),
              task: current.details.task.copyWith(
                version: response.taskVersion,
                updatedAtUtc: response.taskUpdatedAtUtc,
              ),
            ),
            isSaving: false,
            clearMutationError: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> addAcceptanceCriterion(String text) async {
    final current = state;
    final normalized = text.trim();
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        normalized.isEmpty) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await acceptanceCriteriaRepository.create(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: CreateTaskAcceptanceCriterionPayload(
        text: normalized,
        expectedVersion: current.details.task.version,
      ),
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) async {
        final criteria = [...current.details.acceptanceCriteria, response.data]
          ..sort((a, b) => a.position.compareTo(b.position));
        emit(_withCriteriaMutation(current, criteria, response));
        return true;
      },
    );
  }

  Future<bool> toggleAcceptanceCriterion(
    TaskAcceptanceCriterionResponse criterion,
  ) => updateAcceptanceCriterion(
    criterion,
    isAccepted: !criterion.isAccepted,
  );

  Future<bool> updateAcceptanceCriterion(
    TaskAcceptanceCriterionResponse criterion, {
    String? text,
    bool? isAccepted,
  }) async {
    final current = state;
    final normalizedText = (text ?? criterion.text).trim();
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        normalizedText.isEmpty) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await acceptanceCriteriaRepository.update(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      criterionId: criterion.id,
      payload: UpdateTaskAcceptanceCriterionPayload(
        text: normalizedText,
        position: criterion.position,
        isAccepted: isAccepted ?? criterion.isAccepted,
        expectedVersion: current.details.task.version,
      ),
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) async {
        final criteria = current.details.acceptanceCriteria
            .map(
              (candidate) =>
                  candidate.id == criterion.id ? response.data : candidate,
            )
            .toList(growable: false);
        emit(_withCriteriaMutation(current, criteria, response));
        return true;
      },
    );
  }

  Future<bool> deleteAcceptanceCriterion(
    TaskAcceptanceCriterionResponse criterion,
  ) async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final result = await acceptanceCriteriaRepository.delete(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      criterionId: criterion.id,
      expectedVersion: current.details.task.version,
    );
    if (isClosed) return false;
    return result.fold<Future<bool>>(
      (error) async {
        await _handleTaskMutationError(current, error);
        return false;
      },
      (response) async {
        final criteria = current.details.acceptanceCriteria
            .where((candidate) => candidate.id != criterion.id)
            .toList(growable: false);
        emit(_withCriteriaMutation(current, criteria, response));
        return true;
      },
    );
  }

  TaskDetailsReady _withCriteriaMutation<T>(
    TaskDetailsReady current,
    List<TaskAcceptanceCriterionResponse> criteria,
    TaskMutationResponse<T> response,
  ) => current.copyWith(
    details: current.details.copyWith(
      acceptanceCriteria: criteria,
      task: current.details.task.copyWith(
        version: response.taskVersion,
        updatedAtUtc: response.taskUpdatedAtUtc,
      ),
    ),
    isSaving: false,
    clearMutationError: true,
  );
}
