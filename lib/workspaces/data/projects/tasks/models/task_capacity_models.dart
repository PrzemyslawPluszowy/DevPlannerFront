import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_advanced_enums.dart';

part 'task_capacity_models.freezed.dart';
part 'task_capacity_models.g.dart';

/// Payload ustawienia domyślnej dziennej pojemności workspace.
@freezed
abstract class UpdateWorkspaceCapacityPayload
    with _$UpdateWorkspaceCapacityPayload {
  /// Tworzy ustawienie capacity z kontrolą wersji.
  const factory UpdateWorkspaceCapacityPayload({
    required int defaultDailyCapacityMinutes,
    required int expectedVersion,
  }) = _UpdateWorkspaceCapacityPayload;

  /// Odtwarza payload z JSON.
  factory UpdateWorkspaceCapacityPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateWorkspaceCapacityPayloadFromJson(json);
}

/// Odpowiedź pojemności workspace.
@freezed
abstract class WorkspaceCapacityResponse with _$WorkspaceCapacityResponse {
  /// Tworzy odpowiedź capacity.
  const factory WorkspaceCapacityResponse({
    required String workspaceId,
    required int defaultDailyCapacityMinutes,
    required int version,
    DateTime? updatedAtUtc,
  }) = _WorkspaceCapacityResponse;

  /// Odtwarza capacity z JSON.
  factory WorkspaceCapacityResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceCapacityResponseFromJson(json);
}

/// Payload utworzenia override capacity użytkownika.
@freezed
abstract class CreateUserCapacityOverridePayload
    with _$CreateUserCapacityOverridePayload {
  /// Tworzy zakresową dostępność użytkownika.
  const factory CreateUserCapacityOverridePayload({
    required String coreUserId,
    required DateTime startDate,
    required DateTime endDate,
    required int availableMinutesPerDay,
    String? reason,
  }) = _CreateUserCapacityOverridePayload;

  /// Odtwarza payload z JSON.
  factory CreateUserCapacityOverridePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateUserCapacityOverridePayloadFromJson(json);
}

/// Payload aktualizacji override capacity.
@freezed
abstract class UpdateUserCapacityOverridePayload
    with _$UpdateUserCapacityOverridePayload {
  /// Tworzy zmianę override z kontrolą wersji.
  const factory UpdateUserCapacityOverridePayload({
    required DateTime startDate,
    required DateTime endDate,
    required int availableMinutesPerDay,
    String? reason,
    required int expectedVersion,
  }) = _UpdateUserCapacityOverridePayload;

  /// Odtwarza payload z JSON.
  factory UpdateUserCapacityOverridePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateUserCapacityOverridePayloadFromJson(json);
}

/// Odpowiedź override capacity użytkownika.
@freezed
abstract class UserCapacityOverrideResponse
    with _$UserCapacityOverrideResponse {
  /// Tworzy odpowiedź override.
  const factory UserCapacityOverrideResponse({
    required String id,
    required String workspaceId,
    required String projectId,
    required String coreUserId,
    required DateTime startDate,
    required DateTime endDate,
    required int availableMinutesPerDay,
    String? reason,
    required int version,
    required DateTime updatedAtUtc,
  }) = _UserCapacityOverrideResponse;

  /// Odtwarza override z JSON.
  factory UserCapacityOverrideResponse.fromJson(Map<String, dynamic> json) =>
      _$UserCapacityOverrideResponseFromJson(json);
}

/// Agregaty obciążenia jednego użytkownika.
@freezed
abstract class TaskWorkloadUserResponse with _$TaskWorkloadUserResponse {
  /// Tworzy agregaty workload.
  const factory TaskWorkloadUserResponse({
    required String coreUserId,
    required int assignedTaskCount,
    required int estimatedMinutes,
    required int loggedMinutes,
    @Default(0) int unplannedEstimatedMinutes,
    @Default(0) int availableCapacityMinutes,
    @Default(0) int remainingCapacityMinutes,
    @Default(false) bool isOverCapacity,
    @Default(CapacitySource.workspaceDefault) CapacitySource capacitySource,
  }) = _TaskWorkloadUserResponse;

  /// Odtwarza agregaty z JSON.
  factory TaskWorkloadUserResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskWorkloadUserResponseFromJson(json);
}

/// Odpowiedź workload projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TaskWorkloadResponse with _$TaskWorkloadResponse {
  /// Tworzy workload projektu.
  const factory TaskWorkloadResponse({
    required String projectId,
    required List<TaskWorkloadUserResponse> users,
    DateTime? fromDate,
    DateTime? toDate,
  }) = _TaskWorkloadResponse;

  /// Odtwarza workload z JSON.
  factory TaskWorkloadResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskWorkloadResponseFromJson(json);
}
