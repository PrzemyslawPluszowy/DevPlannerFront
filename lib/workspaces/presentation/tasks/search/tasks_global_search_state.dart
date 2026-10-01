import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:equatable/equatable.dart';

/// Current query, cursor page, and recoverable failure for task search.
final class TasksGlobalSearchState extends Equatable {
  const TasksGlobalSearchState({
    this.query = '',
    this.items = const [],
    this.nextCursor,
    this.failure,
    this.cooldownUntilUtc,
    this.retryWaitSeconds = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
  });

  final String query;
  final List<GlobalTaskSearchItemResponse> items;
  final String? nextCursor;
  final ApiError? failure;

  /// Shared deadline from the last throttled request, independent of query.
  final DateTime? cooldownUntilUtc;

  /// Rounded-up seconds until an explicit retry is allowed.
  final int retryWaitSeconds;
  final bool isLoading;
  final bool isLoadingMore;

  TasksGlobalSearchState copyWith({
    String? query,
    List<GlobalTaskSearchItemResponse>? items,
    String? nextCursor,
    bool clearCursor = false,
    ApiError? failure,
    bool clearFailure = false,
    DateTime? cooldownUntilUtc,
    bool clearCooldown = false,
    int? retryWaitSeconds,
    bool? isLoading,
    bool? isLoadingMore,
  }) => TasksGlobalSearchState(
    query: query ?? this.query,
    items: items ?? this.items,
    nextCursor: clearCursor ? null : nextCursor ?? this.nextCursor,
    failure: clearFailure ? null : failure ?? this.failure,
    cooldownUntilUtc: clearCooldown
        ? null
        : cooldownUntilUtc ?? this.cooldownUntilUtc,
    retryWaitSeconds: clearCooldown
        ? 0
        : retryWaitSeconds ?? this.retryWaitSeconds,
    isLoading: isLoading ?? this.isLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );

  @override
  List<Object?> get props => [
    query,
    items,
    nextCursor,
    failure,
    cooldownUntilUtc,
    retryWaitSeconds,
    isLoading,
    isLoadingMore,
  ];
}
