import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_capacity_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/milestone_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/data/shared/enums/workspace_feature_enums.dart';

part 'workspace_feature_models.freezed.dart';
part 'workspace_feature_models.g.dart';

/// Payload aktualizacji layoutu dashboardu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateDashboardPreferencePayload
    with _$UpdateDashboardPreferencePayload {
  /// Przekazuje layout JSON i wersję optimistic concurrency.
  const factory UpdateDashboardPreferencePayload({
    required Map<String, dynamic> layout,
    required int expectedVersion,
  }) = _UpdateDashboardPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateDashboardPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateDashboardPreferencePayloadFromJson(json);
}

/// Zapisane preferencje dashboardu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class DashboardPreferenceResponse with _$DashboardPreferenceResponse {
  /// Zwraca layout, kontekst i wersję preferencji.
  const factory DashboardPreferenceResponse({
    required String workspaceId,
    required String userId,
    required DashboardContextKind context,
    String? projectId,
    required Map<String, dynamic> layout,
    required DateTime updatedAtUtc,
    required int version,
  }) = _DashboardPreferenceResponse;

  /// Odtwarza preferencje z JSON.
  factory DashboardPreferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardPreferenceResponseFromJson(json);
}

/// Zdarzenie w strumieniu aktywności workspace.
@freezed
abstract class WorkspaceActivityItemResponse
    with _$WorkspaceActivityItemResponse {
  /// Zawiera źródło, encję, aktora i czas zdarzenia.
  const factory WorkspaceActivityItemResponse({
    required String id,
    required String sourceModule,
    required String eventType,
    required String workspaceId,
    String? projectId,
    required String entityId,
    String? actorCoreUserId,
    required DateTime occurredAtUtc,
    String? metadataJson,
  }) = _WorkspaceActivityItemResponse;

  /// Odtwarza aktywność z JSON.
  factory WorkspaceActivityItemResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceActivityItemResponseFromJson(json);
}

/// Strona strumienia aktywności workspace.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WorkspaceActivityPageResponse
    with _$WorkspaceActivityPageResponse {
  /// Zwraca zdarzenia i kursor kolejnej strony.
  const factory WorkspaceActivityPageResponse({
    required List<WorkspaceActivityItemResponse> items,
    String? nextCursor,
  }) = _WorkspaceActivityPageResponse;

  /// Odtwarza stronę z JSON.
  factory WorkspaceActivityPageResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceActivityPageResponseFromJson(json);
}

/// Payload utworzenia linku synchronizacji źródło–zadanie.
@freezed
abstract class CreateCrossModuleSyncLinkPayload
    with _$CreateCrossModuleSyncLinkPayload {
  /// Wskazuje zadanie i źródło synchronizacji.
  const factory CreateCrossModuleSyncLinkPayload({
    required String taskId,
    required CrossModuleSyncSourceKind sourceKind,
    required String sourceId,
  }) = _CreateCrossModuleSyncLinkPayload;

  /// Odtwarza payload z JSON.
  factory CreateCrossModuleSyncLinkPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateCrossModuleSyncLinkPayloadFromJson(json);
}

/// Stan linku synchronizacji między zadaniem a Wiki/Whiteboard.
@freezed
abstract class CrossModuleSyncLinkResponse with _$CrossModuleSyncLinkResponse {
  /// Zawiera źródło, status i ostatnią propagację.
  const factory CrossModuleSyncLinkResponse({
    required String id,
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CrossModuleSyncSourceKind sourceKind,
    required String sourceId,
    required CrossModuleSyncLinkStatus status,
    required int lastTaskVersion,
    required int lastSourceVersion,
    String? lastCorrelationId,
    String? lastError,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required int version,
  }) = _CrossModuleSyncLinkResponse;

  /// Odtwarza link z JSON.
  factory CrossModuleSyncLinkResponse.fromJson(Map<String, dynamic> json) =>
      _$CrossModuleSyncLinkResponseFromJson(json);
}

/// Payload zmiany stanu linku synchronizacji.
@freezed
abstract class SetCrossModuleSyncLinkStatePayload
    with _$SetCrossModuleSyncLinkStatePayload {
  /// Ustawia pauzę oraz oczekiwaną wersję linku.
  const factory SetCrossModuleSyncLinkStatePayload({
    required bool paused,
    required int expectedVersion,
  }) = _SetCrossModuleSyncLinkStatePayload;

  /// Odtwarza payload z JSON.
  factory SetCrossModuleSyncLinkStatePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$SetCrossModuleSyncLinkStatePayloadFromJson(json);
}

