import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TaskMilestoneState {
  const TaskMilestoneState();
}

final class TaskMilestoneLoading extends TaskMilestoneState {
  const TaskMilestoneLoading();
}

final class TaskMilestoneFailure extends TaskMilestoneState {
  const TaskMilestoneFailure(this.message);

  final String message;
}

final class TaskMilestoneReady extends TaskMilestoneState {
  const TaskMilestoneReady({
    required this.milestones,
    this.assigned,
    this.isSaving = false,
    this.error,
  });

  final List<MilestoneResponse> milestones;
  final MilestoneResponse? assigned;
  final bool isSaving;
  final String? error;

  TaskMilestoneReady copyWith({
    MilestoneResponse? assigned,
    bool clearAssigned = false,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => TaskMilestoneReady(
    milestones: milestones,
    assigned: clearAssigned ? null : assigned ?? this.assigned,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
  );
}

/// Odczytuje i mutuje faktyczne przypisanie jednego zadania do milestone’u.
final class TaskMilestoneCubit extends Cubit<TaskMilestoneState> {
  TaskMilestoneCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  }) : super(const TaskMilestoneLoading());

  final MilestoneRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;

  Future<void> load() async {
    emit(const TaskMilestoneLoading());
    final milestonesResult = await repository.listMilestones(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    await milestonesResult.fold(
      (error) async => emit(TaskMilestoneFailure(error.message)),
      (milestones) async {
        for (final milestone in milestones) {
          final tasksResult = await repository.listTasks(
            workspaceId: workspaceId,
            projectId: projectId,
            milestoneId: milestone.id,
          );
          if (isClosed) return;
          String? errorMessage;
          var containsTask = false;
          tasksResult.fold(
            (error) => errorMessage = error.message,
            (tasks) => containsTask = tasks.any((task) => task.id == taskId),
          );
          if (errorMessage case final message?) {
            emit(TaskMilestoneFailure(message));
            return;
          }
          if (containsTask) {
            emit(
              TaskMilestoneReady(milestones: milestones, assigned: milestone),
            );
            return;
          }
        }
        emit(TaskMilestoneReady(milestones: milestones));
      },
    );
  }

  Future<bool> assign(MilestoneResponse milestone) async {
    final current = state;
    if (current is! TaskMilestoneReady ||
        current.isSaving ||
        current.assigned != null) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.assignTask(
      workspaceId: workspaceId,
      projectId: projectId,
      milestoneId: milestone.id,
      taskId: taskId,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (_) {
        emit(current.copyWith(assigned: milestone, isSaving: false));
        return true;
      },
    );
  }

  Future<bool> unassign() async {
    final current = state;
    final assigned = current is TaskMilestoneReady ? current.assigned : null;
    if (current is! TaskMilestoneReady ||
        current.isSaving ||
        assigned == null) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.unassignTask(
      workspaceId: workspaceId,
      projectId: projectId,
      milestoneId: assigned.id,
      taskId: taskId,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (_) {
        emit(current.copyWith(clearAssigned: true, isSaving: false));
        return true;
      },
    );
  }
}
