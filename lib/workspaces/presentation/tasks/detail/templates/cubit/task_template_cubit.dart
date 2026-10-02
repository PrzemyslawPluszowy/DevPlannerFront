import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/session/task_detail_section_lifecycle.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  const TaskTemplateFailure(
    this.message, {
    this.apiError,
    this.retryRevision = 0,
  });

  final String message;
  final ApiError? apiError;
  final int retryRevision;
}

final class TaskTemplateSaved extends TaskTemplateState {
  const TaskTemplateSaved();
}

/// Wykonuje pojedynczy zapis otwartego zadania do biblioteki szablonów.
final class TaskTemplateCubit extends Cubit<TaskTemplateState> {
  TaskTemplateCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    this.canEdit,
    this.onAccessLost,
  }) : super(const TaskTemplateIdle());

  final TaskTemplateRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  final bool Function()? canEdit;
  final void Function(ApiError)? onAccessLost;
  late final _lifecycle = TaskDetailSectionLifecycle(
    isClosed: () => isClosed,
    canEdit: canEdit,
    onAccessLost: onAccessLost,
  );

  DateTime? _retryAfterUtc;
  Timer? _retryTimer;

  bool get canSubmit =>
      _lifecycle.canMutate &&
      state is! TaskTemplateSaving &&
      state is! TaskTemplateSaved &&
      (_retryAfterUtc == null ||
          !DateTime.now().toUtc().isBefore(_retryAfterUtc!));

  /// Zapisuje aktualny stan zadania pod nazwą nadaną przez użytkownika.
  Future<void> createFromTask(String name) async {
    final normalizedName = name.trim();
    if (!canSubmit || normalizedName.isEmpty) {
      return;
    }

    final generation = _lifecycle.begin()!;
    emit(const TaskTemplateSaving());
    try {
      final result = await repository.create(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        payload: CreateTaskTemplatePayload(name: normalizedName),
      );
      if (!_lifecycle.isCurrent(generation)) return;
      result.fold(_publishFailure, (_) => emit(const TaskTemplateSaved()));
    } on Object catch (error) {
      if (!_lifecycle.isCurrent(generation)) return;
      _publishFailure(switch (error) {
        final ApiError apiError => apiError,
        final DioException dioError => ApiError.fromDioException(
          dioError,
          fallbackMessage: '',
        ),
        _ => const ApiError(
          type: ApiErrorType.unknown,
          message: '',
          apiCode: 'tasks.template_save_failed',
        ),
      });
    }
  }

  void _publishFailure(ApiError error) {
    _retryTimer?.cancel();
    _retryAfterUtc = error.retryAfterUtc?.toUtc();
    final delay = _retryAfterUtc?.difference(DateTime.now().toUtc());
    if (delay != null && delay > Duration.zero) {
      _retryTimer = Timer(delay, _enableRetry);
    }
    emit(TaskTemplateFailure(error.message, apiError: error));
    _lifecycle.reportError(error);
  }

  void _enableRetry() {
    _retryTimer = null;
    _retryAfterUtc = null;
    if (isClosed) return;
    final current = state;
    if (current is TaskTemplateFailure) {
      emit(
        TaskTemplateFailure(
          current.message,
          apiError: current.apiError,
          retryRevision: current.retryRevision + 1,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _lifecycle.invalidate();
    _retryTimer?.cancel();
    return super.close();
  }
}
