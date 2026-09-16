import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';

sealed class TaskTimelineState {
  const TaskTimelineState();
}

final class TaskTimelineLoading extends TaskTimelineState {
  const TaskTimelineLoading();
}

final class TaskTimelineFailure extends TaskTimelineState {
  const TaskTimelineFailure(this.message);
  final String message;
}

final class TaskTimelineReady extends TaskTimelineState {
  const TaskTimelineReady({
    required this.timeline,
    required this.fromUtc,
    required this.toUtc,
  });
  final TaskTimelineResponse timeline;
  final DateTime fromUtc;
  final DateTime toUtc;
}

/// Steruje cursorowym snapshotem Gantta w zakresie wybranym przez użytkownika.
final class TaskTimelineCubit extends Cubit<TaskTimelineState> {
  TaskTimelineCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskTimelineLoading());

  final TasksRepository repository;
  final String workspaceId;
  final String projectId;

  Future<void> load({DateTime? fromUtc, DateTime? toUtc}) async {
    final now = DateTime.now().toUtc();
    final from = fromUtc ?? DateTime.utc(now.year, now.month);
    final to = toUtc ?? DateTime.utc(now.year, now.month + 3);
    if (!to.isAfter(from)) return;
    emit(const TaskTimelineLoading());
    final result = await repository.getProjectTimeline(
      workspaceId: workspaceId,
      projectId: projectId,
      query: ProjectTaskTimelineQuery(fromUtc: from, toUtc: to),
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(TaskTimelineFailure(error.message)),
      (timeline) => emit(
        TaskTimelineReady(timeline: timeline, fromUtc: from, toUtc: to),
      ),
    );
  }
}
