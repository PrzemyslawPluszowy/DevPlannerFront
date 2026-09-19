import 'dart:async';

import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit zarządzający regułami cykliczności zadań i historią wykonań w projekcie.
class ProjectRecurrencesCubit extends Cubit<ProjectRecurrencesState> {
  /// Tworzy instancję menedżera cykliczności.
  ProjectRecurrencesCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    this.realtime,
  }) : super(const ProjectRecurrencesInitial()) {
    if (realtime != null) {
      _updatesSub = realtime?.updates.listen(_onRealtimeUpdate);
    }
  }

  final TaskRecurrenceRepository repository;
  final TaskProjectRealtime? realtime;
  final String workspaceId;
  final String projectId;

  StreamSubscription<TaskProjectRealtimeUpdate>? _updatesSub;

  /// Pobiera listę reguł oraz historię wykonań dla projektu.
  Future<void> load() async {
    final previousRules = switch (state) {
      ProjectRecurrencesLoaded(:final rules) => rules,
      _ => null,
    };
    final previousRuns = switch (state) {
      ProjectRecurrencesLoaded(:final runs) => runs,
      _ => null,
    };

    emit(
      ProjectRecurrencesLoading(
        previousRules: previousRules,
        previousRuns: previousRuns,
      ),
    );

    final rulesResult = await repository.getProjectRecurrences(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    final runsResult = await repository.getProjectRecurrenceRuns(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    if (isClosed) return;

    rulesResult.fold(
      (error) => emit(ProjectRecurrencesError(error.message)),
      (rules) {
        runsResult.fold(
          (error) => emit(ProjectRecurrencesError(error.message)),
          (runs) => emit(ProjectRecurrencesLoaded(rules: rules, runs: runs)),
        );
      },
    );
  }

  /// Wstrzymuje lub wznawia regułę cykliczną.
  Future<bool> togglePause(ProjectTaskRecurrenceItemResponse rule) async {
    final current = state;
    if (current is! ProjectRecurrencesLoaded) return false;

    emit(current.copyWith(isActionInProgress: true, clearFeedback: true));

    final isPausing = rule.isActive;
    final result = isPausing
        ? await repository.pause(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: rule.sourceTaskId,
            expectedVersion: rule.version,
          )
        : await repository.resume(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: rule.sourceTaskId,
            expectedVersion: rule.version,
          );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(
          current.copyWith(
            isActionInProgress: false,
            feedback: ProjectRecurrenceFeedbackError(error.message),
          ),
        );
        return false;
      },
      (success) {
        final msg = isPausing
            ? 'Wstrzymano serię cykliczną'
            : 'Wznowiono serię cykliczną';
        emit(
          current.copyWith(
            isActionInProgress: false,
            feedback: ProjectRecurrenceFeedbackSuccess(msg),
          ),
        );
        unawaited(load());
        return true;
      },
    );
  }

  /// Wywołuje natychmiastowe utworzenie kolejnego wystąpienia serii.
  Future<bool> triggerRunNow(ProjectTaskRecurrenceItemResponse rule) async {
    final current = state;
    if (current is! ProjectRecurrencesLoaded) return false;

    emit(current.copyWith(isActionInProgress: true, clearFeedback: true));

    final result = await repository.triggerRunNow(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: rule.sourceTaskId,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(
          current.copyWith(
            isActionInProgress: false,
            feedback: ProjectRecurrenceFeedbackError(error.message),
          ),
        );
        return false;
      },
      (success) {
        emit(
          current.copyWith(
            isActionInProgress: false,
            feedback: const ProjectRecurrenceFeedbackSuccess(
              'Pomyślnie wygenerowano nowe wystąpienie zadania',
            ),
          ),
        );
        unawaited(load());
        return true;
      },
    );
  }

  /// Usuwa regułę cykliczną dla zadania.
  Future<bool> deleteRule(ProjectTaskRecurrenceItemResponse rule) async {
    final current = state;
    if (current is! ProjectRecurrencesLoaded) return false;

    emit(current.copyWith(isActionInProgress: true, clearFeedback: true));

    final result = await repository.delete(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: rule.sourceTaskId,
      expectedVersion: rule.version,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(
          current.copyWith(
            isActionInProgress: false,
            feedback: ProjectRecurrenceFeedbackError(error.message),
          ),
        );
        return false;
      },
      (success) {
        emit(
          current.copyWith(
            isActionInProgress: false,
            feedback: const ProjectRecurrenceFeedbackSuccess(
              'Pomyślnie usunięto cykliczność zadania',
            ),
          ),
        );
        unawaited(load());
        return true;
      },
    );
  }

  void _onRealtimeUpdate(dynamic update) {
    if (isClosed) return;
    unawaited(load());
  }

  @override
  Future<void> close() {
    unawaited(_updatesSub?.cancel());
    return super.close();
  }
}
