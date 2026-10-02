import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_retry_after_gate.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_state.dart';

/// Buduje błędy sekcji czasu bez ukrywania zachowanych wpisów po błędzie GET.
final class TaskTimeTrackingErrorStateFactory {
  const TaskTimeTrackingErrorStateFactory._();

  static TaskTimeTrackingState loadFailure({
    required ApiError error,
    required TaskTimeTrackingReady? previousReady,
    required TaskDetailRetryAfterGate retryAfter,
    required void Function() onRetryAvailable,
  }) {
    retryAfter.schedule(error, onAvailable: onRetryAvailable);
    if (previousReady == null) {
      return TaskTimeTrackingFailure(
        error.message,
        apiError: error,
        isRetryBlocked: retryAfter.isBlocked,
      );
    }
    return previousReady.copyWith(
      isSaving: false,
      error: error.message,
      apiError: error,
      isRetryBlocked: retryAfter.isBlocked,
    );
  }

  static TaskTimeTrackingReady mutationFailure({
    required TaskTimeTrackingReady current,
    required ApiError error,
    required TaskDetailRetryAfterGate retryAfter,
    required void Function() onRetryAvailable,
  }) {
    retryAfter.schedule(error, onAvailable: onRetryAvailable);
    return current.copyWith(
      isSaving: false,
      error: error.message,
      apiError: error,
      isRetryBlocked: retryAfter.isBlocked,
    );
  }
}
