import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';

/// Wynik operacji pobierania szczegółów szablonu zadania.
sealed class TaskTemplateDetailsLoadResult {
  const TaskTemplateDetailsLoadResult();

  TaskTemplateDetailsResponse? get detailsOrNull => switch (this) {
    TaskTemplateDetailsLoaded(:final details) => details,
    TaskTemplateDetailsLoadFailure() => null,
  };

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

  bool get isSuccess => this is TaskTemplateMutationSuccess;

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

/// Gotowy katalog szablonów z zachowaniem listy podczas mutacji.
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
