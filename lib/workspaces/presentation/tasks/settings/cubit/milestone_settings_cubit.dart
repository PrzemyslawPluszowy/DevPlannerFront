import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class MilestoneSettingsState {
  const MilestoneSettingsState();
}

final class MilestoneSettingsInitial extends MilestoneSettingsState {
  const MilestoneSettingsInitial();
}

final class MilestoneSettingsLoading extends MilestoneSettingsState {
  const MilestoneSettingsLoading();
}

final class MilestoneSettingsFailure extends MilestoneSettingsState {
  const MilestoneSettingsFailure(this.message);

  final String message;
}

final class MilestoneSettingsReady extends MilestoneSettingsState {
  const MilestoneSettingsReady({
    required this.milestones,
    this.tasksByMilestone = const {},
    this.loadingTaskMilestoneIds = const {},
    this.isSaving = false,
    this.error,
  });

  final List<MilestoneResponse> milestones;
  final Map<String, List<MilestoneTaskResponse>> tasksByMilestone;
  final Set<String> loadingTaskMilestoneIds;
  final bool isSaving;
  final String? error;

  MilestoneSettingsReady copyWith({
    List<MilestoneResponse>? milestones,
    Map<String, List<MilestoneTaskResponse>>? tasksByMilestone,
    Set<String>? loadingTaskMilestoneIds,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => MilestoneSettingsReady(
    milestones: milestones ?? this.milestones,
    tasksByMilestone: tasksByMilestone ?? this.tasksByMilestone,
    loadingTaskMilestoneIds:
        loadingTaskMilestoneIds ?? this.loadingTaskMilestoneIds,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
  );
}

/// Konfiguracja kamieni milowych jednego projektu.
final class MilestoneSettingsCubit extends Cubit<MilestoneSettingsState> {
  MilestoneSettingsCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const MilestoneSettingsInitial());

  final MilestoneRepository repository;
  final String workspaceId;
  final String projectId;

  Future<void> load() async {
    emit(const MilestoneSettingsLoading());
    final result = await repository.listMilestones(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(MilestoneSettingsFailure(error.message)),
      (milestones) =>
          emit(MilestoneSettingsReady(milestones: _sorted(milestones))),
    );
  }

  Future<bool> save({
    MilestoneResponse? existing,
    required String name,
    required String description,
    required DateTime? dueAtUtc,
    required MilestoneStatus status,
  }) async {
    final current = state;
    final normalizedName = name.trim();
    if (current is! MilestoneSettingsReady ||
        current.isSaving ||
        normalizedName.isEmpty) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final normalizedDescription = description.trim();
    final result = existing == null
        ? await repository.createMilestone(
            workspaceId: workspaceId,
            projectId: projectId,
            payload: CreateMilestonePayload(
              name: normalizedName,
              description: normalizedDescription.isEmpty
                  ? null
                  : normalizedDescription,
              dueAtUtc: dueAtUtc,
            ),
          )
        : await repository.updateMilestone(
            workspaceId: workspaceId,
            projectId: projectId,
            milestoneId: existing.id,
            payload: UpdateMilestonePayload(
              name: normalizedName,
              description: normalizedDescription.isEmpty
                  ? null
                  : normalizedDescription,
              dueAtUtc: dueAtUtc,
              status: status,
            ),
          );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (milestone) {
        emit(
          MilestoneSettingsReady(
            milestones: _sorted([
              for (final item in current.milestones)
                if (item.id != milestone.id) item,
              milestone,
            ]),
          ),
        );
        return true;
      },
    );
  }

  Future<bool> delete(MilestoneResponse milestone) async {
    final current = state;
    if (current is! MilestoneSettingsReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.deleteMilestone(
      workspaceId: workspaceId,
      projectId: projectId,
      milestoneId: milestone.id,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (_) {
        emit(
          MilestoneSettingsReady(
            milestones: current.milestones
                .where((item) => item.id != milestone.id)
                .toList(),
          ),
        );
        return true;
      },
    );
  }

  /// Ładuje zadania dopiero po rozwinięciu konkretnego milestone’u.
  Future<void> loadTasks(MilestoneResponse milestone) async {
    final current = state;
    if (current is! MilestoneSettingsReady ||
        current.loadingTaskMilestoneIds.contains(milestone.id)) {
      return;
    }
    emit(
      current.copyWith(
        loadingTaskMilestoneIds: {
          ...current.loadingTaskMilestoneIds,
          milestone.id,
        },
      ),
    );
    final result = await repository.listTasks(
      workspaceId: workspaceId,
      projectId: projectId,
      milestoneId: milestone.id,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        current.copyWith(
          loadingTaskMilestoneIds: ({...current.loadingTaskMilestoneIds}
            ..remove(milestone.id)),
          error: error.message,
        ),
      ),
      (tasks) => emit(
        current.copyWith(
          tasksByMilestone: {...current.tasksByMilestone, milestone.id: tasks},
          loadingTaskMilestoneIds: ({...current.loadingTaskMilestoneIds}
            ..remove(milestone.id)),
        ),
      ),
    );
  }

  Future<bool> unassignTask({
    required MilestoneResponse milestone,
    required MilestoneTaskResponse task,
  }) async {
    final current = state;
    if (current is! MilestoneSettingsReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.unassignTask(
      workspaceId: workspaceId,
      projectId: projectId,
      milestoneId: milestone.id,
      taskId: task.id,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (_) {
        emit(
          current.copyWith(
            isSaving: false,
            tasksByMilestone: {
              ...current.tasksByMilestone,
              milestone.id: [
                ...?current.tasksByMilestone[milestone.id],
              ].where((item) => item.id != task.id).toList(),
            },
          ),
        );
        return true;
      },
    );
  }

  static List<MilestoneResponse> _sorted(List<MilestoneResponse> milestones) =>
      [...milestones]..sort((left, right) {
        final leftDue = left.dueAtUtc ?? DateTime(9999);
        final rightDue = right.dueAtUtc ?? DateTime(9999);
        return leftDue.compareTo(rightDue);
      });
}
