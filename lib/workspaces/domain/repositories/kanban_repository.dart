import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:flutter/foundation.dart';

/// Filtry jednej cursorowej kolumny Kanban.
final class KanbanColumnQuery {
  const KanbanColumnQuery({
    this.cursor,
    this.limit = 25,
    this.assigneeUserId,
    this.priority,
    this.milestoneId,
    this.status,
    this.customStatusId,
  }) : assert(
         limit >= 1 && limit <= 50,
         'Limit strony kolumny Kanban musi mieścić się w zakresie 1–50.',
       );

  final String? cursor;
  final int limit;
  final String? assigneeUserId;
  final TaskPriority? priority;
  final String? milestoneId;

  /// Status karty; w widoku osób osoba opisuje kolumnę, więc status zawęża
  /// karty w kolumnach, a nie wybiera kolumnę.
  final ProjectTaskStatus? status;

  /// Własny status projektu; alternatywa dla [status].
  final String? customStatusId;
}

/// Filtry tablicy Kanban wspólne dla liczników kolumn, kart i kolejnych stron.
///
/// Backend liczy `totalTaskCount` i WIP tą samą predykatą, którą filtruje karty,
/// dlatego filtr musi być wysłany razem z pierwszym odczytem tablicy oraz z
/// każdym doładowaniem kolumny.
@immutable
final class KanbanBoardFilter {
  const KanbanBoardFilter({
    this.assigneeUserId,
    this.priority,
    this.milestoneId,
    this.status,
    this.customStatusId,
  });

  static const KanbanBoardFilter none = KanbanBoardFilter();

  final String? assigneeUserId;
  final TaskPriority? priority;
  final String? milestoneId;

  /// Status karty. W widoku statusów kolumna już opisuje status, więc ten
  /// wymiar jest tam nieużywany; w widoku osób to jedyny filtr kart.
  final ProjectTaskStatus? status;

  /// Własny status projektu; alternatywa dla [status].
  final String? customStatusId;

  /// Czy tablica pokazuje pełny projekt, czy zawężony zestaw kart.
  bool get isActive =>
      assigneeUserId != null ||
      priority != null ||
      milestoneId != null ||
      status != null ||
      customStatusId != null;

  /// Liczba aktywnych wymiarów filtra — używana przez pasek aktywnego filtra.
  int get activeCount =>
      (assigneeUserId == null ? 0 : 1) +
      (priority == null ? 0 : 1) +
      (milestoneId == null ? 0 : 1) +
      (status == null ? 0 : 1) +
      (customStatusId == null ? 0 : 1);

  /// Tworzy zapytanie kolumny dziedziczące filtry tablicy.
  KanbanColumnQuery toColumnQuery({String? cursor}) => KanbanColumnQuery(
    cursor: cursor,
    assigneeUserId: assigneeUserId,
    priority: priority,
    milestoneId: milestoneId,
    status: status,
    customStatusId: customStatusId,
  );

  KanbanBoardFilter copyWith({
    String? assigneeUserId,
    TaskPriority? priority,
    String? milestoneId,
    ProjectTaskStatus? status,
    String? customStatusId,
    bool clearAssignee = false,
    bool clearPriority = false,
    bool clearMilestone = false,
    bool clearStatus = false,
    bool clearCustomStatus = false,
  }) => KanbanBoardFilter(
    assigneeUserId: clearAssignee
        ? null
        : assigneeUserId ?? this.assigneeUserId,
    priority: clearPriority ? null : priority ?? this.priority,
    milestoneId: clearMilestone ? null : milestoneId ?? this.milestoneId,
    // Status to **jeden** wymiar: ustawienie własnego statusu zdejmuje systemowy
    // i odwrotnie. Dwa naraz zawęziłyby tablicę do pustego zbioru (Backend
    // odrzuca taki zestaw), więc model pilnuje tego sam, a nie tylko UI.
    status: clearStatus || customStatusId != null
        ? null
        : status ?? this.status,
    customStatusId: clearCustomStatus || status != null
        ? null
        : customStatusId ?? this.customStatusId,
  );

