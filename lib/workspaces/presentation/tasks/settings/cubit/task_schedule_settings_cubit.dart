import 'package:devplanner/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TaskScheduleSettingsState {
  const TaskScheduleSettingsState();
}

final class TaskScheduleSettingsLoading extends TaskScheduleSettingsState {
  const TaskScheduleSettingsLoading();
}

final class TaskScheduleSettingsFailure extends TaskScheduleSettingsState {
  const TaskScheduleSettingsFailure(this.message);
  final String message;
}

final class TaskScheduleSettingsReady extends TaskScheduleSettingsState {
  const TaskScheduleSettingsReady({
    required this.mode,
    required this.holidays,
    this.isSavingMode = false,
    this.busyHolidayId,
    this.error,
  });

  final AutoScheduleMode mode;
  final List<WorkspaceHolidayResponse> holidays;
  final bool isSavingMode;
  final String? busyHolidayId;
  final String? error;

  TaskScheduleSettingsReady copyWith({
    AutoScheduleMode? mode,
    List<WorkspaceHolidayResponse>? holidays,
    bool? isSavingMode,
    String? busyHolidayId,
    bool clearBusyHoliday = false,
    String? error,
    bool clearError = false,
  }) => TaskScheduleSettingsReady(
    mode: mode ?? this.mode,
    holidays: holidays ?? this.holidays,
    isSavingMode: isSavingMode ?? this.isSavingMode,
    busyHolidayId: clearBusyHoliday
        ? null
        : busyHolidayId ?? this.busyHolidayId,
    error: clearError ? null : error ?? this.error,
  );
}

/// Zarządza trybem harmonogramu i wspólnym kalendarzem dni wolnych.
final class TaskScheduleSettingsCubit extends Cubit<TaskScheduleSettingsState> {
  TaskScheduleSettingsCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskScheduleSettingsLoading());

  final TaskScheduleRepository repository;
  final String workspaceId;
  final String projectId;

  Future<void> load() async {
    emit(const TaskScheduleSettingsLoading());
    final settingsResult = await repository.getSettings(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    final holidaysResult = await repository.listHolidays(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    settingsResult.fold(
      (error) => emit(TaskScheduleSettingsFailure(error.message)),
      (settings) => holidaysResult.fold(
        (error) => emit(TaskScheduleSettingsFailure(error.message)),
        (holidays) => emit(
          TaskScheduleSettingsReady(
            mode: settings.mode,
            holidays: holidays,
          ),
        ),
      ),
    );
  }

  Future<void> setMode(AutoScheduleMode mode) async {
    final current = state;
    if (current is! TaskScheduleSettingsReady || current.isSavingMode) return;
    emit(current.copyWith(mode: mode, isSavingMode: true, clearError: true));
    final result = await repository.setMode(
      workspaceId: workspaceId,
      projectId: projectId,
      mode: mode,
    );
    final latest = state;
    if (isClosed || latest is! TaskScheduleSettingsReady) return;
    result.fold(
      (error) => emit(current.copyWith(error: error.message)),
      (_) => emit(latest.copyWith(isSavingMode: false)),
    );
  }

  Future<void> addHoliday(DateTime date, String name) async {
    final current = state;
    if (current is! TaskScheduleSettingsReady) return;
    final result = await repository.addHoliday(
      workspaceId: workspaceId,
      projectId: projectId,
      date: date,
      name: name.trim(),
    );
    final latest = state;
    if (isClosed || latest is! TaskScheduleSettingsReady) return;
    result.fold(
      (error) => emit(latest.copyWith(error: error.message)),
      (holiday) => emit(
        latest.copyWith(
          holidays: [...latest.holidays, holiday]
            ..sort((a, b) => a.date.compareTo(b.date)),
        ),
      ),
    );
  }

  Future<void> deleteHoliday(String holidayId) async {
    final current = state;
    if (current is! TaskScheduleSettingsReady ||
        current.busyHolidayId != null) {
      return;
    }
    emit(current.copyWith(busyHolidayId: holidayId, clearError: true));
    final result = await repository.deleteHoliday(
      workspaceId: workspaceId,
      projectId: projectId,
      holidayId: holidayId,
    );
    final latest = state;
    if (isClosed || latest is! TaskScheduleSettingsReady) return;
    result.fold(
      (error) =>
          emit(latest.copyWith(error: error.message, clearBusyHoliday: true)),
      (_) => emit(
        latest.copyWith(
          holidays: latest.holidays
              .where((item) => item.id != holidayId)
              .toList(),
          clearBusyHoliday: true,
        ),
      ),
    );
  }
}
