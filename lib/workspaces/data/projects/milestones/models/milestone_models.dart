import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/shared/enums/milestone_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';

part 'milestone_models.freezed.dart';
part 'milestone_models.g.dart';

/// Payload utworzenia kamienia milowego.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateMilestonePayload with _$CreateMilestonePayload {
  /// Tworzy dane zgodne z `CreateMilestoneRequest`.
  const factory CreateMilestonePayload({
    /// Nazwa kamienia milowego.
    required String name,

    /// Opcjonalny opis.
    String? description,

    /// Opcjonalny termin w UTC.
    DateTime? dueAtUtc,
  }) = _CreateMilestonePayload;

  /// Odtwarza payload z JSON.
  factory CreateMilestonePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateMilestonePayloadFromJson(json);
}

/// Payload aktualizacji kamienia milowego.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateMilestonePayload with _$UpdateMilestonePayload {
  /// Tworzy dane zgodne z `UpdateMilestoneRequest`.
  const factory UpdateMilestonePayload({
    /// Nazwa kamienia milowego.
    required String name,

    /// Opcjonalny opis.
    String? description,

    /// Opcjonalny termin w UTC.
    DateTime? dueAtUtc,

    /// Status kamienia milowego.
    required MilestoneStatus status,
  }) = _UpdateMilestonePayload;

  /// Odtwarza payload z JSON.
  factory UpdateMilestonePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateMilestonePayloadFromJson(json);
}

/// Odpowiedź z danymi kamienia milowego.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class MilestoneResponse with _$MilestoneResponse {
  /// Tworzy odpowiedź zgodną z `MilestoneResponse`.
  const factory MilestoneResponse({
    /// UUID kamienia milowego.
    required String id,

    /// UUID projektu.
    required String projectId,

    /// UUID workspace.
    required String workspaceId,

    /// Nazwa kamienia milowego.
    required String name,

    /// Opis albo null.
    String? description,

    /// Termin w UTC albo null.
    DateTime? dueAtUtc,

    /// Status kamienia milowego.
    required MilestoneStatus status,

    /// Procent wykonania.
    required double progress,

    /// Czas utworzenia.
    required DateTime createdAtUtc,

    /// Czas aktualizacji.
    required DateTime updatedAtUtc,

    /// Wersja optimistic concurrency.
    required int version,
  }) = _MilestoneResponse;

  /// Odtwarza kamień milowy z JSON.
  factory MilestoneResponse.fromJson(Map<String, dynamic> json) =>
      _$MilestoneResponseFromJson(json);
}

/// Zadanie przypisane do kamienia milowego.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class MilestoneTaskResponse with _$MilestoneTaskResponse {
  /// Tworzy odpowiedź zgodną z `MilestoneTaskResponse`.
  const factory MilestoneTaskResponse({
    /// UUID zadania.
    required String id,

    /// Numer zadania.
    required int number,

    /// Klucz zadania.
    required String key,

    /// Tytuł zadania.
    required String title,

    /// Status zadania.
    required ProjectTaskStatus status,

    /// Priorytet zadania.
    required TaskPriority priority,

    /// Termin zadania albo null.
    DateTime? dueAtUtc,

    /// Wersja zadania.
    required int version,
  }) = _MilestoneTaskResponse;

  /// Odtwarza zadanie milestone z JSON.
  factory MilestoneTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$MilestoneTaskResponseFromJson(json);
}
