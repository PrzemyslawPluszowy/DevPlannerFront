import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';

sealed class TaskLabelsSettingsState {
  const TaskLabelsSettingsState();
}

final class TaskLabelsSettingsInitial extends TaskLabelsSettingsState {
  const TaskLabelsSettingsInitial();
}

final class TaskLabelsSettingsLoading extends TaskLabelsSettingsState {
  const TaskLabelsSettingsLoading();
}

final class TaskLabelsSettingsFailure extends TaskLabelsSettingsState {
  const TaskLabelsSettingsFailure(this.message);

  final String message;
}

final class TaskLabelsSettingsReady extends TaskLabelsSettingsState {
  const TaskLabelsSettingsReady({
    required this.labels,
    this.isSaving = false,
    this.error,
  });

  final List<TaskLabelResponse> labels;
  final bool isSaving;
  final String? error;

  TaskLabelsSettingsReady copyWith({
    List<TaskLabelResponse>? labels,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => TaskLabelsSettingsReady(
    labels: labels ?? this.labels,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
  );
}

/// Stan i mutacje katalogu etykiet projektu.
final class TaskLabelsSettingsCubit extends Cubit<TaskLabelsSettingsState> {
  TaskLabelsSettingsCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskLabelsSettingsInitial());

  final TaskMetadataRepository repository;
  final String workspaceId;
  final String projectId;

  Future<void> load() async {
    emit(const TaskLabelsSettingsLoading());
    final result = await repository.listLabels(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(TaskLabelsSettingsFailure(error.message)),
      (labels) => emit(TaskLabelsSettingsReady(labels: _sorted(labels))),
    );
  }

  Future<bool> save({
    TaskLabelResponse? existing,
    required String name,
    required String color,
  }) async {
    final current = state;
    final normalizedName = name.trim();
    final normalizedColor = color.trim().toUpperCase();
    if (current is! TaskLabelsSettingsReady ||
        current.isSaving ||
        normalizedName.isEmpty ||
        !RegExp(r'^#[0-9A-F]{6}$').hasMatch(normalizedColor)) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = existing == null
        ? await repository.createLabel(
            workspaceId: workspaceId,
            projectId: projectId,
            payload: CreateTaskLabelPayload(
              name: normalizedName,
              color: normalizedColor,
            ),
          )
        : await repository.updateLabel(
            workspaceId: workspaceId,
            projectId: projectId,
            labelId: existing.id,
            payload: UpdateTaskLabelPayload(
              name: normalizedName,
              color: normalizedColor,
            ),
          );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (label) {
        final labels = [
          for (final item in current.labels)
            if (item.id != label.id) item,
          label,
        ];
        emit(TaskLabelsSettingsReady(labels: _sorted(labels)));
        return true;
      },
    );
  }

  Future<bool> archive(TaskLabelResponse label) async {
    final current = state;
    if (current is! TaskLabelsSettingsReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.archiveLabel(
      workspaceId: workspaceId,
      projectId: projectId,
      labelId: label.id,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (_) {
        emit(
          TaskLabelsSettingsReady(
            labels: current.labels
                .where((item) => item.id != label.id)
                .toList(),
          ),
        );
        return true;
      },
    );
  }

  static List<TaskLabelResponse> _sorted(List<TaskLabelResponse> labels) =>
      [...labels]..sort((left, right) => left.name.compareTo(right.name));
}
