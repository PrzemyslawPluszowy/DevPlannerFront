import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_history_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan lokalnego, cursorowego panelu historii pojedynczego zadania.
sealed class TaskHistoryState {
  const TaskHistoryState();
}

final class TaskHistoryInitial extends TaskHistoryState {
  const TaskHistoryInitial();
}

final class TaskHistoryLoading extends TaskHistoryState {
  const TaskHistoryLoading();
}

final class TaskHistoryFailure extends TaskHistoryState {
  const TaskHistoryFailure(this.message);

  final String message;
}

final class TaskHistoryReady extends TaskHistoryState {
  const TaskHistoryReady({
    required this.events,
    required this.nextCursor,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<TaskHistoryEventResponse> events;
  final String? nextCursor;
  final bool isLoadingMore;
  final String? loadMoreError;

  bool get hasMore => nextCursor != null;

  TaskHistoryReady copyWith({
    List<TaskHistoryEventResponse>? events,
    String? nextCursor,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) => TaskHistoryReady(
    events: events ?? this.events,
    nextCursor: nextCursor ?? this.nextCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreError: clearLoadMoreError
        ? null
        : loadMoreError ?? this.loadMoreError,
  );
}

/// Ładuje historię biznesową tylko podczas otwartego panelu szczegółów.
final class TaskHistoryCubit extends Cubit<TaskHistoryState> {
  TaskHistoryCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  }) : super(const TaskHistoryInitial());

  final TaskHistoryRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  int _requestSerial = 0;

  /// Ponownie pobiera pierwszą stronę, np. po błędzie lub po otwarciu panelu.
  Future<void> load() => _fetch(reset: true);

  /// Dopina kolejną stronę, zachowując stabilną kolejność i deduplikację ID.
  Future<void> loadMore() async {
    final current = state;
    if (current is! TaskHistoryReady ||
        current.isLoadingMore ||
        !current.hasMore) {
      return;
    }
    await _fetch(reset: false, current: current);
  }

  Future<void> _fetch({
    required bool reset,
    TaskHistoryReady? current,
  }) async {
    final serial = ++_requestSerial;
    if (reset) {
      emit(const TaskHistoryLoading());
    } else {
      emit(current!.copyWith(isLoadingMore: true, clearLoadMoreError: true));
    }

    final result = await repository.listHistory(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      cursor: reset ? null : current!.nextCursor,
    );
    if (isClosed || serial != _requestSerial) return;

    result.fold(
      (error) {
        if (reset) {
          emit(TaskHistoryFailure(error.message));
        } else {
          emit(
            current!.copyWith(
              isLoadingMore: false,
              loadMoreError: error.message,
            ),
          );
        }
      },
      (page) {
        final events = reset
            ? _deduplicate(page.items)
            : _deduplicate([...current!.events, ...page.items]);
        emit(TaskHistoryReady(events: events, nextCursor: page.nextCursor));
      },
    );
  }

  List<TaskHistoryEventResponse> _deduplicate(
    Iterable<TaskHistoryEventResponse> events,
  ) {
    final seenIds = <String>{};
    return [
      for (final event in events)
        if (seenIds.add(event.eventId)) event,
    ];
  }
}
