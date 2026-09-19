import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'kanban_models.freezed.dart';
part 'kanban_models.g.dart';

/// Lekka etykieta wyświetlana na karcie Kanban.
@freezed
abstract class KanbanCardLabelResponse with _$KanbanCardLabelResponse {
  /// Tworzy etykietę karty.
  const factory KanbanCardLabelResponse({
    required String id,
    required String name,
    required String color,
  }) = _KanbanCardLabelResponse;

  /// Odtwarza odpowiedź z JSON.
  factory KanbanCardLabelResponse.fromJson(Map<String, dynamic> json) =>
      _$KanbanCardLabelResponseFromJson(json);
}

/// Wartość pola niestandardowego widoczna na karcie.
@freezed
abstract class KanbanCardCustomFieldResponse
    with _$KanbanCardCustomFieldResponse {
  /// Tworzy skrót pola niestandardowego.
  const factory KanbanCardCustomFieldResponse({
    required String fieldId,
    required String name,
    required String valueJson,
  }) = _KanbanCardCustomFieldResponse;

  /// Odtwarza odpowiedź z JSON.
  factory KanbanCardCustomFieldResponse.fromJson(Map<String, dynamic> json) =>
      _$KanbanCardCustomFieldResponseFromJson(json);
}

/// Lekka karta zadania przeznaczona do tablicy Kanban.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class KanbanTaskCardResponse with _$KanbanTaskCardResponse {
  /// Tworzy pełny snapshot karty Kanban.
  const factory KanbanTaskCardResponse({
    required String id,
    required int number,
    required String taskCode,
    required String title,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    required int position,
    String? primaryAssigneeUserId,
    String? milestoneId,
    DateTime? dueAtUtc,
    required int checklistTotal,
    required int checklistCompleted,
    required int attachmentCount,
    required int version,
    int? estimatedMinutes,
    int? loggedMinutes,
    @Default(0) int subtaskTotal,
    @Default(0) int subtaskCompleted,
    @Default(false) bool isBlocked,
    List<String>? blockedByTaskIds,
    List<KanbanCardLabelResponse>? labels,
    List<KanbanCardCustomFieldResponse>? customFieldsSummary,
    String? coverAttachmentId,
    String? customStatusId,
    TaskRecurrenceSummaryResponse? recurrence,
    @Default(false) bool isPinned,
    @Default(0) int watcherCount,
    @Default(false) bool isWatchedByMe,
  }) = _KanbanTaskCardResponse;

  /// Odtwarza kartę z JSON.
  factory KanbanTaskCardResponse.fromJson(Map<String, dynamic> json) =>
      _$KanbanTaskCardResponseFromJson(json);
}

/// Pojedyncza kolumna tablicy Kanban.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class KanbanColumnResponse with _$KanbanColumnResponse {
  /// Tworzy stronę kart jednej kolumny.
  const factory KanbanColumnResponse({
    required ProjectTaskStatus status,
    required String displayName,
    required String color,
    int? wipLimit,
    required int totalTaskCount,
    required bool isWipLimitExceeded,
    required List<KanbanTaskCardResponse> tasks,
    String? nextCursor,
    String? customStatusId,
  }) = _KanbanColumnResponse;

  /// Odtwarza kolumnę z JSON.
  factory KanbanColumnResponse.fromJson(Map<String, dynamic> json) =>
      _$KanbanColumnResponseFromJson(json);
}

/// Snapshot aktywnej tablicy Kanban projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class KanbanBoardResponse with _$KanbanBoardResponse {
  /// Tworzy konfigurację i widoczne kolumny tablicy.
  const factory KanbanBoardResponse({
    required String projectId,
    required KanbanSwimlaneMode swimlaneMode,
    required int settingsVersion,
    required List<ProjectTaskStatus> hiddenColumns,
    required List<KanbanCardField> visibleCardFields,
    required KanbanCardDensity defaultCardDensity,
    required List<KanbanColumnResponse> columns,
  }) = _KanbanBoardResponse;

  /// Odtwarza tablicę z JSON.
  factory KanbanBoardResponse.fromJson(Map<String, dynamic> json) =>
      _$KanbanBoardResponseFromJson(json);
}

