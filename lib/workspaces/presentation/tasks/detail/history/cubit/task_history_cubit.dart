import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_history_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/history/task_history_changes.dart';
import 'package:dio/dio.dart';
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
  const TaskHistoryFailure(this.message, {this.apiError});

  final String message;
  final ApiError? apiError;
}

final class TaskHistoryReady extends TaskHistoryState {
  const TaskHistoryReady({
    required this.events,
    required this.nextCursor,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.loadMoreFailure,
    this.actorNames = const {},
    this.actorLookupFailure,
  });

  final List<TaskHistoryEventResponse> events;
  final String? nextCursor;
  final bool isLoadingMore;
  final String? loadMoreError;
  final ApiError? loadMoreFailure;
  final Map<String, String> actorNames;
  final ApiError? actorLookupFailure;

  bool get hasMore => nextCursor != null;

  TaskHistoryReady copyWith({
    List<TaskHistoryEventResponse>? events,
    String? nextCursor,
    bool? isLoadingMore,
    String? loadMoreError,
    ApiError? loadMoreFailure,
    bool clearLoadMoreError = false,
  }) => TaskHistoryReady(
    events: events ?? this.events,
    nextCursor: nextCursor ?? this.nextCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreFailure: clearLoadMoreError
        ? null
        : loadMoreFailure ?? this.loadMoreFailure,
    loadMoreError: clearLoadMoreError
        ? null
        : loadMoreError ?? this.loadMoreError,
    actorNames: actorNames,
    actorLookupFailure: actorLookupFailure,
  );
}

/// Ładuje historię biznesową tylko podczas otwartego panelu szczegółów.
final class TaskHistoryCubit extends Cubit<TaskHistoryState> {
  TaskHistoryCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    this.onAccessLost,
    this.memberProfilesRepository,
  }) : super(const TaskHistoryInitial());

  final TaskHistoryRepository repository;
  final ProjectMemberProfilesRepository? memberProfilesRepository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  int _requestSerial = 0;
  final void Function(ApiError)? onAccessLost;

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
    if (isClosed) return;
    final serial = ++_requestSerial;
    if (reset) {
      emit(const TaskHistoryLoading());
    } else {
      emit(current!.copyWith(isLoadingMore: true, clearLoadMoreError: true));
    }

    final result = await _readHistory(reset ? null : current!.nextCursor);
    if (isClosed || serial != _requestSerial) return;
    final members = reset && result.isRight()
        ? await _loadActorNames()
        : (
            names: current?.actorNames ?? const <String, String>{},
            failure: current?.actorLookupFailure,
          );
    if (isClosed || serial != _requestSerial) return;
    final lookupFailure = members.failure;
    if (lookupFailure != null &&
        (lookupFailure.type == ApiErrorType.unauthorized ||
            lookupFailure.type == ApiErrorType.forbidden ||
            lookupFailure.type == ApiErrorType.notFound)) {
      emit(TaskHistoryFailure(lookupFailure.message, apiError: lookupFailure));
      onAccessLost?.call(lookupFailure);
      return;
    }

    result.fold(
      (error) {
        final accessFailure =
            error.type == ApiErrorType.unauthorized ||
            error.type == ApiErrorType.forbidden ||
            error.type == ApiErrorType.notFound;
        if (reset || accessFailure) {
          emit(TaskHistoryFailure(error.message, apiError: error));
          if (accessFailure) onAccessLost?.call(error);
        } else {
          emit(
            current!.copyWith(
              isLoadingMore: false,
              loadMoreError: error.message,
              loadMoreFailure: error,
            ),
          );
        }
      },
      (page) {
        final events = reset
            ? _deduplicate(page.items)
            : _deduplicate([...current!.events, ...page.items]);
        emit(
          TaskHistoryReady(
            events: events,
            nextCursor: page.nextCursor,
            actorNames: members.names,
            actorLookupFailure: members.failure,
          ),
        );
      },
    );
  }

  Future<Either<ApiError, CursorPageResponse<TaskHistoryEventResponse>>>
  _readHistory(String? cursor) async {
    try {
      return await repository.listHistory(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        cursor: cursor,
      );
    } catch (error) {
      return Left(_failure(error, 'task_history_read_failed'));
    }
  }

  Future<({Map<String, String> names, ApiError? failure})>
  _loadActorNames() async {
    final profiles = memberProfilesRepository;
    if (profiles == null) {
      return (names: const <String, String>{}, failure: null);
    }
    try {
      final result = await profiles.listProfiles(
        workspaceId: workspaceId,
        projectId: projectId,
      );
      return result.fold<({Map<String, String> names, ApiError? failure})>(
        (error) => (names: const <String, String>{}, failure: error),
        (members) => (
          names: Map<String, String>.unmodifiable({
            for (final member in members)
              if (member.displayName?.trim().isNotEmpty == true)
                member.userId: member.displayName!.trim(),
          }),
          failure: null,
        ),
      );
    } catch (error) {
      return (
        names: const <String, String>{},
        failure: _failure(error, 'task_history_actor_lookup_failed'),
      );
    }
  }

  static ApiError _failure(Object error, String code) => switch (error) {
    ApiError() => error,
    DioException() => ApiError.fromDioException(error, fallbackMessage: ''),
    _ => ApiError(type: ApiErrorType.unknown, message: '', contractCode: code),
  };

  List<TaskHistoryEventResponse> _deduplicate(
    Iterable<TaskHistoryEventResponse> events,
  ) {
    final seenIds = <String>{};
    return [
      for (final event in events)
        if (seenIds.add(event.eventId)) TaskHistoryChanges.prepare(event),
    ];
  }
}
