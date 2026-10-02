import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_state.dart';

/// Publikuje odblokowanie niezależnych akcji czasu i nazw weryfikujących.
final class TaskTimeTrackingRetryStatePublisher {
  const TaskTimeTrackingRetryStatePublisher._();

  static void time({
    required bool isClosed,
    required TaskTimeTrackingState state,
    required void Function(TaskTimeTrackingState) emit,
  }) {
    if (isClosed) return;
    switch (state) {
      case TaskTimeTrackingFailure(:final message, :final apiError):
        emit(TaskTimeTrackingFailure(message, apiError: apiError));
      case TaskTimeTrackingReady(:final isRetryBlocked) when isRetryBlocked:
        emit(state.copyWith(isRetryBlocked: false));
      default:
        break;
    }
  }

  static void reviewerNames({
    required bool isClosed,
    required TaskTimeTrackingState state,
    required void Function(TaskTimeTrackingState) emit,
  }) {
    if (isClosed || state is! TaskTimeTrackingReady) return;
    emit(state.copyWith(isReviewerLookupRetryBlocked: false));
  }
}