/// Payload przesunięcia karty między kolumnami.
@freezed
abstract class MoveKanbanTaskPayload with _$MoveKanbanTaskPayload {
  /// Przekazuje docelową pozycję i wersję karty.
  const factory MoveKanbanTaskPayload({
    required ProjectTaskStatus targetStatus,
    String? previousTaskId,
    String? nextTaskId,
    required int expectedVersion,
    String? customStatusId,
  }) = _MoveKanbanTaskPayload;

  /// Odtwarza payload z JSON.
  factory MoveKanbanTaskPayload.fromJson(Map<String, dynamic> json) =>
      _$MoveKanbanTaskPayloadFromJson(json);
}

/// Wynik przesunięcia karty.
@freezed
abstract class MoveKanbanTaskResponse with _$MoveKanbanTaskResponse {
  /// Zwraca kartę oraz stan limitu WIP.
  const factory MoveKanbanTaskResponse({
    required KanbanTaskCardResponse task,
    required int targetColumnTaskCount,
    int? targetColumnWipLimit,
    required bool isWipLimitExceeded,
  }) = _MoveKanbanTaskResponse;

  /// Odtwarza odpowiedź z JSON.
  factory MoveKanbanTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$MoveKanbanTaskResponseFromJson(json);
}

/// Element zbiorczego przesunięcia kart.
@freezed
abstract class BulkMoveKanbanTaskItemPayload
    with _$BulkMoveKanbanTaskItemPayload {
  /// Wskazuje kartę i jej oczekiwaną wersję.
  const factory BulkMoveKanbanTaskItemPayload({
    required String taskId,
    required int expectedVersion,
  }) = _BulkMoveKanbanTaskItemPayload;

  /// Odtwarza payload z JSON.
  factory BulkMoveKanbanTaskItemPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkMoveKanbanTaskItemPayloadFromJson(json);
}

/// Payload zbiorczego przesunięcia kart.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkMoveKanbanTasksPayload with _$BulkMoveKanbanTasksPayload {
  /// Przekazuje docelową kolumnę i listę kart.
  const factory BulkMoveKanbanTasksPayload({
    required ProjectTaskStatus targetStatus,
    required List<BulkMoveKanbanTaskItemPayload> tasks,
    String? customStatusId,
  }) = _BulkMoveKanbanTasksPayload;

  /// Odtwarza payload z JSON.
  factory BulkMoveKanbanTasksPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkMoveKanbanTasksPayloadFromJson(json);
}

/// Wynik zbiorczego przesunięcia kart.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkMoveKanbanTasksResponse with _$BulkMoveKanbanTasksResponse {
  /// Zwraca karty i stan limitu kolumny.
  const factory BulkMoveKanbanTasksResponse({
    required List<KanbanTaskCardResponse> tasks,
    required int targetColumnTaskCount,
    int? targetColumnWipLimit,
    required bool isWipLimitExceeded,
  }) = _BulkMoveKanbanTasksResponse;

  /// Odtwarza odpowiedź z JSON.
  factory BulkMoveKanbanTasksResponse.fromJson(Map<String, dynamic> json) =>
      _$BulkMoveKanbanTasksResponseFromJson(json);
}

/// Element zbiorczej aktualizacji kart.
@freezed
abstract class BulkUpdateKanbanTaskItemPayload
    with _$BulkUpdateKanbanTaskItemPayload {
  /// Wskazuje kartę i jej oczekiwaną wersję.
  const factory BulkUpdateKanbanTaskItemPayload({
    required String taskId,
    required int expectedVersion,
  }) = _BulkUpdateKanbanTaskItemPayload;

  /// Odtwarza payload z JSON.
  factory BulkUpdateKanbanTaskItemPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkUpdateKanbanTaskItemPayloadFromJson(json);
}

