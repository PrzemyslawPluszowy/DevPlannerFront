import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_template_repository.dart';

/// Stan zapisu bieżącego zadania jako szablonu.
sealed class TaskTemplateState {
  const TaskTemplateState();
}

final class TaskTemplateIdle extends TaskTemplateState {
  const TaskTemplateIdle();
}

final class TaskTemplateSaving extends TaskTemplateState {
  const TaskTemplateSaving();
}

final class TaskTemplateFailure extends TaskTemplateState {
  const TaskTemplateFailure(this.message);

  final String message;
}

final class TaskTemplateSaved extends TaskTemplateState {
  const TaskTemplateSaved();
}

/// Wykonuje pojedynczy zapis otwartego zadania do biblioteki szablonów.
final class TaskTemplateCubit extends Cubit<TaskTemplateState> {
  TaskTemplateCubit({
    required this.repository,
    required this.workspaceId,
    required this.taskId,
  }) : super(const TaskTemplateIdle());

  final TaskTemplateRepository repository;
  final String workspaceId;
  final String taskId;

  /// Zapisuje aktualny stan zadania pod nazwą nadaną przez użytkownika.
  Future<void> createFromTask(String name) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty || state is TaskTemplateSaving) return;

    emit(const TaskTemplateSaving());
    final result = await repository.create(
      workspaceId: workspaceId,
      taskId: taskId,
      payload: CreateTaskTemplatePayload(name: normalizedName),
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(TaskTemplateFailure(error.message)),
      (_) => emit(const TaskTemplateSaved()),
    );
  }
}