/// Wynik zadania na osobistym dashboardzie.
@freezed
abstract class HomeDashboardTaskResponse with _$HomeDashboardTaskResponse {
  /// Zawiera zadanie, projekt, status i deep link.
  const factory HomeDashboardTaskResponse({
    required String id,
    required int number,
    required String title,
    required String projectId,
    required String projectName,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? dueAtUtc,
    required String deepLink,
  }) = _HomeDashboardTaskResponse;

  /// Odtwarza zadanie z JSON.
  factory HomeDashboardTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardTaskResponseFromJson(json);
}

/// Aktywność pokazana na dashboardzie.
@freezed
abstract class HomeDashboardActivityResponse
    with _$HomeDashboardActivityResponse {
  /// Zawiera źródło i encję aktywności.
  const factory HomeDashboardActivityResponse({
    required String id,
    required String sourceModule,
    required String eventType,
    String? projectId,
    String? entityId,
    required DateTime occurredAtUtc,
  }) = _HomeDashboardActivityResponse;

  /// Odtwarza aktywność z JSON.
  factory HomeDashboardActivityResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardActivityResponseFromJson(json);
}

/// Zasób ostatnio zmieniony w workspace.
@freezed
abstract class HomeDashboardResourceResponse
    with _$HomeDashboardResourceResponse {
  /// Zawiera nazwę zasobu i deep link.
  const factory HomeDashboardResourceResponse({
    required String id,
    required String resourceType,
    required String name,
    String? projectId,
    required DateTime updatedAtUtc,
    required String deepLink,
  }) = _HomeDashboardResourceResponse;

  /// Odtwarza zasób z JSON.
  factory HomeDashboardResourceResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardResourceResponseFromJson(json);
}

/// Rozmowa z nieprzeczytanymi wiadomościami.
@freezed
abstract class HomeDashboardDiscussionResponse
    with _$HomeDashboardDiscussionResponse {
  /// Zawiera rozmowę, licznik i deep link.
  const factory HomeDashboardDiscussionResponse({
    required String conversationId,
    String? name,
    required int unreadMessageCount,
    required DateTime latestMessageAtUtc,
    required String deepLink,
  }) = _HomeDashboardDiscussionResponse;

  /// Odtwarza rozmowę z JSON.
  factory HomeDashboardDiscussionResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardDiscussionResponseFromJson(json);
}

/// Key Result pokazany na dashboardzie.
@freezed
abstract class HomeDashboardKeyResultResponse
    with _$HomeDashboardKeyResultResponse {
  /// Zawiera wartości rezultatu i deep link.
  const factory HomeDashboardKeyResultResponse({
    required String id,
    required String name,
    required double currentValue,
    required double targetValue,
    String? projectId,
    required DateTime updatedAtUtc,
    required String deepLink,
  }) = _HomeDashboardKeyResultResponse;

  /// Odtwarza rezultat z JSON.
  factory HomeDashboardKeyResultResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardKeyResultResponseFromJson(json);
}

/// Osobisty pulpit workspace.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class HomeDashboardResponse with _$HomeDashboardResponse {
  /// Zwraca liczniki oraz access-safe sekcje dashboardu.
  const factory HomeDashboardResponse({
    required String workspaceId,
    required int unreadNotifications,
    required int openTasks,
    required int dueToday,
    required int overdue,
    required List<HomeDashboardTaskResponse> nextTasks,
    required List<HomeDashboardActivityResponse> recentActivity,
    required DateTime generatedAtUtc,
    List<HomeDashboardResourceResponse>? recentResources,
    List<HomeDashboardDiscussionResponse>? unreadDiscussions,
    List<HomeDashboardKeyResultResponse>? assignedKeyResults,
    List<HomeDashboardActivityResponse>? teamActivity,
  }) = _HomeDashboardResponse;

  /// Odtwarza pulpit z JSON.
  factory HomeDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardResponseFromJson(json);
}

/// Kamień milowy dashboardu projektu.
@freezed
abstract class ProjectDashboardMilestoneResponse
    with _$ProjectDashboardMilestoneResponse {
  /// Zawiera status, postęp i termin kamienia.
  const factory ProjectDashboardMilestoneResponse({
    required String id,
    required String name,
    required MilestoneStatus status,
    required double progress,
    DateTime? dueAtUtc,
  }) = _ProjectDashboardMilestoneResponse;

  /// Odtwarza kamień z JSON.
  factory ProjectDashboardMilestoneResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectDashboardMilestoneResponseFromJson(json);
}