/// Payload zbiorczej aktualizacji pól kart.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkUpdateKanbanTasksPayload
    with _$BulkUpdateKanbanTasksPayload {
  /// Przekazuje karty i opcjonalne wspólne wartości pól.
  const factory BulkUpdateKanbanTasksPayload({
    required List<BulkUpdateKanbanTaskItemPayload> tasks,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    List<String>? assigneeIds,
    List<String>? labelIds,
  }) = _BulkUpdateKanbanTasksPayload;

  /// Odtwarza payload z JSON.
  factory BulkUpdateKanbanTasksPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkUpdateKanbanTasksPayloadFromJson(json);
}

/// Wynik zbiorczej aktualizacji kart.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkUpdateKanbanTasksResponse
    with _$BulkUpdateKanbanTasksResponse {
  /// Zwraca zaktualizowane karty.
  const factory BulkUpdateKanbanTasksResponse({
    required List<KanbanTaskCardResponse> tasks,
    required int updatedCount,
  }) = _BulkUpdateKanbanTasksResponse;

  /// Odtwarza odpowiedź z JSON.
  factory BulkUpdateKanbanTasksResponse.fromJson(Map<String, dynamic> json) =>
      _$BulkUpdateKanbanTasksResponseFromJson(json);
}

/// Payload konfiguracji tablicy Kanban.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateProjectKanbanSettingsPayload
    with _$UpdateProjectKanbanSettingsPayload {
  /// Przekazuje ustawienia kolumn i oczekiwaną wersję.
  const factory UpdateProjectKanbanSettingsPayload({
    required KanbanSwimlaneMode swimlaneMode,
    required Map<String, int> columnWipLimits,
    required List<ProjectTaskStatus> hiddenColumns,
    required int expectedVersion,
    List<KanbanCardField>? visibleCardFields,
    @Default(KanbanCardDensity.comfortable)
    KanbanCardDensity defaultCardDensity,
  }) = _UpdateProjectKanbanSettingsPayload;

  /// Odtwarza payload z JSON.
  factory UpdateProjectKanbanSettingsPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateProjectKanbanSettingsPayloadFromJson(json);
}

/// Zapisana konfiguracja tablicy Kanban.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectKanbanSettingsResponse
    with _$ProjectKanbanSettingsResponse {
  /// Zwraca ustawienia i wersję do kolejnej zmiany.
  const factory ProjectKanbanSettingsResponse({
    required String projectId,
    required KanbanSwimlaneMode swimlaneMode,
    required Map<String, int> columnWipLimits,
    required List<ProjectTaskStatus> hiddenColumns,
    required List<KanbanCardField> visibleCardFields,
    required KanbanCardDensity defaultCardDensity,
    required DateTime updatedAtUtc,
    required int version,
  }) = _ProjectKanbanSettingsResponse;

  /// Odtwarza odpowiedź z JSON.
  factory ProjectKanbanSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectKanbanSettingsResponseFromJson(json);
}

/// Payload osobistych ustawień widoku Kanban.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateUserKanbanPreferencePayload
    with _$UpdateUserKanbanPreferencePayload {
  /// Przekazuje zwinięte kolumny, filtr i wersję.
  const factory UpdateUserKanbanPreferencePayload({
    required List<ProjectTaskStatus> collapsedColumns,
    required KanbanQuickFilter quickFilter,
    required int expectedVersion,
    List<String>? collapsedCustomStatusIds,
  }) = _UpdateUserKanbanPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateUserKanbanPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateUserKanbanPreferencePayloadFromJson(json);
}

/// Osobiste ustawienia widoku tablicy Kanban.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UserKanbanPreferenceResponse
    with _$UserKanbanPreferenceResponse {
  /// Zwraca preferencje bieżącego użytkownika.
  const factory UserKanbanPreferenceResponse({
    required String workspaceId,
    required String projectId,
    required String userId,
    required List<ProjectTaskStatus> collapsedColumns,
    required KanbanQuickFilter quickFilter,
    DateTime? updatedAtUtc,
    required int version,
    required List<String> collapsedCustomStatusIds,
  }) = _UserKanbanPreferenceResponse;

  /// Odtwarza odpowiedź z JSON.
  factory UserKanbanPreferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$UserKanbanPreferenceResponseFromJson(json);
}
