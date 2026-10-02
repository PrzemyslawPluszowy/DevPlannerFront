import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_retry_after_gate.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_entry_reviewer_name_lookup.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_state.dart';
import 'package:flutter/foundation.dart';

/// Ogranicza równoległe odczyty nazw i zarządza ich osobnym cooldownem.
final class TaskTimeEntryReviewerLookupGate {
  TaskTimeEntryReviewerLookupGate({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  });

  final _retryAfter = TaskDetailRetryAfterGate();
  final ProjectMemberProfilesRepository? repository;
  final String workspaceId;
  final String projectId;
  int _serial = 0;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool get isRetryBlocked => _retryAfter.isBlocked;

  int? begin() {
    if (_isLoading || isRetryBlocked) return null;
    _isLoading = true;
    return ++_serial;
  }

  bool isCurrent(int serial) => serial == _serial;

  Future<TaskTimeReviewerLookupOutcome?> lookup({
    required TaskTimeTrackingReady current,
    required bool refreshUnseen,
    required bool forceRefresh,
    required VoidCallback onStarted,
    required VoidCallback onRetryAvailable,
  }) async {
    final serial = begin();
    if (serial == null) return null;
    onStarted();
    final request = await TaskTimeEntryReviewerNameLookup.loadForEntries(
      repository: repository,
      workspaceId: workspaceId,
      projectId: projectId,
      entries: current.entries,
      alreadyLookedUp: current.reviewerIdsLookedUp,
      refreshUnseen: refreshUnseen,
      forceRefresh: forceRefresh,
    );
    if (!isCurrent(serial)) return null;
    final response = request.result;
    if (response?.failure case final failure?) {
      fail(serial, failure, onRetryAvailable: onRetryAvailable);
      return (
        serial: serial,
        reviewerIds: request.reviewerIds,
        names: const <String, String>{},
        failure: failure,
        retryBlocked: isRetryBlocked,
      );
    }
    complete(serial);
    return (
      serial: serial,
      reviewerIds: request.reviewerIds,
      names: response?.names ?? const <String, String>{},
      failure: null,
      retryBlocked: false,
    );
  }

  void complete(int serial) {
    if (!isCurrent(serial)) return;
    _isLoading = false;
    _retryAfter.clear();
  }

  void fail(
    int serial,
    ApiError error, {
    required VoidCallback onRetryAvailable,
  }) {
    if (!isCurrent(serial)) return;
    _isLoading = false;
    _retryAfter.schedule(error, onAvailable: onRetryAvailable);
  }

  void cancelPending() {
    _serial++;
    _isLoading = false;
  }

  void dispose() => _retryAfter.dispose();
}

typedef TaskTimeReviewerLookupOutcome = ({
  int serial,
  Set<String> reviewerIds,
  Map<String, String> names,
  ApiError? failure,
  bool retryBlocked,
});
