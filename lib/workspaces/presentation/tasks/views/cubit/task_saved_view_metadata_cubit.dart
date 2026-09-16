import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';

@immutable
sealed class TaskSavedViewMetadataState {
  const TaskSavedViewMetadataState();
}

final class TaskSavedViewMetadataLoading extends TaskSavedViewMetadataState {
  const TaskSavedViewMetadataLoading();
}

final class TaskSavedViewMetadataFailure extends TaskSavedViewMetadataState {
  const TaskSavedViewMetadataFailure(this.message);

  final String message;
}

final class TaskSavedViewMetadataReady extends TaskSavedViewMetadataState {
  const TaskSavedViewMetadataReady({
    required this.labels,
    required this.customFields,
  });

  final List<TaskLabelResponse> labels;
  final List<TaskCustomFieldResponse> customFields;
}

/// Ładuje metadane potrzebne konfiguratorowi widoku poza warstwą widgetów.
final class TaskSavedViewMetadataCubit
    extends Cubit<TaskSavedViewMetadataState> {
  TaskSavedViewMetadataCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskSavedViewMetadataLoading());

  final TaskMetadataRepository repository;
  final String workspaceId;
  final String projectId;

  Future<void> load() async {
    emit(const TaskSavedViewMetadataLoading());
    final labelsFuture = repository.listLabels(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    final fieldsFuture = repository.listCustomFields(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    final labelsResult = await labelsFuture;
    final fieldsResult = await fieldsFuture;
    if (isClosed) return;
    final labelsError = labelsResult.fold((error) => error, (_) => null);
    final fieldsError = fieldsResult.fold((error) => error, (_) => null);
    final error = labelsError ?? fieldsError;
    if (error != null) {
      emit(TaskSavedViewMetadataFailure(error.message));
      return;
    }

    emit(
      TaskSavedViewMetadataReady(
        labels: labelsResult.fold((_) => const [], (value) => value),
        customFields: fieldsResult.fold((_) => const [], (value) => value),
      ),
    );
  }
}
