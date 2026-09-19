import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'task_template_picker_state.dart';

/// Zarządza katalogiem szablonów, preferencją domyślnej formatki oraz operacjami CRUD.
final class TaskTemplatePickerCubit extends Cubit<TaskTemplatePickerState> {
  TaskTemplatePickerCubit({required this.repository, required this.workspaceId})
    : super(const TaskTemplatePickerLoading());

  final TaskTemplateRepository repository;
  final String workspaceId;

  /// Pobiera pełny szablon przed edycją z zachowaniem błędu ApiError.
  Future<TaskTemplateDetailsLoadResult> loadDetails(String templateId) async {
    final result = await repository.details(
      workspaceId: workspaceId,
      templateId: templateId,
    );
    if (isClosed) {
      return const TaskTemplateDetailsLoadFailure(
        ApiError(type: .canceled, message: 'Operation cancelled'),
      );
    }
    return result.fold(
      TaskTemplateDetailsLoadFailure.new,
      TaskTemplateDetailsLoaded.new,
    );
  }

  /// Tworzy nową definicję szablonu od zera w bieżącym workspace.
  Future<TaskTemplateMutationResult> createFromDefinition(
    CreateTaskTemplateDefinitionPayload payload,
  ) async {
    final current = state;
    if (current is! TaskTemplatePickerReady || current.isCreating) {
      return const TaskTemplateMutationFailure(
        ApiError(type: .validation, message: 'Operation in progress'),
      );
    }
    emit(current.copyWith(isCreating: true, clearError: true));
    final result = await repository.createFromDefinition(
      workspaceId: workspaceId,
      payload: payload,
    );
    if (isClosed) {
      return const TaskTemplateMutationFailure(
        ApiError(type: .canceled, message: 'Operation cancelled'),
      );
    }
    return result.fold(
      (error) {
        emit(current.copyWith(isCreating: false, error: error.message));
        return TaskTemplateMutationFailure(error);
      },
      (_) async {
        emit(current.copyWith(isCreating: false));
        await refresh();
        return const TaskTemplateMutationSuccess();
      },
    );
  }

  /// Zapisuje pełny payload szablonu z jego aktualną wersją.
  Future<TaskTemplateMutationResult> updateDetails({
    required String templateId,
    required UpdateTaskTemplatePayload payload,
  }) async {
    final current = state;
    if (current is! TaskTemplatePickerReady ||
        current.updatingTemplateId != null) {
      return const TaskTemplateMutationFailure(
        ApiError(type: .validation, message: 'Operation in progress'),
      );
    }
    emit(current.copyWith(updatingTemplateId: templateId, clearError: true));
    final result = await repository.update(
      workspaceId: workspaceId,
      templateId: templateId,
      payload: payload,
    );
    if (isClosed) {
      return const TaskTemplateMutationFailure(
        ApiError(type: .canceled, message: 'Operation cancelled'),
      );
    }
    return result.fold(
      (error) {
        emit(
          current.copyWith(
            clearUpdatingTemplate: true,
            error: error.message,
          ),
        );
        return TaskTemplateMutationFailure(error);
      },
      (_) async {
        emit(current.copyWith(clearUpdatingTemplate: true));
        await refresh();
        return const TaskTemplateMutationSuccess();
      },
    );
  }

  /// Pobiera katalog od zera ze stanem ładowania całego panelu.
  Future<void> load() async {
    emit(const TaskTemplatePickerLoading());
    final templatesResult = await repository.list(workspaceId);
    if (isClosed) return;
    await templatesResult.fold(
      (error) async => emit(TaskTemplatePickerFailure(error.message)),
      (templates) async {
        final defaultResult = await repository.getDefault(workspaceId);
        if (isClosed) return;
        defaultResult.fold(
          (_) => emit(TaskTemplatePickerReady(templates: templates)),
          (preference) => emit(
            TaskTemplatePickerReady(
              templates: templates,
              defaultTemplateId: preference.taskTemplateId,
            ),
          ),
        );
      },
    );
  }

  /// Odświeża listę i preferencję w tle bez przełączania na stan TaskTemplatePickerLoading.
  Future<void> refresh() async {
    final current = state;
    if (current is! TaskTemplatePickerReady) {
      await load();
      return;
    }
    final templatesResult = await repository.list(workspaceId);
    if (isClosed) return;
    await templatesResult.fold(
      (error) async => emit(current.copyWith(error: error.message)),
      (templates) async {
        final defaultResult = await repository.getDefault(workspaceId);
        if (isClosed) return;
        defaultResult.fold(
          (_) => emit(
            current.copyWith(
              templates: templates,
              clearError: true,
            ),
          ),
          (preference) => emit(
            current.copyWith(
              templates: templates,
              clearDefault: preference.taskTemplateId == null,
              defaultTemplateId: preference.taskTemplateId,
              clearError: true,
            ),
          ),
        );
      },
    );
  }