/// Dashboard projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectDashboardResponse with _$ProjectDashboardResponse {
  /// Zwraca liczniki Kanban, kamienie i workload zespołu.
  const factory ProjectDashboardResponse({
    required String projectId,
    required String projectName,
    required Map<String, int> kanbanColumnCounts,
    required List<ProjectDashboardMilestoneResponse> milestones,
    required TaskWorkloadResponse teamWorkload,
    required List<HomeDashboardActivityResponse> recentActivity,
    required DateTime generatedAtUtc,
    @Default(false) bool isWipLimitExceeded,
    @Default(0) int velocityCompletedLast14Days,
  }) = _ProjectDashboardResponse;

  /// Odtwarza dashboard projektu z JSON.
  factory ProjectDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectDashboardResponseFromJson(json);
}

/// Wynik wyszukiwania zadania.
@freezed
abstract class GlobalSearchTaskResult with _$GlobalSearchTaskResult {
  /// Zawiera kod, tytuł i projekt zadania.
  const factory GlobalSearchTaskResult({
    required String id,
    required String taskCode,
    required String title,
    required String status,
    required String projectId,
  }) = _GlobalSearchTaskResult;

  /// Odtwarza wynik z JSON.
  factory GlobalSearchTaskResult.fromJson(Map<String, dynamic> json) =>
      _$GlobalSearchTaskResultFromJson(json);
}

/// Wynik wyszukiwania projektu.
@freezed
abstract class GlobalSearchProjectResult with _$GlobalSearchProjectResult {
  /// Zawiera nazwę, opis i status projektu.
  const factory GlobalSearchProjectResult({
    required String id,
    required String name,
    String? description,
    required String status,
  }) = _GlobalSearchProjectResult;

  /// Odtwarza wynik z JSON.
  factory GlobalSearchProjectResult.fromJson(Map<String, dynamic> json) =>
      _$GlobalSearchProjectResultFromJson(json);
}

/// Wynik wyszukiwania strony Wiki.
@freezed
abstract class GlobalSearchWikiResult with _$GlobalSearchWikiResult {
  /// Zawiera tytuł, projekt i status Verified.
  const factory GlobalSearchWikiResult({
    required String id,
    String? projectId,
    required String title,
    required bool isVerified,
  }) = _GlobalSearchWikiResult;

  /// Odtwarza wynik z JSON.
  factory GlobalSearchWikiResult.fromJson(Map<String, dynamic> json) =>
      _$GlobalSearchWikiResultFromJson(json);
}

/// Wynik wyszukiwania pliku Storage.
@freezed
abstract class GlobalSearchFileResult with _$GlobalSearchFileResult {
  /// Zawiera nazwę, MIME i projekt pliku.
  const factory GlobalSearchFileResult({
    required String id,
    String? projectId,
    required String name,
    required String mimeType,
  }) = _GlobalSearchFileResult;

  /// Odtwarza wynik z JSON.
  factory GlobalSearchFileResult.fromJson(Map<String, dynamic> json) =>
      _$GlobalSearchFileResultFromJson(json);
}

/// Wynik wyszukiwania whiteboardu.
@freezed
abstract class GlobalSearchWhiteboardResult
    with _$GlobalSearchWhiteboardResult {
  /// Zawiera nazwę i projekt whiteboardu.
  const factory GlobalSearchWhiteboardResult({
    required String id,
    required String projectId,
    required String name,
  }) = _GlobalSearchWhiteboardResult;

  /// Odtwarza wynik z JSON.
  factory GlobalSearchWhiteboardResult.fromJson(Map<String, dynamic> json) =>
      _$GlobalSearchWhiteboardResultFromJson(json);
}

/// Wynik wyszukiwania wiadomości Chat.
@freezed
abstract class GlobalSearchChatResult with _$GlobalSearchChatResult {
  /// Zawiera wiadomość, rozmowę, autora i snippet.
  const factory GlobalSearchChatResult({
    required String messageId,
    required String conversationId,
    required String authorCoreUserId,
    String? conversationName,
    required String snippet,
    required DateTime createdAtUtc,
  }) = _GlobalSearchChatResult;

  /// Odtwarza wynik z JSON.
  factory GlobalSearchChatResult.fromJson(Map<String, dynamic> json) =>
      _$GlobalSearchChatResultFromJson(json);
}

/// Zbiorczy wynik globalnego wyszukiwania workspace.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class GlobalSearchResponse with _$GlobalSearchResponse {
  /// Zwraca wyniki zadań, projektów, Wiki, Storage, Whiteboard i Chat.
  const factory GlobalSearchResponse({
    required String query,
    required List<GlobalSearchTaskResult> tasks,
    required List<GlobalSearchProjectResult> projects,
    required List<GlobalSearchWikiResult> wikiPages,
    required List<GlobalSearchFileResult> files,
    required List<GlobalSearchWhiteboardResult> whiteboards,
    required List<GlobalSearchChatResult> chatMessages,
  }) = _GlobalSearchResponse;

  /// Odtwarza zbiorczy wynik z JSON.
  factory GlobalSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$GlobalSearchResponseFromJson(json);
}
