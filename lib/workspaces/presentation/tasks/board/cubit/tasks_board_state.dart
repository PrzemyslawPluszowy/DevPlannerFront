import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';

sealed class TasksBoardState {
  const TasksBoardState();
}

final class TasksBoardInitial extends TasksBoardState {
  const TasksBoardInitial();
}

final class TasksBoardLoading extends TasksBoardState {
  const TasksBoardLoading();
}

/// Rodzaj błędu widoku, aby UI nie mieszało braku ACL z utratą połączenia.
enum TasksBoardFailureKind { forbidden, notFound, offline, other }

final class TasksBoardFailure extends TasksBoardState {
  const TasksBoardFailure({
    required this.message,
    required this.kind,
    this.backendCode,
  });

  final String message;
  final TasksBoardFailureKind kind;
  final String? backendCode;
}

final class TasksBoardReady extends TasksBoardState {
  const TasksBoardReady({
    required this.board,
    required this.connectionState,
    required this.presence,
    this.filter = KanbanBoardFilter.none,
    this.loadingFilter = false,
    this.memberProfilesByUserId = const {},
    this.memberPresenceIsFresh = false,
    this.loadingColumnKeys = const <String>{},
    this.columnLoadErrors = const <String, String>{},
    this.columnLoadApiErrors = const <String, ApiError>{},
    this.selectedTaskIds = const <String>{},
    this.pendingTaskIds = const <String>{},
    this.pendingMoveOwners = const {},
    this.pendingCardOwners = const {},
    this.isBulkSaving = false,
    this.bulkError,
    this.canRetryBulk = false,
    this.userPreference,
    this.savingUserPreference = false,
    this.error,
    this.taskDataRevision = 0,
    this.realtimeRevision = 0,
    this.latestRealtimeMutation,
    this.grouping = TasksBoardGrouping.status,
    this.assigneeBoard,
    this.isAssigneeBoardLoading = false,
    this.assigneeGroupLoadErrors = const <String, String>{},
    this.loadingAssigneeGroupKeys = const <String>{},
    this.failedTaskIds = const <String>{},
    this.hiddenAssigneeUserIds = const <String>{},
    this.hideEmptyAssigneeColumns = false,
  });

  final KanbanBoardResponse board;
  final WorkspaceSignalRConnectionState connectionState;
  final List<TaskProjectPresenceUser> presence;

  /// Filtry tablicy opisujące liczniki kolumn i załadowane karty.
  ///
  /// Filtr nie jest preferencją: obowiązuje tylko bieżący widok, a Backend liczy
  /// nim liczniki, więc zmiana filtra wymaga ponownego odczytu tablicy.
  final KanbanBoardFilter filter;

  /// Czy trwa odczyt tablicy po zmianie filtra.
  final bool loadingFilter;

  final Map<String, ProjectMemberProfile> memberProfilesByUserId;
  final bool memberPresenceIsFresh;
  final Set<String> loadingColumnKeys;
  final Map<String, String> columnLoadErrors;
  final Map<String, ApiError> columnLoadApiErrors;
  final Set<String> selectedTaskIds;
  final Set<String> pendingTaskIds;

  /// Właściciel konkretnego ruchu; nie pozwala starej odpowiedzi zwolnić
  /// blokady należącej do nowszej operacji tego samego zadania.
  final Map<String, Object> pendingMoveOwners;

  /// Oddzielni właściciele pin/watch/inline, niezależni od ruchów DnD.
  final Map<String, Object> pendingCardOwners;
  final bool isBulkSaving;
  final TasksViewError? bulkError;
  final bool canRetryBulk;
  final UserKanbanPreferenceResponse? userPreference;
  final bool savingUserPreference;

  /// Ostatni nieudany zapis albo odczyt widoku.
  ///
  /// Błąd jest częścią stanu, a nie jednorazowym zdarzeniem, więc trwały banner
  /// nad treścią widzi go także po przebudowie drzewa, po zamknięciu menu albo
  /// pod nakładką.
  final TasksViewError? error;

  /// Rośnie wyłącznie wtedy, gdy zmieniły się dane zadań: karta, kolejność,
  /// nowe zadanie.
  ///
  /// Widoki listowe odświeżają po tym liczniku swój kursorowy snapshot. Błędy
  /// mają własne pole [error], żeby nieudany zapis ustawień Kanbana nie kazał
  /// Liście przeładowywać danych.
  final int taskDataRevision;

  /// Rośnie przy każdej zaakceptowanej zmianie zadania z SignalR.
  /// Inne widoki projektu (lista, timeline, workload) używają go do
  /// kontrolowanego odświeżenia swojego cursorowego snapshotu.
  final int realtimeRevision;

  /// Konkretna zmiana odpowiadająca [realtimeRevision]. Widoki listowe mogą
  /// zaktualizować pojedynczy wiersz zamiast odczytywać cały snapshot.
  final TaskRealtimeMutation? latestRealtimeMutation;

  /// Sposób grupowania kolumn: status workflow albo osoba przypisana.
  ///
  /// Preferencja jest osobista i trwała (per użytkownik, workspace i projekt),
  /// więc zmiana trybu nie zapisuje wspólnych ustawień projektu.
  final TasksBoardGrouping grouping;

  /// Snapshot tablicy grupowanej po osobach; `null` dopóki widok osób nie został
  /// wczytany. Widok statusów działa niezależnie od tego pola.
  final AssigneeKanbanBoardResponse? assigneeBoard;

  /// Czy trwa przełączenie grupowania albo odczyt tablicy osób.
  final bool isAssigneeBoardLoading;

