import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_advanced_enums.dart';

part 'task_schedule_models.freezed.dart';
part 'task_schedule_models.g.dart';

/// Aktualny tryb automatycznego harmonogramu projektu.
@freezed
abstract class ProjectScheduleSettingsResponse
    with _$ProjectScheduleSettingsResponse {
  /// Tworzy odpowiedź ustawień harmonogramu.
  const factory ProjectScheduleSettingsResponse({
    required AutoScheduleMode mode,
  }) = _ProjectScheduleSettingsResponse;

  /// Odtwarza odpowiedź z kontraktu Workspaces.
  factory ProjectScheduleSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectScheduleSettingsResponseFromJson(json);
}

/// Payload podglądu kaskady terminów.
@freezed
abstract class PreviewScheduleCascadePayload
    with _$PreviewScheduleCascadePayload {
  /// Tworzy propozycję nowych dat zadania bazowego.
  const factory PreviewScheduleCascadePayload({
    required String taskId,
    required DateTime newStartAtUtc,
    required DateTime newDueAtUtc,
  }) = _PreviewScheduleCascadePayload;

  /// Odtwarza payload z JSON.
  factory PreviewScheduleCascadePayload.fromJson(Map<String, dynamic> json) =>
      _$PreviewScheduleCascadePayloadFromJson(json);
}

/// Payload zastosowania kaskady terminów.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ApplyScheduleCascadePayload with _$ApplyScheduleCascadePayload {
  /// Tworzy kaskadę z mapą oczekiwanych wersji.
  const factory ApplyScheduleCascadePayload({
    required String taskId,
    required DateTime newStartAtUtc,
    required DateTime newDueAtUtc,
    required Map<String, int> expectedTaskVersions,
  }) = _ApplyScheduleCascadePayload;

  /// Odtwarza payload z JSON.
  factory ApplyScheduleCascadePayload.fromJson(Map<String, dynamic> json) =>
      _$ApplyScheduleCascadePayloadFromJson(json);
}

/// Przesunięcie daty zadania w kaskadzie.
@freezed
abstract class TaskDateShiftResponse with _$TaskDateShiftResponse {
  /// Tworzy propozycję przesunięcia.
  const factory TaskDateShiftResponse({
    required String taskId,
    required String title,
    DateTime? currentStartAtUtc,
    required DateTime proposedStartAtUtc,
    DateTime? currentDueAtUtc,
    required DateTime proposedDueAtUtc,
    required int shiftWorkingDays,
    required bool isOnCriticalPath,
    required int expectedVersion,
  }) = _TaskDateShiftResponse;

  /// Odtwarza przesunięcie z JSON.
  factory TaskDateShiftResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskDateShiftResponseFromJson(json);
}

/// Zapas czasu zadania.
@freezed
abstract class TaskFloatResponse with _$TaskFloatResponse {
  /// Tworzy obliczony float.
  const factory TaskFloatResponse({
    required String taskId,
    required DateTime earlyStartUtc,
    required DateTime earlyFinishUtc,
    required DateTime lateStartUtc,
    required DateTime lateFinishUtc,
    required int totalFloatDays,
    required bool isCritical,
  }) = _TaskFloatResponse;

  /// Odtwarza float z JSON.
  factory TaskFloatResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskFloatResponseFromJson(json);
}

/// Odpowiedź kaskady terminów.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ScheduleCascadeResponse with _$ScheduleCascadeResponse {
  /// Tworzy odpowiedź kaskady.
  const factory ScheduleCascadeResponse({
    required List<TaskDateShiftResponse> dateShifts,
    required List<String> criticalPathTaskIds,
    required int totalProjectWorkingDays,
    required List<TaskFloatResponse> taskFloats,
  }) = _ScheduleCascadeResponse;

  /// Odtwarza kaskadę z JSON.
  factory ScheduleCascadeResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleCascadeResponseFromJson(json);
}

/// Payload trybu harmonogramu.
@freezed
abstract class SetScheduleModePayload with _$SetScheduleModePayload {
  /// Tworzy ustawienie trybu harmonogramu.
  const factory SetScheduleModePayload({required AutoScheduleMode mode}) =
      _SetScheduleModePayload;

  /// Odtwarza payload z JSON.
  factory SetScheduleModePayload.fromJson(Map<String, dynamic> json) =>
      _$SetScheduleModePayloadFromJson(json);
}

/// Payload dnia wolnego.
@freezed
abstract class CreateWorkspaceHolidayPayload
    with _$CreateWorkspaceHolidayPayload {
  /// Tworzy święto lub dzień wolny.
  const factory CreateWorkspaceHolidayPayload({
    required DateTime date,
    required String name,
  }) = _CreateWorkspaceHolidayPayload;

  /// Odtwarza payload z JSON.
  factory CreateWorkspaceHolidayPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateWorkspaceHolidayPayloadFromJson(json);
}

/// Dzień wolny zwrócony przez API.
@freezed
abstract class WorkspaceHolidayResponse with _$WorkspaceHolidayResponse {
  /// Tworzy odpowiedź dnia wolnego.
  const factory WorkspaceHolidayResponse({
    required String id,
    required DateTime date,
    required String name,
  }) = _WorkspaceHolidayResponse;

  /// Odtwarza odpowiedź z JSON.
  factory WorkspaceHolidayResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceHolidayResponseFromJson(json);
}