  /// Ustawia albo czyści domyślny szablon tylko dla bieżącego użytkownika.
  Future<void> toggleDefault(String templateId) async {
    final current = state;
    if (current is! TaskTemplatePickerReady ||
        current.isSavingDefault ||
        current.busyTemplateId != null ||
        current.isCreating) {
      return;
    }
    final clearing = current.defaultTemplateId == templateId;
    emit(
      current.copyWith(
        isSavingDefault: true,
        clearError: true,
        clearDefault: clearing,
        defaultTemplateId: clearing ? null : templateId,
      ),
    );
    final result = await repository.setDefault(
      workspaceId: workspaceId,
      payload: SetDefaultTaskTemplatePayload(
        taskTemplateId: clearing ? null : templateId,
      ),
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        current.copyWith(isSavingDefault: false, error: error.message),
      ),
      (preference) => emit(
        TaskTemplatePickerReady(
          templates: current.templates,
          defaultTemplateId: preference.taskTemplateId,
        ),
      ),
    );
  }

  /// Zmienia nazwę szablonu z zachowaniem pozostałych pól i pełnej wersji.
  Future<TaskTemplateMutationResult> rename({
    required String templateId,
    required String name,
  }) async {
    final current = state;
    final normalizedName = name.trim();
    if (current is! TaskTemplatePickerReady ||
        current.updatingTemplateId != null ||
        normalizedName.isEmpty) {
      return const TaskTemplateMutationFailure(
        ApiError(type: .validation, message: 'Invalid operation'),
      );
    }
    emit(current.copyWith(updatingTemplateId: templateId, clearError: true));
    final detailsResult = await repository.details(
      workspaceId: workspaceId,
      templateId: templateId,
    );
    if (isClosed) {
      return const TaskTemplateMutationFailure(
        ApiError(type: .canceled, message: 'Operation cancelled'),
      );
    }
    return await detailsResult.fold(
      (error) async {
        emit(
          current.copyWith(
            clearUpdatingTemplate: true,
            error: error.message,
          ),
        );
        return TaskTemplateMutationFailure(error);
      },
      (details) async {
        final result = await repository.update(
          workspaceId: workspaceId,
          templateId: templateId,
          payload: UpdateTaskTemplatePayload(
            name: normalizedName,
            title: details.title,
            description: details.description,
            descriptionDeltaJson: details.descriptionDeltaJson,
            status: details.status,
            priority: details.priority,
            startAtUtc: details.startAtUtc,
            dueAtUtc: details.dueAtUtc,
            taskType: details.taskType,
            size: details.size,
            complexity: details.complexity,
            risk: details.risk,
            businessValue: details.businessValue,
            estimatedMinutes: details.estimatedMinutes,
            assigneeUserIds: details.assigneeUserIds,
            checklistItems: details.checklistItems,
            acceptanceCriteria: details.acceptanceCriteria,
            labels: details.labels,
            customFieldValues: details.customFieldValues,
            customStatus: details.customStatus,
            expectedVersion: details.version,
          ),
        );
        if (isClosed) {
          return const TaskTemplateMutationFailure(
            ApiError(type: .canceled, message: 'Operation cancelled'),
          );
        }
        return result.fold(
          (error) {
            emit(
              current.copyWith(
                clearUpdatingTemplate: true,
                error: error.message,
              ),
            );
            return TaskTemplateMutationFailure(error);
          },
          (_) async {
            emit(current.copyWith(clearUpdatingTemplate: true));
            await refresh();
            return const TaskTemplateMutationSuccess();
          },
        );
      },
    );
  }

  /// Usuwa wybrany szablon wraz z natychmiastowym wyczyszczeniem preferencji w UI.
  Future<TaskTemplateMutationResult> delete(String templateId) async {
    final current = state;
    if (current is! TaskTemplatePickerReady ||
        current.deletingTemplateId != null) {
      return const TaskTemplateMutationFailure(
        ApiError(type: .validation, message: 'Operation in progress'),
      );
    }
    final template = current.templates
        .where((t) => t.id == templateId)
        .firstOrNull;
    if (template == null) {
      return const TaskTemplateMutationFailure(
        ApiError(type: .notFound, message: 'Template not found'),
      );
    }
    emit(current.copyWith(deletingTemplateId: templateId, clearError: true));
    final result = await repository.delete(
      workspaceId: workspaceId,
      templateId: templateId,
      expectedVersion: template.version,
    );
    if (isClosed) {
      return const TaskTemplateMutationFailure(
        ApiError(type: .canceled, message: 'Operation cancelled'),
      );
    }
    return result.fold(
      (error) {
        emit(
          current.copyWith(clearDeletingTemplate: true, error: error.message),
        );
        return TaskTemplateMutationFailure(error);
      },
      (_) async {
        final clearingDefault = current.defaultTemplateId == templateId;
        emit(
          current.copyWith(
            clearDeletingTemplate: true,
            clearDefault: clearingDefault,
          ),
        );
        await refresh();
        return const TaskTemplateMutationSuccess();
      },
    );
  }
}