  /// Błędy doładowania kolejnych stron pojedynczych grup, kluczowane kluczem grupy.
  final Map<String, String> assigneeGroupLoadErrors;

  /// Grupy, których kolejna strona jest właśnie wczytywana.
  final Set<String> loadingAssigneeGroupKeys;

  /// Karty, których ostatni zapis się nie udał. Prezentacja pokazuje na nich
  /// obrys błędu, a komunikat i tak niesie banner, więc błąd nie jest kodowany
  /// wyłącznie kolorem.
  final Set<String> failedTaskIds;

  /// Klucze ukrytych kolumn osób (identyfikator osoby albo „Nieprzypisane”).
  ///
  /// W widoku osób osoba opisuje kolumnę, więc widoczność kolumn zastępuje tam
  /// filtr wykonawcy: użytkownik nie filtruje kart po osobie, tylko decyduje,
  /// które kolumny ma przed oczami. Filtr kart nadal działa w widoku statusów.
  final Set<String> hiddenAssigneeUserIds;

  /// Czy kolumny osób bez zadań są ukryte.
  final bool hideEmptyAssigneeColumns;

  TasksBoardReady copyWith({
    KanbanBoardResponse? board,
    WorkspaceSignalRConnectionState? connectionState,
    List<TaskProjectPresenceUser>? presence,
    KanbanBoardFilter? filter,
    bool? loadingFilter,
    Map<String, ProjectMemberProfile>? memberProfilesByUserId,
    bool? memberPresenceIsFresh,
    Set<String>? loadingColumnKeys,
    Map<String, String>? columnLoadErrors,
    Map<String, ApiError>? columnLoadApiErrors,
    Set<String>? selectedTaskIds,
    Set<String>? pendingTaskIds,
    Map<String, Object>? pendingMoveOwners,
    Map<String, Object>? pendingCardOwners,
    bool? isBulkSaving,
    TasksViewError? bulkError,
    bool clearBulkError = false,
    bool? canRetryBulk,
    UserKanbanPreferenceResponse? userPreference,
    bool clearUserPreference = false,
    bool? savingUserPreference,
    TasksViewError? error,
    bool clearError = false,
    int? taskDataRevision,
    int? realtimeRevision,
    TaskRealtimeMutation? latestRealtimeMutation,
    TasksBoardGrouping? grouping,
    AssigneeKanbanBoardResponse? assigneeBoard,
    bool clearAssigneeBoard = false,
    bool? isAssigneeBoardLoading,
    Map<String, String>? assigneeGroupLoadErrors,
    Set<String>? loadingAssigneeGroupKeys,
    Set<String>? failedTaskIds,
    Set<String>? hiddenAssigneeUserIds,
    bool? hideEmptyAssigneeColumns,
  }) => TasksBoardReady(
    board: board ?? this.board,
    connectionState: connectionState ?? this.connectionState,
    presence: presence ?? this.presence,
    filter: filter ?? this.filter,
    loadingFilter: loadingFilter ?? this.loadingFilter,
    memberProfilesByUserId:
        memberProfilesByUserId ?? this.memberProfilesByUserId,
    memberPresenceIsFresh: memberPresenceIsFresh ?? this.memberPresenceIsFresh,
    loadingColumnKeys: loadingColumnKeys ?? this.loadingColumnKeys,
    columnLoadErrors: columnLoadErrors ?? this.columnLoadErrors,
    columnLoadApiErrors: columnLoadApiErrors ?? this.columnLoadApiErrors,
    selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
    pendingTaskIds: pendingTaskIds ?? this.pendingTaskIds,
    pendingMoveOwners: Map.unmodifiable({
      for (final entry in (pendingMoveOwners ?? this.pendingMoveOwners).entries)
        if ((pendingTaskIds ?? this.pendingTaskIds).contains(entry.key))
          entry.key: entry.value,
    }),
    pendingCardOwners: Map.unmodifiable({
      for (final entry in (pendingCardOwners ?? this.pendingCardOwners).entries)
        if ((pendingTaskIds ?? this.pendingTaskIds).contains(entry.key))
          entry.key: entry.value,
    }),
    isBulkSaving: isBulkSaving ?? this.isBulkSaving,
    bulkError: clearBulkError ? null : bulkError ?? this.bulkError,
    canRetryBulk: canRetryBulk ?? this.canRetryBulk,
    userPreference: clearUserPreference
        ? null
        : userPreference ?? this.userPreference,
    savingUserPreference: savingUserPreference ?? this.savingUserPreference,
    error: clearError ? null : error ?? this.error,
    taskDataRevision: taskDataRevision ?? this.taskDataRevision,
    realtimeRevision: realtimeRevision ?? this.realtimeRevision,
    latestRealtimeMutation:
        latestRealtimeMutation ?? this.latestRealtimeMutation,
    grouping: grouping ?? this.grouping,
    assigneeBoard: clearAssigneeBoard
        ? null
        : assigneeBoard ?? this.assigneeBoard,
    isAssigneeBoardLoading:
        isAssigneeBoardLoading ?? this.isAssigneeBoardLoading,
    assigneeGroupLoadErrors:
        assigneeGroupLoadErrors ?? this.assigneeGroupLoadErrors,
    loadingAssigneeGroupKeys:
        loadingAssigneeGroupKeys ?? this.loadingAssigneeGroupKeys,
    failedTaskIds: failedTaskIds ?? this.failedTaskIds,
    hiddenAssigneeUserIds: hiddenAssigneeUserIds ?? this.hiddenAssigneeUserIds,
    hideEmptyAssigneeColumns:
        hideEmptyAssigneeColumns ?? this.hideEmptyAssigneeColumns,
  );
}
