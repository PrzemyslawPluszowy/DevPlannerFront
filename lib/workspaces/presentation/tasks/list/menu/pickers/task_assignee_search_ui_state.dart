import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';

/// Widok wyszukiwania członków i stan błędu bieżącego żądania.
final class TaskAssigneeSearchUiState {
  const TaskAssigneeSearchUiState({
    required this.visible,
    this.query = '',
    this.nextCursor,
    this.isSearching = false,
    this.isLoadingMore = false,
    this.hasLoaded = false,
    this.error,
    this.errorOnNextPage = false,
  });

  final List<ProjectMemberProfile> visible;
  final String query;
  final String? nextCursor;
  final bool isSearching;
  final bool isLoadingMore;
  final bool hasLoaded;
  final ApiError? error;
  final bool errorOnNextPage;

  TaskAssigneeSearchUiState copyWith({
    List<ProjectMemberProfile>? visible,
    String? query,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? isSearching,
    bool? isLoadingMore,
    bool? hasLoaded,
    ApiError? error,
    bool clearError = false,
    bool? errorOnNextPage,
  }) => TaskAssigneeSearchUiState(
    visible: visible ?? this.visible,
    query: query ?? this.query,
    nextCursor: clearNextCursor ? null : nextCursor ?? this.nextCursor,
    isSearching: isSearching ?? this.isSearching,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    hasLoaded: hasLoaded ?? this.hasLoaded,
    error: clearError ? null : error ?? this.error,
    errorOnNextPage: errorOnNextPage ?? this.errorOnNextPage,
  );
}
