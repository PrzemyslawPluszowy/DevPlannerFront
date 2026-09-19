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
  });

  final TaskDetailsFailureKind kind;
  final String message;
  final int? backendCode;
}

final class TaskDetailsReady extends TaskDetailsState {
  const TaskDetailsReady(
    this.details, {
    this.isSaving = false,
    this.mutationError,
    this.mutationSerial = 0,
  });

  final ProjectTaskDetailsResponse details;
  final bool isSaving;
  final String? mutationError;
  final int mutationSerial;

  TaskDetailsReady copyWith({
    ProjectTaskDetailsResponse? details,
    bool? isSaving,
    String? mutationError,
    bool clearMutationError = false,
    int? mutationSerial,
  }) => TaskDetailsReady(
    details ?? this.details,
    isSaving: isSaving ?? this.isSaving,
    mutationError: clearMutationError
        ? null
        : mutationError ?? this.mutationError,
    mutationSerial: mutationSerial ?? this.mutationSerial,
  );
}
