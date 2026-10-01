import 'package:devplanner/foundation/error/api_error.dart';

sealed class TaskRecurrenceTimeZonesState {
  const TaskRecurrenceTimeZonesState();
}

final class TaskRecurrenceTimeZonesLoading
    extends TaskRecurrenceTimeZonesState {
  const TaskRecurrenceTimeZonesLoading();
}

final class TaskRecurrenceTimeZonesFailure
    extends TaskRecurrenceTimeZonesState {
  const TaskRecurrenceTimeZonesFailure(this.error, {this.canRetry = true});

  final ApiError error;
  final bool canRetry;
}

final class TaskRecurrenceTimeZonesReady extends TaskRecurrenceTimeZonesState {
  const TaskRecurrenceTimeZonesReady({
    required this.allZones,
    required this.visibleZones,
    required this.query,
    required this.currentIdIsUnlisted,
  });

  final List<String> allZones;
  final List<String> visibleZones;
  final String query;
  final bool currentIdIsUnlisted;
}
