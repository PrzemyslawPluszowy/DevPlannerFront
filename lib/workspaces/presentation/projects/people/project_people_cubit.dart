import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/models/project_people_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ProjectPeopleState {
  const ProjectPeopleState({
    this.members = const [],
    this.visibleMembers = const [],
    this.query = '',
    this.isLoading = false,
    this.presenceIsFresh = false,
    this.onlineCount = 0,
    this.error,
  });

  final List<ProjectMemberProfile> members;
  final List<ProjectMemberProfile> visibleMembers;
  final String query;
  final bool isLoading;
  final bool presenceIsFresh;
  final int onlineCount;
  final ApiError? error;
}

/// Właściciel odczytu i odświeżania autoryzowanych osób dla jednego projektu.
final class ProjectPeopleCubit extends Cubit<ProjectPeopleState> {
  ProjectPeopleCubit(
    this.request, {
    this.refreshInterval = const Duration(seconds: 15),
  }) : super(const ProjectPeopleState()) {
    _publish(request.initialProfiles, fresh: request.presenceIsFresh);
    unawaited(refresh());
  }

  final ProjectPeopleRequest request;
  final Duration refreshInterval;
  Timer? _timer;
  int _generation = 0;
  bool _inFlight = false;

  void search(String query) {
    if (isClosed) return;
    _publish(
      state.members,
      query: query,
      fresh: state.presenceIsFresh,
      loading: state.isLoading,
      error: state.error,
    );
  }

  Future<void> refresh() async {
    if (isClosed || _inFlight) return;
    _inFlight = true;
    final generation = _generation;
    _publish(
      state.members,
      fresh: state.presenceIsFresh,
      loading: true,
      error: state.error,
    );
    try {
      final result = await request.repository.listProfiles(
        workspaceId: request.workspaceId,
        projectId: request.projectId,
        forceRefresh: true,
      );
      if (isClosed || generation != _generation) return;
      result.fold(
        (error) {
          final accessLost =
              error.type == ApiErrorType.unauthorized ||
              error.type == ApiErrorType.forbidden ||
              error.type == ApiErrorType.notFound;
          if (accessLost) {
            _timer?.cancel();
            _timer = null;
            request.repository.invalidate(
              workspaceId: request.workspaceId,
              projectId: request.projectId,
            );
          }
          _publish(
            accessLost ? const [] : state.members,
            fresh: false,
            error: error,
          );
        },
        (members) {
          _publish(members, fresh: true);
          _timer ??= Timer.periodic(
            refreshInterval,
            (_) => unawaited(refresh()),
          );
        },
      );
    } finally {
      _inFlight = false;
    }
  }

  void _publish(
    List<ProjectMemberProfile> members, {
    String? query,
    required bool fresh,
    bool loading = false,
    ApiError? error,
  }) {
    if (isClosed) return;
    final normalizedQuery = query ?? state.query;
    final sorted = List<ProjectMemberProfile>.of(members)..sort(_compare);
    final needle = normalizedQuery.trim().toLowerCase();
    final visible = needle.isEmpty
        ? sorted
        : sorted
              .where(
                (member) =>
                    (member.displayName ?? '').toLowerCase().contains(needle),
              )
              .toList();
    emit(
      ProjectPeopleState(
        members: List.unmodifiable(sorted),
        visibleMembers: List.unmodifiable(visible),
        query: normalizedQuery,
        isLoading: loading,
        presenceIsFresh: fresh,
        onlineCount: sorted.where((member) => member.isOnline == true).length,
        error: error,
      ),
    );
  }

  int _compare(ProjectMemberProfile a, ProjectMemberProfile b) {
    if (a.userId == b.userId) return 0;
    if (a.userId == request.ownerUserId) return -1;
    if (b.userId == request.ownerUserId) return 1;
    if (a.isOnline != b.isOnline) {
      if (a.isOnline == true) return -1;
      if (b.isOnline == true) return 1;
    }
    final name = (a.displayName ?? '').toLowerCase().compareTo(
      (b.displayName ?? '').toLowerCase(),
    );
    return name == 0 ? a.userId.compareTo(b.userId) : name;
  }

  @override
  Future<void> close() {
    _generation++;
    _timer?.cancel();
    _timer = null;
    return super.close();
  }
}
