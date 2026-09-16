import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_template_repository.dart';

/// Wynik operacji pobierania szczegółów szablonu zadania.
sealed class TaskTemplateDetailsLoadResult {
  const TaskTemplateDetailsLoadResult();

  /// Zwraca załadowane szczegóły szablonu albo null w przypadku błędu.
  TaskTemplateDetailsResponse? get detailsOrNull => switch (this) {
    TaskTemplateDetailsLoaded(:final details) => details,
    TaskTemplateDetailsLoadFailure() => null,
  };

  /// Zwraca błąd pobierania albo null w przypadku sukcesu.
  ApiError? get errorOrNull => switch (this) {
    TaskTemplateDetailsLoaded() => null,
    TaskTemplateDetailsLoadFailure(:final error) => error,
  };
}

/// Szczegóły szablonu zostały pomyślnie załadowane z backendu.
final class TaskTemplateDetailsLoaded extends TaskTemplateDetailsLoadResult {
  const TaskTemplateDetailsLoaded(this.details);

  final TaskTemplateDetailsResponse details;
}

/// Pobieranie szczegółów szablonu zakończyło się błędem API.
final class TaskTemplateDetailsLoadFailure
    extends TaskTemplateDetailsLoadResult {
  const TaskTemplateDetailsLoadFailure(this.error);

  final ApiError error;
}

/// Wynik mutacji szablonu zadania w bibliotece workspace.
sealed class TaskTemplateMutationResult {
  const TaskTemplateMutationResult();

  /// Czy operacja zakończyła się sukcesem.
  bool get isSuccess => this is TaskTemplateMutationSuccess;

  /// Zwraca błąd mutacji albo null w przypadku sukcesu.
  ApiError? get errorOrNull => switch (this) {
    TaskTemplateMutationSuccess() => null,
    TaskTemplateMutationFailure(:final error) => error,
  };
}

/// Mutacja szablonu zakończyła się powodzeniem.
final class TaskTemplateMutationSuccess extends TaskTemplateMutationResult {
  const TaskTemplateMutationSuccess();
}

/// Mutacja szablonu zakończyła się błędem API.
final class TaskTemplateMutationFailure extends TaskTemplateMutationResult {
  const TaskTemplateMutationFailure(this.error);

  final ApiError error;
}

/// Stan katalogu szablonów dostępnego w przepływie tworzenia zadania.
sealed class TaskTemplatePickerState {
  const TaskTemplatePickerState();
}

/// Początkowe ładowanie całego katalogu szablonów.
final class TaskTemplatePickerLoading extends TaskTemplatePickerState {
  const TaskTemplatePickerLoading();
}

/// Błąd uniemożliwiający załadowanie katalogu szablonów.
final class TaskTemplatePickerFailure extends TaskTemplatePickerState {
  const TaskTemplatePickerFailure(this.message);

  final String message;
}

/// Gotowy katalog szablonów z zachowaniem dotychczasowej listy podczas mutacji.
final class TaskTemplatePickerReady extends TaskTemplatePickerState {
  const TaskTemplatePickerReady({
    required this.templates,
    this.defaultTemplateId,
    this.isSavingDefault = false,
    this.isCreating = false,
    this.updatingTemplateId,
    this.deletingTemplateId,
    this.error,
  });

  final List<TaskTemplateResponse> templates;
  final String? defaultTemplateId;
  final bool isSavingDefault;
  final bool isCreating;
  final String? updatingTemplateId;
  final String? deletingTemplateId;
  final String? error;

  /// Identyfikator szablonu objętego bieżącą operacją mutacji (edycja lub usunięcie).
  String? get busyTemplateId => updatingTemplateId ?? deletingTemplateId;

  TaskTemplatePickerReady copyWith({
    List<TaskTemplateResponse>? templates,
    String? defaultTemplateId,
    bool? isSavingDefault,
    bool? isCreating,
    String? updatingTemplateId,
    String? deletingTemplateId,
    String? busyTemplateId,
    String? error,
    bool clearDefault = false,
    bool clearBusyTemplate = false,
    bool clearUpdatingTemplate = false,
    bool clearDeletingTemplate = false,
    bool clearError = false,
  }) => TaskTemplatePickerReady(
    templates: templates ?? this.templates,
    defaultTemplateId: clearDefault
        ? null
        : defaultTemplateId ?? this.defaultTemplateId,
    isSavingDefault: isSavingDefault ?? this.isSavingDefault,
    isCreating: isCreating ?? this.isCreating,
    updatingTemplateId: clearBusyTemplate || clearUpdatingTemplate
        ? null
        : updatingTemplateId ?? (busyTemplateId ?? this.updatingTemplateId),
    deletingTemplateId: clearBusyTemplate || clearDeletingTemplate
        ? null
        : deletingTemplateId ?? this.deletingTemplateId,
    error: clearError ? null : error ?? this.error,
  );
}

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
            assigneeCoreUserIds: details.assigneeCoreUserIds,
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