  /// Równość obejmuje **wszystkie** wymiary filtra: bez tego filtr różniący się
  /// tylko statusem byłby uznany za ten sam i zmiana po cichu nie odświeżyłaby
  /// tablicy (koordynator pomija ustawienie identycznego filtra).
  @override
  bool operator ==(Object other) =>
      other is KanbanBoardFilter &&
      other.assigneeUserId == assigneeUserId &&
      other.priority == priority &&
      other.milestoneId == milestoneId &&
      other.status == status &&
      other.customStatusId == customStatusId;

  @override
  int get hashCode => Object.hash(
    assigneeUserId,
    priority,
    milestoneId,
    status,
    customStatusId,
  );
}

/// Pełny kontrakt danych i mutacji tablicy Kanban projektu.
abstract interface class KanbanRepository {
  /// Pobiera tablicę; filtry zawężają liczniki kolumn i pierwsze strony kart.
  Future<Either<ApiError, KanbanBoardResponse>> getBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
  });

  /// Pobiera pełne, wersjonowane ustawienia tablicy projektu.
  Future<Either<ApiError, ProjectKanbanSettingsResponse>> getSettings({
    required String workspaceId,
    required String projectId,
  });

  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  getSystemColumn({
    required String workspaceId,
    required String projectId,
    required ProjectTaskStatus status,
    KanbanColumnQuery query = const KanbanColumnQuery(),
  });

  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  getCustomColumn({
    required String workspaceId,
    required String projectId,
    required String customStatusId,
    KanbanColumnQuery query = const KanbanColumnQuery(),
  });

  Future<Either<ApiError, MoveKanbanTaskResponse>> moveTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required MoveKanbanTaskPayload payload,
  });

  /// Pobiera tablicę pogrupowaną po osobach.
  ///
  /// Kolumnę karty wyznacza wyłącznie główny wykonawca, więc współwykonawcy
  /// pozostają widoczni na karcie, ale jej nie duplikują.
  Future<Either<ApiError, AssigneeKanbanBoardResponse>> getAssigneeBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
  });

  /// Pobiera kolejną stronę jednej grupy osób.
  ///
  /// [assigneeUserId] równy null oznacza grupę „Nieprzypisane”. Kursor jest
  /// związany z grupą i filtrami, więc kursor z innej kolumny Backend odrzuca.
  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  getAssigneeGroup({
    required String workspaceId,
    required String projectId,
    String? assigneeUserId,
    KanbanColumnQuery query = const KanbanColumnQuery(),
  });

  /// Zmienia wyłącznie głównego wykonawcę karty, bez zmiany statusu.
  ///
  /// [targetUserId] równy null usuwa wszystkich wykonawców zadania.
  Future<Either<ApiError, ChangeKanbanPrimaryAssigneeResponse>>
  changePrimaryAssignee({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String? targetUserId,
    required int expectedVersion,
  });

  Future<Either<ApiError, BulkMoveKanbanTasksResponse>> bulkMove({
    required String workspaceId,
    required String projectId,
    required BulkMoveKanbanTasksPayload payload,
  });

  Future<Either<ApiError, BulkUpdateKanbanTasksResponse>> bulkUpdate({
    required String workspaceId,
    required String projectId,
    required BulkUpdateKanbanTasksPayload payload,
  });

  Future<Either<ApiError, ProjectKanbanSettingsResponse>> updateSettings({
    required String workspaceId,
    required String projectId,
    required UpdateProjectKanbanSettingsPayload payload,
  });

  Future<Either<ApiError, UserKanbanPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  });

  Future<Either<ApiError, UserKanbanPreferenceResponse>> updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateUserKanbanPreferencePayload payload,
  });
}
