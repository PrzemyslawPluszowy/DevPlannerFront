import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';

enum TaskDetailsFailureKind { forbidden, notFound, conflict, offline, other }

sealed class TaskDetailsState {
  const TaskDetailsState();
}

final class TaskDetailsInitial extends TaskDetailsState {
  const TaskDetailsInitial();
}

final class TaskDetailsLoading extends TaskDetailsState {
  const TaskDetailsLoading();
}

final class TaskDetailsFailure extends TaskDetailsState {
  const TaskDetailsFailure({
    required this.kind,
    required this.message,
    this.backendCode,
    this.error,
  });

  final TaskDetailsFailureKind kind;
  final String message;
  final int? backendCode;
  final ApiError? error;
}

final class TaskDetailsReady extends TaskDetailsState {
  const TaskDetailsReady(
    this.details, {
    this.isSaving = false,
    this.mutationError,
    this.mutationSerial = 0,
    this.mutationFailure,
    this.mutationOwner,
    this.conflictBase,
  });

  final ProjectTaskDetailsResponse details;
  final bool isSaving;
  final String? mutationError;
  final int mutationSerial;
  final ApiError? mutationFailure;

  /// Local editor token; never transported to the API.
  final Object? mutationOwner;

  /// Agregat sprzed konfliktu do porównania ze szkicem i aktualnym serwerem.
  final ProjectTaskDetailsResponse? conflictBase;

  bool get canEdit =>
      details.capabilities?.canEdit ?? details.task.archivedAtUtc == null;
  bool get canToggleArchive => details.task.archivedAtUtc == null
      ? details.capabilities?.canArchive ?? true
      : details.capabilities?.canRestore ?? true;

  TaskDetailsReady copyWith({
    ProjectTaskDetailsResponse? details,
    bool? isSaving,
    String? mutationError,
    bool clearMutationError = false,
    int? mutationSerial,
    ApiError? mutationFailure,
    Object? mutationOwner,
    bool clearMutationOwner = false,
    ProjectTaskDetailsResponse? conflictBase,
  }) => TaskDetailsReady(
    details ?? this.details,
    isSaving: isSaving ?? this.isSaving,
    mutationError: clearMutationError
        ? null
        : mutationError ?? this.mutationError,
    mutationSerial: mutationSerial ?? this.mutationSerial,
    mutationFailure: clearMutationError
        ? null
        : mutationFailure ?? this.mutationFailure,
    mutationOwner: clearMutationError || clearMutationOwner
        ? null
        : mutationFailure != null
        ? mutationOwner
        : this.mutationOwner,
    conflictBase: clearMutationError ? null : conflictBase ?? this.conflictBase,
  );
}
